---
title: Monitor serverless event processing
description: Guidance on monitoring serverless event-driven architectures using Application Insights.
author: rasavant-ms
ms.author: rasavant
ms.date: 06/25/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - devops
  - developer-tools
  - analytics
  - compute
categories:
  - devops
  - developer-tools
  - analytics
  - compute
products:
  - azure-monitor
  - azure-application-insights
  - azure-event-hubs
  - azure-functions
ms.custom:
  - guide
  - fcp
---
<!-- cSpell:ignore todatetime dateformatter tostring kusto KEDA datetimes isfuzzy Ccmd rasavant -->

# Monitor serverless event processing

This article provides guidance on monitoring [serverless](https://azure.microsoft.com/solutions/serverless/) event-driven architectures.

Monitoring provides insight into the behavior and health of your systems. It helps you build a holistic view of the environment, retrieve historic trends, correlate diverse factors, and measure changes in performance, consumption, or error rate. You can use monitoring to define alerts when conditions occur that could impact the quality of your service, or when conditions of particular interest to your specific environment arise.

This article demonstrates using [Azure Monitor](https://azure.microsoft.com/services/monitor/) to monitor a serverless application built using [Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Functions](https://azure.microsoft.com/services/functions/). It discusses useful metrics to monitor, describes how to integrate with [Application Insights](/azure/azure-monitor/app/app-insights-overview) and capture custom metrics, and provides code samples.

## Assumptions

This article assumes you have an architecture like the one described in the [Serverless event processing reference architecture](../../reference-architectures/serverless/event-processing.yml). Basically:

- Events arrive at Azure Event Hubs.
- A Function App is triggered to handle the event.
- Azure Monitor is available for use with your architecture.

## Metrics from Azure Monitor

First we need to decide which metrics will be needed before we can begin to formulate useful insights about the architecture. Each resource performs different tasks, and in turn generates different metrics.

These metrics from Event Hub will be of interest to capture useful insights:

- Incoming requests
- Outgoing requests
- Throttled requests
- Successful requests
- Incoming messages
- Outgoing messages
- Captured messages
- Incoming bytes
- Outgoing bytes
- Captured bytes
- User errors

Similarly, these metrics from Azure Functions will be of interest to capture useful insights:

- Function execution count
- Connections
- Data in
- Data out
- HTTP server errors
- Requests
- Requests in application queue
- Response time

## Using diagnostics logging to capture insights

When analyzed together, the above metrics can be used to formulate and capture the following insights:

- Rate of requests processed by Event Hubs
- Rate of requests processed by Azure Functions
- Total Event Hub throughput
- User errors
- Duration of Azure Functions
- End-to-end latency
- Latency at each stage
- Number of messages lost
- Number of messages processed more than once

To ensure that Event Hubs captures the necessary metrics, we must first enable diagnostic logs (which are disabled by default). We must then select which logs are desired and configure the correct Log Analytics workspace as the destination for them.

The log and metric categories that we are interested in are:

- OperationalLogs
- AutoScaleLogs
- KafkaCoordinatorLogs *(for Apache Kafka workloads)*
- KafkaUserErrorLogs *(for Apache Kafka workloads)*
- EventHubVNetConnectionEvent
- AllMetrics

Azure documentation provides instructions on how to [Set up diagnostic logs for an Azure event hub](/azure/event-hubs/event-hubs-diagnostic-logs#enable-diagnostic-logs). The following screenshot shows an example *Diagnostic setting* configuration panel with the correct log and metric categories selected, and a Log Analytics workspace set as the destination. (If an external system is being used to analyze the logs, the option to *Stream to an event hub* can be used instead.)

:::image type="content" source="images/monitoring-serverless-event-processing-diagnostic-setting.png" alt-text="Screenshot of an Event Hub diagnostic settings configuration panel showing the correct log and metric categories selected, and a Log Analytics workspace set as the destination." lightbox="images/monitoring-serverless-event-processing-diagnostic-setting.png":::

> [!NOTE]
> In order to utilize log diagnostics to capture insights, you should create event hubs in different namespaces. This is because of a constraint in Azure.
>
> The Event Hubs set in a given Event Hubs namespace is represented in Azure Monitor metrics under a dimension called `EntityName`. In the Azure portal, data for a specific event hub normally can be viewed on that instance of Azure Monitor. But when the metrics data is routed to the log diagnostics, there is currently no way to view data per event hub by filtering on the `EntityName` dimension.
>
> As a workaround, creating event hubs in different namespaces helps make it possible to locate metrics for a specific hub.

## Using Application Insights

You can enable Application Insights to capture metrics and custom telemetry from Azure Functions. This allows you to define analytics that suit your own purposes, providing another way to get important insights for the serverless event processing scenario.

This screenshot shows an example listing of custom metrics and telemetry within Application Insights:

:::image type="content" source="images/monitoring-serverless-event-processing-application-insights-messages.png" alt-text="Screenshot showing an example listing of custom metrics and telemetry within Application Insights." lightbox="images/monitoring-serverless-event-processing-application-insights-messages.png":::

### Default custom metrics

In Application Insights, custom metrics for Azure Functions are stored in the `customMetrics` table. It includes the following values, spanned over a timeline for different function instances:

- `AvgDurationMs`
- `MaxDurationMs`
- `MinDurationMs`
- `Successes`
- `Failures`
- `SuccessRate`
- `Count`

These metrics can be used to efficiently calculate the aggregated averages across the multiple function instances that are invoked in a run.

This screenshot shows what these default custom metrics look like when viewed in Application Insights:

:::image type="content" source="images/monitoring-serverless-event-processing-application-insights-custom-metrics.png" alt-text="Screenshot showing what default custom metrics look like when viewed in Application Insights." lightbox="images/monitoring-serverless-event-processing-application-insights-custom-metrics.png":::

### Custom messages

Custom messages logged in the Azure Function code (using the `ILogger`) are obtained from the Application Insights `traces` table.

The `traces` table has the following important properties (among others):

- `timestamp`
- `cloud_RoleInstance`
- `operation_Id`
- `operation_Name`
- `message`

Here is an example of what a custom message might look like in the Application Insights interface:

:::image type="content" source="images/monitoring-serverless-event-processing-application-insights-custom-message.png" alt-text="Screenshot showing an example of a custom message in the Application Insights 'traces' data table." lightbox="images/monitoring-serverless-event-processing-application-insights-custom-message.png":::

If the incoming Event Hub message or `EventData[]` is logged as a part of this custom `ILogger` message, then that is also made available in Application Insights. This can be very useful.

For our serverless event processing scenario, we log the JSON serialized message body that's received from the event hub. This allows us to capture the raw byte array, along with `SystemProperties` like `x-opt-sequence-number`, `x-opt-offset`, and `x-opt-enqueued-time`. To determine when each message was received by the Event Hub, the `x-opt-enqueued-time` property is used.

**Sample query:**

```kusto
traces
| where timestamp between(min_t .. max_t)
| where message contains "Body"
| extend m = parse_json(message))
| project timestamp = todatetime(m.SystemProperties.["x-opt-enqueued-time"])
```

The sample query would return a message similar to the following example result, which gets logged by default in Application Insights. The properties of the `Trigger Details` can be used to locate and capture additional insights around messages received per `PartitionId`, `Offset`, and `SequenceNumber`.

**Example result of the sample query:**

```json
"message": Trigger Details: PartitionId: 26, Offset: 17194119200, EnqueueTimeUtc: 2020-11-03T02:14:01.7740000Z, SequenceNumber: 843572, Count: 10,
```

> [!WARNING]
> The library for Azure Java Functions currently has an issue that prevents access to the `PartitionID` and the `PartitionContext` when using `EventHubTrigger`. [Learn more in this GitHub issue report.](https://github.com/Azure/azure-functions-java-library/issues/138)

### Tracking message flow using a transaction ID with Application Insights

In Application Insights, we can view all the telemetry related to a particular transaction by doing a Transaction search query on the transaction's `Operation Id` value. This can be especially useful for capturing the percentile values of average times for messages as the transaction moves through the event stream pipeline.

The following screenshot shows an example Transaction search in the Application Insights interface. The desired `Operation ID` is entered in the query field, identified with a magnifying glass icon (and shown here outlined in a red box). At the bottom of the main pane, the `Results` tab shows matching events in sequential order. In each event entry, the `Operation ID` value is highlighted in dark blue for easy verification.

:::image type="content" source="images/monitoring-serverless-event-processing-transaction-search.png" alt-text="Screenshot showing an example Transaction search in the Application Insights interface." lightbox="images/monitoring-serverless-event-processing-transaction-search.png":::

A query generated for a specific operation ID will look like the following. Note that the `Operation ID` GUID is specified in the third line's `where * has` clause. This example further narrows the query between two different `datetimes`.

```kusto
union isfuzzy=true availabilityResults, requests, exceptions, pageViews, traces, customEvents, dependencies
| where timestamp > datetime("2020-10-09T06:58:40.024Z") and timestamp < datetime("2020-11-11T06:58:40.024Z")
| where * has "1c8c9d7073a00e4bbdcc8f2e6570e46"
| order by timestamp desc
| take 100
```

Here is a screenshot of what the query and its matching results might look like in the Application Insights interface:

:::image type="content" source="images/monitoring-serverless-event-processing-search-log.png" alt-text="Screenshot showing part of the Application Insights interface with the results of a query generated for a specific Operation ID. The actual query is visible in a top area, and the matching results are listed below." lightbox="images/monitoring-serverless-event-processing-search-log.png":::

## Capture custom metrics from Azure Functions

### .NET functions

[Structured logging](/azure/azure-functions/functions-dotnet-class-library?tabs=v2%2Ccmd#structured-logging) is used in the .NET Azure functions for capturing custom dimensions in the Application Insights traces table. These custom dimensions can then be used for querying data.

As an example, here is the log statement in the .NET `TransformingFunction`:

```csharp
log.LogInformation("TransformingFunction: Processed sensorDataJson={sensorDataJson}, " +
    "partitionId={partitionId}, offset={offset} at {enqueuedTimeUtc}, " +
    "inputEH_enqueuedTime={inputEH_enqueuedTime}, processedTime={processedTime}, " +
    "transformingLatencyInMs={transformingLatencyInMs}, processingLatencyInMs={processingLatencyInMs}",
    sensorDataJson,
    partitionId,
    offset,
    enqueuedTimeUtc,
    inputEH_enqueuedTime,
    processedTime,
    transformingLatency,
    processingLatency);
```

The resulting logs created on Application Insights contain the above parameters as custom dimensions, as shown in this screenshot:

:::image type="content" source="images/monitoring-serverless-event-processing-custom-dimensions.png" alt-text="Screenshot showing logs created in Application Insights by the previous C-sharp code sample." lightbox="images/monitoring-serverless-event-processing-custom-dimensions.png":::

These logs can be queried as follows:

```kusto
traces
| where timestamp between(min_t .. max_t)
// Function name should be of the function consuming from the Event Hub of interest
| where operation_Name == "{Function_Name}"
| where message has "{Function_Name}: Processed"
| project timestamp = todatetime(customDimensions.prop__enqueuedTimeUtc)
```

> [!NOTE]
> In order to make sure we do not affect performance in these tests, we have turned on the sampling settings of Azure Function logs for Application Insights using the `host.json` file as shown below. This means that all statistics captured from logging are considered to be average values and not actual counts.

**host.json example:**

```json
"logging": {
    "applicationInsights": {
        "samplingExcludedTypes": "Request",
        "samplingSettings": {
            "isEnabled": true
        }
    }
}
```

### Java functions

Currently, structured logging isn't supported in Java Azure functions for capturing custom dimensions in the Application Insights traces table.

As an example, here is the log statement in the Java `TransformingFunction`:

```java
LoggingUtilities.logSuccessInfo(
    context.getLogger(), 
    "TransformingFunction", 
    "SuccessInfo", 
    offset, 
    processedTimeString, 
    dateformatter.format(enqueuedTime), 
    transformingLatency
);
```

The resulting logs created on Application Insights contain the above parameters in the message as shown below:

:::image type="content" source="images/monitoring-serverless-event-processing-application-insights-message-java.png" alt-text="Screenshot showing logs created in Application Insights by the previous Java code sample." lightbox="images/monitoring-serverless-event-processing-application-insights-message-java.png":::

These logs can be queried as follows:

```kusto
traces
| where timestamp between(min_t .. max_t)
// Function name should be of the function consuming from the Event Hub of interest
| where operation_Name in ("{Function name}") and message contains "SuccessInfo"
| project timestamp = todatetime(tostring(parse_json(message).enqueuedTime))
```

> [!NOTE]
> In order to make sure we do not affect performance in these tests, we have turned on the sampling settings of Azure Function logs for Application Insights using the `host.json` file as shown below. This means that all statistics captured from logging are considered to be average values and not actual counts.

**host.json example:**

```json
"logging": {
    "applicationInsights": {
        "samplingExcludedTypes": "Request",
        "samplingSettings": {
            "isEnabled": true
        }
    }
}
```

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Rajasa Savant](https://www.linkedin.com/in/rajasa-savant/) | Senior Software Engineer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Serverless event processing](../../reference-architectures/serverless/event-processing.yml) is a reference architecture detailing a typical architecture of this type, with code samples and discussion of important considerations.
- [De-batching and filtering in serverless event processing with Event Hubs](../../solution-ideas/articles/serverless-event-processing-filtering.yml) describes in more detail how these portions of the reference architecture work.
- [Private link scenario in event stream processing](../../solution-ideas/articles/serverless-event-processing-private-link.yml) is a solution idea for implementing a similar architecture in a virtual network (VNet) with private endpoints, in order to enhance security.
- [Azure Kubernetes in event stream processing](../../solution-ideas/articles/serverless-event-processing-aks.yml) describes a variation of a serverless event-driven architecture running on Azure Kubernetes with KEDA scaler.
