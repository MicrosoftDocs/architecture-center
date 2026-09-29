---
title: Scheduler Agent Supervisor pattern
description: See how to coordinate a set of distributed actions as a single operation so the entire operation succeeds or fails as a whole.
ms.author: pnp
author: claytonsiemens77
ms.date: 06/12/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Scheduler Agent Supervisor pattern

Coordinate a set of distributed actions as a single logical operation so the operation as a whole either succeeds or fails. Handle failures transparently, or else undo completed work. This approach adds resilience to distributed systems by recovering from transient exceptions, longer-lasting faults, and process failures that interrupt multistep workflows orchestrated across remote services and resources.

## Context and problem

Applications often perform tasks that span multiple steps, and some steps might invoke remote services or access remote resources under the orchestration of application logic. Interaction with anything outside the local process exposes the task to a range of failure modes. The orchestrating logic must handle these failure modes without losing the integrity of the operation as a whole.

You can handle simple situations, like transient faults that resolve on their own, by using approaches like the [Retry pattern](./retry.yml). When faults are more permanent, or when the orchestrator itself fails, the system must restore a consistent state from durable records and ensure the integrity of the overall operation.

## Solution

The Scheduler Agent Supervisor pattern coordinates a multistep distributed task through three logical actors. These actors orchestrate the steps to be performed as part of the overall task, and handle both successful and failed runs.

### Scheduler

The *Scheduler* arranges the steps that make up the task and orchestrates their execution. The Scheduler is responsible for combining steps into a pipeline or workflow, and running them in the correct order. As each step progresses, the Scheduler records its state, such as *step not yet started*, *step running*, or *step completed*. The state also includes a *complete-by* time that limits how long the step is allowed to take.

When a step needs a remote service or resource, the Scheduler invokes an appropriate Agent and passes the work details to it. The Scheduler typically communicates with Agents through asynchronous request/response messaging, often implemented over queues. You can use other distributed messaging technologies instead.

> [!NOTE]
> The Scheduler performs a similar function to the Process Manager role in the [Process Manager pattern](https://www.enterpriseintegrationpatterns.com/patterns/messaging/ProcessManager.html). A workflow engine that the Scheduler controls typically defines and implements the workflow, decoupling the business workflow logic from the Scheduler itself.

### Agent

An *Agent* encapsulates a call to a remote service or access to a remote resource that a task step references. Each Agent typically wraps calls to a single service or resource and implements the appropriate error handling and retry logic within the complete-by time that the Scheduler imposes. When retry logic is involved, the Agent passes a stable identifier across all retry attempts. A downstream service can use this for deduplication.

If different steps in the workflow use different services or resources, each step can reference a different Agent. That mapping is an implementation detail of the pattern. For guidance on designing retry strategies, see [Best practices for transient fault handling](../best-practices/transient-faults.md).

### Supervisor

The *Supervisor* monitors the status of the steps that the Scheduler performs. The Supervisor runs periodically at a frequency the workload specifies, and examines the step state the Scheduler recorded. If the Supervisor finds steps that timed out or failed, it arranges for the appropriate Agent to recover the step, or it triggers another remedial action that might include modifying the step status. The Supervisor only requests these recovery actions. The Scheduler and Agents implement them.

### Interactions

The Scheduler, Agent, and Supervisor are logical components, and their physical implementation depends on the technology you use. For example, you might implement several logical Agents as part of a single web service or as activities inside the same hosted worker.

The Scheduler maintains task progress and per-step state in a durable data store called the *state store*. The Supervisor uses this information to determine whether a step failed. The following diagram shows the relationship between the Scheduler, the Agents, the Supervisor, and the state store.

:::image type="complex" source="./_images/scheduler-agent-supervisor-pattern.png" alt-text="Diagram that shows the Scheduler, Agents, and Supervisor interacting through a shared durable state store." lightbox="./_images/scheduler-agent-supervisor-pattern.png" border="false"
  At upper left, the Scheduler organizes and runs steps. A double-arrow line labeled "Scheduler requests Agent to access remote resource" goes to an Agent at right, and a double-arrow line labeled "Agent accesses remote resource or service" points from the Agent to a remote resource. Below that, double-arrow lines point from the Scheduler to another Agent and then to a remote service. Another double-arrow line labeled "Scheduler maintains step status" goes down to the state store. A double-arrow line labeled "Supervisor monitors step status" connects the state store and the Supervisor to its right. An arrow labeled "Supervisor requests step reattempt" points from the Supervisor back up and left to the Scheduler.
:::image-end:::

- The Scheduler organizes and runs the steps that comprise the task as a workflow.
- A step in the workflow can send a request to an Agent to access a remote resource or invoke a remote service. Requests and responses are typically sent asynchronously.
- An Agent accesses the remote resource or service. The agent should include error handling and retry logic.
- The Scheduler maintains the status of each step in the state store as it starts and completes.
- The Supervisor monitors the status of steps in the state store, and might request update of a step status.
- The Supervisor requests the Scheduler to reattempt a failed step.

When the application is ready to run a task, it submits a request to the Scheduler. The Scheduler records initial state for the task and its steps, such as *step not yet started*, in the state store, and then starts running the operations the workflow defines. As the Scheduler starts each step, it updates the state of that step, such as *step running*, in the state store.

If a step references a remote service or resource, the Scheduler sends a message to the appropriate Agent. The message carries the information that the Agent needs to invoke the service or access the resource, along with the complete-by time and retry allowance for the operation.

An Agent can implement whatever retry logic is appropriate for its work, but if the Agent doesn't complete its work within the complete-by time, the Scheduler assumes that the operation failed and stops waiting for a response. The Agent must observe the deadline and must not start new side effects after time expires, although work already in progress might continue.

If the Agent completes its operation successfully, it returns a response to the Scheduler. The Scheduler updates the state, to *step completed* for example, and begins the next step. This process continues until the entire task is complete.

The Scheduler must ignore any late response, and the Agent must not attempt workflow recovery on its own. If the Agent itself fails, the Scheduler also doesn't receive a response. The status in the state store intentionally doesn't distinguish a step that times out from a step that fails.

When a step times out or fails, the state store record still shows the step as *running*, but with an expired complete-by time. The Supervisor scans for records in this condition and arranges recovery.

The Supervisor also needs to prevent the same step from retrying indefinitely. The Supervisor maintains a retry count for each step alongside the state information in the state store. If the count exceeds a predefined threshold, the Supervisor can be set to wait for an extended period before asking the Scheduler to retry the step, in case the underlying fault clears during that interval.

One possible Supervisor strategy is to extend the complete-by value and send a message to the Scheduler identifying the timed-out step, so the Scheduler can attempt it again. This design requires the step logic to be [idempotent](./idempotent-consumer.md), because the same work might be done more than once.

Alternatively, the Supervisor can ask the Scheduler to undo the entire task by triggering a [compensating transaction](./compensating-transaction.md). This approach depends on the Scheduler and Agents providing enough information to implement compensating operations for each step that already completed successfully. The compensation log needs ordering as well as durability, because compensating operations typically run in the reverse order of the steps that completed. A compensating operation that itself fails leaves the task in a state that's neither completed nor cleanly undone. The state store must be able to represent this condition so operators can locate and investigate it.

> [!NOTE]
> The Supervisor doesn't monitor the Scheduler and Agents and restart them if they fail. That role belongs to the hosting infrastructure. The Supervisor also doesn't need to know the business operations the Scheduler is running, including how to compensate if they fail. That knowledge belongs to the workflow logic the Scheduler runs. The Supervisor is responsible only for detecting that a step has failed and arranging either for the step to be repeated or for the entire task that contains the failed step to be undone.

In an actual implementation of this pattern, multiple instances of the Scheduler might run concurrently, each handling a subset of tasks. The system might also run multiple instances of each Agent, or multiple Supervisors. When more than one Supervisor is active, the Supervisors must coordinate so they don't compete to recover the same failed step or task. The [Leader Election pattern](./leader-election.yml) is one way to coordinate Supervisors.

The main benefit of this pattern is that the system remains resilient to both transient and unrecoverable failures, and you can build it to be self-healing. If an Agent or the Scheduler fails, you can start a new instance, and the Supervisor can arrange for the affected task to resume. If the Supervisor itself fails, another instance can take over where the previous one stopped. When the Supervisor runs on a schedule, a new instance starts automatically at the next interval. You can also replicate the state store for greater resilience.

## Problems and considerations

Consider the following points when deciding how to implement this pattern:

- **Implementation complexity.** This pattern is difficult to implement and requires thorough testing of every failure mode the system can experience. Plan for fault-injection testing along with functional testing.

- **Retry amplification.** Independent retry limits at the Agent, orchestration runtime, client library, messaging, and Supervisor layers multiply the number of calls to a failing dependency. Designate the Scheduler as the owner of a durable end-to-end retry budget, and configure or disable retries at the other layers so their combined maximum can't exceed the budget.

- **Admission control.** The pattern doesn't limit how much work can be in flight at once. Because the Scheduler is built to never lose work it accepts, a slow or failing downstream service produces a growing population of processing records rather than visible backpressure to the submitter. The submission path needs its own admission control, such as a bounded queue, a cap on concurrent in-flight tasks, or rejection of new submissions when the pending backlog crosses a threshold. This backpressure helps ensure that a downstream incident doesn't silently cause an unbounded state-store backlog.

- **Recovery state durability.** The Scheduler recovery and retry logic is complex and depends on the state held in the state store. You might also need to record the information required to drive a compensating transaction in a durable store, and the compensating transaction itself can fail. Treat the state store and any compensating-transaction log as first-class durable assets. These assets must outlive the Scheduler, the Agents, and the Supervisor, and they must be recoverable independently of the workers that write to them.

  > [!IMPORTANT]  
  > The compensation log must inherit the data classification of the data it needs to track. If a step accepts customer or payment data, the compensating transaction log inherits that sensitivity and the accompanying retention rules.

- **Dual-write issue.** Submitting a task typically involves more than one durable write. For example, a task might need to write both an application record in a business database and an initial record in the state store. These writes don't share a transaction, so if only one write completes, an application record might have no state-store record or a state-store record might have no application record. The current pattern itself doesn't resolve this dual-write problem. Common solutions include writing inside a durable orchestration with a compensating delete on failure, applying the [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md), or using a stable identifier such as the application's own task ID to make each write safely repeatable.

- **Workflow and state versioning.** Long-running tasks can span deployments, so changes to workflow logic or persisted state can prevent replay, recovery, or compensation for in-flight work. Version both contracts, and retain compatible code and state handling until no active task depends on them.

- **Compensation outcomes.** A compensating transaction can complete, fail, or stall partway through. The state machine the Scheduler maintains needs to represent all of these states. If *Error* is the only terminal state, a stuck compensation looks identical to a step that failed before compensation ran, and operators lose the signal they need to intervene. Distinguish *compensation in progress*, *compensation completed*, and *compensation failed* in the state-store schema rather than collapsing them into a single *Error* state.

- **Supervisor cadence.** How often to run the Supervisor is a deliberate trade-off. It should run often enough that failed or timed-out steps don't block work for an extended period, but not so often that it becomes a source of load and cost against the state store. Tune the interval against the typical step duration and the acceptable detection delay for a stuck step, and revisit it as workflow volume grows.

- **Step idempotency.** An Agent might run a step more than once. For example, the Supervisor might extend the complete-by time and ask the Scheduler to retry a step whose original execution already produced an effect that the Scheduler never saw. Therefore, the logic that implements each step must be [idempotent](./idempotent-consumer.md).

- **Operational visibility.** The pattern's runtime behavior is in state-store transitions rather than in synchronous responses. Operators can see only what the state store and the workers emit. Decide what the Scheduler, Agents, and Supervisor should emit, and which thresholds should trigger alerts.

- **Scheduler restart and recovery.** If the Scheduler restarts after a failure, or the workflow the Scheduler is running terminates unexpectedly, the Scheduler must be able to determine the status of any task it was handling when it failed and resume the task from that point. The implementation details of this recovery are typically system-specific. For example, a Scheduler built on a checkpointed orchestration runtime can rely on the runtime to replay history and resume, whereas a custom Scheduler has to reconstruct in-flight state from the state store itself. If a task can't be recovered, the work already done for that task might need to be undone, which can require a [compensating transaction](./compensating-transaction.md).

## When to use this pattern

Use this pattern when:

- **A process runs in a distributed workload and must remain resilient** to both communication failures and operational failures across the services and resources it coordinates.

- **Background jobs orchestrate multistep workflows whose steps involve remote services or resources**, and the workflows as a whole must either complete or be undone cleanly. Common examples include order processing and resource provisioning. For more information, see [Best practices for background jobs](../best-practices/background-jobs.md).

This pattern might not be suitable when:

- **The task doesn't invoke remote services or access remote resources.** There's no distributed failure surface for the Scheduler, Agent, and Supervisor roles to mitigate. The pattern's coordination overhead adds cost with no resiliency benefit.

## Workload design

Evaluate how to use the Scheduler Agent Supervisor pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern uses a durable state store and a periodic Supervisor to detect steps that timed out or failed and to drive recovery.<br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy)<br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern separates the orchestration of long-running, multistep work from the Agents that perform the steps, so steps can be dispatched to Agents that have capacity. Higher-priority work can be scheduled ahead of lower-priority work when the implementation provides an explicit priority signal.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:09 Critical flows](/azure/well-architected/performance-efficiency/prioritize-critical-flows) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

This example deploys a web application that implements an ecommerce system on Microsoft Azure. Users browse products and place orders through a web front end, and the background workers in the order-processing path call a remote service that's prone to transient and longer-lasting faults. Order processing implements the Scheduler Agent Supervisor pattern by using [Durable Functions](/azure/durable-task/durable-functions/durable-functions-overview), [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview), and [Azure Cosmos DB](/azure/cosmos-db/overview).

A submission activity writes to the orders database and a Cosmos DB state store, a Durable Functions orchestrator claims pending state records and dispatches work to an Agent through a pair of Service Bus request and response queues, and a Supervisor scans the state store for expired `CompleteBy` times.

The following diagram shows a high-level view of the Azure solution.

:::image type="complex" source="./_images/scheduler-agent-supervisor-solution.png" alt-text="Diagram that shows the example ecommerce order-processing solution." lightbox="./_images/scheduler-agent-supervisor-solution.png" border="false"
  At upper left, an application instance icon points down to a submission process icon through a message queue. Arrows point from the submission process to an orders database at upper right and to a state store at lower right. A double arrow goes right and down from the orders database to the Scheduler, and a double arrow goes right and up from the state store to the Scheduler. An arrow points to the right from the Scheduler to an Agent through a message queue. A double arrow connects the Agent and a remote service to its right. An arrow points from the Agent back to the Scheduler through a message queue. A double arrow goes between the state store and the Supervisor to its right.
:::image-end:::

1. The application posts a request to a queue to handle the order.
1. The submission process retrieves requests, inserts order details in the orders database, and generates a record for the order in the state store.
1. The Scheduler looks for an order with `LockedBy` set to null in the state store, and workflow logic in the Scheduler handles the order.
1. The workflow logic sends requests to and receives responses from Agents through message queues.
1. Workflow tasks use Agents to invoke the remote service.
1. The Supervisor looks for orders with an expired `CompleteBy` value and updates this value to enable the Scheduler to reattempt the process.

### Submission

When a customer places an order, the web front end posts an order message to a Service Bus queue. A submission function receives the message in [PeekLock mode](/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock), inserts the order details into the orders database, and creates a state-store record for the order process.

Because the orders database and the database created with Azure Cosmos DB are different resources and don't share a transaction, the function treats each write as independently idempotent. The function uses the order ID as a stable key, creates either record when it's missing, and accepts an existing record only after verifying that its immutable order data matches the message. Conflicting data causes the function to dead-letter the message and alert an operator, rather than overwriting a record.

The record contains the following fields:

| Field | Description |
| ----- | ----------- |
| `OrderID` | The ID of the order in the orders database, used as the Azure Cosmos DB document ID and partition key.|
| `LockedBy` | The attempt-specific instance ID of the orchestration handling the order. Multiple Scheduler orchestrations might be running, but a conditional state transition allows only one active attempt to claim an order.|
| `CompleteBy` | The time by which the order must be processed.|
| `ProcessState` | The current state of the task handling the order. The possible states are:<br> - `Pending`: The order is created but processing hasn't started. <br> - `Processing`: The order is currently being processed. <br> - `Processed`: The order processed successfully. <br> - `Error`: Order processing failed.|
| `FailureCount` | The number of failed or timed-out processing attempts recorded for the order.|

When the submission activity first writes the record, it copies `OrderID` from the new order, sets `LockedBy` and `CompleteBy` to `null`, sets `ProcessState` to `Pending`, and sets `FailureCount` to `0`.

> [!NOTE]
> In this example, the order-handling logic is intentionally simple and has a single step that calls a remote service. In a more complex multistep scenario, the submission activity would create one state-store record per step, keeping `OrderID` as the partition key, but using a unique item ID such as `{OrderID}:{StepID}`, so the Scheduler and Supervisor can reason about each step's status independently.

### Scheduling

The Scheduler is a Durable Functions orchestrator. A starter function polls Azure Cosmos DB for records where `LockedBy` is null and `ProcessState` is `Pending`. The function creates an attempt-specific orchestration instance ID from `OrderID` and the next attempt number. A conditional update sets `ProcessState` to `Processing` and `LockedBy` to that instance ID before the starter schedules the orchestration. This claim prevents two starters from scheduling the same attempt.

Each update from the orchestration also verifies that `LockedBy` still matches its instance ID. This check prevents an expired attempt from changing the state of a replacement attempt. Cross-order parallelism comes from running many orchestration instances concurrently, not from parallelism inside one order. The orchestration sets `CompleteBy` and drives the workflow.

The orchestrator retrieves the order details from the orders database and runs the workflow as a sequence of activity functions. When a step needs the remote service, it invokes an Agent.

### Execution

The Agent can be an activity function when the work is short-lived and runs in the same function app, or it can be a separate worker reached over a Service Bus request/response queue pair when it runs in a different runtime or across a trust boundary. In both cases, the orchestrator races a [durable timer](/azure/durable-task/common/durable-task-timers) against the Agent response to detect the `CompleteBy` deadline.

When the Agent is reached over Service Bus, a queue-triggered function receives the response and uses the Durable Functions client to raise an external event that includes the orchestration instance ID and a stable event ID. The orchestrator deduplicates external events by enabling [duplicate detection](/azure/service-bus-messaging/duplicate-detection) and setting a stable `MessageId` on each request, so Service Bus can discard duplicates introduced by retries.

If the Agent receives a response from the remote service before the durable timer fires, the Agent returns the result to the orchestrator. The orchestrator completes the step and updates `ProcessState` to `Processed` only if `LockedBy` still identifies the current orchestration. If the timer fires first, the orchestrator treats the step as failed, stops waiting, and completes without changing the state record.

The Agent cooperatively stops starting new side effects after its own deadline, but work already in progress might continue. The state-store record then stays in the `Processing` state with an expired `CompleteBy` value, allowing the Supervisor to arrange recovery. Use idempotency or a target-enforced fencing token to prevent an overlapping attempt from duplicating or conflicting with a side effect.

If the Agent detects an unrecoverable, non-transient fault while contacting the remote service, it returns an error response to the orchestrator. The orchestrator sets `ProcessState` to `Error` and raises an event that alerts an operator, who can investigate the failure and resubmit the failed processing step.

### Supervision

The Supervisor periodically queries the Azure Cosmos DB state store for orders in `Processing` status with an expired `CompleteBy`. Because `OrderID` is the partition key, this query reaches every physical partition even when `ProcessState` and `CompleteBy` are indexed. The process bounds each scan by a `CompleteBy` time window, a maximum result count, and continuation-token paging, and monitors its request unit (RU) charge.

Larger workloads maintain a separate recovery index or queue that's partitioned for the Supervisor's access pattern. When the Supervisor finds an expired record, it uses a conditional update that verifies the expired `LockedBy` value before it increments `FailureCount`. If `FailureCount` is below a configured threshold, the Supervisor resets `LockedBy` to `null`, updates `CompleteBy` with a new expiration time, and sets `ProcessState` back to `Pending`, which allows the starter to schedule a new attempt. If `FailureCount` exceeds the threshold, the Supervisor treats the failure as non-transient, sets `ProcessState` to `Error`, and raises an event that alerts an operator.

> [!NOTE]
> The Supervisor is hosted as a [timer-triggered function](/azure/azure-functions/functions-bindings-timer) when the scan is short and lightweight, or as a [scheduled Azure Container Apps job](/azure/container-apps/jobs) when the scan needs a custom container image, longer-running execution, or sidecars. Both options run on a cron-style schedule and suit the periodic, short-lived work the Supervisor performs. The timer trigger uses a storage lock across scaled-out instances in one function app. Independent deployments or Container Apps jobs that can overlap use the conditional recovery claim described previously, or you can coordinate them through the [Leader Election pattern](./leader-election.yml).

### Status reporting

The orchestrator might also need to keep the application that submitted the order informed about progress and final status, which the diagram doesn't show. The application and the orchestrator are deliberately decoupled. The application doesn't know which orchestration instance is handling the order, and the orchestration doesn't know which application instance posted it. Because of this decoupling, the orchestrator can't return progress updates synchronously.

To report order status back, each submitting application supplies its own private, access-controlled Service Bus response queue. The request sent to the submission activity includes the identifier of that queue, which the submission activity records on the order's state-store record so the orchestrator can post to the right queue rather than broadcasting. The orchestrator then posts status messages such as *request received*, *order completed*, or *order failed* to that queue, including the `OrderID` so the application can correlate each message with the original request.

## Supporting technologies

Map the pattern's logical roles to services that fit your workflow and operational requirements:

- **Scheduler:** Use [Durable Functions](/azure/durable-task/durable-functions/durable-functions-overview) for code-first orchestration or [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) for visual workflows and connector-based integration.

- **Agent messaging:** Use [Service Bus](/azure/well-architected/service-guides/azure-service-bus) queues for asynchronous request and response messaging.

- **State store:** Use [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) for document state or [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) for relational state and cross-record transactions.

- **Supervisor:** Use a [Functions timer trigger](/azure/azure-functions/functions-bindings-timer) for lightweight scans or a [Container Apps job](/azure/well-architected/service-guides/azure-container-apps) when you need a container runtime.

- **Compensation log:** Store compensation records with task state or in [Azure Table storage](/azure/storage/tables/table-storage-overview) or [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage).

## Next steps

- [Choose between Azure Functions and Azure Logic Apps](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs) for workflow orchestration.
- [Version Durable Functions orchestrations](/azure/durable-task/common/durable-orchestration-versioning) to protect in-flight workflows during deployments.
- [Prevent message loss and duplicate processing in Azure Service Bus](/azure/service-bus-messaging/service-bus-message-loss-and-duplicates) by combining message settlement, idempotency, and dead-letter handling.

## Related resources

The following patterns might also be relevant when you implement this pattern:

- [Retry pattern](./retry.yml). An Agent can use this pattern to transparently retry an operation that accesses a remote service or resource and previously failed. Use it when the cause of the failure is expected to be transient and can be corrected by a retry.

- [Circuit Breaker pattern](./circuit-breaker.md). An Agent connecting to a remote service or resource can use this pattern to handle faults that take a variable amount of time to correct, so repeated calls don't pile up against a dependency that's unlikely to respond.

- [Compensating Transaction pattern](./compensating-transaction.md). If a Scheduler can't complete its workflow successfully, the work already performed might need to be undone. The Compensating Transaction pattern describes how to undo that work for operations that follow the eventual-consistency model, which is common in the long-running business processes a Scheduler coordinates.

- [Leader Election pattern](./leader-election.yml). When multiple Supervisor instances run concurrently, they must coordinate so they don't compete to recover the same failed step. The Leader Election pattern describes how to elect a single coordinator for that work.
