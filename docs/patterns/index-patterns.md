---
title: Cloud design patterns
titleSuffix: Azure Architecture Center
description: Design patterns for building reliable, scalable, secure applications in the cloud.
author: dragon119
ms.date: 03/01/2018
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: design-pattern
ms.custom:
  - design-pattern
keywords: Azure
---

# Cloud Design Patterns

These design patterns are useful for building reliable, scalable, secure applications in the cloud.

Each pattern describes the problem that the pattern addresses, considerations for applying the pattern, and an example based on Microsoft Azure. Most of the patterns include code samples or snippets that show how to implement the pattern on Azure. However, most of the patterns are relevant to any distributed system, whether hosted on Azure or on other cloud platforms.

## Challenges in cloud development

<!-- markdownlint-disable MD033 -->
<table>
<tr>
    <td style="width: 64px; vertical-align: middle;"><a href="./category/data-management.md"><img src="_images/category/data-management.svg" alt="Data management" /></a></td>
    <td>
        <h3><a href="./category/data-management.md">Data Management</a></h3>
        <p>Data management is the key element of cloud applications, and influences most of the quality attributes. Data is typically hosted in different locations and across multiple servers for reasons such as performance, scalability or availability, and this can present a range of challenges. For example, data consistency must be maintained, and data will typically need to be synchronized across different locations.</p>
    </td>
</tr>
<tr>
    <td style="width: 64px; vertical-align: middle;"><a href="./category/design-implementation.md"><img src="_images/category/design-implementation.svg" alt="Design and implementation" /></a></td>
    <td>
        <h3><a href="./category/design-implementation.md">Design and Implementation</a></h3>
        <p>Good design encompasses factors such as consistency and coherence in component design and deployment, maintainability to simplify administration and development, and reusability to allow components and subsystems to be used in other applications and in other scenarios. Decisions made during the design and implementation phase have a huge impact on the quality and the total cost of ownership of cloud hosted applications and services.</p>
    </td>
</tr>
<tr>
    <td style="width: 64px; vertical-align: middle;"><a href="./category/messaging.md"><img src="_images/category/messaging.svg" alt="Messaging icon" /></a></td>
    <td>
        <h3><a href="./category/messaging.md">Messaging</a></h3>
        <p>The distributed nature of cloud applications requires a messaging infrastructure that connects the components and services, ideally in a loosely coupled manner in order to maximize scalability. Asynchronous messaging is widely used, and provides many benefits, but also brings challenges such as the ordering of messages, poison message management, idempotency, and more.</p>
    </td>
</tr>
</table>
<!-- markdownlint-disable MD033 -->

## Catalog of patterns

| Pattern | Summary | Category |
| ------- | ------- | -------- |
| [Ambassador](./ambassador.md) | Create helper services that send network requests on behalf of a consumer service or application. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Anti-Corruption Layer](./anti-corruption-layer.md) | Implement a façade or adapter layer between a modern application and a legacy system. |[Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md)|
| [Asynchronous Request-Reply](./async-request-reply.md) | Decouple backend processing from a frontend host, where backend processing needs to be asynchronous, but the frontend still needs a clear response. | [Messaging](./category/messaging.md) |
| [Backends for Frontends](./backends-for-frontends.md) | Create separate backend services to be consumed by specific frontend applications or interfaces. | [Design and Implementation](./category/design-implementation.md) |
| [Bulkhead](./bulkhead.md) | Isolate elements of an application into pools so that if one fails, the others will continue to function. | [Reliability](../framework/resiliency/reliability-patterns.md) |
| [Cache-Aside](./cache-aside.md) | Load data on demand into a cache from a data store | [Data Management](./category/data-management.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Choreography](./choreography.md)| Let each service decide when and how a business operation is processed, instead of depending on a central orchestrator.| [Messaging](./category/messaging.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Circuit Breaker](./circuit-breaker.md) | Handle faults that might take a variable amount of time to fix when connecting to a remote service or resource. | [Reliability](../framework/resiliency/reliability-patterns.md) |
| [Claim Check](./claim-check.md) | Split a large message into a claim check and a payload to avoid overwhelming a message bus. | [Messaging](./category/messaging.md) |
| [Compensating Transaction](./compensating-transaction.md) | Undo the work performed by a series of steps, which together define an eventually consistent operation. | [Reliability](../framework/resiliency/reliability-patterns.md) |
| [Competing Consumers](./competing-consumers.md) | Enable multiple concurrent consumers to process messages received on the same messaging channel. | [Messaging](./category/messaging.md) |
| [Compute Resource Consolidation](./compute-resource-consolidation.md) | Consolidate multiple tasks or operations into a single computational unit | [Design and Implementation](./category/design-implementation.md) |
| [CQRS](./cqrs.md) | Segregate operations that read data from operations that update data by using separate interfaces. | [Data Management](./category/data-management.md), <hr> [Design and Implementation](./category/design-implementation.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Deployment Stamps](./deployment-stamp.md) | Deploy multiple independent copies of application components, including data stores. | [Reliability](../framework/resiliency/reliability-patterns.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Event Sourcing](./event-sourcing.md) | Use an append-only store to record the full series of events that describe actions taken on data in a domain. | [Data Management](./category/data-management.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [External Configuration Store](./external-configuration-store.md) | Move configuration information out of the application deployment package to a centralized location. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Federated Identity](./federated-identity.md) | Delegate authentication to an external identity provider. | [Security](../framework/security/security-patterns.md) |
| [Gatekeeper](./gatekeeper.md) | Protect applications and services by using a dedicated host instance that acts as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. | [Security](../framework/security/security-patterns.md) |
| [Gateway Aggregation](./gateway-aggregation.md) | Use a gateway to aggregate multiple individual requests into a single request. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Gateway Offloading](./gateway-offloading.md) | Offload shared or specialized service functionality to a gateway proxy. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Gateway Routing](./gateway-routing.md) | Route requests to multiple services using a single endpoint. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Geodes](./geodes.md) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. | [Reliability](../framework/resiliency/reliability-patterns.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Health Endpoint Monitoring](./health-endpoint-monitoring.md) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. | [Reliability](../framework/resiliency/reliability-patterns.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Index Table](./index-table.md) | Create indexes over the fields in data stores that are frequently referenced by queries. | [Data Management](./category/data-management.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Leader Election](./leader-election.md) | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. | [Design and Implementation](./category/design-implementation.md), <hr> [Reliability](../framework/resiliency/reliability-patterns.md) |
| [Materialized View](./materialized-view.md) | Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations. | [Data Management](./category/data-management.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Pipes and Filters](./pipes-and-filters.md) | Break down a task that performs complex processing into a series of separate elements that can be reused. | [Design and Implementation](./category/design-implementation.md), <hr> [Messaging](./category/messaging.md) |
| [Priority Queue](./priority-queue.md) | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. | [Messaging](./category/messaging.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Publisher/Subscriber](./publisher-subscriber.md) | Enable an application to announce events to multiple interested consumers asynchronously, without coupling the senders to the receivers. | [Messaging](./category/messaging.md) |
| [Queue-Based Load Leveling](./queue-based-load-leveling.md) | Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads. | [Reliability](../framework/resiliency/reliability-patterns.md), <hr> [Messaging](./category/messaging.md), <hr> [Resiliency](/azure/architecture/framework/resiliency/reliability-patterns), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Retry](./retry.md) | Enable an application to handle anticipated, temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that's previously failed. | [Reliability](../framework/resiliency/reliability-patterns.md) |
| [Scheduler Agent Supervisor](./scheduler-agent-supervisor.md) | Coordinate a set of actions across a distributed set of services and other remote resources. | [Messaging](./category/messaging.md), <hr> [Reliability](../framework/resiliency/reliability-patterns.md) |
| [Sequential Convoy](./sequential-convoy.md) | Process a set of related messages in a defined order, without blocking processing of other groups of messages. | [Messaging](./category/messaging.md) |
| [Sharding](./sharding.md) | Divide a data store into a set of horizontal partitions or shards. | [Data Management](./category/data-management.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Sidecar](./sidecar.md) | Deploy components of an application into a separate process or container to provide isolation and encapsulation. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Static Content Hosting](./static-content-hosting.md) | Deploy static content to a cloud-based storage service that can deliver them directly to the client. | [Design and Implementation](./category/design-implementation.md), <hr> [Data Management](./category/data-management.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Strangler Fig](./strangler-fig.md) | Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services. | [Design and Implementation](./category/design-implementation.md), <hr> [Operational Excellence](../framework/devops/devops-patterns.md) |
| [Throttling](./throttling.md) | Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service. | [Reliability](../framework/resiliency/reliability-patterns.md), <hr> [Performance Efficiency](../framework/scalability/performance-efficiency-patterns.md) |
| [Valet Key](./valet-key.md) | Use a token or key that provides clients with restricted direct access to a specific resource or service. | [Data Management](./category/data-management.md), <hr> [Security](../framework/security/security-patterns.md) |
