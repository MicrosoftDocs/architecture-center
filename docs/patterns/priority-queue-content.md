The priority queue pattern allows a workload to process high-priority tasks more quickly than lower-priority tasks. It uses messages sent to one or more queues This pattern is useful in applications that offer different service level guarantees to individual clients.

## Context and problem

Workloads must manage and process tasks with varying levels of importance and urgency. Some tasks require immediate attention, while others can wait. To efficiently handle tasks based on their priority, workloads need a mechanism to prioritize and execute tasks accordingly.

Typically, workloads process tasks in the order they arrive, using a first-in, first-out (FIFO) queue structure. In a FIFO queue, workload consumers process tasks in the same order they are received. However, this approach does not account for the varying importance of tasks.

## Solution

Priority queues address allow workloads to process tasks based on their priority rather than their arrival order. The application sending a message to the queue assigns a priority to the message, and consumers process the messages by priority. There are two main approaches to this solution. You can use a single queue or multiple queues, one for each message priority.

### Single queue

With a single queue, the sending application assigns a priority to each message, and sends it to the queue. The queue orders messages by priority, ensuring that consumers process higher-priority messages before lower-priority ones.

![Diagram that illustrates a queuing mechanism that supports message prioritization.](./_images/priority-queue-pattern.png)
*Architecture of a single queue and single consumer pool.*

### Multiple queues

Multiple queues allows you to use separate queues for different task priority levels. The sending application assigns a priority to each message and directs it to the appropriate queue, and consumers process the messages. A multiple queue solution uses either a single consumer pool or multiple consumer pools.

#### Multiple consumer pools

With multiple consumer pools, each queue has its own designated consumers. Higher priority queues use more consumers or higher performance tiers to process messages more quickly. Lower priority queues receive less dedicated capacity and consumers process messages more slowly than the high-priority queue.

Use multiple consumer when you need guaranteed low-priority processing, queue isolation, dedicated resource allocation, scalability, and performance fine-tuning.

![Diagram that illustrates the use of separate message queues for each priority.](./_images/priority-queue-separate.png)
*Architecture of multiple queues and multiple consumer pools.*

#### Single consumer pool

With a single consumer pool, all queues share a single pool of consumers. Consumers process messages from the highest priority queue first and only process messages from lower priority queues when there are no high priority messages. As a result, the single consumer pool always processes higher priority messages before lower priority ones. This setup could lead to lower priority messages being continually delayed and potentially never processed.

>[!NOTE]
> The [Competing Consumers pattern](./competing-consumers.yml) is relevant here as it allows you to scale the number of consumer based on demand. Most message queue implementations support multiple consumers. Multiple instances of a consumer application compete to process messages from the same queue. The Competing Consumers pattern helps balance the load and improve processing efficiency.

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

## When to use the priority queue pattern

- *Varying task urgency and importance*: When tasks have different levels of urgency and importance, and you need to ensure that more critical tasks are processed before less critical ones.

- *Service level agreements*: When offering different service level guarantees to individual clients, ensuring that high-priority clients receive better performance and availability.

- *Workload management*: When workloads must manage tasks that require immediate attention while allowing less urgent tasks to wait, facilitating efficient task processing based on priority.

## Workload design

An architect should evaluate how the Priority Queue pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | Separating items based on business priority enables you to focus reliability efforts on the most critical work.<br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:07 Background jobs](/azure/well-architected/reliability/background-jobs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | Separating items based on business priority enables you to focus performance efforts on the most time-sensitive work.<br/><br/> - [PE:09 Critical flows](/azure/well-architected/performance-efficiency/prioritize-critical-flows) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

The PriorityQueue example on [GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/priority-queue) implements the priority queue pattern using Azure Service Bus.

![Diagram that shows how to implement a priority queue by using Service Bus topics and subscriptions.](./_images/priority-queue-service-bus.png)
*Figure 3


The example has an application (`PriorityQueueSender`) that creates messages and assigns a custom property called `Priority` in each message. `Priority` has a value of `High` or `Low`. `PriorityQueueSender` uses a time-triggered Azure function that posts messages to a Service Bus topic every 30 seconds. The function binds to an Service Bus topic named "messages". `IAsyncCollector` is an interface provided by Azure Functions SDK that allows for the asynchronous collection of ServiceBusMessage objects. The `collector` parameter acts as a container that accumulates messages to be sent to the specified Service Bus topic. Within the function, messages are created and added to the collector using its `AddAsync` method.

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

The example uses two Service Bus subscriptions. It uses multiple consumer pools (`PriorityQueueConsumerHigh` and `PriorityQueueConsumerLow`) dedicated to read messages from the Service Bus subscription. `PriorityQueueConsumerHigh` and `PriorityQueueConsumerLow` functions integrate with Azure Service Bus via triggers and bindings. For example, in the `PriorityQueueConsumerHigh`, the `ServiceBusTrigger` configures the function to trigger when a new message is received in the `highPriority` subscription of the messages topic.

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

You can configure how many instances the functions on Azure App Service can scale out to. You can do that by configuring the *Enforce Scale Out Limit* option from the Azure portal. Set a maximum scale-out limit for each function. You typically need to have more instances of the `PriorityQueueConsumerHigh` function than the `PriorityQueueConsumerLow` function. This configuration ensures that high priority messages are read from the queue more quickly than low priority messages.

## Next steps

The following resources might be helpful to you when you implement this pattern:

- [A sample that demonstrates this pattern, on GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/priority-queue).

- [Asynchronous messaging primer](/previous-versions/msp-n-p/dn589781(v=pandp.10)). A consumer service that processes a request might need to send a reply to the instance of the application that posted the request. This article provides information about the strategies that you can use to implement request/response messaging.

- [Autoscaling guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)). You can sometimes scale the size of the pool of consumer processes that are handling a queue based on the length of the queue. This strategy can help you improve performance, especially for pools that handle high priority messages.

## Related resources

The following patterns might be helpful to you when you implement this pattern:

- [Competing Consumers pattern](./competing-consumers.yml). To increase the throughput of the queues, you can implement multiple consumers that listen on the same queue and process tasks in parallel. These consumers compete for messages, but only one should be able to process each message. This article provides more information on the benefits and disadvantages of implementing this approach.

- [Throttling pattern](./throttling.yml). You can implement throttling by using queues. You can use priority messaging to ensure that requests from critical applications, or applications that are run by high-value customers, are given priority over requests from less important applications.
