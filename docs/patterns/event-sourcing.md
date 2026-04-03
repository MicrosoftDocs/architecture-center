---
title: Event Sourcing Pattern
description: Learn how to use an append-only store to record the full series of events that describe actions taken on data in a domain.
ms.author: pnp
author: claytonsiemens77
ms.date: 03/27/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Event Sourcing pattern

Instead of storing only the current state of the data in a relational database, store the full series of actions taken on an object in an append-only store. The store acts as the system of record that you can use to materialize the domain objects. This approach can improve auditability and write performance in complex systems.

> [!IMPORTANT]
> Event sourcing is a complex pattern that introduces significant trade-offs. It changes how you store data, handle concurrency, evolve schemas, and query state. It's costly to migrate to or from an event sourcing solution, and after you adopt the pattern, it constrains future design decisions in the parts of the system that use it. Adopt event sourcing when its benefits, like auditability and historical reconstruction, justify the pattern's complexity. For most systems and most parts of a system, traditional data management is sufficient.

## Context and problem

Most applications work with data. The application typically stores the latest state of the data in a relational database and inserts or updates data as needed. For example, in the traditional create, read, update, and delete (CRUD) model, an application reads data from the store, modifies it, and updates the current state of the data with the new values, typically by using transactions that lock the data.

The CRUD approach is straightforward and fast for most scenarios. However, in high-load systems, this approach presents challenges:

- **Write contention:** Because updates require read-modify-write cycles with row-level locking, concurrent writes to the same entity degrade performance and become a bottleneck under load.

- **Auditability:** CRUD systems only store the latest state of the data. If you don't implement an auditing mechanism that records the details of each operation in a separate log, you lose data history.

## Solution

The Event Sourcing pattern defines an approach to handling operations on data that a sequence of events drive. Each event is recorded in an append-only store. Application code raises events that describe each action taken on the object. It typically sends events to a queue in which a separate process, an event handler, listens to the queue and persists the events in an event store. Each event represents a logical change to the object, such as `AddedItemToOrder` or `OrderCanceled`.

The events persist in an event store that serves as the system of record, or the authoritative data source, about the current state of the data. Extra event handlers can listen for specific events and take action as needed. For example, consumers might initiate tasks that apply operations in the events to other systems or take other associated actions required to finish the operation. The application code that generates the events is decoupled from the systems that subscribe to the events.

Each entity in an event-sourced system has its own event stream, which is the ordered sequence of events that records every change to that entity. At any point, applications can read the history of events. Applications derive the current state of an entity by replaying all the events in its stream. This process is known as *rehydration*. It can occur on demand when the application handles a request.

Applications typically implement [materialized views](./materialized-view.yml) because it's costly to read and replay events. Materialized views are read-only projections of the event store that are optimized for querying. For example, a system can maintain a materialized view of all customer orders that it uses to populate the UI. When the application adds new orders, adds or removes items in the order, or adds shipping information, the application raises events and a handler updates the materialized view.

The following diagram shows an overview of this pattern combined with the [Command Query Responsibility Segregation (CQRS) pattern](./cqrs.md). The presentation layer reads from a separate read-only store and writes commands to command handlers. The command handlers retrieve the entity's event stream from the event store, run business logic, and push new events to a queue. Event handlers consume events from the queue and write events to the event store, update the read-only store, or integrate with external systems.

  :::image type="complex" source="./_images/event-sourcing-overview.svg" border="false" lightbox="./_images/event-sourcing-overview.svg" alt-text="Diagram that shows an overview and example of the Event Sourcing pattern.":::
      At the top of the diagram, a box represents the presentation layer. In the upper right, an arrow labeled reads points from the presentation layer to a box labeled business object, which points to a read-only store. An arrow labeled writes points from the presentation layer to a box on the left that includes command handlers and business objects. From this box, an arrow labeled get cart events points to an event store. Another arrow points from the command handlers box to a box at the bottom labeled queue or topic that contains seven envelope icons. Alongside this arrow, envelope icons represent events like cart created, item 1 added, item 2 added, item 1 removed, and shipping information added. Three arrows point from the queue or topic box to separate event handlers. The leftmost event handler writes events to the event store. The middle event handler updates the read-only store. The rightmost event handler integrates with external systems.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/event-sourcing-overview.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. The presentation layer calls an object that reads from a read-only store. It uses the returned data to populate the UI.

1. The presentation layer calls command handlers to perform actions like *create a cart* or *add an item to the cart*.

1. The command handler loads the entity by retrieving its event stream from the event store. For example, it might retrieve all cart events. It replays those events against the entity to reconstruct its current state before any new action occurs.

1. The business logic runs and events are raised. In most implementations, the events are pushed to a queue or topic to decouple the event producers and event consumers.

1. Event handlers listen for specific events and take the appropriate action for that handler. In this example, the event handlers take the following actions:

    1. Write the events to the event store

    1. Update a read-only store optimized for queries

    1. Integrate with external systems

### Pattern advantages

The Event Sourcing pattern provides the following advantages:

- Events are immutable, and you can store them by using an append-only operation. The UI, workflow, or process that initiates an event can continue, and tasks that handle the events can run in the background. Write throughput improves, especially for the presentation layer, because append-only writes avoid the row-level lock contention that update-in-place systems create.

- Events are simple objects that describe an action that occurs along with any associated data required to describe the action that the event represents. Events don't directly update a data store. Event handlers pick up and process recorded events when a handler is available and the system can handle the load. Use events to help simplify implementation and management.

- Events typically have meaning for a domain expert, whereas object-relational impedance mismatch can make complex database tables hard to understand. Tables are artificial constructs that represent the current state of the system, not the events that occur.

- Event sourcing can help prevent concurrent updates from causing conflicts because it avoids the requirement to directly update objects in the data store. Command handlers rehydrate an entity from its event stream to enforce business rules before they append new events, so two handlers that load the same entity simultaneously can act on the same state.

   For example, each handler sees five remaining seats, and both handlers can accept a reservation. Event stores address this scenario by using optimistic concurrency control and reject an append if the stream changed since it was read. Upon rejection, the handler reloads the entity, reevaluates, and retries.

- Append-only event storage provides an audit trail that applications can use to monitor actions taken against a data store. It can regenerate the current state as materialized views or projections by replaying the events at any time, and it can help test and debug the system.

   The requirement to use compensating events to cancel changes can provide a history of reversed changes. If the model stores only the current state, this history doesn't exist. You can also use the list of events to analyze application performance, detect user behavior trends, and obtain other useful business information.

- The command handlers raise events, and tasks perform operations in response to those events. This decoupling of the tasks from the events provides flexibility and extensibility. Tasks know about the type of event and the event data, but not about the operation that triggers the event.

   Multiple tasks can handle each event, so they can easily integrate with other services and systems that only listen for new events that the event store raises. But the event sourcing events are typically low level, and it might be necessary to generate specific integration events instead.

> [!TIP]
> Event sourcing is commonly combined with the [CQRS pattern](./cqrs.md) by performing the data management tasks in response to the events and by materializing views from the stored events. Use this combination to independently scale reads and writes because append-only event ingestion and query-optimized projections operate separately.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Event design:** Design events to capture the business intent behind each change in addition to the resulting state. For example, in the seat-reservation system, an event that records *two seats were reserved* is more valuable than an event that records *remaining seats changed to 42*. The first event tells you what happened. The second event only tells you the resulting state. State-focused events reduce the event store to a change log that has no business meaning. Intent-focused events provide more detailed projections, meaningful audit trails, and the flexibility to build new read models from historical events without having to change the write environment.

- **Eventual consistency:** The system is only eventually consistent when it creates materialized views or generates projections of data by replaying events. A delay exists between when an application handles a request and adds events to the event store, when the events publish, and when consumers handle the events. During this period, new events that describe further changes to entities might arrive at the event store. Ensure that your customers understand that data is eventually consistent and that the system is designed to account for eventual consistency in these scenarios.

- **Versioning events:** The event store is the permanent source of information, so you should never update the event data. The only way to update an entity or undo a change is to add a compensating event to the event store. A compensating event is a new event that reverses or corrects the effect of a previous event. For example, a `ReservationCanceled` event compensates for a prior `SeatsReserved` event. The original event remains in the stream, and the compensating event records that it was undone.

  This immutability also means that if a bug produces incorrect events, those events persist in the store. Fixing the bug in application code doesn't fix the historical events, so you might also need compensating events or upcasters to handle the bad data during replay. If the schema (rather than the data) of the persisted events needs to change, perhaps during a migration, it can be difficult to combine existing events in the store with the new version.

  You can use the following strategies individually or in combination:

  - **Tolerant deserialization:** Design event consumers to ignore unknown fields and use default values for missing fields. This approach handles additive, nonbreaking changes, such as adding an optional field, without requiring any transformation of stored events.

  - **Event versioning:** Include a version identifier in each event, either as metadata in the event envelope or as part of the event type name. Consumers use the version to select the appropriate handling logic.

  - **Upcasting:** Register transformation functions that convert older event schemas to the current schema during deserialization. You can chain upcasters so that the application code only needs to handle the latest version. The stored events remain unchanged, which preserves immutability.

  - **In-place migration:** Rewrite historical events to the new schema directly in the event store. This approach breaks immutability and should be a last resort because it undermines the audit trail.

- **Event ordering:** Multiple-threaded applications and multiple instances of applications might store events in the event store. The consistency of events in the event store and the order of events that affect a specific entity's current state are crucial. Adding a timestamp to every event can help you avoid problems. Another common practice is to annotate each event that results from a request with an incremental identifier. If two actions attempt to add events for the same entity at the same time, the event store can reject an event that matches an existing entity identifier and event identifier.

- **Event querying:** There's no standard approach or existing mechanisms, such as SQL queries, for reading events to obtain information. The only data that you can extract is a stream of events by using an event identifier as the criteria. The event ID typically maps to individual entities. You can determine the current state of an entity only by replaying all of the events that relate to it against the original state of that entity.

- **Event store options:** An event store can be a purpose-built database designed for append-only event streams or a general-purpose relational or document database with an append-only table.

  - Purpose-built event stores provide built-in support for tasks like reading a stream by entity, optimistic concurrency, and snapshots.

  - Relational databases are familiar and widely available but require you to build those behaviors yourself.

  Because each entity has its own independent event stream, event stores partition naturally by entity ID, which simplifies horizontal scaling or sharding when needed.

  > [!IMPORTANT]
  > Don't confuse an event store with an event stream message broker. Message brokers such as Apache Kafka typically lack per-entity stream queries and optimistic concurrency. They work well as a distribution layer to fan out events to projections and external consumers, but they aren't a substitute for an event store.

- **Entity state re-creation:** The length of each event stream affects how you manage and update the system. If the streams are large, replaying every event to rehydrate an entity becomes costly in both time and compute. To mitigate this cost, create snapshots at specific intervals, such as every *N* events. A snapshot is a serialized representation of the entity's state at a specific point in its event stream. To rehydrate the entity, load the most recent snapshot and replay only the events that occur after it, rather than replaying the entire stream from the beginning. When you choose a snapshot frequency, balance the storage cost of snapshots against the time saved during rehydration.

  > [!NOTE]
  > Snapshots are an optimization, not a replacement for the event stream. The event stream remains the source of truth, and you can regenerate snapshots from it at any time.

- **Conflict handling:** Optimistic concurrency control prevents conflicting writes to the same event stream, but the application must still handle conflicts that span multiple entities. For example, an event that indicates a reduction in stock inventory might arrive in the data store while a customer places an order for that item. Design the system to reconcile these situations, such as by advising the customer or by creating a back order.

- **Idempotency requirements:** Event delivery to consumers is typically *at least once*, so consumers can receive the same event more than once. Event handlers must be idempotent so processing a duplicate event doesn't change the outcome. For example, if multiple instances of a consumer process seat-reservation events to maintain an available-seat count, a duplicated reservation event must result in only one decrement. Without idempotency, projections drift from the event stream and side effects such as payments or notifications trigger more than once. Track the last processed event sequence number for each consumer and skip duplicates, or design state mutations that are inherently safe to repeat.

- **Circular logic:** Be mindful of scenarios in which the processing of one event requires the creation of one or more new events. This sequence can result in an infinite loop.

- **Testing:** A specific testing style best suits event-sourced systems. Set up past events, issue a command, and assert on the new events produced. This *given-when-then* approach tests business logic without databases, queues, or projections. But you also need integration tests for projections, idempotency behavior, and schema evolution paths, which adds testing surface compared to CRUD systems.

- **Personal data and regulatory compliance:** The append-only, immutable nature of an event store conflicts with data protection regulations that require deletion of personal data, such as the *right to be forgotten* laws. Deleting events outright breaks stream integrity, so design for this tension from the start.

  - A common approach is to store personal data outside the event store and reference it by identifier in events. This approach allows deletion to occur independently without affecting the event stream.

  - When you can't separate personal data from events, use crypto-shredding. Encrypt personal data in events by using a per-subject key. Delete the key to render the data unrecoverable while leaving the event structure intact. This approach adds encryption overhead on every read and write and requires robust key management.

## When to use this pattern

Use this pattern when:

- You want to capture intent, purpose, or reason in the data. For example, you can capture changes to a customer entity as a series of specific event types, such as *Moved home*, *Closed account*, or *Deceased*.

- You must minimize or completely avoid conflicting updates to data.

- You want to record events that occur, to replay them to restore the state of a system, to roll back changes, or to keep a history and audit log. For example, when a task consists of multiple steps, you might need to run actions to revert updates and then replay some steps to bring the data back into a consistent state.

- The application already uses events as a natural feature of its operation, and event sourcing requires little extra development or implementation effort.

- You need to decouple the process of inputting or updating data from the tasks required to apply these actions. This change might be to improve UI performance or to distribute events to other listeners that act when the events occur. For example, you can integrate a payroll system with an expense submission website. Both the website and the payroll system consume events that the event store raises in response to data updated on the website.

- You want the flexibility to change the format of materialized models and entity data if requirements change, or when you use CQRS and you need to adapt a read model or the views that expose the data.

- You use CQRS and eventual consistency is acceptable while a read model is updated, or entity and data rehydration from an event stream results in acceptable performance reduction.

This pattern might not be suitable when:

- Systems have straightforward CRUD operations that don't require auditability, replay, or historical reconstruction of state. The operational overhead of an event store isn't justified if the only requirement is current-state reads and writes.

- Prototypes, minimum viable products (MVPs), or systems have short expected lifespans. The upfront investment in event design, schema evolution strategy, and projection infrastructure rarely yield a return in these scenarios.

- Systems require consistency and real-time updates to the views of the data. Eventual consistency between the event store and projections is inherent to event sourcing.

- Domains in which data is mostly static or for reference, such as lookup tables or catalogs. This type of data changes infrequently and doesn't benefit from change history.

- Teams don't have experience in [event-driven architectures](../guide/architecture-styles/event-driven.md). Event sourcing changes how you test, debug, and operate a system. Adopting it without the foundational knowledge increases the risk of antipatterns that are costly to reverse.

> [!TIP]
> Event sourcing doesn't have to be an all-or-nothing decision for your entire system. Apply it selectively to the parts of your system that it benefits the most, such as a payment ledger or order-processing pipeline. Use traditional CRUD for parts when the complexity isn't justified, such as user profile management or application configuration.

## Workload design

Evaluate how to use the Event Sourcing pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern can facilitate state reconstruction if you need to recover state stores because you capture a history of changes in complex business processes.<br/><br/> - [Data partitioning](/azure/well-architected/design-guides/partition-data)<br/> - [RE:09 Disaster recovery](/azure/well-architected/reliability/disaster-recovery) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern, usually combined with CQRS, an appropriate domain design, and strategic snapshotting, can improve workload performance because of atomic append-only operations and the avoidance of database locking for writes and reads.<br/><br/> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

A conference management system needs to track the number of completed bookings for a conference. By tracking this number, it can check for available seats when a potential attendee tries to make a booking. The system can store the total number of bookings for a conference in at least two ways:

- The system can store information about the total number of bookings as a separate entity in a database that holds booking information. As attendees make or cancel bookings, the system increases or decreases this number. This approach is simple in theory, but it can cause scalability problems if a large number of attendees attempt to book seats during a short period of time. For example, this surge typically occurs on the final day before the booking period closes.

- The system can store information about bookings and cancellations as events held in an event store. It calculates the number of available seats by replaying these events. This approach can be more scalable because of the immutability of events. The system needs to only read data from the event store or append data to the event store. It never modifies event information about bookings and cancellations.

The following diagram shows how you might use event sourcing to implement the seat reservation subsystem of the conference management system.

  :::image type="complex" source="./_images/event-sourcing-example.svg" border="false" lightbox="./_images/event-sourcing-example.svg" alt-text="Diagram that shows how to use event sourcing to capture information about seat reservations in a conference management system.":::
      At the top of the diagram, a box represents the presentation layer. An arrow labeled writes points from the presentation layer to a box that includes command handlers and business objects. An arrow labeled get seat availability events points from that box to an event store. An arrow labeled seat reserved (number of seats) points from the command handlers box to a box labeled queue or topic. An arrow points from the queue or topic box to an event handler. Another arrow points from the event handler to the event store.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/event-sourcing-example.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. The UI issues a command to reserve seats for two attendees. A separate command handler handles the command. The command handler is a piece of logic that's decoupled from the UI and is responsible for handling requests posted as commands.

1. The system constructs an entity that contains information about all reservations for the conference by replaying the events that describe bookings and cancellations. This entity is called `SeatAvailability`, and it's contained within a domain model that exposes methods for querying and modifying the data in the entity.

   > [!TIP]
   > Consider optimizations like snapshots so that you don't need to replay the full list of events to obtain the current state of the entity. Snapshots also maintain a cached copy of the entity in memory.

1. The command handler invokes a method that the domain model exposes to make the reservations.

1. The `SeatAvailability` entity raises an event that contains the number of reserved seats. The next time that the entity applies events, it uses all the reservations to compute the number of remaining seats.

1. The system appends the new event to the list of events in the event store.

If a user cancels a seat, the system follows a similar process, but the command handler issues a command that generates a seat cancellation event and appends it to the event store.

The system can provide a complete history, or audit trail, of the bookings and cancellations for a conference by using an event store. The events in the event store are the accurate record. You don't need to persist entities in any other way because the system can easily replay the events and restore the state to any point in time.

## Next step

- [CQRS pattern](./cqrs.md): The write store that provides the permanent source of information for a CQRS implementation is typically based on an implementation of the Event Sourcing pattern. The pattern segregates the operations that read data in an application from the operations that update data by using separate interfaces.

## Community resources

- [Object-relational impedance mismatch](https://wikipedia.org/wiki/Object%E2%80%93relational_impedance_mismatch).

- [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html), by Martin Fowler: The original 2005 description of the pattern that established the foundational vocabulary.

- [CQRS Documents (PDF)](https://cqrs.files.wordpress.com/2010/11/cqrs_documents.pdf), by Greg Young: The definitive resource about event sourcing and CQRS from the practitioner who formalized both patterns.

## Related resources

The following patterns and guidance might also be relevant when you implement this pattern:

- [Materialized View pattern](./materialized-view.yml): The data store that you use in an event sourcing system typically isn't suited for efficient querying. Instead, a common approach is to generate prepopulated views of the data at regular intervals or when the data changes.

- [Compensating Transaction pattern](./compensating-transaction.yml): The system doesn't update existing data in an event sourcing store. Instead, it adds new entries that transition the state of entities to the new values. To reverse a change, it uses compensating entries because it can't reverse the previous change. The Compensating Transaction pattern article describes how to undo the work that a previous operation performed.

- [Domain analysis for microservices](../microservices/model/tactical-domain-driven-design.md): In systems that use domain-driven design (DDD), the entity that owns an event stream is typically an [aggregate](../microservices/model/tactical-domain-driven-design.md#aggregates), a consistency boundary that receives commands, enforces business rules, and emits events.
