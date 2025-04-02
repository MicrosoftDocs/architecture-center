---
title: Cloud Design Patterns
description: Learn about design patterns for building reliable, scalable, and more secure applications in the cloud with examples based on Microsoft Azure.
ms.author: robbag
author: RobBagby
ms.date: 12/11/2024
ms.topic: design-pattern
ms.subservice: design-pattern
products:
  - azure
categories:
  - compute
  - databases
  - migration
  - security
  - web
---

# Cloud design patterns

Architects design workloads by integrating platform services, functionality, and code to meet both functional and nonfunctional requirements. Designing effective workloads requires you to understand these requirements and select topologies and methodologies that address the challenges posed by the workload's constraints. Cloud design patterns provide solutions to many common challenges.

System design heavily relies on established design patterns. Infrastructure, code, and distributed systems are developed by using a combination of these patterns. These patterns are crucial for building reliable, more secure, cost-optimized, operationally efficient, and high-performing applications in the cloud.

The following cloud design patterns are technology-agnostic, which makes them suitable for any distributed system. You can apply these patterns across Azure, other cloud platforms, on-premises setups, and hybrid environments.

## How cloud design patterns enhance the design process

Cloud workloads are vulnerable to the [fallacies of distributed computing](https://wikipedia.org/wiki/Fallacies_of_distributed_computing), which are common but incorrect assumptions about how distributed systems operate. Examples of these fallacies include:

- The network is reliable.
- Latency is zero.
- Bandwidth is infinite.
- The network is secure.
- Topology doesn't change.
- There's one administrator.
- Component versioning is simple.
- Observability implementation can be delayed.

These misconceptions can result in flawed workload designs. Design patterns don't eliminate these misconceptions but help raise awareness, provide compensation strategies, and provide mitigations. Each cloud design pattern has trade-offs. Focus on why you should choose a specific pattern instead of how to implement it.

A well-architected workload considers how these industry-standard design patterns should be used as the core building blocks for workload design. Each design pattern in the Azure Well-Architected Framework represents one or more of its pillars. However, adopting specific patterns might introduce trade-offs with the goals of other pillars.

## Pattern catalog

Each pattern in this catalog describes the problem that it addresses, considerations for applying the pattern, and an example based on Microsoft Azure. Some patterns include code samples or snippets that show how to implement the pattern on Azure.

| Pattern | Summary | Well-Architected Framework pillars |
| :------ | :------ | :-------------------------------------- |
| [Ambassador](./ambassador.yml) | Create helper services that send network requests on behalf of a consumer service or application. | - Reliability<br>- Security |
| [Anti-Corruption Layer](./anti-corruption-layer.yml) | Implement a façade or adapter layer between a modern application and a legacy system. | - Operational Excellence |
| [Asynchronous Request-Reply](./async-request-reply.yml) | Decouple back-end processing from a front-end host. This pattern is useful when back-end processing must be asynchronous, but the front end requires a clear and timely response. | - Performance Efficiency |
| [Backends for Frontends](./backends-for-frontends.yml) | Create separate back-end services that are designed for specific front-end applications or interfaces. | - Reliability<br>- Security<br>- Performance Efficiency |
| [Bulkhead](./bulkhead.yml) | Isolate elements of an application into pools so that if one fails, the others continue to function. | - Reliability<br>- Security<br>- Performance Efficiency |
| [Cache-Aside](./cache-aside.yml) | Load data on demand into a cache from a data store. | - Reliability<br>- Performance Efficiency |
| [Choreography](./choreography.yml) | Let each service decide when and how a business operation is processed, instead of depending on a central orchestrator. | - Operational Excellence<br>- Performance Efficiency |
| [Circuit Breaker](./circuit-breaker.md) | Handle faults that might take a variable amount of time to fix when you connect to a remote service or resource. | - Reliability<br>- Performance Efficiency |
| [Claim Check](./claim-check.yml) | Split a large message into a claim check and a payload to avoid overwhelming a message bus. | - Reliability<br>- Security<br>- Cost Optimization<br>- Performance Efficiency |
| [Compensating Transaction](./compensating-transaction.yml) | Undo the work performed by a sequence of steps that together form an eventually consistent operation. | - Reliability |
| [Competing Consumers](./competing-consumers.yml) | Enable multiple concurrent consumers to process messages received on the same messaging channel. | - Reliability<br>- Cost Optimization<br>- Performance Efficiency |
| [Compute Resource Consolidation](./compute-resource-consolidation.yml) | Consolidate multiple tasks or operations into a single computational unit. | - Cost Optimization<br>- Operational Excellence<br>- Performance Efficiency |
| [CQRS](./cqrs.md) | Separate operations that read data from those that update data by using distinct interfaces. | - Performance Efficiency |
| [Deployment Stamps](./deployment-stamp.yml) | Deploy multiple independent copies of application components, including data stores. | - Operational Excellence<br>- Performance Efficiency |
| [Edge Workload Configuration](./edge-workload-configuration.md) | Centralize configuration to address the challenge of configuring multiple systems and devices on the shop floor. |
| [Event Sourcing](./event-sourcing.yml) | Use an append-only store to record the full series of events that describe actions taken on data in a domain. | - Reliability<br>- Performance Efficiency |
| [External Configuration Store](./external-configuration-store.yml) | Move configuration information out of the application deployment package to a centralized location. | - Operational Excellence |
| [Federated Identity](./federated-identity.yml) | Delegate authentication to an external identity provider. | - Reliability<br>- Security<br>- Performance Efficiency |
| [Gatekeeper](./gatekeeper.yml) | Protect applications and services by using a dedicated host instance that serves as a broker between clients and the application or service. | - Security<br>- Performance Efficiency |
| [Gateway Aggregation](./gateway-aggregation.yml) | Use a gateway to aggregate multiple individual requests into a single request. | - Reliability<br>- Security<br>- Operational Excellence<br>- Performance Efficiency |
| [Gateway Offloading](./gateway-offloading.yml) | Offload shared or specialized service functionality to a gateway proxy. | - Reliability<br>- Security<br>- Cost Optimization<br>- Operational Excellence<br>- Performance Efficiency |
| [Gateway Routing](./gateway-routing.yml) | Route requests to multiple services by using a single endpoint. | - Reliability<br>- Operational Excellence<br>- Performance Efficiency |
| [Geode](./geodes.yml) | Deploy back-end services across geographically distributed nodes. Each node can handle client requests from any region. | - Reliability<br>- Performance Efficiency |
| [Health Endpoint Monitoring](./health-endpoint-monitoring.yml) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. | - Reliability<br>- Operational Excellence<br>- Performance Efficiency |
| [Index Table](./index-table.yml) | Create indexes over the fields in data stores that queries frequently reference. | - Reliability<br>- Performance Efficiency |
| [Leader Election](./leader-election.yml) | Coordinate actions in a distributed application by electing one instance as the leader. The leader manages a collection of collaborating task instances. | - Reliability |
| [Materialized View](./materialized-view.yml) | Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations. | - Performance Efficiency |
| [Messaging Bridge](./messaging-bridge.yml) | Build an intermediary to enable communication between messaging systems that are otherwise incompatible. | - Cost Optimization<br>- Operational Excellence |
| [Pipes and Filters](./pipes-and-filters.yml) | Break down a task that performs complex processing into a series of separate elements that can be reused. | - Reliability |
| [Priority Queue](./priority-queue.yml) | Prioritize requests sent to services so that requests with a higher priority are processed more quickly. | - Reliability<br>- Performance Efficiency |
| [Publisher/Subscriber](./publisher-subscriber.yml) | Enable an application to announce events to multiple consumers asynchronously, without coupling senders to receivers. | - Reliability<br>- Security<br>- Cost Optimization<br>- Operational Excellence<br>- Performance Efficiency |
| [Quarantine](./quarantine.yml) | Ensure that external assets meet a team-agreed quality level before consuming them in the workload. | - Security<br>- Operational Excellence |
| [Queue-Based Load Leveling](./queue-based-load-leveling.yml) | Use a queue that buffers tasks and smooths intermittent heavy loads. | - Reliability<br>- Cost Optimization<br>- Performance Efficiency |
| [Rate Limit](./rate-limiting-pattern.yml) | Avoid or minimize throttling errors by controlling the consumption of resources. | - Reliability |
| [Retry](./retry.yml) | Enable applications to handle anticipated temporary failures by retrying failed operations. | - Reliability |
| [Saga](./saga.yml) | Manage data consistency across microservices in distributed transaction scenarios. | - Reliability |
| [Scheduler Agent Supervisor](./scheduler-agent-supervisor.yml) | Coordinate a set of actions across distributed services and resources. | - Reliability<br>- Performance Efficiency |
| [Sequential Convoy](./sequential-convoy.yml) | Process a set of related messages in a defined order without blocking other message groups. | - Reliability |
| [Sharding](./sharding.yml) | Divide a data store into a set of horizontal partitions or shards. | - Reliability<br>- Cost Optimization |
| [Sidecar](./sidecar.yml) | Deploy components into a separate process or container to provide isolation and encapsulation. | - Security<br>- Operational Excellence |
| [Static Content Hosting](./static-content-hosting.yml) | Deploy static content to a cloud-based storage service for direct client delivery. | - Cost Optimization |
| [Strangler Fig](./strangler-fig.md) | Incrementally migrate a legacy system by gradually replacing pieces of functionality with new applications and services. | - Reliability<br>- Cost Optimization<br>- Operational Excellence |
| [Throttling](./throttling.yml) | Control the consumption of resources by applications, tenants, or services. | - Reliability<br>- Security<br>- Cost Optimization<br>- Performance Efficiency |
| [Valet Key](./valet-key.yml) | Use a token or key to provide clients with restricted, direct access to a specific resource or service. | - Security<br>- Cost Optimization<br>- Performance Efficiency |

## Next step

Review the design patterns from the perspective of the Well-Architected pillar that the pattern aims to optimize.

- [Design patterns to support the Reliability pillar](/azure/well-architected/reliability/design-patterns)
- [Design patterns to support the Security pillar](/azure/well-architected/security/design-patterns)
- [Design patterns to support the Cost Optimization pillar](/azure/well-architected/cost-optimization/design-patterns)
- [Design patterns to support the Operational Excellence pillar](/azure/well-architected/operational-excellence/design-patterns)
- [Design patterns to support the Performance Efficiency pillar](/azure/well-architected/performance-efficiency/design-patterns)
