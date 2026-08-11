---
title: Azure Event Hubs with Azure Functions
description: Learn how to architect, develop, and deploy efficient and scalable code that runs on Azure Functions and responds to Event Hubs events.
author: dbarkol
ms.author: dabarkol
ms.date: 04/22/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Integrate Event Hubs with serverless functions on Azure

Solutions that use Azure Event Hubs together with Azure Functions benefit from a [serverless](https://azure.microsoft.com/solutions/serverless/) architecture that's scalable, cost-effective, and capable of processing large volumes of data in near real time. Although these services are commonly used together, there are many features, settings, and intricacies that add complexity to their relationship. This article provides guidance on how to effectively take advantage of this integration by highlighting key considerations and techniques for performance, resiliency, security, observability, and scale.

## Event Hubs core concepts

[Event Hubs](https://azure.microsoft.com/products/event-hubs/) is a highly scalable event processing service that can receive millions of events per second. Before you explore the patterns and best practices for Azure Functions integration, it's best to understand the fundamental components of Event Hubs.

The following diagram shows the Event Hubs stream processing architecture.

:::image type="complex" source="./images/event-hubs-architecture.svg" border="false" lightbox="./images/event-hubs-architecture.svg" alt-text="Diagram that shows the Event Hubs stream processing architecture.":::
    The diagram flow starts with the event producers. Three protocol labels, HTTPS, AMQP, and Kafka, appear to the right of the producers, indicating the supported ingress protocols. A single arrow points from the producers through these protocols into the central component, a large box labeled Azure Event Hubs. Inside the Azure Event Hubs box, there are four partitions. To the right of the Azure Event Hubs box, there are two consumer groups arranged vertically. To the right of the consumer groups, there are eight event receivers. Solid arrows point from the top four event receivers through consumer group 1 and then to all four partitions. Dashed arrows point from the bottom four event receivers through consumer group 2 and then to all four partitions.
:::image-end:::

*Apache® and Apache Kafka® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

### Events

An event is a notification or state change that's represented as a fact that happened in the past. Events are immutable and persisted in an **event hub**, also referred to as a *topic* in [Kafka](https://kafka.apache.org/). An event hub is comprised of one or more [partitions](/azure/event-hubs/event-hubs-features#partitions).

### Partitions

When the sender doesn't specify a partition, received events are distributed across partitions in the event hub. Each event is written to exactly one partition and isn't multicast across partitions. Each partition works as a log where records are written in an append-only pattern. The analogy of a *commit log* is frequently used to describe how events are added to the end of a sequence in a partition.

:::image type="complex" source="./images/event-hubs-partition-writes.svg" border="false" lightbox="./images/event-hubs-partition-writes.svg" alt-text="Diagram that shows how incoming writes are distributed across multiple partitions in an event hub.":::
    Diagram that shows how incoming writes are distributed across multiple partitions in an event hub. On the left is a large box that contains three partitions. Each partition is a horizontal row of solid vertical bar icons that represent stored events, followed by a single dashed-outline rectangle at the right end of the row that indicates the next available position for an incoming event. On the right side of the diagram, the label "writes" points to all three partitions, which illustrates that incoming writes are distributed across all partitions. At the bottom of the diagram, a horizontal arrow spans the width of the partitions box and is labeled "old" on the left and "new" on the right, which indicates that events within each partition are ordered chronologically from left to right, with the oldest events on the left.
:::image-end:::

When you use more than one partition, parallel logs can be used from within the same event hub. This design provides multiple degrees of parallelism and enhances throughput for consumers.

### Consumers and consumer groups

A partition can be consumed by more than one consumer, each reading from and managing their own offsets.

:::image source="./images/event-hubs-partition-consumers.svg" type="content" border="false" lightbox="./images/event-hubs-partition-consumers.svg" alt-text="Diagram that shows a single partition being read independently by two consumers while a producer writes to it.":::

You can use Event Hubs [consumer groups](/azure/event-hubs/event-hubs-features#consumer-groups) to enable multiple consuming applications to each have a separate view of the event stream and read the stream independently at their own pace and with their own offsets.

For more information, see [Event Hubs features and terminology](/azure/event-hubs/event-hubs-features).

## Consuming events with Azure Functions

Azure Functions supports [trigger](/azure/azure-functions/functions-bindings-event-hubs-trigger) and [output](/azure/azure-functions/functions-bindings-event-hubs-output) bindings for Event Hubs. This section describes how Azure Functions uses trigger bindings to respond to events sent to an event hub event stream.

Each instance of an Event Hubs triggered function uses a single `EventProcessorHost` instance. The trigger (powered by Event Hubs) ensures that only one `EventProcessorHost` instance can get a lease on a given partition.

For example, consider an event hub that has 10 partitions and 1,000 events distributed across all partitions, with a varying number of messages in each partition.

When your function is first enabled, there's only one instance of the function. The first function instance is called `Function_1`. `Function_1` has a single instance of `EventProcessorHost` that holds a lease on all 10 partitions. This instance reads events from partitions 1 through 10. From this point, one of the following scenarios applies:

- **New function instances aren't needed.** `Function_1` can process all 1,000 events before the Functions scaling logic takes effect. In this case, all 1,000 messages are processed by `Function_1`.

    :::image type="complex" source="./images/event-hubs-functions.svg" border="false" lightbox="./images/event-hubs-functions.svg" alt-text="Diagram that shows a single Azure Functions instance holding leases on all 10 partitions of an event hub.":::
        The diagram flow starts with the event producers. Three protocol labels, HTTPS, AMQP, and Kafka, appear to the right of the producers, indicating the supported ingress protocols. A single arrow points from the producers through these protocols into the central component, a large box labeled Azure Event Hubs. Inside the Azure Event Hubs box, there are 10 partitions. To the right of the Azure Event Hubs box is a narrow vertical box that represents a consumer group. To the right of this group is a rectangle labeled function app. The rectangle contains 10 leases. Function_1 is shown to the right of the rectangle. Arrows point from each of the 10 partitions and combine into one arrow that crosses through the consumer group box and then points to the function app. The diagram illustrates that the single function instance Function_1 holds leases on all 10 partitions and is responsible for processing events from every partition.
    :::image-end:::

- **An additional function instance is added.** Event-based scaling or other automated or manual logic might determine that `Function_1` has more messages than it can process and then create a new function app instance (`Function_2`). This new function also has an associated instance of `EventProcessorHost`. As the underlying event hub detects that a new host instance is trying to read messages, it load balances the partitions across the host instances. For example, partitions 1 through 5 might be assigned to `Function_1` and partitions 6 through 10 to `Function_2`.

    :::image type="complex" source="./images/event-hubs-functions-two-instances.svg" border="false" lightbox="./images/event-hubs-functions-two-instances.svg" alt-text="Diagram that shows two Azure Functions instances splitting partition leases across an event hub that has 10 partitions.":::
        Diagram that shows two Azure Functions instances splitting partition leases across an event hub that has 10 partitions. The diagram flow starts with the event producers. Three protocol labels, HTTPS, AMQP, and Kafka, appear to the right of the producers, indicating the supported ingress protocols. A single arrow points from the producers through these protocols into the central component, a large box labeled Azure Event Hubs. Inside the Azure Event Hubs box, there are 10 partitions. To the right of the Azure Event Hubs box is a narrow vertical box that represents a consumer group. To the right of this group, two separate rectangles that represent Azure functions are stacked vertically. The top rectangle, labeled Function_1, contains leases 1 through 5. The bottom rectangle, labeled Function_2, contains leases 6 through 10. Arrows point from each of the first 5 partitions and combine into one arrow that crosses through the consumer group box and then points to Function_1. Arrows point from each of the second 5 partitions and combine into one arrow that crosses through the consumer group box and then points to Function_2. The diagram illustrates that Event Hubs balances the partition leases between the two function instances. Function_1 is responsible for partitions 1 through 5, and Function_2 is responsible for partitions 6 through 10.
    :::image-end:::

- ***N* more function instances are added.** Event-based scaling or other automated or manual logic might determine that both `Function_1` and `Function_2` have more messages than they can process and create new `Function_*N*` function app instances. Instances are created to the point where *N* is equal to or greater than the number of event hub partitions. In this example, Event Hubs again load balances the partitions, in this case across the instances `Function_1` through `Function_10`.

    :::image type="complex" source="./images/event-hubs-functions-n-instances.svg" border="false" lightbox="./images/event-hubs-functions-n-instances.svg" alt-text="Diagram that shows 10 Azure Functions instances splitting partition leases across an event hub that has 10 partitions.":::
        Diagram that shows 10 Azure Functions instances splitting partition leases across an event hub that has 10 partitions. The diagram flow starts with the event producers. Three protocol labels, HTTPS, AMQP, and Kafka, appear to the right of the producers, indicating the supported ingress protocols. A single arrow points from the producers through these protocols into the central component, a large box labeled Azure Event Hubs. Inside the Azure Event Hubs box, there are 10 partitions. To the right of the Azure Event Hubs box is a vertical box that represents a consumer group. To the right of this group, 11 separate rectangles that represent Azure functions are stacked vertically. Ten of these rectangles are labeled "lease 1" through "lease 10." The last one is labeled "ready for lease." Each of these rectangles is associated with a function, labeled Function_1 through Function_N. Arrows point from each of partition to the function with the corresponding number. For example, partition 1 points to Function_1.
    :::image-end:::

As scaling occurs, *N* instances can be a number greater than the number of event hub partitions. This situation might occur while event-driven scaling stabilizes instance counts, or because other automated or manual logic created more instances than partitions. In this case, `EventProcessorHost` instances only obtain locks on partitions as they become available from other instances, because at any given time only one function instance from the same consumer group can access or read from the partitions it has locks on.

When all function execution completes (with or without errors), checkpoints are committed to the associated storage account. When checkpointing succeeds, the function is ready to process a new batch of events.

Dynamic, event-based scaling is possible with Consumption, Flex Consumption, and Premium Azure plans. Kubernetes-hosted function apps can also take advantage of the [KEDA scaler for Event Hubs](https://keda.sh/docs/2.20/scalers/azure-event-hub/). Event-based scaling currently isn't possible when the function app is hosted in a Dedicated (App Service) plan, which requires you to determine the right number of instances based on your workload.

To learn more, see [Azure Event Hubs bindings for Azure Functions](/azure/azure-functions/functions-bindings-event-hubs) and [Azure Event Hubs trigger for Azure Functions](/azure/azure-functions/functions-bindings-event-hubs-trigger).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

 - [David Barkol](https://www.linkedin.com/in/davidbarkol/) | AI Apps GBB

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

> [!div class="nextstepaction"]
> [Performance and scale](./performance-scale.md)
