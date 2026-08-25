---
title: Monitor Azure Functions and Event Hubs
description: Learn how to monitor an Azure Functions topology that uses Event Hubs.
author: dbarkol 
ms.author: dabarkol
ms.date: 04/22/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Monitor Azure Functions and Event Hubs

Monitoring provides insights into the behavior and health of your systems. It helps you get a holistic view of the environment and historic trends, correlate diverse factors, and measure changes in performance, consumption, or error rate.

Azure Functions provides built-in integration with [Application Insights](/azure/azure-monitor/app/app-insights-overview). From Application Insights, you can get information like the number of function app instances or requests and the dependency telemetry of a function. When you use Functions together with Azure Event Hubs, Application Insights can also track the outgoing dependency telemetries to the event hub, calculate the processing time, and show the end-to-end flow of the system that's connected via Event Hubs.

This article introduces useful features and insights that you can get from Application Insights for your solution that uses Event Hubs together with Functions.

## Application map

[Application map](/azure/azure-monitor/app/app-map) shows how the components in a system interact with each other. Because Application Insights provides dependency telemetry, it can map the flow of events between Azure Functions and Event Hubs, including the average number of calls for each function and the average duration of an event in Event Hubs. It also displays transactions that contain failures in red.

After you send the expected load to your system, you can go to Application Insights in the [Azure portal](https://portal.azure.com) and select **Application map** in the navigation pane. The following map shows three functions, three event hubs, and apparent failures during writes to a downstream database.

:::image type="content" source="images/observability-application-map.png" alt-text="Screenshot of an application map that shows three functions, three event hubs, and apparent failures during writes to a downstream database.":::

## End-to-end transaction details

End-to-end transaction details show how your system components interact with each other, in chronological order. This view also shows how long an event took to process. You can drill into the telemetry of each component in this view. Doing so helps you troubleshoot across components within the same request when a problem occurs.

:::image type="content" source="images/observability-end-to-end-transaction.png" alt-text="Screenshot of the end-to-end transaction details view in Application Insights. It shows the timeline of a function request, an outgoing dependency to an event hub, the time spent in queue, and the subsequent execution.":::

## Platform metrics and telemetry

You can use platform-generated metrics in Azure Monitor for Event Hubs and Azure Functions to monitor a solution's behavior and health:

- [Event Hubs metrics in Azure Monitor](/azure/event-hubs/monitor-event-hubs) can help you capture useful insights for Event Hubs. Insights include aggregates of Incoming Requests, Outgoing Requests, Throttled Requests, Successful Requests, Incoming Messages, Outgoing Messages, Captured Messages, Incoming Bytes, Outgoing Bytes, Captured Bytes, and User Errors.

- Azure Functions provides many of the same metrics as [Azure App Service](/azure/app-service/web-sites-monitor). It also provides [Function Execution Count and Function Execution Units](/azure/azure-functions/monitor-functions-reference) metrics that you can use to [understand the utilization and cost of the Consumption plan](/azure/azure-functions/functions-consumption-costs). Other useful metrics include Connections, Data In, Data Out, Average Memory Working Set, Thread Count, Requests, and Response Time.

Azure Functions integrates with Application Insights to provide advanced and detailed telemetry and insights into the Functions host and function executions. To learn more, see [Analyze Azure Functions telemetry in Application Insights](/azure/azure-functions/analyze-telemetry-data). When you use Application Insights to monitor a topology, a variety of configurations is available. To learn more, see [Configure monitoring for Azure Functions](/azure/azure-functions/configure-monitoring).

The following example shows extra telemetry for functions triggered by Event Hubs. It's generated in the **traces** table:

```
Trigger Details: PartitionId: 6, Offset: 3985758552064-3985758624640, EnqueueTimeUtc: 2025-10-31T12:51:58.1750000+00:00-2025-10-31T12:52:03.8160000+00:00, SequenceNumber: 3712266-3712275, Count: 10
```

This data is useful because it contains information about the message that triggered the function and can be used for querying and insights. It includes the following data for each time the function is triggered:

- The **partition ID** (6)
- The **partition offset** range (3985758552064-3985758624640)
- The **enqueue time range** in UTC (2025-10-31T12:51:58.1750000+00:00-2025-10-31T12:52:03.8160000+00:00)
- The **sequence number range** 3712266-3712275
- The **count of messages** (10)

See the [Example Application Insights queries](#example-application-insights-queries) section of this article for examples of how to use this telemetry.

You can also use custom telemetry for different languages ([C\# class library](/azure/azure-functions/functions-dotnet-class-library#logging), [C\# isolated](/azure/azure-functions/dotnet-isolated-process-guide#logging), [C\# script](/azure/azure-functions/functions-reference-csharp#logging), [JavaScript](/azure/azure-functions/functions-reference-node#logging), [Java](/azure/azure-functions/functions-reference-java#logger), [PowerShell](/azure/azure-functions/functions-reference-powershell#logging), and [Python](/azure/azure-functions/functions-reference-python#logging-and-monitoring)). This logging appears in the **traces** table in Application Insights. You can create your own entries into Application Insights and add custom dimensions that you can use for querying data and creating custom dashboards.

Finally, when your function app connects to an event hub by using an output binding, entries are also written to the [Application Insights Dependencies table](/azure/azure-functions/functions-monitoring#dependencies).

:::image type="content" source="images/observability-dependencies-table.png" alt-text="Screenshot of the Application Insights dependencies table." lightbox="images/observability-dependencies-table.png":::

For Event Hubs, the correlation is injected into the event payload, and you see a **Diagnostic-Id** property in events:

:::image type="content" source="images/observability-diagnostic-id.png" alt-text="Screenshot of an event payload that shows a Diagnostic-Id property in the Properties object, together with system properties like sequence number, offset, and enqueue time." lightbox="images/observability-diagnostic-id.png" border="false":::

This property uses the [W3C Trace Context](https://www.w3.org/TR/trace-context/) format that's also used as **Operation Id** and **Operation Links** in telemetry created by Functions. This format allows Application Insights to construct the correlation between event hub events and function executions, even when they're distributed.

:::image type="complex" source="images/observability-batch-events.png" alt-text="Diagram that shows how Application Insights correlates telemetry across two functions that process a batch of events." lightbox="images/observability-batch-events.png" border="false":::
The diagram is titled "when function processed a batch of events." It shows two tables labeled 1st and 2nd, each representing a function execution. The first table contains three rows for FirstFunction: one request, one trace, and one dependency. All share the same Operation ID. The second table contains two rows for SecondFunction: a request and a trace. The Operation ID in this table isn't the same as the ID for FirstFunction. An annotation pointing to the Operation ID column reads "1. Application Insights creates new Operation Id." The request is associated with an operation links column that contains a JSON array. Each entry in the array references the operation ID from FirstFunction. An annotation pointing to this column reads "2. Operation links is a list of operation Ids of each event in the batch."
:::image-end:::

## Example Application Insights queries

The following list contains Application Insights queries that can help you monitor a solution that uses Event Hubs together with Azure Functions. These queries display detailed information for functions triggered by event hubs that use telemetry emitted by the Event Hubs extension.

When [sampling is enabled](/azure/azure-functions/configure-monitoring?tabs=v2#configure-sampling) in Application Insights, there might be gaps in the data.

### Detailed event processing information

The data is only emitted in the correct format when batched dispatch is used. When you use batch dispatch, the function accepts multiple events for each execution. We recommend this mode [for improved performance](performance-scale.md#batching-for-triggered-functions). Keep in mind the following considerations:

- The `dispatchTimeMilliseconds` value approximates the length of time between when the event was written to the event hub and when it was picked up by the function app for processing.
- `dispatchTimeMilliseconds` can be negative or otherwise inaccurate because of clock drift between the event hub server and the function app.
- Event Hubs partitions are processed sequentially. A message isn't dispatched to function code for processing until all previous messages are processed. Monitor the execution time of your functions because longer execution times cause dispatch delays.
- The calculation uses the enqueueTime of the first message in the batch. Dispatch times might be lower for other messages in the batch.
- `dispatchTimeMilliseconds` is based on the point in time.
- Sequence numbers are per-partition, and duplicate processing can occur because Event Hubs doesn't guarantee exactly-once message delivery.

```kusto
traces
| where message startswith "Trigger Details: Parti"
| parse message with * "tionId: " partitionId:string ", Offset: "
offsetStart:string "-" offsetEnd:string", EnqueueTimeUtc: "
enqueueTimeStart:datetime "+00:00-" enqueueTimeEnd:datetime "+00:00, SequenceNumber: "
sequenceNumberStart:string "-" sequenceNumberEnd:string ", Count: "
messageCount:int
| extend dispatchTimeMilliseconds = (timestamp - enqueueTimeStart) / 1ms
| project timestamp, cloud_RoleInstance, operation_Name, processId =
customDimensions.ProcessId, partitionId, messageCount, sequenceNumberStart,
sequenceNumberEnd, enqueueTimeStart, enqueueTimeEnd, dispatchTimeMilliseconds
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-detailed-event-processing.png" alt-text="Screenshot of the Application Insights query results for the detailed event processing query." lightbox="images/observability-detailed-event-processing.png":::

### Dispatch latency visualization

This query visualizes the 50th and 90th percentile event dispatch latency for a given function that's triggered by an event hub. For more information and notes, see the previous query.

```kusto
traces
| where operation_Name == "<enter the name of your function here>"
| where message startswith "Trigger Details: Parti"
| parse message with * "tionId: " partitionId:string ", Offset: "
offsetStart:string "-" offsetEnd:string", EnqueueTimeUtc: "
enqueueTimeStart:datetime "+00:00-" enqueueTimeEnd:datetime "+00:00, SequenceNumber: "
sequenceNumberStart:string "-" sequenceNumberEnd:string ", Count: "
messageCount:int
| extend dispatchTimeMilliseconds = (timestamp - enqueueTimeStart) / 1ms
| summarize percentiles(dispatchTimeMilliseconds, 50, 90) by bin(timestamp, 5m)
| render timechart
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-dispatch-latency-visualization.png" alt-text="Screenshot of a time chart showing the 50th and 90th percentile dispatch latency in milliseconds over 24 hours. The 50th percentile line stays near 25 ms. The 90th percentile line fluctuates between roughly 50 ms and 460 ms." lightbox="images/observability-dispatch-latency-visualization.png":::

### Dispatch latency summary

This query is similar to the previous one, but it shows a summary view.

```kusto
traces
| where message startswith "Trigger Details: Parti"
| parse message with * "tionId: " partitionId:string ", Offset: "
offsetStart:string "-" offsetEnd:string", EnqueueTimeUtc: "
enqueueTimeStart:datetime "+00:00-" enqueueTimeEnd:datetime "+00:00, SequenceNumber: "
sequenceNumberStart:string "-" sequenceNumberEnd:string ", Count: "
messageCount:int
| extend dispatchTimeMilliseconds = (timestamp - enqueueTimeStart) / 1ms
| summarize messageCount = sum(messageCount),
percentiles(dispatchTimeMilliseconds, 50, 90, 99, 99.9, 99.99) by operation_Name
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-dispatch-latency-summary.png" alt-text="Screenshot of the Application Insights query results for the dispatch latency summary. It shows a message count and dispatch latency percentiles." lightbox="images/observability-dispatch-latency-summary.png" border="false":::

### Message distribution across partitions

This query shows how to visualize message distribution across partitions.

```kusto
traces
| where message startswith "Trigger Details: Parti"
| parse message with * "tionId: " partitionId:string ", Offset: "
offsetStart:string "-" offsetEnd:string", EnqueueTimeUtc: "
enqueueTimeStart:datetime "+00:00-" enqueueTimeEnd:datetime "+00:00, SequenceNumber: "
sequenceNumberStart:string "-" sequenceNumberEnd:string ", Count: "
messageCount:int
| summarize messageCount = sum(messageCount) by cloud_RoleInstance,
bin(timestamp, 5m)
| render areachart kind=stacked
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-message-distribution-across-partitions.png" alt-text="Screenshot of the Application Insights query results for the message distribution across partitions query." lightbox="images/observability-message-distribution-across-partitions.png":::

### Message distribution across instances

This query shows how to visualize message distribution across instances.

```kusto
traces
| where message startswith "Trigger Details: Parti"
| parse message with * "tionId: " partitionId:string ", Offset: "
offsetStart:string "-" offsetEnd:string", EnqueueTimeUtc: "
enqueueTimeStart:datetime "+00:00-" enqueueTimeEnd:datetime "+00:00, SequenceNumber: "
sequenceNumberStart:string "-" sequenceNumberEnd:string ", Count: "
messageCount:int
| summarize messageCount = sum(messageCount) by cloud_RoleInstance,
bin(timestamp, 5m)
| render areachart kind=stacked
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-message-distribution-across-instances.png" alt-text="Screenshot of the Application Insights query results for the message distribution across instances query." lightbox="images/observability-message-distribution-across-instances.png":::

### Executing instances and allocated instances

This query shows how to visualize the number of Azure Functions instances that are processing events from Event Hubs, and the total number of instances (processing and waiting for lease). The two numbers should usually match.

```kusto
traces
| where message startswith "Trigger Details: Parti"
| summarize type = "Executing Instances", Count = dcount(cloud_RoleInstance) by
bin(timestamp, 60s)
| union (
    traces
    | summarize type = "Allocated Instances", Count = dcount(cloud_RoleInstance) by
bin(timestamp, 60s)
)
| project timestamp, type, Count
| render timechart
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-executing-instances-and-allocated-instances.png" alt-text="Screenshot of the Application Insights query results for the executing instances and allocated instances query." lightbox="images/observability-executing-instances-and-allocated-instances.png":::

### All telemetry for a specific function execution

You can use the **operation_Id** field across the different tables in Application Insights. For Azure functions triggered by Event Hubs, the following query, for example, returns the trigger information, telemetry from logs inside the function code, and dependencies and exceptions:

```kusto
union isfuzzy=true requests, exceptions, traces, dependencies
| where * has "<enter the operation_Id of your function execution here>"
| order by timestamp asc
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-all-telemetry-for-a-specific-function-execution.png" alt-text="Screenshot of the result of an Application Insights query. It shows all telemetry for a single operation ID." lightbox="images/observability-all-telemetry-for-a-specific-function-execution.png":::

### End-to-end latency for an event

The **enqueueTimeUtc** property in the trigger detail trace shows the enqueue time of only the first event of each batch that the function processed. You can use a more advanced query to calculate the end-to-end latency for events that pass through two functions connected by an event hub. This query expands the operation links (if there are any) in the second function's request and maps its completion time to the corresponding operation ID of the first function's start time.

```kusto
let start = view(){
requests
| where operation_Name == "FirstFunction"
| project start_t = timestamp, first_operation_Id = operation_Id
};
let link = view(){
requests
| where operation_Name == "SecondFunction"
| mv-expand ex = parse_json(tostring(customDimensions["_MS.links"]))
| extend parent = case(isnotempty(ex.operation_Id), ex.operation_Id, operation_Id )
| project first_operation_Id = parent, second_operation_Id = operation_Id
};
let finish = view(){
traces
| where customDimensions["EventName"] == "FunctionCompleted" and operation_Name
== "SecondFunction"
| project end_t = timestamp, second_operation_Id = operation_Id
};
start
| join kind=inner (
link
| join kind=inner finish on second_operation_Id
) on first_operation_Id
| project start_t, end_t, first_operation_Id, second_operation_Id
| summarize avg(datetime_diff('second', end_t, start_t))
```

The following screenshot shows the query results.

:::image type="content" source="images/observability-end-to-end-latency-for-an-event.png" alt-text="Screenshot of Application Insights query results for the end-to-end latency query." lightbox="images/observability-end-to-end-latency-for-an-event.png":::

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [David Barkol](https://www.linkedin.com/in/davidbarkol/) | AI Apps GBB

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Analyze Azure Functions telemetry in Application Insights](/azure/azure-functions/analyze-telemetry-data)
- [Configure monitoring for Azure Functions](/azure/azure-functions/configure-monitoring?tabs=v2)
- [Metrics in Azure Monitor - Azure Event Hubs](/azure/event-hubs/monitor-event-hubs)
- [Kusto Query Language](/kusto/query/)
