<!-- cSpell:ignore shardlet shardlets MGET MSET -->

This article describes some strategies for partitioning data in various Azure data stores. For general guidance about when to partition data and best practices, see [Design a data partitioning strategy](/azure/well-architected/design-guides/partition-data).

## Partitioning Azure SQL Database

A single SQL database has a limit to the volume of data that it can contain. Throughput is constrained by architectural factors and the number of concurrent connections that it supports.

[Elastic pools](/azure/azure-sql/database/elastic-pool-overview) support horizontal scaling for a SQL database. Using elastic pools, you can partition your data into shards that are spread across multiple SQL databases. You can also add or remove shards as the volume of data that you need to handle grows and shrinks. Elastic pools can also help reduce contention by distributing the load across databases.

Each shard is implemented as a SQL database. A shard can hold more than one dataset (called a *shardlet*). Each database maintains metadata that describes the shardlets that it contains. A shardlet can be a single data item, or a group of items that share the same shardlet key. For example, in a multitenant application, the shardlet key can be the tenant ID, and all data for a tenant can be held in the same shardlet.

Client applications are responsible for associating a dataset with a shardlet key. A separate SQL Database acts as a global shard map manager. This database has a list of all the shards and shardlets in the system. The application connects to the shard map manager database to obtain a copy of the shard map. It caches the shard map locally, and uses the map to route data requests to the appropriate shard. This functionality is hidden behind a series of APIs that are contained in the [Elastic Database client library](/azure/azure-sql/database/elastic-database-client-library), which is available for Java and .NET.

For more information about elastic pools, see [Scaling out with Azure SQL Database](/azure/azure-sql/database/elastic-scale-introduction).

To reduce latency and improve availability, you can replicate the global shard map manager database. With the Premium pricing tiers, you can configure active geo-replication to continuously copy data to databases in different regions.

Alternatively, use [Azure Data Factory](/azure/data-factory) to replicate the shard map manager database across regions. This form of replication runs periodically and is more suitable if the shard map changes infrequently, and doesn't require Premium tier.

Elastic Database provides two schemes for mapping data to shardlets and storing them in shards:

- A **list shard map** associates a single key to a shardlet. For example, in a multitenant system, the data for each tenant can be associated with a unique key and stored in its own shardlet. To guarantee isolation, each shardlet can be held within its own shard.

  :::image type="content" source="./images/data-partitioning/point-shardlet.svg" alt-text="Diagram that shows a list shard map to store tenant data in separate shards." border="false":::

  *Download a [Visio file](https://arch-center.azureedge.net/data-partitioning-strategies.vsdx) of this diagram.*

- A **range shard map** associates a set of contiguous key values to a shardlet. For example, you can group the data for a set of tenants (each with their own key) within the same shardlet. This scheme is less expensive than the first, because tenants share data storage, but has less isolation.

  :::image type="content" source="./images/data-partitioning/range-shardlet.svg" alt-text="Diagram that shows a range shard map to store data for a range of tenants in a shard." lightbox="./images/data-partitioning/range-shardlet.svg" border="false":::

  *Download a [Visio file](https://arch-center.azureedge.net/data-partitioning-strategies.vsdx) of this diagram*

A single shard can contain the data for several shardlets. For example, you can use list shardlets to store data for different noncontiguous tenants in the same shard. You can also mix range shardlets and list shardlets in the same shard, although they're addressed through different maps. The following diagram shows this approach:

:::image type="content" source="./images/data-partitioning/multiple-shard-maps.svg" alt-text="Diagram that shows multiple shard maps." lightbox="./images/data-partitioning/multiple-shard-maps.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/data-partitioning-strategies.vsdx) of this diagram.*

Elastic pools make it possible to add and remove shards as the volume of data shrinks and grows. Client applications can create and delete shards dynamically, and transparently update the shard map manager. However, removing a shard is a destructive operation that also requires deleting all the data in that shard.

If an application needs to split a shard into two separate shards or combine shards, use the [split-merge tool](/azure/azure-sql/database/elastic-scale-overview-split-and-merge). This tool runs as an Azure web service, and migrates data safely between shards.

The partitioning scheme can significantly affect the performance of your system. It can also affect the rate at which shards have to be added or removed, or that data must be repartitioned across shards. Consider the following points:

- Group data that is used together in the same shard, and avoid operations that access data from multiple shards. A shard is a SQL database in its own right, and cross-database joins must be performed on the client side.

  Although SQL Database doesn't support cross-database joins, you can use the Elastic Database tools to perform [multi-shard queries](/azure/azure-sql/database/elastic-scale-multishard-querying). A multi-shard query sends individual queries to each database and merges the results.

- Don't design a system that has dependencies between shards. Referential integrity constraints, triggers, and stored procedures in one database can't reference objects in another.

- If you have reference data that is frequently used by queries, consider replicating this data across shards. This approach can remove the need to join data across databases. Ideally, such data should be static or slow-moving, to minimize the replication effort and reduce the chances of it becoming stale.

- Shardlets that belong to the same shard map should have the same schema. SQL Database doesn't enforce this rule, but data management and querying becomes complex if each shardlet has a different schema. Instead, create separate shard maps for each schema. Remember that data belonging to different shardlets can be stored in the same shard.

- Transactional operations are only supported for data within a shard, and not across shards. Transactions can span shardlets as long as they're part of the same shard. Therefore, if your business logic needs to perform transactions, either store the data in the same shard or implement eventual consistency.

- Place shards close to the users that access the data in those shards. This strategy helps reduce latency.

- Avoid having a mixture of highly active and relatively inactive shards. Try to spread the load evenly across shards. This might require hashing the sharding keys. If you're geo-locating shards, make sure that the hashed keys map to shardlets held in shards stored close to the users that access that data.

## Partitioning Azure Table storage

For information about partitioning and Azure Table Storage, see [Multitenancy and Azure Table Storage](../guide/multitenant/service/table-storage.md).

## Partitioning Azure Blob Storage

For information about partitioning and Azure Blob Storage, see [Multitenancy and Azure Blob Storage](../guide/multitenant/service/blob-storage.md).

## Partitioning Azure Storage queues

For information about partitioning and Azure Queue Storage, see [Multitenancy and Azure Queue Storage](../guide/multitenant/service/queue-storage.md).

## Partitioning Azure Service Bus

For information about partitioning and Azure Service Bus, see [Multitenancy and Azure Service Bus](../guide/multitenant/service/service-bus.md).

## Partitioning Azure Cosmos DB

[Azure Cosmos DB for NoSQL][cosmos-db-sql-api] is a NoSQL database for storing JSON documents. A document in an Azure Cosmos DB database is a JSON-serialized representation of an object or other piece of data. No fixed schemas are enforced except that every document must contain a unique ID.

Documents are organized into collections. You can group related documents together in a collection. For example, in a system that maintains blog postings, you can store the contents of each blog post as a document in a collection. You can also create collections for each subject type. Alternatively, in a multitenant application, such as a system where different authors control and manage their own blog posts, you can partition blogs by author and create separate collections for each author. The storage space that's allocated to collections is elastic and can shrink or grow as needed.

Azure Cosmos DB supports automatic partitioning of data based on an application-defined partition key. A *logical partition* is a partition that stores all the data for a single partition key value. All documents that share the same value for the partition key are placed within the same logical partition. Azure Cosmos DB distributes values according to hash of the partition key. A logical partition has a maximum size of 20 GB. Therefore, the choice of the partition key is an important decision at design time. Choose a property with a wide range of values and even access patterns. For more information, see [Partitioning and horizontal scaling in Azure Cosmos DB](/azure/cosmos-db/partitioning).

> [!NOTE]
> Each Azure Cosmos DB database has a *performance level* that determines the amount of resources it gets. A performance level is associated with a *request unit (RU)* rate limit. The RU rate limit specifies the volume of resources that's reserved and available for exclusive use by that collection. The cost of a collection depends on the performance level that's selected for that collection. The higher the performance level (and RU rate limit) the higher the charge. You can adjust the performance level of a collection by using the Azure portal. For more information, see [Request Units in Azure Cosmos DB][cosmos-db-ru].

If the partitioning mechanism that Azure Cosmos DB provides isn't sufficient, you might need to shard the data at the application level. Document collections provide a natural mechanism for partitioning data within a single database. The most straightforward way to implement sharding is to create a collection for each shard. Containers are logical resources and can span one or more servers. Fixed-size containers have a maximum limit of 20 GB and 10,000 RU/s throughput. Unlimited containers don't have a maximum storage size, but must specify a partition key. With application sharding, the client application must direct requests to the appropriate shard, usually by implementing its own mapping mechanism based on some attributes of the data that define the shard key.

All databases are created in the context of an Azure Cosmos DB database account. A single account can contain several databases, and it specifies in which regions the databases are created. Each account also enforces its own access control. You can use Azure Cosmos DB accounts to geo-locate shards (collections within databases) close to the users who need to access them, and enforce restrictions so that only those users can connect to them.

Consider the following points when deciding how to partition data with Azure Cosmos DB for NoSQL:

- **The resources available to an Azure Cosmos DB database are subject to the quota limitations of the account**. Each database can contain multiple collections. Each collection has its own performance level, which determines the reserved throughput in request units per second (RU/s) that are available for that collection. For more information, see [Azure subscription and service limits, quotas, and constraints][azure-limits].

- **Each document must have an attribute that can be used to uniquely identify that document within the collection in which it's held**. This attribute is different from the shard key, which defines which collection holds the document. A collection can contain a large number of documents. In theory, it's limited only by the maximum length of the document ID. The document ID can be up to 255 characters.

- **All operations against a document are performed within the context of a transaction. Transactions are scoped to the collection in which the document is contained.** If an operation fails, the work that it has performed is rolled back. While a document is subject to an operation, any changes that are made are subject to snapshot-level isolation. This mechanism guarantees that if, for example, a request to create a new document fails, another user who's querying the database simultaneously won't see a partial document that is then removed.

- **Database queries are also scoped to the collection level**. A single query can retrieve data from only one collection. If you need to retrieve data from multiple collections, you must query each collection individually and merge the results in your application code.

- **Azure Cosmos DB supports programmable items that can all be stored in a collection alongside documents**. These include stored procedures, user-defined functions, and triggers (written in JavaScript). These items can access any document within the same collection. Furthermore, these items run either inside the scope of the ambient transaction (in the case of a trigger that fires as the result of a create, delete, or replace operation performed against a document), or by starting a new transaction (in the case of a stored procedure that is run as the result of an explicit client request). If the code in a programmable item throws an exception, the transaction is rolled back. You can use stored procedures and triggers to maintain integrity and consistency between documents, but these documents must all be part of the same collection.

- **The collections that you intend to hold in the databases should be unlikely to exceed the throughput limits defined by the performance levels of the collections**. For more information, see [Request Units in Azure Cosmos DB][cosmos-db-ru]. If you anticipate reaching these limits, consider splitting collections across databases in different accounts to reduce the load per collection.

## Partitioning Azure AI Search

The ability to search for data is often the primary method of navigation and exploration that's provided by many web applications. It helps users find resources quickly (for example, products in an e-commerce application) based on combinations of search criteria. The AI Search service provides full-text search capabilities over web content, and includes features such as type-ahead, suggested queries based on near matches, and faceted navigation. For more information, see [What is AI Search?].

AI Search stores searchable content as JSON documents in a database. You define indexes that specify the searchable fields in these documents and provide these definitions to AI Search. When a user submits a search request, AI Search uses the appropriate indexes to find matching items.

AI Search manages partitioning for you. You scale a service by adding *partitions* to increase storage and *replicas* to increase query throughput and availability. The service distributes documents across partitions automatically, so you can't define a custom partition key or partitioning scheme within a single service. The main architectural decisions you control are the pricing tier you select and the number of partitions and replicas you allocate. The tier sets the upper bounds on storage, document count, and index count, so choose it based on your projected data volume and query load rather than on current needs alone. For the specific limits per tier, see [Service limits in AI Search](/azure/search/search-limits-quotas-capacity).

> [!NOTE]
> You can store a limited set of data types in searchable documents, including strings, Booleans, numeric data, datetime data, and some geographical data. For more information, see the page [Supported data types (AI Search)] on the Microsoft website.

You have limited control over how AI Search partitions data for each instance of the service. However, in a global environment you might be able to improve performance and reduce latency and contention further by partitioning the service itself using either of the following strategies:

- Create an instance of AI Search in each geographic region, and ensure that client applications are directed toward the nearest available instance. This strategy requires that any updates to searchable content are replicated in a timely manner across all instances of the service.

- Create two tiers of AI Search:

  - A local service in each region that contains the data that's most frequently accessed by users in that region. Users can direct requests here for fast but limited results.
  - A global service that encompasses all the data. Users can direct requests here for slower but more complete results.

This approach is most suitable when there's a significant regional variation in the data that's being searched.

## Partitioning Azure Managed Redis

Azure Managed Redis is a fully managed, enterprise-grade data platform built on Redis Enterprise. It excels at classic caching scenarios, and it also provides a multimodel, in-memory environment that can accelerate both traditional application patterns and modern AI‑driven architectures, like AI agents.

Azure Managed Redis supports built-in high availability and horizontal scaling through Redis clustering, which distributes data across multiple nodes. You can adjust capacity and performance by scaling the service tier and SKU, so you don't need to deploy multiple caches to increase overall storage or throughput. For more information, see [Azure Managed Redis].

Partitioning a Redis data store involves splitting data across multiple nodes. Azure Managed Redis uses native Redis Cluster partitioning to automatically distribute keys across nodes based on hash slots. This approach abstracts the underlying nodes from application logic and removes the need for application-level partition management in most scenarios. For more information about clustering models and client connectivity options in Azure Managed Redis, see [Azure Managed Redis clustering](/azure/redis/architecture#clustering).

Client applications connect to the cluster by using standard Redis client libraries through Redis endpoints. Requests automatically route to the appropriate node within the cluster. If a request reaches a node that doesn't own the requested key, the request forwards internally to the node that holds the corresponding hash slot. The Redis service and supporting client libraries handle request routing and cluster topology management.

Redis clustering is transparent to application logic. Nodes can be added or removed and data can be automatically rebalanced without requiring application reconfiguration.

Operations that involve multiple keys, like transactions or batch operations, must ensure that all participating keys reside in the same partition. Application developers should design key-naming strategies accordingly to support these access patterns.

> [!IMPORTANT]
> Azure Managed Redis provides built-in Redis clustering as part of the service. Applications should generally rely on native Redis Cluster partitioning rather than implementing client-side partitioning logic.

The remainder of this section focuses on data modeling and key design considerations when you work with partitioned Redis data stores.

Consider the following points when you use Azure Managed Redis to structure and partition data:

- Azure Managed Redis doesn't serve as a permanent system of record. Applications must be able to retrieve data from a durable data store if data becomes unavailable, or if data is evicted from Redis.

  Applications populate data in Azure Managed Redis by using different patterns depending on their requirements. In cache-aside approaches, applications load data into Redis on demand. Applications might also use ingestion-based patterns, where data is proactively written to Redis from external systems. You can implement ingestion by using event-driven or batch ingestion mechanisms, like Redis Data Integration (RDI) or Azure Functions, which synchronize data from durable data stores into Redis.

- Structure or model frequently accessed data together, so that it can be stored and retrieved together. Redis provides a broad set of optimized data structures to support different access patterns. Some examples of optimized data structures include:

  - Simple key-value entries for small, bounded values
  - Aggregate types, like lists, which can act as queues and stacks
  - Sets and sorted sets, which support unordered collections and ranked data
  - Hashes, which can group related fields together under a single key
  - Bitmaps for efficient representation of flags and Boolean states
  - Probabilistic data structures, like Bloom filters and HyperLogLog, for space-efficient membership and cardinality estimation
  - Document-oriented structures for storing and querying JSON data
  - Time-series structures optimized for timestamped measurements
  - Indexing and search capabilities for querying structured and semistructured data

- Use aggregate and structured data types to associate many related values with a single key. A Redis key identifies a list, set, sorted set, hash, or document rather than the individual data items that it contains. Azure Managed Redis supports these data structures. For more information, see [Data types].

  For example, in an e-commerce system that tracks customer orders, you can store each customer's details in a Redis hash that uses the customer ID as its key. Each hash holds a collection of order IDs associated with that customer. A separate Redis set stores the orders themselves as hashes that use the order ID as their key. The following diagram shows this structure. Redis doesn't enforce referential integrity, so the application must maintain relationships between customers and orders.

  :::image type="content" source="./images/data-partitioning/redis-customers-and-orders.png" alt-text="Suggested structure in Redis storage for recording customer orders and their details." lightbox="./images/data-partitioning/redis-customers-and-orders.png" border="false":::

  > [!NOTE]
  > In Redis, keys and values are binary-safe and can store values up to hundreds of megabytes (MBs) in size. But you should keep values relatively small and bounded to minimize latency, reduce replication and rebalancing costs, and improve overall efficiency. Ensure that keys follow a consistent naming convention that's descriptive, stable, and not excessively long. A common approach is to use keys of the form `entity_type:ID`. For example, `customer:99` represents the key for a customer with ID 99.

- To implement vertical partitioning, store related information in separate data structures under different keys within the same Redis database. For example, in an e-commerce application, store commonly accessed product information in one Redis hash and store less frequently accessed or more detailed product data in another Redis hash. Both structures can use the same product identifier as part of the key, like `product:nn` for frequently accessed data and `product:details:nn` for detailed information. This approach helps reduce the amount of data that most queries retrieve and improves access efficiency.

- Azure Managed Redis uses built-in Redis clustering to distribute data across nodes and to rebalance data automatically as the cluster scales. Applications don't need to manage repartitioning explicitly. Instead, partition-aware design should focus on key structure, access patterns, and data life cycle.

- Applications usually access Redis by exact key lookups. While careful key design remains important, Azure Managed Redis also provides indexing and search capabilities that applications use to query data based on attributes, ranges, or text content. These capabilities can help avoid application-side key iteration or complex secondary-key management. Apply search and indexing selectively, based on access patterns and query requirements, rather than as a replacement for efficient key-based access.

- Azure Managed Redis supports assigning a time-to-live (TTL) value to keys to control data life cycle. You can use TTL values to manage freshness, enforce retention policies, or support cache and derived-data scenarios. Set up eviction policies to determine how Redis behaves when memory pressure occurs. Design applications to tolerate evictions and reload or regenerate data when necessary.

  > [!NOTE]
  > With Azure Managed Redis, the service tier and SKU determine capacity and performance, and you can adjust them over time as workload requirements change. Design applications to scale independently of specific node sizes or fixed capacity limits.

- Redis batches and transactions can't span multiple partitions. Any data affected by a batch or transaction must reside within the same partition. When you design keys and access patterns, ensure that you colocate related keys that participate in transactional or batched operations.

  > [!NOTE]
  > A sequence of operations in a Redis transaction isn't necessarily atomic in the traditional database sense. The commands that compose a transaction are validated and queued before execution. If an error occurs during this phase, the entire queue is discarded. After the transaction is successfully submitted, the queued commands run sequentially. If a command fails during execution, only that command fails. Previous and subsequent commands in the queue are still executed. For more information, see [Redis transactions](https://redis.io/docs/latest/develop/using-commands/transactions/).

- Redis supports a limited set of atomic operations across multiple keys. The primary multikey atomic operations are `MGET` and `MSET`, which retrieve or store values for a specified set of keys. When you use these operations in a clustered deployment, all referenced keys must reside in the same partition. Design your keys to account for this constraint and ensure correctness and performance.

## Partitioning Azure Event Hubs

For information about partitioning and Azure Event Hubs, see [Multitenancy and Azure Event Hubs](../guide/multitenant/service/event-hubs.md).

### Next steps

For more information about using partitions in Event Hubs, see [What is Event Hubs?].

For considerations about trade-offs between availability and consistency, see [Availability and consistency in Event Hubs].

[Availability and consistency in Event Hubs]: /azure/event-hubs/event-hubs-availability-and-consistency
[azure-limits]: /azure/azure-subscription-service-limits
[Azure Managed Redis]: https://azure.microsoft.com/products/managed-redis
[cosmos-db-ru]: /azure/cosmos-db/request-units
[Data Types]: https://redis.io/docs/latest/develop/data-types/
[cosmos-db-sql-api]: /azure/cosmos-db/sql-api-introduction
[event-hubs]: /azure/event-hubs

[Performing Entity Group Transactions]: /rest/api/storageservices/Performing-Entity-Group-Transactions
[Service Bus quotas]: /azure/service-bus-messaging/service-bus-quotas
[Supported Data Types (AI Search)]: /rest/api/searchservice/Supported-data-types
[What is Event Hubs?]: /azure/event-hubs/event-hubs-what-is-event-hubs
[What is AI Search?]: /azure/search/search-what-is-azure-search
[scalability targets]: /azure/storage/common/scalability-targets-standard-account
