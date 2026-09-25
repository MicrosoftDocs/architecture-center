---
title: Claim Check pattern
description: Store a large message payload in an external data store and send a reference called a claim check through a messaging system.
ms.author: pnp
author: claytonsiemens77
ms.date: 08/31/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Claim Check pattern

Store a large message payload in an external data store and send only a reference to the stored payload through the messaging system. Receiving applications present the reference token, called a *claim check*, to retrieve the large payload when they need to process it. This approach lets workloads transfer large payloads without storing them in the messaging system.

## Context and problem

Traditional messaging systems are optimized to manage a high volume of small messages, and often restrict the message size they can handle. Large messages not only risk exceeding size limits, but can also degrade system performance when the messaging system stores them.

The following constraints make inline payload transmission through the messaging system insufficient:

- **Size-limit rejection.** Messaging systems reject messages that exceed a configured maximum.

- **Broker resource pressure.** Storing large payloads in the broker consumes disproportionate memory and disk compared to the metadata the broker needs to route and deliver the message. This consumption competes with needed resources for other messages in the system.

- **Throughput degradation.** Larger messages increase serialization, transfer, and deserialization time per operation.

- **Cost escalation.** Some messaging systems charge by message size, tier, or capacity unit. Transmitting large payloads inline can push workloads into higher-cost tiers or capacity allocations.

## Solution

The Claim Check pattern separates payload storage from message delivery. A sending application writes the full payload to an external data store and sends a reference to that payload through the messaging system. The messaging system never sees or stores the payload. Receiving applications use the reference to retrieve the payload directly from the data store. The reference is an identifier that the receiving application must resolve.

:::image type="complex" source="./_images/claim-check-diagram.svg" alt-text="Diagram that shows the Claim Check pattern." lightbox="./_images/claim-check-diagram.svg" border="false":::
   At upper left, Step 1 shows an arrow pointing to the right from a payload to the sending application that generates it. In step 2, an arrow labeled Payload points down from the sending application to a data store below. In Step 3, an arrow points to the right from the sending application to a message with a claim-check token in the messaging system. In step 4, an arrow points to the right from the messaging system to the receiving application. In step 5, an arrow labeled Payload points from the data store up to the receiving application. Step 6 shows an arrow pointing to the right from the receiving application to the payload.
:::image-end:::

The pattern follows this sequence:

1. The sending application generates the payload.
1. The sending application saves the payload in the external data store.
1. After the save succeeds, the sending application generates a reference to the stored payload and publishes it to the messaging system as a claim check message.
1. A receiving application retrieves the message and reads the claim check token.
1. The receiving application uses the token to retrieve the payload from the data store.
1. The receiving application processes the payload.

The messaging system handles only the small claim check message, which avoids message-size rejection and the need to use resources to transfer and retain large message payloads. The external data store applies access controls and lifecycle policies to the payload independent of the messaging system.

## Problems and considerations

Consider the following points when deciding how to implement this pattern:

- **Payload lifecycle ownership.** Define which component owns payload deletion and how the component determines that the payload isn't needed. Coordinate message expiration and payload retention so that a valid claim check doesn't point to deleted data.

- **Conditional application.** Decide whether to make all messages claim checks or to make the claim-check decision per message. If it's conditional, ensure that the schema defines whether the payload is inline or external.

- **Token and store security.** Don't embed security tokens as part of the claim check. Leave authorization as an independent interaction between producer or consumer systems and the data store. If your solution requires consumers to be explicitly granted temporary access, use the [Valet Key pattern](./valet-key.yml) instead.

- **Payload and token consistency.** Payload write and token publication occur in separate systems and aren't in one atomic transaction. A failure after payload write but before token publication can leave a payload orphaned. A token published before its payload is retrievable can mean consumers receive references they can't resolve. Publish the token only after the payload write succeeds. Because retries can deliver the same claim check more than once, use the [Idempotent Consumer pattern](./idempotent-consumer.md) to process duplicates safely.

- **Payload integrity.** When consumers must verify payload integrity, include a content hash or digital signature in the message. Define a protocol for mismatches, such as rejecting the payload, retrying retrieval, or routing the message for investigation.

- **Payload availability and durability.** The external data store must remain available and durable for the entire period that receiving applications need to retrieve a payload. If the store experiences an outage or data loss, consumers that hold valid tokens can't retrieve their payloads and their message processing stalls.

- **Retrieval-hop latency.** The pattern adds extra network trips compared to inline message delivery. Receiving applications must call the external data store to retrieve the payload before processing can begin.

- **Framework-provided claim check support.** Use the capabilities your message bus SDK offers. For example, NServiceBus has a [DataBus](https://docs.particular.net/nservicebus/messaging/claimcheck/) feature that can automate payload storage and retrieval.

## When to use this pattern

Use this pattern when:

- **Message payloads regularly exceed the maximum message size** that the messaging system supports. Offloading the payload to an external data store and transmitting only a lightweight claim check token avoids size-limit rejections.

- **Large messages consume disproportionate broker resources.** Large messages affect messaging system performance by increasing serialization and transfer time or by degrading throughput for all producers and consumers that share the messaging system.

- **Payloads contain sensitive information** that shouldn't be visible to the messaging system or to intermediary components such as queue-monitoring tools. Apply the pattern to the entire payload or only to its sensitive portions. Store the sensitive content in a secured data store with dedicated access controls to keep it out of the messaging path.

- **Messages have complex routing with repeated serialization.** Messages traverse multiple routing components that perform serialization, deserialization, encryption, or decryption. Transmit only a small token through intermediaries to eliminate repeated processing of the full payload at each hop and reduce cumulative latency.

This pattern might not be suitable when:

- **Latency sensitivity outweighs payload size concerns.** Workloads that require the lowest possible end-to-end latency between producer and consumer might not tolerate the added network hops for payload storage and retrieval. If messages can be delivered inline without exceeding size or performance limits, direct delivery is simpler and faster.

- **You can choose a transport or tier that supports the payload size.** When payloads stay within a transport's supported limit and don't create unacceptable throughput or latency, send them inline to avoid the external-store dependency. For example, [Azure Service Bus Premium tier](/azure/service-bus-messaging/service-bus-premium-messaging#large-messages-support) supports Advanced Message Queuing Protocol (AMQP) messages up to 100 MB. Keep messages as small as possible, because large messages reduce throughput and increase latency.

- **Coordination across two systems isn't possible.** The pattern requires coordination across two independent systems. The claim check value needs to be written in a way that the receiving system can understand, and its format might need to be adjusted over time.

### Alternatives

Consider these approaches as alternatives to this pattern:

- **Reduce the inline payload size.** Compression can reduce repetitive text or binary payloads, and a more compact serializer can reduce message overhead. Choose this approach when the reduced payload fits comfortably within the transport limit and every producer and consumer can use the same compression and serialization format.

- **Split and aggregate the payload naturally.** Divide a large payload into a sequence of smaller messages when consumers can process chunks independently or reassemble them after delivery. This approach keeps the data in the messaging system, but it adds sequencing, correlation, duplicate handling, and reassembly requirements. For more information, see the [Splitter](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Sequencer.html) and [Aggregator](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Aggregator.html) patterns from Enterprise Integration Patterns.

## Workload design

Evaluate how to use the Claim Check pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of the pillars.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure it fully **recovers** after failure. | Messaging systems can provide durable delivery, high availability, and disaster recovery, but they typically don't provide the payload-level data protection and recovery capabilities of a dedicated data store, such as versioning, backup, point-in-time restore, or independent replication. Storing the payload separately lets you select and configure these capabilities based on payload recovery requirements.<br/><br/> - [RE:03 Failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis)<br/> - [RE:09 Disaster recovery](/azure/well-architected/reliability/disaster-recovery) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of workload data and systems. | The Claim Check pattern can extract sensitive data from messages and store it in a secure data store. This setup enables tighter access controls so that only the services intended to use the sensitive data can access it. The pattern also hides this data from unrelated services, such as those used for queue monitoring.<br/><br/> - [SE:03 Data classification](/azure/well-architected/security/data-classification)<br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is focused on **sustaining and improving** your workload's **return on investment**. | Messaging systems often impose limits on message size, and increased size limits are often a premium feature. Reducing the size of message bodies might allow you to use a cheaper messaging solution. Factor in added costs for payload storage, network transfer, and cleanup processing.<br/><br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs)<br/> - [CO:09 Flow costs](/azure/well-architected/cost-optimization/optimize-flow-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** by optimizing scaling, data transfer, and code execution. | The Claim Check pattern improves sending, receiving, and messaging system efficiency by managing large messages more effectively. It reduces the size of messages sent to the messaging system and ensures that receiving applications access large messages only when needed.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:12 Continuous performance optimization](/azure/well-architected/performance-efficiency/continuous-performance-optimize) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Examples

This section links to GitHub [Claim-check cloud pattern examples](https://github.com/Azure-Samples/cloud-design-patterns/tree/main/claim-check) that show how Azure services implement the Claim Check pattern. Each example uses Azure Blob Storage as the external data store and pairs it with a different Azure messaging system. Samples 1 through 3 use the blob URL in an Azure Event Grid notification as the claim check. Sample 4 uses a custom claim check that the sending application publishes.

In samples 1 through 3:

1. A sending application uploads a large payload to Blob Storage.
1. The upload triggers a `Microsoft.Storage.BlobCreated` event through an Event Grid system topic.
1. Event Grid routes the notification, which contains a direct blob URL that the examples use as the claim check, to the configured messaging system.
1. A receiving application, implemented as an Azure Functions function app or command-line client, retrieves the notification, extracts the blob URL, and downloads the payload directly from Blob Storage for processing.

In a production implementation, you filter the event subscription by operations that indicate a fully committed block blob, and design the receiver to handle delayed, duplicate, and out-of-order events.

Sample 4 uses a different approach. Instead of routing a Blob Storage notification through Event Grid, the sending application constructs the claim check after uploading the payload to Blob Storage. The sending application then publishes the claim check to the Azure Event Hubs Kafka endpoint by using the Apache Kafka protocol. This approach suits environments that already use Kafka-compatible producers or require custom token formats.

The following table lists each example with its messaging system, claim check publisher, receiving application, and storage dependencies. Select each link to view the example code on GitHub.

| Sample code | Messaging system | Claim check publisher | Receiving application | Storage dependencies |
| --- | --- | --- | --- | --- |
| [Code example 1](https://github.com/Azure-Samples/cloud-design-patterns/tree/main/claim-check/code-samples/sample-1) | Azure Queue Storage | Event Grid | Functions | Blob Storage |
| [Code example 2](https://github.com/Azure-Samples/cloud-design-patterns/tree/main/claim-check/code-samples/sample-2) | Event Hubs (Azure SDK over AMQP) | Event Grid | Executable command-line client | Blob Storage for payloads and a separate Blob Storage checkpoint store |
| [Code example 3](https://github.com/Azure-Samples/cloud-design-patterns/tree/main/claim-check/code-samples/sample-3) | Service Bus | Event Grid | Functions | Blob Storage |
| [Code example 4](https://github.com/Azure-Samples/cloud-design-patterns/tree/main/claim-check/code-samples/sample-4) | Event Hubs (Apache Kafka protocol) | Executable command-line client | Functions | Blob Storage |

## Next steps

- Read the canonical [Enterprise Integration Patterns description of Claim Check](https://www.enterpriseintegrationpatterns.com/patterns/messaging/StoreInLibrary.html).
- Review another implementation in [Dealing with large Service Bus messages using claim check pattern](https://turbo360.com/blog/deal-with-large-service-bus-messages-using-claim-check-pattern).
- [Choose between Azure Event Grid, Event Hubs, and Service Bus](/azure/service-bus-messaging/compare-messaging-services).

## Related resources

- [Asynchronous Request-Reply pattern](./asynchronous-request-reply.md)
- [Competing Consumers pattern](./competing-consumers.md)
- [Sequential Convoy pattern](./sequential-convoy.md)
- [Valet Key pattern](./valet-key.yml)
