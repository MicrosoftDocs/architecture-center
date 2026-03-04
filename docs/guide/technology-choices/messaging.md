---
title: Asynchronous Messaging Options
description: Learn about asynchronous messaging options in Azure, including the different types of messages and the entities that participate in a messaging infrastructure.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/11/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Asynchronous messaging options

This article describes the different types of messages and the entities that participate in a messaging infrastructure. Based on message type requirements, Azure provides messaging services that include Azure Service Bus messaging, Azure Event Grid, and Azure Event Hubs. For more information, see [Compare messaging services](/azure/service-bus-messaging/compare-messaging-services).

At an architectural level, a *producer* entity creates a message datagram to distribute information. *Consumer* entities become aware of the information and act accordingly. The producer and the consumers can communicate directly or through an intermediary *message broker* entity. This article focuses on asynchronous messaging that uses a message broker.

:::image type="complex" source="./images/messaging.png" border="false" lightbox= "./images/messaging.png" alt-text="Diagram that shows the components of asynchronous messaging.":::
The diagram shows a flow that starts with a producer, goes to a message broker, and ends with a consumer.
:::image-end:::

Messages have two main categories:

- A *command* is a message that requests a specific action from the consumer.
- An *event* is a message that informs the consumer that an action occurred.

## Commands

A producer sends a command that requests the consumer to perform an operation within a business transaction.

A command is a high-value message that has strict delivery requirements. A command must be delivered at least once. If a command doesn't reach its destination, the entire business transaction might fail. In most cases, consumers shouldn't process a command more than one time. Duplicate processing can cause erroneous transactions, like duplicate orders or double billing.

Commands often manage the workflow of a multistep business transaction. Depending on the business logic, the producer might expect the consumer to acknowledge the message and report the results of the operation. Based on that result, the producer can choose how to proceed.

## Events

An event is a message that a producer raises to announce that something happened. The producer (known as the *publisher* in this context) has no expectation that the event will result in any specific action.

Interested consumers can subscribe, listen for events, and take actions depending on their consumption scenario. Events can have multiple subscribers or no subscribers at all. Different subscribers can react to the same event with different actions, independently of one another.

The producer and consumer are loosely coupled and managed independently. The producer doesn't expect the consumer to acknowledge the event back to the producer. A consumer that's no longer interested in the events can unsubscribe, which removes the consumer from the pipeline without affecting the producer or the overall functionality of the system.

Events have two categories:

- **Discrete events:** The producer raises events to announce individual facts. A common use case is event notification. For example, Azure Resource Manager raises events when it creates, modifies, or deletes resources. A logic app can subscribe to those events and send alert emails.

- **Event streams:** The producer raises a sequence of related events over time. Consumers typically evaluate streams for statistical purposes, either within a temporal window or as events arrive. Telemetry is a common use case, like monitoring the health and load of a system. Another use case includes event streaming from Internet of Things (IoT) devices.

You can implement event messaging by using the [Publisher-Subscriber pattern](../../patterns/publisher-subscriber.yml).

:::image type="complex" source="./images/event-pull.png" border="false" lightbox="./images/event-pull.png" alt-text="Diagram of the Publisher-Subscriber pattern for event messaging.":::
A publisher sends messages to a central message component, which then delivers those messages to two subscribers, labeled subscriber A and subscriber B.
:::image-end:::

## Role and benefits of a message broker

An intermediate message broker stores and moves messages from the producer to the consumer. It can also provide other benefits.

### Decoupling

A message broker separates the producer's message-generation logic from the consumer's message-processing logic. In a complex workflow, this separation helps you decouple business operations and coordinate the workflow.

Consider a business transaction that requires distinct operations in sequence:

1. The producer issues a command that signals a consumer to start an operation.

1. The consumer acknowledges the message in a separate response queue reserved for lining up responses for the producer.

1. After the producer receives the response, it sends a new message to start the next operation.

1. A different consumer processes that message and sends a completion message to the response queue.

By using messaging, the services coordinate the transaction workflow among themselves.

:::image type="complex" source="./images/messagetrans.png" border="false" lightbox="./images/messagetrans.png" alt-text="Diagram of producer-consumer communication.":::
Diagram that shows a producer on the left. The producer sends two separate message streams into two message queues. Each queue sends messages to a corresponding consumer labeled consumer A and consumer B. Both consumers send their responses back to a shared response queue, then to the producer.
:::image-end:::

A message broker provides temporal decoupling. The producer and consumer don't have to run concurrently. A producer can send a message to the message broker regardless of the consumer availability. And the producer's availability doesn't restrict the consumer.

For example, the user interface (UI) of a web app generates messages and uses a queue as the message broker. When the consumer is ready, it can retrieve messages from the queue and perform the work. Temporal decoupling helps the UI remain responsive and unblocked while the messages are handled asynchronously.

Some operations can take a long time. After the producer issues a command, it shouldn't have to wait until the consumer completes the operation. A message broker helps process messages asynchronously.

### Load balancing

Producers can post a large number of messages for multiple consumers to process. Use a message broker to distribute processing across servers and improve throughput. Consumers can run on different servers to spread the workload. You can dynamically add or remove consumers to scale the system as needed.

:::image type="complex" source="./images/comp-con.png" border="false" lightbox="./images/comp-con.png" alt-text="Diagram of the Competing Consumers pattern.":::
Diagram that shows an application instance on the left. It sends messages into a single message queue in the center. From this queue, three arrows point to three separate consumer instances on the right that represent a pool of consumers that process messages in parallel.
:::image-end:::

The [Competing Consumers pattern](../../patterns/competing-consumers.yml) processes multiple messages concurrently to optimize throughput, improve scalability and availability, and balance the workload.

### Load leveling

Producers generate varying message volumes that can spike suddenly. Rather than adding consumers to handle the extra load, a message broker buffers the messages. Consumers then process messages at a manageable rate without overloading the system.

:::image type="complex" source="./images/load-lev.png" border="false" lightbox="./images/load-lev.png" alt-text="Diagram of Queue-based Load Leveling pattern.":::
Three producers on the left point to a central message queue. A single arrow exits the queue to one consumer on the right. Below the diagram, a bar chart labeled requests received at a variable rate has uneven bars. Another bar chart labeled messages processed at a more constant rate has more uniform bars.
:::image-end:::

For more information, see [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.yml).

### Reliable messaging

A message broker ensures that messages persist through communication failures between the producer and the consumer. The producer posts messages to the broker, and the consumer retrieves them after communication resumes. The producer remains unblocked unless it loses connectivity to the message broker.

### Resilient messaging

A message broker adds resiliency to consumers in your system. If a consumer fails while it processes a message, another consumer instance can process that message. The broker retains the message, which supports this reprocessing.

### Large messages

When your payload exceeds the message broker's size limit, or when consumers need to access large payloads only occasionally, use the [Claim-Check pattern](../../patterns/claim-check.yml). Store the large payload in an external store like Azure Blob Storage. Send the broker a message that includes a pointer to the stored payload. The consumer uses the pointer to retrieve the payload when needed. This approach prevents large datagrams from overwhelming the broker and consumers.

## Technology choices for a message broker

Azure provides several message broker services that each have different features. Before you choose a service, determine the intent and requirements of the message.

### Service Bus messaging

Use [Service Bus messaging](/azure/service-bus-messaging/service-bus-messaging-overview) queues to transfer commands from producers to consumers.

#### Pull model

A consumer of a Service Bus queue continuously polls Service Bus to check for new messages. The client SDKs and the [Azure functions trigger for Service Bus](/azure/azure-functions/functions-bindings-service-bus-trigger) handle this polling automatically. When a message becomes available, the SDK invokes the consumer's callback and delivers the message to the consumer.

#### Guaranteed delivery

Service Bus uses a peek-lock mechanism. When a consumer retrieves a message, Service Bus locks it temporarily. This lock prevents other consumers from processing the same message.

The consumer must report the message's processing status. When the consumer marks the message as consumed, Service Bus removes the message from the queue. If a failure, timeout, or crash occurs, Service Bus unlocks the message so that other consumers can retrieve it. This approach prevents message loss during transfer.

A producer might accidentally send the same message twice. For example, a producer instance fails after it sends a message. Another producer replaces the original instance and sends the message again. Service Bus queues provide a [built-in deduping capability](/azure/service-bus-messaging/duplicate-detection) that detects and removes duplicate messages. Service Bus might still deliver a message twice. For example, if a consumer fails while processing, Service Bus returns the message to the queue, and the same consumer or another consumer retrieves it again. The consumer's message-processing logic should be idempotent so that repeated processing doesn't change the system state.

#### Message ordering

To ensure that messages are delivered in the order that they were sent, Service Bus queues use sessions to provide ordered delivery. A session can have one or more messages. Service Bus correlates messages by using the `SessionId` property. Messages that belong to a session never expire. You can lock a session to a consumer to prevent a different consumer from handling its messages.

For more information, see [Message sessions](/azure/service-bus-messaging/message-sessions).

#### Message persistence

Service Bus queues support durable temporal decoupling. Even when a consumer is unavailable or unable to process the message, it remains in the queue.

#### Checkpoint long-running transactions

Business transactions can run for a long time. Each operation in the transaction can have multiple messages. Use checkpointing to coordinate the workflow and provide resiliency if a transaction fails.

Service Bus queues support checkpointing through the [session state capability](/azure/service-bus-messaging/message-sessions#message-session-state). Consumers use [`SetSessionStateAsync`](/dotnet/api/azure.messaging.servicebus.servicebussessionreceiver.setsessionstateasync) to incrementally record state information in the queue for messages that belong to a session. For example, a consumer can track progress by periodically calling [`GetSessionStateAsync`](/dotnet/api/azure.messaging.servicebus.servicebussessionreceiver.getsessionstateasync) to check the state. If a consumer fails, another consumer can use the state information to determine the last known checkpoint and resume the session.

#### Dead-letter queue

A Service Bus queue has a default subqueue, called the [*dead-letter queue (DLQ)*](/azure/service-bus-messaging/service-bus-dead-letter-queues), to hold messages that Service Bus can't deliver or that consumers can't process. Service Bus or the message processing logic in the consumer can add messages to the DLQ. The DLQ retains messages until a consumer retrieves them from the queue.

Service Bus moves messages to the DLQ in the following scenarios:

- A *poison message* is a message that the consumer can't handle because it's malformed or contains unexpected information. To detect poison messages in Service Bus queues, set the `MaxDeliveryCount` property of the queue. If the consumer receives the same message more times than this property value allows, Service Bus moves the message to the DLQ.

- A message might no longer be relevant if a consumer doesn't process it within a specific period. Service Bus queues let the producer post messages with a time-to-live (TTL) attribute. If this period expires before a consumer receives the message, Service Bus places the message in the DLQ.

Check messages in the DLQ to determine the failure reason. You might not be able to reprocess those messages and might need a custom compensating action.

#### Hybrid solution

Service Bus bridges on-premises systems and cloud solutions. On-premises systems are often difficult to reach because of firewall restrictions. Both the producer and consumer, either on-premises or in the cloud, can use the Service Bus queue endpoint in the cloud as the location to exchange messages.

[Azure Relay Hybrid Connections](/azure/azure-relay/relay-hybrid-connections-protocol) provides a turnkey implementation for message-based cross-premises communication. Azure Relay is built on Service Bus and provides bidirectional, request-response patterns and datagram flows.

You can also use the [Messaging Bridge pattern](/azure/architecture/patterns/messaging-bridge) to handle these scenarios.

#### Topics and subscriptions

Service Bus supports the Publisher-Subscriber pattern through topics and subscriptions.

Topics and subscriptions let the producer broadcast messages to multiple consumers. When a topic receives a message, it forwards the message to all subscribed consumers. You can optionally add filter criteria to a subscription so that consumers receive only a subset of messages. Each consumer retrieves messages from a subscription, similar to a queue.

Keep routing logic simple. Avoid embedding complex business rules in your subscription filters. Prefer the *smart endpoints and dumb pipes* approach. Use the broker for reliable transport and broad routing, but handle complex decision logic within the consuming service.

For more information, see [Service Bus topics](/azure/service-bus-messaging/service-bus-messaging-overview#topics).

#### Protocols in Service Bus

Service Bus uses the [Advanced Message Queueing Protocol (AMQP)](/azure/service-bus-messaging/service-bus-amqp-overview) for industry-wide interoperability. The service also supports the [Java Message Service (JMS) API](/azure/service-bus-messaging/how-to-use-java-message-service-20) standard.

For more information about the message format schema, see [Messages, payloads, and serialization](/azure/service-bus-messaging/service-bus-messages-payloads).

### Event Grid

Use [Event Grid](/azure/event-grid/overview) for discrete events. Event Grid follows the Publisher-Subscriber pattern. When event sources trigger events, they publish them to [Event Grid topics](/azure/event-grid/concepts#topics). Consumers of those events create Event Grid subscriptions by specifying event types and an event handler to process the events. Each event can have multiple subscriptions.

#### Push model in Event Grid

Event Grid can propagate messages to the subscribers in a durable push model. Suppose that you have an Event Grid subscription with a webhook. When a new event arrives, Event Grid posts the event to the webhook endpoint. In the push model, if no subscribers exist or subscribers repeatedly fail to respond, Event Grid discards the events.

You can build a custom endpoint to receive events if the endpoint [follows the webhook specification](/azure/event-grid/end-point-validation-cloud-events-schema). Or you can use built-in capabilities like the [Event Grid bindings for Azure Functions](/azure/azure-functions/functions-bindings-event-grid).

#### Integrate with Azure

Choose Event Grid if you want to get notifications about Azure resources. Many Azure services serve as event sources that have built-in Event Grid topics. Event Grid also supports various Azure services that you can set up as [event handlers](/azure/event-grid/overview#event-handlers). You can subscribe to those topics to route events to event handlers of your choice. For example, you can use Event Grid to invoke an Azure function when you create or delete a storage blob.

#### Custom topics

Create custom Event Grid topics if you want to send events from your application or an Azure service that Event Grid doesn't integrate with.

For example, suppose that you want to monitor the progress of an entire business transaction. The participating services raise events as they process their individual business operations. A web app displays those events. To implement this monitoring, create a custom topic and add a subscription that registers your web app as an HTTP webhook. When business services send events to the custom topic, Event Grid pushes the events to your web app.

#### Filtered events

You can specify filters in a subscription to instruct Event Grid to route only a subset of events to a specific event handler. Specify the filters in the [subscription schema](/azure/event-grid/subscription-creation-schema). When producers send events to the topic, Event Grid automatically forwards only events with values that match the filter to that subscription.

For example, applications upload content in various formats to Blob Storage. Blob Storage raises and publishes an event to Event Grid each time a file arrives. You can add a filter to the subscription that limits events to images only so that an event handler can generate thumbnails.

For more information, see [Filter events for Event Grid](/azure/event-grid/how-to-filter-events).

#### High throughput

Event Grid has multiple [tiers](/azure/event-grid/choose-right-tier#basic-and-standard-tiers) to support high‑throughput, high‑volume use cases. Feature availability and throughput vary by tier.

#### Resilient delivery

Successful delivery for events matters less than it does for commands, but you might still want delivery guarantees depending on the event type. Event Grid attempts to deliver each message *at least once* for each subscription. You can turn on and customize features like retry policies, expiration time, and dead lettering. For more information, see [Event Grid message delivery and retry](/azure/event-grid/delivery-and-retry).

The Event Grid retry process improves resiliency, but it doesn't guarantee delivery. Event Grid might deliver the message more than one time, skip, or delay some retries when the endpoint remains unresponsive for an extended period. For more information, see [Retry schedule](/azure/event-grid/delivery-and-retry#retry-schedule).

When you turn on dead lettering, Event Grid persists undelivered events to a Blob Storage account. If the Blob Storage endpoint becomes unresponsive, Event Grid delays delivery and eventually discards the event. For more information, see [Set dead-letter location and retry policy](/azure/event-grid/manage-event-delivery).

Event Grid doesn't guarantee order for event delivery.

#### Pull model in Event Grid

In addition to the push model, Event Grid supports [HTTP-based pull delivery](/azure/event-grid/pull-delivery-overview) that uses queue-like semantics. Use this model when your event consumers have the following characteristics:

- Process events on a schedule rather than continuously
- Have intermittent availability that prevents reliable real-time push delivery
- Have network restrictions that require a [private link](/azure/event-grid/configure-private-endpoints)
- Can't expose a push notification endpoint

Event Grid remains optimized for high-throughput distribution of discrete events, even with pull delivery. If your workload requires enterprise messaging features like strictly ordered processing (sessions), transactions, or duplicate detection, use Service Bus instead.

#### Protocols in Event Grid

Event Grid supports two event schemas:

- **CloudEvents schema:** Prefer this format schema for events. It's based on an [open specification](https://github.com/cloudevents/spec/blob/v1.0/spec.md) for describing event data and provides high interoperability between vendor systems.

- **Event Grid schema:** Use this proprietary, nonextensible format schema only when you can't use the CloudEvents schema. This schema is specific to Event Grid.

Event Grid supports two protocols for message broker interaction:

- A [custom HTTP publish API](/rest/api/eventgrid/dataplane/operation-groups) to receive events into the system for distribution.

- A [Message Queuing Telemetry Transport (MQTT) broker](/azure/event-grid/mqtt-overview) capability that lets MQTT clients publish and subscribe to messages. For example, this capability can provide bidirectional communication for IoT scenarios.

### Event Hubs

When you work with event streams, use [Event Hubs](/azure/event-hubs/event-hubs-about) as the message broker. Event Hubs buffers large volumes of data at low latency. Multiple consumers can read data concurrently from the buffer. You can transform the received data by using any real-time analytics provider. Event Hubs also stores events in a storage account.

#### High-volume ingestion

Event Hubs can ingest millions of events per second. Event Hubs appends events to the stream and orders them by time.

#### Pull model in Event Hubs

Event Hubs provides publisher-subscriber capabilities. A key difference between other queues and Event Hubs is how Event Hubs makes event data available to subscribers. Event Hubs uses a pull‑based model in which it appends events to a stream rather than placing them in a traditional queue. A subscriber manages its cursor and can move forward and back in the stream, select a time offset, and replay a sequence at its pace.

*Stream processors* are subscribers that pull data from Event Hubs for transformation and statistical analysis. For complex processing like aggregation over time windows or anomaly detection, use [Azure Stream Analytics](../../reference-architectures/data/stream-processing-stream-analytics.yml) or [Apache Spark](https://spark.apache.org/). You can also integrate Event Hubs with Microsoft Fabric by [loading data into your eventhouse](/fabric/real-time-intelligence/get-data-event-hub) or [creating an eventstream](/fabric/real-time-intelligence/event-streams/add-source-azure-event-hubs).

To process individual events in each partition, you can use [EventProcessorHost](/azure/event-hubs/event-processor-balance-partition-load), built-in connectors like [Azure Logic Apps](/azure/connectors/connectors-create-api-azure-event-hubs), or [Event Hubs trigger and bindings for Azure Functions](/azure/azure-functions/functions-bindings-event-hubs).

#### Partitioning

A *partition* is a portion of the event stream. Event Hubs divides events by using a partition key. For example, several IoT devices send device data to an event hub. The partition key is the device identifier. As Event Hubs ingests events, it moves them to separate partitions. Within each partition, Event Hubs orders all events by time.

A *consumer* is an instance of code that processes the event data. Event Hubs follows a partitioned consumer pattern. Each consumer only reads a specific partition. Multiple partitions result in faster processing because multiple consumers can read the stream concurrently.

Instances of the same consumer make up a single consumer group. Multiple consumer groups can read the same stream with different intentions. Suppose that an event stream has data from a temperature sensor. One consumer group can read the stream to detect anomalies like a spike in temperature. Another consumer can read the same stream to calculate a rolling average temperature in a temporal window.

Event Hubs implements the Publisher-Subscriber pattern through multiple consumer groups, where each group serves as a separate subscriber.

For more information about Event Hubs partitioning, see [Partitions](/azure/event-hubs/event-hubs-features#partitions).

#### Event Hubs capture

You can use the capture feature to store the event stream in [Blob Storage](/azure/storage/blobs/storage-blobs-overview) or [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction). Capture provides reliable storage because it keeps your data for a period if the storage account is unavailable, then writes to the storage after it becomes available.

Storage services also provide extra features for analyzing events. For example, use the access tiers of a Blob Storage account to store events in a hot tier for data that needs frequent access. You might use that data for visualization. Alternatively, you can store data in the archive tier and retrieve it occasionally for auditing purposes.

Capture stores *all* events that Event Hubs ingests and provides batch processing capabilities. You can generate reports on the data by using a MapReduce function. Captured data can also serve as the source of truth. If your aggregated data misses specific details, you can retrieve them from the captured data.

For more information about this feature, see [Capture events through Event Hubs in Blob Storage or Data Lake Storage](/azure/event-hubs/event-hubs-capture-overview).

#### Support for Apache Kafka clients

Event Hubs provides an endpoint for [Apache Kafka](https://kafka.apache.org/) clients. Existing clients can update their configuration to point to the endpoint and start sending events to Event Hubs. You don't need to make any code changes.

For more information, see [Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-apache-kafka-overview).

## Crossover scenarios

You can combine two messaging services to gain advantages. This approach increases messaging system efficiency. For example, suppose that you use Service Bus queues to handle messages in your business transaction. Idle queues that occasionally receive messages create inefficiency because the consumer continuously polls the queue for new messages. You can set up an Event Grid subscription and use an Azure function as the event handler. Each time the queue receives a message and no consumers are listening, Event Grid sends a notification that invokes the Azure function to drain the queue.

:::image type="complex" source="./images/crossover1.png" border="false" lightbox="./images/crossover1.png" alt-text="Diagram that shows Service Bus to Event Grid integration.":::
On the left, a Service Bus queue publishes messages. In the center, an Event Grid subscription sends notifications. The Event Grid subscription points to a logic app, which drains the queue.
:::image-end:::

For more information, see [Service Bus to Event Grid integration overview](/azure/service-bus-messaging/service-bus-to-event-grid-integration-concept).

The [enterprise integration architecture that uses message queues and events](../../example-scenario/integration/queues-events.yml) includes Service Bus to Event Grid integration.

As another example, Event Grid receives a set of events. Some events require a workflow and other events trigger notifications. The message metadata indicates the type of event. To check the metadata, use the filtering feature in the event subscription. If an event requires a workflow, Event Grid sends it to a Service Bus queue. The receivers of that queue can take necessary actions. Event Grid sends the notification events to Logic Apps to send alert emails.

:::image type="complex" source="./images/crossover2.png" border="false" lightbox="./images/crossover2.png" alt-text="Diagram of Event Grid to Service Bus integration.":::
On the left, resource group events point to a subscription that filters events based on metadata. From the subscription, one arrow points to a Service Bus queue that stores commands. Another arrow points to a logic app that sends alert emails.
:::image-end:::

## Related patterns

Consider the following patterns when you implement asynchronous messaging:

- [Competing Consumers pattern](../../patterns/competing-consumers.yml): Multiple consumers might need to compete to read messages from a queue. This pattern explains how to process multiple messages concurrently to optimize throughput, improve scalability and availability, and balance the workload.

- [Priority Queue pattern](../../patterns/priority-queue.yml): When business logic requires prioritized message processing, this pattern describes how consumers process higher-priority messages before lower-priority messages.

- [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.yml): This pattern uses a message broker to act as a buffer between a producer and a consumer. This pattern helps minimize the impact of intermittent heavy loads on both the producer's and consumer's availability and responsiveness.

- [Retry pattern](../../patterns/retry.yml): Producers or consumers might temporarily lose connection to a queue because of transient failures. This pattern describes how to retry operations during transient failures to maintain application resiliency.

- [Scheduler Agent Supervisor pattern](../../patterns/scheduler-agent-supervisor.yml): Workflows often require messaging to coordinate distributed services. This pattern demonstrates how messaging coordinates distributed actions and helps systems recover from failures by retrying failed operations.

- [Choreography pattern](../../patterns/choreography.yml): This pattern shows how services can use messaging to control the workflow of a business transaction.

- [Claim-Check pattern](../../patterns/claim-check.yml): This pattern shows how to divide a large message into a claim check and a payload.

## Community resources

- [Blog post: Idempotency](https://blog.jonathanoliver.com/idempotency-patterns/)
- [Blog post: What do you mean by event driven?](https://martinfowler.com/articles/201701-event-driven.html)
