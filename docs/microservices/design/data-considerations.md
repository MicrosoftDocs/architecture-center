---
title: Data Considerations for Microservices
description: Learn about managing data in a microservices architecture. Data integrity and data consistency pose critical challenges for microservices.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/26/2022
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Data considerations for microservices

This article describes considerations for managing data in a microservices architecture. Each microservice manages its own data, so data integrity and data consistency pose critical challenges. 

Two services shouldn't share a data store. Each service manages its own private data store, and other services can't access it directly. This rule prevents unintentional coupling between services, which happens when services share the same underlying data schemas. If the data schema changes, the change must be coordinated across every service that relies on that database. Isolating each service's data store limits the scope of change and preserves the agility of independent deployments. Each microservice might also have unique data models, queries, or read and write patterns. A shared data store limits each team's ability to optimize data storage for its specific service.

:::image type="complex" source="../images/cqrs-microservices-wrong.png" border="false" alt-text="Diagram that shows a wrong approach to Command Query Responsibility Segregation (CQRS).":::
The diagram shows service A and a database in a section on the left. An arrow labeled write points from service A to the database. Service B resides outside this section on the right. An arrow labeled read points to the database. A red X goes across this arrow.
:::image-end:::

This approach naturally leads to [polyglot persistence](https://martinfowler.com/bliki/PolyglotPersistence.html), which means using multiple data storage technologies within a single application. One service might need the schema-on-read capabilities of a document database. Another service might need the referential integrity that a relational database management system (RDBMS) provides. Each team can choose the best option for its service.

> [!NOTE]
> Services can safely share the same physical database server. Problems occur when services share the same schema, or they read and write to the same set of database tables.

## Challenges

The distributed approach to managing data introduces several challenges. First, redundancy can occur across data stores. The same data item might appear in multiple places. For example, data might be stored as part of a transaction and then stored elsewhere for analytics, reporting, or archiving. Duplicated or partitioned data can lead to problems with data integrity and consistency. When data relationships span multiple services, traditional data management techniques can't enforce those relationships.

Traditional data modeling follows the rule of *one fact in one place*. Every entity appears exactly once in the schema. Other entities might reference it but not duplicate it. The main advantage of the traditional approach is that updates occur in a single place, which prevents data consistency problems. In a microservices architecture, you must consider how updates propagate across services and how to manage eventual consistency when data appears in multiple places without strong consistency.

## Approaches to managing data

No single approach works for all cases. Consider the following general guidelines to manage data in a microservices architecture:

- **Define the required consistency level for each component, and prefer eventual consistency where possible.** Identify areas in the system where you need strong consistency or atomicity, consistency, isolation, and durability (ACID) transactions. And identify areas where eventual consistency is acceptable. For more information, see [Use tactical domain-driven design (DDD) for microservices](../model/tactical-ddd.yml).

- **Use a single source of truth when you require strong consistency.** One service might represent the source of truth for a given entity and expose it through an API. Other services might hold their own copy of the data, or a subset of the data, that's eventually consistent with the primary data but not considered the source of truth. For example, in an e-commerce system that has a customer order service and a recommendation service, the recommendation service might listen to events from the order service. But if a customer requests a refund, the order service, not the recommendation service, has the complete transaction history.

- **Apply transaction patterns to maintain consistency across services.** Use patterns like [Scheduler Agent Supervisor](../../patterns/scheduler-agent-supervisor.yml) and [Compensating Transaction](../../patterns/compensating-transaction.yml) to keep data consistent across multiple services. To avoid partial failure among multiple services, you might need to store an extra piece of data that captures the state of a unit of work that spans multiple services. For example, keep a work item on a durable queue while a multi-step transaction is in progress.

- **Store only the data that a service needs.** A service might only need a subset of information about a domain entity. For example, in the shipping bounded context, you need to know which customer is associated with a specific delivery. But you don't need the customer's billing address because the accounts bounded context manages that information. Careful domain analysis and a DDD approach can enforce this principle.

- **Consider whether your services are coherent and loosely coupled.** If two services continually exchange information with each other and create chatty APIs, you might need to redraw your service boundaries. Merge the two services or refactor their functionality.

- **Use an [event-driven architecture style](../../guide/architecture-styles/event-driven.md).** In this architecture style, a service publishes an event when changes to its public models or entities occur. Other services can subscribe to these events. For example, another service can use the events to construct a materialized view of the data that's more suitable for querying.

  - **Publish a schema for events.** A service that owns events should publish a schema to automate serialization and deserialization of events. This approach avoids tight coupling between publishers and subscribers. Consider JSON schema or a framework like Protobuf or Avro.

  - **Reduce event bottlenecks at scale.** At high scale, events can become a bottleneck on the system. Consider using aggregation or batching to reduce the total load.

## Example: Choose data stores for the drone delivery application

The previous articles in this series describe a drone delivery service as a running example. For more information about the scenario and the corresponding architecture, see [Design a microservices architecture](./index.md).

To recap, this application defines several microservices for scheduling deliveries by drone. When a user schedules a new delivery, the client request includes information about the delivery, like pickup and dropoff locations, and about the package, such as size and weight. This information defines a unit of work.

The various back-end services use different portions of the information in the request and have different read and write profiles.

:::image type="complex" source="../images/data-considerations.svg" border="false" lightbox="../images/data-considerations.svg" alt-text="Diagram that shows data considerations.":::
The diagram shows a flow inside a main section. The flow starts with gateway, then ingestion, then scheduler. Scheduler points to account, external transport, package, drone, and delivery. Delivery points to delivery history and Azure Managed Redis. Delivery history points to a file and a database. Package points to a database. Azure Managed Redis, delivery history, the databases, and the folder reside outside the main section.
:::image-end:::

### Delivery service

The delivery service stores information about every delivery that's currently scheduled or in progress. It listens for events from the drones and tracks the status of deliveries in progress. It also sends domain events with delivery status updates.

Users frequently check the status of a delivery while they wait for their package. So the delivery service requires a data store that emphasizes throughput (read and write) over long-term storage. The delivery service doesn't do complex queries or analysis. It only fetches the latest status for a specific delivery. The delivery service team chose Azure Managed Redis for its high read-write performance. The information stored in Azure Managed Redis is short-lived. After a delivery finishes, the delivery history service becomes the system of record.

### Delivery history service

The delivery history service listens for delivery status events from the delivery service. It stores this data in long-term storage. This historical data supports two scenarios, each with different storage requirements.

The first scenario aggregates data for data analytics to optimize the business or improve service quality. The delivery history service doesn't do the actual data analysis. It only ingests and stores the data. For this scenario, the storage must be optimized for data analysis over large datasets and use a schema-on-read approach to accommodate various data sources. [Azure Data Lake Storage](/azure/data-lake-store/) is a good fit for this scenario because it's an Apache Hadoop file system compatible with Hadoop Distributed File System (HDFS). It's also tuned for performance for data analytics scenarios.

The second scenario lets users look up the history of a delivery after the delivery finishes. Data Lake Storage doesn't support this scenario. For optimal performance, store time-series data in Data Lake Storage in folders partitioned by date. But this structure makes individual ID-based lookups inefficient. Unless you also know the timestamp, an ID lookup requires you to scan the entire collection. To address this problem, the delivery history service also stores a subset of the historical data in Azure Cosmos DB for quicker lookup. The records don't need to stay in Azure Cosmos DB indefinitely. You can archive older deliveries after a specific time period, like a month, by running an occasional batch process. Archiving data can reduce costs for Azure Cosmos DB and keep the data available for historical reporting from Data Lake Storage.

For more information, see [Tune Data Lake Storage for performance](/azure/data-lake-store/data-lake-store-performance-tuning-guidance).

### Package service

The package service stores information about all packages. The data store for the package service must meet the following requirements:

- Long-term storage
- High write throughput to handle a large volume of packages
- Simple queries by package ID without complex joins or referential integrity constraints

The package data isn't relational, so a document-oriented database works well. Azure DocumentDB can achieve high throughput by using sharded collections. The package service team is familiar with the MongoDB, Express.js, AngularJS, and Node.js (MEAN) stack, so they choose to implement [Azure DocumentDB](/azure/documentdb/overview). This choice lets them use their existing MongoDB experience while getting the benefits of a fully managed high-performance Azure service.

## Related resources

- [Design patterns for microservices](./patterns.yml)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
- [Design a microservices architecture](index.md)
- [Design APIs for microservices](api-design.md)
- [Microservices architecture design](../../guide/architecture-styles/microservices.md)
