The Outbox design pattern is a way to ensure message handling logic can deal with duplicate messages.

## Context and problem

The biggest advantage of using messaging over remote procedure call (RPC) technologies is the _at-least_once_ characteristics of message processing. This means that a message is not lost after an unsuccessful attempt at processing it but rather is put back to the queue and delivered again, until it is eventually successfully acknowledged. 

While this characteristic is great for ensuring no information is lost by the running system, it has an inherent drawback that any given message may be delivered to the processing code multiple times. In absence of code that guards against processing a message multiple times the data quickly becomes corrupted by updates applied multiple times.

Historically this issue has been mitigated by distributed transcation technologies implementing Two-Phase Commit protocol (2PC) like Microsoft Distributed Transaction Coordinator. Such technologies allowed a single transaction to span both the messaging infrastructure and the database, ensuring that either:
 - all the data is updated and the message is consumed
 - no data is updated and the message is returned back to the queue

Due to the issues with scalability and performance of the 2PC protocol, the distributed transaction technologies are no longer available for modern messaging technologies, such as Azure Service Bus and developers need to write code protecting against duplicate processing into their message handling logic. Adding such logic to a message handling code is referred to as making that code _idempotent_. 

In mathematics, where the term originates, _idempotence_ is a property of functions. A given function _f_ is _idempotent_ if and only if _f(f(x)) = f(x)_. In the context of the HTTP protocol, [RFC 7231](https://datatracker.ietf.org/doc/html/rfc7231#section-4), states, "A ... method is considered _idempotent_ if the intended effect on the server of multiple identical requests with that method is the same as the effect for a single such request.". The latter is helpful in attempt to define _idempotence_ for the message handling problem:

> An independent message handling code is one that produces the same effects regardless of how many times a given message has been delivered

The well-documented approach to the challenge of making message handling code _idempotent_ is to add a check, prior to executing the code, if the code was already executed, usually by checking some external resource like a database. This is illustrated by the following pseudocode:

```c#
if (HasBeenProcessed(message))
{
    return;
}
Process(message);
MarkProcessed(message);
```

It does not, however, take into account that typical message handling code affects multiple external resources, i.e. a database (store or update some data) and messaging infrastructure (send follow-up messages). In other words, it may happen that the first attempt at processing a message resulted in updating the database but crashed before being able to send out messages. In that case, the message is "rolled back" to the queue, after which it will be picked up and attempted to be processed again. 

In order for the system to eventually arrive at a consistent state, the logic of processing the message the second time must correctly emit the messages that should have been emitted after the first processing attempt, but not make any other changes to the database. This can pose a significant challenge because typically business code includes any number of external inputs that change from one invocation to the next:
 - data stores
 - environment properties, e.g. data and time
 - pseudo-random value generators
 - sequences, e.g. GUID

## Solution

Given multiple resources that can be affected during the processing of a message, the solution to the problem is to split the execution of the message handling logic into two parts:
 - compute the effects against each resource and persist them
 - apply these effects

It is based on the assumption that once the effects are computed and made persistent they can always be applied against their respective resources. This, of course, is not true for most interactions with database in any environment that allows concurret access. For that reason the practical solution needs to distinguish between the primary and secondary (_side_) affects. One resource is designated primary and plays a double role. The effects of the message handling are applied to the primary resource _immediately_ in the same transaction as storing all _side_ effects. Only after this transaction is committed, the _side_ effects are applied e.g. messages are sent out. 

The assumption is that the _side_ effect application never fails. The resulting algorithm for the Outbox pattern is following:

```c#
if (HasBeenProcessed(message))
{
    return;
}
ComputeEffects(message);
var tx = BeginTransaction();
ApplyEffectsToPrimary(tx);
StoreSideEffects(tx);
MarkProcessed(message, tx);
tx.Commit();

ApplySideEffects();
CleanUpSideEffects();
```

The Outbox pattern can be implemented in the infrastructure layer of the solution ensuring that all message handlers running on top of that infrastructure are automatically made _idempotent_. The alternative is ensure each individual message handler is _idempotent_ by applying techniques some of the following techniques:

- do not access more than one resource in any message handler
- use deterministic or domain identifiers instead of GUIDs
- do not rely on system clock or pseudo-random value generators
- use idempotent-by-design data structures

### Benefits

- Provides a simple programming abstraction, similar to one exposed by distributed transaction technologies
- Can be implemented in the infrastructure layer with minimal effect to message handling code, allowing smooth transition away from distributed transaction technologies
- Supports resources that never had been able to participate in distributed transactions, such as key-value stores
- Has relatively mild requirements for the primary resource -- optimistic concurrency control

### Drawbacks

- Generates more traffic with the primary resource (database) in form of two additional operations requiring a round-trip: checking if a message has been processed and cleaning up the side effects.
- Requires that the primary resource supports optimistic concurrency control
- Requires storing information about all previously processed messages. In principle that information should never be removed but in practice often age-based approach is used to prevent data from growing indefinitely. 

## Issues and considerations

Consider the following points when implementing the Outbox pattern:

- In order to take advantage of the pattern, each message needs to have a unique identifier. Many messaging technologies like Azure Service Bus provide this identifier out-of-the-box, but in some of them, it is not set automatically.
- Consider how long to store information about processed messages. The likelihood of message being duplicated diminishes with time significantly. In practice value of 1 or 2 weeks is often used as maximum age to keep the deduplication data.
- Depending on the technology used for the primary resource, it might or might not be possible to use native features to remove expired dedupliction data. For example, Cosmos DB has a built in time-to-live mechanism that can be used to ensure message processing information is removed after configured time.
- The clock for removing deduplication data can only be started after the `CleanUpSideEffects` operation succeeds. Otherwise there is a risk of losing the side effects if a message is stuck for extended period of time, e.g. falsly identified as a _poison message_ and sent to a _dead-letter queue_.
- Side effects other than sending or publishing messages are supported provided the likelihood of failure to apply them is negligible, e.g. creating or updating a document in a key-value store.

### Side effects application

The design of the side effects application is a major consideration when implementing the outbox pattern. There are three major approaches to the problem.

#### Background worker

In this approach an external process periodically polls the data store where the side effects are persisted. The advantage of this approach is the fact that it can also be used at the boundary of the system e.g. when processing incoming HTTP requests and sending out messagess. There are, however, significant disadvantages of this approach. First, it relies on querying the data store for all outstanding side effects. This query pattern might be expensive or even impossible in certain partitioned data stores (e.g. Cosmos DB). The second issue is the fact that polling implies the code is executed periodically. Such requirement makes deployment in serverless environments (e.g. Azure Functions) problematic as the worker needs to use a dedicated (timer) trigger. Finally, the polling mechanism has poor scalability characteristics. Higher side effect processing throughput cannot be simply achieved by deployment multiple background workers as they would compete to process the same items. 

#### Incoming message

An alternative approach is to use the incoming message as a driver for side effects application. In this approach the side effects are applied immediately after the main transaction is committed and before the incoming message is consumed. If the application fails, the incoming message simply goes back to the queue and is picked up again. This time the business processing is skipped and only the side effects application is performed.

This approach scales well, does not require any dedicated deployment items and does not rely on cross-partition queries. Its disadvantage is the fact that it cannot be used at the system boundary.

#### Control message

In this approach the side effects application is driven by a special control message that is dispatched prior to committing the main transaction. The processing logic of this message has a built-in delay mechanism to give the main transaction some time to commit (e.g. 30 seconds). If that does not happen, a special record is created that prevents the transaction completion and the control message is dropped. 

This method has the same benefits as the approach based on the incoming message but has been adapted for usage at the boundary of the system where there is not incoming durable message.

## When to use this pattern

Use the Outbox pattern when you:

- Use modern messaging technology, such as Azure Service Bus, to build line-of-business applictions where you cannot afford to lose messages or duplicate the processing. 

This pattern might not be suitable if:

- When using messaging to transfer portions of information that do not have high value e.g. sensor readings
- When using another pattern that provides similar consistency guarantees e.g. Event Sourcing
- When building components that require extremely low-latency processing. In this case it might be better to use _idempotency_ techniques optimized for each message handler e.g. taking advantage of _idempotent_ data structures 

## Example

Check out [this example of using the Outbox pattern with CosmosDB](https://learn.microsoft.com/en-us/azure/architecture/databases/guide/transactional-outbox-cosmos). This specific implementation uses a background worker to apply the side effects (sent outgoing messages).

## Next steps

The following information may be relevant when implementing this pattern:

- https://exactly-once.github.io/ contains resources on message deduplication techniques
- Example with Cosmos DB https://learn.microsoft.com/en-us/azure/architecture/best-practices/transactional-outbox-cosmos
- Outbox in NServiceBus https://docs.particular.net/nservicebus/outbox/

## Related resources

- https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing
- https://learn.microsoft.com/en-us/azure/architecture/patterns/retry
