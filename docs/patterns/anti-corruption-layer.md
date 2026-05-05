---
title: Anti-Corruption Layer Pattern
description: Learn about the Anti-Corruption Layer pattern. Implement a facade or adapter layer between a modern application and a legacy system.
ms.author: pnp
author: claytonsiemens77
ms.date: 07/28/2022
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Anti-Corruption Layer pattern

Implement a facade or adapter layer between different subsystems that don't share the same semantics. This layer translates requests that one subsystem makes to the other subsystem. Use this pattern to ensure that dependencies on outside subsystems don't limit an application's design. This pattern was first described by Eric Evans in *Domain-Driven Design*.

## Context and problem

Most applications rely on other systems for some data or functionality. For example, when you migrate a legacy application to a modern system, the application might continue to use existing legacy resources. New features must be able to call the legacy system. This capability is especially important for gradual migrations in which you move different features of a larger application to a modern system over time.

These legacy systems often have quality problems like convoluted data schemas or obsolete APIs. The features and technologies that legacy systems use can vary widely from more modern systems. To interoperate with the legacy system, the new application might need to support outdated infrastructure, protocols, data models, APIs, or other features that you don't otherwise put into a modern application.

When you maintain access between new and legacy systems, you force the new system to adhere to at least some of the legacy system's APIs or other semantics. When these legacy features have quality problems, this support corrupts what might otherwise be a cleanly designed modern application.

Similar problems can arise with any external system that your development team doesn't control.

## Solution

Isolate the different subsystems by placing an anti-corruption layer between them. This layer translates communications between the two systems. This approach allows one system to remain unchanged while the other avoids compromising its design and technological approach.

:::image type="complex" source="./_images/anti-corruption-layer.png" border="false" lightbox="./_images/anti-corruption-layer.png" alt-text="Diagram that shows an overview of the Anti-Corruption Layer pattern.":::
    The diagram shows a central anti-corruption layer component that acts as the translation boundary between two subsystems. On the left, within a dotted boundary labeled subsystem A, three microservice rectangles connect via bidirectional arrows to data store cylinders. Arrows point from each of the microservices in subsystem A to the anti-corruption layer. Three arrows point from the anti-corruption layer back to each microservice. These arrows represent bidirectional communication between subsystem A and the anti-corruption layer. On the right, within a dotted boundary, a bidirectional arrow connects a single large rectangle labeled subsystem B and a data store cylinder. An arrow points from subsystem B and from the data store to the anti-corruption layer. Two arrows point from the anti-corruption layer to subsystem B and its data store. The overall structure illustrates how the anti-corruption layer mediates all communication between the microservices of subsystem A and the components of subsystem B by translating their respective data models and semantics without the need for either subsystem to understand the other's internal structure.
:::image-end:::

The diagram shows an application that has two subsystems. Subsystem A calls to subsystem B through an anti-corruption layer. Communication between subsystem A and the anti-corruption layer always uses the data model and architecture of subsystem A. Calls from the anti-corruption layer to subsystem B conform to that subsystem's data model or methods. The anti-corruption layer contains all of the logic necessary to translate between the two systems. You can implement the layer as a component within the application or as an independent service.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- The anti-corruption layer might add latency to calls made between the two systems.

- The anti-corruption layer adds an extra service that you must manage and maintain.

- Consider how you plan to scale the anti-corruption layer.

- Consider whether you need more than one anti-corruption layer. For example, you might want to decompose functionality into multiple services that use different technologies or languages.

- Consider how you plan to manage the anti-corruption layer in relation with your other applications or services. Consider how to integrate it into your monitoring, release, and configuration processes.

- Make sure that you maintain and can monitor transaction and data consistency.

- Consider whether the anti-corruption layer needs to handle all communication between different subsystems, or just a subset of features.

- If the anti-corruption layer is part of an application migration strategy, consider whether it's permanent or whether you plan to retire it after you migrate all legacy functionality.

- The previous diagram uses distinct subsystems to illustrate this pattern, but you can also apply it to other service architectures, such as legacy code integration in a monolithic architecture.

- The anti-corruption layer mediates systems that might have different trust levels, so consider enforcing input validation and sanitization at this boundary.

- Plan for observability, including correlation IDs and structured logging, to diagnose translation failures.

## When to use this pattern

Use this pattern when:

- You plan a migration to happen over multiple stages, but you need to maintain integration between new and legacy systems.

- Two or more subsystems have different semantics, but they need to communicate.

This pattern might not be suitable when:

- The new and legacy systems have no significant semantic differences. Simultaneously, it's important to focus the anti-corruption layer on translation logic. Avoid placing business rules or orchestration in the layer.

## Workload design

Evaluate how to use the Anti-Corruption Layer pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern helps ensure that new component design remains uninfluenced by legacy implementations that might have different data models or business rules when you integrate with these legacy systems and it can reduce technical debt in new components while still supporting existing components.<br/><br/> - [OE:04 Tools and processes](/azure/well-architected/operational-excellence/tools-processes)<br/> - [OE:07 Monitoring system](/azure/well-architected/operational-excellence/observability) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

This pattern is conceptual and originates in Domain‑Driven Design. Azure services such as API Management or Azure Functions may assist with protocol handling and translation, but the core purpose of an Anti‑corruption Layer is to protect the domain model, not to prescribe any specific product choice.

```text
       Client Apps
           |
           v
    +--------------------+
    | Azure API          |
    | Management (APIM)  |  <-- Auth, throttling, protocol facade (REST)
    +--------------------+
              |
              v                     +----------------------------+
    +----------------------------+  | Azure Monitor              |
    | Azure Function             |  | & Application Insights     |
    | OrdersAclFunction          |  |                            |
    | - Maps REST DTO -> Domain  |--| - Logging & Tracing        |
    | - Maps Domain -> Legacy DTO|  | - Translation Error Rates  |
    +----------------------------+  +----------------------------+
              |
              v
    +----------------------------+
    | Legacy Order System        |
    +----------------------------+
```

In this example, API Management handles the external exposure and protocol concerns. The Azure Function implements the Anti-corruption Layer through domain mapping between the new system and the legacy system. Azure Monitor and Application Insights provide the critical observability required to track the success and latency of the translation between the two subsystems.

Beyond this synchronous request/response model, the anti-corruption layer can also use an asynchronous, event-driven approach. By using Azure Service Bus, Azure Event Grid, or Azure Event Hubs, the layer decouples the modern domain from the legacy system's throughput constraints, enabling message-based translation for high-throughput or highly decoupled workloads.

## Next steps

- Explore cloud design patterns that help manage distributed transactions and maintain data consistency, such as the [Compensating Transaction pattern](./compensating-transaction.yml) and [Saga distributed transactions pattern](./saga.yml)

- Because the anti-corruption layer can become a single point of failure, plan for resilience using the [Retry pattern](./retry.yml), [Circuit Breaker pattern](./circuit-breaker.md), [Bulkhead pattern](./bulkhead.yml), and [Health Endpoint Monitoring pattern](./health-endpoint-monitoring.yml).

## Related resources

- [Strangler Fig pattern](./strangler-fig.md)
- [Messaging Bridge pattern](./messaging-bridge.yml)
