---
title: Rate Limiting Pattern
description: Control the rate at which your application sends requests to a service so that you stay within the service's throttling limits and overall capacity.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/08/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted 
---

# Rate Limiting pattern

Control the rate at which your application sends requests to a service so that you stay within the service's [throttling](./throttling.md) limits and overall capacity. This approach helps you avoid or minimize throttling errors and more accurately predict throughput.

Rate limiting is appropriate in many scenarios, but it's particularly helpful for large-scale, repetitive automated tasks such as batch processing.

## Context and problem

Performing large numbers of operations against a throttled service can result in increased traffic and reduced throughput, because you need to track rejected requests and then retry the operations. As the number of operations increases, a throttling limit might require multiple passes of resending data, which results in a larger performance impact.

For example, consider the following problematic retry-on-error process for ingesting data into Azure Cosmos DB:

1. Your application needs to ingest 10,000 records into Azure Cosmos DB. Each record costs 10 request units (RUs) to ingest, so a total of 100,000 RUs is required to complete the job.

1. Your Azure Cosmos DB instance has 20,000 RUs provisioned capacity.
1. You send all 10,000 records to Azure Cosmos DB. 2,000 records are written successfully and 8,000 records are rejected.
1. You send the remaining 8,000 records to Azure Cosmos DB. 2,000 records are written successfully and 6,000 records are rejected.
1. You send the remaining 6,000 records to Azure Cosmos DB. 2,000 records are written successfully and 4,000 records are rejected.
1. You send the remaining 4,000 records to Azure Cosmos DB. 2,000 records are written successfully and 2,000 records are rejected.
1. You send the remaining 2,000 records to Azure Cosmos DB. All are written successfully.

The ingestion job completes successfully, but only after sending 30,000 records to Azure Cosmos DB. The entire data set consists of only 10,000 records.

There are other factors to consider in this example:

- Large numbers of errors can also result in extra work to log these errors and process the resulting log data. The preceding approach handles 20,000 errors, and logging these errors might impose a processing, memory, or storage resource cost.

- Because you don't know the throttling limits of the ingestion service, you don't have a way to set expectations for how long data processing takes. Rate limiting can allow you to calculate the time required for ingestion.

## Solution

Rate limiting can reduce your traffic and potentially improve throughput by reducing the number of records sent to a service over a given period of time.

A service can throttle requests based on different metrics over time, such as:

- The number of operations (for example, 20 requests per second).
- The amount of data (for example, 2 GiB per minute).
- The relative cost of operations (for example, 20,000 RUs per second).

Regardless of the metric that you use for throttling, your rate limiting implementation will involve controlling the number and/or size of operations sent to the service during a specific time period. Rate limiting optimizes your use of the service without exceeding its throttling capacity.

In scenarios where your APIs can handle requests faster than throttled ingestion services allow, you must manage how quickly you use the service. Treating throttling only as a data-rate mismatch and buffering ingestion requests until the service recovers creates risk. If your application stops responding in this scenario, any buffered data might be lost.

To avoid this risk, consider sending your records to a durable messaging system that *can* handle your full ingestion rate. (Services such as Azure Event Hubs can handle millions of operations per second.) You can then use one or more job processors to read the records from the messaging system at a controlled rate that's within the throttled service's limits. Submitting records to the messaging system can save internal memory by allowing you to dequeue only the records that can be processed during a given time interval.

Azure provides several durable messaging services that you can use with this pattern, including:

- [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview)
- [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction)
- [Event Hubs](/azure/event-hubs/event-hubs-about)

:::image type="complex" source="./_images/rate-limiting-pattern-01.png" border="false" lightbox="./_images/rate-limiting-pattern-01.png" alt-text="Diagram that shows a durable messaging flow. Three job processors call into a throttled service.":::
The flow starts with a user sending a batch of 10,000 messages through to an API component. The API forwards all messages to a durable messaging service component. From the durable messaging service, three separate flows lead to three job processor components. Each flow is labeled x100 / sec, which indicates that each job processor dequeues messages at a controlled rate of 100 per second. All three job processor components connect to a throttled service component. The throttled service labeled "throttled at 300 records per second," which equals the combined output of the three processors.
:::image-end:::

When you send records, the time period that you use for releasing records might be more granular than the period that the service throttles on. Systems often set throttles based on timespans that you can easily comprehend and work with. However, for the computer running a service, these timeframes might be very long compared to how fast it can process information. For instance, a system might throttle per second or per minute, but commonly the code is processing on the order of nanoseconds or milliseconds.

Although it's not required, it's often recommended to send smaller numbers of records more frequently to improve throughput. So, rather than trying to batch records for a release once per second or once per minute, you can be more granular than that to keep your resource consumption (memory, CPU, and network) flowing at a more even rate. This approach prevents potential bottlenecks caused by sudden bursts of requests. For example, if a service allows 100 operations per second, the implementation of a rate limiter might even out requests by releasing 20 operations every 200 milliseconds, as shown in the following graph.

:::image type="complex" source="./_images/rate-limiting-pattern-02.png" border="false" lightbox="./_images/rate-limiting-pattern-02.png" alt-text="Chart that shows a rate-limited flow over time.":::
The chart is titled Rate Limited Flow. It plots the number of operations on the y-axis from 0 to 25 against a timestamp on the x-axis from 0.0 to 4.0. From timestamp 0.0 to 0.2, the number of operations is 0, which indicates that no operations are sent. Between 0.2 and 0.4, the line rises steeply to 20, which represents the rate limiter reaching its configured ceiling. At timestamp 3.0, the line drops sharply back to 0, which indicates that the work is complete or that the rate limiter stopped releasing records. From 3.2 through 3.8, the value remains at 0. The flat plateau between 0.4 and 3.0 is the key feature of the chart. It shows that rate limiting produces a consistent, predictable throughput rather than the bursts and drops that are associated with a problematic retry-on-error approach.
:::image-end:::

In addition, it's sometimes necessary for multiple uncoordinated processes to share a throttled service. To implement rate limiting in this scenario, you can logically partition the service's capacity and then use a distributed mutual exclusion system to manage exclusive locks on those partitions. The uncoordinated processes can then compete for locks on those partitions whenever they need capacity. For each partition that a process holds a lock for, it's granted a certain amount of capacity.

For example, if the throttled system allows 500 requests per second, you might create 20 partitions worth 25 requests per second each. If a process needed to issue 100 requests, it might ask the distributed mutual exclusion system for four partitions. The system might grant two partitions for 10 seconds. The process would then rate limit to 50 requests per second, complete the task in two seconds, and then release the lock.

One way to implement this pattern is to use Azure Storage. In this scenario, you create one 0-byte blob per logical partition in a container. Your applications can then obtain [exclusive leases](/rest/api/storageservices/lease-blob) directly against those blobs for a short period of time (for example, 15 seconds). For every lease an application is granted, it can use that partition's amount of capacity. The application then needs to track the lease time so that, when the time expires, the application can stop using the capacity that it was granted. When you implement this pattern, you'll often want each process to attempt to lease a random partition when it needs capacity.

To further reduce latency, you might allocate a small amount of exclusive capacity for each process. A process would then only seek to obtain a lease on shared capacity if it needed to exceed its reserved capacity.

:::image type="complex" source="./_images/rate-limiting-pattern-03.png" border="false" lightbox="./_images/rate-limiting-pattern-03.png" alt-text="Diagram that shows multiple processes competing for exclusive leases on blob partitions in Azure Blob Storage.":::
The diagram shows four processes competing for exclusive leases on six numbered blob partitions that are stored in Blob Storage. The four processes are labeled A, B, C, and D. Blob Storage contains six blob partitions numbered 0 through 5. From process A, a green arrow points to partition 0, indicating a successful lease acquisition. A red arrow points from process A to partition 1, indicating a failed lease attempt, because another process already holds that partition. From process D, one green arrow points to partition 1, indicating that process D holds the lease on that partition. That's why process A's attempt on partition 1 failed. A second green arrow points from process D to partition 4, indicating a second lease held by process D. No arrows are associated with processes B and C because they don't hold leases. Partitions 2, 3, and 5 are also unleased.
:::image-end:::

As an alternative to Azure Storage, you could also implement this kind of lease management system by using technologies such as [ZooKeeper](https://zookeeper.apache.org), [etcd](https://etcd.io), and [Redis/Redsync](https://github.com/go-redsync/redsync).

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Although the Rate Limiting pattern can reduce the number of throttling errors, your application still needs to properly handle any throttling errors that might occur.

- Ensure that retries are coordinated with rate limiting. Blind or overly aggressive retries can increase load and create retry storms, so propagate back-pressure signals (for example, HTTP 429 with `Retry-After`) and use a limited number of retries with small random delays between attempts.
- If your application has multiple workstreams that access the same throttled service, you need to integrate all of them into your rate limiting strategy. For instance, you might support bulk loading records into a database but also querying for records in that same database. You can manage capacity by ensuring that all workstreams are gated through the same rate limiting mechanism. Alternatively, you might reserve separate pools of capacity for each workstream.
- The throttled service might be used in multiple applications. In some cases, it's possible to coordinate that usage (as shown earlier in this article). If you start to see a larger than expected number of throttling errors, that increased number might indicate contention between applications accessing a service. In this case, you might need to consider temporarily reducing the throughput imposed by your rate limiting mechanism until the usage from other applications decreases.

## When to use this pattern

Use this pattern when:

- You need to reduce throttling errors raised by a rate-limited service.

- You want to minimize traffic, as compared to naive retry-on-error approaches.
- You need to reduce memory consumption by dequeuing records only when there's sufficient capacity to process them.

This pattern might not be suitable when:

- The operation requires immediate, synchronous completion with very low latency and can't tolerate queuing or deferred processing.

- The primary bottleneck isn't request rate, but instead is concurrency or resource contention (for example, CPU saturation or long-running in-flight work). In these cases, scaling or concurrency controls are more appropriate.

## Workload design

Evaluate how to use the Rate Limiting pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This tactic protects the client by acknowledging and honoring the limitations and costs of communicating with a service when the service prefers to avoid excessive usage.<br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following example application allows users to submit records of various types to an API. Each record type has a unique job processor that performs the following steps:

1. Validation
1. Enrichment
1. Insertion of the record into the database

All components of the application (API, job processor A, and job processor B) are separate processes that can be scaled independently. The processes don't directly communicate with one another.

:::image type="complex" source="./_images/rate-limiting-pattern-04.png" border="false" lightbox="./_images/rate-limiting-pattern-04.png" alt-text="Diagram that shows a multi-queue, multi-processor flow with partitioned lease storage writing to a throttled database.":::
The diagram shows two users submitting records via a shared API. Each record type is routed to a separate queue, processed by a dedicated job processor, and written to a throttled database at a controlled rate that's governed by blob partition leases in Azure Storage. The two users each send a batch of messages to the API component. One user submits 10,000 messages and the other submits 5,000 messages. The API routes the 10,000 messages to queue A and the 5,000 messages to queue B. Queue A connects to job processor A, and queue B connects to job processor B. Job processor A writes to the database at a rate of 300 records per second. Job processor B writes to the database at 500 records per second. Both job processors connect to a database component that's labeled "throttled at 800 records per second." Below the two job processors, Azure Storage contains eight blob partitions labeled 0 through 7. A note indicates that each partition is worth 100 records per second. Multiple arrows connect the job processors to the blob partitions. Green arrows point from job processor A to partitions 0, 4, and 6, which indicates that the processor holds leases on those three partitions. These leases account for its 300 records-per-second rate. Green arrows point from job processor B to partitions 1, 2, 3, 5, and 7. These arrows indicate that this processor holds leases on five partitions. These leases account for its 500 records-per-second rate. Failed lease attempts are shown as red arrows that cross over to partitions that are already held by the other processor. These arrows represent contention resolution. The diagram shows that the sum of all held partitions across both processors equals 800 records per second, which matches the database throttle limit.
:::image-end:::

In this example, each blob lease represents a fixed share of allowed database throughput. A processor can only dequeue and write at the combined rate of the leases that it currently holds. As processors gain or lose leases over time, their allowed write rate changes, which keeps total database traffic within the configured limit while still letting all queued work progress.

This diagram incorporates the following workflow:

1. A user submits 10,000 records of type A to the API.
1. The API enqueues those 10,000 records in queue A.
1. A user submits 5,000 records of type B to the API.
1. The API enqueues those 5,000 records in queue B.
1. Job processor A sees that queue A has records and attempts to gain an exclusive lease on blob 2.
1. Job processor B sees that queue B has records and attempts to gain an exclusive lease on blob 2.
1. Job processor A fails to obtain the lease.
1. Job processor B obtains the lease on blob 2 for 15 seconds. It can now rate limit requests to the database at a rate of 100 per second.
1. Job processor B dequeues 100 records from queue B and writes them.
1. One second passes.
1. Job processor A sees that queue A has more records and tries to gain an exclusive lease on blob 6.
1. Job processor B sees that queue B has more records and tries to gain an exclusive lease on blob 3.
1. Job processor A obtains the lease on blob 6 for 15 seconds. It can now rate limit requests to the database at a rate of 100 per second.
1. Job processor B obtains the lease on blob 3 for 15 seconds. It can now rate limit requests to the database at a rate of 200 per second. (It also holds the lease for blob 2.)
1. Job processor A dequeues 100 records from queue A and writes them.
1. Job processor B dequeues 200 records from queue B and writes them.
1. One second passes.
1. Job processor A sees that queue A has more records and tries to gain an exclusive lease on blob 0.
1. Job processor B sees that queue B has more records and tries to gain an exclusive lease on blob 1.
1. Job processor A obtains the lease on blob 0 for 15 seconds. It can now rate limit requests to the database at a rate of 200 per second. (It also holds the lease for blob 6.)
1. Job processor B obtains the lease on blob 1 for 15 seconds. It can now rate limit requests to the database at a rate of 300 per second. (It also holds the lease for blobs 2 and 3.)
1. Job processor A dequeues 200 records from queue A and writes them.
1. Job processor B dequeues 300 records from queue B and writes them.
1. And so on.

After 15 seconds, one or both jobs still won't be completed. As the leases expire, a processor should also reduce the number of requests that it dequeues and writes.

![GitHub logo](../_images/github.png) Implementations of this pattern are available in different programming languages:

- **Go** implementation is available on [GitHub](https://github.com/Azure-Samples/go-batcher).
- **Java** implementation is available on [GitHub](https://github.com/Azure-Samples/java-rate-limiting-pattern-sample).

## Next steps

The following guidance might also be relevant when you implement this pattern:

- [Advanced request throttling with Azure API Management](/azure/api-management/api-management-sample-flexible-throttling). Use this as complementary edge admission control to enforce per-key call-rate limits and quotas, and to return consistent back-pressure signals to clients.

- [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services). Select the best durable messaging backbone for buffering and controlled ingestion.
- [Handle transient faults in Azure applications](/azure/well-architected/design-guides/handle-transient-faults). Design retry behavior so that clients back off correctly when limits are reached.

## Related resources

The following patterns and guidance might also be relevant when you implement this pattern:

- [Throttling](./throttling.md). The Rate Limiting pattern is typically implemented in response to a throttled service.
- [Retry](./retry.yml). When requests to a throttled service result in throttling errors, it's generally appropriate to retry those requests after an appropriate interval.
- [Queue-Based Load Leveling](./queue-based-load-leveling.md) is similar to the Rate Limiting pattern but differs in several key ways:

  - Rate limiting doesn't necessarily need to use queues to manage load, but it does need to make use of a durable messaging service. For example, a Rate Limiting pattern can use services like Apache Kafka or Event Hubs.

  - The Rate Limiting pattern introduces the concept of a distributed mutual exclusion system on partitions, which allows you to manage capacity for multiple uncoordinated processes that communicate with the same throttled service.
  - A Queue-Based Load Leveling pattern is applicable whenever there's a performance mismatch between services or you want to improve resilience. So it's a broader pattern than Rate Limiting, which is more specifically concerned with efficiently accessing a throttled service.
