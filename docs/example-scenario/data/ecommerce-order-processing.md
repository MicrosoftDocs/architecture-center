---
title: Scalable order processing
titleSuffix: Azure Example Scenarios
description: Build a highly scalable order processing pipeline using Azure Cosmos DB.
author: alexbuckgit
ms.date: 07/10/2018
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
  - fasttrack
  - web-apps
social_image_url: /azure/architecture/example-scenario/data/media/architecture-ecommerce-order-processing.png
---

# Scalable order processing on Azure

This example scenario is relevant to organizations that need a highly scalable and resilient architecture for online order processing. Potential applications include e-commerce and retail point-of-sale, order fulfillment, and inventory reservation and tracking.

This scenario takes an event sourcing approach, using a functional programming model implemented via [microservices](https://azure.com/microservices). Each microservice is treated as a stream processor, and all business logic is implemented via microservices. This approach enables high availability and resiliency, geo-replication, and fast performance.

Using managed Azure services such as Cosmos DB and HDInsight can help reduce costs by leveraging Microsoft's expertise in globally distributed cloud-scale data storage and retrieval. This scenario specifically addresses an e-commerce or retail scenario; if you have other needs for data services, you should review the list of available [fully managed intelligent database services in Azure][product-category].

## Relevant use cases

Other relevant use cases include:

- E-commerce or retail point-of-sale back-end systems.
- Inventory management systems.
- Order fulfillment systems.
- Other integration scenarios relevant to an order processing pipeline.

## Architecture

![Example architecture for a scalable order processing pipeline][architecture]

This architecture details key components of an order processing pipeline. The data flows through the scenario as follows:

1. Event messages enter the system via customer-facing applications (synchronously over HTTP) and various back-end systems (asynchronously via Apache Kafka). These messages are passed into a command processing pipeline.
2. Each event message is ingested and mapped to one of a defined set of commands by a command processor microservice. The command processor retrieves any current state relevant to executing the command from an event stream snapshot database. The command is then executed, and the output of the command is emitted as a new event.
3. Each event emitted as the output of a command is committed to an event stream database using Cosmos DB.
4. For each database insert or update committed to the event stream database, an event is raised by the Cosmos DB Change Feed. Downstream systems can subscribe to any event topics that are relevant to that system.
5. All events from the Cosmos DB Change Feed are also sent to a snapshot event stream microservice, which calculates any state changes caused by events that have occurred. The new state is then committed to the event stream snapshot database stored in Cosmos DB. The snapshot database provides a globally distributed, low latency data source for the current state of all data elements. The event stream database provides a complete record of all event messages that have passed through the architecture, which enables robust testing, troubleshooting, and disaster recovery scenarios.

### Components

- [Cosmos DB](/azure/cosmos-db/introduction) is Microsoft's globally distributed, multi-model database that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements (SLAs). This scenario uses Cosmos DB for event stream storage and snapshot storage, and leverages [Cosmos DB's Change Feed][docs-cosmos-db-change-feed] features to provide data consistency and fault recovery.
- [Apache Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is a managed service implementation of Apache Kafka, an open-source distributed streaming platform for building real-time streaming data pipelines and applications. Kafka also provides message broker functionality similar to a message queue, for publishing and subscribing to named data streams. This scenario uses Kafka to process incoming as well as downstream events in the order processing pipeline.

## Considerations

Many technology options are available for real-time message ingestion, data storage, stream processing, storage of analytical data, and analytics and reporting. For an overview of these options, their capabilities, and key selection criteria, see [Big data architectures: Real-time processing](/azure/architecture/data-guide/technology-choices/real-time-ingestion) in the [Azure Data Architecture Guide](/azure/architecture/data-guide).

Microservices have become a popular architectural style for building cloud applications that are resilient, highly scalable, independently deployable, and able to evolve quickly. Microservices require a different approach to designing and building applications. Tools such as Docker, Kubernetes, Azure Service Fabric, and Nomad enable the development of microservices-based architectures. For guidance on building and running a microservices-based architecture, see [Designing microservices on Azure](/azure/architecture/microservices) in the Azure Architecture Center.

### Availability

This scenario's event sourcing approach allows system components to be loosely coupled and deployed independently of one another. Cosmos DB offers [high availability][docs-cosmos-db-regional-failover] and helps organization manage the tradeoffs associated with consistency, availability, and performance, all with [corresponding guarantees][docs-cosmos-db-guarantees]. Apache Kafka on HDInsight is also designed for [high availability][docs-kafka-high-availability].

Azure Monitor provides unified user interfaces for monitoring across various Azure services. For more information, see [Monitoring in Microsoft Azure](/azure/monitoring-and-diagnostics/monitoring-overview). Event Hubs and Stream Analytics are both integrated with Azure Monitor.

For other availability considerations, see the [availability checklist][availability].

### Scalability

Kafka on HDInsight allows [configuration of storage and scalability](/azure/hdinsight/kafka/apache-kafka-scalability) for Kafka clusters. Cosmos DB provides fast, predictable performance and [scales seamlessly](/azure/cosmos-db/partition-data) as your application grows.
The event sourcing microservices-based architecture of this scenario also makes it easier to scale your system and expand its functionality.

For other scalability considerations, see the [scalability checklist][scalability] available in the Azure Architecture Center.

### Security

The [Cosmos DB security model](/azure/cosmos-db/secure-access-to-data) authenticates users and provides access to its data and resources. For more information, see [Cosmos DB database security](/azure/cosmos-db/database-security).

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

The event sourcing architecture and associated technologies in this example scenario make this scenario highly resilient when failures occur. For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Pricing

To examine the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how pricing would change for your particular scenario, change the appropriate variables to match your expected data volume. For this scenario, the example pricing includes only Cosmos DB and a Kafka cluster for processing events raised from the Cosmos DB Change Feed. Event processors and microservices for originating systems and other downstream systems are not included, and their cost is highly dependent on the quantity and scale of these services as well as the technologies chosen for implementing them.

The currency of Azure Cosmos DB is the request unit (RU). With request units, you don't need to reserve read/write capacities or provision CPU, memory, and IOPS. Azure Cosmos DB supports various APIs that have different operations, ranging from simple reads and writes to complex graph queries. Because not all requests are equal, requests are assigned a normalized quantity of request units based on the amount of computation required to serve the request. The number of request units required by your solution is dependent on data element size and the number of database read and write operations per second. For more information, see [Request units in Azure Cosmos DB](/azure/cosmos-db/request-units). These estimated prices are based on Cosmos DB running in two Azure regions.

We have provided three sample cost profiles based on amount of activity you expect:

- [Small][small-pricing]: this pricing example correlates to 5 RUs reserved with a 1 TB data store in Cosmos DB and a small (D3 v2) Kafka cluster.
- [Medium][medium-pricing]: this pricing example correlates to 50 RUs reserved with a 10 TB data store in Cosmos DB and a midsized (D4 v2) Kafka cluster.
- [Large][large-pricing]: this pricing example correlates to 500 RUs reserved with a 30 TB data store in Cosmos DB and a large (D5 v2) Kafka cluster.

## Related resources

This example scenario is based on a more extensive version of this architecture built by [Jet.com](https://jet.com) for its end-to-end order processing pipeline. For more information, see the [jet.com technical customer profile][source-document] and [jet.com's presentation at Build 2018][source-presentation].

Other related resources include:

- *[Designing Data-Intensive Applications](https://dataintensive.net)* by Martin Kleppmann (O'Reilly Media, 2017).
- *[Domain Modeling Made Functional: Tackle Software Complexity with Domain-Driven Design and F#](https://pragprog.com/book/swdddf/domain-modeling-made-functional)* by Scott Wlaschin (Pragmatic Programmers LLC, 2018).
- Other [Cosmos DB use cases][docs-cosmos-db-use-cases]
- [Real time processing architecture](/azure/architecture/data-guide/big-data/real-time-processing) in the [Azure Data Architecture Guide](/azure/architecture/data-guide).

<!-- links -->

[architecture]: ./media/architecture-ecommerce-order-processing.png
[product-category]: https://azure.microsoft.com/product-categories/databases/
[source-document]: https://customers.microsoft.com/story/jet-com-powers-innovative-e-commerce-engine-on-azure-in-less-than-12-months
[source-presentation]: https://channel9.msdn.com/events/Build/2018/BRK3602
[small-pricing]: https://azure.com/e/3d43949ffbb945a88cc0a126dc3a0e6e
[medium-pricing]: https://azure.com/e/1f1e7bf2a6ad4f7799581211f4369b9b
[large-pricing]: https://azure.com/e/75207172ece94cf6b5fb354a2252b333
[docs-cosmos-db-change-feed]: /azure/cosmos-db/change-feed
[docs-cosmos-db-regional-failover]: /azure/cosmos-db/regional-failover
[docs-cosmos-db-guarantees]: /azure/cosmos-db/high-availability#slas-for-availability
[docs-cosmos-db-use-cases]: /azure/cosmos-db/use-cases
[docs-kafka-high-availability]: /azure/hdinsight/kafka/apache-kafka-high-availability
[docs-event-hubs]: /azure/event-hubs/event-hubs-what-is-event-hubs
[docs-stream-analytics]: /azure/stream-analytics/stream-analytics-introduction
[availability]: /azure/architecture/checklist/availability
[scalability]: /azure/architecture/checklist/scalability
[resiliency]: /azure/architecture/patterns/category/resiliency/
[security]: /azure/security/
