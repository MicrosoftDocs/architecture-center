---
title: Background jobs guidance
description: Learn about background tasks that run independently of the user interface, such as batch jobs, intensive processing tasks, and long-running processes.
ms.author: pnp
author: claytonsiemens77
ms.date: 10/18/2022
ms.topic: best-practice
ms.subservice: best-practice
ms.custom:
  - best-practice
---

<!-- cSpell:ignore webjobs -->

# Background jobs

Many types of applications require background tasks that run independently of the user interface (UI). Examples include batch jobs, intensive processing tasks, and long-running processes such as workflows. Background jobs can be executed without requiring user interaction--the application can start the job and then continue to process interactive requests from users. This can help to minimize the load on the application UI, which can improve availability and reduce interactive response times.

For example, if an application is required to generate thumbnails of images that are uploaded by users, it can do this as a background job and save the thumbnail to storage when it's complete--without the user needing to wait for the process to be completed. In the same way, a user placing an order can initiate a background workflow that processes the order, while the UI allows the user to continue browsing the web app. When the background job is complete, it can update the stored orders data and send an email to the user that confirms the order.

When you consider whether to implement a task as a background job, the main criterion is whether the task can run without user interaction and without the UI needing to wait for the job to be completed. Tasks that require the user or the UI to wait while they are completed might not be appropriate as background jobs.

## Types of background jobs

Background jobs typically include one or more of the following types of jobs:

- CPU-intensive jobs, such as mathematical calculations or structural model analysis.

- I/O-intensive jobs, such as executing a series of storage transactions or indexing files.

- Batch jobs, such as nightly data updates or scheduled processing.

- Long-running workflows, such as order fulfillment, or provisioning services and systems.

- Sensitive-data processing where the task is handed off to a more secure location for processing. For example, you might not want to process sensitive data within a web app. Instead, you might use a pattern such as the [Gatekeeper pattern](../patterns/gatekeeper.yml) to transfer the data to an isolated background process that has access to protected storage.

## Triggers

Background jobs can be initiated in several different ways. They fall into one of the following categories:

- [**Event-driven triggers**](#event-driven-triggers). The task is started in response to an event, typically an action taken by a user or a step in a workflow.
- [**Schedule-driven triggers**](#schedule-driven-triggers). The task is invoked on a schedule based on a timer. This might be a recurring schedule or a one-off invocation that is specified for a later time.

### Event-driven triggers

Event-driven invocation uses a trigger to start the background task. Examples of using event-driven triggers include:

- The UI or another job places a message in a queue. The message contains data about an action that has taken place, such as the user placing an order. The background task listens on this queue and detects the arrival of a new message. It reads the message and uses the data in it as the input to the background job. This pattern is known as [asynchronous message-based communication](/dotnet/architecture/microservices/architect-microservice-container-applications/asynchronous-message-based-communication).

- The UI or another job saves or updates a value in storage. The background task monitors the storage and detects changes. It reads the data and uses it as the input to the background job.

- The UI or another job makes a request to an endpoint, such as an HTTPS URI, or an API that is exposed as a web service. It passes the data that is required to complete the background task as part of the request. The endpoint or web service invokes the background task, which uses the data as its input.

Typical examples of tasks that are suited to event-driven invocation include image processing, workflows, sending information to remote services, sending email messages, and provisioning new users in multitenant applications.

### Schedule-driven triggers

Schedule-driven invocation uses a timer to start the background task. Examples of using schedule-driven triggers include:

- A timer that is running locally within the application or as part of the application's operating system invokes a background task on a regular basis.

- A timer that is running in a different application, such as Azure Logic Apps, sends a request to an API or web service on a regular basis. The API or web service invokes the background task.

- A separate process or application starts a timer that causes the background task to be invoked once after a specified time delay, or at a specific time.

Typical examples of tasks that are suited to schedule-driven invocation include batch-processing routines (such as updating related-products lists for users based on their recent behavior), routine data processing tasks (such as updating indexes or generating accumulated results), data analysis for daily reports, data retention cleanup, and data consistency checks.

If you use a schedule-driven task that must run as a single instance, be aware of the following considerations:

- If the compute instance that is running the scheduler (such as a virtual machine using Windows scheduled tasks) is scaled, you then have multiple instances of the scheduler running. These could start multiple instances of the task. [Design scheduled tasks to be idempotent](#design-for-idempotency) so that running the same task more than once doesn't produce duplicate results or inconsistencies.

- If tasks run for longer than the period between scheduler events, the scheduler might start another instance of the task while the previous one is still running.

## Returning results

Background jobs execute asynchronously in a separate process, or even in a separate location, from the UI or the process that invoked the background task. Ideally, background tasks are "fire and forget" operations, and their execution progress has no impact on the UI or the calling process. This means that the calling process doesn't wait for completion of the tasks and can't automatically detect when the task ends.

If you require a background task to communicate with the calling task to indicate progress or completion, you must implement a mechanism for this. Some options are:

- **Return a status endpoint to the caller**. The caller receives a URL (or resource identifier) when it submits the job and polls that endpoint for status. This approach is described by the [Asynchronous Request-Reply pattern](../patterns/async-request-reply.yml). It works well for HTTP-based APIs where the caller initiates a long-running operation and needs to check for completion.

- **Use a reply queue**. The background task sends messages to a queue that the caller listens on. The messages indicate status and completion. If you use Azure Service Bus, you can use the **ReplyTo** and **CorrelationId** properties to correlate responses to requests.

- **Push notifications through events**. The background task publishes an event when it completes (or at key milestones). The caller subscribes to those events. This approach works well with [Azure Event Grid](/azure/event-grid/overview) for cloud-native event routing, or with a publish-and-subscribe mechanism like Azure Service Bus topics.

- **Call back to the caller through a webhook**. The caller provides a callback URL when it submits the job. The background task sends an HTTP request to that URL when processing completes or when errors occur. This approach is useful when the caller is an external system.

- **Write status to shared storage**. The background task writes progress or results to a shared data store (such as a database or blob) that the caller monitors. This approach is straightforward but requires the caller to poll for changes.

## Design for idempotency

Background jobs are especially prone to running more than once for the same logical work item. Queues deliver messages at least once, schedulers can overlap if a job runs longer than the timer interval, and infrastructure restarts can replay partially completed work. Design every background job so that running it multiple times with the same input produces the same outcome. For implementation techniques, see the [guidance on idempotent message processing](../reference-architectures/containers/aks-mission-critical/mission-critical-data-platform.md#idempotent-message-processing).

## Hosting environment

You can host background tasks by using a range of different Azure platform services:

- [**Azure Functions**](#azure-functions). A serverless compute service that supports event-driven and schedule-driven triggers with automatic scaling. Use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) for long-running or stateful workflows.

- [**Azure Container Apps**](#azure-container-apps). A serverless container platform that supports both long-running services and discrete [jobs](/azure/container-apps/jobs). Jobs run to completion and can be triggered manually, on a schedule, or by events. Container Apps uses [KEDA](https://keda.sh/) for event-driven autoscaling, including scale to zero.

- [**Azure Kubernetes Service (AKS)**](#azure-kubernetes-service). A managed Kubernetes environment that provides full control over container orchestration. Use Kubernetes [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) and [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) for background processing when you need direct access to the Kubernetes API and control plane.

- [**Azure Batch**](#azure-batch). A platform service that schedules compute-intensive work to run on a managed collection of virtual machines. It can automatically scale compute resources across tens, hundreds, or thousands of nodes.

- [**Azure Virtual Machines**](#azure-virtual-machines). An IaaS option for background tasks that require full control over the operating system or runtime environment, such as Windows services, third-party executables, or specialized runtimes.

- [**Azure App Service WebJobs**](#azure-app-service-webjobs). A feature of Azure App Service that runs background scripts or programs in the same context as a web app. Consider WebJobs when you need background processing that is colocated with an existing App Service application.

The following sections describe these options in more detail and include considerations to help you choose the appropriate option.

### Azure Functions

Azure Functions is a serverless compute service that runs event-driven code. Functions are a fit for background jobs because they support a wide range of [triggers](/azure/azure-functions/functions-triggers-bindings), including queue messages, blob storage changes, timer schedules, HTTP requests, and Event Grid events.

For short-duration background tasks, Azure Functions provides automatic scaling (including scale to zero on the Consumption plan) and pay-per-execution billing. For long-running or stateful workflows, use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview), which extends Azure Functions with orchestration capabilities.

Durable Functions supports several [patterns](/azure/azure-functions/durable/durable-functions-overview#application-patterns) that are directly applicable to background job coordination:

- **Function chaining**. Execute a sequence of functions in a specific order, passing the output of each step to the next.
- **Fan-out/fan-in**. Run multiple functions in parallel and then aggregate the results.
- **Async HTTP APIs**. Coordinate long-running operations with external clients by using a polling endpoint or webhook callback.
- **Human interaction**. Pause an orchestration until an external event (such as an approval) is received, with optional timeout-based escalation.
- **Monitor**. Implement a recurring process that polls for a condition, with configurable intervals and timeouts.

#### Azure Functions considerations

- Choose a [hosting plan](/azure/azure-functions/functions-scale) based on your workload characteristics:

  - **Consumption plan**. Best for infrequent or unpredictable workloads. You pay only for execution time and resources consumed. Execution duration is limited by a configurable timeout (default 5 minutes, maximum 10 minutes).

  - **Flex Consumption plan**. Provides the scale-to-zero billing model of the Consumption plan with additional features like virtual network integration, configurable instance sizes, and faster scaling. Supports concurrency control for event-driven processing.

  - **Premium plan**. Suited for high-throughput workloads that run continuously or near-continuously. Provides pre-warmed instances to avoid cold starts, virtual network integration, and longer execution durations.

  - **Dedicated (App Service) plan**. Run functions on existing App Service infrastructure. This option is appropriate when you have underutilized App Service capacity and want to share compute costs.

- Durable Functions maintains orchestration state automatically through checkpointing. If a function app restarts, the orchestration resumes from its last checkpoint. Design activity functions to be [idempotent](/azure/azure-functions/durable/durable-functions-best-practice-reference) so that retries don't produce duplicate side effects. You can also use [timer triggers](/azure/azure-functions/functions-bindings-timer) to run functions on a schedule without an external event source.

### Azure Container Apps

Azure Container Apps supports background processing through [Container Apps jobs](/azure/container-apps/jobs), which run containerized tasks to completion and then stop. Jobs are suited for batch processing, scheduled tasks, and event-driven work where a short-lived process handles a discrete unit of work. For a general overview of the platform, see [Azure Container Apps overview](/azure/container-apps/overview).

Container Apps jobs support three trigger types:

- **Manual jobs**. Triggered on demand through the Azure CLI, Azure portal, or Azure Resource Manager API. Use manual jobs for one-time tasks such as data migrations or on-demand processing that is initiated by an application.

- **Scheduled jobs**. Triggered at specific times by using a cron expression. Use scheduled jobs for nightly reports, periodic data cleanup, or recurring data processing.

- **Event-driven jobs**. Triggered by events such as a message arriving in a queue. Container Apps uses [KEDA](https://keda.sh/) to monitor event sources and scale job executions based on configured rules. Event-driven jobs can scale to zero when there are no events to process. For a walkthrough, see [Tutorial: Deploy an event-driven job](/azure/container-apps/tutorial-event-driven-jobs).

For background tasks that run continuously (for example, a service that constantly processes messages from a queue), deploy a container app instead of a job. Container apps restart automatically on failure and support [scaling rules](/azure/container-apps/scale-app) based on queue length or other metrics.

#### Azure Container Apps considerations

- Container Apps jobs require you to build and maintain container images. This adds overhead compared to Azure Functions, but it gives you full control over the runtime, dependencies, and OS-level tooling your job needs.

- For event-driven jobs, verify that your event source is supported by a [KEDA scaler](https://keda.sh/docs/scalers/). KEDA supports Azure Service Bus, Azure Storage Queues, Apache Kafka, RabbitMQ, and many other sources.

- If you need direct access to the Kubernetes APIs and control plane, use [Azure Kubernetes Service](/azure/aks/intro-kubernetes) instead.

### Azure Kubernetes Service

Use Azure Kubernetes Service (AKS) when your background jobs require direct access to the Kubernetes API, custom scheduling logic, or integration with a broader Kubernetes-based platform that your team already operates.

Use Kubernetes [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) for scheduled background tasks and [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) for one-time run-to-completion work. You can also use [KEDA](https://keda.sh/) with AKS for event-driven autoscaling of job processors.

#### Azure Kubernetes Service considerations

- AKS requires operational investment in cluster management, upgrades, and security patching. If you don't need direct Kubernetes API access, [Azure Container Apps jobs](#azure-container-apps) provide a managed alternative with less overhead.

### Azure Batch

Consider [Azure Batch](/azure/batch/batch-technical-overview) if you need to run large, parallel high-performance computing (HPC) workloads across tens, hundreds, or thousands of VMs.

The Batch service provisions the VMs, assigns tasks to the VMs, runs the tasks, and monitors the progress. Batch can automatically scale out the VMs in response to the workload. Batch also provides job scheduling. Azure Batch supports both Linux and Windows VMs.

#### Azure Batch considerations

Batch works well with intrinsically parallel workloads. It can also perform parallel calculations with a reduce step at the end, or run [Message Passing Interface (MPI) applications](/azure/batch/batch-mpi) for parallel tasks that require message passing between nodes.

An Azure Batch job runs on a pool of nodes (VMs). One approach is to allocate a pool only when needed and then delete it after the job completes. This approach maximizes utilization because nodes aren't idle, but the job must wait for nodes to be allocated. Alternatively, you can create a pool ahead of time. That approach minimizes the time that it takes for a job to start but can result in nodes that sit idle. For more information, see [Pool and compute node lifetime](/azure/batch/batch-api-basics#pool-and-compute-node-lifetime). For broader HPC guidance, see [Batch and HPC solutions for large-scale computing workloads](../guide/compute/high-performance-computing.md).

### Azure Virtual Machines

Background tasks might require a full operating system environment or specific runtime dependencies that prevent them from using platform or serverless services. Typical examples include Windows services, third-party executables, and programs written for specialized runtimes. You can choose from a range of operating systems for an Azure virtual machine and run your service or executable on that virtual machine.

To initiate the background task in a separate virtual machine, you have several options:

- You can execute the task on demand directly from your application by sending a request to an endpoint that the task exposes. This passes in any data that the task requires. This endpoint invokes the task.

- You can configure the task to run on a schedule by using a scheduler or timer that is available in your chosen operating system. For example, on Windows you can use Windows Task Scheduler to execute scripts and tasks. Or, if you have SQL Server installed on the virtual machine, you can use the SQL Server Agent to execute scripts and tasks.

- You can use Azure Logic Apps to initiate the task by adding a message to a queue that the task listens on, or by sending a request to an API that the task exposes.

See the earlier section [Triggers](#triggers) for more information about how you can initiate background tasks.

#### Azure Virtual Machines considerations

Consider the following points when you decide whether to deploy background tasks in an Azure virtual machine:

- Hosting background tasks in a separate [Azure virtual machine](/azure/virtual-machines/linux/faq) provides flexibility and allows precise control over initiation, execution, scheduling, and resource allocation. However, it increases runtime cost if a virtual machine must be deployed solely to run background tasks. To evaluate whether a VM is the right compute model, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).

- There is no built-in facility in the Azure portal to monitor individual tasks, and no automated restart capability for failed tasks. You can monitor the basic status of the virtual machine and manage it by using [Azure PowerShell cmdlets](/powershell/azure). However, you need to implement your own mechanisms for collecting instrumentation data from the task and the operating system. Use the [Azure Monitor Agent](/azure/azure-monitor/agents/agents-overview) to collect logs and metrics from the VM.

- You might consider creating monitoring probes that are exposed through HTTP endpoints. The code for these probes could perform health checks, collect operational information and statistics, or collate error information and return it to a management application. For more information, see the [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml).

### Azure App Service WebJobs

Azure [WebJobs](/azure/app-service/webjobs-create) is a feature of Azure App Service that runs background scripts or programs in the same instance as a web app. WebJobs run within the sandbox of the web app, which means that they can access environment variables, connection strings, and other configuration shared with the app. You can use the [Azure WebJobs SDK](/azure/app-service/webjobs-sdk-get-started) to simplify the code you write for common background processing tasks.

Consider WebJobs when you have an existing App Service web app and you need background processing that shares the same lifecycle, configuration, and deployment as the web app. WebJobs aren't recommended as a general-purpose background job platform for new workloads. For new event-driven or scheduled background processing, evaluate [Azure Functions](#azure-functions) or [Azure Container Apps jobs](#azure-container-apps) first.

WebJobs can run as continuous or triggered processes:

- **Run continuously**. The WebJob starts immediately and runs as a long-running process. The script or program is stored in site/wwwroot/app_data/jobs/continuous.

- **Run on a schedule or on demand**. The WebJob is triggered by a schedule (via a CRON expression) or started manually. The script or program is stored in site/wwwroot/app_data/jobs/triggered.

#### Azure App Service WebJobs considerations

- By default, WebJobs scale with the web app. You can configure a job to run as a single instance by setting the **is_singleton** configuration property to **true**. Single instance WebJobs are useful for tasks that you don't want to run as simultaneous multiple instances, such as reindexing or data analysis.

- To minimize the impact of jobs on the performance of the web app, consider creating an empty Azure Web App instance in a separate App Service plan to host long-running or resource-intensive WebJobs.

- WebJobs share compute resources with the host web app. Resource-intensive background processing can degrade the responsiveness of the web app.

## Partitioning

If you decide to include background tasks within an existing compute instance, you must consider how this affects the quality attributes of the compute instance and the background task itself. These factors help you to decide whether to colocate the tasks with the existing compute instance or separate them out into a separate compute instance:

- **Availability**: Background tasks are often more tolerant of brief outages than the UI because pending work can be queued. However, if the queue backs up because background processing is unavailable for too long, the application as a whole is affected.

- **Recovery**: If a compute instance that only hosts background tasks fails, the application can continue serving users as long as pending work is queued. When the instance recovers, it processes the backlog.

- **Security**: Background tasks might need access to different resources, credentials, or network segments than the UI. Running them in a separate compute instance lets you apply a tighter security boundary, such as restricting network access to a data store that the UI should never reach directly. You can also use patterns such as [Gatekeeper](../patterns/gatekeeper.yml) to isolate background compute from user-facing components.

- **Manageability**: Background tasks often change on a different release cadence than the UI. Separating them avoids redeploying the entire application when only the job logic changes.

- **Scalability**: Background tasks typically scale on different signals (queue depth, batch size) than the UI (concurrent users, request rate). Separating them lets each scale independently.

Separating background tasks into dedicated compute adds hosting cost. Weigh that cost against the operational benefits of independent scaling, deployment, and failure isolation.

## Conflicts

If you have multiple instances of a background job, they might compete for access to resources and services, such as databases and storage. This concurrent access can result in resource contention, which might cause conflicts in availability of the services and in the integrity of data in storage. You can resolve resource contention by using a pessimistic locking approach. This prevents competing instances of a task from concurrently accessing a service or corrupting data.

Another approach to resolve conflicts is to define background tasks as a singleton, so that there's only ever one instance running. But this eliminates the reliability and performance benefits that a multiple-instance configuration can provide. This is especially true if the UI can supply sufficient work to keep more than one background task busy.

It is vital to ensure that the background task can automatically restart and that it has sufficient capacity to cope with peaks in demand. You can achieve this by allocating a compute instance with sufficient resources, by implementing a queueing mechanism that can store requests for later execution when demand decreases, or by using a combination of these techniques.

## Coordination

The background tasks might be complex and might require multiple individual tasks to execute to produce a result or to fulfill all the requirements. It is common in these scenarios to divide the task into smaller discrete steps or subtasks that can be executed by multiple consumers. Multistep jobs can be more efficient and more flexible because individual steps might be reusable in multiple jobs. It is also easy to add, remove, or modify the order of the steps.

Coordinating multiple tasks and steps can be challenging, but there are three common patterns that you can use to guide your implementation of a solution:

- **Decomposing a task into multiple reusable steps**. A background job that processes information through several stages (for example, validate, transform, store) can be decomposed into discrete filters connected by queues. Each step runs independently and can be scaled or reused across different jobs. For more information, see the [Pipes and Filters pattern](../patterns/pipes-and-filters.yml).

- **Managing execution of the steps for a task**. A background job composed of several steps that call remote services or access remote resources needs orchestration logic to sequence the steps, handle timeouts, and track progress. For more information, see [Scheduler Agent Supervisor pattern](../patterns/scheduler-agent-supervisor.yml).

- **Managing recovery for task steps that fail**. A background job that spans multiple steps (which together define an eventually consistent operation) might need to undo completed work if a later step fails. For more information, see the [Compensating Transaction pattern](../patterns/compensating-transaction.yml).

## Resiliency considerations

Background tasks must be resilient in order to provide reliable services to the application. When you are planning and designing background tasks, consider the following points:

- Background tasks must be able to gracefully handle restarts without corrupting data or introducing inconsistency into the application. For long-running or multistep tasks, consider using *checkpointing* by saving the state of jobs in persistent storage, or as messages in a queue if this is appropriate. For example, you can persist state information in a message in a queue and incrementally update this state information with the task progress so that the task can be processed from the last known good checkpoint instead of restarting from the beginning. When you use Azure Service Bus queues, you can use [message sessions](/azure/service-bus-messaging/message-sessions) to save and retrieve application processing state. For more information about designing reliable multistep processes and workflows, see the [Scheduler Agent Supervisor pattern](../patterns/scheduler-agent-supervisor.yml).

- Design background tasks to shut down gracefully when the hosting platform signals termination. Deployments, scale-in events, and platform maintenance can stop a running instance at any time. If a background task is mid-execution when it receives a termination signal (such as SIGTERM in containers), it should stop accepting new work, finish or checkpoint the current work item, and exit cleanly. For queue-driven tasks, this means completing the current message before the process exits so the message isn't redelivered unnecessarily. If the task can't finish in time, it should checkpoint its progress or allow the message visibility timeout to expire so another instance picks up the work.

  Set the platform's shutdown grace period (such as `terminationGracePeriodSeconds` in Kubernetes or the [shutdown timeout](/azure/azure-functions/functions-host-json#functiontimeout) in Azure Functions) long enough for your typical work item to complete.

- When you use queues to communicate with background tasks, the queues can act as a buffer to store requests that are sent to the tasks while the application is under higher than usual load. This allows the tasks to catch up with the UI during less busy periods. It also means that restarts won't block the UI. For more information, see the [Queue-Based Load Leveling pattern](../patterns/queue-based-load-leveling.yml). If some tasks are more important than others, consider implementing the [Priority Queue pattern](../patterns/priority-queue.yml) to ensure that these tasks run before less important ones.

- Background tasks that are initiated by messages or process messages must be designed to handle inconsistencies, such as messages arriving out of order, messages that repeatedly cause an error (often referred to as *poison messages*), and messages that are delivered more than once. Consider the following factors:

  - Messages that must be processed in a specific order, such as those that change data based on the existing data value (for example, adding a value to an existing value), might not arrive in the original order in which they were sent. Alternatively, they might be handled by different instances of a background task in a different order due to varying loads on each instance. Messages that must be processed in a specific order should include a sequence number, key, or some other indicator that background tasks can use to ensure that they are processed in the correct order. If you are using Azure Service Bus, you can use message sessions to guarantee the order of delivery. But it's usually more efficient, where possible, to design the process so that the message order isn't important.

  - Typically, a background task peeks at messages in the queue, which temporarily hides them from other message consumers. Then it deletes the messages after they are successfully processed. If a background task fails when processing a message, that message reappears on the queue after the peek time-out expires. It is then processed by another instance of the task or during the next processing cycle of this instance. If the message consistently causes an error in the consumer, it blocks the task, the queue, and eventually the application itself when the queue becomes full. So, it's vital to detect and remove poison messages from the queue. If you're using Azure Service Bus, messages that cause an error can be moved automatically or manually to an associated [dead letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues).

  - Queues are guaranteed at *least once* delivery mechanisms, which means a message can be delivered more than once. If a background task fails after processing a message but before deleting it from the queue, the message becomes available for processing again. All message-driven background tasks must be idempotent. See [Design for idempotency](#design-for-idempotency) for techniques to handle duplicate delivery safely.

- **Distinguish transient from permanent failures in your job processor**. When a background task fails to process a message, the queue redelivers it automatically. If the failure is transient (a downstream service timeout or throttling response), redelivery is the right behavior. If the failure is permanent (invalid message payload, missing referenced data), the message fails on every attempt. Configure your job processor to detect permanent failures and route those messages directly to a [dead letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) instead of consuming retry attempts. Use the queue's max delivery count to cap how many times a message is retried before it's dead-lettered automatically. For more information on handling transient conditions in your processing logic, see [Transient fault handling](transient-faults.md).

## Observability considerations

Background jobs run without a user present, so failures are silent unless you actively monitor for them. When you plan observability for background tasks, consider the following points:

- **Track job completion, not just job start.** Log when a background job starts, completes, and fails. Include the job type, a correlation identifier that ties the job back to the triggering event or message, and the elapsed duration. Without completion tracking, a job that hangs or crashes silently appears to be running normally.

- **Alert on missed schedules.** For schedule-driven tasks, monitor that each expected run actually occurred. If a scheduled job doesn't fire, there's no error to catch because nothing ran. Compare actual execution times against the expected schedule and alert when a run is missing.

- **Monitor dead letter queues.** Dead-lettered messages represent background work that wasn't completed. Set up alerts on [dead letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) depth and message age so that your operations team can investigate failures, fix the underlying issue, and resubmit messages. Without monitoring, failed work accumulates silently.

- **Measure queue wait time, not just processing time.** The total time from when a message is enqueued to when it finishes processing is what matters to the business. A job that processes in 2 seconds but sat in the queue for 30 minutes still delivered a 30-minute delay. Track enqueue-to-completion latency alongside per-job processing duration.

- **Correlate across job steps.** Multistep background jobs can span multiple services, queues, and compute instances. Propagate a correlation identifier through every step so that you can trace the full lifecycle of a single work item in your logs and [distributed traces](/azure/azure-monitor/app/distributed-trace-data).

## Scaling and performance considerations

Background tasks must keep pace with the rate at which work arrives. If tasks fall behind, queues grow, latency increases, and downstream processes stall. When you plan scaling for background tasks, consider the following points:

- **Scale on queue depth, not on CPU alone.** For message-driven background tasks, the most meaningful scaling signal is how much work is waiting, not how busy the current instances are. Azure Functions, Azure Container Apps, and AKS (via [KEDA](https://keda.sh/)) all support scaling based on queue length, topic subscription count, or other event-source metrics. This approach adds capacity when work accumulates and removes it when queues drain.

- **Use scale-to-zero for intermittent workloads.** If your background jobs only run at certain times, such as nightly batch jobs or event-driven processing with idle periods, use a hosting model that scales to zero when there's no work. Azure Functions (Consumption and Flex Consumption plans) and Azure Container Apps Jobs scale to zero by default, so you don't pay for idle compute.

- **Scale background tasks independently from the application.** Host background tasks in a separate compute service so that the UI and background processing scale on different signals. If you have multiple background task types with different throughput characteristics, consider separating them so each type can scale independently.

- **Scale the entire processing pipeline, not just compute.** Adding more task instances doesn't help if the queue, database, or downstream API becomes the bottleneck. Identify throughput limits across the pipeline, including messaging throughput units, database request units, and API rate limits, and scale those resources alongside your compute.

- **Enforce single-instance execution when required.** Some scheduled background tasks must not run concurrently, such as database maintenance or report generation that isn't idempotent. Azure Functions timer triggers use a [distributed lock](/azure/azure-functions/functions-bindings-timer#usage) to ensure only one instance runs. For containers, use Kubernetes CronJob's `concurrencyPolicy: Forbid` or Container Apps job-level concurrency settings.

## Next steps

- [More recommendations for developing background jobs](/azure/well-architected/reliability/background-jobs)
- [Choose a messaging service](/azure/service-bus-messaging/compare-messaging-services)
- [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree)

## Related resources

- [Queue-Based Load Leveling pattern](../patterns/queue-based-load-leveling.yml)
- [Priority Queue pattern](../patterns/priority-queue.yml)
- [Pipes and Filters pattern](../patterns/pipes-and-filters.yml)
- [Scheduler Agent Supervisor pattern](../patterns/scheduler-agent-supervisor.yml)
- [Compensating Transaction pattern](../patterns/compensating-transaction.yml)
- [Leader Election pattern](../patterns/leader-election.yml)
- [Competing Consumers pattern](../patterns/competing-consumers.yml)
