# Stream processing for IoT using Azure Functions

This chapter describes using Azure Functions to perform warm-path processing in an IoT solution. As described in the [Introduction](./index.md) to this series, the Drone Delivery application has the following functional requirements for warm-path processing:

- Read events from IoT Hub
- Transform the longitude and latitude values into [GeoJSON](https://tools.ietf.org/html/rfc7946) format. This is a standard format for geospatial data.
- Store the output in Cosmos DB.

Cosmos DB has native support for [geospatial data](https://docs.microsoft.com/en-us/azure/cosmos-db/geospatial). Cosmos DB collections can be indexed for efficient spatial queries. For example, an application could query for all drones within 1 km of a specified location, or find all drones inside a given area. Cosmos DB can also scale to support very high write throughput. 

These processing requirements are simple enough that they don't require a full-fledged stream processing engine. In particular, the warm path described here does not join streams, aggregate data, or process across time windows. Based on these requirements, Azure Functions is a good fit. 

In the Azure Functions programming model, you write a small piece of code (a function). You also declare a [trigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings) for the function, which defines how the function is invoked. You can also declare an *output binding* that connects the function to an output.

1. As messages arrive in the IoT hub, the function is invoked with a batch of messages.
2. The function loops through the message to process them, and puts the results into a collection object.
3. Based on the binding, the collection object sends the data to an output &mdash; in this case, Cosmos DB.

The Azure Function for the warm path uses the Cosmos DB output binding, which is provided with the SDK. By using an output binding, you don't have to write any code to invoke Cosmos DB APIs directly. The function simply adds objects to a collection, and the binding serializes the objects to JSON and writes them to Cosmos DB.  

The function uses the Cosmos DB client SDK to convert the latitude/longitude values into the expected GeoJSON values:

```csharp
foreach (var message in messages)
{
    var text = Encoding.UTF8.GetString(message.GetBytes());
    try
    {
        dynamic telemetry = JObject.Parse(text);
        if (telemetry.sensorType == DroneSensorEventType)
        {
            string position = telemetry.position;
            var (latitude, longitude) = DroneTelemetryConverter.ConvertPosition(position);

            await documents.AddAsync(new
            {
                id = telemetry.deviceId,
                deviceId = telemetry.deviceId,
                Location = new Point(longitude, latitude),
                Timestamp = message.EnqueuedTimeUtc
            });
            count++;
        }
    }
    catch (Exception ex)
    {
        log.Error("Error processing message", ex);
    }
}
```

## Partitioning

In order to scale out the Cosmos DB collection, create the collection with a partition key and include the partition key in each document that you write to Cosmos DB. Some characteristics of a good partition key:

- The key value space is large.
    - Cosmos DB creates physical partitions based on actual usage, and transparently splits physical partitions in the background as usage goes up.
- There will be an even distribution of reads/writes per key value, avoiding hot keys. 
- The maximum data stored for any single key value will not exceed 10 GB. 
    - If you try to write more than 10 GB to a single partition, Cosmos DB returns an error.
- The partition key for a document won't change.
    - You can't update the partition key on an existing document. If the value changes, you have to delete the document and recreate.


The warm path stores exactly one document per drone. The function continually updates the documents with the drone's latest position, using an upsert operation. Therefore, device ID is a good partition key for this scenario. Writes will be evenly distributed across the keys, and the size of each partition is strictly bounded, because there is a single document for each key value. 


On the other hand, suppose the function create a separate document for every device message that it received. Message ID would be a better partition key in that case. Using the device ID as a partition key would quickly exceed the 10 GB limit per partition. 

For more information, see [Partition and scale in Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/partition-data).

## Throughput

As implemented, the warm path has two main potential bottlenecks:

- Throttling by the database.
- The speed at which the function can process messages.

Cosmos DB throttles requests if the throughput exceeds the provisioned RUs. You should monitor Cosmos DB for throttled requests (HTTP 429). If requests are consistently being throttled, scale out the collection to add more RU. Another symptom of throttling is that the average request latency spikes inside the function, due to the functioning retrying the failed requests. 

If the function can't process messages quickly enough, you won't necessarily see any errors. However, the function will lag further and further behind the input stream. 

To detect this condition, monitor the difference between the time when a message arrives at IoT Hub, and the time when the function receives the message for processing. The reference implementation includes a custom metric to track this value:

```csharp
var ticksUTCNow = DateTimeOffset.UtcNow;

// Track whether messages are arriving at the function late.
DateTime? firstMsgEnqueuedTicksUtc = messages[0]?.EnqueuedTimeUtc;
if (firstMsgEnqueuedTicksUtc.HasValue)
{
    CustomTelemetry.TrackMetric(
                        context,
                        "IoTHubMessagesReceivedFreshnessMsec",
                        (ticksUTCNow - firstMsgEnqueuedTicksUtc.Value).TotalMilliseconds);
}
```

The `TrackMetric` function writes a custom metric to Application Insights. For information about using `TrackMetric` inside an Azure Function, see [Custom telemetry in C# function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring#custom-telemetry-in-c-functions).

If the function is able to keep up with the volume of messages, this metric should stay at a low steady state. (Some latency is unavoidable, so the value will never be zero.) But if the function falls behind, the delta between enqueued time and processing time will start to go up.

Here's a graph from a load test where the function was not keeping up. The message lateness steadily rises to 5 minutes, meaning the function is processing messages that are already 5 minutes old when they reach the function. 

![](./_images/warm-path-message-lateness.png)
 
The value peaks at 5 minutes because the function includes logic to discard messages that are more than 5 minutes late:

```csharp
foreach (var message in messages)
{
    // Drop stale messages,
    if (message.EnqueuedTimeUtc < cutoffTime)
    {
        log.Info($"Dropping late message batch. Enqueued time = {message.EnqueuedTimeUtc}, Cutoff = {cutoffTime}");
        droppedMessages++;
        continue;
    }
```

You can see this in the following graph which tracks number of messages received vs number of Cosmos DB documents written. The number of messages per minute continues to climb, but at some point the number of documents writes hits a plateau. This corresponds to the time when the function falls so far behind that it begins to discard messages. 
 
![](./_images/warm-path-dropped-messages.png)

Azure Functions can run in parallel, but in this case, the degree of parallelism is limited by the number of Event Hub partitions, because each partition is assigned one function instance at a time. You can scale out by creating the IoT Hub with more partitions. 

Another way to increase throughput is to optimize the I/O calls made by the function. Our baseline implementation uses the built-in Cosmos DB output binding. This worked well for the target throughput of 2500 messages per second. However, load tests showed the function fell behind at higher throughput. The reference implementation includes an optimized version of the function for high throughput. This version calls the Cosmos DB client directly, so that database writes can be done in parallel. 

```csharp
private async Task<(long documentsUpserted,
                    long droppedMessages,
                    long cosmosDbTotalMilliseconds)>
                ProcessMessagesFromEventHub(
                    int taskCount,
                    int numberOfDocumentsToUpsertPerTask,
                    EventData[] messages,
                    TraceWriter log)
{
    DateTimeOffset cutoffTime = DateTimeOffset.UtcNow.AddMinutes(-5);

    var tasks = new List<Task>();

    for (var i = 0; i < taskCount; i++)
    {
        var docsToUpsert = messages
                            .Skip(i * numberOfDocumentsToUpsertPerTask)
                            .Take(numberOfDocumentsToUpsertPerTask);
        // client will attempt to create connections to the data 
        // nodes on Cosmos db's clusters on a range of port numbers
        tasks.Add(UpsertDocuments(i, docsToUpsert, cutoffTime, log));
    }

    await Task.WhenAll(tasks); 

    return (this.UpsertedDocuments,
            this.DroppedMessages,
            this.CosmosDbTotalMilliseconds);
}
```

With this approach, race conditions are theoretically possible. Suppose that two messages from the same drone happen to arrive in the same batch of messages. By writing them in parallel, the earlier message could overwrite the later message. In the Drone Delivery application, this is an acceptable risk for two reasons:

- First, the odds of a race condition are fairly small. With a large number of devices, most of the time, a batch will contain messages from completely distinct devices.

- Second, the warm path can tolerate losing an occasional message. Drones send new position data every 5 seconds, so the data in Cosmos DB is updated continually.

However, in other scenarios, it may be important to process the events strictly in order.
