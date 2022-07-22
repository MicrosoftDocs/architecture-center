---
title: Private Link service considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Private Link that are useful when working with multitenanted systems, and it provides links to guidance and examples.
author: johndowns
ms.author: jodowns
ms.date: 07/21/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-virtual-network
 - azure-private-link
categories:
 - data
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Private Link

Azure Private Link provides private IP addressing for Azure platform services, and for your own applications hosted on Azure virtual machines. You can use Private Link to enable private connectivity from your tenants' Azure environments. Tenants can also use Private Link to access your solution from their on-premises environments when they're connected through virtual private networks (VPNs) or ExpressRoute. In this article, we review how you can configure Private Link for an Azure-hosted multitenant solution.

## Key considerations

### Service selection

When you use Private Link, it's important to consider the service that you want to allow inbound connectivity to. In most solutions, the service is one of the following types:

- An application hosting platform, like Azure App Service.
- A network or API gateway, like Azure Application Gateway or Azure API Management.
- Virtual machines.

The application platform you use determines a number of aspects of your Private Link configuration, and the limits that apply. Additionally, some application services don't support Private Link for inbound traffic.

### Limits

Carefully consider the number of private endpoints that you can create. If you use a platform as a service (PaaS) application platform, it's important be aware of the maximum number of private endpoints that a single resource can support. If you run virtual machines, you can attach a Private Link service instance to a load balancer. In this configuration, you can generally connect a higher number of private endpoints, but limits still apply. These limits might determine how many tenants you can connect to your resources by using Private Link. Review [TODO quotas](TODO) to understand the limits to the number of endpoints and connections.

Additionally, some services require specialized networking configuration to use Private Link. For example, if you use Private Link with Azure Application Gateway, you must [provision a dedicated subnet](/azure/application-gateway/private-link-configure) in addition to the standard subnet for the Application Gateway resource.

Carefully test your solution, including your deployment and diagnostic configuration, with your Private Link configuration enabled. Some Azure services block public internet traffic when a private endpoint is enabled, which can require that you change your deployment and management processes.

### Internet-facing applications

If you plan to deploy your solution to be both internet-facing and also exposed through private endpoints, consider your topology and the traffic paths that each type of tenant will follow.

For example, suppose you build an internet-facing application that runs on a virtual machine scale set. You use Azure Front Door, including its web application firewall (WAF), for security and traffic acceleration:

<!-- TODO diagram -->

If you provide a tenant with a private endpoint to access your solution, their traffic bypasses your Front Door profile and the WAF:

<!-- TODO diagram -->

In some solutions, this might be problematic because your WAF might be an important security component. You might also embed traffic routing or caching functionality in your Front Door profile, and traffic flowing through private endpoints won't use these features.

## Isolation models

- The decision over how many PL resources to deploy largely depends on whether your application tier is shared or dedicated.
- If you have an application tier that's shared between multiple tenants:
   - If it's VM-based, you need to deploy one or more PLS resources. Typically you'll start with one, and then deploy more only if you run into limits (although the limits are high).
   - If it's PaaS-based, you will deploy one PE per tenant. Note that there are limits around how many PEs can be attached to a single PaaS resource - the limits differ for each service.
- If you have dedicated application tier deployments per tenant, you probably only need one or a small number of PEs per deployment to enable the tenant to access the resource.

## Features of Azure Private Link that support multitenancy

When you use Azure App Configuration in a multitenant application, there are several features that you can use to store and retrieve tenant-specific settings.

### Visibility

- Private Link service enables you to [control the visibility of your private endpoint](/azure/private-link/private-link-service-overview#control-service-exposure).
- Will you let all Azure subscriptions be able to add a private endpoint to your service, or will it only be for a subset?
- If you only allow known subscriptions, how will you authorise their subscription IDs? For example, you might provide an administration user interface in your solution to collect the subscription ID, and then passing that subscription ID to Azure to pre-approve connection requests.

### Aliases

- When using Private Link service, as well as some other Private Link-compatible Azure services, you can [provide an alias](/azure/private-link/private-link-service-overview#alias) to your tenants instead of giving them your Azure subscription IDs and other resource details.
- This avoids disclosure of your subscription IDs and resource group names.

### Approval process

- Private Link service supports manual and auto approval based on subscription IDs.
- Even if you use manual approval, you might build a custom automated approval system to look at your tenants who have been authorised for using private endpoints, and approving those connections automatically.
- [Doc](/azure/private-link/private-link-service-overview#control-service-access)

### Proxy Protocol v2

- By default, you only see the NATted IP address of the client. However, Private Link service enables you to get access to the original client IP address in their own private subnet.
- This can be useful if you need to add IP address-based access restrictions for clients on different private IP addresses all accessing the same private endpoint. For example, you might enable tenants to set their own access restrictions to enforce a rule like "host 10.0.0.10 can access the service, but 10.0.0.20 can't". Or, you might implement IP address restrictions to enforce licensing constraints.
- [Doc](/azure/private-link/private-link-service-overview#getting-connection-information-using-tcp-proxy-v2)

## Related resources

- [SaaS Private Connectivity pattern](https://github.com/Azure/SaaS-Private-Connectivity)

## Next steps

Review [networking approaches for multitenancy](../approaches/networking.md).
