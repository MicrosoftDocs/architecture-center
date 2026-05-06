---
title: Use Tactical DDD to Design Microservices
description: Use domain-driven design in a microservices architecture to identify the entity and aggregate patterns, which help identify natural boundaries for the services.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/25/2026
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
azureCategories:
  - developer-tools
products:
  - azure-devops

---

# Use tactical DDD to design microservices

Domain-driven design (DDD) rejects a single unified model for the entire system. It instead encourages you to divide the system into bounded contexts that each has its own model. The [domain analysis](domain-analysis.md) article covers the strategic phase of DDD. This article continues those steps and applies tactical DDD patterns to define domain models more precisely within their bounded contexts.

In a microservices architecture, where each bounded context is a microservice candidate, the entity and aggregate patterns matter. Applying these patterns helps identify natural boundaries for the services in your application. For more information, see [Identify microservice boundaries](./microservice-boundaries.yml). As a general principle, design a microservice to be no smaller than an aggregate and no larger than a bounded context.

This article reviews the tactical patterns and then applies them to the shipping bounded context in the Drone Delivery application.

## Overview of the tactical patterns

This section summarizes the tactical DDD patterns. If you're familiar with DDD, you can continue to the next section. These patterns appear in Eric Evans' *Domain-Driven Design*, the book that introduced the term. Another practical, modern reference is *Learning Domain-Driven Design* by Vlad Khononov.

:::image type="complex" border="false" source="../images/ddd-patterns.png" alt-text="Diagram of tactical patterns in DDD." lightbox="../images/ddd-patterns.png":::
   The diagram has five key sections. An arrow points from application service to domain service. One arrow points from domain service to the aggregate section. Another arrow points from domain service to an aggregate section that contains root entity, entity, and value object. A line points from the first aggregate section to the domain event section.
:::image-end:::

### Entities

An entity is an object that has a unique identity that persists over time. For example, in a banking application, customers and accounts are entities.

An entity has the following characteristics:

- An entity has a unique identifier in the system, which you can use to look up or retrieve the entity.

  - Two entity instances that share the same identity represent the same domain concept, even if their attributes differ at a given point in time. For instance, a person's name or address might change, but they remain the same individual. Conversely, two instances that have identical attributes but different identities are distinct entities.

  - The identifier isn't always exposed directly to users. It can be a globally unique identifier (GUID) or a primary key in a database.

   Choose your identity strategy intentionally. Natural keys, like an order number or a government-issued ID, convey business meaning and are recognized across systems. Surrogate keys, like GUIDs, lack business meaning but avoid coupling to external systems. In a microservices architecture, other services reference entities by their identifiers, so the identity must remain stable and meaningful across service boundaries. An identity can span multiple bounded contexts and might persist beyond the lifetime of the application.

- Entities should encapsulate behavior, not only carry data. When business logic lives outside the entity in service classes, you create an *anemic domain model*. That antipattern undermines the benefit of DDD, which is to express business rules inside the domain model. Put validation, state transitions, and business rules inside the entity. For example, a `Delivery` entity should contain the logic to determine whether you can cancel it, rather than delegate that decision to an external service.

### Value objects

A value object has no identity. It's defined only by the values of its attributes. Two value objects that have the same attribute values are interchangeable. Common examples include colors, dates and times, currency amounts, and measurements.

- Value objects are immutable. To update a value object, you create a new instance to replace the old instance. You can share immutable objects across threads, cache them without defensive copying, and reason about them more easily in distributed systems.

- Value objects can include methods that encapsulate domain logic, but those methods shouldn't produce side effects. They return new value objects instead.

Prefer value objects as your default modeling choice. Only promote a concept to an entity when you need to track its identity over time. For example, an `Address` is typically a value object because two addresses with the same street, city, and postal code are interchangeable. But if your domain must track a specific address record over time, like for audit purposes, then it becomes an entity.

### Aggregates

An aggregate defines a consistency boundary around one or more entities. Exactly one entity in an aggregate is the root. Lookup is done by using the root entity's identifier. Any other entities in the aggregate are children of the root, and are referenced by following pointers from the root.

Use aggregates to model transactional invariants. Real-world domains contain complex relationships. Customers create orders, orders contain products, and products have suppliers. When the application modifies several related objects, it must enforce consistency and uphold the required invariants.

Traditional applications typically enforce consistency through database transactions. In a distributed application, that approach doesn't work across boundaries. A single business transaction might span multiple data stores, run for a long time, or involve non-Microsoft services. The application must enforce the invariants that the domain, not the data layer, requires. Aggregates model that responsibility.

> [!NOTE]
> An aggregate can consist of a single entity without child entities. What makes it an aggregate is the transactional boundary.

When you design aggregates, follow these rules:

- **Design small aggregates.** Include only the data that must remain consistent within a single transaction. In the drone delivery example, `Delivery`, `Package`, `Drone`, and `Account` each form separate aggregates because they have independent life cycles. When you combine them, you force unrelated updates to compete for the same locks.

- **Reference other aggregates by identity only.** The `Delivery` aggregate stores a `DroneId` and a `PackageId`, not direct references to those objects. This decoupling maps directly to microservice boundaries.

- **Use eventual consistency across aggregates.** When a business process spans multiple aggregates, use domain events rather than a single transaction. When a delivery completes, the `Delivery` aggregate raises a `DeliveryCompleted` event that other services react to asynchronously.

### Domain and application services

In DDD terminology, a service is a stateless object that implements logic that doesn't naturally belong to an entity or value object.

> [!TIP]
> The term *service* has multiple meanings in software development. The definition in this article doesn't directly relate to microservices.

DDD defines the following two types of services:

- **Domain services** encapsulate business rules that span multiple entities or aggregates. In the shipping bounded context, the `Scheduler` functions as a domain service because the scheduling logic involves business rules about drone availability, delivery windows, and route optimization that don't belong to any single entity.

- **Application services** orchestrate use cases. They coordinate calls to domain services and repositories, manage transactions, and handle concerns like user authentication or SMS notifications. They contain no business logic themselves. An API endpoint that receives a delivery request, calls the `Scheduler`, and returns the result is an application service.

### Domain events

Domain events are domain-significant changes. For example, *a record was inserted into a table* doesn't qualify as a domain event, but *a delivery was canceled* does. Aggregates raise domain events after they change state, and these events function as the primary way to coordinate work across aggregate boundaries.

In a microservices architecture, domain events must sometimes cross microservice boundaries. Internal domain events stay within a bounded context. The system publishes integration events asynchronously through a message broker after the transaction that originated them commits. For example, when the shipping bounded context completes a delivery, it publishes a `DeliveryCompleted` integration event that the accounts bounded context consumes to trigger invoices. For more information about asynchronous messages, see [Interservice communication](../design/interservice-communication.yml).

### Other patterns

Other DDD patterns not covered in this article include factories, repositories, and modules. These patterns matter when you implement a microservice, but this article focuses on the patterns that help you identify microservice boundaries.

## Drone delivery: Apply the patterns

The shipping bounded context must handle the following scenarios:

- A customer requests a drone to pick up goods from a business registered with the drone delivery service.

- The sender generates a tag with a barcode or RFID to put on the package.

- A drone picks up and delivers a package from the source location to the destination location.

- When a customer schedules a delivery, the system provides an ETA based on route information, weather conditions, and historical data.

- When the drone is in flight, a user tracks the current location and the latest ETA.

- The customer can cancel a delivery until a drone picks up the package.

- The system notifies the customer when the delivery completes.

- The sender can request delivery confirmation from the customer, in the form of a signature or fingerprint.

- Users can look up the history of a completed delivery.

From these scenarios, the development team identifies the following entities:

- `Delivery`
- `Package`
- `Drone`
- `Account`
- `Confirmation`
- `Notification`
- `Tag`

Aggregates like `Delivery`, `Package`, `Drone`, and `Account` each define their own transactional consistency boundaries. Each aggregate has its own independent life cycle and a different part of the system manages it. For example, you can create, update, and complete a delivery without a transaction that locks the drone or account. The `Confirmation` and `Notification` entities function as child entities of `Delivery` entities because they don't exist independently. The `Tag` entities function as child entities of `Package` entities for the same reason.

The value objects in this design include `Location`, `ETA`, `PackageWeight`, and `PackageSize`. These objects lack identity and don't get tracked over time.

The following unified modeling language (UML) diagram shows the `Delivery` aggregate. It references other aggregates like `Account`, `Package`, and `Drone` by identity only.

:::image type="complex" border="false" source="../images/delivery-entity.png" alt-text="UML diagram of the delivery aggregate." lightbox="../images/delivery-entity.png":::
   The image contains a delivery header. Below the header are the following terms: ID string, OwnerID: REF, Pickup: Location, Drop-off: Location, Packages: REF, Expedited: BOOLEAN, Confirmation: Confirmation, and DroneId: REF. Three lines connect this section to the terms account, package, and drone.
:::image-end:::

The design includes two domain events:

- While a drone is in flight, the `Drone` entity sends `DroneStatus` events that describe the drone's location and status, like in-flight or landed.

- The `Delivery` entity sends `DeliveryTracking` events when the stage of a delivery changes. The `DeliveryTracking` events include `DeliveryCreated`, `DeliveryRescheduled`, `DeliveryHeadedToDropoff`, and `DeliveryCompleted`.

These events describe meaningful domain occurrences that matter in the domain model. They represent domain-level occurrences and don't depend on any specific programming language construct.

The development team identifies one area of functionality that doesn't fit within the entities described so far. A component must coordinate all steps to schedule or update a delivery. The team adds the following two domain services to the design:

- A `Scheduler` that coordinates the steps

- A `Supervisor` that monitors the status of each step to detect failures or timeouts

This approach is a variation of the [Scheduler Agent Supervisor pattern](../../patterns/scheduler-agent-supervisor.yml).

:::image type="complex" border="false" source="../images/drone-ddd.png" alt-text="Diagram of the revised domain model." lightbox="../images/drone-ddd.png":::
   The image contains 11 key sections. An arrow labeled observes points from supervisor to scheduler. An arrow points from scheduler to drone. A double-sided arrow labeled coordinates points from account to delivery. An arrow points from coordinates to package. A smaller arrow points from package to tag. A dotted arrow labeled drone status points from drone to delivery. Two smaller arrows point from delivery to confirmation and notification. A dotted line connects delivery and delivery status.
:::image-end:::

## Next step

The next step is to define the boundaries for each microservice.

> [!div class="nextstepaction"]
> [Identify microservice boundaries](./microservice-boundaries.yml)

## Related resources

- [Microservices architecture design](../../guide/architecture-styles/microservices.md)
- [Design a microservices architecture](../../microservices/design/index.md)
- [Use domain analysis to model microservices](domain-analysis.md)
- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
