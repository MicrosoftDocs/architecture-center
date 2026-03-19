<!-- cSpell:ignore BSON keyspace INCRBY DECR DECRBY GETSET MGET MSET SADD SMEMBERS SDIFF SUNION ZADD LPUSH RPUSH LPOP RPOP LRANGE RRANGE -->

Caching is a common technique that aims to improve the performance and scalability of a system. It caches data by temporarily copying frequently accessed data to fast storage that's located close to the application. If this fast data storage is located closer to the application than the original source, then caching can significantly improve response times for client applications by serving data more quickly.

Caching is most effective when a client instance repeatedly reads the same data, especially if all the following conditions apply to the original data store:

- It remains relatively static.
- It's slow compared to the speed of the cache.
- It's subject to a high level of contention.
- It's far away when network latency can cause access to be slow.

## Caching in distributed applications

Distributed applications typically implement either or both of the following strategies when caching data:

- They use a private cache, where data is held locally on the computer that's running an instance of an application or service.
- They use a shared cache, serving as a common source that multiple processes and machines can access.

In both cases, caching can be performed client-side and server-side. Client-side caching is done by the process that provides the user interface for a system, such as a web browser or desktop application. Server-side caching is done by the process that provides the business services that are running remotely.

### Private caching

The most basic type of cache is an in-memory store. It's held in the address space of a single process and accessed directly by the code that runs in that process. This type of cache is quick to access. It can also provide an effective means for storing modest amounts of static data. The size of a cache is typically constrained by the amount of memory available on the machine that hosts the process.

If you need to cache more information than is physically possible in memory, you can write cached data to the local file system. This process is slower to access than data that's held in memory, but it should still be faster and more reliable than retrieving data across a network.

If you have multiple instances of an application that uses this model running concurrently, each application instance has its own independent cache holding its own copy of the data.

Think of a cache as a snapshot of the original data at some point in the past. If this data isn't static, it's likely that different application instances hold different versions of the data in their caches. Therefore, the same query performed by these instances can return different results, as shown in Figure 1.

![The results of using an in-memory cache in different instances of an application](./images/caching/Figure1.png)

*Figure 1: Using an in-memory cache in different instances of an application.*

### Shared caching

If you use a shared cache, it can help alleviate concerns that data might differ in each cache, which can occur with in-memory caching. Shared caching ensures that different application instances see the same view of cached data. It locates the cache in a separate location, which is typically hosted as part of a separate service, as shown in Figure 2.

![The results of using a shared cache](./images/caching/Figure2.png)

*Figure 2: Using a shared cache.*

An important benefit of the shared caching approach is the scalability it provides. Many shared cache services are implemented by using a cluster of servers and use software to distribute the data across the cluster transparently. An application instance sends a request to the cache service. The underlying infrastructure determines the location of the cached data in the cluster. You can easily scale the cache by adding more servers.

There are two main disadvantages of the shared caching approach:

- The cache is slower to access because it's no longer held locally to each application instance.
- The requirement to implement a separate cache service might add complexity to the solution.

## Considerations for using caching

The following sections describe in more detail the considerations for designing and using a cache.

### Decide when to cache data

Caching can dramatically improve performance, scalability, and availability. The more data that you have and the larger the number of users that need to access this data, the greater the benefits of caching become. Caching reduces the latency and contention that are associated with handling large volumes of concurrent requests in the original data store.

For example, a database might support a limited number of concurrent connections. Retrieving data from a shared cache, however, rather than the underlying database, makes it possible for a client application to access this data even if the number of available connections is currently exhausted. Additionally, if the database becomes unavailable, client applications might be able to continue by using the data that's held in the cache.

Consider caching data that is read frequently but modified infrequently (for example, data that has a higher proportion of read operations than write operations). However, we don't recommend that you use the cache as the authoritative store of critical information. Instead, ensure that all changes that your application can't afford to lose are always saved to a persistent data store. If the cache is unavailable, your application can still continue to operate by using the data store, and you won't lose important information.

### Determine how to cache data effectively

The key to using a cache effectively lies in determining the most appropriate data to cache, and caching it at the appropriate time. The data can be added to the cache on demand the first time an application retrieves it. The application needs to fetch the data only once from the data store, and that subsequent access can be satisfied by using the cache.

Alternatively, a cache can be partially or fully populated with data in advance, typically when the application starts (an approach known as seeding). However, it might not be advisable to implement seeding for a large cache because this approach can impose a sudden, high load on the original data store when the application starts running.

Often an analysis of usage patterns can help you decide whether to fully or partially prepopulate a cache, and to choose the data to cache. For example, you can seed the cache with the static user profile data for customers who use the application regularly (perhaps every day), but not for customers who use the application only once a week.

Caching typically works well with data that's immutable or that changes infrequently. Examples include reference information such as product and pricing information in an e-commerce application, or shared static resources that are costly to construct. Some or all of this data can be loaded into the cache at application startup to minimize demand on resources and to improve performance. You might also want to have a background process that periodically updates the reference data in the cache to ensure it's up-to-date. Or, the background process can refresh the cache when the reference data changes.

Caching is less useful for dynamic data, although there are some exceptions to this consideration. For more information, see the [Cache highly dynamic data](#cache-highly-dynamic-data) section later in this article. When the original data changes regularly, either the cached information becomes stale quickly or the overhead of synchronizing the cache with the original data store reduces the effectiveness of caching.

A cache doesn't have to include the complete data for an entity. For example, if a data item represents a multivalued object, such as a bank customer with a name, address, and account balance, some of these elements might remain static, such as the name and address. Other elements, such as the account balance, might be more dynamic. In these situations, it can be useful to cache the static portions of the data and retrieve (or calculate) only the remaining information when it's required.

We recommend that you carry out performance testing and usage analysis to determine whether prepopulating or on-demand loading of the cache, or a combination of both, is appropriate. The decision should be based on the volatility and usage pattern of the data. Cache utilization and performance analysis are important in applications that encounter heavy loads and must be highly scalable. For example, in highly scalable scenarios you can seed the cache to reduce the load on the data store at peak times.

Caching can also be used to avoid repeating computations while the application is running. If an operation transforms data or performs a complicated calculation, it can save the results of the operation in the cache. If the same calculation is required afterward, the application can retrieve the results from the cache.

An application can modify data that's held in a cache. However, we recommend thinking of the cache as a transient data store that could disappear at any time. Don't store valuable data in the cache only; make sure that you maintain the information in the original data store as well. This means that if the cache becomes unavailable, you minimize the chance of losing data.

### Cache highly dynamic data

When you store rapidly changing information in a persistent data store, it can impose an overhead on the system. For example, consider a device that continually reports status or some other measurement. If an application chooses not to cache this data on the basis that the cached information is usually outdated, then the same consideration could be true when storing and retrieving this information from the data store. In the time it takes to save and fetch this data, it might change.

In a situation such as this, consider the benefits of storing the dynamic information directly in the cache instead of in the persistent data store. If the data is noncritical and doesn't require auditing, then it doesn't matter if the occasional change is lost.

### Manage data expiration in a cache

In most cases, data that's held in a cache is a copy of data that's held in the original data store. The data in the original data store might change after it was cached, causing the cached data to become stale. Many caching systems enable you to configure the cache to expire data and reduce the period for which data might be out of date.

Expired cached data is removed from the cache, and the application must retrieve the data from the original data store (it can put the newly fetched information back into cache). You can set a default expiration policy when you configure the cache. In many cache services, you can also stipulate the expiration period for individual objects when you store them programmatically in the cache. Some caches enable you to specify the expiration period as an absolute value, or as a sliding value that causes the item to be removed from the cache if it isn't accessed within the specified time. This setting overrides any cache-wide expiration policy, but only for the specified objects.

> [!NOTE]
> Consider the expiration period for the cache and the objects that it contains carefully. If you make it too short, objects expire too quickly and you reduce the benefits of using the cache. If you make the period too long, you risk the data becoming stale.

It's also possible that the cache might fill up if data is allowed to remain resident for a long time. In this case, any requests to add new items to the cache might cause some items to be forcibly removed in a process known as eviction. Cache services typically evict data on a least-recently-used (LRU) basis, but you can usually override this policy and prevent items from being evicted. However, if you adopt this approach, you risk exceeding the memory that's available in the cache. An application that attempts to add an item to the cache will fail with an exception.

Some caching implementations might provide other eviction policies. There are several types of eviction policies. These include:

- A most-recently-used policy (in the expectation that the data won't be required again).
- A first-in-first-out policy (oldest data is evicted first).
- An explicit removal policy based on a triggered event (such as the data being modified).

### Invalidate data in a client-side cache

Data that's held in a client-side cache is generally considered to be outside the auspices of the service that provides the data to the client. A service can't directly force a client to add or remove information from a client-side cache.

This means that it's possible for a client that uses a poorly configured cache to continue using outdated information. For example, if the expiration policies of the cache aren't properly implemented, a client might use outdated information that's cached locally when the information in the original data source changes.

If you build a web application that serves data over an HTTP connection, you can implicitly force a web client (such as a browser or web proxy) to fetch the most recent information. You can do this if a resource is updated by a change in the URI of that resource. Web clients typically use the URI of a resource as the key in the client-side cache, so if the URI changes, the web client ignores any previously cached versions of a resource and fetches the new version instead.

## Managing concurrency in a cache

Often, caches are designed to be shared by multiple instances of an application. Each application instance can read and modify data in the cache, so the same concurrency issues that arise with any shared data store also apply to a cache. In a situation where an application needs to modify data held in the cache, you might need to ensure that updates made by one instance of the application don't overwrite the changes made by another instance.

Depending on the nature of the data and the likelihood of collisions, you can adopt one of two approaches to concurrency:

- **Optimistic**. Before the application updates the data, it checks whether the data in the cache has changed since it was retrieved. If the data is still the same, the change can be made. Otherwise, the application has to decide whether to update it. (The business logic that drives this decision is application-specific.) This approach is suitable for situations where updates are infrequent, or where collisions are unlikely to occur.
- **Pessimistic**. When it retrieves the data, the application locks it in the cache to prevent another instance from changing it. This process ensures that collisions can't occur, but they can also block other instances that need to process the same data. Pessimistic concurrency can affect the scalability of a solution and is recommended only for short-lived operations. This approach might be appropriate for situations where collisions are more likely, especially if an application updates multiple items in the cache and must ensure that these changes are applied consistently.

### Implement high availability and scalability, and improve performance

Avoid using a cache as the primary repository of data; this is the role of the original data store from which the cache is populated. The original data store is responsible for ensuring the persistence of the data.

Be careful not to introduce critical dependencies on the availability of a shared cache service into your solutions. An application should be able to continue functioning if the service that provides the shared cache is unavailable. The application shouldn't become unresponsive or fail while waiting for the cache service to resume.

Therefore, the application must be prepared to detect the availability of the cache service and fall back to the original data store if the cache is inaccessible. The [Circuit-Breaker pattern](../patterns/circuit-breaker.md) is useful for handling this scenario. The service that provides the cache can be recovered, and once it becomes available, the cache can be repopulated as data is read from the original data store, following a strategy such as the [Cache-aside pattern](../patterns/cache-aside.yml).

However, system scalability might be affected if the application falls back to the original data store when the cache is temporarily unavailable. While the data store is being recovered, the original data store could be swamped with requests for data, resulting in timeouts and failed connections.

Consider implementing a local, private cache in each instance of an application, together with the shared cache that all application instances access. When the application retrieves an item, it can check first in its local cache, then in the shared cache, and finally in the original data store. The local cache can be populated using the data in either the shared cache, or in the database if the shared cache is unavailable.

This approach requires careful configuration to prevent the local cache from becoming too stale with respect to the shared cache. However, the local cache acts as a buffer if the shared cache is unreachable. Figure 3 shows this structure.

![Using a local private cache with a shared cache](./images/caching/Caching3.png)

*Figure 3: Using a local private cache with a shared cache.*

To support large caches that hold relatively long-lived data, some cache services provide a high-availability option that implements automatic failover if the cache becomes unavailable. This approach typically involves replicating the cached data that's stored on a primary cache server to a secondary cache server, and switching to the secondary server if the primary server fails or connectivity is lost.

To reduce the latency that's associated with writing to multiple destinations, the replication to the secondary server might occur asynchronously when data is written to the cache on the primary server. This approach leads to the possibility that some cached information might be lost if there's a failure, but the proportion of this data should be small, compared to the overall size of the cache.

If a shared cache is large, it might be beneficial to partition the cached data across nodes to reduce the chances of contention and improve scalability. Many shared caches support the ability to dynamically add (and remove) nodes and rebalance the data across partitions. This approach might involve clustering, in which the collection of nodes is presented to client applications as a seamless, single cache. Internally, however, the data is dispersed between nodes following a predefined distribution strategy that balances the load evenly. For more information about possible partitioning strategies, see [Data partitioning guidance](/previous-versions/msp-n-p/dn589795(v=pandp.10)).

Clustering can also increase the availability of the cache. If a node fails, the remainder of the cache is still accessible. Clustering is frequently used with replication and failover. Each node can be replicated, and the replica can be quickly brought online if the node fails.

Many read and write operations are likely to involve single data values or objects. However, at times it might be necessary to store or retrieve large volumes of data quickly. For example, seeding a cache could involve writing hundreds or thousands of items to the cache. An application might also need to retrieve a large number of related items from the cache as part of the same request.

Many large-scale caches provide batch operations for these purposes. This enables a client application to package up a large volume of items into a single request and reduces the overhead that's associated with performing a large number of small requests.

## Caching and eventual consistency

For the cache-aside pattern to work, the instance of the application that populates the cache must have access to the most recent and consistent version of the data. In a system that implements eventual consistency (such as a replicated data store) this might not be the case.

One instance of an application could modify a data item and invalidate the cached version of that item. Another instance of the application might attempt to read this item from a cache, which causes a cache-miss, so it reads the data from the data store and adds it to the cache. However, if the data store isn't fully synchronized with the other replicas, the application instance could read and populate the cache with the old value.

For more information about handling data consistency, see the [Data consistency primer](/previous-versions/msp-n-p/dn589800(v=pandp.10)).

### Protect cached data

Irrespective of the cache service you use, consider how to protect the data that's held in the cache from unauthorized access. There are two main concerns:

- The privacy of the data in the cache.
- The privacy of data as it flows between the cache and the application that's using the cache.

To protect data in the cache, the cache service might implement an authentication mechanism that requires that applications specify the following details:

- Which identities can access data in the cache.
- Which operations (read and write) that these identities are allowed to perform.

To reduce overhead that's associated with reading and writing data, after an identity is granted write or read access to the cache, that identity can use any data in the cache.

If you need to restrict access to subsets of the cached data, you can do one of the following approaches:

- Split the cache into partitions (by using different cache servers) and only grant access to identities for the partitions that they should be allowed to use.
- Encrypt the data in each subset by using different keys, and provide the encryption keys only to identities that should have access to each subset. A client application might still be able to retrieve all of the data in the cache, but it will only be able to decrypt the data for which it has the keys.

You must also protect the data as it flows in and out of the cache. To do this, you depend on the security features provided by the network infrastructure that client applications use to connect to the cache. If the cache is implemented using an on-site server within the same organization that hosts the client applications, then the isolation of the network itself might not require you to take more steps. If the cache is located remotely and requires a TCP or HTTP connection over a public network (such as the Internet), consider implementing SSL.

## Implement caching with Azure Managed Redis

The remaining sections of this article describe how to implement the caching patterns discussed above using [Azure Managed Redis](/azure/redis/overview). Azure Managed Redis is a managed Redis service that you can use as a shared cache across application instances. It supports key-value caching, data structures such as sets, sorted sets, and lists, and optional persistence for durability across restarts.

For information about available tiers, capacity planning, networking, and feature details, see the [Azure Managed Redis documentation](/azure/redis/overview).

### Manage data expiration and eviction

Azure Managed Redis implements the expiration and eviction strategies described in [Manage data expiration in a cache](#manage-data-expiration-in-a-cache) through two mechanisms:

- **Per-key TTL.** You can assign a time-to-live (TTL) to each key when you store it, or add one later with the `EXPIRE` command. When the TTL elapses, Redis removes the key automatically. TTLs support both absolute and relative expiration. For code examples, see [Specify automatically expiring keys](#specify-automatically-expiring-keys) later in this article.

- **Eviction policy.** When Redis reaches its memory limit, it evicts keys according to a configured policy. The default policy is `volatile-lru`, which evicts the least recently used key that has a TTL set. Other policies include `allkeys-lru`, `volatile-random`, and `noeviction` (which causes write operations to fail when memory is full). Choose an eviction policy based on whether your application uses TTLs consistently and whether you prefer to protect keys that have no expiration. For more information about eviction policies, see [Key eviction](/azure/redis/key-eviction).

### Manage concurrency

Azure Managed Redis supports the optimistic and pessimistic concurrency approaches described in [Managing concurrency in a cache](#managing-concurrency-in-a-cache):

- **Optimistic concurrency.** Use the `WATCH` command to monitor one or more keys before starting a transaction with `MULTI`/`EXEC`. If any watched key changes before the transaction executes, Redis discards the transaction and the client can retry. This approach avoids locks and works well when collisions are infrequent. For code examples using the StackExchange `ITransaction` interface, see [Perform atomic and batch operations](#perform-atomic-and-batch-operations) later in this article.

- **Atomic single-key operations.** Commands such as `INCR`, `DECR`, and `GETSET` update a value in a single step, eliminating the read-modify-write race condition. Use these when the update logic can be expressed as a single Redis command.

- **Lua scripting.** For multi-step updates that must be atomic across multiple keys, execute a Lua script on the server. Redis runs the entire script as a single operation without interleaving other commands.

In clustered deployments, all keys involved in a transaction or Lua script must reside in the same hash slot. Use hash tags (for example, `customer:{123}:name` and `customer:{123}:email`) to colocate related keys.

### Implement high availability and scalability

The top-half guidance in [Implement high availability and scalability, and improve performance](#implement-high-availability-and-scalability-and-improve-performance) describes replication, failover, partitioning, and layered caching as general strategies. Azure Managed Redis provides built-in support for these:

- **Replication and failover.** Each Azure Managed Redis instance uses primary/replica replication. The service monitors node health and automatically promotes a replica if the primary fails. This aligns with the asynchronous replication model described above. A small amount of recently written data may be lost during an unexpected failover because replication is asynchronous.

- **Clustering.** For workloads that exceed the capacity of a single node, Azure Managed Redis supports clustering to shard data across multiple nodes. You can choose between OSS Clustering Policy (clients route directly to shards) and Enterprise Clustering Policy (a proxy handles routing transparently). For details, see [Partitioning a Redis cache](#partitioning-a-redis-cache) later in this article.

- **Active geo-replication.** For multi-region availability, Azure Managed Redis supports active geo-replication, which links instances across Azure regions into a single replication group. Each instance can handle reads and writes, and changes sync automatically. Your application is responsible for redirecting traffic to a healthy instance during a regional failure. For more information, see [Active geo-replication](/azure/redis/how-to-active-geo-replication).

- **Layered caching.** As described in the guidance above, you can combine a local in-memory cache with Azure Managed Redis to reduce latency and provide a fallback if the shared cache is temporarily unreachable. The [Circuit-Breaker pattern](../patterns/circuit-breaker.md) and [Cache-aside pattern](../patterns/cache-aside.yml) help manage this layered approach.

### Protect cached data in Azure Managed Redis

The guidance in [Protect cached data](#protect-cached-data) describes two concerns: controlling who can access cached data, and protecting data in transit. Azure Managed Redis addresses both:

- **Authentication.** Use [Microsoft Entra ID authentication](/azure/redis/entra-for-authentication) as the primary access control mechanism.
- **Network isolation.** Use [Private Endpoints](/azure/redis/managed-redis-private-link) to restrict network access to your cache so that traffic doesn't traverse the public internet.
- **Encryption.** Azure Managed Redis encrypts data in transit with TLS and encrypts data at rest by default.

Follow the principle of least privilege when granting access to your cache.

### Caching session state and HTML output

Azure Managed Redis can be used to store session state and output cache data for ASP.NET Core and ASP.NET applications. By keeping session data and rendered output in a shared Redis-based cache, applications running across multiple instances, such as in Azure App Service, Azure Kubernetes Service (AKS), Azure Container Apps, or virtual machine scale sets, can maintain consistent user experiences without requiring server affinity.

#### ASP.NET Core

ASP.NET Core applications use the `IDistributedCache` abstraction and session middleware. Azure Managed Redis integrates with `IDistributedCache` through the `Microsoft.Extensions.Caching.StackExchangeRedis` package.

```csharp
builder.Services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = "<your-cache-name>.redis.azure.net:10000";
    options.InstanceName = "app-cache:";
});

builder.Services.AddSession();
```

ASP.NET Core output caching middleware can also use Redis as a distributed backing store, enabling applications to share rendered fragments or pages across all instances. For more information, see [ASP.NET Core output cache provider for Redis](/azure/redis/aspnet-core-output-cache-provider).

#### .NET Aspire integration

[.NET Aspire](/dotnet/aspire/get-started/aspire-overview) applications can use the `Aspire.Hosting.Azure.Redis` package to declare an Azure Managed Redis resource in the app host. Consuming projects receive the connection configuration automatically through dependency injection, which eliminates manual connection-string management across services.

```csharp
// App host: declare the Azure Managed Redis resource
var cache = builder.AddAzureManagedRedis("cache");

builder.AddProject<Projects.ProductService>()
    .WithReference(cache);
```

Consuming services register the distributed cache in the same way as any other `IDistributedCache` provider. For more information, see [.NET Aspire Azure Managed Redis integration](/dotnet/aspire/caching/azure-managed-redis-integration).

#### ASP.NET (classic)

For ASP.NET applications that haven't migrated to ASP.NET Core, Redis-based providers are available for both [session state](/azure/redis/aspnet-session-state-provider) and [output caching](/azure/redis/aspnet-output-cache-provider). These providers enable external session storage and page-level caching across web farm instances without requiring client affinity.

> [!TIP]
> For best performance, deploy your application and Azure Managed Redis instance in the same Azure region.

### Partitioning a Redis cache

Partitioning (or sharding) distributes data across multiple Redis nodes so that the dataset and throughput exceed the capacity of a single server. Partitioning increases scalability, improves load distribution, enables high availability, and supports large or high-throughput workloads.

Azure Managed Redis supports two clustering policies:

- **OSS Clustering Policy (default):**  
  Provides the highest performance and lowest routing overhead. Clients communicate directly with the appropriate shard and follow OSS Redis Cluster semantics, including MOVED and ASK redirections. Cluster-aware clients such as StackExchange.Redis automatically handle these redirects.

- **Redis Enterprise Clustering Policy:**  
  Uses the Redis Enterprise proxy to provide transparent routing through a single endpoint. Clients do not need to implement cluster-aware logic or handle MOVED/ASK responses. This policy offers simpler client integration but introduces a small routing overhead.

Azure Managed Redis also supports **non-clustered mode**, which uses a single primary/replica pair with no sharding. This mode is suitable for smaller workloads or applications that do not require horizontal scale-out.

#### Server-side partitioning

With both clustering policies (OSS or Enterprise), data is automatically sharded across nodes. Clustering provides:

- Key-to-shard hashing and balanced shard placement  
- High availability through primary/replica configuration  
- Automatic failover and resynchronization  
- Online resharding (scale-out and scale-in)  
- Horizontal scaling for large caching layers, JSON stores, search indexes, and vector embedding workloads for AI applications

**In OSS mode**, clients route directly to shards and manage redirection.  
**In Enterprise mode**, the proxy handles routing internally for clients.

#### Partitioning in self-managed environments

Custom partitioning models (such as client-side hashing or third-party proxies) are typically only used in self-managed Redis deployments running on VMs or Kubernetes. These approaches require more operational effort and are generally unnecessary when using Azure Managed Redis, where clustering handles routing, failover, and resharding automatically.

#### Implement Redis cache client applications

Redis supports client applications in many programming languages. For .NET applications, several client libraries are available, each suited for different Redis workloads. Choosing the appropriate library depends on whether Redis is being used strictly as a cache or as a multi-model data platform.

To connect to a Redis server, you use the static `Connect` method of the `ConnectionMultiplexer` class. The connection that this method creates is built for use throughout the lifetime of the client application. The same connection can be used by multiple concurrent threads. Don't reconnect and disconnect each time you perform a Redis operation because this can degrade performance.

#### Choosing a .NET client library

When using Azure Managed Redis, the recommended .NET libraries depend on the scenario:

##### **1. Using Redis for caching

For basic caching scenarios like storing and retrieving string values, byte arrays, or simple serialized objects, the preferred libraries are:

- **StackExchange.Redis** (low-level Redis client, high performance)  
- **Microsoft.Extensions.Caching.StackExchangeRedis** (opinionated `IDistributedCache` integration for ASP.NET Core)

These libraries provide the primitives required to build common caching patterns. However, these patterns are not built into the client libraries. The application must implement the caching logic using Redis commands and background processing where appropriate.

IDistributedCache provides a simplified abstraction suitable for basic distributed caching, but it stores values as opaque byte arrays and does not expose advanced Redis data structures. For more control over caching behavior, including atomic operations, transactions, pipelining, and Lua scripting, use StackExchange.Redis directly.

#### Connecting to Azure Managed Redis

For information about how to connect to Azure Managed Redis using multiple coding languages, see: [How to connect to Azure Managed Redis Quick start](/azure/redis/dotnet)

#### Implementing cache-aside pattern

```csharp
ConfigurationOptions config = new ConfigurationOptions();
...
ConnectionMultiplexer redisHostConnection = ConnectionMultiplexer.Connect(config);
IDatabase db = redisHostConnection.GetDatabase();
...
private async Task<string> RetrieveItemAsync(string itemKey)
{
    // Attempt to retrieve the item from the Redis cache
    string itemValue = await db.StringGetAsync(itemKey);

    // If the value returned is null, the item was not found in the cache
    // So retrieve the item from the data source and add it to the cache
    if (itemValue == null)
    {
        itemValue = await GetItemFromDataSourceAsync(itemKey);
        await db.StringSetAsync(itemKey, itemValue);
    }

    // Return the item
    return itemValue;
}
```

#### Serializing .NET objects

With native JSON support in Redis, you no longer need to manually serialize .NET objects before storing them.

```csharp
public static class RedisJsonExtensions
{
    public static async Task<T?> GetAsync<T>(
        this IDatabase cache,
        string key,
        string path = "$")
    {
        var result = await cache.ExecuteAsync("JSON.GET", key, path);

        if (result.IsNull)
            return default;

        return JsonSerializer.Deserialize<T>(result!);
    }

    public static async Task SetAsync<T>(
        this IDatabase cache,
        string key,
        T value,
        TimeSpan? expiry = null,
        string path = "$")
    {
        var json = JsonSerializer.Serialize(value);

        // Store JSON document
        await cache.ExecuteAsync("JSON.SET", key, path, json);

        // Apply TTL if provided
        if (expiry.HasValue)
        {
            await cache.KeyExpireAsync(key, expiry);
        }
    }

    public static async Task<bool> ExpireAsync(
        this IDatabase cache,
        string key,
        TimeSpan expiry)
    {
        return await cache.KeyExpireAsync(key, expiry);
    }
}
```

### Using Redis as a cache

The simplest way to use Redis for caching is to store values under keys using the key-value model. Values may be strings or binary data of arbitrary length, making Redis well suited for caching serialized objects, configuration data, session state, or precomputed results. This scenario was illustrated earlier in the section *Implement Redis cache client applications*.

Keys also contain uninterpreted data, so you can use any binary information as the key. The longer the key is, however, the more space it takes to store, and the longer it takes to perform lookup operations. For usability and ease of maintenance, design your keyspace carefully and use meaningful (but not verbose) keys.

For example, use structured keys like `customer:100` (instead of just `100`) to represent the key for the customer with ID 100. This scheme enables you to distinguish between values that store different data types. For example, you can also use the key `orders:100` to represent the key for the order with ID 100.

While strings are the most common caching approach, Redis supports a rich set of native data types such as hashes, lists, sets, sorted sets, and streams, enabling more flexible caching patterns. For more information about Redis data types, see the Redis documentation on [data types](https://redis.io/docs/latest/develop/data-types/).

#### Perform atomic and batch operations

Redis provides a set of atomic operations that allow applications to update values safely without race conditions. These operations are performed directly on the server, ensuring the update is completed as a single, indivisible action. Atomic operations are commonly used when Redis is functioning as a cache or a high-performance coordination layer.

#### Atomic operations on string values

Redis offers atomic operations for incrementing, decrementing, or replacing values. These operations prevent race hazards that might occur if `GET` and `SET` were issued separately.

Examples include:

- `INCR`, `INCRBY`, `DECR`, `DECRBY`  
- `GETSET`, which retrieves the value that's associated with a key and changes it to a new value. The StackExchange library makes this operation available through the `IDatabase.StringGetSetAsync` method. The following code snippet shows an example of this method. This code returns the current value that's associated with the key "data:counter" from the previous example. Then it resets the value for this key back to zero, all as part of the same operation:

  ```csharp
  ConnectionMultiplexer redisHostConnection = ...;
  IDatabase cache = redisHostConnection.GetDatabase();
  ...
  string oldValue = await cache.StringGetSetAsync("data:counter", 0);
  ```

- `MGET` and `MSET`, which can return or change a set of string values as a single operation. The `IDatabase.StringGetAsync` and `IDatabase.StringSetAsync` methods are overloaded to support this functionality, as shown in the following example:

  ```csharp
  ConnectionMultiplexer redisHostConnection = ...;
  IDatabase cache = redisHostConnection.GetDatabase();
  ...
  // Create a list of key-value pairs
  var keysAndValues =
      new List<KeyValuePair<RedisKey, RedisValue>>()
      {
          new KeyValuePair<RedisKey, RedisValue>("data:key1", "value1"),
          new KeyValuePair<RedisKey, RedisValue>("data:key99", "value2"),
          new KeyValuePair<RedisKey, RedisValue>("data:key322", "value3")
      };

  // Store the list of key-value pairs in the cache
  cache.StringSet(keysAndValues.ToArray());
  ...
  // Find all values that match a list of keys
  RedisKey[] keys = { "data:key1", "data:key99", "data:key322"};
  // values should contain { "value1", "value2", "value3" }
  RedisValue[] values = cache.StringGet(keys);

  ```

You can also combine multiple operations into a single Redis transaction. The StackExchange library provides support for transactions through the `ITransaction` interface.

You create an `ITransaction` object by using the `IDatabase.CreateTransaction` method. You invoke commands to the transaction by using the methods provided by the `ITransaction` object.

The `ITransaction` interface provides access to a set of methods that's similar to those accessed by the `IDatabase` interface, except that all the methods are asynchronous. This means that they're only performed when the `ITransaction.Execute` method is invoked. The value that's returned by the `ITransaction.Execute` method indicates whether the transaction was created successfully (true) or if it failed (false).

The following code snippet shows an example that increments and decrements two counters as part of the same transaction:

```csharp
ITransaction transaction = cache.CreateTransaction();

var tx1 = transaction.StringIncrementAsync("data:counter1");
var tx2 = transaction.StringDecrementAsync("data:counter2");

bool result = await transaction.ExecuteAsync();

Console.WriteLine("Transaction {0}", result ? "succeeded" : "failed");

if (result)
{
    long increment = await tx1;
    long decrement = await tx2;

    Console.WriteLine("Result of increment: {0}", increment);
    Console.WriteLine("Result of decrement: {0}", decrement);
}
```

Redis transactions are unlike transactions in relational databases. The `Execute` method queues all the commands that comprise the transaction to run, and if any command isn't valid, then the transaction stops. If all the commands have been queued successfully, each command runs asynchronously. If any command fails, the others still continue processing. If you need to verify that a command completed successfully, fetch the results by using the **Result** property of the corresponding task, as shown in the previous example.

For more information about concurrency strategies, transactions, pipelining, and Lua scripting in Azure Managed Redis, see [Manage concurrency](#manage-concurrency) earlier in this article.

#### Perform fire and forget cache operations

Redis supports fire and forget operations by using command flags. In this situation, the client initiates an operation but has no interest in the result and doesn't wait for the command to be completed. The following example shows how to perform the INCR command as a fire and forget operation:

```csharp
ConnectionMultiplexer redisHostConnection = ...;
IDatabase cache = redisHostConnection.GetDatabase();
...
await cache.StringSetAsync("data:key1", 99);
...
cache.StringIncrement("data:key1", flags: CommandFlags.FireAndForget);
```

#### Specify automatically expiring keys

When you store an item in a Redis cache, you can specify a timeout after which the item is automatically removed from the cache. You can also query how much more time a key has before it expires by using the `TTL` command. This command is available to StackExchange applications by using the `IDatabase.KeyTimeToLive` method.

The following code snippet shows how to set an expiration time of 20 seconds on a key, and query the remaining lifetime of the key:

```csharp
ConnectionMultiplexer redisHostConnection = ...;
IDatabase cache = redisHostConnection.GetDatabase();
...
// Add a key with an expiration time of 20 seconds
await cache.StringSetAsync("data:key1", 99, TimeSpan.FromSeconds(20));
...
// Query how much time a key has left to live
// If the key has already expired, the KeyTimeToLive function returns a null
TimeSpan? expiry = cache.KeyTimeToLive("data:key1");
```

You can also set the expiration time to a specific date and time by using the EXPIRE command, which is available in the StackExchange library as the `KeyExpireAsync` method:

```csharp
ConnectionMultiplexer redisHostConnection = ...;
IDatabase cache = redisHostConnection.GetDatabase();
...
// Add a key with an expiration date of midnight on 1st January 2015
await cache.StringSetAsync("data:key1", 99);
await cache.KeyExpireAsync("data:key1",
    new DateTime(2015, 1, 1, 0, 0, 0, DateTimeKind.Utc));
...
```

> [!TIP]
> You can manually remove an item from the cache by using the DEL command, which is available through the StackExchange library as the `IDatabase.KeyDeleteAsync` method.

#### Cross-correlate cached items

When you cache related items, you often need to find them by relationship rather than by primary key alone. For example, you might cache blog posts and need to answer queries like "which posts share tag Y?" or "which tags belong to post X?"

In Azure Managed Redis, the recommended approach is to use [RedisJSON and RediSearch](/azure/redis/overview#modules). Store each cached item as a JSON document with its metadata, then create a RediSearch index over the fields you need to query. RediSearch handles reverse lookups, tag-based filtering, range queries, and full-text search without requiring your application to maintain separate index structures.

For simpler scenarios, you can also use Redis Sets to build forward and reverse indexes manually. Store a Set per post (containing its tags) and a Set per tag (containing the post IDs):

```csharp
foreach (BlogPost post in posts)
{
    string postTagsKey = string.Format(CultureInfo.InvariantCulture,
        "blog:posts:{0}:tags", post.Id);
    await cache.SetAddAsync(
        postTagsKey, post.Tags.Select(s => (RedisValue)s).ToArray());

    foreach (var tag in post.Tags)
    {
        await cache.SetAddAsync(string.Format(CultureInfo.InvariantCulture,
            "tag:{0}:blog:posts", tag), post.Id);
    }
}
```

You can then query tags for a post with `SetMembersAsync`, find common tags across posts with `SetCombineAsync(SetOperation.Intersect, ...)`, or find all posts for a given tag. The tradeoff is that your application must maintain both the forward and reverse Sets, which adds complexity as the number of relationships grows.

#### Find recently accessed items

Many applications need to track the most recently accessed or viewed items. For example, a blogging site might display the most recently read posts to a returning visitor. Redis Lists provide an efficient way to implement recency-based caching patterns. Items can be pushed to either end of the list using `LPUSH` or `RPUSH`, and removed using `LPOP` or `RPOP`. Use `LTRIM` to cap the list length and prevent unbounded memory growth.

#### Implement a leader board

Redis Sorted Sets (ZSETs) maintain ordered rankings by associating each element with a numeric score. Redis keeps the ordering automatically, and operations such as `ZADD`, `ZRANGE`, and `ZREVRANGE` are O(log N), so sorted sets remain efficient even with large item counts.

#### Adding items to a leader board

The following example demonstrates how to add a blog post and its score to a leaderboard using the `ZADD` command via `SortedSetAddAsync`:

```csharp
var db = connection.GetDatabase();
string redisKey = "blog:post_rankings";

BlogPost blogPost = ...; // The blog post being ranked

await db.SortedSetAddAsync(redisKey, blogPost.Title, blogPost.Score);
```

Sorted Sets automatically maintain ascending order by score, and update operations are O(log N), making them highly suitable for large-scale leaderboards.

#### Retrieving ranked items

You can retrieve items in ascending score order using `SortedSetRangeByRankWithScoresAsync`:

```csharp
var entries = await db.SortedSetRangeByRankWithScoresAsync(redisKey);

foreach (var entry in entries)
{
    Console.WriteLine($"{entry.Element}: {entry.Score}");
}
```

> [!NOTE]
> `SortedSetRangeByRankAsync` returns only member values, not scores.

#### Retrieving top-N items

To get the highest-scoring items, such as the top 10 posts, use descending order:

```csharp
foreach (var post in await cache.SortedSetRangeByRankWithScoresAsync(
                               redisKey, 0, 9, Order.Descending))
{
    Console.WriteLine(post);
}
```

#### Retrieving items by score range

You can also query items based on score boundaries rather than rank:

```csharp
foreach (var post in await cache.SortedSetRangeByScoreWithScoresAsync(
                               redisKey, 5000, 100000))
{
    Console.WriteLine(post);
}
```

To prevent a leaderboard from growing indefinitely, remove old entries using `SortedSetRemoveRangeByRankAsync` or use time-scoped keys (for example, daily or weekly leaderboards). You can update scores atomically using `SortedSetIncrementAsync` (`ZINCRBY`).

#### Serialization considerations

When you choose a serialization format, consider tradeoffs between performance, interoperability, versioning, compatibility with existing systems, data compression, and memory overhead. When you evaluate the performance, remember that benchmarks are highly dependent on context. They might not reflect your actual workload, and might not consider newer libraries or versions. There's no single "fastest" serializer for all scenarios.

Some options to consider include:

- [Protocol Buffers](https://protobuf.dev) (also called protobuf) is a serialization format developed by Google for serializing structured data efficiently. It uses strongly typed definition files to define message structures. These definition files are then compiled to language-specific code for serializing and deserializing messages. Protobuf can be used over existing RPC mechanisms, or it can generate an RPC service.

- [Apache Thrift](https://thrift.apache.org) uses a similar approach, with strongly typed definition files and a compilation step to generate the serialization code and RPC services.

- [Apache Avro](https://avro.apache.org) provides similar functionality to Protocol Buffers and Thrift, but there's no compilation step. Instead, serialized data always includes a schema that describes the structure.

- [JSON](https://json.org) is an open standard that uses human-readable text fields. It has broad cross-platform support. JSON doesn't use message schemas. Being a text-based format, it isn't efficient over the wire. In some cases, however, you might be returning cached items directly to a client via HTTP, in which case storing JSON could save the cost of deserializing from another format and then serializing to JSON.

- [binary JSON (BSON)](https://bsonspec.org) is a binary serialization format that uses a structure similar to JSON. BSON was designed to be lightweight, easy to scan, and fast to serialize and deserialize, relative to JSON. Payloads are comparable in size to JSON. Depending on the data, a BSON payload might be smaller or larger than a JSON payload. BSON has some more data types that aren't available in JSON, notably BinData (for byte arrays) and Date.

- [MessagePack](https://msgpack.org) is a binary serialization format that is designed to be compact for transmission over the wire. There are no message schemas or message type checking.

- [Bond](https://microsoft.github.io/bond) is a cross-platform framework for working with schematized data. It supports cross-language serialization and deserialization. Notable differences from other systems listed here are support for inheritance, type aliases, and generics.

- [gRPC](https://www.grpc.io) is an open-source RPC system developed by Google. By default, it uses Protocol Buffers as its definition language and underlying message interchange format.

## Next steps

- [Azure Managed Redis documentation](/azure/redis)
- [Azure Managed Redis FAQ](/azure/redis/faq)
- [Task-based Asynchronous pattern](/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap)
- [Redis documentation](https://redis.io/documentation)
- [StackExchange.Redis](https://stackexchange.github.io/StackExchange.Redis)
- [Data partitioning guide](/previous-versions/msp-n-p/dn589795(v=pandp.10))

## Related resources

The following patterns might also be relevant to your scenario when you implement caching in your applications:

- [Cache-aside pattern](../patterns/cache-aside.yml): This pattern describes how to load data on demand into a cache from a data store. This pattern also helps to maintain consistency between data that's held in the cache and the data in the original data store.

- The [Sharding pattern](../patterns/sharding.yml) provides information about implementing horizontal partitioning to help improve scalability when storing and accessing large volumes of data.
