The Claim-Check pattern allows workloads to process large messages without storing them in a messaging system. Instead, the pattern stores the message in a data store and generates a "claim check" for the message. A claim check is a token that validates entitlement to retrieve a specific object. The messaging system sends the token (claim check) to receiving applications so they can retrieve the message from a data store. The messaging system never stores the message, only the token.

This pattern is also known as Reference-Based Messaging and was first [introduced][enterprise-integration-patterns] in the book *Enterprise Integration Patterns* by Gregor Hohpe and Bobby Woolf.

## Context and problem

Traditional messaging systems are optimized to manage a high volume of small messages and often have restrictions on the size of messages they can process. Large messages not only risk exceeding these limits but can also impair the performance of the entire system when they are stored within the messaging system.

## Solution

Don't send large messages to the messaging system. Instead, send the message to an external data store. Generate a unique, obscure token (claim check) to retrieve the stored data and send that token to the messaging system. The messaging system sends the token to clients that need to process that specific message.

![Diagram of the Claim-Check pattern.](./_images/claim-check.png)

1. Send message
1. Store message in the data store
1. Send token (claim check) to messaging system.
1. Read the token (claim check)
1. Retrieve the message
1. Process the message

## Issues and considerations

Consider the following recommendations when implementing the Claim-Check pattern:

- *Delete consumed messages.* If you don't need to archive the message, delete the message data after the receiving applications consume it. Use either a synchronous or asynchronous deletion strategy:

  - *Synchronous deletion*: The consuming application deletes the message immediately after consumption. It ties deletion to the message handling workflow and uses messaging-workflow compute capacity.
  
  - *Asynchronous deletion*: A process outside the message processing workflow deletes the message. It decouples message deletion from the message handling workflow and minimizes use of messaging-workflow compute.
  
- *Implement the pattern conditionally.* Incorporate logic in the sender application that only applies the Claim-Check pattern if the message size surpasses the messaging system's limit. For smaller messages, bypass the pattern and sent the smaller message to the messaging system. This conditional approach reduces latency, optimizes resources utilization, and improves throughput.

## When to use this pattern

The following scenarios are the primary use cases for the Claim-Check pattern:

- *Messaging system limitations*: Message sizes surpass the limits of your messaging system (for example, over 100 MB for Service Bus premium tier, or 1 MB for Event Grid). Offload the message to external storage, sending only the token to the messaging system.

- *Messaging system performance*: Large messages are straining the messaging systems and degrading system performance.

The following scenarios are secondary use cases for the Claim-Check pattern:

- *Sensitive data protection*: Messages contain sensitive data that must be shielded from unauthorized access. Apply the Claim-Check pattern to all or portions of sensitive messages. Secure the data without transmitting it directly through the messaging system.

- *Complex routing scenarios*: Messages traversing multiple components can cause performance bottlenecks due to serialization, deserialization, encryption, and decryption tasks. Use the Claim-Check pattern to prevent direct message processing by intermediary components.

## Workload design

An architect should evaluate how the Claim-Check pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure it fully **recovers** after failure. | Messaging systems don't provide the same reliability and disaster recovery that are often present in dedicated data stores. Separating the data from the message can provide increased reliability for the underlying data. This separation facilitates message redundancy that allows you to recover messages after a disaster.<br/><br/> - [RE:03 Failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis)<br/> - [RE:09 Disaster recovery](/azure/well-architected/reliability/disaster-recovery) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of workload data and systems. | The Claim-Check pattern can extract sensitive data from messages and store it in a secure data store. This setup allows you to implement tighter access controls, ensuring that only the services intended to use the sensitive data can access it. At the same time, it hides this data from unrelated services, such as those used for queue monitoring.<br/><br/> - [SE:03 Data classification](/azure/well-architected/security/data-classification)<br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is focused on **sustaining and improving** your workload's **return on investment**. | Messaging systems often impose limits on message size, and increased size limits is often a premium feature. Reducing the size of message bodies might enable you to use a cheaper messaging solution.<br/><br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs)<br/> - [CO:09 Flow costs](/azure/well-architected/cost-optimization/optimize-flow-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** by optimizing scaling, data transfer, and code execution. | The Claim-Check pattern improves the efficiency of sending and receiving applications and the messaging system by managing large messages more effectively. It reduces the size of messages sent to the messaging system and ensures receiving applications access large messages only when needed.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:12 Continuous performance optimization](/azure/well-architected/performance-efficiency/continuous-performance-optimize) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Examples

The following examples demonstrate how Azure facilitates the implementation of the Claim-Check Pattern:

- *Azure messaging systems*: They cover four different Azure messaging systems: Azure Queue Storage, Azure Event Hubs (Standard API), Azure Service Bus, and Azure Event Hubs (Kafka API).

- *Automatic vs. manual token generation*: These examples also show two methods to generate the claim-check token. In code examples 1-3, Azure Event Grid automatically generates the token when the sending application sends the message to Azure Blob Storage. Code example 4 shows a manual token generation process using an executable command-line client.

Choose the example that suits your needs and follow the provided link to view the code on GitHub:

| Sample code                   | Data store         | Token generator               | Sending application            | Messaging system             | Receiving application          |
|-------------------------------|--------------------|--------------------           |---------------------           |------------------------------|---------------------           |
| [Code example 1][example-1]   | Azure Blob Storage | Azure Event Grid              | Function                       | Azure Queue Storage          | Executable command-line client |
| [Code example 2][example-2]   | Azure Blob Storage | Azure Event Grid              | Function                       | Event Hubs (Standard API)    | Executable command-line client |
| [Code example 3][example-3]   | Azure Blob Storage | Azure Event Grid              | Function                       | Azure Service Bus            | Executable command-line client |
| [Code example 4][example-4]   | Azure Blob Storage | Executable command-line client| Executable command-line client | Azure Event Hubs (Kafka API) | Function                       |

## Next steps

- The Enterprise Integration Patterns site has a [description][enterprise-integration-patterns] of this pattern.
- For another example, see [Dealing with large Service Bus messages using Claim-Check pattern](https://www.serverless360.com/blog/deal-with-large-service-bus-messages-using-claim-check-pattern) (blog post).
- An alternative pattern for handling large messages is [Split][splitter] and [Aggregate][aggregator].
- Libraries like NServiceBus provide support for this pattern out-of-the-box with their ["data bus" functionality](https://docs.particular.net/nservicebus/messaging/databus/azure-blob-storage).

## Related resources

- [Asynchronous Request-Reply Pattern](./async-request-reply.yml)
- [Competing Consumers pattern](./competing-consumers.yml)
- [Sequential Convoy pattern](./sequential-convoy.yml)

<!-- links -->
[aggregator]: https://www.enterpriseintegrationpatterns.com/patterns/messaging/Aggregator.html
[enterprise-integration-patterns]: https://www.enterpriseintegrationpatterns.com/patterns/messaging/StoreInLibrary.html
[example-1]: https://github.com/mspnp/cloud-design-patterns/tree/master/claim-check/code-samples/sample-1
[example-2]: https://github.com/mspnp/cloud-design-patterns/tree/master/claim-check/code-samples/sample-2
[example-3]: https://github.com/mspnp/cloud-design-patterns/tree/master/claim-check/code-samples/sample-3
[example-4]: https://github.com/mspnp/cloud-design-patterns/tree/master/claim-check/code-samples/sample-4
[sample-code]: https://github.com/mspnp/cloud-design-patterns/tree/master/claim-check
[splitter]: https://www.enterpriseintegrationpatterns.com/patterns/messaging/Sequencer.html