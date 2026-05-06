---
title: Implement the Transactional Outbox Pattern by Using Azure Cosmos DB
description: Learn how to use the Azure Cosmos DB change feed feature and Azure Service Bus for reliable messaging and guaranteed delivery of domain events in distributed applications.
author: wueda
ms.author: awild
ms.date: 02/23/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
---

# Implement the Transactional Outbox pattern by using Azure Cosmos DB

Implementing reliable messaging in distributed systems can be challenging. This article describes how to use the Transactional Outbox pattern for reliable messaging and guaranteed delivery of events, which is an important part of supporting [idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing). This pattern uses Azure Cosmos DB transactional batches, the change feed, and Azure Service Bus.

## Overview

Microservice architectures address scalability, maintainability, and agility challenges in large applications, but this architectural pattern also introduces data-handling challenges. In distributed applications, each service independently maintains its required data in a dedicated service-owned data store. To support this scenario, you typically use a messaging solution, like RabbitMQ, Kafka, or Service Bus. These solutions distribute data, or *events*, from one service to other services through a message bus. Internal or external consumers subscribe to these messages and receive notifications when data changes.

Consider an ordering system. When a user creates an order, the `Ordering` service receives data from a client application via a REST endpoint. The service maps the payload to an internal representation of an `Order` object to validate the data. After the service commits the order to the database, it publishes an `OrderCreated` event to a message bus. Other services that need to respond to new orders, like `Inventory` or `Invoicing` services, subscribe to `OrderCreated` messages, process them, and store them in their own databases.

The following pseudocode shows this process from the `Ordering` service perspective:

```csharp
CreateNewOrder(CreateOrderDto order){
  // Validate the incoming data.
  ...
  // Apply business logic.
  ...
  // Save the object to the database.
  var result = _orderRepository.Create(order);

  // Publish the respective event.
  _messagingService.Publish(new OrderCreatedEvent(result));

  return Ok();
}
```

This approach works until an error occurs between saving the order object and publishing the event. At this point, the event send can fail for several reasons:

- Network error
- Message service outage
- Host failure

Regardless of the error, the system can't publish the `OrderCreated` event to the message bus, and other services aren't notified that an order was created. The `Ordering` service must now handle concerns beyond its core business process. It must track which events need publishing when the message bus recovers. Lost events can cause data inconsistencies across the application.

:::image type="complex" source="_images/event-handling-before-pattern.svg" alt-text="Diagram that shows event handling without the Transactional Outbox pattern." lightbox="_images/event-handling-before-pattern.svg" border="false":::
Sequence diagram that shows how a client app sends a create order request to an ordering service. The service begins a transaction, inserts the order, and commits the transaction. After the transaction completes, an attempt to send an event to the message bus fails.
:::image-end:::

## Solution

Use the *Transactional Outbox pattern* to avoid these situations. This pattern saves events in a data store that's typically in an outbox table in your database before it pushes them to a message broker. When you save the business object and its events within the same database transaction, the system guarantees no data loss. The transaction either commits everything or rolls back everything if an error occurs. To publish the events, a separate service or worker process queries the outbox table for unhandled entries, publishes them, and marks them as processed. This pattern prevents event loss when you create or modify business objects.

:::image type="complex" source="_images/out-box-pattern.svg" alt-text="Diagram that shows event handling that uses the Transactional Outbox pattern and a relay service to publish events to the message broker." lightbox="_images/out-box-pattern.svg" border="false":::
Sequence diagram that shows how a client app sends a create order request to an ordering service. The service begins a transaction, inserts the order and an OrderCreated event, commits the transaction, and returns the OrderID. A background worker then retrieves outbox entries from the data store, publishes the events to the message bus, and marks the events as processed in the data store.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/TransactionalOutbox.vsdx) of this architecture.*

In a relational database, the implementation of the pattern is straightforward. For example, when a service uses Entity Framework Core, it creates a database transaction by using an Entity Framework context, saves the business object and event, and commits the transaction or rolls it back. The worker service that processes events is also straightforward to implement. It periodically queries the outbox table for new entries, publishes newly inserted events to the message bus, and marks these entries as processed.

In practice, implementation becomes more complex. You must preserve event order so that the system publishes an `OrderCreated` event before an `OrderUpdated` event.

## Implementation in Azure Cosmos DB

This section demonstrates how to implement the Transactional Outbox pattern in Azure Cosmos DB. The implementation achieves reliable, in-order messaging between services by combining the Azure Cosmos DB change feed with Service Bus. The sample service manages `Contact` objects, like `FirstName`, `LastName`, `Email`, and `Company` information. The service uses the Command and Query Responsibility Segregation (CQRS) pattern and follows basic domain-driven design (DDD) concepts. For more information, see the [sample code](https://github.com/Azure-Samples/transactional-outbox-pattern).

A `Contact` object in the sample service has the following structure:

```json
{
    "name": {
        "firstName": "John",
        "lastName": "Doe"
    },
    "description": "This is a contact",
    "email": "johndoe@contoso.com",
    "company": {
        "companyName": "Contoso",
        "street": "Street",
        "houseNumber": "1a",
        "postalCode": "92821",
        "city": "Palo Alto",
        "country": "US"
    },
    "createdAt": "2026-02-09T11:07:37.3022907+02:00",
    "deleted": false
}
```

When the service creates or updates a `Contact`, the object emits events that contain information about the change. The system can raise several types of domain events:

- `ContactCreated` when a contact is added
- `ContactNameUpdated` when `FirstName` or `LastName` is changed
- `ContactEmailUpdated` when the email address is updated
- `ContactCompanyUpdated` when company properties are changed

### Transactional batches

To implement this pattern, ensure that the same database transaction saves both the `Contact` business object and its corresponding events. In Azure Cosmos DB, transactions work differently than in relational database systems. Azure Cosmos DB transactions, called *transactional batches*, operate on a single [logical partition](/azure/cosmos-db/partitioning) and guarantee Atomicity, Consistency, Isolation, and Durability (ACID) properties. You can't save two documents in a transactional batch operation in different containers or logical partitions. The sample service stores both the business object and its events in the same container and logical partition.

### Context, repositories, and UnitOfWork

The core of the sample implementation is a *container context* that tracks objects saved in the same transactional batch. It maintains a list of created and modified objects and operates on a single Azure Cosmos DB container. The following example defines the interface:

```csharp
public interface IContainerContext
{
    public Container Container { get; }
    public List<IDataObject<Entity>> DataObjects { get; }
    public void Add(IDataObject<Entity> entity);
    public Task<List<IDataObject<Entity>>> SaveChangesAsync(CancellationToken cancellationToken = default);
    public void Reset();
}
```

The container context list tracks both `Contact` and `DomainEvent` objects. The implementation stores both types in the same container. The same Azure Cosmos DB container stores multiple object types. Each object has a `Type` property that distinguishes business objects from events.

Each type has a dedicated repository that defines and implements data access. The `Contact` repository interface provides the following methods:

```csharp
public interface IContactsRepository
{
    public void Create(Contact contact);
    public Task<(Contact, string)> ReadAsync(Guid id, string etag);
    public Task DeleteAsync(Guid id, string etag);
    public Task<(List<(Contact, string)>, bool, string)> ReadAllAsync(int pageSize, string continuationToken);
    public void Update(Contact contact, string etag);
}
```

The `Event` repository has a single method that creates new events in the store:

```csharp
public interface IEventRepository
{
    public void Create(ContactDomainEvent e);
}
```

Both repository interface implementations receive a reference to a single `IContainerContext` instance through dependency injection. This shared instance ensures that both repositories operate on the same Azure Cosmos DB context.

The final component is `UnitOfWork`, which commits changes from the `IContainerContext` instance to Azure Cosmos DB:

```csharp
public class UnitOfWork : IUnitOfWork
{
    private readonly IContainerContext _context;
    public IContactRepository ContactsRepo { get; }

    public UnitOfWork(IContainerContext ctx, IContactRepository cRepo)
    {
        _context = ctx;
        ContactsRepo = cRepo;
    }

    public Task<List<IDataObject<Entity>>> CommitAsync(CancellationToken cancellationToken = default)
    {
        return _context.SaveChangesAsync(cancellationToken);
    }
}
```

### Event handling: Creation and publication

Every time a `Contact` object is created, modified, or soft deleted, the service raises a corresponding event. This solution combines DDD with the [Mediator pattern from Jimmy Bogard](https://lostechies.com/jimmybogard/2014/05/13/a-better-domain-events-pattern/). Bogard suggests that implementations maintain a list of events from domain object modifications and publish these events before saving the object to the database.

The domain object stores the list of changes, so no other component can modify the event chain. An `IEventEmitter<IEvent>` interface defines the behavior for maintaining events (`IEvent` instances) in the domain object, and an abstract `DomainEntity` class implements the interface:

```csharp
public abstract class DomainEntity : Entity, IEventEmitter<IEvent>
{
[...]
[...]
    private readonly List<IEvent> _events = new();

    [JsonIgnore] public IReadOnlyList<IEvent> DomainEvents => _events.AsReadOnly();

    public virtual void AddEvent(IEvent domainEvent)
    {
        var i = _events.FindIndex(0, e => e.Action == domainEvent.Action);
        if (i < 0)
        {
            _events.Add(domainEvent);
        }
        else
        {
            _events.RemoveAt(i);
            _events.Insert(i, domainEvent);
        }
    }
[...]
[...]
}
```

The `Contact` object raises domain events. The `Contact` entity follows basic DDD concepts and sets the domain properties' setters as private. No public setters exist in the class. Instead, the class provides methods to manipulate the internal state. These methods raise events for specific modifications, like `ContactNameUpdated` or `ContactEmailUpdated`.

The following example updates the name of a contact. The event is raised at the end of the method.

```csharp
public void SetName(string firstName, string lastName)
{
    if (string.IsNullOrWhiteSpace(firstName) ||
        string.IsNullOrWhiteSpace(lastName))
    {
        throw new ArgumentException("FirstName or LastName cannot be empty");
    }

    Name = new Name(firstName, lastName);

    if (IsNew) return; // if an object is newly created, all modifications are handled by ContactCreatedEvent

    AddEvent(new ContactNameUpdatedEvent(Id, Name));
    ModifiedAt = DateTimeOffset.UtcNow;
}

```

The corresponding `ContactNameUpdatedEvent` tracks the changes:

```csharp
public class ContactNameUpdatedEvent : ContactDomainEvent
{
    public Name Name { get; }

    public ContactNameUpdatedEvent(Guid contactId, Name contactName) : 
        base(Guid.NewGuid(), contactId, nameof(ContactNameUpdatedEvent))
    {
        Name = contactName;
    }
}
```

At this point, events are only logged in the domain object and nothing is saved to the database or published to a message broker. The list of events are processed right before the business object is saved to the data store, which follows the previous recommendation. In this case, the processing occurs in the `SaveChangesAsync` method of the `IContainerContext` instance, which is implemented in a private `RaiseDomainEvents` method. The list of tracked entities of the container context is `dObjs`.

```csharp
private void RaiseDomainEvents(List<IDataObject<Entity>> dObjs)
{
    var eventEmitters = new List<IEventEmitter<IEvent>>();

    // Get all EventEmitters.
    foreach (var o in dObjs)
        if (o.Data is IEventEmitter<IEvent> ee)
            eventEmitters.Add(ee);

    // Raise events.
    if (eventEmitters.Count <= 0) return;
    foreach (var evt in eventEmitters.SelectMany(eventEmitter => eventEmitter.DomainEvents))
        _mediator.Publish(evt);
}
```

The [MediatR](https://github.com/LuckyPennySoftware/MediatR) package on the last line is an implementation of the Mediator pattern in C#. The package publishes an event within the application. You can publish events through MediatR because all events, like `ContactNameUpdatedEvent`, implement the `INotification` interface of the MediatR package.

A corresponding handler must process these events. This part of the process uses the `IEventsRepository` implementation. The following example shows the `NameUpdated` event handler:

```csharp
public class ContactNameUpdatedHandler :
    INotificationHandler<ContactNameUpdatedEvent>
{
    private IEventRepository EventRepository { get; }

    public ContactNameUpdatedHandler(IEventRepository eventRepo)
    {
        EventRepository = eventRepo;
    }

    public Task Handle(ContactNameUpdatedEvent notification,
        CancellationToken cancellationToken)
    {
        EventRepository.Create(notification);
        return Task.CompletedTask;
    }
}
```

The constructor injects an `IEventRepository` instance into the handler class. When a `ContactNameUpdatedEvent` is published in the service, the `Handle` method is invoked and uses the events repository instance to create a notification object. That notification object is inserted into the list of tracked objects in the `IContainerContext` object and joins the objects that are saved in the same transactional batch to Azure Cosmos DB.

At this point, the container context knows which objects to process. To eventually persist the tracked objects to Azure Cosmos DB, the `IContainerContext` implementation creates the transactional batch, adds all relevant objects, and runs the operation against the database. The `SaveInTransactionalBatchAsync` method handles this process, and the `SaveChangesAsync` method invokes it.

The following parts of the implementation create and run the transactional batch:

```csharp
private async Task<List<IDataObject<Entity>>> SaveInTransactionalBatchAsync(
    CancellationToken cancellationToken)
{
    if (DataObjects.Count > 0)
    {
        var pk = new PartitionKey(DataObjects[0].PartitionKey);
        var tb = Container.CreateTransactionalBatch(pk);
        DataObjects.ForEach(o =>
        {
            TransactionalBatchItemRequestOptions tro = null;

            if (!string.IsNullOrWhiteSpace(o.Etag))
                tro = new TransactionalBatchItemRequestOptions { IfMatchEtag = o.Etag };

            switch (o.State)
            {
                case EntityState.Created:
                    tb.CreateItem(o);
                    break;
                case EntityState.Updated or EntityState.Deleted:
                    tb.ReplaceItem(o.Id, o, tro);
                    break;
            }
        });

        var tbResult = await tb.ExecuteAsync(cancellationToken);
...
[Check for return codes, etc.]
...
    }

    // Return copy of current list as result.
    var result = new List<IDataObject<Entity>>(DataObjects);

    // Work has been successfully done. Reset DataObjects list.
    DataObjects.Clear();
    return result;
}
```

The following steps summarize the workflow for updating the name on a contact object:

1. A client wants to update the name of a contact. The `SetName` method is invoked on the contact object and the properties are updated.

1. The `ContactNameUpdated` event is added to the list of events in the domain object.

1. The contact repository's `Update` method is invoked, which adds the domain object to the container context. The object is now tracked.

1. `CommitAsync` is invoked on the `UnitOfWork` instance, which calls `SaveChangesAsync` on the container context.

1. Within `SaveChangesAsync`, a `MediatR` instance publishes all events in the list of the domain object, and the event repository adds them to the *same container context*.

1. In `SaveChangesAsync`, a `TransactionalBatch` is created. It holds both the contact object and the event.

1. The `TransactionalBatch` runs and the data is committed to Azure Cosmos DB.

1. `SaveChangesAsync` and `CommitAsync` successfully return.

### Persistence

A `DataObject` instance wraps all objects saved to Azure Cosmos DB. This object provides common properties:

- `ID`.
- `PartitionKey`.
- `Type`.
- `State` has values like `Created` and `Updated`, which aren't persisted in Azure Cosmos DB.
- `Etag` provides [optimistic concurrency control (OCC)](/azure/cosmos-db/database-transactions-optimistic-concurrency#optimistic-concurrency-control).
- `TTL` provides automatic cleanup of old documents.
- `Data` is a generic data object.

The `IDataObject` generic interface defines these properties. Both the repositories and the container context use this interface:

```csharp

public interface IDataObject<out T> where T : Entity
{
    string Id { get; }
    string PartitionKey { get; }
    string Type { get; }
    T Data { get; }
    string Etag { get; set; }
    int Ttl { get; }
    EntityState State { get; set; }
}

```

The following example shows how objects like `Contact` and `ContactNameUpdatedEvent` appear when they're wrapped in a `DataObject` instance and saved to the database:

```json
// The Contact document/object after creation.
{
    "id": "aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb",
    "partitionKey": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2",
    "type": "contact",
    "data": {
        "name": {
            "firstName": "John",
            "lastName": "Doe"
        },
        "description": "This is a contact",
        "email": "johndoe@contoso.com",
        "company": {
            "companyName": "Contoso",
            "street": "Street",
            "houseNumber": "1a",
            "postalCode": "92821",
            "city": "Palo Alto",
            "country": "US"
        },
        "createdAt": "2026-02-09T11:07:37.3022907+02:00",
        "deleted": false,
        "id": "aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb"
    },
    "ttl": -1,
    "_etag": "\"180014cc-0000-1500-0000-614455330000\"",
    "_ts": 1632301657
}

// An event document after a name update.
{
    "id": "bbbbbbbb-7777-8888-9999-cccccccccccc",
    "partitionKey": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2",
    "type": "domainEvent",
    "data": {
        "name": {
            "firstName": "Jane",
            "lastName": "Doe"
        },
        "contactId": "aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb",
        "action": "ContactNameUpdatedEvent",
        "id": "d6a5f4b2-84c3-4ac7-ae22-6f4025ba9ca0",
        "createdAt": "2026-02-09T11:37:37.3022907+02:00"
    },
    "ttl": 120,
    "_etag": "\"18005bce-0000-1500-0000-614456b80000\"",
    "_ts": 1632303457
}

```

The `Contact` and `ContactNameUpdatedEvent` (type `domainEvent`) documents have the same partition key and both documents persist in the same logical partition.

### Change feed processing

To read the stream of events and send them to a message broker, the service uses the [Azure Cosmos DB change feed](https://devblogs.microsoft.com/cosmosdb/change-feed-unsung-hero-of-azure-cosmos-db/).

The change feed is a persistent log of changes in your container. It operates in the background and tracks modifications. Within one logical partition, the order of the changes is guaranteed. The most convenient way to read the change feed is to use an [Azure function with an Azure Cosmos DB trigger](/azure/azure-functions/scenario-database-changes-azure-cosmosdb). You can also use the [change feed processor library](/azure/cosmos-db/change-feed-processor). You can integrate change feed processing into your web API as a background service via the `IHostedService` interface. This sample implementation uses a simple console application that implements the abstract class [BackgroundService](/dotnet/api/microsoft.extensions.hosting.backgroundservice) to host long-running background tasks in .NET applications.

To receive the changes from the Azure Cosmos DB change feed, you need to instantiate a `ChangeFeedProcessor` object, register a handler method for message processing, and begin monitoring for changes:

```csharp
private async Task<ChangeFeedProcessor> StartChangeFeedProcessorAsync()
{
    var changeFeedProcessor = _container
        .GetChangeFeedProcessorBuilder<ExpandoObject>(
            _configuration.GetSection("Cosmos")["ProcessorName"],
            HandleChangesAsync)
        .WithInstanceName(Environment.MachineName)
        .WithLeaseContainer(_leaseContainer)
        .WithMaxItems(25)
        .WithStartTime(new DateTime(2000, 1, 1, 0, 0, 0, DateTimeKind.Utc))
        .WithPollInterval(TimeSpan.FromSeconds(3))
        .Build();

    _logger.LogInformation("Starting Change Feed Processor...");
    await changeFeedProcessor.StartAsync();
    _logger.LogInformation("Change Feed Processor started. Waiting for new messages to arrive.");
    return changeFeedProcessor;
}
```

A handler method (`HandleChangesAsync` in this implementation) processes the messages. In this sample, events are published to a Service Bus topic that's partitioned for scalability and has the [deduplication feature turned on](/azure/service-bus-messaging/duplicate-detection). Any service that needs to respond to changes in `Contact` objects can subscribe to that Service Bus topic and receive and process the changes for its own context.

Each Service Bus message includes a `SessionId` property. Service Bus sessions preserve message order ([first in, first out (FIFO)](/azure/service-bus-messaging/message-sessions), which ensures that events are processed in the correct sequence.

The following code handles messages from the change feed:

```csharp
private async Task HandleChangesAsync(IReadOnlyCollection<ExpandoObject> changes, CancellationToken cancellationToken)
{
    _logger.LogInformation($"Received {changes.Count} document(s).");
    var eventsCount = 0;

    Dictionary<string, List<ServiceBusMessage>> partitionedMessages = new();

    foreach (var document in changes as dynamic)
    {
        if (!((IDictionary<string, object>)document).ContainsKey("type") ||
            !((IDictionary<string, object>)document).ContainsKey("data")) continue; // Unknown document type.

        if (document.type == EVENT_TYPE) // domainEvent.
        {
            string json = JsonConvert.SerializeObject(document.data);
            var sbMessage = new ServiceBusMessage(json)
            {
                ContentType = "application/json",
                Subject = document.data.action,
                MessageId = document.id,
                PartitionKey = document.partitionKey,
                SessionId = document.partitionKey
            };

            // Create message batch per partitionKey.
            if (partitionedMessages.ContainsKey(document.partitionKey))
            {
                partitionedMessages[sbMessage.PartitionKey].Add(sbMessage);
            }
            else
            {
                partitionedMessages[sbMessage.PartitionKey] = new List<ServiceBusMessage> { sbMessage };
            }

            eventsCount++;
        }
    }

    if (partitionedMessages.Count > 0)
    {
        _logger.LogInformation($"Processing {eventsCount} event(s) in {partitionedMessages.Count} partition(s).");

        // Loop over each partition.
        foreach (var partition in partitionedMessages)
        {
            // Create batch for partition.
            using var messageBatch =
                await _topicSender.CreateMessageBatchAsync(cancellationToken);
            foreach (var msg in partition.Value)
                if (!messageBatch.TryAddMessage(msg))
                    throw new Exception();

            _logger.LogInformation(
                $"Sending {messageBatch.Count} event(s) to Service Bus. PartitionId: {partition.Key}");

            try
            {
                await _topicSender.SendMessagesAsync(messageBatch, cancellationToken);
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message);
                throw;
            }
        }
    }
    else
    {
        _logger.LogInformation("No event documents in change feed batch. Waiting for new messages to arrive.");
    }
}
```

### Error handling

When an error occurs during change processing, the change feed library restarts reading messages from the position where it successfully processed the last batch. For example, if the application successfully processed 10,000 messages and encounters an error while it processes batch 10,001 to 10,025, the library restarts at position 10,001. The library tracks processing progress by using information saved in a `Leases` container in Azure Cosmos DB.

When reprocessing occurs, the application might have already sent some messages to Service Bus, which normally creates duplicate message processing. To prevent this scenario, you can turn on duplicate message detection in Service Bus. Service Bus checks whether a message already exists in a topic or queue based on the application-controlled `MessageId` property of the message. That property is set to the `ID` of the event document. When Service Bus receives a duplicate message, it ignores and drops the message.

### Cleanup and maintenance

In a typical Transactional Outbox implementation, the service updates the handled events and sets a `Processed` property to `true`, which indicates that a message is successfully published. You can implement this behavior manually in the handler method. But you don't need to manually update events in this scenario. Azure Cosmos DB tracks processed events by using the change feed and the `Leases` container.

As a last step, you occasionally need to delete older events from the container so that only the most recent records and documents remain. To support this cleanup, the implementation applies the Azure Cosmos DB TTL feature on documents. Azure Cosmos DB can automatically delete documents based on a `TTL` property added to a document that specifies a time span in seconds. Azure Cosmos DB continuously checks the container for documents that have a `TTL` property and automatically removes expired documents from the database.

When all the components work as expected, events are processed and published within seconds. If an error occurs in Azure Cosmos DB, events aren't sent to the message bus because both the business object and the corresponding events can't be saved to the database. 

The primary consideration is to set a suitable `TTL` value on the `DomainEvent` documents when the background worker (change feed processor) or the service bus are unavailable. In a production environment, set a time span of multiple days, like 10 days. This duration ensures that all components have sufficient time to process and publish changes within the application.

## Summary

The Transactional Outbox pattern solves the problem of reliably publishing domain events in distributed systems. The pattern commits the business object's state and its events in the same transactional batch, and a background processor relays these events as messages. This approach ensures that other internal or external services eventually receive the information that they depend on. This sample differs from traditional Transactional Outbox implementations. It uses features like the Azure Cosmos DB change feed for automatic event processing and TTL to simplify implementation.

The following diagram summarizes the Azure components in this scenario.

:::image type="complex" source="_images/components.svg" alt-text="Diagram that shows the Azure components required to implement the Transactional Outbox pattern by using Azure Cosmos DB and Service Bus." lightbox="_images/components.svg" border="false":::
Architecture diagram that shows how a client application sends requests to a contacts service, which uses an Azure Cosmos DB transactional batch to save both the business object and domain events. A background worker processes the Azure Cosmos DB change feed and publishes events to Service Bus. Function apps subscribe to the Service Bus topic to receive the events.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/AzureComponents.vsdx) of this architecture.*

This solution provides the following advantages:

- Reliable messaging and guaranteed delivery of events.

- Preserved event order and message deduplication through Service Bus.

- No need to maintain an extra `Processed` property that indicates successful processing of an event document.

- Deletion of events from Azure Cosmos DB via TTL. The process doesn't consume request units that are needed for handling user and application requests. Instead, it uses *leftover* request units in a background task.

- Reliable message processing via `ChangeFeedProcessor` or an Azure function.

- Optional support for multiple change feed processors that each maintain their own pointer in the change feed.

### Considerations

The sample application in this article demonstrates how to implement the Transactional Outbox pattern on Azure by using Azure Cosmos DB and Service Bus. Other approaches use NoSQL databases. To reliably save the business object and events in the database, you can embed the list of events in the business object document. The downside of this approach is that the cleanup process must update each document that contains events, which increases request unit cost compared to using TTL.

The sample code in this article isn't production-ready code. It has limitations regarding multithreading, especially the way events are handled in the `DomainEntity` class and how objects are tracked in the `CosmosContainerContext` implementations. Use it as a starting point for your own implementations. Alternatively, consider using existing libraries that have this functionality built in, like [NServiceBus](https://docs.particular.net/nservicebus/outbox) or [MassTransit](https://masstransit.io/documentation/configuration/middleware/outbox).

### Deploy this scenario

To test this scenario on GitHub, see the [source code, deployment files, and instructions](https://github.com/Azure-Samples/transactional-outbox-pattern).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Christian Dennig](https://www.linkedin.com/in/christian-dennig/) | Principal Software Engineer
- [Alexander Wild](https://www.linkedin.com/in/wueda/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Tackle business complexity in a microservice by using DDD and CQRS patterns](/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns)
- [Message deduplication in Service Bus](/azure/service-bus-messaging/duplicate-detection)
- [Change feed processor library](/azure/cosmos-db/change-feed-processor)
- [Jimmy Bogard: A better domain events pattern](https://lostechies.com/jimmybogard/2014/05/13/a-better-domain-events-pattern)

## Related resources

- [Idempotent message processing](../../reference-architectures/containers/aks-mission-critical/mission-critical-data-platform.md#idempotent-message-processing)
- [Use tactical DDD to design microservices](../../microservices/model/tactical-ddd.yml)
- [CQRS pattern](../../patterns/cqrs.md)
- [Materialized View pattern](../../patterns/materialized-view.yml)
