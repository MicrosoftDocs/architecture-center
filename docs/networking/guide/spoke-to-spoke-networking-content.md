The most common networking design patterns in Azure use hub-and-spoke virtual network topologies deployed in one or multiple Azure regions. These topologies can optionally connect to on-premises networks via Azure ExpressRoute or site-to-site virtual private network (VPN) tunnels across the public internet.

Most design guides focus on application traffic that flows to those virtual networks from users in internal, on-premises networks or from the internet. This type of traffic is commonly known as *north-south traffic*, which is a term that reflects its vertical representation in network diagrams. This article focuses on various patterns available for *east-west traffic*. Communication flows between workloads deployed in Azure virtual networks, either within a single region or across multiple regions.

Making sure that your network design satisfies requirements for east-west traffic is crucial to providing performance, scalability, and resiliency to your applications that run in Azure.

## Potential use cases

Spoke-to-spoke traffic can be important in the following scenarios:

- Different tiers of a single application are in separate virtual networks. For example, perimeter network servers, also known as *DMZ servers*, in a perimeter virtual network communicate with application services in an internal virtual network.

- Application workloads in different environments, such as Development, Staging, and Production, must replicate data among each other.

- Different applications or microservices need to communicate with each other.

- Databases need to replicate data across regions to guarantee business continuity if a disaster occurs.

- Users are inside Azure virtual networks. For example, they use Azure Virtual Desktop.

## Patterns and topologies for inter-spoke communication

The two main topologies that you can use in Azure designs that cross multiple virtual networks are [self-managed hub and spoke][hubnspoke] and [Azure Virtual WAN][vwan]. In a Virtual WAN environment, Microsoft manages the hub virtual networks and everything inside them. In a self-managed hub-and-spoke environment, you manage the hub virtual network.

Virtual WAN and self-managed hub-and-spoke topologies are both architectures where workloads run in spoke virtual networks. Connectivity to on-premises is centralized in a hub virtual network. Many of the concepts described in this article apply to both self-managed hub-and-spoke and Virtual WAN designs.

There are two main patterns for connecting spoke virtual networks to each other:

- **Spokes directly connected to each other.** Virtual network peerings or VPN tunnels are created between the spoke virtual networks to provide direct connectivity without traversing the hub virtual network.

- **Spokes communicate over a network appliance.** Each spoke virtual network peers with either Virtual WAN or a hub virtual network. An appliance routes traffic between spokes. You can manage the appliance yourself, or Microsoft can manage it for you. This management model works similarly to how management is handled in Virtual WAN deployments.

### Pattern 1: Spokes directly connected to each other

Direct connections between spokes typically provide better throughput, latency, and scalability than connections that go through a network virtual appliance (NVA) across a hub. Sending traffic through NVAs can add latency to the traffic if the NVAs are in a different availability zone and at least two virtual network peerings need to be crossed when traffic is sent over the hub. The options for connecting two spoke virtual networks to each other directly include virtual network peering, Azure Virtual Network Manager, and VPN tunnels.

- **[Virtual network peering][virtual-network-peering]:** Consider the advantages of direct virtual network peerings over spokes:

  - Lower cost because fewer virtual network peering hops are required

  - Better performance because traffic doesn't need to traverse any network appliance that introduces latency or potential bottlenecks
  
  Other scenarios include cross-tenant connectivity. However, you might need to inspect traffic between spoke virtual networks. This process might require you to send traffic through centralized networking devices in the hub virtual network.

- **[Subnet peering][subnet-peering]:** Similar to virtual network peering, but subnet peering allows more granularity by specifying which subnets at both sides of the peering are allowed to talk to each other.

- **[Virtual Network Manager][avnm-hns]:** In addition to the advantages of virtual network peering, Virtual Network Manager provides a management service that lets you manage virtual network environments and create connectivity at scale. You can use Virtual Network Manager to build three types of topologies across subscriptions. These topologies work with both existing and new virtual networks.

  - Hub and spoke with spokes that aren't connected to each other.

  - Hub and spoke with spokes that are directly connected to each other, without any hop in the middle.

  - A meshed group of virtual networks that are interconnected.

    :::image type="complex" border="false" source="images/virtual-network-manager-connectivity-options.svg" alt-text="Network diagram that shows the topologies that Virtual Network Manager supports." lightbox="images/virtual-network-manager-connectivity-options.svg":::
       The diagram shows the topologies that Virtual Network Manager supports. These topologies include hub and spoke, mesh, and hub and spoke with direct connectivity between spokes.
    :::image-end:::

    *Download a [Visio file](https://arch-center.azureedge.net/spoke-to-spoke-source-diagrams.vsdx) of this architecture.*
  
    When you create a hub-and-spoke topology with Virtual Network Manager in which spokes are connected to each other, direct connectivity between spoke virtual networks in the same [network group][avnm-network-group] are automatically created bi-directionally. By using Virtual Network Manager, you can statically or dynamically make spoke virtual networks members of a specific network group, which automatically creates the connectivity for any virtual network.
  
    You can create multiple network groups to isolate clusters of spoke virtual networks from direct connectivity. Each network group provides the same region and multiregion support for spoke-to-spoke connectivity. Be sure to stay below the maximum limits for Virtual Network Manager that are described in the [Virtual Network Manager FAQ][avnm-limits].

- **VPN tunnels connecting virtual networks:** You can configure VPN services to directly connect spoke virtual networks by using Microsoft [VPN gateways][virtual-network-to-virtual-network] or non-Microsoft VPN NVAs. The advantage of this option is that spoke virtual networks connect across commercial and sovereign clouds within the same cloud provider or connectivity cross-cloud providers. If there are software-defined wide area network NVAs in each spoke virtual network, this configuration can facilitate by using the non-Microsoft provider's control plane and feature set to manage virtual network connectivity.

   This option can also help you meet compliance requirements for the encryption of traffic across virtual networks in a single Azure datacenter that [Media Access Control Security encryption][macsec] doesn't provide. But this option has its own set of challenges because of the bandwidth limits of Internet Protocol Security tunnels (1.25 Gbps per tunnel) and the design constraints of having virtual network gateways in both hub and spoke virtual networks. If the spoke virtual network has a virtual network gateway, it can't be connected to Virtual WAN or use a hub's virtual network gateway to connect to on-premises networks.

#### Pattern 1a: Single region

Regardless of the technology that you use to connect spoke virtual networks to each other, the network topologies look like the following image for a single region:

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings.svg" alt-text="Network diagram that shows a single-region hub-and-spoke design. It has spokes that are connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings.svg":::
   The image shows four virtual network sections. Three black lines connect the hub virtual network to three separate virtual networks. A green triangle connects the three spoke networks.
:::image-end:::

#### Pattern 1b: Multiple regions

Designs that connect all spoke virtual networks to each other can extend across multiple regions. In this topology, Virtual Network Manager becomes even more important. It helps reduce the administrative overhead required to maintain a large number of connections.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-2-hubs-full-mesh.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design with spokes in the same region connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-2-hubs-full-mesh.svg":::
   The image shows the East US hub, the West US hub, and six spoke virtual networks. A black line connects the East US hub and the West US hub. Three black lines point from the East US hub to three separate spokes. Two black lines point from the West US hub to two separate spokes. Five green lines point from each spoke and interconnect the six spokes.
:::image-end:::

> [!NOTE]
> When you connect spoke virtual networks directly, either in one region or in multiple regions, consider doing so for spoke virtual networks in the same environment. For example, connect one spoke Development virtual network with another spoke Development virtual network. But avoid connecting a spoke Development virtual network with a spoke Production virtual network.

When you directly connect spoke virtual networks to each other in a fully meshed topology, you need to consider the potentially high number of virtual network peerings required. The following diagram illustrates this problem. In this scenario, we strongly recommend Virtual Network Manager so that you can automatically create virtual network connections.

:::image type="complex" border="false" source="images/peering-number-chart.svg" alt-text="Diagram that shows how the required number of peerings grows with the number of spokes." lightbox="images/peering-number-chart.svg":::
   The image shows a line chart that represents the peerings required for full mesh connectivity. The x axis shows the number of spoke virtual networks. The y axis shows the number of peerings. As the number of virtual networks increases, so do the number of peerings.
:::image-end:::

### Pattern 2: Spokes communicate over a network appliance

Instead of connecting spoke virtual networks directly to each other, you can use network appliances to forward traffic between spokes. Network appliances provide other network services like deep packet inspection and traffic segmentation or monitoring. However, they can introduce latency and performance bottlenecks if they're not properly sized. These appliances are typically located in a hub virtual network that the spokes connect to. There are multiple options for using a network appliance to forward traffic between spokes:

- **Virtual WAN hub router:** Virtual WAN is fully managed by Microsoft. It contains a virtual router that attracts traffic from spokes and routes it to either another virtual network that's connected to Virtual WAN or to on-premises networks via ExpressRoute or site-to-site or point-to-site VPN tunnels. The Virtual WAN router scales up and down automatically, so you only need to make sure that the traffic volume between spokes stays within the [Virtual WAN limits][vwan-limits].

- **Azure Firewall:** [Azure Firewall][azfw] is a network appliance that Microsoft manages and can be deployed in hub virtual networks that you manage or in Virtual WAN hubs. It can forward IP address packets, and it can also inspect them and apply traffic segmentation rules that are defined in policies. It provides autoscaling up to the [Azure Firewall limits][azfw-limits] so that it doesn't become a bottleneck. Azure Firewall provides out-of-the-box multiregion capabilities only when used with Virtual WAN. Without Virtual WAN, you need to implement user-defined routes to achieve cross-regional spoke-to-spoke communication.

- **Non-Microsoft NVAs:** If you prefer to use an NVA from a Microsoft partner to perform routing and network segmentation, you can deploy NVAs in either a hub-and-spoke or a Virtual WAN topology. For more information, see [Deploy highly available NVAs][nva-ha] or [NVAs in a Virtual WAN hub][vwan-nva]. You need to be sure that the NVA supports the bandwidth that the inter-spoke communications generate.

- **Azure VPN Gateway:** You can use a VPN gateway as a next hop type of user-defined route. However, Microsoft doesn't recommend that you use VPN virtual network gateways to route spoke-to-spoke traffic. These devices are designed for encrypting traffic to on-premises sites or VPN users. For example, there's no guaranteed bandwidth between spokes that a VPN gateway can route.

- **ExpressRoute:** In specific configurations, an ExpressRoute gateway can advertise routes that attract spoke-to-spoke communication, sending traffic to the Microsoft Edge router, where it's routed to the destination spoke. This pattern is sometimes known as *ExpressRoute hairpinning*, and needs to be explicitly enabled following the instructions in [Enable or disable virtual network to virtual network or virtual network to Virtual WAN traffic through ExpressRoute][expressroute-hairpinning]. Microsoft strongly discourages this scenario because it introduces latency by sending traffic to the Microsoft backbone edge and back. Microsoft doesn't recommend this approach because it causes a single point of failure and has a large blast radius. This scenario creates multiple problems. It puts extra pressure on the ExpressRoute infrastructure, specifically the gateway and physical routers. That added pressure can result in packet drops.

In self-managed hub-and-spoke network designs that have centralized NVAs, the appliance is typically placed in the hub. Virtual network peerings between hub-and-spoke virtual networks need to be created manually or automatically with Virtual Network Manager:

- **Manual virtual network peerings or subnet peerings:** This approach is sufficient when you have a low number of spoke virtual networks. However, it creates management overhead at scale.

- **[Virtual Network Manager][avnm-hns]:** Virtual Network Manager provides features to manage virtual network environments and peerings at scale. Peering configurations between hub-and-spoke virtual networks are automatically configured bi-directionally for network groups.

  Virtual Network Manager can statically or dynamically add spoke virtual network memberships to a specific [network group][avnm-network-group], which automatically creates the peering connection for new members. Spoke virtual networks in network groups can [use the hub VPN or ExpressRoute gateways for connectivity][avnm-hub-as-gw]. Be sure to stay below the maximum [limits for Virtual Network Manager][avnm-limits].

#### Pattern 2a: Single region

The following diagram shows a single-region hub-and-spoke topology that sends traffic between spokes through an Azure firewall that's deployed in the hub virtual network. Traffic is forwarded to the centralized appliance in the hub via user-defined routes that are applied to the spoke subnets.

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva.svg" alt-text="Network diagram that shows a basic hub-and-spoke design with spokes interconnected through a centralized NVA." lightbox="images/spoke-to-spoke-via-nva.svg":::
   The image shows a basic hub-and-spoke design with spokes interconnected through a centralized NVA. The three black lines connect the hub to the three spokes.
:::image-end:::

In specific circumstances, it might be beneficial to separate the NVAs that handle spoke-to-spoke and internet traffic for scalability. You can achieve this separation by taking the following actions:

- Tune the route tables in each spoke is necessary to send private address traffic, such as traffic that uses RFC 1918 prefixes like `10.0.0.0/8`, `172.16.0.0/12`, or `192.168.0.0/16`, to an NVA. This appliance handles Azure-to-Azure and Azure-to-on-premises traffic, often known as *east-west traffic*.

- Tune internet traffic, which has a `0.0.0.0/0 route`, to a second NVA. This NVA is responsible for Azure-to-internet traffic, also known as *north-south traffic*.

The following diagram shows this configuration:

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-north-south.svg" alt-text="Network diagram that shows a basic hub-and-spoke design. It has spokes connected via two centralized NVAs for internet and private traffic." lightbox="images/spoke-to-spoke-via-nva-north-south.svg":::
   The image shows a North-South hub and an East-West hub. Three dotted lines point from the North-South hub to three separate spokes. Three black lines point from the East-West hub to three separate spokes.
:::image-end:::

> [!NOTE]
> The Azure firewall requires that only one Azure Firewall resource can be deployed in a virtual network. Therefore, a separate hub virtual network is required for extra Azure Firewall resources. For NVA scenarios, you can use a single hub virtual network for extra NVA deployments.

#### Pattern 2b: Multiple regions

You can extend the same configuration to multiple regions. For example, in a self-managed hub-and-spoke design that uses Azure Firewall, you should apply extra route tables to the Azure Firewall subnets in each hub for the spokes in the remote region. This configuration ensures that inter-region traffic can be forwarded between the Azure firewalls in each hub virtual network. Inter-regional traffic between spoke virtual networks then traverses both Azure firewalls. For more information, see [Use Azure Firewall to route a multi-hub and spoke topology][azfw-multi-hub-and-spoke].

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design via NVAs in the hubs." lightbox="images/spoke-to-spoke-via-nva-2-hubs.svg":::
   The image shows an East US hub and a West US hub. A black line connects the two hubs. Three solid black lines connect the East US hub to three separate spokes. Three solid black lines connect the West US hub to three separate spokes.
:::image-end:::

The design variation that has separate Azure firewalls or NVAs for north-south and east-west traffic is also possible in a multiregion hub-and-spoke topology:

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-2-hubs-north-south.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design. It has separate east-west and north-south firewalls in each region." lightbox="images/spoke-to-spoke-via-nva-2-hubs-north-south.svg":::
   The image shows the following hubs: a North-South East US hub, an East-West East US hub, an East-West West US hub, and a North-South West US hub. Three dotted lines connect the North-South East US hub to three separate spokes. Three solid lines connect the East-West East US hub to three separate spokes. Three solid lines connect the East-West West US hub to three separate spokes. Three dotted lines connect the North-South West US hub to three separate spokes.
:::image-end:::

Virtual WAN creates a similar topology and takes over the routing complexity. It manages routing in the hubs, which Microsoft manages, and in the spokes, where routes can be injected without manual route table edits. The network administrator only needs to connect the spoke virtual networks to a Virtual WAN hub and doesn't need to worry about forwarding traffic between regions.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-virtual-wan.svg" alt-text="Network diagram that shows a Virtual WAN design with spokes connected via Virtual WAN." lightbox="images/spoke-to-spoke-through-virtual-wan.svg":::
   The image shows a virtual WAN with East US and West US virtual hubs. Two groups of three lines connect the virtual WAN to three separate spokes. There are six spokes in total.
:::image-end:::

### Mixed patterns

Some scenarios might require a hybrid approach that combines the two patterns described previously. In this case, traffic between specific spokes needs to go over direct connections, but the rest of the spokes communicate through a central network appliance. For example, in a Virtual WAN environment, you can directly connect two specific spokes that have high bandwidth and low latency requirements. Another scenario involves spoke virtual networks that are part of a single environment. For example, you might allow a spoke Development virtual network to connect directly to another spoke Development virtual network, but force Development and Production workloads to communicate through the central appliance.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-selective-peerings-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design.. Some spokes are connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-selective-peerings-2-hubs.svg":::
   The image shows an East US hub and the West US hub. A black line connects the hubs. Three black lines connect the East US hub to three separate spokes. Three black lines connect the West US hub to three separate spokes. A green line connects one spoke from each hub.
:::image-end:::

Another common pattern connects spokes in one region via direct virtual network peerings or Virtual Network Manager [connected groups][avnm-connected-group], but allows inter-regional traffic to cross NVAs. The main motivation for this model is typically to reduce the number of virtual network peerings in the architecture. However, compared to the first model (direct connectivity between spokes), one disadvantage introduced in this model is more virtual network peering hops for cross-region traffic. These hops increase costs because of the multiple virtual network peerings that are crossed. Another disadvantage is the extra load to the hub NVAs to front all cross-regional traffic.  

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design. Spokes in a single region are connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-2-hubs.svg":::
   The image shows an East US hub and the West US hub. A black line connects the hubs. Three black lines connect the East US hub to three separate spokes. Three black lines connect the West US hub to three separate spokes. In both hubs, a green triangle connects the three spokes.
:::image-end:::

The same designs are applicable to Virtual WAN. However, one consideration is that direct connectivity between spoke virtual networks must be manually configured between the virtual networks themselves instead of through the Virtual WAN resource. Virtual Network Manager currently doesn't support architectures based on Virtual WAN. Consider the following diagram:

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-virtual-wan.svg" alt-text="Network diagram that shows a Virtual WAN design with spokes connected via Virtual WAN and some virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-virtual-wan.svg":::
   The image shows a virtual WAN with East US and West US virtual hubs. In both hubs, three black lines connect the virtual WAN section to three separate spokes. A green triangle also connects the three spokes in each hub.
:::image-end:::

> [!NOTE]
> For mixed approaches, it's important to understand that direct connectivity via virtual network peering propagates system routes for its connecting virtual networks that are often more specific than custom routes configured via route tables. Therefore, the virtual network peering path is preferred over custom routes that follow the [longest prefix-match route selection][udr-route-selection].
>
> However, in less common scenarios, if there's both a system route and a custom user-defined route that have the same address prefix, the user-defined route takes precedence over system routes (automatically created by virtual network peering). This behavior results in spoke-to-spoke virtual network traffic traversing through the hub virtual network, even if there's a direct connection through peering.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Jay Li](https://www.linkedin.com/in/jie-jay-li/) | Senior Product Manager
- [Jose Moreno](https://www.linkedin.com/in/erjosito) | Principal Customer Engineer
- [Alejandra Palacios](https://www.linkedin.com/in/alejandrampalacios) | Senior Azure Infrastructure Customer Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Mohamed Hassan](https://www.linkedin.com/in/mohnader) | Principal PM Manager
- [Andrea Michael](https://www.linkedin.com/in/amichael98) | Program Manager
- [Yasukuni Morishima](https://www.linkedin.com/in/yasukuni-morishima-621aa9141) | Customer Engineer II
- Jithin PP| Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Cloud Adoption Framework: Landing zone network topology and connectivity][caf-network-topology-and-connectivity]
- [Virtual Network Manager][avnm]
- [Virtual WAN][vwan]
- [Azure Firewall][azfw]
- [Secure network connectivity on Azure][secure-network-azure]
- [Introduction to Azure Virtual Networks][intro-avn]
- [Traditional Azure networking topology][traditional-azure-topology]

## Related resources

- [Hub-spoke network topology in Azure][hub-spoke-azure]
- [Hub-spoke network topology with Virtual WAN][hub-spoke-azure-virtual-wan]

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
[macsec]: /azure/virtual-network/virtual-networks-faq#is-vnet-peering-traffic-encrypted
[nva-ha]: network-virtual-appliance-high-availability.md
[secure-network-azure]: /training/modules/secure-network-connectivity-azure
[subnet-peering]: /azure/virtual-network/how-to-configure-subnet-peering
[traditional-azure-topology]: /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
[udr-route-selection]: /azure/virtual-network/virtual-networks-udr-overview#how-azure-selects-a-route
[virtual-network-peering]: /azure/virtual-network/virtual-network-peering-overview
[virtual-network-to-virtual-network]: /azure/vpn-gateway/vpn-gateway-howto-vnet-vnet-resource-manager-portal
[vwan-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#virtual-wan-limits
[vwan-nva]: /azure/virtual-wan/about-nva-hub
[vwan]: /azure/virtual-wan/virtual-wan-about
