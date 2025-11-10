---
title: Domain analysis for microservices
description: This article shows a domain-driven approach to designing microservices so that each service follows the general rule of doing just one thing.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/25/2019
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Using domain analysis to model microservices

One of the biggest challenges of microservices is to define the boundaries of individual services. The general rule is that a service should do only one thing, but putting that rule into practice requires careful thought. There's no mechanical process that produces the correct design. You have to think deeply about your business domain, requirements, architecture characteristics (also known as *nonfunctional requirements*), and goals. Otherwise, you can end up with a haphazard design that exhibits some undesirable characteristics, such as hidden dependencies between services, tight coupling, or poorly designed interfaces. This article shows a domain-driven approach to designing microservices. Evaluating service boundaries is an ongoing effort on evolving workloads. Sometimes the evaluation results in redefined definitions of existing boundaries that require more application development to accommodate the changes.

This article uses a drone delivery service as a running example. For more information about the scenario and the corresponding reference implementation, see [Design a microservices architecture](../design/index.md).

## Introduction

Microservices should be designed around business capabilities, not horizontal layers such as data access or messaging. In addition, they should have loose coupling and high functional cohesion. Microservices are *loosely coupled* if you can change one service without requiring other services to be updated at the same time. A microservice is *cohesive* if it has a single, well-defined purpose, such as managing user accounts or tracking delivery history. A service should encapsulate domain knowledge and abstract that knowledge from clients. For example, a client should be able to schedule a drone without knowing the details of the scheduling algorithm or how the drone fleet is managed. Architecture characteristics have to be defined for each microservice to match its domain concerns, rather than being defined for the entire system. For example, a customer-facing microservice might need to have performance, availability, fault tolerance, security, testability, and agility. A backend microservice might need to have only fault tolerance and security. If microservices have synchronous communications with each other, the dependency between them often produces the need to share the same architecture characteristics.

Domain-driven design (DDD) provides a framework that can get you most of the way to a set of well-designed microservices. DDD has two distinct phases, strategic and tactical. In strategic DDD, you define the large-scale structure of the system. Strategic DDD helps to ensure that your architecture remains focused on business capabilities. Tactical DDD provides a set of design patterns that you can use to create the domain model. These patterns include entities, aggregates, and domain services. These tactical patterns help you to design microservices that are both loosely coupled and cohesive.

:::image type="complex" border="false" source="../images/ddd-process.png" alt-text="Diagram that shows a DDD process." lightbox="../images/ddd-process.png":::
   The image has four sections: Analyze domain, Define bounded contexts, Define entities, aggregates, and services, and Identify microservices. Double greater-than signs indicate a flow between the sections, from left to right.
:::image-end:::

In this article and the next, we'll walk through the following steps, applying them to the Drone Delivery application:

1. Start by analyzing the business domain to understand the application's functional requirements. The output of this step is an informal description of the domain, which can be refined into a more formal set of domain models.

2. Next, define the *bounded contexts* of the domain. Each bounded context contains a domain model that represents a particular subdomain of the larger application.

3. Within a bounded context, apply tactical DDD patterns to define entities, aggregates, and domain services.

4. Use the results from the previous step to identify the microservices in your application.

In this article, we cover the first three steps, which are primarily concerned with DDD. In the next article, we'll identify the microservices. However, it's important to remember that DDD is an iterative, ongoing process. Service boundaries aren't fixed in stone. As an application evolves, you might decide to break apart a service into several smaller services.

> [!NOTE]
> This article doesn't show a complete and comprehensive domain analysis. We deliberately kept the example brief, to illustrate the main points. For more background on DDD, we recommend Eric Evans' *Domain-Driven Design*, the book that first introduced the term. Another good reference is *Implementing Domain-Driven Design* by Vaughn Vernon.

## Scenario: Drone delivery

Fabrikam, Inc. is starting a drone delivery service. The company manages a fleet of drone aircraft. Businesses register with the service, and users can request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user with an estimated delivery time. While the delivery is in progress, the customer can track the location of the drone, with a continuously updated ETA.

This scenario includes a fairly complex domain. Some of the key business concerns include scheduling drones, tracking packages, managing user accounts, and storing and analyzing historical data. Fabrikam also aims to get to market quickly and iterate rapidly, adding new functionality and capabilities. The application must operate at cloud scale and meet a high service-level objective. Also, Fabrikam expects different parts of the system to have varying requirements for data storage and querying. These considerations lead Fabrikam to adopt a microservices architecture for the Drone Delivery application.

## Analyze the domain

A DDD approach helps you design microservices so that every service forms a natural fit to a functional business requirement. It can help you to avoid the trap of letting organizational boundaries or technology choices dictate your design.

Before you write any code, you should have a high-level understanding of the system that you build. DDD starts by modeling the business domain and creating a *domain model*. The domain model is an abstract model of the business domain. It distills and organizes domain knowledge and provides a common language for developers and domain experts.

Start by mapping all the business functions and their connections. This effort can be a collaboration that includes domain experts, software architects, and other stakeholders. You don't need to use any particular formalism. Sketch a diagram or draw on whiteboard.

As you fill in the diagram, you might start to identify discrete subdomains. Which functions are closely related? Which functions are core to the business, and which functions provide ancillary services? What's the dependency graph? During this initial phase, you aren't concerned with technologies or implementation details. That said, you should note the place where the application needs to integrate with external systems, such as customer relationship management, payment processing, or billing systems.

## Example: Drone delivery application

After some initial domain analysis, the Fabrikam team came up with a rough sketch that depicts the Drone Delivery domain.

:::image type="complex" border="false" source="../images/ddd1.svg" alt-text="Diagram that shows the Drone Delivery domain." lightbox="../images/ddd1.svg":::
   The diagram is an interconnected web with multiple connecting lines and ovals that contain words. Shipping connects to Drone management, Third party, Call center, Accounts, Invoicing, and Returns. Accounts connects to Call center, Shipping, Invoicing, User rating, and Loyalty. Drone management connects to Drone sharing, Predictive analysis, Drone repair, ETA analysis, Third party, and Shipping.
:::image-end:::

- **Shipping** is placed in the center of the diagram, because it's core to the business. Everything else in the diagram exists to enable this functionality.
- **Drone management** is also core to the business. Functionality that is closely related to drone management includes **drone repair** and using **predictive analysis** to predict when drones need servicing and maintenance.
- **ETA analysis** provides time estimates for pickup and delivery.
- **Third-party transportation** will enable the application to schedule alternative transportation methods if a package cannot be shipped entirely by drone.
- **Drone sharing** is a possible extension of the core business. The company might have excess drone capacity during certain hours, and could rent out drones that would otherwise be idle. This feature will not be in the initial release.
- **Video surveillance** is another area that the company might expand into later.
- **User accounts**, **Invoicing**, and **Call center** are subdomains that support the core business.

Notice that at this point in the process, we haven't made any decisions about implementation or technologies. Some of the subsystems might involve external software systems or third-party services. Even so, the application needs to interact with these systems and services, so it's important to include them in the domain model.

> [!NOTE]
> When an application depends on an external system, there's a risk that the external system's data schema or API can leak into the application. This kind of leakage can compromise the architectural design. It's especially common with legacy systems that don't follow modern best practices and might use convoluted data schemas or outdated APIs. In these cases, it's important to establish a well-defined boundary between the external system and the application. Consider using the [Strangler Fig pattern](../../patterns/strangler-fig.md) or the [Anti-Corruption Layer pattern](../../patterns/anti-corruption-layer.yml) to enforce this boundary.

## Define bounded contexts

The domain model will include representations of real things in the world &mdash; users, drones, packages, and so forth. But that doesn't mean that every part of the system needs to use the same representations for the same things.

For example, subsystems that handle drone repair and predictive analysis will need to represent many physical characteristics of drones, such as their maintenance history, mileage, age, model number, performance characteristics, and so on. But when it's time to schedule a delivery, we don't care about those things. The scheduling subsystem only needs to know whether a drone is available, and the ETA for pickup and delivery.

If we tried to create a single model for both of these subsystems, it would be unnecessarily complex. It would also become harder for the model to evolve over time, because any changes will need to satisfy multiple teams working on separate subsystems. Therefore, it's often better to design separate models that represent the same real-world entity (in this case, a drone) in two different contexts. Each model contains only the features and attributes that are relevant within its particular context.

The DDD concept of *bounded contexts* comes into play here. A bounded context defines the boundary within a domain where a specific domain model applies. Referring to the previous diagram, you can group functionality based on whether different functions share the same domain model.

:::image type="complex" border="false" source="../images/ddd2.svg" alt-text="Diagram that shows multiple bounded contexts." lightbox="../images/ddd2.svg":::
   The diagram is an interconnected web with multiple connecting lines and ovals that contain words. Dotted lines section off various ovals. Drone management is connected to Video surveillance, Shipping, and Third-party transportation. Accounts is connected to Drone sharing, Shipping, and Call center. The third-party transportation and Call center sections are both labeled as External systems.
:::image-end:::

Bounded contexts are not necessarily isolated from one another. In this diagram, the solid lines connecting the bounded contexts represent places where two bounded contexts interact. For example, Shipping depends on User Accounts to get information about customers, and on Drone Management to schedule drones from the fleet.

In the book *Domain Driven Design*, Eric Evans describes several patterns for maintaining the integrity of a domain model when it interacts with another bounded context. One of the main principles of microservices is that services communicate through well-defined APIs. This approach corresponds to two patterns that Evans calls Open Host Service and Published Language. The idea of Open Host Service is that a subsystem defines a formal protocol (API) for other subsystems to communicate with it. Published Language extends this idea by publishing the API in a form that other teams can use to write clients. In the article [Designing APIs for microservices](../design/api-design.md), we discuss using [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) (formerly known as Swagger) to define language-agnostic interface descriptions for REST APIs, expressed in JSON or YAML format.

For the rest of this journey, we will focus on the Shipping bounded context.

## Next steps

After completing a domain analysis, the next step is to apply tactical DDD, to define your domain models with more precision.

> [!div class="nextstepaction"]
> [Tactical DDD](./tactical-ddd.yml)

## Related resources

- [Microservices architecture design](../../guide/architecture-styles/microservices.md)
- [Design a microservices architecture](../../microservices/design/index.md)
- [Identify microservice boundaries](microservice-boundaries.yml)
- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
