---
title: Azure Managed Redis Considerations for Multitenancy
description: Learn about Azure Managed Redis features, like Microsoft Entra ID authentication, active geo-replication, and Redis modules, that you can use to improve the performance of multitenant systems.
author: PlagueHO
ms.author: dascottr
ms.date: 04/08/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure Managed Redis

[Azure Managed Redis](/azure/redis/overview) is an in-memory data store based on [Redis Enterprise](https://redis.io/about/redis-enterprise/) software. Azure Managed Redis is commonly used to improve your solution's performance, reduce the load on your database or other data-tier components, and minimize the amount of state stored on compute nodes.

This article describes some of the Azure Managed Redis features that are useful in multitenant solutions. It also provides links to guidance that can help you plan how to use Azure Managed Redis in your solution.

## Isolation models

When you work with a multitenant system that uses Azure Managed Redis, you need to determine the level of isolation that you want to use. Azure Managed Redis supports two primary isolation models.

The following table summarizes the differences between the main tenancy isolation models for Azure Managed Redis:

| Consideration | Shared cache instance | Cache instance per tenant |
| --- | --- | --- |
| **Data isolation** | Low. Use Redis data structures or key prefixes to identify each tenant's data. Your application enforces tenant separation. | High |
| **Performance isolation** | Low. All tenants share the same compute resources. | High |
| **Deployment complexity** | Low | Medium-high |
| **Operational complexity** | Low | Medium-high |
| **Resource cost** | Low | High |
| **Example scenario** | Large multitenant solution that has a shared application tier | Individual application instances for each tenant that require strict data and performance isolation |

### Shared cache instance

You might consider deploying a single cache and using it to store cached data for some or all of your tenants. This approach is commonly used when you have a single application instance that all of your tenants share.

Consider the following points when evaluating deploying a shared cache for multiple tenants:

- **Separation of data:** When you follow this approach, your application is solely responsible for keeping tenant data separated. You can use key prefixes to distinguish data from different tenants, but your application needs to be diligent about only accessing data for the tenant that it's working with. Alternatively, you can consider using Redis data structures, like [sets](https://redis.io/docs/latest/develop/data-types/#sets) or [hashes](https://redis.io/docs/latest/develop/data-types/#hashes), for each tenant's data. Each of these approaches supports large numbers of keys, so they can scale to many tenants. However, you need to manage authorization within your application instead of within the cache.

- **Tenant identifiers and key prefixes:** When you onboard a new tenant to a shared cache, establish a key prefix convention that is unique and collision-resistant, such as using a tenant identifier. If your solution uses Redis modules, plan your module selection at instance creation time because you can't add modules later. When you offboard a tenant, use the [`SCAN`](https://redis.io/commands/scan/) command with a tenant-specific pattern to identify and delete the tenant's keys. If you need to migrate a tenant from a shared cache to a dedicated instance, use the [import/export feature](/azure/redis/how-to-import-export-data) to transfer data.

    Azure Managed Redis is internally configured to use [clustering](/azure/redis/architecture#clustering) across all tiers and SKUs. Clustering can affect how you manage tenant data by introducing `CROSSSLOT` restrictions on multi-key commands. To avoid `CROSSSLOT` errors when you operate on data for a single tenant, consider using Redis [hash tags](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/#hash-tags), such as `{tenantId}`, as part of your key naming convention. Hash tags ensure that all keys for a single tenant are located on the same shard.

- **Cluster policy:** The choice of [cluster policy](/azure/redis/architecture#cluster-policies) affects your multitenancy approach. The OSS cluster policy provides the best performance but requires cluster-aware client libraries. The Enterprise cluster policy uses a single endpoint and is simpler to configure, but it can become a bottleneck at high throughput. The Non-Clustered policy is only available for instances of 25 GB or less, and is useful for migration scenarios from nonclustered Azure Cache for Redis instances.

- **Avoid noisy neighbor problems:** When you share a cache instance between tenants, consider that all of your tenants share the same underlying compute resources for the cache. This approach can be vulnerable to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Ensure that you follow best practices for Azure Managed Redis to use your cache's resources efficiently and to mitigate any noisy neighbor effects. Best practices include:

    - [Scaling](/azure/redis/best-practices-scale)
    - [Memory management](/azure/redis/best-practices-memory-management)
    - [Server load management](/azure/redis/best-practices-server-load)

    Consider monitoring your cache's resources, such as CPU and memory. If you observe resource pressure, consider the following mitigations:

    - Scale up to a cache tier that has higher levels of resources. Azure Managed Redis provides [Memory Optimized, Balanced, and Compute Optimized tiers](/azure/redis/overview#choosing-the-right-tier), each with different memory-to-vCPU ratios.
    - Scale out to multiple caches by sharding your cached data. One option is to shard by tenant, where some tenants use cache A and some use cache B. Or you can shard by subsystem, where one part of your solution caches data for all tenants to cache A, and another part of your solution caches onto cache B.

- **Limits:** Each Azure Managed Redis SKU has a [maximum number of client connections](/azure/redis/overview#maximum-number-of-client-connections). This limit increases with higher performance tiers and larger instance sizes. When you plan how many tenants to serve from a shared cache, consider whether the total number of connections from all tenants might approach this limit.

- **Cost allocation:** When multiple tenants share a cache, measuring each tenant's cost contribution is challenging because Azure Managed Redis billing is at the instance level. Consider implementing application-level metering to track per-tenant resource consumption. For dedicated instances, use Azure resource tags to attribute costs to individual tenants.

### Cache instance per tenant

You might consider deploying a separate instance of Azure Managed Redis for each tenant. There's no limit to the number of caches that you can deploy within a single Azure subscription. This approach provides the strongest level of data and performance isolation. Each tenant's instance can also be configured with a different tier, such as Compute Optimized for premium tenants and Balanced for standard tenants.

Consider the following points when evaluating deploying a cache for each tenant:

- **Cost management:** Each cache is billed as a separate Azure resource. This isolation model means that as you grow to large numbers of tenants, you might incur more cost. Furthermore, this approach often doesn't make efficient use of each cache's resources because each Azure Managed Redis instance generally supports large volumes of requests. It's best to only consider this isolation approach if you have strict data or performance isolation requirements.

- **Networking:** Azure Managed Redis uses [private endpoints](/azure/redis/private-link) for network isolation. VNet injection isn't supported. If your solution requires per-tenant network isolation, each tenant needs a separate cache instance with its own private endpoint.

- **Encryption:** Azure Managed Redis encrypts data in transit via TLS and supports [customer-managed keys (CMK)](/azure/redis/how-to-encryption) for disk encryption. CMK is scoped per cache instance, not per tenant. Data stored in memory isn't encrypted by the service. If your tenants have strict data protection requirements, consider implementing application-level encryption before writing sensitive data to the cache.

## Features of Azure Managed Redis that support multitenancy

The following Azure Managed Redis features support multitenancy.

### Microsoft Entra ID authentication

Azure Managed Redis uses [Microsoft Entra ID for authentication by default](/azure/redis/entra-for-authentication). When you create a new cache, access key authentication is disabled. You add individual Microsoft Entra users or service principals to the cache instance's Redis users list.

Authenticated users receive full data access to all keys in the cache. Azure Managed Redis doesn't currently support custom data access policies that restrict access to specific keys or key patterns. In multitenant solutions, the lack of key-level access restriction means that you can't restrict a specific identity to access only a specific tenant's keys within a shared cache. If your solution requires per-tenant access control at the cache level, consider using separate cache instances for each tenant.

### Active geo-replication

Many multitenant solutions need to be geo-distributed. You might share a globally distributed application tier. In this scenario, your application instances read from and write to a nearby cache to maintain acceptable performance. Azure Managed Redis supports [linking multiple caches together across regions in an active-active configuration](/azure/redis/how-to-active-geo-replication).

### Redis modules

Azure Managed Redis supports [Redis modules](/azure/redis/redis-modules), which extend the core Redis data structures with additional functionality. The following list contains some Redis modules that can be useful in multitenant solutions:

- **RediSearch** provides full-text search, secondary indexing, and [vector similarity search](https://redis.io/solutions/vector-search/). In a multitenant context, you can create per-tenant search indexes within a shared cache instance.
- **RedisJSON** enables you to store and query JSON-formatted data. You can use RedisJSON to store structured tenant-specific documents.
- **RedisBloom** adds probabilistic data structures like bloom filters and cuckoo filters that are useful for deduplication across tenants.
- **RedisTimeSeries** provides optimized time series storage that can be useful for per-tenant telemetry or monitoring data. RedisTimeSeries isn't available on the Flash Optimized tier.

> [!NOTE]
> Some modules requires your cache instance to have specific configuration.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI

Other contributors:

- [Philip Laussermair](https://www.linkedin.com/in/philip-laussermair/) | Senior Solutions Architect, Redis Inc

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Storage and data approaches for multitenancy](../approaches/storage-data.md)
- [Multitenancy and Azure Cache for Redis](cache-redis.md)
- [Cache-Aside pattern](../../../patterns/cache-aside.yml)
- [Sharding pattern](../../../patterns/sharding.md)
- [Migrate to Azure Managed Redis](/azure/redis/migrate/migrate-basic-standard-premium-overview)
