---
title: Saga Pattern
titleSuffix: Saga design pattern for distributed transactions on microservices
description: Saga is a pattern to ensure data consistency on distributed transactions in a  microservices architecture
author: fernandoBRS
ms.date: 06/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - microservices
  - databases
  - event-driven
  - transactions
ms.subservice: reference-architecture
---

# Saga Pattern

Saga is a design pattern that provides a mechanism to ensure data consistency across microservices in distributed transaction scenarios. A saga is a sequence of local transactions that updates each local database and publishes a message to trigger the next transaction step. In event of failed steps, compensating transactions are executed as an effort to counteract preceding transactions.

## Context and problem

In a microservices architecture that leverages the [Database-per-microservice](https://docs.microsoft.com/en-us/dotnet/architecture/cloud-native/database-per-microservice) pattern (i.e. domain data encapsulated within each service), ensure data consistency can be challenging as transactions can occur across microservices. Transactions that are within a single service can still use ACID transactions; however, a transaction management mechanism that works across services is required to maintain data consistency.

Unlike a saga pattern, some distributed architectures guarantee all participants in the transaction commit or rollback.  One example is a [two-phase commit (2PC)](https://en.wikipedia.org/wiki/Two-phase_commit_protocol).  Some participant implementations, such as NoSQL databases and message brokering, do not support such a guarantee.  Another guarantee limitation is synchronousity and availability [IPC](https://en.wikipedia.org/wiki/Inter-process_communication). In order for distributed transactions to commit, all the participating services must be available, potentially reducing the overall system availability.  Architectural implementations with inter-process communication or transactioning limitations may be candidates to adopt the saga pattern.


> Key-Terms

- **Atomicity**: An atomic transaction is an indivisible and irreducible series of operations that must all occur or none occur.

- **Choreography**: A way to coordinate sagas where participants exchange events without a centralized point of control. With choreography each local transaction publishes domain events that trigger local transactions in other services.

- **Command**: An object used to encapsulate all information needed to perform an action or trigger an event at a later time.

- **Compensatable transactions**: A transaction which may potentially be reversed by processing another transaction with the opposite effect.

- **Consistency**: Consistency ensures that a transaction may only bring the database from one valid state to another.

- **Durability**: Durability guarantees that committed transactions, remain committed even in the case of a system failure (e.g., power outage or crash).

- **Event**: An event is a fact that describes a state change that occurred to the entity.

- **IPC**: Interprocess communication (IPC) refers specifically to the management mechanisms an operating system provides which allow separate processes to share data.

- **Isolation**: Isolation ensures that concurrent transaction execution produces the same database state that sequentially executed transactions would have produced.

- **Local transaction**: The atomic work effort performed by a saga participant.

- **Orchestration**: A way to coordinate sagas where a centralized controller tells the saga participants what operations to perform.  In other words, an orchestrator tells the participants what local transactions to execute.

- **Pivot transaction**: The go/no-go point in a saga. If the pivot transaction commits, the saga will run until completion. A pivot transaction can be a transaction that is neither compensatable nor retriable. Alternatively, it can be the last compensatable transaction or the first retriable transaction.

- **Retriable transactions**: Also: Retryable transactions. Transactions that follow the pivot transaction and are guaranteed to succeed.

- **Saga**: A saga is a sequence of local transactions. Each local transaction updates the database and publishes a message or event to trigger the next local transaction in the saga. If a local transaction fails because it violates a business rule, then the saga executes a series of compensating transactions that undo the changes that were made by the preceding local transactions.

- **Transaction**: A transaction is a single unit of logic or work, sometimes made up of multiple operations that by definition must be atomic, consistent, isolated and durable.

- **Two-phase commit (2PC)**: Distributed transaction management mechanism that ensures that all participants in a transaction either commit or rollback.

## Solution

The Saga pattern offers a transaction management mechanism using a sequence of local transactions. Each local transaction updates the database and publishes a message or event to trigger the next local transaction in the saga. If a local transaction fails because it violates a business rule then the saga executes a series of compensating transactions that undo the changes that were made by the preceding local transactions.

![Saga Overview](./images/saga-overview.png)

There are two common Saga implementation approaches:

### **Choreography**

A way to coordinate sagas where participants exchange events without a centralized point of control. With choreography each local transaction publishes domain events that trigger local transactions in other services.

![Choreography Overview](./images/choreography-pattern.png)

**Benefits**  

- Suited for simple Saga workflows that require few saga participants as there is no need to designing an implementation of a coordination logic.
- Does not require additional service implementation and maintenance.
- Does not introduce a single point of failure since the responsibilities are distributed across the saga participants.

**Drawbacks**

- Workflow can become confusing while adding new steps, as it is difficult to track which saga participants listen to which commands.
- Potential risk of adding cyclic dependency between saga participants as they have to consume to one another's commands.
- Integration testing tends to be hard as all services should be running in order to simulate a transaction.

### **Orchestration**

A Saga orchestrator handles all the transactions and tells the participants what operation to perform based on events. It handles failure recovery by compensating transactions, executes Saga requests, and stores and interprets the states of each task. This approach is suitable when there is control over every participant in the process, and control over the flow of activities.

![Orchestration Overview](./images/orchestrator.png)

**Benefits**  

- Suited for complex Saga workflows involving many participants or new participants added over time.
- Does not introduce cyclical dependencies as the orchestrator unilaterally depends on the saga participants.  Participants are independant of the orchestrator.
- Reduced coupling, as saga participants don't need to know about commands that need to be produced for other participants.
- Clear separation of concerns that simplifies the business logic.

**Drawbacks**

- Additional design complexity that requires an implementation of a coordination logic.
- Additional point of failure as orchestrator manages the complete workflow.

## Issues and considerations

- The Saga pattern may initially be challenging as it requires a new way of thinking on how to coordinate a transaction and maintain data consistency for a business process spanning multiple microservices.
- The Saga pattern is particularly hard to debug; and the complexity grows as participants increase.
- The data cannot be rolled back because saga participants commit changes to local databases.
- The lack of participant data isolation imposes durability challenges.  The Saga implementation must include countermeasures to reduce anomalies. 
- The following anomalies can happen without proper measure:
    - **Lost updates**: One saga overwrites without reading changes made by another saga.
    - **Dirty reads**: A transaction or a saga reads the updates made by a saga that has not yet completed those updates.
    - **Fuzzy/nonrepeatable reads**: Different saga steps may read different data because an update of the data may occur between the reads.
- Suggested countermeasures to reduce or prevent anomalies:
    - **Semantic lock**: An application-level lock where a saga's compensatable transaction uses a semaphore to indicate an update is in progress.
    - **Commutative updates**: Update operations may be designed so they may be executed in any order and produce the same result.
    - **Pessimistic view**: One saga can read **dirty** data while another one is running a compensatable transaction to rollback the operation. In the reordered version of the saga, the underlying data is updated in a retriable transaction, which eliminates the possibility of a dirty read.
    - **Reread value**: Verifies that data is unchanged and then updates the record. If the record has changed, the necessary steps abort and possibly restarts.
    - **Version file**: Records the operations that are performed on a record as they arrive and then executes them in the correct order.
    - **By value**: Use each request's business risk to dynamically select the concurrency mechanism. Low-risk requests favor sagas while high-risk requests favor distributed transactions.
- Both Choreography-based and Orchestration-based sagas have their own set of challenges and technologies to coordinate the workflow.
- The implementation must be capable of handling a set of potential transient failures and provide idempotence for reducing side-effects and ensure data consistency.
- It is also recommended to implement observability to monitor and track the saga workflow

## When to use this pattern

Use Saga pattern when:

* Need to ensure data consistency in a distributed system without tight coupling.
* Need to roll back or compensate if one of the operations in the sequence of our process fails.

Saga pattern is less suitable for:

* Tightly-coupled transactions.
* Compensating transactions occur in earlier participants.
* Cyclic dependencies.

## Example

The [Orchestration-based Saga on Serverless](https://github.com/Azure-Samples/saga-orchestration-serverless) is a Saga implementation reference using the orchestration approach that simulates a money transfer scenario with successful and failed workflows.

## Related patterns and guidance

The following patterns might also be useful when implementing this pattern:

[Choreography](https://review.docs.microsoft.com/en-us/azure/architecture/patterns/choreography?branch=master): Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control.

[Compensating Transaction](https://review.docs.microsoft.com/en-us/azure/architecture/patterns/compensating-transaction?branch=master): Undo the work performed by a series of steps, which together define an eventually consistent operation, if one or more of the steps fail. Operations that follow the eventual consistency model are commonly found in cloud-hosted applications that implement complex business processes and workflows.

[Retry](https://review.docs.microsoft.com/en-us/azure/architecture/patterns/retry?branch=master): Enable an application to handle transient failures when it tries to connect to a service or network resource, by transparently retrying a failed operation. This can improve the stability of the application.

[Circuit Breaker](https://review.docs.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker?branch=master): Handle faults that might take a variable amount of time to recover from, when connecting to a remote service or resource. This can improve the stability and resiliency of an application.

[Health Endpoint Monitoring](https://review.docs.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring?branch=master): Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. This can help to verify that applications and services are performing correctly.

## References

Richardson, Chris. 2018: _Microservices Patterns_. Manning Publications, pp. 110-145
