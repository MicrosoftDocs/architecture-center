---
title: Connect an On-Premises Network to Azure by Using ExpressRoute
description: This architecture shows how to connect an on-premises network to an Azure virtual network by using Azure ExpressRoute.
author: cynthiatreger
ms.author: ctreger
ms.date: 07/21/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom:
    - arb-hybrid
---


# Connect an on-premises network to Azure by using ExpressRoute

This article describes a reference architecture for connecting an on-premises network to an Azure virtual network by using Azure ExpressRoute over private peering. It's written for network architects and engineers who design hybrid connectivity.

You'll learn how the ExpressRoute circuit, gateway, and connection fit together, where each component is deployed, and how on-premises traffic reaches resources in an Azure virtual network. The article covers private peering only. Microsoft peering, which provides connectivity to Microsoft 365 and Azure public services over public IP addresses, is out of scope.

An ExpressRoute setup has three main components: the **circuit**, the **gateway**, and the **connection**.

:::image type="complex" source="images/expressroute-logical-components.svg" alt-text="Diagram that shows the logical components used in ExpressRoute private connectivity." border="false" lightbox="images/expressroute-logical-components.svg":::
Diagram that shows the three logical components that together establish ExpressRoute private connectivity: the ExpressRoute circuit, the ExpressRoute connection, and the ExpressRoute gateway. On the far left is a box labeled On-premises network. A line extends from the on-premises network to a building icon labeled ExpressRoute peering location. A large shape labeled Microsoft global network spans from the ExpressRoute peering location across the connection and gateway to encompass the Azure region, visually grouping the components that operate within the Microsoft backbone. Below the ExpressRoute peering location is the ExpressRoute circuit. A plus sign separates the circuit from the ExpressRoute connection. The connection is associated with the Microsoft global network. Another plus sign separates the connection from the ExpressRoute gateway. The ExpressRoute gateway is associated with the Azure region, which is in the Microsoft global network. The diagram conveys that these three resources must all be provisioned and linked in sequence: circuit at the peering location, then gateway inside the Azure virtual network, and then connection joining the two.
:::image-end:::

ExpressRoute delivers connectivity through [ExpressRoute peering locations](/azure/expressroute/expressroute-locations). Peering locations are the entry points into the Microsoft backbone, and [Azure regions](/azure/reliability/regions-list) are the locations where you deploy Azure resources. Peering locations and Azure regions are two distinct entities in different physical locations.

## Architecture

An ExpressRoute circuit supports two peering types. [ExpressRoute private peering](/azure/expressroute/expressroute-circuit-peerings#privatepeering) (blue in the diagram) connects your on-premises network to Azure virtual networks through an ExpressRoute gateway. [Microsoft peering](/azure/expressroute/expressroute-circuit-peerings#microsoftpeering) (red in the diagram) connects to Microsoft 365, Dynamics 365, and Azure public services through public IP addresses. This article doesn't address Microsoft peering.

:::image type="complex" source="images/expressroute-connectivity-diagram.svg" alt-text="Diagram that shows hybrid connectivity with an ExpressRoute gateway." border="false" lightbox="images/expressroute-connectivity-diagram.svg":::
Diagram that shows how an ExpressRoute circuit supports two peering types that route traffic to different destinations. On the left is a box labeled On-premises network. A line extends from the on-premises network to a box labeled Partner edge, which then connects to a box labeled Microsoft Enterprise Edge routers (MSEE). There are two connections between the partner edge and the MSEE: a primary link and a secondary link. Together, these two links form a single ExpressRoute circuit, and each link carries both ExpressRoute private peering and Microsoft peering traffic. From the MSEE, the two paths diverge. The Microsoft peering path leads to a box labeled Microsoft 365, Dynamics 365, and Azure public services, which holds eight service icons: Copilot, Kubernetes services, Storage accounts, Azure Cosmos DB, Dynamics 365, Microsoft Entra ID, Virtual machines, and Application gateways. The Azure private peering path leads to a separate box labeled Azure region. The region contains an ExpressRoute gateway.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/expressroute-private-peering-connectivity.pptx) of the architectures in this article.*

The following diagram shows the architecture for the private peering path, including the redundant primary and secondary circuit links between the on-premises network and the Azure virtual network.

:::image type="complex" source="images/expressroute-private-peering-architecture.svg" alt-text="Diagram that shows a reference architecture for a hybrid network architecture that uses ExpressRoute private peering." border="false" lightbox="images/expressroute-private-peering-architecture.svg":::
Diagram that shows the reference architecture for ExpressRoute private peering, organized into three zones: On-premises on the left, Peering location in the center, and Microsoft global network on the right. Under the On-premises label is a box labeled On-premises network. The Peering location zone contains an ExpressRoute circuit. This circuit contains a primary link and a secondary link. Each link connects local edge routers to MSEEs. Two lines extend from the customer network into the Peering location zone, connecting to the two local edge routers. Lines from both MSEE routers converge and pass through an ExpressRoute connection icon, which is between the peering location zone and the Microsoft global network zone. The lines then continue into a box labeled Virtual network. Inside the Virtual network box, a dashed-border box labeled Gateway subnet contains an ExpressRoute gateway. The converging lines from both MSEEs terminate at the ExpressRoute gateway.
:::image-end:::

Traffic crosses three administrative zones on its way from on-premises hosts to Azure resources: your on-premises network, the ExpressRoute peering location where the circuit terminates, and the Azure virtual network reached via the ExpressRoute gateway. The workflow that follows describes how a packet traverses these zones. The components inventory after it describes each element shown in the diagram.

### Workflow

Traffic flows from left to right through the three zones shown in the diagram:

1. **On-premises network.** Traffic originates from your on-premises network and travels to local edge routers at the ExpressRoute peering location.

1. **Peering location.** The local edge routers connect to Microsoft Enterprise Edge routers (MSEEs) through the ExpressRoute circuit. Redundant primary and secondary links provide high availability between the local routers and the MSEEs.

1. **Azure virtual network.** The MSEEs forward traffic through the ExpressRoute connection to the ExpressRoute gateway in the gateway subnet. The gateway routes traffic into the Azure virtual network.

### Components

The architecture consists of the following components:

- **On-premises network.** This private network is operated within your organization. It represents the organization's internal, self-managed network environment.

- **Azure virtual network.** An Azure virtual network provides your isolated network environment in Azure. It's deployed within a single region. It functions as an extension of your organization's private network in the cloud. Use subnets to organize and segment resources as needed.

- **ExpressRoute circuit.** A logical connection between your on-premises infrastructure and Microsoft cloud services through a connectivity provider. The circuit provides two redundant connections between MSEEs and your local edge routers, and Azure private peering establishes redundant BGP sessions over those connections. Each ExpressRoute circuit is provisioned at an [ExpressRoute peering location](/azure/expressroute/expressroute-locations), where cross-connections to the Microsoft global network terminate.

    - **MSEEs.** Two Microsoft-managed routers operating in an active-active, highly available configuration.

    - **Local edge routers.** Routers that connect the on-premises network to the circuit. These routers are supplied by an [ExpressRoute connectivity provider](/azure/expressroute/expressroute-locations-providers) or, in the case of [ExpressRoute Direct](/azure/expressroute/expressroute-erdirect-about), by the customer.

- **ExpressRoute virtual network gateway.** The virtual network gateway enables connectivity between the Azure virtual network and the ExpressRoute circuit that's used for on-premises connectivity. You deploy it as multiple gateway instances for high availability. It connects to both MSEEs, and it runs in an Azure region. The gateway is bound to a single Azure region and a single virtual network, so it's the point at which the redundant circuit converges into a single per-region admission surface. Reaching resources in other regions requires additional gateways in additional virtual networks attached to the same circuit, or a hub topology that uses virtual network peering or Azure Virtual WAN.

    - **Gateway subnet.** A dedicated subnet within the virtual network that hosts the Azure virtual network gateways (ExpressRoute gateway, VPN gateway, or both). The subnet must be named `GatewaySubnet`.

- **ExpressRoute connection.** A resource that links the ExpressRoute circuit at the peering location to the ExpressRoute virtual network gateway in Azure. It establishes the virtual connection between the MSEE routers and the gateway.

## Set up ExpressRoute components

This section describes how to provision and connect the three ExpressRoute resources introduced in the architecture: the circuit at the peering location, the ExpressRoute gateway inside the Azure virtual network, and the connection that links them. Provision them in that order. The gateway has no peer to attach to until the circuit exists, and the connection resource requires both the circuit and the gateway.

#### ExpressRoute circuit and peerings

Create an ExpressRoute circuit by using the Azure portal, Azure CLI, or PowerShell. For step-by-step instructions, see [Create an ExpressRoute circuit](/azure/expressroute/expressroute-howto-circuit-arm?tabs=standard).

After the circuit is provisioned by your connectivity provider or directly by you, configure [Azure private peering](/azure/expressroute/expressroute-circuit-peerings#privatepeering), [Microsoft peering](/azure/expressroute/expressroute-circuit-peerings#microsoftpeering), or both. These routing domains provide connectivity to Azure private resources (virtual networks) and Microsoft cloud services, respectively.

Each ExpressRoute circuit has a fixed bandwidth, shared across all peerings on that circuit. Each circuit belongs to a specific connectivity provider and peering location. This association is fixed for the life of the circuit. To change either the provider or the peering location, you need to create a new circuit. The [ExpressRoute circuit SKU](/azure/expressroute/expressroute-faqs#what-is-the-connectivity-scope-for-different-expressroute-circuit-skus) (Local, Standard, Premium) determines the maximum reach of Azure resources that you can connect to.

For routing configuration guidelines, see [Create and modify peering for an ExpressRoute circuit](/azure/expressroute/expressroute-howto-routing-portal-resource-manager).

Review the [routing requirements](/azure/expressroute/expressroute-routing#dynamic-route-exchange) before you configure circuit routing.

#### ExpressRoute gateway

An [ExpressRoute gateway](/azure/expressroute/expressroute-about-virtual-network-gateways) is a virtual network gateway of type ExpressRoute. Deploy it inside your virtual network to extend your on-premises network into Azure. Deploy it in a dedicated subnet named `GatewaySubnet`. The same subnet can also host a VPN gateway in a coexistence configuration.

ExpressRoute offers multiple [gateway SKUs](/azure/expressroute/expressroute-about-virtual-network-gateways#gateway-skus) for different throughput and performance requirements. Higher SKUs allocate more CPU and bandwidth, which supports higher throughput to the virtual network.

To deploy the gateway, follow the instructions in [Configure a virtual network gateway for ExpressRoute](/azure/expressroute/expressroute-howto-add-gateway-portal-resource-manager).

#### ExpressRoute connection

An ExpressRoute connection links a virtual network, specifically its ExpressRoute gateway, to an ExpressRoute circuit. This connection enables private routing between your on-premises network and Azure resources.

Key properties:

- **Multiple circuits per virtual network.** A single virtual network can connect to multiple ExpressRoute circuits.
- **Multiple gateways per circuit.** A single ExpressRoute circuit can link to multiple ExpressRoute gateways in different virtual networks.
- **Service limits.** For more information, see [Azure ExpressRoute limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-expressroute-limits).

Because of fan-in and fan-out across circuits and gateways, a single circuit can be shared across virtual networks owned by different teams, regions, or subscriptions. Account for this shared blast radius when you assign ownership, alerting, and change control for the circuit.

To create the connection, see [Connect a virtual network to ExpressRoute circuits](/azure/expressroute/expressroute-howto-linkvnet-portal-resource-manager).

## Considerations

These considerations align with the pillars of the Azure Well-Architected Framework, a set of guiding principles for improving workload quality. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures that your workload can consistently meet the availability and performance expectations of your users. See the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

ExpressRoute has multiple components, so design resiliency across all of them:

- **Gateway resiliency.** Use [zone-redundant ExpressRoute gateways](/azure/reliability/reliability-virtual-network-gateway?toc=%2Fazure%2Fexpressroute%2Ftoc.json&pivots=expressroute) to avoid single-zone failures.
- **Circuit resiliency.** Use the built-in [active-active configuration](/azure/expressroute/design-architecture-for-resiliency#plan-for-active-active-configuration). Consider deploying [redundant circuits](/azure/expressroute/design-architecture-for-resiliency#evaluate-the-resiliency-of-multi-site-redundant-expressroute-circuits). Enable [Bidirectional Forwarding Detection (BFD)](/azure/expressroute/expressroute-bfd), when the on-premises peer supports and is configured for it, to detect link failures faster.
- **Connection resiliency.** Link gateways and circuits through geographically diverse, fully redundant cross-connections so that connectivity remains available during site-level failures or [disaster-recovery](/azure/expressroute/designing-for-disaster-recovery-with-expressroute-privatepeering#large-distributed-enterprise-network) events.

The ExpressRoute virtual network gateway is the per-region reliability ceiling. All upstream redundancy, including active-active MSEEs, BFD, redundant circuits, and geographically diverse cross-connections, converges at a single regional gateway. Regional resilience of the connectivity path itself requires a second gateway in a second region. End-to-end disaster recovery also requires geo-redundant circuits through distinct peering locations. See [Designing for disaster recovery with ExpressRoute private peering](/azure/expressroute/designing-for-disaster-recovery-with-expressroute-privatepeering) for multi-region designs.

For end-to-end resiliency guidance, see [Design and architect Azure ExpressRoute for resiliency](/azure/expressroute/design-architecture-for-resiliency).

### Security

Security protects your applications and data from unauthorized access or misuse. See the [Design review checklist for Security](/azure/well-architected/security/checklist).

Keep the following considerations in mind:

- **Reachability isn't authorization.** ExpressRoute provides private reachability between your on-premises network and Azure. It doesn't authenticate or authorize callers. Anyone who can reach a resource over the circuit is bounded only by what the routing advertises. Azure-side controls, including network security groups (NSGs), Azure Firewall, and application-layer authentication, are still required.

- **Security appliances.** Insert security appliances between the on-premises network and the provider edge to filter undesired inbound traffic. This pattern delegates inspection and incident-response obligations for traffic entering the circuit to the on-premises team, making that team part of the Azure workload's runtime security path.

  :::image type="complex" source="images/expressroute-connectivity-with-on-premises-firewall.svg" alt-text="Diagram that shows hybrid connectivity with an on-premises firewall." border="false" lightbox="images/expressroute-connectivity-with-on-premises-firewall.svg":::
  Diagram that shows how on-premises firewalls are inserted into the ExpressRoute connectivity path before traffic reaches the circuit. On the left is a box labeled On-premises network. This box contains two firewall icons. Bidirectional arrows connect the network devices to each firewall, indicating that all traffic entering and leaving the customer network passes through the firewalls before reaching the circuit. Lines extend from each firewall to a pair of router icons outside the on-premises network box. Each of these routers connects to its own Microsoft edge router, one via a primary ExpressRoute circuit, and one via a secondary ExpressRoute circuit. From the Microsoft edge routers, the two paths diverge. One path, which is red, connects to box labeled Microsoft 365, Dynamics 365, and Azure public services. This box contains eight service icons: Copilot, Kubernetes services, Storage accounts, Azure Cosmos DB, Dynamics 365, Microsoft Entra ID, virtual machines, and application gateways. The other path, which is blue, leads to box labeled Azure region. The region contains an ExpressRoute gateway icon.
  :::image-end:::

- **Forced tunneling.** Implement forced tunneling to route internet-bound traffic back on-premises through an inspected egress path when audit or compliance controls require it. Forced tunneling couples Azure workload egress to on-premises edge capacity and availability. It shifts inspection and incident-response obligations onto the on-premises team. Account for that coupling in egress capacity planning and incident response.

  :::image type="complex" source="images/expressroute-connectivity-with-forced-tunneling.svg" alt-text="Diagram that shows hybrid connectivity with forced tunneling." border="false" lightbox="images/expressroute-connectivity-with-forced-tunneling.svg":::
  Diagram that shows how forced tunneling routes internet-bound traffic from Azure back to an on-premises internet proxy before it exits to the internet. On the left is a box labeled On-premises network. This box contains a firewall icon that's labeled Internet proxy. The on-premises network is connected to the internet. In the center of the diagram, there are two ExpressRoute circuits labeled Primary link and Secondary link. Each link connects two router icons. The routers on the left represent local edge routers, and the ones on the right represent Microsoft edge routers. Three traffic paths travel across the primary and secondary links simultaneously, as identified by a legend. The blue path indicates Azure private peering for virtual networks. The red path indicates Microsoft peering for Office 365, Microsoft 365, and Azure public services that use public IP addresses. The yellow path indicates internet traffic that travels over the private peering. The internet traffic path runs from an ExpressRoute gateway in an Azure region, back through the circuit links to the local edge routers, and into the on-premises network. From there it runs through the internet proxy to the internet. From the Microsoft edge routers, the Microsoft peering path connects to a box labeled Microsoft 365, Dynamics 365, and Azure public services. This box contains Copilot, Kubernetes services, Storage accounts, Azure Cosmos DB, and Dynamics 365, Microsoft Entra ID, virtual machines, and application gateways. The Azure private peering path leads to a box labeled Azure region, which contains an ExpressRoute gateway.
  :::image-end:::

- **VM exposure.** Avoid exposing VMs directly to the internet. Ensure that they're reachable only through private IPs, and restrict any management access by using NSGs, ACLs, and just-in-time (JIT) controls. Assign public IPs only when you need to, and protect them with strict allowlists. Consider using Azure Policy to prevent the creation of public IP addresses. For more information, see the "Network interfaces shouldn't have public IPs" definition in [Built-in policy definitions for Azure Virtual Network](/azure/virtual-network/policy-reference).

- **Encryption.** Traffic over ExpressRoute isn't encrypted by default. You can optionally enable:

  - [MACsec](/azure/expressroute/expressroute-howto-macsec). Layer 2, hop-by-hop encryption, available on ExpressRoute Direct only. It secures traffic on the physical links between customer routers and Microsoft edge routers with minimal performance impact.
  - [VPN over ExpressRoute](/azure/expressroute/expressroute-about-encryption#end-to-end-encryption-by-ipsec-faq) (end-to-end). Uses an IPsec/IKE VPN tunnel terminated on an Azure VPN gateway or non-Microsoft network virtual appliance. ExpressRoute provides the underlying private transport. See [Configure a Site-to-Site VPN connection over ExpressRoute private peering](/azure/vpn-gateway/site-to-site-vpn-private-peering). Enabling IPsec over ExpressRoute introduces extra processing overhead and might reduce effective throughput, as compared to that of native ExpressRoute traffic.

- **BGP session integrity.** Use an MD5 hash during private or Microsoft [peering configuration](/azure/expressroute/expressroute-howto-routing-portal-resource-manager#prerequisites) to protect BGP sessions from tampering. MD5 protects against casual session manipulation, but it isn't a strong cryptographic control. Treat it as session integrity, not as transport encryption or strong authentication.

For a full list of security recommendations, see the [Azure security baseline for ExpressRoute](/security/benchmark/azure/baselines/expressroute-security-baseline).

### Cost Optimization

Cost Optimization focuses on reducing unnecessary expenses and improving operational efficiencies. See the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

ExpressRoute provides two pricing models:

- **Metered Data.** Free inbound data. Outbound data charged per GB.
- **Unlimited Data.** Fixed monthly port fee. Both inbound and outbound data is included.

Monitor circuit utilization and select a plan that aligns with actual usage.

The pricing plan is one cost factor among several. Review these structural factors together:

- **Gateway SKU.** Higher-performance gateway SKUs incur a higher recurring charge. See [Gateway SKUs](/azure/expressroute/expressroute-about-virtual-network-gateways#gateway-skus) for per-SKU sizing and performance information.
- **Circuit SKU/tier.** The Local, Standard, and Premium tiers have different recurring charges and connectivity scopes. Premium adds a recurring premium for higher route limits, more virtual network links, and global reachability.
- **Circuit bandwidth.** Bandwidth is a recurring charge. Increases are nondisruptive, but for decreases you need to re-create the circuit, so downsizing creates more friction than upsizing.
- **Redundancy choices.** The redundant circuits, geographically diverse cross-connections, and multi-region gateways recommended in [Reliability](#reliability) each add recurring costs. Treat the reliability target and the cost considerations as a single decision.

For full pricing details, see [Azure ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute/).

### Operational Excellence

Operational Excellence ensures that your connectivity remains observable, supportable, and well-maintained. See the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Keep the following considerations in mind:

- **Real-time visibility.** Use [ExpressRoute Traffic Collector](/azure/expressroute/how-to-configure-traffic-collector) and [ExpressRoute Insights with Network Insights](/azure/expressroute/expressroute-network-insights) for performance, availability, and packet-drop metrics.
- **Maintenance notifications.** Configure [Azure Service Health](/azure/expressroute/maintenance-alerts) alerts to receive ExpressRoute maintenance notifications.
- **End-to-end reachability.** Use [Connection Monitor for ExpressRoute](/azure/expressroute/how-to-configure-connection-monitor) to track connectivity between Azure and on-premises. Connection Monitor is the end-to-end reachability signal. The other items in this list are per-component signals. All components reporting a healthy status doesn't guarantee end-to-end reachability if BGP is misadvertised, the peer is filtering, or one circuit link silently failed.
- **Gateway health.** Monitor gateway health and performance by using [Azure Monitor](/azure/expressroute/monitor-expressroute-reference#supported-metrics-for-microsoftnetworkexpressroutegateways) (CPU, throughput, routes, and flows).
- **Change-management of the shared circuit.** A circuit is shared infrastructure. Connectivity-provider-side changes, peering reconfigurations, and bandwidth modifications affect every virtual network attached to the circuit. Assign clear circuit ownership, notify downstream virtual network owners of planned changes, and coordinate change windows across teams that share the circuit.

For the full metrics list, see [Azure ExpressRoute monitoring data reference](/azure/expressroute/monitor-expressroute-reference). For broader resiliency monitoring guidance, see [Monitoring and alerting recommendations](/azure/expressroute/design-architecture-for-resiliency#monitoring-and-alerting-recommendations).

### Performance Efficiency

Performance Efficiency ensures that the connectivity layer can scale and sustain expected load. See the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Key considerations:

- **Component interdependency.** The gateway SKU must match the performance needs of the circuit. Higher-bandwidth circuits require higher-performance gateways to avoid bottlenecks. See [ExpressRoute gateway SKUs](/azure/expressroute/expressroute-about-virtual-network-gateways#gateway-skus) for per-SKU throughput information that you can use to match the gateway to the circuit.

- **Circuit and gateway limits.** A single ExpressRoute circuit supports a maximum number of route advertisements and virtual network links. A single ExpressRoute gateway supports a limited number of circuit connections. See [Azure ExpressRoute limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-expressroute-limits).

  > [!NOTE]
  > Use the [Azure Connectivity Toolkit](/azure/expressroute/expressroute-troubleshooting-network-performance#azurect---the-azure-connectivity-toolkit) to test and baseline link latency and throughput.

- **Circuit bandwidth.** Available bandwidth depends on your connectivity provider. Use `Get-AzExpressRouteServiceProvider` to list providers and bandwidth SKUs that are supported in your region.

- **ExpressRoute Premium add-on.** This add-on provides:
  - Higher route limits for private peering.
  - More virtual network links per circuit.
  - Global reachability across regions.

  Premium adds a recurring premium charge and extends the circuit's reach scope across regions, which broadens the set of virtual networks that can attach. Weigh the uplift against the pricing-plan and structural factors in [Cost Optimization](#cost-optimization) and against the governance controls that decide which virtual networks attach to the circuit.

- **Scaling options.** If you need higher performance, increase circuit bandwidth or upgrade the circuit SKU (including switching to Premium). Bandwidth increases are nondisruptive, but for decreases you need to re-create the circuit. Also, you can't switch from the Unlimited Data plan back to Metered Data. For the PowerShell commands and SKU-coupling rules, see [Modifying an ExpressRoute circuit](/azure/expressroute/expressroute-howto-circuit-arm#modifying-an-expressroute-circuit).

- **ExpressRoute scalable gateway.** Use the [ExpressRoute scalable gateway](/azure/expressroute/scalable-gateway) (ErGwScale SKU) to automatically scale gateway capacity without manual intervention.

- **ExpressRoute FastPath.** Enable [ExpressRoute FastPath](/azure/expressroute/about-fastpath) for higher throughput and reduced latency. When you enable FastPath, traffic bypasses the gateway for data-plane traffic. FastPath is a data-path bypass: the gateway's control-plane role (route propagation, BGP, gateway metrics) is unchanged, but data-plane observability and any policy that depended on traffic traversing the gateway no longer apply. FastPath also has configuration constraints (for example, around user-defined routes on the gateway subnet). Review the [FastPath limitations](/azure/expressroute/about-fastpath#limitations) before enabling it.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Cynthia Treger](https://www.linkedin.com/in/cynthia-treger-6663402/) | Solution Engineer Global Black Belt

## Next steps

To put this architecture into practice, start by creating the ExpressRoute circuit. The following product documentation and Microsoft Learn modules cover circuit creation, gateway deployment, virtual network linking, and the surrounding hybrid networking concepts.

Product documentation:

- [ExpressRoute documentation](/azure/expressroute)
- [Azure security baseline for ExpressRoute](/security/benchmark/azure/baselines/expressroute-security-baseline?toc=%2fazure%2fexpressroute%2fTOC.json)
- [Create an ExpressRoute circuit](/azure/expressroute/expressroute-howto-circuit-portal-resource-manager)
- [Azure networking documentation](/azure/networking/)
- [Configure ExpressRoute and Site-to-Site coexisting connections by using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Microsoft 365 services](/office365/servicedescriptions/office-365-service-descriptions-technet-library)

Microsoft Learn modules:

- [Configure virtual network peering](/training/modules/configure-vnet-peering)
- [Design and implement Azure ExpressRoute](/training/modules/design-implement-azure-expressroute)

## Related resources

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Azure hybrid options](../../guide/technology-choices/hybrid-considerations.yml)
- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
- [Connect an on-premises network to Azure](hybrid-connectivity-options.md)
- [Implement a secure hybrid network](../dmz/secure-vnet-dmz.yml)
- [Architecture best practices for Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute)
