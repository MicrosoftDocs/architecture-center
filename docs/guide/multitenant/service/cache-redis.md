---
title: Azure Cache for Redis considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Cache for Redis that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Cache for Redis in a multitenant solution.
author: willvelida
ms.author: willvelida
ms.date: 05/08/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-cache-redis
categories:
 - management-and-governance
 - databases
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Cache for Redis

Azure Cache for Redis is commonly used to increase the performance of your solution, to reduce the load on your database or other data-tier components, and to reduce the amount of state that's stored on compute nodes. In this article, we describe some of the features of Azure Cache for Redis that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Azure Cache for Redis.

## Isolation models

When working with a multitenant system that uses Azure Cache for Redis, you need to make a decision about the level of isolation you want to use. Azure Cache for Redis supports several isolation models.

The following table summarizes the differences between the main tenancy isolation models for Azure Cache for Redis:

| Consideration | Shared cache, shared database | Shared cache, database per tenant | Cache per tenant |
|---|---|---|---|
| **Data isolation** | Low. Use Redis data structures or key prefixes to identify each tenant's data | Low. Data is separated but no security isolation is provided | High |
| **Performance isolation** | Low. All tenants share the same compute resources | Low. All tenants share the same compute resources | High |
| **Deployment complexity** | Low | Medium | Medium-high |
| **Operational complexity** | Low | Low | Medium-high |
| **Resource cost** | Low | Low | High |
| **Example scenario** | Large multitenant solution with a shared application tier | Migrating a single-tenant application to be multitenant-aware | Individual application instances per tenant |

### Shared cache instance and shared database

You might consider deploying a single cache, with a single Redis database, and using it to store cached data for all of your tenants. This approach is commonly used when you have a single application tier that all of your tenants share.

To isolate tenant-specific data within each cache, consider using key prefixes to prepend the tenant ID. Your application can then access specific data for a specific tenant. Alternatively, you can consider using Redis data structures, like [sets](https://redis.io/docs/manual/data-types/#sets) or [hashes](https://redis.io/docs/manual/data-types/#hashes), for each tenant's data. Both sets and hashes support a large number of keys, so this approach can scale to many tenants.

When you use a single cache instance, the application needs to be authorized to access the entire cache. Azure Cache for Redis doesn't provide granular access control within a cache.

When you use this approach, consider that all of your tenants will share the same underlying compute resources for the cache. So, this approach can be vulnerable to the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Ensure that you follow the best practices for Azure Cache for Redis for [scaling](/azure/azure-cache-for-redis/cache-best-practices-scale), [memory management](/azure/azure-cache-for-redis/cache-best-practices-memory-management), and [server load](/azure/azure-cache-for-redis/cache-best-practices-server-load), to make the most efficient use of your cache's resources and to mitigate any noisy neighbor effects.

Additionally, consider monitoring your cache's resources, such as CPU and memory. If you observe resource pressure, consider the following mitigations:

- Scale up to a cache SKU or tier with higher levels of resources.
- Scale out to multiple caches by sharding your cached data. You can either shard by tenant, where some tenants use cache A and some use cache B, or you can shard by subsystem, where one part of your solution caches data for all tenants to cache A, and another part of your solution caches onto cache B.

### Shared cache instance with a database per tenant

Another approach you might consider is to deploy a single cache instance, and deploy tenant-specific Redis databases within the instance. This approach provides some degree of logical isolation of each tenant's data, but it doesn't provide any performance isolation or protection against noisy neighbors.

This approach might be useful for migration scenarios. For example, suppose you modernize a single-tenant application that isn't designed to work with multiple tenants, and you gradually convert it to be multitenancy-aware by including the tenant context in all requests. You can gain some cost efficiencies by using a single shared cache, and you won't need to update the application's logic to use tenant key prefixes or tenant-specific data structures.

Azure Cache for Redis imposes [limits on the number of databases that can be created on a single cache](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-cache-for-redis-limits). Ensure that you understand the number of tenants that you'll grow to, before you implement this approach.

Additionally, this approach doesn't provide any benefits for security isolation of data. In Azure Cache for Redis, authentication and authorization are performed at the cache instance level.

> [!NOTE]
> Azure Cache for Redis supports multiple databases on specific tiers, and it doesn't support multiple databases when you use clustered instances.

### Cache instance per tenant

You might consider deploying a separate instance of Azure Cache for Redis for each tenant. There's no limit to the number of caches you can deploy within a single Azure subscription. This approach provides the strongest level of data and performance isolation.

However, each cache is billed as a separate Azure resource, so as you grow to large numbers of tenants, you might incur more cost. Furthermore, this approach often doesn't make efficient use of each cache's resources, since each Azure Cache for Redis instance generally supports large volumes of requests. It's best to only consider this isolation approach if you have strict data or performance isolation requirements.

## Features of Azure Cache for Redis that support multitenancy

### Active geo-replication

Many multitenant solutions need to be geo-distributed. You might share a globally distributed application tier, with your application instances reading from and writing to a nearby cache to maintain acceptable performance. The Enterprise tier of Azure Cache for Redis supports [linking multiple caches together across regions, in an active-active configuration](/azure/azure-cache-for-redis/cache-high-availability#active-geo-replication).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Will Velida](http://linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure

Other contributors:

 * Carl Dacosta | Principal Software Engineering Manager, Azure Cache for Redis
 * [Kyle Teegarden](https://www.linkedin.com/in/kyleteegarden) | Senior Program Manager, Azure Cache for Redis 
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).
