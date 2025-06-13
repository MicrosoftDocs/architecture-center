This article describes the Messaging Bridge pattern, which is a technique that you can use to integrate disparate systems that are built on top of different messaging infrastructures.

## Context and problem

Many organizations and workloads can inadvertently have IT systems that use multiple messaging infrastructures like Microsoft Message Queueing (MSMQ), RabbitMQ, Azure Service Bus, and Amazon SQS. This problem can occur due to mergers, acquisitions, or due to extending current on-premises systems to cloud-hosted components for cost-effectiveness and the ease of maintenance.

Developers might address this challenge by modifying the systems being integrated to communicate by using HTTP-based web services. However, this approach has drawbacks, including:

- The systems must be modified by adding an HTTP client on one side and an HTTP request handler on the other. The systems must then be retested and redeployed.
- HTTP endpoints must be hosted, which adds complexity when you make web services secure and highly available.
- Frequent network connectivity problems that require custom-built retry mechanisms.

## Solution

If the systems being integrated consist of components that communicate by exchanging messages, the Messaging Bridge pattern improves integration and mitigates drawbacks.

In this scenario, each system connects to one messaging infrastructure. To integrate across different messaging infrastructures, introduce a bridge component that connects to two or more messaging infrastructures at the same time. The bridge pulls messages from one and pushes them to the other without changing the payload.

The systems being integrated don't need to recognize the others or the bridge. The sender system is configured to send specific messages to a designated queue on its native messaging infrastructure. The bridge picks up those messages and forwards them to another queue in a different messaging infrastructure where the receiver system picks them up.

### Benefits

- The systems being integrated via the Messaging Bridge don't have to be modified. Ideally, the endpoints aren't aware that the messages are bridged.
- The integration is more reliable compared to the HTTP alternative due to the at-least-once message delivery mechanism guarantee.
- Migration scenarios can be more flexible. For example, endpoints can be migrated from one messaging infrastructure to another as the schedule permits instead of all at once.

### Drawbacks

- Advanced features of one or both messaging technologies might not be available on the bridged route.
- The bridged route needs to consider both technologies' limitations. For example, the maximum message size might be 4 MB in MSMQ but only 64 KB in Azure Storage queues.

## Issues and considerations

Consider the following points when implementing the Messaging Bridge pattern:

- If one of the integrated systems relies on distributed transactions, for example Microsoft Distributed Transaction Coordinator (DTC), for correctness, you must implement a deduplication mechanism in the bridge.

- If one of the systems being integrated doesn't use any messaging infrastructure and can't be modified, you can build the Messaging Bridge between the infrastructure that's used by the other system and a SQL Server-emulated queue. The legacy system can send messages by using the [change data capture](/sql/relational-databases/track-changes/about-change-data-capture-sql-server) feature for SQL Server to push its changes to a dedicated queue table. The bridge can forward these messages to the actual messaging infrastructure.

- You can use a single queue in each messaging infrastructure, designated as the *bridging queue*. In this topology, configure the sending system to use that specific queue as the destination for message types that are sent to the other system. You can also use multiple pairs of queues in each messaging infrastructure, so the sender is unaware of the bridge. A *shadow queue* is created for each destination queue in the destination system's messaging infrastructure. The bridge forwards messages between the shadow queues and their counterparts.

- In order to meet the desired availability service-level agreements (SLAs), you might need to scale out the Messaging Bridge by using the [Competing consumers](./competing-consumers.yml) approach.

- Regular message-processing components use the [Retry pattern](./retry.yml) to handle transient failures. The retry counter limit enables components to detect *poison* messages and remove them from the queue to unblock processing. The bridge might require a different retry policy to prevent falsely identifying messages as poison if an infrastructure failure occurs. You might use the [Circuit Breaker](./circuit-breaker.md) pattern to pause forwarding.

## When to use this pattern

Use the Messaging Bridge pattern when you need to:

- Integrate existing systems with minimal need for modification.
- Integrate legacy applications that can't use other messaging technologies.
- Extend existing on-premises applications with cloud-hosted components.
- Connect geo-distributed systems when the internet connection isn't stable.
- Migrate a single distributed system from one messaging infrastructure to another incrementally without the need to migrate the whole system in one effort.

This pattern might not be suitable if:

- At least one of the systems involved relies on a feature of one messaging infrastructure that isn't present in the other.
- Integration is synchronous in nature, and the initiating system requires immediate response.
- Integration has specific functional or nonfunctional requirements, such as security or privacy concerns.
- The volume of data for the integration exceeds the capacity of the messaging system or makes messaging an expensive solution to the problem.

## Workload design

An architect should evaluate how the Messaging Bridge pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is focused on **sustaining and improving** your workload's **return on investment**. | This intermediary step can increase the longevity of your existing system without the need for rewrites by allowing interoperability with systems that use a different messaging or eventing technology.<br/><br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs#determine-the-future-of-the-feature) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This decoupling provides flexibility when you transition messaging and eventing technology within your workload or when you have heterogeneous requirements from external dependencies.<br/><br/> - [OE:06 Deploying workload changes](/azure/well-architected/operational-excellence/workload-supply-chain) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

There's an application written in a .NET framework for managing employee scheduling hosted on-premises. The application is well-structured with separate components communicating via MSMQ. The application works, and the workload team has no intention of rewriting it. A new consumer of the scheduling data needs to be built to meet a business need, and the IT strategy calls for building new software as cloud-native applications to optimize the costs and delivery time.

The asynchronous queue-based architecture worked for the workload team in the past, so the team is going to use the same architectural approach but with the modern technology, Service Bus. The workload team doesn't want to introduce synchronous communication between the cloud and the on-premises deployment to mitigate the latency or unavailability of one affecting the other.

The team decides to use the Messaging Bridge pattern to connect the two systems. The pattern consists of two parts. One part receives messages from the existing MSMQ queue and forwards them to Service Bus. The other part takes messages from the Service Bus and forwards them to the existing MSMQ queue.

:::image type="content" source="./_images/messaging-bridge.png" alt-text="Diagram of the Messaging Bridge integrating MSMQ and Service Bus." lightbox="./_images/messaging-bridge.png" border="false":::

When the implementation team uses this approach, they utilize existing infrastructure in the existing application to integrate with the new components. The existing application isn't aware that the new components are hosted in Azure. Similarly, the new components communicate with the legacy application in the same way that they communicate between themselves, by sending Service Bus messages. The bridge forwards messages between the two systems.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Principal Content Developer - Azure Patterns & Practices
- [Kyle Baley](https://www.linkedin.com/in/kylebaley/) | Software Engineer
- [Udi Dahan](https://www.linkedin.com/in/udidahan/) | Founder & CEO of Particular Software
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Bryan Lamos](https://www.linkedin.com/in/bryanlamos/) | Content Developer - Azure Patterns & Practices
- [Szymon Pobiega](https://www.linkedin.com/in/szymonpobiega/) | Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Messaging Bridge pattern description](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingBridge.html) from the enterprise integration patterns community.
- Learn how to implement a [Messaging Bridge](https://docs.spring.io/spring-integration/reference/bridge.html) in the Spring Java framework.
- [QPid bridge](https://openmama.finos.org/openmama_qpid_bridge.html) can be used to bridge AMQP-enabled messaging technologies.
- The [NServiceBus Messaging Bridge](https://docs.particular.net/nservicebus/bridge) is a .NET implementation of a queue-to-queue bridge that supports a range of messaging infrastructures including MSMQ, Service Bus, and Azure Queue Storage.
- [NServiceBus.Router](https://github.com/SzymonPobiega/NServiceBus.Router) is an open-source project that implements the Messaging Bridge pattern. It also allows bridging more than two technologies in a single instance and has advanced message-routing capabilities.

## Related resources

- The [Competing Consumers](./competing-consumers.yml) pattern ensures the implementation of the Messaging Bridge can handle the load.
- The [Retry](./retry.yml) pattern allows the Messaging Bridge to handle transient failures.
- The [Circuit Breaker](./circuit-breaker.md) pattern conserves resources when either side of the bridge experiences downtime.
