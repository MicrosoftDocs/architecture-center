<!---content for performance-scale.yml--->
When using Azure Functions with Event Hubs, there are many features and decisions involved that influence both performance and scale. This article provides prescriptive guidance for getting the most out of this dynamic pairing.

## Function grouping

Typically, a function encapsulates a unit of work that processes individual events. This work may include the transformation of an event into a new data structure, or perhaps an enrichment step in a data pipeline for downstream applications.

How you group functions may have a direct effect on the performance and scale capabilities of your function apps. Several [best practices](/azure/azure-functions/functions-best-practices#function-organization-best-practices) suggest grouping by access rights, deployment, and the usage patterns that invoke your code.

Other guidance for grouping functions, with storage and consumer group considerations, include:

- **Hosting a single function within a function app**: An isolated Event Hubs-triggered function reduces resource contention between other running functions, especially those that are CPU or memory intensive. This benefit occurs because each function has its own memory footprint and usage patterns that can directly affect scale of the function app in which the functions run.

- **Separate storage accounts for each function app**: Avoid sharing storage accounts between function apps. Also, don't use the same storage account that is used for the function app for other storage operations or needs. It's important to use separate storage accounts since Event Hubs triggered functions can potentially have a high volume of storage transactions due to checkpointing.

- **Create a dedicated consumer group for each function app**: In a stream processing solution, each consumer application equates to a [consumer group](/azure/event-hubs/event-hubs-features#consumer-groups). A function app is a prime example of a consumer application. Don't share consumer groups between function apps and other consumer applications. The following diagram provides an example of two function apps reading from an event hub, where each app has its own dedicated consumer group:

    ![Dedicated consumer groups for each function app](./images/event-hubs-functions-consumer-groups.svg)

In summary, each function app should be perceived as a distinct application with its own, assigned consumer group. This ensures offset integrity for each consumer and simplifies dependencies in an event streaming architecture. This configuration, along with providing each event hub-triggered function its own function app and storage account, helps set the foundation for optimal performance and scale.

## Function hosting plans

Reviewing [how functions scale on different plans](/azure/azure-functions/functions-scale) is an important step when assessing hosting options.

When using the Consumption plan, by default each function app has its own plan. Function apps in the consumption plan scale independently and are most effective when they avoid long running tasks.

The Premium and Dedicated plans are often used to host multiple function apps and functions that are more CPU and memory intensive. It's important to note that all the function apps in these plans sharing the same resources allocated to the plan. If functions have different load profiles or unique requirements, it's best to host them in different plans. This is especially true for stream processing applications.

## Event Hubs scaling

When it comes to an Event Hubs namespace, there are several important settings that need to be evaluated to ensure peak performance and scale. This section focuses on the Standard tier of Event Hubs and its unique features that affect scaling when used with Azure Functions. To learn more about Event Hubs tiers, see [Basic vs. standard vs. premium vs. dedicated tiers](/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers).

### Understanding throughput units

In the Event Hubs standard tier, throughput is classified as the amount of data that enters and is read from the namespace within a given period. A [throughput unit](/azure/event-hubs/event-hubs-faq#throughput-units) (TU) is a mechanism that's used to both measure and manage how much throughput an Event Hubs namespace supports.

For reference, a *namespace* in Event Hubs may be compared to a *cluster* in Kafka. For a conceptual mapping between Kafka and Event Hubs, review this [table](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview#kafka-and-event-hub-conceptual-mapping).

Each throughput unit is billed on an hourly basis and is shared across all the event hubs in a namespace. This means that all the applications and services, both publishers and consumers, must be accounted for when choosing the number of allotted TUs. Azure Functions impacts the number of bytes and events that are both published to and read from an event hub.

The emphasis for determining the number of TUs is centered around the point of ingress. However, the aggregate for the consumer applications, including the rate at which those events are processed, must also be included in the calculation.

### Scale up with auto-inflate

Auto-inflate may be enabled on an Event Hubs namespace to accommodate scenarios where load increases beyond the configured number of TUs. This makes sure that throttling from the service won't occur and that processing, including the ingesting of events, can continue without disruption. Since TUs are one of the important settings that also impact costs, taking advantage of the auto-inflate feature helps address concerns about overprovisioning.

Auto-inflate is a unique feature of Event Hubs that is often confused with autoscale, especially within the context of serverless solutions. It's important to note that this characteristic in Event Hubs supports the increasing of TUs dynamically to support bursts scenarios but doesn't have a feature to deflate or scale-down automatically.

For scenarios that require high throughput and cannot be accommodated with the maximum allotted number of TUs, consider the Azure Event Hubs Premium tier or [Dedicated](/azure/event-hubs/event-hubs-dedicated-overview) cluster.

### Partitions and concurrent functions

When an event hub is created, the number of
[partitions](/azure/event-hubs/event-hubs-features#partitions) must be specified. The partition count remains fixed and cannot be changed except from the [Premium](/azure/event-hubs/event-hubs-premium-overview) and [Dedicated](/azure/event-hubs/event-hubs-dedicated-overview) tiers. When using the Event Hubs trigger, the number of concurrent function app instances can potentially match the number of partitions.

In Consumption and Premium plans, the function app instances scale out dynamically to the meet the number of partitions, when needed. Dedicated (App Service) plans require you to manually configure your instances or [set up and autoscale scheme](/azure/azure-functions/dedicated-plan#scaling). Ultimately, a one-to-one relationship between the number of partitions and function app instances is the ideal target for maximum throughput in a stream processing solution.

Optimal parallelism is achieved by having multiple consumers within a consumer group. For Azure Functions, this translates to many instances of a function app within the plan. The result is referred to as *partition-level parallelism* or the *maximum degree of parallelism*.

![Maximum degree of parallelism](./images/event-hubs-parallelism.svg)

It might initially make sense to configure as many partitions as possible to achieve maximum throughput and account for the possibility of a higher volume of events. However, there are several important factors that must be considered when many partitions are configured:

- **More partitions could lead to more throughput:** Since the degree of parallelism is the number of consumers (function app instances), the more partitions there are, the higher the concurrent throughput can be. This fact is important when sharing a designated number of TUs for an event hub with other consumer applications.

- **More functions may require more memory:** As the number of function app instances increase, so does the memory footprint of resources within the plan. At some point, too many partitions could deteriorate performance for consumers.

- **Back pressure from downstream services:** As more throughput is generated, the potential to overwhelm or receive back pressure from downstream services may arise. Consumer fan-out must be accounted for when considering the consequences it may have on the surrounding resources. Examples may include throttling from other services, network saturation, and other forms of resource contention that may occur with an increase in throughput.

- **Sparsely populated partitions:** The combination of many partitions and a low volume of events can lead to data that is sparely distributed across partitions. Instead, a smaller number of partitions can provide more optimal performance and resource usage for  Functions to consume.

### Availability and consistency

When a partition key or ID isn't specified, the Event Hubs service routes an incoming event to the next available partition. This approach provides high availability and helps increase throughput for consumers.

When ordering is important, a specific partition may be specified to preserve the order of events when they are published. A consumer application that reads from the same partition can then process the events in order. This tradeoff provides consistency but compromises availability. Only use approach when the ordering of events is a requirement.

For Functions, ordering is achieved when events are published to a particular partition and an Event Hubs triggered function obtains a lease to the same partition. Currently, the ability to configure a partition with the Event Hubs output binding is not supported. Instead, using one of the Event Hubs SDKs is the best approach for publishing to a specific partition.

For a more detailed explanation of the how availability and consistency are supported by Azure Event Hubs, it is recommended to review this [article](/azure/event-hubs/event-hubs-availability-and-consistency).

## Event Hubs trigger

This section focuses on the settings and considerations involved when optimizing Event Hubs triggered functions for peak performance. Factors include batch processing, sampling and related features that influence the behavior of an event hub [trigger](/azure/azure-functions/functions-bindings-event-hubs-trigger) binding.

### Batching

Functions that are triggered by event hubs can be configured to process a collection of events, or one event at a time. Processing a batch of events is more efficient because of the overhead involved for each function invocation. Unless you need to process only a single event, your function should be configured to process multiple events when invoked.

Enabling batching for the Event Hubs trigger binding varies between languages:

- In C#, cardinality is automatically configured when an array is designated for the type in the `EventHubTrigger` attribute.

- JavaScript, Python, and other languages enable batching when the cardinality property is set to *many* in the function.json file for the function.

To learn more about how batching is enabled, see the [attribute and annotation](/azure/azure-functions/functions-bindings-event-hubs-trigger?tabs=javascript#attributes-and-annotations) options for each supported language.

### Trigger settings

Several configuration settings in the [host.json](/azure/azure-functions/functions-bindings-event-hubs#hostjson-settings) file play a key role in the performance characteristics of the Event Hubs trigger binding for Azure Functions:

- **maxBatchSize:** This setting represents the maximum number of events the function receives when invoked. It is important to recognize that this isn't the minimum number of events, only the maximum. If the number of events received is less than this amount, the function is still invoked with as many events as are available. You can't set the minimum batch size.

- **prefetchCount:** One of the most important settings when optimizing for performance is the prefetch count. This value is referenced by the underlying AMQP channel to determine how many messages to fetch and cache for the client. The prefetch count should be greater than or equal to the `maxBatchSize` value and is commonly set to a multiple of that amount. Setting this value to a number less than the `maxBatchSize` setting could have a negative impact on performance.

- **batchCheckpointFrequency:** As batches are processed by your function, this value is used to determine the rate at which a checkpoint is created. By default, this value is set to `1`, which means that after a function successfully processes a batch, a checkpoint is produced. Keep in mind that a checkpoint is created at the partition level for each reader in the consumer group. This interesting blog [post](https://shervyna.medium.com/event-triggered-azure-function-replays-retries-a3cb1efd17b5) provides some addition insight into the behavior this setting may introduce and how it influences replays and retries of events.

The values you set for the trigger binding should be determined over the course of several performance tests and iterations. It is recommended that changes are made iteratively and measured consistently to fine-tune these options accordingly. The default values are an effort to provide a starting point for most event processing solutions.

### Checkpointing

Understanding the concept of [checkpointing](/azure/event-hubs/event-hubs-features#checkpointing) is critical for Event Hubs triggered functions. It's the responsibility of the Functions host to checkpoint as events are processed and the setting for the batch checkpoint frequency is met.

The following concepts are important in understanding the relationship between checkpointing and how your function processes events:

- **Exceptions still count towards success:** If the function process doesn't crash while processing events, the completion of the function is considered successful. Catching and handling exceptions should still be a defensive approach in the function code. When successful, the Functions host evaluates the setting for the batch frequency checkpoint and create a checkpoint if it has been reached, regardless of exceptions that may have occurred during processing.

- **Batch frequency matters:** In high volume event streaming solutions, it may be beneficial to change the batchCheckpointFrequency setting to a value greater than 1. Increasing this value can help reduce the rate of which a checkpoint is created, which will lessen the number of I/O operations to the storage account and yield higher performance.

- **Replays may happen:** Each time a function is invoked with the Event Hubs trigger binding, it uses the most recent checkpoint to determine where to resume processing. It has been stressed that the offset for every consumer is saved at the partition level for each consumer group. Replays happen when a checkpoint did not occur during the last invocation of the function, and it is invoked again. To learn more about duplicates and deduplication techniques, see [Idempotency](resilient-design.md#idempotency) in the next article.

Understanding checkpointing becomes critical when considering best practices for error handling and retries, which will be covered in a later section of this article.

### Telemetry Sampling

Azure Functions provides built-in support for [Application Insights](/azure/azure-monitor/app/app-insights-overview). With this feature, you can collect log, performance, and information about runtime exceptions that occur within your functions. This powerful setup offers some key configuration choices that will affect performance. Some of the notable settings and considerations for monitoring and performance are:

- **Enable telemetry sampling**: for high throughput scenarios, you should evaluate the amount of telemetry and information that you will need. Review the telemetry [sampling](/azure/azure-monitor/app/sampling) feature in Application Insights to avoid degrading the performance of your function with unnecessary telemetry data and metrics.

- **Configure aggregation settings:** Examine and configure the frequency in which data is aggregated and sent to Application Insights. This configuration setting is in the [host.json](/azure/azure-functions/functions-host-json) file along with many other sampling and logging related options. To learn more, see [Configure the aggregator](/azure/azure-functions/configure-monitoring?tabs=v2#configure-the-aggregator).

- **Disable AzureWebJobDashboard**: For apps that target version 1.x of the Azure Functions runtime, this setting stores the connection string to a storage account that's used by the Azure SDK to retain logs for the WebJobs dashboard. If Application Insights is used in favor of the WebJobs dashboard, then this setting should be removed. To learn more, see the [AzureWebJobsDashboard](/azure/azure-functions/functions-app-settings#azurewebjobsdashboard) setting reference.

It's important to mention that when Application Insights is enabled without sampling, all telemetry data is sent. Sending data about all events may have a detrimental effect on the overall performance of the function, especially under high-throughput event streaming scenarios.

Taking advantage of sampling and continually assessing the appropriate amount of telemetry needed for monitoring is one of the many, crucial settings available for optimum performance. Telemetry should be used for general platform health evaluation in the aggregate and for occasional troubleshooting, and not to capture core business metrics. To learn more, see [Configure sampling](/azure/azure-functions/configure-monitoring?tabs=v2#configure-sampling).

## Output binding

Publishing to an event stream from a function is simplified by using the [output](/azure/azure-functions/functions-bindings-event-hubs-output) binding for Event Hubs. Several of the benefits of using this binding include:

- **Resource management**: The binding handles both the client and connection lifecycles for you. This reduces the potential for issues that may arise with port exhaustion and connection pool management.

- **Less code**: The binding abstracts the underlying SDK and reduces the amount of code needed to publish events. This results in code that is easier to write and maintain.

- **Batching**: For several languages, batching is supported to efficiently publish to an event stream. This can improve performance and help streamline code that sends the events.

It is highly recommended that you review the list of [supported languages](/azure/azure-functions/supported-languages) for Azure Functions and their respective developer guides. The *Bindings* section for each language provides detailed examples and documentation.

### Batching

If your function only publishes a single event, configuring the binding with a return value is a common approach. This is helpful if the function execution always ends with a statement that sends the event. Using the return value is a pattern that should only be used for synchronous functions that return only one event.

Batching is encouraged to improve performance when sending multiple events to a stream. Batching allows the binding to publish events in the most efficient possible way.

Support for sending multiple events with the output binding to Event Hubs is available in C#, Java, Python, and JavaScript.

### Output multiple events in C#

Use the `ICollector` and `IAsyncCollector` types when sending multiple events from a function in C#.

- The `ICollector<T>.Add()` method can be used in both synchronous and asynchronous functions. It executes the add operation as soon as it's called.

- the `IAsyncCollector<T>.AddAsync()` method prepares the events to be published to the event stream. If you are writing an asynchronous function, you should use `IAsyncCollector` to better manage the published events.

Refer to the [documentation](/azure/azure-functions/functions-bindings-event-hubs-output?tabs=csharp) for examples of publishing both single and multiple events using C#.

### Throttling and back pressure

Throttling considerations apply to output binding as well, not only for Event Hubs but also for Azure services such as [Azure Cosmos DB](/azure/cosmos-db/). In general, it's important to become familiar with the limits and quotas that apply to those services and to plan accordingly.

To handle downstream errors, you can catch exceptions from IAsyncCollector by wrapping AddAsync and FlushAsync in an exception handler for .NET Azure Functions, or not use output bindings and use the Event Hubs SDKs directly.

## Function code

This section covers the key areas that must be considered when writing code to process events from an Event Hubs triggered function.

### Asynchronous programming

It's recommended to have your function employ non-blocking, [asynchronous](/azure/azure-functions/functions-best-practices#use-async-code-but-avoid-blocking-calls) code. This is important when I/O calls are involved.

When considering asynchronous programming in an Functions, there are some essential guidelines that should be followed:

- **All asynchronous or all synchronous:** If a function is configured to run asynchronously, all the I/O calls should be asynchronous as well. In most cases, being partially asynchronous can be worse than code that is entirely synchronous. Choose either asynchronous or synchronous for the implementation of the function and follow it all the way through.

- **Avoid blocking calls:** Blocking calls return to the caller only after the call completes. This is different than asynchronous calls that return immediately. An example in C# would be calling **Task.Result** or **Task.Wait** on an asynchronous operation.

### More about blocking calls

When blocking calls are made on asynchronous operations, it can lead to thread-pool starvation and cause the function process to crash. This happens because a blocking call requires another thread to be created to compensate for the original call that is now waiting. As a result, it now requires twice as many threads to complete the operation.

Avoiding this *sync over async* approach is especially important when Event Hubs is involved since a crash to the function will not update the checkpoint. The next time the function is invoked it could end up in this cycle and appear to be *stuck* or move along slowly as function executions will eventually time out.

Troubleshooting this phenomenon usually starts with reviewing the trigger settings and running experiments that may involve increasing the partition count. Investigations can also lead to changing several of the batching options such as the max batch size or prefetch count. The impression is that it's a throughput problem or configuration setting that just needs to be tuned accordingly. However, the core problem is in the code itself and must be addressed there for the proper resolution.

## Next steps

Before continuing, consider reviewing these related articles:

- [Monitor s](/azure/azure-functions/functions-monitoring)
- [Azure Functions reliable event processing](/azure/azure-functions/functions-reliable-event-processing)
- [Designing Azure Functions for identical input](/azure/azure-functions/functions-idempotent)
- [ASP.NET Core async guidance](https://github.com/davidfowl/AspNetCoreDiagnosticScenarios/blob/master/AsyncGuidance.md).

> [!div class="nextstepaction"]
> [Resilient Event Hubs and Functions design](./resilient-design.md)

## Related resources

- [Monitoring serverless event processing](../guide/monitoring-serverless-event-processing.md) provides guidance on monitoring serverless event-driven architectures.
- [Serverless event processing](../../reference-architectures/serverless/event-processing.yml) is a reference architecture detailing a typical architecture of this type, with code samples and discussion of important considerations.
- [De-batching and filtering in serverless event processing with Event Hubs](../../solution-ideas/articles/serverless-event-processing-filtering.yml) describes in more detail how these portions of the reference architecture work.
