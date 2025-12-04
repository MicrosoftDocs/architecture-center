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
   The diagram illustrates the layered structure of an N-tier architecture with clear separation between components. Client requests enter through a web application firewall (WAF) that provides security filtering before reaching the web tier. The web tier serves as the presentation layer. It handles user interactions and routing requests to appropriate business logic components. Two distinct processing paths emerge from the web tier: one path flows directly to middle tier one for synchronous operations, while another path uses messaging infrastructure to communicate with middle tier two for asynchronous processing. Both middle tiers represent business logic layers that process requests and interact with the data tier through caching mechanisms to optimize performance. The data tier serves as the foundation. It stores and manages application data while supporting both middle tiers through cached data access patterns.
:::image-end:::

**[N-tier][n-tier]** is a traditional architecture for enterprise applications that divides an application into logical layers and physical tiers. Each layer has a specific responsibility, and layers manage dependencies by only calling into layers below them. Typical layers include presentation, business logic, and data access.

N-tier architectures are well-suited for migrating existing applications that already use a layered architecture. This approach requires minimal changes when moving to Azure and supports mixed environments with both on-premises and cloud components. But the horizontal layering can make it difficult to introduce changes without affecting multiple parts of the application, which limits agility for frequent updates.

### Web-Queue-Worker

:::image type="complex" border="false" source="./images/web-queue-worker-logical.svg" alt-text="Logical diagram of Web-Queue-Worker architecture style." lightbox="./images/web-queue-worker-logical.svg":::
   The diagram shows a clean separation between user-facing and background processing components. Client interactions begin with authentication through an identity provider before reaching the web front end, which serves as the primary user interface. The web front end maintains three distinct operational relationships: it can directly communicate with remote services for external integrations, access the database for immediate data operations, and enqueue work items for background processing. The queue serves as a decoupling mechanism. It enables the worker component to process resource-intensive or long-running tasks independently from user requests. The worker retrieves jobs from the queue and performs operations against the database, with caching infrastructure that supports both the web front end and worker for optimized data access. Also, static content is distributed through a content delivery network (CDN) to improve performance for client applications.
:::image-end:::

**[Web-Queue-Worker][web-queue-worker]** is an architecture that consists of a web front end, a message queue, and a back-end worker. The web front end handles HTTP requests and user interactions, while the worker performs resource-intensive tasks, long-running workflows, or batch operations. Communication between the front end and worker occurs through an asynchronous message queue.

This architecture is ideal for applications with relatively simple domains that have some resource-intensive processing requirements. It's easy to understand and deploy with managed Azure services like App Service and Azure Functions. You can scale the front end and worker independently to provide flexibility in resource allocation. But without careful design, both components can become large and monolithic.

### Microservices

:::image type="complex" border="false" source="./images/microservices-logical.svg" alt-text="Logical diagram of microservices architecture style." lightbox="./images/microservices-logical.svg":::
   The diagram depicts a distributed microservices architecture organized into distinct functional layers. On the left, client applications and external systems initiate requests that flow through a centralized API gateway, which serves as the single entry point and routing mechanism for the entire system. The API gateway directs requests to the appropriate microservices layer, which contains multiple service types: domain services that encapsulate specific business capabilities, composition services that orchestrate interactions between domain services, and individual services that handle discrete functions. Each microservice maintains data autonomy through its own dedicated database. The diagram shows a polyglot persistence approach using both SQL and NoSQL databases tailored to each service's specific data requirements. The microservices communicate asynchronously through message-oriented middleware. This approach enables loose coupling by way of publish-subscribe patterns and event-driven interactions. Three foundational infrastructure layers support this distributed architecture: observability systems provide comprehensive monitoring, logging, and distributed tracing across service boundaries. Management and orchestration platforms handle automated deployment, scaling, and service discovery. DevOps toolchains enable continuous integration, testing, and delivery pipelines for independent service deployments.
:::image-end:::

**The [Microservices][microservices]** architecture decomposes applications into a collection of small, autonomous services. Each service implements a single business capability within a bounded context and is self-contained with its own data storage. Services communicate through well-defined APIs and can be developed, deployed, and scaled independently.

Microservices enable teams to work autonomously and support frequent updates with higher release velocity. This architecture is well-suited for complex domains that require frequent changes and innovation. But it introduces significant complexity in areas such as service discovery, data consistency, and distributed system management. Success requires mature development and DevOps practices, which makes it more suitable for organizations that have advanced technical capabilities.

### Event-driven architecture

:::image type="complex" border="false" source="./images/event-driven.svg" alt-text="Diagram of an event-driven architecture style." lightbox="./images/event-driven.svg":::
   The diagram illustrates a decoupled, asynchronous communication pattern fundamental to event-driven architectures. Multiple event producers operate independently. The generated streams of events based on business activities, user interactions, or system state changes without any knowledge of downstream consumers. The producers feed their events into a centralized event ingestion system that serves as an intelligent broker. The broker receives, validates, persists, and reliably distributes events across the architecture. The event ingestion component serves as a critical decoupling point. It ensures producers remain isolated from consumers while it provides guarantees around event delivery, ordering, and durability. From this central hub, events are distributed through a fan-out pattern to multiple independent event consumers positioned on the right side of the diagram. Each consumer represents a distinct business capability or service that subscribes to specific event types relevant to its domain responsibilities. The consumers process events asynchronously and in parallel, enabling the system to scale horizontally while maintaining loose coupling. This architectural pattern removes direct dependencies between producers and consumers. It lets each component evolve, scale, and deploy independently while maintaining system resilience through the event broker's buffering and retry capabilities.
:::image-end:::

**[Event-driven architectures](./event-driven.md)** use a publish-subscribe model where event producers generate streams of events, and event consumers respond to those events in near real time. Producers and consumers are decoupled from each other, with communication happening through event channels or brokers. This architecture supports both simple event processing and complex event pattern analysis.

Event-driven architectures excel in scenarios that require real-time processing with minimal latency. Some examples are IoT solutions, financial trading systems, or applications that need to process high volumes of streaming data. Event-driven architectures provide excellent scalability and fault isolation but introduce challenges around guaranteed delivery, event ordering, and eventual consistency across distributed components.

### Big data

:::image type="complex" border="false" source="./images/big-data-logical.svg" alt-text="Logical diagram of a big data architecture style." lightbox="./images/big-data-logical.svg":::
   The diagram presents a comprehensive big data architecture with two complementary processing pipelines that handle different data velocities and analytical requirements. The batch processing pipeline begins with diverse data sources that feed into scalable data storage systems, typically data lakes, or distributed file systems capable of storing massive volumes of structured, semi-structured, and unstructured data. The batch processing component performs large-scale transformations, aggregations, and analytical computations on the historical data. It operates on scheduled intervals or when sufficient data accumulates. Results from batch processing flow through two pathways: directly to analytics and reporting systems for immediate consumption, and to analytical data stores where processed data is persisted in optimized formats for complex queries and historical analysis. Simultaneously, the real-time processing pipeline captures streaming data through real-time message ingestion systems that handle high-velocity data streams from sources like IoT devices, web applications, or transactional systems. Stream processing components analyze this data in motion, performing real-time aggregations, filtering, and pattern detection to generate immediate insights. The real-time results also follow dual pathways, feeding both directly into analytics and reporting for instant dashboards and alerts, and into the same analytical data stores to create a unified view combining historical and current data. The orchestration layer spans both pipelines. It coordinates complex workflows, manages dependencies between batch and streaming jobs, schedules processing tasks, and ensures data consistency across the entire architecture. This orchestration enables you to create lambda architectures where both batch and real-time processing can operate on the same datasets, providing both comprehensive historical analysis and immediate operational intelligence.
:::image-end:::

**[Big data](./big-data.md)** architectures handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. These architectures typically include components for data storage (like data lakes), batch processing for historical analysis, stream processing for real-time insights, and analytical data stores for reporting and visualization.

Big data architectures are essential for organizations that need to extract insights from massive datasets, support predictive analytics using machine learning, or process real-time streaming data from IoT devices. Modern implementations often use managed services like Microsoft Fabric to simplify the complexity of building and maintaining big data solutions.

### Big compute

:::image type="complex" border="false" source="./images/big-compute-logical.png" alt-text="Diagram that illustrates a big compute architecture style." lightbox="./images/big-compute-logical.png":::
   The diagram illustrates a sophisticated job distribution and operation system designed for high-performance computing workloads. At the entry point, client applications submit computationally intensive jobs through a job queue interface that acts as a buffer and intake mechanism for incoming work requests. The jobs flow into a centralized scheduler or coordinator component that serves as the intelligent brain of the system, responsible for analyzing job characteristics, resource requirements, and computational dependencies. The scheduler performs critical functions including job decomposition, resource allocation planning, and workload optimization based on available computing resources and task interdependencies. From this central coordination point, the scheduler intelligently routes work along two distinct operation pathways based on the computational characteristics of each job. The first pathway directs work to parallel task handling environments designed for embarrassingly parallel workloads where individual tasks can run independently without requiring communication between processing units. These parallel tasks are distributed across hundreds or thousands of cores simultaneously, with each core processing discrete units of work in isolation. The second pathway handles tightly coupled tasks that require frequent inter-process communication, shared memory access, or synchronized operation patterns. These tightly coupled workloads typically use high-speed interconnects like InfiniBand or remote direct memory access (RDMA) networks to enable rapid data exchange between processing nodes. The scheduler continuously monitors both operation environments, manages resource allocation, handles fault tolerance, and optimizes performance by dynamically adjusting the distribution of work based on system capacity, job priorities, and completion requirements. The bifurcated approach allows the architecture to efficiently handle diverse computational workloads while maximizing resource use across the entire computing infrastructure.
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

- [Build applications on the Microsoft Cloud](/microsoft-cloud/dev/overview/introduction)
- [Best practices in cloud applications](/azure/architecture/best-practices/index-best-practices)
- [Cloud design patterns](/azure/architecture/patterns)
- [Performance testing and antipatterns for cloud applications](/azure/architecture/antipatterns)
- [Architect multitenant solutions on Azure](/azure/architecture/guide/multitenant/overview)
- [Mission-critical workload architecture on Azure](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)
- [Architecture for startups](/azure/architecture/guide/startups/startup-architecture)

[ball-of-mud]: https://en.wikipedia.org/wiki/Big_ball_of_mud
[microservices]: ./microservices.md
[n-tier]: ./n-tier.md
[web-queue-worker]: ./web-queue-worker.md
