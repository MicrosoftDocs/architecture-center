This article shows how an Azure App Service web application that uses Azure Database for PostgreSQL as the system of record can use Azure Managed Redis in a cache-aside pattern to store frequently requested data and reduce repeated database reads.

For reads, the application checks Azure Managed Redis first. If Redis doesn't contain the requested key, the application queries the Azure Database for PostgreSQL database for the information, returns the result to the requesting client, and stores the result in Redis with a time to live (TTL).

For writes, the application commits changes to Azure Database for PostgreSQL and invalidates any affected Redis keys. On the next read, the application retrieves the current data from Azure Database for PostgreSQL and repopulates the Azure Managed Redis cache. This sequence follows the [Cache-Aside pattern](../../patterns/cache-aside.yml).

> [!IMPORTANT]
> Use this architecture when the application can tolerate short periods of stale data. If clients must receive new cached values immediately after an application-controlled write, consider write-through caching instead.

## Architecture

:::image type="complex" border="false" source="./_images/cache-aside-azure-managed-redis-postgresql.png" alt-text="Diagram that shows cache-aside caching with Azure Managed Redis and Azure Database for PostgreSQL." lightbox="./_images/cache-aside-azure-managed-redis-postgresql.png":::
   Numbered green circles show read flow. 1. A client sends an HTTPS read request to an App Service app inside a virtual network. 2. An arrow labeled Check Redis for key points from the app to the Azure Managed Redis private endpoint. 3. An arrow labeled Cache hit: Return data points from the cache endpoint to the app. 4. An arrow labeled Cache miss: Query PostgreSQL points from the app to the PostgreSQL private endpoint. 5. An arrow labeled Return PostgreSQL results to client points from the PostgreSQL endpoint to the app. 6. An arrow labeled Store results in Redis with TTL points from the app to the cache endpoint. Numbered blue boxes show write flow. 1. The client sends an HTTPS write request to the app. 2. An arrow labeled Write and commit authoritative data points from the app to the PostgreSQL endpoint. 3. An arrow labeled Invalidate affected Redis keys. Next read repopulates cache points from the app to the cache endpoint. Arrows point from the application tier, cache, and PostgreSQL to Azure Monitor.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/cache-aside-azure-managed-redis-postgresql.vsdx) of this architecture.*

### Data flow

App Service handles application reads and writes. Azure Database for PostgreSQL flexible server is the system of record. Azure Managed Redis stores cached values that the application can re-create from PostgreSQL.

The following steps correspond to the numbers on the architecture diagram.

#### Read flow

1. A client sends an HTTPS read request to the application that runs on App Service.

1. The application creates a cache key and checks Azure Managed Redis for the key.

1. If Redis contains the key, the application returns the cached value to the client.

1. If Redis doesn't contain the key, the application queries Azure Database for PostgreSQL for the value.

1. The application returns the value to the client.

1. The application attempts to store the query result in Redis with a TTL.

   If the cache fill fails, the application logs the failure and returns the PostgreSQL value to the client without caching it. A later request can attempt to populate the cache again.

The application loads data into the cache only when the application needs the data. A later request for the same key can use Redis instead of running the PostgreSQL query again.

#### Write and invalidation flow

1. A client sends an HTTPS write request to the application that runs on App Service.

1. The application writes the authoritative data to Azure Database for PostgreSQL and commits the database transaction.

1. After the commit succeeds, the application invalidates any affected Redis keys.

The application commits the database transaction before it invalidates the cache keys. This order follows the standard cache-aside write sequence and keeps the existing cache entry if the database write fails.

The next read for an invalidated key follows the normal read flow. Redis reports a cache miss, so the application queries PostgreSQL and stores the current result in Redis.

> [!IMPORTANT]
> Every writer that changes cached PostgreSQL data must participate in cache invalidation. Route these writes through a controlled write path that commits the PostgreSQL transaction and then invalidates all affected Redis keys. Restrict direct database write permissions to prevent application identities from bypassing this path. If a batch job or integration must write directly to PostgreSQL, require it to record durable invalidation intent in the same transaction, or else don't cache the affected data. Otherwise, stale values can remain in Redis until their TTLs expire.

All the components in the workload, including Azure Database for PostgreSQL, are configured to send metrics and logs to Azure Monitor.

### Components

The following components implement this architecture.

- [Azure Managed Redis](/azure/redis/overview) is an in-memory distributed cache based on [Redis Enterprise](https://redis.io/about/redis-enterprise/). In this solution, Managed Redis stores frequently requested values and query results that the application can re-create from PostgreSQL. Redis isn't the system of record. Azure Managed Redis supports private endpoint connectivity and Microsoft Entra authentication.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) provides a fully managed hosting environment for building, deploying, and scaling web applications. In this solution, App Service hosts the web application or API and owns the cache-aside logic. It creates cache keys, reads Redis, queries PostgreSQL on cache misses, stores values in Redis, writes data to PostgreSQL, and invalidates Redis keys after successful writes.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is the system of record. All application writes commit to PostgreSQL before App Service invalidates the related Redis keys. In this architecture, the application reaches the flexible server through a private endpoint.

- [Azure Private Link](/azure/private-link/private-link-overview) provides private endpoint connectivity to Azure Managed Redis and Azure Database for PostgreSQL. The private endpoints provide private IP addresses that the application can reach through the virtual network.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) provides workload identities. App Service can use a managed identity to obtain Microsoft Entra tokens without storing application credentials. Azure Managed Redis uses Microsoft Entra authentication by default for new caches. Azure Database for PostgreSQL supports authentication by using system-assigned and user-assigned managed identities.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) provides network isolation for the workload. In this architecture, App Service uses virtual network integration to send and receive traffic through the virtual network to and from the Azure Managed Redis and Azure Database for PostgreSQL private endpoints. Private DNS resolves the service hostnames to their private IP addresses.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) collects metrics and logs from application and data services. Application telemetry with platform metrics measures cache use, Redis latency, PostgreSQL latency, and failures.

### Alternatives

Consider the following alternatives and their trade-offs.

- **Write-through caching:** Use write-through caching when clients must read the new cached value immediately after a successful application-controlled write. Write-through caching updates the system of record and the cache as part of the write workflow. It adds work and failure handling to the write path.

- **PostgreSQL read replicas:** Use read replicas when the main requirement is to move read traffic away from the primary server while keeping PostgreSQL query features. Azure Database for PostgreSQL read replicas use asynchronous PostgreSQL replication, so the application must account for replication lag.

- **Materialized views:** Use PostgreSQL materialized views when the database can create and maintain the required query result efficiently. This approach keeps the query in PostgreSQL and avoids adding a distributed cache.

## Scenario details

A web application stores business data in Azure Database for PostgreSQL, and many requests read the same data repeatedly. These repeated reads can increase PostgreSQL CPU use, I/O, connection use, and response time as traffic grows.

Examples include the following scenarios:

- Product and catalog data
- Customer profiles
- Account settings
- Configuration data
- Inventory summaries
- Query results that use joins or calculations
- API responses that require repeated database reads

Azure Managed Redis can store the result after the first read from PostgreSQL. Subsequent requests for the same cache key can return the cached value without using a database query.

The architecture uses the following rules:

- PostgreSQL is the system of record.
- Redis stores values that the application can re-create.
- App Service checks Redis before querying PostgreSQL.
- Cached values have a TTL.
- The application commits PostgreSQL writes before it invalidates Redis keys.
- The next read repopulates an invalidated cache entry.
- The application measures cache use and PostgreSQL fallback load.

The cache-aside pattern doesn't guarantee that Redis and PostgreSQL always contain the same value. A read can occur after a PostgreSQL commit but before the cache invalidation completes. If invalidation fails, the old value can remain until its TTL expires or the application removes the value.

### Cache key design

Use cache keys that the application can create in the same way for every request. Include every input that can produce a different result in the cache key, such as tenant ID, entity ID, locale, relevant query parameters, and schema version. Don't put sensitive data directly in cache key names.

Example keys include:

```text
tenant:42:customer:123:v2
tenant:42:product:456:v3
account:789:settings:v1
```

Use a schema version when an application deployment changes the format of a cached value. The version prevents a new application version from reading an incompatible cached value.

### TTL selection

Assign a TTL to each cached value. The TTL controls how long data remains in Redis, and also limits how long an old value can remain after a failed invalidation.

Select an appropriate TTL for the data. Data that changes often can allow a shorter TTL than stable reference data. If a TTL is too short, the application can make unnecessary PostgreSQL queries. If it's too long, stale data can remain in the cache for longer than the workload permits.

Avoid setting many related keys to expire at the same time. Add a small random variation to the TTL when simultaneous expiration could cause a large increase in PostgreSQL queries.

### Cache invalidation

A PostgreSQL write can affect one or more Redis keys. For example, a product update can affect all of the following keys:

```text
tenant:42:product:456:v3
tenant:42:category:12:page:1:v2
tenant:42:featured-products:v1
```

Keep the relationship between database writes and cache keys clear. The application must know which keys a write affects. If one write affects a large or unpredictable set of keys, reconsider the key design. A shorter TTL or a narrower cached result can be easier to manage. Don't use a full Redis key scan as the normal method to find keys for invalidation.

### Potential use cases

This architecture supports the following workloads:

- Applications that have high read volume and lower write volume
- Applications that repeat the same PostgreSQL queries
- APIs that need low read latency and can accept short periods of stale data
- Applications that need to reduce repeated read load on PostgreSQL

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Cache invalidation

- Treat Azure Database for PostgreSQL as the system of record. Don't treat Redis values as committed business data.

- Assign a TTL to cached values. If cache invalidation fails after a PostgreSQL commit, the TTL limits how long the old value remains available.

- Retry Redis invalidation when a transient error occurs. Use a bounded retry policy with backoff. Don't roll back a committed PostgreSQL transaction because a Redis invalidation fails.

- If all invalidation retries fail, rely on the TTL to remove the stale value. Select the TTL according to the maximum stale-data period that the workload can accept.

- If the workload can't accept the stale-data period, use a different consistency model. Write-through caching is one option when the cached value must be current after a completed application-controlled write.

- If the workload must recover invalidations after an application process stops, record the invalidation intent durably in the same PostgreSQL transaction as the business change. Process the intent asynchronously and idempotently by using an outbox.

- If PostgreSQL is unavailable during a write, don't invalidate the existing Redis value as if the database write succeeded.

- Account for a concurrent cache-fill race. A read that starts before a database commit finishes can retrieve the previous value and populate Redis after the write path invalidates the key. Use versioned cached values, coordinate cache fills and invalidations, or choose a stronger consistency model when the workload can't tolerate this race.

#### Dependency resilience

- Use short timeouts and a circuit breaker for Redis operations. If Redis is unavailable during a read, bypass the cache and query PostgreSQL only within tested database capacity limits.

- Treat cache population as a best-effort operation when the PostgreSQL read succeeds. If the Redis cache fill fails, return the PostgreSQL value to the client, record the failure in telemetry, and continue without caching the value. Don't fail the request or repeatedly retry the cache fill on the request path.

- If PostgreSQL is unavailable during a cache miss, return a dependency failure. Don't store the failure as a normal cache result.

- Protect PostgreSQL from a large number of simultaneous cache misses. When a popular key expires, several application instances can query PostgreSQL for the same value at the same time. Limit concurrent fills for the same key when this behavior can overload the database.

- Size and test PostgreSQL for cache misses, cache warm-up, and short Redis outages. Don't assume that every production request is a cache hit.

#### Availability and failover

- Enable high availability for Azure Managed Redis in production. In regions that support availability zones, Azure Managed Redis distributes nodes across zones by default. This architecture is single-region, and doesn't survive a regional outage.

- Configure high availability for Azure Database for PostgreSQL when the workload's recovery objectives require it. Test database and cache failover separately, because the services use different failover mechanisms.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Network isolation

- Use private endpoints for [Azure Managed Redis](/azure/redis/private-link) and [Azure Database for PostgreSQL](/azure/postgresql/network/how-to-networking-servers-deployed-public-access-add-private-endpoint). We recommend private endpoint connectivity as the networking option for keeping traffic private to these resources. Disable public network access to both services so clients can connect only through configured private endpoints.

- Use App Service [virtual network integration](/azure/app-service/overview-vnet-integration) to reach private endpoints for Azure Managed Redis and Azure Database for PostgreSQL. App Service virtual network integration lets an app connect to resources that are available through a virtual network, including private endpoints. Configure private DNS so each service hostname resolves to its private endpoint.

#### Authentication

- Use a managed identity for App Service.

- Use Microsoft Entra authentication instead of access keys for Azure Managed Redis. Redis clients must refresh their Microsoft Entra authentication tokens before the tokens expire.

- Azure Database for PostgreSQL supports managed identities for authentication. Use Microsoft Entra authentication when it meets the workload requirements.

#### Authorization

- Grant the application only the PostgreSQL and Redis permissions that it requires.

- Check application authorization before you return a cached value.

- Include tenant, user, or authorization scope in the cache key when the response depends on that scope.

#### Data protection and governance

- Use Transport Layer Security (TLS) for Redis and PostgreSQL client connections.

- For regulated or sensitive cached data, define the access, retention, expiration, and deletion requirements before you store the data in Redis.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator estimate](https://azure.com/e/81005ea06966429c990e0e22b6858d1e) as a starting point to estimate the cost of App Service, Azure Managed Redis, Azure Database for PostgreSQL, private endpoints, Azure Monitor, and network traffic for this workload. Adjust the estimate to match your region, capacity, availability, and usage requirements.

The main cost drivers for this architecture include:

- Azure Managed Redis capacity and availability configuration.
- Azure Database for PostgreSQL compute and storage.
- PostgreSQL capacity for cache misses and Redis outages.
- App Service capacity.
- Azure Monitor data collection and retention.
- Private endpoint and network costs.

Use these practices to control cost:

- Cache data only when requests reuse it.

- Measure the cache-hit ratio for important endpoints and key types.

- Remove cached access paths that have a low hit ratio.

- Keep cached values small.

- Use TTLs to remove values that the application no longer needs.

- Select an eviction policy that matches the workload's caching behavior. Treat evictions as cache misses and verify that PostgreSQL can absorb the resulting load.

- Size Redis for the active cached data instead of the total Azure Database for PostgreSQL database size.

- Measure Azure Database for PostgreSQL resource use before and after you add the cache.

- Keep enough Azure Database for PostgreSQL capacity for cache misses, cache warm-up, and tested Redis outage conditions.

- Evaluate Azure Managed Redis against Azure Database for PostgreSQL read replicas when your main requirement is database read scaling. Read replicas require their own provisioned compute and storage.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Keep cache-key creation, TTL rules, serialization, and invalidation rules in one application component or shared library.

- Use consistent key names. Include a schema version when the cached value format changes.

- Keep a clear mapping between application write operations and the Redis keys that each operation must invalidate.

- Record structured logs for cache operations. The following fields are useful:

  - `requestId`
  - `cacheKey`
  - `cacheResult`
  - `redisDuration`
  - `postgresqlDuration`
  - `invalidationStatus`
  - `retryCount`

- Use distributed tracing so one request shows the Redis lookup, PostgreSQL query on a miss, Redis cache fill, and application response.

- Monitor the following application metrics:

  - Cache requests
  - Cache hits
  - Cache misses
  - Cache-hit ratio
  - Redis lookup latency
  - PostgreSQL fallback latency
  - Cache-fill failures
  - Cache-invalidation failures
  - PostgreSQL query duration
  - Cache bypass count
  - Cached value size

- Azure Database for PostgreSQL provides metrics and logs for server monitoring. Monitor PostgreSQL CPU, memory, connections, storage, I/O, and query performance through Azure Monitor.

- Monitor Redis memory use, evictions, connections, server load, and operation latency. Alert when these signals indicate that cache misses or failures could increase PostgreSQL load.

- Monitor for the following conditions:

  - Redis is unavailable during a read.
  - Redis is unavailable during a cache fill.
  - Redis invalidation fails after a PostgreSQL commit.
  - App Service stops after PostgreSQL commits and before invalidation.
  - PostgreSQL is unavailable during a cache miss.
  - PostgreSQL is unavailable during a write.
  - Many requests access the same key after it expires.
  - A deployment changes the cached value format.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Measure cache performance for each important endpoint and key type. A workload-wide hit ratio can hide poor results for an important access path.

- Cache a value when repeated Redis lookups cost less than repeated PostgreSQL queries and application processing.

- Keep cached values small. Large values use more Redis memory and require more network and serialization work.

- Don't cache unbounded query results. Use pagination or a narrower query when the result can grow without a known limit.

- Reuse Redis connections. Don't create a new Redis connection for every request.

- Use PostgreSQL connection pooling. Don't create a new database connection for every request.

- Size the Azure Database for PostgreSQL flexible server for cache misses and Redis outages. Don't size PostgreSQL only for the expected cache-hit state.

- Enable the Azure Database for PostgreSQL query store to track query performance over time and identify long-running or resource-intensive queries. Optimize PostgreSQL queries even when the expected cache-hit ratio is high.
  
- Use different TTLs for data with different access and freshness requirements.

- Add small TTL variations when many related entries might otherwise expire at the same time.

- Identify keys that receive a large share of Redis traffic. Split large cached values or change the key design if one key limits throughput.

- Measure the number of keys that each PostgreSQL write invalidates. Avoid broad cached query results when one data change requires a large or unpredictable number of Redis deletes.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Philip Laussermair](https://www.linkedin.com/in/philip-laussermair/) | Lead Solutions Architect, Redis

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use Microsoft Entra ID for cache authentication with Azure Managed Redis](/azure/redis/entra-for-authentication)
- [Use private endpoints with Azure Managed Redis](/azure/redis/private-link)
- [Use private endpoints with Azure Database for PostgreSQL flexible server](/azure/postgresql/network/how-to-networking-servers-deployed-public-access-add-private-endpoint)
- [Use managed identity authentication with Azure Database for PostgreSQL flexible server](/azure/postgresql/security/security-connect-with-managed-identity)
- [Monitor Azure Database for PostgreSQL flexible server](/azure/postgresql/monitor/concepts-monitoring)

## Related resources

- [Cache-Aside pattern](../../patterns/cache-aside.yml)
- [Write-through caching with Azure Managed Redis and Azure SQL Database](/azure/architecture/databases/architecture/write-through-caching-azure-sql-managed-redis)
- [Read replicas in Azure Database for PostgreSQL flexible server](/azure/postgresql/read-replica/concepts-read-replicas)
- [Query store in Azure Database for PostgreSQL flexible server](/azure/postgresql/monitor/concepts-query-store)
