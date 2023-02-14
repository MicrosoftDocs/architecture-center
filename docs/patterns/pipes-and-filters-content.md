Decompose a task that performs complex processing into a series of separate elements that can be reused. Doing so can improve performance, scalability, and reusability by allowing task elements that perform the processing to be deployed and scaled independently.

## Context and problem

An application can perform a variety of tasks that vary in complexity on the information it processes. A straightforward but inflexible approach to implementing an application is to perform this processing in a monolithic module. However, this approach is likely to reduce the opportunities for refactoring the code, optimizing it, or reusing it if parts of the same processing are required elsewhere in the application.

The following diagram illustrates the problems with processing data by using the monolithic approach. An application receives and processes data from two sources. The data from each source is processed by a separate module that performs a series of tasks to transform the data before passing the result to the business logic of the application.

![Diagram that shows a solution implemented with monolithic modules.](./_images/pipes-and-filters-modules.png)

Some of the tasks that the monolithic modules perform are functionally similar, but the modules were designed separately. The code that implements the tasks is closely coupled in a module. Reuse and scalability weren't taken into account during development.

However, the processing tasks performed by each module, or the deployment requirements for each task, might change as business requirements are updated. Some tasks might be compute-intensive tasks that could benefit from running on powerful hardware. Other tasks might not require such expensive resources. Also, additional processing might be required in the future, or the order in which the tasks performed by the processing might change. A solution that addresses these problems and increases the possibilities for code reuse is required.

## Solution

Break down the processing that's required for each stream into a set of separate components (or *filters*), each performing a single task. To achieve a standard format of the data that each component receives and sends, the filters can be combined in the pipeline. Doing so avoids code duplication and makes it easy to remove or replace components, or integrate additional components, if the processing requirements change. This diagram shows a solution that's implemented with pipes and filters:

![Diagram that shows a solution that's implemented with pipes and filters.](./_images/pipes-and-filters-solution.png)

The time it takes to process a single request depends on the speed of the slowest filters in the pipeline. One or more filters could be bottlenecks, especially if a high number of requests appear in a stream from a particular data source. A key advantage of the pipeline structure is that it provides opportunities for running parallel instances of slow filters, which enables the system to spread the load and improve throughput.

The filters that make up a pipeline can run on different machines, which enables them to be scaled independently and take advantage of the elasticity that many cloud environments provide. A filter that's computationally intensive can run on high-performance hardware, while other less-demanding filters can be hosted on less-expensive commodity hardware. The filters don't even need to be in the same datacenter or geographic location, so each element in a pipeline to run in an environment that's close to the resources it requires. This diagram shows an example applied to the pipeline for the data from Source 1:

![Diagram that shows an example applied to the pipeline for the data from Source 1.](./_images/pipes-and-filters-load-balancing.png)

If the input and output of a filter are structured as a stream, you can perform the processing for each filter in parallel. The first filter in the pipeline can start its work and output its results, which are passed directly to the next filter in the sequence before the first filter completes its work.

Another benefit of this model is the resiliency that it can provide. If a filter fails or the machine that it's running on is no longer available, the pipeline can reschedule the work that the filter was doing and direct it to another instance of the component. Failure of a single filter doesn't necessarily result in failure of the entire pipeline.

Using the Pipes and Filters pattern together with the [Compensating Transaction pattern](./compensating-transaction.yml) is an alternative approach to implementing distributed transactions. You can break a distributed transaction into separate, compensable tasks, each of which can be implemented via a filter that also implements the Compensating Transaction pattern. You can implement the filters in a pipeline as separate hosted tasks that run close to the data that they maintain.

## Issues and considerations

Consider the following points when you decide how to implement this pattern:

- **Complexity**. The increased flexibility that this pattern provides can also introduce complexity, especially if the filters in a pipeline are distributed across different servers.

- **Reliability**. Use an infrastructure that ensures that data flowing between filters in a pipeline won't be lost.

- **Idempotency**. If a filter in a pipeline fails after receiving a message and the work is rescheduled to another instance of the filter, part of the work might already be complete. If the work updates some aspect of the global state (like information stored in a database), a single update could be repeated. A similar issue might occur if a filter fails after it posts its results to the next filter in the pipeline but before indicating that it's completed its work successfully. In these cases, the same work could be repeated by another instance of the filter, causing the same results to be posted twice. This scenario could result in subsequent filters in the pipeline processing the same data twice. Therefore, filters in a pipeline should be designed to be idempotent. For more information, see [Idempotency Patterns](https://blog.jonathanoliver.com/idempotency-patterns) on Jonathan Oliver's blog.

- **Repeated messages**. If a filter in a pipeline fails after it posts a message to the next stage of the pipeline, another instance of the filter might be run, and it would post a copy of the same message to the pipeline. This scenario could cause two instances of the same message to be passed to the next filter. To avoid this problem, the pipeline should detect and eliminate duplicate messages.

  > [!NOTE] 
  > If you implement the pipeline by using message queues (like Azure Service Bus queues), the message queuing infrastructure might provide automatic duplicate message detection and removal.

- **Context and state**. In a pipeline, each filter essentially runs in isolation and shouldn't make any assumptions about how it was invoked. Therefore, each filter should be provided with sufficient context to perform its work. This context could include a significant amount of state information.

## When to use this pattern

Use this pattern when:

- The processing required by an application can easily be broken down into a set of independent steps.

- The processing steps performed by an application have different scalability requirements.

    > [!NOTE] 
    > You can group filters that should scale together in the same process. For more information, see the [Compute Resource Consolidation pattern](./compute-resource-consolidation.yml).

- You require the flexibility to allow reordering of the processing steps that are performed by an application, or to allow the capability to add and remove steps.

- The system can benefit from distributing the processing for steps across different servers.

- You need a reliable solution that minimizes the effects of failure in a step while data is being processed.

This pattern might not be useful when:

- The processing steps performed by an application aren't independent, or they have to be performed together as part of a single transaction.

- The amount of context or state information that's required by a step makes this approach inefficient. You might be able to persist state information to a database, but don't use this strategy if the extra load on the database causes excessive contention.

## Example

You can use a sequence of message queues to provide the infrastructure that's required to implement a pipeline. An initial message queue receives unprocessed messages. A component that's implemented as a filter task listens for a message on this queue, performs its work, and then posts the transformed message to the next queue in the sequence. Another filter task can listen for messages on this queue, process them, post the results to another queue, and so on, until the fully transformed data appears in the final message in the queue. This diagram illustrates a pipeline that uses message queues:

![Diagram showing a pipeline that uses message queues.](./_images/pipes-and-filters-message-queues.png)

If you're building a solution on Azure, you can use Service Bus queues to provide a reliable and scalable queuing mechanism. The `ServiceBusPipeFilter` class shown in the following C# code demonstrates how you can implement a filter that receives input messages from a queue, processes the messages, and posts the results to another queue.

> [!NOTE]
> The `ServiceBusPipeFilter` class is defined in the PipesAndFilters.Shared project, which is available on [GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/pipes-and-filters).

```csharp
public class ServiceBusPipeFilter
{
  ...
  private readonly string inQueuePath;
  private readonly string outQueuePath;
  ...
  private QueueClient inQueue;
  private QueueClient outQueue;
  ...

  public ServiceBusPipeFilter(..., string inQueuePath, string outQueuePath = null)
  {
     ...
     this.inQueuePath = inQueuePath;
     this.outQueuePath = outQueuePath;
  }

  public void Start()
  {
    ...
    // Create the outbound filter queue if it doesn't exist.
    ...
    this.outQueue = QueueClient.CreateFromConnectionString(...);

    ...
    // Create the inbound and outbound queue clients.
    this.inQueue = QueueClient.CreateFromConnectionString(...);
  }

  public void OnPipeFilterMessageAsync(
    Func<BrokeredMessage, Task<BrokeredMessage>> asyncFilterTask, ...)
  {
    ...

    this.inQueue.OnMessageAsync(
      async (msg) =>
    {
      ...
      // Process the filter and send the output to the
      // next queue in the pipeline.
      var outMessage = await asyncFilterTask(msg);

      // Send the message from the filter processor
      // to the next queue in the pipeline.
      if (outQueue != null)
      {
        await outQueue.SendAsync(outMessage);
      }

      // Note: There's a chance that the same message could be sent twice
      // or that a message could be processed by an upstream or downstream
      // filter at the same time.
      // This would happen in a situation where processing of a message was
      // completed, it was sent to the next pipe/queue, and it then failed
      // to complete when using the PeekLock method.
      // In a real-world implementation, you should consider idempotent message 
      // processing and concurrency.     
    },
    options);
  }

  public async Task Close(TimeSpan timespan)
  {
    // Pause the processing threads.
    this.pauseProcessingEvent.Reset();

    // There's no clean approach for waiting for the threads to complete
    // the processing. This example simply stops any new processing, waits
    // for the existing thread to complete, closes the message pump,
    // and finally returns.
    Thread.Sleep(timespan);

    this.inQueue.Close();
    ...
  }

  ...
}
```

The `Start` method in the `ServiceBusPipeFilter` class connects to a pair of input and output queues, and the `Close` method disconnects from the input queue. The `OnPipeFilterMessageAsync` method performs the actual processing of messages, and the `asyncFilterTask` parameter of this method specifies the processing to be performed. The `OnPipeFilterMessageAsync` method waits for incoming messages on the input queue, runs the code specified by the `asyncFilterTask` parameter over each message as it arrives, and posts the results to the output queue. The queues are specified by the constructor.

The sample solution implements filters in a set of worker roles. Each worker role can be scaled independently, depending on the complexity of the business processing that it performs or the resources that are required for processing. Additionally, multiple instances of each worker role can be run in parallel to improve throughput.

The following code shows an Azure worker role named `PipeFilterARoleEntry`, which is defined in the PipeFilterA project in the sample solution.

```csharp
public class PipeFilterARoleEntry : RoleEntryPoint
{
  ...
  private ServiceBusPipeFilter pipeFilterA;

  public override bool OnStart()
  {
    ...
    this.pipeFilterA = new ServiceBusPipeFilter(
      ...,
      Constants.QueueAPath,
      Constants.QueueBPath);

    this.pipeFilterA.Start();
    ...
  }

  public override void Run()
  {
    this.pipeFilterA.OnPipeFilterMessageAsync(async (msg) =>
    {
      // Clone the message and update it.
      // Properties set by the broker (Deliver count, enqueue time, ...)
      // aren't cloned and must be copied over if required.
      var newMsg = msg.Clone();

      await Task.Delay(500); // DOING WORK

      Trace.TraceInformation("Filter A processed message:{0} at {1}",
        msg.MessageId, DateTime.UtcNow);

      newMsg.Properties.Add(Constants.FilterAMessageKey, "Complete");

      return newMsg;
    });

    ...
  }

  ...
}
```

This role contains a `ServiceBusPipeFilter` object. The `OnStart` method in the role connects to the queues that receive input messages and post output messages. (The names of the queues are defined in the `Constants` class.) The `Run` method invokes the `OnPipeFilterMessageAsync` method to perform processing on each message that's received. (In this example, the processing is simulated by waiting for a short time.) When processing is complete, a new message is constructed that contains the results (in this case, a custom property is added to the input message), and this message is posted to the output queue.

The sample code contains another worker role named `PipeFilterBRoleEntry`. It's in the PipeFilterB project. This role is similar to `PipeFilterARoleEntry`, but it performs different processing in the `Run` method. In the example solution, these two roles are combined to construct a pipeline. The output queue for the `PipeFilterARoleEntry` role is the input queue for the `PipeFilterBRoleEntry` role.

The sample solution also provides two other roles named `InitialSenderRoleEntry` (in the InitialSender project) and `FinalReceiverRoleEntry` (in the FinalReceiver project). The `InitialSenderRoleEntry` role provides the initial message in the pipeline. The `OnStart` method connects to a single queue, and the `Run` method posts a method to that queue. The queue is the input queue that's used by the `PipeFilterARoleEntry` role, so posting a message to it causes the message to be received and processed by the `PipeFilterARoleEntry` role. The processed message then passes through the `PipeFilterBRoleEntry` role.

The input queue for the `FinalReceiveRoleEntry` role is the output queue for the `PipeFilterBRoleEntry` role. The `Run` method in the `FinalReceiveRoleEntry` role, shown in the following code, receives the message and performs some final processing. It then writes the values of the custom properties added by the filters in the pipeline to the trace output.

```csharp
public class FinalReceiverRoleEntry : RoleEntryPoint
{
  ...
  // Final queue/pipe in the pipeline to process data from.
  private ServiceBusPipeFilter queueFinal;

  public override bool OnStart()
  {
    ...
    // Set up the queue.
    this.queueFinal = new ServiceBusPipeFilter(...,Constants.QueueFinalPath);
    this.queueFinal.Start();
    ...
  }

  public override void Run()
  {
    this.queueFinal.OnPipeFilterMessageAsync(
      async (msg) =>
      {
        await Task.Delay(500); // DOING WORK

        // The pipeline message was received.
        Trace.TraceInformation(
          "Pipeline Message Complete - FilterA:{0} FilterB:{1}",
          msg.Properties[Constants.FilterAMessageKey],
          msg.Properties[Constants.FilterBMessageKey]);

        return null;
      });
    ...
  }

  ...
}
```

## Next steps

You might find the following resources helpful when you implement this pattern:

- [A sample that demonstrates this pattern, on GitHub](https://github.com/mspnp/cloud-design-patterns/tree/master/pipes-and-filters)
- [Idempotency patterns](https://blog.jonathanoliver.com/idempotency-patterns), on Jonathan Oliver's blog

## Related resources

The following patterns might also be relevant when you implement this pattern:

- [Competing Consumers pattern](./competing-consumers.yml). A pipeline can contain multiple instances of one or more filters. This approach is useful for running parallel instances of slow filters. It enables the system to spread the load and improve throughput. Each instance of a filter competes for input with the other instances, but two instances of a filter shouldn't be able to process the same data. This article explains the approach.
- [Compute Resource Consolidation pattern](./compute-resource-consolidation.yml). It might be possible to group filters that should scale together into a single process. This article provides more information about the benefits and tradeoffs of this strategy.
- [Compensating Transaction pattern](./compensating-transaction.yml). You can implement a filter as an operation that can be reversed, or that has a compensating operation that restores the state to a previous version if there's a failure. This article explains how you can implement this pattern to maintain or achieve eventual consistency.
