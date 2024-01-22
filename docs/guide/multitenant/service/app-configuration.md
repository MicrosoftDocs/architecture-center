---
title: Azure App Configuration considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure App Configuration that are useful when working with multitenanted systems, and it provides links to guidance and examples.
author: johndowns
ms.author: jodowns
ms.date: 05/08/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-resource-manager
categories:
 - data
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure App Configuration

[Azure App Configuration](/azure/azure-app-configuration/overview) enables you to store configuration settings for your application. By using Azure App Configuration, you can easily implement the [External Configuration Store pattern](../../../patterns/external-configuration-store.yml). In this article, we describe some of the features of Azure App Configuration that are useful when working with multitenanted systems, and we link to guidance and examples for how to use Azure App Configuration in a multitenant solution.

## Isolation models

A *store* refers to a single instance of the Azure App Configuration service.

In a multitenant solution, it's common to have some settings that you share among multiple tenants, such as global settings or settings that apply to all tenants within a [deployment stamp](../approaches/overview.yml#deployment-stamps-pattern). Global settings are often best stored within a shared App Configuration store. By following this approach, you minimize the number of places that you need to update when the value of a setting changes. This approach also minimizes the risk that settings could get out of sync.

Commonly, you will also have tenant-specific settings. For example, you might need to store each tenant's database name or internal identifiers. Or, you might want to specify different log levels for each tenant, such as when you diagnose a problem that's reported by a specific tenant and you need to collect diagnostic logs from that one tenant. You can choose whether to combine the tenant-specific settings for multiple tenants into a single store, or to deploy a store for each tenant. This decision should be based on your requirements. If your solution uses a single shared application tier for multiple tenants, there's likely to be minimal benefit to using tenant-specific stores. But if you deploy tenant-specific application instances, you might choose to mirror the same approach by deploying tenant-specific configuration stores.

The following table summarizes the differences between the main tenancy isolation models for Azure App Configuration:

| Consideration | Shared store | Store per tenant |
|---|---|---|
| **Data isolation** | Low. Use key prefixes or labels to identify each tenant's data | High |
| **Performance isolation** | Low | High |
| **Deployment complexity** | Low | Medium-high |
| **Operational complexity** | Low | Medium-high |
| **Resource cost** | Low | Medium-high |
| **Example scenario** | Large multitenant solution with a shared application tier | Premium tier tenants with fully isolated deployments |

### Shared stores

You can deploy a shared Azure App Configuration store for your whole solution, or for each stamp. You can then use the same store for all of your tenants' settings, and you can use [key prefixes](#key-prefixes) or [labels](#labels) to distinguish them.

If you need to store a large amount of data per tenant, or if you need to scale to a large number of tenants, you might be at risk of exceeding [any of the resource limits for a single store](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration). In this scenario, consider whether you can shard your tenants across a set of shared stores, to minimize the deployment and management costs.

If you follow this approach, ensure you understand the [resource quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration) that apply. In particular, be mindful of the total storage limit for the service tier you use, and ensure that you won't exceed the maximum requests per hour.

### Stores per tenant

You might instead choose to deploy an Azure App Configuration store for each tenant. The Azure App Configuration [standard tier](/azure/azure-app-configuration/faq#which-app-configuration-tier-should-i-use) enables you to deploy an unlimited number of stores in your subscription. However, this approach is often more complex to manage, because you have to deploy and configure more resources. There's also [a charge for each store resource that you deploy](https://azure.microsoft.com/pricing/details/app-configuration/#pricing).

Consider tenant-specific stores if you have one of the following situations:

- You need to use [customer-managed encryption keys](/azure/azure-app-configuration/concept-customer-managed-keys), where the keys are separate for each tenant.
- Your tenants require their configuration data to be completely isolated from other tenants' data. Access permission for Azure App Configuration is controlled at the store level, so by deploying separate stores, you can configure separate access permissions.

## Features of Azure App Configuration that support multitenancy

When you use Azure App Configuration in a multitenant application, there are several features that you can use to store and retrieve tenant-specific settings.

### Key prefixes

In Azure App Configuration, you work with key-value pairs that represent application settings. The key represents the name of the configuration setting. You can use a hierarchical naming structure for your keys. In a multitenant solution, consider using a tenant identifier as the prefix for your keys.

For example, suppose you need to store a setting to indicate the logging level for your application. In a single-tenant solution, you might name this setting `LogLevel`. In a multitenant solution, you might choose to use a hierarchical key name, such as `tenant1/LogLevel` for tenant 1, `tenant2/LogLevel` for tenant 2, and so on.

Azure App Configuration enables you to specify long key names, to support multiple levels in a hierarchy. If you choose to use long key names, ensure you understand the [size limits for keys and values](/azure/azure-app-configuration/concept-key-value#keys).

When you load a single tenant's configuration into your application, you can specify a [key prefix filter](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.select#parameters) to only load that tenant's keys. You can also configure the provider library for Azure App Configuration to [trim the key prefix](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.trimkeyprefix#microsoft-extensions-configuration-azureappconfiguration-azureappconfigurationoptions-trimkeyprefix(system-string)) from the keys, before it makes them available to your application. When you trim the key prefix, your application sees a consistent key name, with that tenant's values loaded into the application.

### Labels

Azure App Configuration also supports [labels](/azure/azure-app-configuration/concept-key-value#label-keys), which enable you to have separate values with the same key.

Labels are often used for versioning, working with multiple deployment environments, or for other purposes in your solution. While you can use tenant identifiers as labels, you won't be able to use labels for anything else. So, it's often a good practice to use [key prefixes](#key-prefixes) instead of labels, when you work with a multitenant solution.

If you do decide to use labels for each tenant, your application can load just the settings for a specific tenant by using a [label filter](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.select#parameters). This approach can be helpful if you have separate application deployments for each tenant.

### Application-side caching

When you work with Azure App Configuration, it's important to cache the settings within your application, instead of loading them every time you use them. The [Azure App Configuration provider libraries](/azure/azure-app-configuration/overview#use-app-configuration) cache settings and refresh them automatically.

You also need to decide whether your application loads the settings for a single tenant or for all tenants.

As your tenant base grows, the amount of time and the memory required to load settings for all tenants together is likely to increase. So, in most situations, it's a good practice to load the settings for each tenant separately, when your application needs them.

If you load each tenant's configuration settings separately, your application needs to cache each set of settings separately to any others. In .NET applications, consider using an [in-memory cache](/aspnet/core/performance/caching/memory) to cache the tenant's IConfiguration object and then use the tenant identifier as the cache key. By using an in-memory cache, you don't need to reload a configuration upon every request, but the cache can remove unused instances if your application is under memory pressure. You can also configure expiration times for each tenant's configuration settings.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 * [Zhenlan Wang](https://www.linkedin.com/in/zhenlanwang) | Principal Software Engineering Manager, Azure App Configuration

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
