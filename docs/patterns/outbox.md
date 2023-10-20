The Outbox design pattern is a way to ensure message handling logic can deal with duplicate messages.

## Context and problem

The biggest advantage of using messaging over remote procedure call (RPC) technologies is the _at-least_once_ characteristics of message processing. This means that a message is not lost after an unsuccessful attempt at processing it but rather is put back to the queue and delivered again, until it is eventually successfully acknowledged. 

While this characteristic is great for ensuring no information is lost by the running system, it has an inherent drawback that any given message may be delivered to the processing code multiple times. In absence of code that guards against processing a message multiple times the data quickly becomes corrupted by updates applied multiple times.

Historically this issue has been mitigated by distributed transcation technologies implementing Two-Phase Commit protocol (2PC) like Microsoft Distributed Transaction Coordinator. Such technologies allowed a single transaction to span both the messaging infrastructure and the database, ensuring that either:
 - all the data is updated and the message is consumed
 - no data is updated and the message is returned back to the queue

Due to the issues with scalability and performance of the 2PC protocol, the distributed transaction technologies are no longer available for modern messaging technologies, such as Azure Service Bus and developers need to write code protecting against duplicate processing into their message handling logic. Adding such logic to a message handling code is referred to as making that code _idempotent_. 

In mathematics, where the term originates, _idempotence_ is a property of fuctions. A given function _f_ is _idempotent_ if and only if _f(f(x)) = (x)_. In the cotext of the HTTP protocol, [RFC 7231](https://datatracker.ietf.org/doc/html/rfc7231#section-4), states, "A ... method is considered _idempotent_ if the intended effect on the server of multiple identical requests with that method is the same as the effect for a single such request.". The latter is hepful in attempt to define _idempotence_ for the message handling problem:

> An independent message handling code is one that produces the same side effects regardless of how many times a given message has been delivered

The well-documented approach to the challenge of making message handling code _idempotent_ is to add a check, prior to executing the code, if the side effects have already been applied. This is illustrated by the following pseudocode:

```c#
if (!HasBeenProcessed(message))
{
    return;
}
Process(message);
MarkProcessed(message);
```

It does not, however, take into account that a typical message handling code affects multiple external resources, i.e. a database (store or update some data) and a messaging infrastructure (send follow-up messages). In other words, it may happen that the first attempt at processing a message resulted in updating a database but failed to send out messages. The message is put back into the queue, picked up again and the second attempt manages to send the messages. 

In order for that logic to be consistent, both attempts have to see exactly the same state, including but not limited to:
 - data in all queried data stores
 - environment properties, e.g. data and time
 - pseudo-random value generators
 - sequeces, e.g. GUID

## Solution

The solution to this problem is to split the execution of the message handling logic into two parts:
 - compute the side effects
 - apply the side effects

and is based on the assumption that, once side effects are computed and made persistent, they can always be applied. This, of course, is not true for most interactions with database in any environment that allows concurret access. For that reason, one resource, usually the database, is designated as primary. The primary resource plays double role. In addition to being the target for the side effects, it also is used to store the computed side effects that target other resources. The resulting algorithm for the Outbox pattern is following:

```c#
if (!HasBeenProcessed(message))
{
    return;
}
ComputeSideEffects(message);
var tx = BeginTransaction();
ApplySideEffectsToPrimary(tx);
StoreSideEffects(tx);
MarkProcessed(message, tx);
tx.Commit();
CleanUpSideEffects(tx);
```

The Outbox pattern can be implemented in the infrastructure layer of the solution ensuring that all message handlers running on top of that infrastructure are automatically made _idempotent_. The alternative is ensure each individual message handler is _idempotent_ by applying techniques some of the following techniques:

- do not access more than one resource in any message handler
- use deterministic or domain identifiers instead of GUIDs
- do not rely on system clock or pseudo-random value generators
- use idempotent-by-design data structures

### Benefits

- Provides programming simple programming abstraction, simialar to one exposed by distributed transaction technologies
- Can be implemented in the infrastructure layer with minimal effect to message handling code, allowing smooth transition away from distributed transaction technologies
- Supports resources that never had been able to participate in distributed transactions, such as key-value stores
- Has relatively mild requirements for the primary resource -- optimistic concurrency control

### Drawbacks

- Generates more traffic with the primary resource (database) in form of two additional operations requiring a round-trip: checking if a message has been processed and cleaning up the side effects.
- Requires that the primary resource supports optimistic concurrency control
- Requires storing information about all previously processed messages. In principle that information should never be removed but in practice often age-based approach is used to prevent data from growing indefinitely. 

## Issues and considerations

Consider the following points when implementing the Outbox pattern:

- In order to take advatage of the pattern, each message needs to have a unique identifier. Most messaging technologies, e.g. Azure Service Bus, provide this identifier out-of-the-box, but all.
- Consider how long to store information about processed messages. The likelihood of message being duplicated diminishes with time significantly. In practice value of 1 or 2 weeks is often used as maximum age to keep the deduplication data.
- Depending on the technology used for the primary resource, it might or might not be possible to use native features to remove expired dedupliction data. For example, Cosmos DB has a built in time-to-live mechanism that can be used to ensure message processing information is removed after configured time.
- The clock for removing deduplication data can only be started after the `CleanUpSideEffects` operation succeeds. Otherwise there is a risk of losing the side effects if a message is stuck for extended period of time, e.g. falsly identified as a _poison message_ and sent to a _dead-letter queue_.
- Side effects other than sending or publishing messages are supported provided the likelihood of failure to apply them is negligible, e.g. creating or updating a document in a key-value store.  

## When to use this pattern

Use the Outbox pattern when you:

- Use modern messaging technology, such as Azure Service Bus, to build line-of-business applictions where you cannot afford to lose messages or duplicate the processing. 

This pattern might not be suitable if:

- When using messaging to transfer portions of information that do not have high value e.g. sensor readings
- When using another pattern that provides similar consistency guarantees e.g. Event Sourcing
- When building components that require extremely low-latency processing. In this case it might be better to use _idempotency_ techniques optimized for each message handler e.g. taking advantage of _idempotent_ data structures 

## Example

TBD

## Next steps

The following information may be relevant when implementing this pattern:

- https://exactly-once.github.io/
- Example with Cosmos DB https://learn.microsoft.com/en-us/azure/architecture/best-practices/transactional-outbox-cosmos
- Outbox in NServiceBus https://docs.particular.net/nservicebus/outbox/

TBD

## Related resources

- https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing
- https://learn.microsoft.com/en-us/azure/architecture/patterns/retry

TBD
