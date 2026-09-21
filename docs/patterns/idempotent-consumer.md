---
title: Idempotent Consumer Pattern
description: Use the Idempotent Consumer pattern to safely process duplicate messages from at-least-once deliveries so that repeated processing has the same effects as processing once.
ms.author: pnp
author: claytonsiemens77
ms.date: 08/13/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Idempotent Consumer pattern

Design message consumers so that processing the same message more than once has the same effects as processing it once. Messaging systems that guarantee at-least-once delivery can deliver the same message multiple times. Resilience against duplicates ensures that reprocessing a message doesn't create duplicate records, double-charge a customer, or have other unwanted effects.

## Context and problem

Distributed applications commonly exchange work through a message broker instead of using direct synchronous calls. Most brokers, including Azure Service Bus, Azure Event Hubs, Apache Kafka, and RabbitMQ, provide *at-least-once* delivery. This guarantee ensures that a message reaches a consumer even when failures occur, but also means that the broker can deliver the same message more than once.

It's impractical to guarantee *exactly-once* delivery across a distributed system. Even brokers that use exactly-once semantics can guarantee only operations they directly control, such as delivering messages to consumers or writing data back to the broker. They can't control the side effects that consumers implement in external systems. The durable solution isn't to eliminate duplicate delivery but to make the consumer process it correctly. When you combine at-least-once delivery with a consumer that ignores duplicates, you achieve *effectively-once* processing.

Duplicates can arise from several sources:

- **Producer retries.** A producer sends a message, doesn't receive an acknowledgment because of a transient network fault or timeout, and sends the message again. The broker now holds two copies even though the send succeeded the first time.

- **Redelivery after a missing acknowledgment.** A consumer receives and processes a message but fails to acknowledge it because the consumer crashes, the lock expires, or the acknowledgment is lost. The broker assumes the message wasn't processed and delivers it again.

- **Consumer failures during processing.** A consumer completes a database write but crashes before acknowledging the message. Another instance picks up the message and repeats the write.

## Solution

Create an idempotent consumer by having the consumer keep a record of messages it successfully processes and skip any messages it already processed, based on a stable identifier that survives redelivery. The consumer checks the persistent identifier store to determine whether it already processed that identifier, and then either processes the message or discards it as a duplicate.

The core flow consists of the following steps:

1. Read the message and extract its deduplication key.
1. Check the deduplication store for that key.
1. If the key already exists in the store, treat the message as a duplicate. Acknowledge the message and stop processing it, optionally returning the previously recorded outcome.
1. If the key doesn't yet exist in the store, process the message and record the key in a single atomic operation, and then acknowledge the message.

The following sections provide guidance for making consumers idempotent:

### Choose a stable deduplication key

The deduplication key must uniquely and consistently identify the logical message across every redelivery. Use either a producer-assigned message identifier or a business-level idempotency key that identifies the specific logical operation, not a shared correlation context that several messages can carry.

For example, set the Service Bus `MessageId` property to a value that uniquely identifies the logical message. Don't use `CorrelationId` as the key, because it refers to groups of related messages, such as a request and its replies. For events that follow the CloudEvents specification, the `source` and `id` attribute combination uniquely identifies an event and stays stable across redeliveries.

Don't key on transport-level identifiers that the broker regenerates upon redelivery, or on values derived from delivery attempts. Those values change between deliveries and defeat duplicate detection. Also avoid deriving the key from volatile fields such as receive timestamps.

When more than one independent consumer processes the same channel, such as multiple subscribers in a publish-subscribe design, each consumer receives its own copy of a message and needs to independently track processing completion. If the consumers share a deduplication store, key the records on a composite of the consumer identity and the message identity. A store keyed on the message identity alone would let the first consumer suppress processing for all the others.

### Decide where to store processed keys

The following storage options are common for processed keys:

- **A dedicated deduplication table.** The consumer maintains a separate table, sometimes called an *inbox*, that holds one row per processed key. This approach keeps deduplication concerns separate from business data and works well if many message types share the same mechanism.

- **The business entity itself.** The consumer stores the key on the record that the message creates or updates. This approach avoids a separate table but couples deduplication to the business data type.

### Commit the processed key and the side effects atomically

A check-then-process flow has a failure window. If a consumer processes a message and then records the key in a separate step, a crash between the two operations leaves the side effects applied but the key unrecorded, so the consumer reprocesses the next redelivery.

Avoid this failure window by writing the deduplication marker and the business side effects in the same transaction. If a consumer commits both operations together or not at all, upon redelivery it either finds the marker and skips the message, or finds no marker because the transaction didn't complete and safely reprocesses the message. This transactional variant is the *Inbox* pattern, and is the consumer-side companion to the producer [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md).

### Guard against concurrent duplicates

Under at-least-once delivery with concurrent [competing consumers](./competing-consumers.md), two instances can receive copies of the same message at the same time. Both instances can pass the existence check before either instance commits, so the check alone doesn't prevent double processing.

Enforce correctness at the data store instead of in application logic by taking the following steps:

- **Use a uniqueness constraint** on the deduplication key such that two transactions can attempt to insert a key, but only one can succeed. The other transaction fails the constraint and treats the message as a duplicate. This approach makes the database the single arbiter of the conflict.

- **Avoid check-then-set races in caches.** A pattern that checks a key and then sets it in two separate operations has a window that lets concurrent retries claim the key. Use an atomic conditional write, such as an insert that fails on conflict or a set-if-absent operation, to make claiming the key a single atomic step.

### Handle side effects that can't join the transaction

Some processes can't participate in the consumer's database transaction, such as calling a third-party API or writing to an external store. Use the following two-phase approach for these processes:

1. Record the key with an *in-progress* state, and then perform the external action.
1. Update the record to *completed* and store the outcome.

On redelivery, a *completed* record tells the consumer to skip repeating the call. An *in-progress* record signals that a previous attempt might be partially completed or is being processed by another consumer. The consumer should reconcile stale records or route unresolved cases for intervention before acknowledging redelivery.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Prefer naturally idempotent operations.** Some operations are inherently idempotent and don't need deduplication bookkeeping. An upsert keyed on a business identifier, a write that sets an absolute value rather than an increment, or an HTTP `PUT` to a resource identifier produce the same results whether they run once or many times.

  You can sometimes make an operation naturally idempotent by using [event-carried state transfer](https://martinfowler.com/articles/201701-event-driven.html#Event-carriedStateTransfer). The message carries the resulting absolute state, such as an order's new status, so the consumer applies it as an upsert instead of a relative change.

  > [!TIP]
  > Design for natural idempotency if possible, and use deduplication techniques only for operations that can't be made naturally idempotent.

- **Use a messaging framework instead of configuring deduplication.** Correctly implementing deduplication storage, commit, and cleanup is error-prone. Message-based frameworks provide this pattern as a built-in feature.

  For example, [NServiceBus](https://docs.particular.net/architecture/consistency) deduplicates incoming messages by their message identifiers and provides configurable retention and cleanup for deduplication data. The [MassTransit consumer outbox](https://masstransit.io/documentation/configuration/middleware/outbox) tracks received messages by their message identifiers to provide exactly-once consumer behavior.

- **Manage the lifecycle of deduplication records.** Deduplication records accumulate unless you set them to expire. Retain each record at least as long as the broker can still redeliver the original message. The size of this window depends on the broker's maximum delivery attempts, its lock or visibility timeout, and the message time-to-live.

  Set a time-to-live on deduplication records that exceeds this window, so that a late redelivery still finds its marker. Deleting records too early reopens the window for duplicates. Account for messages that operators resubmit from dead-letter queues, because these resubmissions can occur long after the normal redelivery window closes.

- **Don't substitute broker deduplication for idempotent consumer logic.** Some platforms filter duplicates at the transport layer. For example, Service Bus [duplicate detection](/azure/service-bus-messaging/duplicate-detection) discards messages that repeat a `MessageId` within a configured time window, which suppresses duplicate producer send retries.

  This feature operates on the send side and within a bounded window, so it doesn't prevent a consumer from processing the same message twice after a redelivery. You still need idempotent consumer logic. Use platform features to reduce duplicate volume, not as a replacement for the Idempotent Consumer pattern.

- **Account for message ordering.** Deduplication removes duplicates, but doesn't guarantee order. If the consumer depends on processing order, combine this pattern with an ordering mechanism such as Service Bus [message sessions](/azure/service-bus-messaging/message-sessions), or include sequence or version data so the consumer can reject stale messages.

- **Instrument for observability.** Emit the deduplication key and a correlation identifier in structured logs, and track a metric for detected duplicates. A rising duplicate rate can indicate producer misconfiguration, an undersized acknowledgment or lock window, or unhealthy consumers. Use [distributed tracing and correlation](/azure/service-bus-messaging/service-bus-end-to-end-tracing) to follow a message across services.

- **Propagate idempotency to downstream calls.** Making the message consumer idempotent doesn't protect the services it calls. When a consumer invokes downstream services as part of processing, propagate the idempotency key so that each service tier can deduplicate its own work.

## When to use this pattern

Use this pattern when:

- You consume messages from a broker that provides at-least-once delivery, which is the default for most brokers.

- Reprocessing a message can produce incorrect results, such as duplicate financial transactions, duplicate resource creation, or repeated notifications.

- Multiple competing consumers process the same channel, which makes concurrent duplicate delivery more likely.

This pattern might not be suitable when:

- The operations the consumer performs are already naturally idempotent, so reprocessing is harmless and deduplication bookkeeping adds cost without benefit.

- The workload can tolerate the effects of occasional duplicate processing, and the cost of a deduplication store outweighs the effect of a duplicate.

### Idempotent processing beyond messaging

This pattern applies idempotency to message consumers, but idempotent processing is a broader reliability principle that can benefit any operation that runs more than once over an identical task. This principle includes extract, transform, load (ETL) transformations that reprocess replayed data, stream processing that resumes from a checkpoint, scheduled jobs that overlap or restart, and webhook or HTTP endpoints that receive duplicate deliveries.

The same core technique applies in each case.

1. Use a stable key to identify the unit of work.
1. Record what you process.
1. Skip or absorb duplicate runs so that repeating the work doesn't change the outcome.

The mechanisms in this article, such as stable keys, atomic markers, and uniqueness constraints, transfer to these contexts even when no message broker is involved.

## Workload design

Evaluate how to use the Idempotent Consumer pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern lets a workload use at-least-once delivery and safe retries without corrupting data, which transforms duplicate delivery from a correctness risk into a tolerated condition. <br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation)<br/> - [Transient faults](/azure/well-architected/design-guides/handle-transient-faults) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following example describes an idempotent consumer that processes orders from Service Bus and persists state in Azure Cosmos DB for NoSQL.

1. A producer sets the Service Bus `MessageId` to a business-level order identifier.
1. The consumer receives the message in [PeekLock](/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock) mode, which makes the message available for redelivery if the consumer doesn't settle it before the lock expires.
1. The consumer's Azure Cosmos DB container partitions on the `/orderId` order identifier and sets the document `id` to the same order identifier, so every copy of a given order resolves to the same logical partition and the order `id` itself serves as the deduplication marker.

The consumer takes the following steps to process each message:

1. Read the message and use its `MessageId` as the deduplication key.
1. Attempt to create the order document with the `id` and partition key both set to the order identifier.
1. If the creation succeeds, complete the message so that Service Bus removes it from the queue.
1. If the creation fails with an HTTP 409 (Conflict) status because a document with that `id` already exists, read the existing document and compare it to the current message.
1. If the stored request hash or immutable business fields match, treat the message as a duplicate, complete it, and skip further processing.
1. If the stored request hash or immutable business fields don't match, send the message to a dead-letter queue and raise an alert, rather than silently discarding the message. The producer might have reused the identifier for different content, or the message details might have changed since the order was first processed.
1. If processing fails for a transient reason, abandon the message so that Service Bus redelivers it, or let the lock expire so another consumer can receive it.

The create operation is atomic, so it serves as both the deduplication check and the write operation. Two consumers that receive copies of the same message can't both create the order. One creation attempt succeeds, and the other attempt returns a conflict and safely discards its duplicate.

When processing must write more than one document, use a [transactional batch](/azure/cosmos-db/transactional-batch) that includes both the deduplication key and the business documents within the same partition key. Because a transactional batch operates within a single logical partition, you choose a partition key that all the documents for one message share. The batch commits all the documents together or none at all, so a crash between processing and acknowledgment can't leave the deduplication marker and the business data out of sync. A batch that tries to create a document that already exists returns a 409 (Conflict) status, which identifies the duplicate.

To make this idempotent consumer also resilient against duplicate send retries, enable [duplicate detection](/azure/service-bus-messaging/duplicate-detection) on the queue. On a Standard or Premium queue, duplicate detection suppresses repeated sends within its history window. The idempotent consumer still handles any duplicates that fall outside that window or that result from redelivery.

## Next step

- [Designing Azure Functions for identical input](/azure/azure-functions/functions-idempotent) provides guidance for building idempotent functions that tolerate duplicate invocations.

## Related resources

- [Asynchronous messaging options in Azure](../guide/technology-choices/messaging.md) describes the messaging infrastructure choices that determine your delivery guarantees and duplicate-handling requirements.

- The [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md), which reliably publishes messages by committing them in the same transaction as the business data, is the publisher side of the Idempotent Consumer pattern.

- The [Retry pattern](./retry.yml) enables applications to handle transient faults by retrying operations, which makes idempotent processing necessary because retries can cause duplicate delivery.

- [Resilient Azure Event Hubs and Azure Functions design](../serverless/event-hubs-functions/resilient-design.md) applies this pattern to functions that Event Hubs triggers, including deduplication techniques for event streams.

