The messaging bridge design pattern integrates systems built on top of different messaging infrastructures.

## Context and problem

Many organizations and workloads can inadvertently have IT systems that use multiple messaging infrastructures like Microsoft Message Queueing (MSMQ), RabbitMQ, Azure Service Bus, and Amazon SQS. This problem can occur due to mergers, acquisitions, or due to extending current on-premises systems to cloud-hosted components for cost-effectiveness and the ease of maintenance.

Developers might address this challenge by modifying the systems being integrated to communicate by using HTTP-based web services. However, this approach has drawbacks, including:

- The systems must be modified by adding an HTTP client on one side and an HTTP request handler on the other. The systems must then be retested and redeployed.
- HTTP endpoints must be hosted, adding to the complexity for making these services more secure and available.
- An implementation of this pattern is prone to network connectivity problems, requiring custom-built retry mechanisms.

## Solution

If the systems being integrated consist of components that communicate by exchanging messages, the messaging bridge pattern solves the integration problem and mitigates the noted drawbacks.

In this scenario, each system connects to one messaging infrastructure. To integrate them, introduce a bridge component that's able to connect to two or more messaging infrastructures at the same time. The bridge pulls messages from one and pushes them to the other without changing the payload.

The systems being integrated don't need to know about the others or the bridge. The sender system is configured to send specific messages to a designated queue. The bridge picks up the messages and forwards them to another queue in a different messaging infrastructure where the receiver system picks them up.

### Benefits

- The systems being integrated via the messaging bridge don't have to be modified. Ideally, the endpoints aren't aware that the messages are bridged.
- The integration is more reliable compared to the HTTP alternative due to the at-least-once message delivery mechanism guarantee.
- Migration scenarios can be more flexible. For example, endpoints can be migrated from one messaging infrastructure to another as the schedule permits instead of all-at-once.

### Drawbacks

- Advanced features of one or both messaging technologies might not be available on the bridged route.
- The bridged route needs to consider both technologies' limitations. For example, the maximum message size might be 4 MB on MSMQ but only 64 KiB on Azure Storage Queues.

## Issues and considerations

Consider the following points when implementing the messaging bridge pattern:

- If one of the integrated systems relies on distributed transactions, for example Microsoft Distributed Transaction Coordinator (DTC), for correctness, a deduplication mechanism must be put in place in the bridge.

- If one of the systems being integrated doesn't use any messaging infrastructure and can't be modified, the messaging bridge might be built between the infrastructure used by the other system and a SQL server-emulated queue. The legacy system can be made to send messages by using [Change data capture](/sql/relational-databases/track-changes/about-change-data-capture-sql-server) for the SQL server to push its changes to a dedicated queue-table. The bridge can take these messages and forward them to the actual messaging infrastructure.

- You can use a single queue in each messaging infrastructure, designated as *bridging queue*. In this topology, the sending system must be configured to use that specific queue as the destination for message types that are sent to the other system. You can also use multiple pairs of queues in each messaging infrastructure to allow the sender to be unaware of the bridge. A *shadow queue* is created for each destination queue in the destination system's messaging infrastructure. The bridge is responsible for forwarding messages between the shadow queues and their counterparts.

- In order to meet desired availability SLAs, the messaging bridge might need to be scaled-out by using the [Competing consumers](./competing-consumers.yml) approach.

- Regular message-processing components use a [Retry](./retry.yml) pattern to cope with transient failures. The retry counter limit allows them to detect *poison* messages and remove them from the queue to unblock processing. The bridge might require a different retry policy to prevent falsely identifying messages as poison if an infrastructure failure occurs, possibly involving a [Circuit breaker](./circuit-breaker.yml) to pause forwarding.

## When to use this pattern

Use the messaging bridge pattern when you need to:

- Integrate existing systems with minimal need for modification.
- Integrate legacy applications that can't be changed to use other messaging technologies.
- Extend existing on-premises applications with cloud-hosted components.
- Connect geo-distributed systems when the internet connection isn't stable.
- Migrate a single distributed system from one messaging infrastructure to another incrementally without the need to migrate the whole system in one effort.

This pattern might not be suitable if:

- At least one of the systems involved relies on a specific feature of one messaging infrastructure not present in the other.
- Integration is synchronous in nature; the initiating system requires immediate response.
- Integration has specific functional or nonfunctional requirements, such as security or privacy concerns.
- The volume of data for the integration exceeds the capacity of the messaging system or makes messaging not a cost-effective solution to the problem.

## Example

There's an application written in a .NET framework for managing employee scheduling hosted on-premises. The application is well-structured with separate components communicating via MSMQ. The application works, and the workload team has no intention of rewriting it. A new consumer of the scheduling data needs to be built to meet a business need, and the IT strategy calls for building new software as cloud-native applications to optimize the costs and delivery time.

Since the asynchronous queue-based architecture worked for the workload team in the past, the team is going to use the same architectural approach but with the modern technology, Service Bus. The workload team doesn't want to introduce synchronous communication between the cloud and the on-premises deployment to mitigate the latency or unavailability of one impacting the other.

A decision is made to use the messaging bridge pattern to connect the two systems. It consists of two parts. One part receives messages from the existing MSMQ queue and forwards them to Service Bus. The other part does the opposite and takes messages from the Service Bus and forwards them to the existing MSMQ queue.

:::image type="content" source="./_images/messaging-bridge-patterns.png" alt-text="Diagram of the messaging bridge integrating MSMQ and Service Bus." lightbox="./_images/messaging-bridge-patterns.png" border="false":::

When the implementation team uses this approach, they utilize existing infrastructure in the existing application to integrate with the new components. The existing application isn't aware that the new components are hosted in Azure. Similarly, the new components communicate with the legacy application in the same way as they communicate between themselves, by sending Service Bus messages. The bridge forwards messages between the two systems.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Rob Bagby](https://www.linkedin.com/in/robbagby) | Principal Architecture Content Lead
- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Bryan Lamos](https://www.linkedin.com/in/bryanlamos) | Developer Relations

Other contributors:

- [Kyle Baley](https://www.linkedin.com/in/kylebaley) | Software Engineer
- [Udi Dahan](https://www.linkedin.com/in/udidahan) | Founder & CEO
- [Szymon Pobiega](https://www.linkedin.com/in/szymonpobiega) | Engineer

## Next steps

- [Messaging bridge pattern description](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingBridge.html) from the enterprise integration patterns community.
- Learn how to implement a [messaging bridge](https://docs.spring.io/spring-integration/docs/current/reference/html/bridge.html) in the Spring Java framework.
- [QPid bridge](https://openmama.finos.org/openmama_qpid_bridge.html) can be used to bridge AMQP-enabled messaging technologies.
- [NServiceBus messaging bridge](https://docs.particular.net/nservicebus/bridge) is a .NET implementation of a queue-to-queue bridge that supports a range of messaging infrastructures including MSMQ, Service Bus, and Queue Storage.
- [Router](https://github.com/SzymonPobiega/NServiceBus.Router) is an open source project that implements the messaging bridge pattern. It also allows bridging more than two technologies in a single instance, and has advanced message routing capabilities.

## Related resources

- [Competing consumers](./competing-consumers.yml) ensures the implementation of the messaging bridge can cope with the load.
- [Retry](./retry.yml) allows the messaging bridge handle transient failures.
- [Circuit breaker](./circuit-breaker.yml) conserves resources when either side of the bridge is experiencing downtime.
