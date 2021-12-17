---
title: NAT Gateway considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of NAT Gateway that are useful when you work with multitenanted systems, and it provides links to guidance and examples for how to use NAT Gateway in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 12/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-resource-manager
categories:
 - management-and-governance
 - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# NAT Gateway considerations for multitenancy

NAT Gateway provides control over outbound network connectivity from resources hosted within an Azure virtual network. In this article, we review how NAT Gateway can help to mitigate SNAT port exhaustion, which can sometimes impact multitenant applications. We also review how you can use NAT Gateway to assign static IP addresses to your outbound traffic.

> [!NOTE]
> Firewalls, like [Azure Firewall](/azure/firewall/overview), enable you to control and log your outbound traffic. Azure Firewall also provides similar SNAT port scale and outbound IP address control to NAT Gateway. NAT Gateway is less costly, but also has fewer features and is not a security product.

## Features of NAT Gateway that support multitenancy

### High-scale SNAT ports

SNAT ports are allocated when your application makes multiple concurrent outbound connections to the same public IP address, on the same port.

SNAT port exhaustion commonly happens when your application initiates large numbers of separate connections to the same IP address.
 
In most applications, SNAT port exhaustion indicates that your application is incorrectly handling HTTP connections or TCP ports. However, some multitenant applications are at particular risk of exceeding SNAT port limits, even if they reuse connections appropriately. For example, this situation can occur when your application connects to large numbers of tenant-specific databases on the same database server.

> [!TIP]
> If you observe SNAT port exhaustion in a multitenant application, you should verify whether your application follows good practices. Ensure you reuse HTTP connections and don't recreate new connections every time you connect to an external service. You might be able to deploy a NAT Gateway to work around the problem, but if your code is buggy, you could encounter the problem again in the future.

The issue is exacerbated when you work with Azure services that are themselves multitenant, such as [Azure App Service and Azure Functions](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors). They share their SNAT ports betwen multiple customers, which means they provide fewer SNAT ports for your application to use.

If you determine that you are experiencing SNAT exhaustion and also that your application code correctly handles your outbound connections, consider deploying NAT Gateway. This approach is commonly used by customers deploying multitenant solutions built on [Azure App Service and Azure Functions](/azure/app-service/networking/nat-gateway-integration).

Each NAT Gateway resource can provide up to one million SNAT ports, when configured with the maximum number of public IP addresses. You can consider [deploying multiple NAT Gateway instances across multiple subnets](/azure/virtual-network/nat-gateway/nat-gateway-resource#performance) if you need to scale even beyond this limit.

### Outbound IP address control

Outbound IP address control can be useful in multitenant applications when you have all of the following requirements:

- You use Azure services that don't automatically provide dedicated static IP addresses for outbound traffic. These services include Azure App Service, Azure Functions, API Management (when running in the consumption tier), and Azure Container Instances.
- You need to connect to your tenants' networks over the internet.
- Your tenants need to perform IP address-based filtering.

When a NAT Gateway instance is applied to a subnet, any outbound traffic from that subnet uses the public IP address associated with the NAT gateway.

> [!NOTE]
> When you associate multiple public IP addresses with a single NAT Gateway, your outbound traffic could come from any of those IP addresses. If you need to configure firewall rules at the destination, you should either allow each IP address, or use a [public IP address prefix](/azure/virtual-network/ip-services/public-ip-address-prefix) resource to use a set of public IP addresses in the same range.

## Next steps

- [Learn more about NAT Gateway](/azure/virtual-network/nat-gateway/nat-gateway-resource).
- [Learn how to use NAT Gateway with Azure App Service and Azure Functions](/azure/app-service/networking/nat-gateway-integration).
- Review [Architectural approaches for networking in multitenant solutions](../approaches/networking.md).
