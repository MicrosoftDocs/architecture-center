This pattern loads data on demand into a cache from a data store. Use this pattern to improve performance and help maintain consistency between data in a cache and data in an underlying data store.

## Context and problem

Applications use a cache to improve performance for repeated access to information in a data store. But cached data can't always remain consistent with the data store. Applications should implement a strategy that keeps the data in the cache as up-to-date as possible. The strategy should also detect when cached data becomes stale and handle it appropriately.

## Solution

Many commercial caching systems provide read-through and write-through or write-behind operations. In these systems, an application retrieves data by referencing the cache. If the data isn't in the cache, the application retrieves it from the data store and adds it to the cache. The system automatically writes any changes made to cached data back to the data store.

For caches that don't provide this functionality, the applications that use the cache must maintain the data.

An application can emulate the functionality of read-through caching by implementing the Cache-Aside pattern. This strategy loads data into the cache on demand. The following diagram uses the Cache-Aside pattern to store data in the cache.

:::image type="complex" source="./_images/cache-aside-diagram.svg" alt-text="Diagram that shows the use of the Cache-Aside pattern to read and store data in the cache." border="false" lightbox="./_images/cache-aside-diagram.svg":::
   The diagram includes an app, cache, and data store. The cache points to the app, labeled step 1. The data store points to the app, labeled step 2. The app points to the cache, labeled step 3.
:::image-end:::

1. The application determines whether an item currently resides in the cache by attempting to read from the cache.

2. If the item isn't in the cache, also known as a *cache miss*, the application retrieves the item from the data store.
3. The application adds the item to the cache and then returns it to the caller.

If an application updates information, it can follow the write-through strategy by making the modification to the data store and invalidating the corresponding item in the cache.

When the item is needed again, the Cache-Aside pattern retrieves the updated data from the data store and adds it to the cache.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Lifetime of cached data:** Many caches use an expiration policy to invalidate data and remove it from the cache if it isn't accessed for a set period. To make cache-aside effective, ensure that the expiration policy matches the pattern of access for applications that use the data. Don't make the expiration period too short because premature expiration can cause applications to continually retrieve data from the data store and add it to the cache. Similarly, don't make the expiration period so long that the cached data becomes stale. Caching works best for relatively static data or data that applications read frequently.

- **Evicting data:** Most caches have a limited size compared to the data store where the data originates. If the cache exceeds its size limit, it evicts data. Most caches adopt a least-recently-used policy to select items for eviction, but some allow customization.

- **Configuration:** You can configure cache behavior globally or per cached item. A single global eviction policy might not suit all items. If an item is expensive to retrieve, configure the cache item individually. In this situation, it makes sense to keep the item in the cache, even if it gets accessed less frequently than cheaper items.

- **Priming the cache:** Many solutions prepopulate the cache with data that an application likely requires as part of the startup processing. The Cache-Aside pattern remains useful when some of this data expires or gets evicted.

- **Consistency:** The Cache-Aside pattern doesn't guarantee consistency between the data store and the cache. For example, an external process can change an item in the data store at any time. This change doesn't appear in the cache until the item loads again. In a system that replicates data across data stores, frequent synchronization can make consistency challenging.

- **Local caching:** A cache can be local to an application instance and be stored in-memory. Cache-aside works well in this environment if an application repeatedly accesses the same data. But a local cache is private, so different application instances can each have a copy of the same cached data. This data can quickly become inconsistent between caches, so you might need to expire data in a private cache and refresh it more frequently. In these scenarios, consider using a shared or distributed caching mechanism.

- **Semantic caching:** Some workloads can benefit from doing cache retrieval based on semantic meaning rather than exact keys. This approach reduces the number of requests and tokens sent to language models. Only use semantic caching when the data supports semantic equivalence, doesn't risk returning unrelated responses, and doesn't contain private and sensitive data. For example, "What is my yearly take home salary?" is semantically similar to "What is my yearly take home pay?" But if different users ask these questions, the answers should differ. You also shouldn't include this sensitive data in your cache.

## When to use this pattern

Use this pattern when:

- A cache doesn't provide native read-through and write-through operations.

- Resource demand is unpredictable. This pattern enables applications to load data on demand. It doesn't assume which data an application requires in advance.

This pattern might not be suitable when:

- The data is sensitive or security related. Storing data in a cache might be inappropriate, especially when multiple applications or users share the cache. Always retrieve this type of data from the primary source.

- The cached data set is static. If the data fits into the available cache space, prime the cache with the data on startup and apply a policy that prevents the data from expiring.
- Most requests don't experience a cache hit. In this situation, the overhead of checking the cache and loading data into it might outweigh the benefits of caching.
- You cache session state information in a web application hosted in a web farm. In this environment, avoid introducing dependencies based on client-server affinity.

## Workload design

Evaluate how to use the Cache-Aside pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | Caching replicates data. In limited ways, it can preserve the availability of frequently accessed data if the origin data store becomes temporarily unavailable. If the cache malfunctions, the workload can fall back to the origin data store. <br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Caching improves performance for read-heavy data that changes infrequently and tolerates some staleness. <br/><br/> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance)<br/> - [PE:12 Continuous performance optimization](/azure/well-architected/performance-efficiency/continuous-performance-optimize) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

Consider using [Azure Managed Redis](/azure/redis/overview) to create a distributed cache that multiple application instances can share.

The following example uses the [StackExchange.Redis](https://github.com/StackExchange/StackExchange.Redis) client, which is a Redis client library written for .NET. To connect to an Azure Managed Redis instance, call the static `ConnectionMultiplexer.Connect` method and pass in the connection string. The method returns a `ConnectionMultiplexer` that represents the connection.

One way to share a `ConnectionMultiplexer` instance in your application is to have a static property that returns a connected instance, similar to the following example. This approach provides a thread-safe way to initialize only a single connected instance.

```csharp
private static ConnectionMultiplexer Connection;

// Redis connection string information
private static Lazy<ConnectionMultiplexer> lazyConnection = new Lazy<ConnectionMultiplexer>(() =>
{
    string cacheConnection = ConfigurationManager.AppSettings["CacheConnection"].ToString();
    return ConnectionMultiplexer.Connect(cacheConnection);
});

public static ConnectionMultiplexer Connection => lazyConnection.Value;
```

The `GetMyEntityAsync` method in the following example shows an implementation of the Cache-Aside pattern. This method retrieves an object from the cache by using the read-through approach.

The method identifies an object by using an integer ID as the key. It tries to retrieve an item from the cache by using this key. If the cache contains a matching item, it returns the item. If the cache doesn't contain a match, the `GetMyEntityAsync` method retrieves the object from a data store, adds it to the cache, and then returns it. This example omits the code that reads the data from the data store because that logic depends on the data store. The cached item is configured to expire to prevent it from becoming stale if another service or process updates it.

```csharp
// Set five minute expiration as a default
private const double DefaultExpirationTimeInMinutes = 5.0;

public async Task<MyEntity> GetMyEntityAsync(int id)
{
  // Define a unique key for this method and its parameters.
  var key = $"MyEntity:{id}";
  var cache = Connection.GetDatabase();

  // Try to get the entity from the cache.
  var json = await cache.StringGetAsync(key).ConfigureAwait(false);
  var value = string.IsNullOrWhiteSpace(json)
                ? default(MyEntity)
                : JsonConvert.DeserializeObject<MyEntity>(json);

  if (value == null) // Cache miss
  {
    // If there's a cache miss, get the entity from the original store and cache it.
    // Code has been omitted because it is data store dependent.
    value = ...;

    // Avoid caching a null value.
    if (value != null)
    {
      // Put the item in the cache with a custom expiration time that
      // depends on how critical it is to have stale data.
      await cache.StringSetAsync(key, JsonConvert.SerializeObject(value)).ConfigureAwait(false);
      await cache.KeyExpireAsync(key, TimeSpan.FromMinutes(DefaultExpirationTimeInMinutes)).ConfigureAwait(false);
    }
  }

  return value;
}
```

> [!NOTE]
> The examples use Azure Managed Redis to access the store and retrieve information from the cache. For more information, see [Create an Azure Managed Redis instance](/azure/redis/quickstart-create-managed-redis) and [Use Azure Cache for Redis in .NET Core](/azure/redis/dotnet-core-quickstart).

The following `UpdateEntityAsync` method demonstrates how to invalidate an object in the cache when the application changes the value. The code updates the original data store and then removes the cached item from the cache.

```csharp
public async Task UpdateEntityAsync(MyEntity entity)
{
    // Update the object in the original data store.
    await this.store.UpdateEntityAsync(entity).ConfigureAwait(false);

    // Invalidate the current cache object.
    var cache = Connection.GetDatabase();
    var id = entity.Id;
    var key = $"MyEntity:{id}"; // The key for the cached object.
    await cache.KeyDeleteAsync(key).ConfigureAwait(false); // Delete this key from the cache.
}
```

> [!NOTE]
> The order of the steps is important. Update the data store *before* removing the item from the cache. If you remove the cached item first, there's a small window of time when a client might fetch the item before the data store is updated. In this situation, the fetch results in a cache miss because the item isn't in the cache. The cache miss causes the application to retrieve the outdated item from the data store and add it back to the cache. This sequence leads to stale data in the cache.

## Next steps

- [Data consistency primer](/previous-versions/msp-n-p/dn589800(v=pandp.10)): This primer describes problems with consistency across distributed data. It also summarizes how an application can implement eventual consistency to maintain the availability of data. Cloud applications typically store data across multiple data stores and locations. You must efficiently manage and maintain data consistency in this environment, particularly because of concurrency and availability problems that can arise.

- [Use Azure Managed Redis as a semantic cache](/azure/redis/tutorial-semantic-cache): This tutorial shows you how to implement semantic caching by using Azure Managed Redis.

## Related resources

- [Reliable Web App pattern](../web-apps/guides/enterprise-app-patterns/overview.md#reliable-web-app-pattern): This pattern applies the Cache-Aside pattern to web applications in the cloud.

- [Caching guidance](../best-practices/caching.yml): This guidance provides more information about how to cache data in a cloud solution, and problems to consider when you implement a cache.
