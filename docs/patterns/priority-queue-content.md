Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. This pattern is useful in applications that offer different service level guarantees to individual clients.

## Context and problem

Applications can delegate specific tasks to other services, for example, to perform background processing or to integrate with other applications or services. In the cloud, a message queue is typically used to delegate tasks to background processing. In many cases, the order requests are received in by a service isn't important. In some cases, though, it's necessary to prioritize specific requests. These requests should be processed earlier than lower priority requests that were sent previously by the application.

## Solution

A queue is usually a first-in, first-out (FIFO) structure, and consumers typically receive messages in the same order that they were posted to the queue. However, some message queues support priority messaging. The application posting a message can assign a priority and the messages in the queue are automatically reordered so that those with a higher priority will be received before those with a lower priority. The figure illustrates a queue with priority messaging.

![Figure 1 - Using a queuing mechanism that supports message prioritization](./_images/priority-queue-pattern.png)

> Most message queue implementations support multiple consumers (following the [Competing Consumers pattern](./competing-consumers.yml)), and the number of consumer processes can be scaled up or down depending on demand.

In systems that don't support priority-based message queues, an alternative solution is to maintain a separate queue for each priority. The application is responsible for posting messages to the appropriate queue. Each queue can have a separate pool of consumers. Higher priority queues can have a larger pool of consumers running on faster hardware than lower priority queues. The next figure illustrates using separate message queues for each priority.

![Figure 2 - Using separate message queues for each priority](./_images/priority-queue-separate.png)

A variation on this strategy is to have a single pool of consumers that check for messages on high priority queues first, and only then start to fetch messages from lower priority queues. There are some semantic differences between a solution that uses a single pool of consumer processes (either with a single queue that supports messages with different priorities or with multiple queues that each handle messages of a single priority), and a solution that uses multiple queues with a separate pool for each queue.

In the single pool approach, higher priority messages are always received and processed before lower priority messages. In theory, messages that have a very low priority could be continually superseded and might never be processed. In the multiple pool approach, lower priority messages will always be processed, just not as quickly as those of a higher priority (depending on the relative size of the pools and the resources that they have available).

Using a priority-queuing mechanism can provide the following advantages:

- It allows applications to meet business requirements that require prioritization of availability or performance, such as offering different levels of service to specific groups of customers.

- It can help to minimize operational costs. In the single queue approach, you can scale back the number of consumers if necessary. High priority messages will still be processed first (although possibly more slowly), and lower priority messages might be delayed for longer. If you've implemented the multiple message queue approach with separate pools of consumers for each queue, you can reduce the pool of consumers for lower priority queues, or even suspend processing for some very low priority queues by stopping all the consumers that listen for messages on those queues.

- The multiple message queue approach can help maximize application performance and scalability by partitioning messages based on processing requirements. For example, vital tasks can be prioritized to be handled by receivers that run immediately while less important background tasks can be handled by receivers that are scheduled to run at less busy periods.

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

Define the priorities in the context of the solution. For example, high priority could mean that messages should be processed within ten seconds. Identify the requirements for handling high priority items, and the other resources that should be allocated to meet these criteria.

Decide if all high priority items must be processed before any lower priority items. If the messages are being processed by a single pool of consumers, you have to provide a mechanism that can preempt and suspend a task that's handling a low priority message if a higher priority message becomes available.

In the multiple queue approach, when using a single pool of consumer processes that listen on all queues rather than a dedicated consumer pool for each queue, the consumer must apply an algorithm that ensures it always services messages from higher priority queues before those from lower priority queues.

Monitor the processing speed on high and low priority queues to ensure that messages in these queues are processed at the expected rates.

If you need to guarantee that low priority messages will be processed, it's necessary to implement the multiple message queue approach with multiple pools of consumers. Alternatively, in a queue that supports message prioritization, it's possible to dynamically increase the priority of a queued message as it ages. However, this approach depends on the message queue providing this feature.

Using a separate queue for each message priority works best for systems that have a few well-defined priorities.

Message priorities can be determined logically by the system. For example, rather than having explicit high and low priority messages, they could be designated as "fee-paying customer," or "non-fee paying customer." Depending on your business model, your system can allocate more resources to processing messages from fee-paying customers than non-fee paying ones.

There might be a financial and processing cost associated with checking a queue for a message (some commercial messaging systems charge a small fee each time a message is posted or retrieved, and each time a queue is queried for messages). This cost increases when checking multiple queues.

It's possible to dynamically adjust the size of a pool of consumers based on the length of the queue that the pool is servicing. For more information, see the [Autoscaling Guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)).

## When to use this pattern

This pattern is useful in scenarios where:

- The system must handle multiple tasks that have different priorities.

- Different users or tenants should be served with different priority.

## Example

Microsoft Azure doesn't provide a queuing mechanism that natively supports automatic prioritization of messages through sorting. However, it does provide Azure Service Bus topics and subscriptions that support a queuing mechanism that provides message filtering, together with a wide range of flexible capabilities that make it ideal for use in most priority queue implementations.

An Azure solution can implement a Service Bus topic an application can post messages to, in the same way as a queue. Messages can contain metadata in the form of application-defined custom properties. Service Bus subscriptions can be associated with the topic, and these subscriptions can filter messages based on their properties. When an application sends a message to a topic, the message is directed to the appropriate subscription where it can be read by a consumer. Consumer processes can retrieve messages from a subscription using the same semantics as a message queue (a subscription is a logical queue). The following figure illustrates implementing a priority queue with Azure Service Bus topics and subscriptions.

![Figure 3 - Implementing a priority queue with Azure Service Bus topics and subscriptions](./_images/priority-queue-service-bus.png)

In the figure above, the application creates several messages and assigns a custom property called `Priority` in each message with a value, either `High` or `Low`. The application posts these messages to a topic. The topic has two associated subscriptions that both filter messages by examining the `Priority` property. One subscription accepts messages where the `Priority` property is set to `High`, and the other accepts messages where the `Priority` property is set to `Low`. A pool of consumers reads messages from each subscription. The high priority subscription has a larger pool, and these consumers might be running on more powerful computers with more resources available than the consumers in the low priority pool.

There's nothing special about the designation of high and low-priority messages in this example. They're simply labels specified as properties in each message, and are used to direct messages to a specific subscription. If additional priorities are required, it's relatively easy to create further subscriptions and pools of consumer processes to handle these priorities.

The PriorityQueue solution available on [GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/priority-queue) contains an implementation of this approach. This solution contains Azure Function projects named `PriorityQueueConsumerHigh` and `PriorityQueueConsumerLow`. These Azure Functions integrate with Azure Service Bus via triggers and bindings, they connect to different subscriptions defined in the ServiceBusTrigger and react to the incoming messages.

```csharp
public static class PriorityQueueConsumerHighFn
{
    [FunctionName("HighPriorityQueueConsumerFunction")]
    public static void Run(
      [ServiceBusTrigger("messages", "highPriority", Connection = "ServiceBusConnection")]string highPriorityMessage,
      ILogger log)
    {
        log.LogInformation($"C# ServiceBus topic trigger function processed message: {highPriorityMessage}");
    }
}
```

An administrator can configure how many instances the functions on the app service consumption can scale out to by configuring the Dynamic Scale out hosting option from the Azure portal; enforcing a maximum scale-out limit for each function. Typically, there'll be more instances of the `PriorityQueueConsumerHigh` function than the `PriorityQueueConsumerLow` function.

Another project named `PriorityQueueSender` contains a time triggered Azure Function configured to run every 30 seconds; this Azure Function integrates with Azure Service Bus via an output binding and sends batches of low and high priority messages to an `IAsyncCollector`; when the function posts messages to the topic associated with the subscriptions used by the `PriorityQueueConsumerHigh` and `PriorityQueueConsumerLow` functions, it specifies the priority by using the `Priority` custom property, as shown in the following code:

```csharp
public static class PriorityQueueSenderFn
{
    [FunctionName("PriorityQueueSenderFunction")]
    public static async Task Run(
        [TimerTrigger("0,30 * * * * *")] TimerInfo myTimer,
        [ServiceBus("messages", Connection = "ServiceBusConnection")] IAsyncCollector<ServiceBusMessage> collector)
    {
        for (int i = 0; i < 10; i++)
        {
            var messageId = Guid.NewGuid().ToString();
            var lpMessage = new ServiceBusMessage() { MessageId = messageId };
            lpMessage.ApplicationProperties["Priority"] = Priority.Low;
            lpMessage.Body = BinaryData.FromString($"Low priority message with Id: {messageId}");
            await collector.AddAsync(lpMessage);

            messageId = Guid.NewGuid().ToString();
            var hpMessage = new ServiceBusMessage() { MessageId = messageId };
            hpMessage.ApplicationProperties["Priority"] = Priority.High;
            hpMessage.Body = BinaryData.FromString($"High priority message with Id: {messageId}");
            await collector.AddAsync(hpMessage);
        }
    }
}
```

## Next steps

The following guidance might also be relevant when implementing this pattern:

- A sample that demonstrates this pattern is available on [GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/priority-queue).

- [Asynchronous Messaging Primer](/previous-versions/msp-n-p/dn589781(v=pandp.10)). A consumer service that processes a request might need to send a reply to the instance of the application that posted the request. Provides information on the strategies that you can use to implement request/response messaging.

- [Autoscaling Guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)). It might be possible to scale the size of the pool of consumer processes handling a queue depending on the length of the queue. This strategy can help to improve performance, especially for pools handling high priority messages.

## Related patterns and guidance

The following patterns might also be relevant when implementing this pattern:

- [Competing Consumers pattern](./competing-consumers.yml). To increase the throughput of the queues, it's possible to have multiple consumers that listen on the same queue, and process the tasks in parallel. These consumers will compete for messages, but only one should be able to process each message. Provides more information on the benefits and tradeoffs of implementing this approach.

- [Throttling pattern](./throttling.yml). You can implement throttling by using queues. Priority messaging can be used to ensure that requests from critical applications, or applications being run by high-value customers, are given priority over requests from less important applications.
