Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. This pattern is useful in applications that offer different service level guarantees to individual clients.

## Context and problem

Applications can delegate specific tasks to other services, for example, to perform background processing or to integrate with other applications or services. In the cloud, a message queue is typically used to delegate tasks to background processing. In many cases, the order in which requests are received by a service isn't important. In some cases, though, it's necessary to prioritize specific requests. These requests should be processed earlier than lower priority requests that were previously sent by the application.

## Solution

A queue usually is a first-in, first-out (FIFO) structure, and consumers typically receive messages in the same order that they're posted to the queue. However, some message queues support priority messaging. The application that's posting a message can assign a priority. The messages in the queue are automatically reordered so that those that have a higher priority are received before those that have a lower priority. This diagram illustrates the process:

![Diagram that illustrates a queuing mechanism that supports message prioritization.](./_images/priority-queue-pattern.png)

>[!NOTE] 
> Most message queue implementations support multiple consumers. (See the [Competing Consumers pattern](./competing-consumers.yml).) The number of consumer processes can be scaled up and down based on demand.

In systems that don't support priority-based message queues, an alternative solution is to maintain a separate queue for each priority. The application is responsible for posting messages to the appropriate queue. Each queue can have a separate pool of consumers. Higher priority queues can have a larger pool of consumers that run on faster hardware than lower priority queues. This diagram illustrates the use of separate message queues for each priority:

![Diagram that illustrates the use of separate message queues for each priority.](./_images/priority-queue-separate.png)

A variation on this strategy is to implement a single pool of consumers that check for messages on high priority queues first, and only after that start to fetch messages from lower priority queues. There are some semantic differences between a solution that uses a single pool of consumer processes (either with a single queue that supports messages that have different priorities or with multiple queues that each handle messages of a single priority), and a solution that uses multiple queues with a separate pool for each queue.

In the single-pool approach, higher priority messages are always received and processed before lower priority messages. In theory, low priority messages could be continually superseded and might never be processed. In the multiple pool approach, lower priority messages are always processed, but not as quickly as higher priority messages (depending on the relative size of the pools and the resources that are available for them).

Using a priority-queuing mechanism can provide the following advantages:

- It allows applications to meet business requirements that require the prioritization of availability or performance, such as offering different levels of service to different groups of customers.

- It can help to minimize operational costs. If you use the single-queue approach, you can scale back the number of consumers if you need to. High priority messages are still processed first (although possibly more slowly), and lower priority messages might be delayed for longer. If you implement the multiple message queue approach with separate pools of consumers for each queue, you can reduce the pool of consumers for lower priority queues. You can even suspend processing for some very low priority queues by stopping all the consumers that listen for messages on those queues.

- The multiple message queue approach can help maximize application performance and scalability by partitioning messages based on processing requirements. For example, you can prioritize critical tasks so that they're handled by receivers that run immediately, and less important background tasks can be handled by receivers that are scheduled to run at times that are less busy.

## Considerations

Consider the following points when you decide how to implement this pattern:

- Define the priorities in the context of the solution. For example, a *high priority* message could be defined as a  message that should be processed within 10 seconds. Identify the requirements for handling high priority items, and the resources that need to be allocated to meet your criteria.

- Decide whether all high priority items must be processed before any lower priority items. If the messages are processed by a single pool of consumers, you have to provide a mechanism that can preempt and suspend a task that's handling a low priority message if a higher priority message enters the queue.

- In the multiple queue approach, when you use a single pool of consumer processes that listen on all queues rather than a dedicated consumer pool for each queue, the consumer must apply an algorithm that ensures it always services messages from higher priority queues before messages from lower priority queues.

- Monitor the processing speed on high and low priority queues to ensure that messages in those queues are processed at the expected rates.

- If you need to guarantee that low priority messages will be processed, implement the multiple message queue approach with multiple pools of consumers. Alternatively, in a queue that supports message prioritization, you can dynamically increase the priority of a queued message as it ages. However, this approach depends on the message queue providing this feature.

- The strategy of using separate queues based on message priority is recommended for systems that have a few well-defined priorities.

- The system can logically determine message priorities. For example, rather than having explicit high and low priority messages, you could designate messages as "paying customer" or "non-paying customer." Your system could then allocate more resources to processing messages from paying customers.

- There might be a financial and processing cost associated with checking a queue for a message. For instance, some commercial messaging systems charge a small fee each time a message is posted or retrieved, and each time a queue is queried for messages. This cost increases when you check multiple queues.

- You can dynamically adjust the size of a pool of consumers based on the length of the queue that the pool is servicing. For more information, see [Autoscaling guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)).

## When to use this pattern

This pattern is useful in scenarios where:

- The system must handle multiple tasks that have different priorities.

- Different users or tenants should be served with different priorities.

## Example

Azure doesn't provide a queuing mechanism that natively supports automatic prioritization of messages via sorting. However, it does provide Azure Service Bus topics, Service Bus subscriptions that support a queuing mechanism that provides message filtering, and a range of flexible capabilities that make Azure ideal for most priority-queue implementations.

An Azure solution can implement a Service Bus topic that an application can post messages to, just as it would post them to a queue. Messages can contain metadata in the form of application-defined custom properties. You can associate Service Bus subscriptions with the topic, and the subscriptions can filter messages based on their properties. When an application sends a message to a topic, the message is directed to the appropriate subscription, where a consumer can read it. Consumer processes can retrieve messages from a subscription by using the same semantics that they would use with a message queue. (A subscription is a logical queue.) This diagram shows how to implement a priority queue by using Service Bus topics and subscriptions:

![Diagram that shows how to implement a priority queue by using Service Bus topics and subscriptions.](./_images/priority-queue-service-bus.png)

In the preceding diagram, the application creates several messages and assigns a custom property called `Priority` in each message. `Priority` has a value of `High` or `Low`. The application posts these messages to a topic. The topic has two associated subscriptions that filter messages based on the `Priority` property. One subscription accepts messages with the `Priority` property set to `High`. The other accepts messages with the `Priority` property set to `Low`. A pool of consumers reads messages from each subscription. The high priority subscription has a larger pool, and these consumers might be running on more powerful computers that have more available resources than the computers for the low priority pool.

There's nothing special about the designation of high and low priority messages in this example. They're simply labels that are specified as properties in each message. They're used to direct messages to a specific subscription. If additional priorities are needed, it's relatively easy to create more subscriptions and pools of consumer processes to handle those priorities.

The PriorityQueue solution on [GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/priority-queue) is based on this approach. This solution contains Azure Function projects named `PriorityQueueConsumerHigh` and `PriorityQueueConsumerLow`. These Azure Function projects integrate with Service Bus via triggers and bindings. They connect to different subscriptions that are defined in `ServiceBusTrigger` and react to the incoming messages.

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

As an administrator, you can configure how many instances the functions on Azure App Service can scale out to. You can do that by configuring the **Enforce Scale Out Limit** option from the Azure portal, setting a maximum scale-out limit for each function. You typically need to have more instances of the `PriorityQueueConsumerHigh` function than the `PriorityQueueConsumerLow` function. This configuration ensures that high priority messages are read from the queue more quickly than low priority messages.

Another project, `PriorityQueueSender`, contains a time-triggered Azure function that's configured to run every 30 seconds. This function integrates with Service Bus via an output binding and sends batches of low and high priority messages to an `IAsyncCollector` object. When the function posts messages to the topic that's associated with the subscriptions used by the `PriorityQueueConsumerHigh` and `PriorityQueueConsumerLow` functions, it specifies the priority by using the `Priority` custom property, as shown here:

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

The following resources might be helpful to you when you implement this pattern:

- [A sample that demonstrates this pattern, on GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/priority-queue).

- [Asynchronous messaging primer](/previous-versions/msp-n-p/dn589781(v=pandp.10)). A consumer service that processes a request might need to send a reply to the instance of the application that posted the request. This article provides information about the strategies that you can use to implement request/response messaging.

- [Autoscaling guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)). You can sometimes scale the size of the pool of consumer processes that are handling a queue based on the length of the queue. This strategy can help you improve performance, especially for pools that handle high priority messages.

## Related resources

The following patterns might be helpful to you when you implement this pattern:

- [Competing Consumers pattern](./competing-consumers.yml). To increase the throughput of the queues, you can implement multiple consumers that listen on the same queue and process tasks in parallel. These consumers compete for messages, but only one should be able to process each message. This article provides more information on the benefits and disadvantages of implementing this approach.

- [Throttling pattern](./throttling.yml). You can implement throttling by using queues. You can use priority messaging to ensure that requests from critical applications, or applications that are run by high-value customers, are given priority over requests from less important applications.
