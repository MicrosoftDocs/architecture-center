---
title: Azure VPN Gateway Site-to-Site Connectivity for Hybrid Networks
description: This architecture shows how to establish encrypted layer-3 connectivity between your on-premises network and Azure virtual networks by using Azure VPN Gateway.
author: cynthiatreger
ms.author: ctreger
ms.date: 07/23/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Azure VPN Gateway site-to-site connectivity for hybrid networks

This article describes how to use Azure VPN Gateway to establish encrypted layer-3 site-to-site (S2S) connectivity between an on-premises network and an Azure virtual network over the public internet by using IPsec/IKE tunnels. It helps network architects and cloud infrastructure engineers understand the architecture, decide when site-to-site VPN is the right hybrid connectivity choice, and plan a deployment. This guidance applies whether VPN Gateway is the primary hybrid link, a backup or complement to [Azure ExpressRoute](/azure/expressroute/expressroute-introduction), or a rapid-deployment option with global reach when private circuits are unavailable or not yet in place.

> [!NOTE]
> This article primarily covers Azure site-to-site (S2S) VPN connectivity between on-premises networks and Azure virtual networks. This article doesn't cover point-to-site (P2S) or VNet-to-VNet VPN scenarios in depth. Those scenarios target remote user access and inter-VNet connectivity, respectively.

## Architecture

The following diagram shows a hybrid topology in which an on-premises network connects to an Azure virtual network through a site-to-site IPsec/IKE tunnel terminated on Azure VPN Gateway. The on-premises VPN device initiates the tunnel over the public internet to the VPN gateway's public IP address. You deploy the VPN gateway into a dedicated subnet named `GatewaySubnet` inside the virtual network, and a local network gateway resource represents the on-premises site by its public IP or FQDN and the address prefixes behind it. A VPN connection resource links the VPN gateway to the local network gateway and defines the tunnel properties.

:::image type="complex" source="./images/vpn-gateway-site-to-site-connection-diagram.svg" alt-text="Diagram that shows hybrid connectivity with a VPN Gateway." border="false" lightbox="./images/vpn-gateway-site-to-site-connection-diagram.svg":::
Diagram that shows a multi-site VPN connectivity architecture where two on-premises sites each connect to a single Azure VPN gateway through separate IPsec site-to-site VPN tunnels. On the left, there are two on-premises sites, each with a router icon at its boundary. The routers are labeled Local network device, public IP address 1 and Local network device, public IP address 2. A line from each router passes through an IPsec S2S VPN tunnel. The lines from both tunnels converge and connect to a VPN gateway in an Azure region on the right. A label between the two tunnels and the gateway reads VPN Gateway public IP address, indicating that both tunnels terminate at the same public endpoint on the Azure side. The Azure region contains a virtual network and a VPN Gateway icon.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/hybrid-vpn-connectivity.pptx) of this architecture.*

### Workflow

The following workflow describes both the provisioning sequence and the runtime traffic flow for a site-to-site VPN connection.

#### Provisioning

1. **Create the virtual network.** Create an Azure virtual network with a dedicated subnet named `GatewaySubnet`. Reserve this subnet exclusively for gateway instances. Don't host other resources in it.

1. **Deploy the VPN gateway.** Deploy an [Azure VPN gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) into `GatewaySubnet`. Azure assigns one or two public IP addresses to the gateway, depending on whether the gateway uses active-standby or active-active mode.

1. **Create the local network gateway.** Create a [local network gateway](/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#lng) resource that represents the remote network. This resource defines the public IP address or FQDN of the on-premises VPN device and the address prefixes that exist behind that remote site.

1. **Establish the VPN connection.** Create a VPN connection resource that links the VPN gateway to the local network gateway. The connection defines the shared key (or authentication method), connection type (site-to-site), and optional features such as [BGP](/azure/vpn-gateway/vpn-gateway-bgp-overview) or [NAT rules](/azure/vpn-gateway/nat-overview).

1. **Configure the on-premises VPN device.** Configure the on-premises VPN device to establish IPsec/IKE tunnels to the Azure VPN gateway's public IP addresses: one address in active-standby mode, or two in active-active mode. Both sides negotiate IKE phase 1 and phase 2 parameters and establish the encrypted tunnel.

#### Runtime

1. **On-premises host sends traffic to Azure.** An on-premises host sends a packet destined for a resource in the Azure virtual network. The on-premises routing infrastructure directs the packet to the on-premises VPN device.

1. **On-premises VPN device encrypts and transmits the packet.** The on-premises VPN device matches the packet against the configured IPsec security association, encrypts the packet payload by using the negotiated IPsec/IKE parameters, encapsulates it in a new IP header addressed to the Azure VPN gateway's public IP, and transmits it over the public internet.

1. **Azure VPN gateway receives and decrypts the packet.** The Azure VPN gateway receives the encapsulated packet on its public IP endpoint, validates the IPsec security association, decrypts the packet, and removes the tunnel encapsulation to recover the original packet.

1. **Azure routes the packet to the destination.** The VPN gateway forwards the decrypted packet into the Azure virtual network. Azure uses the virtual network's route tables, including any user-defined routes or BGP-learned routes, to deliver the packet to the destination resource.

1. **Return traffic follows the reverse path.** The destination Azure resource sends a response packet. Azure routes the response to the VPN gateway, which encrypts and encapsulates it and transmits it over the public internet to the on-premises VPN device. Then the on-premises device decrypts it and delivers it to the originating host.

If IKE phase 1 or phase 2 negotiation fails, a rekey doesn't complete, or liveness checks (dead peer detection) declare the peer unreachable, the tunnel enters a disconnected state and traffic that depends on it is dropped until the tunnel is re-established. Active-active deployments, redundant on-premises devices, and BGP dynamic routing reduce the user-visible duration of this condition by failing traffic over to a surviving tunnel rather than waiting for the original tunnel to recover. For more information, see the [Reliability](#reliability) section.

### Components

- **Azure Virtual Network.** An [Azure virtual network](/azure/well-architected/service-guides/virtual-network) provides the private network address space in Azure that hosts your workloads. In this architecture, the virtual network contains `GatewaySubnet` and any spoke or workload subnets that receive traffic from the VPN tunnel. Virtual Network is the foundational networking service that enables IP-based communication between Azure resources and with on-premises networks.

- **Azure VPN Gateway.** [Azure VPN Gateway](/azure/vpn-gateway/) is a virtual network gateway that terminates encrypted IPsec/IKE tunnels and routes traffic between Azure and remote networks. In this architecture, the VPN gateway establishes site-to-site connectivity with the on-premises VPN device and serves as the Azure-side tunnel endpoint. VPN Gateway provides native Azure-managed VPN termination, BGP dynamic routing, and coexistence with ExpressRoute, without requiring third-party network virtual appliances. For higher availability and resiliency, you can deploy VPN gateways in active-active mode by using two gateway instances and two public IP addresses. Active-active mode requires a route-based gateway. Policy-based gateways don't support active-active mode.

  The VPN gateway deploys into a dedicated subnet named `GatewaySubnet`, which is reserved exclusively for gateway instances (ExpressRoute gateway, VPN gateway, or both) and must not host other resources.

- **Local network gateway.** A [local network gateway](/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#lng) is an Azure resource that represents the remote (on-premises or branch) network for routing purposes. In this architecture, the local network gateway defines the public IP address or FQDN of the on-premises VPN device and the address prefixes behind that remote site. Azure uses the local network gateway to determine where to forward traffic after it exits the VPN gateway. In multi-site scenarios, you create multiple local network gateway resources to represent different branch or partner networks.

- **VPN connection.** A [VPN connection](/azure/vpn-gateway/design) is an Azure resource that links the VPN gateway to a local network gateway (for site-to-site connectivity) or to another VPN gateway (for VNet-to-VNet connectivity). In this architecture, the VPN connection defines the tunnel properties, including the connection type (S2S), shared key or authentication method, and optional features such as BGP routing and NAT rules for overlapping address spaces. A single VPN gateway supports multiple simultaneous connections. All tunnels share the available gateway bandwidth. Although the VPN connection is an Azure resource, the underlying tunnel traverses the public internet and inherits that path's throughput, jitter, and loss characteristics. For more information, see the [Performance Efficiency](#performance-efficiency) section.

- **Public IP addresses.** Azure public IP resources associated with the VPN gateway serve as tunnel endpoints. In this architecture, the VPN gateway uses one public IP address in active-standby mode or two public IP addresses in active-active mode. Remote VPN devices establish IPsec/IKE connections to these public IP addresses. When you create a new VPN gateway, you must use a Standard SKU public IP address, which uses static allocation. For more information, see [VPN Gateway FAQ](/azure/vpn-gateway/vpn-gateway-vpn-faq#virtual-network-gateways). Because this address is reachable from the public internet, it's the surface that an on-premises device, and any other source, can target. Apply the protective controls in the [Security](#security) section to this surface.

- **On-premises VPN device.** A physical or virtual network appliance in the on-premises or branch network establishes the remote end of the IPsec/IKE tunnel. Use an on-premises VPN device that's compatible with VPN Gateway, and configure it to connect to the gateway's public IP addresses. For a list of validated devices and configuration guides, see [About VPN devices for connections](/azure/vpn-gateway/vpn-gateway-about-vpn-devices).

## Scenario details

Azure S2S VPN connectivity provides encrypted, IPsec/IKE-based hybrid connectivity over the public internet when [ExpressRoute](/azure/expressroute/expressroute-introduction) private circuits aren't available, aren't yet provisioned, or aren't the right fit on their own. The same architecture also serves as a complementary or failover path alongside ExpressRoute. This configuration protects against circuit outages and provides a rapid-deployment option with global reach.

The architecture supports several optional and advanced capabilities:

- **Dynamic routing with BGP.** [BGP with VPN Gateway](/azure/vpn-gateway/vpn-gateway-bgp-overview) exchanges routes automatically between Azure and remote networks, which reduces static configuration and improves failover behavior when a tunnel or gateway instance becomes unavailable.
- **NAT for overlapping address spaces.** [NAT on VPN Gateway](/azure/vpn-gateway/nat-overview) translates overlapping IP ranges so that connected networks can communicate without renumbering, which is common when you integrate partner or acquired networks.
- **Coexistence with ExpressRoute.** VPN Gateway can coexist with ExpressRoute in the same virtual network to provide a VPN-based backup during ExpressRoute outages or transitional connectivity during ExpressRoute provisioning. Running both paths in parallel requires explicit route-preference design. For identical prefixes, Azure prefers ExpressRoute automatically, but longest-prefix match can override that preference. Configure the on-premises network with a higher local preference for routes received through ExpressRoute to keep the intended path symmetric. For more information, see [Configure ExpressRoute and Site-to-Site coexisting connections](/azure/expressroute/expressroute-howto-coexist-resource-manager).
- **VPN over ExpressRoute private peering.** For workloads with regulatory or compliance requirements that mandate encryption in transit, you can run IPsec/IKE tunnels over ExpressRoute private peering. This approach combines the predictable latency and private transport of ExpressRoute with end-to-end encryption. IPsec processing reduces effective throughput and has more latency than unencrypted private peering, so this option is best reserved for workloads where regulatory or compliance requirements justify that overhead. For more information, see [Site-to-site VPN over private peering](/azure/vpn-gateway/site-to-site-vpn-private-peering).

### Potential use cases

This architecture is relevant for organizations that need encrypted hybrid connectivity in scenarios such as:

- **Branch office connectivity.** Organizations with distributed branch offices connect each site to Azure over S2S VPN tunnels, which lets centralized workloads serve multiple locations.
- **Rapid deployment.** Teams that need hybrid connectivity quickly, without waiting for ExpressRoute circuit provisioning, deploy VPN gateways to establish tunnels in a short timeframe, including for proof-of-concept work.
- **ExpressRoute backup and failover.** Organizations that run ExpressRoute as the primary hybrid link deploy S2S VPN as a backup path to maintain connectivity during ExpressRoute outages or maintenance windows.
- **Regulated and compliance-driven environments.** Sectors such as finance, healthcare, and government that require end-to-end encryption in transit use VPN over ExpressRoute private peering to meet regulatory mandates, even when traffic already flows over private circuits.
- **Mergers, acquisitions, and partner integration.** Organizations that connect partner or newly acquired networks with overlapping address spaces use VPN Gateway NAT rules to enable connectivity without IP renumbering.
- **Multi-cloud and non-Microsoft connectivity.** Organizations connect Azure to non-Azure cloud environments or non-Microsoft datacenters over IPsec/IKE tunnels terminated on VPN Gateway.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Zone-redundant gateways.** Use an availability zone-supported VPN Gateway SKU for every new deployment. In a region that supports availability zones, deploy the gateway zone-redundantly. In a region without availability zones, the availability zone-supported SKU deploys regionally. Non-availability zone VpnGw1-5 SKUs can no longer be created and are scheduled for retirement after September 2026. The Basic SKU doesn't support zone redundancy and is intended only for development and test scenarios. For more information, see [VPN Gateway SKU consolidation and migration](/azure/vpn-gateway/gateway-sku-consolidation), [Reliability in Azure virtual network gateways (VPN)](/azure/reliability/reliability-virtual-network-gateway), and [About zone-redundant virtual network gateways](/azure/vpn-gateway/about-zone-redundant-vnet-gateways).
- **Active-active configuration.** Configure the Azure VPN gateway in active-active mode so that both gateway VMs process traffic simultaneously through two public IP addresses and two parallel IPsec tunnels to the on-premises device. Active-active reduces failover time compared with active-standby and can distribute traffic across both tunnels. For more information, see [Design highly available connectivity for cross-premises and VNet-to-VNet connections](/azure/vpn-gateway/vpn-gateway-highlyavailable).
- **Redundant on-premises devices.** Pair active-active Azure gateways with two on-premises VPN devices so that the failure of one Azure gateway VM, one tunnel, or one on-premises device doesn't sever the site-to-site connection. A single on-premises device with two tunnels protects against an Azure gateway instance or tunnel failure, but the device remains a single point of failure.
- **ExpressRoute and VPN coexistence.** For workloads that require a higher availability target than VPN Gateway alone provides, configure site-to-site VPN as a backup path for an [ExpressRoute](/azure/expressroute/expressroute-introduction) circuit. The two paths fail over independently and protect against circuit-level outages. For more information, see [Configure ExpressRoute and site-to-site coexisting connections](/azure/expressroute/expressroute-howto-coexist-resource-manager).
- **Service-level agreement.** All VPN Gateway SKUs, other than the Basic SKU, are eligible for the 99.95% availability SLA. Validate the SLA that applies to your chosen SKU and configuration against your workload's availability target. The gateway SLA covers the Azure side only. End-to-end tunnel availability also depends on the on-premises VPN device, the on-premises internet circuit, and the public-internet path between them, each of which needs its own redundancy strategy. For the current SLA values, see [SLA for VPN Gateway](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).
- **Maintenance windows.** Use customer-controlled gateway maintenance to align Azure-initiated maintenance with your change windows. Planned maintenance runs sequentially across the two gateway VMs so that one VM remains active, but aligning the window still reduces risk during business-critical periods. For more information, see [Configure customer-controlled maintenance for your virtual network gateways](/azure/vpn-gateway/customer-controlled-gateway-maintenance).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- **Strong cryptography.** Configure custom IPsec/IKE policies that use modern algorithms such as AES-256 for encryption, SHA-256 or stronger for integrity, and Diffie-Hellman Group 14 or higher (or ECP groups) for key exchange. The default Azure policy sets accept older parameters for interoperability. Tighten them where compliance requires it. For more information, see [About cryptographic requirements and Azure VPN gateways](/azure/vpn-gateway/vpn-gateway-about-compliance-crypto) and [Configure IPsec/IKE policy for site-to-site VPN connections](/azure/vpn-gateway/ipsec-ike-policy-howto).
- **Connection authentication.** Treat the site-to-site VPN preshared key as a secret. If you use preshared key retrieval from Key Vault, first open a Microsoft Support request to enable the feature for the subscription, and grant the gateway's managed identity access to the secret. For stronger authentication, use certificate-based authentication on supported gateway SKUs. Certificate-based site-to-site authentication is available only in Azure public cloud and isn't supported on the Basic SKU.
- **Public IP exposure.** The gateway's public IP address is reachable from the public internet and is the surface that any source can target with IKE traffic. Enable [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on the virtual network where applicable, monitor the public IP for anomalous traffic, and treat the gateway public IP as a perimeter resource in your network security posture.
- **Forced tunneling.** When enterprise policy requires that Azure-originated internet traffic is inspected on-premises, configure forced tunneling so that the default route for the virtual network is advertised through the site-to-site tunnel and Azure-bound outbound flows are redirected to the on-premises perimeter. This configuration satisfies the inspection requirement but routes all Azure-originated internet egress through the tunnel and the on-premises perimeter, which adds latency to outbound flows and makes the tunnel's bandwidth a dependency for general internet access from Azure. Size the gateway and the on-premises egress accordingly. For more information, see [About forced tunneling for site-to-site configurations](/azure/vpn-gateway/about-site-to-site-tunneling).
- **Network segmentation.** Place workload subnets behind network security groups and, where required, an [Azure Firewall](/azure/firewall/overview) or non-Microsoft network virtual appliance in a hub virtual network. The VPN gateway terminates the tunnel. It doesn't filter east-west or north-south traffic between subnets.
- **Control-plane access.** Govern the gateway, connection, public IP, and key vault resources with least-privilege Azure role-based access control. Where applicable, require just-in-time elevation through [Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-configure) for changes to the gateway SKU, connection properties, or shared key, because each of those operations directly affects tunnel availability or confidentiality.
- **Production-grade SKU.** Avoid the Basic SKU for any production deployment. It doesn't support custom IPsec/IKE policies, active-active mode, BGP, zone redundancy, or several other security and resiliency features. For more information, see [About VPN Gateway SKUs](/azure/vpn-gateway/about-gateway-skus).
- **Diagnostic logging.** Enable VPN Gateway diagnostic logs (gateway, tunnel, route, and IKE diagnostics) and forward them to a Log Analytics workspace or [Microsoft Sentinel](/azure/sentinel/overview) for threat detection and incident investigation. For more information, see [Secure your VPN Gateway deployment](/azure/vpn-gateway/secure-vpn-gateway).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Right-size the SKU.** Gateway SKUs differ significantly in hourly compute cost and in supported throughput, tunnel count, and BGP capacity. Start from the SKU that matches expected aggregate throughput and tunnel count, then scale up only when monitored utilization justifies it. Some SKU transitions support an in-place upgrade with minimal or no downtime, while others require migration or deletion and re-creation. Check the supported upgrade path before planning the change, and build modest headroom into the initial choice. For SKU options and quoted aggregate throughput per SKU, see [About gateway SKUs](/azure/vpn-gateway/about-gateway-skus). For current pricing, see [VPN Gateway pricing](https://azure.microsoft.com/pricing/details/vpn-gateway/).
- **Share through hub-spoke.** Deploy one VPN gateway in a hub virtual network and let spoke virtual networks reach on-premises through virtual network peering with gateway transit enabled. When you use this configuration, you avoid paying for one gateway per spoke. For more information, see [Configure VPN gateway transit for virtual network peering](/azure/vpn-gateway/vpn-gateway-peering-gateway-transit).
- **Egress data transfer.** The hourly compute charge is independent of traffic, but egress data leaving the gateway is billed at internet egress rates for traffic to on-premises and at inter-region rates for VNet-to-VNet flows in different regions. Factor expected egress volume into the cost model rather than treating the gateway as a flat hourly cost. Sustained, high-volume hybrid traffic is a signal to re-evaluate the choice between VPN Gateway and ExpressRoute on total cost, not only on capability. The total cost includes compute, egress, and operational overhead.
- **Resiliency cost.** Active-active mode is billed at the same hourly rate as active-standby for the same SKU, and zone redundancy adds no extra gateway cost when a supported SKU is used. Standard SKU public IPs used by the gateway are billed separately.
- **Non-production environments.** Non-production gateways accumulate hourly compute charges whether or not tunnels are active. Run non-production environments at a lower SKU than production, deploy fewer gateways, and consolidate them into a shared non-production hub where possible. Delete unused development and test gateways only when the re-creation time and configuration impact are acceptable.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Infrastructure as code.** Define the virtual network, `GatewaySubnet`, public IP addresses, virtual network gateway, local network gateway, and connection resource declaratively with Bicep, ARM templates, or Terraform. Keep the shared key out of the versioned definition by injecting it through a secure deployment parameter or supported Key Vault integration. Version the IPsec/IKE policy so the cryptographic configuration remains auditable.
- **Diagnostics and monitoring.** Send VPN Gateway metrics and diagnostic logs to a Log Analytics workspace through diagnostic settings. Use Azure Monitor alerts on tunnel state, BGP peer status, gateway egress, and tunnel ingress/egress for proactive detection of connectivity loss. For the available log categories and metrics, see [Monitor Azure VPN Gateway](/azure/vpn-gateway/monitor-vpn-gateway) and [VPN Gateway monitoring data reference](/azure/vpn-gateway/monitor-vpn-gateway-reference).
- **Packet capture.** Use the built-in packet capture capability with five-tuple filters to scope captures during connectivity or security investigations rather than capturing all traffic. For more information, see [Configure packet capture for VPN gateways](/azure/vpn-gateway/packet-capture).
- **Change management.** Treat gateway SKU changes, IPsec/IKE policy changes, BGP configuration changes, and shared-key rotations as disruptive operations. Roll them out to non-production first, schedule a change window for production, define a rollback path before the change, and validate tunnel state, BGP peering, and end-to-end reachability after the change. Coordinate shared-key rotations end to end: rotate in Key Vault, update the connection resource, update the on-premises device, and verify tunnel re-establishment before declaring the rotation complete.
- **On-premises device parity.** You must configure the on-premises VPN device with cryptographic parameters, BGP timers, and traffic selectors that match the Azure side. Mismatches are a common cause of tunnel instability. For example, BGP keepalive and hold timers on Azure are fixed at 60 and 180 seconds. For more information, see [VPN Gateway FAQ](/azure/vpn-gateway/vpn-gateway-vpn-faq) and the [validated VPN devices list](/azure/vpn-gateway/vpn-gateway-about-vpn-devices).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **SKU throughput.** Each gateway SKU has a published aggregate throughput target and tunnel limit. The aggregate throughput is shared across all tunnels on the gateway, so a single tunnel doesn't achieve the SKU's full headline value when other tunnels are active. Plan SKU selection against measured per-tunnel demand and total tunnel count. For the values that each SKU offers, see [About gateway SKUs](/azure/vpn-gateway/about-gateway-skus).
- **Internet path variability.** Throughput across an IPsec tunnel over the public internet is bounded by the slowest segment between the on-premises device and the Azure gateway, including ISP capacity, packet loss, latency, and MTU. Measured throughput typically falls below the SKU's headline number for this reason. When predictable performance is required, evaluate [ExpressRoute](/azure/expressroute/expressroute-introduction) as the primary path and VPN as a backup.
- **MTU and fragmentation.** IPsec encapsulation reduces the effective MTU of the tunnel. When PMTU discovery is blocked between the on-premises device and Azure, oversized packets are silently dropped and throughput collapses for affected flows. Apply TCP MSS clamping on the on-premises VPN device and follow the Azure MTU guidance for VPN tunnels. For more information, see [About VPN devices and IPsec/IKE parameters](/azure/vpn-gateway/vpn-gateway-about-vpn-devices).
- **Active-active capacity.** Active-active mode lets both gateway VMs forward traffic concurrently and can distribute aggregate traffic across multiple tunnels. Per-flow throughput is still bounded by a single tunnel because IPsec flows don't split across tunnels mid-stream. A single TCP flow within a tunnel can be further bounded by the processing capacity of a single CPU core on the gateway VM, which is why benchmarks of one large transfer can come in below the published aggregate number.
- **BGP convergence.** Enable [BGP on VPN Gateway](/azure/vpn-gateway/vpn-gateway-bgp-overview) where the on-premises device supports it. BGP allows dynamic route exchange and speeds up failover convergence after a tunnel, gateway VM, or on-premises device failure, as compared with static routing.
- **Gateway placement.** Latency is dominated by the geographic distance between the on-premises device and the Azure region that hosts the gateway. Deploy the gateway in the Azure region closest to the workloads and on-premises sites it serves, and use additional regional gateways rather than backhauling all traffic through a distant gateway.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

**Principal author:**

- [Cynthia Treger](https://www.linkedin.com/in/cynthia-treger-6663402/) | Solution Engineer Global Black Belt

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For step-by-step deployment guidance and more background on the services in this architecture, see the following resources.

**Product documentation:**

- [Azure VPN Gateway documentation](/azure/vpn-gateway/)
- [Azure security baseline for Azure VPN Gateway](/security/benchmark/azure/baselines/vpn-gateway-security-baseline)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Azure networking blog](https://azure.microsoft.com/blog/category/networking/)

**Deployment and configuration guides:**

- [Tutorial: Create a site-to-site VPN connection in the Azure portal](/azure/vpn-gateway/tutorial-site-to-site-portal)
- [Configure ExpressRoute and site-to-site coexisting connections by using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager)

## Related resources

For broader hybrid networking context, see the following resources. Topics include comparing connectivity options, designing the topology that hosts the VPN gateway, and securing the resulting hybrid perimeter.

- [Hybrid architecture design](/azure/architecture/hybrid/hybrid-start-here)
- [Azure hybrid options](/azure/architecture/guide/technology-choices/hybrid-considerations)
- [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke)
- [Connect an on-premises network to Azure](/azure/architecture/reference-architectures/hybrid-networking/hybrid-connectivity-options)
- [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz)