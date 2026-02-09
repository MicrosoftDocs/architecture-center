Domain-driven design (DDD) opposes the idea of having a single unified model for the entire system. Instead, it encourages dividing the system into bounded contexts, each with its own model. During the strategic phase of DDD, you map out the business domain and define bounded contexts for your domain models.

Tactical DDD is when you define your domain models with more precision. The tactical patterns are applied within a single bounded context. In a microservices architecture, where each bounded context is a microservice candidate, the entity and aggregate patterns are of note. Applying these patterns helps identify natural boundaries for the services in your application. For more information, see [Identify microservice boundaries](./microservice-boundaries.yml). As a general principle, a microservice should be no smaller than an aggregate and no larger than a bounded context.

This article reviews the tactical patterns and then applies them to the Shipping bounded context in the Drone Delivery application.

## Overview of the tactical patterns

This section provides a brief summary of the tactical DDD patterns. If you're familiar with DDD, you might choose to skip it. These patterns are described in more detail in chapters 5 and 6 of Eric Evans' book, and in *Implementing Domain-Driven Design* by Vaughn Vernon.

:::image type="complex" border="false" source="../images/ddd-patterns.png" alt-text="Diagram of tactical patterns in DDD." lightbox="../images/ddd-patterns.png":::
   The diagram has five key sections. An arrow points from Application service to Domain service. One arrow points from Domain service to the Aggregate section. Another arrow points from Domain service to an Aggregate section that contains Root entity, Entity, and Value object. A line points from the first Aggregate section to the Domain event section.
:::image-end:::

**Entities**. An entity is an object with a unique identity that persists over time. For example, in a banking application, customers and accounts would be entities.

- An entity has a unique identifier in the system, which can be used to look up or retrieve the entity. That doesn't mean the identifier is always exposed directly to users. It could be a GUID or a primary key in a database.

- An identity can span multiple bounded contexts and might persist beyond the lifetime of the application. For example, bank account numbers or government-issued IDs aren't tied to a specific application.

- The attributes of an entity can change over time. For instance, a person's name or address might change, but they remain the same individual.

**Value objects**. A value object has no identity. It's defined only by the values of its attributes. Value objects are immutable. To update a value object, a new instance is created to replace the old one. Value objects can include methods that encapsulate domain logic, but those methods must not produce side effects or modify the object's state. Common examples of value objects include colors, dates and times, and currency values.

**Aggregates**. An aggregate defines a consistency boundary around one or more entities. Exactly one entity in an aggregate is the root. Lookup is done using the root entity's identifier. Any other entities in the aggregate are children of the root, and are referenced by following pointers from the root.

The purpose of an aggregate is to model transactional invariants. Things in the real world have complex webs of relationships. Customers create orders, orders contain products, and products have suppliers. If the application modifies several related objects, how does it guarantee consistency? How do we keep track of invariants and enforce them?

Traditional applications have often used database transactions to enforce consistency. In a distributed application, however, that's often not feasible. A single business transaction might span multiple data stores, or might be long running, or might involve third-party services. Ultimately it's up to the application, not the data layer, to enforce the invariants required for the domain. That's what aggregates are meant to model.

> [!NOTE]
> An aggregate might consist of a single entity, without child entities. What makes it an aggregate is the transactional boundary.

**Domain and application services**. In DDD terminology, a service is an object that implements some logic without holding any state. Evans distinguishes between *domain services*, which encapsulate domain logic, and *application services*, which provide technical functionality, such as user authentication or sending an SMS message. Domain services are often used to model behavior that spans multiple entities.

> [!NOTE]
> The term *service* is overloaded in software development. The definition used here isn't directly related to microservices.

**Domain events**. Domain events can notify other parts of the system when something occurs. As the name suggests, domain events should represent something meaningful within the domain. For example, "a record was inserted into a table" isn't a domain event. "A delivery was canceled" is a domain event. Domain events are especially important in a microservices architecture. Because microservices are distributed and don't share data stores, domain events enable coordination between services. For more information about asynchronous messaging, see [Interservice communication](../design/interservice-communication.yml).

There are a few other DDD patterns not covered here, including factories, repositories, and modules. These patterns can be helpful when you implement a microservice, but they're less relevant when you design the boundaries between microservices.

## Drone delivery: Applying the patterns

We start with the scenarios that the Shipping bounded context must handle.

- A customer can request a drone to pick up goods from a business that is registered with the drone delivery service.
- The sender generates a tag (barcode or RFID) to put on the package.
- A drone will pick up and deliver a package from the source location to the destination location.
- When a customer schedules a delivery, the system provides an ETA based on route information, weather conditions, and historical data.
- When the drone is in flight, a user can track the current location and the latest ETA.
- Until a drone has picked up the package, the customer can cancel a delivery.
- The customer is notified when the delivery is completed.
- The sender can request delivery confirmation from the customer, in the form of a signature or finger print.
- Users can look up the history of a completed delivery.

From these scenarios, the development team identified the following **entities**.

- Delivery
- Package
- Drone
- Account
- Confirmation
- Notification
- Tag

The first four, Delivery, Package, Drone, and Account, are all **aggregates** that represent transactional consistency boundaries. Confirmations and Notifications are child entities of Deliveries, and Tags are child entities of Packages.

The **value objects** in this design include Location, ETA, PackageWeight, and PackageSize.

To illustrate, here is a UML diagram of the Delivery aggregate. Notice that it holds references to other aggregates, including Account, Package, and Drone.

:::image type="complex" border="false" source="../images/delivery-entity.png" alt-text="UML diagram of the Delivery aggregate." lightbox="../images/delivery-entity.png":::
   The image contains a Delivery header. Below the header are the following terms: Id string, OwnerID: REF, Pickup: Location, Drop-off: Location, Packages: REF, Expedited: BOOLEAN, Confirmation: Confirmation, and DroneId: REF. Three lines connect this section to the terms Account, Package, and Drone.
:::image-end:::

There are two domain events:

- While a drone is in flight, the Drone entity sends DroneStatus events that describe the drone's location and status (in-flight, landed).

- The Delivery entity sends DeliveryTracking events whenever the stage of a delivery changes. The DeliveryTracking events include DeliveryCreated, DeliveryRescheduled, DeliveryHeadedToDropoff, and DeliveryCompleted.

Notice that these events describe things that are meaningful within the domain model. They describe something about the domain, and aren't tied to a particular programming language construct.

The development team identified one more area of functionality, which doesn't fit neatly into any of the entities described so far. Some part of the system must coordinate all of the steps involved in scheduling or updating a delivery. Therefore, the development team added two **domain services** to the design: a *Scheduler* that coordinates the steps, and a *Supervisor* that monitors the status of each step, in order to detect whether any steps failed or timed out. This approach is a variation of the [Scheduler Agent Supervisor pattern](../../patterns/scheduler-agent-supervisor.yml).

:::image type="complex" border="false" source="../images/drone-ddd.png" alt-text="Diagram of the revised domain model." lightbox="../images/drone-ddd.png":::
   The image contains 11 key sections. An arrow labeled Observes points from Supervisor to Scheduler. An arrow points from Scheduler to Drone. A double-sided arrow labeled Coordinates points from Account to Delivery. An arrow points from Coordinates to Package. A smaller arrow points from Package to Tag. A dotted arrow labeled Drone status points from Drone to Delivery. Two smaller arrows point from Delivery to Confirmation and Notification. A dotted line connects Delivery and Delivery status.
:::image-end:::

## Next steps

The next step is to define the boundaries for each microservice.

> [!div class="nextstepaction"]
> [Identify microservice boundaries](./microservice-boundaries.yml)

## Related resources

- [Microservices architecture design](../../guide/architecture-styles/microservices.md)
- [Design a microservices architecture](../../microservices/design/index.md)
- [Using domain analysis to model microservices](domain-analysis.md)
- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
