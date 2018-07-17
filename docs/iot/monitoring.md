# Monitoring

It's important to monitor the health and performance of any application, and IoT is no exception.  The purpose of monitoring is to measure performance and uptime, track the health of the system, observe failures, and be able to find the cause of failures.

For applications that run in the cloud, you have to monitor two distinct aspects of the system:

- **Infrastructure monitoring**. You should monitor all of the cloud services used in your application. For example, monitor the number of messages ingested by your IoT Hub instance, or whether a service is throttling requests. Use Azure Monitor to monitor Azure services. This service is built into the Azure platform and does not require any additional code in your application. 

- **Application monitoring**. An application should be instrumented to product run-time metrics and application logs. Metrics are numerical values that can be analyzed. Use them to observe the system in real time, or analyze performance trends over time. Logs are records of events that occur while the application is running. They include things like application logs (trace statements) or web server logs. Logs are primarily useful for forensics and root cause analysis. Consider using Application Insights for application metrics and logs.

It's no good collecting all of this data unless you can see the data and act on it. Broadly speaking, there are three main ways that you will consume monitoring data:

- **Alerts**. If a critical failure happens, such as a subsystem fails, the monitoring system should send an alert, so that operators know to respond. Azure Monitor allows you to create alert rules based on a set of criteria, such as a metric hitting a certain threshold.

- **Dashboards**. A dashboard is a visual representation of the monitoring data. You can create a dashboard in the Azure Portal, or use a third-party dashboard.

- **Ad hoc queries**. Distributed systems tend to generate a large volume of logs and traces. To perform root-cause analysis, you must be able to query all of your logs. Azure Log Analytics is an analytics engine that can collect data from Azure Monitor, Application Insights, and other sources.

## Creating a monitoring dashboard

A dashboard provides a way to visualize the application metrics. When creating a dashboard, consider the following two options:

- Create a custom dashboard in the Azure Portal. This option is very easy to create and deploy, because Azure Monitor and Application Insights are both integrated into the portal. You can create a custom dashboard from a set of existing resources in Azure. Then you can download an Azure Resource Manager template for the dashboard and use it to automate deployment the dashboard. By parameterizing the template, you can make it a part of your CI/CD pipeline. For more information, see Programmatically create Azure Dashboards.

- Use a third-party dashboard that integrates with Azure Monitor. For example, plugins are available for Grafana or Datadog. This approach requires some additional work to set up, but lets you take advantage of advanced features provided by those dashboards, such as heatmaps and other visualizations.

For our own load testing, we built two dashboards, one using the Azure Portal, and one using Grafana. The two dashboards pull from the same data sources. Here you can see them side-by-side:

![](./_images/dashboards.png)

A good monitoring dashboard should make it easy to tell at a glance when key metrics are in the red. It should also be easy to see how different metrics are correlated across time. Finally, you should be able to select a time range, in order to understand what was happening before and during an incident.

## Key performance indicators

It's important to choose the right metrics to monitor. You are looking to capture warning signals, metrics to validate the system is functioning correctly, and anything that will help with root cause analysis after a failure.

The best time to detect a problem is before it happens. Warning signals let you know when a resource is hitting a performance or scale limit. For example, any of the following could indicate a capacity problem:

- Stream Analytics job has SU consumptions above 80%.
- Cosmos DB begins to throttle requests.
- IoT Hub is close to the maximum message ingestion.

Often these signals mean that you should scale a resource to provide more capacity. Consider creating alerts for these signals, if they require an operator to respond. However, you also need to balance the number of alerts against the danger of having too many false positives.

For the hot and warm paths, you should also measure the processing latency. It's possible that everything can work fine without errors, but the processing falls behind the ingestion rate.

In a stream processing application, it can be hard to know whether the system is functioning correctly, because the quantity of data is too large to inspect manually. For example, consider anomaly detection in the Drone Delivery application. If no anomalies are detected, does that mean every drone is functioning normally, or does it mean the messages aren't reaching the stream processing component?  

For this reason, it's useful to include some metrics that validate the overall state of the system. For example, include a query that detects the absence of telemetry from a device. That way, you can avoid "silent failures" where a lack of a signal is interpreted to mean systems are running normally.

A final point to consider: Single metrics can be hard to interpret. For example, in the warm path, we track the number of documents written to Cosmos DB per second. Without any other context, this metric is meaningless. How many documents *should* get written? But it has meaning when you compare it to the number of messages ingested by IoT Hub. As the volume of device messages goes up, the number of writes to Cosmos DB should go up proportionally.

For reference, here are the metrics that we tracked during our load testing:

Cold path:

- Blob Storage: Storage capacity, transactions per minute

Hot path:

- IoT Hub: Total messages, total device data usage, throttling errors, number of registered devices, number of connected devices, endpoint latency
- Azure Functions: Request count, error count, maximum function duration
- Azure Stream Analytics: SU % utilization, conversion errors, input deserialization errors, I/O events, late events, dropped/adjusted events 
- Cosmos DB: RU, total requests

Warm path:

- Azure Functions: Request count, error count, maximum function duration
- Cosmos DB: RU, total requests
- Custom metrics: 
    - Messages received per batch
    - Documents created or updated per batch
    - Message freshness (latency)
    - Number of discarded messages (late messages)

Device simulator:

- IoT Hub metrics
- CPU usage for VMs running the simulator
- Network Out (bytes of outgoing traffic on all network interfaces)

## Distributed tracing

A common challenge in distributed systems is understanding how messages flow through the system. When a message triggers some action, it's useful to know where the message originated. For IoT scenarios, that means messages should include the device ID and timestamp in the message. You might also include an event ID to correlate several messages that relate to the same event. If there are processing steps that transform the message payload, they should preserve these values. For example, if the pipeline includes a protocol translation stage, the output should include the fields needed for correlation. 

However, there's often a processing stage that aggregates the data stream, for example by computing an average over a time window. At that point, there's no way to correlate individual messages. Instead, you may need to track statistical metrics, such as the data volume going into and out of the pipeline, as a way to validate that messages are being processed.

For cloud-to-device messages, you should correlate the entire data path when possible. For example, consider a connected car application that allows a driver to lock or unlock a car remotely, using a mobile app. In this scenario, the mobile app sends a command to the cloud, which triggers sending a message to the car. The command message that is sent to the car should include a correlation ID that associates it with the mobile app request. That way, if there is a failure or some other issue, you will be able to reconstruct the sequence of events.

## Example of performance monitoring

Here is an example of using monitoring to diagnose a performance issue. All of the screenshots in this section are taken from a load test that we performed on the warm path. During this test, we deliberately stressed the system by 

The first symptom of a problem was receiving a lot of 429 errors from Cosmos DB, indicating that Cosmos DB was throttling the write requests.

![](./_images/cosmosdb-429.png)

In response, we scaled Cosmos DB by increasing the number RUs allocated for the collection, but the errors continued. This seemed strange, because our back-of-envelope calculation showed that Cosmos DB should have no problem keeping up with the volume of write requests. 

Later that day, one of out developers sent the following email to the team:

> I looked at Cosmos DB for the warm path. There's one thing I don't understand. The partition key is deliveryid, however we don't send deliveryid to Cosmos DB. Am I missing something?

That was the clue. Looking at the partition heat map, it turned out that all of the documents were landing on the same partition. 

![](./_images/cosmosdb-partitions.png)

What you want to see in the heat map is an even distrubution across all of the partitions. In this casem because every document was getting written to the same partition, adding RUs didn't help. The problem turned out to be a bug in the code. Although the Cosmos DB collection had a partition key, the Azure Function didn't actually include the partition key in the document.

When the team deployed a code fix and re-ran the test, Cosmos DB stopped throttling.
For awhile, everything looked good. But at a certain load, telemetry showed that the function was writing fewer documents that it should.

The Azure Function receives two message types from upstream &mdash; drone position and drone state. It ignores the drone state messages, and upserts a Cosmos DB document for each position message. 

In the following diagram, the yellow line is number of messages received per batch, and the green is the number of documents written per batch. These should be proportional. Instead, the number of database write operations per batch drops significantly at about 07:30.

![](./_images/warm-path-dropped-messages.png)

Now let's look at another metric: The latency beween when message arrives at IoT Hub, and when the function processes that message. You can see that at the same point in time, the lateness spikes dramatically, levels off, and the declines.

![](./_images/warm-path-message-lateness.png)

What was happening? Simply put, the function was not writing documents quickly enough to keep up with the incoming volume of messages. Over time, it fell further and further behind. The function has logic to discard messages that are more than 5 minutes old. You can see this in the graph when the lateness metric drops back to zero. In the meantime, data has been lost, because the function was throwing away messages.

Keep in mind that the Cosmos DB collection had RUs to spare. So the problem had nothing to do Cosmos DB being able to handle the load. Once we optimized the function code, we achieved a much higher throughput. For details about the optimized code, see [Optimizing the Azure Function](./azure-functions.md#optimizing-the-azure-function).



