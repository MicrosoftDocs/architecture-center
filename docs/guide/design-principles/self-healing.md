---
title: Design for self healing
description: Learn to design resilient applications that can recover from failures without manual intervention through self-healing.
author: ckittel
ms.author: pnp
ms.date: 07/28/2025
ms.topic: conceptual
ms.subservice: architecture-guide
---

# Design for self healing

## Design your application to be self healing when failures occur

In a distributed system, failures must be expected to happen. Hardware can fail. The network can have transient failures. Rarely will an entire service, data center, or even Azure region experience a disruption, however, even those must be designed for in your workload architecture. Resiliency and recovery should be addressed early in your workload design.

Therefore, design an application that is self-healing when failures occur. This requires a three-pronged approach:

- Detect failures.
- Respond to failures gracefully.
- Log and monitor failures to give operational insight.

How you respond to a particular type of failure depends on your workload's availability requirements. For example, if you require high availability, you might deploy to multiple availability zones in a region. To avoid outages, even in the unlikely event of an entire Azure region experiencing disruption, you can automatically fail over to a secondary region during a regional outage. However, that will incur a higher cost and potentially lower performance than a single-region deployment.

Also, don't just consider big events like regional outages, which are generally rare. You should focus as much, if not more, on handling local, short-lived failures, such as network connectivity failures or failed database connections.

A self-healing workload design is fundamental in [Azure Well-Architected Framework's reliability pillar](/azure/well-architected/reliability/principles), which emphasizes building resilient systems that can withstand malfunctions and recover to a fully functioning state. Your self-healing strategy is there to support your workload's availability targets, including Service Level Objectives (SLO).

## Recommendations

**Use decoupled components that communicate asynchronously**. Design components to be decoupled in terms of time and space. Decoupling in time means that components don't need to be present simultaneously for communication to be possible. Decoupling in space means that the sender and receiver don't have to run in the same process. Decoupled components should use events to communicate with each other, which helps minimize the chance of cascading failures.

**Retry failed operations**. Transient failures might occur due to momentary loss of network connectivity, a dropped database connection, or a timeout when a service is busy. Build retry logic into your application to handle transient failures. For many Azure services, the client SDK implements automatic retries. For more information, see [Transient fault handling](../../best-practices/transient-faults.md) and the [Retry pattern](../../patterns/retry.yml).

**Implement health endpoint monitoring**. Each service should expose a health endpoint that indicates its current state and the state of its dependencies. External monitoring systems, load balancers, and orchestrators use these health endpoints to determine if a service is healthy and route traffic accordingly. For more information, see the [Health Endpoint Monitoring pattern](../../patterns/health-endpoint-monitoring.yml).

**Protect failing remote services (Circuit Breaker)**. It's good to retry after a transient failure, but if the failure persists, you can end up with too many callers hammering a failing service. This can lead to cascading failures as requests back up. Use the [Circuit Breaker pattern](../../patterns/circuit-breaker.md) to fail fast (without making the remote call) when an operation is likely to fail.

**Isolate critical resources (Bulkhead)**. Failures in one subsystem can sometimes cascade. This can happen if a failure causes some resources, such as threads or sockets, not to be freed in a timely manner, leading to resource exhaustion. To avoid this, use the [Bulkhead pattern](../../patterns/bulkhead.yml) to partition a system into isolated groups so that a failure in one partition does not bring down the entire system.

**Perform load leveling**. Applications might experience sudden spikes in traffic that can overwhelm services on the backend. To avoid this, use the [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.yml) to queue work items to run asynchronously. The queue acts as a buffer that smooths out peaks in the load.

**Fail over**. If an instance can't be reached, fail over to another instance. For stateless components like web servers, place multiple instances behind a load balancer or traffic manager. For stateful components like databases, use replicas and implement failover mechanisms. Depending on the data store and how it replicates, the application might need to handle eventual consistency.

**Compensate failed transactions**. In general, avoid distributed transactions, as they require coordination across services and resources. Instead, compose an operation from smaller individual transactions. If the operation fails midway through, use [Compensating Transactions](../../patterns/compensating-transaction.yml) to undo any step that already completed.

**Checkpoint long-running transactions**. Checkpoints can provide resiliency if a long-running operation fails. When the operation restarts (for example, it is picked up by another VM), it can be resumed from the last checkpoint. Consider implementing a mechanism that records state information about the task at regular intervals, and save this state in durable storage that can be accessed by any instance of the process running the task. In this way, if the process is shut down, the work that it was performing can be resumed from the last checkpoint by using another instance. There are libraries that provide this functionality, such as [NServiceBus](https://docs.particular.net/nservicebus/sagas/) and [MassTransit](https://masstransit.io/documentation/patterns/saga). They transparently persist state, where the intervals are aligned with the processing of messages from queues in Azure Service Bus.

**Degrade gracefully and stay responsive during failure**. Sometimes you can't work around a problem, but you can provide reduced functionality that is still useful. Consider an application that shows a catalog of books. If the application can't retrieve the thumbnail image for the cover, it might show a placeholder image. Entire subsystems might be noncritical for the application. For example, on an e-commerce site, showing product recommendations is probably less critical than processing orders.

**Throttle clients**. Sometimes a small number of users create excessive load, which can reduce your application's availability for other users. In this situation, throttle the client for a certain period of time. See the [Throttling pattern](../../patterns/throttling.yml).

**Block bad actors**. Just because you throttle a client, it doesn't mean client was acting maliciously. It just means the client exceeded their service quota. But if a client consistently exceeds their quota or otherwise behaves badly, you might block them. Define an out-of-band process for user to request getting unblocked.

**Use leader election**. When you need to coordinate a task, use [Leader Election](../../patterns/leader-election.yml) to select a coordinator. This approach ensures that the coordinator is not a single point of failure. If the coordinator fails, a new one is selected. Rather than implementing a leader election algorithm from scratch, consider an off-the-shelf solution such as [Apache ZooKeeper](https://zookeeper.apache.org/).

**Test with fault injection**. All too often, the success path is well tested but not the failure path. A system could run in production for a long time before a failure path is exercised. Use fault injection to test the resiliency of the system to failures, either by triggering actual failures or by simulating them.

**Implement chaos engineering**. Chaos engineering extends the concept of fault injection by randomly introducing failures or abnormal conditions into production instances. Tools such as [Azure Chaos Studio](/azure/chaos-studio/) help you run controlled chaos experiments that identify weaknesses in your self-healing strategy.

**Use availability zones**. Many Azure regions provide [availability zones](/azure/reliability/availability-zones-overview), which are isolated sets of data centers within the region. Some Azure services can be deployed *zonally*, which ensures they are placed in a specific zone and can help reduce latency in communicating between components in the same workload. Alternatively, some services can be deployed with *zone redundancy*, which means that Azure automatically replicates the resource across zones for high availability. Consider which approach provides the best set of tradeoffs for your solution. To learn more about how to design your solution to use availability zones and regions, see [Recommendations for using availability zones and regions](/azure/well-architected/reliability/regions-availability-zones). Be aware that some services that support availability zones require you to configure the service to specifically scale out across those zones, such as setting a minimum instance count to three.

**Don't add more than you need.** Your self-healing strategy must align with your cost constraints, performance targets, and acceptable downtime levels. Avoid implementing self-healing capabilities in portions of your workload that do not have requirements for this level of automated recovery.

## Next step

> [!div class="nextstepaction"]
> [Ten design principles for Azure applications](index.md)
