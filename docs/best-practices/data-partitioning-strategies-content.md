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

For information about partitioning and Azure Cosmos DB, see [Multitenancy and Azure Cosmos DB](../guide/multitenant/service/cosmos-db.md).

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

For information about partitioning and Azure Managed Redis, see [Multitenancy and Azure Managed Redis](../guide/multitenant/service/managed-redis.md).

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
