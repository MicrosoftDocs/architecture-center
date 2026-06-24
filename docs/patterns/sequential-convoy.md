---
title: Sequential Convoy Pattern
description: Use an established pattern to process a set of related messages in a defined order, without blocking the processing of other groups of messages.
ms.author: pnp
author: anaharris-ms
ms.date: 06/24/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Sequential Convoy pattern

Group related messages by a category key and process each group sequentially, one message at a time, while processing different groups in parallel.

This pattern resolves the tension between maintaining first-in, first-out (FIFO) correctness within each logical group and scaling out concurrent processing across groups. The design ensures that ordering constraints don't become a system-wide bottleneck.

## Context and problem

Applications often need to process related messages in the order they arrive while still scaling out to handle increased load. In a distributed architecture, this requirement is difficult to achieve because workers independently pull messages from a shared queue. When multiple workers compete for messages, as in the [Competing Consumers pattern](./competing-consumers.md), ordering breaks down.

Consider an order-tracking system that receives a stream of operations, such as creating an order, adding a transaction, modifying a past transaction, and deleting an order. Each order's operations must be processed in FIFO order, because applying them out of sequence would corrupt the order's state. However, the incoming queue interleaves operations across many orders. A single consumer that enforces global ordering becomes a bottleneck, and multiple consumers might process the same order's operations out of sequence.

The straightforward approaches to this problem each break down in a different way:

- **Single consumer.** A single consumer preserves message order because it processes one message at a time, but it can't scale to handle increased throughput.

- **Multiple competing consumers.** Multiple consumers scale throughput by pulling messages in parallel, but they lose per-group ordering guarantees. Two workers can pull consecutive messages for the same order and process them simultaneously or out of sequence, which corrupts the order state.

## Solution

The Sequential Convoy pattern partitions related messages into categories and processes each category sequentially, one message at a time, while categories are processed in parallel.

The pattern works by assigning each message a category key that identifies the group it belongs to. A message broker uses this key to partition messages into logical groups. Within each group, the broker enforces FIFO ordering so that a consumer that locks a group receives messages strictly in the sequence that they were enqueued. Different groups can be processed by different consumers simultaneously, so the system scales horizontally across groups without sacrificing ordering within any single group.

On Azure, Azure Service Bus [message sessions](/azure/service-bus-messaging/message-sessions) provide a built-in implementation of this pattern.

The following diagram shows the general Sequential Convoy pattern.

:::image type="complex" source="_images/sequential-convoy-overall.png" border="false" lightbox="_images/sequential-convoy-overall.png" alt-text="Diagram of the Sequential Convoy pattern. It shows a producer, a central queue, and three consumers.":::
    The diagram flows from left to right and shows three components. On the far left is a box labeled producer. An arrow points from the producer to a central box labeled queue. From the queue, three arrows point to the right, each labeled with a category name. The top arrow is labeled category A and points to a box labeled consumer A in the upper right. The middle arrow is labeled category B and points to a box labeled consumer B in the center right. The bottom arrow is labeled category C and points to a box labeled consumer C in the lower right. The three separate lines from the queue to the three consumers illustrate that the queue partitions messages by category key. It routes each category's messages exclusively to the corresponding consumer, which allows each consumer to process its respective message streams in parallel and in FIFO order without interfering with each other.
:::image-end:::

In the queue, messages for different categories might be interleaved, as shown in the following diagram.

:::image type="complex" source="_images/sequential-convoy-queuemessages.png" border="false" lightbox="_images/sequential-convoy-queuemessages.png" alt-text="Diagram that shows four categories of interleaved messages in a single queue. Each category occupies its own horizontal lane.":::
    The diagram shows the interior of a single queue rendered as a wide rectangular area. Inside the queue, four horizontal lanes are stacked vertically and numbered 1 through 4 along the right edge, each with an arrow pointing to the right to indicate the direction of message flow. Lane 1 contains four message blocks distributed across the full width of the queue, indicating a high volume of messages for that category. Lane 2 also contains four message blocks, also spread across the width. Lane 3 contains three message blocks, and lane 4 contains a single message block positioned toward the right side of the queue. The varying positions and densities of the message blocks across lanes illustrate that messages from all four categories arrive interleaved within the same shared queue. Despite this interleaving, each category's messages maintain their left-to-right arrival order within their respective lane, showing that per-category FIFO ordering is preserved even as different categories share a single queue structure.
:::image-end:::

This pattern provides several key benefits:

- **Ordered processing per group.** Messages within each category are processed strictly in sequence, which prevents race conditions, out-of-order state mutations, and the need for reordering workarounds.

- **Horizontal scale across groups.** Each category is an independent unit of concurrency. Adding consumers increases throughput proportionally to the number of active categories, without breaking ordering guarantees.

- **Producer-consumer decoupling.** Producers enqueue messages without knowledge of which consumer will process them or when. Consumers are independently scalable and replaceable.

## Problems and considerations

Consider the following points when you decide how to implement this pattern:

- **Category and scale unit.** Determine what property of your incoming messages you can scale out on. The category key defines the unit of parallelism: each distinct key value becomes an independently processable group. In the order-tracking scenario, this property is the order ID. Choosing a key that is too coarse (for example, a single customer ID for all orders) limits parallelism, while choosing a key that is too fine doesn't provide meaningful ordering benefit.

- **Throughput limits.** Evaluate your target message throughput. Because this pattern enforces sequential processing within each category, throughput per category is bounded by the time to process a single message. Optimize per-message processing time, for example, by using asynchronous I/O or batching downstream writes, because that time directly determines the maximum throughput for each category. If your overall throughput requirement is very high, reconsider whether strict FIFO ordering is necessary for the entire message lifecycle. Alternatives include enforcing a start message and end message to bracket a sequence, or sorting messages by timestamp within a batch window and then sending the batch for parallel processing.

- **Service capabilities.** Verify whether your choice of message broker supports one-at-a-time processing of messages within a queue or category of a queue. Not all messaging services provide session-level locking or FIFO guarantees within a partition. If the broker doesn't natively support this capability, the consumer must implement its own coordination logic, which adds complexity and risks duplicate processing, missed messages, or out-of-order execution. Session support might also constrain the choice of messaging tier or SKU, which affects cost.

- **Evolvability.** Plan how you will add new categories of messages to the system. The pattern must accommodate growth in category cardinality without requiring structural changes to consumers. For example, suppose the ledger system described earlier is specific to one customer. If you need to onboard a new customer, you should be able to add a set of ledger processors that distribute work per customer ID without redesigning the queue topology.

- **Out-of-order message delivery.** Messages can arrive out of order because of variable network latency between the producer and the broker, before the broker's session ordering takes effect. Consider using sequence numbers to verify ordering within each category. You can also include an end-of-sequence flag in the last message of a transaction so consumers can detect when a sequence is complete.

- **Poison message handling.** A message that repeatedly fails processing within a session blocks all subsequent messages in that session because the pattern enforces strict sequential ordering. Design a strategy to detect poison messages, such as tracking delivery attempt counts, and move them to a [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) after a defined retry threshold so the remaining messages in the session can continue processing.

- **Broker availability.** The message broker is a shared dependency for all categories. Its availability and durability directly affect the pattern's reliability guarantees. Evaluate broker-level resiliency features such as availability zones and geo-disaster recovery based on the workload's availability requirements and budget, because higher-durability configurations typically increase cost.

- **Producer key correctness.** The pattern assumes that producers set the category key (session ID) correctly on every message. If a producer sets an incorrect key, either accidentally or because of a bug, the message routes to the wrong session and corrupts that group's state. Validate that producers assign category keys consistently, and consider adding key-validation logic at the consumer if the consequence of a misrouted message is severe.

- **Operational complexity.** Monitoring session-based processing adds operational overhead above that of standard queue consumption. Operators need visibility into session backlogs (the number of active sessions and the depth of messages waiting in each session) to identify categories that are falling behind. Dead-lettered sessions require a separate monitoring and remediation workflow to investigate failed messages, resolve the root cause, and replay corrected messages back into the session.

- **Session lock contention and latency.** Session locking introduces latency overhead because each consumer must acquire an exclusive lock on a session before processing messages. When a consumer holds a session lock, no other consumer can process messages from that session, even if the consumer is slow or temporarily stalled. If the lock duration is too short, lock expiration can cause message reprocessing. If the lock duration is too long, a stalled consumer delays recovery. Tune the session lock duration based on expected message processing time, and implement lock renewal for longer-running operations.

- **Consumer scaling and cost.** Parallelism across sessions translates to concurrent consumer instances. In a serverless model such as Azure Functions, each active session maps to a concurrent execution, and in a dedicated model, it maps to an instance or thread. The number of active sessions therefore directly influences compute cost. Plan consumer scaling limits and concurrency controls to balance throughput against cost.

## When to use this pattern

Use this pattern when:

- Messages arrive in order and must be processed in the same order.
- Messages can be categorized so that each category becomes an independent unit of scale for the system.

This pattern might not be suitable when:

- You expect extremely high throughput scenarios (millions of messages per minute), because the FIFO requirement limits the scaling that the system can achieve.

- Message ordering isn't required. When messages can be processed independently in any order, the [Competing Consumers pattern](./competing-consumers.md) provides simpler horizontal scaling without the coordination overhead of session locking.

## Workload design

Evaluate how to use Sequential Convoy in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern uses session-based FIFO ordering to eliminate race conditions, contention-prone message handling logic, and other workarounds for incorrectly ordered messages that can lead to malfunctions.<br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:07 Background jobs](/azure/well-architected/design-guides/background-jobs) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

On Azure, you can implement this pattern by using Service Bus [message sessions](/azure/service-bus-messaging/message-sessions). For the consumers, you can use either Azure Logic Apps with the [Service Bus peek-lock connector](/azure/connectors/connectors-create-api-servicebus) or Azure Functions with the [Service Bus trigger](/azure/azure-functions/functions-bindings-service-bus).

When a producer sets the `SessionId` property on a message, Service Bus groups all messages that share the same session ID into a single logical session. A consumer accepts a session and receives an exclusive lock on it. This lock guarantees that only one consumer processes messages for that session at any time and that messages arrive in FIFO order. Other consumers can simultaneously accept and process different sessions, providing parallel throughput across groups.

In the order-tracking example, the system processes each ledger message in the order it's received and sends each transaction to another queue where the category is set to the order ID. A transaction never spans multiple orders in this scenario, so consumers process each category in parallel but FIFO within the category.

The ledger processor fans out the messages by de-batching the content of each message in the first queue:

:::image type="complex" source="_images/sequential-convoy-examplearch.png" border="false" lightbox="_images/sequential-convoy-examplearch.png" alt-text="Diagram of the Sequential Convoy example architecture. It shows a producer, a ledger queue, a ledger processor, a transactions queue, and three order processors.":::
    The diagram flows from left to right across five stages. On the far left is a box labeled producer. An arrow points from the producer to a box labeled ledger queue. An arrow points from the ledger queue to a box labeled ledger processor. An arrow points from the ledger processor to a box labeled transactions queue. From the transactions queue, three arrows point to the right, each labeled with a session category. The top arrow is labeled order A transactions and points to a box labeled order processor A. The middle arrow is labeled order B transactions and points to a box labeled order processor B. The bottom arrow is labeled order C transactions and points to a box labeled order processor C. The diagram illustrates the serial-to-parallel transition: the producer sends all messages through the ledger queue and ledger processor sequentially, and the ledger processor sets the session ID on each message to the corresponding order ID before enqueuing it to the transactions queue. The transactions queue then routes each order's messages exclusively to the corresponding order processor, which allows order processor A, order processor B, and order processor C to consume their respective sessions in parallel and in FIFO order.
:::image-end:::

The ledger processor performs three steps:

1. Walks the ledger one transaction at a time.
1. Sets the session ID of the message to match the order ID.
1. Sends each ledger transaction to a secondary queue with the session ID set to the order ID.

The consumers listen to the secondary queue and process all messages with matching order IDs in FIFO order. Consumers use [peek-lock](/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock) mode.

The ledger queue is a serial-to-parallel transition point: all transactions pass through it sequentially before fanning out to session-based parallel processing. This serialization stage is the primary scalability bottleneck because it gates the throughput of the entire downstream pipeline. However, after the ledger processor fans out messages to the secondary queue, consumers can scale independently across sessions, one per order ID.

## Supporting technologies

- [Service Bus message sessions](/azure/service-bus-messaging/message-sessions): Groups messages by session ID and enforces FIFO processing within each session. Message sessions are the primary Azure mechanism for implementing the Sequential Convoy pattern.

- [Azure Functions Service Bus trigger](/azure/azure-functions/functions-bindings-service-bus): Supports session-based triggers that allow function instances to process messages from a single session at a time.

- [Logic Apps Service Bus connector](/azure/connectors/connectors-create-api-servicebus): Provides a Service Bus connector with peek-lock support for consuming session-enabled queues in workflow-based processing.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Naga Venkata Cheruvu](https://www.linkedin.com/in/naga-cheruvu/) | Senior Cloud Solution Architect + AI infra

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Competing Consumers pattern](./competing-consumers.md): Multiple consumers pull messages from a shared queue in parallel, which increases throughput but removes per-message ordering guarantees. The Sequential Convoy pattern addresses the ordering gap that Competing Consumers introduces. It addresses this gap by partitioning messages into category-keyed sessions and processing each session sequentially.

- [Queue-Based Load Leveling pattern](./queue-based-load-leveling.md): A queue buffers work between producers and consumers to absorb bursts and smooth uneven load. The Sequential Convoy pattern builds on this buffering by adding session-based partitioning, so that the queue both levels load across categories and preserves FIFO ordering within each category.

- [Priority Queue pattern](./priority-queue.yml): Messages are routed to separate queues or given priority within a queue so that higher-priority work is processed before lower-priority work. When ordering within a priority level must also be preserved, the Sequential Convoy pattern can be combined with priority queuing to enforce FIFO processing within each priority-keyed session.

- [Peek-Lock Message (Non-Destructive Read)](/rest/api/servicebus/peek-lock-message-non-destructive-read): This operation atomically retrieves and locks a message from a queue or subscription for processing.

- [In order delivery of correlated messages in Logic Apps by using Service Bus sessions](/archive/blogs/logicapps/in-order-delivery-of-correlated-messages-in-logic-apps-by-using-service-bus-sessions): This blog post describes Logic Apps support for the Sequential Convoy pattern.