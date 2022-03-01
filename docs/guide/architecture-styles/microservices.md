---
title: Microservice architecture style
titleSuffix: Azure Application Architecture Guide
description: Read about the benefits, challenges, and best practices of the microservices architecture style on Azure.
author: EdPrice-MSFT
ms.date: 01/04/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.custom:
  - seojan19
  - microservices
  - guide
products:
  - azure
categories:
  - management-and-governance
---

# Microservices architecture style

[!INCLUDE [microservices-intro](../../includes/microservices-intro.md)]

## Best practices

- Model services around the business domain.

- Decentralize everything. Individual teams are responsible for designing and building services. Avoid sharing code or data schemas.

- Data storage should be private to the service that owns the data. Use the best storage for each service and data type.

- Services communicate through well-designed APIs. Avoid leaking implementation details. APIs should model the domain, not the internal implementation of the service.

- Avoid coupling between services. Causes of coupling include shared database schemas and rigid communication protocols.

- Offload cross-cutting concerns, such as authentication and SSL termination, to the gateway.

- Keep domain knowledge out of the gateway. The gateway should handle and route client requests without any knowledge of the business rules or domain logic. Otherwise, the gateway becomes a dependency and can cause coupling between services.

- Services should have loose coupling and high functional cohesion. Functions that are likely to change together should be packaged and deployed together. If they reside in separate services, those services end up being tightly coupled, because a change in one service will require updating the other service. Overly chatty communication between two services may be a symptom of tight coupling and low cohesion.

- Isolate failures. Use resiliency strategies to prevent failures within a service from cascading. See [Resiliency patterns](/azure/architecture/framework/resiliency/reliability-patterns) and [Designing reliable applications](/azure/architecture/framework/resiliency/principles).

## Next steps

For detailed guidance about building a microservices architecture on Azure, see [Designing, building, and operating microservices on Azure](../../microservices/index.yml).

<!-- links -->

[resiliency-overview]: /azure/architecture/framework/resiliency/principles
[resiliency-patterns]: /azure/architecture/framework/resiliency/reliability-patterns
