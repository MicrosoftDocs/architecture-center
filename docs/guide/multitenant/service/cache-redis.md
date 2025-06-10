---
title: Azure Cache for Redis considerations for multitenancy
description: This article describes the features of Azure Cache for Redis that are useful when you work with multitenant systems, and it provides links to guidance for how to use Azure Cache for Redis in a multitenant solution.
author: landonpierce
ms.author: landonpierce
ms.date: 07/09/2024
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom:
  - guide
  - arb-saas
---

# Multitenancy and Azure Cache for Redis

Azure Cache for Redis is commonly used to increase the performance of your solution, to reduce the load on your database or other data-tier components, and to reduce the amount of state that you store on compute nodes. In this article, we describe some of the features of Azure Cache for Redis that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Azure Cache for Redis.

## Isolation models

When working with a multitenant system that uses Azure Cache for Redis, you need to make a decision about the level of isolation you want to use. Azure Cache for Redis supports several isolation models.

The following table summarizes the differences between the main tenancy isolation models for Azure Cache for Redis:

| Consideration | Shared cache, shared database | Shared cache and database, access control list | Shared cache, database per tenant | Cache per tenant |
|---|---|---|---|
| **Data isolation** | Low. Use Redis data structures or key prefixes to identify each tenant's data | High. Data is isolated based on key prefixes | Low. Data is separated but no security isolation is provided | High |
| **Performance isolation** | Low. All tenants share the same compute resources | Low. All tenants share the same compute resources | Low. All tenants share the same compute resources | High |
| **Deployment complexity** | Low | Low-medium | Medium | Medium-high |
| **Operational complexity** | Low | Low-medium | Low | Medium-high |
| **Resource cost** | Low | Low | Low | High |
| **Example scenario** | Large multitenant solution with a shared application tier | Large multitenant solution with distinct application identities that access the cache | Migrating a single-tenant application to be multitenant-aware | Individual application instances per tenant |

### Shared cache instance and shared database

You might consider deploying a single cache, with a single Redis database, and using it to store cached data for all of your tenants. This approach is commonly used when you have a single application instance that all of your tenants share.

When you follow this approach, your application is solely responsible for keeping tenant data separated. You can use key prefixes to distinguish data from different tenants, but your application needs to be diligent about only accessing data for the tenant it's working with. Alternatively, you can consider using Redis data structures, like [sets](https://redis.io/docs/latest/develop/data-types/#sets) or [hashes](https://redis.io/docs/latest/develop/data-types/#hashes), for each tenant's data. Each of these approaches supports large numbers of keys, so they can scale to many tenants. However, you need to manage authorization within your application instead of within the cache.

When you share a cache instance and database between tenants, consider that all of your tenants share the same underlying compute resources for the cache. So, this approach can be vulnerable to the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Ensure that you follow the best practices for Azure Cache for Redis to make the most efficient use of your cache's resources and to mitigate any noisy neighbor effects. Best practices include:

- [Scaling](/azure/azure-cache-for-redis/cache-best-practices-scale)
- [Memory management](/azure/azure-cache-for-redis/cache-best-practices-memory-management)
- [Server load](/azure/azure-cache-for-redis/cache-best-practices-server-load)

Additionally, consider monitoring your cache's resources, such as CPU and memory. If you observe resource pressure, consider the following mitigations:

- Scale up to a cache SKU or tier with higher levels of resources.
- Scale out to multiple caches by sharding your cached data. One option is to shard by tenant, where some tenants use cache A and some use cache B. Or you can shard by subsystem, where one part of your solution caches data for all tenants to cache A, and another part of your solution caches onto cache B.

### Shared cache and database with access control lists

If your application tier uses distinct identities to access the cache for each tenant, use Redis [access control lists](#access-control-lists). Access control lists enable you to restrict access to tenants' information to specific identities. You identify the data the identity is allowed to access based on key names or prefixes. This approach can be a good fit when you have distinct application instances for each tenant, or if you have a shared application that uses multiple identities to access downstream services based on the tenant context.

Similarly to the previous isolation model, sharing the cache and database means that you need to take precautions to avoid the Noisy Neighbor problem.

### Shared cache instance with a database per tenant

Another approach you might consider is to deploy a single cache instance, and deploy tenant-specific Redis databases within the instance. This approach provides some degree of logical isolation of each tenant's data, but it doesn't provide any performance isolation or protection against noisy neighbors.

This approach might be useful for migration scenarios. For example, suppose you modernize a single-tenant application that isn't designed to work with multiple tenants, and you gradually convert it to be multitenancy-aware by including the tenant context in all requests. You can gain some cost efficiencies by using a single shared cache, and you don't need to update the application's logic to use tenant key prefixes or tenant-specific data structures.

Azure Cache for Redis imposes [limits on the number of databases that can be created on a single cache](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-cache-for-redis-limits). Before implementing this approach, consider the number of tenants that you expect to grow to.

Additionally, this approach doesn't provide any benefits for security isolation of data. In Azure Cache for Redis, authentication and authorization are performed at the cache instance level.

> [!NOTE]
> Azure Cache for Redis supports multiple databases on specific tiers, and it doesn't support multiple databases when you use clustered instances.

### Cache instance per tenant

You might consider deploying a separate instance of Azure Cache for Redis for each tenant. There's no limit to the number of caches you can deploy within a single Azure subscription. This approach provides the strongest level of data and performance isolation.

However, each cache is billed as a separate Azure resource, so as you grow to large numbers of tenants, you might incur more cost. Furthermore, this approach often doesn't make efficient use of each cache's resources, since each Azure Cache for Redis instance generally supports large volumes of requests. It's best to only consider this isolation approach if you have strict data or performance isolation requirements.

## Features of Azure Cache for Redis that support multitenancy

### Access control lists

Azure Cache for Redis provides a powerful [role-based access control system](/azure/azure-cache-for-redis/cache-configure-role-based-access-control), which enables you to create comprehensive data access policies to enforce your authentication and authorization rules. These rules can be specified at varying levels of granularity, including to allow a user access to cache keys that follow a specific pattern. By using key patterns, you can share a single cache instance and database between multiple tenants, each with their own user accounts. Azure Cache for Redis enforces tenant isolation to ensure that a user can only access their own set of keys that follow the pattern.

For example, suppose you have a tenant named Fabrikam. Your application tier should only be able to access cache data relating to Fabrikam, and not from other tenants. You might define a custom access policy that allows reading and setting all cache keys that begin with `Fabrikam`:

```
+@read +set ~Fabrikam*
```

You can then assign the policy to the Microsoft Entra identity that your Fabrikam application instance uses. After you configure your cache, the Fabrikam user can access keys named `FabrikamData1` and `FabrikamUserDetails`, but not `ContosoData1`.

### Active geo-replication

Many multitenant solutions need to be geo-distributed. You might share a globally distributed application tier, with your application instances reading from and writing to a nearby cache to maintain acceptable performance. The Enterprise tier of Azure Cache for Redis supports [linking multiple caches together across regions, in an active-active configuration](/azure/azure-cache-for-redis/cache-high-availability#active-geo-replication).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer
- [Will Velida](https://www.linkedin.com/in/willvelida/) | Customer Engineer 2, FastTrack for Azure

Other contributors:

- Carl Dacosta | Principal Software Engineering Manager, Azure Cache for Redis
- [Kyle Teegarden](https://www.linkedin.com/in/kyleteegarden/) | Senior Program Manager, Azure Cache for Redis
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).
