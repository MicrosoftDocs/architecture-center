---
title: Microservices Architecture Style
description: Learn about microservices on Azure, an architectural style for applications that are resilient, highly scalable, and independently deployable.
author: RobBagby
ms.author: robbag
ms.date: 07/26/2022
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: fcp
---

# Microservices architecture style

Microservices are a popular architectural style for building applications that are resilient, highly scalable, independently deployable, and able to evolve quickly. A successful microservices architecture requires a complete mindset shift. It's not just about breaking an architecture into smaller services. You also need to rethink how you design, deploy, and operate systems. 

A microservices architecture consists of a collection of small, autonomous services. Each service is self-contained and should implement a single business capability within a bounded context. A bounded context is a natural division within a business and provides an explicit boundary within which a domain model exists.

:::image type="complex" border="false" source="./images/microservices-logical.svg" alt-text="Logical diagram of microservices architecture style." lightbox="./images/microservices-logical.svg":::
   The diagram illustrates a microservices architecture deployed on Microsoft Azure. It's organized into eight labeled sections that each represent a key architectural component. The layout flows from left to right and top to bottom. On the far left, icons labeled clients represent users or external systems that initiate requests to the application. An arrow points from the clients to API Gateway. Requests flow through API Gateway and on to the appropriate microservices. Arrows point from API Gateway to a box labeled microservices. This box contains two icons for domain services, one icon for composition services, and one icon for service. Arrows point from the microservices to another box that's labeled data persistence. This box contains icons that represent SQL DB, NoSQL DB, and SQL DB. Arrows also point from microservices to a box that represents event streaming and messaging services. The diagram also includes boxes that represent observability, management and orchestration, and DevOps.
:::image-end:::

## What are microservices?

- Microservices are small, independent, and loosely coupled. A single small team of developers can write and maintain a service.

- Each service is a separate codebase, which can be managed by a small development team.

- Services can be deployed independently. A team can update an existing service without rebuilding and redeploying the entire application.

- Services are responsible for persisting their own data or external state. This approach differs from the traditional model, where a separate data layer handles data persistence.

- Services communicate with each other by using well-defined APIs. Internal implementation details of each service are hidden from other services.

- Supports polyglot programming. For example, services don't need to share the same technology stack, libraries, or frameworks.

## Components

In addition to the services themselves, some other components appear in a typical microservices architecture:

**Management/orchestration.** This management component is responsible for microservices orchestration, ensuring efficient scheduling and deployment of services across nodes, detecting and recovering from failures, and enabling autoscaling based on demand. Typically, this functionality is provided by a container orchestration platform like Kubernetes. In cloud-native environments, solutions like Azure Container Apps offer managed container orchestration with built-in scaling, simplifying deployment and operational overhead. 

**API Gateway.** The API gateway is the entry point for clients. Instead of calling services directly, clients call the API gateway, which forwards the call to the appropriate services on the back end. The API gateway handles common cross-cutting concerns like authentication, logging, and load balancing. In a cloud-native microservices architecture, lightweight service proxies like Envoy and Nginx might also be used for internal service-to-service communication, also known as East/West traffic to enable advanced routing and traffic control.

**Message-oriented middleware (MOM).** Messaging platforms like Apache Kafka and Azure Service Bus enable asynchronous communication in microservices by promoting loose coupling and supporting high scalability. They're foundational to event-driven architectures, allowing services to react to events in real-time and also communicate via async messaging. 

**Observability.** Having an effective observability strategy is crucial in microservices, enabling teams to maintain system reliability and quickly resolve problems. Centralized logging consolidates logs for easier diagnostics, while real-time monitoring via APM agents and open-source observability frameworks like OpenTelemetry (OTel) provides visibility into system health and performance. Distributed tracing is also essential for tracking requests across service boundaries, helping identify bottlenecks and optimize performance. 

**Data management.** A well-designed database architecture is critical for microservices, supporting autonomy and scalability. Microservices often adopt polyglot persistence, using different types of databases like SQL and NoSQL based on each service's specific needs. This aligns with the principle of Domain Driven Design (DDD)/Bounded Context, where each service owns its data and schema, reducing cross-service dependencies and enabling independent evolution. This decentralized approach enhances flexibility, performance optimization, and resilience across the system.  

## Benefits

- **Agility.** Because microservices are deployed independently, it's easier to manage bug fixes and feature releases. You can update a service without redeploying the entire application, and roll back an update if something goes wrong. In many traditional applications, if a bug is found in one part of the application, it can block the entire release process. New features might be held up waiting for a bug fix to be integrated, tested, and published.

- **Small, focused teams.** A microservice should be small enough that a single feature team can build, test, and deploy it. Small team sizes promote greater agility. Large teams tend to be less productive, because communication is slower, management overhead goes up, and agility diminishes.

- **Small code base.** In a monolithic application, there's a tendency over time for code dependencies to become tangled. Adding a new feature requires touching code in many places. By not sharing code or data stores, a microservices architecture minimizes dependencies, and that makes it easier to add new features.

- **Mix of technologies.** Teams can pick the technology that best fits their service, using a mix of technology stacks as appropriate.

- **Fault isolation.** If an individual microservice becomes unavailable, it doesn't disrupt the entire application, as long as any upstream microservices are designed to handle faults correctly. For example, you can implement the [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker), or you can design your solution so that the microservices communicate with each other using [asynchronous messaging patterns](/dotnet/architecture/microservices/architect-microservice-container-applications/asynchronous-message-based-communication).

- **Scalability.** Services can be scaled independently, letting you scale out subsystems that require more resources, without scaling out the entire application. Using an orchestrator such as Kubernetes, you can pack a higher density of services onto a single host, which allows for more efficient utilization of resources.

- **Data isolation.** It's easier to perform schema updates, because only a single microservice is affected. In a monolithic application, schema updates can become challenging, because different parts of the application might all touch the same data, making any alterations to the schema risky.

## Challenges

The benefits of microservices don't come for free. Here are some of the challenges to consider before embarking on a microservices architecture.

- **Complexity.** A microservices application has more moving parts than the equivalent monolithic application. Each service is simpler, but the entire system as a whole is more complex. Make sure that you consider challenges like service discovery, data consistency, transaction management, and inter-service communication when you design your application.

- **Development and testing.** Writing a small service that relies on other dependent services requires a different approach than writing a traditional monolithic or layered application. Existing tools aren't always designed to work with service dependencies. Refactoring across service boundaries can be difficult. It's also challenging to test service dependencies, especially when the application is evolving quickly.

- **Lack of governance.** The decentralized approach to building microservices has advantages, but it can also lead to problems. You might end up with so many different languages and frameworks that the application becomes hard to maintain. It might be useful to put some project-wide standards in place, without overly restricting teams' flexibility. This method especially applies to cross-cutting functionality such as logging.

- **Network congestion and latency.** The use of many small, granular services can result in more interservice communication. Also, if the chain of service dependencies gets too long (service A calls B, which calls C...), the extra latency can become a problem. You need to design APIs carefully. Avoid overly chatty APIs, think about serialization formats, and look for places to use asynchronous communication patterns like [queue-based load leveling](../../patterns/queue-based-load-leveling.yml).

- **Data integrity.** Each microservice is responsible for its own data persistence. As a result, data consistency across multiple services can be a challenge. Different services persist data at different times, using different technology, and with potentially different levels of success. When more than one microservice is involved in persisting new or changed date, it's unlikely that the complete data change could be considered an ACID transaction. Instead, the technique is more aligned to BASE (Basically Available, Soft state, and Eventually consistent). Embrace eventual consistency where possible.

- **Management.** To be successful with microservices requires a mature DevOps culture. Correlated logging across services can be challenging. Typically, logging must correlate multiple service calls for a single user operation.

- **Versioning.** Updates to a service must not break services that depend on it. Multiple services could be updated at any given time, so without careful design, you might have problems with backward or forward compatibility.

- **Skill set.** Microservices are highly distributed systems. Carefully evaluate whether the team has the skills and experience to be successful.

## Best practices

- Model services around the business domain. Use domain-driven design (DDD) to identify bounded contexts and define clear service boundaries. Avoid creating overly granular services, which can increase complexity and reduce performance.

- Decentralize everything. Individual teams are responsible for designing and building services end to end. Avoid sharing code or data schemas.

- Standardize your technology choices by limiting the number of languages and frameworks that you use. Establish platform-wide standards for logging, monitoring, and deployment.

- Data storage should be private to the service that owns the data. Use the best storage for each service and data type.

- Services communicate through well-designed APIs. Avoid leaking implementation details. APIs should model the domain, not the internal implementation of the service.

- Avoid coupling between services. Causes of coupling include shared database schemas and rigid communication protocols.

- Improve security by using mTLS for service-to-service encryption. Implement role-based access control and use API gateways to enforce policies.

- Offload cross-cutting concerns, such as authentication and SSL termination, to the gateway. Service meshes and frameworks like Dapr can also help with common cross-cutting concerns like mTLS authentication and resiliency.

- Keep domain knowledge out of the gateway. The gateway should handle and route client requests without any knowledge of the business rules or domain logic. Otherwise, the gateway becomes a dependency and can cause coupling between services.

- Services should have loose coupling and high functional cohesion. Functions that are likely to change together should be packaged and deployed together. If they reside in separate services, those services end up being tightly coupled, because a change in one service requires updating the other service. Overly chatty communication between two services might be a symptom of tight coupling and low cohesion.

- Use CI/CD pipelines to automate testing and deployment. Deploy services independently and monitor rollout health.

- Isolate failures. Use resiliency strategies to prevent failures within a service from cascading. See [Resiliency patterns](/azure/well-architected/reliability/design-patterns) and [Designing reliable applications](/azure/well-architected/reliability/principles).

- Use chaos engineering to test the resiliency of your microservice architecture and its dependencies. Evaluate and improve how the system handles partial failures.

- Implement centralized logging, distributed tracing (OpenTelemetry), and metrics collection to ensure observability.

## Antipatterns for microservices

When designing and implementing microservices, certain pitfalls frequently arise that can undermine the benefits of this architectural style. Recognizing these anti-patterns helps teams avoid costly mistakes and build more resilient, maintainable systems. The following are some key anti-patterns to avoid:

- Implementing microservices without a deep understanding of the business domain leads to poorly aligned service boundaries and undermines the intended benefits.

- Designing events that depend on past or future events breaks the principle of atomic and self-contained messaging, making consumers wait and reducing system reliability.

- Using database entities as events exposes internal service details and often fails to convey the correct business intent, leading to tightly coupled and unclear integrations.

- Avoiding data duplication at all costs is an anti-pattern. Using patterns like materialized views to maintain local copies improves service autonomy and reduces cross-service dependencies.

- Using generic events forces consumers to interpret and filter messages, adding unnecessary complexity and reducing clarity in event-driven communication.

- Sharing common libraries or dependencies between microservices creates tight coupling, making changes risky and widespread, and goes against the principle of self-contained services.

- Exposing microservices directly to consumers leads to tight coupling, scalability issues, and security risks. Using an API Gateway provides a clean, manageable, and secure entry point.

- Keeping configuration values inside microservices tightly couples them to specific environments, making deployments harder. However, externalizing configuration promotes flexibility and environment portability.

- Embedding security logic like token validation directly inside microservices complicates their code and maintenance. Offloading security to dedicated components, on the other hand, keeps services focused and cleaner.

- Failing to abstract common microservices tasks leads to repetitive, error-prone code and limits flexibility, whereas using abstraction frameworks like Dapr simplifies development and addresses platform limitations.

## Process for building a microservices architecture

The articles listed here present a structured approach for designing, building, and operating a microservices architecture.

**Domain analysis.** To avoid some common pitfalls when designing microservices, use domain analysis to define your microservice boundaries. Follow these steps:

1. [Use domain analysis to model microservices](../../microservices/model/domain-analysis.md).
1. [Use tactical DDD to design microservices](../../microservices/model/tactical-ddd.yml).
1. [Identify microservice boundaries](../../microservices/model/microservice-boundaries.yml).

**Design the services.** Microservices require a decentralized and agile approach to designing and building applications. For more information, see [Designing a microservices architecture](../../microservices/design/index.yml).

**Operate in production.** Because microservices architectures are distributed, you must have robust operations for deployment and monitoring.

- [CI/CD for microservices architectures](../../microservices/ci-cd.yml)
- [Build a CI/CD pipeline for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.yml)

## Related resources

- [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)