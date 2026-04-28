---
title: Design Patterns for Microservices
description: Learn about design patterns that address common microservices challenges like data consistency, cross-service communication, failure isolation, and legacy integration.
author: claytonsiemens77
ms.author: pnp
ms.date: 03/30/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Design patterns for microservices

A microservices architecture distributes responsibility across independent services. That independence changes how you handle the following common architectural challenges:

- Data consistency maintenance without distributed transactions
- Cross-service communication management
- Failure isolation so that failures don't cascade
- Legacy system integration during migration

The design patterns in this article address these challenges directly. Each pattern targets a specific concern that you might encounter when you design, build, and operate microservices.

:::image type="complex" source="../images/microservices-patterns.png" border="false" lightbox="../images/microservices-patterns.png" alt-text="Diagram that shows microservices design patterns and their relationships.":::
  The diagram flow starts with a client application. An arrow points from the client application to a box that represents the microservices application. A second arrow points from the client application to the Strangler Fig pattern. Two arrows point from the Strangler Fig pattern. One arrow points to the microservices application box, and the other arrow points to a rectangle labeled legacy system at the bottom of the diagram. The microservices application box includes design patterns and microservices. In a section labeled API gateway, an arrow points from the Gateway Offloading pattern to the Gateway Routing and Gateway Aggregation patterns. An arrow points from the Gateway Routing pattern to a microservice for desktop. An arrow points from the Gateway Aggregation pattern to a microservice for mobile. These microservices are within a section labeled Backends for Frontends. Arrows point from these microservices to another microservice under a box labeled Sidecar. An arrow points from this microservice to a remote service outside of the microservices application box. An arrow points from the microservice for mobile to a section that contains two boxes labeled service. Arrows point from each service to an event bus between them. In another section, an arrow that passes through an anti-corruption layer points from a microservice to the legacy system outside of the microservices application.
:::image-end:::

## Common design patterns

- [**Anti-Corruption Layer**](../../patterns/anti-corruption-layer.yml) implements a facade or adapter layer between subsystems that don't share the same semantics. This pattern translates requests between subsystems and prevents dependencies on legacy systems or other services that have incompatible domain models from limiting a new service's design.

- [**Backends for Frontends**](../../patterns/backends-for-frontends.md) creates separate backend services for different types of clients, such as desktop and mobile. When you take this approach, a single backend service doesn't need to handle the conflicting requirements of various client types. This pattern helps keep each microservice simple by separating client-specific concerns.

- [**Bulkhead**](../../patterns/bulkhead.md) isolates critical resources, such as connection pools, memory, and CPU, for each workload or service. This isolation prevents a single workload or service from consuming all resources. This pattern increases workload resiliency by preventing one service from causing cascading failures.

- [**Choreography**](../../patterns/choreography.md) lets each service decide when and how to process a business operation, rather than depending on a central orchestrator. This pattern reduces coupling between services and supports frequent service updates or changes.

- [**Command Query Responsibility Segregation (CQRS)**](../../patterns/cqrs.md) segregates read operations from write operations into separate data models. This pattern improves performance, scalability, and security in microservices where reads and writes have different performance or scaling requirements.

- [**Gateway Routing**](../../patterns/gateway-routing.yml) uses an API gateway as a reverse proxy to route client requests to different services based on the request. This approach gives clients a single endpoint instead of many.

  [**Gateway Aggregation**](../../patterns/gateway-aggregation.yml) uses the gateway to combine multiple client requests into a single request. This approach reduces chattiness between clients and services.

  [**Gateway Offloading**](../../patterns/gateway-offloading.yml) centralizes cross-cutting functionality, such as Secure Socket Layer (SSL) termination, authentication, and rate limiting, into the gateway so that individual services don't have to implement these concerns separately.

  For more information, see [API gateways for microservices](gateway.yml).

- [**Saga**](../../patterns/saga.yml) manages data consistency across microservices that have independent data stores. A saga is a sequence of local transactions in which each service performs its operation and triggers the next step. If a step fails, the saga runs compensating transactions to undo the preceding changes. This pattern replaces distributed transactions, which are often impractical in a microservices architecture.

- [**Sidecar**](../../patterns/sidecar.md) deploys helper components of an application as a separate container or process to provide isolation and encapsulation. Use this pattern to attach common functionality, such as logging, monitoring, and networking configuration, to a service without embedding it in the service's code.

- [**Strangler Fig**](../../patterns/strangler-fig.md) supports incremental migration from a legacy system by gradually replacing specific pieces of functionality with new services. Consumers continue to use the same interface, unaware that the migration is taking place, until you fully replace the legacy system.

## Supporting patterns

[Interservice communication](interservice-communication.yml) describes the [Retry](../../patterns/retry.yml) and [Circuit Breaker](../../patterns/circuit-breaker.md) patterns for resilient service-to-service calls.

For the complete catalog of cloud design patterns in Azure Architecture Center, see [Cloud design patterns](../../patterns/index.md).

## Next steps

- [Training: Build your first microservice by using .NET](/training/modules/dotnet-microservices/)
- [What are microservices?](/devops/deliver/what-are-microservices)
- [Microservices architecture](/dotnet/architecture/microservices/architect-microservice-container-applications/microservices-architecture)

## Related resources

- [Microservices architecture style](../../guide/architecture-styles/microservices.md)
- [Design a microservices architecture](index.md)
- [Use domain analysis to model microservices](../model/domain-analysis.md)
- [Data considerations for microservices](data-considerations.md)