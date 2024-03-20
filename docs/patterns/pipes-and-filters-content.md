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

## Workload design

An architect should evaluate how the Pipes and Filters pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | The single responsibility of each stage enables focused attention and avoids the distraction of commingled data processing.<br/><br/> - [RE:01 Simplicity](/azure/well-architected/reliability/simplify)<br/> - [RE:07 Background jobs](/azure/well-architected/reliability/background-jobs) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

You can use a sequence of message queues to provide the infrastructure that's required to implement a pipeline. An initial message queue receives unprocessed messages that become the start of the pipes and filters pattern implementation. A component that's implemented as a filter task listens for a message on this queue, performs its work, and then posts a new or transformed message to the next queue in the sequence. Another filter task can listen for messages on this queue, process them, post the results to another queue, and so on, until the final step that ends the pipes and filters process. This diagram illustrates a pipeline that uses message queues:

![Diagram showing a pipeline that uses message queues.](./_images/pipes-and-filters-message-queues.png)

An image processing pipeline could be implemented using this pattern. If your workload takes an image, the image could pass through a series of largely independent and reorderable filters to perform actions such as:

- content moderation
- resizing
- watermarking
- reorientation
- Exif metadata removal
- Content delivery network (CDN) publication

In this example, the filters could be implemented as individually deployed Azure Functions or even a single Azure Function app that contains each filter as an isolated deployment. The use of Azure Function triggers, input bindings, and output bindings can simplify the filter code and work automatically with a queue-based pipe using a [claim check](./claim-check.yml) to the image to process.

:::image type="complex" source="./_images/pipes-and-filters-image-processing-example.svg" alt-text="Diagram showing an image processing pipeline that uses Azure Queue Storage between a series of Azure Functions." lightbox="./_images/pipes-and-filters-image-processing-example.svg":::
   This diagram shows three unprocessed images on the left of various file types. To the right of those is an Azure Queue Storage pipe with claim check messages for each image; followed by an Azure Function that performs content moderation on the image as a filter. All the images are stored in an Azure Blob Storage account. There is another queue (pipe) and function (filter) that follows the first to handle image resizing. Then there is an ellipsis (…) which represents unshown pipes and filters. The last pipe and filter are responsible for publishing the final, fully processed image to its destination.
:::image-end:::

Here's an example of what one filter, implemented as an Azure Function, triggered from a Queue Storage pipe with a claim Check to the image, and writing a new claim check to another Queue Storage pipe might look like. The implementation has been replaced with pseudocode in comments for brevity. More code like this can be found in the [demonstration of the Pipes and Filters pattern](https://github.com/mspnp/cloud-design-patterns/tree/main/pipes-and-filters#readme) available on GitHub.

```csharp
// This is the "Resize" filter. It handles claim checks from input pipe, performs the
// resize work, and places a claim check in the next pipe for anther filter to handle.
[Function(nameof(ResizeFilter))]
[QueueOutput("pipe-fjur", Connection = "pipe")]  // Destination pipe claim check
public async Task<string> RunAsync(
  [QueueTrigger("pipe-xfty", Connection = "pipe")] string imageFilePath,  // Source pipe claim check
  [BlobInput("{QueueTrigger}", Connection = "pipe")] BlockBlobClient imageBlob)  // Image to process
{
  _logger.LogInformation("Processing image {uri} for resizing.", imageBlob.Uri);

  // Idempotency checks
  // ...

  // Download image based on claim check in queue message body
  // ...
  
  // Resize the image
  // ...

  // Write resized image back to storage
  // ...

  // Create claim check for image and place in the next pipe
  // ...
  
  _logger.LogInformation("Image resizing done or not needed. Adding image {filePath} into the next pipe.", imageFilePath);
  return imageFilePath;
}
```

## Next steps

You might find the following resources helpful when you implement this pattern:

- A [demonstration of the Pipes and Filters Pattern](https://github.com/mspnp/cloud-design-patterns/tree/main/pipes-and-filters#readme) using the image processing scenario is available on GitHub.
- [Idempotency patterns](https://blog.jonathanoliver.com/idempotency-patterns), on Jonathan Oliver's blog

## Related resources

The following patterns might also be relevant when you implement this pattern:

- [Claim-Check pattern](./claim-check.yml). A pipeline implemented using a queue may not hold the actual item being sent through the filters, but instead a pointer to the data that needs to be processed. The example uses a claim check in Azure Queue Storage for images stored in Azure Blob Storage.
- [Competing Consumers pattern](./competing-consumers.yml). A pipeline can contain multiple instances of one or more filters. This approach is useful for running parallel instances of slow filters. It enables the system to spread the load and improve throughput. Each instance of a filter competes for input with the other instances, but two instances of a filter shouldn't be able to process the same data. This article explains the approach.
- [Compute Resource Consolidation pattern](./compute-resource-consolidation.yml). It might be possible to group filters that should scale together into a single process. This article provides more information about the benefits and tradeoffs of this strategy.
- [Compensating Transaction pattern](./compensating-transaction.yml). You can implement a filter as an operation that can be reversed, or that has a compensating operation that restores the state to a previous version if there's a failure. This article explains how you can implement this pattern to maintain or achieve eventual consistency.
