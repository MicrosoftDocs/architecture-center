This article compares two ways to connect virtual networks in Azure: virtual network peering and VPN gateways. It also explores spoke-to-spoke communication patterns for hub-and-spoke architectures to help you choose the optimal approach for your networking requirements.

A virtual network is a virtual, isolated portion of the Azure public network. By default, traffic can't be routed between two virtual networks. However, it's possible to connect virtual networks, either within a single region or across two regions, so that traffic can be routed between them.

## Virtual network connection types

**Virtual network peering**. Virtual network peering connects two Azure virtual networks. Once peered, the virtual networks appear as one for connectivity purposes. Traffic between virtual machines in the peered virtual networks is routed through the Microsoft backbone infrastructure, through private IP addresses only. No public internet is involved. You can also peer virtual networks across Azure regions (global peering).

Virtual network peering provides a low-latency, high-bandwidth connection. There is no gateway in the path, so there are no extra hops, ensuring low latency connections. It's useful in scenarios such as cross-region data replication and database failover. Because traffic is private and remains on the Microsoft backbone, also consider virtual network peering if you have strict data policies and want to avoid sending any traffic over the internet.

**Subnet peering**. Subnet peering enables users to connect specific subnets between virtual networks instead of peering entire virtual networks. Subnet peering gives users fine-grained control over which subnets to link. Users can use it for scenarios like overlapping virtual network ranges, IPv6-only connections, and selective gateway exposure.

**VPN gateways**. A VPN gateway is a specific type of virtual network gateway that is used to send traffic between an Azure virtual network and a cross-premises location over the public internet. You can also use a VPN gateway to send traffic between Azure virtual networks. Each virtual network can have at most one VPN gateway. You should enable [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

VPN gateways provide a limited bandwidth connection and are useful in scenarios where you need encryption but can tolerate bandwidth restrictions. In these scenarios, customers are also not as latency-sensitive. 

## Gateway transit

Virtual network peering and VPN gateways can also coexist via gateway transit

Gateway transit enables you to use a peered virtual network's gateway for connecting to on-premises, instead of creating a new gateway for connectivity. As you increase your workloads in Azure, you need to scale your networks across regions and virtual networks to keep up with the growth. Gateway transit allows you to share an ExpressRoute or VPN gateway with all peered virtual networks and lets you manage the connectivity in one place. Sharing enables cost-savings and reduction in management overhead.

With gateway transit enabled on virtual network peering, you can create a transit virtual network that contains your VPN gateway, Network Virtual Appliance, and other shared services. As your organization grows with new applications or business units and as you spin up new virtual networks, you can connect to your transit virtual network using peering. This prevents adding complexity to your network and reduces management overhead of managing multiple gateways and other appliances.

## Configuring connections

Virtual network peering and VPN gateways both support the following connection types:

- Virtual networks in different regions.
- Virtual networks in different Microsoft Entra tenants.
- Virtual networks in different Azure subscriptions.

For more information, see the following articles:

- [Create a virtual network peering: Azure Resource Manager, different subscriptions](/azure/virtual-network/create-peering-different-subscriptions)
- [Configure a virtual network-to-virtual network VPN gateway connection by using the Azure portal](/azure/vpn-gateway/vpn-gateway-howto-vnet-vnet-resource-manager-portal)
- [Connect virtual networks from different deployment models by using the portal](/azure/vpn-gateway/vpn-gateway-connect-different-deployment-models-portal)
- [VPN Gateway FAQ](/azure/vpn-gateway/vpn-gateway-vpn-faq)

## Comparison of virtual network peering and VPN gateway

| Item | Virtual network peering | VPN gateway |
|------|--------------|--------------|
| Limits |  Up to 500 virtual network peerings per virtual network (see [Networking limits](/azure/azure-subscription-service-limits#networking-limits)). To increase further, the Azure Virtual Network Manager connectivity configuration feature allows users to create up to 1,000 virtual networks peerings per virtual network. | One VPN gateway per virtual network. The maximum number of tunnels per gateway depends on the [gateway SKU](/azure/vpn-gateway/vpn-gateway-about-vpngateways#gwsku). |
| Pricing model | [Ingress/Egress](https://azure.microsoft.com/pricing/details/virtual-network/) | [Hourly + Egress](https://azure.microsoft.com/pricing/details/vpn-gateway/) |
| Encryption | [Azure Virtual Network Encryption](/azure/virtual-network/virtual-network-encryption-overview) can be leveraged. | Custom IPsec/IKE policy can be applied to new or existing connections. See [About cryptographic requirements and Azure VPN gateways](/azure/vpn-gateway/vpn-gateway-about-compliance-crypto). |
| Bandwidth limitations | No bandwidth limitations. | Varies based on SKU. See [Gateway SKUs by tunnel, connection, and throughput](/azure/vpn-gateway/vpn-gateway-about-vpngateways#benchmark). |
| Private? | Yes. Routed through Microsoft backbone and private. No public internet involved. | Public IP involved, but routed through Microsoft backbone if [Microsoft global network](/azure/virtual-network/ip-services/routing-preference-overview) is enabled. |
| Transitive relationship | Peering connections are nontransitive. Transitive networking can be achieved using NVAs or gateways in the hub virtual network. See [Hub-spoke network topology](../../networking/architecture/hub-spoke.yml) for an example. | If virtual networks are connected via VPN gateways and BGP is enabled in the virtual network connections, transitivity works. |
| Initial setup time | Fast | ~30 minutes |
| Typical scenarios | Data replication, database failover, and other scenarios needing frequent backups of large data. | Encryption-specific scenarios that are not latency sensitive and do not need high throughout. |

The virtual network peering and VPN gateway technologies form the foundation for more complex networking architectures. One of the most common enterprise patterns is hub-and-spoke networking, where multiple spoke virtual networks need to communicate with each other. The choice between virtual network peering and VPN gateways significantly affects how you implement inter-spoke communication.

## Spoke-to-spoke communication patterns

*Inter-spoke networking* refers to direct communication between workloads that run in different spoke virtual networks within hub-and-spoke architectures. This method eliminates the need to route traffic through the central hub.

Inter-spoke networking provides the following benefits:

- **Performance optimization:** Lower latency and higher bandwidth by eliminating extra network hops through hub appliances and avoiding centralized bottlenecks

- **Cost reduction:** Fewer virtual network peering hops required and reduced infrastructure costs from not over-provisioning hub appliances for all inter-spoke traffic

- **Architectural flexibility:** Enables efficient multi-tier applications and microservices communication across separate virtual networks while maintaining selective hub control

- **Operational simplicity:** Reduced network complexity with fewer components to monitor and troubleshoot, which leads to faster problem resolution

- **Business continuity enhancement:** Reliable, high-bandwidth connections for critical database replication and disaster recovery across regions

Hub-and-spoke architectures provide excellent centralized control and security, but they can become performance bottlenecks and cost centers when *all* workload-to-workload traffic must traverse the hub. Inter-spoke networking provides architectural flexibility to optimize for performance and cost where it makes business sense, while maintaining centralized control where security and governance require it.

There are two main patterns that connect spoke virtual networks to each other:

- **Spokes directly connect to each other.** Virtual network peerings or VPN tunnels are created between the spoke virtual networks to provide direct connectivity without traversing the hub virtual network.

- **Spokes communicate over a network appliance.** Each spoke virtual network peers with either Virtual WAN or a hub virtual network. An appliance routes traffic between spokes. You can manage the appliance yourself, or Microsoft can manage it for you. This management model works similarly to how management is handled in Virtual WAN deployments.

### Pattern 1: Spokes directly connect to each other

Direct connections between spokes typically provide better throughput, latency, and scalability than connections that go through a network virtual appliance (NVA) across a hub. Sending traffic through NVAs can add latency to the traffic if the NVAs are in a different availability zone and at least two virtual network peerings need to be crossed when traffic is sent over the hub. The options for connecting two spoke virtual networks to each other directly include virtual network peering, Azure Virtual Network Manager, and VPN tunnels.

- **[Virtual network peering][virtual-network-peering]:** As discussed earlier, virtual network peering provides low-latency, high-bandwidth connections with cost advantages for direct spoke connectivity.
  
  Other scenarios include cross-tenant connectivity. However, you might need to inspect traffic between spoke virtual networks. This process might require you to send traffic through centralized networking devices in the hub virtual network.

- **[Subnet peering][subnet-peering]:** Similar to virtual network peering, but subnet peering allows more granularity by specifying which subnets at both sides of the peering are allowed to communicate with each other.

- **[Virtual Network Manager][avnm-hns]:** In addition to the advantages of virtual network peering, Virtual Network Manager provides a management service that lets you manage virtual network environments and create connectivity at scale. You can use Virtual Network Manager to build three types of topologies across subscriptions. These topologies work with both existing and new virtual networks.

  - Hub and spoke with spokes that aren't connected to each other.

  - Hub and spoke with spokes that are directly connected to each other, without a hop in the middle.

  - A meshed group of virtual networks that are interconnected.

    :::image type="complex" border="false" source="images/virtual-network-manager-connectivity-options.svg" alt-text="Network diagram that shows the topologies that Virtual Network Manager supports." lightbox="images/virtual-network-manager-connectivity-options.svg":::
       These topologies include hub and spoke, mesh, and hub and spoke with direct connectivity between spokes.
    :::image-end:::

    *Download a [Visio file](https://arch-center.azureedge.net/spoke-to-spoke-source-diagrams.vsdx) of this architecture.*
  
    When you create a hub-and-spoke topology with Virtual Network Manager in which spokes are connected to each other, direct connectivity between spoke virtual networks in the same [network group][avnm-network-group] are automatically created bi-directionally. By using Virtual Network Manager, you can statically or dynamically make spoke virtual networks members of a specific network group, which automatically creates virtual network connectivity.
  
    You can create multiple network groups to isolate clusters of spoke virtual networks from direct connectivity. Each network group provides the same region and multiregion support for spoke-to-spoke connectivity. Be sure to stay below the maximum [limits for Virtual Network Manager][avnm-limits].

- **VPN tunnels connecting virtual networks:** You can configure VPN services to directly connect spoke virtual networks by using Microsoft [VPN gateways][virtual-network-to-virtual-network] or non-Microsoft VPN NVAs. The advantage of this option is that spoke virtual networks connect across commercial and sovereign clouds within the same cloud provider or connectivity cross-cloud providers. If there are software-defined wide area network NVAs in each spoke virtual network, you can use the non-Microsoft provider's control plane and feature set to manage virtual network connectivity.

   This option can also help you meet compliance requirements for the encryption of traffic across virtual networks in a single Azure datacenter that [Media Access Control Security encryption][macsec] doesn't provide. But this option has its own set of challenges because of the bandwidth limits of Internet Protocol Security tunnels (1.25 Gbps per tunnel) and the design constraints of having virtual network gateways in both hub and spoke virtual networks. If the spoke virtual network has a virtual network gateway, it can't be connected to Virtual WAN or use a hub's virtual network gateway to connect to on-premises networks.

#### Pattern 1a: Single region

Regardless of the technology that you use to connect spoke virtual networks to each other, the network topologies look like the following image for a single region.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings.svg" alt-text="Network diagram that shows a single-region hub-and-spoke design. It has spokes that are connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings.svg":::
   The image shows four virtual network sections. Three black lines connect the hub virtual network to three separate virtual networks. A green triangle connects the three spoke networks.
:::image-end:::

#### Pattern 1b: Multiple regions

Designs that connect all spoke virtual networks to each other can extend across multiple regions. In this topology, Virtual Network Manager becomes even more important. It helps reduce the administrative overhead required to maintain a large number of connections.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-peerings-2-hubs-full-mesh.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design with spokes in the same region connected via virtual network peerings." lightbox="images/spoke-to-spoke-through-peerings-2-hubs-full-mesh.svg":::
   The image shows the East US hub, the West US hub, and six spoke virtual networks. A black line connects the East US hub and the West US hub. Three black lines point from the East US hub to three separate spokes. Two black lines point from the West US hub to two separate spokes. Five green lines point from each spoke and interconnect the six spokes.
:::image-end:::

> [!NOTE]
> When you connect spoke virtual networks directly, either in one region or in multiple regions, consider doing so for spoke virtual networks in the same environment. For example, connect one spoke development virtual network with another spoke development virtual network. But avoid connecting a spoke development virtual network with a spoke production virtual network.

When you directly connect spoke virtual networks to each other in a fully meshed topology, you need to consider the potentially high number of virtual network peerings required. The following diagram illustrates this problem. In this scenario, we strongly recommend Virtual Network Manager so that you can automatically create virtual network connections.

:::image type="complex" border="false" source="images/peering-number-chart.svg" alt-text="Diagram that shows how the required number of peerings grows with the number of spokes." lightbox="images/peering-number-chart.svg":::
   The image shows a line chart that represents the peerings required for full mesh connectivity. The x axis shows the number of spoke virtual networks. The y axis shows the number of peerings. As the number of virtual networks increases, so do the number of peerings.
:::image-end:::

### Pattern 2: Spokes communicate over a network appliance

Instead of connecting spoke virtual networks directly to each other, you can use network appliances to forward traffic between spokes. Network appliances provide other network services like deep packet inspection and traffic segmentation or monitoring. However, they can introduce latency and performance bottlenecks if they're not properly sized. These appliances are typically located in a hub virtual network that the spokes connect to. There are multiple options for using a network appliance to forward traffic between spokes:

- **Virtual WAN hub router:** Virtual WAN is fully managed by Microsoft. It contains a virtual router that attracts traffic from spokes and routes it to either another virtual network that's connected to Virtual WAN or to on-premises networks via ExpressRoute or site-to-site or point-to-site VPN tunnels. The Virtual WAN router scales up and down automatically, so you only need to make sure that the traffic volume between spokes stays within the [Virtual WAN limits][vwan-limits].

- **Azure Firewall:** [Azure Firewall][azfw] is a network appliance that Microsoft manages and can be deployed in hub virtual networks that you manage or in Virtual WAN hubs. It can forward IP address packets, and it can also inspect them and apply traffic segmentation rules that are defined in policies. It provides autoscaling up to the [Azure Firewall limits][azfw-limits] so that it doesn't become a bottleneck. Azure Firewall provides built-in multiregion capabilities only when used with Virtual WAN. Without Virtual WAN, you need to implement user-defined routes to achieve cross-regional spoke-to-spoke communication.

- **Non-Microsoft NVAs:** If you prefer to use an NVA from a Microsoft partner to perform routing and network segmentation, you can deploy NVAs in either a hub-and-spoke or a Virtual WAN topology. For more information, see [Deploy highly available NVAs][nva-ha] or [NVAs in a Virtual WAN hub][vwan-nva]. You need to be sure that the NVA supports the bandwidth that the inter-spoke communications generate.

- **Azure VPN Gateway:** You can use a VPN gateway as a next hop type of user-defined route. However, we don't recommend that you use VPN virtual network gateways to route spoke-to-spoke traffic. These devices are designed for encrypting traffic to on-premises sites or VPN users. For example, there's no guaranteed bandwidth between spokes that a VPN gateway can route.

- **ExpressRoute:** In specific configurations, an ExpressRoute gateway can advertise routes that attract spoke-to-spoke communication, sending traffic to the Microsoft Edge router, where it's routed to the destination spoke. This pattern is sometimes known as *ExpressRoute hairpinning* and needs to be [explicitly enabled][expressroute-hairpinning]. We strongly discourage this scenario because it introduces latency by sending traffic to the Microsoft backbone edge and back. It also creates a single point of failure and a large blast radius. And it puts extra pressure on the ExpressRoute infrastructure, specifically the gateway and physical routers, which can result in packet drops.

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

- Tune the route tables in each spoke to send private address traffic, such as traffic that uses RFC 1918 prefixes like `10.0.0.0/8`, `172.16.0.0/12`, or `192.168.0.0/16`, to an NVA. This appliance handles Azure-to-Azure and Azure-to-on-premises traffic, often known as *east-west traffic*.

- Tune internet traffic, which has a `0.0.0.0/0` route, to a second NVA. This NVA is responsible for Azure-to-internet traffic, also known as *north-south traffic*.

The following diagram shows this configuration.

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-north-south.svg" alt-text="Network diagram that shows a basic hub-and-spoke design. It has spokes connected via two centralized NVAs for internet and private traffic." lightbox="images/spoke-to-spoke-via-nva-north-south.svg":::
   The image shows a North-South hub and an East-West hub. Three dotted lines point from the North-South hub to three separate spokes. Three black lines point from the East-West hub to three separate spokes.
:::image-end:::

> [!NOTE]
> The Azure firewall requires that only one Azure Firewall resource be deployed in a virtual network. Therefore, a separate hub virtual network is required for extra Azure Firewall resources. For NVA scenarios, you can use a single hub virtual network for extra NVA deployments.

#### Pattern 2b: Multiple regions

You can extend the same configuration to multiple regions. For example, in a self-managed hub-and-spoke design that uses Azure Firewall, you should apply extra route tables to the Azure Firewall subnets in each hub for the spokes in the remote region. This configuration ensures that inter-region traffic can be forwarded between the Azure firewalls in each hub virtual network. Inter-regional traffic between spoke virtual networks then traverses both Azure firewalls. For more information, see [Use Azure Firewall to route a multi-hub and spoke topology][azfw-multi-hub-and-spoke].

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-2-hubs.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design via NVAs in the hubs." lightbox="images/spoke-to-spoke-via-nva-2-hubs.svg":::
   The image shows an East US hub and a West US hub. A black line connects the two hubs. Three solid black lines connect the East US hub to three separate spokes. Three solid black lines connect the West US hub to three separate spokes.
:::image-end:::

The design variation that has separate Azure firewalls or NVAs for north-south and east-west traffic is also possible in a multiregion hub-and-spoke topology.

:::image type="complex" border="false" source="images/spoke-to-spoke-via-nva-2-hubs-north-south.svg" alt-text="Network diagram that shows a two-region hub-and-spoke design. It has separate east-west and north-south firewalls in each region." lightbox="images/spoke-to-spoke-via-nva-2-hubs-north-south.svg":::
   The image shows the following hubs: a North-South East US hub, an East-West East US hub, an East-West West US hub, and a North-South West US hub. Three dotted lines connect the North-South East US hub to three separate spokes. Three solid lines connect the East-West East US hub to the same spokes. Three solid lines connect the East-West West US hub to three different separate spokes. Three dotted lines connect the North-South West US hub to these spokes.
:::image-end:::

Virtual WAN creates a similar topology and takes over the routing complexity. It manages routing in the hubs, which Microsoft manages, and in the spokes, where routes can be injected without manual route table edits. The network administrator only needs to connect the spoke virtual networks to a Virtual WAN hub and doesn't need to worry about forwarding traffic between regions.

:::image type="complex" border="false" source="images/spoke-to-spoke-through-virtual-wan.svg" alt-text="Network diagram that shows a Virtual WAN design with spokes connected via Virtual WAN." lightbox="images/spoke-to-spoke-through-virtual-wan.svg":::
   The image shows Virtual WAN with East US and West US virtual hubs. Two groups of three lines connect Virtual WAN to three separate spokes. There are six spokes in total.
:::image-end:::

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Jay Li](https://www.linkedin.com/in/jie-jay-li/) | Senior Product Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Plan virtual networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)
- [Choose a solution to connect an on-premises network to Azure](./index.yml)

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
[nva-ha]: network-virtual-appliance-high-availability.md
[secure-network-azure]: /training/modules/secure-network-connectivity-azure
[subnet-peering]: /azure/virtual-network/how-to-configure-subnet-peering
[traditional-azure-topology]: /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
[udr-route-selection]: /azure/virtual-network/virtual-networks-udr-overview#how-azure-selects-a-route
[virtual-network-peering]: /azure/virtual-network/virtual-network-peering-overview
[virtual-network-to-virtual-network]: /azure/vpn-gateway/vpn-gateway-howto-vnet-vnet-resource-manager-portal
[vwan-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-virtual-wan-limits
[vwan-nva]: /azure/virtual-wan/about-nva-hub
[vwan]: /azure/virtual-wan/virtual-wan-about
