
This article describes how to minimize private address space consumption when you build large networks in Azure. You might need to minimize address space consumption if proper allocation policies aren't established, and you run out of private IP addresses to assign to Azure virtual networks. This article presents two methods for proper IP address management in Azure.

## Scenario details

Corporate networks typically use address spaces that are in the private IPv4 address ranges that are defined in RFC 1918. The address ranges are 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16. In on-premises environments, these ranges provide enough IP addresses to meet the requirements of even the largest networks. As a result, many organizations develop address-management practices that prioritize simple routing configurations and agile processes for IP allocation. Efficient use of the address space isn't a priority.

In the cloud, large hybrid networks are easy to build, and some common architectural patterns, like microservices or containerization, might lead to increased IP address consumption. So it’s important to adjust those address-management practices. In a cloud environment, treat private IPv4 addresses as a limited resource.

### Azure Virtual Network IP address ranges

In your Azure virtual networks, we recommend that you use the address blocks defined by RFC 1918. These address blocks are for general-purpose private networks and are nonroutable on the public internet.

You can use other ranges, but before you use those ranges in your virtual network, read the Internet Assigned Numbers Authority (IANA) documentation to understand the potential implications to your environment. You can use the following ranges:

- Shared address space defined by RFC 6598 for carrier-grade network address translation (NAT) that's treated as private address space in Azure Virtual Network. The address block is 100.64.0.0/10.
- Public, internet-routable IP addresses that your organization doesn't own. This practice is discouraged because resources in the virtual network can’t access internet endpoints that are exposed over the public IP addresses.
- Special-purpose address blocks that are defined by IANA, like 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 233.252.0.0/24, and 240.0.0.0/4.

> [!NOTE]
> The previous ranges don't provide a long-term solution for organizations that have IPv4 exhaustion issues. In that case, you should minimize private address space consumption.

You can't use the following IP address ranges in Azure virtual networks:

- 224.0.0.0/4 (Multicast)
- 255.255.255.255/32 (Broadcast)
- 127.0.0.0/8 (Loopback)
- 169.254.0.0/16 (Link-local)
- 168.63.129.16/32 (Internal DNS)

### Azure landing zone alignment

The recommendations in this article are for scenarios that are based on the [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). The guidance assumes that:

- Each region has a hub-and-spoke topology.
- Hub-and-spoke networks that are in different regions are connected to each other via global virtual network peering or connections to the same Azure ExpressRoute circuit or circuits.
- Hub-and-spoke networks are connected to on-premises sites via a combination of ExpressRoute circuits and site-to-site VPNs.

The following diagram shows an example architecture. The recommendations are equally applicable to networks that are built on top of Azure Virtual WAN, which also has hub-and-spoke networks in each region.

:::image type="content" source="./images/ipv4-exhaustion-hub-spoke.svg" alt-text="Diagram that shows the regional hub-and-spoke topology." border="false" lightbox="./images/ipv4-exhaustion-hub-spoke.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-hub-spoke-pp.pptx) of this architecture.*

In a scenario that's based on the Azure landing zone architecture, applications are deployed in their own landing zone. Each landing zone contains a spoke virtual network that's peered to a regional hub. Spoke virtual networks are an integral part of the corporate network and are assigned routable IPv4 addresses. These addresses are unique across the entire corporate network. So, all architectural components that are deployed in Azure Virtual Network consume IPv4 addresses in the corporate network’s address space even if only a few components expose endpoints that must be reachable from the entire corporate network. These architectural components might be virtual machines, first-party or third-party network virtual appliances (NVAs), or virtual network-injected platform-as-a-service (PaaS) services.

For the remainder of this article, *front-end component* refers to an application component that's reachable from the entire corporate network, or from outside the component's landing zone. *Back-end component* refers to an application component that doesn't expose endpoints in the corporate network and only needs to be reachable from within its own landing zone. For example, a web application that exposes an endpoint is a front-end component, and a database that doesn't expose an endpoint is a back-end component.

The following sections describe two methods to minimize private address space consumption when you build large networks in Azure.

## Method 1: Nonroutable landing zone spoke virtual networks

RFC 1918 carves IP address blocks out of the IPv4 32-bit address space and makes them nonroutable on the public internet, so you can reuse them in multiple private networks for internal communication. This method is based on the same principle that applies to private address space. One or more address ranges are carved out of the entire private address space that's used by your organization and declared nonroutable within your organization’s corporate network. The address ranges are reused in multiple landing zones. As a result, each landing zone:

- Is assigned a routable address space that's made of one or more address ranges. Your organization centrally manages the address ranges and uniquely assigns them to a landing zone for communicating with the corporate network. Addresses in the routable space are assigned to front-end components.
- Can use the nonroutable address space, which is the address ranges that your organization declares nonroutable in the corporate network. You can use these reserved ranges for internal communication in all landing zones. Addresses in the nonroutable space are assigned to back-end components.

In an Azure hub-and-spoke network that's customer-managed or based on Virtual WAN, two or more spoke virtual networks can't have overlapping IP address spaces. Nonroutable address blocks can't be assigned to a landing zone spoke. Virtual network peering is nontransitive, so a landing zone spoke virtual network can peer with a *second-level* spoke virtual network that has a nonroutable address space. The following diagram shows the dual virtual network topology for landing zones.

:::image type="content" source="./images/ipv4-exhaustion-hub-spoke-vnet-peering.svg" alt-text="Diagram that shows the dual virtual network topology for landing zones." border="false" lightbox="./images/ipv4-exhaustion-hub-spoke-vnet-peering.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-hub-spoke-vnet-peering.pptx) of this architecture.*

Each application landing zone contains two peered virtual networks. One virtual network has routable IP addresses and hosts front-end components. The other virtual network has nonroutable IP addresses and hosts back-end components. The routable landing zone spoke peers with the regional hub. The nonroutable landing zone spoke peers with the routable landing zone spoke. Virtual network peering is nontransitive, so nonroutable prefixes aren't visible to the regional hub or the rest of the corporate network. The routable virtual networks can't use the nonroutable address ranges. Some organizations have fragmented address space that’s already assigned to routable networks. It can be challenging to identify unused large address blocks and declare them nonroutable. In that case, consider unused addresses that aren’t included in the RFC 1918 address space. The previous diagram provides an example of carrier-grade NAT addresses, like RFC 6598, in nonroutable spoke virtual networks.

### Single virtual network landing zone migration

Virtual network peering provides full layer-3 connectivity between two peered virtual networks. Application components deployed in traditional single virtual network landing zones that communicate with each other over IP can be freely moved between routable and nonroutable spoke virtual networks in a landing zone. This section describes two typical migration patterns.

The following applications are exposed via layer-7 application delivery controllers:

:::image type="content" source="./images/ipv4-exhaustion-app-gw-l7.svg" alt-text="Diagram that shows the migration pattern for applications that are exposed via layer-7 application delivery controllers." border="false" lightbox="./images/ipv4-exhaustion-app-gw-l7.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-app-gw-l7.pptx) of this architecture.*

Applications that are exposed via layer-7 application delivery controllers can be moved to the nonroutable spoke. The application delivery controller is the only front-end component that must reside in the routable landing zone spoke.

The following applications are exposed via an Azure load balancer:

:::image type="content" source="./images/ipv4-exhaustion-load-balancer-l4.svg" alt-text="Diagram that shows the migration pattern for applications that are exposed via Azure Load Balancer." border="false" lightbox="./images/ipv4-exhaustion-load-balancer-l4.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-load-balancer-l4.pptx) of this architecture.*

If an application exposes its endpoints via an Azure load balancer, the compute instances that are part of the load balancer’s back-end pool must remain in the same virtual network. Azure load balancers only support back-end instances in their own virtual network.

### Outbound dependencies

An application’s back-end components don't need to be reachable, or receive inbound connections, from the corporate network, but they often have outbound dependencies. Back-end components might need to connect to endpoints that are outside their landing zones in instances such as DNS resolution, accessing application endpoints that are exposed by other landing zones, or accessing logging or backup facilities.

When services initiate connections in nonroutable spoke virtual networks, you must implement source NAT (SNAT) for connections behind a routable IP address. To implement SNAT, deploy a NAT-capable device in the routable spoke virtual network. Each landing zone runs its own dedicated NAT NVA. There are two options for implementing SNAT in a landing zone: Azure Firewall or third-party NVAs. In both cases, all subnets in the nonroutable spoke must be associated with a custom route table. As shown in the following diagram, the route table forwards traffic to destinations outside the landing zone to the SNAT device. Azure NAT Gateway doesn't support SNAT for traffic destined to private IP address space, such as RFC 1918 space.

:::image type="content" source="./images/ipv4-exhaustion-snat-nva.svg" alt-text="Diagram that shows how the custom route table forwards traffic to the SNAT device." border="false" lightbox="./images/ipv4-exhaustion-snat-nva.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-nva.pptx) of this architecture.*

#### Implement SNAT via Azure Firewall

Azure Firewall:

- Provides high availability.
- Provides native scalability and three different SKUs. SNAT is not a resource-intensive task, so consider the basic SKU first. For landing zones that require large volumes of outbound traffic from the nonroutable address space, use the standard SKU.
- Performs SNAT for traffic behind the private IP addresses of any of its instances. Each instance can use all the nonprivileged ports.

The following diagram shows the landing zone layout to implement SNAT in a hub-and-spoke network topology by using Azure Firewall.

:::image type="content" source="./images/ipv4-exhaustion-snat-azure-firewall.svg" alt-text="Diagram that shows the SNAT implementation by using Azure Firewall." border="false" lightbox="./images/ipv4-exhaustion-snat-azure-firewall.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-azfw.pptx) of this architecture.*

You must associate all subnets in the nonroutable spoke with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.

The following diagram shows the landing zone layout to implement SNAT *in a Virtual WAN-based* hub-and-spoke network by using Azure Firewall.

:::image type="content" source="./images/ipv4-exhaustion-snat-azure-firewall-virtual-wan.svg" alt-text="Diagram that shows the SNAT implementation in a Virtual WAN-based network by using Azure Firewall." border="false" lightbox="./images/ipv4-exhaustion-snat-azure-firewall-virtual-wan.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-azfw-virtual-wan.pptx) of this architecture.*

You must associate all subnets in the nonroutable spoke, or the spokes that aren't connected to Virtual WAN, with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.

For both layouts, to provide resources in the nonroutable spoke access to routable IP addresses outside their landing zone, you must deploy Azure Firewall with the **Perform SNAT** option set to **Always** in each landing zone’s routable spoke. You can find instructions about how to configure Azure Firewall to implement SNAT on all received connections in public documentation. The following screenshot shows the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in nonroutable spoke virtual networks.

:::image type="content" source="./images/ipv4-exhaustion-azure-firewall-snat-behavior.svg" alt-text="Screenshot that shows the dialog for Azure Firewall Default SNAT Behavior. Always is selected for the Perform SNAT option." border="false" lightbox="./images/ipv4-exhaustion-azure-firewall-snat-behavior.svg":::

#### Implement SNAT via third-party NVAs

Third-party NVAs with NAT capabilities are available in Azure Marketplace. They provide:

- Granular control over scale-in and scale-out.
- Granular control of the NAT pool.
- Custom NAT policies, such as using different NAT addresses depending on the properties of the incoming connection, like the source or destination IP address.

Consider the following recommendations:

- For high availability, deploy clusters with at least two NVAs. Use an Azure load balancer to distribute incoming connections from the nonroutable spoke virtual network to the NVAs. A high-availability port load-balancing rule is required because the cluster implements SNAT on all connections that leave the landing zone. Azure Standard Load Balancer supports high-availability port load-balancing rules.
- The Azure SDN stack supports single-arm and dual-arm NVAs. Single-arm NVAs are preferred because they reduce address space consumption in the routable spoke virtual networks.

The following diagram shows the landing zone layout to implement SNAT in a hub-and-spoke network topology by using third-party NVAs.

:::image type="content" source="./images/ipv4-exhaustion-nva-snat-flow.svg" alt-text="Diagram that shows the implementation of SNAT in a hub-and-spoke network topology by using third-party NVAs." border="false" lightbox="./images/ipv4-exhaustion-nva-snat-flow.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-nva-snat-flow.pptx) of this architecture.*

The following diagram shows the landing zone layout to implement SNAT *in a Virtual WAN-based* hub-and-spoke network topology by using third-party NVAs.

:::image type="content" source="./images/ipv4-exhaustion-virtual-wan-nva-snat-flow.svg" alt-text="Diagram that shows the implementation of SNAT in a Virtual WAN-based hub-and-spoke network topology by using third-party NVAs." border="false" lightbox="./images/ipv4-exhaustion-virtual-wan-nva-snat-flow.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-virtual-wan-nva-snat-flow.pptx) of this architecture.*

For both third-party NVA layouts, you must deploy multiple instances behind an Azure load balancer to provide high availability. Azure Load Balancer Standard SKU is required.

## Method 2: Azure Private Link services

Private Link provides access to applications that are deployed in a virtual network that's not connected to your virtual network. In the server-side, or application, virtual network, a Private Link service is deployed and associated with an application endpoint that's exposed on the front-end IP address of an internal Azure standard SKU load balancer. In the client-side virtual network, a private endpoint resource is deployed and associated with the Private Link service. The private endpoint exposes the application endpoint in your virtual networks. Private Link provides the tunneling and NAT logic to route traffic between the client side and the server side. For more information, see [What is Azure Private Link?](/azure/private-link/private-link-overview)

Private Link doesn't require a layer-3 connection between the client-side virtual network and the server-side virtual network. The two virtual networks can have overlapping IP address spaces. Private Link allows the deployment of applications in dedicated, isolated virtual networks, all of them using the same nonroutable address space. The applications are exposed as Private Link services in the corporate network, which uses a routable address space. In the context of the Azure landing zone architecture, the resulting landing zone topology has:

- An isolated virtual network that hosts the entire application and the Private Link service that's associated with the application’s endpoints. The application team defines the virtual network address space.
- A spoke virtual network with a routable address space that hosts the private endpoint that's associated with the Private Link service. The spoke virtual network is directly peered with the regional hub.

The following diagram shows the Private Link-enabled landing zone topology.

:::image type="content" source="./images/ipv4-exhaustion-private-link.svg" alt-text="Diagram that shows the landing zone topology when Private Link services expose applications deployed in isolated virtual networks." border="false" lightbox="./images/ipv4-exhaustion-private-link.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link.pptx) of this architecture.*

### Use a Private Link service for outbound dependencies

When you deploy applications in isolated spoke virtual networks, use a Private Link service for outbound dependencies. Define private endpoints in the isolated spoke virtual network and associate them with a Private Link service in routable virtual networks. The following diagram shows the conceptual approach.

:::image type="content" source="./images/ipv4-exhaustion-private-link-isolated.png" alt-text="Diagram that shows Private Link services used for outbound dependencies for applications deployed in isolated virtual networks." border="false" lightbox="./images/ipv4-exhaustion-private-link-isolated.png":::

In real-world, large-scale implementations, the Private Link method might not apply:

- If the applications deployed in the isolated virtual network have multiple outbound dependencies. When you deploy a Private Link service and a private endpoint for each of the outbound dependencies, it increases complexity and management needs.
- If the outbound dependence includes endpoints in the routable network that can't be part of an Azure Load Balancer backend pool, Private Link isn't applicable.

To overcome these two limitations, deploy a proxy/NAT solution in the routable spoke and make it accessible from the isolated virtual network by using Private Link.

:::image type="content" source="./images/ipv4-exhaustion-private-link-flow.svg" alt-text="Diagram that shows the architecture that uses a Private Link service for outbound dependencies." border="false" lightbox="./images/ipv4-exhaustion-private-link-flow.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link-flow.pptx) of this architecture.*

Use a single private endpoint or Private Link service to expose a proxy/NAT solution that's deployed in the routable network. Port-translation and address-translation rules are defined on the NVAs. These rules allow the use of a single private endpoint in the isolated virtual network to access multiple dependencies in the routable network.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

- [Federico Guerrini](https://www.linkedin.com/in/federico-guerrini-phd-8185954) | EMEA Technical Lead
- [Khush Kaviraj](https://www.linkedin.com/in/khushalkaviraj) | Cloud Solution Architect
- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solution Architect
  
**Other contributors:**

- [Jodi Martis](https://www.linkedin.com/in/jodimartis) | Technical Writer

 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Deploy Azure Firewall in a virtual network](/azure/firewall/tutorial-firewall-deploy-portal-policy)
- [Configure SNAT in Azure Firewall](/azure/firewall/snat-private-range)
- [Supported IP addresses in Azure Virtual Network](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-vnets)
- [Azure Private Link](/azure/private-link/private-link-overview)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview)
- [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview)

## Related resources

- [Networking architecture design](networking-start-here.md)
- [Architectural approaches for networking in multitenant solutions](../multitenant/approaches/networking.md)
- [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology)
