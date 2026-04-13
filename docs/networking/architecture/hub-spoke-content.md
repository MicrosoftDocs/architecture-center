This reference architecture implements a hub-spoke network pattern with customer-managed hub infrastructure components. The hub-spoke network pattern, also known as *hub and spoke*, is the network topology that the Cloud Adoption Framework for Azure recommends. See, [Define an Azure network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology) to understand why this topology is considered a best practice for many organizations.

For a Microsoft-managed hub infrastructure solution, see [Hub-spoke network topology with Azure Virtual WAN](./hub-spoke-virtual-wan-architecture.yml).

## Architecture

:::image type="complex" border="false" source="./_images/hub-spoke-network-topology-architecture.svg" alt-text="Diagram that shows the hub-spoke virtual network topology architecture." lightbox="./_images/hub-spoke-network-topology-architecture.svg":::
   Diagram that shows a hub-spoke network layout in Azure. A large outer frame labeled Azure Virtual Network Manager contains a central hub virtual network and four spoke virtual networks around it. On the left, outside the hub, a cross-premises network contains two virtual machines and a gateway icon. In the middle, the hub virtual network contains three services: Azure Bastion at the top, Azure Firewall in the center, and Azure VPN Gateway or Azure ExpressRoute at the bottom. Azure Monitor appears to the right of the hub, connected to the hub services by dashed lines labeled Diagnostics. Two production spoke virtual networks appear on the right, one above the other. Each production spoke contains a resource subnet with three virtual machines. Dashed lines labeled Forced Tunnel run from both production spokes toward the hub firewall area. At the bottom, there are two nonproduction spoke virtual networks, each with a resource subnet and three virtual machines. Dotted arrows between the lower spokes indicate that they can be peered or directly connected. Other dotted arrows show spoke virtual networks connecting or peering through the hub. Across the top, a dotted bidirectional arrow labeled virtual network peering connects the hub to the upper production spoke.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-architecture.vsdx) of this architecture.*

### Hub-spoke concepts

Hub-spoke network topologies typically include many of the following architectural concepts:

- **Hub virtual network:** The hub virtual network hosts shared Azure services. Workloads hosted in the spoke virtual networks can use these services. The hub virtual network is the central point of connectivity for cross-premises networks. The hub contains your primary point of egress and provides a way to connect one spoke to another for cross-virtual network traffic.

   A hub is a regional resource. If your workloads reside in multiple regions, place one hub in each region. The hub provides the following features and options:

  - **Cross-premises gateway:** The ability to connect and integrate different network environments. This gateway is usually a VPN or an Azure ExpressRoute circuit.
  
  - **Egress control:** The management and regulation of outbound traffic that originates in the peered spoke virtual networks.

  - **Ingress control:** The optional management and regulation of inbound traffic to endpoints that exist in peered spoke virtual networks.

  - **Remote access:** The way individual workloads in spoke networks are accessed from network locations outside of the spoke's own network. This access might target the workload's data or control plane.
  
  - **Remote spoke access for virtual machines (VMs):** A cross-organization remote connectivity solution for Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to VMs distributed throughout spoke networks.

  - **Routing:** The management of traffic between the hub and the connected spokes. Routing supports secure and efficient communication.

- **Spoke virtual networks:** Spoke virtual networks isolate and manage workloads separately in each spoke. Each workload can include multiple tiers, with multiple subnets connected through Azure load balancers. Spokes can exist in different subscriptions and represent different environments, such as production and nonproduction. One workload can spread across multiple spokes.

   In most scenarios, you should peer each spoke to a single hub network in the same region.

   Spoke networks follow the rules for [default outbound access](/azure/virtual-network/ip-services/default-outbound-access). A core purpose of the hub-spoke network topology is to direct outbound internet traffic through the control mechanisms in the hub.

- **Virtual network cross-connectivity:** Virtual network connectivity facilitates communication between isolated virtual networks. A control mechanism enforces permissions and determines the permitted direction of communications between networks. A hub provides an option to support cross-network connections to flow through the centralized network.

- **DNS:** Hub-spoke solutions often provide a Domain Name System (DNS) solution that all peered spokes use, especially for cross-premises routing and private endpoint DNS records.

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks in Azure. Virtual Network provides secure communication between Azure resources, such as VMs, and cross-premises networks, the internet, and each other. In this architecture, virtual networks connect to the hub by using Virtual Network [peering connections](/azure/virtual-network/virtual-network-peering-overview), which are nontransitive, low-latency connections between virtual networks. Peered virtual networks can exchange traffic over the Azure backbone without a router. In a hub-spoke architecture, use direct peering between virtual networks only in special circumstances.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed service that provides secure and seamless RDP and SSH access to VMs without exposing their public IP addresses. In this architecture, Azure Bastion is used as a managed offering to support direct VM access across connected spokes.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a managed cloud-based network security service that protects Virtual Network resources. This stateful firewall service has built-in high availability and unrestricted cloud scalability to help you create, enforce, and log application and network connectivity policies across subscriptions and virtual networks. In this architecture, Azure Firewall has multiple potential roles. The firewall is the primary egress point for traffic from peered spoke virtual networks to the internet. The firewall can also inspect inbound traffic by using network intrusion detection and prevention system (IDPS) rules. The firewall can also function as a DNS proxy server to support fully qualified domain name (FQDN) traffic rules.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway that sends encrypted traffic between a virtual network on Azure and different networks over the public internet. You can also use VPN Gateway to send encrypted traffic between other virtual networks over the Microsoft network. In this architecture, VPN Gateway can connect spokes to the remote network. Spokes typically don't deploy their own VPN gateway. They use the centralized solution that the hub provides. To manage this connectivity, you must establish routing configuration.

- An [ExpressRoute gateway](/azure/expressroute/expressroute-about-virtual-network-gateways) exchanges IP routes and routes network traffic between your on-premises network and your Azure virtual network. In this architecture, ExpressRoute can serve as an alternative to VPN Gateway to connect spokes to a remote network. Spokes don't deploy their own ExpressRoute gateway. They use the centralized solution that the hub provides. To manage this connectivity, you must establish routing configuration.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) can collect, analyze, and act on telemetry data from cross-premises environments including Azure and on-premises. Azure Monitor helps you maximize the performance and availability of your applications and quickly identify problems. In this architecture, Azure Monitor is the log and metric sink for the hub resources and for network metrics. Azure Monitor can also function as a logging sink for resources in spoke networks. Each spoke workload determines its own logging configuration, and this architecture doesn't require spoke logging to Azure Monitor.

### Alternatives

This architecture involves the creation, configuration, and maintenance of `virtualNetworkPeerings`, `routeTables`, and `subnets`. [Azure Virtual Network Manager](/azure/virtual-network-manager/overview) is a management service that helps you group, configure, deploy, and manage virtual networks at scale across Azure subscriptions, regions, and Microsoft Entra directories.

With Virtual Network Manager, you can define [network groups](/azure/virtual-network-manager/concept-network-groups) to identify and logically segment your virtual networks. You can also use [connected groups](/azure/virtual-network-manager/concept-connectivity-configuration) to provide communication between groups of virtual networks as if they're connected manually. This approach adds a layer of abstraction so that you can describe the networking topology without changing its implementation.

We recommend that you evaluate whether you should use Virtual Network Manager to optimize your network management operations. To determine whether Virtual Network Manager provides net value for your network's size and complexity, compare the service cost with the time savings and operational benefits.

## Scenario details

This reference architecture implements a hub-spoke network pattern where the hub virtual network acts as a central point of connectivity to many spoke virtual networks. The spoke virtual networks connect with the hub and can isolate workloads. You can also support cross-premises scenarios by using the hub to connect to on-premises networks.

This architecture describes a network pattern that includes customer-managed hub infrastructure components. For a Microsoft-managed hub infrastructure solution, see [Hub-spoke network topology that uses Azure Virtual WAN](/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture).

The benefits of using a customer-managed hub-spoke configuration include:

- Cost savings
- Overcoming subscription limits
- Workload isolation
- Flexibility
  - More control over how network virtual appliances (NVAs) are deployed, such as number of NICs, number of instances, or the compute size
  - Use of NVAs that aren't supported by Virtual WAN

### Advanced scenarios

Your architecture might differ from the simple hub-spoke architecture described in this article. The following list describes guidance for advanced scenarios:

- To add more regions, [use Azure Firewall to route a multi-hub-spoke topology](/azure/firewall/firewall-multi-hub-spoke).

- To use advanced spoke-to-spoke patterns, use [Spoke-to-spoke networking](../../reference-architectures/hybrid-networking/virtual-network-peering.yml#spoke-to-spoke-communication-patterns).

- To replace Azure Firewall with a custom NVA, [deploy highly available NVAs](/azure/architecture/networking/guide/network-virtual-appliance-high-availability).

- To replace the virtual network gateway with a custom software-defined WAN (SD-WAN) NVA, see [SD-WAN integration with Azure hub-spoke network topologies](/azure/architecture/networking/guide/sdwan-integration-in-hub-and-spoke-network-topologies).

- To provide transitivity between your ExpressRoute and VPN or SDWAN, or to customize prefixes advertised over Border Gateway Protocol (BGP) on Azure virtual network gateways, see [Route Server support for ExpressRoute and Azure VPN](/azure/route-server/expressroute-vpn-support).
 
- To add private resolver or DNS servers, see [Private resolver architecture](/azure/dns/private-resolver-architecture).

### Potential use cases

Typical uses for a hub-spoke architecture include workloads that:

- Have several environments that require shared services. For example, a workload might have development, testing, and production environments. Shared services might include DNS IDs, Network Time Protocol (NTP), or Active Directory Domain Services (AD DS). Shared services are placed in the hub virtual network, and each environment deploys to a different spoke to maintain isolation.

- Don't require connectivity to each other, but require access to shared services.

- Require central control over security, like a perimeter network (also known as *DMZ*, *demilitarized zone*, and *screened subnet*) firewall in the hub and segregated workload management in each spoke.

- Require central control over connectivity, such as selective connectivity or isolation between spokes of specific environments or workloads.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups, subscriptions, and regions

This example solution uses a single Azure resource group. You can also implement the hub and each spoke in different resource groups and subscriptions.

When you peer virtual networks in different subscriptions, you can associate the subscriptions to the same or different Microsoft Entra tenants. This flexibility provides decentralized management of each workload and maintains shared services in the hub. For more information, see [Create a virtual network peering across different subscriptions and Microsoft Entra tenants](/azure/virtual-network/create-peering-different-subscriptions).

#### Azure landing zones

The [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/) is based on hub-spoke topology. In that architecture, a centralized platform team manages the hub's shared resources and network, while spokes share a co-ownership model with the platform team and the workload team that uses the spoke network. All hubs reside in a Connectivity subscription for centralized management. Spoke virtual networks exist across multiple individual workload subscriptions, also called *application landing zone subscriptions*.

### Virtual network subnets

The following recommendations explain how to configure subnets on the virtual network.

#### GatewaySubnet

The virtual network gateway requires this subnet. You can also use a hub-spoke topology without a gateway if you don't need cross-premises network connectivity.

Create a [gateway subnet with an IP address range of at least /26 or larger](/azure/expressroute/expressroute-about-virtual-network-gateways#gateway-subnet-size) named *GatewaySubnet*. The /26 address range provides sufficient scalability to avoid gateway size limitations and accommodate extra ExpressRoute circuits in the future. For more information about gateway setup, see [Configure ExpressRoute and site-to-site coexisting connections by using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager).

#### AzureFirewallSubnet

Create a subnet named *AzureFirewallSubnet* with an address range of at least `/26`. We recommend `/26` as the minimum size to cover future size limitations. This subnet doesn't support network security groups (NSGs).

Azure Firewall requires this subnet. If you use a partner NVA, follow its network requirements.

### Spoke network connectivity

Virtual network peering or connected groups are nontransitive relationships between virtual networks. If you need spoke virtual networks to connect to each other, add a peering connection between those spokes or place them in the same network group.

#### Spoke connections through Azure Firewall or an NVA

The number of virtual network peerings per virtual network is limited. If you have many spokes that need to connect with each other, you might not have enough peering connections. Connected groups also have limitations. For more information, see [Networking limits](/azure/azure-subscription-service-limits#networking-limits) and [Connected groups limits](/azure/virtual-network-manager/faq#what-are-the-service-limitations-of-azure-virtual-network-manager).

In this scenario, consider using user-defined routes (UDRs) to force spoke traffic to be sent to Azure Firewall or another NVA that acts as a router at the hub. This change allows the spokes to connect to each other. To support this configuration, implement Azure Firewall with forced tunnel configuration turned on. For more information, see [Azure Firewall forced tunneling](/azure/firewall/forced-tunneling).

The topology in this architectural design facilitates egress flows. While Azure Firewall is primarily for egress security, it can also be an ingress point. For more considerations about hub NVA ingress routing, see [Azure Firewall and Azure Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway).

#### Spoke connections to remote networks through a hub gateway

To configure spokes to communicate with remote networks through a hub gateway, you can use virtual network peerings or connected network groups. To use virtual network peerings, open the virtual network **Peering** setup and complete the following actions:

- Configure the peering connection in the hub to **Allow** gateway transit.
- Configure the peering connection in each spoke to **Use the remote virtual network's gateway**.
- Configure all peering connections to **Allow** forwarded traffic.

For more information, see [Create a virtual network peering](/azure/virtual-network/virtual-network-manage-peering#create-a-peering).

To use connected network groups:

1. In Virtual Network Manager, create a network group and add member virtual networks.
1. Create a hub-spoke connectivity configuration.
1. For the **Spoke network groups**, select **Hub as gateway**.

For more information, see [Create a hub-spoke topology by using Virtual Network Manager](/azure/virtual-network-manager/how-to-create-hub-and-spoke).

### Spoke network communications

Spoke virtual networks can communicate with each other in two main ways:

- Communication via an NVA, like a firewall and router. This method adds a hop between the two spokes.

- Communication by using virtual network peering or Virtual Network Manager direct connectivity between spokes. This approach doesn't add a hop between the two spokes and is recommended to minimize latency.

Azure Private Link can selectively expose individual resources to other virtual networks. For example, you can use Private Link to expose an internal load balancer to a different virtual network without the need to form or maintain peering or routing relationships.

For more information about spoke-to-spoke networking patterns, see [Virtual network connectivity options and spoke-to-spoke communication](../../reference-architectures/hybrid-networking/virtual-network-peering.yml).

#### Communication through an NVA

If you need connectivity between spokes, consider deploying Azure Firewall or another NVA in the hub. Then create routes to forward traffic from a spoke to the firewall or NVA, which can then route to the second spoke. In this scenario, you must configure the peering connections to accept forwarded traffic.

:::image type="complex" border="false" source="./_images/spoke-spoke-routing.svg" alt-text="Diagram that shows routing between spokes that uses Azure Firewall." lightbox="./_images/spoke-spoke-routing.svg":::
   Diagram that shows three large dashed boxes arranged in a row. A spoke virtual network is on the left, a hub virtual network is in the center, and another spoke virtual network is on the right. Inside each spoke virtual network is a dotted box labeled Resource subnet that contains three virtual machine icons. Inside the hub virtual network is a dotted box that contains an Azure Firewall icon. Between the left spoke and the hub, and between the hub and the right spoke, dotted double-headed arrows labeled Peering show the network connections. Dashed arrows near the bottom run horizontally from each spoke toward the hub and point inward to Azure Firewall, which indicates that traffic from both spokes is directed to the firewall in the center rather than flowing directly between the two spokes. The overall layout highlights the hub as the middle point through which communication between the two spoke networks is routed.
:::image-end:::

You can also use a VPN gateway to route traffic between spokes, although this choice affects latency and throughput. For more information, see [Configure VPN gateway transit for virtual network peering](/azure/vpn-gateway/vpn-gateway-peering-gateway-transit).

Evaluate the services that you share in the hub to ensure that the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider your firewall solution's bandwidth limits when you add multiple spokes. You can move some of these shared services to a second level of hubs.

#### Direct communication between spoke networks

To connect directly between spoke virtual networks without routing traffic through the hub virtual network, you can create peering connections between spokes or turn on direct connectivity for the network group. We recommend that you limit peering or direct connectivity to spoke virtual networks that are part of the same environment and workload.

When you use Virtual Network Manager, you can add spoke virtual networks to network groups manually or add networks automatically based on conditions that you define.

The following diagram illustrates how to use Virtual Network Manager for direct connectivity between spokes.

:::image type="complex" border="false" source="./_images/spoke-spoke-azure-virtual-network-manager.svg" alt-text="Diagram that shows using Virtual Network Manager for direct connectivity between spokes." lightbox="./_images/spoke-spoke-azure-virtual-network-manager.svg":::
   Diagram that shows a large rectangular frame labeled Azure Virtual Network Manager, with the label Network group across the top. Inside the frame are three dashed boxes arranged left to right: a spoke virtual network, a hub virtual network, and another spoke virtual network. The two spoke boxes each contain a dotted inner box labeled Resource subnet with three virtual machine icons. The center hub box contains a dotted inner box with an Azure Firewall icon. Between the left spoke and the hub and between the hub and the right spoke, dotted double-headed arrows are labeled Connected virtual networks. Along the bottom, a dashed line labeled Directly connected virtual networks runs between the two spoke networks, with upward arrowheads into each spoke, which indicates a direct spoke-to-spoke path that sits below and separate from the hub connections.
:::image-end:::

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Use [availability zones](/azure/reliability/availability-zones-overview) for Azure services in the hub that support them.

We recommend that you use at least one hub per region and that you connect only spokes from the same region to those hubs. This configuration helps bulkhead regions avoid failures in one region's hub that could cause widespread network routing failures in unrelated regions.

For higher availability, you can use ExpressRoute and a VPN for failover. For more information, see [Connect an on-premises network to Azure by using ExpressRoute with VPN failover](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml) and [Design and architect ExpressRoute for resiliency](/azure/expressroute/design-architecture-for-resiliency).

Because of how Azure Firewall implements FQDN application rules, ensure that all resources that egress through the firewall use the same DNS provider as the firewall itself. Otherwise, Azure Firewall might block legitimate traffic because the firewall's IP resolution of the FQDN differs from the traffic originator's IP resolution of the same FQDN. You can include Azure Firewall proxy in the spoke DNS resolution to keep FQDNs in sync with the traffic originator and with Azure Firewall.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

To protect against DDoS attacks, turn on [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network. Any resource that has a public IP is susceptible to a DDoS attack. The following public IPs need to be protected even if your workloads aren't exposed publicly:

- Azure Firewall public IP addresses
- VPN gateway public IP addresses
- The ExpressRoute control plane public IP address

To minimize the risk of unauthorized access and to enforce strict security policies, always set explicit `deny` rules in NSGs.

Use the [Azure Firewall Premium](/azure/firewall/premium-portal) version to turn on Transport Layer Security (TLS) inspection, IDPS, and URL filtering.

#### Virtual Network Manager security

To ensure a baseline set of security rules, associate [security admin rules](/azure/virtual-network-manager/concept-security-admins) with virtual networks in network groups. Security admin rules take precedence over and are evaluated before NSG rules. Security admin rules support prioritization, service tags, and network layer (L3) and transport layer (L4) protocols.

Use Virtual Network Manager [deployments](/azure/virtual-network-manager/concept-deployments) to facilitate controlled rollout of critical changes to network group security rules.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Consider the following cost-related factors when you deploy and manage hub-spoke networks. For more information, see [Virtual network pricing](https://azure.microsoft.com/pricing/details/virtual-network).

#### Azure Firewall costs

This architecture deploys an Azure Firewall instance in the hub network. Using an Azure Firewall deployment as a shared solution consumed by multiple workloads can significantly save cloud costs compared to other NVAs. For more information, see [Azure Firewall versus NVAs](https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances).

To use your deployed resources effectively, choose the right Azure Firewall size. Decide what features you need and which tier best suits your current set of workloads. For more information about the available Azure Firewall SKUs, see [What is Azure Firewall?](/azure/firewall/overview)

#### Direct peering

To reduce or eliminate Azure Firewall processing costs, selectively use direct peering or other spoke-to-spoke communication that bypasses the hub. Savings can be significant for networks that have workloads with high-throughput, low-risk communication between spokes, such as database synchronization or large file copy operations.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Activate diagnostic settings for all services, such as Azure Bastion, Azure Firewall, and your cross-premises gateway. To reduce costs, turn off any settings that aren't related to your operations. Resources such as Azure Firewall can generate large log volumes and can lead to high monitoring costs.

Use [Connection monitor](/azure/network-watcher/connection-monitor-overview) for end-to-end monitoring to detect anomalies and to identify and troubleshoot network issues.

Use [Azure Network Watcher](/azure/network-watcher/network-watcher-overview) to monitor and troubleshoot network components, including using [traffic analytics](/azure/network-watcher/traffic-analytics) to show you the systems in your virtual networks that generate the most traffic. You can use traffic analytics to identify potential bottlenecks.

If you use ExpressRoute, use [Azure Traffic Collector](/azure/expressroute/traffic-collector) to analyze flow logs for the network flows sent over your ExpressRoute circuits. Traffic Collector provides visibility into traffic that flows over Microsoft enterprise edge routers.

Use FQDN-based rules in Azure Firewall for non-HTTP(S) protocols or for when you configure SQL Server. Using FQDNs reduces the management burden compared to individual IP address management.

[Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing) based on your peering requirements. Ensure that the address space doesn't overlap across cross-premises locations and Azure locations.

#### Automation with Virtual Network Manager

To centrally manage connectivity and security controls, use [Virtual Network Manager](/azure/virtual-network-manager/overview) to create new hub-spoke virtual network topologies or onboard existing topologies. Use Virtual Network Manager to prepare your hub-spoke network topologies for large-scale future growth across multiple subscriptions, management groups, and regions.

Example Virtual Network Manager use-case scenarios include:

- Democratization of spoke virtual network management to groups such as business units or application teams. Democratization can result in large numbers of virtual network-to-virtual network connectivity and network security rules requirements.

- Standardization of multiple replica architectures in multiple Azure regions to ensure a global footprint for applications.

To ensure uniform connectivity and network security rules, you can use [network groups](/azure/virtual-network-manager/concept-network-groups) to group virtual networks in any subscription, management group, or region under the same Microsoft Entra tenant. You can automatically or manually onboard virtual networks to network groups through dynamic or static membership assignments.

Define virtual networks discoverability in Virtual Network Manager by using [scopes](/azure/virtual-network-manager/concept-network-manager-scope). Scopes make network manager instances flexible so that you can distribute management responsibilities across virtual network groups.
 

To connect spoke virtual networks in the same network group, use Virtual Network Manager to implement virtual network peering or [direct connectivity](/azure/virtual-network-manager/concept-connectivity-configuration#enable-direct-connectivity). Use the [global mesh](/azure/virtual-network-manager/concept-connectivity-configuration#global-mesh) option to extend mesh direct connectivity to spoke networks in different regions. The following diagram shows global mesh connectivity between regions.

:::image type="complex" border="false" source="./_images/hub-spoke.svg" alt-text="Diagram that shows spoke global mesh direct connectivity over regions." lightbox="./_images/hub-spoke.svg":::
   Diagram that shows two large dashed rectangles side by side, labeled Azure region 1 on the left and Azure region 2 on the right. Each region contains a central box labeled Hub virtual network, surrounded by several smaller dotted boxes that represent spoke networks. Short dashed lines come from each hub to its surrounding spokes, which form a star-like hub-spoke pattern in both regions. A single dashed line connects the hub in Azure region 1 to the hub in Azure region 2 across the gap between the two region rectangles. The two sides mirror each other visually: each hub sits near the center of its region, each has multiple spokes around it, and each spoke is linked inward to its local hub. The diagram emphasizes two separate regional hub-spoke layouts with one direct interregion connection between the two hubs.
:::image-end:::

You can associate virtual networks within a network group to a baseline set of security admin rules. Network group security admin rules prevent spoke virtual network owners from overwriting baseline security rules, but they can add their own security rules and NSGs. For an example of how to use security admin rules in hub-spoke topologies, see [Create a secured hub-spoke network](/azure/virtual-network-manager/tutorial-create-secured-hub-and-spoke).

To facilitate a controlled rollout of network groups, connectivity, and security rules, Virtual Network Manager configuration deployments help you safely release critical configuration changes to hub-spoke environments.

To simplify the process of creating and maintaining route configurations, you can use [automated management of UDRs in Virtual Network Manager](/azure/virtual-network-manager/concept-user-defined-route).

To centralize the management of IP addresses, you can use [IP address management (IPAM) in Virtual Network Manager](/azure/virtual-network-manager/concept-ip-address-management). IPAM prevents IP address space conflicts across on-premises and cloud virtual networks.

To get started with Virtual Network Manager, see [Create a hub-spoke topology by using Virtual Network Manager](/azure/virtual-network-manager/how-to-create-hub-and-spoke).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

For workloads that communicate from on-premises to VMs in an Azure virtual network that require low latency and high bandwidth, consider using [ExpressRoute FastPath](/azure/expressroute/about-fastpath). Improve performance by using FastPath to send traffic directly from on-premises to virtual machines (VMs) in your virtual network and to bypass the ExpressRoute virtual network gateway.

For spoke-to-spoke communications that require low-latency, you can set up spoke-to-spoke networking.

Choose a [gateway SKU](/azure/vpn-gateway/about-gateway-skus) that meets your requirements, such as the number of point-to-site or site-to-site connections, required packets-per-second, bandwidth requirements, or TCP flows.

For latency-sensitive flows, such as SAP or access to storage, you can bypass Azure Firewall or hub routing. To help you decide the best approach, you can [test the latency introduced by Azure Firewall](/azure/firewall/firewall-best-practices#testing-and-monitoring). You can use features such as [virtual network peering](/azure/virtual-network/virtual-network-peering-overview), which connects two or more networks, or you can use [Private Link](/azure/private-link/private-link-overview) to connect to a service over a private endpoint in your virtual network.

You can reduce your throughput by using Azure Firewall features such as IDPS. For more information, see [Azure Firewall performance](/azure/firewall/firewall-performance#performance-data).

## Deploy this scenario

This deployment includes one hub virtual network and two connected spokes and deploys an Azure Firewall instance and Azure Bastion host. Optionally, the deployment can include VMs in the first spoke network and a VPN gateway. To create network connections, you can choose between virtual network peering or Virtual Network Manager connected groups. Each method has several deployment options.

- [Hub-spoke with virtual network peering deployment](/samples/mspnp/samples/hub-and-spoke-deployment)
- [Hub-spoke with Virtual Network Manager connected groups deployment](/samples/mspnp/samples/hub-and-spoke-deployment-with-connected-groups/)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Jose Moreno](https://www.linkedin.com/in/erjosito/) | Solutions Engineer
- [Alejandra Palacios](https://www.linkedin.com/in/alejandrampalacios/) | Senior Customer Engineer
- [Adam Torkar](https://www.linkedin.com/in/adam-torkar-41652311/) | Senior Customer Experience Engineer

Other contributors:

- [Matthew Bratschun](https://www.linkedin.com/in/matthewbratschun/) | Customer Engineer
- [Jay Li](https://www.linkedin.com/in/jie-jay-li/) | Senior Product Manager
- [Telmo Sampaio](https://www.linkedin.com/in/telmo-sampaio-172200/) | Principal Service Engineering Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is a secured virtual hub?](/azure/firewall-manager/secured-virtual-hub)
- [Define an Azure network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology)

## Related resources

- [Azure Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.md)
- [Troubleshoot a hybrid VPN connection](../../reference-architectures/hybrid-networking/troubleshoot-vpn.yml)
- [Spoke-to-spoke networking](../../reference-architectures/hybrid-networking/virtual-network-peering.yml#spoke-to-spoke-communication-patterns)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../../reference-architectures/containers/aks/baseline-aks.yml)