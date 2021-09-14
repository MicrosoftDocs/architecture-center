# Performance and scale

When using Functions with Event Hubs, there are many features and decisions
involved that influence both performance and scale. This section will provide
prescriptive guidance for getting the most out of this dynamic pairing.

## Function grouping

Typically, a function encapsulates a unit of work that processes events in a
timely manner. Examples may include the transformation of an event into a new
data structure, or perhaps an enrichment step in a data pipeline for downstream
applications.

How you group functions may have a direct impact on the performance and scale
capabilities of your function apps. Several [best
practices](https://docs.microsoft.com/azure/azure-functions/functions-best-practices#function-organization-best-practices)
suggest grouping by access rights, deployment, and the usage patterns that
invoke your code.

Additional guidance for grouping functions, as well as storage and consumer
group considerations, include:

- **Hosting a single function within a function app**: Since each function has
    its own memory footprint and usage patterns that can directly affect scale,
    an isolated event hub-triggered function will reduce resource contention
    between other running functions, especially those that are CPU or memory
    intensive.

- **Separate storage accounts for each function app**: Avoid sharing storage
    accounts between function apps. Additionally, do not use the same storage
    account that is used for the function app for other storage operations or
    needs. Since event hub triggered functions can potentially have a high
    volume of storage transactions (for checkpointing), this separation is
    extremely important.

- **Create a dedicated consumer group for each function app**: In a stream
    processing solution, each consumer application equates to a [consumer
    group](https://docs.microsoft.com/azure/event-hubs/event-hubs-features#consumer-groups).
    A function app is a prime example of a consumer application. Consumer groups
    should not be shared between function apps or other consumer applications.
    The following diagram provides an example of two function apps, each with
    their own dedicated consumer groups, reading from an event hub:

    ![Dedicated consumer groups for each function app](./images/event_hubs_functions_consumer_groups.svg)

In summary, each function app should be perceived as a distinct application with
its own, assigned consumer group. This ensures offset integrity for each
consumer and simplifies dependencies in an event streaming architecture. This
configuration, along with providing each event hub-triggered function its own
function app and storage account, helps set the foundation for optimal
performance and scale.

## Function hosting plans

Reviewing [how functions scale on different
plans](https://docs.microsoft.com/azure/azure-functions/functions-scale)
is an important step when assessing hosting options.

When using the Consumption plan, the recommended approach is to designate a
function app for each plan. Function apps in the consumption plan will scale
independently and are most effective when they avoid long running tasks.

The Premium and Dedicated plans are often used to host multiple function apps
and more CPU, or memory intensive, functions. It is important to note that all
the function apps in these plans will scale together. If functions have
different load profiles or unique requirements, it is usually best to host them
in different plans. This is especially true for stream processing applications.

## Event Hubs scaling

When it comes to an Event Hubs namespace, there are several important settings
that need to be evaluated to ensure peak performance and scale. This section
will focus on the Standard tier of Event Hubs and its unique features that
affect scaling when used with Azure Functions. For more information about the
differences between the Dedicated, Premium, Standard and other tiers of Event
Hubs, please visit the
[documentation](https://docs.microsoft.com/azure/event-hubs/event-hubs-quotas#dedicated-tier-vs-standard-tier).

### Understanding throughput units

In the Azure Event Hubs standard tier, throughput is classified as the amount of
data that enters and is read from the namespace within a given period. A
[throughput
unit](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-faq#throughput-units)
(TU) is a mechanism that is used to both measure and manage how much throughput
an Event Hubs namespace will support.

For reference, a *namespace* in Event Hubs may be compared to a *cluster* in
Kafka. For a conceptual mapping between Kafka and Event Hubs, please review this
[table](https://docs.microsoft.com/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview#kafka-and-event-hub-conceptual-mapping).

Each throughput unit is billed on an hourly basis and is shared across all the
event hubs in a namespace. This means that all the applications and services,
that both publish and consume events, are participants that must be accounted
for when choosing the number of allotted TUs. This especially includes Azure
Functions, which can account for the number of bytes and events that are both
published and read from an Event Hub.

Often, the emphasis for determining the number of throughput units is centered
around the point of ingress. However, the aggregate for the consumer
applications, and the rate at which they will process those events must also be
included in the calculation.

### Scale up with auto-inflate

Auto-inflate may be enabled on an Event Hubs namespace to accommodate scenarios
where load increases beyond the configured number of throughput units. This will
ensure that throttling from the service will not occur and that processing,
including the ingesting of events, can continue without any disruptions. Since
throughput units are one of the important settings that also impact costs,
taking advantage of the auto-inflate feature helps address concerns about
overprovisioning.

Auto-inflate is a unique feature of Event Hubs that is often confused with
auto-scale, especially within the context of serverless solutions. It is
important to note that this characteristic in Event Hubs supports the increasing
of throughput units dynamically to support bursts scenarios but does not have a
feature to deflate or scale-down automatically.

For scenarios that require high throughput and cannot be accommodated with the
maximum allotted number of throughput units, consider the Azure Event Hubs
Premium tier or
[Dedicated](https://docs.microsoft.com/azure/event-hubs/event-hubs-dedicated-overview)
cluster.

### Partitions and concurrent functions

When an event hub is created, the number of
[partitions](https://docs.microsoft.com/azure/event-hubs/event-hubs-features#partitions)
must be specified. The partition count remains fixed and cannot be changed
except from the
[Premium](https://docs.microsoft.com/azure/event-hubs/event-hubs-premium-overview)
and
[Dedicated](https://docs.microsoft.com/azure/event-hubs/event-hubs-dedicated-overview)
tiers. When using the event hub trigger for functions, the number of concurrent
function instances can potentially match the number of partitions.

In the consumption plan, the function instances will scale out dynamically to
the meet the number of partitions, if necessary. Other hosting plans, will scale
functions based on the designated number of instances that have been configured.
Ultimately, a one-to-one relationship between the number of partitions and
function instances is the ideal target for maximum throughput in a stream
processing solution.

Optimal parallelism is achieved by having multiple consumers within a consumer
group. For Azure Functions, this translates to many instances of a function
within a function app. The result is referred to as *partition-level
parallelism* or the *maximum degree of parallelism*.

![Maximum degree of parallelism](./images/event_hubs_parallelism.svg)

It might initially make sense to configure as many partitions as possible to
achieve maximum throughput and account for the possibility of a higher volume of
events. However, there are several important factors that must be considered
when many partitions are configured:

- **More partitions could lead to more throughput:** Since the degree of
    parallelism is the number of consumers (function instances), the more
    partitions there are, the higher the concurrent throughput can be. This is
    especially important when sharing a designated number of TUs (throughput
    units) for an event hub with other consumer applications.

- **More functions may require more memory:** As the number of function
    instances increases, so does the memory footprint of resources within the
    function app. At some point, too many partitions could deteriorate
    performance for consumers.

- **Back pressure from downstream services:** As more throughput is generated,
    the potential to overwhelm or receive back pressure from downstream services
    may arise. Consumer fan-out must be accounted for when considering the
    consequences it may have on the surrounding resources. Examples may include
    throttling from other services, network saturation and other forms of
    resource contention that may occur with an increase in throughput.

- **Sparsely populated partitions:** The combination of many partitions and a
    low volume of events can lead to data that is sparely distributed across
    partitions. Instead, a smaller number of partitions can provide more optimal
    performance and resource usage for Azure Functions to consume.

### Availability and consistency

When a partition key or ID is not specified, the Event Hubs service routes an
incoming event to the next available partition. This approach provides high
availability and helps increase throughput for consumers.

If ordering is important, a specific partition may be specified to preserve the
order of events when they are published. A consumer application that reads from
the same partition can then process the events in order. This tradeoff provides
consistency but compromises availability and should only be considered when the
ordering of events is a requirement.

For Azure Functions, ordering is achieved when events are published to a
particular partition and an Event Hub triggered function obtains a lease to the
same partition. Currently, the ability to configure a partition with the Event
Hub output binding is not supported. Instead, using one of the Event Hubs
SDKs is the best approach for publishing to a specific partition.

For a more detailed explanation of the how availability and consistency is
supported by Azure Event Hubs, it is recommended to review this
[article](https://docs.microsoft.com/azure/event-hubs/event-hubs-availability-and-consistency).

## Event Hubs trigger binding

This section will focus on the settings and considerations involved when
optimizing event hub triggered functions for peak performance. Factors include
batch processing, sampling and related features that influence the behavior of
an event hub
[trigger](https://docs.microsoft.com/azure/azure-functions/functions-bindings-event-hubs-trigger)
binding.

### Batching

Functions that are triggered by event hubs can be configured to process a
collection of events, or one event at a time. Processing a batch of events is
more efficient because of the overhead involved for each function invocation.
Unless there is a necessity to process a single event, your function should be
configured to process multiple events whenever it is invoked.

Enabling batching for the event hub trigger binding varies between languages:

- Cardinality in C\# is automatically configured when an array is designated
    for the type in the
    [EventHubTrigger](https://github.com/Azure/azure-functions-eventhubs-extension/blob/dev/src/Microsoft.Azure.WebJobs.Extensions.EventHubs/EventHubTriggerAttribute.cs)
    attribute.

- JavaScript, Python, and other languages, enable batching when the
    cardinality property is set to *many* in the function.json file for the
    function.

For further details and examples regarding how batching is enabled, review the
[attribute and
annotation](https://docs.microsoft.com/azure/azure-functions/functions-bindings-event-hubs-trigger?tabs=javascript#attributes-and-annotations)
options for each supported language.

### Trigger settings

Several configuration settings in the
[host.json](https://docs.microsoft.com/azure/azure-functions/functions-bindings-event-hubs#hostjson-settings)
file play a key role in the performance characteristics of the Event Hub trigger
binding for Azure Functions:

- **maxBatchSize:** This is the maximum number of events the function will
    receive when invoked. It is very important to recognize that this is not the
    minimum number of events, only the maximum. If the number of events received
    is less than this amount, the function will still be invoked with as many as
    are available. Setting the minimum batch size is not possible.

- **prefetchCount:** One of the most important settings when optimizing for
    performance is the prefetch count. This value is referenced by the
    underlying AMQP channel to determine how many messages to fetch and cache
    for the client. The prefetch count should be greater than or equal to the
    maxBatchSize value and is commonly set to a multiple of that amount. Setting
    this value to a number less than the maxBatchSize setting could have a
    negative impact on performance.

- **batchCheckpointFrequency:** As batches are processed by your function,
    this value is used to determine the rate at which a checkpoint is created.
    By default, this value is set to 1 which means that after a function
    successfully processes a batch, a checkpoint is produced. It should be noted
    that a checkpoint is created at the partition level for each reader in the
    consumer group. This interesting blog
    [post](https://shervyna.medium.com/event-triggered-azure-function-replays-retries-a3cb1efd17b5)
    provides some addition insight into the behavior this setting may introduce
    and how it influences replays and retries of events.

The values you set for the trigger binding should be determined over the course
of several performance tests and iterations. It is recommended that changes are
made iteratively and measured consistently to fine tune these options
accordingly. The default values are an effort to provide a starting point for
most event processing solutions.

### Checkpointing

Understanding the concept of
[checkpointing](https://docs.microsoft.com/azure/event-hubs/event-hubs-features#checkpointing)
is critical for Event Hub triggered functions. It is the responsibility of the
Azure Function to checkpoint as events are processed and the setting for the
batch checkpoint frequency is met.

The following concepts are important in understanding the relationship between
checkpointing and how your function will process events:

- **Exceptions still count towards success:** Provided that the function
    process does not crash while processing events, the completion of the
    function will be considered successful. Catching and handling exceptions
    should still be a defensive approach in the function code. When successful,
    the function will evaluate the setting for the batch frequency checkpoint
    and create a checkpoint if it has been reached, regardless of exceptions
    that may have occurred during processing.

- **Batch frequency matters:** In high volume event streaming solutions, it
    may be beneficial to change the batchCheckpointFrequency setting to a value
    greater than 1. Increasing this value can help reduce the rate of which a
    checkpoint is created, which will lessen the number of I/O operations to the
    storage account and yield higher performance.

- **Replays may happen:** Each time an Azure Function is invoked with the
    Event Hub trigger binding, it uses the most recent checkpoint to determine
    where to resume processing. It has been stressed that the offset for every
    consumer is saved at the partition level for each consumer group. Replays
    happen when a checkpoint did not occur during the last invocation of the
    function, and it is invoked again. See the section below on Idempotency for
    more information on duplicates and deduplication techniques.

Understanding checkpointing becomes critical when considering best practices for
error handling and retries, which will be covered in a later section of this
article.

#### Resources

- [Event Hub triggered Azure function: Replays and
    Retries](https://shervyna.medium.com/event-triggered-azure-function-replays-retries-a3cb1efd17b5)
- [Checkpointing in Event
    Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-features#checkpointing)
- [Azure Functions reliable event
    processing](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reliable-event-processing)
- [Designing Azure Functions for identical input \| Microsoft
    Docs](https://docs.microsoft.com/en-us/azure/azure-functions/functions-idempotent)

### Telemetry Sampling

Azure Functions provides built-in support for [Application
Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview).
With this feature, you can collect log, performance, and information about
runtime exceptions that occur within your functions. This powerful setup offers
some key configuration choices that will affect performance. Some of the notable
settings and considerations for monitoring and performance are:

- **Enable telemetry sampling**: for high throughput scenarios, you should
    evaluate the amount of telemetry and information that you will need. Review
    the telemetry
    [sampling](https://docs.microsoft.com/azure/azure-monitor/app/sampling)
    feature in Application Insights to avoid degrading the performance of your
    function with unnecessary telemetry data and metrics.

- **Configure aggregation settings:** Examine and configure the frequency in
    which data is aggregated and sent to Application Insights. This
    configuration setting is in the
    [host.json](https://docs.microsoft.com/azure/azure-functions/functions-host-json)
    file along with many other sampling and logging related options.

- **Disable AzureWebJobDashboard**: For apps that target version 1.x of the
    Azure Functions runtime, this setting stores the connection string to a
    storage account that is used by the Azure SDK to retain logs for the WebJobs
    dashboard. If Application Insights is used in favor of the WebJobs
    dashboard, then this setting should be removed.

It is important to mention that when Application Insights is enabled without
sampling, **all** telemetry information will be sent. Sending each event may
have a detrimental effect on the overall performance of the function, especially
under high throughput event streaming circumstances.

Taking advantage of sampling and continually assessing the appropriate amount of
telemetry needed for monitoring is one of the many, crucial settings available
for optimum performance. Telemetry should be used for general platform health
evaluation in the aggregate and for occasional troubleshooting, and not to
capture core business metrics.

References

- [Configure the
    aggregator](https://docs.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-the-aggregator)
- [Configure
    sampling](https://docs.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-sampling)
- [AzureWebJobsDashboard](https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#azurewebjobsdashboard)
- [Monitor Azure
    Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring)

## Output binding

Publishing to an event stream from an Azure Function is extremely simple with
the
[output](https://docs.microsoft.com/azure/azure-functions/functions-bindings-event-hubs-output)
binding for Event Hubs. Several of the benefits of using the binding include:

- **Resource management**: The binding handles both the client and connection
    lifecycles for you. This reduces the potential for issues that may arise
    with port exhaustion and connection pool management.

- **Less code**: The binding abstracts the underlying SDK and reduces the
    amount of code needed to publish events. This results in code that is easier
    to write and maintain.

- **Batching**: For several languages, batching is supported to efficiently
    publish to an event stream. This can improve performance and help streamline
    code that sends the events.

It is highly recommended that you review the list of [supported
languages](https://docs.microsoft.com/azure/azure-functions/supported-languages)
for Azure Functions and their respective developer guides. The *Bindings*
section for each language provides detailed examples and documentation.

### Batching

If your function only publishes a single event, configuring the binding with a
return value is a common approach. This is helpful if the function execution
always ends with a statement that sends the event. Using the return value
is a pattern that should only be used for synchronous functions that return only
one event.

Batching is encouraged to improve performance when sending multiple events to a
stream. Batching allows the binding to publish events in the most efficient
possible way.

Support for sending multiple events with the output binding to Event Hubs is
available in C\#, Java, Python and JavaScript.

### Output multiple events in C\#

Use the
[ICollector](https://github.com/Azure/azure-webjobs-sdk/blob/master/src/Microsoft.Azure.WebJobs/ICollector.cs)
and
[IAsyncCollector](https://github.com/Azure/azure-webjobs-sdk/blob/master/src/Microsoft.Azure.WebJobs/IAsyncCollector.cs)
types when sending multiple events from a function in C\#.

- ICollector\<T\>.Add(event) can be used in both synchronous and asynchronous
functions. It will execute the add operation as soon as it is called.
- IAsyncCollector\<T\>.AddAsync(event) prepares the events to be published to the
event stream. If you are writing an asynchronous function, it is recommended
that you leverage IAsyncCollector to manage the events that will be published.

Refer to the
[documentation](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-hubs-output?tabs=csharp)
for examples of publishing both single and multiple events using C\#.

### Throttling and back pressure

Throttling considerations apply to output binding as well, not only for Event
Hubs but also for Azure services such as [Cosmos
DB](https://docs.microsoft.com/azure/cosmos-db/). In general, it’s
important to become familiar with the limits and quotas that apply to those
services and to plan accordingly.

To handle downstream errors, you can catch exceptions from IAsyncCollector by
wrapping AddAsync and FlushAsync in an exception handler for .NET Azure
Functions, or not use output bindings and use the Event Hubs SDKs directly.

## Function code

This section will cover the key areas that must be considered when writing code
to process events from an Event Hub triggered function.

### Asynchronous programming

Generally, it is recommended to have your function employ non-blocking,
[asynchronous](https://docs.microsoft.com/azure/azure-functions/functions-best-practices#use-async-code-but-avoid-blocking-calls)
code. This is particularly important when I/O calls are involved.

When considering asynchronous programming in an Azure Function, there are some
essential guidelines that should be followed:

- **All asynchronous or all synchronous:** If a function is configured to run
    asynchronously, all the I/O calls should be asynchronous as well. In most
    cases, being partially asynchronous can be worse than code that is entirely
    synchronous. Choose either asynchronous or synchronous for the
    implementation of the function and follow it all the way through.

- **Avoid blocking calls:** Blocking calls return to the caller only after the
    call completes. This is very different than asynchronous calls that return
    immediately. An example in C\# would be calling **Task.Result** or
    **Task.Wait** on an asynchronous operation.

### More about blocking calls

When blocking calls are made on asynchronous operations, it can lead to
thread-pool starvation and cause the function process to crash. This happens
because a blocking call requires another thread to be created to compensate for
the original call that is now waiting. As a result, it now requires twice as
many threads to complete the operation.

Avoiding this *sync over async* approach is especially important when Event Hubs
is involved since a crash to the function will not update the checkpoint. The
next time the function is invoked it could end up in this cycle and appear to be
*stuck* or move along very slowly as function executions will eventually
timeout.

Troubleshooting this phenomenon usually starts with reviewing the trigger
settings and running experiments that may involve increasing the partition
count. Investigations can also lead to changing several of the batching options
such as the max batch size or prefetch count. The impression is that it is a
throughput problem or configuration setting that just needs to be tuned
accordingly. However, the core problem is in the code itself and must be
addressed there for the proper resolution.

## References

- [Use async code but avoid blocking
    calls](https://docs.microsoft.com/en-us/azure/azure-functions/functions-best-practices#use-async-code-but-avoid-blocking-calls)
- [Async
    guidance](https://github.com/davidfowl/AspNetCoreDiagnosticScenarios/blob/master/AsyncGuidance.md)

## Next steps

Review considerations for [resilient Event Hubs and Functions design](./resilient-design.md).
