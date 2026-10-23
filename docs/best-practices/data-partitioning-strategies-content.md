<!-- cSpell:ignore shardlet shardlets MGET MSET -->

This article describes some strategies for partitioning data in various Azure data stores. For general guidance about when to partition data and best practices, see [Design a data partitioning strategy](/azure/well-architected/design-guides/partition-data).

## Partitioning Azure SQL Database

For information about partitioning and Azure SQL Database, see [Multitenancy and Azure SQL Database](../guide/multitenant/service/sql-database.md).

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
