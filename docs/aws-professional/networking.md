---
title: Compare AWS and Azure Networking Options
description: Compare the networking options of Azure and AWS. The comparisons cover cloud virtual networking, cross-premises connectivity, DNS management, and more.
author: scaryghosts
categories: azure
ms.author: adamcerini
ms.date: 01/02/2025
ms.topic: conceptual
ms.subservice: cloud-fundamentals
azureCategories:
  - compute
  - networking
products:
  - azure-load-balancer
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

Both AWS Site-to-Site VPN and Azure VPN Gateway are robust solutions for connecting on-premises networks to the cloud. They provide similar features, but there's a notable difference:

 - **Performance.** VPN Gateway offers higher throughput for certain configurations (up to 10 Gbps), whereas Site-to-Site VPN generally ranges between 1.25 Gbps and 5 Gbps per connection (using ECMP).

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

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

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