---
title: Comparing AWS and Azure networking options
description: A comparison of the different networking options between Azure and AWS
author: doodlemania2
ms.date: 05/21/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Networking on Azure and AWS

## Elastic Load Balancing, Azure Load Balancer, and Azure Application Gateway

The Azure equivalents of the two Elastic Load Balancing services are:

- [Load Balancer](https://azure.microsoft.com/documentation/articles/load-balancer-overview): provides the same capabilities as the AWS Classic Load Balancer, allowing you to distribute traffic for multiple VMs at the network level. It also provides failover capability.

- [Application Gateway](https://azure.microsoft.com/documentation/articles/application-gateway-introduction): offers application-level rule-based routing comparable to the AWS Application Load Balancer.

## Route 53, Azure DNS, and Azure Traffic Manager

In AWS, Route 53 provides both DNS name management and DNS-level traffic routing and failover services. In Azure this is handled through two services:

- [Azure DNS](https://azure.microsoft.com/documentation/services/dns) provides domain and DNS management.

- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) provides DNS level traffic routing, load balancing, and failover capabilities.

## Direct Connect and Azure ExpressRoute

Azure provides similar site-to-site dedicated connections through its
[ExpressRoute](https://azure.microsoft.com/documentation/services/expressroute) service. ExpressRoute allows you to connect your local network directly to Azure resources using a dedicated private network connection. Azure also offers more conventional [site-to-site VPN connections](https://azure.microsoft.com/documentation/articles/vpn-gateway-howto-site-to-site-resource-manager-portal) at a lower cost.

## Network service comparison

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

## See also

- [Create a virtual network using the Azure portal](https://azure.microsoft.com/documentation/articles/virtual-networks-create-vnet-arm-pportal)

- [Plan and design Azure Virtual Networks](https://azure.microsoft.com/documentation/articles/virtual-network-vnet-plan-design-arm)

- [Azure Network Security Best Practices](https://azure.microsoft.com/documentation/articles/azure-security-network-security-best-practices)