---
title: Design a Microservices Architecture
description: Learn how to design and build a microservices architecture on Azure by following a reference implementation that illustrates best practices.
author: claytonsiemens77
ms.author: pnp
ms.date: 09/23/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Design a microservices architecture

Microservices are a popular architectural style for building cloud applications that remain resilient, scale efficiently, deploy independently, and evolve rapidly. To deliver real value, microservices require a different approach to design and application development.

This set of articles explores how to build a microservices architecture on Azure. It includes the following guidance:

- [Compute options for microservices](./compute-options.md): Evaluate Azure compute services for microservices, including Azure Kubernetes Service (AKS), Azure Container Apps, and Azure Functions. Learn when to use each service based on your requirements for scalability, management overhead, and deployment models.

- [Interservice communication](./interservice-communication.yml): Design effective communication patterns between microservices by using synchronous and asynchronous approaches. Learn about REST APIs, messaging patterns, event-driven architectures, and service mesh technologies for reliable service-to-service communication.

- [API design](./api-design.md): Create well-designed APIs that support microservices architecture principles. Learn API versioning strategies, error handling patterns, and how to design APIs that promote loose coupling and independent service evolution.

- [API gateways](./gateway.yml): Implement API gateways to manage cross-cutting concerns like authentication, rate limiting, and request routing. Understand how gateways simplify client interactions and provide centralized policy enforcement across your microservices ecosystem.

- [Data considerations](./data-considerations.md): Address data management challenges in microservices architectures, including data consistency patterns, distributed transactions, and choosing appropriate data stores. Learn strategies for maintaining data integrity across service boundaries.

- [Container orchestration](./orchestration.yml): Deploy and manage containerized microservices at scale by using container orchestrators. Understand how platforms like Kubernetes automate deployment, scaling, load balancing, and health management to maintain desired system state in production environments.

- [Design patterns](./patterns.yml): Apply proven design patterns specific to microservices, including the Ambassador pattern for offloading connectivity tasks, the Bulkhead pattern for resource isolation, and the Strangler Fig pattern for incremental application refactoring.

## Prerequisites

Before you read these articles, start with the following resources:

- [Introduction to microservices architectures](../../guide/architecture-styles/microservices.md): Understand the benefits and challenges of microservices and when to use this architecture style.

- [Use domain analysis to model microservices](../model/domain-analysis.md): Learn a domain-driven approach to modeling microservices.

## Example architecture

:::image type="complex" border="false" source="../images/drone-delivery-impl.png" alt-text="Diagram that shows the architecture of a drone delivery workload." lightbox="../images/drone-delivery-impl.png":::
The diagram presents a high-level system architecture that operates within AKS. The layout flows from left to right. It begins with a component labeled Client positioned outside the AKS boundary. The client sends data to the Ingestion service, which resides inside the AKS environment. A directional arrow connects the client to the ingestion service, which indicates the initial data transfer. The ingestion service then forwards the data to Service Bus. From Service Bus, data moves into the Workflow service. The Workflow service directs tasks to one of three specialized services. These services include the Delivery service, the Drone Scheduler service, and the Package service. Each of these services is connected to its own external system or storage solution, represented by arrows that lead to distinct icons. The Delivery service and Drone Scheduler service both route data to storage or database components, while the Package service connects to a cloud or external system. All components, except the client, are enclosed within a dotted boundary labeled AKS, which indicates that they're managed within that environment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/design-microservice-drone-delivery-imp.vsdx) of this architecture.*

## Scenario

Fabrikam, Inc. creates a drone delivery service. The company manages a fleet of drone aircraft. Businesses register with the service, and users can request a drone to pick up goods for delivery. When a customer schedules a pickup, a back-end system assigns a drone and notifies the user of an estimated delivery time. During the delivery, the customer can track the location of the drone, including a continuously updated estimated time of arrival (ETA).

This solution works well for the aerospace and aircraft industries.

This scenario involves a fairly complicated domain. Some business concerns include scheduling drones, tracking packages, managing user accounts, and storing and analyzing historical data. Fabrikam also wants to get to market and then iterate quickly to add new functionality and capabilities. The application needs to operate at cloud scale with a high service-level objective (SLO). Fabrikam also expects different parts of the system to have very different requirements for data storage and querying. Based on considerations, Fabrikam chooses a microservices architecture for the drone delivery application.

> [!NOTE]
> For more information about how to choose between a microservices architecture and other architectural styles, see the [Azure Application architecture guide](../../guide/index.md).

This architecture uses Kubernetes with [AKS](/azure/aks/). But many of the high-level architectural decisions and challenges apply to any container orchestrator.

## Next step

> [!div class="nextstepaction"]
> [Choose a compute option](./compute-options.md)

## Related resources

- [Design interservice communication for microservices](./interservice-communication.yml)
- [Design APIs for microservices](./api-design.md)
- [Use API gateways in microservices](./gateway.yml)
- [Data considerations for microservices](./data-considerations.md)
- [Container orchestration for microservices](./orchestration.yml)
- [Design patterns for microservices](./patterns.yml)
