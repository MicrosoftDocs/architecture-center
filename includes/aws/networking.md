---
author: kobile70
ms.author: vaboya
ms.topic: include
ms.service: architecture-center
---

| Area | AWS service | Azure service | Description |
| -----| ----------- | ------------- | ----------- |
| Cloud virtual networking | [Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc) | [Virtual Network](https://azure.microsoft.com/services/virtual-network) | Provides an isolated, private environment in the cloud. Users have control over their virtual networking environment, including selection of their own IP address range, creation of subnets, and configuration of route tables and network gateways. |
| NAT gateways | [NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) | [Virtual Network NAT](/azure/virtual-network/nat-gateway/nat-overview) | A service that simplifies outbound-only Internet connectivity for virtual networks. When configured on a subnet, all outbound connectivity uses your specified static public IP addresses. Outbound connectivity is possible without a load balancer or public IP addresses directly attached to virtual machines. |
| Cross-premises connectivity | [VPN Gateway](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html) | [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) |Connects Azure virtual networks to other Azure virtual networks, or customer on-premises networks (Site To Site). Allows end users to connect to Azure services through VPN tunneling (Point To Site). |
| DNS management | [Route 53](https://aws.amazon.com/route53) | [DNS](https://azure.microsoft.com/services/dns/) | Manage your DNS records using the same credentials and billing and support contract as your other Azure services |
| DNS-based routing | [Route 53](https://aws.amazon.com/route53) | [Traffic Manager](https://azure.microsoft.com/services/traffic-manager) | A service that hosts domain names, plus routes users to Internet applications, connects user requests to datacenters, manages traffic to apps, and improves app availability with automatic failover. |
Dedicated network | [Direct Connect](https://aws.amazon.com/directconnect) | [ExpressRoute](https://azure.microsoft.com/services/expressroute) | Establishes a dedicated, private network connection from a location to the cloud provider (not over the Internet). |
| Load balancing | [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) | [Load Balancer](https://azure.microsoft.com/services/load-balancer)  | Azure Load Balancer load balances traffic at layer 4 (TCP or UDP). Standard Load Balancer also supports cross-region or global load balancing. |
| Application-level load balancing |  [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) | [Application Gateway](https://azure.microsoft.com/services/application-gateway) | Application Gateway is a layer 7 load balancer. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. |
| Route table | [Custom Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) | [User Defined Routes](/azure/virtual-network/virtual-networks-udr-overview) | Custom, or user-defined (static) routes to override default system routes, or to add more routes to a subnet's route table. |
| Private link | [PrivateLink](https://aws.amazon.com/privatelink) | [Azure Private Link](https://azure.microsoft.com/services/private-link) | Azure Private Link provides private access to services that are hosted on the Azure platform. This keeps your data on the Microsoft network. |
| Private PaaS connectivity |  [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html) | [Private Endpoint](/azure/private-link/private-endpoint-overview) | Private Endpoint provides secured, private connectivity to various Azure platform as a service (PaaS) resources, over a backbone Microsoft private network. |
| Virtual network peering | [VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) | [VNET Peering](https://azure.microsoft.com/resources/videos/virtual-network-vnet-peering) | VNet peering is a mechanism that connects two virtual networks (VNets) in the same region through the Azure backbone network. Once peered, the two virtual networks appear as one for all connectivity purposes. |
| Content delivery networks | [CloudFront](https://aws.amazon.com/cloudfront)| [Front Door](https://azure.microsoft.com/services/frontdoor) | Azure Front Door is a modern cloud content delivery network (CDN) service that delivers high performance, scalability, and secure user experiences for your content and applications. |
| Network Monitoring | [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) | [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Azure Network Watcher allows you to monitor, diagnose, and analyze the traffic in Azure Virtual Network. |

### Networking architectures

<ul class="grid">

[!INCLUDE [Deploy highly available NVAs](../../includes/cards/nva-ha.md)]
[!INCLUDE [Hub-spoke network topology in Azure](../../includes/cards/hub-spoke.md)]
[!INCLUDE [Implement a secure hybrid network](../../includes/cards/secure-vnet-dmz.md)]

</ul>

[view all](/azure/architecture/browse/#networking)
