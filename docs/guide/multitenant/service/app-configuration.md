---
title: Azure App Configuration Considerations for Multitenancy
description: Learn about the features of Azure App Configuration that are useful when you work with multitenant systems, and use the provided links for guidance and examples.
author: johndowns
ms.author: pnp
ms.date: 09/03/2026
ai-usage: ai-assisted
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure App Configuration

[Azure App Configuration](/azure/azure-app-configuration/overview) helps you store configuration settings for your application. By using App Configuration, you can more easily implement the [External Configuration Store pattern](../../../patterns/external-configuration-store.md). This article describes some of the features of App Configuration that are useful when you work with multitenant systems. The provided links take you to guidance and examples for how to use App Configuration in a multitenant solution.

## Isolation models

A *store* refers to a single instance of the App Configuration service.

In a multitenant solution, it's common to have two types of settings:

- **Shared settings**: Apply to multiple tenants, such as global settings or settings that apply to all tenants within a [deployment stamp](../approaches/overview.md#deployment-stamps-pattern). It's often best to store global settings within a shared App Configuration store. By following this approach, you minimize the number of places that you need to update when the value of a setting changes. This approach also minimizes the risk that settings then go out of sync.

- **Tenant-specific settings**: Specify each tenant's database name or internal identifiers. You can use these settings to specify different log levels for each tenant. For example, you might diagnose a problem reported by a specific tenant and you need to collect diagnostic logs from that tenant only. You can choose whether to combine the tenant-specific settings for multiple tenants into a single store, or deploy a store for each tenant. Base your decision on your requirements. If your solution uses a single shared application tier for multiple tenants, there's likely to be minimal benefit to using tenant-specific stores. But if you deploy tenant-specific application instances, you might choose to mirror the same approach by deploying tenant-specific configuration stores.

The following table summarizes the differences between the main tenancy isolation models for App Configuration.

| Consideration | Shared store | Store per tenant |
| --- | --- | --- |
| **Data isolation** | Low. Use key prefixes or labels to identify each tenant's data. | High |
| **Performance isolation** | Low | High |
| **Deployment complexity** | Low | Medium-high |
| **Operational complexity** | Low | Medium-high |
| **Resource cost** | Low | Medium-high |
| **Example scenario** | Large multitenant solution with a shared application tier | Premium tier tenants with fully isolated deployments |

### Shared stores

You can deploy a shared App Configuration store for your whole solution, or one for each stamp. You can then use the same store for all your tenants' settings. Use [key prefixes](#key-prefixes) or [labels](#labels) to distinguish them.

If you need to store a large amount of data per tenant, or scale to a large number of tenants, you might be at risk of exceeding [the resource limits for a single store](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration). In this scenario, consider whether you can share your tenants across a set of shared stores to minimize the deployment and management costs.

If you follow this approach, ensure you understand the [resource quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration) that apply. In particular, consider the storage, request quota, and throughput limits for the service tier that you use. For Standard stores, [geo-replication](/azure/azure-app-configuration/howto-geo-replication) can increase request-quota capacity because each replica has a separate request quota, and supported provider libraries can load-balance requests across replicas. Premium stores have no request quota limit. Use multiple stores when storage limits or tenant partitioning require them.

Geo-replication doesn't prevent [noisy-neighbor issues](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Apply tenant-aware rate limits or quotas in your application, and monitor request usage by tenant.

### Store per tenant

You might instead choose to deploy an App Configuration store for each tenant. The App Configuration [Standard and Premium tiers](/azure/azure-app-configuration/faq#which-app-configuration-tier-should-i-use) help you deploy an unlimited number of stores in your subscription. But this approach is often more complex to manage, because you must then deploy and configure more resources.

> [!NOTE]
> The Developer tier has no SLA. Use it only for low-volume, nonproduction scenarios.

Consider tenant-specific stores if you have one of the following situations:

- Your tenants require different [customer-managed keys (CMKs)](/azure/azure-app-configuration/concept-customer-managed-keys). CMKs require Standard or Premium stores and are configured at the store level, so deploy a separate Standard or Premium store for each tenant that requires a different CMK.
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

When you work with App Configuration, cache the settings within your application instead of loading them every time you use them. The [App Configuration provider libraries](/azure/azure-app-configuration/overview#use-app-configuration) cache settings.

You must also decide whether your application loads the settings for a single tenant or for all tenants.

As your tenant base grows, the amount of time and the memory required to load settings for all tenants together is likely to increase. So, in most situations, it's a good practice to load the settings for each tenant separately, when your application needs them.

If you load each tenant's configuration settings separately, your application needs to cache each set of settings separately from any others.

#### Refresh key-values

Applications need to refresh the values of keys when they change.

A common approach is for an application to watch for changes in a [sentinel key](/azure/azure-app-configuration/howto-best-practices#monitoring-a-sentinel-key), which is a dedicated key with a well-known name that you update after making edits to other keys. You can choose to design your caching architecture based on global or tenant-specific sentinel keys.

In .NET applications, register cached key-values for refresh by using `ConfigureRefresh`, and trigger the refresh by calling `TryRefreshAsync` or by using [App Configuration middleware](/azure/azure-app-configuration/enable-dynamic-configuration-aspnet-core). You can use an [in-memory cache](/aspnet/core/performance/caching/memory) to cache the tenant's `IConfiguration` object and then use the tenant identifier as the cache key. By using an in-memory cache, you don't need to reload a configuration for every request, but the cache can remove unused instances if your application is under memory pressure. You can also configure expiration times for each tenant's configuration settings.

### Configuration rollout and rollback with snapshot references

When a tenant, tenant cohort, or deployment stamp needs its configuration to change on an independent schedule, point a tenant-scoped key at a [snapshot reference](/azure/azure-app-configuration/concept-snapshot-references) rather than at individual values.

Scope the reference key by [key prefix](#key-prefixes) or [label](#labels). Build each referenced snapshot so that it contains only the keys intended for that tenant, cohort, or stamp. Consider the [App Configuration limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration), including the limit on the size of each snapshot. Selecting a scoped reference doesn't filter the snapshot's contents. A supported configuration provider merges every key-value from the snapshot into the application configuration.

Before repointing the reference, configure refresh in the supported configuration provider. Then repoint the reference to roll the tenant or stamp forward or back without a code change or redeployment.

A snapshot reference doesn't change the isolation model. Access is still controlled at the store level, and the application identity needs permission to read the referenced snapshot.

### Configuration delivery to client applications (preview)

If your solution includes browser, mobile, or desktop clients that read configuration directly, a large shared tenant base can generate enough client reads to approach [the request limits for a shared store](#shared-stores). The [Azure Front Door integration for App Configuration](/azure/azure-app-configuration/concept-hyperscale-client-configuration) (preview) caches published configuration at the network edge and absorbs that read volume.

> [!NOTE]
> Client applications that load configuration through Azure Front Door can't use [sentinel key refresh](/azure/azure-app-configuration/how-to-load-azure-front-door-configuration-provider#troubleshooting). Configure the provider to monitor all selected keys for changes.

> [!IMPORTANT]
> This caching model is eventually consistent. Clients see an update only after the [Azure Front Door cache expires](/azure/azure-app-configuration/concept-hyperscale-client-configuration#caching) and the next client configuration refresh occurs. Don't rely on this integration for tenant configuration changes that must take effect immediately.

Configuration delivered through Azure Front Door is publicly accessible without authentication.

> [!WARNING]
> Use a dedicated App Configuration store that contains only settings that are safe for anonymous public access. Don't store secrets, sensitive settings, or tenant-specific data that isn't intended for public disclosure in this store.
>
> Don't treat the Front Door route as an authorization boundary between tenants.

See the linked article for setup, the managed-identity role, cache tuning, replica origins, and provider support.

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
