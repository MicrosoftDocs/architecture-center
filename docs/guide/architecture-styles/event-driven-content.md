An event-driven architecture consists of event producers that generate a stream of events, event consumers that listen for these events, and event channels that transfer events from producers to consumers.

![Diagram that shows an event-driven architecture style.](./images/event-driven.svg)

Events are delivered in near real time, so consumers can respond immediately to events as they occur. Producers are decoupled from consumers. A producer doesn't know which consumers are listening. Consumers are also decoupled from each other, and every consumer sees all of the events. This differs from a [Competing Consumers pattern][competing-consumers] where consumers pull messages from a queue and a message is processed only one time, assuming that there are no errors. In some systems, such as Azure Internet of Things (IoT), events must be ingested at very high volumes.

An event-driven architecture can use a [publish-subscribe model](/azure/architecture/patterns/publisher-subscriber) or an event stream model.

- **Publish-subscribe:** The publish-subscribe messaging infrastructure tracks subscriptions. When an event is published, it sends the event to each subscriber. An event can't be replayed after it's received and new subscribers don't see the event.

- **Event streaming:** Events are written to a log. Events are strictly ordered within a partition and are durable. Clients don't subscribe to the stream. Instead, a client can read from any part of the stream. The client is responsible for advancing their position in the stream. That means a client can join at any time and can replay events.

On the consumer side, there are some typical variations:

- **Simple event processing:** An event immediately triggers an action in the consumer. For example, you can use Azure Functions with an Azure Service Bus trigger, so that a function runs whenever a message is published to a Service Bus topic.

- **Basic event correlation:** A consumer needs to process a few discrete business events that are usually correlated by some identifier and persist some information from earlier events to use when they process later events. This pattern is supported by libraries like [NServiceBus](https://docs.particular.net/tutorials/nservicebus-sagas/1-saga-basics/) and [MassTransit](https://masstransit.io/documentation/configuration/sagas/overview).

- **Complex event processing:** A consumer uses a technology like Azure Stream Analytics to analyze a series of events and identify patterns in the event data. For example, you can aggregate readings from an embedded device over a time window, and generate a notification if the moving average crosses a certain threshold.

- **Event stream processing:** Use a data streaming platform, such as Azure IoT Hub or Apache Kafka, as a pipeline to ingest events and feed them to stream processors. The stream processors act to process or transform the stream. There might be multiple stream processors for different subsystems of the application. This approach is a good fit for IoT workloads.

The source of the events might be external to the system, such as physical devices in an IoT solution. In that case, the system must be able to ingest the data at the volume and throughput that the data source requires.

There are two primary approaches to structure event payloads. When you have control over your event consumers, you can decide on the payload structure for each consumer. This strategy allows you to mix approaches as needed within a single workload.

- **Include all required attributes in the payload:** Use this approach when you want consumers to have all available information without the need to query an external data source. However, it can lead to data consistency issues due to multiple [systems of record](https://wikipedia.org/wiki/System_of_record), specifically after updates. Contract management and versioning can also become complex.

- **Include keys in the payload only:** In this approach, consumers retrieve the necessary attributes, such as a primary key, to independently fetch the remaining data from a data source. This method provides better data consistency because it has a single system of record. However, it can perform poorer than the first approach because consumers must query the data source frequently. There are fewer concerns regarding coupling, bandwidth, contract management, or versioning because events are smaller and contracts simpler.

In the preceding logical diagram, each type of consumer is shown as a single box. To avoid having the consumer become a single point of failure in system, it's typical to have multiple instances of a consumer. Multiple instances might also be required to handle the volume and frequency of events. Also, a single consumer can process events on multiple threads. This can create challenges if events must be processed in order or require exactly-once semantics. For more information, see [Minimize coordination][minimize-coordination].

Many event-driven architectures have two topologies:

- **Broker topology:** Components broadcast occurrences as events to the entire system. Other components either act on the event or ignore the event. This topology is useful when the event processing flow is relatively simple. There's no central coordination or orchestration, so this topology can be dynamic. This topology is highly decoupled, which helps provide scalability, responsiveness, and component fault tolerance. No component owns or is aware of the state of any multistep business transaction, and actions are taken asynchronously. Subsequently, distributed transactions are risky because there's no native means to be restarted or replayed. Error handling and manual intervention strategies need to be carefully considered because this topology can be a source of data inconsistency.

- **Mediator topology:** This topology addresses some of the shortcomings of broker topology. There's an event mediator that manages and controls the flow of events. The event mediator maintains the state and manages error handling and restart capabilities. Unlike broker topology, components broadcast occurrences as commands and only to designated channels. These channels are usually message queues. These commands aren't expected to be ignored by their consumers. This topology provides more control, better distributed error handling, and potentially better data consistency. This topology does introduce increased coupling between components, and the event mediator can become a bottleneck or a reliability concern.

## When to use this architecture

- Multiple subsystems must process the same events.
- Real-time processing with minimum time lag.
- Complex event processing, such as pattern matching or aggregation over time windows.
- High volume and high velocity of data, such as IoT.

## Benefits

- Producers and consumers are decoupled.
- No point-to-point integrations. It's easy to add new consumers to the system.
- Consumers can respond to events immediately as they arrive.
- Highly scalable, elastic, and distributed.
- Subsystems have independent views of the event stream.

## Challenges

- Guaranteed delivery.

  In some systems, especially in IoT scenarios, it's crucial to guarantee that events are delivered.

- Processing events in order or exactly once.

  For resiliency and scalability, each consumer type typically runs in multiple instances. This can create a challenge if the events must be processed in order (within a consumer type), or [idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing) logic isn't implemented.

- Coordinating messages across services.

  Business processes often have multiple services publishing and subscribing to messages to achieve a consistent outcome across a whole workload. You can use [workflow patterns](https://docs.particular.net/architecture/workflows) such as the [Choreography pattern](/azure/architecture/patterns/choreography) and [Saga Orchestration](/azure/architecture/reference-architectures/saga/saga#orchestration) to reliably manage message flows across various services.

- Handling errors.

  Event-driven architecture mainly uses asynchronous communication. A challenge with asynchronous communication is error handling. One way to address this issue is to use a separate error-handler processor. So, when the event consumer experiences an error, it immediately and asynchronously sends the erroneous event to the error-handler processor and moves on. The error-handler processor tries to fix the error and sends the event back to the original ingestion channel. But if the error-handler processor fails, then it can send the erroneous event to an administrator for further inspection. If you use an error-handler processor, erroneous events will be processed out of sequence when they're resubmitted.

- Losing data.

  Another challenge with asynchronous communication is data loss. If any of the components crashes before successfully processing and handing over the event to its next component, then the event is dropped and never makes it into the final destination. To minimize the chance of data loss, persist in-transit events and remove or dequeue the events only when the next component has acknowledged the receipt of the event. These features are usually known as _client acknowledge mode_ and _last participant support_.

- Implementing a traditional request-response pattern.

  Sometimes, the event producer requires an immediate response from the event consumer, such as obtaining a customer eligibility before proceeding with an order. In an event-driven architecture, synchronous communication can be achieved by using [request-response messaging](https://www.enterpriseintegrationpatterns.com/patterns/messaging/RequestReply.html).

  This pattern is usually implemented by a request queue and a response queue. The event producer sends an asynchronous request to a request queue, pauses other operations on that task, and awaits a response in the reply queue. This approach effectively turns this into a synchronous process. Event consumers then process the request and send the reply back through a response queue. This approach usually uses a session ID for tracking, so the event producer knows which message in the response queue is related to the specific request. The original request can also specify the name of the response queue, potentially ephemeral, in a [reply-to header](/dotnet/api/azure.messaging.servicebus.servicebusmessage.replyto) or another mutually agreed-upon custom attribute.

- Maintaining the appropriate number of events.

  Generating an excessive number of fine-grained events can saturate and overwhelm the system, making it difficult to effectively analyze the overall flow of events. This issue is exacerbated when changes need to be rolled back. Conversely, overly consolidating events can also create problems, resulting in unnecessary processing and responses from event consumers.

  To achieve the right balance, consider the consequences of events and whether consumers need to inspect the event payloads to determine their responses. For instance, if you have a compliance check component, it might be sufficient to publish only two types of events: *compliant* and *noncompliant*. This approach allows each event to be processed only by relevant consumers, preventing unnecessary processing.
  
### Other considerations

- The amount of data to include in an event can be a significant consideration that affects both performance and cost. Putting all the relevant information needed for processing in the event itself can simplify the processing code and save additional lookups. Putting the minimal amount of information in an event, like just a couple of identifiers, will reduce transport time and cost, but requires the processing code to look up any additional information it needs. For more information on this, take a look at [this blog post](https://particular.net/blog/putting-your-events-on-a-diet).

- While a request is only visible to the request-handling component, events are often visible to multiple components in a workload, even if those components don't or aren't meant to consume them. Operating with an "assume breach" mindset, be mindful of what information you include in events to prevent unintended information exposure.

- Many applications use event-driven architecture as their primary architecture. You can combine this approach with other architectural styles to create a hybrid architecture. Typical combinations include [microservices](./microservices.yml) and [pipes and filters](../../patterns/pipes-and-filters.yml). Integrating event-driven architecture enhances system performance by eliminating bottlenecks and providing [back pressure](https://wikipedia.org/wiki/Back_pressure) during high request volumes.

- [Specific domains](../../microservices/model/domain-analysis.md) often span multiple event producers, consumers, or event channels. Changes to a particular domain might affect many components.

## Related resources

- [Community discussion video](https://particular.net/webinars/2023-orchestration-choreography-qa) on the considerations of choosing between choreography and orchestration.

 <!-- links -->

[competing-consumers]: ../../patterns/competing-consumers.yml
[minimize-coordination]: ../design-principles/minimize-coordination.yml
