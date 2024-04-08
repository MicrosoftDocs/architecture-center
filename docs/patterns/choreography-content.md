Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control.

## Context and problem

In microservices architecture, it's often the case that a cloud-based application is divided into several small services that work together to process a business transaction end-to-end. To lower coupling between services, each service is responsible for a single business operation. Some benefits include faster development, smaller code base, and scalability. However, designing an efficient and scalable workflow is a challenge and often requires complex interservice communication.

The services communicate with each other by using well-defined APIs. Even a single business operation can result in multiple point-to-point calls among all services. A common pattern for communication is to use a centralized service that acts as the orchestrator. It acknowledges all incoming requests and delegates operations to the respective services. In doing so, it also manages the workflow of the entire business transaction. Each service just completes an operation and is not aware of the overall workflow.

The orchestrator pattern reduces point-to-point communication between services but has some drawbacks because of the tight coupling between the orchestrator and other services that participate in processing of the business transaction. To execute tasks in a sequence, the orchestrator needs to have some domain knowledge about the responsibilities of those services. If you want to add or remove services, existing logic will break, and you'll need to rewire portions of the communication path. While you can configure the workflow, add or remove services easily with a well-designed orchestrator, such an implementation is complex and hard to maintain.

![Processing a request using a central orchestrator](./_images/orchestrator.png)

## Solution

Let each service decide when and how a business operation is processed, instead of depending on a central orchestrator.

One way to implement choreography is to use the [asynchronous messaging pattern](./publisher-subscriber.yml) to coordinate the business operations.

![Processing a request using a choreographer](./_images/choreography-pattern.png)

A client request publishes messages to a message queue. As messages arrive, they are pushed to subscribers, or services, interested in that message. Each subscribed service does their operation as indicated by the message and responds to the message queue with success or failure of the operation. In case of success, the service can push a message back to the same queue or a different message queue so that another service can continue the workflow if needed. If an operation fails, the message bus can retry that operation.

This way, the services choreograph the workflow among themselves without depending on an orchestrator or having direct communication between them.

Because there isn't point-to-point communication, this pattern helps reduce coupling between services. Also, it can remove the performance bottleneck caused by the orchestrator when it has to deal with all transactions.

## When to use this pattern

Use the choreography pattern if you expect to update or replace services frequently, and add or remove some services eventually. The entire app can be modified with less effort and minimal disruption to existing services.

Consider this pattern if you experience performance bottlenecks in the central orchestrator.

This pattern is a natural model for the serverless architecture where all services can be short lived, or event driven. Services can spin up because of an event, do their task, and are removed when the task is finished.

## Issues and considerations

Decentralizing the orchestrator can cause issues while managing the workflow.

If a service fails to complete a business operation, it can be difficult to recover from that failure. One way is to have the service indicate failure by firing an event. Another service subscribes to those failed events takes necessary actions such as applying [compensating transactions](./compensating-transaction.yml) to undo successful operations in a request. The failed service might also fail to fire an event for the failure. In that case, consider using a retry and, or time out mechanism to recognize that operation as a failure. For an example, see the [Example](#example) section.

It's simple to implement a workflow when you want to process independent business operations in parallel. You can use a single message bus. However, the workflow can become complicated when choreography needs to occur in a sequence. For instance, Service C can start its operation only after Service A and Service B have completed their operations with success. One approach is to have multiple message buses or queues that get messages in the required order. For more information, see the [Example](#example) section.

T he choreography pattern becomes a challenge if the number of services grow rapidly. Given the high number of independent moving parts, the workflow between services tends to get complex. Also, distributed tracing becomes difficult.

The orchestrator centrally manages the resiliency of the workflow and it can become a single point of failure. On the other hand, for choreography, the role is distributed between all services and resiliency becomes less robust.

Each service isn't only responsible for the resiliency of its operation but also the workflow. This responsibility can be burdensome for the service and hard to implement. Each service must retry transient, nontransient, and time-out failures, so that the request terminates gracefully, if needed. Also, the service must be diligent about communicating the success or failure of the operation so that other services can act accordingly.

## Workload design

An architect should evaluate how the Choreography pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | Because the distributed components in this pattern are autonomous and designed to be replaceable, you can modify the workload with less overall change to the system.<br/><br/> - [OE:04 Tools and processes](/azure/well-architected/operational-excellence/tools-processes) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | This pattern provides an alternative when performance bottlenecks occur in a centralized orchestration topology.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

This example shows the choreography pattern by creating an event driven, cloud native workload running functions along with microservices. When a client requests a package to be shipped, the workload assigns a drone. Once the package is ready to pick up by the scheduled drone, the delivery process gets started. While in-transit the workload handles the delivery until it gains the shipped status.

![GitHub logo](../_images/github.png) The code example of this pattern is available on [GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/choreography).

This example is a refactoring of the [Drone Delivery implementation](https://github.com/mspnp/microservices-reference-implementation) that replaces the Orchestrator pattern with the Choreography pattern.

![An event driven cloud native example workload implementing choreography pattern](./_images/choreography-example.png)

The Ingestion service handles the client requests and convert them into messages including the delivery details. Business transaction are initiated after consuming those new messages.

A single client business transaction requires three distinct business operations: creating or updating a package, assigning a drone to deliver the package, and the proper handling of the delivery that consists of checking and eventually raising awareness when shipped. Three microservices perform the business processing: Package, Drone Scheduler, and Delivery services. Instead of a central orchestrator, the services use messaging to communicate among themselves. Each service would be responsible to implement a protocol in advance that coordinates in a decentralized way the business workflow.

### Design

The business transaction is processed in a sequence through multiple hops. Each hop is sharing a single message bus among all the business services.

When a client sends a delivery request through an HTTP endpoint, the Ingestion service receives it, converts such request into a message, and then publishes the message to the shared message bus. The subscribed business services are going to be consuming new messages added to the bus. On receiving the message, the business services can complete the operation with success, failure, or the request can time out. If successful, the services respond to the bus with the Ok status code, raises a new operation message, and sends it to the message bus. If there's a failure or time-out, the service reports failure by sending the reason code to the message bus. Additionally, the message is going to be dead lettered for later handling. Messages that couldn't be received or processed within a reasonable and appropriate amount of time are moved the DLQ as well.

The design uses multiple message buses to process the entire business transaction. [Microsoft Azure Service Bus](/azure/service-bus-messaging) and [Microsoft Azure Event Grid](/azure/event-grid/) are composed to provide with the messaging service platform for this design. The workload is deployed on [Azure Container Apps](/azure/container-apps/) hosting [Azure Functions](/azure/azure-functions/functions-container-apps-hosting/) for ingestion, and apps handling [event-driven processing](/azure/container-apps/scale-app?pivots=azure-cli#custom) that executes the business logic.

The design ensures the choreography to occur in a sequence. A single Azure Service Bus namespace contains a topic with two subscriptions and a session-aware queue. The Ingestion service publishes messages to the topic. The Package service and Drone Scheduler service subscribe to the topic and publish messages communicating the success to the queue. Including a common session idendtifier which a GUID associated to the delivery identifier, enables the ordered handling of unbounded sequences of related messages. The Delivery service awaits two related messages per transaction. The first message indicates the package is ready to be shipped, and the second signals that a drone is scheduled.

This design uses Azure Service Bus to handle high-value messages that can't be lost or duplicated during the entire delivery process. When the package is shipped, it's also published a change of state to Azure Event Grid. In this design, the event sender has no expectation about how the change of state is handled. Downstream organization services that arenot included as part of this design could be listening to this event type, and react executing specific business purpose logic (that is, email the shipped order status to the user).

> If you are planning to deploy this into another compute service such as [AKS](/azure/aks/) pub-sub pattern application boilplate could be implemented with [two containers in the same pod](https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/#creating-a-pod-that-runs-two-containers). One container runs the [ambassador](./ambassador.yml) that interacts with your message bus of preference while the another executes the business logic. The approach with two containers in the same pod improves performance and scalability. The ambassador and the business service share the same network allowing for low latency and high throughput.

To avoid cascading retry operations that might lead to multiple efforts, business services should immediately flag unacceptable messages. It's possible to enrich such messages using well-known reason codes or a defined application code, so it can be moved to a [dead letter queue (DLQ)](/azure/service-bus-messaging/service-bus-dead-letter-queues). Consider managing consistency issues implementing [Saga](/azure/architecture/reference-architectures/saga/saga) from downstream services. For example, another service could handle dead lettered messages for remediation purposes only by executing a compensation, rety or pivot transaction.

The business services are idempotent to make sure retry operations don't result in duplicate resources. For example, the Package service uses upsert operations to add data to the data store.

## Related resources

Consider these patterns in your design for choreography.

- Modularize the business service by using the [ambassador design pattern](./ambassador.yml).

- Implement [queue-based load leveling pattern](./queue-based-load-leveling.yml) to handle spikes of the workload.

- Use asynchronous distributed messaging through the [publisher-subscriber pattern](./publisher-subscriber.yml).

- Use [compensating transactions](./compensating-transaction.yml) to undo a series of successful operations in case one or more related operations fail.

- For information about using a message broker in a messaging infrastructure, see [Asynchronous messaging options in Azure](../guide/technology-choices/messaging.yml).

- [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services)
