---
title: Prevent IPv4 Exhaustion in Azure
description: Minimize private address space consumption when you build large networks in Azure. This article presents two methods to create more IPv4 address space.
author: fguerri
ms.author: fguerri
ms.date: 04/30/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Prevent IPv4 exhaustion in Azure

Corporate networks typically use address spaces from the private IPv4 address ranges defined by [Request for Comments (RFC) 1918](https://datatracker.ietf.org/doc/html/rfc1918), like `10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16`. In on-premises environments, these ranges provide enough IP addresses to meet the requirements of even the largest networks. As a result, many organizations develop address management practices that prioritize simple routing configurations and agile processes for IP address allocation. They often don't prioritize efficient use of IPv4 address space.

In the cloud, large networks are easy to build. Some common architectural patterns, like microservices or containerization, might lead to increased IPv4 address consumption. Therefore, it's important to adopt more conservative address management practices and treat IPv4 addresses as a limited resource.

> [!NOTE]
> We recommend that you use the address blocks defined by RFC 1918 in your Azure virtual networks. For more information, see [Address ranges for virtual networks](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-virtual-networks).

This article describes two methods to minimize IPv4 address space consumption when you build large networks in Azure. The methods rely on network topologies that reuse the same IPv4 address blocks in multiple virtual networks or landing zones.

- **Method 1:** Use [IPv4 subnet peering](/azure/virtual-network/how-to-configure-subnet-peering) to exclude one or more subnets from the peering between the landing zone's spoke virtual network and the hub virtual network. You can assign the same nonroutable IP address ranges to subnets excluded from the peering relationship across all landing zones. These IP address ranges can't overlap with other routable IP address ranges.

- **Method 2:** Deploy applications in isolated virtual networks that aren't connected to the landing zones' virtual networks. Associate their endpoints with Azure Private Link services. In the landing zones' spoke virtual networks, create private endpoints associated with the Private Link services. The isolated virtual networks can use any IPv4 address space, even if it overlaps with the corporate network's routable address space.

Method 1 works best in traditional enterprise environments where multiple systems and applications depend on each other. Method 2 works best in loosely coupled environments where applications operate independently.

## Azure landing zone alignment

The recommendations in this article apply to network topologies that are based on the [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture):

- Each region that hosts Azure resources has a hub-and-spoke network.

- Hub-and-spoke networks in different regions connect through global virtual network peering.
- Hub-and-spoke networks connect to on-premises sites via Azure ExpressRoute circuits or site-to-site VPNs.

In the Azure landing zone architecture, each application runs in its own spoke virtual network. Each spoke virtual network uses a unique IPv4 address space across the corporate network.

All resources in a landing zone can connect in the following ways:

- Use their IP address to initiate connections to any other resources in the corporate network

- Receive direct connections from the entire corporate network through their IP address

However, resources don't always need reachability from the entire corporate network. For example, in a landing zone that contains a three-layer web application, such as an HTTP front end, business logic, and data layer, only the HTTP front end must be reachable from outside the landing zone. The other layers must connect with each other and the front end, but they don't need to accept connections from clients. This example suggests that you can minimize IPv4 address consumption by assigning the following components to each landing zone:

- An address space that's unique across the entire corporate network. Only resources that must be reachable from outside their landing zone use this address space. This article refers to this address space as the landing zone's *routable address space*.

- An internal address space for resources that only need to communicate with other resources inside their own landing zone. This address space doesn't require direct reachability from the corporate network. This article refers to this address space as the landing zone's *nonroutable address space*.

In the following sections, *front-end component* refers to an application component that must be reachable from the entire corporate network. *Back-end component* refers to an application component that doesn't expose endpoints in the corporate network and only needs to be reachable within its own landing zone. 

## Method 1: Nonroutable subnets in spoke virtual networks

You can use [IPv4 subnet peering](/azure/virtual-network/how-to-configure-subnet-peering) to restrict a peering relationship between two virtual networks to specific subnets. Only subnets included in the peering configuration can route traffic to each other. Subnets excluded from the peering configuration remain invisible and unreachable from the peer virtual network.

In a hub-and-spoke topology, if you exclude one or more subnets in each spoke from the peering configuration, those subnets remain invisible and unreachable from the hub and from any remote network connected to the hub via other peerings, ExpressRoute connections, or VPN connections. Therefore, you can assign the same address range to all subnets excluded from the peering configuration across all spoke virtual networks. That range must be defined as *nonroutable* and can't be used anywhere else in the corporate network.

The following diagram includes these components:

- The range `10.57.0.0/16` serves as the nonroutable address space.

- The hub virtual network and each landing zone spoke virtual network use unique routable IP address ranges (`10.0.0.0/24`, `10.1.0.0/24`, and `10.2.0.0/24`).

- Each landing zone spoke virtual network also contains one or more nonroutable subnets within the nonroutable range `10.57.0.0/16`. The address space of an Azure virtual network can include multiple IP address ranges.
- These subnets are excluded from the peering relationship with the hub. Therefore, nonroutable subnets in different landing zone spokes can have the same or overlapping address ranges within `10.57.0.0/16`.

:::image type="complex" source="./images/exhaustion-hub-spoke-subnet-peering.svg" alt-text="Diagram that shows how to use subnet peering for landing zones that have routable and nonroutable address spaces." border="false" lightbox="./images/exhaustion-hub-spoke-subnet-peering.svg":::
This diagram contains a hub and two landing zone spokes in separate landing zones. The hub contains three routable subnets. Each landing zone spoke contains two routable subnets and two nonroutable subnets. The hub is connected to each landing zone via subnet peering. Only the routable subnets in the hub and spokes are included in the peering.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-hub-spoke-subnet-peering.pptx) of this architecture.*

This approach preserves full connectivity within a landing zone's spoke virtual network. All resources in the same spoke virtual network can connect with each other, regardless of whether they reside in routable or nonroutable subnets. However, only resources in routable subnets can connect to resources outside their own landing zone.

### Deploy applications to landing zones

When you use subnet peering to build landing zones with nonroutable subnets, you can apply different patterns to distribute an application's front-end and back-end components across routable and nonroutable subnets. The following considerations apply to both newly built applications and applications migrated from traditional landing zones that use a single, fully routable address space. 

- **Applications exposed via Layer-7 application delivery controllers:** These application delivery controllers include Azure Application Gateway or non-Microsoft network virtual appliances (NVAs). Only the application delivery controller's endpoint must be reachable from clients outside the landing zone. Therefore, the application delivery controller is the only front-end component that must reside in a routable subnet.

- **Applications exposed via an Azure load balancer:** If the application uses an internal Azure load balancer, the virtual machines in the load balancer's back-end pool must reside in a routable subnet. You can deploy all other components to nonroutable subnets.

The following diagram shows these patterns:

- Landing zone A hosts a three-layer web application exposed through an application delivery controller, which is the only component in the routable subnet.

- Landing zone B hosts a three-layer application exposed through an internal Azure load balancer.

:::image type="complex" source="./images/exhaustion-deploying-apps.svg" alt-text="Diagram that shows how to deploy applications in landing zones that have routable and nonroutable address spaces." border="false" lightbox="./images/exhaustion-deploying-apps.svg":::
This diagram contains a hub and two landing zone spokes in separate landing zones. The hub contains three routable subnets. The landing zone A spoke contains an application delivery controller in a routable subnet and an HTTP front end, business logic, and data tier in separate nonroutable subnets. The landing zone B spoke contains a TCP/IP front end in a routable subnet and business logic and a data tier in separate nonroutable subnets. The hub is connected to the routable subnets in each spoke via subnet peering.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-deploying-apps.pptx) of this architecture.*

### Outbound dependencies

An application's back-end components don't need to receive inbound connections from the corporate network. But they might need to initiate connections to endpoints outside their landing zone. Typical examples include Domain Name System (DNS) resolution, interaction with Active Directory Domain Services (AD DS) domain controllers, and access to applications in other landing zones or shared services such as log management or backup systems. 

When resources in nonroutable subnets need to initiate connections to endpoints outside their landing zone, those connections must use source NAT (SNAT) behind a routable IP address. Therefore, you must deploy a NAT-capable NVA in a routable subnet in each landing zone. The following diagram shows this configuration.

:::image type="complex" source="./images/exhaustion-network-virtual-appliance.svg" alt-text="Diagram that shows how the custom route table forwards traffic to the SNAT device." border="false" lightbox="./images/exhaustion-network-virtual-appliance.svg":::
This diagram contains a hub and two landing zone spokes in separate landing zones. The hub contains three routable subnets. The landing zone A spoke contains an application delivery controller and NAT in separate routable subnets. It also contains an HTTP front end, business logic, and data tier in separate nonroutable subnets. The application delivery controller points to three components in the HTTP front end subnet. The connection from a component goes through the firewall in the hub via SNAT. The landing zone B spoke contains a TCP/IP front end and NAT in separate routable subnets. It also contains business logic and a data tier in separate nonroutable subnets. The connection from a component in the business logic subnet goes through the firewall in the hub via SNAT. The hub is connected to each landing zone spoke.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-nva.pptx) of this architecture.*

**Nonroutable subnets** must use a custom route table that forwards all traffic destined outside of the landing zone to the NAT-capable NVA. In the previous diagram, the `10.57.0.0/16` range is nonroutable, while other ranges within `10.0.0.0/8` are routable. The custom route table for each nonroutable subnet must contain the following user-defined route (UDR).

| Destination | Next hop type | Next hop IP address |
| ----------- | ----------------------- | ------------------------------------ |
| 10.0.0.0/8  | VirtualNetworkAppliance | \<Spoke NAT-capable NVA IP address\> |

The virtual network's system route table already includes a system route for destinations in the nonroutable `10.57.0.0/16` range. You don't need to define UDRs for traffic within that range.

**Routable subnets**, including the subnet that hosts the NAT-capable NVA, must use a custom route table that forwards traffic outside the landing zone, typically to NVAs in the hub virtual network. These NVAs route traffic among spokes. These hub NVAs don't perform NAT operations. In the previous diagram, the custom route table for each routable subnet must contain the following UDRs.

| Destination  | Next hop type | Next hop IP address |
| ------------ | ----------------------- | ---------------------------------- |
| 10.0.0.0/8   | VirtualNetworkAppliance | \<Hub router/firewall IP address\> |
| 10.0.0.0/24  | VirtualNetworkAppliance | \<Hub router/firewall IP address\> |

The second UDR with destination `10.0.0.0/24` ensures that connections to resources in the hub virtual network route through the hub firewall. Some applications might require more UDRs. If virtual machines in the landing zone need internet access through NVAs that are typically hosted in the hub, you must also define a default route of `0.0.0.0/0`.

> [!NOTE]
> Client-to-AD DS domain controller communication over NAT is supported. Domain controller-to-domain controller communication over NAT hasn't been tested and isn't supported. For more information, see [Support boundaries for Windows Server Active Directory over NAT](/troubleshoot/windows-server/active-directory/support-for-active-directory-over-nat). We recommend that you deploy Windows Server Active Directory domain controllers to routable subnets.

You can use either Azure Firewall or non-Microsoft NVAs as NAT-capable devices. The following sections cover both options. You can't use Azure NAT Gateway because it only supports SNAT for internet-bound traffic.

#### Implement SNAT via Azure Firewall

When you need to prioritize low complexity and minimal management, Azure Firewall provides the best solution to implement SNAT for connections that originate from nonroutable subnets. Azure Firewall provides the following benefits:

- Fully managed lifecycle
- Built-in high availability
- Autoscaling based on traffic volume

When you use Azure Firewall, consider the following factors:

- Deploy Azure Firewall in its own reserved subnet named **AzureFirewallSubnet**, which must use a routable address space.

- Some Azure Firewall SKUs or configurations might require a second reserved subnet for firewall management. The management subnet doesn't require a routable address space.
- Azure Firewall has three different SKUs. SNAT isn't resource-intensive, so start with the Basic SKU. For landing zones that generate large volumes of outbound traffic from nonroutable subnets, consider the Standard SKU.
- Configure Azure Firewall with the **Perform SNAT** option set to **Always**. Each instance uses its nonprivileged ports for SNAT. To configure Azure Firewall to implement SNAT on all received connections, follow the [SNAT configuration steps](/azure/firewall/snat-private-range#configure-snat-private-ip-address-ranges---azure-portal).
- Associate all nonroutable subnets with a custom route table that forwards all traffic destined outside the landing zone to the firewall's private IP address.

The following diagram shows a hub-and-spoke network where each spoke uses Azure Firewall to provide SNAT for connections from nonroutable subnets.

:::image type="complex" source="./images/exhaustion-azure-firewall.svg" alt-text="Diagram that shows the SNAT implementation that uses Azure Firewall." border="false" lightbox="./images/exhaustion-azure-firewall.svg":::
This diagram contains a hub and two landing zone spokes in separate landing zones. The hub contains three routable subnets. The landing zone A spoke contains an application delivery controller and firewall in separate routable subnets. It also contains an HTTP front end, business logic, and data tier in separate nonroutable subnets. The application delivery controller points to three components in the HTTP front end subnet. The connection from a component goes through the firewall in the hub via SNAT. The landing zone B spoke contains a TCP/IP front end and firewall in separate routable subnets. It also contains business logic and a data tier in separate nonroutable subnets. The connection from a component in the business logic subnet goes through the firewall in the hub via SNAT. The hub is connected to each landing zone spoke.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-azure-firewall.pptx) of this architecture.*

#### Implement SNAT via non-Microsoft NVAs

You can find non-Microsoft NVAs that have NAT capabilities in the [Microsoft Marketplace](https://marketplace.microsoft.com/search/products?filters=networking&product=virtual-machines). Consider using a non-Microsoft NVA if your requirements exceed what Azure Firewall can support. For example, you might need the following capabilities:

- Granular control over the NAT pool

- Custom NAT policies, for example you might need to use different NAT addresses for different connections
- Granular control over scale-in and scale-out

When you use non-Microsoft NVAs, consider the following factors:

- Deploy a cluster that has at least two NVAs to ensure high availability.

- Use a Standard SKU Azure load balancer to distribute connections from the nonroutable spoke virtual network to the NVAs. All connections must use SNAT regardless of the destination port, so you should use [high-availability load-balancing rules](/azure/load-balancer/manage-rules-how-to#high-availability-ports), also known as *any-port load-balancing rules*. 
- Choose between single-arm and dual-arm configurations for NAT-capable NVAs. Single-arm configurations are simpler and generally recommended.

The following diagram shows now to implement SNAT in a hub-and-spoke network topology by using non-Microsoft NVAs.

:::image type="complex" source="./images/exhaustion-non-microsoft-network-virtual-appliance.svg" alt-text="Diagram that shows the SNAT implementation by using non-Microsoft NVAs." border="false" lightbox="./images/exhaustion-non-microsoft-network-virtual-appliance.svg":::
This diagram contains a hub and two landing zone spokes in separate landing zones. The hub contains three routable subnets. The landing zone A spoke contains an application delivery controller in a routable subnet and two NAT instances in a routable subnet. It also contains an HTTP front end, business logic, and data tier in separate nonroutable subnets. The application delivery controller points to three components in the HTTP front end subnet. The connection from a component goes through a NAT instance and then the firewall in the hub via SNAT. The landing zone B spoke contains a TCP/IP front end in a routable subnet and two NAT instances in a routable subnet. It also contains business logic and a data tier in separate nonroutable subnets. The connection from a component in the business logic subnet goes through a NAT instance and then the firewall in the hub via SNAT. The hub is connected to each landing zone spoke.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-non-microsoft-nva.pptx) of this architecture.*

### Use Method 1 with Azure Virtual WAN

Azure Virtual WAN doesn't support subnet peering. So you can't create landing zone virtual networks that have nonroutable subnets in Virtual WAN–based hub-and-spoke networks. However, you can still apply the fundamental principle of Method 1 by using two peered virtual networks for each landing zone.

- Assign a routable address space to the first virtual network and connect it to the Virtual WAN hub.

- Assign a nonroutable address space to the second virtual network and peer it with the routable virtual network.

The following diagram shows the resulting topology.

:::image type="complex" source="./images/exhaustion-virtual-wan.svg" alt-text="Diagram that shows an implementation that uses two peered virtual networks." border="false" lightbox="./images/exhaustion-virtual-wan.svg":::
This diagram contains a Virtual WAN hub and two landing zones. Landing zone A contains a landing zone routable spoke and a landing zone nonroutable spoke, which are connected via virtual network peering. The routable spoke contains an application delivery controller in a routable subnet. The nonroutable spoke contains an HTTP front end, business logic, and a data tier in separate nonroutable subnets. The application delivery controller connects to three components in the HTTP front end subnet. Landing zone B contains a landing zone routable spoke and a landing zone nonroutable spoke, which are connected via virtual network peering. The routable spoke contains a TCP/IP front end in a routable subnet. The nonroutable spoke contains business logic and a data tier in separate nonroutable subnets. The Virtual WAN hub is connected to each landing zone routable spoke.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-virtual-wan.pptx) of this architecture.*

This approach doesn't limit connectivity within a landing zone. The two virtual networks in the landing zone are directly peered, so all resources can connect with each other, regardless of whether they reside in a routable or nonroutable virtual network. However, only resources in the routable virtual network can connect to resources outside the landing zone.

From a routing perspective, there's no difference between the following configurations:

- Routable and nonroutable subnets in the same virtual network (described in the previous section for traditional hub-and-spoke networks)

- Directly peered virtual networks (described in this section for hub-and-spoke networks based on Virtual WAN)

As a result, in Virtual WAN-based networks, the following guidance applies:

- You can distribute application components across routable and nonroutable subnets by using the same considerations described in earlier sections.

- You can manage outbound dependencies with NAT-capable NVAs in routable subnets.

## Method 2: Private Link services

[Private Link](/azure/private-link/private-link-overview) enables clients in a virtual network to consume applications in a different virtual network without configuring Layer-3 connectivity, such as virtual network peering or virtual network-to-virtual network VPN. The two virtual networks can use overlapping IP address ranges. Azure transparently handles the required NAT logic. This method applies to both traditional hub-and-spoke networks and Virtual WAN-based networks. 

To expose an application through Private Link, do the following steps:

1. Add the application's endpoints to the back-end pool of an internal Azure load balancer with the Standard SKU.

1. Associate the load balancer's front-end IP address with a [Private Link service resource](/azure/private-link/private-link-service-overview).
1. On the client side, create a [private endpoint resource](/azure/private-link/private-endpoint-overview) and associate it with the server-side Private Link service.

To consume the application, clients connect to the private endpoint. Azure transparently routes the connection to the load balancer front-end IP address that's associated with the corresponding Private Link service.

You can use Private Link to help mitigate IPv4 exhaustion by assigning two virtual networks to each landing zone:

- A virtual network that has a routable address space, connected to the corporate network

- An isolated virtual network, that has an arbitrarily chosen address space, which might even overlap with the corporate network's address space

Deploy applications and the Private Link services that expose their endpoints in the isolated virtual networks. Deploy the private endpoints, which connect to those services, in the routable virtual networks.

The following diagram shows two landing zones that use a large address space `10.0.0.0/16`, which overlaps with the corporate network's address space. Each landing zone assigns this space to an isolated virtual network. The applications are deployed in the isolated spoke virtual networks and associated with Private Link services. 

:::image type="complex" source="./images/exhaustion-private-link.svg" alt-text="Diagram that shows the landing zone topology that uses Private Link services to expose applications deployed in isolated virtual networks." border="false" lightbox="./images/exhaustion-private-link.svg":::
This diagram contains a hub and two landing zones. The hub contains three routable subnets. Each landing zone contains a landing zone routable spoke and a landing zone isolated spoke. The routable spoke contains a private endpoint subnet and a routable subnet. The isolated spoke contains an application subnet and a Private Link service subnet that connects to the private endpoint in the routable spoke. The application subnet connects to the Private Link service subnet. The hub connects to each landing zone routable spoke via virtual network peering.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link.pptx) of this architecture.*

Clients in the corporate network, including clients in other landing zones, consume the applications via private endpoints associated with Private Link services. The following diagram shows how these connections are established.

:::image type="complex" source="./images/exhaustion-private-link-connections.svg" alt-text="Diagram that shows the landing zone topology that uses Private Link services to expose applications deployed in isolated virtual networks and shows how connections are established." border="false" lightbox="./images/exhaustion-private-link-connections.svg":::
This diagram contains a hub and two landing zones. The hub contains three routable subnets. Each landing zone contains a landing zone routable spoke and a landing zone isolated spoke. The routable spoke contains a private endpoint subnet and a routable subnet. The isolated spoke contains an application subnet and a Private Link service subnet that connects to the private endpoint in the routable spoke. The application subnet connects to the Private Link service subnet. The hub connects to each landing zone routable spoke via virtual network peering. There are two flows. One flow goes from the routable subnet in landing zone A, to the firewall in a routable subnet in the hub, to the private endpoint subnet in landing zone B, to the Private Link service subnet in landing zone B, and finally to the application subnet in landing zone B. The second flow goes from routable subnet H3 in the hub, to the private endpoint subnet in landing zone A, to the Private Link service subnet in landing zone A, and finally to the application subnet in landing zone A.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link-connections.pptx) of this architecture.*

### Use a Private Link service for outbound dependencies

Applications in isolated virtual networks can't initiate connections to endpoints in the corporate network. Therefore, Method 2 works best for scenarios where applications in different landing zones operate independently and don't rely on systems in the corporate network. However, you can still apply this method when applications in isolated virtual networks need to access specific endpoints outside their landing zone.

The following diagram shows how a Private Link service enables the application in the isolated virtual network in landing zone A to consume both a shared service in the hub virtual network and an application endpoint in landing zone B.

:::image type="complex" source="./images/exhaustion-private-link-outbound.svg" alt-text="Diagram that shows the architecture that uses a Private Link service for outbound dependencies." border="false" lightbox="./images/exhaustion-private-link-outbound.svg":::
This diagram contains a hub and two landing zones. The hub contains two routable subnets, a shared service subnet, and a Private Link service subnet. The shared service subnet connects to the Private Link service subnet. Each landing zone contains a landing zone routable spoke and a landing zone isolated spoke. The routable spoke contains a private endpoint subnet and a routable subnet. The isolated spoke in landing zone A contains an application subnet, a Private Link service subnet that connects to the private endpoint in the routable spoke, and another private endpoint subnet. The application subnet connects to each private endpoint in the private endpoint subnet. One private endpoint (labeled 1) connects to the Private Link service subnet in the hub. Another private endpoint (labeled 2) connects to the Private Link service subnet in landing zone B. The isolated spoke in landing zone B contains the Private Link service subnet and an application subnet. Each application subnet connects to the Private Link service subnet in the same landing zone. The hub connects to each landing zone routable spoke.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link-outbound.pptx) of this architecture.*

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Federico Guerrini](https://www.linkedin.com/in/federico-guerrini-phd-8185954) | Senior Cloud Solution Architect, EMEA Technical Lead Azure Networking
- [Khush Kaviraj](https://www.linkedin.com/in/khushalkaviraj) | Cloud Solution Architect
- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Configure subnet peering](/azure/virtual-network/how-to-configure-subnet-peering)
- [Deploy Azure Firewall in a virtual network](/azure/firewall/tutorial-firewall-deploy-portal-policy)
- [Configure SNAT in Azure Firewall](/azure/firewall/snat-private-range)
- [Supported IP addresses in Azure Virtual Network](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-virtual-networks)
- [Private Link](/azure/private-link/private-link-overview)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview)
- [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview)
- [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology)

## Related resources

- [Networking architecture design](../../networking/index.md)
- [Architectural approaches for networking in multitenant solutions](../../guide/multitenant/approaches/networking.md)