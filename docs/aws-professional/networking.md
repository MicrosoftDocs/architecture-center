---
title: Compare AWS and Azure Networking Options
description: Compare the networking options of Azure and AWS. The comparisons cover cloud virtual networking, cross-premises connectivity, DNS management, and more.
author: splitfinity81
ms.author: yubaijna
ms.date: 05/11/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare AWS and Azure networking options

This article compares the core networking services that Azure and Amazon Web Services (AWS) offer.

For links to articles that compare other AWS and Azure services and a complete service mapping between AWS and Azure, see [Azure for AWS professionals](/azure/architecture/aws-professional/).

## Azure virtual networks and AWS VPCs

Azure virtual networks and AWS virtual private clouds (VPCs) are similar in that they both provide isolated, logically defined network spaces within their respective cloud platforms. There are, however, key differences in terms of architecture, features, and integration.

- **Subnet placement.** In AWS, each subnet is bound to a single Availability Zone, so achieving zonal redundancy requires creating one subnet per Availability Zone. In Azure, a subnet is a regional construct that spans all availability zones in the region. Resources deployed into the same subnet can reside in different availability zones and use the same subnet CIDR or address space. If you redeploy or move a given resource into a different availability zone, the resource's private IP address might or might not be preserved, depending on the resource type and how you redeploy or move it.

- **Security models.** AWS layers stateful security groups (attached to ENIs) with stateless network ACLs (applied at the subnet boundary). Azure uses stateful network security groups (NSGs), which can be applied at the subnet or NIC level, and [application security groups](/azure/virtual-network/application-security-groups), which you can use to create NSG rules by using logical workload tags instead of IP ranges. The latter approach is conceptually similar to AWS security groups that reference other security groups. For deeper inspection, [Azure Firewall](/azure/firewall/overview) provides a managed, stateful, cloud-native firewall with FQDN filtering, threat intelligence, and optional IDPS/TLS inspection, similar to AWS Network Firewall.

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

AWS route tables contain routes that direct traffic from a subnet or gateway subnet to the destination. In Azure, the corresponding feature is called user-defined routes.

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
| NAT gateways | [AWS NAT gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) | [Azure NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview) |These services simplify outbound-only Internet connectivity for virtual networks. On a subnet, you can configure all outbound connectivity to use static public IP addresses that you specify. Outbound connectivity is possible without a load balancer or public IP addresses directly attached to virtual machines. AWS NAT gateways can be associated with only a single public IP. Azure NAT gateways can have multiple public IPs. |
| Cross-premises connectivity | [Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html) | [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) |AWS Site-to-Site VPN and Azure VPN Gateway provide enhanced-security, reliable VPN connections with high availability and support for industry-standard protocols. The key differences are in their integration with other cloud services and in specific features like route-based and policy-based VPNs in Azure. AWS VPN provides a maximum of 5-Gbps throughput, whereas Azure provides up to 10 Gbps. |
| DNS management | [Route 53](https://aws.amazon.com/route53) | [Azure DNS](https://azure.microsoft.com/services/dns/) | Azure DNS lets you manage your DNS records by using the same credentials and billing and support contract that you use for your other Azure services. Both services support [DNSSEC](/azure/dns/dnssec). |
| DNS-based routing | [Route 53](https://aws.amazon.com/route53) | [Traffic Manager](https://azure.microsoft.com/services/traffic-manager) | These services host domain names, route users to internet applications, connect user requests to datacenters, manage traffic to apps, and improve app availability with automatic failover. |
| Dedicated network | [Direct Connect](https://aws.amazon.com/directconnect) | [ExpressRoute](https://azure.microsoft.com/services/expressroute) | These services establish a dedicated, private network connection from a location to the cloud provider (not over the internet). |
| Load balancing | [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) | [Load Balancer](https://azure.microsoft.com/services/load-balancer)  | Azure Load Balancer load balances traffic at layer 4 (TCP or UDP). Load Balancer also supports cross-subscription and global load balancing. |
| Application-level load balancing |  [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) | [Application Gateway](https://azure.microsoft.com/services/application-gateway) | Application Gateway is a layer 7 load balancer. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. It also provides multi-site routing and security features. |
| Route tables | [Custom Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) | [User Defined Routes](/azure/virtual-network/virtual-networks-udr-overview) | These tables provide custom or user-defined (static) routes to override default system routes, or to add more routes to a subnet's route table. |
| Private link | [PrivateLink](https://aws.amazon.com/privatelink) | [Azure Private Link](https://azure.microsoft.com/services/private-link) | Azure Private Link provides private access to services that are hosted on the Azure platform. This keeps your data on the Microsoft network. |
| Private PaaS connectivity | [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html) | [Private Endpoint](/azure/private-link/private-endpoint-overview) | Private Endpoint provides secured, private connectivity to various Azure platform as a service (PaaS) resources, over a backbone Microsoft private network. |
| Virtual network peering | [VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) | [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) | Virtual network peering is a mechanism that connects two virtual networks in the same region through the Azure backbone network. After they're peered, the two virtual networks appear as one for all connectivity purposes. |
| Content delivery networks | [CloudFront](https://aws.amazon.com/cloudfront) | [Azure Front Door](https://azure.microsoft.com/services/frontdoor) | Azure Front Door is a modern cloud content delivery network (CDN) service that provides high performance, scalability, and secure user experiences for your content and applications. |
| Network monitoring | [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) | [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Azure Network Watcher allows you to monitor, diagnose, and analyze the traffic in Azure Virtual Network. |
| Network security | [Security groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) | [Network security groups](/azure/virtual-network/network-security-groups-overview) | These controls filter network traffic to and from resources in virtual network subnets. |
| Hub-and-spoke and global network hub | [AWS Transit Gateway](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-transit-gateways.html) | [Azure Virtual WAN](/azure/virtual-wan/) | These services centralize network connectivity across many VPCs and virtual networks, on-premises sites, and remote users via a managed transit hub. Virtual WAN integrates natively with Azure Firewall, Azure DDoS Protection, and secure SD-WAN partners. AWS Transit Gateway supports up to 100 Border Gateway Protocol (BGP) prefixes per attachment. Virtual WAN private peering supports 1,000 BGP prefixes. |
| Global traffic acceleration (anycast on backbone) | [AWS Global Accelerator](https://aws.amazon.com/global-accelerator/) | [Azure Front Door](/azure/frontdoor/front-door-overview) / [Azure cross-region load balancer](/azure/load-balancer/cross-region-overview) | These services provide global anycast entry points on the provider's backbone network to improve application performance and availability across regions. Azure Front Door operates at layer 7 (HTTP/HTTPS) with integrated CDN and WAF. Azure cross-region Load Balancer operates at layer 4 for TCP/UDP, which closely matches AWS Global Accelerator's layer-4 behavior. Traffic Manager is DNS-based and is compared separately under DNS-based routing. |
| Cross-premises connectivity | [AWS Direct Connect gateways](https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways-intro.html) | [Azure ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) | These services extend your on-premises networks to the cloud with dedicated private connections that span multiple regions. |
| Cross-VPC/virtual network application networking | [Amazon VPC Lattice](https://aws.amazon.com/vpc/lattice/) | No single equivalent. Use a combination of [Azure Private Link](/azure/private-link/private-link-overview), [Application Gateway for Containers](/azure/application-gateway/for-containers/overview), and [Azure API Management](/azure/api-management/api-management-key-concepts), depending on the scenario. | VPC Lattice is a regional, managed application-layer networking service that provides identity-aware, cross-VPC service-to-service connectivity. Azure addresses these scenarios with multiple services: Private Link for private PaaS and customer-service access across virtual networks, Application Gateway for Containers for AKS-native L7 routing, and API Management for centralized service exposure and policy. |
| Service discovery | [AWS Cloud Map](https://docs.aws.amazon.com/cloud-map/latest/dg/what-is-cloud-map.html) | Built-in service discovery in [AKS](/azure/aks/concepts-network) (CoreDNS) / [Azure Container Apps](/azure/container-apps/networking) / [Azure Service Fabric naming service](/azure/service-fabric/service-fabric-service-manifest-resources) | AWS Cloud Map is a service registry that tracks dynamic application instances and exposes them via DNS or API. Azure provides equivalent functionality via platform-specific service discovery: CoreDNS in AKS, built-in name resolution in Container Apps, and the naming service in Service Fabric. Azure Private DNS, by contrast, is a managed DNS zone service for resolving custom domains inside a virtual network. |
| Managed firewall | [AWS Network Firewall](https://aws.amazon.com/network-firewall/) | [Azure Firewall](/azure/firewall/overview) | These services provide managed, stateful, cloud-native firewall services for virtual networks. Both support traffic inspection with Suricata-compatible rules (AWS) or built-in threat intelligence (Azure), FQDN filtering, and centralized policy management. Azure Firewall is available in Standard, Premium (TLS inspection, IDPS), and Basic tiers. |
| Web application firewall | [AWS WAF](https://aws.amazon.com/waf/) | [Azure Web Application Firewall](/azure/web-application-firewall/overview) (on Application Gateway or Azure Front Door) | Layer 7 protection against common web exploits (OWASP Top 10, SQL injection, XSS). Both services support managed rule sets, custom rules, rate limiting, and bot protection. Azure Web Application Firewall is deployed as a feature of Application Gateway (regional) or Azure Front Door (global). |
| DDoS protection | [AWS Shield Standard and AWS Shield Advanced](https://aws.amazon.com/shield/) | [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) (Network Protection or IP Protection) / Azure basic infrastructure DDoS protection | These services provide protection against volumetric, protocol, and application-layer distributed denial of service (DDoS) attacks. Both platforms provide a free baseline tier (AWS Shield Standard or Azure basic infrastructure DDoS) that's enabled by default, and a paid advanced tier with detailed telemetry, attack analytics, cost protection, and access to a rapid response team. |
| Secure VM remote access | [AWS Systems Manager Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html) / [EC2 Instance Connect Endpoint](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-using-eice.html) | [Azure Bastion](/azure/bastion/bastion-overview) | These services provide secure RDP and SSH connectivity to virtual machines without exposing public IP addresses or opening inbound ports. Azure Bastion is a fully managed PaaS service that's deployed inside a virtual network. |

### Networking architectures

| Architecture | Description |
|----|----|
| [Deploy highly available NVAs](/azure/architecture/networking/guide/network-virtual-appliance-high-availability) | Learn how to deploy network virtual appliances for high availability in Azure. This article includes example architectures for ingress, egress, and both. |
| [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke) | Learn how to implement a hub-spoke topology in Azure, where the hub is a virtual network and the spokes are virtual networks that peer with the hub. |
| [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz) | Learn how to implement a secure hybrid network that extends an on-premises network to Azure with a perimeter network between the on-premises network and an Azure virtual network. |

[View all networking architectures.](/azure/architecture/browse/?terms=networking)

## Migration

If you plan to migrate an AWS workload to Azure, see [Migrate networking from Amazon Web Services to Azure](/azure/migration/migrate-networking-from-aws), which includes some specific [example migration scenarios](/azure/migration/migrate-networking-from-aws#migration-scenarios) that might align to your use case.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Konstantin Rekatas](https://www.linkedin.com/in/krekatas/) | Principal Cloud Solution Architect

Other contributors:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | Director, Partner Technology Strategist
- [Juan Carlos Osorio](https://www.linkedin.com/in/juan-carlos-osorio-6252bba7/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Create a virtual network by using the Azure portal](/azure/virtual-network/quick-create-portal)
- [Plan and design Azure virtual networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)
- [Azure network security best practices](/azure/security/fundamentals/network-best-practices)

## Related resources

- [Compare AWS and Azure resource management](resources.md)
- [Compare AWS and Azure accounts](accounts.md)
