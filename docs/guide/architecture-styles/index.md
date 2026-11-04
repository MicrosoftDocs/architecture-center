---
title: Architecture Styles
description: Learn about architecture styles for cloud applications, including descriptions, recommendations, best practices, and recommended deployment with Azure services.
author: claytonsiemens77
ms.author: pnp
ms.date: 09/25/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Architecture styles

An *architecture style* is a family of architectures that share specific characteristics. For example, [N-tier][n-tier] is a common architecture style. More recently, [microservice architectures][microservices] are starting to gain favor. Architecture styles don't require the use of specific technologies, but some technologies are better suited for certain architectures. For example, containers are well-suited for microservices.

We identified a set of architecture styles that are commonly found in cloud applications. The article for each style includes the following components:

- A description and logical diagram of the style
- Recommendations for when to choose this style
- Benefits, challenges, and best practices
- A recommended deployment that uses relevant Azure services

## A quick tour of the styles

This section gives a quick tour of the architecture styles that we identified, along with some high-level considerations for their use. This list isn't exhaustive. Read more details in the linked articles.

### N-tier

:::image type="complex" border="false" source="./images/n-tier-logical.svg" alt-text="Logical diagram of an N-tier architecture style." lightbox="./images/n-tier-logical.svg":::
   From left to right, Client points to Web application firewall (WAF), which points to Web tier. Web tier branches right: an upper arrow leads to Middle tier 1, and a lower path passes through Messaging to Middle tier 2, positioned below Middle tier 1. Middle tier 1 points right to Remote service above Data tier and separately to Data tier. Middle tier 2 also points right to Data tier.

   Two additional horizontal arrows point left from Data tier toward the two middle tiers. Cache stands between the middle tiers and Data tier, overlapping these left-pointing connectors.
:::image-end:::

**[N-tier][n-tier]** is a traditional architecture for enterprise applications that divides an application into logical layers and physical tiers. Each layer has a specific responsibility, and layers manage dependencies by only calling into layers under them. Typical layers include presentation, business logic, and data access.

N-tier architectures are well-suited for migrating existing applications that already use a layered architecture. This approach requires minimal changes when you move to Azure and supports mixed environments with both on-premises and cloud components. But the horizontal layering can make it difficult to introduce changes without affecting multiple parts of the application, which limits agility for frequent updates.

### Web-Queue-Worker

:::image type="complex" border="false" source="./images/web-queue-worker-logical.svg" alt-text="Logical diagram of Web-Queue-Worker architecture style." lightbox="./images/web-queue-worker-logical.svg":::
   From left to right, Client points to Identity provider, which points to Web front end. Web front end points right to Remote service at the upper right, Database below it, and Queue at its lower right. Queue points to Worker, which also points to Database. Separate left-pointing lines run from Database toward Web front end and Worker; the Cache box between Worker and Database overlaps both lines.

   Along the bottom, Static content beneath Database points left to Content delivery network beneath Web front end. Content delivery network points left to Client.
:::image-end:::

**[Web-Queue-Worker][web-queue-worker]** is an architecture that consists of a web front end, a message queue, and a back-end worker. The web front end handles HTTP requests and user interactions, while the worker performs resource-intensive tasks, long-running workflows, or batch operations. Communication between the front end and worker occurs through an asynchronous message queue.

This architecture is ideal for applications with relatively simple domains that have some resource-intensive processing requirements. It's easy to understand and deploy with managed Azure services like App Service and Azure Functions. You can scale the front end and worker independently to provide flexibility in resource allocation. But without careful design, both components can become large and monolithic.

### Microservices

:::image type="complex" border="false" source="./images/microservices-logical.svg" alt-text="Logical diagram of microservices architecture style." lightbox="./images/microservices-logical.svg":::
   The Clients box on the left points to API gateway, which branches into a dashed Microservices box containing two stacked Domain service boxes and, below them, Composition service pointing right to Service. In a separate dashed Domain databases box to the right, the upper Domain service points to SQL database, the lower points to NoSQL database marked {JSON}, and Service points to a second SQL database.

   Above Microservices is Observability, labeled "Centralized logging, distributed tracing, metrics." Below Microservices, arrows labeled Publish/subscribe and Events descend from its boundary to Message-oriented middleware (MOM). Management/Orchestration sits beneath the middleware, labeled "Autoscaling, service registry, resiliency." A vertical DevOps bar stands at far right. No connectors join Observability, Management/Orchestration, or DevOps to other components.
:::image-end:::

**The [Microservices][microservices]** architecture decomposes applications into a collection of small, autonomous services. Each service implements a single business capability within a bounded context and is self-contained with its own data storage. Services communicate through well-defined APIs and can be developed, deployed, and scaled independently.

Microservices enable teams to work autonomously and support frequent updates with higher release velocity. This architecture is well-suited for complex domains that require frequent changes and innovation. But it introduces significant complexity in areas such as service discovery, data consistency, and distributed system management. Success requires mature development and DevOps practices, which makes it more suitable for organizations that have advanced technical capabilities.

### Event-driven architecture

:::image type="complex" border="false" source="./images/event-driven.svg" alt-text="Diagram of an event-driven architecture style." lightbox="./images/event-driven.svg":::
   The flow runs left to right. Event producers: A single box on the left points right to Event ingestion. Event ingestion: A smaller central box receives that arrow, and three outgoing arrows share its right edge as their starting point. Distribution arrows: The upper arrow slopes up and right, the middle arrow runs horizontally right, and the lower arrow slopes down and right. Event consumers: Three equal-sized boxes are stacked vertically on the right, each labeled "Event consumers" and receiving one arrow. No connectors link the consumers or connect Event producers directly to Event consumers.
:::image-end:::

**[Event-driven architectures](./event-driven.md)** use a [publish-subscribe model](../../patterns/publisher-subscriber.md) where event producers generate streams of events, and event consumers respond to those events in near real time. Producers and consumers are decoupled from each other, with communication happening through event channels or brokers. This architecture supports both simple event processing and complex event pattern analysis.

Event-driven architectures excel in scenarios that require real-time processing with minimal latency. Some examples are IoT solutions, financial trading systems, or applications that need to process high volumes of streaming data. Event-driven architectures provide excellent scalability and fault isolation but introduce challenges around guaranteed delivery, event ordering, and eventual consistency across distributed components.

### Big data

:::image type="complex" border="false" source="./images/big-data-logical.svg" alt-text="Logical diagram of a big data architecture style." lightbox="./images/big-data-logical.svg":::
   The diagram has two horizontal rows between a tall Data sources box on the left and a tall Analytics and reporting box on the right. Data sources points right to Data storage in the upper row and Real-time message ingestion in the lower row. Batch processing sits immediately right of Data storage, and Stream processing immediately right of Real-time message ingestion; no arrows connect either adjacent pair.

   Batch processing and Stream processing each point to Analytical data store, centered between their rows, and separately to Analytics and reporting. Analytical data store also points to Analytics and reporting. A wide Orchestration bar spans beneath the components, with no connectors.
:::image-end:::

**[Big data](./big-data.md)** architectures handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. These architectures typically include components for data storage (like data lakes), batch processing for historical analysis, stream processing for real-time insights, and analytical data stores for reporting and visualization.

Big data architectures are essential for organizations that need to extract insights from massive datasets, support predictive analytics using machine learning, or process real-time streaming data from IoT devices. Modern implementations often use managed services like Microsoft Fabric to simplify the complexity of building and maintaining big data solutions.

### Big compute

:::image type="complex" border="false" source="./images/big-compute-logical.png" alt-text="Diagram that illustrates a big compute architecture style.":::
   Client sits at left. An outlined right-pointing arrow, labeled Job Queue underneath, leads to Scheduler / Coordinator. Two outlined arrows branch diagonally right toward stacked boxes labeled Parallel tasks above and Tightly coupled tasks below.

   Parallel tasks contains four horizontal rows. Each row has an unlabeled cylinder on the left, a task in the center, and another unlabeled cylinder on the right. A line joins the left cylinder to the task, and a right-pointing arrow joins the task to the right cylinder. Tightly coupled tasks contains three tasks arranged in a triangle, with bidirectional arrows connecting every pair. An unlabeled cylinder sits above the triangle with no connecting lines.
:::image-end:::

**[Big compute](./big-compute.md)** architectures support large-scale workloads that require hundreds or thousands of cores for computationally intensive operations. The work can be split into discrete tasks that run across many cores simultaneously, with each task taking input, processing it, and producing output. Tasks can be either independent (embarrassingly parallel) or tightly coupled requiring high-speed communication.

Big compute is essential for simulations, financial risk modeling, scientific computing, engineering stress analysis, and 3D rendering. Azure provides options like Azure Batch for managed big compute workloads or HPC Pack for more traditional cluster management. These architectures can burst capacity on-demand and scale to thousands of cores when needed.

## Architecture styles as constraints

An architecture style places constraints on the design, including the set of elements that can appear and the allowed relationships between those elements. Constraints guide the "shape" of an architecture by restricting the universe of choices. When an architecture conforms to the constraints of a particular style, certain desirable properties emerge.

For example, the constraints in microservices include:

- A service represents a single responsibility.
- Every service is independent of the others.
- Data is private to the service that owns it. Services don't share data.

When you adhere to these constraints, you gain a system that lets you take the following actions:

- Deploy services independently.
- Isolate faults.
- Push more frequent updates.
- Introduce new technologies into the application more easily.

Each architecture style has its own trade-offs. Before you choose an architectural style, it's essential to understand the underlying principles and constraints. Without that understanding, you risk creating a design that superficially conforms to the style without realizing its full benefits. Focus more on why you're selecting a specific style than on how to implement it. Be practical. Sometimes it's better to relax a constraint than to chase architectural purity.

Ideally, the choice of architectural style should be made with input from informed workload stakeholders. The workload team should start by identifying the nature of the problem that they're solving. They should then define the key business drivers and the corresponding architecture characteristics, also known as *nonfunctional requirements*, and prioritize them. For example, if time to market is critical, the team might prioritize maintainability, testability, and reliability to enable rapid deployment. If the team has tight budget constraints, feasibility and simplicity might take precedence. Selecting and sustaining an architectural style isn't a one-time task. It requires ongoing measurement, validation, and refinement. Because changing architectural direction later can be costly, it's often worthwhile to invest more effort upfront to support long-term efficiency and reduce risks.

The following table summarizes how each style manages dependencies, and the types of domain that are best suited for each style.

| Architecture style | Dependency management | Domain type |
|--------------------|------------------------|-------------|
| [N-tier][n-tier] | Horizontal tiers divided by subnet | Traditional business domain. Frequency of updates is low. |
| [Web-Queue-Worker](./web-queue-worker.md) | Front-end and back-end jobs, decoupled by asynchronous messaging. | Relatively simple domain with some resource-intensive tasks. |
| [Microservices][microservices] | Vertically (functionally) decomposed services that call each other through APIs. | Complicated domain. Frequent updates. |
| [Event-driven architecture](./event-driven.md) | Producer or consumer. Independent view for each subsystem. | Internet of Things (IoT) and real-time systems. |
| [Big data](./big-data.md) | Divide a huge dataset into small chunks. Parallel processing on local datasets. | Batch and real-time data analysis. Predictive analysis by using machine learning. |
| [Big compute](./big-compute.md) | Data allocation to thousands of cores. | Compute intensive domains such as simulation. |

## Consider challenges and benefits

Constraints also create challenges, so it's important to understand the trade-offs when you adopt any of these styles. Determine if the benefits of the architecture style outweigh the challenges, *for this subdomain and bounded context*.

Consider the following types of challenges when you select an architecture style:

- **Complexity:** The architecture's complexity must match the domain. If it's too simplistic, it can result in a [big ball of mud][ball-of-mud], where dependencies aren't well managed and the structure breaks down.

- **Asynchronous messaging and eventual consistency:** Asynchronous messaging is used to decouple services and improve reliability because messages can be retried. It also enhances scalability. However, asynchronous messaging also creates challenges in handling eventual consistency and the possibility of duplicate messages.

- **Interservice communication:** Decomposing an application into separate services might increase communication overhead. In microservices architectures, this overhead often results in latency problems or network congestion.

- **Manageability:** Managing the application includes tasks such as monitoring, deploying updates, and maintaining operational health.

## Related resources

- [Ten design principles for Azure applications](../design-principles/index.md)

## Next steps

- [Build applications on the Microsoft Cloud](/microsoft-cloud/)
- [Best practices in cloud applications](/azure/architecture/best-practices/index-best-practices)
- [Cloud design patterns](/azure/architecture/patterns)
- [Performance testing and antipatterns for cloud applications](/azure/architecture/antipatterns)
- [Architect multitenant solutions on Azure](/azure/architecture/guide/multitenant/overview)
- [Mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-overview)
- [Architecture for startups](/azure/architecture/guide/startups/startup-architecture)

[ball-of-mud]: https://en.wikipedia.org/wiki/Big_ball_of_mud
[microservices]: ./microservices.md
[n-tier]: ./n-tier.md
[web-queue-worker]: ./web-queue-worker.md
