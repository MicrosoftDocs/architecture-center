---
title: Azure Cache for Redis Considerations for Multitenancy
description: Learn about Azure Cache for Redis features, like access control lists and active geo-replication, that you can use to improve the performance of multitenant systems.
author: johndowns
ms.author: pnp
ms.date: 06/16/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure Cache for Redis

Azure Cache for Redis is commonly used to improve your solution's performance, reduce the load on your database or other data-tier components, and minimize the amount of state stored on compute nodes. This article describes some of the Azure Cache for Redis features that are useful in multitenant solutions. It also provides links to guidance that can help you plan how to use Azure Cache for Redis in your solution.

## Isolation models

When you work with a multitenant system that uses Azure Cache for Redis, you need to determine the level of isolation that you want to use. Azure Cache for Redis supports several isolation models.

The following table summarizes the differences between the main tenancy isolation models for Azure Cache for Redis:

| Consideration | Shared cache, shared database | Shared cache and database, access control list | Shared cache, database for each tenant | Cache for each tenant |
|---|---|---|---|
| **Data isolation** | Low. Use Redis data structures or key prefixes to identify each tenant's data. | High. Data is isolated based on key prefixes. | Low. Data is separated, but no security isolation is provided. | High |
| **Performance isolation** | Low. All tenants share the same compute resources. | Low. All tenants share the same compute resources. | Low. All tenants share the same compute resources. | High |
| **Deployment complexity** | Low | Low-medium | Medium | Medium-high |
| **Operational complexity** | Low | Low-medium | Low | Medium-high |
| **Resource cost** | Low | Low | Low | High |
| **Example scenario** | Large multitenant solution that has a shared application tier | Large multitenant solution that has distinct application identities that access the cache | Migration of a single-tenant application to be multitenant-aware | Individual application instances for each tenant |

### Shared cache instance and shared database

You might consider deploying a single cache that has a single Redis database, and using it to store cached data for all of your tenants. This approach is commonly used when you have a single application instance that all of your tenants share.

When you follow this approach, your application is solely responsible for keeping tenant data separated. You can use key prefixes to distinguish data from different tenants, but your application needs to be diligent about only accessing data for the tenant that it's working with. Alternatively, you can consider using Redis data structures, like [sets](https://redis.io/docs/latest/develop/data-types/#sets) or [hashes](https://redis.io/docs/latest/develop/data-types/#hashes), for each tenant's data. Each of these approaches supports large numbers of keys, so they can scale to many tenants. However, you need to manage authorization within your application instead of within the cache.

When you share a cache instance and database between tenants, consider that all of your tenants share the same underlying compute resources for the cache. This approach can be vulnerable to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Ensure that you follow best practices for Azure Cache for Redis to use your cache's resources efficiently and to mitigate any noisy neighbor effects. Best practices include:

- [Scaling](/azure/azure-cache-for-redis/cache-best-practices-scale)
- [Memory management](/azure/azure-cache-for-redis/cache-best-practices-memory-management)
- [Server load](/azure/azure-cache-for-redis/cache-best-practices-server-load)

Consider monitoring your cache's resources, such as CPU and memory. If you observe resource pressure, consider the following mitigations:

- Scale up to a cache SKU or tier that has higher levels of resources.
- Scale out to multiple caches by sharding your cached data. One option is to shard by tenant, where some tenants use cache A and some use cache B. Or you can shard by subsystem, where one part of your solution caches data for all tenants to cache A, and another part of your solution caches onto cache B.

### Shared cache and database with access control lists

If your application tier uses distinct identities to access the cache for each tenant, use Redis [access control lists](#access-control-lists). Access control lists enable you to restrict access to tenants' information to specific identities. You identify the data that the identity is allowed to access based on key names or prefixes. This approach can be a good fit when you have distinct application instances for each tenant, or when you have a shared application that uses multiple identities to access downstream services based on the tenant context.

Similarly to the previous isolation model, sharing the cache and database means that you need to take precautions to avoid the noisy neighbor problem.

### Shared cache instance with a database per tenant

Another approach that you might consider is to deploy a single cache instance, and deploy tenant-specific Redis databases within the instance. This approach provides some degree of logical isolation of each tenant's data, but it doesn't provide any performance isolation or protection against noisy neighbors.

This approach might be useful for migration scenarios. For example, suppose you modernize a single-tenant application that isn't designed to work with multiple tenants, and you gradually convert it to be multitenancy-aware by including the tenant context in all requests. You can gain some cost efficiencies by using a single shared cache, and you don't need to update the application's logic to use tenant key prefixes or tenant-specific data structures.

Azure Cache for Redis imposes [limits on the number of databases that can be created on a single cache](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-cache-for-redis-limits). Before you implement this approach, consider the number of tenants that you expect to grow to.

This approach doesn't provide any benefits for security isolation of data. In Azure Cache for Redis, authentication and authorization are performed at the cache instance level.

> [!NOTE]
> Azure Cache for Redis supports multiple databases on specific tiers, and it doesn't support multiple databases when you use clustered instances.

### Cache instance per tenant

You might consider deploying a separate instance of Azure Cache for Redis for each tenant. There's no limit to the number of caches that you can deploy within a single Azure subscription. This approach provides the strongest level of data and performance isolation.

However, each cache is billed as a separate Azure resource. This isolation model means that as you grow to large numbers of tenants, you might incur more cost. Furthermore, this approach often doesn't make efficient use of each cache's resources because each Azure Cache for Redis instance generally supports large volumes of requests. It's best to only consider this isolation approach if you have strict data or performance isolation requirements.

## Features of Azure Cache for Redis that support multitenancy

The following Azure Cache for Redis features support multitenancy.

### Access control lists

Azure Cache for Redis provides a powerful [role-based access control system](/azure/azure-cache-for-redis/cache-configure-role-based-access-control), which enables you to create comprehensive data access policies to enforce your authentication and authorization rules. You can specify these rules at varying levels of granularity, including to allow a user access to cache keys that follow a specific pattern. By using key patterns, you can share a single cache instance and database between multiple tenants that each have their own user accounts. Azure Cache for Redis enforces tenant isolation to ensure that a user can only access their own set of keys that follow the pattern.

For example, suppose that you have a tenant named Fabrikam. Your application tier should only be able to access cache data relating to Fabrikam, and not from other tenants. You might define a custom access policy that allows reading and setting all cache keys that begin with `Fabrikam`:

```
+@read +set ~Fabrikam*
```

You can then assign the policy to the Microsoft Entra identity that your Fabrikam application instance uses. After you configure your cache, the Fabrikam user can access keys named `FabrikamData1` and `FabrikamUserDetails`, but not `ContosoData1`.

### Active geo-replication

Many multitenant solutions need to be geo-distributed. You might share a globally distributed application tier. In this scenario, your application instances read from and write to a nearby cache to maintain acceptable performance. The Enterprise tier of Azure Cache for Redis supports [linking multiple caches together across regions in an active-active configuration](/azure/azure-cache-for-redis/cache-high-availability#active-geo-replication).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Will Velida](https://www.linkedin.com/in/willvelida/) | Customer Engineer 2, FastTrack for Azure

Other contributors:

- Carl Dacosta | Principal Software Engineering Manager, Azure Cache for Redis
- [Kyle Teegarden](https://www.linkedin.com/in/kyleteegarden/) | Senior Program Manager, Azure Cache for Redis
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

[Storage and data approaches for multitenancy](../approaches/storage-data.md)
