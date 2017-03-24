---
title: Choose a solution for connecting an on-premises network to Azure
description: How to choose a solution for connecting an on-premises network to Azure.
author: telmosampaio
ms.author: pnp
ms.date: 02/21/2017
ms.topic: article
ms.service: guidance
---

# Choose a solution for connecting an on-premises network to Azure

This article compares solutions for connecting an on-premises network to an Azure Virtual Network (VNet), including benefits and considerations. We provide a reference architecture and a deployable solution for each option.

## Virtual private network (VPN) connection

Traffic flows between your on-premises network and an Azure VNet through an IPSec VPN tunnel.

[![VPN](./images/vpn.svg)][vpn]

This architecture is suitable for hybrid applications where the traffic between on-premises hardware and the cloud is likely to be light, or you are willing to trade slightly extended latency for the flexibility and processing power of the cloud.

<table>
<thead>
<tr><th>Benefits</th><th>Considerations</th></td>
<tbody>
<tr>
    <td>
        <ul><li>Simple to configure.</li></ul>
    </td>
    <td>
        <ul>
            <li>Requires an on-premises VPN device.</li>
            <li>Although Microsoft guarantees 99.9% availability for each VPN Gateway, this SLA only covers the VPN gateway, and not your network connection to the gateway.</li>
            <li>A VPN connection over Azure VPN Gateway currently supports a maximum of 200 Mbps bandwidth. You may need to partition your Azure virtual network across multiple VPN connections if you expect to exceed this throughput.</li>
        </ul>
    </td>
</tr>
</tbody>
</table>

[Read more...][vpn]

## Azure ExpressRoute connection

ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure. 

[![ExpressRoute](./images/expressroute.svg)][expressroute]

This architecture is suitable for hybrid applications running large-scale, mission-critical workloads that require a high degree of scalability.

<table>
<thead>
<tr><th>Benefits</th><th>Considerations</th></td>
<tbody>
<tr>
    <td>
        <ul>
            <li>Much higher bandwidth available; up to 10 Gbps depending on the connectivity provider.</li>
            <li>Supports dynamic scaling of bandwidth to help reduce costs during periods of lower demand. However, not all connectivity providers have this option.</li>
            <li>May allow your organization direct access to national clouds, depending on the connectivity provider.</li>
            <li>99.9% availability SLA across the entire connection.</li>
        </ul>
    </td>
    <td>
        <ul>
            <li>Can be complex to set up. Creating an ExpressRoute connection requires working with a third-party connectivity provider. The provider is responsible for provisioning the network connection.</li>
            <li>Requires high-bandwidth routers on-premises.</li>
        </ul>
    </td>
</tr>
</tbody>
</table>

[Read more...][expressroute]

## ExpressRoute with VPN failover

[![ExpressRoute with VPN ](./images/expressroute-vpn-failover.svg)][expressroute-vpn-failover]

This architecture is suitable for hybrid applications that need the higher bandwidth of ExpressRoute, and also require highly available network connectivity.

<table>
<thead>
<tr><th>Benefits</th><th>Considerations</th></td>
<tbody>
<tr>
    <td>
        <ul>
            <li>High availability if the ExpressRoute circuit fails, although the fallback connection is on a lower bandwidth network.</li>
        </ul>
    </td>
    <td>
        <ul>
            <li>Complex to configure. You need to set up both a VPN connection and an ExpressRoute circuit.</li>
            <li>Requires redundant hardware (VPN appliances), and a redundant Azure VPN Gateway connection for which you pay charges.</li>
        </ul>
    </td>
</tr>
</tbody>
</table>

[Read more...][expressroute-vpn-failover]

<!-- links -->
[expressroute]: ./expressroute.md
[expressroute-vpn-failover]: ./expressroute-vpn-failover.md
[vpn]: ./vpn.md