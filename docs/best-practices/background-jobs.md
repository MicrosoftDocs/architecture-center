---
title: Best Practices for Background Jobs
description: Learn best practices for designing background jobs on Azure, including hosting options, reliability, and scaling for event-driven and scheduled jobs.
ms.author: pnp
author: claytonsiemens77
ms.date: 03/30/2026
ms.topic: best-practice
ms.subservice: best-practice
---

<!-- cSpell:ignore webjobs -->

# Best practices for background jobs

Many types of applications require background tasks that run independently of the UI. Examples include batch jobs, intensive processing tasks, and long-running processes like workflows. Background jobs run without user interaction. The application starts the job and continues to process interactive requests from users. This approach minimizes load on the application UI, which improves availability and reduces interactive response times.

For example, if an application needs to generate thumbnails of images that users upload, it can run this work as a background job and save the thumbnail to storage when complete. The user doesn't need to wait. Similarly, a user who places an order can initiate a background workflow that processes the order, while the UI lets the user continue to browse the web app. When the background job completes, it updates the stored order data and sends an email to the user to confirm the order.

When you consider whether to implement a task as a background job, the main criterion is whether the task can run without user interaction and without requiring the UI to wait for completion. Tasks that require the user or the UI to wait while they complete might not be suitable as background jobs.

> [!TIP]
> This article provides architectural guidance for designing background job systems on Azure. It covers hosting options, design principles, reliability, security, observability, and scaling. If you perform a reliability review of an existing workload that uses background jobs, see [Recommendations for developing background jobs](/azure/well-architected/design-guides/background-jobs) in the Azure Well-Architected Framework, which provides a focused checklist of reliability requirements.

## Types of background jobs

Background jobs typically include one or more of the following types of jobs:

- CPU-intensive jobs, like mathematical calculations or structural model analysis.

- Input and output (I/O)-intensive jobs, like a series of storage transactions or file indexing.

- Batch jobs, like nightly data updates or scheduled processing.

- Long-running workflows, like order fulfillment, or provisioning services and systems.

- Sensitive-data processing in which you send the task to a more secure location for processing. For example, you might not want to process sensitive data within a web app. You might instead use a pattern like the [Gatekeeper pattern](../patterns/gatekeeper.yml) to transfer the data to an isolated background process that can access protected storage.

## Triggers

You can initiate background jobs in several ways. They fall into one of the following categories:

- **[Event-driven triggers](#event-driven-triggers):** An event, typically a user action or a step in a workflow, starts the task.

- **[Schedule-driven triggers](#schedule-driven-triggers):** A timer invokes the task on a recurring schedule or as a single invocation at a specified time.

### Event-driven triggers

Event-driven invocation uses a trigger to start the background task. Examples of event-driven triggers include:

- The UI or another job places a message in a queue. The message contains data about an action that occurred, like the user placing an order. The background task listens on this queue for new messages. It reads a message and uses the data as the input to the background job. This pattern is known as *[asynchronous message-based communication](/dotnet/architecture/microservices/architect-microservice-container-applications/asynchronous-message-based-communication)*.

- The UI or another job saves or updates a value in storage. The background task monitors the storage and detects changes. It reads the data and uses it as the input to the background job.

- The UI or another job makes a request to an endpoint, like an HTTPS uniform resource identifier (URI), or an API exposed as a web service. It passes the data required to complete the background task as part of the request. The endpoint or web service invokes the background task, which uses the data as its input.

Typical examples of tasks suited to event-driven invocation include image processing, workflows, sending information to remote services, sending email messages, and provisioning new users in multitenant applications.

### Schedule-driven triggers

Schedule-driven invocation uses a timer to start the background task. Examples of schedule-driven triggers include:

- A timer that runs locally within the application or as part of the application's operating system regularly invokes a background task.

- A timer that runs in a different application, like Azure Logic Apps, regularly sends a request to an API or web service. The API or web service invokes the background task.

- A separate process or application starts a timer that starts the background task once after a specified time delay, or at a specific time.

Typical examples of tasks suited to schedule-driven invocation include batch-processing routines (like updating related-products lists for users based on their recent behavior), routine data processing tasks (like updating indexes or generating accumulated results), data analysis for daily reports, data retention cleanup, and data consistency checks.

If you use a schedule-driven task that must run as a single instance, be aware of the following considerations:

- If you scale the compute instance that runs the scheduler, like a virtual machine (VM) that uses Windows scheduled tasks, you create multiple scheduler instances. These instances can start multiple copies of the task. [Design scheduled tasks to be idempotent](#design-for-idempotency) so that running the same task more than once doesn't produce duplicate results or inconsistencies.

- If tasks run for longer than the period between scheduler events, the scheduler might start another instance of the task while the previous instance runs.

## Returning results

Background jobs run asynchronously in a separate process, or even a separate location, from the UI or the process that invoked them. Ideally, background tasks are *fire and forget* operations, and their processing progress has no impact on the UI or the calling process. The calling process doesn't wait for task completion and can't automatically detect when the task ends.

If you require a background task to communicate with the calling task to indicate progress or completion, you must implement a mechanism for this task. Options include:

- **Return a status endpoint to the caller.** The caller receives a URL (or resource identifier) when it submits the job and polls that endpoint for status. The [Asynchronous Request-Reply pattern](../patterns/asynchronous-request-reply.md) describes this approach. It suits HTTP-based APIs in which the caller initiates a long-running operation and needs to check for completion.

- **Use a reply queue.** The background task sends messages to a queue that the caller listens on. The messages indicate status and completion. If you use Azure Service Bus, you can use the `ReplyTo` and `CorrelationId` properties to correlate responses to requests.

- **Push notifications through events.** The background task publishes an event when it completes, or at key milestones. The caller subscribes to those events. This approach suits [Azure Event Grid](/azure/event-grid/overview) for cloud-native event routing, or a publish-and-subscribe mechanism like Service Bus topics.

- **Call back to the caller through a webhook.** The caller provides a callback URL when it submits the job. The background task sends an HTTP request to that URL when processing completes or when errors occur. This approach is useful when the caller is an external system.

- **Write status to shared storage.** The background task writes progress or results to a shared data store, like a database or blob, that the caller monitors. This approach is straightforward but requires the caller to poll for changes.

## Design for idempotency

Background jobs are especially prone to running more than once for the same logical work item. Queues deliver messages at least once, schedulers can overlap if a job runs longer than the timer interval, and infrastructure restarts can replay partially completed work. Design every background job so that the same input produces the same outcome when the job runs multiple times. For more information, see [Idempotent message processing](../reference-architectures/containers/aks-mission-critical/mission-critical-data-platform.md#idempotent-message-processing).

## Hosting environment

You can host background tasks by using a diverse range of Azure platform services:

- **[Azure Functions](#functions):** A serverless compute service that supports event-driven and schedule-driven triggers with automatic scaling. Use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) for long-running or stateful workflows.

- **[Azure Container Apps](#container-apps):** A serverless container platform that supports both long-running services and discrete [jobs](/azure/container-apps/jobs). Jobs run to completion, and you can trigger them manually, on a schedule, or by events. Container Apps uses [KEDA](https://keda.sh/) for event-driven autoscaling, including scale to zero.

- **[Azure Kubernetes Service (AKS)](#aks):** A managed Kubernetes environment that provides full control over container orchestration. Use Kubernetes [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) and [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) for background processing when you need direct access to the Kubernetes API and control plane.

- **[Azure Batch](#batch):** A platform service that schedules compute-intensive work to run on a managed collection of VMs. It can automatically scale compute resources across tens, hundreds, or thousands of nodes.

- **[Azure Virtual Machines](#virtual-machines):** An infrastructure as a service (IaaS) option for background tasks that require full control over the operating system or runtime environment, like Windows services, external executables, or specialized runtimes.

- **[Azure App Service WebJobs](#app-service-webjobs):** A feature of App Service that runs background scripts or programs in the same context as a web app. Consider WebJobs when you need background processing that's colocated with an existing App Service application.

The following sections describe these options in more detail and include considerations to help you choose the suitable option.

### Functions

Functions is a serverless compute service that runs event-driven code. Functions suits background jobs because it supports diverse types of [triggers](/azure/azure-functions/functions-triggers-bindings), including queue messages, blob storage changes, timer schedules, HTTP requests, and Event Grid events.

For short-duration background tasks, Functions provides automatic scaling (including scale to zero) and pay-per-execution billing. For long-running or stateful workflows, use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview), which extends Functions with orchestration capabilities.

Durable Functions supports several orchestration patterns that directly apply to background job coordination:

- **Function chaining:** Run a sequence of functions in a specific order, which passes the output of each step to the next.

- **Fan-out/fan-in:** Run multiple functions in parallel and then aggregate the results.

- **Async HTTP APIs:** Coordinate long-running operations with external clients by using a polling endpoint or webhook callback.

- **Human interaction:** Pause an orchestration until it receives an external event (like an approval), with optional timeout-based escalation.

- **Monitor:** Implement a recurring process that polls for a condition, with configurable intervals and timeouts.

#### Functions considerations

- Choose a [hosting plan](/azure/azure-functions/functions-scale) based on your workload characteristics:

  - **Flex Consumption plan:** Best for background jobs that are intermittent or unpredictable in volume. Scales to zero when there's no work and scales up under load, with per-execution billing. The default function timeout is 30 minutes with no enforced maximum, so the plan handles both short tasks and longer processing. Supports virtual network integration and [always ready instances](/azure/azure-functions/flex-consumption-plan#always-ready-instances) to reduce cold-start latency.

  - **Premium plan:** Suits high-throughput workloads that run continuously or near-continuously. Provides prewarmed instances to avoid cold starts, virtual network integration, and longer run times.

  - **Dedicated (App Service) plan:** Run functions on existing App Service infrastructure. This option is suitable when you have underutilized App Service capacity and want to share compute costs.

- Durable Functions maintains orchestration state automatically through checkpointing. If a function app restarts, the orchestration resumes from its last checkpoint. Design activity functions to be [idempotent](/azure/azure-functions/durable/durable-functions-perf-and-scale) so that retries don't produce duplicate side effects. You can also use [timer triggers](/azure/azure-functions/functions-bindings-timer) to run functions on a schedule without an external event source.

### Container Apps

Container Apps supports background processing through [Container Apps jobs](/azure/container-apps/jobs), which run containerized tasks to completion and then stop. Jobs suit batch processing, scheduled tasks, and event-driven work in which a short-lived process handles a discrete unit of work. For a general overview of the platform, see [Container Apps overview](/azure/container-apps/overview).

Container Apps jobs support three trigger types:

- **Manual jobs:** You trigger these jobs on demand through the Azure CLI, the Azure portal, or the Azure Resource Manager API. Use manual jobs for one-time tasks like data migrations or on-demand processing that an application initiates.

- **Scheduled jobs:** A CRON expression triggers these jobs at specific times. Use scheduled jobs for nightly reports, periodic data cleanup, or recurring data processing.

- **Event-driven jobs:** Events like a message that arrives in a queue trigger these jobs. Container Apps uses [KEDA](https://keda.sh) to monitor event sources and scale job runs based on configured rules. Event-driven jobs can scale to zero when there are no events to process. For more information, see [Deploy an event-driven job](/azure/container-apps/tutorial-event-driven-jobs).

For background tasks that run continuously, like a service that constantly processes messages from a queue, deploy a container app instead of a job. Container apps restart automatically on failure and support [scaling rules](/azure/container-apps/scale-app) based on queue length or other metrics.

#### Container Apps considerations

- Container Apps jobs require you to build and maintain container images. This approach adds overhead compared to Functions, but it gives you full control over the runtime, dependencies, and operating system-level tooling that your job needs.

- For event-driven jobs, verify that a [KEDA scaler](https://keda.sh/docs/scalers/) supports your event source. KEDA supports Service Bus, Azure Storage Queues, Apache Kafka, RabbitMQ, and other sources.

- If you need direct access to the Kubernetes APIs and control plane, use [AKS](/azure/aks/what-is-aks) instead.

### AKS

Use AKS when your background jobs require direct access to the Kubernetes API, custom scheduling logic, or integration with a broader Kubernetes-based platform that your team operates.

Use Kubernetes [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) for scheduled background tasks and [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) for one-time run-to-completion work. You can also use [KEDA](https://keda.sh) with AKS for event-driven autoscaling of job processors.

#### AKS considerations

AKS requires operational investment in cluster management, upgrades, and security patching. If you don't need direct Kubernetes API access, [Container Apps jobs](#container-apps) provide a managed alternative with less overhead.

### Batch

Consider [Batch](/azure/batch/batch-technical-overview) if you need to run large, parallel high-performance computing (HPC) workloads across tens, hundreds, or thousands of VMs.

The Batch service provisions the VMs, assigns tasks to the VMs, runs the tasks, and monitors the progress. Batch can automatically scale out the VMs in response to the workload. Batch also provides job scheduling. Batch supports both Linux and Windows VMs.

#### Batch considerations

Batch works well with intrinsically parallel workloads. It can also perform parallel calculations with a reduce step at the end, or run [message passing interface (MPI) applications](/azure/batch/batch-mpi) for parallel tasks that require message passing between nodes.

A Batch job runs on a pool of nodes (VMs). One approach is to allocate a pool only when needed and then delete it after the job completes. This approach maximizes utilization because nodes aren't idle, but the job must wait for Batch to allocate nodes. Alternatively, you can create a pool ahead of time. That approach minimizes the time that it takes for a job to start but can result in idle nodes. For more information, see [Pool and compute node lifetime](/azure/batch/nodes-and-pools#pool-and-compute-node-lifetime). For broader HPC guidance, see [Batch and HPC solutions for large-scale computing workloads](../guide/compute/high-performance-computing.md).

### Virtual Machines

Background tasks might require a full operating system environment or specific runtime dependencies that prevent them from using platform or serverless services. Typical examples include Windows services, executables, and programs written for specialized runtimes. You can choose from a range of operating systems for an Azure VM and run your service or executable on that VM.

To initiate the background task in a separate VM, you have several options:

- You can run the task on demand directly from your application by sending a request to an endpoint that the task exposes. This request passes in any data that the task requires. The endpoint invokes the task.

- You can set up the task to run on a schedule by using a scheduler or timer available in your chosen operating system. For example, on Windows you can use Windows Task Scheduler to run scripts and tasks. Or if you have SQL Server installed on the VM, you can use the SQL Server Agent to run scripts and tasks.

- You can use Logic Apps to initiate the task by adding a message to a queue that the task listens on, or by sending a request to an API that the task exposes.

For more information about how to initiate background tasks, see [Triggers](#triggers).

#### Virtual Machines considerations

Consider the following points when you deploy background tasks in an Azure VM:

- Hosting background tasks in a separate [Azure VM](/azure/virtual-machines/linux/faq) provides flexibility and precise control over initiation, processing, scheduling, and resource allocation. But this approach increases runtime cost if a VM must be deployed solely to run background tasks. To evaluate whether a VM is the right compute model, see [Choose an Azure compute service](../guide/technology-choices/compute-decision-tree.md).

- The Azure portal has no built-in facility to monitor individual tasks and no automated restart capability for failed tasks. You can monitor the basic status of the VM and manage it by using [Azure PowerShell cmdlets](/powershell/azure/get-started-azureps), but you need to implement your own mechanisms to collect instrumentation data from the task and operating system. Use the [Azure Monitor Agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) to collect logs and metrics from the VM.

- Create monitoring probes exposed through HTTP endpoints. The code for these probes should perform health checks, collect operational information and statistics, or collate error information and return it to a management application. For more information, see the [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml).

### App Service WebJobs

Azure [WebJobs](/azure/app-service/webjobs-create) is a feature of App Service that runs background scripts or programs in the same instance as a web app. WebJobs run within the sandbox of the web app, which means that they can access environment variables, connection strings, and other configuration shared with the app. You can use the [Azure WebJobs SDK](/azure/app-service/webjobs-sdk-get-started) to simplify the code that you write for common background processing tasks.

Consider WebJobs when you have an existing App Service web app and you need background processing that shares the same life cycle, configuration, and deployment as the web app. We don't recommend WebJobs as a general-purpose background job platform for new workloads. For new event-driven or scheduled background processing, evaluate [Functions](#functions) or [Container Apps jobs](#container-apps).

WebJobs can run as continuous or triggered processes:

- **Run continuously:** The WebJob starts immediately and runs as a long-running process. The script or program is stored in `site/wwwroot/app_data/jobs/continuous`.

- **Run on a schedule or on demand:** A schedule via a CRON expression or a manual action triggers the WebJob. The script or program is stored in `site/wwwroot/app_data/jobs/triggered`.

#### App Service WebJobs considerations

- By default, WebJobs scale with the web app. You can set up a job to run as a single instance by setting the `is_singleton` configuration property to `true`. Single-instance WebJobs suit tasks that you don't want to run as simultaneous multiple instances, like reindexing or data analysis.

- To reduce job impact on web app performance, consider creating an empty Azure web app instance in a separate App Service plan to host long-running or resource-intensive WebJobs.

- WebJobs share compute resources with the host web app. Resource-intensive background processing can degrade the responsiveness of the web app.

## Partitioning

If you decide to include background tasks within an existing compute instance, consider how this approach affects the quality attributes of the compute instance and the background task itself. These factors help you decide whether to colocate the tasks with the existing compute instance or separate them into a dedicated compute instance:

- **Availability:** Background tasks often tolerate brief outages better than the UI because pending work can be queued. But if the queue backs up because background processing is unavailable for too long, the application is affected.

- **Recovery:** If a compute instance that only hosts background tasks fails, the application can continue to serve users as long as pending work is queued. When the instance recovers, it processes the backlog.

- **Security:** Background tasks might need access to different resources, credentials, or network segments than the UI. Running them in a separate compute instance lets you apply a tighter security boundary, like restricting network access to a data store that the UI should never reach directly. You can also use patterns like [Gatekeeper](../patterns/gatekeeper.yml) to isolate background compute from user-facing components.

- **Manageability:** Background tasks often change on a different release cadence than the UI. Separating tasks avoids redeploying the entire application when only the job logic changes.

- **Scalability:** Background tasks typically scale on different signals than the UI. Background systems scale based on queue depth or batch size, while the UI scales based on concurrent users or request rate. Separating them lets each task scale independently.

Separating background tasks into dedicated compute adds hosting cost. Compare that cost to the operational benefits of independent scaling, deployment, and failure isolation.

## Conflicts

If you have multiple instances of a background job, they might compete for access to resources and services, like databases and storage. This concurrent access can result in resource contention, which can affect service availability and data integrity. You can resolve resource contention by using a pessimistic locking approach. This approach prevents competing instances of a task from concurrently accessing a service or corrupting data.

Another approach resolves conflicts by defining background tasks as a singleton, so that only one instance runs. But this approach eliminates the reliability and performance benefits of a multiple-instance configuration. This effect is especially true if the UI can supply sufficient work to keep more than one background task busy.

Ensure that the background task can restart automatically and has sufficient capacity to handle peaks in demand. To achieve this result, allocate a compute instance with sufficient resources, implement a queueing mechanism that stores requests for later processing when demand decreases, or combine both techniques.

## Coordination

Background tasks can be complex and require multiple individual tasks to produce a result or fulfill all requirements. In these scenarios, teams often divide the task into smaller, discrete steps or subtasks that multiple consumers can run. Multistep jobs often increase efficiency and flexibility because multiple jobs can reuse individual steps. You can also add, remove, or reorder the steps.

It can be challenging to coordinate tasks, but three common patterns can guide your implementation:

- **Divide a task into multiple reusable steps.** A background job processes information through several stages like validate, transform, and store. You can divide this flow into discrete filters connected by queues. Each step runs independently and can scale or be used in different jobs. For more information, see the [Pipes and Filters pattern](../patterns/pipes-and-filters.yml).

- **Manage how the steps run for a task.** A background job composed of several steps that call remote services or access remote resources needs orchestration logic to sequence the steps, handle timeouts, and track progress. For more information, see [Scheduler Agent Supervisor pattern](../patterns/scheduler-agent-supervisor.yml).

- **Manage recovery for task steps that fail.** A background job that spans multiple steps (which together define an eventually consistent operation) might need to undo completed work if a later step fails. For more information, see the [Compensating Transaction pattern](../patterns/compensating-transaction.yml).

## Reliability considerations

Background tasks must be resilient and recoverable to provide reliable services to the application. When you plan and design background tasks, consider the following points:

- Background tasks must gracefully handle restarts without corrupting data or introducing inconsistency into the application. For long-running or multistep tasks, consider using *checkpointing* by saving job state in persistent storage or in queue messages when suitable. For example, you can persist state information in a queue message and update this state incrementally with task progress so that the task resumes from the last known good checkpoint instead of restarting from the beginning. When you use Service Bus queues, you can use [message sessions](/azure/service-bus-messaging/message-sessions) to save and retrieve application processing state. For more information about designing reliable multistep processes and workflows, see the [Scheduler Agent Supervisor pattern](../patterns/scheduler-agent-supervisor.yml).

- Design background tasks to shut down gracefully when the hosting platform signals termination. Deployments, scale-in events, and platform maintenance can stop a running instance at any time. When a background task receives a termination signal while it runs (like `SIGTERM` in containers), it should stop accepting new work, finish or checkpoint the current work item, and exit cleanly. For queue-driven tasks, graceful shutdown means to complete the current message before the process exits so that the message isn't redelivered unnecessarily. If the task can't finish in time, it should checkpoint its progress or let the message visibility timeout expire so that another instance processes the work.

  Set up the platform's shutdown grace period long enough for your typical work item to complete. In Kubernetes, set `terminationGracePeriodSeconds` on the pod spec. In Functions Flex Consumption and Premium plans, the platform automatically provides up to 60 minutes for in-progress work to complete during [scale-in](/azure/azure-functions/event-driven-scaling#scale-in-behaviors).

- When you use queues to communicate with background tasks, queues can function as a buffer to store requests while the application is under higher than usual load. This design lets tasks catch up with the UI during less busy periods. It also means that restarts don't block the UI. For more information, see the [Queue-Based Load Leveling pattern](../patterns/queue-based-load-leveling.yml). If some tasks are more important than others, consider implementing the [Priority Queue pattern](../patterns/priority-queue.yml) to ensure that these tasks run before less important tasks.

- Background tasks that messages initiate or that process messages must handle inconsistencies, like messages that arrive out of order, messages that repeatedly cause an error (often known as *poison messages*), and messages that are delivered more than once. Consider the following factors:

  - Messages that require ordered processing, like updates that depend on the current data value, might not be delivered in the order that they were sent. Alternatively, different instances of a background task might also handle them in a different order because of varying loads on each instance. Messages that must be processed in a specific order should include a sequence number, key, or another indicator that background tasks can use to ensure correct processing order. If you use Service Bus, you can use message sessions to guarantee the order of delivery. But it's often more efficient, when possible, to design the process so that the message order doesn't matter.

  - A background task typically peeks at messages in the queue, which temporarily hides them from other message consumers. After the task successfully processes a message, it deletes it. If a background task fails when it processes a message, that message reappears on the queue after the peek timeout expires. Another instance of the task or the next processing cycle of this instance then processes it. If the message consistently causes an error in the consumer, it blocks the task, the queue, and eventually the application when the queue becomes full. Detect and remove poison messages from the queue. If you use Service Bus, it can move messages that cause an error automatically, or you can move them manually to an associated [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues).

  - Queues are guaranteed *at least once* delivery mechanisms, which means that a message can be delivered more than once. If a background task fails after processing a message but before deleting it from the queue, the message becomes available for processing again. All message-driven background tasks must be idempotent. For more information, see [Design for idempotency](#design-for-idempotency).

- Distinguish transient failures from permanent failures in your job processor. When a background task fails to process a message, the queue redelivers it automatically. If the failure is transient, like a downstream timeout or a throttling response, redelivery works as intended. If the failure is permanent, like a malformed payload or missing referenced data, the message fails on every attempt. Set up your job processor to detect permanent failures and route those messages directly to a [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) instead of consuming retry attempts. The queue's max delivery count controls how many times the queue retries a message before moving it to the dead-letter queue automatically. For more information about handling transient conditions in your processing logic, see [Transient fault handling](transient-faults.md).

## Security considerations

Background jobs often run with broader access to data stores, APIs, and internal services than the user-facing application. When you plan security for background tasks, consider the following points:

- **Give least-privilege access to job processors.** A background job that reads from a queue and writes to a database should only have permission to do those two operations. Avoid reusing a broad application identity that also serves the UI or admin APIs. If a job processor is compromised, the scope of impact stays limited to its granted permissions.

- **Keep sensitive data out of message payloads.** Queue messages can be logged, dead-lettered, or inspected during debugging. Instead of placing sensitive data like personal information or credentials directly in a message, store the data in a protected data store and pass a reference identifier in the message that the job uses to retrieve the data.

## Observability considerations

Background jobs run without a user present, so failures are silent unless you actively monitor for them. When you plan observability for background tasks, consider the following points:

- **Track job completion, not only job start.** Log when a background job starts, completes, and fails. Include the job type, a correlation identifier that ties the job back to the triggering event or message, and the elapsed duration. Without completion tracking, a job that hangs or crashes silently appears to run normally.

- **Alert on missed schedules.** For schedule-driven tasks, monitor that each expected run occurs. If a scheduled job doesn't fire, there's no error to catch because nothing ran. Compare actual run times against the expected schedule and alert when a run is missing.

- **Monitor dead-letter queues.** Dead-lettered messages represent background work that didn't complete. Set up alerts on [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) depth and message age so that your operations team can investigate failures, fix the underlying problem, and resubmit messages. Without monitoring, failed work accumulates silently.

- **Measure queue wait time, not only processing time.** Business impact is determined by how long a message takes from enqueue to completion. For example, a job that processes in 2 seconds but sits in the queue for 30 minutes causes a 30-minute delay. Track enqueue-to-completion latency alongside per-job processing duration.

- **Correlate across job steps.** Multistep background jobs can span multiple services, queues, and compute instances. Propagate a correlation identifier through every step so that you can trace the full life cycle of a single work item in your logs and [distributed traces](/azure/azure-monitor/app/classic-api).

## Scaling and performance considerations

Background tasks must keep pace with the rate at which work arrives. If tasks fall behind, queues grow, latency increases, and downstream processes stall. When you plan scaling for background tasks, consider the following points:

- **Scale on queue depth, not on CPU alone.** For message-driven background tasks, the most useful scaling signal is how much work waits in the queue, not how busy the current instances are. Functions, Container Apps, and AKS (via [KEDA](https://keda.sh)) all support scaling based on queue length, topic subscription count, or other event-source metrics. This approach adds capacity when work accumulates and removes capacity when queues drain.

- **Use scale-to-zero for intermittent workloads.** If your background jobs run only at specific times, like nightly batch jobs or event-driven processing that has idle periods, use a hosting model that scales to zero when there's no work. Functions and Container Apps jobs can scale to zero, so you don't pay for idle compute.

- **Scale background tasks independently from the application.** Host background tasks in a separate compute service so that the UI and background processing scale on different signals. If you have multiple background task types that have different throughput characteristics, consider separating them so that each type can scale independently.

- **Scale the entire processing pipeline, not only compute.** More task instances don't help if the queue, database, or downstream API becomes the bottleneck. Identify throughput limits across the pipeline, including messaging throughput units, database request units, and API rate limits. Scale those resources alongside your compute.

- **Enforce single-instance execution when required.** Some scheduled background tasks must not run concurrently, like database maintenance or report generation that isn't idempotent. Functions timer triggers use a [distributed lock](/azure/azure-functions/functions-bindings-timer#usage) to ensure that only one instance runs. For containers, use the Kubernetes CronJob `concurrencyPolicy: Forbid` setting or the Container Apps job-level concurrency settings.

## Next steps

- [Recommendations for developing background jobs](/azure/well-architected/design-guides/background-jobs)
- [Choose a messaging service](/azure/service-bus-messaging/compare-messaging-services)
- [Choose an Azure compute service](../guide/technology-choices/compute-decision-tree.md)

## Related resources

- [Queue-Based Load Leveling pattern](../patterns/queue-based-load-leveling.yml)
- [Priority Queue pattern](../patterns/priority-queue.yml)
- [Pipes and Filters pattern](../patterns/pipes-and-filters.yml)
- [Scheduler Agent Supervisor pattern](../patterns/scheduler-agent-supervisor.yml)
- [Compensating Transaction pattern](../patterns/compensating-transaction.yml)
- [Leader Election pattern](../patterns/leader-election.yml)
- [Competing Consumers pattern](../patterns/competing-consumers.md)
