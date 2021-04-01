---
author: doodlemania2
ms.author: adboegli
ms.topic: include
ms.service: architecture-center
---

| Area | AWS service | Azure service | Description |
| -----| ----------- | ------------- | ----------- |
| Cloud virtual networking | [Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc/) | [Virtual Network](https://azure.microsoft.com/services/virtual-network/) | Provides an isolated, private environment in the cloud. Users have control over their virtual networking environment, including selection of their own IP address range, creation of subnets, and configuration of route tables and network gateways. |
| Cross-premises connectivity | [VPN Gateway](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html) | [VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways) |Connects Azure virtual networks to other Azure virtual networks, or customer on-premises networks (Site To Site). Allows end users to connect to Azure services through VPN tunneling (Point To Site). |
| DNS management | [Route 53](https://aws.amazon.com/route53/) | [DNS](https://azure.microsoft.com/services/dns/) | Manage your DNS records using the same credentials and billing and support contract as your other Azure services |
| &nbsp; | [53](https://aws.amazon.com/route53/) | [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) | A service that hosts domain names, plus routes users to Internet applications, connects user requests to datacenters, manages traffic to apps, and improves app availability with automatic failover. |
Dedicated network | [Direct Connect](https://aws.amazon.com/directconnect/) | [ExpressRoute](https://azure.microsoft.com/services/expressroute/) | Establishes a dedicated, private network connection from a location to the cloud provider (not over the Internet). |
| Load balancing | [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) | [Load Balancer](https://azure.microsoft.com/services/load-balancer/)  | Azure Load Balancer load balances traffic at layer 4 (TCP or UDP). Standard Load Balancer also supports cross-region or global load balancing. |
| &nbsp; |  [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) | [Application Gateway](https://azure.microsoft.com/services/application-gateway/) | Application Gateway is a layer 7 load balancer. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. |

### Networking architectures

<ul class="grid">

[!INCLUDE [Deploy highly available NVAs](../../includes/cards/nva-ha.md)]
[!INCLUDE [Hub-spoke network topology in Azure](../../includes/cards/hub-spoke.md)]
[!INCLUDE [Implement a secure hybrid network](../../includes/cards/secure-vnet-dmz.md)]

</ul>

[view all](/azure/architecture/browse/#networking)
