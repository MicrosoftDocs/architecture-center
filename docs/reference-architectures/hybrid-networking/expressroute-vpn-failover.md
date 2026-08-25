---
title: Use Site-to-Site VPN as Failover for Azure ExpressRoute
description: Learn how to connect an on-premises network to an Azure virtual network by using ExpressRoute with a virtual private network (VPN) gateway failover.
author: cynthiatreger
ms.author: ctreger
ms.date: 07/22/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom:
    - arb-hybrid
---

# Use site-to-site VPN as failover for Azure ExpressRoute

This article helps network and cloud architects design resilient hybrid connectivity between an on-premises network and an Azure virtual network. It describes how to use Azure ExpressRoute private peering as the primary connection and a site-to-site VPN as a failover path. Use this pattern when the workload can tolerate the VPN path's lower and less predictable performance during an ExpressRoute outage. Don't use it as the sole backup for latency-sensitive, mission-critical, or bandwidth-intensive workloads. Use ExpressRoute multi-site resiliency for those workloads.

## Architecture

This architecture connects an on-premises network to an Azure virtual network by using ExpressRoute private peering. A site-to-site VPN connection provides a backup path in case the ExpressRoute connection becomes unavailable.

:::image type="complex" source="images/expressroute-connectivity-with-vpn-backup.svg" alt-text="Architecture for a hybrid network architecture that uses ExpressRoute connectivity with VPN failover." border="false" lightbox="images/expressroute-connectivity-with-vpn-backup.svg":::
Diagram that shows a hybrid network architecture that uses ExpressRoute as the primary connectivity path and a site-to-site VPN tunnel as a failover path between an on-premises network and an Azure virtual network. On the left is a box labeled On-premises network, which contains a router at the network boundary. Two connectivity paths extend from the on-premises network toward an Azure region on the right. The first path is the ExpressRoute path. A line connects the on-premises network to a box labeled Partner edge. The partner edge connects to a box labeled Microsoft edge through two parallel links: a primary link and a secondary link. From the Microsoft edge, a line extends rightward into the Azure region and connects to the ExpressRoute gateway. The second path is the VPN backup path. A line labeled IPsec S2S VPN tunnel extends from the on-premises network, bypassing the partner edge and Microsoft edge, and connects to the VPN gateway in the Azure region. In the Azure region, a box contains two gateway icons: the ExpressRoute gateway and the VPN gateway.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/expressroute-vpn-failover.pptx) of this architecture.*

## Components

The architecture contains the following primary components:

- **On-premises network.** Your corporate network, including the edge router or VPN device that terminates both the ExpressRoute connection and the site-to-site VPN tunnel.
- **ExpressRoute private peering.** A dedicated private connection between the on-premises network and the Azure virtual network, established through a connectivity provider and terminated on an ExpressRoute virtual network gateway in Azure.
- **Site-to-site VPN.** An IPsec VPN tunnel over the public internet between the on-premises VPN device and an Azure VPN gateway.

For information about the ExpressRoute components, see [Connect an on-premises network by using Azure ExpressRoute](./expressroute-private-peering-connectivity.md).

For information about the VPN connectivity components, see [Connect an on-premises network by using Azure VPN Gateway](./hybrid-vpn-connectivity.md).

## Scenario details

ExpressRoute provides dedicated, high-bandwidth connectivity between your on-premises infrastructure and Azure. A standard-resiliency ExpressRoute circuit has two active-active connections at one peering location, so that peering location remains a site-level failure domain. This architecture adds resilience by configuring a site-to-site VPN as a backup path. Under normal conditions, traffic flows through the ExpressRoute connection because you configure routing to prefer ExpressRoute over the VPN path. If the ExpressRoute peering location or circuit becomes unavailable, traffic fails over to the IPsec VPN tunnel.

In failover mode, the VPN path carries only the traffic that uses ExpressRoute private peering. Traffic that uses ExpressRoute Microsoft peering continues to reach Microsoft services over the internet rather than over the VPN tunnel.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Failover isn't instantaneous.** When the ExpressRoute circuit becomes unavailable, the on-premises edge router detects the loss through Border Gateway Protocol (BGP) and converges onto the VPN path. Convergence time depends on the BGP timers and keepalive settings on the on-premises device. Stateful sessions that traverse ExpressRoute at the moment of failure generally drop and re-establish over the VPN path.
- **Plan for failback.** Because the on-premises network is configured to prefer ExpressRoute, traffic shifts back automatically when the ExpressRoute circuit recovers and BGP reconverges. Failback is itself a routing event that can disrupt stateful sessions a second time. Decide whether automatic failback is acceptable for your workload, or whether you need to gate it so operators control when traffic returns to ExpressRoute. You can gate it, for example, by using route dampening or a manual cutback.
- **The backup path isn't an equivalent substitute.** The site-to-site VPN runs over the public internet and is bounded by the throughput and SLA of the Azure VPN gateway SKU you choose. Treat the VPN as a degraded-mode path, not as an equivalent replacement for ExpressRoute, especially during an extended ExpressRoute outage.
- **Tradeoff: resilience versus steady-state cost.** This pattern improves availability by paying continuously for a backup path that's unused under normal conditions. If your workload can tolerate a longer recovery objective, or if you have an alternative such as a second ExpressRoute circuit at a different peering location, evaluate whether the cost of an always-on VPN backup matches the resilience benefit.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **The backup path has a steady-state cost.** The Azure VPN gateway runs continuously to keep the backup tunnel ready, and it incurs costs whether or not failover ever occurs. Include the VPN gateway, the tunnel, and any associated egress charges in your baseline cost model, not only in your incident cost model.
- **Size the VPN gateway for failover load, not minimum cost.** The VPN gateway SKU sets the ceiling on backup-path throughput. A gateway sized for minimum steady-state cost can produce a backup that nominally exists but degrades the workload under realistic failover load. Size the gateway against the traffic the workload actually needs to carry during an ExpressRoute outage.
- **Tradeoff: performance during failover versus VPN gateway cost.** A higher VPN gateway SKU preserves more of the workload's normal performance envelope during failover but increases steady-state cost. Decide which of your workloads must continue at full capacity during an ExpressRoute outage and which can run in a degraded mode, and size accordingly.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Validate the failover path on a regular cadence.** A backup path that's never used tends to drift out of working order, through VPN misconfiguration, on-premises route-preference changes, or firmware updates that alter BGP behavior. Run controlled failover drills, or, at a minimum, monitor the health of the VPN tunnel and that BGP sessions are established on both paths, so that failover works on the day you need it.
- **Monitor both paths and the routing state.** Operators need visibility into ExpressRoute circuit health, VPN tunnel state, and BGP session state on the on-premises edge. Without those signals, a degraded ExpressRoute circuit or a silently broken VPN tunnel can go unnoticed until an incident.
- **Govern configuration on the on-premises edge.** The route-preference logic that makes failover correct is located on a device outside Azure that the cloud team often doesn't own. Treat the on-premises edge configuration as part of the workload's operational scope: include it in change management, document the route-preference policy, and review it when the on-premises network team upgrades or replaces the device.
- **Decide failback policy deliberately.** Whether failback is automatic on BGP reconvergence or operator-gated is an operational policy choice, not a default to inherit. Document the decision so operators know what to expect when the ExpressRoute circuit recovers.
- **Tradeoff: simplicity versus operational ownership.** Delegating route preference and failover behavior to the on-premises edge keeps the Azure side simple but transfers a meaningful ongoing obligation to the network team that owns the on-premises device. This obligation includes route configuration, BGP timers, validation, and change control. Make that ownership boundary explicit so the resilience of the design doesn't quietly degrade over time.

## Deployment guidance

**Prerequisite.** You must have an existing on-premises infrastructure that's already configured with a suitable network appliance.

This deployment guidance starts from the **Deploy to Azure** link for the ExpressRoute private peering virtual network quickstart template. The template starts the Azure deployment, but it doesn't complete private peering connectivity or the site-to-site VPN backup path.

1. Select the following link:

   [![Button icon for deploying to Azure.](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fazure-quickstart-templates%2fmaster%2fquickstarts%2fmicrosoft.network%2fexpressroute-private-peering-vnet%2fazuredeploy.json)

1. When the Azure portal opens, select the **Resource group** that you want to deploy these resources into, or create a new resource group. The **Region** and **Location** automatically change to match the resource group.

1. Update the remaining fields if you want to change the resource names, providers, SKU, or network IP addresses for your environment.

1. Select **Review + create**, and then select **Create** to deploy these resources.

1. Wait for the deployment to finish.

1. Before adding the VPN gateway, verify the [ExpressRoute and VPN coexistence requirements](/azure/expressroute/how-to-configure-coexisting-gateway-portal): use a route-based, non-Basic VPN gateway and use a `GatewaySubnet` of /27 or shorter. Then follow the steps in [Create a site-to-site VPN connection](/azure/vpn-gateway/tutorial-site-to-site-portal) to configure the backup path.

1. After you configure a VPN connection to the same on-premises network that you configured for ExpressRoute, configure your on-premises network to prefer ExpressRoute routes over the site-to-site VPN routes. For example, set a higher BGP local preference on routes learned from ExpressRoute. This setting controls the on-premises-to-Azure direction. For Azure-to-on-premises traffic, Azure prefers ExpressRoute only when both paths advertise the same prefix. The longest-prefix match takes precedence. Keep route advertisements aligned, or explicitly design more specific routes, to avoid asymmetric routing. With these routing rules in place, the site-to-site VPN serves as a backup if the ExpressRoute peering location fails.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Sarah Parkes](https://www.linkedin.com/in/sarah-p-a06370) | Senior Cloud Solution Architect
- [Cynthia Treger](https://www.linkedin.com/in/cynthia-treger-6663402/) | Solution Engineer Global Black Belt

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about the services in this architecture, see the following product documentation:

- [Azure ExpressRoute documentation](/azure/expressroute)
- [Create and modify an ExpressRoute circuit](/azure/expressroute/expressroute-howto-circuit-portal-resource-manager)
- [Azure VPN Gateway documentation](/azure/vpn-gateway)
- [Configure ExpressRoute and site-to-site coexisting connections by using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager)

To get foundational skills for this scenario, see the following Microsoft Learn module:

- [Design and implement Azure ExpressRoute](/training/modules/design-implement-azure-expressroute)

## Related resources

For more information about hybrid networking patterns related to this architecture, see the following articles:

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Azure hybrid options](../../guide/technology-choices/hybrid-considerations.yml)
- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
- [Virtual network connectivity options and spoke-to-spoke communication](../../reference-architectures/hybrid-networking/virtual-network-peering.yml)
- [Connect an on-premises network to Azure](hybrid-connectivity-options.md)
- [Implement a secure hybrid network](../dmz/secure-vnet-dmz.yml)
- [Architecture best practices for Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute)
