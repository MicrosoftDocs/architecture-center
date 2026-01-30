---
title: Azure App Configuration Considerations for Multitenancy
description: Learn about the features of Azure App Configuration that are useful when you work with multitenant systems, and use the provided links for guidance and examples.
author: johndowns
ms.author: pnp
ms.date: 09/05/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure App Configuration

[Azure App Configuration](/azure/azure-app-configuration/overview) helps you store configuration settings for your application. By using App Configuration, you can more easily implement the [External Configuration Store pattern](../../../patterns/external-configuration-store.yml). This article describes some of the features of App Configuration that are useful when you work with multitenant systems. The provided links take you to guidance and examples for how to use App Configuration in a multitenant solution.

## Isolation models

A *store* refers to a single instance of the App Configuration service.

In a multitenant solution, it's common to have two types of settings:

- **Shared settings**: Apply to multiple tenants, such as global settings or settings that apply to all tenants within a [deployment stamp](../approaches/overview.md#deployment-stamps-pattern). It's often best to store global settings within a shared App Configuration store. By following this approach, you minimize the number of places that you need to update when the value of a setting changes. This approach also minimizes the risk that settings then go out of sync.

- **Tenant-specific settings**: Specify each tenant's database name or internal identifiers. You can use these settings to specify different log levels for each tenant. For example, you might diagnose a problem reported by a specific tenant and you need to collect diagnostic logs from that tenant only. You can choose whether to combine the tenant-specific settings for multiple tenants into a single store, or deploy a store for each tenant. Base your decision on your requirements. If your solution uses a single shared application tier for multiple tenants, there's likely to be minimal benefit to using tenant-specific stores. But if you deploy tenant-specific application instances, you might choose to mirror the same approach by deploying tenant-specific configuration stores.

The following table summarizes the differences between the main tenancy isolation models for App Configuration.

| Consideration | Shared store | Store per tenant |
|---|---|---|
| **Data isolation** | Low. Use key prefixes or labels to identify each tenant's data. | High |
| **Performance isolation** | Low | High |
| **Deployment complexity** | Low | Medium-high |
| **Operational complexity** | Low | Medium-high |
| **Resource cost** | Low | Medium-high |
| **Example scenario** | Large multitenant solution with a shared application tier | Premium tier tenants with fully isolated deployments |

### Shared stores

You can deploy a shared App Configuration store for your whole solution, or one for each stamp. You can then use the same store for all your tenants' settings. Use [key prefixes](#key-prefixes) or [labels](#labels) to distinguish them.

If you need to store a large amount of data per tenant, or scale to a large number of tenants, you might be at risk of exceeding [the resource limits for a single store](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration). In this scenario, consider whether you can share your tenants across a set of shared stores to minimize the deployment and management costs.

If you follow this approach, ensure you understand the [resource quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration) that apply. In particular, be mindful of the total storage limit for the service tier that you use, and ensure that you don't exceed the maximum requests per hour.

### Store per tenant

You might instead choose to deploy an App Configuration store for each tenant. The App Configuration [Standard tier](/azure/azure-app-configuration/faq#which-app-configuration-tier-should-i-use) helps you deploy an unlimited number of stores in your subscription. But this approach is often more complex to manage, because you must then deploy and configure more resources.

Consider tenant-specific stores if you have one of the following situations:

- You're required to use [customer-managed keys (CMK)](/azure/azure-app-configuration/concept-customer-managed-keys), where the keys are separate for each tenant.
- Your tenants require their configuration data to be isolated from other tenants' data. Access permission for App Configuration is controlled at the store level, so by deploying separate stores, you can configure separate access permissions.

## Features of App Configuration that support multitenancy

When you use App Configuration in a multitenant application, there are several features that you can use to store and retrieve tenant-specific settings.

### Key prefixes

In App Configuration, you work with key-value pairs that represent application settings. The key represents the name of the configuration setting. You can use a hierarchical naming structure for your keys. In a multitenant solution, consider using a tenant identifier as the prefix for your keys.

For example, suppose you need to store a setting to indicate the logging level for your application. In a single-tenant solution, you might name this setting `LogLevel`. In a multitenant solution, you might choose to use a hierarchical key name, such as `tenant1/LogLevel` for tenant 1, and `tenant2/LogLevel` for tenant 2.

You can specify long key names and multiple levels in a hierarchy. If you choose to use long key names, ensure that you understand the [size limits for keys and values](/azure/azure-app-configuration/concept-key-value#keys).

When you load a single tenant's configuration into your application, you can specify a [key prefix filter](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.select) to only load that tenant's keys. You can also configure the provider library for App Configuration to [trim the key prefix](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.trimkeyprefix#microsoft-extensions-configuration-azureappconfiguration-azureappconfigurationoptions-trimkeyprefix) from the keys, before it makes them available to your application. When you trim the key prefix, your application sees a consistent key name, with that tenant's values loaded into the application.

### Labels

App Configuration also supports [labels](/azure/azure-app-configuration/concept-key-value#label-keys). With labels, you can define separate values that use the same key.

Labels help with versioning, working with multiple deployment environments, or for other purposes in your solution. While you can use tenant identifiers as labels, you then can't use labels for anything else. So, for multitenant solutions, it's typically a good practice to use [key prefixes](#key-prefixes) for managing tenant-specific settings, and use labels for other purposes.

If you decide to use labels for each tenant, your application can load only the settings for a specific tenant by using a [label filter](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.select#parameters). This approach is helpful if you have separate application deployments for each tenant.

### Application-side caching

When you work with App Configuration, it's important to cache the settings within your application, instead of loading them every time you use them. The [App Configuration provider libraries](/azure/azure-app-configuration/overview#use-app-configuration) cache settings and refresh them automatically.

You must also decide whether your application loads the settings for a single tenant or for all tenants.

As your tenant base grows, the amount of time and the memory required to load settings for all tenants together is likely to increase. So, in most situations, it's a good practice to load the settings for each tenant separately, when your application needs them.

If you load each tenant's configuration settings separately, your application needs to cache each set of settings separately from any others. In .NET applications, you can use an [in-memory cache](/aspnet/core/performance/caching/memory) to cache the tenant's `IConfiguration` object and then use the tenant identifier as the cache key. By using an in-memory cache, you don't need to reload a configuration for every request, but the cache can remove unused instances if your application is under memory pressure. You can also configure expiration times for each tenant's configuration settings.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Zhenlan Wang](https://www.linkedin.com/in/zhenlanwang) | Principal Software Engineering Manager, App Configuration

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.md).
