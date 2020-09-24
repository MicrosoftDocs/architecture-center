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

- [Azure ExpressRoute][Azure ExpressRoute] extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to Microsoft cloud services like [Microsoft Azure][What is Azure] and [Microsoft 365][What is Microsoft 365].


### Determine the Number of Partitions

Many factors influence the ideal number of partitions that an implementation should use:

- The degree of parallelism in a solution depends on the number of partitions that consumers can read from at the same time. Each consumer reads from its assigned partition. As a result, with more partitions, more consumers can receive events from a topic at the same time. More partitions therefore achieve more throughput.
- Consumers can consume messages from an ingestion pipeline at a high rate only if producers send messages at a comparable rate. It's therefore important to measure the producer's throughput, and not just the consumer's. The producer's throughput determines the total required capacity of the ingestion pipeline.
- Ideally, the number of partitions is at least as much as the desired throughput in megabytes.
- The slowest consumer determines the consumption throughput. However, sometimes no information is available about the downstream consumer applications. In this case, the following test can estimate the throughput:

  - Start with 1 partition as a baseline. (Use this recommendation only in testing environments, not in production systems).
  - Event Hubs with Standard Tier pricing and one partition should produce a throughput between 1MB to 20MB.

- Usually, the number of partitions shouldn't be less than the number of consumers. Otherwise, starving of consumers results. For instance, suppose 8 partitions are assigned to 8 consumers. Any additional consumers that start subscribing will have to wait. However, another strategy involves having one or two consumers ready to pick up when an existing consumer fails. In this case, the consumers need to ensure that they pick up messages from the right offset.

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

Another aspect of the Event Hubs and Kafka architectures involves partition assignment. Messages/events have two parts:

Three ways to distribute events to partitions:

## Considerations

### Drawbacks

### Other considerations

### Partition rebalancing

## Deploy this scenario

## Next steps


## Related resources


