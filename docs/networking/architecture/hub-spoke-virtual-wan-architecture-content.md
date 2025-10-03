This hub-spoke architecture provides an alternate solution to the [hub-spoke network topology architecture](../architecture/hub-spoke.yml) and the [secure hybrid network architecture](../../reference-architectures/dmz/secure-vnet-dmz.yml).

The *hub* is a virtual network in Azure that serves as a central point of connectivity to your on-premises network. The *spokes* are virtual networks that peer with the hub and help isolate workloads. Traffic flows between the on-premises datacenters and the hub through an Azure ExpressRoute or Azure VPN Gateway connection. This approach replaces traditional hubs with
[Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan/), which is a fully managed service.

This architecture includes the benefits of standard hub-spoke network topology and introduces new benefits:

- **Less operational overhead** by replacing existing hubs with a fully managed Virtual WAN service

- **Cost savings** by using a managed service and removing the need for a network virtual appliance (NVA)

- **Improved security** through centrally managed secure hubs that use Azure Firewall and Virtual WAN to minimize security risks related to misconfiguration

- **Separation of concerns** between central IT such as security and infrastructure operations and workloads such as development operations.

## Architecture

:::image type="complex" border="false" source="_images/hub-spoke-virtual-wan-architecture-1.svg" alt-text="Diagram that shows a hub-spoke reference architecture." lightbox="_images/hub-spoke-virtual-wan-architecture-1.svg":::
The diagram has two hub virtual networks that connect. Hub virtual network 1 connects to a shared services virtual network and another virtual network. It also has other connections, including a VPN point-to-site user, two VPN branches, and an ExpressRoute circuit. Hub virtual network 2 has two attached virtual networks. The text under this setup reads Routing configuration of virtual network connections except shared services virtual network. The associated route table is RT_VNets. The propagated route table is default. Hub virtual network 2 connects to two virtual networks. It also has other connections, including a VPN point-to-site user, two VPN branches, and an ExpressRoute circuit. The text under this setup reads Routing configuration of VPN, ExpressRoute, point-to-site connections, and shared services virtual network. The associated route table is default. The propagated route tables are default and RT_VNets. DDoS Protection is in the top right corner of the diagram.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-virtual-wan-architecture-1.vsdx) of this architecture.* 

The architecture uses the following networking components:

- **On-premises network:** A private local area network (LAN) that operates within an organization.

- **VPN device:** A device or service that provides external connectivity to the on-premises network.

- **VPN virtual network gateway or ExpressRoute gateway:** A virtual network gateway that connects the virtual network to the VPN device or [ExpressRoute](/azure/expressroute/expressroute-introduction) circuit that you use for on-premises connectivity.

- **Virtual WAN hub:** The [Virtual WAN](/azure/virtual-wan/virtual-wan-about) serves as the hub in the hub-spoke topology. The hub is the central point of connectivity to your on-premises network. It hosts services for workloads in the spoke virtual networks.

- **Secured virtual hub:** This Virtual WAN hub includes security and routing policies that Azure Firewall Manager configures. A secured virtual hub includes built-in routing, so you don't need to configure user-defined routes (UDRs).

- **Gateway subnet:** This subnet contains the virtual network gateways.

- **Spoke virtual networks:** One or more virtual networks that serve as spokes in the hub-spoke topology. You can use spokes to isolate workloads in their own virtual networks and manage them separately. Each workload might include multiple tiers across multiple subnets, with Azure load balancers that distribute traffic within or between those tiers.

- **Virtual network peering:** You can use virtual network peering to provide a nontransitive, low-latency connection between virtual networks. Peered networks exchange traffic over the Azure backbone without requiring a router. In a hub-spoke network topology, use virtual network peering to connect the hub to each spoke. Virtual WAN enables transitivity among hubs, which isn't possible by using only peering.

### Workflow

The following workflow describes how traffic flows through the hub-spoke Virtual WAN architecture:

1. **Branch or user traffic originates on-premises:** A user or system from a branch site or on-premises network initiates a connection. This traffic is routed through the SD-WAN or VPN device configured to connect to Virtual WAN.

1. **Traffic enters Azure via a VPN or ExpressRoute gateway:** The encrypted traffic reaches the Virtual WAN hub through a VPN or ExpressRoute gateway deployed in the region. Virtual WAN manages and optimizes routing to the appropriate destination.
1. **The Virtual WAN hub manages routing:** The hub evaluates routing policies, including custom routes or policies that Azure Firewall or NVAs enforce. The hub determines the next hop for the traffic. If the destination is in another region or hub, global transit capabilities handle the routing.
1. **Inter-hub connectivity ensures global reachability:** If the destination is in another region, the traffic is routed via the Microsoft global backbone through inter-hub connectivity between Virtual WAN hubs.
1. **Traffic reaches the spoke virtual network:** If the destination is a workload or application in a spoke virtual network, the Virtual WAN hub forwards the traffic based on defined peering and routing configurations.
1. **Security inspection (optional):** Azure Firewall or a non-Microsoft NVA deployed in the hub can inspect traffic before it reaches its final destination. This method enforces centralized security and policy compliance.
1. **The application response follows the reverse path:** The application or resource in the spoke virtual network responds, and the return traffic flows back through the same Virtual WAN hub and gateway. It follows the defined route and security policies.
1. **Azure Firewall filters or routes internet-bound traffic:** If the destination is external, such as the internet, Azure Firewall or a non-Microsoft security solution can inspect, filter, or route the traffic. Then the traffic exits through a secured egress point.

### Components

* [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) provides isolated and secure network environments for workloads. Virtual networks connect to the Virtual WAN hub via virtual network connections. These connections allow workloads in the spokes to communicate securely with each other, on-premises networks, or the internet via centralized services.

* [Virtual WAN](/azure/virtual-wan/virtual-wan-about) is a networking service. It provides a unified global transit network architecture that connects virtual networks, branches, and remote users. In this architecture, it serves as the central control plane and data plane. Virtual WAN manages and routes traffic across hubs, spokes, and external networks, which enables global connectivity through a common framework.
* [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) enables encrypted communication between on-premises networks and Azure by using Internet Protocol Security (IPsec) tunnels. In this architecture, VPN Gateway operates within the hub to securely connect branch offices or datacenters to the Azure network via Virtual WAN.
* [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) provides private, high-throughput connectivity between on-premises infrastructure and Azure. When integrated with Virtual WAN, it provides a reliable and fast alternative to VPN connections for mission-critical workloads.
* [Azure Firewall](/azure/well-architected/service-guides/azure-firewall)  is a cloud-native, stateful network security service that provides threat protection for network traffic. In this architecture, it runs in the Virtual WAN hub to inspect and filter both outbound internet traffic and private traffic between virtual networks or from on-premises environments.

### Alternatives

To implement a hub-spoke architecture, you can use a customer-managed hub infrastructure or a Microsoft-managed hub infrastructure. For both methods, spokes connect to the hub via virtual network peering.

### Potential use cases

You can use this architecture for the following use cases:

- Connectivity among workloads that requires central control and access to shared services

- An enterprise that requires central control over security aspects, such as a firewall, and segregated management for the workloads in each spoke

## Advantages

:::image type="complex" border="false" source="_images/hub-spoke-virtual-wan-architecture-2.svg" alt-text="Diagram that shows the advantages of a hub-spoke reference architecture." lightbox="_images/hub-spoke-virtual-wan-architecture-2.svg":::
The diagram shows Virtual WAN in the center. It has three connected regions. Each region contains multiple virtual networks. Arrows illustrate various types of connectivity, including branch-to-Azure, branch-to-branch, network-to-network, and user VPN connections. The diagram highlights the use of both VPN and ExpressRoute for hybrid connectivity. DDoS Protection is in the top left corner.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-virtual-wan-architecture-2.vsdx) of this architecture.* 

The previous diagram shows advantages that this architecture provides:

- A full meshed hub among Azure virtual networks
- Branch-to-Azure connectivity
- Branch-to-branch connectivity
- Mixed use of VPN and ExpressRoute
- Mixed use of user VPN to the site
- Virtual network-to-virtual network connectivity

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups

The hub and each spoke can reside in different resource groups and, ideally, in different subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can belong to the same Microsoft Entra ID tenant or different ones. This setup enables decentralized management of each workload while sharing services maintained in the hub.

### Virtual WAN

Create a Standard Virtual WAN if your solution requires any of the following capabilities:

- Scaling for higher throughputs

- Private connectivity by using an ExpressRoute Premium circuit in a Global Reach location

- ExpressRoute VPN interconnect

- Integrated monitoring through [Azure Monitor](/azure/virtual-wan/azure-monitor-insights), including metrics and resource health

Standard Virtual WAN uses full-mesh connectivity by default. It supports any-to-any connectivity, including site-to-site VPN, virtual network, ExpressRoute, and point-to-site endpoints, within a single hub and across hubs.

Basic Virtual WAN supports site-to-site VPN connectivity, branch-to-branch connectivity, and branch-to-virtual network connectivity within a single hub.

### Virtual WAN hub

A virtual hub is a Microsoft-managed virtual network that serves as the core of your network in a region. The hub contains various service endpoints to enable connectivity. You can have multiple hubs in each Azure region. For more information, see [Virtual WAN FAQ](/azure/virtual-wan/virtual-wan-faq#is-it-possible-to-create-multiple-virtual-wan-hubs-in-the-same-region). 

When you use the Azure portal to create a hub, the portal creates a virtual hub virtual network and a virtual hub VPN gateway. A Virtual WAN hub requires an address range of at least `/24`. Azure uses this IP address space to reserve a subnet for the gateway and other components.

### Secured virtual hub

You can create a virtual hub as a secured virtual hub or convert an existing hub to a secured one anytime after creation. For more information, see [Secure your virtual hub by using Firewall Manager](/azure/firewall-manager/secure-cloud-network).

### Gateway subnet

For more information about setting up a gateway, see [Hybrid network by using a VPN gateway](/azure/expressroute/expressroute-howto-coexist-resource-manager).

For higher availability, you can use ExpressRoute with a VPN for failover. For more information, see 
[Connect an on-premises network to Azure by using ExpressRoute with VPN failover](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml).

A hub-spoke topology requires a gateway, even if you don't require connectivity to your on-premises network.

### Virtual network peering

Virtual network peering creates a nontransitive relationship between two virtual networks. However, Virtual WAN allows spokes to connect with each other without requiring direct peering.

When you need to connect multiple spokes, you can quickly reach the limit for virtual network peerings for each virtual network. For more information, see [Networking limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits). Virtual WAN resolves this limitation by providing built-in connectivity between spokes. For more information, see [Global transit network architecture and Virtual WAN](/azure/virtual-wan/virtual-wan-global-transit-network-architecture).

You can also configure spokes to use the hub gateway to communicate with remote networks. To allow gateway traffic to flow from the spoke to the hub and connect to remote networks, do the following steps:

1. Configure the peering connection in the hub to **allow gateway transit**.

1. Configure the peering connection in each spoke to **use remote gateways**.

1. Configure all peering connections to **allow forwarded traffic**.

For more information, see [Virtual network connectivity options and spoke-to-spoke communication](../../reference-architectures/hybrid-networking/virtual-network-peering.yml).

#### Virtual network peering for a hub connection

In Virtual WAN, Microsoft manages virtual network peering. When you add a connection to a hub, Virtual WAN configures virtual network peering. As a result, all spokes have a transitive relationship.

### Routing intents

Routing intents in Virtual WAN are predefined routing configurations that simplify how traffic flows between spokes, on-premises, and the internet through the hub. You can use routing intents to enforce consistent and centralized traffic flows for specific traffic categories, including the following categories:

- **Internet:** Traffic destined for the internet
- **Private traffic:** Traffic between virtual networks or from on-premises to virtual networks

When you enable routing intents on the Virtual WAN hub, Azure automatically configures the appropriate routes. Traffic that matches a given intent flows to a specified next hop, such as the following components:

- Azure Firewall for traffic inspection and filtering
- NVAs for custom traffic processing
  
Virtual WAN supports the following routing intents:

- **Internet:** Routes internet-bound traffic through a designated security appliance, such as Azure Firewall
- **Private traffic:** Routes network-to-network or hybrid traffic through the security path, such as an NVA or firewall

### Route maps

Route maps in Virtual WAN provide fine-grained control over advertised and received routes. Use route maps to filter, modify, or control Border Gateway Protocol (BGP) route propagation between Virtual WAN hubs and external networks, such as branches, partner networks, or SD-WAN connections. Route maps control which routes are advertised or accepted over a BGP connection.

You can attach route maps to connections, such as VPN sites, ExpressRoute circuits, or virtual network connections. Each route map consists of one or more rules. These rules include conditions such as match statements and actions such as permit, deny, or set. Azure evaluates rules in order, and the first match determines the outcome for that route. You can apply route maps in either the inbound or outbound direction.

Route maps support scalable and controlled hybrid connectivity and ensure compliance with routing policies and network segmentation. They help prevent routing loops or route leaks in large environments.

### Hub extensions

To support network-wide shared tools, like Domain Name System (DNS) resources, custom NVAs, and Azure Bastion, use the [virtual hub extension pattern](../../guide/networking/private-link-virtual-wan-dns-virtual-hub-extension-pattern.yml) to implement each service. Use this model to build and operate single-responsibility extensions that expose business-critical, shared services that you can't deploy directly in a virtual hub.

#### Spoke connectivity and shared services

Virtual WAN provides connectivity among spokes. But UDRs in the spoke traffic help isolate virtual networks. You can also host shared services on the same Virtual WAN as a spoke.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Virtual WAN handles routing, which helps optimize network latency among spokes and ensure predictable performance. Virtual WAN also provides reliable connectivity among different Azure regions for workloads that span multiple regions. This setup improves end-to-end visibility of network flow within Azure.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

You can convert hubs in Virtual WAN to secure hubs by using Azure Firewall. UDRs remain effective for enforcing network isolation. Virtual WAN also encrypts traffic between on-premises networks and Azure virtual networks through an ExpressRoute connection.

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application design best practices, provides enhanced mitigation against distributed denial-of-service (DDoS) attacks. Enable [DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on perimeter virtual networks.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Virtual WAN pricing page](https://azure.microsoft.com/pricing/details/virtual-wan/) to understand and estimate the most cost-effective solution for your network topology. Virtual WAN pricing involves several key cost factors:

1. **Deployment hours:** Charges for the deployment and use of Virtual WAN hubs.

1. **Scale unit:** Fees based on the bandwidth capacity in megabits per second (Mbps) or gigabits per second (Gbps) for scaling site-to-site or point-to-site VPN and ExpressRoute gateways.
1. **Connection unit:** Costs for each connection to VPN, ExpressRoute, or remote users.
1. **Data processed unit:** Charges per gigabyte (GB) for data processed through the hub.
1. **Routing infrastructure unit:** Costs for routing capabilities in the hub.
1. **Azure Firewall with secured virtual hub:** Recommended but adds an extra cost per deployment unit and per data processed unit.
1. **Hub-to-hub data transfer:** Costs for transferring data between hubs. These costs are subject to inter-region (intra-continental or inter-continental) rates as detailed in [Azure bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth/).

For more information about pricing that aligns with common networking scenarios, see [About Virtual WAN pricing](/azure/virtual-wan/pricing-concepts#pricing).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Microsoft provides Virtual WAN as a managed service. From a technology perspective, it closely resembles a customer-managed hub infrastructure. However, Virtual WAN simplifies the overall network architecture by providing a mesh network topology that enables transitive network connectivity among spokes.

You can monitor Virtual WAN by using Azure Monitor. You can also fully automate site-to-site configuration and connectivity between on-premises networks and Azure.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Virtual WAN helps reduce latency among spokes and across regions. It supports scaling up to 20 Gbps of aggregate throughput.

Virtual WAN provides full-mesh connectivity among spokes while allowing traffic restriction based on specific needs. This architecture enables large-scale, site-to-site performance. You can also create a global transit network architecture by enabling any-to-any connectivity between globally distributed sets of cloud workloads.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author: 

- [Yunus Emre Alpozen](https://www.linkedin.com/in/yemre/) | Program Architect Cross-Workload
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Strengthen your security posture by using Azure](https://azure.microsoft.com/overview/security)
- [Virtual Network](https://azure.microsoft.com/services/virtual-network)
- [ExpressRoute](https://azure.microsoft.com/services/expressroute)
- [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway)
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall)
- [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/)
- [ExpressRoute overview](/azure/expressroute/expressroute-introduction)
- [Extend an on-premises network by using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)

## Related resources

- [Design a hybrid DNS solution by using Azure](../../hybrid/hybrid-dns-infra.yml)
- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Hub-spoke network topology in Azure](../architecture/hub-spoke.yml)
- [Connect an on-premises network to Azure by using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml)
