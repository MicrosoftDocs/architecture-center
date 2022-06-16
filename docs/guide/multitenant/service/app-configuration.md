---
title: Azure App Configuration considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure App Configuration that are useful when working with multitenanted systems, and it provides links to guidance and examples.
author: johndowns
ms.author: jodowns
ms.date: 06/15/2022
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

In a multitenant solution, it's common to have some two types of application configuration settings:

- Settings that you share among multiple tenants, such as global settings or settings that apply to all tenants within a deployment stamp.
- Tenant-specific settings. For example, you might need to store each tenant's database name or internal identifiers. Or, you might want to specify different log levels for each tenant, such as when you diagnose a problem reported by specific tenant and need to collect diagnostic logs from that one tenant.

[Azure App Configuration](/azure/azure-app-configuration/overview) enables you to store configuration settings for your application. By using Azure App Configuration, you can easily implement the [External Configuration Store pattern](../../../patterns/external-configuration-store.yml). In this article, we describe some of the features of Azure App Configuration that are useful when working with multitenanted systems, and we link to guidance and examples for how to use Azure App Configuration in a multitenant solution.

## Isolation models

A *store* refers to a single instance of the Azure App Configuration service. In a multitenant solution, you might consider using shared stores or tenant-specific stores.

### Shared stores

You can deploy a shared Azure App Configuration store for your whole solution, or for each stamp. You can then use the same store for all of your tenants' settings, and use [key prefixes](#key-prefixes) or [labels](#labels) to distinguish them.

If you follow this approach, ensure you understand the [resource quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration) that apply. In particular, be mindful of the total storage limit for the service tier you use, and ensure that you won't exceed the maximum requests per hour.

### Stores per tenant

You might instead choose to deploy an Azure App Configuration store for each tenant. Azure App Configuration enables you to deploy an unlimited number of stores in your subscription. However, this approach is often more complex to manage, because you have to deploy and configure more resources. There's also [a charge for each store resource that you deploy](https://azure.microsoft.com/pricing/details/app-configuration/#pricing).

Consider tenant-specific stores if you have one of the following situations:

- You need to store a large amount of data, or will scale to a large number of tenants, and you'll be at risk of exceeding [any of the resource limits for a single store](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-configuration).
- You need to use [customer-managed encryption keys](/azure/azure-app-configuration/concept-customer-managed-keys), where the keys are separate for each tenant.

## Features of Azure App Configuration that support multitenancy

When you use Azure App Configuration in a multitenant application, there are several features that you can use to store and retrieve tenant-specific settings.

### Key prefixes

In Azure App Configuration, the central element you store and manage is a key-value pair. The key represents the name of the configuration setting. You can use a hierarchical naming structure for your keys, and use a tenant identifier as the prefix for your keys.

For example, suppose you need to store a setting to indicate the logging level for your application. In a single-tenant solution, you might name this setting `LogLevel`. In a multitenant solution, you might choose to use a hierarchical key name, such as `tenant1/LogLevel` for tenant 1, `tenant2/LogLevel` for tenant 2, and so forth.

Azure App Configuration enables you to specify long key names, supporting multiple levels in a hierarchy. If you choose to use long key names, ensure you understand the [size limits for keys and values](/azure/azure-app-configuration/concept-key-value#keys).

When you load a single tenant's configuration into your application, you can specify a [key prefix filter](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.select#parameters) to only load that tenant's keys. You can also configure the .NET SDK for Azure App Configuration to [trim the key prefix](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.trimkeyprefix#microsoft-extensions-configuration-azureappconfiguration-azureappconfigurationoptions-trimkeyprefix(system-string)) from the keys before it makes them available to your application. When you trim the key prefix, your application sees a consistent key name, with tenant-specific values.

### Labels

Azure App Configuration also supports [labels](/azure/azure-app-configuration/concept-key-value#label-keys), which enable you to have separate values with the same key.

You might consider using tenant identifiers as labels. However, labels are often used for versioning or for other purposes in your solution. While you can use tenant identifiers as labels, you won't be able to use labels for anything else. So, it's often a good practice to use [key prefixes](#key-prefixes) instead of labels when you work with multiple tenants.

If you do decide to use labels for each tenant, your application can load just the settings for a specific label by using a [label filter](/dotnet/api/microsoft.extensions.configuration.azureappconfiguration.azureappconfigurationoptions.select#parameters). This approach can be helpful if you have separate application deployments for each tenant.

### Application-side caching

When you work with Azure App Configuration, it's important to cache the settings within your application instead of loading them every time you use them. The Azure App Configuration SDKs automatically cache settings for you, and refresh them automatically as well.

You also need to decide whether your application loads the settings for a single tenant or for all tenants.

As your tenant base grows, the amount of time and the memory resources required to load settings for all tenants together is likely to increase. So, in most situations, it's a good practice to load the settings for each tenant separately when your application needs them.

If you load each tenant's configuration settings separately, your application needs to cache each set of settings separately to any others. In .NET applications, consider using an [in-memory cache](/aspnet/core/performance/caching/memory) to cache the tenant's IConfiguration object and use the tenant identifier as the cache key. By using an in-memory cache, you don't need to reload configuration upon every request, but the cache can remove unused instances if your application is under memory pressure. You can also configure expiration times for each tenant's configuration settings.

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
