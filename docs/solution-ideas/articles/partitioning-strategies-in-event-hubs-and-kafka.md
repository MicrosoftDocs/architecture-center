---
title: Partitioning Strategies in Event Hubs and Kafka
titleSuffix: Azure Solution Ideas
author: JKirsch1
ms.date: 09/24/2020
description: Find out how to migrate IBM zSeries mainframe applications to Azure. Learn how to use TmaxSoft OpenFrame for this task. Understand the lift and shift approach.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - mainframe
  - migration
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/media/migrate-mainframe-application-to-azure.png
---

# Partitioning Strategies in Event Hubs and Kafka

[intro]

## Potential use cases

Many scenarios can benefit from TmaxSoft OpenFrame lift and shift. Possibilities include the following cases:

- use case 1

## Architecture

:::image type="complex" source="../media/event-processing-service.png" alt-text="Architecture diagram showing a lift and shift implementation that migrates IBM zSeries mainframes to Azure." border="false":::
   At the center of the diagram are two virtual machines. Labeled boxes indicate that OpenFrame software runs on the machines, and each box represents a different type of software. These programs migrate applications to Azure and handle transaction processes. They also manage batch programs and provide security. A load balancer is pictured above the virtual machines. Arrows show that it distributes incoming traffic between the machines. Below the virtual machines, a file sharing system is pictured, and to the right is a database. From arrows, it's clear that the virtual machines communicate with the file share and the database. A dotted line surrounds all these components. Outside that line are on-premises users, Azure users, and disaster recovery services. Arrows show the users interacting with the system.
:::image-end:::

- add numbers to diagram: (but how to avoid repeating component defs here. maybe keep them brief and give more thorough defn in Components)
1. Producers generate events/messages. Maybe mention buffering. Maybe mentino auth in EH.
2. what happens in brokers/EH: messages go to partitions. Or do producers send directly to partitions? messages kept until expire. See steps in Amy Boyle's article: processing, etc. Also mention topic/event hub and cluster/namespace.
3. Consumers subscribe. divided into consumer groups. mention auth.
4. messages delivered.



### Components

- Topic: A named stream of messages in Kafka. Event Hubs calls these logical entities *event hubs*.
- Cluster: A unique scoping container that holds one or more Kafka topics.
- Namespace: The Event Hubs equivalent of a cluster. Each namespace can hold event hubs.
- Partition: Topics are further split into one or more Partitions. The messages sent to a topic are distributed across the different partitions in either a round-robin fashion, by sending to a specific partition or by using a key to process a hash to determine the destination partition Messages are stored in order within a partition but across partitions they are not in sequence.


### Determine the Number of Partitions

Deciding how many partitions to use is a complex process. Many factors influence that decision:

- A solution's degree of parallelism depends on the number of partitions that are available. Each consumer reads from its assigned partition. As a result, with more partitions, more consumers can receive events from a topic at the same time. More partitions therefore achieve more throughput.
- Consumers can consume messages from an ingestion pipeline at a high rate only if producers send messages at a comparable rate. It's therefore important to measure the producer's throughput, and not just the consumer's. The producer's throughput determines the total required capacity of the ingestion pipeline.
- Ideally, the number of partitions is at least as much as the desired throughput in megabytes.
- The slowest consumer determines the consumption throughput. However, sometimes no information is available about the downstream consumer applications. In this case, the following test can provide an estimate of the throughput:

  - Start with 1 partition as a baseline. (Use this recommendation only in testing environments, not in production systems).
  - Event Hubs with Standard Tier pricing and one partition should produce a throughput between 1MB to 20MB.

- Usually, the number of partitions shouldn't be less than the number of consumers. Otherwise, starving of consumers results. For instance, suppose 8 partitions are assigned to 8 consumers. Any additional consumers that start subscribing will have to wait. However, another strategy involves having one or two consumers ready to receive events when an existing consumer fails. In this case, the consumers need to ensure that they pick up messages from the right offset.

A rough formula exists for determining the number of partitions. It uses the following throughput values:

- p: The production throughput on a single partition.
- c: The consumption throughput on a single partition.
- t: The target throughput.
  
To achieve the target throughput, the formula calculates the number of partitions that are required in this way:  

`max(t/p,t/c)`  

For example, consider the following situation:

- A producer sends events at a rate of 1k messages / second. For the formula, p is equal to 1MB.
- A consumer receives events at a rate of 500 messages / second. As a result, c gets the value 0.5MB.
- The desired throughput is 2 MB per second, making t 2MB/sec.

With these values, the number of partitions is 4:

`max(t/p,t/c)=max(2/1,2/0.5)=max(2,4)=4`






### Distribute Messages to Partitions

Another aspect of the Event Hubs and Kafka architectures involves partitioning strategy. When an event processing service receives an event, the partitioning strategy determines which partition the service sends the event to.

Each event stores the body of its message in its value. Besides the value, each event also contains a key, as the following diagram shows:

:::image type="complex" source="../media/kafka-message-parts.png" alt-text="Architecture diagram showing a lift and shift implementation that migrates IBM zSeries mainframes to Azure." border="false":::
   At the center of the diagram are two virtual machines. Labeled boxes indicate that OpenFrame software runs on the machines, and each box represents a different type of software. These programs migrate applications to Azure and handle transaction processes. They also manage batch programs and provide security. A load balancer is pictured above the virtual machines. Arrows show that it distributes incoming traffic between the machines. Below the virtual machines, a file sharing system is pictured, and to the right is a database. From arrows, it's clear that the virtual machines communicate with the file share and the database. A dotted line surrounds all these components. Outside that line are on-premises users, Azure users, and disaster recovery services. Arrows show the users interacting with the system.
:::image-end:::

The key contains data about the message and can also play a role in the partitioning strategy. Multiple approaches exist for determining how to partition events:

- By default, the service distributes events among partitions in a round-robin fashion.
- Producers can specify a partition id with an event. The event then goes to the partition with that id. This approach is useful when consumers are only interested in certain messages. When those messages flow to a single partition, the consumer can easily receive them by subscribing to that partition.
- Producers can provide a value for the event key. A hashing-based partitioner then determines a hash value from the key and sends the event to the partition associated with that hash value. All messages with the same key always arrive at the same partition.

The following factors influence the choice of strategy:

- Keys are useful when consumers need to receive messages in the production order. Since all messages with the same key go to the same partition, messages with key values can maintain their order during processing. Consumers then receive them in that order.
- If message grouping or ordering is not required, it's best to avoid the hashing-based partitioning strategy. With Apache Kafka, the producer does not know the status of the destination partition. If a key routes an event to a partition that is down, delays or lost messages can result. In Azure Event Hubs, events with keys first pass through a gateway before proceeding to a partition. This approach handles incoming traffic in a more reliable way since it prevents events from going to unavailable partitions.
- The shape of the data can influence the partitioning approach. Considering how the downstream architecture will distribute the data can also affect the decision.
- If consumers aggregate data on a certain attribute, it makes sense to partition on that attribute, too.
- When storage efficiency is a concern, partitioning on an attribute that concentrates the data can help to speed up storage operations.
- Ingestion pipelines sometimes shard data to get around problems with resource bottlenecks. In these environments, it's efficient to align the partitioning with how the shards are split in the database.

### Partition rebalancing

Each consumer reads event data from at least one partition of a topic. Whenever consumers join or leave a particular topic, the pipeline rebalances the partitions. Apache Kafka uses one of the following strategies when assigning partitions to consumers: 
  
- Round robin: By default, Kafka and Event Hubs use this assignment strategy. This approach distributes all partitions evenly across all members.
- Range assignor: This strategy brings together partitions from different topics. It identifies topics that use the same number of partitions and the same key-partitioning logic. Then it joins partitions from those topics when making assignments to consumers.
- Sticky assignor: This assignment is similar to round-robin in that it ensure a uniform distribution. However, it minimizes partition movement during rebalancing.
- Static assignment: With this approach, the pipeline assigns specific partitions to specific consumers statically by using partition ids. The assignments do not trigger partition rebalances. The user is responsible for making sure that all partitions have subscribers.

## Considerations

Keep in mind the points in the following sections when determining a partitioning strategy and the number of partitions to use.

### Drawbacks of high partition count

There are several disadvantages of using a large number of partitions:

- In Apache Kafka, brokers store event data and offsets in files. If you use numerous partitions, you'll also have a large number of open file handles. The underlying operating system may limit the number of open files. If you're in danger of exceeding that limit, you'll need to reconfigure that setting.
- In Azure Event Hubs, users don't face file system limitations. However, each partition manages its own Azure blob files and optimizes them in the background. With a large number of partitions, it can be expensive to maintain offset information, or *checkpoint* data. The reason is that I/O operations can be time-consuming, and the storage API calls are proportional to the number of partitions.
- Apache Kafka generally positions partitions on different brokers. When a broker fails, Kafka rebalances the partitions to avoid losing messages. The more partitions there are to rebalance, the longer the failover takes, increasing unavailability. It's best to limit the number of partitions to the low thousands.
- With more partitions, the load balancing process has to work with more moving parts and more stress. Transient exceptions can result, especially during an upgrade or load balancing, when Event Hubs sometimes moves partitions to different nodes. Clients should handle transient behavior by incorporating retries to minimize failures. The EventProcessorClient in .NET and Java SDKs or the EventHubConsumerClient in Python and JavaScript SDKs can simplify this process.
- Overall, using more partitions means that more physical resources are in operation. Depending on the client response, more failures can occur as a result.
- In Apache Kafka, events are *committed* after the pipeline has replicated them across all in-sync replicas. This approach ensures the high availability of messages. Since consumers only receive committed messages, the replication process adds to the latency, or the time between when a producer publishes a message and when a consumer reads it. According to experiments that Confluent ran, replicating 1000 partitions from one broker to another can take about 20 milliseconds. The end-to-end latency is then at least 20 milliseconds. When the number of partitions increases further, the latency also grows. This drawback doesn't apply to Event Hubs.
- Each producer for Kafka and Event Hubs stores events in a buffer until a sizeable batch is available or until a specific amount of time passes. Then the producer sends the messages to the ingestion pipeline. The producer maintains a buffer for each partition. When the number of partitions increases, the memory requirement of the client also expands. If consumers receive messages in batches, they may also face the same issue. The situation can become problematic when consumers subscribe to a large number of partitions and have limited memory available for buffering.

### Additional considerations

Keep these points also in mind when implementing this architecture:

- You should use more distinct keys than partitions. Otherwise, some partitions won't receive any messages, leading to unbalanced partition loads.
- In both Apache Kafka and Azure Event Hubs at the Dedicated Tier level, you can change the number of partitions in an operating system. However, if you need to preserve message ordering or use key hashing, try to avoid changing the number of partitions. The reason involves the following facts:
  - The pipeline maps an event to a partition based on the hash of the key.
  - Messages with the same key always go to the same partition. Customers therefore rely on certain partitions and the order of the messages they contain.
  - When the number of partitions changes, the mapping can change. For instance, consider the following formula:  
    `partition assignment = hash key % number of partitions`  
    With this formula, the partition assignment can change when the number of partitions changes.
  - Neither Kafka nor Event Hubs attempts to redistribute events that arrived at partitions before the shuffle. As a result, the guarantee no longer holds that events arrive at a certain partition in publication order.

## Deploy this scenario

## Next steps


## Related resources


