[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The Transit Hub is a dynamic [publish-subscribe model](/azure/architecture/patterns/publisher-subscriber) for data producers and data consumers to create and consume validated curated content or data. The model is elastic to allow for scale and performance. Data producers can quickly onboard and upload data to a service. The service validates the data against a schema that the data producer provides. The service then makes the validated data available for subscribers to consume data they're interested in.

The service validating the data doesn't need to know about the payload, only whether it's valid against a schema that the producer provides. This flexibility means the service can accept new payload types without having to be redeployed. This solution also lets data consumers get historical data that was published before the consumer subscribed.

## Potential use cases

This model is especially useful in the following scenarios:

- Messaging systems where user volume and status is unknown or varies unpredictably
- Publishing systems that potentially need to support new or unknown data sources
- Commerce or ticketing systems that need to continually update data and cache it for fast delivery

## Architecture

![Diagram of the Transit Hub publish-subscribe messaging system.](../media/transit-hub.png)

1. The **Data Producer App** publishes data to Azure Event Hubs.

   The **Data Producer** also provides the JSON schema, which is stored in an Azure Storage container.
1. As new data arrives, the event hub sends the data to the Azure Functions **Event Processing** function.
1. The **Event Processing** function retrieves the JSON schema from Azure Cache for Redis to reduce latency, and uses the schema to validate the data.

   If the schema isn't cached yet, the **Event Processing** function retrieves it from the Azure Storage container. The request for the schema also stores the schema in Azure Cache for Redis for future retrieval.

   >[!NOTE]
   > Azure Schema Registry in Event Hubs can be a viable alternative to storing and caching JSON schemas. For more information, see [Azure Schema Registry in Event Hubs (Preview)](/azure/event-hubs/schema-registry-overview).

1. The **Event Processing** function validates and routes the data:

   - If the topic doesn't exist yet:
     1. The **Event Processing** function publishes the new data to a **New Data** Service Bus topic.
     1. As new data arrives, the **Event Processing** function sends the data from the **New Data** topic to the **Service Bus Topic Manager** function.
        - If the data is valid, the **Service Bus Topic Manager** function creates a new **Valid Data** Service Bus topic.
        - If the data is invalid, the **Service Bus Topic Manager** function creates a new **Invalid Data** Service Bus topic.
     1. If the new data is valid, the **Event Processing** function inserts the data as a new **Snapshot Data** record in Azure Cosmos DB.

   - If the topic already exists:
     - If the data is valid, the **Event Processing** function merges the data into the existing **Valid Data** Service Bus topic.
     - If the data is invalid, the **Event Processing** function merges the data into the existing **Invalid Data** Service Bus topic.

1. As new valid data arrives, the **Event Processing** function sends the data from the **Valid Data** Service Bus topics to the **Data Consumer App**.
1. The **Service Bus Topic Manager** function republishes data to Event Hubs.
1. Event Hubs sends data from the **Invalid Data** Service Bus topic back to the **Data Producer App**. The producer subscribes to this topic to get feedback about invalid data that the producer created.
1. The **Snapshot Data Flat File Processor** in Azure Data Factory runs on a predefined schedule to extract snapshot data from the **Snapshot Data** Azure Cosmos DB database. The processor creates a flat file and publishes it to a **Snapshot Data Flat File** in Azure Storage for downloads.
1. The **Data Consumer App** retrieves a list of all the Service Bus topics that the **Service Bus Topic Manager** has available for subscription.
1. The **Data Consumer App** registers with the **Service Bus Topic Manager** to subscribe to Service Bus topics.

### Components

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs)
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus)
- [Azure Functions](https://azure.microsoft.com/services/functions)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache)


## Next steps

- [Azure Web PubSub service documentation](/azure/azure-web-pubsub/)
- [Service Bus queues, topics, and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions)

## Related resources

- [Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)


