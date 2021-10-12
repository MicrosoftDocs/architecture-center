Implementing reliable messaging in distributed systems can be challenging. This article describes how to use the *Transactional Outbox* pattern for reliable messaging and guaranteed delivery of events with Azure Cosmos DB transactional batches and change feed in combination with Azure Services Bus.

## Overview

Microservice architectures become more and more popular and promise to solve problems like scalability, maintainability, agility etc. The architectural pattern also introduces challenges when it comes to data handling as each service in an application maintains the data it needs to operate independently in a dedicated, service-owned datastore. In such a scenario, you typically use a messaging solution like RabbitMQ, Kafka or Azure Service Bus that distributes data (events) from one service via a messaging bus to other services of the application - or external consumers - as soon as data is manipulated.

A well-known example in that area is an ordering system: when a user wants to create a new order, an *Ordering* service would receive data from a client application via a REST endpoint, it would map the payload to an internal representation of an *Order* object (validate the data) and after a successful commit to the database, it would publish an *OrderCreated* event to a message bus. Any other service interested in newly created orders (e.g. an *Inventory* or *Invoicing* service), would subscribe to *OrderCreated* messages and process / store them accordingly in its own database.

The following pseudo code shows, how this would typically look like from the *Ordering* service perspective:

```csharp
CreateNewOrder(CreateOrderDto order){
  // validate the incoming data
  ...
  // apply business logic
  ...
  // save the object to the database
  var result = _orderRespository.Create(order);

  // publish the respective event
  _messagingService.Publish(new OrderCreatedEvent(result));

  return Ok();
}
```

This all works well until an error occurs between saving the order object and publishing the corresponding event. There can be many reasons why sending an event may fail at this point:

- Network errors
- Message service outage
- Host failure
- etc.

Whatever it is in the end, the result of such an error is that the *OrderCreated* event cannot be published to the message bus and other services won't be notified of the new order. The *Ordering* service now has to take care of various things that do not relate to the actual business logic like keeping track of events that still need to be put on the message bus as soon as it is back online. Even the worst case can happen: data inconsistencies in the application due to lost events.

:::image source="media/transactional-outbox/eventhandling.png" alt-text="Event handling without transactional outbox pattern":::

## Solution

There is a well-known pattern called **Transactional Outbox** that can help avoid these situations. It ensures that events will be saved in a datastore (typically in an *Outbox* table in your database) before ultimately pushing them to a message broker. If the business object and the corresponding events are saved within the same database transaction, it is guaranteed that no data will be lost: either everything will be committed or rolled back in case of an error. To eventually publish the event, a different service or worker process would query the *Outbox* table for unhandled entries, publish the events and mark them as "processed". Using this pattern ensures that events won't be lost after creating or modifying a business object.

:::image type="content" source="media/transactional-outbox/outbox.png" alt-text="Event handling with transactional outbox pattern and relay service for publishing events to message broker":::

In a relational database, the implementation of the pattern is straightforward. If the service e.g. uses Entity Framework Core, it will use an Entity Framework context to create a database transaction, save the business object and the event and commit the transaction – or do a rollback. Also, the worker service that is processing events is easy to implement: it periodically queries the *Outbox* table for new entries, publishes newly inserted events to the message bus and finally marks these entries as *processed*.

In real-life though, things are not as easy as they might look like in the first place. Most importantly, you need to make sure that the order of the events, as they happened in the application, is preserved so that an *OrderUpdated* event doesn’t get published before an *OrderCreated* event.

## Implementation with Cosmos DB

The following chapter shows how to implement the **Transactional Outbox** pattern in Cosmos DB and achieve reliable, in-order messaging between different services with the help of Cosmos DB's change feed and Azure Service Bus. It uses a sample service that is responsible for managing *Contact* objects (`FirstName`, `LastName`, `Email`, `Company Information` etc.). It leverages the CQRS pattern and follows basic Domain-Driven Design concepts.

A `Contact` object in the sample service has the following structure:

```json
{
    "name": {
        "firstName": "Bertram",
        "lastName": "Gilfoyle"
    },
    "description": "This is a contact",
    "email": "bg@piedpiper.com",
    "company": {
        "companyName": "Pied Piper",
        "street": "Street",
        "houseNumber": "1a",
        "postalCode": "092821",
        "city": "Palo Alto",
        "country": "US"
    },
    "createdAt": "2021-09-22T11:07:37.3022907+02:00",
    "deleted": false
}
```

As soon as a `Contact` will be created or updated, it will emit events containing information about the current change. Domain events can be e.g.:

- *ContactCreated* - raised when a contact has been added
- *ContactNameUpdated* - raised when `FirstName` or `LastName` have been changed.
- *ContactEmailUpdated* - raised when the email address has been updated
- *ContactCompanyUpdated* - raised when any of the company properties have been changed

### Transactional Batches

In order to implement the pattern, it needs to be guaranteed that the `Contact` business object as well as the corresponding events will be saved in the same database transaction. In Cosmos DB, transactions work differently compared to relational database systems. Cosmos DB transactions – called *transactional batches* – operate on a **single logical partition** and therefor guarantee ACID properties. You can’t save two documents in a transactional batch operation in different containers or even logical partitions. For the sample service, that means that both the business object and the event(s) will be put in the same container and logical partition.

### Context, Repositories and UnitOfWork

Core of the sample implementation is a *container context* that is responsible for keeping track of objects that need to be saved in the same transactional batch. It maintains a list of created/modified objects and operates on a single Cosmos DB container. The interface for it looks as follows:

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

The list within the *container context* component will hold *Contact* as well as *DomainEvent* objects and both will be put in the same container. That means, multiple types of objects are stored in the same Cosmos DB container and use a *Type* property to distinct between a *business object* and an *event*.

For each type there exists a dedicated repository that defines/implements the data access. The *Contact* repository interface offers the following methods:

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

The *Event* repository looks similar, except that there is only one method to create new events in the store:

```csharp
public interface IEventRepository
{
    public void Create(ContactDomainEvent e);
}
```

The implementations of both repository interfaces get a reference via dependency injection to an *IContainerContext* instance to make sure that both **operate on the same Cosmos DB context**.

The last component is a *UnitOfWork* that is responsible for committing the changes held in the *IContainerContext* instance to Cosmos DB:

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

### Event Handling – Creation and Publication

Every time a *Contact* object is created, modified or (soft-) deleted, the service would raise a corresponding event, so that it can notify other services interested in those changes. Core of the solution provided is a combination of Domain-Driven Design and making use of the mediator pattern as proposed by [Jimmy Bogard](https://lostechies.com/jimmybogard/2014/05/13/a-better-domain-events-pattern/). He suggests maintaining a list of events that happened due to modifications of the domain object and publish these events ultimately **before saving the actual object to the database**.

The list of changes is kept in the domain object itself, so that no other component can modify the chain of events. The behavior of maintaining events (*IEvent* instances) in the domain object is defined via an interface *IEventEmitter<IEvent>* and implemented in an abstract *DomainEntity* class:

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

Raising domain events is the responsibility of the *Contact* object. The *Contact* entity follows basic DDD concepts having the domain properties' setters private - no public setters exist in the class. Instead, it offers dedicated methods to manipulate the internal state and is therefor able to raise the appropriate events for a certain modification (e.g. *ContactNameUpdated*, *ContactEmailUpdated* etc.).

Here’s an example when updating the name of a contact (the event is raised at the end of the method):

```csharp
public void SetName(string firstName, string lastName)
{
    if (string.IsNullOrWhiteSpace(firstName) ||
        string.IsNullOrWhiteSpace(lastName))
    {
        throw new ArgumentException("FirstName or LastName may not be empty");
    }

    Name = new Name(firstName, lastName);

    if (IsNew) return;

    AddEvent(new ContactNameUpdatedEvent(Id, Name));
    ModifiedAt = DateTimeOffset.Now;
}

```

The corresponding *ContactNameUpdatedEvent* that keeps track of the changes looks as follows:

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

So far, events will be just "logged" in the domain object and nothing gets saved to the database or even published to a message broker. Following the recommendation, the list of events will be processed right before saving the business object to the data store. In this case, it happens within the *SaveChangesAsync* method of the *IContainerContext* instance - implemented in a private *RaiseDomainEvents* method (*dObjs* is the list of tracked entities of the container context):

```csharp
private void RaiseDomainEvents(List<IDataObject<Entity>> dObjs)
{
    var eventEmitters = new List<IEventEmitter<IEvent>>();

    // Get all EventEmitters
    foreach (var o in dObjs)
        if (o.Data is IEventEmitter<IEvent> ee)
            eventEmitters.Add(ee);

    // Raise Events
    if (eventEmitters.Count <= 0) return;
    foreach (var evt in eventEmitters.SelectMany(eventEmitter => eventEmitter.DomainEvents))
        _mediator.Publish(evt);
}
```

On the last line, the [MediatR](https://github.com/jbogard/MediatR) package - an implementation of the mediator pattern in C# -  is used to publish an event within the application – this is possible, because all events like *ContactNameUpdatedEvent* implement the *INotification* interface of the *MediatR* package.

These events need to be processed by a corresponding handler – this is where the *IEventsRepository* implementation comes into play. Here is the sample of the *NameUpdated* event handler:

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

An *IEventRepository* instance gets injected into the handler class via the constructor. As soon as an *ContactNameUpdatedEvent* gets published in the service, the *Handle* method is invoked and uses the events repository instance to create a notification object – that in turn gets inserted in the list of tracked objects in the *IContainerContext* object and therefor **will become part of the objects that will be saved in the same transactional batch** to Cosmos DB.

Here are the important parts of the implementation of *IContainerContext*:

```csharp
private async Task<List<IDataObject<Entity>>>
    SaveInTransactionalBatchAsync(List<IDataObject<Entity>> dObjs,
        CancellationToken cancellationToken)
{
    if (dObjs.Count > 0)
    {
        var pk = new PartitionKey(dObjs[0].PartitionKey);
        var tb = Container.CreateTransactionalBatch(pk);
        dObjs.ForEach(o =>
        {
            TransactionalBatchItemRequestOptions tro = null;

            if (!string.IsNullOrWhiteSpace(o.Etag))
                tro = new TransactionalBatchItemRequestOptions
                {
                    IfMatchEtag = o.Etag
                };

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
[check for return codes etc.]
...
    }

    var result = new List<IDataObject<Entity>>(dObjs);
    // reset internal list
    DataObjects.Clear();
    return result;
}

```

### Persistence

To summarize the current state, this is how the process works so far (e.g. for updating the name on a contact object):

1. A client wants to update the name of a contact. Therefor, *SetName* is invoked on the contact object and the properties will be changed accordingly
2. The event *ContactNameUpdated* is added to the list of events in the **domain object**
3. The contact repository's *Update* method is invoked which adds the domain object to the container context. The object is now **tracked**.
4. *CommitAsync* is invoked on the UnitOfWork instance which in turn calls *SaveChangesAsync* on the container context
5. Within *SaveChangesAsync*, all events in the list of the domain object get published by a *MediatR* instance and are added via the event repository to the **same container context**
6. In *SaveChangesAsync*, a *TransactionalBatch* is created which will hold both the contact object and the event
7. The *TransactionalBatch* is executed and the data is committed to Cosmos DB
8. *SaveChangesAsync* and *CommitAsync* successfully return
9. End of the update process

As seen in the code snippets above, all objects saved to Cosmos DB will be wrapped in a *DataObject* instance. Such an object provides common properties like *Id*, *PartitionKey*, *Type*, *State* (like e.g. *Created*, *Updated* etc. – won’t be persisted in Cosmos DB), _Etag_ (for [optimistic locking](https://docs.microsoft.com/azure/cosmos-db/sql/database-transactions-optimistic-concurrency#optimistic-concurrency-control)), *TTL* ([Time-To-Live](https://docs.microsoft.com/azure/cosmos-db/sql/time-to-live) property for automatic cleanup of old documents) and the *Data* itself. All of this is defined in a generic interface called *IDataObject* and used by the repositories and the container context:

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

Objects wrapped in a *DataObject* instance and saved to the database will then look like this (sample *Contact* and *ContactNameUpdatedEvent*):

```json
// Contact document/object - after creation
{
    "id": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2",
    "partitionKey": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2",
    "type": "contact",
    "data": {
        "name": {
            "firstName": "Bertram",
            "lastName": "Gilfoyle"
        },
        "description": "This is a contact",
        "email": "bg@piedpiper.com",
        "company": {
            "companyName": "Pied Piper",
            "street": "Street",
            "houseNumber": "1a",
            "postalCode": "092821",
            "city": "Palo Alto",
            "country": "US"
        },
        "createdAt": "2021-09-22T11:07:37.3022907+02:00",
        "deleted": false,
        "id": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2"
    },
    "ttl": -1,
    "_etag": "\"180014cc-0000-1500-0000-614455330000\"",
    "_ts": 1631868211
}

// after setting a new name - this is how an event document looks like
{
    "id": "d6a5f4b2-84c3-4ac7-ae22-6f4025ba9ca0",
    "partitionKey": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2",
    "type": "domainEvent",
    "data": {
        "name": {
            "firstName": "Dinesh",
            "lastName": "Chugtai"
        },
        "contactId": "b5e2e7aa-4982-4735-9422-c39a7c4af5c2",
        "action": "ContactNameUpdatedEvent",
        "id": "d6a5f4b2-84c3-4ac7-ae22-6f4025ba9ca0",
        "createdAt": "2021-09-17T10:50:01.1692448+02:00"
    },
    "ttl": 120,
    "_etag": "\"18005bce-0000-1500-0000-614456b80000\"",
    "_ts": 1631868600
}

```

You see that the *Contact* and *ContactNameUpdatedEvent* (type: *domainEvent*) documents have the same partition key – hence both documents will be persisted in the same logical partition.

### Change Feed Processing

To read the stream of events and send them to a message broker, the service will make use of the [Cosmos DB Change Feed](https://devblogs.microsoft.com/cosmosdb/change-feed-unsung-hero-of-azure-cosmos-db/).

The Change Feed is a persistent log of changes in your container that is operating in the background keeping track of modifications in the order the changes occurred – per logical partition. The most convenient way to read the Change Feed is to use an [Azure Function with a Cosmos DB trigger](https://docs.microsoft.com/azure/azure-functions/functions-create-cosmos-db-triggered-function). Another option is to use the [Change Feed Processor library](https://docs.microsoft.com/azure/cosmos-db/sql/change-feed-processor). It lets you integrate Change Feed processing in your Web API e.g. as a background service (via *IHostedService* interface). This sample here uses a simple console application that implements the abstract class [_BackgroundService_](https://docs.microsoft.com/dotnet/api/microsoft.extensions.hosting.backgroundservice) for hosting long running background tasks in .NET Core applications.

To receive the changes from the Cosmos DB Change Feed, you need to instantiate a *ChangeFeedProcessor* object, register a handler method for message processing and start listening for changes:

```csharp
private async Task<ChangeFeedProcessor>
    StartChangeFeedProcessorAsync()
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

A handler method (here: *HandleChangesAsync*) is then responsible for processing the messages. In this sample, we publish the events to an Azure Service Bus topic which is partitioned for scalability and has the [de-duplication feature enabled](https://docs.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection). From there on, any service interested in changes to *Contact* objects can subscribe to that topic and receive and process the changes for its own context.

The Service Bus messages produced have a *SessionId* property. By using sessions in Azure Service Bus, you guarantee that the order of the messages is preserved ([FIFO](https://docs.microsoft.com/en-us/azure/service-bus-messaging/message-sessions)) – which is necessary for this use case.

Here is the snippet that handles messages from the Change Feed:

```csharp
private async Task HandleChangesAsync(IReadOnlyCollection<ExpandoObject> changes, CancellationToken cancellationToken)
{
    _logger.LogInformation($"Received {changes.Count} document(s).");
    var eventsCount = 0;

    Dictionary<string, List<ServiceBusMessage>> partitionedMessages = new();

    foreach (var document in changes as dynamic)
    {
        if (!((IDictionary<string, object>)document).ContainsKey("type") ||
            !((IDictionary<string, object>)document).ContainsKey("data")) continue; // unknown doc type

        if (document.type == EVENT_TYPE) // domainEvent
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

            // Create message batch per partitionKey
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

        // Loop over each partition
        foreach (var partition in partitionedMessages)
        {
            // Create batch for partition
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

### Error Handling

In case of an error while processing the changes, the Change Feed library will restart reading messages at the position where it successfully processed the last batch. For example, if the application already processed 10.000 messages, is now in the middle of working on messages 10.001 to 10.0025 and an error happens, the application can simply restart and pick up its work at position 10.001. The library automatically keeps track of what has already been processed via information saved in a *Leases* container in Cosmos DB.

It can happen that – out of the 25 messages that are reprocessed – the service already sent 10 messages to Azure Service Bus. Normally, this would lead to duplicate message processing. As mentioned before, Azure Service Bus has a feature for duplicate message detection, which should be enabled for this scenario. The service will check if a message has already been added to a topic (or queue) during a specified time window based on the application-controlled *MessageId* property of a message. That property is set to the *Id* of the event document, meaning Azure Service Bus will ignore and drop a message, if a certain event has already been successfully added to the Service Bus topic.

### Housekeeping

In a typical "Transactional Outbox" implementation, the service would update the handled events and set a *Processed* property to `true`, indicating that a message has been successfully published. This could be addressed manually in the handler method. In the current scenario, where Azure Cosmos DB is used, the service already keeps track of events that were processed by using the Change Feed (in combination with the *Leases* container).

As a last step, every once in a while the events need to be deleted from the container to only keep the most recent records/documents. To periodically do a clean-up, the implementation leverages another feature of Cosmos DB: Time-To-Live (*TTL*) on documents. Cosmos DB provides the ability to automatically delete documents based on a *TTL* property that can be added to a document – a timespan in seconds. The service will constantly check the container for documents with a *TTL* property and as soon as it has expired, Cosmos DB will remove it from the database.

When all the components work as expected, events will be processed and published fast – meaning within seconds. If there is an error in Cosmos DB, events won't be sent to the message bus, because both the business object as well as corresponding events can’t be saved to the database at all. The only thing to consider in this scenario is to set an appropriate *TTL* value on the *DomainEvent* documents, for the case when the background worker (Change Feed Processor) or the Azure Service Bus aren’t available. In a production environment, it's best to pick a timespan of multiple days, e.g. 10 days. All components involved will then have enough time to process / publish changes within the application.

## Summary

The **Transactional Outbox** pattern solves the problem of reliably publishing (domain) events in distributed systems. By committing the business object's state and its events in the same transactional batch and using a background processor as a message relay, it is ensured that other services - internal or external - will eventually receive the information they depend on. In the end, this is not a "traditional" implementation of the "Transactional Outbox" pattern, because the sample leverages features like the Cosmos DB Change Feed and Time-To-Live to keep things simple and clean.

Here is a summary of the Azure components used in this scenario:

:::image type="content" source="media/transactional-outbox/components.png" alt-text="Azure components to implement transactional outbox with Azure Cosmos DB and Azure Service Bus.":::

The advantages of this solution are:

- reliable messaging and guaranteed delivery of events
- preserved order of events and message de-duplication via Azure Service Bus
- no need to maintain an extra *Processed* property that indicates successful processing of an event document
- error proof processing of messages via ChangeFeedProcessor (or Azure Function)
- optional: add multiple Change Feed processors – each maintaining its own "pointer" enabling additional scenarios

### Deploy this scenario

> Link to sample source code and bicep deployment - currently hosted here: <https://github.com/cdennig/transactional-outbox-sample>. Should be moved to an appropriate location.

## Next steps

Review these articles to learn more:

- [Domain-Driven-Design](https://docs.microsoft.com/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
- [CQRS pattern](https://docs.microsoft.com/azure/architecture/patterns/cqrs)
- [Materialized View pattern](https://docs.microsoft.com/azure/architecture/patterns/materialized-view)
- [Azure Service Bus – Message De-duplication](https://docs.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection)
- [Change Feed Processor library](https://docs.microsoft.com/azure/cosmos-db/sql/change-feed-processor)
- [Jimmy Bogard – A better domain events pattern](https://lostechies.com/jimmybogard/2014/05/13/a-better-domain-events-pattern/)
