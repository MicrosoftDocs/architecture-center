---
title: Azure Managed Redis Considerations for Multitenancy
description: Learn about Azure Managed Redis features, like Microsoft Entra ID authentication, active geo-replication, and Redis modules, that you can use to improve the performance of multitenant systems.
author: PlagueHO
ms.author: dascottr
ms.date: 10/22/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Multitenancy and Azure Managed Redis

[Azure Managed Redis](/azure/redis/overview) is an in-memory data store based on [Redis Enterprise](https://redis.io/about/redis-enterprise/) software. Azure Managed Redis is commonly used to improve your solution's performance, reduce the load on your database or other data-tier components, and minimize the amount of state stored on compute nodes.

This article describes partitioning strategies, isolation models, and Azure Managed Redis features for multitenant solutions.

## Partitioning strategies

Each Azure Managed Redis instance uses an internal clustered architecture. Depending on the SKU and cluster policy, an instance can use one or more *shards*. Azure Managed Redis controls the number and placement of shards.

Internal sharding distributes data and request load, but it doesn't provide tenant isolation. Tenants in one instance still share compute, memory, connections, configuration, and eviction behavior. For tenant isolation options, see [Isolation models](#isolation-models).

### Choose a cluster policy

Azure Managed Redis provides three cluster policies. The policy affects client connectivity, request routing, throughput, module compatibility, and multikey operations:

- **OSS:** Uses the Redis Cluster API and generally provides the highest throughput. It requires a cluster-aware client that connects directly to shards and handles cluster topology and redirections. The service distributes keys across hash slots.
- **Enterprise:** Provides a single proxy endpoint, so clients don't need to support the Redis Cluster API. The proxy routes requests to shards but can become a throughput bottleneck. Enterprise is the only cluster policy that supports the RediSearch module.
- **Non-clustered:** Stores data without sharding and is available only for instances of 25 GB or less. Consider this policy for migration from a nonsharded Redis deployment or when the workload extensively uses operations that can't span hash slots. Non-clustered instances generally provide less throughput than clustered instances.

Choose the cluster policy when you create the instance. You can't change an OSS or Enterprise policy after creation without recreating the instance, but you can change a non-clustered instance to a clustered configuration. For more information, see [Azure Managed Redis cluster policies](/azure/redis/architecture#cluster-policies).

Use a supported client for the selected policy instead of implementing your own shard map or node-routing logic.

Applications interact with Azure Managed Redis as a single logical database rather than addressing specific shards. During supported scale-up operations, Azure Managed Redis adds resources and redistributes data across shards. This abstraction isn't completely transparent: client and network configuration must support the selected cluster policy, and hash-slot restrictions still affect key and transaction design.

Applications don't manage physical shard placement or repartition data explicitly. Instead, partition-aware design focuses on cluster-policy compatibility, key structure, hash-slot distribution, access patterns, multikey operations, and data lifecycle.

### Design tenant keys and hash slots

Use a unique and stable tenant prefix, such as `tenantId:`, to identify a tenant's keys. A prefix supports application routing, metering, data access permissions, and tenant lifecycle operations, but it doesn't force keys into the same hash slot or provide tenant isolation by itself.

With OSS clustering, use a [Redis hash tag](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/#hash-tags), such as `{tenantId}`, only when related keys must occupy the same hash slot for a multikey command or transaction. Don't automatically place every key for a large tenant in one hash slot. Doing so can create a *hot shard*, which handles a disproportionate share of data or requests and becomes a bottleneck while other shards have unused capacity. In a multitenant instance, a hot shard can limit that tenant's scale and affect other tenants whose keys share the shard. Use a narrower transactional boundary or multiple stable buckets when a tenant's load needs to span slots.

Keep values small and bounded. When groups of data have different access or update patterns, store them under separate keys. If the application must retrieve or update those keys together, design the keys for the cluster policy and commands that the application uses. A key prefix or hash slot isn't an authorization or tenant-isolation boundary.

### Plan multikey operations and transactions

Multikey behavior depends on the cluster policy and whether active geo-replication is enabled:

- With OSS clustering, all keys in a multikey command or transaction must map to the same hash slot.
- With Enterprise clustering, only specific multikey commands can operate across slots.
- With active geo-replication, multikey write commands have additional same-slot restrictions.

If a command uses keys in an unsupported combination of hash slots, Azure Managed Redis returns a `CROSSSLOT` error.

Redis transactions provide isolated, sequential execution, but they don't provide rollback semantics. Redis validates commands as they're queued. If a command can't be queued, Redis rejects `EXEC` and discards the transaction. After `EXEC` begins, a runtime error in one command doesn't roll back commands that already succeeded or prevent the remaining queued commands from running. Design and test key placement against the commands and transaction behavior that your application requires.

For the policy-specific command matrix, see [Multikey commands in Azure Managed Redis](/azure/redis/architecture#multi-key-commands). For transaction behavior, see [Redis transactions](https://redis.io/docs/latest/develop/using-commands/transactions/).

### Choose tenant data structures

Choose Redis data structures based on the workload's access patterns. Use bounded aggregate structures, such as lists, sets, sorted sets, or hashes, when the application commonly reads or updates related tenant values together.

Grouping related values under one key can reduce network round trips and avoid cross-slot multikey operations. However, large aggregates can create hot keys and increase latency. Use separate keys when values have different access patterns or require independent updates, expiration, or authorization. Splitting the properties of a logical entity across separate keys is called *vertical partitioning*.

For structures provided by modules, see [Redis modules](#redis-modules).

For example, consider a multitenant product-ordering system:

- **Product catalog:** Use vertical partitioning. Store commonly accessed product fields under a key such as `tenant:42:product:99` and less frequently accessed details under `tenant:42:product:99:details`. This approach lets the application retrieve common data without also retrieving the detailed data. It also applies key-level expiration independently for the common fields and the details.

    Redis hashes support reading individual fields, so evaluate whether separate keys provide enough benefit to justify the extra commands and hash-slot considerations.

- **Customer orders:** Store a customer's profile in a hash and maintain a set of order IDs that refer to separate order keys. For customer `99` in tenant `42`, use keys such as `tenant:42:customer:99:profile` and `tenant:42:customer:99:orders`. Redis doesn't enforce relationships between keys, so the application is responsible for maintaining referential integrity.

If an OSS-cluster multikey operation must access related keys, assign them a narrow shared hash tag. For example, use `tenant:42:customer:{42:99}:profile` and `tenant:42:customer:{42:99}:orders` to place the two customer keys in the same hash slot.

## Isolation models

After you plan internal data distribution and key placement, determine the level of tenant isolation to apply. Azure Managed Redis supports two primary isolation models: *shared Azure Managed Redis instance* and *Azure Managed Redis instance per tenant*.

The following table summarizes the differences between the two isolation models.

| Consideration | Shared instance | Instance per tenant |
| --- | --- | --- |
| **Data isolation** | Low. Use Redis data structures or key prefixes to identify each tenant's data. Your application enforces tenant separation. | High |
| **Performance isolation** | Low. All tenants share the same compute resources. | High |
| **Deployment complexity** | Low | Medium-high |
| **Operational complexity** | Low | Medium-high |
| **Resource cost** | Low | High |
| **Example scenario** | Large multitenant solution that has a shared application tier | Individual application instances for each tenant to enforce strict data and performance isolation |

### Shared instance

In this model, you deploy a single Azure Managed Redis instance and use it to store data for some or all of your tenants. Use this approach when you have a single application instance that all of your tenants share.

Consider the following points when evaluating whether to deploy a shared instance for multiple tenants:

- **Separation of data:** When you follow this approach, your application is responsible for keeping tenant data separate. Use key prefixes to distinguish tenants, and enforce authorization through application logic. For instances that don't use Redis modules, you can also consider [custom data access permissions](#microsoft-entra-id-authentication), which are in preview. Some Redis data structures, like [sets](https://redis.io/docs/latest/develop/data-types/#sets) or [hashes](https://redis.io/docs/latest/develop/data-types/#hashes), can group related tenant data. For key distribution and hash-slot considerations, see [Partitioning strategies](#partitioning-strategies).

- **Tenant identifiers and key prefixes:** When you onboard a tenant to a shared instance, establish a unique and collision-resistant convention for key prefixes, like a tenant identifier. A prefix helps you identify, meter, and manage the tenant's keys, but it doesn't enforce authorization.

- **Data lifecycle and durability:** Azure Managed Redis is designed for ephemeral data by default. Don't use it as the authoritative system of record. Keep authoritative data and data that can't be reconstructed in durable storage when data loss is unacceptable.

    [Persistence](/azure/redis/how-to-persistence) requires high availability and can't be used with active geo-replication. It supports automatic recovery to the same instance, but it isn't a retained backup or point-in-time recovery feature.

    Automate [exports](/azure/redis/how-to-import-export-data) when you need retained backups or recovery into another instance. To migrate a tenant to a dedicated instance, use an application-controlled process that copies only that tenant's data. Exports are instance-wide snapshots, so don't directly import a shared instance's export into a tenant's dedicated instance.

    Set workload-appropriate time-to-live (TTL) values and an eviction policy. In a shared instance, all tenants share memory capacity and the eviction policy, so memory pressure from one tenant can affect cached data for other tenants. Design applications to tolerate evictions and reconstruct cached data.

    When you offboard a tenant, use the [SCAN](https://redis.io/docs/latest/commands/scan/) command with a tenant-specific pattern to identify and delete the tenant's keys.

- **Avoid noisy neighbor problems:** When your tenants share an instance, those tenants share the same underlying compute resources. This approach is vulnerable to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), where the activity of one tenant can negatively affect another tenant's use of the system. Follow Azure Managed Redis best practices to use the instance's resources efficiently and mitigate noisy neighbor effects:

    - [Scaling](/azure/redis/best-practices-scale)
    - [Memory management](/azure/redis/best-practices-memory-management)
    - [Server load management](/azure/redis/best-practices-server-load)

    Monitor the instance's resources, such as CPU and memory. If you observe strain, consider the following mitigations:

    - Scale up to a tier that has more resources. Azure Managed Redis provides [Memory Optimized, Balanced, and Compute Optimized tiers](/azure/redis/overview#choosing-the-right-tier), each with different memory-to-vCPU ratios.

    - Scale out to multiple instances by sharding your cached data. One option is to shard by tenant, where groups of tenants use different instances. Another option is to shard by subsystem, where one part of your solution caches data for all tenants in one instance, and another part caches data in another instance.

- **Limits:** Each Azure Managed Redis tier has a [maximum number of client connections](/azure/redis/overview#maximum-number-of-client-connections). This limit increases with higher performance tiers and larger instance sizes. When you plan how many tenants to serve from a shared instance, consider whether the total number of connections from all tenants might approach this limit.

- **Cost allocation:** When multiple tenants share an instance, measuring each tenant's cost contribution is challenging because Azure Managed Redis bills at the instance level. Consider implementing application-level metering to track per-tenant resource consumption. For dedicated instances, use Azure resource tags to attribute costs to individual tenants.

### Instance per tenant

In this model, you deploy a separate Azure Managed Redis instance for each tenant. There's no limit to the number of instances that you can deploy within a single Azure subscription. This approach provides the strongest level of data and performance isolation. You can also configure each tenant's instance with a different tier, such as Compute Optimized for premium tenants and Balanced for standard tenants.

Consider the following points when evaluating whether to deploy an instance for each tenant:

- **Cost management:** Each instance is billed as a separate Azure resource. This isolation model might incur more cost as you grow to large numbers of tenants. Also, this approach often doesn't make efficient use of each instance's resources because Azure Managed Redis instances generally support large volumes of requests. Consider this isolation approach only if you have strict data or performance isolation requirements.

- **Networking:** Azure Managed Redis uses [private endpoints](/azure/redis/private-link) for network isolation. Virtual network injection isn't supported. If your solution requires per-tenant network isolation, each tenant needs a separate instance with its own private endpoint.

- **Encryption:** Azure Managed Redis encrypts data in transit via Transport Layer Security (TLS) and supports [customer-managed keys](/azure/redis/how-to-encryption) for disk encryption. Customer-managed keys are scoped per instance, not per tenant. The service doesn't encrypt data stored in memory. If your tenants have strict data protection requirements, consider implementing application-level encryption before writing sensitive data to the instance.

## Features of Azure Managed Redis that support multitenancy

The following Azure Managed Redis features support multitenancy.

### Microsoft Entra ID authentication

Azure Managed Redis uses [Microsoft Entra ID for cache authentication](/azure/redis/entra-for-authentication) by default. When you create a new instance, managed identity is turned on. You add individual Microsoft Entra users or service principals to the instance's Redis users list.

Authenticated users receive full data access to all keys in the instance by default. Azure Managed Redis supports [custom data access permissions (preview)](/azure/redis/configure-access-permissions) that can restrict access to specific keys or key patterns. You can restrict an identity's access to only the keys that belong to a specific tenant. If your solution requires per-tenant access control beyond key-pattern restrictions, consider using separate instances for each tenant.

Custom data access permissions aren't supported on instances that have Redis modules enabled. For module-enabled shared instances, enforce tenant authorization in the application or use separate instances when tenants require independent access boundaries.

### Active geo-replication

Many multitenant solutions need to be geo-distributed. You might share a globally distributed application tier. In this scenario, your application instances read from and write to a nearby Azure Managed Redis instance to maintain acceptable performance. Azure Managed Redis supports [active geo-replication](/azure/redis/how-to-active-geo-replication). You can link multiple instances across regions in an active-active configuration.

If you enable active geo-replication, all linked instances must use the same cluster policy, and you can't change the policy afterward. For more information, see [Azure Managed Redis cluster policies](/azure/redis/architecture#cluster-policies).

### Redis modules

Azure Managed Redis supports [Redis modules](/azure/redis/redis-modules), which provide extra functionality to the core Redis data structures. The following list contains some Redis modules that can be useful in multitenant solutions:

Select and enable the required modules when you create the Azure Managed Redis instance. You can't manually add modules later.

- **RediSearch** provides full-text search, secondary indexing, and [vector similarity search](/azure/redis/overview-vector-similarity). In a multitenant context, you can create per-tenant search indexes within a shared instance.

- **RedisJSON** lets you store and query JSON-formatted data. You can use RedisJSON to store structured tenant-specific documents.
- **RedisBloom** adds probabilistic data structures, like bloom filters and cuckoo filters, that are useful for deduplication across tenants.
- **RedisTimeSeries** provides optimized time-series storage that can be useful for per-tenant telemetry or monitoring data. RedisTimeSeries isn't available on the Flash Optimized tier.

> [!NOTE]
> Some modules require your instance to have specific configuration.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI

Other contributor:

- [Philip Laussermair](https://www.linkedin.com/in/philip-laussermair/) | Senior Solutions Architect, Redis Inc

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural approaches for storage and data in multitenant solutions](../approaches/storage-data.md)
- [Cache-Aside pattern](../../../patterns/cache-aside.yml)
- [Write-through caching with Azure Managed Redis and Azure SQL Database](../../../databases/architecture/write-through-caching-azure-sql-managed-redis.yml)
- [Sharding pattern](../../../patterns/sharding.md)
- [Migrate from Azure Cache for Redis to Azure Managed Redis](/azure/redis/migrate/migrate-basic-standard-premium-overview)
