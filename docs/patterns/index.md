---
title: Cloud design patterns
titleSuffix: Azure Architecture Center
description: Learn about design patterns for building reliable, scalable, secure applications in the cloud by seeing examples based on Microsoft Azure.
ms.author: robbag
author: RobBagby
ms.date: 12/11/2024
ms.topic: design-pattern
ms.service: azure-architecture-center
ms.subservice: design-pattern
keywords:
  - Azure
products:
  - azure
categories:
  - management-and-governance
---

# Cloud Design Patterns

Architects design workloads by combining platform services, functionality, and code to fulfill functional and non-functional requirements in workloads. Designing workloads requires understanding of those workload requirements and then choosing topologies and approaches the solve for the challenges presented by the constraints of the workload. Cloud design patterns that address many common challenges.

Systems design is heavily steeped in design patterns. Infrastructure, code, distributed systems all are usually designed around a combination of design patterns. These design patterns are useful for building reliable, secure, cost optimized, operationally sound, and performant applications in the cloud.

These design patterns are not specific to any technology and are relevant to any distributed system, whether hosted on Azure, other cloud platforms, and some can even extend to on-premises or hybrid workloads.

## Cloud design patterns help the design process

Cloud workloads are prone to the [fallacies of distributed computing](https://wikipedia.org/wiki/Fallacies_of_distributed_computing). Some examples of cloud design fallacies are:

- The network is reliable
- Latency is zero
- Bandwidth is infinite
- The network is secure
- Topology doesn't change
- There is one administrator
- Component versioning is simple
- Observability implementation can be delayed

Design patterns don't eliminate notions such as these but can help bring awareness, compensations, and mitigations of them. Each cloud pattern has its own trade-offs. You need to pay attention more to why you're choosing a certain pattern than to how to implement it.

A well-architected workload considers how these industry-wide design patterns should be used as the core building blocks for workload design. Every Azure Well-Architected pillar is represented in these design patterns, often times with the design pattern introducing tradeoffs with other pillars.

## Catalog of patterns

Each pattern in this catalog describes the problem that the pattern addresses, considerations for applying the pattern, and an example based on Microsoft Azure. Some patterns include code samples or snippets that show how to implement the pattern on Azure.

| Pattern | Summary | Azure Well-Architected Framework pillars |
| :------ | :------ | :------- |
| [Ambassador](./ambassador.yml) | Create helper services that send network requests on behalf of a consumer service or application. | Reliability <hr> Security |
| [Anti-Corruption Layer](./anti-corruption-layer.yml) | Implement a façade or adapter layer between a modern application and a legacy system. | Operational Excellence |
| [Asynchronous Request-Reply](./async-request-reply.yml) | Decouple backend processing from a frontend host, where backend processing needs to be asynchronous, but the frontend still needs a clear response. | Performance Efficiency |
| [Backends for Frontends](./backends-for-frontends.yml) | Create separate backend services to be consumed by specific frontend applications or interfaces. | Reliability <hr> Security <hr> Performance Efficiency |
| [Bulkhead](./bulkhead.yml) | Isolate elements of an application into pools so that if one fails, the others will continue to function. | Reliability <hr> Security <hr> Performance Efficiency |
| [Cache-Aside](./cache-aside.yml) | Load data on demand into a cache from a data store | Reliability <hr> Performance Efficiency |
| [Choreography](./choreography.yml)| Let each service decide when and how a business operation is processed, instead of depending on a central orchestrator.| Operational Excellence <hr> Performance Efficiency |
| [Circuit Breaker](./circuit-breaker.yml) | Handle faults that might take a variable amount of time to fix when connecting to a remote service or resource. | Reliability <hr> Performance Efficiency |
| [Claim Check](./claim-check.yml) | Split a large message into a claim check and a payload to avoid overwhelming a message bus. | Reliability <hr> Security <hr> Cost Optimization <hr> Performance Efficiency |
| [Compensating Transaction](./compensating-transaction.yml) | Undo the work performed by a series of steps, which together define an eventually consistent operation. | Reliability |
| [Competing Consumers](./competing-consumers.yml) | Enable multiple concurrent consumers to process messages received on the same messaging channel. | Reliability <hr> Cost Optimization <hr> Performance Efficiency |
| [Compute Resource Consolidation](./compute-resource-consolidation.yml) | Consolidate multiple tasks or operations into a single computational unit | Cost Optimization <hr> Operational Excellence <hr> Performance Efficiency |
| [CQRS](./cqrs.yml) | Segregate operations that read data from operations that update data by using separate interfaces. | Performance Efficiency |
| [Deployment Stamps](./deployment-stamp.yml) | Deploy multiple independent copies of application components, including data stores. |  Operational Excellence <hr> Performance Efficiency |
| [Edge Workload Configuration](./edge-workload-configuration.md) | The great variety of systems and devices on the shop floor can make workload configuration a difficult problem. |  |
| [Event Sourcing](./event-sourcing.yml) | Use an append-only store to record the full series of events that describe actions taken on data in a domain. | Reliability <hr> Performance Efficiency |
| [External Configuration Store](./external-configuration-store.yml) | Move configuration information out of the application deployment package to a centralized location. | Operational Excellence |
| [Federated Identity](./federated-identity.yml) | Delegate authentication to an external identity provider. | Reliability <hr> Security <hr> Performance Efficiency |
| [Gatekeeper](./gatekeeper.yml) | Protect applications and services by using a dedicated host instance that acts as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. | Security <hr> Performance Efficiency |
| [Gateway Aggregation](./gateway-aggregation.yml) | Use a gateway to aggregate multiple individual requests into a single request. | Reliability <hr> Security <hr> Operational Excellence <hr> Performance Efficiency |
| [Gateway Offloading](./gateway-offloading.yml) | Offload shared or specialized service functionality to a gateway proxy. | Reliability <hr> Security <hr> Cost Optimization <hr> Operational Excellence <hr> Performance Efficiency |
| [Gateway Routing](./gateway-routing.yml) | Route requests to multiple services using a single endpoint. | Reliability <hr> Operational Excellence <hr> Performance Efficiency |
| [Geode](./geodes.yml) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. | Reliability <hr> Performance Efficiency |
| [Health Endpoint Monitoring](./health-endpoint-monitoring.yml) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. | Reliability <hr> Operational Excellence <hr> Performance Efficiency |
| [Index Table](./index-table.yml) | Create indexes over the fields in data stores that are frequently referenced by queries. | Reliability <hr> Performance Efficiency |
| [Leader Election](./leader-election.yml) | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. | Reliability |
| [Materialized View](./materialized-view.yml) | Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations. | Performance Efficiency |
| [Messaging Bridge](./messaging-bridge.yml) | Build an intermediary to enable communication between messaging systems that are otherwise incompatible because of protocol or format. | Cost Optimization <hr> Operational Excellence |
| [Pipes and Filters](./pipes-and-filters.yml) | Break down a task that performs complex processing into a series of separate elements that can be reused. | Reliability |
| [Priority Queue](./priority-queue.yml) | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. | Reliability <hr> Performance Efficiency |
| [Publisher/Subscriber](./publisher-subscriber.yml) | Enable an application to announce events to multiple interested consumers asynchronously, without coupling the senders to the receivers. | Reliability <hr> Security <hr> Cost Optimization <hr> Operational Excellence <hr> Performance Efficiency |
| [Quarantine](./quarantine.yml) | Ensures external assets meet a team-agreed quality level before being authorized to consume them in the workload. | Security <hr> Operational Excellence |
| [Queue-Based Load Leveling](./queue-based-load-leveling.yml) | Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads. | Reliability <hr> Cost Optimization <hr> Performance Efficiency |
| [Rate Limit Pattern](./rate-limiting-pattern.yml) | Limiting pattern to help you avoid or minimize throttling errors related to these throttling limits and to help you more accurately predict throughput. | Reliability |
| [Retry](./retry.yml) | Enable an application to handle anticipated, temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that's previously failed. | Reliability |
| [Saga](../reference-architectures/saga/saga.yml) | Manage data consistency across microservices in distributed transaction scenarios. A saga is a sequence of transactions that updates each service and publishes a message or event to trigger the next transaction step. | Reliability |
| [Scheduler Agent Supervisor](./scheduler-agent-supervisor.yml) | Coordinate a set of actions across a distributed set of services and other remote resources. | Reliability <hr> Performance Efficiency |
| [Sequential Convoy](./sequential-convoy.yml) | Process a set of related messages in a defined order, without blocking processing of other groups of messages. | Reliability |
| [Sharding](./sharding.yml) | Divide a data store into a set of horizontal partitions or shards. | Reliability <hr> Cost Optimization |
| [Sidecar](./sidecar.yml) | Deploy components of an application into a separate process or container to provide isolation and encapsulation. | Security <hr> Operational Excellence |
| [Static Content Hosting](./static-content-hosting.yml) | Deploy static content to a cloud-based storage service that can deliver them directly to the client. | Cost Optimization  |
| [Strangler Fig](./strangler-fig.yml) | Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services. | Reliability <hr> Cost Optimization <hr> Operational Excellence |
| [Throttling](./throttling.yml) | Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service. | Reliability <hr> Security <hr> Cost Optimization <hr> Performance Efficiency |
| [Valet Key](./valet-key.yml) | Use a token or key that provides clients with restricted direct access to a specific resource or service. | Security <hr> Cost Optimization <hr> Performance Efficiency |

## Next step

Review the design patterns from the perspective of the Azure Well-Architected Pillar that the pattern seeks to optimize.

- [Design patterns to support the Reliability pillar](/azure/well-architected/reliability/design-patterns)
- [Design patterns to support the Security pillar](/azure/well-architected/security/design-patterns)
- [Design patterns to support the Cost Optimization pillar](/azure/well-architected/cost-optimization/design-patterns)
- [Design patterns to support the Operational Excellence pillar](/azure/well-architected/operational-excellence/design-patterns)
- [Design patterns to support the Performance Efficiency pillar](/azure/well-architected/performance-efficiency/design-patterns)
