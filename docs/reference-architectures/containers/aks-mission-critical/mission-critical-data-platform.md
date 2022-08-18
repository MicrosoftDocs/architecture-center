---
title: Data platform for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources - Networking.
author: esbran
categories: database
ms.author: csiemens
ms.date: 08/01/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
  - database
azureCategories:
  - database  
summary: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources.
products:
  - azure-cosmosdb
---
# Data platform for mission-critical workloads on Azure

## Database

**[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/)** was chosen as the main database as it provides the crucial ability of multi-region writes: each stamp can write to the Cosmos DB replica in the same region with Cosmos DB internally handling data replication and synchronization between regions.

The Azure Mission-Critical reference implementation contains a cloud-native application as its sample workload. Its data model does not require features offered by traditional relational databases (e.g. entity linking across tables with foreign keys, strict row/column schema, views etc.).

The SQL API of Cosmos DB is being used as it provides the most features and there is no requirement for migration scenario (to or from some other database like MongoDB).

The reference implementation uses Cosmos DB as follows:

- **Consistency level** is set to the default "Session consistency" as the most widely used level for single region and globally distributed applications. Azure Mission-Critical does not use weaker consistency with higher throughput because the asynchronous nature of write processing doesn't require low latency on database write.

- **Partition key** is set to `/id` for all collections. This decision is based on the usage pattern which is mostly "writing new documents with random GUID as ID" and "reading wide range of documents by ID". Providing the application code maintains its ID uniqueness, new data will be evenly distributed into partitions by Cosmos DB.

- **Indexing policy** is configured on collections to optimize queries. To optimize RU cost and performance a custom indexing policy is used and this only indexes properties used in query predicates. For example, the application doesn't use the winning player name field as a filter in queries and so it was excluded from the custom indexing policy.

*Example of setting indexing policy in Terraform:*

```hcl
indexing_policy {

  excluded_path {
    path = "/winningPlayerName/?"
  }

  excluded_path {
    path = "/playerGestures/gesture/?"
  }

  excluded_path {
    path = "/playerGestures/playerName/?"
  }

  included_path {
    path = "/*"
  }

}
```

- **Database structure** follows basic NoSQL principles and stores related data as single documents.
  - Application code gets the `playerName` information from AAD and stores it in the database instead of querying AAD each time.
  - Leaderboard is generated on-demand and persists in the database (instead of recalculating on every request) as this action can be a database-heavy operation.

- **In application code**, the SDK is configured as follows:
  - Use Direct connectivity mode (default for .NET SDK v3) as this offers better performance because there are fewer network hops compared to Gateway mode which uses HTTP.
  - `EnableContentResponseOnWrite` is set to `false` to prevent the Cosmos DB client from returning the resource from Create, Upsert, Patch and Replace operations to reduce network traffic and because this is not needed for further processing on the client.
  - Custom serialization is used to set the JSON property naming policy to `JsonNamingPolicy.CamelCase` (to translate .NET-style properties to standard JSON-style and vice-versa) and the default ignore condition to ignore properties with null values when serializing (`JsonIgnoreCondition.WhenWritingNull`).

The Azure Mission-Critical reference implementation leverages the native backup feature of Cosmos DB for data protection. [Cosmos DB's backup feature](https://docs.microsoft.com/azure/cosmos-db/online-backup-and-restore) supports online backups and on-demand data restore.

> Note - In practice, most workloads are not purely OLTP. There is an increasing demand for real-time reporting, such as running reports against the operational system. This is also referred to as HTAP (Hybrid Transactional and Analytical Processing). Cosmos DB supports this capability via [Azure Synapse Link for Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/synapse-link-use-cases).

- **Multi-region write**

Cosmos DB multi-master technology allows your application to write data to the the database in every region that it is deployed in, significantly lowering latency for geographically distributed end-users of the application. The Azure Mission-Critical reference implementation leverages multi-master technology to provide the highest level of app resilience and efficiency available.

- **Conflict management**

With the ability to perform writes across multiple regions comes the necessity to adopt a conflict management model as simultaneous writes can introduce record conflicts.  Last Writer Wins is the default model and is used for the Mission Critical design. The last writer, as defined by the associated timestamps of the records wins the conflict.  The SQL API also allows for a custom property to be defined. 

- **Query optimization**

Given the partition key design recommendation above, a general query efficiency recommendation for read-heavy containers with a high number of partitions is to add an equality filter with the itemID identified.  An in-depth review of query optimization recommendations can be found at [Troubleshoot query issues when using Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/troubleshoot-query-performance).



## Messaging services

Mission critical systems often utilize messaging services for message or event processing. These services promote loose coupling and act as a buffer that insulates the system against unexpected spikes in demand.

- Azure Service Bus is recommended for message-based workloads when handling high-value messages.
- Azure Event Hubs is recommended for event-based systems that process high volumes of events or telemetry.

The following are design considerations and recommendations for Azure Service Bus premium and Azure Event Hubs in a mission critical architecture.

### Handle load

The messaging system must be able to handle the required throughput (as in MB per second). Consider the following:

- The non-functional requirements (NFRs) of the system should specify the average message size and the peak number of messages/second each stamp must support. This can be used to calculate the required peak MB/second per stamp.
- The impact of a failover must be considered when calculating the required peak MB/second per stamp.
- For Azure Service Bus, the NFRs should specify any advanced Service Bus features such as sessions and de-duping messages. These features will affect the throughput of Service Bus.
- The throughput of Service Bus with the required features should be calculated through testing as MB/second per Messaging Unit (MU). For more information about this topic, see [Service Bus premium and standard messaging tiers](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-premium-messaging).
- The throughput of Azure Event Hubs should be calculated through testing as MB/second per throughput unit (TU) for the standard tier or processing unit (PU) for premium tier. For more information about this topic, see [Scaling with Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-scalability).
- The above calculations can be used to validate that the messaging service can handle the required load per stamp, and the required number of scale units required to meet that load.
- The operations section will discuss auto-scaling.

### Every message must be processed

Azure Service Bus premium tier is the recommended solution for high-value messages for which processing must be guaranteed. The following are details regarding this requirement when using Azure Service Bus premium:

- To ensure that messages are properly transferred to and accepted by the broker, message producers should use one of the supported Service Bus API clients. Supported APIs will only return successfully from a send operation if the message was persisted on the queue/topic.
- To ensure messages on the bus are processed, you should use [PeekLock receive mode](https://docs.microsoft.com/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock). This mode enables at-least once processing. The following outlines the process:
  - The message consumer receives the message to process.
  - The consumer is given an exclusive lock on the message for a given time duration.
  - If the consumer successfully processes the message, it sends an acknowledgement back to the broker, and the message is removed from the queue.
  - If an acknowledgement isn't received by the broker in the allotted time period, or the handler explicitly abandons the message, the exclusive lock is released. The message is then available for other consumers to process the message.
  - If a message is not successfully processed a configurable number of times, or the handler forwards the message to the dead-letter queue.
- Because messages can potentially be processed more than one time, message handlers should be made idempotent.
- To ensure that messages sent to the dead-letter queue are acted upon, the dead-letter queue should be monitored, and alerts should be set.
- The system should have tooling for operators to be able to inspect, correct and resubmit messages.

### High availability and disaster recovery

The message broker must be available for producers to send messages and consumers to receive them. The following are details regarding this requirement:

- To ensure the highest availability with Service Bus, use the premium tier, which has support for availability zones in supporting regions. With availability zones, messages and metadata are replicated across three disparate data centers in the same region.
- Use supported Service Bus or Event Hubs SDKs to automatically retry read or write failures.
- Consider [active-active replication](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-federation-overview#all-active-replication) or [active-passive replication](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-federation-overview#active-passive-replication) patterns to insulate against regional disasters.

> [!NOTE]
> Azure Service Bus Geo-disaster recovery only replicates metadata across regions. This feature does not replicate messages.

### Monitoring

The messaging system acts as a buffer between message producers and consumers. There are key indicator types that you should monitor in a mission-critical system that provide valuable insights described below:

- **Throttling** - Throttling indicates that the system does't have the required resources to process the request. Both Service Bus and Event Hubs support monitoring throttled requests. You should alert on this indicator.
- **Queue depth** - A queue depth that is growing can indicate that message processors aren't working or there aren't enough processors to handle the current load. Queue depth can be used to inform auto-scaling logic of handlers.
  - For Service Bus, queue depth is exposed as message count
  - For Event Hubs, the consumers have to calculate queue depth per partition and push the metric to your monitoring software. For each read, the consumer gets the sequence number of the current event, and the event properties of the last enqueued event. The consumer can calculate the offset.
- **Dead-letter queue** - Messages in the dead-letter queue represent messages that couldn't be processed. These messages usually require manual intervention. Alerts should be set on the dead-letter queue.
  - Service Bus has a [dead-letter queue](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-dead-letter-queues) and a DeadLetteredMessages metric.
  - For Event Hubs, this functionality must be custom logic built into the consumer.
- **CPU/Memory usage** - CPU and memory should be monitored to ensure the messaging system has enough resources to process the current load. Both Service Bus premium and Event Hubs premium expose CPU and memory Usage.
  - Messaging units (MUs) are used in Service Bus to isolate resources such as CPU and memory for a namespace. CPU and memory rising above a threshold can indicate that there aren't enough MUs configured, while falling below other thresholds can indicate that there are too many MUs configured. These indicators can be used to [auto-scale MUs](https://docs.microsoft.com/azure/service-bus-messaging/automate-update-messaging-units).
  - Event Hubs premium tier uses processing units (PUs) to isolate resources, while standard tier uses throughput units (TUs). Neither tier requires interaction with CPU/Memory to auto-inflate PUs or TUs.

### Health check

The health of the messaging system must be considered in the health checks for a mission critical application. Consider the following:

- The messaging system acts as a buffer between message producers and consumers. The stamp can be viewed as healthy if producers are able to successfully send messages to the broker.
- The health check should ensure that messages can be sent to the message system.

