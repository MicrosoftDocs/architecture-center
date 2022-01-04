---
title: Azure NAT Gateway considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of NAT Gateway that are useful when you work with multitenanted systems. It also provides links to guidance and examples for how to use NAT Gateway in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 1/4/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-virtual-network
categories:
 - networking
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Azure NAT Gateway considerations for multitenancy

Azure NAT Gateway provides control over outbound network connectivity from your resources that are hosted within an Azure virtual network. In this article, we review how NAT Gateway can mitigate Source Network Address Translation (SNAT) port exhaustion, which can affect multitenant applications. We also review how NAT Gateway assigns static IP addresses to the outbound traffic from your multitenant solution.

> [!NOTE]
> Firewalls, like [Azure Firewall](/azure/firewall/overview), enable you to control and log your outbound traffic. Azure Firewall also provides similar SNAT port scale and outbound IP address control to NAT Gateway. NAT Gateway is less costly, but also has fewer features and is not a security product.

## Features of NAT Gateway that support multitenancy

### High-scale SNAT ports

SNAT ports are allocated when your application makes multiple concurrent outbound connections to the same public IP address, on the same port. SNAT ports are a finite resource within [load balancers](/azure/load-balancer/load-balancer-outbound-connections). If your application opens large numbers of separate connections to the same host, it can consume all of the available SNAT ports. This situation is called *SNAT port exhaustion*.
 
In most applications, SNAT port exhaustion indicates that your application is incorrectly handling HTTP connections or TCP ports. However, some multitenant applications are at particular risk of exceeding SNAT port limits, even if they reuse connections appropriately. For example, this situation can occur when your application connects to many tenant-specific databases behind the same database gateway.

> [!TIP]
> If you observe SNAT port exhaustion in a multitenant application, you should verify whether [your application follows good practices](/azure/load-balancer/troubleshoot-outbound-connection#connectionreuse). Ensure you reuse HTTP connections and don't recreate new connections every time you connect to an external service. You might be able to deploy a NAT Gateway to work around the problem, but if your code doesn't follow best practices, you could encounter the problem again in the future.

The issue is exacerbated when you work with Azure services that share SNAT port allocations between multiple customers, such as [Azure App Service and Azure Functions](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors).

If you determine you're experiencing SNAT exhaustion and are sure your application code correctly handles your outbound connections, consider deploying NAT Gateway. This approach is commonly used by customers deploying multitenant solutions built on [Azure App Service and Azure Functions](/azure/app-service/networking/nat-gateway-integration).

Each NAT gateway provides at least 64,000, and up to 1 million, SNAT ports. You can consider [deploying multiple NAT Gateway instances across multiple subnets or VNets](/azure/virtual-network/nat-gateway/nat-gateway-resource#performance) if you need to scale even beyond this limit. Each virtual machine in a subnet can use any of the available SNAT ports, if it needs them.

### Outbound IP address control

Outbound IP address control can be useful in multitenant applications when you have all of the following requirements:

- You use Azure services that don't automatically provide dedicated static IP addresses for outbound traffic. These services include Azure App Service, Azure Functions, API Management (when running in the consumption tier), and Azure Container Instances.
- You need to connect to your tenants' networks over the internet.
- Your tenants need to filter incoming traffic based on its IP address.

When a NAT Gateway instance is applied to a subnet, any outbound traffic from that subnet uses the public IP addresses associated with the NAT gateway.

> [!NOTE]
> When you associate multiple public IP addresses with a single NAT Gateway, your outbound traffic could come from any of those IP addresses. If you need to configure firewall rules at the destination, you should either allow each IP address, or use a [public IP address prefix](/azure/virtual-network/ip-services/public-ip-address-prefix) resource to use a set of public IP addresses in the same range.

## Isolation models

If you need to provide different outbound public IP addresses for each tenant, you must deploy individual NAT Gateway resources. Each subnet can be associated with a single NAT Gateway instance, so to deploy more NAT gateways, you need to deploy multiple subnets or virtual networks. In turn, you likely need to deploy multiple sets of compute resources.

Review [Architectural approaches for networking in multitenant solutions](../approaches/networking.md) for more information about how to design a multitenant network topology.

## Next steps

- [Learn more about NAT Gateway](/azure/virtual-network/nat-gateway/nat-gateway-resource).
- [Learn how to use NAT Gateway with Azure App Service and Azure Functions](/azure/app-service/networking/nat-gateway-integration).
- Review [Architectural approaches for networking in multitenant solutions](../approaches/networking.md).
