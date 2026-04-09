---
title: Sharding Pattern
description: Use the Sharding design pattern to divide a data store into horizontal partitions or shards to improve scalability and performance in distributed systems.
ms.author: pnp
author: claytonsiemens77
ms.date: 04/02/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Sharding pattern

Divide a data store into a set of horizontal partitions or shards. This approach can improve scalability when you store and access large volumes of data.

## Context and problem

A data store on a single server has the following limitations:

- **Storage space:** A data store for a large-scale cloud application can contain a large volume of data that grows over time. A server provides a finite amount of disk storage, and you can replace existing disks with larger ones or add more disks as data volumes grow. The system eventually reaches a limit where you can't increase storage capacity on a single server.

- **Computing resources:** A cloud application must support a large number of concurrent users who each run queries against the data store. A single server might not provide enough computing power for this load, which results in extended response times and timeouts. You can add memory or upgrade processors, but the system reaches a limit where you can't increase compute resources any further.

- **Network bandwidth:** The rate at which a single server can receive requests and send replies limits data store performance. The volume of network traffic can exceed the capacity of the network connection, which results in failed requests.

- **Geography:** Legal, compliance, or performance requirements might require you to store user data in the same geographic region as the users. If users span across countries/regions, you might not be able to store all the application's data in a single data store.

To postpone these limitations temporarily, you can scale vertically by adding disk capacity, processing power, memory, and network connections. A cloud application that must support a large number of users and high data volumes needs to scale horizontally.

## Solution

Divide the data store into horizontal partitions or shards. Each shard has the same schema but contains its own distinct subset of the data. Each shard is a complete data store that can contain data for many entities of different types. A shard runs on a server that functions as a storage node.

This pattern has the following benefits:

- You can scale out the system by adding more shards on extra storage nodes.

- A system can use prebuilt hardware rather than specialized and expensive computers for each storage node.

- You can reduce contention and improve performance by balancing the workload across shards.

- In the cloud, shards can reside physically close to the users who access the data.

When you divide a data store into shards, decide which data to place in each shard. Each shard typically holds items grouped by one or more data attributes. These attributes form the shard key, sometimes referred to as the *partition key*.

Sharding physically organizes the data. When an application stores and retrieves data, the sharding logic directs it to the appropriate shard. You can implement this logic in the application's data access code or in the data storage system if it transparently supports sharding.

Abstracting the physical location of the data in the sharding logic provides control over which shards contain which data. You can also migrate data between shards without modifying application business logic when you need to redistribute data, such as when shards become unbalanced. The trade-off is the extra data access overhead to determine each data item's location during retrieval.

### Shard key selection

The shard key is the most critical design decision in a sharded system. To change a shard key after you choose it, you typically must migrate all data to a new shard layout, which is an expensive and risky operation on a live system. Make this decision carefully before you write any code.

An effective shard key is immutable, has high cardinality, distributes data and load evenly, and aligns with your dominant query patterns so that most requests resolve against a single shard. Avoid monotonically increasing values (autoincrement integers and sequential timestamps), low-cardinality attributes (booleans and small enum sets), and volatile attributes that change frequently. These attributes lead to hotspots or costly cross-shard data movement.

If no single attribute meets these criteria, define a composite shard key by combining two or more attributes. If queries need to retrieve data by attributes that aren't part of the shard key, use a pattern such as the [Index Table](./index-table.yml) pattern to provide secondary lookups.

For more information about how to choose partition keys across Azure services, see [Data partitioning guidance](../best-practices/data-partitioning.yml) and [Data partitioning strategies](../best-practices/data-partitioning-strategies.yml).

## Sharding strategies

Use one of the following strategies when you select the shard key and decide how to distribute data across shards. You don't need a one-to-one correspondence between shards and the servers that host them. A single server can host multiple shards.

### Lookup sharding strategy

In the lookup strategy, also called the *directory-based strategy*, the sharding logic implements a map that routes a data request to the shard that contains that data by using the shard key. In a multitenant application, you might store all the data for a tenant together in a shard by using the tenant ID as the shard key. Multiple tenants might share the same shard, but the data for a single tenant doesn't spread across multiple shards. The following diagram shows sharding tenant data based on tenant IDs.

:::image type="complex" source="./_images/sharding-tenant.svg" lightbox="./_images/sharding-tenant.svg" alt-text="Diagram that shows tenant data based on tenant IDs" border="false":::
Two application instances send queries for specific tenants to a sharding logic component. The sharding logic routes each request to the correct shard, such as shard A, shard B, or shard C, based on tenant ID. Each shard stores a distinct subset of the data.
:::image-end:::

The mapping between shard key values and physical storage can be direct, where each shard key value maps to a physical partition. A more flexible technique is virtual partitioning, where shard key values map to virtual shards, and the system then maps those virtual shards to fewer physical partitions. An application locates data by using a shard key value that refers to a virtual shard, and the system transparently maps virtual shards to physical partitions. The mapping between a virtual shard and a physical partition can change without requiring application code modifications.

### Range-based sharding strategy

The range-based strategy groups related items together in the same shard and orders them by sequential shard key. This strategy supports applications that frequently retrieve sets of items by using range queries. Range queries return a set of data items for a shard key that falls within a given range.

For example, if an application regularly needs to find all orders placed in a given month, you can retrieve the data faster if you store all orders for a month in date and time order in the same shard. If you store each order in a different shard, the application has to fetch them individually by performing a large number of point queries. The following diagram shows sequential sets, or ranges, of data stored in shards.

:::image type="complex" source="./_images/sharding-sequential-sets.svg" lightbox="./_images/sharding-sequential-sets.svg" alt-text="Diagram that shows sequential sets, or ranges, of data stored in shards." border="false":::
Application instances submit queries for orders placed in specific months. A sharding logic component maps each month to a shard, such as October to shard A, November to shard B, and December to shard C. Orders are stored in date and time sequence within each shard.
:::image-end:::

In this example, the shard key is a composite key that contains the order month as the most significant element, followed by the order day and time. New orders are naturally sorted as they're created and added to a shard.

Some data stores support two-part shard keys. A partition key identifies the shard, and a row key uniquely identifies an item within the shard. The shard typically stores data in row key order. For items that need range queries and must be grouped together, you can use a shard key that has the same value for the partition key but a unique value for the row key.

### Hash-based sharding strategy

The hash-based strategy reduces the chance of hotspots, which are shards that receive a disproportionate amount of load. This strategy distributes data across shards to balance the size of each shard and the average load that each shard encounters. The sharding logic computes the shard to store an item in based on a hash of one or more attributes of the data. The chosen hashing function should distribute data evenly across the shards. The following diagram shows sharding tenant data based on a hash of tenant IDs.

:::image type="complex" source="./_images/sharding-data-hash.svg" lightbox="./_images/sharding-data-hash.svg" alt-text="Diagram that shows sharding tenant data based on a hash of tenant IDs." border="false":::
Application instances submit queries for specific tenants. A sharding logic component hashes the tenant ID and routes each request to a shard, such as tenant 55 to shard B and tenant 56 to shard N. Each shard stores a subset of tenant data.
:::image-end:::

To understand the advantage of the hash strategy over other sharding strategies, consider how a multitenant application that enrolls new tenants sequentially might assign the tenants to shards in the data store. When you use the range strategy, the data for tenants *1* to *n* are stored in shard A, the data for tenants *n+1* to *m* are stored in shard B, and later tenant ranges map to successive shards. If the most recently registered tenants are also the most active, most data activity occurs in a few shards, which can cause hotspots. In contrast, the hash strategy allocates tenants to shards based on a hash of their tenant ID. The hash usually distributes sequential tenants across different shards, which balances the load. The previous diagram shows this approach for tenants 55 and 56.

### Geographic sharding strategy

The geographic strategy assigns data to shards based on the geographic origin or intended consumption region of that data. In many workloads, users and the data that they generate are concentrated in specific regions. Regulatory requirements such as data residency laws might require that specific data remain within a specific jurisdiction. Even without regulatory drivers, placing data close to the users who access it most frequently reduces network latency for reads and writes.

:::image type="complex" source="./_images/sharding-geographic.svg" lightbox="./_images/sharding-geographic.svg" alt-text="Diagram that shows sharding data based on the geography of the application instance." border="false":::
Application instances route queries through a sharding logic component that maps regions to shards. Requests from Asia-Pacific route to shard A, Europe to shard B, and the Americas to shard C. Each shard stores data for its assigned region.
:::image-end:::

In this strategy, you derive the shard key from a geographic attribute such as the user's country/region, the originating datacenter region, or a regional tenant identifier. You host each shard in, or pin it to, infrastructure within that geographic boundary. 

For example, an application that serves customers in North America, Europe, and Asia-Pacific might maintain three shard groups, one group in each corresponding Azure region. A European application that serves only European users routes a request to the Europe shard. This approach reduces latency and meets data residency requirements.

Geographic sharding introduces the risk of uneven data distribution. If most of your users reside in one region, that region's shard carries a disproportionate share of the load and storage. You can combine geographic sharding with another strategy, such as hash or lookup, within each region to distribute load evenly across multiple shards inside the same geographic boundary.

### Advantages and considerations for each strategy

The four sharding strategies have the following advantages and considerations:

- **The lookup strategy** provides more control over shard configuration. Virtual shards reduce the impact of rebalancing because you can add new physical partitions to balance the workload. You can modify the mapping between a virtual shard and its physical partitions without affecting application code. Looking up shard locations adds overhead.

- **The range strategy** is easy to implement and works well with range queries. Range queries can retrieve multiple data items from a single shard in one operation. Data management is simpler. For example, you can schedule updates per time zone based on local load patterns when users in the same region share a shard. However, this strategy doesn't balance load evenly across shards. Rebalancing is difficult and might not resolve uneven load when most activity concentrates on adjacent shard keys.

- **The hash strategy** provides a better chance of even data and load distribution. You can route requests directly by using the hash function without maintaining a map. Computing the hash adds some overhead. Rebalancing is difficult without consistent hashing.

- **The geographic strategy** meets data residency and sovereignty requirements that other strategies don't inherently address. It reduces read and write latency when users access data in their region. However, geographic sharding can create significant data and load imbalance when user populations aren't evenly distributed across regions. Queries that span regions, such as global reporting, must retrieve data from all geographic shards and incur higher latency. Combine geographic sharding with another strategy within each region when you need both compliance and even load distribution.

Most sharding systems implement one of these approaches, but you should also consider the business requirements of your application and its data usage patterns. For example, in a multitenant application:

- You can shard data based on the workload. Segregate data for highly volatile tenants in separate shards to improve data access speed for other tenants.

- You can shard data based on tenant location. Take tenant data in a specific geographic region offline for backup and maintenance during that region's off-peak hours, while tenant data in other regions remains online during their business hours.

- Assign high-value tenants their own dedicated, lightly loaded shards. Lower-value tenants can share more densely packed shards.

- Store data for tenants that need strong data isolation and privacy on separate servers.

### Scaling and data movement operations for each strategy

Each sharding strategy provides different capabilities and levels of complexity to manage scale in, scale out, data movement, and state maintenance.

- **The lookup strategy** allows scaling and data movement operations at the user level, either online or offline. To move data:

   1. Suspend some or all user activity, typically during off-peak periods.

   1. Move the data to the new virtual partition or physical shard.

   1. Update the mappings.

   1. Invalidate or refresh any caches that hold this data.

   1. Resume user activity.

   You can often manage this operation centrally. The lookup strategy requires state to be highly cacheable and replica friendly.

- **The range strategy** limits scaling and data movement operations because you must split and merge data across shards, typically while part or all of the data store is offline. When you move data to rebalance shards, you might not eliminate uneven load if most activity concentrates on adjacent shard keys or data identifiers within the same range. The range strategy might also require state to map ranges to physical partitions.

- **The hash strategy** complicates scaling and data movement operations. The partition keys are hashes of the shard keys or data identifiers. With a standard hash function, such as `hash(key) mod N`, adding or removing a shard reassigns most keys and triggers large-scale data migration. Consistent hashing reduces this impact by arranging the hash space so that only a small fraction of keys move when the shard count changes. The hash strategy doesn't require maintenance of a separate mapping state.

- **The geographic strategy** directly links scaling operations to regional infrastructure provisioning. Adding capacity in one region doesn't relieve load in another region. Regulatory requirements that mandate geographic sharding can also restrict data movement across geographic boundaries. Within each region, scaling uses the secondary strategy that distributes data across that region's shards.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Use sharding complementary to other forms of partitioning, such as vertical partitioning and functional partitioning. For example, a single shard can contain vertically partitioned entities, and you can implement a functional partition as multiple shards. For more information, see [Horizontal, vertical, and functional data partitioning](../best-practices/data-partitioning.yml).

- Keep shards balanced so that they can all handle a similar input/output (I/O) volume. Data skew accumulates over time when records are inserted and deleted, which leads to hotspots. Plan to rebalance periodically.

  Rebalancing moves data between shards and often causes downtime or reduced throughput. To rebalance less frequently, use virtual partitions. Map many logical partitions to fewer physical shards. When a shard is overloaded, redistribute its virtual partitions to new physical shards without rehashing the entire dataset. Azure Cosmos DB uses this approach to decouple the partition scheme from the physical infrastructure.

  Prefer many small shards over few large ones. Smaller shards migrate faster, balance load more evenly, and provide more flexibility for data redistribution.

- Use stable data for the shard key. If the shard key changes, you might need to move the corresponding data item between shards, which increases update operation overhead. Avoid basing the shard key on potentially volatile information. Choose attributes that are invariant or naturally form a key.

- Ensure that shard keys are unique. For example, avoid using autoincrementing fields as the shard key. In some systems, autoincremented fields can't coordinate across shards, which can result in items in different shards having the same shard key.

  > [!NOTE]
  > Autoincremented values in other fields that aren't shard keys can also cause problems. For example, if you use autoincremented fields to generate unique IDs, two different items in different shards might be assigned the same ID.

- Shard the data to support the most frequently performed queries. You might not be able to design a shard key that matches the requirements of every query against the data. If necessary, create secondary index tables to support queries that retrieve data by attributes that aren't part of the shard key. For more information, see [Index Table pattern](./index-table.yml).

- Design your shard key and data model to keep most operations scoped to a single shard. Queries that access only a single shard are more efficient than queries that retrieve data from multiple shards. Denormalize your data to keep related entities that are commonly queried together, such as customers and their orders, in the same shard to reduce the number of separate reads.

  Cross-shard queries add latency, resource consumption, and complexity. When an application must retrieve data from multiple shards, use parallel fan-out queries that run against each shard concurrently and aggregate the results. Even with parallelism, the slowest shard determines overall latency.

  > [!TIP]
  > If an entity in one shard references an entity in another shard, include the shard key for the second entity as part of the schema for the first entity. This approach can improve the performance of queries that reference related data across shards.

- Reconsider your shard key or whether sharding fits your needs if your workload requires strong transactional integrity across shard boundaries. Cross-shard transactions present challenges. Distributed coordination protocols, such as two-phase commit, add latency, introduce failure modes, and reduce throughput. Most sharded systems avoid distributed transactions and adopt eventual consistency instead. In this model, each shard updates independently, and the application handles temporary inconsistencies.

- Make sure the resources available to each shard storage node can handle the scalability requirements in terms of data size and throughput. For more information, see [Data partitioning strategies](../best-practices/data-partitioning-strategies.yml).

- Consider replicating reference data to all shards. If a query against a shard also references static or slow-moving data, add this data to the shard. The application can then fetch all data for the query without making a round trip to a separate data store.

  > [!NOTE]
  > If reference data held in multiple shards changes, the system must sync these changes across all shards. Some degree of inconsistency can occur while this synchronization runs. Design your applications to tolerate this inconsistency.

- Sharded systems multiply operational burden. Plan for these concerns:

  - **Monitoring:** You must aggregate metrics and logs across all shards to get a complete view of system health.

  - **Backup and restore:** You must back up each shard independently and design restore procedures to maintain cross-shard consistency. A point-in-time restore of one shard can create inconsistencies with other shards.

  - **Schema changes:** You must coordinate Data Definition Language (DDL) changes across every shard.

  You can implement these tasks by using scripts or other automation solutions.

- You can geolocate shards to place their data near the application instances that use it. This approach can improve performance but requires extra planning for operations that must access multiple shards in different locations.

## When to use this pattern

> [!TIP]
> Before you design a custom sharding layer, determine which sharding responsibilities your data platform already handles. Some services manage sharding completely. For example, Azure Cosmos DB distributes data across physical partitions, handles splits, and routes queries without application involvement. Other services manage sharding partially. For example, Azure SQL Database provides [elastic database tools](/azure/azure-sql/database/elastic-scale-introduction) for shard map management and data-dependent routing, but you design the shard key and manage split operations. Use the Sharding pattern when you build and operate the sharding logic yourself.

Use this pattern when:

- The total data volume exceeds the storage capacity of a single database instance, and no vertical scaling option addresses the shortfall.

- The transaction throughput or query concurrency exceeds what a single instance can sustain, and read replicas alone don't resolve the bottleneck because write load is also high.

  > [!NOTE]
  > Sharding improves the performance and scalability of a system, and it can also improve availability. A failure in one partition doesn't necessarily prevent an application from accessing data in other partitions. And an operator can perform maintenance or recovery of one partition without making all data unavailable. For more information, see [Data partitioning guidance](../best-practices/data-partitioning.yml).

- Regulatory or compliance requirements mandate that specific data subsets reside in specific geographic jurisdictions, and no single-region deployment can meet all requirements.

- Distinct tenants or customer segments require physical data isolation for security, performance, or contractual reasons.

  In scenarios like these, the sharding pattern is sometimes applied beyond traditional data stores. For example, a DNS zone management system could be sharded by team, environment, or region to reduce the blast radius of DNS changes and establish clear ownership boundaries. In that context, the primary motivation is operational segmentation rather than scalability. For more information, see [Sharding private DNS zones](/azure/dns/sharding-private-dns-zones).

Sharding introduces substantial and permanent complexity into your data architecture. That complexity affects development, operations, testing, query design, and failure recovery for the system's lifetime.

This pattern might not be suitable when:

- Your data volume and throughput fit within a single database instance, even with projected growth. Vertical scaling preserves query simplicity and transactional integrity.

- Your bottleneck is read volume, not write volume or storage capacity. Read replicas and caching layers can offload read traffic without the cross-shard query complexity that sharding introduces.

- Your database engine supports table-level partitioning that meets your performance needs. Partitioning within a single instance doesn't require multiple servers or routing logic.

- Your dominant query patterns require cross-entity joins, multientity transactions, or full-dataset aggregations. Sharding makes these operations expensive, and the overhead of fan-out queries and distributed coordination can outweigh the scaling benefits.

## Workload design

Evaluate how to use the Sharding pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | Data and processing are isolated to the shard, so a malfunction in one shard remains isolated to that shard. <br><br> - [Data partitioning](/azure/well-architected/design-guides/partition-data) <br> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment**. | A system that implements shards often benefits from using multiple instances of less expensive compute or storage resources rather than a single more expensive resource. In many cases, this configuration can save you money. <br/><br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | When you use sharding in your scaling strategy, data and processing are isolated to each shard, so requests only compete for resources within their assigned shard. You can also use sharding to optimize based on geography. <br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) <br/> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

Consider a website that surfaces an expansive collection of information about published books worldwide. The number of possible books cataloged in this workload and the typical query and usage patterns exceed what a single relational database can handle. The workload architect decides to shard the data across multiple database instances by using the books' static ISBN as the shard key. Specifically, the architect uses the [check digit](https://wikipedia.org/wiki/ISBN#Check_digits) (0 - 10) of the ISBN, which provides 11 possible logical shards with fairly balanced data distribution.

To start, the architect colocates the 11 logical shards into three physical shard databases. In this [virtual partition approach](#problems-and-considerations), many logical partitions map to fewer physical nodes. The architect uses the *lookup* sharding approach and stores the key-to-server mapping in a shard map database.

:::image type="complex" source="_images/sharding-example.svg" alt-text="Diagram that shows a sharded SQL Database architecture for a book catalog application." border="false":::
   Azure App Service is labeled Book catalog website. It connects to multiple SQL Database instances and an Azure AI Search instance. One of the databases is labeled as the ShardMap database. It includes an example table that mirrors a part of the mapping table, which is listed later in this article. The table includes three shard databases instances: bookdbshard0, bookdbshard1, and bookdbshard2. The other databases include identical example listings of tables under them. The tables include Books, LibraryOfCongressCatalog, and an indicator of more tables. AI Search is used for faceted navigation and site search. Managed identity is associated with the App Service.
:::image-end:::

### Lookup shard map

The shard map database contains the following shard mapping table and data.

```sql
SELECT ShardKey, DatabaseServer
FROM BookDataShardMap
```

```output
| ShardKey | DatabaseServer |
|----------|----------------|
|        0 | bookdbshard0   |
|        1 | bookdbshard0   |
|        2 | bookdbshard0   |
|        3 | bookdbshard1   |
|        4 | bookdbshard1   |
|        5 | bookdbshard1   |
|        6 | bookdbshard2   |
|        7 | bookdbshard2   |
|        8 | bookdbshard2   |
|        9 | bookdbshard0   |
|       10 | bookdbshard1   |
```

### Example website code: single shard access

The website isn't aware of how many physical shard databases exist (three in this case) or the logic that maps a shard key to a database instance. It only knows that the check digit of a book's ISBN is the shard key. The website has read-only access to the shard map database and read-write access to all shard databases. In this example, the website uses the system managed identity of its Azure App Service host for authorization, which keeps secrets out of connection strings.

The website is configured with the following connection strings either in an `appsettings.json` file, as shown in this example, or through App Service app settings.

```json
{
  ...
  "ConnectionStrings": {
    "ShardMapDb": "Data Source=tcp:<database-server-name>.database.windows.net,1433;Initial Catalog=ShardMap;Authentication=Active Directory Default;App=Book Site v1.5a",
    "BookDbFragment": "Data Source=tcp:SHARD.database.windows.net,1433;Initial Catalog=Books;Authentication=Active Directory Default;App=Book Site v1.5a"
  },
  ...
}
```

The following code shows how the website runs an update query against the workload's database shard pool.

```csharp
...

// All data for this book is stored in a shard based on the book's ISBN check digit,
// which is converted to an integer 0 - 10 (special value 'X' becomes 10).
int isbnCheckDigit = book.Isbn.CheckDigitAsInt;

// Establish a pooled connection to the database shard for this specific book.
using (SqlConnection sqlConn = await shardedDatabaseConnections.OpenShardConnectionForKeyAsync(key: isbnCheckDigit, cancellationToken))
{
  // Update the book's Library of Congress catalog information.
  SqlCommand cmd = sqlConn.CreateCommand();
  cmd.CommandText = @"UPDATE LibraryOfCongressCatalog
                         SET ControlNumber = @lccn,
                             ...
                             Classification = @lcc
                       WHERE BookID = @bookId";

  cmd.Parameters.AddWithValue("@lccn", book.LibraryOfCongress.Lccn);
  ...
  cmd.Parameters.AddWithValue("@lcc", book.LibraryOfCongress.Lcc);
  cmd.Parameters.AddWithValue("@bookId", book.Id);

  await cmd.ExecuteNonQueryAsync(cancellationToken);
}

...
```

In the previous example code, if `book.Isbn` was **978-8-1130-1024-6**, then `isbnCheckDigit` should be **6**. The `OpenShardConnectionForKeyAsync(6)` call is typically implemented by using a cache-aside approach. If cached shard information for shard key **6** isn't available, the method queries the shard map database identified by the `ShardMapDb` connection string. The method retrieves the value **bookdbshard2** from either the application cache or the shard database and substitutes it for `SHARD` in the `BookDbFragment` connection string. The method then establishes or reestablishes a pooled connection to **bookdbshard2.database.windows.net**, opens it, and returns it to the calling code. The code then updates the existing record on that database instance.

### Example website code: multiple shard access

In the rare case when the website requires a direct, cross-shard query, the application performs a parallel fan-out query across all shards.

```csharp
...

// Retrieve all shard keys.
var shardKeys = shardedDatabaseConnections.GetAllShardKeys();

// Run the query in a fan-out style against each shard in the shard list.
Parallel.ForEachAsync(shardKeys, async (shardKey, cancellationToken) =>
{
  using (SqlConnection sqlConn = await shardedDatabaseConnections.OpenShardConnectionForKeyAsync(key: shardKey, cancellationToken))
  {
    SqlCommand cmd = sqlConn.CreateCommand();
    cmd.CommandText = @"SELECT ...
                          FROM ...
                         WHERE ...";

    SqlDataReader reader = await cmd.ExecuteReaderAsync(cancellationToken);

    while (await reader.ReadAsync(cancellationToken))
    {
      // Collect the results into a thread-safe data structure.
    }

    reader.Close();
  }
});

...
```

As an alternative to cross-shard queries, this workload can use an externally maintained index in Azure AI Search for site search or faceted navigation.

### Add shard instances

The workload team knows that if the data catalog or its concurrent usage grows significantly, they might require more than three database instances. The workload team doesn't expect to add database servers dynamically, and they accept workload downtime when a new shard comes online. To bring a new shard instance online, they must move data from existing shards into the new shard and update the shard map table. With this fairly static approach, the workload can confidently cache the shard key database mapping in the website code.

The shard key logic in this example has an upper limit of 11 physical shards. If the workload team determines through load estimation that they eventually require more than 11 database instances, they must make an invasive change to the shard key logic. This change involves careful planning of code modifications and data migration to the new key logic.

### SDK functionality

Instead of writing custom code for shard management and query routing to SQL Database instances, evaluate the [elastic database client library](/azure/azure-sql/database/elastic-database-client-library). This library supports shard map management, data-dependent query routing, and cross-shard queries in both C# and Java.

## Next step

- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels): Distributing data across shards introduces consistency trade-offs. This article describes the spectrum of consistency models, from strong to eventual, and their effects on availability and latency.

## Related resources

- [Horizontal, vertical, and functional data partitioning](../best-practices/data-partitioning.yml): This article describes other strategies for partitioning data in the cloud to improve scalability, reduce contention, and optimize performance.
- [Index Table pattern](./index-table.yml): Sometimes you can't support all queries through the design of the shard key alone. An application can use the Index Table pattern to retrieve data from a large data store by specifying a key other than the shard key.
- [Materialized View pattern](./materialized-view.yml): To maintain the performance of some query operations, you can create materialized views that aggregate and summarize data, especially if you distribute that data across shards.
