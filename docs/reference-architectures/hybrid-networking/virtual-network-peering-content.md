This article compares two ways to connect virtual networks in Azure: virtual network peering and virtual private network (VPN) gateways. It also explores spoke-to-spoke communication patterns for hub-and-spoke architectures to help you choose the optimal approach for your networking requirements.

Virtual networks form the foundation of these topologies. A [virtual network](/azure/virtual-network/virtual-networks-overview) is a private network space in Azure that provides isolation for your resources. By default, Azure doesn't route traffic between virtual networks. But you can connect virtual networks, either within a single region or across two regions, to route traffic between them.

## Virtual network connection types

- **Virtual network peering** connects two Azure virtual networks, which makes them appear as one for connectivity purposes. Azure routes traffic between virtual machines in the peered virtual networks through the Microsoft backbone by using private IP addresses only.

- **Subnet peering** connects specific [subnets](/azure/virtual-network/virtual-network-manage-subnet) between virtual networks instead of peering entire virtual networks.

- **VPN gateways** are specific types of virtual network gateways that send traffic between an Azure virtual network and a cross-premises location over the public internet. You can also use a VPN gateway to send traffic between Azure virtual networks. Each virtual network supports only one VPN gateway.

## Gateway transit

Virtual network peering and VPN gateways can also coexist through gateway transit.

Gateway transit lets you use a peered virtual network's gateway to connect to on-premises, instead of creating a new gateway. As your workloads in Azure increase, you must scale your networks across regions and virtual networks to support that growth. Use gateway transit to share an [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) or VPN gateway with all peered virtual networks and manage connectivity in one place. This method saves money and simplifies management.

When you enable gateway transit on virtual network peering, you can create a transit virtual network that contains your VPN gateway, network virtual appliance (NVA), and other shared services. As your organization adds new applications or business units and creates new virtual networks, you can connect them to your transit virtual network by using peering. This setup avoids network complexity and reduces the effort required to manage multiple gateways and appliances.

## Configure connections

Virtual network peering and VPN gateways support the following connection types:

- Virtual networks in different regions
- Virtual networks in different Microsoft Entra tenants
- Virtual networks in different Azure subscriptions

For more information, see the following articles:

- [Create a virtual network peering across different subscriptions by using Azure Resource Manager](/azure/virtual-network/create-peering-different-subscriptions)
- [Configure a virtual network-to-virtual network VPN gateway connection by using the Azure portal](/azure/vpn-gateway/vpn-gateway-howto-vnet-vnet-resource-manager-portal)
- [Connect virtual networks from different deployment models by using the portal](/azure/vpn-gateway/vpn-gateway-connect-different-deployment-models-portal)
- [Azure VPN Gateway FAQ](/azure/vpn-gateway/vpn-gateway-vpn-faq)

## Comparison of virtual network peering and VPN gateway

| Feature or capability | Virtual network peering | VPN gateway |
|------|--------------|--------------|
| Limits |  Up to [500 virtual network peerings per virtual network](/azure/azure-subscription-service-limits#azure-networking-limits). Use the Azure Virtual Network Manager connectivity configuration feature to create up to 1,000 virtual networks peerings per virtual network. | One VPN gateway per virtual network. The maximum number of tunnels per gateway depends on the [gateway SKU](/azure/vpn-gateway/vpn-gateway-about-vpngateways#gwsku). |
| Pricing model | [Ingress and egress](https://azure.microsoft.com/pricing/details/virtual-network/) | [Hourly and egress](https://azure.microsoft.com/pricing/details/vpn-gateway/) |
| Encryption | Use [Azure Virtual Network encryption](/azure/virtual-network/virtual-network-encryption-overview). | Apply custom [IPsec/IKE](/azure/vpn-gateway/vpn-gateway-about-vpn-devices) policy to new or existing connections. See [About cryptographic requirements and Azure VPN gateways](/azure/vpn-gateway/vpn-gateway-about-compliance-crypto). |
| Bandwidth limitations | No bandwidth limitations | Varies [based on SKU](/azure/vpn-gateway/vpn-gateway-about-vpngateways#gwsku) |
| Private? | Yes, routes through the Microsoft backbone and avoids the public internet | VPN gateways use public IP addresses, but traffic routes through the Microsoft backbone via [Microsoft global network](/azure/virtual-network/ip-services/routing-preference-overview) when it's enabled. |
| Transitive relationship | Peering connections are nontransitive. Use NVAs or gateways in the hub virtual network to enable transitive networking. See a [hub-spoke network topology example](../../networking/architecture/hub-spoke.yml). | Transitive routing is supported if you connect virtual networks via VPN gateways and enable [Border Gateway Protocol (BGP)](/azure/vpn-gateway/vpn-gateway-bgp-overview) in the connections. |
| Initial setup time | Fast | About 30 minutes |
| Typical scenarios | Data replication, database failover, and other scenarios that need frequent backups of large data. Supports data policies that prevent sending any traffic over the internet. | Scenarios that aren't latency sensitive, don't need high throughput, and include data policies that support internet traversal |

The virtual network peering and VPN gateway technologies form the foundation for more complex networking architectures. One of the most common enterprise patterns is hub-and-spoke networking, where multiple spoke virtual networks need to communicate with each other. The choice between virtual network peering and VPN gateways significantly affects how you implement inter-spoke communication.

## Spoke-to-spoke communication patterns

*Inter-spoke networking* refers to direct communication between workloads or workload components that run in different spoke virtual networks within hub-and-spoke architectures. Spoke-to-spoke patterns eliminate the need to route traffic through the central hub.

Inter-spoke networking provides the following benefits:

- **Better performance**: Direct connections eliminate extra hops and bottlenecks.
- **Lower costs**: Fewer peering connections and reduced hub infrastructure requirements.
- **Easier management**: Less complex routing and fewer components to monitor.
- **Regional flexibility**: Support for both single-region and cross-region communication patterns.

Most design guides focus on *north-south traffic*, which flows between users and applications (from on-premises networks or the internet to Azure virtual networks). These patterns focus on *east-west traffic*, which represents communication flows between workload components deployed in Azure virtual networks, either within a single region or across multiple regions. Ensure that your network design satisfies requirements for east-west traffic to provide performance, scalability, and resiliency to your applications that run in Azure.

Hub-and-spoke architectures provide centralized control and security, but they can become performance bottlenecks and cost centers when *all* workload-to-workload traffic must traverse the hub. Inter-spoke networking provides architectural flexibility to optimize for performance and cost where it makes business sense, while maintaining centralized control for security and governance needs.

Two main patterns connect spoke virtual networks to each other:

- **Pattern 1: Spokes directly connect to each other.** Create virtual network peerings or VPN tunnels between the spoke virtual networks to provide direct connectivity without traversing the hub virtual network.

- **Pattern 2: Spokes communicate over a network appliance.** Connect each spoke virtual network to either Azure Virtual WAN or a hub virtual network. A network appliance routes traffic between spokes. You can manage the appliance yourself, or Microsoft can manage it. This management model is similar to management in Virtual WAN deployments.

### Choose your approach

Use the following table to choose your overall approach based on your priorities.

| Your priority | Recommended pattern | Key technology |
|---------------|--------------------|-----------------| 
| Maximum performance | Pattern 1 | Virtual network peering |
| Enterprise scale management | Pattern 1 | Virtual Network Manager |
| Traffic inspection | Pattern 2 | Azure Firewall |
| Multi-region simplicity | Pattern 2 | Virtual WAN |
| Cross-cloud connectivity | Pattern 1 | VPN tunnels |

The following sections provide implementation details for each pattern.

### Pattern 1: Spokes directly connect to each other

Direct connections between spokes typically provide better throughput, latency, and scalability than connections that go through an NVA across a hub. Sending traffic through NVAs can add latency if the NVAs reside in different [availability zones](/azure/availability-zones/az-overview) and traffic must cross at least two virtual network peerings.

To connect two spoke virtual networks to each other directly, use virtual network peering, Virtual Network Manager, or VPN tunnels.

| Technology | Best for | Limitations | Management |
|------------|----------|-------------|------------|
| Virtual network peering | High performance, same cloud | 500 peering limit | Manual |
| Virtual Network Manager | Enterprise scale (more than five spokes) | Learning curve | Automated |
| VPN tunnels | Cross-cloud, encryption | 1.25 Gbps per tunnel | Complex |

#### Virtual network peering

Virtual network peering provides the highest performance option for direct spoke-to-spoke connectivity. This method creates low-latency, high-bandwidth connections through the [Microsoft backbone infrastructure](/azure/networking/microsoft-global-network), without gateways or extra hops in the path. You can also peer virtual networks across Azure regions, which is known as *global peering*.

Use virtual network peering for scenarios such as cross-region data replication and database failover, specifically where your data policies don't require inspection. This approach is often used between network-isolated components within a single workload. Because traffic stays private and travels only on the Microsoft backbone, virtual network peering supports strict data policies and avoids sending traffic over the public internet.

For spoke-to-spoke implementation, follow these guidelines:

- Create peering connections directly between spoke virtual networks that need to communicate.

- Maintain existing hub-to-spoke peerings for centralized services and traffic that should be subjected to egress scrutiny.
- Limit peering to spokes within the same environment.
- Plan for scaling based on the number of spokes. Manual peering works for two to five spokes. Use Virtual Network Manager for larger environments.

To optimize your design, follow these best practices:

- Monitor the 500 peering limit per virtual network.

- Use regional peering when possible for lowest latency.
- Use [network security groups](/azure/virtual-network/network-security-groups-overview) to control traffic flow between peered networks.
- Document peering relationships for troubleshooting and compliance.
- Test connectivity after establishing peerings to verify proper routing.
- Limit connectivity to be unidirectional when supported by the scenario.

[Subnet peering][subnet-peering] works similarly to virtual network peering but provides more granular control. You can specify which subnets at both sides of the peering can communicate with each other. This feature requires subscription registration and enforces a 400 subnet limit per peering connection. Subnet peering supports scenarios like overlapping virtual network ranges, IPv6-only connections, and selective gateway exposure.

#### Virtual Network Manager

[Virtual Network Manager][avnm-hns] provides automated management for virtual network connectivity at scale. You can use Virtual Network Manager to build three types of topologies across subscriptions. These topologies work with both existing and new virtual networks.

  - Hub and spoke with spokes that don't connect to each other

  - Hub and spoke with spokes that directly connect to each other, without a hop in the middle

  - A meshed group of virtual networks that connect to each other

:::image type="complex" border="false" source="images/virtual-network-manager-connectivity-options.svg" alt-text="Network diagram that shows the topologies that Virtual Network Manager supports." lightbox="images/virtual-network-manager-connectivity-options.svg":::
    The diagram shows three network topology diagrams, labeled hub and spoke, mesh, and hub and spoke with direct connectivity between spokes. The first diagram features a central node connected to six outer nodes via solid black lines. The second diagram displays six nodes arranged in a square grid, with each node connected to every other node by green dashed lines. The third diagram combines both styles and shows a central node linked to six outer nodes with black lines. Green dashed lines connect the outer nodes to each other.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/spoke-to-spoke-source-diagrams.vsdx) of these topologies.*
  
When you create a hub-and-spoke topology by using Virtual Network Manager and connect spokes to each other, Azure automatically creates bi-directional connectivity between spoke virtual networks in the same [network group][avnm-network-group].

Use Virtual Network Manager to statically or dynamically assign spoke virtual networks to specific network groups. This assignment automatically creates virtual network connectivity.
  
You can create multiple network groups to isolate clusters of spoke virtual networks from direct connectivity. Each network group supports both single-region and multiregion spoke-to-spoke connections. Understand the [limits for Virtual Network Manager][avnm-limits].

#### VPN tunnels

Configure VPN services to directly connect spoke virtual networks by using Microsoft [VPN gateways][virtual-network-to-virtual-network] or non-Microsoft VPN NVAs. VPN gateways provide limited bandwidth connections and work well in scenarios that require encryption but can tolerate bandwidth restrictions and latency. To help detect and mitigate large-scale attacks, enable [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on perimeter virtual networks.

Spoke virtual networks connect across commercial and sovereign clouds within the same cloud provider or between cross-cloud providers. If each spoke virtual network includes software-defined wide area network NVAs, use the non-Microsoft provider's control plane and feature set to manage virtual network connectivity.

VPN-based connections also help meet compliance requirements for the encryption of traffic across virtual networks in a single Azure datacenter, where [Media Access Control Security encryption (MACsec)][macsec] doesn't apply.

This approach has the following limitations:

- Bandwidth is limited to 1.25 Gbps per tunnel.
- It requires virtual network gateways in both hub and spoke virtual networks.
- Spoke virtual networks that have gateways can't connect to Virtual WAN or use hub gateways for on-premises connectivity.

#### Single vs. multiple regions

The following diagram shows the network topology for a single region, regardless of the technology used for spoke virtual network connection.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings.svg" alt-text="Network diagram that shows a single-region hub-and-spoke design." lightbox="images/spoke-to-spoke-through-peerings.svg":::
The image shows four virtual network sections. Three black lines connect the hub virtual network to three separate virtual networks. Green lines connect all three spoke virtual networks with each other.
:::image-end:::

The following diagram shows the network topology for multiple regions. Designs that connect all spoke virtual networks to each other can extend across multiple regions. Virtual Network Manager helps reduce the administrative effort required to maintain a large number of connections.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-2-hubs-full-mesh.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design with spokes in the same region connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-2-hubs-full-mesh.svg":::
The image shows an East US hub and West US hub at the top and six spoke virtual networks. A black line connects the East US hub and the West US hub. Three black lines point from the East US hub to three separate spokes. Three black lines point from the West US hub to three separate spokes. Five green lines point from each spoke and interconnect the six spokes.
:::image-end:::

> [!NOTE]
> When you use the direct connection method, whether in a single region or multiple regions, connect spoke virtual networks within the same environment. For example, connect one spoke development virtual network with another spoke development virtual network. Don't connect a spoke development virtual network with a spoke production virtual network.

When you directly connect spoke virtual networks to each other in a fully meshed topology, expect a high number of virtual network peerings. The following diagram shows this challenge. In this scenario, use Virtual Network Manager to automatically create virtual network connections.

:::image type="complex" border="false" source="images/peering-number-chart.svg" alt-text="Diagram that shows how the required number of peerings grows with the number of spokes." lightbox="images/peering-number-chart.svg":::
The image shows a line chart that represents the peerings required for full mesh connectivity. The x axis shows the number of spoke virtual networks. The y axis shows the number of peerings. The number of virtual networks increases as the number of peerings increases.
:::image-end:::

### Pattern 2: Spokes communicate over a network appliance

Instead of connecting spoke virtual networks directly to each other, you can use network appliances to forward traffic between spokes. Network appliances provide other network features like deep packet inspection, traffic segmentation, and monitoring. But they can introduce latency and performance bottlenecks if not properly sized. These appliances typically reside in a hub virtual network that the spokes connect to.

The following resources use a network appliance to forward traffic between spokes:

- **Virtual WAN hub router:** Microsoft manages Virtual WAN. Virtual WAN contains a virtual router that attracts traffic from spokes. It routes that traffic to either another virtual network connected to Virtual WAN or to on-premises networks via ExpressRoute or site-to-site or point-to-site VPN tunnels. The Virtual WAN router scales up and down automatically. You only need to ensure that the traffic volume between spokes stays within the [Virtual WAN limits][vwan-limits].

- **Azure Firewall:** [Azure Firewall][azfw] is a Microsoft-managed network appliance that you can deploy in hub virtual networks that you manage or in Virtual WAN hubs. It forwards IP address packets, inspects them, and applies traffic segmentation rules defined in policies. Azure Firewall automatically scales up so that it doesn't become a bottleneck, but it has [limits][azfw-limits]. It supports built-in multiregion capabilities only when used with Virtual WAN. Without Virtual WAN, you must implement user-defined routes to enable cross-regional spoke-to-spoke communication.

- **Non-Microsoft NVAs:** If you prefer Microsoft partner NVAs to perform routing and network segmentation, you can deploy them in either a hub-and-spoke or Virtual WAN topology. For more information, see [Deploy highly available NVAs][nva-ha] and [NVAs in a Virtual WAN hub][vwan-nva]. Ensure that the NVA supports the bandwidth that the inter-spoke communications generate.

- **Azure VPN Gateway:** You can use a VPN gateway as a next hop type of user-defined route. Don't use VPN virtual network gateways to route spoke-to-spoke traffic. These devices are designed to encrypt traffic to cross-premises sites or VPN users. For example, Azure doesn't guarantee bandwidth between spokes when you route through a VPN gateway.
- **ExpressRoute:** An ExpressRoute gateway can advertise routes that attract spoke-to-spoke communication. This setup sends traffic to the Microsoft Edge router, which routes it to the destination spoke. This pattern, known as *ExpressRoute hairpinning*, must be [explicitly enabled][expressroute-hairpinning]. Avoid using this approach because it introduces latency by sending traffic to the Microsoft backbone edge and back. It creates a single point of failure and expands the blast radius. It also puts extra load on the ExpressRoute infrastructure, specifically the gateway and physical routers, which can result in packet drops.

In self-managed hub-and-spoke network designs that include centralized NVAs, place the appliance in the hub. Create virtual network peerings between hub-and-spoke virtual networks manually, or use Virtual Network Manager to automate the configuration:

- **Manual virtual network peerings or subnet peerings:** This approach works well when you have a few spoke virtual networks. But it adds management overhead at scale.

- **[Virtual Network Manager][avnm-hns]:** Virtual Network Manager automates peering configurations between hub and spoke virtual networks at scale. Spoke virtual networks in network groups can [use the hub VPN or ExpressRoute gateways for connectivity][avnm-hub-as-gw]. Stay within the [Virtual Network Manager limits][avnm-limits].

#### Single region deployment

The following diagram shows a single-region hub-and-spoke topology that sends traffic between spokes through an Azure firewall deployed in the hub virtual network. [User-defined routes](/azure/virtual-network/virtual-networks-udr-overview) applied to the spoke subnets forward traffic to the centralized appliance in the hub.

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva.svg" alt-text="Network diagram that shows a basic hub-and-spoke design with spokes that interconnect through a centralized NVA." lightbox="images/spoke-to-spoke-via-nva.svg":::
The image shows a basic hub-and-spoke design with spokes interconnected through a centralized NVA. The three black lines connect the hub to the three spokes.
:::image-end:::

To improve scalability, you can separate NVAs that handle spoke-to-spoke traffic from NVAs that handle internet traffic. To separate NVAs, do the following steps:

- Tune the [route tables](/azure/virtual-network/manage-route-table) in each spoke to send private address traffic, such as traffic that uses RFC 1918 prefixes like `10.0.0.0/8`, `172.16.0.0/12`, or `192.168.0.0/16`, to an NVA. This appliance handles Azure-to-Azure and Azure-to-on-premises traffic, often known as *east-west traffic*.

- Tune internet traffic, which has a `0.0.0.0/0` route, to a second NVA. This NVA manages Azure-to-internet traffic, also known as *north-south traffic*.

The following diagram shows this configuration.

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-north-south.svg" alt-text="Network diagram that shows a basic hub-and-spoke design. It has spokes connected via two centralized NVAs for internet and private traffic." lightbox="images/spoke-to-spoke-via-nva-north-south.svg":::
The image shows a North-South hub and an East-West hub. The North-South hub includes one NVA. The East-West hub includes two NVAs. Three dotted lines point from the North-South hub to three separate spokes. Three black lines point from the East-West hub to the same three spokes.
:::image-end:::

> [!NOTE]
> Azure Firewall supports only one firewall resource per virtual network. To deploy extra Azure Firewall resources, create separate hub virtual networks. For NVA scenarios, use a single hub virtual network for extra NVA deployments.

#### Multiple region deployment

You can extend the same configuration to multiple regions. For example, in a self-managed hub-and-spoke design that uses Azure Firewall, apply extra [route tables](/azure/virtual-network/manage-route-table) to the Azure Firewall subnets in each hub. These route tables support spokes in remote regions and ensure that inter-region traffic flows between the Azure firewalls in each hub virtual network. Inter-regional traffic between spoke virtual networks traverses both Azure firewalls. For more information, see [Use Azure Firewall to route a multi-hub and spoke topology][azfw-multi-hub-and-spoke].

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design via NVAs in the hubs." lightbox="images/spoke-to-spoke-via-nva-2-hubs.svg":::
The image shows an East US hub and a West US hub. Each hub includes a firewall. A black line connects the two hubs. Three solid black lines connect the East US hub to three separate spokes. Three solid black lines connect the West US hub to three separate spokes.
:::image-end:::

The following diagram shows a design variation that includes separate Azure firewalls or NVAs for north-south and east-west traffic in a multiregion hub-and-spoke topology.

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-2-hubs-north-south.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design. It has separate east-west and north-south firewalls in each region." lightbox="images/spoke-to-spoke-via-nva-2-hubs-north-south.svg":::
The image shows the following hubs: a North-South East US hub, an East-West East US hub, an East-West West US hub, and a North-South West US hub. Three dotted lines connect the North-South East US hub to three separate spokes. Three solid lines connect the East-West East US hub to the same spokes. Three solid lines connect the East-West West US hub to three different separate spokes. Three dotted lines connect the North-South West US hub to these spokes.
:::image-end:::

The following topology uses Virtual WAN to simplify routing. Virtual WAN manages routing in the hubs, which Microsoft manages, and in the spokes, where it can inject routes automatically without manual route table edits. The network administrator only needs to connect the spoke virtual networks to a Virtual WAN hub and doesn't need to manage traffic forwarding between regions.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-virtual-wan.svg" alt-text="Network diagram that shows a design with spokes connected via Virtual WAN." lightbox="images/spoke-to-spoke-through-virtual-wan.svg":::
The diagram shows Virtual WAN with East US and West US virtual hubs. Two groups of three lines connect Virtual WAN to three separate spokes.
:::image-end:::

### Mixed patterns

Some scenarios require a hybrid approach that combines the two patterns. In this case, traffic between specific spokes goes over direct connections, but the rest of the spokes communicate through a central network appliance. For example, in a Virtual WAN environment, you can directly connect two specific spokes that have high-bandwidth and low-latency requirements.

Another scenario involves spoke virtual networks that are part of a single environment. For example, you might connect a spoke development virtual network directly to another spoke development virtual network, but development and production workloads communicate through the central appliance.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-selective-peerings-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design. Some spokes are connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-selective-peerings-2-hubs.svg":::
The image shows an East US hub and West US hub. Each hub has an NVA. A black line connects the hubs. Three black lines connect the East US hub to three separate spokes. Three black lines connect the West US hub to three separate spokes. A green line connects one spoke from each hub.
:::image-end:::

Another common pattern connects spokes in one region via direct virtual network peerings or Virtual Network Manager [connected groups][avnm-connected-group] but allows inter-regional traffic to cross NVAs. This model reduces the number of virtual network peerings in the architecture. But compared to the first model (direct connectivity between spokes), this model has more virtual network peering hops for cross-region traffic. These hops increase costs because of the multiple virtual network peerings that are crossed. This model also introduces extra load to the hub NVAs to front cross-regional traffic.  

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design. Spokes in a single region are connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-2-hubs.svg":::
The image shows an East US hub and West US hub. Each hub has an NVA. A black line connects the hubs. Three black lines connect the East US hub to three separate spokes. Three black lines connect the West US hub to three separate spokes. In both hub networks, the spokes are all connected with each other with green lines.
:::image-end:::

The same designs apply to Virtual WAN. But direct connectivity between spoke virtual networks requires manual configuration between the virtual networks instead of through the Virtual WAN resource. Virtual Network Manager doesn't support architectures that use Virtual WAN. Consider the following diagram.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-virtual-wan.svg" alt-text="Network diagram that shows a Virtual WAN design with spokes connected via Virtual WAN and some virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-virtual-wan.svg":::
The image shows Virtual WAN with East US and West US virtual hubs. In both hubs, three black lines connect the Virtual WAN section to three separate spokes. The spokes in each hub are all connected with each other with green lines. No lines directly connect spokes from one hub to spokes in the other hub.
:::image-end:::

> [!NOTE]
> For mixed approaches, direct connectivity via virtual network peering propagates system routes between connected virtual networks. These system routes are often more specific than custom routes configured via route tables. Therefore, the virtual network peering path is preferred over custom routes that follow the [longest prefix-match route selection][udr-route-selection].
>
> In less common scenarios, when a system route and a custom user-defined route have the same address prefix, the user-defined route overrides the system routes created by virtual network peering. This behavior causes spoke-to-spoke virtual network traffic to pass through the hub virtual network, even when a direct peering connection exists.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Jay Li](https://www.linkedin.com/in/jie-jay-li/) | Senior Product Manager
- [Jose Moreno](https://www.linkedin.com/in/erjosito/) | Principal Customer Engineer
- [Alejandra Palacios](https://www.linkedin.com/in/alejandrampalacios/) | Azure Customer Engineer

Other contributors:

- [Mohamed Hassan](https://www.linkedin.com/in/mohnader/) | Head of Product, Azure Networking
- [Andrea Michael](https://www.linkedin.com/in/amichael98/) | Product Manager 2

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Plan virtual networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)
- [Choose a solution to connect an on-premises network to Azure](./index.yml)
- [Create a virtual network peering by using the Azure portal](/azure/virtual-network/tutorial-connect-virtual-networks-portal)
- [Virtual Network Manager](/azure/virtual-network-manager/overview)
- [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)

[avnm-connected-group]: /azure/virtual-network-manager/concept-connectivity-configuration#connectedgroup
[avnm-hns]: /azure/virtual-network-manager/concept-connectivity-configuration#hub-and-spoke-topology
[avnm-hub-as-gw]: /azure/virtual-network-manager/concept-connectivity-configuration#use-hub-as-a-gateway
[avnm-limits]: /azure/virtual-network-manager/faq#limits
[avnm-network-group]: /azure/virtual-network-manager/concept-network-groups
[avnm]: /azure/virtual-network-manager/overview
[azfw-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits
[azfw-multi-hub-and-spoke]: /azure/firewall/firewall-multi-hub-spoke
[azfw]: /azure/firewall/overview
[caf-network-topology-and-connectivity]: /azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity
[expressroute-hairpinning]: /azure/expressroute/expressroute-howto-add-gateway-portal-resource-manager#enable-or-disable-vnet-to-vnet-or-vnet-to-virtual-wan-traffic-through-expressroute
[hub-spoke-azure]: ../architecture/hub-spoke.yml
[hub-spoke-azure-virtual-wan]: ../architecture/hub-spoke-virtual-wan-architecture.yml
[hubnspoke]: /azure/architecture/reference-architectures/hybrid-networking/hub-spoke
[intro-avn]: /training/modules/introduction-to-azure-virtual-networks
[macsec]: /azure/virtual-network/virtual-networks-faq#is-virtual-network-peering-traffic-encrypted
[nva-ha]: ../../networking/guide/network-virtual-appliance-high-availability.md
[secure-network-azure]: /training/modules/secure-network-connectivity-azure
[subnet-peering]: /azure/virtual-network/how-to-configure-subnet-peering
[traditional-azure-topology]: /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
[udr-route-selection]: /azure/virtual-network/virtual-networks-udr-overview#how-azure-selects-a-route
[virtual-network-peering]: /azure/virtual-network/virtual-network-peering-overview
[virtual-network-to-virtual-network]: /azure/vpn-gateway/vpn-gateway-howto-vnet-vnet-resource-manager-portal
[vwan-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-virtual-wan-limits
[vwan-nva]: /azure/virtual-wan/about-nva-hub
[vwan]: /azure/virtual-wan/virtual-wan-about
