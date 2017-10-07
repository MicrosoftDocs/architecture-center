---
title: Choose a solution for connecting an on-premises network to Azure
description: Compares reference architectures for connecting an on-premises network to Azure.
author: telmosampaio
ms.date: 04/06/2017
---

# Choose a solution for connecting an on-premises network to Azure

This article compares options for connecting an on-premises network to an Azure Virtual Network (VNet). We provide a reference architecture and a deployable solution for each option.

## VPN connection

Use a virtual private network (VPN) to connect your on-premises network with an Azure VNet through an IPSec VPN tunnel.

This architecture is suitable for hybrid applications where the traffic between on-premises hardware and the cloud is likely to be light, or you are willing to trade slightly extended latency for the flexibility and processing power of the cloud.

**Benefits**

- Simple to configure.

**Challenges**

- Requires an on-premises VPN device.
- Although Microsoft guarantees 99.9% availability for each VPN Gateway, this SLA only covers the VPN gateway, and not your network connection to the gateway.
- A VPN connection over Azure VPN Gateway currently supports a maximum of 200 Mbps bandwidth. You may need to partition your Azure virtual network across multiple VPN connections if you expect to exceed this throughput.

**[Read more...][vpn]**

## Azure ExpressRoute connection

ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure. 

This architecture is suitable for hybrid applications running large-scale, mission-critical workloads that require a high degree of scalability. 

**Benefits**

- Much higher bandwidth available; up to 10 Gbps depending on the connectivity provider.
- Supports dynamic scaling of bandwidth to help reduce costs during periods of lower demand. However, not all connectivity providers have this option.
- May allow your organization direct access to national clouds, depending on the connectivity provider.
- 99.9% availability SLA across the entire connection.

**Challenges**

- Can be complex to set up. Creating an ExpressRoute connection requires working with a third-party connectivity provider. The provider is responsible for provisioning the network connection.
- Requires high-bandwidth routers on-premises.

**[Read more...][expressroute]**

## ExpressRoute with VPN failover

This options combines the previous two, using ExpressRoute in normal conditions, but failing over to a VPN connection if there is a loss of connectivity in the ExpressRoute circuit.

This architecture is suitable for hybrid applications that need the higher bandwidth of ExpressRoute, and also require highly available network connectivity. 

**Benefits**

- High availability if the ExpressRoute circuit fails, although the fallback connection is on a lower bandwidth network.

**Challenges**

- Complex to configure. You need to set up both a VPN connection and an ExpressRoute circuit.
- Requires redundant hardware (VPN appliances), and a redundant Azure VPN Gateway connection for which you pay charges.

**[Read more...][expressroute-vpn-failover]**

<!-- links -->
[expressroute]: ./expressroute.md
[expressroute-vpn-failover]: ./expressroute-vpn-failover.md
[vpn]: ./vpn.md