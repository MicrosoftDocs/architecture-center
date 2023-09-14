This example scenario is relevant to organizations that need a highly scalable and resilient architecture for online order processing. Potential applications include e-commerce and retail point-of-sale, order fulfillment, and inventory reservation and tracking.

## Architecture

:::image type="content" alt-text="Diagram of example architecture for a scalable order processing pipeline." source="./media/architecture-ecommerce-order-processing.png" lightbox="./media/architecture-ecommerce-order-processing.png":::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-ecommerce-order-processing.vsdx)* of this architecture.

### Dataflow

This architecture details key components of an order processing pipeline. The data flows through the scenario as follows:

1. Event messages enter the system via customer-facing applications (synchronously over HTTP) and various back-end systems (asynchronously via Apache Kafka). These messages are passed into a command processing pipeline.
2. Each event message is ingested and mapped to one of a defined set of commands by a command processor microservice. The command processor retrieves any current state relevant to executing the command from an event stream snapshot database. The command is then executed, and the output of the command is emitted as a new event.
3. Each event emitted as the output of a command is committed to an event stream database using Azure Cosmos DB.
4. For each database insert or update committed to the event stream database, an event is raised by the Azure Cosmos DB change feed. Downstream systems can subscribe to any event topics that are relevant to that system.
5. All events from the Azure Cosmos DB change feed are also sent to a snapshot event stream microservice, which calculates any state changes caused by events that have occurred. The new state is then committed to the event stream snapshot database stored in Azure Cosmos DB. The snapshot database provides a globally distributed, low latency data source for the current state of all data elements. The event stream database provides a complete record of all event messages that have passed through the architecture, which enables robust testing, troubleshooting, and disaster recovery scenarios.

### Components

- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is Microsoft's globally distributed, multi-model database that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements (SLAs). This scenario uses Azure Cosmos DB for event stream storage and snapshot storage, and it applies [Azure Cosmos DB Change Feed][docs-cosmos-db-change-feed] features to provide data consistency and fault recovery.
- [Apache Kafka on Azure HDInsight](https://azure.microsoft.com/products/hdinsight) is a managed service implementation of Apache Kafka, an open-source distributed streaming platform for building real-time streaming data pipelines and applications. Kafka also provides message broker functionality similar to a message queue, for publishing and subscribing to named data streams. This scenario uses Kafka to process incoming and downstream events, in the order processing pipeline.

## Scenario details

This scenario takes an event-sourcing approach, using a functional programming model implemented via [microservices](https://azure.com/microservices). Each microservice is treated as a stream processor, and all business logic is implemented via microservices. This approach enables high availability and resiliency, geo-replication, and fast performance.

Using managed Azure services such as Azure Cosmos DB and HDInsight can help reduce costs by using Microsoft's expertise in globally distributed cloud-scale data storage and retrieval. This scenario specifically addresses an e-commerce or retail scenario; if you have other needs for data services, you should review the list of available [fully managed intelligent database services in Azure][product-category].

### Potential use cases

Other relevant use cases include:

- E-commerce or retail point-of-sale back-end systems.
- Inventory management systems, for the retail or manufacturing industries.
- Order fulfillment systems.
- Other integration scenarios relevant to an order processing pipeline.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Many technology options are available for real-time message ingestion, data storage, stream processing, storage of analytical data, and analytics and reporting. For an overview of these options, their capabilities, and key selection criteria, see [Big data architectures: Real-time processing](../../data-guide/technology-choices/real-time-ingestion.md) in the [Azure Data Architecture Guide](../../data-guide/index.md).

Microservices have become a popular architectural style for building cloud applications that are resilient, highly scalable, independently deployable, and able to evolve quickly. Microservices require a different approach to designing and building applications. Tools such as Docker, Kubernetes, Azure Service Fabric, and Nomad enable the development of microservices-based architectures. For guidance on building and running a microservices-based architecture, see [Designing microservices on Azure](../../microservices/index.yml) in the Azure Architecture Center.

### Availability

This scenario's event-sourcing approach allows system components to be loosely coupled and deployed independently of one another. Azure Cosmos DB offers [high availability][docs-cosmos-db-regional-failover] and helps organization manage the tradeoffs associated with consistency, availability, and performance, all with [corresponding guarantees][docs-cosmos-db-guarantees]. Apache Kafka on HDInsight is also designed for [high availability][docs-kafka-high-availability].

Azure Monitor provides unified user interfaces for monitoring across various Azure services. For more information, see [Monitoring in Microsoft Azure](/azure/monitoring-and-diagnostics/monitoring-overview). Event Hubs and Stream Analytics are both integrated with Azure Monitor.

For other availability considerations, see the [availability checklist](https://review.learn.microsoft.com/azure/architecture/framework/resiliency/overview).

### Scalability

Kafka on HDInsight allows [configuration of storage and scalability](/azure/hdinsight/kafka/apache-kafka-scalability) for Kafka clusters. Azure Cosmos DB provides fast, predictable performance and [scales seamlessly](/azure/cosmos-db/partition-data) as your application grows. The event-sourcing microservices-based architecture of this scenario also makes it easier to scale your system and expand its functionality.

For other scalability considerations, see the [performance efficiency checklist][scalability] available in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The [Azure Cosmos DB security model](/azure/cosmos-db/secure-access-to-data) authenticates users and provides access to its data and resources. For more information, see [Azure Cosmos DB database security](/azure/cosmos-db/database-security).

For general guidance on designing secure solutions, see the [Azure Security Documentation](/azure/security).

### Resiliency

The event sourcing architecture and associated technologies in this example scenario make this scenario highly resilient when failures occur. For general guidance on designing resilient solutions, see [Designing resilient applications for Azure](/azure/architecture/framework/resiliency/reliability-patterns).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To examine the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how pricing would change for your particular scenario, change the appropriate variables to match your expected data volume. For this scenario, the example pricing includes only Azure Cosmos DB and a Kafka cluster for processing events raised from the Azure Cosmos DB change feed. Event processors and microservices for originating systems and other downstream systems aren't included, and their cost is highly dependent on the quantity and scale of these services as well as the technologies chosen for implementing them.

The currency of Azure Cosmos DB is the request unit (RU). With request units, you don't need to reserve read/write capacities or provision CPU, memory, and IOPS. Azure Cosmos DB supports various APIs that have different operations, ranging from simple reads and writes to complex graph queries. Because not all requests are equal, requests are assigned a normalized quantity of request units based on the amount of computation required to serve the request. The number of request units required by your solution is dependent on data element size and the number of database read and write operations per second. For more information, see [Request units in Azure Cosmos DB](/azure/cosmos-db/request-units). These estimated prices are based on Azure Cosmos DB running in two Azure regions.

We've provided three sample cost profiles based on amount of activity you expect:

- [Small][small-pricing]: this pricing example correlates to 5 RUs reserved with a 1-TB data store in Azure Cosmos DB and a small (D3 v2) Kafka cluster.
- [Medium][medium-pricing]: this pricing example correlates to 50 RUs reserved with a 10-TB data store in Azure Cosmos DB and a midsized (D4 v2) Kafka cluster.
- [Large][large-pricing]: this pricing example correlates to 500 RUs reserved with a 30-TB data store in Azure Cosmos DB and a large (D5 v2) Kafka cluster.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Alex Buck](https://www.linkedin.com/in/alex-buck-0161575) | Senior Content Developer

## Next steps

This example scenario is based on a more extensive version of this architecture built by jet.com for its end-to-end order processing pipeline. For more information, see the [jet.com technical customer profile][source-document] and [jet.com's presentation at Build][source-presentation].

See this other content:

- *[Designing Data-Intensive Applications](https://dataintensive.net)* by Martin Kleppmann (O'Reilly Media, 2017).
- *[Domain Modeling Made Functional: Tackle Software Complexity with Domain-Driven Design and F#](https://pragprog.com/book/swdddf/domain-modeling-made-functional)* by Scott Wlaschin (Pragmatic Programmers LLC, 2018).
- Other [Azure Cosmos DB use cases][docs-cosmos-db-use-cases]
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Consume an Azure Cosmos DB SQL API change feed using the SDK](/training/modules/consume-azure-cosmos-db-sql-api-change-feed-use-sdk)
- [What is Apache Kafka in Azure HDInsight?](/azure/hdinsight/kafka/apache-kafka-introduction)
- [Perform advanced streaming data transformations with Apache Spark and Kafka in Azure HDInsight](/training/modules/perform-advanced-streaming-data-transformations-with-spark-kafka)

## Related resources

See the related architectural content:

- See the [Real time processing architecture](../../data-guide/big-data/real-time-processing.yml) in the [Azure Data Architecture Guide](../../data-guide/index.md).
- [E-commerce front end](/azure/architecture/example-scenario/apps/ecommerce-scenario)
- [Architect scalable e-commerce web app](/azure/architecture/web-apps/idea/scalable-ecommerce-web-app)
- [Intelligent product search engine for e-commerce](/azure/architecture/example-scenario/apps/ecommerce-search)
- [Retail and e-commerce using Azure MySQL](/azure/architecture/solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-mysql)
- [Retail and e-commerce using Azure PostgreSQL](/azure/architecture/solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-postgresql)
- [Magento e-commerce platform in Azure Kubernetes Service](/azure/architecture/example-scenario/magento/magento-azure)
- [E-commerce website running in secured App Service Environment](/azure/architecture/web-apps/idea/ecommerce-website-running-in-secured-ase)
- [Dynamics Business Central as a service on Azure](/azure/architecture/solution-ideas/articles/business-central)
- [Scalable order processing](/azure/architecture/example-scenario/data/ecommerce-order-processing)

<!-- links -->

[architecture]: ./media/architecture-ecommerce-order-processing.png
[product-category]: https://azure.microsoft.com/product-categories/databases
[source-document]: https://customers.microsoft.com/story/jet-com-powers-innovative-e-commerce-engine-on-azure-in-less-than-12-months
[source-presentation]: /events/build-2018/brk3602
[small-pricing]: https://azure.com/e/3d43949ffbb945a88cc0a126dc3a0e6e
[medium-pricing]: https://azure.com/e/1f1e7bf2a6ad4f7799581211f4369b9b
[large-pricing]: https://azure.com/e/75207172ece94cf6b5fb354a2252b333
[docs-cosmos-db-change-feed]: /azure/cosmos-db/change-feed
[docs-cosmos-db-regional-failover]: /azure/cosmos-db/regional-failover
[docs-cosmos-db-guarantees]: /azure/cosmos-db/high-availability#slas-for-availability
[docs-cosmos-db-use-cases]: /azure/cosmos-db/use-cases
[docs-kafka-high-availability]: /azure/hdinsight/kafka/apache-kafka-high-availability
[availability]: /azure/architecture/framework/resiliency/principles
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[resiliency]: /azure/architecture/framework/resiliency/reliability-patterns
[security]: /azure/security
