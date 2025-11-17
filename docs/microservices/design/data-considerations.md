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

Two services shouldn't share a data store. Each service manages its own private data store, and other services can't access it directly. This rule prevents unintentional coupling between services, which happens when services share the same underlying data schemas. If the data schema changes, the change must be coordinated across every service that relies on that database. Isolating each service's data store limits the scope of change and preserves the agility of independent deployments. Each microservice might also have unique data models, queries, or read and write patterns. A shared data store limits each team's ability to optimize data storage for their particular service.

:::image type="complex" source="../images/cqrs-microservices-wrong.png" border="false" lightbox="../images/cqrs-microservices-wrong.png" alt-text="Diagram that shows a wrong approach to Command Query Responsibility Segregation (CQRS).":::
The diagram shows service A and a database in a section on the left. An arrow labeled write points from service A to the database. Service B resides outside this section on the right. An arrow labeled read points to the database. A red X goes across this arrow.
:::image-end:::

This approach naturally leads to [polyglot persistence](https://martinfowler.com/bliki/PolyglotPersistence.html), which means using multiple data storage technologies within a single application. One service might require the schema-on-read capabilities of a document database. Another service might need the referential integrity that a relational database management system (RDBMS) provides. Each team can choose the best option for its service.

> [!NOTE]
> Services can share the same physical database server. Problems occur when services share the same schema, or they read and write to the same set of database tables.

## Challenges

The distributed approach to managing data introduces several challenges. First, redundancy can occur across data stores. The same data item might appear in multiple places. For example, data might be stored as part of a transaction and then stored elsewhere for analytics, reporting, or archiving. Duplicated or partitioned data can lead to problems with data integrity and consistency. When data relationships span multiple services, traditional data management techniques can't enforce those relationships.

Traditional data modeling follows the rule of *one fact in one place*. Every entity appears exactly once in the schema. Other entities might hold references to it but not duplicate it. The obvious advantage to the traditional approach is that updates are made in a single place, which avoids problems with data consistency. In a microservices architecture, you have to consider how updates are propagated across services, and how to manage eventual consistency when data appears in multiple places without strong consistency.

## Approaches to managing data

No single approach works for all cases, but consider the following general guidelines to manage data in a microservices architecture:

- **Define the required consistency level for each component, and prefer eventual consistency where possible.** Identify areas in the system where you need strong consistency or atomicity, consistency, isolation, and durability (ACID) transactions. And identify areas where eventual consistency is acceptable. For more information, see [Use tactical domain-driven design (DDD) to design microservices](../model/tactical-ddd.yml).

- **Use a single source of truth when you require strong consistency.** One service might represent the source of truth for a given entity and expose it through an API. Other services might hold their own copy of the data, or a subset of the data, that is eventually consistent with the master data but not considered the source of truth. For example, imagine an e-commerce system with a customer order service and a recommendation service. The recommendation service might listen to events from the order service, but if a customer requests a refund, it's the order service, not the recommendation service, that has the complete transaction history.

- **Apply transaction patterns to maintain consistency across services.** Use patterns such as [Scheduler Agent Supervisor](../../patterns/scheduler-agent-supervisor.yml) and [Compensating Transaction](../../patterns/compensating-transaction.yml) to keep data consistent across multiple services. To avoid partial failure among multiple services, you might need to store an extra piece of data that captures the state of a unit of work that spans multiple services. For example, keep a work item on a durable queue while a multi-step transaction is in progress.

- **Store only the data that a service needs.** A service might only need a subset of information about a domain entity. For example, in the Shipping bounded context, you need to know which customer is associated with a particular delivery. But you don't need the customer's billing address becuase the Accounts bounded context manages that information. Careful domain analysis and a DDD approach can enforce this principle.

- Consider whether your services are coherent and loosely coupled. If two services are continually exchanging information with each other, resulting in chatty APIs, you might need to redraw your service boundaries, by merging two services or refactoring their functionality.

- Use an [event-driven architecture style](../../guide/architecture-styles/event-driven.md). In this architecture style, a service publishes an event when there are changes to its public models or entities. Interested services can subscribe to these events. For example, another service could use the events to construct a materialized view of the data that is more suitable for querying.

- A service that owns events should publish a schema that can be used to automate serializing and deserializing the events, to avoid tight coupling between publishers and subscribers. Consider JSON schema or a framework like [Microsoft Bond](https://github.com/Microsoft/bond), Protobuf, or Avro.

- At high scale, events can become a bottleneck on the system, so consider using aggregation or batching to reduce the total load.

## Example: Choosing data stores for the Drone Delivery application

The previous articles in this series discuss a drone delivery service as a running example. You can read more about the scenario and the corresponding architecture in [Design a microservices architecture](./index.md).

To recap, this application defines several microservices for scheduling deliveries by drone. When a user schedules a new delivery, the client request includes information about the delivery, such as pickup and dropoff locations, and about the package, such as size and weight. This information defines a unit of work.

The various backend services care about different portions of the information in the request, and also have different read and write profiles.

:::image type="complex" source="../images/data-considerations.svg" border="false" lightbox="../images/data-considerations.svg" alt-text="Diagram that shows data considerations.":::
The diagram shows a flow inside a main section. The flow starts with gateway, then ingestion, then scheduler. Scheduler points to account, external transport, package, drone, and delivery. Delivery points to delivery history and Azure Managed Redis. Delivery history points to a file and a database. Package points to a database. Azure Managed Redis, delivery history, the databases, and the folder reside outside the main section.
:::image-end:::

### Delivery service

The Delivery service stores information about every delivery that is currently scheduled or in progress. It listens for events from the drones, and tracks the status of deliveries that are in progress. It also sends domain events with delivery status updates.

It's expected that users will frequently check the status of a delivery while they are waiting for their package. Therefore, the Delivery service requires a data store that emphasizes throughput (read and write) over long-term storage. Also, the Delivery service doesn't perform any complex queries or analysis, it simply fetches the latest status for a given delivery. The Delivery service team chose Azure Managed Redis for its high read-write performance. The information stored in Redis is relatively short-lived. Once a delivery is complete, the Delivery History service is the system of record.

### Delivery History service

The Delivery History service listens for delivery status events from the Delivery service. It stores this data in long-term storage. There are two different use-cases for this historical data, which have different data storage requirements.

The first scenario is aggregating the data for the purpose of data analytics, in order to optimize the business or improve the quality of the service. Note that the Delivery History service doesn't perform the actual analysis of the data. It's only responsible for the ingestion and storage. For this scenario, the storage must be optimized for data analysis over a large set of data, using a schema-on-read approach to accommodate a variety of data sources. [Azure Data Lake Store](/azure/data-lake-store/) is a good fit for this scenario. Data Lake Store is an Apache Hadoop file system compatible with Hadoop Distributed File System (HDFS), and is tuned for performance for data analytics scenarios.

The other scenario is enabling users to look up the history of a delivery after the delivery is completed. Azure Data Lake isn't optimized for this scenario. For optimal performance, Microsoft recommends storing time-series data in Data Lake in folders partitioned by date. (See [Tuning Azure Data Lake Store for performance](/azure/data-lake-store/data-lake-store-performance-tuning-guidance)). However, that structure isn't optimal for looking up individual records by ID. Unless you also know the timestamp, a lookup by ID requires scanning the entire collection. Therefore, the Delivery History service also stores a subset of the historical data in Azure Cosmos DB for quicker lookup. The records don't need to stay in Azure Cosmos DB indefinitely. Older deliveries can be archived &mdash; say, after a month. This could be done by running an occasional batch process. Archiving older data can reduce costs for Cosmos DB while still keeping the data available for historical reporting from the Data Lake.

### Package service

The Package service stores information about all of the packages. The storage requirements for the Package are:

- Long-term storage.
- Able to handle a high volume of packages, requiring high write throughput.
- Support simple queries by package ID. No complex joins or requirements for referential integrity.

Because the package data isn't relational, a document-oriented database is appropriate, and Azure Cosmos DB can achieve high throughput by using sharded collections. The team that works on the Package service is familiar with the MEAN stack (MongoDB, Express.js, AngularJS, and Node.js), so they select the [MongoDB API](/azure/cosmos-db/mongodb-introduction) for Azure Cosmos DB. That lets them leverage their existing experience with MongoDB, while getting the benefits of Azure Cosmos DB, which is a managed Azure service.

## Related resources

- [Design patterns for microservices](./patterns.yml)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
- [Design a microservices architecture](index.md)
- [Design APIs for microservices](api-design.yml)
- [Microservices architecture design](../../guide/architecture-styles/microservices.md)
