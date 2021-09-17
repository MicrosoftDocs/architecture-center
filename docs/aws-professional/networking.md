---
title: Comparing AWS and Azure networking options
description: A comparison of the different networking options between Azure and AWS
author: vaboya
ms.author: vaboya
ms.date: 09/17/2021
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

- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) provides DNS level traffic routing, load balancing, and failover capabilities.

## Direct connect and Azure ExpressRoute

Azure provides similar site-to-site dedicated connections through its
[ExpressRoute](https://azure.microsoft.com/documentation/services/expressroute) service. ExpressRoute allows you to connect your local network directly to Azure resources using a dedicated private network connection. Azure also offers more conventional [site-to-site VPN connections](/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal) at a lower cost.

## Route tables

AWS provides route tables that contain routes to direct traffic, from a subnet/gateway subnet to the destination. In Azure, this feature is called user-defined routes. 

With [user-defined routes](https://docs.microsoft.com/azure/virtual-network/virtual-networks-udr-overview), you can create custom or user-defined (static) routes in Azure, to override Azure's default system routes, or to add more routes to a subnet's route table.

## Network service comparison

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

## See also

- [Create a virtual network using the Azure portal](/azure/virtual-network/quick-create-portal)

- [Plan and design Azure Virtual Networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm)

- [Azure Network Security Best Practices](/azure/security/fundamentals/network-best-practices)
