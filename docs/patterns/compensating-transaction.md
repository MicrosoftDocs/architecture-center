---
title: Compensating Transaction Pattern
description: Use the Compensating Transaction pattern to undo work when a step of an eventually consistent operation fails in distributed systems.
ms.author: pnp
author: claytonsiemens77
ms.date: 04/16/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Compensating Transaction pattern

Use this pattern to undo work when one or more steps fail in an eventually consistent operation. Cloud-hosted applications that implement complex business processes and workflows commonly use operations that follow the eventual consistency model.

## Context and problem

Cloud applications frequently modify data that is spread across various data sources in different geographic locations. To avoid contention and improve performance in a distributed environment, applications should implement eventual consistency instead of strong transactional consistency. In the eventual consistency model, a typical business operation consists of a series of separate steps. During these steps, the overall view of the system state might be inconsistent. But the system should become consistent again when all steps finish.

Handling step failures presents a key challenge in the eventual consistency model. After a failure, you might need to undo work from completed operation steps. However, you can't always roll back the data because other concurrent application instances might change the data. Even when concurrent instances don't change the data, it can be more complex to undo a step than to restore the original state. You might need to apply business-specific rules. For an example, see the [travel website example](#example).

When an operation that implements eventual consistency spans multiple data stores, you must access each data store to undo the changes. To prevent the system from remaining inconsistent, you must reliably undo the work in every data store.

An operation that implements eventual consistency doesn't always store its affected data in a database. For example, in a service-oriented architecture (SOA) environment, an operation can invoke an action in a service and change the state that the service holds. To undo the operation, you must also undo this state change, which can involve invoking the service again to reverse the first action's effects.

## Solution

Implement a compensating transaction that undoes the effects of completed steps in the original operation. You might think that you can simply restore the system to its original state, but this approach can overwrite changes from other concurrent application instances. Instead, the compensating transaction must intelligently account for concurrent work. This process is usually application specific and depends on the original operation.

You can use a workflow to implement an eventually consistent operation that requires compensation. As the original operation runs, the system records information about each step and how to undo it. If the operation fails, the workflow rewinds through the completed steps and reverses each step.

:::image type="complex" source="./_images/compensating-transaction.svg" alt-text="Diagram that shows the steps to create an itinerary and the steps of the compensating transaction that cancel the itinerary." border="false" lightbox="./_images/compensating-transaction.svg":::
Diagram that shows a workflow with forward steps and compensating actions. A user initiates an operation that runs step 1, step 2, and step 3 sequentially. If all steps succeed, the process completes. If a failure occurs after any step, compensating actions run in reverse order to undo completed work, which ends in a compensated state.
:::image-end:::

While each step is a separate action, together they form an eventually consistent operation. The system must perform the steps and the corresponding undo operations for each step. If the customer cancels, these undo operations can run as a compensating transaction.

A single-step failure doesn't always require you to roll back the entire system by using a compensating transaction. For example, in a travel website scenario, a customer books flights F1, F2, and F3 but fails to reserve a room at hotel H1. Offering the customer a room at a different hotel is preferable to canceling the flights. The customer can still choose to cancel, which triggers the compensating transaction to undo the flight bookings. However, the customer should make this decision, not the system. When decisions are high impact or hard to automate reliably, include a human in the decision-making process.

Consider these important points:

- A compensating transaction might not need to undo the work in the exact reverse order of the original operation.

- You might be able to perform some undo steps in parallel.

- You might need to apply business-specific rules. For example, canceling a flight reservation might not entitle the customer to a complete refund.

This approach is similar to the [Saga distributed transactions pattern](./saga.yml).

Compensating transactions are eventually consistent operations and can fail. The system should record progress so that it can resume the compensating transaction from the point of failure. A step might run multiple times when retried, so design each step as an [idempotent command](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing).

Sometimes manual intervention is the only way to recover from a failed step. In these situations, the system should raise an alert that includes detailed information about the reason for the failure.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- It might not be easy to determine when a step in an operation that implements eventual consistency fails. A step might not fail immediately but instead get blocked. You might need to implement a timeout mechanism.

- It's not easy to generalize compensation logic. A compensating transaction is application specific. It relies on the application having sufficient information to undo the effects of each step in a failed operation.

- Compensating transactions don't always work. Define the steps in a compensating transaction as idempotent commands so that you can repeat them if the compensating transaction itself fails.

- The infrastructure that handles the steps must meet the following criteria:

  - It's resilient in both the original operation and the compensating transaction.

  - It doesn't lose the information required to compensate for a failing step.

  - It reliably monitors compensation logic progress. Compensating transactions run after the original operations commit, and other transactions might change intermediate states. Therefore, ensure that you can correlate and audit both the original operation and its compensation end-to-end.

- A compensating transaction doesn't necessarily return the system data to its state at the start of the original operation. Instead, the transaction compensates for the work that the operation completes successfully before it failed.

- The compensating transaction steps don't always reverse the original operation in the exact opposite order. For example, if one data store is more sensitive to inconsistencies than another, undo changes to that store first.

- Some measures can help you improve success rates. You can place a short-term lock with a timeout on each resource that's required to complete an operation. You can acquire these resources in advance, and then perform work only after you acquire all resources. Finalize all actions before the locks expire.

- Retry logic that treats more errors as transient can help minimize failures that trigger a compensating transaction. When a step in an operation that implements eventual consistency fails, handle it as a transient exception and retry the step. Only stop the operation and trigger compensation if the step fails repeatedly or you can't recover it. For more information about retry strategies, see [Transient fault handling](../best-practices/transient-faults.md).

- When you implement a compensating transaction, you face many challenges similar to implementing eventual consistency. For more information, see [Minimize coordination](../guide/design-principles/minimize-coordination.yml).

- Define clear *points of no return* and irreversible steps. In complex workflows, you can't safely or meaningfully undo some operations, such as external side effects or legally binding actions. Identify compensable versus irreversible steps. Design the workflow so that irreversible steps occur only after all critical validations succeed.

## When to use this pattern

Use this pattern when:

- A business operation spans multiple steps, services, or data stores and must be undone if a later step fails. This scenario often occurs in long‑running workflows that follow an eventual consistency model and can't rely on atomic transactions.

- Failure recovery often requires domain-specific logic rather than a simple data rollback. Use compensating actions when undoing work requires you to apply business rules, such as canceling reservations or issuing partial refunds.

This pattern might not be suitable when:

- Operations can be safely retried and most failures are transient. Retry logic alone is often sufficient in these cases, and compensating transactions add unnecessary complexity.

- The system can't tolerate temporary inconsistency, or compensation can't reliably restore a valid state. Use strong consistency mechanisms or atomic transactions across all steps instead.

## Workload design

Evaluate how to use the Compensating Transaction in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | Compensation actions address malfunctions in critical workload paths by using processes like directly rolling back data changes, breaking transaction locks, or even running native system behavior to reverse the effect. <br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:09 Disaster recovery](/azure/well-architected/reliability/disaster-recovery) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following diagram shows a practical Azure implementation of the Compensating Transaction pattern. Other implementations might also work for your workload requirements. An orchestrator that runs in Azure Container Apps coordinates each step of a long-running workflow by sending commands through Azure Service Bus. As each forward step succeeds, the orchestrator records both execution state and the corresponding compensating action in Azure Cosmos DB so that the workflow can be resumed, correlated, and audited.

:::image type="complex" source="./_images/compensating-transaction-azure.svg" alt-text="Diagram that shows an Azure implementation of the Compensating Transaction pattern." border="false" lightbox="./_images/compensating-transaction-azure.svg":::
Diagram that shows a workflow in an Azure Container Apps environment. A client sends a request to an orchestrator container, which coordinates Service A and Service B and records operations. Step 1 and step 2 messages flow through Service Bus. If a step fails, compensating actions run in reverse order. Failed messages move to a dead-letter queue. The environment integrates with Microsoft Entra ID for identity and Application Insights and Azure Monitor for observability.
:::image-end:::

This model uses retries first to preserve forward progress. If a step fails, the orchestrator applies retry logic for transient faults and attempts to continue the original operation. Compensation is invoked only when forward progress becomes impossible, such as when retries are exhausted or the failure is classified as nontransient.

Business-specific rules can also prefer forward progress over immediate compensation. If a step fails, the orchestrator can select an alternative path, such as substituting an equivalent service or fallback option, instead of rolling back the workflow. For high-impact or ambiguous cases, you can pause the workflow for human review before you decide whether to continue on an alternative path or trigger compensation. This approach treats compensation as a last resort and lets domain rules drive recovery decisions.

In a typical sequence, the orchestrator sends step messages through Service Bus (steps 1 and 2), receives successful outcomes, and stores forward and compensation metadata in Azure Cosmos DB.

You can trigger compensation in two ways:

- When a later step in the same workload fails and you must undo previously successful steps. This compensation can happen immediately when a step returns a business error such as a rule-validation failure or after technical retries are exhausted and the message is moved to the dead-letter queue.

- When a subsequent client explicitly requests to cancel a completed operation.

In either case, the orchestrator reads the stored compensation records and sends compensation commands to the corresponding service. If a compensation step fails transiently, Service Bus retries can complete it without escalating the incident.

If repeated retries still fail, Service Bus moves the message to a dead-letter queue and preserves failure details. The orchestrator, or a dedicated dead-letter processor, raises an alert and emits structured telemetry, including failure reason and correlation IDs, to Azure Monitor and Log Analytics, which can surface in Application Insights. This operational path helps teams diagnose failures, determine the need for manual intervention, and maintain traceability across both the original and compensating flows.

The workflow can start compensation automatically for clear, low-risk conditions or pause for human review when the situation is ambiguous, high impact, or requires a manual decision.

Use managed identities and Microsoft Entra ID-based authorization between components to avoid shared secrets and enforce least-privilege access. When you create a simplified reference diagram, treat these identity and authorization controls as baseline implementation concerns rather than explicit flow steps. Keep the diagram focused on orchestration, retry, compensation, and failure handling.

## Related resources

- [Data considerations for microservices](../microservices/design/data-considerations.md): Learn why eventual consistency and partial failure are inherent in distributed systems. The Compensating Transaction pattern provides a concrete mechanism to handle those failures when operations span multiple services.

- [Transactional Outbox pattern with Azure Cosmos DB](../databases/guide/transactional-out-box-cosmos.md): Use this pattern when compensating transactions need to publish events or commands reliably. It helps ensure that state changes and messages are recorded atomically, which prevents message loss.

- [Design for self-healing](../guide/design-principles/self-healing.md): Use compensating transactions as part of a self-healing approach for your applications.

- [Scheduler Agent Supervisor pattern](./scheduler-agent-supervisor.yml): Use this pattern to implement resilient systems that perform business operations across distributed services and resources. These systems sometimes need compensating transactions to undo work.

- [Retry pattern](./retry.yml): Use this pattern to handle transient failures and minimize the need for compensating transactions.

- [Saga distributed transactions pattern](./saga.yml): Use this pattern to manage data consistency across microservices in distributed transactions. Saga uses compensating transactions for failure recovery.

- [Pipes and Filters pattern](./pipes-and-filters.yml): Use this pattern with the Compensating Transaction pattern as an alternative to distributed transactions when you decompose complex tasks into reusable steps.
