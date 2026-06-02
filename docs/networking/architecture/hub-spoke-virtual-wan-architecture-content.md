This hub-spoke architecture provides an alternate solution to the self-managed [hub-spoke network topology architecture](../architecture/hub-spoke.yml) and the [secure hybrid network architecture](../../reference-architectures/dmz/secure-vnet-dmz.yml).

The *hub* is a virtual network in Azure that serves as a central point of connectivity to your on-premises network, and to provide and secure connectivity between the spokes and to/from the public internet. The *spokes* are virtual networks that are peered with the hub through Virtual WAN connections and help isolate workloads. Traffic flows between the on-premises datacenters and the hub through an Azure ExpressRoute or Azure VPN Gateway connection. This approach replaces self-managed hubs with [Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan/), which is a Microsoft-managed service.

This architecture includes the benefits of standard hub-spoke network topology and introduces new benefits:

- **Less operational overhead** by replacing existing hubs with a fully managed Virtual WAN service, since Microsoft manages the peerings between all the hubs and the network configuration inside of the hubs.

- **Improved security** through centrally managed secure hubs that use Azure Firewall and Virtual WAN to minimize security risks related to misconfiguration, making sure that all traffic flows are inspected by a firewall.

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

- **Spoke virtual networks:** One or more virtual networks that serve as spokes in the hub-spoke topology. You can use spokes to isolate workloads in their own virtual networks and manage them separately. Each workload might include multiple tiers across multiple subnets, with Azure load balancers that distribute traffic within or between those tiers.

- **Virtual network peering:** You can use virtual network peering to provide a nontransitive, low-latency connection between virtual networks. Peered networks exchange traffic over the Azure backbone without requiring a router. In a hub-spoke network topology, you use virtual network peerings to connect the hub to each spoke and between the hubs, along with user-defined routes (UDRs) to handle cross-hub traffic. In Virtual WAN Microsoft manages both the peerings between the hubs and the routing required for cross-hub traffic flows.

### Workflow

The following workflow describes how traffic flows through the hub-spoke Virtual WAN architecture:

1. **Branch or user traffic originates on-premises:** A user or system from a branch site or on-premises network initiates a connection. This traffic is routed through the SD-WAN or VPN device configured to connect to Virtual WAN.

1. **Traffic enters Azure via a VPN or ExpressRoute gateway:** The encrypted traffic reaches the Virtual WAN hub through a VPN or ExpressRoute gateway deployed in the region. Virtual WAN manages and optimizes routing to the appropriate destination.

1. **The Virtual WAN hub manages routing:** The hub evaluates routing policies, including custom routes or policies that Azure Firewall or Network Virtual Appliances (NVAs) enforce. The hub determines the next hop for the traffic. If the destination is in another region or hub, global transit capabilities handle the routing.

1. **Inter-hub connectivity ensures global reachability:** If the destination is in another region, the traffic is routed via the Microsoft global backbone through inter-hub connectivity between Virtual WAN hubs.

1. **Traffic reaches the spoke virtual network:** If the destination is a workload or application in a spoke virtual network, the Virtual WAN hub forwards the traffic based on defined peering and routing configurations.

1. **Security inspection (optional):** When you configure a private routing policy through [routing intent](/azure/virtual-wan/how-to-routing-policies), Azure Firewall, an integrated next-generation firewall (NGFW) NVA, or a SaaS security solution deployed in the hub inspects traffic before it reaches its final destination. This method enforces centralized security and policy compliance.

1. **The application response follows the reverse path:** The application or resource in the spoke virtual network responds, and the return traffic flows back through the same Virtual WAN hub and gateway. It follows the defined route and security policies.

1. **Internet egress traffic is inspected and routed:** If the destination is external, such as the internet, Virtual WAN forwards the traffic to the security solution that you set as the next hop for the routing policy that handles internet traffic.

   In **direct access** mode, an internet routing policy steers `0.0.0.0/0` and the security solution forwards inspected traffic to the internet from the hub. In [**forced tunnel** mode](/azure/virtual-wan/about-internet-routing), the private routing policy handles `0.0.0.0/0` and the security solution forwards inspected traffic to an on-premises egress point.

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) provides isolated and secure network environments for workloads. Virtual networks connect to the Virtual WAN hub via virtual network connections. These connections allow workloads in the spokes to communicate securely with each other, on-premises networks, or the internet via centralized services.

- [Virtual WAN](/azure/virtual-wan/virtual-wan-about) is a networking service. It provides a unified global transit network architecture that connects virtual networks, branches, and remote users. In this architecture, it serves as the central control plane and data plane. Virtual WAN manages and routes traffic across hubs, spokes, and external networks, which enables global connectivity through a common framework.

- [Virtual WAN site-to-site VPN gateway](/azure/virtual-wan/virtual-wan-site-to-site-portal) is a Virtual WAN-specific resource that provides encrypted IPsec/IKE connectivity from on-premises VPN devices to the hub. In this architecture, it securely connects branch offices or datacenters to Azure through Virtual WAN.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) provides private, high-throughput connectivity between on-premises infrastructure and Azure. When integrated with Virtual WAN, it provides a reliable and fast alternative to VPN connections for mission-critical workloads.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall)  is a cloud-native, stateful network security service that provides threat protection for network traffic. In this architecture, it runs in the Virtual WAN hub to inspect and filter both outbound internet traffic and private traffic between virtual networks or from on-premises environments.

### Alternatives

To implement a hub-spoke architecture, you can use a self-managed hub infrastructure or a Microsoft-managed hub infrastructure. For both methods, spokes connect to the hub via virtual network peering.

## Scenario details

This article describes a hub-spoke network pattern where Azure Virtual WAN provides the Microsoft-managed hub infrastructure. The Virtual WAN hub serves as the central point of connectivity to many spoke virtual networks and on-premises networks. Spoke virtual networks connect to the hub and isolate workloads. You can also support cross-premises scenarios by connecting branch offices and datacenters through VPN or ExpressRoute gateways that are managed within the hub.

Unlike a self-managed hub-spoke topology, Virtual WAN handles hub infrastructure, routing, and peering as a managed service. This approach reduces operational overhead, provides built-in transitive connectivity among spokes, and supports global transit across multiple regions and hubs.

### Potential use cases

You can use this architecture for the following use cases:

- Centralized hybrid connectivity that connects multiple workload virtual networks to on-premises datacenters through ExpressRoute or VPN.

- Centralized inspection and policy enforcement for traffic between workloads, between workloads and on-premises, and to and from the internet.

- Branch and remote-user connectivity at scale, aggregating site-to-site VPN, point-to-site user VPN, and SD-WAN connections from many sites.

- Supports Azure landing zones where workload teams own their own subscriptions and the platform team provides connectivity as a shared service.

This architecture largely serves the [same scenarios](./hub-spoke.yml#potential-use-cases) as a self-managed hub-spoke topology, but differs in resource management, flexibility, and cost.

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

### Resource organization

The hub and each spoke can reside in different resource groups and, ideally, in different subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can belong to the same Microsoft Entra ID tenant or different ones. This setup enables decentralized management of each workload while sharing services maintained in the hub.

A virtual network can't span subscriptions. When you follow the Azure landing zone [subscription democratization](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization) design principle and place each workload, or each workload-environment pair, in its own subscription, each workload's network is necessarily its own virtual network. The hub-spoke topology is how those workload networks share hybrid connectivity, transit, and centralized inspection.

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

A Virtual WAN hub requires an address range of at least `/24`. Azure reserves the space for the hub router and for any gateways or other components you add to the hub. Gateways are separate resources that you create explicitly; see [Gateway connectivity](#gateway-connectivity) for the gateways this architecture uses.

Virtual WAN doesn't support IPv6 in the hub or its gateways, and a spoke virtual network with an IPv6 address range loses IPv6 connectivity when you attach it to a hub. If your workloads, hybrid connectivity, or remote users require IPv6, choose a self-managed hub-spoke topology. See [Virtual WAN FAQ](/azure/virtual-wan/virtual-wan-faq#is-there-support-for-ipv6-in-virtual-wan).

### Secured virtual hub

You can create a virtual hub as a secured virtual hub or convert an existing hub to a secured one anytime after creation. For more information, see [Secure your virtual hub by using Firewall Manager](/azure/firewall-manager/secure-cloud-network).

The Azure Firewall in a secured virtual hub is shared by every spoke virtual network and branch site connected to that hub. Plan for how network address translation affects workload design:

- **Outbound flows from any spoke or branch leave the hub sourced from one of the firewall's public IP addresses.** This is source network address translation (SNAT). Azure Firewall SNATs each outbound flow to one of the attached public IP addresses, and the selection isn't deterministic, so partner allowlists must cover the entire set of IP addresses attached to the secured hub firewall. Use a [public IP address prefix](/azure/virtual-network/ip-services/public-ip-address-prefix) to express that set as a contiguous range.

  The number of attached public IP addresses also sets the SNAT port budget for every connected workload; plan for the aggregate concurrent outbound connection rate across all spokes and branches because exhaustion affects every workload that egresses through the hub. Adding public IPs is the primary lever to increase SNAT capacity in a secured hub. [Azure NAT Gateway](/azure/nat-gateway/nat-overview), which scales SNAT for Azure Firewall in standard virtual networks, [isn't supported in a Virtual WAN hub](/troubleshoot/azure/nat-gateway/troubleshoot-nat-and-azure-services#azure-firewall).

- **Workloads published through the firewall are reachable at the firewall's public IP address.** You publish a backend with a destination network address translation (DNAT) rule. Azure Firewall also SNATs DNAT-matched packets, so the backend observes the firewall instance's IP address as the source rather than the original client's IP address.

  If your application requires the client's IP address, terminate the client connection upstream in a reverse proxy such as Azure Application Gateway or Azure Front Door, forward the client's IP address in the `X-Forwarded-For` HTTP header, and follow [Preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation) so the backend continues to observe the client's host name.

#### Network virtual appliances in the hub

You can deploy specific third-party NVAs directly inside the Virtual WAN hub. Only the NVAs that Microsoft and the vendor have jointly qualified can run in the hub. Each qualified NVA falls into one of three role categories:

- **SD-WAN connectivity NVAs.** Terminate branch connectivity. These NVAs aren't eligible to be the next-hop resource for [routing intent](/azure/virtual-wan/how-to-routing-policies).

- **Next-generation firewall (NGFW) NVAs.** Inspect traffic. These NVAs are eligible to be the next-hop resource for routing intent.

- **Dual-role SD-WAN and NGFW NVAs.** Combine both roles in a single appliance.

A Virtual WAN hub hosts only one integrated NVA, and that one slot is shared across all three categories. To run both SD-WAN connectivity and NGFW inspection from a partner in the same hub, you must use a dual-role NVA; you can't deploy a separate SD-WAN NVA alongside a separate NGFW NVA.

For the authoritative list of partners, the vendor identifiers that routing intent accepts, and which category each vendor falls into, see [About NVAs in a Virtual WAN hub](/azure/virtual-wan/about-nva-hub). Examples of qualified vendors include Barracuda, Check Point, Cisco, and Fortinet.

Deploying NVAs in the hub eliminates the need for user-defined routes in spoke virtual networks and provides centralized traffic inspection with Azure-managed high availability and scaling.

#### Third-party SaaS security solutions

Virtual WAN hubs also support third-party SaaS networking and security solutions that are distinct from IaaS-based NVAs. For example, Palo Alto Networks Cloud NGFW can be deployed as a fully managed SaaS offering inside the hub, providing inline traffic inspection without managing appliance infrastructure. These SaaS solutions integrate with routing intent and are billed through Azure Marketplace. You can deploy at most one SaaS security solution per hub. For more information, see [Install Palo Alto Networks Cloud NGFW in a Virtual WAN hub](/azure/virtual-wan/how-to-palo-alto-cloud-ngfw).

#### Combine security solutions in a single hub

Routing intent gives you two traffic-steering controls per hub: one private routing policy and one internet routing policy, each with a single next-hop resource. All east-west, branch-to-virtual-network, and inter-hub traffic moves together under the private policy, so you can't use routing intent to send datacenter-to-Azure traffic to one vendor's firewall and east-west traffic to another.

The following coexistence patterns are supported in a single hub:

- **Azure Firewall plus one integrated NGFW NVA.** Set one policy's next hop to Azure Firewall and the other to a partner NGFW NVA. For more information, see [Can I deploy an NVA into a Secure hub?](/azure/virtual-wan/about-nva-hub#nva-faq) in the NVA FAQ.

- **Azure Firewall plus one SaaS security solution.** Set one policy's next hop to Azure Firewall and the other to the SaaS security resource deployed in the hub.

Two third-party NVAs in the same hub aren't supported, whether they differ by vendor or by [role category](#network-virtual-appliances-in-the-hub). If you genuinely need per-traffic-type vendor separation beyond what the two routing policies allow, consider one of these alternatives:

- **Deploy multiple hubs**, each with its own next-hop choice for the workloads that connect to it. Inter-hub inspection requires routing intent on every hub.
- **Place the secondary NVA in a spoke virtual network** and selectively peer the virtual networks that need to use it. The [performance and security optimized Virtual WAN architecture](performance-security-optimized-vwan.yml) shows this pattern.

### Gateway connectivity

To create a gateway in a Virtual WAN hub, see [Create a site-to-site connection by using Azure Virtual WAN](/azure/virtual-wan/virtual-wan-site-to-site-portal) and [Create an ExpressRoute association to Virtual WAN](/azure/virtual-wan/virtual-wan-expressroute-portal).

For higher availability of hybrid connectivity, deploy a VPN gateway alongside the ExpressRoute gateway in the same hub and set the Border Gateway Protocol (BGP) path preference to favor ExpressRoute. The VPN connection then carries traffic only when the ExpressRoute circuit fails. For more information, see [Virtual WAN disaster recovery design](/azure/virtual-wan/disaster-recovery-design) and the reliability recommendations in [Architecture best practices for Azure Virtual WAN](/azure/well-architected/service-guides/azure-virtual-wan#reliability).

This architecture deploys gateways in the hub to provide the branch, remote-user, and on-premises connectivity shown in the diagrams. Gateways are a common addition to a Virtual WAN hub, not a requirement: a hub without any gateway still routes spoke-to-spoke traffic through the hub router.

### Virtual network peering

Virtual network peering creates a nontransitive relationship between two virtual networks. However, Virtual WAN allows spokes to connect with each other without requiring direct peering.

When you need to connect multiple spokes, you can quickly reach the limit for virtual network peerings for each virtual network. For more information, see [Networking limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits). Virtual WAN resolves this limitation by providing built-in connectivity between spokes. For more information, see [Global transit network architecture and Virtual WAN](/azure/virtual-wan/virtual-wan-global-transit-network-architecture).

#### Virtual network peering for a hub connection

In Virtual WAN, Microsoft manages virtual network peering. When you add a connection to a hub, Virtual WAN configures virtual network peering. As a result, all spokes have a transitive relationship and automatically reach the hub's gateways and connected branches through the hub's route tables, without per-connection peering settings such as gateway transit or remote gateways.

### Routing intents

Routing intent is a declarative routing feature that sends traffic through a security solution deployed in the Virtual WAN hub. A hub has at most two routing policies, and each policy has a single next-hop resource:

- **Private routing policy.** Steers VNet-to-VNet, branch-to-VNet (over ExpressRoute, site-to-site VPN, or point-to-site VPN), and inter-hub traffic to the configured next hop as a single class.

  By default, the policy matches the RFC1918 aggregates `10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16`. To inspect other private address ranges such as non-RFC1918 prefixes advertised by on-premises or delegated subnets used by services such as [Azure NetApp Files](/azure/azure-netapp-files/configure-virtual-wan), add them to the policy's additional prefixes.

- **Internet routing policy.** Steers `0.0.0.0/0` traffic to the configured next hop, which forwards inspected traffic directly to the internet from the hub. This pattern is called **direct access**.

Each policy accepts one of the following next-hop resources: Azure Firewall, an integrated NGFW NVA, or a SaaS security solution. The two policies can point to different resources in the same hub. For example, you can set the private policy next hop to Azure Firewall and the internet policy next hop to a SaaS security solution. For the current eligibility list, vendor identifiers, and configuration steps, see [How to configure Virtual WAN Hub routing intent and routing policies](/azure/virtual-wan/how-to-routing-policies). For guidance on combining different security products in the same hub, see [Combine security solutions in a single hub](#combine-security-solutions-in-a-single-hub).

To inspect internet-bound traffic in the hub and then send it to an on-premises egress point instead of directly to the internet, use **forced tunnel** mode. In this mode you don't configure an internet routing policy; instead, you configure a private routing policy and add `0.0.0.0/0` to the policy's additional prefixes. The private policy's next-hop security solution inspects `0.0.0.0/0` traffic and forwards it through a default route that Virtual WAN learns from on-premises, from an NVA (in the hub or in a spoke), or from a static route on a virtual network connection. Forced tunnel mode doesn't support DNAT and can introduce asymmetric routing in some topologies. For more information, see [Internet access patterns with routing intent](/azure/virtual-wan/about-internet-routing).

Internet ingress isn't a routing intent traffic class. To publish a workload to the internet, configure a DNAT rule on the hub firewall, or terminate the client connection upstream at Azure Application Gateway or Azure Front Door in a spoke virtual network. For more information, see the [Secured virtual hub](#secured-virtual-hub) section.

### Route maps

Route maps in Virtual WAN provide fine-grained control over advertised and received routes. Use route maps to filter, modify, or control Border Gateway Protocol (BGP) route propagation between Virtual WAN hubs and external networks, such as branches, partner networks, or SD-WAN connections. Route maps control which routes are advertised or accepted over a BGP connection.

You can attach route maps to connections, such as VPN sites, ExpressRoute circuits, or virtual network connections. Each route map consists of one or more rules. These rules include conditions such as match statements and actions such as permit, deny, or set. Azure evaluates rules in order, and the first match determines the outcome for that route. You can apply route maps in either the inbound or outbound direction.

Route maps support scalable and controlled hybrid connectivity and ensure compliance with routing policies and network segmentation. They help prevent routing loops or route leaks in large environments.

### Hub extensions

To support network-wide shared tools, like Domain Name System (DNS) resources, custom NVAs, and Azure Bastion, use the [virtual hub extension pattern](../../guide/networking/private-link-virtual-wan-dns-virtual-hub-extension-pattern.yml) to implement each service. Use this model to build and operate single-responsibility extensions that expose business-critical, shared services that you can't deploy directly in a virtual hub.

#### Spoke connectivity and shared services

Virtual WAN provides connectivity among spokes. But UDRs in the spoke traffic help isolate virtual networks. You can also host shared services on the same Virtual WAN as a spoke.

#### Private Link with Virtual WAN

Virtual WAN supports up to 4,000 private endpoints per hub, which enables secure connectivity to Azure PaaS services without exposing traffic to the public internet. Use Private Link to access services such as Azure Storage, Azure SQL Database, or custom services. The higher-scale private endpoint limits that are available for standard virtual networks don't apply to Virtual WAN hubs. For more information, see [Share a Private Link service across Virtual WAN](/azure/virtual-wan/howto-private-link).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Virtual WAN handles routing, which helps optimize network latency among spokes and ensure predictable performance. Virtual WAN also provides reliable connectivity among different Azure regions for workloads that span multiple regions. This setup improves end-to-end visibility of network flow within Azure.

- Long-lived TCP flows that traverse the shared Azure Firewall in the secured virtual hub drop on idle timeouts and instance recycling. Workloads that hold connections for hours, such as VPN tunnels, database sessions, and SSH or RDP sessions, need bi-directional TCP keep-alives and application-level retry. Scale-in and monthly platform maintenance also recycle Azure Firewall instances and drop sessions that outlast the drain period. For idle-timeout values, scale-in behavior, and prescaling guidance, see [Azure Firewall TCP session management](/azure/firewall/tcp-session-behavior).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

You can convert hubs in Virtual WAN to secure hubs by using Azure Firewall. UDRs remain effective for enforcing network isolation. ExpressRoute private peering doesn't encrypt traffic by default. To encrypt on-premises traffic that traverses ExpressRoute, configure [IPsec over ExpressRoute](/azure/virtual-wan/vpn-over-expressroute), which runs a site-to-site VPN tunnel through the ExpressRoute private peering.

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application design best practices, provides enhanced mitigation against distributed denial-of-service (DDoS) attacks. Azure DDoS Protection is available in two tiers: [DDoS Network Protection](/azure/ddos-protection/ddos-protection-sku-comparison), which covers entire virtual networks and includes DDoS Rapid Response and cost protection, and DDoS IP Protection, a per-IP model suited for smaller environments. For hub-spoke architectures with many public endpoints, DDoS Network Protection is recommended. Enable DDoS Protection on perimeter virtual networks.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Virtual WAN pricing page](https://azure.microsoft.com/pricing/details/virtual-wan/) to understand and estimate the most cost-effective solution for your network topology. Virtual WAN pricing involves several key cost factors:

1. **Deployment hours:** Charges for the deployment and use of Virtual WAN hubs.

1. **Scale unit:** Fees based on the bandwidth capacity in megabits per second (Mbps) or gigabits per second (Gbps) for scaling site-to-site or point-to-site VPN and ExpressRoute gateways.
1. **Connection unit:** Costs for each connection to VPN, ExpressRoute, or remote users.
1. **Data processed unit:** Charges per gigabyte (GB) for data processed through the hub.
1. **Routing infrastructure unit:** Costs for routing capabilities in the hub. Use the [Virtual WAN pricing page](https://azure.microsoft.com/pricing/details/virtual-wan/) and the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) for current and region-specific estimates.
1. **Azure Firewall with secured virtual hub:** Recommended but adds an extra cost per deployment unit and per data processed unit.
1. **Hub-to-hub data transfer:** Costs for transferring data between hubs. These costs are subject to inter-region (intra-continental or inter-continental) rates as detailed in [Azure bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth/).

For more information about pricing that aligns with common networking scenarios, see [About Virtual WAN pricing](/azure/virtual-wan/pricing-concepts#pricing).

To explore a starting-point cost for this two-hub architecture, open this [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/7b824244c8924d188049f8db757ee6ee). Adjust the values to match your expected traffic volumes, number of spokes, and gateway scale units.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Microsoft provides Virtual WAN as a managed service. From a technology perspective, it closely resembles a self-managed hub infrastructure. However, Virtual WAN simplifies the overall network architecture by providing a mesh network topology that enables transitive network connectivity among spokes.

You should monitor Virtual WAN by using Azure Monitor. Key hub-level metrics include **Routing Infrastructure Units usage (%)** for capacity planning and scale monitoring, and **Bits In** and **Bits Out** to track hub traffic volume. Set alert rules when utilization or traffic approaches thresholds to proactively manage hub scale. For more information, see [Azure Virtual WAN monitoring](/azure/virtual-wan/monitor-virtual-wan). You can also fully automate site-to-site configuration and connectivity between on-premises networks and Azure.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Virtual WAN helps reduce latency among spokes and across regions. Gateway throughput varies by gateway type and deployment scope. For workloads that exceed single-gateway or single-hub limits, deploy additional hubs or gateways per region to scale aggregate capacity. For current limits, see [Virtual WAN limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#virtual-wan-limits).

Virtual WAN provides full-mesh connectivity among spokes while allowing traffic restriction based on specific needs. This architecture enables large-scale, site-to-site performance. You can also create a global transit network architecture by enabling any-to-any connectivity between globally distributed sets of cloud workloads.

Plan capacity for the shared hub firewall:

- Size Azure Firewall for the inspection profile you plan to run, not its advertised maximum throughput. Enabling both TLS inspection and IDPS in Deny mode can significantly reduce effective throughput compared with running without inspection. If a single hub's inspected throughput becomes the constraint, scale out across multiple hubs. For figures by feature combination, see [Azure Firewall performance](/azure/firewall/firewall-performance#performance-data).

- Network rule capacity is combinatorial, not a flat rule count. Azure Firewall has a limit on unique source-destination combinations across network rules. The sources, destinations, IP groups, FQDNs, protocols, and ports in each rule multiply against each other, so a few rules can consume a large share of the budget. An IP group counts as one unit regardless of size, so use [IP groups](/azure/firewall/ip-groups) to compact allowlists and [policy analytics](/azure/firewall/policy-analytics) to track usage against the documented [Azure Firewall limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits).

## Advanced scenarios

Your architecture might differ from the simple hub-spoke architecture described in this article. The following list describes guidance for advanced scenarios:

- To extend your network across multiple regions, deploy additional Virtual WAN hubs. For more information, see [Global transit network architecture and Virtual WAN](/azure/virtual-wan/virtual-wan-global-transit-network-architecture).

- To deploy third-party firewall or SD-WAN appliances directly in the hub, see [About NVAs in a Virtual WAN hub](/azure/virtual-wan/about-nva-hub).

- To integrate SaaS-based security solutions like Palo Alto Networks Cloud NGFW, see [Install Palo Alto Networks Cloud NGFW in a Virtual WAN hub](/azure/virtual-wan/how-to-palo-alto-cloud-ngfw).

- To control BGP route propagation and filtering across connections, see [About Virtual WAN hub route maps](/azure/virtual-wan/route-maps-about).

  To enforce centralized traffic inspection with routing intents, see [Configure routing intent and policies through Virtual WAN](/azure/virtual-wan/how-to-routing-policies).

- To use forced tunnel mode for on-premises internet egress, see [Securing internet access with routing intent](/azure/virtual-wan/about-internet-routing).

- To provide DNS resolution across spokes and on-premises, see [Private resolver architecture](/azure/dns/private-resolver-architecture) and the [virtual hub extension pattern](/azure/architecture/networking/guide/private-link-virtual-wan-dns-virtual-hub-extension-pattern).

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

## Related resources

- [Design a hybrid DNS solution by using Azure](../../hybrid/hybrid-dns-infra.yml)
- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Hub-spoke network topology in Azure](../architecture/hub-spoke.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.md)
