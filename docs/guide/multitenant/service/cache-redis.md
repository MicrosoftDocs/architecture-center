---
title: Azure Cache for Redis considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Cache for Redis that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Cache for Redis in a multitenant solution.
author: willvelida
ms.author: willvelida
ms.date: 6/20/2022
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

Azure Cache for Redis is commonly used to increase the performance of your solution, to reduce the load on your database or other data tier components, and to reduce the amount of state stored on compute nodes. On this page, we describe some of the features of Azure Cache for Redis that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Azure Cache for Redis.

## Isolation models

- Cache instance per tenant
  - Cost - there's a minimum size and cost for each instance, so with many tenants it can be expensive
  - No limit to the number of instances in a subscription.
- Database per tenant
  - Provides logical isolation
  - Doesn't work with clustered instances, and only applies to basic/standard/premium
  - There's a limit of how many databases can be on a cache instance (see https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-cache-for-redis-limits)
  - Could be useful for migration scenarios, where you're taking a single-tenant application (which is not aware of multitenancy) and using a single shared cache, but without being able to update the application's logic to use tenant key prefixes or tenant-specific data structures.
  - But:
    - Authorization applies to the whole cache
    - Share compute resources, so subject to [Noisy Neighbor problem](https://docs.microsoft.com/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor)
    - Migration to another cache requires manual intervention
- Single cache instance and database shared among all tenants
  - Can use either key prefixes or data structures like [Sets](https://redis.io/docs/manual/data-types/#sets) or [Hashes](https://redis.io/docs/manual/data-types/#hashes) for each tenant's data. Redis Sets support large numbers of keys.
  - Authorization applies to the whole cache, not per tenant
  - All tenants will share compute resources, so subject to [Noisy Neighbor problem]
    - So follow [Redis best practices] to make most efficient use of your cache resources
    - Also monitor your cache resources, and if you start to see it being exhausted, consider sharding across multiple caches. You can either shard vertically (i.e. some tenants on cache A, some on cache B), or you can shard horizontally (i.e. one part of your solution caches data for all tenants to cache A, and another part of your solution caches onto instance B)

## Features of Azure Cache for Redis that support multitenancy

### Active geo-replication

- Many multitenant solutions need to be geo-distributed. You might share an globally distributed application tier and the applications need to access a local cache for high performance.
- [Multiple caches can be linked together in active-active configuration](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/how-to-utilize-active-geo-replication-in-azure-cache-for-redis/ba-p/3074404) ([docs](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-high-availability#active-geo-replication))
- Enterprise tier only.

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Will Velida](http://linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure

Other contributors:

 * [John Downs](http://linkedin.com/in/john-downs) | Senior Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
