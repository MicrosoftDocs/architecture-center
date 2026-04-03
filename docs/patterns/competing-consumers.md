---
title: Competing Consumers Pattern
description: Learn how the Competing Consumers pattern supports multiple concurrent consumers processing messages received on the same messaging channel.
author: claytonsiemens77
ms.author: pnp
ms.date: 04/02/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Competing Consumers pattern

Enable multiple concurrent consumers to process messages received on the same messaging channel. With multiple concurrent consumers, a system can process multiple messages at the same time to optimize throughput, improve scalability and availability, and balance the workload.

## Context and problem

A cloud application often handles a large number of requests. Instead of processing each request synchronously, the application can pass requests through a messaging system to a consumer service that handles them asynchronously. This strategy helps prevent request processing from blocking application business logic.

The number of requests can vary significantly over time. A sudden increase in user activity or aggregated requests from multiple tenants can create an unpredictable workload. At peak hours, a system might need to process many hundreds of requests per second. At other times, the number might be small. Also, the work required to handle these requests might vary widely. If you use a single consumer service instance, requests can overwhelm that instance. Or an influx of application messages can overload the messaging system.

To handle this fluctuating workload, the system can run multiple consumer service instances. However, the system must coordinate these consumers to ensure that each message is delivered to only one consumer. The system must also balance the workload across consumers to prevent one instance from becoming a bottleneck.

## Solution

Use a message queue to implement the communication channel between the application and the consumer service instances. The application posts requests as messages to the queue, and consumer service instances receive and process messages from the queue. This approach lets the same pool of consumer service instances handle messages from any instance of the application. The following diagram shows how a message queue distributes work to service instances.

:::image type="complex" border="false" source="./_images/competing-consumers-diagram.png" alt-text="Diagram that shows how a message queue distributes work to service instances." lightbox="./_images/competing-consumers-diagram.png":::
   The diagram has three key sections. On the left, arrows point from application instances to the message queue in the center. On the right, arrows point from the message queue to the consumer service instance pool, which processes the messages.
:::image-end:::

> [!NOTE]
> Multiple consumers receive these messages, but the Competing Consumers pattern differs from the [Publisher-Subscriber pattern](publisher-subscriber.md). In the Competing Consumers pattern, one consumer receives each message for processing. In the Publisher-Subscriber pattern, **all** consumers receive **every** message.

This solution has the following benefits:

- It provides a load-leveled system that can handle wide variations in request volume from application instances. The queue functions as a buffer between application instances and consumer service instances. This buffer can minimize the effect on availability and responsiveness for both the application and service instances. For more information, see [Queue-based Load Leveling pattern](./queue-based-load-leveling.yml). A message that requires some long-running processing doesn't prevent other consumer service instances from processing other messages concurrently.

- It improves reliability. If a producer communicates directly with a consumer instead of using this pattern and doesn't monitor the consumer, it faces a high probability of losing messages or failing to process them when the consumer fails. In this pattern, the system doesn't send messages to a specific service instance. A failed service instance doesn't block a producer, and any working service instance can process messages.

- It doesn't require complex coordination between consumers or between producer and consumer instances. The message queue ensures that each message is delivered at least once.

- It scales. When you apply [autoscaling](/azure/architecture/best-practices/auto-scaling), the system can dynamically increase or decrease the number of consumer service instances as message volume fluctuates.

- It can improve resiliency if the message queue provides transactional read operations. If a consumer service instance reads and processes a message as part of a transactional operation and fails, this pattern can ensure that the message is returned to the queue so that another consumer service instance can process it. To mitigate the risk of continuous message failures, we recommend that you use [dead-letter queues](/azure/service-bus-messaging/service-bus-dead-letter-queues).

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Message ordering:** The order in which consumer service instances receive messages isn't guaranteed and doesn't necessarily show the order in which the messages were created. Design the system so that it [processes messages idempotently](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing). This design helps eliminate processing order dependencies.

  Azure Service Bus can implement guaranteed first-in-first-out ordering of messages and other patterns by using [message sessions](/azure/service-bus-messaging/message-sessions).

- **Service resiliency requirements:** If the system detects and restarts failed service instances, it might need to implement the operations that those service instances perform as idempotent to minimize the effects when it retrieves and processes a single message more than once.

- **Poison message detection:** A malformed message or a task that requires access to resources that aren't available can cause a service instance to fail. The system should prevent these messages from returning to the queue indefinitely and instead capture and store their details elsewhere for analysis if necessary. Service Bus can automatically send messages to a [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) after the delivery count exceeds the configured `MaxDeliveryCount` threshold.

- **Result handling:** The service instance that handles a message is fully decoupled from the application logic that generates the message, so they might not be able to communicate directly. If the service instance generates results that must go back to the application logic, store this information in a location that both components can access. To prevent the application logic from retrieving incomplete data, the system must indicate when processing completes. A worker process can pass results back to the application logic through a dedicated message reply queue. The application logic must be able to correlate these results with the original message.

- **Messaging system scaling:** In a large-scale solution, high message volume can overwhelm a single message queue and turn it into a system bottleneck. In this situation, consider partitioning the messaging system to send messages from specific producers to a specific queue, or load balance to distribute messages across multiple message queues.

- **Messaging system reliability:** Use a reliable messaging system to guarantee that messages aren't lost after the application enqueues them. This capability is essential to ensure that all messages are delivered at least once.

## When to use this pattern

Use this pattern when:

- The application workload is divided into tasks that can run asynchronously.

- Tasks are independent and can run in parallel.

- The work volume is highly variable and requires a scalable solution.

- The solution must provide high availability and remain resilient when task processing fails.

This pattern might not be suitable when:

- You can't easily separate the application workload into discrete tasks, or there's a high degree of dependence between tasks.

- Tasks must run synchronously, and the application logic must wait for each task to complete before it continues.

- Tasks must run in a specific sequence.

> [!NOTE]
> Some messaging systems support sessions that let a producer group messages together and ensure that the same consumer handles all messages in the group. You can use this mechanism with prioritized messages when supported to enforce message ordering and deliver messages in sequence from a producer to a single consumer.

## Workload design

Evaluate how to use the Competing Consumers pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern builds redundancy in queue processing by treating consumers as replicas, so an instance failure doesn't prevent other consumers from processing queue messages. <br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy) <br/> - [Background jobs](/azure/well-architected/reliability/background-jobs) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment**. | This pattern can help optimize costs because it scales based on queue depth and can scale down to zero when the queue is empty. It can also optimize costs because you can limit the maximum number of concurrent consumer instances. <br/><br/> - [CO:05 Rate optimization](/azure/well-architected/cost-optimization/get-best-rates) <br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern distributes load across consumer nodes to increase utilization, and dynamic scaling based on queue depth minimizes overprovisioning. <br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:07 Code and infrastructure](/azure/well-architected/performance-efficiency/optimize-code-infrastructure) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

Azure provides Service Bus queues and Azure Functions queue triggers that together directly implement this cloud design pattern. Functions integrates with Service Bus through triggers and bindings. This integration lets you build functions that consume queue messages from publishers. Publishing applications post messages to a queue, and consumers implemented as Functions can retrieve and handle those messages.

For resiliency, a Service Bus queue lets a consumer use [PeekLock mode](/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock) when it retrieves a message from the queue. This mode keeps the message but hides it from other consumers. The Functions runtime receives a message in PeekLock mode. If the function completes successfully, the runtime calls `Complete` on the message. If the function fails, the runtime might call `Abandon` and make the message visible again so that another consumer can retrieve it. If the function runs longer than the PeekLock timeout, the runtime automatically renews the lock as long as the function runs.

:::image type="complex" border="false" source="./_images/competing-consumers.svg" alt-text="Diagram that uses Service Bus to distribute work to Functions." lightbox="./_images/competing-consumers.svg":::
   On the left, an arrow points from an app to a message section that includes Service Bus. An arrow labeled fail points from this section to the dead-letter queue. Another line from the message section splits into two arrows that are numbered 1 and 2 that point to consumer 1 and consumer 2, respectively.
:::image-end:::

[Functions automatically scales](/azure/azure-functions/functions-scale) the number of consumer instances based on queue depth and traffic. This scaling lets the solution handle bursts of work while minimizing cost during low-volume periods. If Functions creates multiple instances, they compete by independently pulling and processing messages. For more information, see [Service Bus queues, topics, and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions) and [Service Bus trigger for Functions](/azure/azure-functions/functions-bindings-service-bus-trigger).

For more information about how to use the Service Bus client library for .NET to send messages to a Service Bus queue, see the published [examples](/dotnet/api/overview/azure/messaging.servicebus-readme#examples).

## Next steps

- [Choose a messaging service in Azure](/azure/architecture/guide/technology-choices/messaging): Learn how different Azure messaging services like Service Bus, Azure Storage queues, Azure Event Hubs, and Azure Event Grid support asynchronous communication patterns, and how to choose the right service and messaging model for your scenario.

- [Autoscaling best practices](/azure/architecture/best-practices/auto-scaling): Learn how to design solutions that scale out consumer instances based on workload, like queue length or message throughput, so that you can handle peak load and control cost during periods of low activity.

## Related resources

- [Compute Resource Consolidation pattern](./compute-resource-consolidation.md): You might be able to consolidate multiple instances of a consumer service into a single process to reduce costs and management overhead. The Compute Resource Consolidation pattern describes the benefits and trade-offs of this approach.

- [Queue-based Load Leveling pattern](./queue-based-load-leveling.yml): A message queue can add resiliency to the system. Resiliency lets service instances handle widely varying volumes of requests from application instances. The message queue functions as a buffer that levels the load. The Queue-based Load Leveling pattern describes this scenario in more detail.
