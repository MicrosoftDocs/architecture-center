

This article compares three options for connecting an on-premises network to an Azure Virtual Network (VNet). For each option, a more detailed reference architecture is available.

## VPN connection

A [VPN gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location. The encrypted traffic goes over the public Internet.

This architecture is suitable for hybrid applications where the traffic between on-premises hardware and the cloud is likely to be light, or you're willing to trade slightly extended latency for the flexibility and processing power of the cloud.

:::image type="content" source="./images/vpn-gateway-multisite-connection-diagram.svg" alt-text="Diagram of a VPN gateway." lightbox="./images/vpn-gateway-multisite-connection-diagram.svg" :::

*Download a [Visio file](https://arch-center.azureedge.net/hybrid-networking-connect-to-azure.vsdx) of this diagram.*

### Benefits

- Simple to configure.
- Much higher aggregate bandwidth available; up to 10 Gbps depending on the VPN Gateway SKU.

### Challenges

- Requires an on-premises VPN device.
- Although Microsoft guarantees 99.9% availability for each VPN Gateway, this [SLA](https://azure.microsoft.com/support/legal/sla/vpn-gateway/) only covers the VPN gateway, and not your network connection to the gateway.

### Reference architecture

- [Hybrid network with VPN gateway](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz)

<!-- markdownlint-disable MD024 -->

## Azure ExpressRoute connection

[ExpressRoute](/azure/expressroute/) connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure.

This architecture is suitable for hybrid applications running large-scale, mission-critical workloads that require a high degree of scalability.

:::image type="content" source="./images/expressroute-connection-overview.svg" alt-text="Diagram of a VPN gateway." lightbox="./images/expressroute-connection-overview.svg" :::

*Download a [Visio file](https://arch-center.azureedge.net/hybrid-networking-connect-to-azure.vsdx) of this diagram.*

> [!NOTE]
> In the context of ExpressRoute, the Microsoft edge describes the edge routers on the Microsoft side of the ExpressRoute circuit. This is the ExpressRoute circuit's point of entry into Microsoft's network.
> 

### Benefits

- Much higher bandwidth available; up to 10 Gbps depending on the connectivity provider.
- Lower and more consistent latencies compared to typical connections over the Internet.
- Supports dynamic scaling of bandwidth to help reduce costs during periods of lower demand. However, not all connectivity providers have this option.
- May allow your organization direct access to national clouds, depending on the connectivity provider.
- 99.9% availability SLA across the entire connection.

### Challenges

- Can be complex to set up. Creating an ExpressRoute connection requires working with a third-party connectivity provider. The provider is responsible for provisioning the network connection.
- Requires high-bandwidth routers on-premises.

### Reference architecture

- [Hybrid network with ExpressRoute](./expressroute.yml)

## ExpressRoute with VPN failover

This option combines the previous two, using ExpressRoute in normal conditions, but failing over to a VPN connection if there's a loss of connectivity in the ExpressRoute circuit.

This architecture is suitable for hybrid applications that need the higher bandwidth of ExpressRoute, and also require highly available network connectivity.

### Benefits

- High availability if the ExpressRoute circuit fails, although the fallback connection is on a lower bandwidth network.

### Challenges

- Complex to configure. You need to set up both a VPN connection and an ExpressRoute circuit.
- Requires redundant hardware (VPN appliances), and a redundant Azure VPN Gateway connection for which you pay charges.

### Reference architecture

- [Hybrid network with ExpressRoute and VPN failover](./expressroute-vpn-failover.yml)

<!-- markdownlint-disable MD024 -->

### Reference architectures

- [Hub-spoke topology](./hub-spoke.yml)
