# Resilient Event Hubs and Functions design

Error handling, designing for idempotency and managing retry behavior are a few
of the critical measures you can take to ensure that Event Hub triggered
functions are resilient and capable of handling large volumes of data. This
section will cover these crucial topics and make available a set of
recommendations for serverless event-streaming solutions.

Azure provides three [messaging
services](https://docs.microsoft.com/azure/event-grid/compare-messaging-services)
that can be used with Azure Functions to support a wide range of unique,
event-driven scenarios. Event Hubs is commonly used for event streaming, big
data settings, due to its partitioned consumer model and ability to ingest data
at a very high rate. For a detailed comparison of Azure messaging services,
please review this
[article](https://docs.microsoft.com/azure/event-grid/compare-messaging-services).

## Streaming benefits and challenges

Understanding the benefits and drawbacks of streams will provide an appreciation
for how a service like [Event
Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-about)
operates. This invaluable context is also needed when making impactful
architectural decisions, troubleshooting issues, and optimizing for performance.
To successfully build resilient solutions with Azure Event Hubs and Azure
Functions, the following essential points must be realized:

- **Streams are not queues:** Event Hubs, Kafka and other similar offerings
    that are built on the partitioned consumer model, do not intrinsically
    support some of the principal features in a message broker, such as [Service
    Bus](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview).
    Perhaps the biggest indicator of this is the fact that reads are
    **non-destructive**. This means that the data that is read by an Azure
    Function is not deleted afterwards. Instead, it is immutable and remains for
    other consumers, and possibly even the same ones, to read again. For this
    reason, solutions that aim to implement patterns such as [competing
    consumers](https://docs.microsoft.com/azure/architecture/patterns/competing-consumers),
    are better suited for a traditional message broker.

- **Missing inherit dead-letter support:** A dead-letter channel is not a
    native feature in Event Hubs or Kafka. Often, the *concept* of
    dead-lettering is integrated into a streaming solution to account for data
    that cannot be processed. This functionality is intentionally not an innate
    element in Event Hubs and is only added on the consumer side to manufacture a
    similar behavior or effect. Like the previous comment regarding queues, the
    need for this functionality may be an opportunity to reflect on the
    appropriate messaging service for the type of processing required.

- **A unit of work is a partition:** In a traditional message broker, a unit
    of work is a single message. In a streaming solution, a partition is often
    considered the unit of work. If each event in an event hub is regarded as a
    discrete message that requires it to be treated like an order processing
    operation or financial transaction, it is most likely an indication of the
    wrong messaging service being used.

- **No server-side filtering:** One of the reasons Event Hubs is capable of
    tremendous scale and throughput is due to the very low overhead on the
    service itself. Features like server-side filtering, indexes, and
    cross-broker coordination are not part of the architecture of Event Hubs.
    Azure Functions are occasionally used to filter events by routing them to
    other Event Hubs based on the contents in the body or header. This approach
    is very common in event streaming but comes with the caveat that each event
    is read and evaluated by the initial function.

- **Every reader must read all data:** Since server-side filtering is
    unavailable, a consumer sequentially reads all the data in a partition. This
    includes data that may not be relevant or could even be malformed. There are
    several options and even strategies that can be used to compensate for these
    challenges that will be covered later in this section.

These significant design decisions allow Event Hubs to do what it does best:
support a significant influx of events and provide a robust and resilient
service for consumers to read from. Each consumer application is tasked with the
responsibility of maintaining their own, client-side offsets or cursor to those
events. The low overhead makes Event Hubs an affordable and powerful option for
event streaming.

## Idempotency

One of the core tenets of Azure Event Hubs is the concept of at-least once
delivery. This approach ensures that events will always be delivered. It also
means that events can be received more than once, even repeatedly, by consumers
such as an Azure Function. For this reason, it is important that an Event Hub
triggered function supports the [Idempotent
Consumer](https://microservices.io/patterns/communication-style/idempotent-consumer.html)
pattern.

Working under the assumption of at-least once delivery, especially within the
context of an event-driven architecture, is a responsible approach for reliably
processing events. Your function must be idempotent so that the outcome of
processing the same event multiple times is the same as processing it once.

### How duplicates happen

There are several different scenarios that could result in duplicate events
being delivered to an Azure Function:

- **Checkpointing:** If the Azure Function host crashes, or the threshold set
    for the [batch checkpoint
    frequency](https://docs.microsoft.com/azure/azure-functions/functions-bindings-event-hubs#hostjson-settings)
    is not met, a checkpoint will not be created. As a result, the offset for
    the consumer is not advanced and the next time the function is invoked, it
    will resume from the last checkpoint. It is important to note that
    checkpointing occurs at the partition level for each consumer.

- **Duplicate events published:** There are many techniques that could
    alleviate the possibility of the same event being published to a stream,
    however, it is still the responsibility of the consumer to idempotently
    handle duplicates.

- **Missing acknowledgments:** In some situations, an outgoing request to a
    service may be successful, however, an acknowledgment (ACK) from the service
    is never received. This might result in the perception that the outgoing
    call failed and initiate a series or retries or other outcomes from the
    function. In the end, duplicate events could be published, or a checkpoint
    is not created.

### Deduplication techniques

Designing your Azure Function for [identical
input](https://docs.microsoft.com/azure/azure-functions/functions-idempotent)
should be the default approach taken when paired with the Event Hub trigger
binding. Techniques that should be considered, are:

- **Looking for duplicates:** Before processing, take the necessary steps to
    validate that the event should be processed. In some cases, this will
    require an investigation to confirm that it is still valid. It could also be
    possible that handling the event is no longer necessary due to data
    freshness or logic that invalidates the event.

- **Design events for idempotency:** By providing additional information
    within the payload of the event, it may be possible to ensure that
    processing it multiple times will not have any detrimental effects. Take the
    example of an event that includes an amount to withdrawal from a bank
    account. If not handled responsibly, it is possible that it could decrement
    the balance of an account multiple times. However, if the same event
    includes the updated balance to the account, it could be used to perform an
    upsert operation to the bank account balance. This event-carried state
    transfer approach occasionally requires coordination between producers and
    consumers and should be used when it makes sense to participating services.

### References

- [Azure Functions reliable event
    processing](https://docs.microsoft.com/azure/azure-functions/functions-reliable-event-processing)
- [Designing Azure Functions for identical
    input](https://docs.microsoft.com/azure/azure-functions/functions-idempotent)

## Error handling and retries

Error handling and retries are a few of the most important qualities of
distributed, event-driven applications, and Functions are no exception. For
event streaming solutions, the need for proper error handling support is
crucial, as thousands of events can quickly turn into an equal number of errors
if they are not handled correctly.

### Error handling guidance

Without error handling, it can be tricky to implement retries, detect runtime
exceptions, and investigate issues. Every Azure Function should have at the very
minimum, some level or error handling. A few recommended guidelines are:

- **Use Application Insights:** Enable and use Application Insights to log
    errors and monitor the health of your Azure Functions. Be mindful of the
    configurable sampling options for scenarios that process a high volume of
    events.

- **Add structured error handling:** Apply the appropriate error handling
    constructs for each programming language to catch, log, and detect
    anticipated and unhandled exceptions in your function code. For instance,
    use a try/catch block in C\#, Java and JavaScript and take advantage of the
    [try and
    except](https://docs.python.org/3/tutorial/errors.html#handling-exceptions)
    blocks in Python to handle exceptions.

- **Logging:** Catching an exception during execution provides an opportunity
    to log critical information that could be used to detect, reproduce, and fix
    issues reliably. Log the exception, not just the message, but the body,
    inner exception and other useful artifacts that will be helpful later.

- **Do not catch and ignore exceptions:** One of the worst things you can do
    is catch an exception and place an empty code block on it. If you catch a
    generic exception, log it somewhere, otherwise it will become extremely
    difficult to investigate bugs and reported issues.

### Retries

Implementing retry logic in an event streaming architecture can be quite
complex. Supporting cancellation tokens, retry counts and exponential back off
strategies are just a few of the considerations that make it challenging.
Fortunately, Azure Functions provides [retry
policies](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-error-pages?tabs=csharp#retry-policies-preview)
that can make up for many of these tasks that you would typically code yourself.

Several important factors that must be considered when using the retry policies
with the Event Hub binding, include:

- **Avoid indefinite retries:** When the [max retry
    count](https://docs.microsoft.com/azure/azure-functions/functions-host-json#retry)
    setting is set to a value of -1, the function will retry indefinitely. In
    general, indefinite retries should be used very sparingly with Azure
    Functions and almost never with the Event Hub trigger binding.

- **Choose the appropriate retry strategy:** A [fixed
    delay](https://docs.microsoft.com/azure/azure-functions/functions-bindings-error-pages?tabs=csharp#fixed-delay-retry)
    strategy may be optimal for scenarios that receive back pressure from other
    Azure services. In these cases, the delay could be used to avoid throttling
    and other limitations encountered from those services. The [exponential
    back off](https://docs.microsoft.com/azure/azure-functions/functions-bindings-error-pages?tabs=csharp#exponential-backoff-retry)
    strategy offers more flexibility in regard to the retry delay interval and
    is commonly used when integrating with 3rd party services, REST endpoints
    and other Azure services as well.

- **Keep intervals and retry counts low:** Attempt to maintain a short retry
    interval, if possible, perhaps never exceeding 1 minute. The same applies to
    the maximum number of retry attempts, which should also be a reasonably
    small value. These settings are especially pertinent when running in the
    Azure Functions consumption plan.

- **Circuit breaker pattern:** A transient fault error from time to time is
    expected and a natural use case for retries. However, if a significant
    number of failures or issues are occurring during the processing of the
    Azure Function, it may make sense to stop the function, address the issues
    and restart later.

An important takeaway for the retry policies in Azure Functions is that it is a
best effort feature for reprocessing events. It does not substitute the need for
error handling, logging and other important patterns that provide resiliency to
your code.

### References

- [Azure Functions error handling and retry guidance \| Microsoft
    Docs](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-error-pages?tabs=csharp)
- [Azure Functions retry policy
    options](https://docs.microsoft.com/en-us/azure/azure-functions/functions-host-json#retry)

## Strategies for failures and corrupt data

There are several noteworthy approaches that, based on circumstances, could be
used to compensate for issues that arise due to failures or bad data in an event
stream. Some fundamental tactics are:

- **Stop sending and reading:** Pause the reading and writing of events to fix
    the underlying issue. The benefit of this approach is that data will not be
    lost, and operations could resume after a fix is rolled out. This may
    require a circuit-breaker component in the architecture and possibly a
    notification to the affected services to achieve. In some cases, stopping an
    Azure Function may be necessary until the issues are resolved.

- **Drop messages:** If messages are not important or are considered
    non-mission critical, consider moving on and not processing them. This does
    not work for scenarios that require strong consistency such as recording
    moves in a chess match or finance-based transactions. Error handling inside
    of an Azure Function would be a recommended approach for catching and
    dropping messages that cannot be processed.

- **Retry:** There are many situations that may warrant the reprocessing of an
    event. The most common scenario would be a transient error encountered when
    calling another service or dependency. Network errors, service limits and
    availability, and strong consistency are perhaps the most frequent use cases
    that justify reprocessing attempts.

- **Dead letter:** The idea here is to publish the event to a different event
    hub so that the existing flow is not interrupted. The perception is that it
    has been moved off the hot path and could be dealt with later or by a
    different process. This solution is used frequently for handling poisoned
    messages or events. It should be noted that each Azure Function, that is
    configured with a different consumer group, will still encounter the bad or
    corrupt data in their stream and must handle it responsibly.

- **Retry and dead letter:** The combination of numerous retry attempts before
    ultimately publishing to a dead letter stream once a threshold is met, is
    another familiar method.

- **Use a schema registry:** A schema registry can be used as a proactive tool
    to help improve consistency and data quality. The [Azure Schema
    Registry](https://docs.microsoft.com/en-us/azure/event-hubs/schema-registry-overview)
    can support the transition of schemas along with versioning and different
    compatibility modes as schemas evolve. At its core, the schema will serve as
    a contract between producers and consumers, which could reduce the
    possibility of invalid or corrupt data being published to the stream.

In the end, there isn’t a perfect solution and the consequences and tradeoffs of
each of the strategies needs to be thoroughly examined. Based on the
requirements, using several of these techniques together may be the best
approach.

## Next steps

Read about [security](./security.md).
