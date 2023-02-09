If you have a series of steps that together define an eventually consistent operation, the Compensating Transaction pattern can be useful. Specifically, if one or more of the steps fail, you can use the Compensating Transaction pattern to undo the work performed by the steps. You can typically find operations that follow the eventual consistency model in cloud-hosted applications that implement complex business processes and workflows.

## Context and problem

Applications that run in the cloud frequently modify data. This data might be spread across various data sources in different geographic locations. To avoid contention and improve performance in a distributed environment, an application shouldn't try to provide strong transactional consistency. Rather, the application should implement eventual consistency. In the eventual consistency model, a typical business operation consists of a series of separate steps. While these steps are being performed, the overall view of the system state might be inconsistent. But when the operation finishes and all the steps have run, the system should become consistent again.

The [Data Consistency Primer](/previous-versions/msp-n-p/dn589800(v=pandp.10)) provides information about why distributed transactions don't scale well. This resource also lists principles of the eventual consistency model.

A challenge in the eventual consistency model is how to handle a step that fails. In this case, you might need to undo all the work completed by the previous steps in the operation. However, the data can't simply be rolled back, because other concurrent instances of the application might have changed it. Even in cases where the data hasn't been changed by a concurrent instance, undoing a step might not simply be a matter of restoring the original state. It might be necessary to apply various business-specific rules. For an example, see the travel website that the [Example](#example) section describes, later in this article.

If an operation that implements eventual consistency spans several heterogeneous data stores, undoing the steps in the operation requires visiting each data store in turn. The work performed in every data store must be undone reliably to prevent the system from remaining inconsistent.

The data affected by an operation that implements eventual consistency isn't always held in a database. In a service-oriented architecture (SOA) environment, an operation can invoke an action in a service and cause a change in the state held by that service. To undo the operation, this state change must also be undone. This process can involve invoking the service again and performing another action that reverses the effects of the first.

## Solution

The solution is to implement a compensating transaction. The steps in a compensating transaction undo the effects of the steps in the original operation. A likely approach is to replace the current state with the state the system was in at the start of the operation. But a compensating transaction can't always take that approach, because it might overwrite changes made by other concurrent instances of an application. Instead, a compensating transaction must be an intelligent process that takes into account any work done by concurrent instances. This process is usually application-specific, driven by the nature of the work performed by the original operation.

A common approach is to use a workflow to implement an eventually consistent operation that requires compensation. As the original operation proceeds, the system records information about each step, including how the work performed by that step can be undone. If the operation fails at any point, the workflow rewinds back through the steps it has completed. At each step, the workflow performs the work that reverses that step. Two important points are:

- A compensating transaction might not have to undo the work in the exact reverse order of the original operation.
- It might be possible to perform some of the undo steps in parallel.

This approach is similar to the Sagas strategy discussed in [Clemens Vasters' blog](https://vasters.com/archive/Sagas.html).

A compensating transaction is also an eventually consistent operation, so it can also fail. The system should be able to resume the compensating transaction at the point of failure and continue. It might be necessary to repeat a step that fails, so the steps in a compensating transaction should be defined as idempotent commands. For more information, see [Idempotency Patterns](https://blog.jonathanoliver.com/idempotency-patterns/) on Jonathan Oliver's blog.

In some cases, manual intervention might be the only way to recover from a step that has failed. In these situations, the system should raise an alert and provide as much information as possible about the reason for the failure.

## Issues and considerations

Consider the following points when you decide how to implement this pattern:

It might not be easy to determine when a step in an operation that implements eventual consistency has failed. A step might not fail immediately. Instead, it might get blocked. You might need to implement a time-out mechanism.

Compensation logic isn't easily generalized. A compensating transaction is application-specific. It relies on the application having sufficient information to be able to undo the effects of each step in a failed operation.

Define the steps in a compensating transaction as idempotent commands. Then the steps can be repeated if the compensating transaction itself fails.

The infrastructure that handles the steps must be resilient in the original operation and in the compensating transaction. That infrastructure must not lose the information that's required to compensate for a failing step. The infrastructure also must be able to reliably monitor the progress of the compensation logic.

A compensating transaction doesn't necessarily return the data in the system to the state it was in at the start of the original operation. Instead, it compensates for the work performed by the steps that finished successfully before the operation failed.

The order of the steps in the compensating transaction doesn't necessarily have to be the exact opposite of the steps in the original operation. For example, one data store might be more sensitive to inconsistencies than another. The steps in the compensating transaction that undo the changes to this store should occur first.

There are measures you can take to help increase the likelihood that the overall activity succeeds. Specifically, you can place a short-term timeout-based lock on each resource that's required to complete an operation. You can also obtain these resources in advance. Then perform the work only after you've acquired all the resources. Finalize all actions before the locks expire.

Consider using retry logic that's more forgiving than usual to minimize failures that trigger a compensating transaction. If a step in an operation that implements eventual consistency fails, try handling the failure as a transient exception and repeating the step. Only stop the operation and initiate a compensating transaction if a step fails repeatedly or can't be recovered.

Many challenges with implementing a compensating transaction are the same as those with implementing eventual consistency. For more information, see the "Considerations for Implementing Eventual Consistency" section in [Data Consistency Primer](/previous-versions/msp-n-p/dn589800(v=pandp.10)).

## When to use this pattern

Use this pattern only for operations that must be undone if they fail. If possible, design solutions to avoid the complexity of requiring compensating transactions.

## Example

A travel website lets customers book itineraries. A single itinerary might comprise a series of flights and hotels. A customer who travels from Seattle to London and then on to Paris might perform the following steps when creating an itinerary:

1. Book a seat on flight F1 from Seattle to London.
1. Book a seat on flight F2 from London to Paris.
1. Book a seat on flight F3 from Paris to Seattle.
1. Reserve a room at hotel H1 in London.
1. Reserve a room at hotel H2 in Paris.

These steps constitute an eventually consistent operation, although each step is a separate action. Besides performing these steps, the system must also record the counter operations for undoing each step. This information is needed in case the customer cancels the itinerary. The steps necessary to perform the counter operations can then run as a compensating transaction.

The steps in the compensating transaction might not be the exact opposite of the original steps. Also, the logic in each step in the compensating transaction must take business-specific rules into account. For example, unbooking a seat on a flight might not entitle the customer to a complete refund of any money paid. The following figure illustrates generating a compensating transaction to undo a long-running transaction to book a travel itinerary.

![Generating a compensating transaction to undo a long-running transaction to book a travel itinerary](./_images/compensating-transaction-diagram.png)

> [!NOTE]
> It might be possible for the steps in the compensating transaction to be performed in parallel, depending on how you've designed the compensating logic for each step.

In many business solutions, failure of a single step doesn't always necessitate rolling back the system by using a compensating transaction. For example, if&mdash;after having booked flights F1, F2, and F3 in the travel website scenario&mdash;the customer is unable to reserve a room at hotel H1, it's preferable to offer the customer a room at a different hotel in the same city rather than canceling the flights. The customer can still decide to cancel (in which case the compensating transaction runs and undoes the bookings made on flights F1, F2, and F3), but this decision should be made by the customer rather than by the system.

## Related resources

The following patterns and guidance might also be relevant when implementing this pattern:

- [Data Consistency Primer](/previous-versions/msp-n-p/dn589800(v=pandp.10)). The Compensating Transaction pattern is often used to undo operations that implement the eventual consistency model. This primer provides information on the benefits and tradeoffs of eventual consistency.

- [Scheduler-Agent-Supervisor pattern](./scheduler-agent-supervisor.yml). Describes how to implement resilient systems that perform business operations that use distributed services and resources. Sometimes, it might be necessary to undo the work performed by an operation by using a compensating transaction.

- [Retry pattern](./retry.yml). Compensating transactions can be expensive to perform, and it might be possible to minimize their use by implementing an effective policy of retrying failing operations by following the Retry pattern.
