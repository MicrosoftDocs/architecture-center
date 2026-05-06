---
title: Publisher-Subscriber Pattern
description: Use an intermediary message broker or event bus to decouple senders from consumers and distribute messages to interested subscribers asynchronously.
ms.author: pnp
author: claytonsiemens77
ms.date: 03/04/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals

---

# Publisher-Subscriber pattern

The Publisher-Subscriber pattern lets applications broadcast events asynchronously to multiple interested consumers without coupling the senders and the receivers. This approach is known as *pub/sub messaging*.

## Context and problem

Cloud-based and distributed applications often include system components that send information to other components as events occur. When a sender communicates directly with its consumers, it must know the identity and endpoint of every consumer, deliver messages to each consumer, and manage failures individually. Adding or removing a consumer requires changes to the sender, which limits how independently teams can develop and deploy components.

Message queues decouple senders from consumers and prevent the sender from blocking a process while it waits for a response. A standard queue creates a direct relationship between a sender and a single consumer. To support multiple consumers, the sender must create a separate queue for each consumer, which increases routing complexity and doesn't scale well. Some consumers need only a subset of the information that the sender produces, but queues don't provide built-in ways to filter messages by content or category.

Many scenarios require a sender to announce events to many interested consumers without knowing who those consumers are. Each consumer also needs a way to decide independently which events to receive.

## Solution

Introduce an asynchronous messaging subsystem that includes the following components:

- An input messaging channel that the sender uses. The sender packages events into messages by using a known message format and sends these messages via the input channel. The sender in this pattern is also known as the *publisher*.

  > [!NOTE]
  > A *message* is a packet of data. An *event* is a message that notifies other components about a change or an action that occurs. This pattern typically works with events, but it also carries any type of message, including commands and state notifications.

- One output messaging channel for each consumer. The consumers are known as *subscribers*.

- A mechanism for copying each message from the input channel to the output channels for all subscribers interested in that message. An intermediary like a message broker or event bus typically handles this operation.

The following diagram shows the logical components of this pattern.

:::image type="complex" border="false" source="./_images/publish-subscribe.png" alt-text="The diagram shows a publish-subscribe pattern that uses a message broker." lightbox="./_images/publish-subscribe.png":::
   The diagram shows a publisher on the left. An arrow points to an input channel. An arrow points from the input channel to a message broker in the center. An arrow points from the message broker to an output channel. Three arrows point from the output channel to three separate subscribers on the right.
:::image-end:::

Pub/sub messaging has the following benefits:

- Decouples subsystems that need to communicate. Subsystems support independent management, and the broker retains messages even if one or more receivers are offline.

- Increases scalability and improves sender responsiveness. The sender sends a single message to the input channel and then returns to its core processing responsibilities. The messaging infrastructure routes messages to interested subscribers.

- Isolates faults. A subscriber failure doesn't affect the publisher or other subscribers, and the broker retains messages until a recovered subscriber is ready to process them.

- Supports deferred or scheduled processing. Subscribers can wait to pick up messages until off-peak hours, or the system can route or process messages according to a specific schedule.

- Supports integration between systems that use different platforms, programming languages, and communication protocols, and also connects on-premises systems with applications that run in the cloud.

- Improves testability. Channels support monitoring, and messages are available for inspection or logging as part of an integration test strategy.

- Provides separation of concerns for applications. Each application can focus on its core capabilities while the messaging infrastructure handles the work required to reliably route messages to multiple consumers.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Existing technologies:** Use messaging products and services that support a publish-subscribe model instead of building your own. In Azure, consider the following services:

  - [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) for messaging that requires transactions, ordering, sessions, or dead-letter queues.

  - [Azure Event Grid](/azure/event-grid/overview) for event‑based, push‑delivered notifications, especially when Azure resources change state and need to notify subscribed components.

  - [Azure Event Hubs](/azure/event-hubs/event-hubs-about) for high-throughput event streaming scenarios like telemetry ingestion and log aggregation. Event Hubs uses a log-based streaming model rather than traditional pub/sub messaging, but it supports multiple consumer groups that read the same stream independently.

  For more information, see [Choose between Azure services that deliver messages](/azure/service-bus-messaging/compare-messaging-services). Other technologies that support pub/sub messaging include [Redis](https://redis.io/docs/latest/develop/pubsub/), RabbitMQ, and Apache Kafka.

  Libraries like [MassTransit](https://masstransit.io) and [NServiceBus](https://docs.particular.net/nservicebus/) provide built-in support for the publish-subscribe model on Service Bus and other messaging technologies.

- **Subscription handling:** The messaging infrastructure must provide mechanisms that consumers use to subscribe to or unsubscribe from available channels.

- **Security:** Authenticate and authorize both publishers and subscribers on a per-topic basis. Unauthorized publishers that inject messages can damage a system as much as unauthorized subscribers that read them. Encrypt messages in transit, and if content is sensitive, encrypt them at rest in the broker to prevent eavesdropping.

- **Subsets of messages:** Subscribers are usually interested in only a subset of messages from a publisher. Messaging services often let subscribers select what they receive through the following mechanisms:

  - **Topics:** Each topic has a dedicated output channel, and each consumer can subscribe to all relevant topics.

  - **Content filtering:** The broker inspects and distributes messages based on their content. Each subscriber can specify the content that it needs.

  Choose topic granularity deliberately. Broad topics are simpler to manage but require subscribers to filter out messages that they don't need. Narrow topics reduce subscriber-side filtering but increase the number of topics to manage. Some brokers support wildcard subscriptions, like `orders.*`, which let subscribers match multiple topics without enumerating each one.

- **Bidirectional communication:** Channels in a publish-subscribe system are unidirectional. If a subscriber needs to acknowledge or communicate status back to the publisher, use the [Request-Reply pattern](https://www.enterpriseintegrationpatterns.com/patterns/messaging/RequestReply.html). This pattern uses one channel to send a message to the subscriber and a separate reply channel to communicate back to the publisher.

- **Message ordering:** The order in which subscribers receive messages isn't guaranteed and doesn't necessarily reflect the order in which the sender created them. If ordering matters, the broker might support ordered delivery within a partition or session, but that constrains scalability. Design subscribers to handle messages independently of arrival order.

- **Message priority:** Some workloads require that specific messages be processed before others. The [Priority Queue pattern](priority-queue.yml) provides a mechanism to route higher-priority messages before lower-priority messages.

- **Poison messages:** A malformed message, or a task that requires access to unavailable resources, can cause a service instance to fail. Capture and store these message details elsewhere for analysis. Some message brokers, like Service Bus, support this process through [dead-letter queues](/azure/service-bus-messaging/service-bus-dead-letter-queues).

- **Message size:** Brokers enforce message size limits. When payloads are large, store the content, like files or images, in an external data store and include a reference in the message. The [Claim-Check pattern](claim-check.yml) describes this approach.

- **Delivery guarantees and duplicate messages:** Messaging systems provide different delivery guarantees that each have trade-offs.

  - *At-most-once delivery* minimizes overhead but can lose messages if the broker or subscriber fails.

  - *At-least-once delivery* ensures message delivery but can result in duplicates, like when a sender fails after it posts a message and a new instance repeats the post.

  - *Exactly-once delivery* removes duplicates but adds coordination overhead and latency, and its availability depends on the messaging infrastructure.

  If your broker doesn't provide deduplication, design subscribers to [handle messages idempotently](../reference-architectures/containers/aks-mission-critical/mission-critical-data-platform.md#idempotent-message-processing). Different subscribers in the same workload might require different guarantees.

- **Message expiration:** Some messages have a limited lifetime. If a receiver doesn't process a message within that period, the message becomes irrelevant and the system discards it. Set an expiration timestamp in the message data so that receivers can check its relevance before they process it.

- **Message scheduling:** A message might be embargoed and unavailable for processing until a specific date and time. Set a release timestamp so that the messaging system withholds the message until that point.

- **Message schema evolution:** Publishers and subscribers deploy independently, so message schemas change over time. Prefer backward-compatible changes, like adding optional fields, so that existing subscribers continue to work. For breaking changes, version through topic names, like `orders.v1` and `orders.v2`, or through a version field in message metadata. Subscribers should ignore fields that they don't recognize.

- **Correlation:** The broker decouples publishers from subscribers, which makes it harder to trace the end-to-end flow of a message. Include a correlation ID in every message so that subscribers and logging systems can connect related operations into a single trace.

- **Backpressure and scaling:** When subscribers can't keep up, unprocessed messages accumulate in the broker and can deplete its resources. Use broker flow control settings to limit unacknowledged messages for each subscriber. Scale out subscribers by using the [Competing Consumers pattern](competing-consumers.md) when flow control alone isn't sufficient.

## When to use this pattern

Use this pattern when:

- An application needs to broadcast information to a significant number of consumers.

- An application needs to communicate with independently developed applications or services. They might use different platforms, programming languages, or communication protocols.

- An application can send information to consumers without requiring real-time responses from them.

- The systems being integrated are designed to support an eventual consistency model for their data.

- An application needs to communicate information to multiple consumers that have different availability requirements or uptime schedules than the sender.

This pattern might not be suitable when:

- An application has only a few consumers that need significantly different information from the producing application. The overhead of a broker adds complexity without any scaling benefit. Direct communication or separate queues might be more suitable.

- An application requires near real-time interaction with consumers. The pub/sub model introduces latency through the broker. Use a request-reply pattern when the publisher requires a synchronous response.

- Consumers must process messages in a specific, guaranteed order. Pub/sub systems generally don't guarantee ordering across subscribers, and maintaining order adds significant constraints to the broker and consumer design.

- The operation requires a single atomic transaction across the publisher and its consumers. Pub/sub messaging is inherently asynchronous and eventually consistent. If you need transactional guarantees, consider a direct database transaction or the [Saga pattern](saga.yml) for coordinating distributed transactions.

## Workload design

Evaluate how to use the Publisher-Subscriber pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern decouples components so that you can set independent reliability targets and remove direct dependencies. <br/><br/> - [RE:03 Failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis)<br/> - [RE:07 Background jobs](/azure/well-architected/reliability/background-jobs) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | This pattern introduces a clear security segmentation boundary. Use it to isolate queue subscribers from the publisher at the network level. <br/><br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining** and **improving** your workload's **return on investment (ROI)**. | This decoupled design supports event-driven architectures that align with consumption-based billing models and help avoid overprovisioning. <br/><br/> - [CO:05 Rate optimization](/azure/well-architected/cost-optimization/get-best-rates) <br/> - [CO:12 Scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | The broker as an intermediary lets you change the implementation on either the publisher or subscriber side without coordinating changes across both components. <br/><br/> - [OE:06 Workload development](/azure/well-architected/operational-excellence/workload-supply-chain) <br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Decoupling publishers from consumers lets you optimize compute and code for the specific tasks that each consumer handles for a given message type. <br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following diagram shows an enterprise integration architecture that uses Service Bus to coordinate workflows and Event Grid to notify subsystems of events that occur. For more information, see [Enterprise integration on Azure by using message queues and events](../example-scenario/integration/queues-events.yml).

:::image type="complex" source="../example-scenario/integration/media/enterprise-integration-message-broker-events.svg" border="false" alt-text="Architecture diagram of an enterprise integration pattern that uses a message broker and events." lightbox="../example-scenario/integration/media/enterprise-integration-message-broker-events.svg":::
   On the far left, a solid arrow labeled HTTPS points right from the client apps to an API gateway icon. Client apps connects to Microsoft Entra ID via an arrow labeled authentication. A solid arrow labeled HTTPS points from the API gateway to REST or simple object access protocol (SOAP) web service. Two regions are to the right of the API gateway. The top-middle region, labeled workflow and orchestration, includes three logic app icons. A dotted arrow points from one logic app icon to Service Bus.  A dotted arrow points from Service Bus to the second Logic app icon. A solid arrow labeled HTTPS points from this logic app to software as a service (SaaS) service. An unlabeled arrow splits from this line and points to Azure services. Another dotted arrow points from Event Grid to the third logic app. A solid arrow labeled HTTPS points from this logic app to SaaS service. An unlabeled arrow splits from this line and points to Azure services. The lower-middle region labeled queues, topics, subscriptions, and events includes Service Bus and Event Grid. A dotted arrow labeled messages points to message-based service. On the far right, a section labeled back-end systems contains three icons: SaaS service, Azure services, and message-based service. A dotted arrow labeled events points from Azure services to Event Grid. A dotted arrow labeled send or pull messages points from message-based service to Service Bus.
:::image-end:::

## Next steps

- [Asynchronous messaging options](../guide/technology-choices/messaging.md)
- [You don't need ordered delivery](https://particular.net/blog/you-dont-need-ordered-delivery)

## Related resources

- [Event-driven architecture style](../guide/architecture-styles/event-driven.md)
- [Idempotent message processing](../reference-architectures/containers/aks-mission-critical/mission-critical-data-platform.md#idempotent-message-processing)
- [Enterprise integration on Azure by using message queues and events](../example-scenario/integration/queues-events.yml)
