---
title: Compare AWS and Azure networking options
description: Compare networking options between Azure and AWS. The comparisons cover cloud virtual networking, cross-premises connectivity, DNS management, and more.
author: vaboya
categories: azure
ms.author: johanv
ms.date: 11/25/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
azureCategories:
  - compute
  - networking
products:
  - azure-load-balancer
---

This article compares the core networking services Microsoft Azure and Amazon Web Services (AWS) offer.

- For links to articles that compare other AWS and Azure services, see [Azure for AWS professionals](/azure/architecture/aws-professional/).
- For a complete listing and charts showing service mapping between AWS and Azure, see [AWS to Azure services comparison](/azure/architecture/aws-professional/services).



## Virtual Networks, Azure VNets and AWS VPCs
Azure Virtual Networks (VNets) and AWS Virtual Private Clouds (VPCs) are similar in that they both provide isolated, logically defined network spaces within their respective cloud platforms. However, there are key differences in terms of architecture, features, and integration. 

- **Subnet Placement:** AWS subnets are tied to Availability Zones, whereas Azure subnets are region-specific without AZ constraints. This allows resources to switch between Availability Zones without changing the IP addresses
- **Security Models:** AWS uses both Security Groups (stateful) and Network Access Control Lists (stateless), while Azure relies on Network Security Groups (Stateful).
- **Peering:** Both Azure and AWS support VNet/VPC peering. Both technologies allow more complex peering through the use of Azure WAN or AWS Transit Gateway.

## VPN
Both AWS Site-to-Site VPN and Azure VPN Gateway are robust solutions for connecting on-premises networks to the cloud. They are similar in features with a notable difference:
 - **Performance:** Azure VPN Gateway offers higher throughput for certain configurations (up to 10 Gbps), whereas AWS Site-to-Site VPN generally ranges between 1.25 - 5 Gbps per connection using ECMP.

## Elastic Load Balancing, Azure Load Balancer, and Azure Application Gateway
The Azure equivalent of the Elastic Load Balancing services are:
- **Load Balancer:** Provides the same network layer 4 capabilities as the AWS Network Load Balancer, allowing you to distribute traffic for multiple VMs at the network level. It also provides a failover capability.
-	**Application Gateway:** Offers application-level rule-based routing comparable to the AWS Application Load Balancer.

## Route 53, Azure DNS, and Azure Traffic Manager
In AWS, Route 53 provides both DNS name management and DNS-level traffic routing and failover services. In Azure this is handled through two services:
-	Azure DNS provides domain and DNS management.
-	Traffic Manager provides DNS level traffic routing, load balancing, and failover capabilities.

## Direct connect and Azure ExpressRoute
Azure provides similar site-to-site dedicated connections through its ExpressRoute service. ExpressRoute allows you to connect your local network directly to Azure resources using a dedicated private network connection. Both Azure and AWS offer site-to-site VPN connections. 

## Route tables
AWS provides route tables that contain routes to direct traffic, from a subnet/gateway subnet to the destination. In Azure, this feature is called user-defined routes (UDRs).
With user-defined routes, you can create custom or user-defined (static) routes in Azure, to override the Azure default system routes, or to add more routes to a subnet's route table.

## Private Link
Similar to AWS PrivateLink, Azure Private Link provides private connectivity from a virtual network to an Azure platform as a service (PaaS) solution, a customer-owned service, or a Microsoft partner service.

## VPC peering, VNet peering in Azure
In AWS, a VPC peering connection is a networking connection between two VPCs, which enables you to route traffic between them using private Internet Protocol version 4 (IPv4) addresses or Internet Protocol version 6 (IPv6) addresses.

*Azure virtual network (VNet) peering enables you to seamlessly connect two or more Virtual Networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Like traffic between virtual machines in the same network, traffic is routed through Microsoft's private network only.
Neither VNets or VPCs allow transitive peering, however in Azure you can achieve transitive networking by using NVAs (Network Virtual Appliances) or gateways in the hub virtual network


## Network service comparison

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

## See also

- [Create a virtual network using the Azure portal](/azure/virtual-network/quick-create-portal)

- [Plan and design Azure Virtual Networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)

- [Azure Network Security Best Practices](/azure/security/fundamentals/network-best-practices)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Konstantin Rekatas](https://www.linkedin.com/in/krekatas/)

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini)

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps
## Related resources