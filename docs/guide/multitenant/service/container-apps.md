---
title: Azure Container Apps considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Container Apps that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Container Apps in a multitenant solution.
author: willvelida
ms.author: willvelida
ms.date: 10/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-container-apps
categories:
 - management-and-governance
 - compute
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Azure Container Apps considerations for multitenancy

Azure Container Apps enables you to run microservices and containerized applications on a serverless platform. In this article, we describe some of the features of Azure Container Apps that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Azure Container Apps in multitenancy scenarios.

## Isolation models

When working with a multitenant system that uses Azure Container Apps, you need to make a decision about the level of isolation required. Azure Container Apps supports different models of multitenancy:

- You can provide *trusted multitenancy*, such as when your tenants are all from within your organization, by using a shared environment.
- You can provide *hostile multitenancy*, such as in situations where you can't be sure of the code that your tenants run, by deploying separate environments for each tenant.

The following table summarizes the differences between the main tenancy isolation models for Azure Container Apps:

| **Considerations** | **Environment per tenant** | **Container apps per tenant** | **Shared container apps** |
| --- | --- | --- | --- |
| **Data isolation** | High | Low | Low |
| **Performance isolation** | High | Medium. No network isolation | Low |
| **Deployment complexity** | Medium | Low-medium | Low |
| **Operational complexity** | Medium | Low | Low |
| **Resource cost** | High | Low | Low |
| **Example scenario** | Running hostile multitenant workloads in isolated environments for security and compliance reasons |  Optimizing cost, networking resources and operations for trusted multitenant applications | Multitenant solution implemented at the business logic level |

### Shared container apps

You might want to consider deploying shared container apps in a single Container Apps environment, which is used for all your tenants.

This approach is generally cost-efficient and requires the least operational overhead since there are fewer resources to manage.

However, to be able to use this isolation model, your application code must be multitenancy-aware. This isolation model doesn't guarantee any isolation at the network, compute, monitoring or data level. Tenant isolation must be handled by your application code. This model is not appropriate for hostile multitenancy workloads, where you don't trust the code that's running.

Additionally, this model is potentially subject to [nosiy neigbour concerns](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), where one tenant's workload might impact the performance of another tenant's workload. If you need to provide dedicated throughput to mitigate this concern, the shared container apps model might not be appropriate.

> [!NOTE]
> The [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) is useful when different tenants are on different costing models. For example, tenants might be assigned to shared or dedicated Container Apps environments depending on their pricing tier. This deployment strategy allows you to go beyond the limits of Azure Container Apps for a single subscription per region and scale linearly as the number of tenants grow.

### Container apps per tenant

Another approach that you might consider is to isolate your tenants by deploying tenant-specific container apps within a shared environment.

This isolation model provides you with logical isolation between each tenant and gives you the following advantages:

- **Cost efficiency**: By sharing a Container Apps environment, virtual network, and other attached resources like a Log Analytics workspace, you can generally reduce your overall cost and management complexity per tenant.
- **Separation of upgrades and deployments**: Each tenant's application binaries can be deployed and upgraded independently from other container apps in the same environment. This approach can be helpful if you need to upgrade tenants to specific versions of your code at different times to others.
- **Resource isolation**: Each container app within your environment will be allocated with it's own CPU and memory resources. Should a tenant require more resources, you can allocate more CPU and memory to that tenant's specific container app. Be mindful that there are [limits on total CPU and memory allocations](/azure/container-apps/containers#configuration) on container apps.

However, this approach provides no hardware or network isolation between tenants. All container apps in the same environment share the same virtual network. You need to trust the workloads deployed to the apps, to ensure that they don't cause misuse the shared resources.

Additionally, [there are limits on how many container apps you can deploy into a single environment](/azure/container-apps/quotas). Take into account the number of tenants that you'll grow to before implementing this isolation model.

Azure Container Apps has built-in support for Dapr, which uses a modular design to deliver functionality as [components](/azure/container-apps/dapr-overview). In Azure Container Apps, Dapr components are environment-level resources. When sharing the same environment across multiple tenants, ensure that you properly scope the Dapr components to the correct tenant-specific container app to guarantee isolation and avoid the risk of data leakage issues.

> [!NOTE]
> Don't use [revisions](/azure/container-apps/revisions) for different tenants. Revisions don't provide resource isolation. They're designed for deployment scenarios when you need to have multiple versions of your app running as part of an update rollout process, such as blue-green deployments and A/B testing.

### Environment per tenant

You might consider deploying a single Container Apps environment for each of your tenants. A [Container Apps environment](/azure/container-apps/environment) is the isolation boundary around a group of container apps. An environment provides compute and network isolation on the data plane. Each environment is deployed into its own virtual network, shared by all of the apps within the environment. Each environment has its own Dapr and monitoring configuration.

This approach provides the strongest level of data and performance isolation since your tenants data and traffic will be isolated to their specific environment. This isolation model also removes the need for your applications to be multitenancy-aware. With this approach, you have more granular control over how you allocate resources to container apps within the environment, which can be determined according to your tenants requirements. For example, some tenants may require more CPU and memory resources than others, so you provide more resources to your tenant's applications while benefiting from the isolation that tenant-specific environments provide.

However, there are low [limits on how many environments you can deploy within a subscription per region](/azure/container-apps/quotas). In some situations, these [quotas can be increased by request by opening an Azure support case](https://azure.microsoft.com/support/create-ticket/).

Ensure that you understand the number of tenants that you'll grow to before you implement this isolation model.  Keep in mind that this approach often incurs a higher total cost of ownership, and higher levels of deployment and operational complexity, due to the extra resources you need to deploy and manage.

## Features of Azure Container Apps that support multitenancy

### Custom domain names

Azure Container Apps enables you to use [wildcard DNS and to add your own wildcard TLS certificates](/azure/container-apps/custom-domains-certificates#add-a-custom-domain-and-certificate). When you use tenant-specific subdomains, wildcard DNS and TLS certificates enable you to easily scale your solution to a large number of tenants, without requiring a manual reconfiguration of each new tenant.

In Azure Container Apps, you manage certificates at the environment level. [Ingress](/azure/container-apps/ingress) must also be enabled for the container app before you can bind a custom domain to it.

### Request Authentication and authorization

Azure Container Apps can [validate authentication tokens on behalf of your app](/azure/container-apps/authentication#feature-architecture). If a request doesn't contain a token, the token is invalid, or if the request isn't authorized, Azure Container Apps can be configured to either block the request, or redirect it to your identity provider, so that the user can sign in.

If your tenants use Azure Active Directory (Azure AD) as their identity provider, you can configure Azure Container Apps to use the [/common endpoint](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant) to validate user tokens. This ensures that, regardless of the user's Azure AD tenant, their tokens are validated and accepted.

You can also integrate Azure Container Apps with [Azure Active Directory B2C](/azure/active-directory-b2c/overview) for user authentication via third-party identity providers.

More information:

- [Azure Container Apps authorization](/azure/container-apps/authentication)
- [Enable authentication and authorization in Azure Container Apps with Azure Active Directory](/azure/container-apps/authentication-azure-active-directory)

> [!NOTE]
> The features for authentication and authorization in Azure Container Apps are similar those in Azure App Service. However, there are some differences. For more information, see [Considerations for using built-in authentication](/azure/container-apps/authentication#considerations-for-using-built-in-authentication).

### Managed Identities

You can use managed identities from Azure AD to allow your container app to access other Azure AD-protected resources. This removes the need for your container app to manage credentials, and gives you the advantage of providing specific permissions to your container app identity for role-based access control.

Be mindful of which isolation model you choose when using managed identities. For example, if you share your container apps among all your tenants that interact to tenant-specific databases, you will need to ensure that one tenant can't access another tenant's database.

For more information:

- [Managed identities in Azure Container Apps](/azure/container-apps/managed-identity?tabs=portal%2Cdotnet)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Daniel Larsen](http://linkedin.com/in/daniellarsennz) | Principal Customer Engineer, FastTrack for Azure
 * [Will Velida](http://linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure
 
Other contributors:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Kendall Roden](https://www.linkedin.com/in/kendallroden/) | Senior Program Manager, Azure Container Apps
 * [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 
 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [Resources for architects and developers of multitenant solutions](../related-resources.md).
