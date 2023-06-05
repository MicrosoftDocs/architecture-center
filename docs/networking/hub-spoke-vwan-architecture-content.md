This hub-spoke architecture provides an alternate solution to the
reference architectures [hub-spoke network topology in Azure](../reference-architectures/hybrid-networking/hub-spoke.yml) and [implement a secure hybrid network](../reference-architectures/dmz/secure-vnet-dmz.yml?tabs=portal).

The *hub* is a virtual network in Azure that acts as a central point of connectivity to your on-premises network. The *spokes* are virtual networks that peer with the hub and can be used to isolate workloads. Traffic flows between the on-premises data center(s) and the hub through an ExpressRoute or VPN gateway connection. The main differentiator of this approach is the use of
[Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan/) (VWAN) to replace hubs as a managed service.

This architecture includes the benefits of standard hub-spoke network topology and introduces new benefits:

-   **Less operational overhead** by replacing existing hubs with a fully managed VWAN service.

-   **Cost savings** by using a managed service and removing the necessity of network virtual appliance.

-   **Improved security** by introducing centrally managed secured Hubs with Azure Firewall and VWAN to minimize security risks related to misconfiguration.

-   **Separation of concerns** between central IT (SecOps, InfraOps) and workloads (DevOps).

## Potential use cases

Typical uses for this architecture include cases in which:

-   Connectivity among workloads requires central control and access to shared services.

-   An enterprise requires central control over security aspects, such as a firewall, and requires segregated management for the workloads in each spoke.

## Architecture

![Hub-spoke reference architecture infographic](media/hub-spoke-vwan-architecture-001.png)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-vwan-architecture-001.vsdx) of this architecture.* 

The architecture consists of:

-   **On-premises network**. A private local area network (LAN) running within an organization.

-   **VPN device**. A device or service that provides external connectivity to the on-premises network.

-   **VPN virtual network gateway or ExpressRoute gateway**. The virtual network gateway enables the virtual network to connect to the VPN device, or
    [ExpressRoute](/azure/expressroute/expressroute-introduction) circuit, used for connectivity with your on-premises network.

-   **Virtual WAN hub**. The [Virtual WAN](/azure/virtual-wan/virtual-wan-about) is used as the hub in the hub-spoke topology. The hub is the central point of connectivity to your on-premises network, and a place to host services that can be consumed by the different workloads hosted in the spoke virtual networks.

-   **Secured virtual hub**. A Virtual WAN hub with associated security and routing policies configured by Azure Firewall Manager. A secured virtual hub comes with a built-in routing so there is no need to configure user-defined routes.

-   **Gateway subnet**. The virtual network gateways are held in the same subnet.

-   **Spoke virtual networks**. One or more virtual networks that are used as spokes in the hub-spoke topology. Spokes can be used to isolate workloads in their own virtual networks and are managed separately from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers.

-   **Virtual network peering**. Two virtual networks can be connected using a VNet peering connection. Peering connections are nontransitive, low-latency connections between virtual networks. Once peered, virtual networks exchange traffic by using the Azure backbone, without the need for a router. In a hub-spoke network topology, you use virtual network peering to connect the hub to each spoke. Azure Virtual WAN enables transitivity among hubs, which is not possible solely using peering.

### Components

* [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network)
* [Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan)
* [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway)
* [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute)
* [Azure Firewall](https://azure.microsoft.com/services/azure-firewall)

### Alternatives

A hub-spoke architecture can be achieved two ways: a customer-managed hub infrastructure, or a Microsoft-managed hub infrastructure. In either case, spokes are connected to the hub using virtual network peering.

## Advantages

![Hub-spoke reference architecture infographic](media/hub-spoke-vwan-architecture-002.png)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-vwan-architecture-002.vsdx) of this architecture.* 

This diagram illustrates a few of the advantages that this architecture can provide:
* A full meshed hub among Azure Virtual Networks
* Branch to Azure connectivity
* Branch to Branch connectivity
* Mixed use of VPN and Express Route
* Mixed use of user VPN to the site
* VNET to VNET connectivity

## Recommendations

The following recommendations apply to most scenarios. Follow them, unless you have a specific requirement that overrides them.

### Resource groups

The hub and each spoke can be implemented in different resource groups, and, even better, in different subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can be associated to the same or a different Azure Active Directory tenant. This allows for a decentralized management of each workload, while sharing services maintained in the hub.

### Virtual WAN

Create a Standard Virtual WAN if you have a requirement for any of the following:

-   Scaling for higher throughputs

-   Private Connectivity (requires Premium Circuit in Global Reach location)

-   ExpressRoute VPN Interconnect

-   Integrated monitoring with [Azure Monitor](/azure/virtual-wan/azure-monitor-insights) (Metrics and Resource Health)

Standard Virtual WANs are by default connected in a full mesh. Standard Virtual WAN supports any-to-any connectivity (Site-to-Site VPN, VNet, ExpressRoute, Point-to-site endpoints) in a single hub as well as across hubs. Basic virtual WAN supports only Site-to-Site VPN connectivity, branch-to-branch connectivity, and branch-to-VNet connectivity in a **single hub**.

### Virtual WAN Hub

A virtual hub is a Microsoft-managed virtual network. The hub contains various service endpoints to enable connectivity. The hub is the core of your network in a region. There can be multiple hubs per Azure region. For more information, see [Virtual WAN FAQ](/azure/virtual-wan/virtual-wan-faq#is-it-possible-to-create-multiple-virtual-wan-hubs-in-the-same-region). 

When you create a hub using the Azure portal, it creates a virtual hub VNet and a virtual hub VPN gateway. A Virtual WAN Hub requires an address range minimum of /24. This IP address space will be used for reserving a subnet for gateway and other components.

### Secured virtual hub

A virtual hub can be created as a secured virtual hub or converted to a secure one anytime after creation. For additional information, see [Secure your virtual hub using Azure Firewall Manager](/azure/firewall-manager/secure-cloud-network).

### GatewaySubnet

For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

-   [Hybrid network using ExpressRoute](../reference-architectures/hybrid-networking/expressroute.yml)

-   [Hybrid network using a VPN Gateway](/azure/expressroute/expressroute-howto-coexist-resource-manager)

For greater availability, you can use ExpressRoute plus a VPN for failover. See
[Connect an on-premises network to Azure using ExpressRoute with VPN failover](../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml).

A hub-spoke topology cannot be used without a gateway, even if you don't need connectivity with your on-premises network.

### Virtual network peering

Virtual network peering is a nontransitive relationship between two virtual networks. However, Azure Virtual WAN allows spokes to connect with each other without having a dedicated peering among them.

However, if you have several spokes that need to connect with each other, you will run out of possible peering connections very quickly due to the limitation on the number of virtual network peerings per virtual network. (For more information, see [Networking limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits).) In this scenario, Azure VWAN will solve this problem with its out-of-box functionality. For additional information, see [Global transit network architecture and Virtual WAN](/azure/virtual-wan/virtual-wan-global-transit-network-architecture).

You can also configure spokes to use the hub gateway to communicate with remote networks. To allow gateway traffic to flow from spoke to hub, and connect to remote networks, you must:

-   Configure the peering connection in the hub to **allow gateway transit**.

-   Configure the peering connection in each spoke to **use remote gateways**.

-   Configure all peering connections to **allow forwarded traffic**.

For additional information, see [Choose between virtual network peering and VPN gateways](../reference-architectures/hybrid-networking/vnet-peering.yml)*.*

### Hub extensions

To support network-wide shared services like DNS resources, custom NVAs, Azure Bastion, and others, implement each service following the [virtual hub extension pattern](../guide/networking/private-link-virtual-wan-dns-virtual-hub-extension-pattern.yml). Following this model, you can build and operate single-responsibility extensions to individually expose these business-critical, shared services that you're otherwise unable to deploy directly in a virtual hub.

## Considerations

### Operations

Azure VWAN is a managed service provided by Microsoft. From a technology standpoint, it is not completely different from a customer-managed hub infrastructure. Azure Virtual WAN simplifies overall network architecture by offering a mesh network topology with transitive network connectivity among spokes. Monitoring of Azure VWAN can be achieved using Azure Monitor. Site-to-site configuration and connectivity between on-premises networks and Azure can be fully automated.

### Reliability

Azure Virtual WAN handles routing, which helps to optimize network latency among spokes as well as assure predictability of latency. Azure Virtual WAN also provides reliable connectivity among different Azure regions for the workloads spanning multiple regions. With this setup, end-to-end flow within Azure becomes more visible.

### Performance

With the help of Azure Virtual WAN, lower latency among spokes and across regions can be achieved. Azure Virtual WAN enables you to scale up to 20Gbps aggregate throughput.

### Scalability

Azure Virtual WAN provides a full mesh connectivity among spokes by preserving the ability to restrict traffic based on needs. With this architecture it is possible to have large-scale site-to-site performance. Moreover, you can create a global transit network architecture by enabling any-to-any connectivity between globally distributed sets of cloud workloads.

### Security

Hubs in Azure VWAN can be converted to secure HUBs by leveraging Azure Firewall. User-defined routes (UDRs) can still be leveraged in the same way to achieve network isolation. Azure VWAN enables encryption of traffic between the on-premises networks and Azure virtual networks over ExpressRoute.

[Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection Standard](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

### Spoke connectivity and shared services

Connectivity among spokes is already achieved using Azure Virtual WAN. However, using UDRs in the spoke traffic is useful to isolate virtual networks. Any shared service can also be hosted on the same Virtual WAN as a spoke.

### Virtual network peering - Hub connection

Virtual network peering is a nontransitive relationship between two virtual networks. While using Azure Virtual WAN, virtual network peering is managed by Microsoft. Each connection added to a hub will also configure virtual network peering. With the help Virtual WAN, all spokes will have a transitive relationship.

### Cost optimization

A customer-managed hub infrastructure introduces management cost to underlying Azure resources. To achieve a transitive connectivity with a predictable latency, you must have a Network Virtual Appliance (NVA) or Azure Firewall deployed in each hub. Using Azure Firewall with either choice will lower the cost compared to an NVA. Azure Firewall costs are the same for both options. There is an extra cost for Azure Virtual WAN; however, it is much less costly than managing your own hub infrastructure.

For more information, see [Virtual WAN pricing](https://azure.microsoft.com/pricing/details/virtual-wan).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author: 

 - [Yunus Emre Alpozen](https://www.linkedin.com/in/yemre/) | Program Architect Cross-Workload
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more:

-   [Hub-spoke network topology in Azure](../reference-architectures/hybrid-networking/hub-spoke.yml)

-   [Design a hybrid Domain Name System solution with Azure](../hybrid/hybrid-dns-infra.yml)

-   [Implement a secure hybrid network](../reference-architectures/dmz/secure-vnet-dmz.yml)

-   [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)

-   [Connect an on-premises network to Azure using ExpressRoute](../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)

-   [Firewall and Application Gateway for virtual networks](../example-scenario/gateway/firewall-application-gateway.yml)

-   [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)

-   [Secure and govern workloads with network level segmentation](../reference-architectures/hybrid-networking/network-level-segmentation.yml)

## Related resources

-   [Strengthen your security posture with Azure](https://azure.microsoft.com/overview/security)

-   [Virtual Network](https://azure.microsoft.com/services/virtual-network)

-   [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute)

-   [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway)

-   [Azure Firewall](https://azure.microsoft.com/services/azure-firewall)
