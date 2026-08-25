---
title: Idempotent Consumer Pattern
description: Use the Idempotent Consumer pattern to safely process duplicate messages from at-least-once delivery so that repeated processing has the same effect as processing once.
ms.author: pnp
author: claytonsiemens77
ms.date: 08/13/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Idempotent Consumer pattern

Design message consumers so that processing the same message more than once has the same effect as processing it once. Messaging systems that guarantee at-least-once delivery can deliver the same message multiple times. Without resilience against duplicates, reprocessing a message can create duplicate records, double-charge a customer, or have other unwanted effects.

## Context and problem

Distributed applications commonly exchange work through a message broker instead of direct synchronous calls. Most brokers, including Azure Service Bus, Azure Event Hubs, Apache Kafka, and RabbitMQ, provide *at-least-once* delivery. This guarantee ensures that a message reaches a consumer even when failures occur, but it also means that the broker can deliver the same message more than once.

Duplicates arise from several sources:

- Producer retries

  A producer sends a message, doesn't receive an acknowledgment because of a transient network fault or timeout, and sends the message again. The broker now holds two copies even though the send succeeded the first time.

- Redelivery after a missing acknowledgment

  A consumer receives and processes a message but fails to acknowledge it because the consumer crashes, the lock expires, or the acknowledgment is lost. The broker assumes the message wasn't processed and delivers it again.

- Consumer failures mid-processing

  A consumer completes a database write but crashes before it acknowledges the message. When another instance picks up the redelivered message, it repeats the write.

*Exactly-once delivery* across a distributed system is impractical to guarantee. Even brokers that claim exactly-once semantics only guarantee operations they directly control, such as delivering messages to consumers or writing data back to the broker. They can't guarantee the external side effects that consumers perform in other systems. The durable solution isn't to eliminate duplicate delivery. It's to make the consumer tolerate it. When you combine at-least-once delivery with a consumer that ignores duplicates, you achieve *effectively exactly-once processing*.

## Solution

Make the consumer idempotent by maintaining a record of processed messages and skipping any message that it saw before. The consumer keys this decision on a stable identifier that survives redelivery, checks a persistent store to determine whether that identifier was already processed, and either processes the message or discards it as a duplicate.

The following steps describe the core flow:

1. Read the message and extract its deduplication key.
1. Check the deduplication store for that key.
1. If the key exists, treat the message as a duplicate. Acknowledge it and stop, optionally returning the previously recorded outcome.
1. If the key doesn't exist, process the message and record the key in a single atomic operation, then acknowledge the message.

### Choose a stable deduplication key

The key must uniquely and consistently identify the logical message across every redelivery. Use a producer-assigned message identifier or a business-level idempotency key that identifies the specific logical operation, not a shared correlation context that several messages can carry. In Azure Service Bus, the `MessageId` property serves this purpose because it uniquely identifies the message and its payload. Don't use `CorrelationId` as the key, because it groups related messages, such as a request and its replies. For events that follow the CloudEvents specification, the combination of the `source` and `id` attributes uniquely identifies an event and stays stable across redeliveries.

Don't key on transport-level identifiers that the broker regenerates on redelivery or on values derived from delivery attempts, because those values change between duplicates and defeat detection. Also avoid deriving the key from volatile fields such as receive timestamps.

When more than one independent consumer processes the same channel, such as multiple subscribers in a publish-subscribe design, each consumer legitimately processes its own copy of a message and needs to independently track completion of message processing. If those consumers share one deduplication store, key the record on a composite of the consumer identity and the message identity. A store keyed on the message identity alone lets the first consumer suppress processing for all the others.

### Decide where to store processed keys

You have two common options:

- **A dedicated deduplication table.** The consumer maintains a separate table, sometimes called an *inbox*, that holds one row per processed key. This approach keeps deduplication concerns separate from business data and works well when many message types share one mechanism.

- **The business entity itself.** The consumer stores the key on the record that the message creates or updates. This approach avoids a separate table but couples deduplication to the shape of the business data.

### Commit the marker and the side effects atomically

The check-then-process flow has a failure window. If the consumer processes the message and then records the key in a separate step, a crash between the two operations leaves the side effects applied but the key unrecorded, so the next delivery reprocesses the message.

Address this failure window by writing the deduplication marker and the business side effects in the same transaction. When both commit together or not at all, a redelivery either finds the committed marker and skips, or finds no marker because the transaction rolled back and safely reprocesses. This transactional variant is the *inbox pattern*, and it's the consume-side companion to the [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md) on the produce side.

### Guard against concurrent duplicates

Under at-least-once delivery with multiple [competing consumers](./competing-consumers.md), two instances can receive copies of the same message at the same time. Both can pass the existence check before either commits, so the check alone doesn't prevent double processing.

Enforce correctness at the data store instead of in application logic:

- **Use a unique constraint** on the deduplication key. Both transactions attempt to insert the key, but only one succeeds. The other fails the constraint and treats the message as a duplicate. This approach makes the database the single arbiter of the race.

- **Avoid check-then-set races in caches.** A pattern that checks a key and then sets it across two separate operations has a window that lets concurrent retries both claim the key. Use an atomic conditional write, such as an insert that fails on conflict or a set-if-absent operation, so that claiming the key is a single atomic step.

### Handle side effects that can't join the transaction

Some processes can't participate in the consumer's database transaction, such as calling a third-party API or writing to an external store. For these processes, use a two-phase approach:

1. Record the key with an *in-progress* state before you perform the external action.
1. Perform the process.
1. Update the record to *completed* and store the outcome.

On redelivery, a *completed* record lets you skip repeating the call. An *in-progress* record signals that a previous attempt might have partially completed or is being worked on by another consumer.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Prefer naturally idempotent operations.** Some operations are inherently idempotent and need no deduplication bookkeeping. An upsert keyed on a business identifier, a write that sets an absolute value rather than an increment, or an HTTP `PUT` to a resource identifier produces the same result whether it runs once or many times.

  You can sometimes make an operation naturally idempotent through [event-carried state transfer](https://martinfowler.com/articles/201701-event-driven.html#Event-carriedStateTransfer), where the message carries the resulting absolute state, such as an order's new status, so the consumer applies it as an upsert instead of a relative change.

  > [!TIP]
  > Design for natural idempotency first, and add deduplication techniques only for operations that can't be made naturally idempotent.

- **Manage the lifecycle of deduplication records.** Deduplication records accumulate unless you expire them. Retain each record at least as long as the broker can redeliver the original message. This window depends on the broker's maximum delivery attempts, its lock or visibility timeout, and the message time-to-live. Set a time-to-live on deduplication records that exceeds this window so that a late redelivery still finds its marker. Deleting records too early reopens the window for duplicates. Account for messages that an operator resubmits from a dead-letter queue, because a resubmission can occur long after the normal redelivery window.

- **Use a messaging framework instead of hand-rolling deduplication.** Implementing the deduplication store, the atomic commit, and the record cleanup correctly is error-prone. Message-based frameworks provide this pattern as a built-in feature.

  For example, [NServiceBus](https://docs.particular.net/architecture/consistency) deduplicates incoming messages by their message identifier and provides configurable retention and cleanup for deduplication data. The [MassTransit consumer inbox](https://masstransit.io/documentation/configuration/middleware/outbox) tracks received messages by their message identifier to provide exactly-once consumer behavior.

- **Broker deduplication reduces but doesn't remove the need for idempotent consumer logic.** Some platforms filter duplicates at the transport layer. Azure Service Bus [duplicate detection](/azure/service-bus-messaging/duplicate-detection) discards messages that carry a repeated `MessageId` within a configured time window, which suppresses duplicates caused by producer send retries. This feature operates on the send side and within a bounded window. It doesn't prevent a consumer from processing the same message twice after a redelivery, so you still need idempotent consumer logic. Treat platform features as a first layer of defense that lowers duplicate volume, not as a replacement for the pattern.

- **Account for message ordering.** Deduplication removes duplicates but doesn't guarantee order. If the consumer depends on processing order, combine this pattern with an ordering mechanism, such as Azure Service Bus [message sessions](/azure/service-bus-messaging/message-sessions), or include sequence or version data that lets the consumer reject stale messages.

- **Instrument for observability.** Emit the deduplication key and a correlation identifier in structured logs, and track a metric for detected duplicates. A rising duplicate rate can indicate producer misconfiguration, an undersized acknowledgment or lock window, or unhealthy consumers. Use [end-to-end tracing and correlation](/azure/service-bus-messaging/service-bus-end-to-end-tracing) to follow a message across services.

- **Propagate idempotency to downstream calls.** Making one consumer idempotent doesn't protect the services it calls. When a consumer invokes downstream services as part of processing, propagate the idempotency key so that each tier can deduplicate its own work.

## When to use this pattern

Use this pattern when:

- You consume messages from a broker that provides at-least-once delivery, which is the default for most brokers.

- Reprocessing a message produces incorrect results, such as duplicate financial transactions, duplicate resource creation, or repeated notifications.

- Multiple competing consumers process the same channel, which makes concurrent duplicate delivery likely.

This pattern might not be suitable when:

- Every operation the consumer performs is already naturally idempotent, so reprocessing is harmless and deduplication bookkeeping adds cost without benefit.

- The workload can tolerate the effects of occasional duplicate processing, and the cost of a deduplication store outweighs the impact of a duplicate.

### Idempotent processing beyond messaging

This pattern applies idempotency to message consumers, but idempotent processing is a broader reliability principle. Any operation that can run more than once over an identical task benefits from it. This principle includes extract, transform, load (ETL) transformations that reprocess replayed data, stream processing that resumes from a checkpoint, scheduled jobs that overlap or restart, and webhook or HTTP endpoints that receive duplicate deliveries.

In each case, the same core technique applies:

1. Identify the unit of work with a stable key.
1. Record what you already processed.
1. Skip or absorb duplicates so that repeating the work doesn't change the outcome.

The mechanisms in this article, such as stable keys, atomic markers, and unique constraints, transfer to those contexts even when no message broker is involved.

## Workload design

Evaluate how to use the Idempotent Consumer pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern lets a workload use at-least-once delivery and safe retries without corrupting data, which turns duplicate delivery from a correctness risk into a tolerated condition. <br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation)<br/> - [Handle Transient faults](/azure/well-architected/design-guides/handle-transient-faults) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following example shows an idempotent consumer that processes orders from Azure Service Bus and persists state in Azure Cosmos DB for NoSQL.

A producer sets the Service Bus `MessageId` to a business-level order identifier. The consumer receives messages in [PeekLock](/azure/service-bus-messaging/message-transfers-locks-settlement) mode, which redelivers a message if the consumer doesn't complete it within the lock duration. The consumer's Azure Cosmos DB container partitions on the order identifier (`/orderId`) and sets the document `id` to the same order identifier, so every copy of a given order resolves to the same logical partition and the order record itself serves as the deduplication marker.

The consumer processes each message as follows:

1. Read the message and use its `MessageId` as the deduplication key.
1. Create the order document with `id` and the partition key both set to the order identifier.
1. If the create succeeds, complete the message so that Service Bus removes it from the queue.
1. If the create fails with an HTTP 409 (Conflict) status because a document with that `id` already exists, read the existing document and compare it against the current message. If a stored request hash or immutable business fields match, treat the message as a duplicate, complete it, and skip processing. If they don't match, the producer might have reused the identifier for different content, or the order details might have changed since it was first processed, so dead-letter the message or raise an alert instead of silently discarding it.
1. If processing fails for a transient reason, abandon the message so that Service Bus redelivers it, or let the lock expire so that another consumer receives it.

The create operation is atomic, so it serves as both the deduplication check and the write. Two consumers that receive copies of the same message can't both create the order. One create wins, and the other returns a conflict and safely discards its duplicate.

When processing must write more than one document, use a [transactional batch](/azure/cosmos-db/transactional-batch) that includes both the deduplication document and the business documents within the same partition key. Because a transactional batch operates within a single logical partition, choose a partition key that all the documents for one message share. The batch commits all documents together or none at all, so a crash between processing and acknowledgment can't leave the deduplication marker and the business data out of sync. A batch that tries to create a document that already exists returns a 409 (Conflict) status, which identifies the duplicate.

To make this consumer resilient against duplicate send retries as well, enable [duplicate detection](/azure/service-bus-messaging/duplicate-detection) on the queue. Duplicate detection suppresses repeated sends within its history window, and the idempotent consumer handles any duplicates that fall outside that window or that result from redelivery.

## Next step

- [Asynchronous messaging options in Azure](../guide/technology-choices/messaging.md) describes the messaging infrastructure choices that determine your delivery guarantees and duplicate-handling requirements.

## Related resources

- [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md) is the publisher side of this pattern. It reliably publishes messages by committing them in the same transaction as the business data.

- [Retry pattern](./retry.yml) enables applications to handle transient faults by retrying operations, which makes idempotent processing necessary because retries can cause duplicate delivery.

- [Resilient Azure Event Hubs and Azure Functions design](../serverless/event-hubs-functions/resilient-design.md) applies this pattern to functions that Azure Event Hubs triggers, including deduplication techniques for event streams.

- [Designing Azure Functions for identical input](/azure/azure-functions/functions-idempotent) provides guidance for building idempotent functions that tolerate duplicate invocations.
