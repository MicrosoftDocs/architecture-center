---
title: Use Domain Analysis to Model Microservices
description: This article shows a domain-driven approach to designing microservices so that each service follows the general rule of doing only one thing.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/23/2026
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Use domain analysis to model microservices

One of the biggest challenges of microservices is to define the boundaries of individual services. The general rule is that a service should do only one thing, but putting that rule into practice requires careful thought. There's no mechanical process that produces the correct design. You must think deeply about your business domain, requirements, architecture characteristics (also known as *nonfunctional requirements*), and goals. Otherwise, you risk creating an unstructured design that has hidden dependencies between services, tight coupling, or poorly designed interfaces. This article shows a domain-driven approach to designing microservices. Service boundary evaluation is an ongoing effort for evolving workloads. Sometimes the evaluation results in redefined boundaries that require more application development to accommodate the changes.

This article uses a drone delivery service as a running example. For more information about the scenario and the corresponding reference implementation, see [Design a microservices architecture](../design/index.md).

## Introduction

Design microservices around business capabilities, not horizontal layers like data access or messaging. Ensure that microservices have loose coupling and high functional cohesion. Microservices are *loosely coupled* if you can change one service without updating other services at the same time. A microservice is *cohesive* if it has a single, well-defined purpose, like managing user accounts or tracking delivery history. Services should encapsulate domain knowledge and abstract that knowledge from clients. For example, a client can schedule a drone without knowledge of the scheduling algorithm or drone fleet management.

You must define architecture characteristics for each microservice to match its domain concerns, rather than define them for the entire system. For example, a customer-facing microservice might require performance, availability, fault tolerance, security, testability, and agility. A back-end microservice might require only fault tolerance and security. When microservices communicate synchronously, their runtime dependency often requires them to share the same architecture characteristics.

Domain-driven design (DDD) provides a framework that supports the design of well-structured microservices. DDD has a *strategic* phase and a *tactical* phase. In strategic DDD, you define the large-scale system structure. Strategic DDD ensures that your architecture remains focused on business capabilities. Tactical DDD provides design patterns that you can use to create the domain model. These patterns include entities, aggregates, and domain services. These tactical patterns help you design microservices that are loosely coupled and cohesive.

The concept of *ubiquitous language* is central in DDD. It's a shared vocabulary that developers and domain experts create together within each bounded context. Teams use this language consistently in conversations, documentation, and code. When the same terms mean the same thing across all these areas, teams reduce misunderstandings and produce domain models that accurately reflect business intent. Each bounded context can have its own ubiquitous language, which means that the same word (like *account*) has different meanings in different contexts.

:::image type="complex" border="false" source="../images/ddd-process.png" alt-text="Diagram that shows a DDD process." lightbox="../images/ddd-process.png":::
   The image has four sections: analyze domain; define bounded contexts; define entities, aggregates, and services; and identify microservices. Double greater-than signs indicate a flow between the sections, from left to right.
:::image-end:::

This article and the related [Tactical DDD](./tactical-domain-driven-design.md) article present the following steps and apply them to the drone delivery application:

1. Analyze the business domain to understand the application's functional requirements. The output of this step is an informal description of the domain, which you can refine into a more formal set of domain models.

1. Define the *bounded contexts* of the domain. Each bounded context contains a domain model that represents a specific subdomain of the larger application.

1. Apply tactical DDD patterns within a bounded context to define entities, aggregates, and domain services.

1. Use the results from the previous step to identify the microservices in your application.

This article covers the first two steps, which primarily concern strategic DDD. The article [Tactical DDD](./tactical-domain-driven-design.md) covers step 3. The article [Identify microservice boundaries](microservice-boundaries.yml) covers step 4. DDD is an iterative, ongoing process, so service boundaries don't remain fixed. As an application evolves, you might decide to separate a service into several smaller services.

> [!NOTE]
> This article doesn't show a complete and comprehensive domain analysis. The example is intentionally brief and focuses on the key ideas. For more background about DDD, read Eric Evans's *Domain-Driven Design*, the book that first introduced the term. Another good reference is *Learning Domain-Driven Design* by Vlad Khononov for a practical, modern treatment of the subject.

## Scenario: Drone delivery

Fabrikam, Inc., starts a drone delivery service. The company manages a fleet of drone aircraft. Businesses register with the service, and users request a drone to pick up goods for delivery. When a customer schedules a pickup, a back-end system assigns a drone and notifies the user with an estimated delivery time. While the delivery progresses, the customer tracks the drone location, with a continuously updated estimated time of arrival (ETA).

This scenario involves a complex domain. Key business concerns include how to schedule drones, track packages, manage user accounts, and store and analyze historical data. Fabrikam also aims to reach market quickly and iterate rapidly to add new functionality and capabilities. The application must operate at cloud scale and meet a high service-level objective (SLO). Fabrikam also expects different parts of the system to have different requirements for data storage and query operations. These considerations lead Fabrikam to adopt a microservices architecture for the drone delivery application.

## Analyze the domain

A DDD approach helps you design microservices so that each service aligns naturally with a functional business requirement. It also helps you avoid letting organizational boundaries or technology choices dictate your design.

> [!TIP]
> [Conway's law](https://en.wikipedia.org/wiki/Conway's_law) observes that systems tend to mirror the communication structures of the organizations that build them. When that mirroring occurs passively, it can lead to architectures that reflect organizational charts rather than business domains. You can use DDD to your advantage by defining service boundaries through domain analysis and then intentionally aligning team ownership to those boundaries. This proactive approach ensures that your team structure supports the architecture rather than conflicting with it.
>
> If a single team must own multiple unrelated bounded contexts, or a single bounded context requires coordination across many teams, revisit either the boundaries or the team structure.

Before you write any code, you need a high-level understanding of the system that you build. DDD models the business domain and creates a *domain model*. The domain model is an abstract model of the business domain. It distills and organizes domain knowledge and establishes a shared language for developers and domain experts.

Start by mapping all the business functions and the connections among them. This effort should involve domain experts, software architects, and other stakeholders. You don't need to follow a specific formal method. For example, you can sketch a diagram or use a whiteboard. One structured approach involves *event storming*. Whether you use [event storming](https://wikipedia.org/wiki/Event_storming) or a less formal approach, the goal is to build a shared understanding of the domain before you choose technologies.

As you fill in the diagram, you might start to identify discrete subdomains. Look for the following patterns:

- Functions that are closely related

- Functions that are key to the business versus functions that provide supporting services

- The dependency graph between functions

During this initial phase, don't focus on technologies or implementation details. But you should identify where the application must integrate with external systems, like customer relationship management, payment processing, or billing systems.

## Example: Drone delivery application

After some initial domain analysis, the Fabrikam team creates a rough sketch that depicts the drone delivery domain.

:::image type="complex" border="false" source="../images/ddd1.svg" alt-text="Diagram that shows the drone delivery domain." lightbox="../images/ddd1.svg":::
   The diagram is an interconnected web that has multiple connecting lines and ovals that contain words. Shipping connects to drone management, third party, call center, accounts, invoicing, and returns. Accounts connects to call center, shipping, invoicing, user rating, and loyalty. Drone management connects to drone sharing, predictive analysis, drone repair, ETA analysis, third party, shipping, and video surveillance.
:::image-end:::

- **Shipping** appears in the center of the diagram because it's core to the business. Everything else in the diagram exists to support this functionality.

- **Drone management** is also core to the business. Functionality closely related to drone management includes drone repair and using predictive analysis to predict when drones need servicing and maintenance.

- **ETA analysis** provides time estimates for pickup and delivery.

- **Third-party transportation** lets the application schedule alternative transportation methods if a package can't be shipped entirely by drone.

- **Drone sharing** is a possible extension of the core business. The company might have excess drone capacity during specific hours and can rent out idle drones. The initial release doesn't include this feature.

- **Video surveillance** is another area that the company might expand into later.

- **User accounts**, **invoicing**, and **call center** are subdomains that support the core business.

DDD classifies subdomains into three categories, and this classification helps prioritize where to invest the most design effort:

- **Core subdomains** provide a competitive advantage. Shipping and drone management form core subdomains for Fabrikam because they define the business. These subdomains require detailed modeling and substantial team investment.

- **Supporting subdomains** keep the business operational but don't differentiate it from competitors. Invoicing falls into this category. It requires custom development but doesn't serve as the competitive advantage source.

- **Generic subdomains** represent problems that the industry already solved. User accounts and call center form generic subdomains that Fabrikam can address by using existing prebuilt or standard solutions rather than custom-built systems.

At this point in the process, Fabrikam hasn't made any decisions about implementation or technologies. Some of the subsystems might involve external software systems or non-Microsoft services. But the application needs to interact with these systems and services, so Fabrikam includes them in the domain model.

> [!NOTE]
> When an application depends on an external system, the external system's data schema or API might leak into the application. This leakage can compromise the architectural design. It's especially common in legacy systems that don't follow modern best practices and might use convoluted data schemas or outdated APIs. In these cases, establish a well-defined boundary between the external system and the application. Consider using the [Strangler Fig pattern](../../patterns/strangler-fig.md) or the [Anti-Corruption Layer pattern](../../patterns/anti-corruption-layer.yml) to enforce this boundary.

## Define bounded contexts

The domain model includes representations of real-world entities, like users, drones, packages, and other entities. But that doesn't mean that each part of the system needs to use the same representations for the same entities.

For example, subsystems that handle drone repair and predictive analysis need to represent many physical characteristics of drones, like their maintenance history, mileage, age, model number, and performance characteristics. But when the time comes to schedule a delivery, those details become irrelevant. The scheduling subsystem only needs to know whether a drone is available and the ETA for pickup and delivery.

Creating a single model for both subsystems introduces unnecessary complexity. The model also becomes harder to evolve over time because changes need to satisfy multiple teams that work on separate subsystems. As a result, it's better to design separate models that represent the same real-world entity (in this case, a drone) in two different contexts. Each model includes only the features and attributes that are relevant within its context.

The DDD concept of *bounded contexts* applies here. A bounded context defines the boundary within a domain where a specific domain model applies. Fabrikam can group functionality based on whether different functions share the same domain model.

:::image type="complex" border="false" source="../images/ddd2.svg" alt-text="Diagram that shows multiple bounded contexts." lightbox="../images/ddd2.svg":::
   The diagram is an interconnected web that has multiple connecting lines and ovals that contain words. Dotted lines section off each oval. Drone management connects to video surveillance, shipping, and third-party transportation. Accounts connects to drone sharing, shipping, and call center. The third-party transportation and call center sections are both labeled as external systems.
:::image-end:::

Bounded contexts aren't necessarily isolated from one another. In the previous diagram, the solid lines that connect the bounded contexts represent places where two bounded contexts interact. For example, shipping depends on user accounts to retrieve customer information and on drone management to schedule drones from the fleet.

Fabrikam identifies these interactions and creates a *context map* that documents the relationships between bounded contexts. A context map highlights integration points and helps teams clarify responsibilities. Evans and subsequent DDD practitioners describe several relationship patterns:

- [Customer-Supplier](https://ddd-practitioners.com/home/glossary/bounded-context/bounded-context-relationship/customer-supplier/): One context (upstream) provides data or services that another context (downstream) depends on. The teams negotiate the contract between them.

- [Open Host Service](https://ddd-practitioners.com/home/glossary/bounded-context/bounded-context-relationship/open-host-service/) and [Published Language](https://ddd-practitioners.com/home/glossary/bounded-context/bounded-context-relationship/published-language/): The upstream context exposes a well-defined API (Open Host Service) described in a shared format (Published Language) that downstream contexts consume.

- [Anti-corruption Layer](https://ddd-practitioners.com/home/glossary/bounded-context/bounded-context-relationship/anticorruption-layer/): The downstream team builds a [translation layer](../../patterns/anti-corruption-layer.yml) to protect its model from upstream model changes.

- [Separate Ways](https://ddd-practitioners.com/home/glossary/bounded-context/bounded-context-relationship/separate-ways/): Two contexts have no integration. Each context evolves independently.

In a microservices architecture, Open Host Service and Published Language are especially relevant because microservices communicate through well-defined APIs. The article [Design APIs for microservices](../design/api-design.md) describes how to use [OpenAPI specification](https://spec.openapis.org/oas/latest.html) to define language-agnostic interface descriptions for REST APIs, expressed in JSON or YAML format.

For the rest of this journey, we will focus on the shipping bounded context.

## Next step

After you complete a domain analysis, apply tactical DDD to define your domain models more precisely.

> [!div class="nextstepaction"]
> [Tactical DDD](./tactical-domain-driven-design.md)

## Related resources

- [Microservices architecture design](../../guide/architecture-styles/microservices.md)
- [Design a microservices architecture](../../microservices/design/index.md)
- [Identify microservice boundaries](microservice-boundaries.yml)
- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
