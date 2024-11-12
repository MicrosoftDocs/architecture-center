An event-driven architecture consists of **event producers** that generate a stream of events, **event consumers** that listen for these events, and **event channels** that transfer events from producers to consumers.

![Diagram of an event-driven architecture style](./images/event-driven.svg)

Events are delivered in near real time, so consumers can respond immediately to events as they occur. Producers are decoupled from consumers &mdash; a producer doesn't know which consumers are listening. Consumers are also decoupled from each other, and every consumer sees all of the events. This differs from a [Competing Consumers][competing-consumers] pattern, where consumers pull messages from a queue and a message is processed just once (assuming no errors). In some systems, such as IoT, events must be ingested at very high volumes.

An event driven architecture can use a [publish/subscribe](/azure/architecture/patterns/publisher-subscriber) (also called *pub/sub*) model or an event stream model.

- **Pub/sub**: The messaging infrastructure keeps track of subscriptions. When an event is published, it sends the event to each subscriber. After an event is received, it can't be replayed, and new subscribers don't see the event.

- **Event streaming**: Events are written to a log. Events are strictly ordered (within a partition) and durable. Clients don't subscribe to the stream, instead a client can read from any part of the stream. The client is responsible for advancing its position in the stream. That means a client can join at any time, and can replay events.

On the consumer side, there are some common variations:

- **Simple event processing**. An event immediately triggers an action in the consumer. For example, you could use Azure Functions with a Service Bus trigger, so that a function executes whenever a message is published to a Service Bus topic.

- **Basic event correlation**. A consumer needs to process a small number of discrete business events, usually correlated by some identifier, persisting some information from earlier events to use when processing later events. This pattern is supported by libraries like [NServiceBus](https://docs.particular.net/tutorials/nservicebus-sagas/1-saga-basics/) and [MassTransit](https://masstransit.io/documentation/configuration/sagas/overview).

- **Complex event processing**. A consumer processes a series of events, looking for patterns in the event data, using a technology such as Azure Stream Analytics. For example, you could aggregate readings from an embedded device over a time window, and generate a notification if the moving average crosses a certain threshold.

- **Event stream processing**. Use a data streaming platform, such as Azure IoT Hub or Apache Kafka, as a pipeline to ingest events and feed them to stream processors. The stream processors act to process or transform the stream. There may be multiple stream processors for different subsystems of the application. This approach is a good fit for IoT workloads.

The source of the events may be external to the system, such as physical devices in an IoT solution. In that case, the system must be able to ingest the data at the volume and throughput that is required by the data source.

There are two primary approaches to structuring event payloads:

- **Including all required attributes in the payload**: This approach is used when you want consumers to have all available information without the need to query an external data source. However, it can lead to data consistency issues due to multiple [systems of record](https://wikipedia.org/wiki/System_of_record), particularly after updates. Contract management and versioning can also become complex.

- **Including only key(s) in the payload**: In this approach, consumers retrieve the necessary attributes, such as a primary key, to independently fetch the remaining data from a data source. While this method offers better data consistency due to a single system of record, it can perform poorer than the first approach since consumers must query the data source frequently. There are fewer concerns regarding coupling, bandwidth, contract management, or versioning, as events are smaller and contracts simpler.

Please note that the above options are not binary choices but rather two ends of a spectrum. You may need to adjust your payload according to the needs of event consumers. For events within a bounded context (also known as [domain events](https://learn.microsoft.com/azure/architecture/microservices/model/tactical-ddd)), consider including IDs and selectively adding the required attributes. For events across bounded contexts (also known as [integration events](https://learn.microsoft.com/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/domain-events-design-implementation#domain-events-versus-integration-events)), it may be beneficial to include all potentially required attributes in the payload.

In the logical diagram above, each type of consumer is shown as a single box. In practice, it's common to have multiple instances of a consumer, to avoid having the consumer become a single point of failure in system. Multiple instances might also be necessary to handle the volume and frequency of events. Also, a single consumer might process events on multiple threads. This can create challenges if events must be processed in order or require exactly-once semantics. See [Minimize Coordination][minimize-coordination].

There are two primary topologies within many event-driven architectures:

- **Broker topology**. Components broadcast occurrences as events to the entire system, and other components either act upon the event or just ignore the event. This topology is useful when the event processing flow is relatively simple. There is no central coordination or orchestration, so this topology can be very dynamic. This topology is highly decoupled, which helps provide scalability, responsiveness, and component fault tolerance. No component owns or is aware of the state of any multistep business transaction, and actions are taken asynchronously. Subsequently, distributed transactions are risky because there is no native means to be restarted or replayed. Error handling and manual intervention strategies need to be carefully considered because this topology can be a source of data inconsistency.

- **Mediator topology**. This topology addresses some of the shortcomings of broker topology. There is an event mediator that manages and controls the flow of events. The event mediator maintains the state and manages error handling and restart capabilities. Unlike broker topology, components broadcast occurrences as commands and only to designated channels, usually message queues. These commands aren't expected to be ignored by their consumers. This topology offers more control, better distributed error handling, and potentially better data consistency. This topology does introduce increased coupling between components, and the event mediator could become a bottleneck or a reliability concern.

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

  Each consumer type typically runs in multiple instances, for resiliency and scalability. This can create a challenge if the events must be processed in order (within a consumer type), or [idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing) logic isn't implemented.

- Coordinating messages across services.

  Business processes often involve multiple services publishing and subscribing to messages to achieve a consistent outcome across a whole workload. [Workflow patterns](https://docs.particular.net/architecture/workflows) such as the [Choreography pattern](/azure/architecture/patterns/choreography) and [Saga Orchestration](/azure/architecture/reference-architectures/saga/saga#orchestration) can be used to reliably manage message flows across various services.

- Error handling.

  Event-driven architecture uses mainly asynchronous communication. A challenge with asynchronous communication is error handling. One way to address this issue is to use a separate error-handler processor. So, when the event consumer experiences an error, it immediately and asynchronously sends the erroneous event to the error-handler processor and moves on. The error-handler processor tries to fix the error and sends the event back to the original ingestion channel. But if the error-handler processor fails, then it can send the erroneous event to an administrator for further inspection. If you use an error-handler processor, erroneous events will be processed out of sequence when they are resubmitted.

- Data loss.

  Another challenge with asynchronous communication is data loss. If any of the components crashes before successfully processing and handing over the event to its next component, then the event is dropped and never makes it into the final destination. To minimize the chance of data loss, persist in-transit events and remove or dequeue the events only when the next component has acknowledged the receipt of the event. These features are usually known as _client acknowledge mode_ and _last participant support_.

- Implementing a traditional request-response pattern.

  Sometimes, the event producer requires an immediate response from the event consumer, such as obtaining a customer eligibility before proceeding with an order. In event-driven architecture, synchronous communication can be achieved through [request-response messaging](https://www.enterpriseintegrationpatterns.com/patterns/messaging/RequestReply.html).

  This pattern is usually implemented by utilizing multiple queues - a request queue and a response queue. The event producer sends an asynchronous request to a request queue, pauses other operation on that task, and awaits a response in the reply queue; effectively turning this into a synchronous process. Event consumers then process the request and send the reply back through a response queue. This approach usually utilizes a session ID for tracking, so the event producer knows which message in the response queue is related to the specific request. The original request could also specify the name of the response queue, potentially ephemeral, in a [reply-to header](/dotnet/api/azure.messaging.servicebus.servicebusmessage.replyto) or another mutually agreed-upon custom attribute.

- Maintaining the appropriate number of events.

  Generating an excessive number of fine-grained events can saturate and overwhelm the system, making it difficult to effectively analyze the overall flow of events. This issue is exacerbated when changes need to be rolled back. Conversely, overly consolidating events can also create problems, resulting in unnecessary processing and responses from event consumers.

  To achieve the right balance, consider the consequences of events and whether consumers need to inspect the event payloads to determine their responses. For instance, if you have a compliance check component, it may be sufficient to publish only two types of events: *compliant* and *non-compliant*. This approach allows each event to be processed only by relevant consumers, preventing unnecessary processing.
  
### Additional considerations

- The amount of data to include in an event can be a significant consideration that affects both performance and cost. Putting all the relevant information needed for processing in the event itself can simplify the processing code and save additional lookups. Putting the minimal amount of information in an event, like just a couple of identifiers, will reduce transport time and cost, but requires the processing code to look up any additional information it needs. For more information on this, take a look at [this blog post](https://particular.net/blog/putting-your-events-on-a-diet).
- While a request is only visible to the request-handling component, events are often visible to multiple components in a workload, even if those components don't or aren't meant to consume them. Operating with an "assume breach" mindset, be mindful of what information you include in events to prevent unintended information exposure.
- Many applications use event-driven architecture as their primary architecture; however, this approach can be combined with other architectural styles, resulting in hybrid architectures. Common combinations include [microservices](./microservices.yml) and [pipes and filters](../../patterns/pipes-and-filters.yml). Integrating event-driven architecture enhances system performance by eliminating bottlenecks and providing [back pressure](https://wikipedia.org/wiki/Back_pressure) during high request volumes.
- [Specific domains](../../microservices/model/domain-analysis.md) often span multiple event producers, consumers, or event channels. Changes to a particular domain might impact many components.

## Related resources

-  [Community discussion video](https://particular.net/webinars/2023-orchestration-choreography-qa) on the considerations of choosing between choreography and orchestration.

 <!-- links -->

[competing-consumers]: ../../patterns/competing-consumers.yml
[minimize-coordination]: ../design-principles/minimize-coordination.yml
