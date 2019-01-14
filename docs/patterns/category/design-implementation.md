---
title: Design and Implementation patterns
titleSuffix: Cloud Design Patterns
description: Good design encompasses factors such as consistency and coherence in component design and deployment, maintainability to simplify administration and development, and reusability to allow components and subsystems to be used in other applications and in other scenarios. Decisions made during the design and implementation phase have a huge impact on the quality and the total cost of ownership of cloud hosted applications and services.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Design and Implementation patterns

Good design encompasses factors such as consistency and coherence in component design and deployment, maintainability to simplify administration and development, and reusability to allow components and subsystems to be used in other applications and in other scenarios. Decisions made during the design and implementation phase have a huge impact on the quality and the total cost of ownership of cloud hosted applications and services.

|                                Pattern                                 |                                                                                                      Summary                                                                                                       |
|------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                     [Ambassador](../ambassador.md)                     |                                                         Create helper services that send network requests on behalf of a consumer service or application.                                                          |
|          [Anti-Corruption Layer](../anti-corruption-layer.md)          |                                                               Implement a façade or adapter layer between a modern application and a legacy system.                                                                |
|         [Backends for Frontends](../backends-for-frontends.md)         |                                                          Create separate backend services to be consumed by specific frontend applications or interfaces.                                                          |
|                           [CQRS](../cqrs.md)                           |                                                         Segregate operations that read data from operations that update data by using separate interfaces.                                                         |
| [Compute Resource Consolidation](../compute-resource-consolidation.md) |                                                                     Consolidate multiple tasks or operations into a single computational unit                                                                      |
|   [External Configuration Store](../external-configuration-store.md)   |                                                        Move configuration information out of the application deployment package to a centralized location.                                                         |
|            [Gateway Aggregation](../gateway-aggregation.md)            |                                                                   Use a gateway to aggregate multiple individual requests into a single request.                                                                   |
|             [Gateway Offloading](../gateway-offloading.md)             |                                                                      Offload shared or specialized service functionality to a gateway proxy.                                                                       |
|                [Gateway Routing](../gateway-routing.md)                |                                                                            Route requests to multiple services using a single endpoint.                                                                            |
|                [Leader Election](../leader-election.md)                | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. |
|              [Pipes and Filters](../pipes-and-filters.md)              |                                                     Break down a task that performs complex processing into a series of separate elements that can be reused.                                                      |
|                        [Sidecar](../sidecar.md)                        |                                                  Deploy components of an application into a separate process or container to provide isolation and encapsulation.                                                  |
|         [Static Content Hosting](../static-content-hosting.md)         |                                                        Deploy static content to a cloud-based storage service that can deliver them directly to the client.                                                        |
|                      [Strangler](../strangler.md)                      |                                         Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services.                                          |
