---
title: Comparing AWS and Azure networking options
description: A comparison of the different networking options between Azure and AWS
author: doodlemania2
ms.date: 05/21/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
products:
  - azure-load-balancer
---

# Networking on Azure and AWS

## Elastic Load Balancing, Azure Load Balancer, and Azure Application Gateway

The Azure equivalents of the two Elastic Load Balancing services are:

- [Load Balancer](/azure/load-balancer/load-balancer-overview): provides the same capabilities as the AWS Classic Load Balancer, allowing you to distribute traffic for multiple VMs at the network level. It also provides failover capability.

- [Application Gateway](/azure/application-gateway/overview): offers application-level rule-based routing comparable to the AWS Application Load Balancer.

## Route 53, Azure DNS, and Azure Traffic Manager

In AWS, Route 53 provides both DNS name management and DNS-level traffic routing and failover services. In Azure this is handled through two services:

- [Azure DNS](https://azure.microsoft.com/documentation/services/dns) provides domain and DNS management.

- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager) provides DNS level traffic routing, load balancing, and failover capabilities.

## Direct Connect and Azure ExpressRoute

Azure provides similar site-to-site dedicated connections through its
[ExpressRoute](https://azure.microsoft.com/documentation/services/expressroute) service. ExpressRoute allows you to connect your local network directly to Azure resources using a dedicated private network connection. Azure also offers more conventional [site-to-site VPN connections](/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal) at a lower cost.

## Private Link

Simlar to AWS PrivateLink, [Azure Private Link](https://azure.microsoft.com/services/private-link) provides private connectivity from a virtual network to an Azure platform as a service (PaaS) solution, a customer-owned service, or a Microsoft partner service.

## VPC Peering, Azure VNet Peering

In AWS, a VPC peering connection is a networking connection between two VPCs, which enables you to route traffic between them using private IPv4 addresses or IPv6 addresses. 

[Azure virtual network (VNet) peering](/azure/virtual-network/virtual-network-peering-overview) enables you to seamlessly connect two or more Virtual Networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Like traffic between virtual machines in the same network, traffic is routed through Microsoft's private network only.

## Content delivery networks - CloudFront and Azure CDN

In AWS, CloudFront provides CDN services, to globally deliver data, videos, applications, and APIs. This is similar to Azure Content Delivery Network (CDN). 

[Azure CDN](https://azure.microsoft.com/services/cdn) is a feature-inclusive content delivery network bundle that is capable of handling most CDN workloads. Customers can choose to use Azure Content Delivery Network Standard from Verizon or Akamai. For a full list of Azure CDN product offerings, see [What are the comparisons between Azure CDN product features?](/azure/cdn/cdn-features).

## Network service comparison

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

## See also

- [Create a virtual network using the Azure portal](/azure/virtual-network/quick-create-portal)

- [Plan and design Azure Virtual Networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)

- [Azure Network Security Best Practices](/azure/security/fundamentals/network-best-practices)
