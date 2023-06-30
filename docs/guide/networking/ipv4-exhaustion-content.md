
This article describes how to minimize private address space consumption when you build large networks in Azure. You might need to minimize address space consumption if proper allocation policies aren't established, and you run out of private IP addresses to assign to Azure virtual networks. This article describes how to use non-routable landing zone spoke virtual networks or Private Link services to create the proper environment.

## Scenario details

The following sections present recommendations for scenarios that have a huge number of IPv4 address requirements and for environments that have limited RFC 1918 address space.

Corporate networks typically use address spaces that are in the private IPv4 address ranges that RFC 1918 defines, such as 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16. In on-premises environments, these ranges provide enough IP addresses to meet the requirements of even the largest networks. As a result, many organizations develop address-management practices that prioritize simple-routing configurations and agile processes for IP allocation. Efficient use of the address space isn't a priority.

In the cloud, large hybrid networks are easy to build, and architectural patterns, like microservices or container orchestration platforms, consume many IP addresses, so it’s important to adjust those address-management practices. In a cloud environment, treat private IPv4 addresses as a limited resource.

### Azure Virtual Network IP address ranges

In Azure Virtual Network, we recommend that you use the address blocks that RFC 1918 defines. These address blocks are for general-purpose private networks and are "non-routable" on the public internet.

But there are other ranges that you can use. Before you use these ranges in your virtual network, read the IANA documentation to understand the potential implications to your environment. You can use the following ranges:

- The shared address space for carrier-grade NAT (CGN) that RFC 6598 defines is treated as private address space in Azure Virtual Network. The address block is 100.64.0.0/10.
- You can use public, internet-routable IP addresses in Azure Virtual Network that aren’t owned by your organization, but this practice is discouraged. When you use public address ranges, resources in the virtual network can’t access internet endpoints that are exposed over the public IP addresses.
- You can use some of the special-purpose address blocks that IANA defines, like 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 233.252.0.0/24, and 240.0.0.0/4.

> [!NOTE]
> The previous ranges won't provide a long-term solution for organizations that have IPv4 exhaustion issues across the entire RFC 1918 address space. Those organizations should minimize private address space consumption.

You can't use the following IP address ranges in Azure Virtual Network:

- 224.0.0.0/4 (Multicast)
- 255.255.255.255/32 (Broadcast)
- 127.0.0.0/8 (Loopback)
- 169.254.0.0/16 (Link-local)
- 168.63.129.16/32 (Internal DNS)

### Azure landing zone alignment

The best practices in this article are for scenarios that are based on the [Azure landing zones reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). The guidance assumes that:

- Each region has a hub-and-spoke topology.
- Hub-and-spoke networks that are in different regions are connected.
- Hub-and-spoke networks are connected to on-premises sites via a combination of virtual network peering, ExpressRoute circuits, and site-to-site VPNs.

The recommendations are equally applicable to networks that are built on top of Azure Virtual WAN, which also has hub-and-spoke networks in each region.

:::image type="content" source="./media/ipv4-exhaustion-hub-spoke.png" alt-text="Regional hub-and-spoke topology recommended by the Azure landing zone reference architecture." border="false" lightbox="./media/ipv4-exhaustion-hub-spoke.png":::

*Figure 1. Regional hub-and-spoke topology recommended by the Azure landing zone reference architecture. In multi-region scenarios, a hub-and-spoke network is created in each region. Application landing zones are typically assigned a single spoke virtual network, peered to the regional hub that's deployed into the platform landing zone.*

In a scenario that's based on the Azure landing zone reference architecture, applications are deployed in their own landing zones. Each landing zone contains a spoke virtual network that's peered to a regional hub. Spoke virtual networks are an integral part of the corporate network and are assigned routable IPv4 addresses. These addresses are unique across the entire corporate network. So, all architectural components that are deployed in Azure Virtual Network consume IPv4 addresses in the corporate network’s address space even if only a few of them expose endpoints that must be reachable from the entire corporate network. These architectural components might be virtual machines, first-party or third-party network NVAs, or virtual network-injected PaaS services.

For the remainder of this article, "front-end components" refer to application components that are reachable from the entire corporate network (from outside the components' landing zone). "Back-end components" refer to application components that don't expose endpoints in the corporate network and only need to be reachable from within their own landing zone. For example, a web application that exposes an endpoint is a front-end component, and a database that doesn't expose an endpoint is a back-end component.

The following sections describe the best practices to minimize private address space consumption when you build large networks in Azure. You might need to minimize address space consumption if proper address space allocation policies aren't established, and you run out of private IP addresses to assign to Azure virtual networks.

## Best practice #1: Non-routable landing zone spoke virtual networks

RFC 1918 carves IP address blocks out of the IPv4 32-bit address space and makes them "non-routable" in the public internet, so that they can be reused in multiple private networks for internal communication. This best practice is based on the same principle that applies to private address space. One or more address ranges are carved out of the entire private address space that's used by an organization and declared "non-routable" within that organization’s corporate network. The address ranges are reused in multiple landing zones. As a result, each landing zone:

- Is assigned a "routable" address space that's made of one or more address ranges. The address ranges are centrally managed by the organization and uniquely assigned to a landing zone for communicating with the corporate network. Addresses in the routable space are assigned to front-end components.
- Can use the "non-routable" address space, which is the address ranges that the organization declared non-routable in the corporate network. You can use these reserved ranges for internal communication in all landing zones. Addresses in the non-routable space are assigned to back-end components.

In an Azure hub-and-spoke network that's customer-managed or based on Virtual WAN, two or more spoke virtual networks can't have overlapping IP address spaces. So non-routable address blocks can't be assigned to a landing zone spoke. Virtual network peering is nontransitive, so a landing zone spoke virtual network can peer with a "second-level" spoke virtual network that has a non-routable address space. The following diagram shows the dual virtual network topology for landing zones:

:::image type="content" source="./media/ipv4-exhaustion-hub-spoke-vnet-peering.png" alt-text="Each application landing zone contains two peered virtual networks, one with routable IP addresses, which hosts front-end components, and one with non-routable IP addresses, which hosts back-end components." border="false" lightbox="./media/ipv4-exhaustion-hub-spoke-vnet-peering.png":::

*Figure 2. Each application landing zone contains two peered virtual networks, one with routable IP addresses, which hosts front-end components, and one with non-routable IP addresses, which hosts back-end components.*

Each application landing zone has two peered virtual networks. In the previous diagram, the virtual networks are "routable landing zone spoke" and "non-routable landing zone spoke". The routable landing zone spoke peers with the regional hub. The non-routable landing zone spoke peers the routable landing zone spoke. Virtual network peering is nontransitive, so non-routable prefixes aren't visible to the regional hub or the rest of the corporate network. The routable virtual networks can't use the "non-routable" address ranges. Some organizations have fragmented address space that’s already assigned to routable networks. It can be challenging to identify unused large address blocks and declare them "non-routable". If that's the case, consider unused addresses that aren’t included in the RFC 1918 address space. The previous diagram provides an example of CGN addresses (RFC 6598) in non-routable spoke virtual networks.

### Migration from single virtual network landing zones

Virtual network peering provides full layer-3 connectivity between two peered virtual networks. Traditional single virtual network landing zones communicate with each other over IP. If application components are deployed in single virtual network landing zones, you can move the components between routable and non-routable spoke virtual networks. The following sections describe migration patterns for two types of applications.

#### Applications that are exposed via layer-7 application delivery controllers

Applications that are exposed via layer-7 application delivery controllers can be moved to the non-routable spoke. The application delivery controller is the only front-end component that must reside in the routable landing zone spoke.

:::image type="content" source="./media/ipv4-exhaustion-app-gw-l7.png" alt-text="Migration approach from traditional landing zone for applications exposed via layer-7 application delivery controllers." border="false" lightbox="./media/ipv4-exhaustion-app-gw-l7.png":::

#### Applications that are exposed via an Azure load balancer

If an application exposes its endpoints via an Azure load balancer, the compute instances that are part of the load balancer’s back-end pool must remain in the same virtual network. Azure load balancers only support back-end instances in their own virtual network.

:::image type="content" source="./media/ipv4-exhaustion-load-balancer-l4.png" alt-text="Migration approach from traditional landing zone for applications exposed via Azure Load Balancer." border="false" lightbox="./media/ipv4-exhaustion-load-balancer-l4.png":::

### Outbound dependencies

An application’s back-end components don't need to be reachable, or receive inbound connections, from the corporate network, but the components often have outbound dependencies. Back-end components might need to connect to endpoints that are outside of their landing zones in instances such as DNS resolution, access to application endpoints that are exposed by other landing zones, or access to logging or backup facilities.

When services initiate connections in non-routable spoke virtual networks, you must source NAT the connections behind a routable IP address. Deploy a NAT-capable NVA in the routable spoke virtual network. Each landing zone runs its own dedicated NAT NVA. There are two options for implementing SNAT in a landing zone: Azure Firewall or third-party NVAs. In both cases, all subnets in the non-routable spoke must be associated with a custom route table. The route table forwards traffic to destinations outside of the landing zone to the SNAT device. Azure NAT Gateway doesn't support SNAT for destinations with private IP address space, such as RFC 1918.

:::image type="content" source="./media/ipv4-exhaustion-snat-nva.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Source-NAT NVA(s) must be deployed in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to the SNAT NVA(s)." border="false" lightbox="./media/ipv4-exhaustion-snat-nva.png":::

*Figure 5. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Source-NAT NVA(s) must be deployed in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to the SNAT NVA(s).*

#### Implement SNAT via Azure Firewall

The following diagram shows the landing zone layout when you use Azure Firewall for source NAT in a hub-and-spoke network topology.

:::image type="content" source="./media/ipv4-exhaustion-snat-azfw.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall." border="false" lightbox="./media/ipv4-exhaustion-snat-azfw.png":::

*Figure 6. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.*

The following diagram shows the landing zone layout when you use Azure Firewall for source NAT in a Virtual WAN-based hub-and-spoke network.

:::image type="content" source="./media/ipv4-exhaustion-snat-azfw-vwan.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke (VWAN Connected). All subnets in the non-routable spoke (No Connection with VWAN) must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall." border="false" lightbox="./media/ipv4-exhaustion-snat-azfw-vwan.png":::

*Figure 7. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke (VWAN Connected). All subnets in the non-routable spoke (No Connection with VWAN) must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.*

The following design considerations apply:

- Azure Firewall provides high availability.
- Azure Firewall provides native scalability and three different SKUs. Source NAT is a non-resource intensive task, so consider the basic SKU first. For landing zones that require large volumes of outbound traffic from the non-routable address space, use the standard SKU.
- Azure Firewall source NATs traffic behind the private IP addresses of any of its instances. Each instance can use all the nonprivileged ports.
- You can find instructions to configure Azure Firewall to source NAT all received connections in public documentation.

:::image type="content" source="./media/ipv4-exhaustion-azfw-snat-behavior.png" alt-text="Azure Firewall can be configured to Source-NAT all received connections. This is the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in non-routable spoke virtual networks." border="false" lightbox="./media/ipv4-exhaustion-azfw-snat-behavior.png":::

*Figure 8. Azure Firewall can be configured to Source-NAT all received connections. This is the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in non-routable spoke virtual networks.*

#### Implement SNAT via third-party NVAs

Third-party NVAs with NAT capabilities are available in Azure Marketplace. They provide:

- Granular control over scale in or scale out.
- Granular control of the NAT pool.
- Custom NAT policies, such as using different NAT addresses depending on the properties of the incoming connection, like the source or destination IP.

The following design considerations apply:

- For high availability, deploy clusters with at least two NVAs. Use an Azure load balancer to distribute incoming connections from the non-routable spoke virtual network to the NVAs. An "HA Port" load balancing rule is required because the cluster source NATs all connections that leave the landing zone. Azure Load Balancer Standard supports "HA Port" load balancing rules.
- The Azure network virtualization stack has no constraints for the number of NICs that the NVAs use. The third-party NVA option is mainly driven by the NVAs that are used. Single-homed NVAs are preferred because they reduce address space consumption in the routable spoke virtual networks.

The following diagram shows the landing zone layout when you use third-party NVAs in a hub-and-spoke network topology.
:::image type="content" source="./media/ipv4-exhaustion-nva-snat-flow.png" alt-text="When using third-party NVAs, in a traditional hub-spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure load balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required." border="false" lightbox="./media/ipv4-exhaustion-nva-snat-flow.png":::

*Figure 9.  When using third-party NVAs, in a traditional hub-spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure load balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required.*

The following diagram shows the landing zone layout when you use third-party NVAs in a Virtual WAN-based hub-and-spoke network topology.

:::image type="content" source="./media/ipv4-exhaustion-vwan-nva-snat-flow.png" alt-text="When using third-party NVAs, in a VWAN spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure load balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required." border="false" lightbox="./media/ipv4-exhaustion-vwan-nva-snat-flow.png":::

*Figure 10.  When using third-party NVAs, in a VWAN spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure Load Balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required.*

## Best practice #2: Private Link services

Private Link is an Azure feature that provides access to an application that's deployed in a virtual network that's disconnected from your virtual network. In the server-side (application) virtual network, a Private Link Service resource is deployed and associated with an application endpoint that's exposed on the front-end IP address of an internal Azure load balancer (Standard SKU). In the client-side virtual network, a Private Endpoint resource is deployed and associated with the Private Link Service. The private endpoint exposes the application endpoint in your virtual networks. Private Link provides the tunneling and NAT-ting logic to route traffic between the client side and the server side. For more information, see [What is Azure Private Link?](/azure/private-link/private-link-overview)

Private Link doesn't require a layer-3 connection between the client side and the server side virtual networks. The two virtual networks can have overlapping IP address spaces. Private Link allows the deployment of applications in dedicated, isolated virtual networks that have the same address space. The applications are exposed as Private Link services in the corporate network, which uses a routable address space. In the context of the Azure landing zone reference architecture, the resulting landing zone topology has:

- An isolated virtual network that hosts the entire application and the Private Link service that's associated with the application’s endpoints. The application team defines the virtual network address space.
- A spoke virtual network with a routable address space that hosts the private endpoint that's associated with the Private Link service. The spoke virtual network is directly peered with the regional hub.

The following diagram shows the landing zone topology that's enabled by Private Link.

:::image type="content" source="./media/ipv4-exhaustion-private-link.png" alt-text="Landing zone topology when Private Link Services are used to expose applications deployed in isolated virtual networks." border="false" lightbox="./media/ipv4-exhaustion-private-link.png":::

### Use Private Link service for outbound dependencies

When you deploy applications in isolated spoke virtual networks, use Private Link service for outbound dependencies. Define private endpoints in the isolated spoke virtual network and associate them with Private Link service in routable virtual networks. The following diagram shows the conceptual approach.

:::image type="content" source="./media/ipv4-exhaustion-private-link-isolated.png" alt-text="Private Link Services can be used for outbound dependencies for applications deployed in isolated virtual networks." border="false" lightbox="./media/ipv4-exhaustion-private-link-isolated.png":::

In real-world, large-scale implementations, the approach shown in the previous section might not be applicable:

- If the applications deployed in the isolated virtual network have multiple outbound dependencies. When you deploy a Private Link service and a private endpoint for each of the outbound dependencies, it increases complexity and management needs.
- If endpoints in the routable network that can't be part of an Azure load balancer back-end pool can't be exposed as Private Link services.

To overcome these two limitations, deploy a proxy/NAT solution in the routable spoke and make it accessible from the isolated virtual network by using Private Link.

:::image type="content" source="./media/ipv4-exhaustion-private-link-flow.png" alt-text="A single Private Endpoint/Private Link Service can be used to expose a proxy/NAT solution deployed in the routable network. Port- and Address-Translation rules defined on the NVAs allow a single Private Endpoint in the isolated virtual network to be used for accessing multiple dependencies in the routable network." border="false" lightbox="./media/ipv4-exhaustion-private-link-flow.png":::

*Figure 13. A single Private Endpoint/Private Link Service can be used to expose a proxy/NAT solution deployed in the routable network. Port-Translation and Address-Translation rules defined on the NVAs allow a single Private Endpoint in the isolated virtual network to be used for accessing multiple dependencies in the routable network.*

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

- [Federico Guerrini](https://www.linkedin.com/in/federico-guerrini-phd-8185954) | EMEA Technical Lead
- [Khush Kaviraj](https://www.linkedin.com/in/khushalkaviraj) | Cloud Solution Architect
- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solution Architect
  
 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Deploy Azure Firewall in a virtual network](/azure/firewall/tutorial-firewall-deploy-portal-policy)
- [Configure SNAT on Azure Firewall](/azure/firewall/snat-private-range)
- [Supported IP addresses in Azure Virtual Network](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-vnets)
- [Azure Private Link](/azure/private-link/private-link-overview)

## Related resources


