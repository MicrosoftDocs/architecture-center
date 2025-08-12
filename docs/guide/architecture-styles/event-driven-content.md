---
title: Event-Driven Architecture Style
description: Explore the benefits, challenges, and best practices for event-driven and IoT architectures on Azure.
author: claytonsiemens77
ms.author: pnp
ms.date: 08/06/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: arb-web
---

# Event-driven architecture style

An event-driven architecture consists of *event producers* that generate a stream of events, *event consumers* that listen for these events, and *event channels* (often implemented as event brokers or ingestion services) that transfer events from producers to consumers.

## Architecture approach

:::image type="complex" border="false" source="./images/event-driven.svg" alt-text="Diagram that shows an event-driven architecture style." lightbox="./images/event-driven.svg":::
   An arrow points from the Event producers section to the Event ingestion section. Three arrows point from the Event ingestion section to three sections that are all labeled Event consumers.
:::image-end:::

Events are delivered in near real time, so consumers can respond immediately to events as they occur. Producers are decoupled from consumers: A producer doesn't know which consumers are listening. Consumers are also decoupled from each other, and every consumer sees all of the events. 

This process differs from a [Competing Consumers pattern][competing-consumers]. In the Competing Consumers pattern, consumers pull messages from a queue. Each message is processed only one time, assuming that there are no errors. In some systems, such as [Azure Internet of Things (IoT)](/azure/iot-fundamentals/iot-introduction), events must be ingested at high volumes.

An event-driven architecture can use a [publish-subscribe model](/azure/architecture/patterns/publisher-subscriber) or an event stream model.

- **Pub/sub:** The publish-subscribe messaging infrastructure tracks subscriptions. When an event is published, it sends the event to each subscriber. Once received, an event can't be replayed, and new subscribers don't see the event. [Azure Event Grid](/azure/event-grid/overview) is a recommended service for pub/sub scenarios.

- **Event streaming:** Events are written to a log. Events are strictly ordered within a partition and are durable. Clients don't subscribe to the stream. Instead, a client can read from any part of the stream. The client is responsible for advancing their position in the stream. That means a client can join at any time and can replay events. [Azure Event Hubs](/azure/event-hubs/event-hubs-about) is designed for high-throughput event streaming.

On the consumer side, there are some common variations:

- **Simple event processing:** An event immediately triggers an action in the consumer. For example, you can use [Azure Functions](/azure/azure-functions/functions-overview) with an [Event Grid trigger](/azure/azure-functions/functions-bindings-event-grid-trigger) or [Azure Service Bus trigger](/azure/azure-functions/functions-bindings-service-bus-trigger) so that your code runs whenever a message is published.

- **Basic event correlation:** A consumer processes a few discrete business events, correlates them by some identifier, and persists information from earlier events for use when processing later events. Libraries like [NServiceBus](https://docs.particular.net/tutorials/nservicebus-sagas/1-saga-basics/) and [MassTransit](https://masstransit.io/documentation/configuration/sagas/overview) support this pattern.

- **Complex event processing:** A consumer uses a technology like [Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction) to analyze a series of events and identify patterns in the event data. For example, you can aggregate readings from an embedded device over a time window and generate a notification if the moving average crosses a certain threshold.

- **Event stream processing:** Use a data streaming platform, such as [Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub), [Azure Event Hubs](/azure/event-hubs/event-hubs-about), or [Azure Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-apache-kafka-overview), as a pipeline to ingest events and feed them to stream processors. The stream processors act to process or transform the stream. There might be multiple stream processors for different subsystems of the application. This approach is a good fit for IoT workloads.

The source of the events might be external to the system, such as physical devices in an IoT solution. In that case, the system must be able to ingest the data at the volume and throughput that the data source requires.

There are two primary approaches to structure event payloads. When you have control over your event consumers, you can decide on the payload structure for each consumer. This strategy allows you to mix approaches as needed within a single workload.

- **Include all required attributes in the payload:** Use this approach when you want consumers to have all available information without needing to query an external data source. However, it can lead to data consistency problems because of multiple [systems of record](https://wikipedia.org/wiki/System_of_record), particularly after updates. Contract management and versioning can also become complex.

- **Include only keys in the payload:** In this approach, consumers retrieve the necessary attributes, such as a primary key, to independently fetch the remaining data from a data source. This method provides better data consistency because it has a single system of record. However, it can perform poorer than the first approach because consumers must query the data source frequently. You have fewer concerns regarding coupling, bandwidth, contract management, or versioning because smaller events and simpler contracts reduce complexity.

In the preceding diagram, each type of consumer is shown as a single box. To avoid having the consumer become a single point of failure in the system, it's typical to have multiple instances of a consumer. Multiple instances might also be required to handle the volume and frequency of events. A single consumer can process events on multiple threads. This setup can create challenges if events must be processed in order or require exactly-once semantics. For more information, see [Minimize coordination][minimize-coordination].

There are two primary topologies within many event-driven architectures:

- **Broker topology:** Components broadcast events to the entire system. Other components either act on the event or ignore the event. This topology is useful when the event processing flow is relatively simple. There's no central coordination or orchestration, so this topology can be dynamic. This topology is highly decoupled, which helps provide scalability, responsiveness, and component fault tolerance. No component owns or is aware of the state of any multistep business transaction, and actions are taken asynchronously. Therefore, distributed transactions are risky because there's no built-in way to be restarted or replayed. You need to carefully consider error handling and manual intervention strategies because this topology can be a source of data inconsistency.

- **Mediator topology:** This topology addresses some of the shortcomings of broker topology. There's an event mediator that manages and controls the flow of events. The event mediator maintains the state and manages error handling and restart capabilities. In contrast to the broker topology, in this topology, components broadcast occurrences as commands and only to designated channels. These channels are usually message queues. Consumers are expected to process these commands. This topology provides more control, better distributed error handling, and potentially better data consistency. This topology does introduce increased coupling between components, and the event mediator can become a bottleneck or a reliability concern.

## When to use this architecture

You should use this architecture when:

- Multiple subsystems must process the same events.
- Real-time processing with minimum time lag is required.
- Complex event processing, such as pattern matching or aggregation over time windows, is required.
- High volume and high velocity of data is required, as with, for example, IoT.
- You need to decouple producers and consumers for independent scalability and reliability goals.

## Benefits

The benefits of this architecture are:

- Producers and consumers are decoupled.
- No point-to-point integrations. It's easy to add new consumers to the system.
- Consumers can respond to events immediately as they occur.
- Highly scalable, elastic, and distributed.
- Subsystems have independent views of the event stream.

## Challenges

- Guaranteed delivery.

  In some systems, especially in IoT scenarios, it's crucial to guarantee that events are delivered.

- Processing events in order or exactly once.

  For resiliency and scalability, each consumer type typically runs in multiple instances. This process can create a challenge if the events must be processed in order within a consumer type, or if [idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing) logic isn't implemented.

- Message coordination across services.

  Business processes often have multiple services that publish and subscribe to messages to achieve a consistent outcome across a whole workload. You can use [workflow patterns](https://docs.particular.net/architecture/workflows) like the [Choreography pattern](/azure/architecture/patterns/choreography) and [Saga Orchestration](/azure/architecture/reference-architectures/saga/saga#orchestration) to reliably manage message flows across various services.

- Error handling.

  Event-driven architecture mainly uses asynchronous communication. A challenge with asynchronous communication is error handling. One way to address this problem is to use a separate error-handler processor. When the event consumer experiences an error, it immediately and asynchronously sends the erroneous event to the error-handler processor and moves on. The error-handler processor tries to fix the error and sends the event back to the original ingestion channel. But if the error-handler processor fails, it can send the erroneous event to an administrator for further inspection. If you use an error-handler processor, erroneous events are processed out of sequence when they're resubmitted.

- Data loss.

  Another challenge with asynchronous communication is data loss. If any of the components crashes before successfully processing and handing over the event to its next component, then the event is dropped and never makes it into the final destination. To minimize the chance of data loss, persist in-transit events and remove or dequeue the events only when the next component acknowledges the receipt of the event. These features are known as *client acknowledge mode* and *last participant support*.

- Implementation of a traditional request-response pattern.

  Sometimes the event producer requires an immediate response from the event consumer, such as obtaining customer eligibility before proceeding with an order. In an event-driven architecture, synchronous communication can be achieved by using [request-response messaging](https://www.enterpriseintegrationpatterns.com/patterns/messaging/RequestReply.html).

  This pattern is implemented with two queues: A request queue and a response queue. The event producer sends an asynchronous request to a request queue, pauses other operations on that task, and awaits a response in the reply queue. This approach effectively turns this pattern into a synchronous process. Event consumers then process the request and send the reply back through a response queue. This approach usually uses a session ID for tracking, so the event producer knows which message in the response queue is related to the specific request. The original request can also specify the name of the response queue, potentially ephemeral, in a [reply-to header](/dotnet/api/azure.messaging.servicebus.servicebusmessage.replyto), or another mutually agreed-upon custom attribute.

- Maintenance of the appropriate number of events.

  Generating an excessive number of fine-grained events can saturate and overwhelm the system, making it difficult to effectively analyze the overall flow of events. This problem is exacerbated when changes need to be rolled back. Conversely, overly consolidating events can also create problems, resulting in unnecessary processing and responses from event consumers.

  To achieve the right balance, consider the consequences of events and whether consumers need to inspect the event payloads to determine their responses. For instance, if you have a compliance check component, it might be sufficient to publish only two types of events: *compliant* and *noncompliant*. This approach helps ensure that only relevant consumers process each event, which prevents unnecessary processing.
  
### Other considerations

- The amount of data to include in an event can be a significant consideration that affects both performance and cost. You can simplify the processing code and eliminate extra lookups by placing all the relevant information needed for processing directly in the event. When you add only a minimal amount of information to an event, such as a few identifiers, you reduce transport time and cost. However, this approach requires the processing code to retrieve any additional information it needs. For more information, see [Putting your events on a diet](https://particular.net/blog/putting-your-events-on-a-diet).

- A request is only visible to the request-handling component. But events are often visible to multiple components in a workload, even if those components don't or aren't meant to consume them. To operate with an "assume breach" mindset, be mindful of what information you include in events to prevent unintended information exposure.

- Many applications use event-driven architecture as their primary architecture. You can combine this approach with other architectural styles to create a hybrid architecture. Typical combinations include [microservices](./microservices.md) and [pipes and filters](../../patterns/pipes-and-filters.yml). Integrate an event-driven architecture to enhance system performance by eliminating bottlenecks and providing [back pressure](https://wikipedia.org/wiki/Back_pressure) during high request volumes.

- [Specific domains](../../microservices/model/domain-analysis.md) often span multiple event producers, consumers, or event channels. Changes to a particular domain might affect many components.

## Related resources

- [Community discussion video](https://particular.net/webinars/2023-orchestration-choreography-qa) on the considerations of choosing between choreography and orchestration.

 <!-- links -->

[competing-consumers]: ../../patterns/competing-consumers.yml
[minimize-coordination]: ../design-principles/minimize-coordination.yml
