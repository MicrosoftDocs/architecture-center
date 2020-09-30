---
title: Partitioning Strategies in Event Hubs and Kafka
titleSuffix: Azure Solution Ideas
author: JKirsch1
ms.date: 09/30/2020
description: Learn about partitioning in Event Hubs and Kafka. See how many partitions to use in ingestion pipelines and which partitioning assignment strategy to use.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - hybrid
  - analytics
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/media/event-processing-service.png
---

# Partitioning strategies in Event Hubs and Kafka

Azure Event Hubs and Apache Kafka are both event ingestion services that manage high-scale event streaming. To be efficient, such systems need to offer parallel processing. But at times, they also need to maintain the order of events that they process.

Both services use a [partitioning model][Partitions] to achieve parallelism. Besides improving efficiency, such an architecture makes load balancing possible. With more concurrent readers processing data, throughput increases. Partitioned consumers therefore also make the architecture scalable. To preserve the order of events, Event Hubs and Kafka make use of partition keys and ids.

This reference architecture illustrates different partitioning strategies that Event Hubs and Kafka use. In particular, the discussion addresses the following points:

- The advantages and disadvantages of using more than a required number of partitions.
- The effects of partitioning on downstream processing of data.
- Strategies for identifying the number of partitions to use.
- The differences between partitioning in Event Hubs and Kafka.
- Insights drawn from code examples.

## Potential use cases

Many organizations can benefit from event ingestion services. Possibilities include the following cases:

- Industries that work with naturally streaming data, such as banking transactions, analytics pipelines, and application logs.
- Businesses that manage sequential data, such as weather readings, gene sequences, or price feeds.
- Administrators seeking solutions that gracefully manage loads as processors join or leave the implementation.

## Architecture

:::image type="complex" source="../media/event-processing-service.png" alt-text="Architecture diagram showing the flow of events in an ingestion pipeline. Events flow from producers to a cluster or namespace and then to consumers." border="false":::
   At the center of the diagram is a box labeled Kafka Cluster or Event Hub Namespace. Three smaller boxes sit inside that box. Each is labeled Topic or Event Hub, and each contains multiple rectangles labeled Partition. Above the main box are rectangles labeled Producer. Arrows point from the producers to the main box. Below the main box are rectangles labeled Consumer. Arrows point from the main box to the consumers and are labeled with various offset values. A single blue frame labeled Consumer Group surrounds two of the consumers, grouping them together.
:::image-end:::

1. Producers, or event publishers, send data to the ingestion service, or *pipeline*. In Event Hubs, publishers use a [Shared Access Signature (SAS)][Shared Access Signatures] token to identify themselves. Producers can publish events individually, but they can also buffer events and publish them in batches.
1. Servers in the namespace, or cluster, process incoming events and distribute them among partitions. These partitions reside within event hubs, or topics. The pipeline servers also provide load balancing, rebalancing, and disaster recovery services.
1. Consumers subscribe to topics. Multiple consumers can make up consumer groups. This approach gives each consumer a separate view of the event stream. In Event Hubs, consumers connect via an [AMQP 1.0 session][AMQP 1.0], a state-aware bidirectional communication channel.
1. Consumers listen to events they subscribe to and then process the feed of published events. Consumers also engage in *checkpointing*. Through this process, subscribers mark or commit their position within a partition event sequence.

### Components

- [Azure Event Hubs][Azure Event Hubs]: A fully managed big data streaming platform and event ingestion service. Event Hubs receives and processes events and then distributes them to consumers. Since Event Hubs sits between event publishers and event consumers, it decouples event stream production from event consumption.
- [Apache Kafka][Apache Kafka]: An open-source stream-processing platform. Kafka provides a distributed solution for handling real-time data feeds.
- Event hub: A logical entity that is a named stream of events in Event Hubs.
- Topic: The Kafka equivalent of an event hub.
- Namespace: A unique scoping container that holds one or more event hubs.
- Cluster: The Kafka equivalent of a namespace. Each cluster can hold topics.
- Partition: A subdivision within an event hub or a topic. When the pipeline sends events to an event hub or a topic, it distributes them across the partitions in one of the following ways:

  - Using a round-robin fashion.
  - Sending to a specific partition.
  - Using a key to process a hash that determines the destination partition.
  
  Within a partition, events remain in production order. Across partitions, events do not remain in sequence.
- Consumer: A process or application that subscribes to a topic and processes the feed of published events. Each consumer reads a specific subset of the event stream. That subset can include more than one partition. However, only one consumer can subscribe to each partition at a time.
- Offset: A placeholder for a consumer. An offset works like a bookmark to identify the last event that the consumer read.
- Consumer group: A group of consumers that the pipeline uses for load sharing. When a consumer group subscribes to events in a topic, each consumer in the group reads a different event. In this way, multiple consuming applications each have a separate view of the event stream. The applications work independently from each other, at their own pace and with their own offsets.
- Throughput: The amount of data, or number of events, that pass through the system in a set period of time. Pipelines usually measure throughput in bits per second (bps), and sometimes in data packets per second (pps).
- Broker: A Kafka server that hosts and manages topics.

### Determine the number of partitions

The process of deciding how many partitions to use is complex. Many factors influence that decision:

- A solution's degree of parallelism depends on the number of partitions that are available. Each consumer reads from its assigned partition. As a result, with more partitions, more consumers can receive events from a topic at the same time. More partitions therefore achieve more throughput.
- Ideally, the number of partitions should equal or exceed the desired throughput in megabytes.
- The number of partitions should usually equal or exceed the number of consumers. Otherwise, starving of consumers results. For instance, suppose eight partitions are assigned to eight consumers. Any additional consumers that start subscribing will have to wait. However, another strategy keeps one or two consumers ready to receive events when an existing consumer fails. In this case, the consumers need to ensure that they pick up events from the right offset.

A rough formula exists for determining the number of partitions. It uses the following throughput values:

- `p`: The production throughput on a single partition.
- `c`: The consumption throughput on a single partition.
- `t`: The target throughput.
  
The formula calculates the number of partitions that are needed to achieve the target throughput in this way:  

`max(t/p, t/c)`  

For example, consider the following situation:

- A producer sends events at a rate of 1,000 events per second. For the formula, `p` is equal to 1 MBps.
- A consumer receives events at a rate of 500 events per second. As a result, `c` gets the value 0.5 MBps.
- The desired throughput is 2 MBps, setting `t` to 2 MBps.

With these values, the number of partitions is 4:

`max(t/p, t/c) = max(2/1, 2/0.5) = max(2, 4) = 4`

When calculating the production and consumption throughput, keep these points in mind:

- The slowest consumer determines the consumption throughput. However, sometimes no information is available about the downstream consumer applications. In this case, the following test can provide an estimate of the throughput:

  - Start with one partition as a baseline. (Use this recommendation only in testing environments, not in production systems).
  - Event Hubs with Standard tier pricing and one partition should produce throughput between 1 MBps and 20 MBps.

- Consumers can consume events from an ingestion pipeline at a high rate only if producers send events at a comparable rate. It's therefore important to measure the producer's throughput, and not just the consumer's. The producer's throughput determines the total required capacity of the ingestion pipeline.

### Distribute events to partitions

Another aspect of the Event Hubs and Kafka architectures is the partitioning strategy. An event that arrives at a processing service goes to a partition. The partitioning strategy determines that partition.

Each event stores its content in its value. Besides the value, each event also contains a key, as the following diagram shows:

:::image type="complex" source="../media/pipeline-event-parts.png" alt-text="Architecture diagram showing the parts of an event. Each event, or message, consists of a key and a value. Multiple events make up a stream." border="false":::
   At the center of the diagram are multiple pairs of boxes. A label below the boxes indicates that each pair represents a message. Each message contains a blue box labeled Key and a black box labeled Value. The messages are arranged horizontally. Arrows between messages that point from left to right indicate that the messages form a sequence. Above the messages is the label Stream. Brackets indicate that the sequence forms a stream.
:::image-end:::

The key contains data about the event and can also play a role in the partitioning strategy.

Multiple approaches exist for determining how to partition events:

- By default, services distribute events among partitions in a round-robin fashion.
- Producers can specify a partition id with an event. The event then goes to the partition with that id. This approach is useful when consumers are only interested in certain events. When those events flow to a single partition, the consumer can easily receive them by subscribing to that partition.
- Producers can provide a value for the event key. When they do, a hashing-based partitioner determines a hash value from the key. The event then goes to the partition associated with that hash value. All events with the same key always arrive at the same partition.

The following factors influence the choice of strategy:

- Keys are useful when consumers need to receive events in production order. Since all events with the same key go to the same partition, events with key values can maintain their order during processing. Consumers then receive them in that order.
- If event grouping or ordering is not required, it's best to avoid the hashing-based partitioning strategy. With Apache Kafka, the producer does not know the status of the destination partition. If a key routes an event to a partition that is down, delays or lost events can result. In Azure Event Hubs, events with keys first pass through a gateway before proceeding to a partition. This approach handles incoming traffic in a more reliable way since it prevents events from going to unavailable partitions.
- The shape of the data can influence the partitioning approach. Considering how the downstream architecture will distribute the data can also affect the decision.
- If consumers aggregate data on a certain attribute, it makes sense to partition on that attribute, too.
- When storage efficiency is a concern, partitioning on an attribute that concentrates the data can help to speed up storage operations.
- Ingestion pipelines sometimes shard data to get around problems with resource bottlenecks. In these environments, it's efficient to align the partitioning with how the shards are split in the database.

### Partition rebalancing

Each consumer reads event data from at least one partition of a topic. Whenever consumers join or leave a particular topic, the pipeline rebalances the partitions. Apache Kafka uses one of the following strategies when assigning partitions to consumers:
  
- Round robin: By default, Kafka and Event Hubs use this assignment strategy. This approach distributes all partitions evenly across all members.
- Range assignor: This strategy brings together partitions from different topics. It identifies topics that use the same number of partitions and the same key-partitioning logic. Then it joins partitions from those topics when making assignments to consumers.
- Sticky assignor: This assignment is similar to round robin in that it ensures a uniform distribution. However, it minimizes partition movement during rebalancing.
- Static assignment: With this approach, the pipeline uses partition ids to assign specific partitions to specific consumers. The assignments do not trigger partition rebalances. The user is responsible for making sure that all partitions have subscribers.

## Considerations

Keep in mind the points in the following sections when determining a partitioning strategy and the number of partitions to use.

### Drawbacks of high partition count

There are several disadvantages of using a large number of partitions:

- In Apache Kafka, brokers store event data and offsets in files. If you use numerous partitions, you'll also have a large number of open file handles. The underlying operating system may limit the number of open files. If you're in danger of exceeding that limit, you'll need to reconfigure that setting.
- In Azure Event Hubs, users don't face file system limitations. However, each partition manages its own Azure blob files and optimizes them in the background. With a large number of partitions, it can be expensive to maintain offset information, or checkpoint data. The reason is that I/O operations can be time-consuming, and the storage API calls are proportional to the number of partitions.
- Apache Kafka generally positions partitions on different brokers. When a broker fails, Kafka rebalances the partitions to avoid losing events. The more partitions there are to rebalance, the longer the failover takes, increasing unavailability. For this reason, it's best to limit the number of partitions to the low thousands.
- With more partitions, the load balancing process has to work with more moving parts and more stress. *Transient exceptions* can result. These errors can occur when there are temporary disturbances, such as network issues or intermittent internet service. They can come up during an upgrade or load balancing, when Event Hubs sometimes moves partitions to different nodes. Clients should handle transient behavior by incorporating retries to minimize failures. The [EventProcessorClient in the .NET][Azure Event Hubs Event Processor client library for .NET] and [Java SDKs][Azure Event Hubs client library for Java] or the [EventHubConsumerClient in the Python][Azure Event Hubs client library for Python] and [JavaScript SDKs][Azure Event Hubs client library for Javascript] can simplify this process.
- Overall, using more partitions means that more physical resources are in operation. Depending on the client response, more failures can occur as a result.
- In Apache Kafka, events are *committed* after the pipeline has replicated them across all in-sync replicas. This approach ensures the high availability of events. Since consumers only receive committed events, the replication process adds to the *latency*. In ingestion pipelines, this term refers to the time between when a producer publishes a event and a consumer reads it. According to [experiments that Confluent ran][How to choose the number of topics/partitions in a Kafka cluster?], replicating 1,000 partitions from one broker to another can take about 20 milliseconds. The end-to-end latency is then at least 20 milliseconds. When the number of partitions increases further, the latency also grows. This drawback doesn't apply to Event Hubs.
- Each producer for Kafka and Event Hubs stores events in a buffer until a sizeable batch is available or until a specific amount of time passes. Then the producer sends the events to the ingestion pipeline. The producer maintains a buffer for each partition. When the number of partitions increases, the memory requirement of the client also expands. If consumers receive events in batches, they may also face the same issue. The situation can become problematic when consumers subscribe to a large number of partitions but have limited memory available for buffering.

### Additional considerations

Keep these points also in mind when implementing this architecture:

- You should use more distinct keys than partitions. Otherwise, some partitions won't receive any events, leading to unbalanced partition loads.
- In both Apache Kafka and Azure Event Hubs at the Dedicated tier level, you can change the number of partitions in an operating system. However, if you need to preserve event ordering or use key hashing, try to avoid changing the number of partitions. The reason involves the following facts:
  - The pipeline maps an event to a partition based on the hash of the key.
  - Events with the same key always go to the same partition. Customers therefore rely on certain partitions and the order of the events they contain.
  - When the number of partitions changes, the mapping can change. For instance, consider the following formula:  
    `partition assignment = hash key % number of partitions`  
    With this formula, the partition assignment can change when the number of partitions changes.
  - Neither Kafka nor Event Hubs attempts to redistribute events that arrived at partitions before the shuffle. As a result, the guarantee no longer holds that events arrive at a certain partition in publication order.

## Deploy this scenario

### Maintain throughput

Consider an example involving log aggregation. The goal is not to process events in order, but rather, to maintain a specific throughput.

You can use a Kafka client to implement producer and consumer methods. Since order isn't important, you can use the default partitioning assignment. There's no need to send messages to specific partitions. The following code illustrates these concepts:

```csharp
public static void RunProducer(string broker, string connectionString, string topic)
{
    // Set the configuration values of the producer.
    var producerConfig = new ProducerConfig
    {
        BootstrapServers = broker,
        SecurityProtocol = SecurityProtocol.SaslSsl,
        SaslMechanism = SaslMechanism.Plain,
        SaslUsername = "$ConnectionString",
        SaslPassword = connectionString,
    };

    // Set the message key to Null since the code does not use it.
    using (var p = new ProducerBuilder<Null, string>(producerConfig).Build())
    {
        try
        {
            // Send a fixed number of messages. Use the Produce method to generate
            // many messages in rapid succession instead of the ProduceAsync method.
            for (int i=0; i < NumOfMessages; i++)
            {
                string value = "message-" + i;
                Console.WriteLine($"Sending message with key: not-specified," +
                    $"value: {value}, partition-id: not-specified");
                p.Produce(topic, new Message<Null, string> { Value = value });
            }

            // Wait up to 10 seconds for any in-flight messages to be sent.
            p.Flush(TimeSpan.FromSeconds(10));
        }
        catch (ProduceException<Null, string> e)
        {
            Console.WriteLine($"Delivery failed with error: {e.Error.Reason}");
        }
    }
}


public static void RunConsumer(string broker, string connectionString, string consumerGroup, string topic)
{
    var consumerConfig = new ConsumerConfig
    {
        BootstrapServers = broker,
        SecurityProtocol = SecurityProtocol.SaslSsl,
        SocketTimeoutMs = 60000,
        SessionTimeoutMs = 30000,
        SaslMechanism = SaslMechanism.Plain,
        SaslUsername = "$ConnectionString",
        SaslPassword = connectionString,
        GroupId = consumerGroup,
        AutoOffsetReset = AutoOffsetReset.Earliest
    };

    using (var c = new ConsumerBuilder<string, string>(consumerConfig).Build())
    {
        c.Subscribe(topic);

        CancellationTokenSource cts = new CancellationTokenSource();
        Console.CancelKeyPress += (_, e) =>
        {
            e.Cancel = true;
            cts.Cancel();
        };

        try
        {
            while (true)
            {
                try
                {
                    var message = c.Consume(cts.Token);
                    Console.WriteLine($"Consumed - key: {message.Message.Key}, "+
                        $"value: {message.Message.Value}, " +
                        $"partition-id: {message.Partition}," +
                        $"offset: {message.Offset}");
                }
                catch (ConsumeException e)
                {
                    Console.WriteLine($"Error occured: {e.Error.Reason}");
                }
            }
        }
        catch(OperationCanceledException)
        {
            // Close the consumer to ensure that it leaves the group cleanly
            // and that final offsets are committed.
            c.Close();
        }
    }
}
```

This code example produces the following results:

:::image type="content" source="../media/event-processing-results-maintain-throughput.png" alt-text="Screenshot showing producer and consumer logs. Events arrived out of order, used a random pattern for partition assignment, and did not contain keys." border="false":::

In this case, the topic has four partitions. The following events took place:

- The producer sent 10 messages, each without a partition key.
- The messages arrived at partitions in a random order.
- A single consumer listened to all four partitions and received the messages out of order.

If the code had used two instances of the consumer, each instance would have subscribed to two of the four partitions.

### Distribute to specific partition

Consider an example involving error messages. Suppose certain applications need to process error messages, but all other messages can go to a common consumer. In this case, the producer sends error messages to a specific partition. Consumers who want to receive error messages listen to that partition. The following code shows how to implement this scenario:

```csharp
// Producer code.
var topicPartition = new TopicPartition(topic, partition);

...

p.Produce(topicPartition, new Message<Null, string> { Value = value });

// Consumer code.
// Subscribe to one partition.
c.Assign(new TopicPartition(topic, partition));

// Use this code to subscribe to a list of partitions.
c.Assign(new List<TopicPartition> {
  new TopicPartition(topic, partition1),
  new TopicPartition(topic, partition2)
});
```

As the following results show, the producer sent all messages to partition 2 in this case, and the consumer only read messages from partition 2:

:::image type="content" source="../media/event-processing-results-specify-partition.png" alt-text="Screenshot showing producer and consumer logs. All events went to partition 2. They arrived in production order, and none contained a key." border="false":::

In this scenario, if you add another consumer instance to listen to this topic, the pipeline won't assign any partitions to it. The new consumer will starve until the existing consumer shuts down. If the existing consumer shuts down, the pipeline will assign a different, active consumer to read from the partition. But the pipeline will only make that assignment if the new consumer is not dedicated to another partition.

### Preserve event order

Consider bank transactions that a consumer needs to process in order. In this scenario, you can use the customer id of each event as the key. For the event value, use the details of the transaction. The following code shows how to implement this case:

```csharp
Producer code
// This code assigns the key an integer value. You can also assign it any other valid key value.
using (var p = new ProducerBuilder<int, string>(producerConfig).Build())
...
p.Produce(topic, new Message<int, string> { Key = i % 2, Value = value });
```

This code produces the following results:

:::image type="content" source="../media/event-processing-results-specify-key.png" alt-text="Screenshot showing producer and consumer logs. Events had keys that determined the partition they went to. Within partitions, events arrived in order." border="false":::

As these results show, the producer only used two unique keys. The messages then went to only two partitions instead of all four. The pipeline guarantees that messages with the same key go to the same partition.

## Next steps

- [Use Azure Event Hubs from Apache Kafka applications][Use Azure Event Hubs from Apache Kafka applications]
- [Apache Kafka developer guide for Azure Event Hubs][Apache Kafka developer guide for Azure Event Hubs]
- [Quickstart: Data streaming with Event Hubs using the Kafka protocol][Quickstart: Data streaming with Event Hubs using the Kafka protocol]
- [Send events to and receive events from Azure Event Hubs - .NET (Azure.Messaging.EventHubs)][Send events to and receive events from Azure Event Hubs - .NET]

## Related resources

- [Balance partition load across multiple instances of your application][Balance partition load across multiple instances of your application]
- [Dynamically add partitions to an event hub (Apache Kafka topic) in Azure Event Hubs][Dynamically add partitions to an event hub in Azure Event Hubs]
- [Availability and consistency in Event Hubs][Availability and consistency in Event Hubs]
- [Azure Event Hubs Event Processor client library for .NET][Azure Event Hubs Event Processor client library for .NET]
- [Effective strategies for Kafka topic partitioning][Effective strategies for Kafka topic partitioning]
- [Confluent blog post: How to choose the number of topics/partitions in a Kafka cluster?][How to choose the number of topics/partitions in a Kafka cluster?]



[AMQP 1.0]: https://docs.microsoft.com/azure/service-bus-messaging/service-bus-amqp-protocol-guide
[Apache Kafka]: https://www.confluent.io/what-is-apache-kafka/
[Apache Kafka developer guide for Azure Event Hubs]: https://docs.microsoft.com/azure/event-hubs/apache-kafka-developer-guide
[Availability and consistency in Event Hubs]: https://docs.microsoft.com/azure/event-hubs/event-hubs-availability-and-consistency?tabs=latest
[Azure Event Hubs]: https://docs.microsoft.com/azure/event-hubs/event-hubs-about
[Azure Event Hubs client library for Java]: https://docs.microsoft.com/java/api/overview/azure/messaging-eventhubs-readme?view=azure-java-stable
[Azure Event Hubs client library for Javascript]: https://docs.microsoft.com/javascript/api/overview/azure/event-hubs-readme?view=azure-node-latest
[Azure Event Hubs client library for Python]: https://docs.microsoft.com/python/api/overview/azure/eventhub-readme?view=azure-python
[Azure Event Hubs Event Processor client library for .NET]: https://github.com/Azure/azure-sdk-for-net/tree/master/sdk/eventhub/Azure.Messaging.EventHubs.Processor
[Balance partition load across multiple instances of your application]: https://docs.microsoft.com/azure/event-hubs/event-processor-balance-partition-load
[Dynamically add partitions to an event hub in Azure Event Hubs]: https://docs.microsoft.com/en-us/azure/event-hubs/dynamically-add-partitions
[Effective strategies for Kafka topic partitioning]: https://blog.newrelic.com/engineering/effective-strategies-kafka-topic-partitioning/
[How to choose the number of topics/partitions in a Kafka cluster?]: https://www.confluent.io/blog/how-choose-number-topics-partitions-kafka-cluster/
[Partitions]: https://docs.microsoft.com/azure/event-hubs/event-hubs-scalability#partitions
[Quickstart: Data streaming with Event Hubs using the Kafka protocol]: https://docs.microsoft.com/azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs
[Send events to and receive events from Azure Event Hubs - .NET]: https://docs.microsoft.com/azure/event-hubs/event-hubs-dotnet-standard-getstarted-send
[Shared Access Signatures]: https://docs.microsoft.com/azure/event-hubs/authorize-access-shared-access-signature
[Use Azure Event Hubs from Apache Kafka applications]: https://docs.microsoft.com/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview