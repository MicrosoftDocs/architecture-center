---
title: Data platform for mission-critical workloads on Azure
description: Data decisions for the baseline reference architecture for a mission-critical workload on Azure.
author: msimecek
categories: database
ms.author: csiemens
ms.date: 09/20/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
  - database
azureCategories:
  - database  
summary: Data decisions for the baseline reference architecture for a mission-critical workload on Azure.
products:
  - azure-cosmosdb
  - azure-event-hubs
  - azure-service-bus
---
# Data platform for mission-critical workloads on Azure

In a mission-critical architecture, any state must be stored outside the compute as much as possible. The choice of technology is based on these key architectural characteristics:

|Characteristics|Considerations|
|---|---|
|Performance|How much compute is required?|
|Latency|What impact will the distance between the user and the data store have on latency? What is the desired level of consistency with tradeoff on latency?|
|Responsiveness|Is the data store required to be always available?|
|Scalability|What's the partitioning scheme?|
|Durability|Is the data expected to long lasting? What is the retention policy? |
|Resiliency|In case of a failure, is the data store able to fail over automatically? What measures are in place to reduce the failover time? |
|Security|Is the data encrypted? Can the datastore be reached over public network?|

In this architecture, there are two data stores:

- **Database** 

  Stores related to the workload.  It's recommended that all state is stored globally in a database separated from regional stamps. Build redundancy by deploying the database across regions. For mission-critical workloads, synchronizing data across regions should be the primary concern. Also, in case of a failure, write requests to the database should still be functional.

  Data replication in an active-active configuration is highly recommended. The application should be able to instantly connect with another region. All instances should be able to handle read and write requests.

- **Message broker**

  The only stateful service in the regional stamp is the message broker, which stores requests for a short period. The broker serves the need for buffering and reliable messaging. The processed requests are persisted in the global database.

> For other data considerations, see [Misson-critical guidance in Well-architected Framework: Data platform considerations](/azure/architecture/framework/mission-critical/mission-critical-data-platform).

## Database

This architecture uses Azure Cosmos DB for NoSQL. This option is chosen because it provides the most features needed in this design:

- **Multi-region write**

  Multi-region write is enabled with replicas deployed to every region in which a stamp is deployed. Each stamp can write locally and Azure Cosmos DB handles data replication and synchronization between the stamps. This capability significantly lowers latency for geographically distributed end-users of the application. The Azure Mission-Critical reference implementation uses multi-master technology to provide maximum resiliency and availability.

  Zone redundancy is also enabled within each replicated region.

  For details on multi-region writes, see [Configure multi-region writes in your applications that use Azure Cosmos DB](/azure/cosmos-db/sql/how-to-multi-master).

- **Conflict management**

  With the ability to perform writes across multiple regions comes the necessity to adopt a conflict management model as simultaneous writes can introduce record conflicts. Last Writer Wins is the default model and is used for the Mission Critical design. The last writer, as defined by the associated timestamps of the records wins the conflict. Azure Cosmos DB for NoSQL also allows for a custom property to be defined.

- **Query optimization**

  A general query efficiency recommendation for read-heavy containers with a high number of partitions is to add an equality filter with the itemID identified. An in-depth review of query optimization recommendations can be found at [Troubleshoot query issues when using Azure Cosmos DB](/azure/cosmos-db/sql/troubleshoot-query-performance).

- **Backup feature**

  It's recommended that you use the native backup feature of Azure Cosmos DB for data protection. [Azure Cosmos DB backup feature](/azure/cosmos-db/online-backup-and-restore) supports online backups and on-demand data restore.

> [!NOTE]
> Most workloads aren't purely OLTP. There is an increasing demand for real-time reporting, such as running reports against the operational system. This is also referred to as HTAP (Hybrid Transactional and Analytical Processing). Azure Cosmos DB supports this capability via [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link-use-cases).

### Data model for the workload

Data model should be designed such that features offered by traditional relational databases aren't required. For example, foreign keys, strict row/column schema, views, and others.

The workload has these **data access characteristics**:

- Read pattern:
  - Point reads - Fetching a single record. Item ID and partition key is directly used for maximum optimization (1 RU per request).
  - List reads - Getting catalog items to display in a list. `FeedIterator` with limit on number of results is used.
- Write pattern:
  - Small writes - Requests usually insert a single or a small number of records in a transaction.
- Designed to handle high traffic from end-users with the ability to scale to handle traffic demand in the order of millions of users.
- Small payload or dataset size - usually in order of KB.
- Low response time (in order of milliseconds).
- Low latency (in order of milliseconds).

### Configuration

Azure Cosmos DB is configured as follows:

- **Consistency level** is set to the default *Session consistency* because it's the most widely used level for single region and globally distributed applications. Weaker consistency with higher throughput isn't needed because of the asynchronous nature of write processing and doesn't require low latency on database write.

  > [!NOTE] 
  > The _Session_ consistency level offers a reasonable tradeoff for latency, availability and consistency guarantees for this specific application. It's important to understand that _Strong_ consistency level isn't available for multi-master write databases.

- **Partition key** is set to `/id` for all collections. This decision is based on the usage pattern, which is mostly *"writing new documents with GUID as the ID"* and *"reading wide range of documents by IDs"*. Providing the application code maintains its ID uniqueness, new data is evenly distributed into partitions by Azure Cosmos DB, enabling infinite scale.

- **Indexing policy** is configured on collections to optimize queries. To optimize RU cost and performance, a custom indexing policy is used. This policy only indexes the properties that are used in query predicates. For example, the application doesn't use the comment text field as a filter in queries. It was excluded from the custom indexing policy.

Here's an example from the implementation that shows indexing policy settings using Terraform:

```
indexing_policy {

  excluded_path {
    path = "/description/?"
  }

  excluded_path {
    path = "/comments/text/?"
  }

  included_path {
    path = "/*"
  }

}
```

For information about connection from the application to Azure Cosmos DB in this architecture, see [Application platform considerations for mission-critical workloads](./mission-critical-app-design.md#database-connection)

## Messaging services

Mission critical systems often utilize messaging services for message or event processing. These services promote loose coupling and act as a buffer that insulates the system against unexpected spikes in demand.

- Azure Service Bus is recommended for message-based workloads when handling high-value messages.
- Azure Event Hubs is recommended for event-based systems that process high volumes of events or telemetry.

The following are design considerations and recommendations for Azure Service Bus premium and Azure Event Hubs in a mission critical architecture.

### Handle load

The messaging system must be able to handle the required throughput (as in MB per second). Consider the following:

- The non-functional requirements (NFRs) of the system should specify the average message size and the peak number of messages/second each stamp must support. This information can be used to calculate the required peak MB/second per stamp.
- The impact of a failover must be considered when calculating the required peak MB/second per stamp.
- For Azure Service Bus, the NFRs should specify any advanced Service Bus features such as sessions and de-duping messages. These features will affect the throughput of Service Bus.
- The throughput of Service Bus with the required features should be calculated through testing as MB/second per Messaging Unit (MU). For more information about this topic, see [Service Bus premium and standard messaging tiers](/azure/service-bus-messaging/service-bus-premium-messaging).
- The throughput of Azure Event Hubs should be calculated through testing as MB/second per throughput unit (TU) for the standard tier or processing unit (PU) for premium tier. For more information about this topic, see [Scaling with Event Hubs](/azure/event-hubs/event-hubs-scalability).
- The above calculations can be used to validate that the messaging service can handle the required load per stamp, and the required number of scale units required to meet that load.
- The operations section will discuss auto-scaling.

### Every message must be processed

Azure Service Bus premium tier is the recommended solution for high-value messages for which processing must be guaranteed. The following are details regarding this requirement when using Azure Service Bus premium:

- To ensure that messages are properly transferred to and accepted by the broker, message producers should use one of the supported Service Bus API clients. Supported APIs will only return successfully from a send operation if the message was persisted on the queue/topic.
- To ensure messages on the bus are processed, you should use [PeekLock receive mode](/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock). This mode enables at-least once processing. The following outlines the process:
  - The message consumer receives the message to process.
  - The consumer is given an exclusive lock on the message for a given time duration.
  - If the consumer successfully processes the message, it sends an acknowledgment back to the broker, and the message is removed from the queue.
  - If an acknowledgment isn't received by the broker in the allotted time period, or the handler explicitly abandons the message, the exclusive lock is released. The message is then available for other consumers to process the message.
  - If a message is not successfully processed a configurable number of times, or the handler forwards the message to the [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues).
    - To ensure that messages sent to the dead-letter queue are acted upon, the dead-letter queue should be monitored, and alerts should be set.
    - The system should have tooling for operators to be able to [inspect, correct, and resubmit messages](/azure/service-bus-messaging/service-bus-dead-letter-queues#sending-dead-lettered-messages-to-be-reprocessed).

- Because messages can potentially be processed more than one time, message handlers should be made idempotent.

#### Idempotent message processing

In [RFC 7231](https://tools.ietf.org/html/rfc7231#section-4), the Hypertext Transfer Protocol states, "A ... method is considered _idempotent_ if the intended effect on the server of multiple identical requests with that method is the same as the effect for a single such request."

One common technique of making message handling idempotent is to check a persistent store, like a database, if the message has already been processed. If it has been processed, you wouldn't run the logic to process it again. 
- There might be situations where the processing of the message includes database operations, specifically the insertion of new records with database-generated identifiers. New messages can be emitted to the broker, which contain those identifiers. Because there aren't distributed transactions that encompass both the database and the message broker, there can be a number of complications that can occur if the process running the code happens to fail. See the following example situations:
  - The code emitting the messages might run before the database transaction is committed, which is how many developers work using the [Unit of Work pattern](https://www.programmingwithwolfgang.com/repository-and-unit-of-work-pattern). Those messages can _escape_, if the failure occurs between calling the broker and asking that the database transaction be committed. As the transaction rolls back, those database-generated IDs are also undone, which leaves them available to other code that might be running at the same time. This can cause recipients of the _escaped_ messages to process the wrong database entries, which hurts the overall consistency and correctness of your system.
  - If developers put the code that emits the message *after* the database transaction completes, the process can still fail between these operations (transaction committed - message sent). When that happens, the message will go through processing again, but this time the idempotence guard clause will see that it has already been processed (based on the data stored in the database). The clause will skip the message emitting code, believing that everything was done successfully last time. Downstream systems, which were expecting to receive notifications about the completed process, do not receive anything. This situation again results in an overall state of inconsistency.
- The solution to the above problems involves using the [Transactional Outbox pattern](/azure/architecture/best-practices/transactional-outbox-cosmos), where the outgoing messages are stored _off to the side_, in the same transactional store as the business data. The messages are then transmitted to the message broker, when the initial message has been successfully processed.
- Since many developers are unfamiliar with these problems or their solutions, in order to guarantee that these techniques are applied consistently in a mission-critical system, we suggest you have the functionality of the outbox and the interaction with the message broker wrapped in some kind of library. All code processing and sending transactionally-significant messages should make use of that library, rather than interacting with the message broker directly.
  - Libraries that implement this functionality in .NET include [NServiceBus](https://docs.particular.net/nservicebus/outbox) and [MassTransit](https://masstransit-project.com/advanced/transactional-outbox.html).

### High availability and disaster recovery

The message broker must be available for producers to send messages and consumers to receive them. The following are details regarding this requirement:

- To ensure the highest availability with Service Bus, use the premium tier, which has support for availability zones in supporting regions. With availability zones, messages and metadata are replicated across three disparate data centers in the same region.
- Use supported Service Bus or Event Hubs SDKs to automatically retry read or write failures.
- Consider [active-active replication](/azure/service-bus-messaging/service-bus-federation-overview#all-active-replication) or [active-passive replication](/azure/service-bus-messaging/service-bus-federation-overview#active-passive-replication) patterns to insulate against regional disasters.

> [!NOTE]
> Azure Service Bus Geo-disaster recovery only replicates metadata across regions. This feature does not replicate messages.

### Monitoring

The messaging system acts as a buffer between message producers and consumers. There are key indicator types that you should monitor in a mission-critical system that provide valuable insights described below:

- **Throttling** - Throttling indicates that the system does't have the required resources to process the request. Both Service Bus and Event Hubs support monitoring throttled requests. You should alert on this indicator.
- **Queue depth** - A queue depth that is growing can indicate that message processors aren't working or there aren't enough processors to handle the current load. Queue depth can be used to inform auto-scaling logic of handlers.
  - For Service Bus, queue depth is exposed as message count
  - For Event Hubs, the consumers have to calculate queue depth per partition and push the metric to your monitoring software. For each read, the consumer gets the sequence number of the current event, and the event properties of the last enqueued event. The consumer can calculate the offset.
- **Dead-letter queue** - Messages in the dead-letter queue represent messages that couldn't be processed. These messages usually require manual intervention. Alerts should be set on the dead-letter queue.
  - Service Bus has a [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) and a DeadLetteredMessages metric.
  - For Event Hubs, this functionality must be custom logic built into the consumer.
- **CPU/Memory usage** - CPU and memory should be monitored to ensure the messaging system has enough resources to process the current load. Both Service Bus premium and Event Hubs premium expose CPU and memory Usage.
  - Messaging units (MUs) are used in Service Bus to isolate resources such as CPU and memory for a namespace. CPU and memory rising above a threshold can indicate that there aren't enough MUs configured, while falling below other thresholds can indicate that there are too many MUs configured. These indicators can be used to [auto-scale MUs](/azure/service-bus-messaging/automate-update-messaging-units).
  - Event Hubs premium tier uses processing units (PUs) to isolate resources, while standard tier uses throughput units (TUs). Those tiers don't requires interaction with CPU/Memory to auto-inflate PUs or TUs.

### Health check

The health of the messaging system must be considered in the health checks for a mission critical application. Consider the following factors:

- The messaging system acts as a buffer between message producers and consumers. The stamp can be viewed as healthy if producers are able to successfully send messages to the broker and if consumers are able to successfully process messages from the broker.
- The health check should ensure that messages can be sent to the message system.

## Next steps

Deploy the reference implementation to get a full understanding of the resources and their configuration used in this architecture.

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)
