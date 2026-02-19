---
title: Compare AWS and Azure Networking Options
description: Compare the networking options of Azure and AWS. The comparisons cover cloud virtual networking, cross-premises connectivity, DNS management, and more.
author: splitfinity81
ms.author: yubaijna
ms.date: 01/02/2025
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare AWS and Azure networking options

 This article compares the core networking services that Azure and Amazon Web Services (AWS) offer.

For links to articles that compare other AWS and Azure services and a complete service mapping between AWS and Azure, see [Azure for AWS professionals](/azure/architecture/aws-professional/).

## Azure virtual networks and AWS VPCs

Azure virtual networks and AWS virtual private clouds (VPCs) are similar in that they both provide isolated, logically defined network spaces within their respective cloud platforms. There are, however, key differences in terms of architecture, features, and integration.

- **Subnet placement.** AWS subnets are tied to AWS Availability Zones, whereas Azure subnets are region-specific without availability zone constraints. The Azure design allows resources to switch availability zones without changing IP addresses.
- **Security models.** AWS uses both security groups (stateful) and network access control lists (stateless). Azure uses network security groups (stateful).
- **Peering.** Both Azure and AWS support virtual network / VPC peering. Both technologies allow more complex peering via Azure Virtual WAN or AWS Transit Gateway.

## VPN

Both AWS Site-to-Site VPN and Azure VPN Gateway are robust solutions for connecting on-premises networks to the cloud. They provide similar features, but there's a notable difference with performance. VPN Gateway offers higher throughput for certain configurations (up to 10 Gbps), whereas Site-to-Site VPN generally ranges between 1.25 Gbps and 5 Gbps per connection (using ECMP).

## Elastic Load Balancing, Azure Load Balancer, and Azure Application Gateway

The Azure equivalents of the Elastic Load Balancing services are:

- **Load Balancer** provides the same network layer 4 capabilities as the AWS Network Load Balancer, so you can distribute traffic for multiple VMs at the network level. It also provides failover capability.
- **Application Gateway** provides application-level rule-based routing comparable to that of the AWS Application Load Balancer.

## Route 53, Azure DNS, and Azure Traffic Manager

In AWS, Route 53 provides both DNS name management and DNS-level traffic routing and failover services. In Azure, two services handle these tasks:

- **Azure DNS** provides domain and DNS management.
- **Traffic Manager** provides DNS-level traffic routing, load balancing, and failover capabilities.

## AWS Direct Connect and Azure ExpressRoute

AWS Direct Connect can link a network directly to AWS. Azure provides similar site-to-site dedicated connections through ExpressRoute. You can use ExpressRoute to connect your local network directly to Azure resources by using a dedicated private network connection. Both Azure and AWS offer site-to-site VPN connections.

## Route tables

AWS provides route tables that contain routes that direct traffic from a subnet or gateway subnet to the destination. In Azure, the corresponding feature is called user-defined routes (UDRs).

With user-defined routes, you can create custom or user-defined (static) routes. These routes override the default Azure system routes. You can also add more routes to a subnet's route table.

## Azure Private Link

Private Link is similar to AWS PrivateLink. Azure Private Link provides private connectivity from a virtual network to an Azure platform as a service (PaaS) solution, a customer-owned service, or a Microsoft partner service.

## VPC peering and virtual network peering

In AWS, a VPC peering connection is a networking connection between two VPCs. You can use this connection to route traffic between the VPCs by using private Internet Protocol version 4 (IPv4) addresses or Internet Protocol version 6 (IPv6) addresses.

You can use Azure virtual network peering to connect two or more virtual networks in Azure. For connectivity purposes, the virtual networks appear as one. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Like traffic between virtual machines in a single network, traffic is routed only through the Microsoft private network.

Neither virtual networks nor VPCs allow transitive peering. In Azure, however, you can achieve transitive networking by using network virtual appliances (NVAs) or gateways in the hub virtual network.

## Network service comparison

| Area | AWS service | Azure service | Description |
| -----| ----------- | ------------- | ----------- |
| Cloud virtual networking | [Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc) | [Virtual Network](https://azure.microsoft.com/services/virtual-network) | These services provide an isolated private environment in the cloud. You have control over your virtual networking environment, including the selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways. In AWS, each subnet must reside in one availability zone. In Azure, subnets can span multiple availability zones. |
| NAT gateways | [AWS NAT gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) | [Azure NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview) |These services simplify outbound-only Internet connectivity for virtual networks. On a subnet, you can configure all outbound connectivity to use static public IP addresses that you specify. Outbound connectivity is possible without a load balancer or public IP addresses directly attached to virtual machines. AWS NAT gateways can only be associated with a single public IP. Azure NAT gateways can have multiple public IPs. |
| Cross-premises connectivity | [Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html) | [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) |AWS Site-to-Site VPN and Azure VPN Gateway provide enhanced-security, reliable VPN connections with high availability and support for industry-standard protocols. The key differences are in their integration with other cloud services and in specific features like route-based and policy-based VPNs in Azure. AWS VPN provides a maximum of 5 Gbps throughput, whereas Azure provides up to 10 Gbps. |
| DNS management | [Route 53](https://aws.amazon.com/route53) | [Azure DNS](https://azure.microsoft.com/services/dns/) | Azure DNS lets you manage your DNS records by using the same credentials and billing and support contract that you use for your other Azure services. Both services support [DNSSEC](/azure/dns/dnssec). |
| DNS-based routing | [Route 53](https://aws.amazon.com/route53) | [Traffic Manager](https://azure.microsoft.com/services/traffic-manager) | These services host domain names, route users to internet applications, connect user requests to datacenters, manage traffic to apps, and improve app availability with automatic failover. |
| Dedicated network | [Direct Connect](https://aws.amazon.com/directconnect) | [ExpressRoute](https://azure.microsoft.com/services/expressroute) | These services establish a dedicated, private network connection from a location to the cloud provider (not over the internet). |
| Load balancing | [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) | [Load Balancer](https://azure.microsoft.com/services/load-balancer)  | Azure Load Balancer load balances traffic at layer 4 (TCP or UDP). Standard Load Balancer also supports cross-subscription and global load balancing. |
| Application-level load balancing |  [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) | [Application Gateway](https://azure.microsoft.com/services/application-gateway) | Application Gateway is a layer 7 load balancer. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. It also provides multi-site routing and security features. |
| Route tables | [Custom Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) | [User Defined Routes](/azure/virtual-network/virtual-networks-udr-overview) | These tables provide custom or user-defined (static) routes to override default system routes, or to add more routes to a subnet's route table. |
| Private link | [PrivateLink](https://aws.amazon.com/privatelink) | [Azure Private Link](https://azure.microsoft.com/services/private-link) | Azure Private Link provides private access to services that are hosted on the Azure platform. This keeps your data on the Microsoft network. |
| Private PaaS connectivity |  [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html) | [Private Endpoint](/azure/private-link/private-endpoint-overview) | Private Endpoint provides secured, private connectivity to various Azure platform as a service (PaaS) resources, over a backbone Microsoft private network. |
| Virtual network peering | [VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) | [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) | Virtual network peering is a mechanism that connects two virtual networks in the same region through the Azure backbone network. After they're peered, the two virtual networks appear as one for all connectivity purposes. |
| Content delivery networks | [CloudFront](https://aws.amazon.com/cloudfront)| [Front Door](https://azure.microsoft.com/services/frontdoor) | Azure Front Door is a modern cloud content delivery network (CDN) service that delivers high performance, scalability, and secure user experiences for your content and applications. |
| Network monitoring | [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) | [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Azure Network Watcher allows you to monitor, diagnose, and analyze the traffic in Azure Virtual Network. |
| Network security | [Security groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) | [Network security groups](/azure/virtual-network/network-security-groups-overview) | These controls filter network traffic to and from resources in a virtual network subnets. |
| Virtual network peering | [AWS transit gateways](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-transit-gateways.html) | [Azure Virtual WAN](/azure/virtual-wan/) | These services simplify and enhance network connectivity across multiple environments to support scalable and flexible network architectures. Virtual WAN integrates with Azure Firewall and Azure DDoS Protection to provide additional security features. AWS transit gateways rely on AWS security services like AWS Shield and AWS WAF. Virtual WAN is designed for global connectivity, so it's easier to connect branch offices and remote users worldwide. AWS transit gateways support 100 BGP prefixes per private connection. Virtual WAN private peering supports 1,000 BGP prefixes. |
| Cloud virtual networking | [AWS Global Accelerator](https://aws.amazon.com/global-accelerator/) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | These services improve the availability and performance of your applications with global routing and traffic management. |
| Cross-premises connectivity | [AWS Direct Connect gateways](https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways-intro.html) | [Azure ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) | These services extend your on-premises networks to the cloud with dedicated private connections that span multiple regions. |
| Application-level networking | [AWS App Mesh](https://docs.aws.amazon.com/app-mesh/latest/userguide/what-is-app-mesh.html) | [Azure Kubernetes Service](/azure/aks/) | These services provide application-level networking to manage microservices, including service discovery, load balancing, and traffic routing. |
| Service discovery | [AWS Cloud Map](https://docs.aws.amazon.com/cloud-map/latest/dg/what-is-cloud-map.html) | [Azure Private DNS](/azure/dns/private-dns-overview) | These services provide service discovery for cloud resources. They enable you to register application resources and dynamically update their locations. |

### Networking architectures

| Architecture | Description |
|----|----|
| [Deploy highly available NVAs](/azure/architecture/networking/guide/network-virtual-appliance-high-availability) | Learn how to deploy network virtual appliances for high availability in Azure. This article includes example architectures for ingress, egress, and both. |
| [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke) | Learn how to implement a hub-spoke topology in Azure, where the hub is a virtual network and the spokes are virtual networks that peer with the hub. |
| [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz) | See a secure hybrid network that extends an on-premises network to Azure with a perimeter network between the on-premises network and an Azure virtual network. |

[View all networking architectures.](/azure/architecture/browse/?terms=networking)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Konstantin Rekatas](https://www.linkedin.com/in/krekatas/) | Principal Cloud Solution Architect

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | 
Director, Partner Technology Strategist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Create a virtual network using the Azure portal](/azure/virtual-network/quick-create-portal)
- [Plan and design Azure virtual networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)
- [Azure network security best practices](/azure/security/fundamentals/network-best-practices)

## Related resources

- [Compare AWS and Azure resource management](resources.md)
- [Compare AWS and Azure accounts](accounts.md)
