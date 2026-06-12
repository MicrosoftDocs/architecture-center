---
title: Queue-Based Load Leveling Pattern
description: Learn how to smooth intermittent heavy loads by using a queue that acts as a buffer between a task and the service that it invokes.
ms.author: pnp
author: claytonsiemens77
ms.date: 06/09/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Queue-Based Load Leveling pattern

Use a queue that acts as a buffer between a task and the service that it invokes. This approach smooths intermittent heavy loads that might cause the service to fail or the task to time out. It helps minimize the effect of demand peaks on availability and responsiveness of the task and the service.

## Context and problem

Many solutions in the cloud run tasks that invoke services. In this environment, intermittent heavy loads can cause performance or reliability problems for a service.

A service might be part of the same solution as the tasks that use it, or it might be a partner service that provides access to frequently used resources. Examples of these types of services include a cache or a storage service. When multiple tasks run concurrently and use the same service, it's difficult to predict the volume of requests at any time.

A service might experience demand peaks that overload it and make the service unable to respond to requests quickly. Flooding a service with many concurrent requests can also cause the service to fail if it can't handle the contention that these requests cause.

## Solution

Place a queue between the task and the service. The task and the service run asynchronously. The task posts a message that contains the data that the service requires to the queue. The queue acts as a buffer and stores the message until the service retrieves it. The service retrieves messages from the queue and processes them. Requests from multiple tasks, which can be generated at highly variable rates, can be passed to the service through the same message queue. The following diagram shows how a queue can level the load on a service.

:::image type="complex" source="./_images/queue-based-load-leveling-pattern.png" border="false" lightbox="./_images/queue-based-load-leveling-pattern.png" alt-text="Diagram that shows how a message queue acts as a buffer between tasks and a service.":::
    The diagram shows how a message queue decouples variable-rate task requests from a service that processes them at a consistent rate. The flow moves from left to right. On the left, separate arrows point from three task icons to a central message queue to show how tasks independently submit requests to the same queue. A single arrow points from the message queue to a service node on the far right, which represents how the service processes messages at a consistent rate.
:::image-end:::

The queue decouples the tasks from the service so that the service can handle the messages at its own pace even when concurrent tasks generate a high volume of requests. Also, tasks aren't delayed if the service isn't available when they post messages to the queue.

This pattern provides the following benefits:

- It helps maximize availability because service delays don't immediately and directly affect the application. The application can continue to post messages to the queue even when the service isn't available or isn't currently processing messages.

- It helps maximize scalability because the number of queues and the number of services can vary to meet demand.

- It helps control costs because you only need enough service instances to meet the requirements for an average load rather than the peak load.

> [!NOTE]
> Some services implement throttling when demand reaches a threshold that might cause system failure. Throttling can reduce the available functionality. Implement load leveling in these services to ensure that demand doesn't reach this threshold.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Implement application logic that controls the rate at which services handle messages to avoid overwhelming the target resource. Avoid passing spikes in demand to the next stage of the system. Test the system under load to ensure that it provides the required leveling. To achieve the required leveling, adjust the number of queues and the number of service instances that handle messages.

- Message queues are a one-way communication mechanism. If a task expects a reply from a service, you might need to implement a mechanism that the service can use to send a response. For more information, see [Asynchronous messaging options in Azure](/azure/architecture/guide/technology-choices/messaging).

- [Autoscaling](/azure/architecture/best-practices/auto-scaling) without bounding consumers' aggregate downstream rate only moves the overload to downstream dependencies. This overload can increase contention for resources that these services share and diminish the effectiveness of the queue to level the load.

- If your average producer rate exceeds the consumer rate, the queue continues to grow and latency increases. Monitor queue depth and scale consumers within safe limits, or shed work at the producer.

- This pattern depends on queue durability to prevent message loss. If the broker doesn't persist messages to durable storage, a crash or capacity limit can cause enqueued data to be lost before consumers process it. Choose a queue service that persists messages to disk or replicated storage, and understand its size quotas and retention limits. For workloads that require messages to survive regional failures, evaluate geo-disaster recovery options.

- Most queue services deliver messages with at-least-once semantics, which means that consumers can receive the same message more than once. Design consumer logic to be [idempotent](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing) so that processing the same message multiple times produces the same outcome and avoids problems such as duplicate records or repeated charges.

- Some messages can't be processed because they contain malformed data, reference missing resources, or trigger persistent errors. Rather than letting these messages cycle indefinitely and block the queue, route them to a [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues). Monitor dead-letter queue depth so that your operations team can investigate failures, fix the underlying problem, and resubmit messages when appropriate.

- Introducing a queue between a producer and consumer doesn't preserve the original submission order under all conditions, especially when multiple consumers process messages in parallel. If your workload requires strict ordering, use features such as [message sessions](/azure/service-bus-messaging/message-sessions) in Azure Service Bus. If strict ordering isn't required, design consumers to handle messages in any order, which simplifies scaling.

## When to use this pattern

Use this pattern when:

- Your workload experiences intermittent spikes that can overwhelm downstream services.

- You need to decouple request intake from processing throughput to improve resilience and cost control.

This pattern might not be suitable when:

- The caller requires a low-latency, synchronous response.

- The workload volume is predictably low and stable, so adding queueing complexity provides little benefit.

## Workload design

Evaluate how to use the Queue-Based Load Leveling pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | The approach that this pattern describes can provide resilience against sudden spikes in demand by decoupling the arrival of tasks from their processing. It can also isolate malfunctions in queue processing so that they don't affect intake.<br/><br/> - [RE:06 Scaling](/azure/well-architected/reliability/scaling) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment**. | Because load processing is decoupled from the request or task intake, you can use this approach to reduce the need to overprovision resources to handle peak load.<br/><br/> - [CO:12 Scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This approach enables intentional design for throughput performance because request intake doesn't need to correlate with the processing rate.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

A web app writes data to an external data store. If several instances of the web app run concurrently, the data store might be unable to respond to requests quickly enough, which causes requests to time out, be throttled, or otherwise fail. The following diagram shows a data store overwhelmed by concurrent requests from instances of an application.

:::image type="complex" source="./_images/queue-based-load-leveling-overwhelmed.png" border="false" lightbox="./_images/queue-based-load-leveling-overwhelmed.png" alt-text="Diagram that shows several concurrent requests from instances of a web app overwhelming a service.":::
    In the diagram, arrows point from several vertically stacked Azure App Service instance icons to one data store icon. Some of the App Service instances successfully connect to the data store. Two of the instances show a blocked-connection symbol labeled timeout, which indicates that the connection attempt failed.
:::image-end:::

To resolve this problem, use a queue to level the load between the application instances and the data store. An Azure Functions app reads messages from a Service Bus queue and performs the read/write requests to the data store. Azure Functions can scale instances based on Service Bus backlog by using target-based scaling, within your configured scaling bounds. You can also tune trigger concurrency settings to protect the data store. For implementation guidance, see [Target-based scaling](/azure/azure-functions/functions-target-based-scaling#service-bus-queues-and-topics) and [Limit scale-out](/azure/azure-functions/event-driven-scaling#limit-scale-out). Without this tuning, the worker layer can reintroduce back-end contention.

:::image type="complex" source="./_images/queue-based-load-leveling-function.png" border="false" lightbox="./_images/queue-based-load-leveling-function.png" alt-text="Diagram that shows how to use a queue and a function app to level the load.":::
    In the diagram, arrows point from several vertically stacked App Service instance icons to a Service Bus message queue. Another arrow points from the message queue, through a function app, and to the data store.
:::image-end:::

As a technology variation, you can implement the same pattern by using Azure Container Apps instead of Azure Functions. In that approach, a containerized worker consumes messages from [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) and writes to the data store. Container Apps scales the worker between configured minimum and maximum replicas based on queue-related scale rules. You can also implement the same approach by using [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction) as the event source. For implementation guidance, see [Set scaling rules in Container Apps](/azure/container-apps/scale-app) and [Deploy an event-driven job by using Container Apps](/azure/container-apps/tutorial-event-driven-jobs).

## Next steps

The following guidance might also be relevant when implementing this pattern:

- [Asynchronous messaging options in Azure](/azure/architecture/guide/technology-choices/messaging): Message queues are inherently asynchronous. You might need to redesign a task's application logic if it communicates directly with a service. Similarly, you might need to refactor a service to accept requests from a message queue.

- [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services): Get more information to help you choose a messaging and queuing mechanism in Azure applications.

- [Recommendations for developing background jobs](/azure/well-architected/design-guides/background-jobs): Apply this pattern to background jobs so that message queues can store requests for background tasks when the application experiences high load.

- [Web-Queue-Worker architecture style](/azure/architecture/guide/architecture-styles/web-queue-worker): The web and the worker are both stateless. Session state can be stored in a distributed cache. The worker does long-running work asynchronously and can be triggered by messages on the queue or run on a schedule for batch processing.

## Related resources

- [Competing Consumers pattern](./competing-consumers.md): It might be possible to run multiple instances of a service, each acting as a message consumer from the load-leveling queue. You can use this approach to adjust the rate at which messages are received and passed to a service.

- [Throttling pattern](./throttling.md): A simple way to implement throttling in a service is to use queue-based load leveling and route all requests to a service through a message queue. The service can process requests at a rate that ensures it doesn't exhaust the resources it needs and reduces the amount of possible contention.
