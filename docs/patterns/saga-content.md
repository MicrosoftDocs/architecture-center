The Saga design pattern helps maintain data consistency in distributed systems by coordinating transactions across multiple services. A saga is a sequence of local transactions where each service performs its operation and initiates the next step through events or messages. If a step in the sequence fails, the saga executes compensating transactions to undo the completed steps, maintaining data consistency.

## Context and problem

A *transaction* represents a unit of work, which can include multiple operations. Within a transaction, an *event* refers to a state change affecting an entity. A *command* encapsulates all information needed to perform an action or trigger a subsequent event.

Transactions must adhere to the principles of atomicity, consistency, isolation, and durability (ACID).

- **Atomicity**: All operations succeed or none do.
- **Consistency**: Data transitions from one valid state to another.
- **Isolation**: Concurrent transactions yield the same results as sequential ones.
- **Durability**: Once committed, changes persist even in failures.

In a single service, transactions follow ACID principles because they operate within a single database. However, achieving ACID compliance across multiple services is more complex.

### Challenges in microservices architectures

Microservices architectures typically assign a [dedicated database to each microservice](/dotnet/architecture/cloud-native/distributed-data#database-per-microservice-why), which offers several benefits:

- Each service encapsulates its own data.
- Each service can use the most suitable database technology and schema for its specific needs.
- Independent scaling of databases for each service.
- Failures in one service are isolated from others.

Despite these advantages, this architecture complicates cross-service data consistency. Traditional database guarantees like ACID aren't directly applicable to multiple independently managed data stores. Due to these limitations, architectures that rely on interprocess communication (IPC) or traditional transaction models, like two-phase commit (2PC) protocol, are often better suited for the Saga pattern.

## Solution

The Saga pattern manages transactions by breaking them into a sequence of *local transactions* (*see figure 1*).

![Diagram that shows a saga overview.](./_images/saga-overview.png)<br>
*Figure 1. A saga with three services.*

Each local transaction:

1. Completes its work atomically within a single service.
1. Updates the service's database.
1. Initiates the next transaction via an event or message.
1. If a local transaction fails, the saga executes a series of *compensating transactions* to reverse the changes made by the preceding local transactions.

### Key concepts in the Saga pattern

- **Compensable transactions**: Transactions that other transactions can undo or compensate for with the opposite effect. If a step in the saga fails, compensating transactions undo the changes that the compensable transactions made.

- **Pivot transaction**: The pivot transaction serves as the "point of no return" in the saga. Once the pivot transaction succeeds, compensable transactions (which could be undone) are no longer relevant. All subsequent actions must complete for the system to achieve a consistent final state. A pivot transaction can fall into different roles depending on the flow of the saga:

  - *Irreversible (noncompensable)*: It can't be undone or retried.
  
  - *Boundary between reversible and committed*: It can be the last undoable (compensable) transaction, or it can be the first retryable operation in the saga.

- **Retryable transactions**: These transactions follow the pivot transaction. Retryable transactions are idempotent and ensure that the saga can reach its final state, even if temporary failures occur. It guarantees that the saga achieves a consistent state eventually.

### Saga implementation approaches

There are two common saga implementation approaches, *choreography* and *orchestration*. Each approach has its own set of challenges and technologies to coordinate the workflow.

#### Choreography

In choreography, services exchange events without a centralized controller. With choreography, each local transaction publishes domain events that trigger local transactions in other services (*see figure 2*).

![Diagram that shows a saga using choreography](./_images/choreography-pattern.png)<br>
*Figure 2. A saga that uses choreography.*

| **Benefits of choreography** | **Drawbacks of choreography** |
|--------------|---------------|
| Good for simple workflows with few services and don't need a coordination logic. | Workflow can become confusing when adding new steps. It's difficult to track which saga participants listen to which commands. |
| No other service is required for coordination. | There's a risk of cyclic dependency between saga participants because they have to consume each other's commands. |
| Doesn't introduce a single point of failure, since the responsibilities are distributed across the saga participants. | Integration testing is difficult because all services must be running to simulate a transaction. |

#### Orchestration

In orchestration, a centralized controller (orchestrator) handles all the transactions and tells the participants which operation to perform based on events. The orchestrator executes saga requests, stores and interprets the states of each task, and handles failure recovery with compensating transactions (*see figure 3*).

![Diagram that shows a saga using orchestration](./_images/orchestrator.png)<br>
*Figure 3. A saga that uses orchestration.*

| **Benefits of orchestration** | **Drawbacks of orchestration** |
|--------------|---------------|
| Better suited for complex workflows or when adding new services. | Other design complexity requires an implementation of a coordination logic. |
| Avoids cyclic dependencies since the orchestrator manages the flow. | Introduces a point of failure because the orchestrator manages the complete workflow. |
| Clear separation of responsibilities simplifies service logic. | |

## Issues and considerations

Consider the following points when implementing the Saga pattern:

- **Shift in design thinking**: Adopting the Saga pattern requires a different mindset, focusing on coordinating transactions and ensuring data consistency across multiple microservices.

- **Complexity of debugging sagas**: Debugging sagas can be complex, especially as the number of participating services grows.

- **Irreversible local database changes**: Data can't be rolled back because saga participants commit changes to their respective databases.

- **Handling transient failures and idempotence**: The system must handle transient failures effectively and ensure idempotence, where repeating the same operation doesn't alter the outcome. For more information, see [Idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing).

- **Need for monitoring and tracking sagas**: Monitoring and tracking the workflow of a saga are essential to maintain operational oversight.

- **Limitations of compensating transactions**: Compensating transactions might not always succeed, potentially leaving the system in an inconsistent state.

### Potential data anomalies in sagas

Data anomalies are inconsistencies that can occur when sagas execute across multiple services. Because each service manages its own data (participant data), there's no built-in isolation across services. This setup can result in data inconsistencies or durability issues, such as partially applied updates or conflicts between services. Common issues include:

- **Lost updates**: When one saga modifies data without considering changes made by another saga, it leads to overwritten or missing updates.

- **Dirty reads**: When a saga or transaction reads data that another saga modified but not yet completed.

- **Fuzzy (nonrepeatable) reads**: When different steps in a saga read inconsistent data because updates occur between the reads.

### Strategies to address data anomalies

To reduce or prevent these anomalies, consider these countermeasures:

- **Semantic lock**: Use application-level locks where a saga's compensable transaction uses a semaphore to indicate an update is in progress.

- **Commutative updates**: Design updates so they can be applied in any order while still producing the same result, reducing conflicts between sagas.

- **Pessimistic view**: Reorder the sequence of the saga so that data updates occur in retryable transactions to eliminate dirty reads. Otherwise, one saga could read dirty data (uncommitted changes) while another saga is simultaneously executing a compensable transaction to roll back its updates.

- **Rereading values**: Validate that data remains unchanged before making updates. If data changes, abort the current step and restart the saga as needed.

- **Version files**: Maintain a log of all operations on a record and ensure they're executed in the correct sequence to prevent conflicts.

- **Risk-based concurrency (by value)**: Dynamically choose the appropriate concurrency mechanism based on the potential business risk. For example, use sagas for low-risk updates and distributed transactions for high-risk ones.

## When to use this pattern

Use the Saga pattern when you need to:

- Ensure data consistency in a distributed system without tight coupling.
- Roll back or compensate if one of the operations in the sequence fails.

The Saga pattern is less suitable for:

- Tightly coupled transactions.
- Compensating transactions that occur in earlier participants.
- Cyclic dependencies.

## Next steps

- [Distributed data](/dotnet/architecture/cloud-native/distributed-data)
- Richardson, Chris. 2018: *Microservices Patterns*. Manning Publications.

## Related resources

The following patterns might also be useful when implementing this pattern:

- [Choreography](./choreography.yml) has each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control.
- [Compensating transactions](./compensating-transaction.yml) undo work performed by a series of steps, and eventually define a consistent operation if one or more steps fail. Cloud-hosted applications that implement complex business processes and workflows often follow this *eventual consistency model*.
- [Retry](./retry.yml) lets an application handle transient failures when it tries to connect to a service or network resource, by transparently retrying the failed operation. Retry can improve the stability of the application.
- [Circuit breaker](./circuit-breaker.yml) handles faults that take a variable amount of time to recover from, when connecting to a remote service or resource. Circuit breaker can improve the stability and resiliency of an application.
- [Health endpoint monitoring](./health-endpoint-monitoring.yml) implements functional checks in an application that external tools can access through exposed endpoints at regular intervals. Health endpoint monitoring can help verify that applications and services are performing correctly.
