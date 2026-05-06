---
title: How to Use Azure NAT Gateway in a Multitenant Solution
description: Learn about Azure NAT Gateway features that are useful when you work with multitenant systems. See examples of how to use these features.
author: johndowns
ms.author: pnp
ms.date: 06/13/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# How to use Azure NAT Gateway in a multitenant solution

Azure NAT Gateway provides control over outbound network connectivity from your resources that are hosted within an Azure virtual network. This article describes how Azure NAT Gateway can mitigate source network address translation (SNAT) port exhaustion, which can affect multitenant applications. It also describes how Azure NAT Gateway assigns static IP addresses to the outbound traffic from your multitenant solution.

> [!NOTE]
> Firewalls, like [Azure Firewall](/azure/firewall/overview), enable you to control and log your outbound traffic. Azure Firewall also provides similar SNAT port scale and outbound IP address control to Azure NAT Gateway. Azure NAT Gateway is less costly, but it has fewer features and isn't a security product.

## Features that support multitenancy

The following sections describe Azure NAT Gateway features that you can use in multitenant solutions.

### High-scale SNAT ports

SNAT ports are allocated when your application makes multiple concurrent outbound connections to the same public IP address on the same port. SNAT ports are a finite resource within [load balancers](/azure/load-balancer/load-balancer-outbound-connections). If your application opens large numbers of separate connections to the same host, it can consume all of the available SNAT ports. This scenario is called *SNAT port exhaustion*.
 
In most applications, SNAT port exhaustion indicates that your application incorrectly handles HTTP connections or Transmission Control Protocol (TCP) ports. However, some multitenant applications are especially at risk of exceeding SNAT port limits, even if they reuse connections appropriately. For example, this scenario can occur when your application connects to many tenant-specific databases behind the same database gateway.

> [!TIP]
> If you observe SNAT port exhaustion in a multitenant application, you should first verify whether [your application follows good practices](/azure/load-balancer/troubleshoot-outbound-connection). Ensure that you reuse HTTP connections and don't re-create new connections every time you connect to an external service. You might be able to deploy a network address translation (NAT) gateway to work around the problem, but if your code doesn't follow the best practices, you might encounter the problem again in the future.

SNAT port exhaustion worsens when you work with Azure services that share SNAT port allocations between multiple customers. Examples of services that behave in this manner include Azure App Service and Azure Functions. For more information, see [Troubleshoot intermittent outbound connection errors in App Service](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors).

If you determine that your application experiences SNAT port exhaustion and that your application code correctly handles your outbound connections, consider integrating Azure NAT Gateway. Customers who deploy multitenant solutions that are built on App Service and Azure Functions often use this approach. For more information, see [Azure NAT Gateway integration](/azure/app-service/networking/nat-gateway-integration).

An individual NAT gateway can have multiple public IP addresses attached to it, and each public IP address provides a set of SNAT ports to connect outbound to the internet. To understand the maximum number of SNAT ports and IP addresses that a single NAT gateway can support, see [Azure NAT Gateway limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-nat-gateway-limits). If you need to scale beyond this limit, you can consider [deploying multiple Azure NAT Gateway instances across multiple subnets or virtual networks](/azure/virtual-network/nat-gateway/nat-gateway-resource#performance). Each virtual machine in a subnet can use any of the available SNAT ports if needed.

### Outbound IP address control

Outbound IP address control can be useful in multitenant applications if you have all of the following requirements:

- You use Azure services that don't automatically provide dedicated static IP addresses for outbound traffic. These services include App Service, Azure Functions, Azure API Management (when it runs in the consumption tier), and Azure Container Instances.

- You need to connect to your tenants' networks over the internet.

- Your tenants need to filter incoming traffic based on the IP address of each request.

When an Azure NAT Gateway instance is applied to a subnet, any outbound traffic from that subnet uses the public IP addresses that are associated with the NAT gateway.

> [!NOTE]
> When you associate multiple public IP addresses with a single NAT gateway, your outbound traffic can come from any of those IP addresses. You might need to configure firewall rules at the destination. Either allow each IP address individually, or use a [public IP address prefix](/azure/virtual-network/ip-services/public-ip-address-prefix) resource to define a set of public IP addresses within the same range.

## Isolation models

If you need to provide different outbound public IP addresses for each tenant, you must deploy individual Azure NAT Gateway resources. Each subnet can be associated with a single Azure NAT Gateway instance. To deploy more NAT gateways, you need to deploy multiple subnets or virtual networks. In turn, you likely need to deploy multiple sets of compute resources.

For more information about how to design a multitenant network topology, see [Architectural approaches for networking in multitenant solutions](../approaches/networking.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Aimee Littleton](https://www.linkedin.com/in/aimeelittleton) | Senior Program Manager, Azure NAT Gateway
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer
- [Joshua Waddell](https://www.linkedin.com/in/joshua-waddell) | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure NAT Gateway resource](/azure/virtual-network/nat-gateway/nat-gateway-resource)
- [Azure NAT Gateway integration](/azure/app-service/networking/nat-gateway-integration)
