## Performance
## Latency
## Responsiveness
## Scalability
## Durability
## Resiliency
## Security

---

## Dump zone

The Azure Mission-Critical application data access pattern has the following characteristics:

- Read pattern - Point reads e.g. queries which fetch a single record. These queries have a "WHERE" clause defined so that a single row is selected for reads.
- Write pattern - Small writes e.g. queries which usually insert a single or a very small number of records in a transaction.
- Designed to handle high traffic from end-users with the ability to scale to handle traffic demand in the order of millions of users
- Payload or dataset size - small (usually in order of KB)
- Data freshness - This stores the latest transactional data with a limited history
- Low response time (in order of milli-seconds)
- Low Latency (in order of milli-seconds)
- The OLTP nature of the access pattern of Azure Mission-Critical has a bearing on the choice of architectural characteristics and must be considered while choosing backend datastores. The key architectural characteristics are:

Based on these characteristics, Azure Mission-Critical uses the following data stores:

Cosmos DB to serve as the main backend database.
Event Hubs for messaging capabilities.
Note - From data platform capabilities perspective, the current reference implementation of Azure Mission-Critical focuses on the operational data store. In future, we plan to update Azure Mission-Critical guidance to include analytics capabilities. In the meantime, we encourage readers to refer to Enterprise Scale Analytics guidance for enabling analytics at scale on Azure.

Database
Azure Cosmos DB was chosen as the main database as it provides the crucial ability of multi-region writes: each stamp can write to the Cosmos DB replica in the same region with Cosmos DB internally handling data replication and synchronization between regions.

Azure Mission-Critical is a cloud-native application. Its data model does not require features offered by traditional relational databases (e.g. entity linking across tables with foreign keys, strict row/column schema, views etc.).

The SQL API of Cosmos DB is being used as it provides the most features and there is no requirement for migration scenario (to or from some other database like MongoDB).

The reference implementation uses Cosmos DB as follows:

Consistency level is set to the default "Session consistency" as the most widely used level for single region and globally distributed applications. Azure Mission-Critical does not use weaker consistency with higher throughput because the asynchronous nature of write processing doesn't require low latency on database write.

Partition key is set to /id for all collections. This decision is based on the usage pattern which is mostly "writing new documents with random GUID as ID" and "reading wide range of documents by ID". Providing the application code maintains its ID uniqueness, new data will be evenly distributed into partitions by Cosmos DB.

Indexing policy is configured on collections to optimize queries. To optimize RU cost and performance a custom indexing policy is used and this only indexes properties used in query predicates. For example, the application doesn't use the winning player name field as a filter in queries and so it was excluded from the custom indexing policy.

Example of setting indexing policy in Terraform:

``` 
indexing_policy {

  excluded_path {
    path = "/winningPlayerName/?"
  }

  excluded_path {
    path = "/playerGestures/gesture/?"
  }

  excluded_path {
    path = "/playerGestures/playerName/?"
  }

  included_path {
    path = "/*"
  }

}
```
Database structure follows basic NoSQL principles and stores related data as single documents.

Application code gets the playerName information from AAD and stores it in the database instead of querying AAD each time.
Leaderboard is generated on-demand and persists in the database (instead of recalculating on every request) as this action can be a database-heavy operation.
In application code, the SDK is configured as follows:

Use Direct connectivity mode (default for .NET SDK v3) as this offers better performance because there are fewer network hops compared to Gateway mode which uses HTTP.
EnableContentResponseOnWrite is set to false to prevent the Cosmos DB client from returning the resource from Create, Upsert, Patch and Replace operations to reduce network traffic and because this is not needed for further processing on the client.
Custom serialization is used to set the JSON property naming policy to JsonNamingPolicy.CamelCase (to translate .NET-style properties to standard JSON-style and vice-versa) and the default ignore condition to ignore properties with null values when serializing (JsonIgnoreCondition.WhenWritingNull).
The Azure Mission-Critical reference implementation leverages the native backup feature of Cosmos DB for data protection. Cosmos DB's backup feature supports online backups and on-demand data restore.

Note - In practice, most workloads are not purely OLTP. There is an increasing demand for real-time reporting, such as running reports against the operational system. This is also referred to as HTAP (Hybrid Transactional and Analytical Processing). Cosmos DB supports this capability via Azure Synapse Link for Cosmos DB.

## Messaging bus

Azure Event Hubs service is used for the asynchronous messaging between the API service (CatalogService) and the background worker (BackgroundProcessor). It was chosen over alternative services like Azure Service Bus because of its high throughput support and because Azure Mission-Critical does not require features like Service Bus' in-order delivery.

Event Hubs offers Zone Redundancy in its Standard SKU, whereas Service Bus requires Premium tier for this reliability feature.

The only event processor in the Azure Mission-Critical reference implementation is the BackgroundProcessor service which captures and processes events from all Event Hubs partitions.

Every message needs to contain the action metadata property which directs the route of processing:

// `action` is a string:
//  - AddCatalogItem
//  - AddComment
//  - AddRating
//  - DeleteObject
switch (action)
{
    case Constants.AddCatalogItemActionName:
        await AddCatalogItemAsync(messageBody);
        break;
    case Constants.AddCommentActionName:
        await AddItemCommentAsync(messageBody);
        break;
    case Constants.AddRatingActionName:
        await AddItemRatingAsync(messageBody);
        break;
    case Constants.DeleteObjectActionName:
        await DeleteObjectAsync(messageBody);
        break;
    default:
        _logger.LogWarning("Unknown event, action={action}. Ignoring message", action);
        break;
}
Besides standard user flow messages (database CRUD operations),there are also health check messages identified by the HEALTHCHECK=TRUE metadata value. Currently health check messages are dropped and not processed further.

If a message isn't a health check and doesn't contain action, it's also dropped.

See BackgroundProcessor for more details about the implementation.

Note - A messaging queue is not intended to be used as a persistent data store for an long periods of time. Event Hubs supports Capture feature which enables an Event Hub to automatically write a copy of messages to a linked Azure Storage account. This keeps utilization of an Event Hubs queue in-check but it also serves as a mechanism to backup messages.

