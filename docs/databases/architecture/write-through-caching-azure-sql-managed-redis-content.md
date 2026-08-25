This article shows how to implement an application-managed write-through caching strategy for a high-traffic web application. The workload uses Azure App Service for the application tier, Azure Functions as the write-through coordinator, Azure SQL Database as the system of record (SOR), and Azure Managed Redis as a distributed cache for low-latency reads.

In this architecture, SQL Database remains the authoritative data store. Azure Managed Redis stores derived cached values. Functions coordinates writes and returns a completed write response only after the SQL transaction commits and the corresponding Redis cache entry is updated.

> [!IMPORTANT]
> Use write-through caching only for read-heavy access paths where clients need fresh values immediately after application-controlled writes. For data that's rarely read after writes, highly volatile, or unlikely to produce a high cache-hit ratio, read from SQL Database or use a simpler caching pattern.

## Architecture

:::image type="complex" border="false" source="./_images/write-through-caching-functions-azure-sql-managed-redis.svg" alt-text="Diagram that shows a write-through caching architecture with App Service, Functions, SQL Database, and Azure Managed Redis." lightbox="./_images/write-through-caching-functions-azure-sql-managed-redis.svg":::
   A client application appears on the left. An arrow labeled HTTPS requests points from the client application to App Service. A section labeled Azure virtual network contains App Service, the write-through function, the repair function, Azure Managed Redis, SQL Database, two private endpoints, and Azure Monitor. App Service runs in an application subnet in the virtual network. App Service handles read requests and sends write requests to Functions. App Service and Functions use managed identities where supported to access Azure resources. On the left side of the diagram, an arrow labeled read requests points from the application tier in App Service to the Azure Managed Redis private endpoint. Five numbered circles (1 through 5) mark the read flow path. An arrow labeled cache-miss read requests points from App Service to the SQL Database private endpoint. For reads, App Service checks Azure Managed Redis first. When the cache doesn't contain the requested value, App Service reads the authoritative value from SQL Database and writes the value to Azure Managed Redis with an expiration time. An arrow labeled write requests points from App Service to an icon that represents the write-through and repair functions. An arrow labeled synchronous write-through cache update points from the write-through and repair functions to Azure Managed Redis private endpoint. Another arrow labeled write-through function and repair function with authoritative writes via Functions beneath it points to the SQL Database private endpoint. For writes, App Service calls an HTTP-triggered Azure function. The function validates the request, checks idempotency, writes the change to Azure SQL Database, commits the SQL transaction, and then updates the corresponding cache key in Azure Managed Redis. The function returns a completed write response only after both SQL and Redis are updated. The SQL transaction records the intended cache update in a durable outbox table. If the SQL commit succeeds but the Redis update fails, the outbox entry remains pending. A repair function later processes pending outbox entries and updates Redis idempotently. Private endpoints connect the virtual network to Azure SQL Database and Azure Managed Redis. App Service and Functions use virtual network integration and private DNS to reach these services through their private endpoints. A dotted arrow labeled metrics and logs points from the main section that includes App Service, functions, and the private endpoints to Azure Monitor. Another dotted arrow connects Azure Managed Redis distributed cache and SQL Database system of record and points to Azure Monitor. Azure Monitor receives logs, metrics, and distributed traces from App Service, Functions, SQL Database, Azure Managed Redis, and the repair process.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/write-through-caching-functions-azure-sql-managed-redis.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram.

#### Read flow

1. A client sends a request to the application that's hosted on App Service. App Service must run a read operation to fulfill the client's request.

1. The application computes a deterministic cache key and tries to read the value from Azure Managed Redis.

1. If Azure Managed Redis contains the value, the application returns the cached value to the client.

1. If Azure Managed Redis doesn't contain the value, the application reads the authoritative value from SQL Database.

1. The application writes the SQL result to Azure Managed Redis with a time to live (TTL), then returns the value to the client.

#### Write-through flow

1. A client sends a write request to the application that's hosted on App Service.

1. App Service calls an HTTP-triggered Azure Function that owns the write-through contract.

1. The function validates the request, checks the idempotency key, commits the change to SQL Database, and records the cache-update intent in the SQL outbox.

1. After the SQL commit succeeds, the function writes the updated value to Azure Managed Redis with a TTL and a version value, such as a SQL rowversion, timestamp, or ETag.

1. If SQL and Redis both update successfully, the function marks the outbox entry as completed and returns a completed write response. If the Redis update fails after the SQL commit, the function leaves the outbox entry pending and returns a response according to the API contract, such as `202 Accepted` or `503 Service Unavailable` with `Retry-After`.

1. A repair function processes pending outbox entries and updates Redis idempotently.

Azure Monitor collects telemetry for application requests, function executions, SQL operations, Redis operations, cache misses, outbox entries, repair actions, and dependency failures.

### Components

In this architecture, the following components work together to implement application-managed write-through caching for data that requires low-latency reads and application-controlled read-after-write behavior.

- [Azure Managed Redis](/azure/redis/overview) is an in-memory data store that provides high-throughput, low-latency access to cached data. In this architecture, it stores frequently accessed data, such as entity records, read models, configuration values, metadata, and precomputed API responses. The workload uses Redis to reduce read latency and SQL read load. Redis is a derived data store, not the commit authority.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a managed platform for hosting web applications, APIs, and mobile back ends. In this architecture, it hosts the web application and read path. App Service performs cache lookups, populates Redis on cache misses, and calls Functions for writes. App Service doesn't write directly to SQL Database for write-through operations, so the workload has one controlled write path.

- [Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute service that runs event-driven code without requiring infrastructure management. In this architecture, it implements the write-through boundary for application-controlled writes. The write function validates requests, enforces idempotency, commits changes to SQL Database, updates Azure Managed Redis, and returns completed write responses only after both stores are updated. A repair function processes pending outbox entries so the cache can recover after partial failures.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database service that provides high availability (HA), security, and built-in intelligence. In this architecture, it serves as the SOR. All authoritative writes commit to SQL before the function updates Redis. A SQL outbox table stores durable cache-update intent so that the workload can repair Redis when a function or Redis failure occurs after the SQL commit.

- [Azure Private Link](/azure/private-link/private-link-overview) is a service that provides private connectivity between Azure resources over the Microsoft backbone network. In this architecture, it provides private endpoint connectivity from the virtual network to SQL Database and Azure Managed Redis. The workload uses private connectivity to keep SQL and Redis access off the public internet.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management (IAM) service. In this architecture, it provides identity for users and workload identities. App Service and Functions use managed identities where supported to access Azure resources and reduce reliance on stored credentials.

- [Azure Monitor](/azure/azure-monitor/overview) is a comprehensive monitoring service that provides observability across Azure resources and applications. In this architecture, it collects metrics, logs, and traces for App Service, Functions, SQL Database, Azure Managed Redis, and the repair process. The workload uses this telemetry to observe cache hit ratio, dependency latency, Redis update failures, outbox health, and end-to-end write-through behavior.

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and their trade-offs.

- **Cache-aside with invalidation instead of write-through caching:** Use the [Cache-Aside pattern](../../patterns/cache-aside.yml) when the application can tolerate short-lived staleness or when you prefer simpler write behavior. In this approach, the application commonly updates SQL and deletes the related cache entry. This approach reduces write-path complexity, but the cache might not contain the updated value immediately after a successful write.

- **App Service-only write-through instead of Functions:** Implement the same write-through contract inside App Service when you don't need a separate serverless write component. This approach avoids an extra network hop but couples the write-through policy to the web application.

- **Asynchronous cache refresh instead of write-through caching:** Use a queue, outbox processor, or change-processing workflow when the workload can tolerate Redis being updated after the write response. This approach can reduce write latency, but it isn't write-through because cache updates happen after the completed write response.

- **SQL Database readable replicas instead of Azure Managed Redis:** Use readable secondaries, geo-replicas, or Hyperscale named replicas when the main goal is SQL read scale and queries need relational semantics, joins, filtering, or query optimization.

## Scenario details

A high-traffic web application stores business data in SQL Database. As request volume grows, repeated reads increase latency and consume database resources. The team wants to use Azure Managed Redis to serve frequently requested data from memory, but the team also needs users to see recent changes after successful application-controlled writes.

This architecture addresses that scenario with an application-managed write-through strategy. Functions owns the write-through contract. SQL Database remains the commit authority. Azure Managed Redis improves read latency and reduces SQL load. App Service owns the read path and delegates writes to Functions.

The completed write order is:

1. Validate the request.

1. Check the idempotency key or operation identifier.

1. Write to SQL Database.

1. Commit the SQL transaction and durable cache-update intent.

1. Update the corresponding Redis key with the current value and version.

1. Mark the cache-update intent as completed.

1. Return the completed write response.

This workload provides read-after-write optimization for writes that pass through the write-through function. It doesn't provide atomic distributed transactions across SQL Database and Azure Managed Redis. If SQL commits successfully but Redis can't be updated, SQL remains authoritative, the durable outbox drives repair, and the API contract must avoid treating the operation as a normal completed write until Redis is updated.

### Potential use cases

- Customer, product, catalog, or account profile APIs that have high read volume and lower write volume.

- Business applications that require low-latency reads but need SQL Database as the durable SOR.

- Applications that serve compact read models, metadata, settings, or precomputed API responses.

- Workloads that need application-controlled read-after-write behavior without adopting an asynchronous write-behind model.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Treat SQL Database as the authoritative store. Don't write a new value to Azure Managed Redis as if it's committed when the SQL write fails.

- Make Functions the only write-through path for application-controlled writes. Prevent bypass writes where possible through permissions, code ownership, and operational controls.

- Record durable cache-update intent in the same SQL transaction as the business write. Use a SQL outbox table so a function crash after SQL commit doesn't lose the required Redis update.

- Make outbox processing durable and idempotent. Track pending, completed, failed, retry count, next retry time, and last error so the repair function can resume safely after failures.

- Return a completed write response only after the SQL commit and Redis update succeed. If Redis can't be updated after SQL commits, use an explicit partial-completion contract, such as `202 Accepted` or a retryable failure response.

- Make the write function and repair function idempotent. Use idempotency keys for create and command-style writes so that clients can safely retry failed requests.

- Use SQL rowversion, version numbers, timestamps, or ETags in cached values. Prevent older retries or repair jobs from overwriting newer cache entries.

- Use TTLs for cached values as a backstop against stale data from partial failures, direct SQL updates, deployment bugs, or missed invalidations.

- Use short Redis timeouts and separate Redis circuit breakers for each caller. In App Service, put a circuit breaker around cache reads and cache-population writes. If the breaker opens, bypass Redis and read from SQL Database only within tested SQL capacity limits. In Functions, put a circuit breaker around Redis updates from the write function and repair function. If Redis is unavailable during writes, leave the outbox entry pending and don't return a normal completed write response.

- Configure Azure Managed Redis HA for production workloads. In regions that support availability zones, use zone redundancy to improve resilience to zone failures.

- For multiple-region requirements, evaluate active geo-replication for Azure Managed Redis and the appropriate SQL Database business continuity option. Test failover behavior because Redis and SQL use separate replication and consistency models.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use private endpoints for SQL Database and Azure Managed Redis. Restrict public access to the resources unless required. In cases where public access is required, use firewall rules to lock down access to known IP addresses.

- Use managed identities for communications between Azure services.

- Restrict SQL write permissions to the Functions managed identity. Don't allow App Service to write directly to SQL for write-through operations.

- Secure the function endpoint so only authorized callers can invoke write operations. Use Microsoft Entra authentication and private networking.

- Use Microsoft Entra authentication for Azure Managed Redis instead of access keys.

- Use Transport Layer Security (TLS) for all SQL and Redis client connections.

- Don't cache sensitive or security-critical data unless the workload has an approved design for cache data protection, authorization, retention, and eviction.

- Include tenant, user, or authorization scope in cache keys when cached data is scoped to a tenant or user. The application is responsible for enforcing authorization before it returns cached data.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator estimate](https://azure.com/e/0f4b7fcf8ff64f0e863989668c5caa5f) as a starting point to estimate the cost of App Service, Functions, SQL Database, Azure Managed Redis, private endpoints, Azure Monitor, and network traffic for this workload. Adjust the estimate to match your region, capacity, availability, and usage requirements.

Major cost drivers include:

- Azure Managed Redis tier, memory capacity, throughput capacity, HA, persistence, and geo-replication.

- SQL Database compute capacity required for normal traffic, cache warm-up, and tested fallback during Redis outages or low cache-hit periods.

- App Service and Functions capacity required for the read path, write-through coordination, retry processing, and repair jobs.

- Azure Monitor telemetry volume and retention for traces, logs, metrics, and dependency data.

Use these practices to optimize cost:

- Cache compact read models instead of full database records.

- Use TTLs and eviction policy to control memory growth. Avoid caching low-hit-ratio data.

- Rightsize Azure Managed Redis based on memory, throughput, CPU, connection count, and HA requirements.

- Monitor whether SQL compute can be reduced after the cache reaches the expected hit ratio. Don't reduce SQL capacity below the level needed for cache outages, cache warm-up, or repair operations.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Implement the cache policy in the write-through function or a shared application library so reads, writes, TTLs, serialization, and key naming remain consistent.

- Use deterministic key names, such as `tenant:{tenantId}:customer:{customerId}` or `product:{productId}:v1`. Include a schema version when cached value formats change.

- Emit structured logs for write-through operations. Include operation ID, idempotency key, cache key, SQL commit status, SQL version, Redis update status, retry count, outbox status, and final response status.

- Use distributed tracing so one request shows the App Service operation, Functions invocation, SQL call, Redis call, retry behavior, and final response status. Use [OpenTelemetry with Functions](/azure/azure-functions/opentelemetry-howto) and [Application Insights dependency tracking](/azure/azure-monitor/app/dependencies) to correlate application operations and dependency calls.

- Monitor outbox depth, oldest pending outbox age, Redis update failures, repair success rate, cache hit ratio, and dependency latency.

- Test dependency failures, including Redis unavailability during reads, Redis update failure after SQL commit, function crash after SQL commit, SQL unavailability during reads, and SQL unavailability during writes.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Account for the extra network hop through Functions on the write path. Measure end-to-end write latency against service-level objectives (SLOs).

- Measure cache hit ratio by endpoint, operation, and entity type. A global hit ratio can hide poor performance for important paths. Use those measurements to define a cacheability policy, such as caching product details or account profiles but reading directly from SQL for rarely reused, highly volatile, or large query results.

- Reuse SQL and Redis client connections in App Service and Functions. Avoid creating a new connection for every request or function invocation. Azure SQL binding operations use `SqlClient`, which provides connection pooling by default. For Redis SDK-based access, reuse a long-lived client or connection multiplexer according to the client library guidance.

- Keep Redis values compact. Cache projections that match read APIs instead of full relational entities when possible.

- Identify hot keys that receive disproportionate traffic. Hot keys can concentrate load on one Redis shard or node, increase latency, and limit scale even when the overall cache has available capacity. Mitigate hot keys by splitting large values, caching narrower projections, or changing the data model.

- Account for write amplification. One SQL write can require multiple cache changes. Prefer caching entity records or narrowly scoped projections instead of broad query results that require many invalidations.

- Avoid broad query-result caches unless you understand the invalidation and update cost.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Philip Laussermair](https://www.linkedin.com/in/philip-laussermair/) | Senior Solutions Architect, Redis

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use Microsoft Entra ID for cache authentication with Azure Managed Redis](/azure/redis/entra-for-authentication)
- [Azure Managed Redis with Private Link](/azure/redis/private-link)
- [Managed identities in Microsoft Entra for Azure SQL](/azure/azure-sql/database/authentication-azure-ad-user-assigned-managed-identity)
- [SQL Database reliability](/azure/reliability/reliability-sql-database)

## Related resources

- [Get started with database architecture design](../database-get-started.md)
- [Cache-Aside pattern](../../patterns/cache-aside.yml)
- [Multitenancy and Azure Managed Redis](../../guide/multitenant/service/managed-redis.md)
- [Data partitioning guidance](../../best-practices/data-partitioning.yml)
