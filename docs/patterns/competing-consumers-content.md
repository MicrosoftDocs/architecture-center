Enable multiple concurrent consumers to process messages received on the same messaging channel. With multiple concurrent consumers, a system can process multiple messages concurrently to optimize throughput, to improve scalability and availability, and to balance the workload.

## Context and problem

An application running in the cloud is expected to handle a large number of requests. Rather than process each request synchronously, a common technique is for the application to pass them through a messaging system to another service (a consumer service) that handles them asynchronously. This strategy helps to ensure that the business logic in the application isn't blocked, while the requests are being processed.

The number of requests can vary significantly over time for many reasons. A sudden increase in user activity or aggregated requests coming from multiple tenants can cause an unpredictable workload. At peak hours, a system might need to process many hundreds of requests per second, while at other times the number could be very small. Additionally, the nature of the work performed to handle these requests might be highly variable. By using a single instance of the consumer service, you can cause that instance to become flooded with requests. Or, the messaging system might be overloaded by an influx of messages that come from the application. To handle this fluctuating workload, the system can run multiple instances of the consumer service. However, these consumers must be coordinated to ensure that each message is only delivered to a single consumer. The workload also needs to be load balanced across consumers to prevent an instance from becoming a bottleneck.

## Solution

Use a message queue to implement the communication channel between the application and the instances of the consumer service. The application posts requests in the form of messages to the queue, and the consumer service instances receive messages from the queue and process them. This approach enables the same pool of consumer service instances to handle messages from any instance of the application. The figure illustrates using a message queue to distribute work to instances of a service.

![Using a message queue to distribute work to instances of a service](./_images/competing-consumers-diagram.png)

This solution has the following benefits:

- It provides a load-leveled system that can handle wide variations in the volume of requests sent by application instances. The queue acts as a buffer between the application instances and the consumer service instances. This buffer can help minimize the impact on availability and responsiveness, for both the application and the service instances. For more information, see [Queue-based Load Leveling pattern](./queue-based-load-leveling.yml). Handling a message that requires some long-running processing doesn't prevent other messages from being handled concurrently by other instances of the consumer service.

- It improves reliability. If a producer communicates directly with a consumer instead of using this pattern, but doesn't monitor the consumer, there's a high probability that messages could be lost or fail to be processed if the consumer fails. In this pattern, messages aren't sent to a specific service instance. A failed service instance won't block a producer, and messages can be processed by any working service instance.

- It doesn't require complex coordination between the consumers, or between the producer and the consumer instances. The message queue ensures that each message is delivered at least once.

- It's scalable. When you apply [auto-scaling](/azure/architecture/best-practices/auto-scaling), the system can dynamically increase or decrease the number of instances of the consumer service as the volume of messages fluctuates.

- It can improve resiliency if the message queue provides transactional read operations. If a consumer service instance reads and processes the message as part of a transactional operation, and the consumer service instance fails, this pattern can ensure that the message will be returned to the queue to be picked up and handled by another instance of the consumer service. In order to mitigate the risk of a message continuously failing, we recommend you make use of [dead-letter queues](/azure/service-bus-messaging/service-bus-dead-letter-queues).

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

- **Message ordering**. The order in which consumer service instances receive messages isn't guaranteed, and doesn't necessarily reflect the order in which the messages were created. Design the system to ensure that message processing is idempotent because this will help to eliminate any dependency on the order in which messages are handled. For more information, see [Idempotency Patterns](https://blog.jonathanoliver.com/idempotency-patterns/) on Jonathon Oliver's blog.

    > Microsoft Azure Service Bus Queues can implement guaranteed first-in-first-out ordering of messages by using message sessions. For more information, see [Messaging Patterns Using Sessions](/archive/msdn-magazine/2012/december/azure-insider-microsoft-azure-service-bus-messaging-patterns-using-sessions).

- **Designing services for resiliency**. If the system is designed to detect and restart failed service instances, it might be necessary to implement the processing performed by the service instances as idempotent operations to minimize the effects of a single message being retrieved and processed more than once.

- **Detecting poison messages**. A malformed message, or a task that requires access to resources that aren't available, can cause a service instance to fail. The system should prevent such messages being returned to the queue, and instead capture and store the details of these messages elsewhere so that they can be analyzed if necessary.

- **Handling results**. The service instance handling a message is fully decoupled from the application logic that generates the message, and they might not be able to communicate directly. If the service instance generates results that must be passed back to the application logic, this information must be stored in a location that's accessible to both. In order to prevent the application logic from retrieving incomplete data the system must indicate when processing is complete.

     > If you're using Azure, a worker process can pass results back to the application logic by using a dedicated message reply queue. The application logic must be able to correlate these results with the original message. This scenario is described in more detail in the [Asynchronous Messaging Primer](/previous-versions/msp-n-p/dn589781(v=pandp.10)).

- **Scaling the messaging system**. In a large-scale solution, a single message queue could be overwhelmed by the number of messages and become a bottleneck in the system. In this situation, consider partitioning the messaging system to send messages from specific producers to a particular queue, or use load balancing to distribute messages across multiple message queues.

- **Ensuring reliability of the messaging system**. A reliable messaging system is needed to guarantee that after the application enqueues a message it won't be lost. This system is essential for ensuring that all messages are delivered at least once.

## When to use this pattern

Use this pattern when:

- The workload for an application is divided into tasks that can run asynchronously.
- Tasks are independent and can run in parallel.
- The volume of work is highly variable, requiring a scalable solution.
- The solution must provide high availability, and must be resilient if the processing for a task fails.

This pattern might not be useful when:

- It's not easy to separate the application workload into discrete tasks, or there's a high degree of dependence between tasks.
- Tasks must be performed synchronously, and the application logic must wait for a task to complete before continuing.
- Tasks must be performed in a specific sequence.

> Some messaging systems support sessions that enable a producer to group messages together and ensure that they're all handled by the same consumer. This mechanism can be used with prioritized messages (if they are supported) to implement a form of message ordering that delivers messages in sequence from a producer to a single consumer.

## Example

Azure provides Service Bus Queues and Azure Function queue triggers that, when combined, are a direct implementation of this cloud design pattern. Azure Functions integrate with Azure Service Bus via triggers and bindings. Integrating with Service Bus allows you to build functions that consume queue messages sent by publishers. The publishing application(s) will post messages to a queue, and consumers, implemented as Azure Functions, can retrieve messages from this queue and handle them.

For resiliency, a Service Bus queue enables a consumer to use `PeekLock` mode when it retrieves a message from the queue; this mode doesn't actually remove the message, but simply hides it from other consumers. The Azure Functions runtime receives a message in PeekLock mode, if the function finishes successfully it calls Complete on the message, or it may call Abandon if the function fails, and the message will become visible again, allowing another consumer to retrieve it. If the function runs for a period longer than the PeekLock timeout, the lock is automatically renewed as long as the function is running.

Azure Functions can scale out/in based on the depth of the queue, all acting as competing consumers of the queue. If multiple instances of the functions are created they all compete by independently pulling and processing the messages.

For detailed information on using Azure Service Bus queues, see [Service Bus queues, topics, and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions).

For information on Queue triggered Azure Functions, see [Azure Service Bus trigger for Azure Functions](/azure/azure-functions/functions-bindings-service-bus-trigger).

The following code shows how you can create a new message and send it to a Service Bus Queue by using a `ServiceBusClient` instance.

```csharp
private string serviceBusConnectionString = ...;
...

  public async Task SendMessagesAsync(CancellationToken  ct)
  {
   try
   {
    var msgNumber = 0;

    var serviceBusClient = new ServiceBusClient(serviceBusConnectionString);

    // create the sender
    ServiceBusSender sender = serviceBusClient.CreateSender("myqueue");

    while (!ct.IsCancellationRequested)
    {
     // Create a new message to send to the queue
     string messageBody = $"Message {msgNumber}";
     var message = new ServiceBusMessage(messageBody);

     // Write the body of the message to the console
     this._logger.LogInformation($"Sending message: {messageBody}");

     // Send the message to the queue
     await sender.SendMessageAsync(message);

     this._logger.LogInformation("Message successfully sent.");
     msgNumber++;
    }
   }
   catch (Exception exception)
   {
    this._logger.LogException(exception.Message);
   }
  }
```

The following code example shows a consumer, written as a C# Azure Function, that reads message metadata and logs a Service Bus Queue message. Note how the `ServiceBusTrigger` attribute is used to bind it to a Service Bus Queue.

```csharp
[FunctionName("ProcessQueueMessage")]
public static void Run(
    [ServiceBusTrigger("myqueue", Connection = "ServiceBusConnectionString")]
    string myQueueItem,
    Int32 deliveryCount,
    DateTime enqueuedTimeUtc,
    string messageId,
    ILogger log)
{
    log.LogInformation($"C# ServiceBus queue trigger function consumed message: {myQueueItem}");
    log.LogInformation($"EnqueuedTimeUtc={enqueuedTimeUtc}");
    log.LogInformation($"DeliveryCount={deliveryCount}");
    log.LogInformation($"MessageId={messageId}");
}
```

## Next steps

- [Asynchronous Messaging Primer](/previous-versions/msp-n-p/dn589781(v=pandp.10)). Message queues are an asynchronous communications mechanism. If a consumer service needs to send a reply to an application, it might be necessary to implement some form of response messaging. The Asynchronous Messaging Primer provides information on how to implement request/reply messaging using message queues.

- [Autoscaling Guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)). It might be possible to start and stop instances of a consumer service since the length of the queue applications post messages on varies. Autoscaling can help to maintain throughput during times of peak processing.

## Related resources

The following patterns and guidance might be relevant when implementing this pattern:

- [Compute Resource Consolidation pattern](./compute-resource-consolidation.yml). It might be possible to consolidate multiple instances of a consumer service into a single process to reduce costs and management overhead. The Compute Resource Consolidation pattern describes the benefits and tradeoffs of following this approach.

- [Queue-based Load Leveling pattern](./queue-based-load-leveling.yml). Introducing a message queue can add resiliency to the system, enabling service instances to handle widely varying volumes of requests from application instances. The message queue acts as a buffer, which levels the load. The Queue-based Load Leveling pattern describes this scenario in more detail.
