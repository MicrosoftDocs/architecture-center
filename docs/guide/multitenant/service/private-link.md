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

- Your services run in Azure. You might have tenants who also have an Azure environment, or even an on-premises environment that's connected to Azure through a VPN or ExpressRoute.
- They might want to access your application through a private IP address within their own Azure virtual network.

## Key considerations

- Which backend service do users connect to?
  - Private Link service is used with SLB.
  - Your application tier might be using App Service or another PaaS service, which then imposes limits around how many private endpoints can be attached. Or, you can 
  - Also if your application is designed to be internet-facing, e.g. with Front Door and/or a WAF, then a private endpoint might bypass this. Consider your networking topology carefully
- Ensure that you understand the constraints that your services might impose when you enable private endpoints.
  - Each service has limits on the number of private endpoints and the number of connections that can be made to each private endpoint. Depending on the service, these limits are different.
  - For example, Application Gateway requires that you [provision a second subnet for Private Link](/azure/application-gateway/private-link-configure).
  - App Service disables public access to your application, which also can impact your ability to deploy and remotely debug your application.

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
