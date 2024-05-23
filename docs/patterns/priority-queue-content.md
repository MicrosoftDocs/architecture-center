Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. This pattern is useful in applications that offer different service level guarantees to individual clients.

## Context and problem priority queues solve

Workloads must manage and process tasks with varying levels of importance and urgency. Some tasks require immediate attention, while others can wait. To efficiently handle tasks based on their priority, workloads need a mechanism to prioritize and execute tasks accordingly.

Typically, workloads process tasks in the order they arrive, using a first-in, first-out (FIFO) queue structure. In a FIFO queue, workload consumers process tasks in the same order they are received. However, this approach does not account for the varying importance of tasks.

## Solution

 Priority queues address allow workloads to process tasks based on their priority rather than their arrival order. The application sending a message to the queue assigns a priority to the message, and consumers process the messages by priority.

There are two main approaches to this solution. You can use a single-queue solution with one priority queue. Or you can use a multiple-queue solution with dedicated queues for each message priority.

| Condition                                                         | Single Queue Solution | Multiple Queue Solution |
|-------------------------------------------------------------------|------------------------|-------------------------|
| Built-in priority queue functionality <br>&<br>A single queue meets messaging needs | X                    |                      |
| No built-in priority queue functionality | | X|
| Messaging needs exceeds single queue limits | | X|
| Need to fine-tune consumer performance| | X |
| Need message isolation | | X |

### Single-queue solution

In a single-queue solution, the workload uses one queue. The sending application assigns a priority to each message and sends it to the queue. The queue orders messages by priority, ensuring that consumers process higher-priority messages before lower-priority ones (*see figure 1*).

![Diagram that illustrates a queuing mechanism that supports message prioritization.](./_images/priority-queue-pattern.png)
*Figure 1. Single queue solution for the priority queue pattern*

>[!NOTE]
> Most message queue implementations support multiple consumers. (See the [Competing Consumers pattern](./competing-consumers.yml).) The number of consumer processes can be scaled up and down based on demand.

Use a single-queue solution if ***all*** of the following apply:

- *Native priority queue support*: Your chosen queue service natively supports message prioritization within a single queue
- *Capacity needs met.* A single queue can support the capacity needs of your workload without exceeding the volume and scaling limits of the queue service.

### Multiple-queue solution

A multiple-queue solution involves using separate queues for different task priority levels. The sending application assigns a priority to each message and directs it to the appropriate queue, and consumers process the messages.

Use multiple queues if ***any*** of the following apply:

- *No native priority queue capability*: Your queue service does not natively support message prioritization within a single queue.
- *Message volume exceeds single queue capacity*: A single queue cannot handle the capacity needs of your workload without exceeding its volume and scaling limits.
- *Need to fine-tune consumer performance*: You need to allocate resources differently based on task priority, such as dedicating more resources to higher-priority tasks.
- *Need message isolation*: You need to ensure high-priority tasks are isolated from lower-priority ones, minimizing the risk of delays.

A multiple queue solution uses either multiple consumer pools or a single consumer pool.

**Multiple consumer pools**: With multiple consumer pools, each queue has its own designated consumers. Higher priority queues use more consumers or higher performance tiers to process messages more quickly. Lower priority queues receive less dedicated capacity and consumers process messages more slowly than the high-priority queue.

Use multiple consumer when you need guaranteed low-priority processing, queue isolation, dedicated resource allocation, scalability, and performance fine-tuning.

![Diagram that illustrates the use of separate message queues for each priority.](./_images/priority-queue-separate.png)

**Single consumer pool**: With a single consumer pool, all queues share a single pool of consumers. Consumers process messages from the highest priority queue first and only process messages from lower priority queues when there are no high priority messages. As a result, the single consumer pool always processes higher priority messages before lower priority ones. This setup could lead to lower priority messages being continually delayed and potentially never processed.

Use a single consumer pool if you need:

- Strict prioritization: High-priority messages must always be processed first.
- Resource efficiency: Shared resources among queues optimize overall utilization and reduce idle time.
- Variable load handling: Workload varies, allowing lower priority tasks to be processed when high-priority queues are idle.
- Simple management: Simplified setup with one consumer pool for all queues.

Use multiple consumer pools if you need:

- Guaranteed low-priority processing: Ensure low-priority messages are processed, avoiding indefinite delays.
- Queue isolation: Strict isolation between high and low-priority tasks to prevent interference.
- Dedicated resource allocation: Allocate more resources to high-priority queues for faster processing.
- Scalability and capacity management: Scale independently based on the demand of each priority queue.
- Performance fine-tuning: Provide specialized handling for different priority levels.

## Considerations for the priority queue pattern

Consider the following recommendations when you decide how to implement the priority queue pattern:

### General recommendations

- *Define priorities clearly.* Establish distinct and clear priority levels relevant to your solution. For example, a high-priority message might require processing within 10 seconds. Identify the requirements for handling high-priority items and allocate the necessary resources accordingly.

- *Adjust consumer pools dynamically.* Scale the size of consumer pools based on the queue length they are servicing.

- *Prioritize service levels.* Implement priority queues to meet business needs that require prioritized availability or performance. Different customer groups can receive varying levels of service, ensuring high-priority customers experience better performance and availability.

- *Determine priorities logically.* Use logical criteria to set message priorities. For instance, designate messages as "paying customer" or "non-paying customer" and allocate more resources to processing messages from paying customers.

- *Ensure low-priority processing.* In queues that support message prioritization, dynamically increase the priority of aged messages if the system allows it, ensuring they eventually get processed.

- *Consider queue costs.* Be aware of the financial and processing costs associated with checking queues. Some commercial systems charge fees for posting, retrieving, and querying messages, which can increase with the number of queues.

### Single consumer pool recommendations

- *Implement preemption and suspension.* Decide if all high-priority items must be processed before any lower-priority items. In a single pool of consumers, provide a mechanism to preempt and suspend consumers handling low-priority messages if a high-priority message arrives.

- *Apply consumer algorithms.* Use an algorithm that ensures high-priority queues are always serviced before lower-priority ones when using a single pool of consumers for multiple queues.

- *Optimize costs.* Optimize operational costs by scaling back the number of consumers when using the single-queue approach. High-priority messages will still be processed first, though possibly more slowly, while lower-priority messages might face longer delays.

### Multiple queues recommendations

- *Monitor processing speeds.* Continuously monitor the processing speed of high and low-priority queues to ensure that messages are processed at the expected rates.

- *Minimize costs.*  Process critical tasks immediately available consumers while less critical background tasks can be scheduled during less busy times.

### Old content

**Benefits of priority queues**: Using a priority-queuing mechanism can provide the following advantages:

- It allows applications to meet business requirements that require the prioritization of availability or performance, such as offering different levels of service to different groups of customers.

- It can help to minimize operational costs. If you use the single-queue approach, you can scale back the number of consumers if you need to. High priority messages are still processed first (although possibly more slowly), and lower priority messages might be delayed for longer. If you implement the multiple message queue approach with separate pools of consumers for each queue, you can reduce the pool of consumers for lower priority queues. You can even suspend processing for some very low priority queues by stopping all the consumers that listen for messages on those queues.

- The multiple message queue approach can help maximize application performance and scalability by partitioning messages based on processing requirements. For example, you can prioritize critical tasks so that they're handled by receivers that run immediately, and less important background tasks can be handled by receivers that are scheduled to run at times that are less busy.

**Other misc**

- Define the priorities in the context of the solution. For example, a *high priority* message could be defined as a  message that should be processed within 10 seconds. Identify the requirements for handling high priority items, and the resources that need to be allocated to meet your criteria.

- Decide whether all high priority items must be processed before any lower priority items. If the messages are processed by a single pool of consumers, you have to provide a mechanism that can preempt and suspend a task that's handling a low priority message if a higher priority message enters the queue.

- In the multiple queue approach, when you use a single pool of consumer processes that listen on all queues rather than a dedicated consumer pool for each queue, the consumer must apply an algorithm that ensures it always services messages from higher priority queues before messages from lower priority queues.

- Monitor the processing speed on high and low priority queues to ensure that messages in those queues are processed at the expected rates.

- If you need to guarantee that low priority messages will be processed, implement the multiple message queue approach with multiple pools of consumers. Alternatively, in a queue that supports message prioritization, you can dynamically increase the priority of a queued message as it ages. However, this approach depends on the message queue providing this feature.

- The strategy of using separate queues based on message priority is recommended for systems that have a few well-defined priorities.

- The system can logically determine message priorities. For example, rather than having explicit high and low priority messages, you could designate messages as "paying customer" or "non-paying customer." Your system could then allocate more resources to processing messages from paying customers.

- There might be a financial and processing cost associated with checking a queue for a message. For instance, some commercial messaging systems charge a small fee each time a message is posted or retrieved, and each time a queue is queried for messages. This cost increases when you check multiple queues.

- You can dynamically adjust the size of a pool of consumers based on the length of the queue that the pool is servicing. For more information, see [Autoscaling guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)).

## When to use the priority queue pattern

This pattern is useful in scenarios where:

- The system must handle multiple tasks that have different priorities.

- Different users or tenants should be served with different priorities.

## Workload design

An architect should evaluate how the Priority Queue pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | Separating items based on business priority enables you to focus reliability efforts on the most critical work.<br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:07 Background jobs](/azure/well-architected/reliability/background-jobs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | Separating items based on business priority enables you to focus performance efforts on the most time-sensitive work.<br/><br/> - [PE:09 Critical flows](/azure/well-architected/performance-efficiency/prioritize-critical-flows) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

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
