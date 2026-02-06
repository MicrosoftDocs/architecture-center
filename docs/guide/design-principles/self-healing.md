---
title: Design for Self-Healing
description: Learn how to design self-healing Azure applications that detect, respond to, and recover from failures to ensure high availability and resilience.
author: ckittel
ms.author: pnp
ms.date: 07/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Design for self-healing

Failures are inevitable in a distributed system. Hardware can fail. The network can have transient failures. Entire services, datacenters, or even Azure regions rarely experience a disruption, but your workload architecture must account for those outages. Address resiliency and recovery early in your workload design.

Design an application that's self-healing when failures occur. Use the following approach:

- Detect failures.
- Respond to failures gracefully.
- Log and monitor failures to provide operational insight.

## Design your application to self-heal when failures occur

Align your response to failures with your workload's availability requirements. For example, if you require high availability, you might deploy to multiple availability zones in a region. To avoid outages when an Azure region experiences disruption, you can automatically fail over to a secondary region. This approach increases cost and can reduce performance compared to a single-region deployment.

Don't focus only on rare, large‑scale events like regional outages. Focus equally, or more, on local, short‑lived failures such as network connectivity loss or database connection failures.

A self-healing workload design is fundamental in the [Azure Well-Architected Framework Reliability pillar](/azure/well-architected/reliability/principles), which emphasizes building resilient systems that can withstand malfunctions and recover to a fully functioning state. Build your self-healing strategy to support your workload's availability targets, including service-level objectives (SLOs).

## Recommendations

**Use decoupled components that communicate asynchronously.** Design components to be decoupled in terms of time and space. Decoupling in time means that components don't need to be present simultaneously for communication. Decoupling in space means that the sender and receiver don't have to run in the same process. Decoupled components should use events to communicate with each other, which helps minimize the chance of cascading failures.

**Retry failed operations.** Transient failures might occur because of momentary loss of network connectivity, a dropped database connection, or a timeout when a service is busy. Build retry logic into your application to handle transient failures. For many Azure services, the client SDK implements automatic retries. For more information, see [Transient fault handling](../../best-practices/transient-faults.md) and the [Retry pattern](../../patterns/retry.yml).

**Implement health endpoint monitoring.** Each service should expose a health endpoint that indicates its current state and the state of its dependencies. External monitoring systems, load balancers, and orchestrators use these health endpoints to determine whether a service is healthy and route traffic accordingly. For more information, see the [Health Endpoint Monitoring pattern](../../patterns/health-endpoint-monitoring.yml).

**Protect failing remote services.** It's good practice to retry after a transient failure, but persistent failure can overload a failing service and cause cascading failures. Use the [Circuit Breaker pattern](../../patterns/circuit-breaker.md) to fail fast without making the remote call when an operation is likely to fail.

**Isolate critical resources.** Failures in one subsystem can cascade if resources, such as threads or sockets, aren't released promptly, which can lead to resource exhaustion. Use the [Bulkhead pattern](../../patterns/bulkhead.yml) to partition a system into isolated groups so that a failure in one partition doesn't affect the entire system.

**Perform load leveling.** Applications can experience sudden spikes in traffic that overwhelm services on the back end. Use the [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.yml) to queue work items to run asynchronously. The queue acts as a buffer that smooths out load peaks.

**Fail over.** If an instance can't be reached, fail over to another instance. For stateless components like web servers, place multiple instances behind a load balancer or traffic manager. For stateful components like databases, use replicas and implement failover mechanisms. Depending on the data store and how it replicates, the application might need to handle eventual consistency.

**Compensate failed transactions.** In general, avoid distributed transactions because they require coordination across services and resources. Instead, compose an operation from smaller individual transactions. If the operation fails midway through, use the [Compensating Transaction pattern](../../patterns/compensating-transaction.yml) to undo completed steps.

**Add checkpoints to long-running transactions.** Checkpoints provide resiliency if a long-running operation fails. When the operation restarts, for example if another virtual machine picks it up, it can resume from the last checkpoint. Consider implementing a mechanism that records state information about the task at regular intervals. Save this state in durable storage that any instance of the process that runs the task can access. If the process shuts down, another instance can resume the work from the last checkpoint. Libraries such as [NServiceBus](https://docs.particular.net/nservicebus/sagas/) and [MassTransit](https://masstransit.io/documentation/patterns/saga) provide this functionality. They transparently persist state, and the intervals align with message processing from queues in Azure Service Bus.

**Degrade gracefully and stay responsive during failure.** Sometimes you can't work around a problem, but you can provide reduced functionality that remains useful. For example, if an application can't retrieve a book cover thumbnail image, it might show a placeholder image. Entire subsystems might be noncritical, such as product recommendations on an e-commerce site compared to order processing.

**Throttle clients.** Sometimes a few users create excessive load, which can reduce your application's availability for other users. In this situation, throttle the client for a set period of time. For more information, see the [Throttling pattern](../../patterns/throttling.yml).

**Block bad actors.** Throttling doesn't imply malicious intent. It means that the client exceeded their service quota. But if a client consistently exceeds their quota or otherwise behaves badly, you might block them. Define an out-of-band process for users to request unblocking.

**Use leader election.** When you need to coordinate a task, use the [Leader Election pattern](../../patterns/leader-election.yml) to select a coordinator. This approach ensures that the coordinator isn't a single point of failure. If the coordinator fails, the system selects a new one. Rather than implementing a custom leader election algorithm, consider a prebuilt solution such as [Apache ZooKeeper](https://zookeeper.apache.org/).

**Test by using fault injection.** The success path often receives thorough testing, but the failure path doesn't. A system can run in production for a long time before a failure path is triggered. Use fault injection to test the system's resiliency by triggering or simulating failures.

**Implement chaos engineering.** Chaos engineering extends the concept of fault injection by randomly introducing failures or abnormal conditions into production instances. Tools such as [Azure Chaos Studio](/azure/chaos-studio/) help you run controlled chaos experiments that identify weaknesses in your self-healing strategy.

**Use availability zones.** Many Azure regions provide [availability zones](/azure/reliability/availability-zones-overview), which are isolated sets of datacenters within the region. You can deploy some Azure services *zonally*, which ensures that they reside in a specific zone and can help reduce latency for communication between components in the same workload. Alternatively, you can deploy some services with *zone redundancy*, which means that Azure automatically replicates the resource across zones for high availability. Consider which approach provides the best set of trade-offs for your solution. For more information, see [Recommendations for availability zones and regions](/azure/well-architected/reliability/regions-availability-zones). Some services that support availability zones require you to configure the service to specifically scale out across those zones, such as by setting a minimum instance count to three.

**Don't add more than you need.** Your self-healing strategy must align with your cost constraints, performance targets, and acceptable downtime levels. Avoid implementing self-healing capabilities in parts of your workload that don't require this level of automated recovery.

## Next step

> [!div class="nextstepaction"]
> [Ten design principles for Azure applications](index.md)
