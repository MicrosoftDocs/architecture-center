[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a highly scalable architecture for ingesting metadata from external catalogs, like [Acryl Data](https://www.acryldata.io/) and [data.world](https://data.world/), into [Microsoft Purview](https://www.microsoft.com/security/business/microsoft-purview). The company in this scenario has various subdivisions and subsidiaries that work independently. 

*Apache® and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/synchronization-framework.png" alt-text="Diagram that shows an architecture for ingesting metadata from external catalogs." lightbox="../media/synchronization-framework.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/synchronization-framework.vsdx) of this architecture.*  

### Workflow 

This solution imports three types of objects from external catalogs into Microsoft Purview: [assets](/azure/purview/catalog-asset-details), [glossary terms](/azure/purview/concept-business-glossary), and [classifications](/azure/purview/concept-classification).  

The architecture has two main components:  

- Connectors (steps 1 and 2) 
- An import module (step 3) 

The **connectors** are specific to each external catalog. They're responsible for the first two steps: extract and transform. Because of the nature of these steps, and because the connectors depend on details that are specific to the external catalog, you need to create a connector for each catalog that the solution works with. Catalog-specific details include how to extract the metadata, by using, for example, APIs, and how the metadata is structured. You therefore need one of each of the services components of the connectors shown in the diagram (Azure Functions, Azure Event Hubs) per external catalog. The output of the connector component is written in a catalog-agnostic format, referred in this article to as the *pivot* format.

The **import module** is the last step in the synchronization framework. It's catalog agnostic and works with metadata in pivot format. All metadata that was extracted and transformed to pivot format is streamed to three services buses, one for each object type: classifications, glossary terms, and assets. An Azure function listens to each service bus queue and imports the received object into Microsoft Purview as an upsert operation by using the [Microsoft Purview API](/rest/api/purview/catalogdataplane/entity) or [SDKs](/azure/purview/tutorial-using-python-sdk). The functions also populate intermediate storage, referred to as *synchronization state* in this article, with information about the imported objects. Deletion is handled on a scheduled basis, via an Azure function, based on information from synchronization state.

1. **Extract** 

   The extract step is accomplished in one of two ways: pull-based or push-based.

   - **Pull-based** extraction: This approach uses an Azure function with an event hub as output binding. The Azure function pulls all the metadata from the external catalog. The function is triggered on a [scheduled basis](/azure/azure-functions/functions-bindings-timer).  

     - The Azure function can split the extracted metadata into separate messages, as appropriate. For example, if the external catalog contains metadata about six Azure SQL tables, you can split the information into six messages, one for each table. Use the structure of the metadata from the external catalog to determine whether splitting the messages makes sense.
     - Each message is then sent to the Event Hubs topic that corresponds to that external catalog via [Event Hubs output binding](/azure/azure-functions/functions-bindings-event-hubs-output).  
   - **Push-based** extraction: The subdivision owns the extraction step. The subdivision implements a mechanism that uses Kafka to directly push the metadata to an Event Hubs topic.  

   > [!Note] 
   > One Event Hub topic is used for each external catalog.  

2. **Transform**

   During the transform step, the metadata received from the external catalog is converted into a common format, called *[pivot](#pivot-classes)* in this article. This step consists of one Azure function, with an event hub as an input binding, for each external catalog. The output of this step is a set of assets, glossary terms, or classifications in the pivot format. This set is streamed to the corresponding Azure Service Bus queue via a [Service Bus output binding](/azure/azure-functions/functions-bindings-service-bus-output).  

   For example, if the message received in the event hub contains a glossary term, the term is transformed to its pivot format and sent to the pivot glossary terms queue. 

3. **Import** 

   The last step is catalog agnostic and is responsible for loading the objects into Microsoft Purview in the intermediate pivot format. It consists of three Azure functions, each listening to its corresponding Service Bus queue. Every function implements an upsert operation (create/update) for one of the three object types. Using an upsert avoids creating duplicates. The Microsoft Purview REST API or SDKs, like the [Microsoft Purview Python SDK](/azure/purview/tutorial-using-python-sdk), are used for the import.
 
   [Azure Table Storage](/azure/storage/tables/) is used for the synchronization state intermediate storage. During the import, the synchronization state is updated with information about the imported object.  

   This synchronization framework operates based on the assumption that all metadata from the external catalog is imported during each run. Object creation and updates are handled by the upsert operation. An Azure function uses synchronization state to handle deletion. Because the synchronization framework is triggered on a schedule, a cleanup mechanism can run that identifies objects in synchronization state that weren't updated in a given number of days, even when multiple synchronizations ran during that time. In such a case, the metadata doesn't exist in the external catalog and should be removed from Microsoft Purview as well. 

### Components

- [Azure Functions](https://azure.microsoft.com/products/functions) is used in all compute steps. You can easily trigger Azure functions based on a schedule or specific events, which is particularly useful in a synchronization framework. 
- [Event Hubs](https://azure.microsoft.com/products/event-hubs) is used between the extract and transform steps. It streams the metadata that's extracted from the external catalog and is consumed during the transformation step. Event Hubs provides [an interface that can consume events produced by Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview).  
   - An external catalog can communicate with the system by using its own protocol and language, without needing details about the internals of the system, which uses exclusively the Event Hubs protocol. 
   - Event Hubs is suitable for both pull-based and push-based scenarios.
- [Service Bus](https://azure.microsoft.com/products/service-bus) is used as the message broker between the transform and import steps. Separate queues are used for assets, glossary terms, and classification. Service Bus provides high scalability and built-in mechanisms that are useful in an event-driven distributed system, like Peek-Lock, a dead letter queue, and message deferral. 
- [Microsoft Purview](https://azure.microsoft.com/products/purview/) is a data governance solution that provides a holistic map of metadata assets. 
- [Table Storage](https://azure.microsoft.com/products/storage/tables) stores the state of the objects that are synchronized between the external sources and Microsoft Purview. It's cost effective and provides highly scalable data storage, a simple API, and a strong consistency model. 
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) are used for all Azure functions when they communicate with the corresponding event hubs and service bus queues. For information about using the Microsoft Purview Rest API with a service principal, see [How to use REST APIs for Microsoft Purview Data Planes](/azure/purview/tutorial-using-rest-apis). For more information about access control in Microsoft Purview, see [Understand access and permissions in the Microsoft Purview governance portal](/azure/purview/catalog-permissions).
- [Application Insights](/azure/azure-monitor/app/app-insights-overview), a feature of [Azure Monitor](https://azure.microsoft.com/products/monitor), is used to collect telemetry. Monitoring is important in distributed systems. For more information, see [Distributed tracing in Application Insights](/azure/azure-monitor/app/distributed-tracing).

## Scenario details

This entire process is fully idempotent, which means that retriggering the process from any step is enough to make the system eventually consistent. For more information about using Event Hubs with Azure Functions, see [Integrate Event Hubs with serverless functions on Azure](../../serverless/event-hubs-functions/event-hubs-functions.yml). 

This architecture is also highly scalable:

- In addition to offering plans for scalability, Event Hubs provides an [Auto-inflate feature](/azure/event-hubs/event-hubs-auto-inflate) that increases the number of throughput units as needed. Similarly, Service Bus has an automatic scaling feature that adapts the number of messaging units. 
- The architecture uses Event Hubs and Service Bus triggers, which enables Azure Functions to scale in or out, balance the load, and process incoming messages concurrently as needed. 

  > [!note]
  > To avoid lock contention and achieve the highest performance, you need to perform throughput testing.  

- The Azure functions use Event Hubs triggers, which are compatible with the use of a [consumption plan](https://azure.microsoft.com/pricing/details/functions/#:~:text=Azure%20Functions%20consumption%20plan%20is,function%20apps%20in%20that%20subscription.) that bills based on per-second resource consumption and executions. Using this plan makes the architecture scalable and cost-efficient.

### Potential use cases

Organizations that take advantage of the potential of data can gain significant benefits. For example, Contoso, like many large companies, wants to create a holistic view of its data assets to enable data-driven business scenarios. Contoso is made up of multiple subdivisions and subsidiaries that work independently, which results in data silos and limited collaboration. 

For example, employees in Division A are starting a new project. Data assets like web site logs, trend analysis, and social network analysis might be relevant to the project. However, these assets belong to other subsidiaries, and the employees aren't even aware of them, which affects the success of the project. 

Contoso wants to avoid this type of situation by creating a federated metadata catalog. Examples of metadata include the name and schema of a SQL table. The metadata doesn't reveal the contents of the table. 

Contoso decides to use Microsoft Purview to solve this problem. Microsoft Purview enables the search and discovery of metadata about data assets. A federated catalog improves collaboration and breaks down organizational boundaries. Subdivisions and subsidiaries still own their data. However, because they share metadata about the data, collaboration improves. On a case-by-case basis, data can also be shared. Some subdivisions have already invested time and effort into implementing their own catalogs and scanning and enriching metadata, sometimes by using custom solutions. The next challenge is to determine how to import metadata from other catalogs into Microsoft Purview.

To resolve this challenge, Contoso uses the architecture described in this article to ingest metadata from external catalogs into Microsoft Purview. 

## Pivot classes

In this article, the word *pivot* is used to describe a set of custom classes that represents the output of the transform step and the input for the import step. 

Here's the class diagram:

:::image type="content" source="../media/pivot-class-diagram.png" alt-text="Class diagram for the PivotItem class." lightbox="../media/pivot-class-diagram.png" border="false":::

`PivotItem` is the base class. `PivotClassificationItem`, `PivotAssetItem`, and `PivotGlossaryItem` inherit from the base class.

By using the information passed in the pivot classes, the import step [can create or update an entity](/rest/api/purview/catalogdataplane/entity/create-or-update-entities), [a glossary term](/rest/api/purview/catalogdataplane/glossary/create-glossary-term), or a [classification](/rest/api/purview/scanningdataplane/classification-rules/create-or-update) via, for example, the REST API.

You can use `PivotAssetItem` to create relationships between assets. You can also assign [glossary terms](/rest/api/purview/catalogdataplane/glossary/assign-term-to-entities) or [classifications](/rest/api/purview/catalogdataplane/entity/add-classification) to assets by using the `glossary_items` and `classification_items` properties.

The Microsoft Purview Data Catalog is based on the [Apache Atlas](https://atlas.apache.org/2.0.0/index.html) format, so each metadata object that's supported in Microsoft Purview has a type.

The type is analogous to a class definition in object-oriented programming (OOP). All metadata objects managed by Microsoft Purview (out of the box or through custom types) are modeled via type definitions. For more information about the type system, see [Type definitions and how to create custom types in Microsoft Purview](/azure/purview/tutorial-custom-types).

> [!Note] 
> For even better scalability, you can [ingest metadata by using the Atlas hook](/azure/purview/how-to-lineage-spark-atlas-connector). Microsoft Purview can have an optional underlying event hub on which Kafka Surface is enabled. However, the import step only sends Kafka messages to a topic. You have no visibility into whether the sent data is actually ingested later in the process. You can enable that visibility by adding logic, but doing so adds complexity. To provide a better user experience, this architecture uses REST APIs that provide return statuses and relies on the Azure Functions scale-out capability.

### Additional details about properties

`type` is the type of the asset that you want to create. For example, if you want to create an asset of type SQL table, the `type` is `azure_sql_table`. For an overview of the types in Microsoft Purview, see [Types - REST API](/rest/api/purview/catalogdataplane/types/get-all-type-definitions?tabs=HTTP).  

- `target_collection` is the name of the collection in which the asset should be located in Microsoft Purview. 

- `external_catalog_id` is the unique identifier of the object in the external catalog. 

All of these properties are set in the connector so that they can be used during the import step. 

## Synchronization state 

The synchronization state intermediate storage maintains the state of synchronization by storing the mapping between the source metadata and Microsoft Purview metadata objects, as shown here:

|Partition Key| Row Key| Sync Start Time| Correlation ID|State|Purview Object ID|Sync End Time |
|-|-|-|-|-|-|-|
|*CatalogName*_Asset |123..a1c|2023—10-24T21:05:32Z|456..def|Pending| |
|*CatalogName*_Glossary |7c3…bdf|2023-10-25T22:12:27Z|er3..2d4|Completed|5f9…sds|2023-10-25T22:13:02Z| 
|*CatalogName*_Classification|de3…85f|2023-11-25T22:12:27Z|ce4...13c|Failed||2023-11-25T22:13:02Z| 

> [!Note] 
> Synchronization state is used to reflect the last run of the synchronization framework. It doesn't provide historical data of all runs. Therefore, there's only one entry per object imported from external catalogs. It reflects the state of the last synchronization (`Completed`, `Pending`, or `Failed`).

Here are some details about these properties: 

- `Partition Key`. A concatenation of the name of the external catalog and the type of the object (`Asset`, `Glossary`, or `Classification`). For example: 
  - `CatalogA_Asset`. Assets from a catalog called Catalog A. 
  - `CatalogB_Glossary`. Glossary terms from a catalog called Catalog B. 
  - `CatalogC_Classification`. Classifications from a catalog called Catalog C. 
- `Row Key`. The unique identifier of the metadata object in the external catalog, such as the GUID. It's used as the row key in every partition. 

  > [!Note] 
  > [Table Storage](https://azure.microsoft.com/products/storage/tables/) is used for synchronization state because it provides strong consistency, which ensures that there's only one unique record per object for a given partition.

- [Correlation ID](/azure/azure-monitor/app/correlation). The unique identifier of the synchronization operation. It's created at the start of the workflow and passed from one step to another. 
- `Sync Start Time` and `Sync End Time`. The start and end time of the synchronization operation (UTC). 
- `State`. The state of the synchronization operation (`Pending`, `Completed`, or `Failed`). 
- `Purview Object ID`. The unique identifier of the object in Microsoft Purview. 

`Partition Key` and `Row Key` are used as a tuple to uniquely identify an object from the external catalog. The tuple uses the `Purview Object ID` property to link the object that's extracted from the external catalog to the object that's created in Microsoft Purview.

This configuration ensures that: 

- Only one unique record exists per object for a given partition. For example, if three glossary terms are imported from Catalog A, there will be three entries in synchronization state that have `CatalogA_Glossary` as the partition key. Each entry will have a different row key, which is based on the unique identifier of that item in the external catalog. 
- Synchronization state is used as a locking mechanism so that two messages can't import the same object at the same time. Table Storage is particularly useful for this purpose.

### Import and synchronization state

The following diagram illustrates the details of the import flow of an asset and shows how the synchronization state storage is used:

:::image type="content" source="../media/import-flow.png" alt-text="Diagram that shows the import flow." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/synchronization-framework.vsdx) of this architecture.*

#### Dataflow

1. The import step is triggered. Synchronization state storage is queried by `Partition Key` and `Row Key`:  
   1. If no entry exists, the import process initializes a new line with the `State` set to `Pending`. The `Row Key` is set to the unique identifier of the object in the external catalog and the `Partition Key` is set accordingly. A lock ensures that no other process can import the same metadata object at the same time. `Sync Start Time` and `Correlation ID` are also initialized. 
   1. If an entry already exists: 
      1. If the `State` is `Failed`, the entry is updated with a new `Correlation ID` and a new `Sync Start Time`, and the `State` is set to `Pending`.  
      1. If the `State` is `Pending`, the message is scheduled to be re-queued later. For this purpose, the [dead-lettering queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) and re-queue mechanism that [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) offers by default is convenient. 
      1. If the `State` is `Completed`, the `Correlation ID` of the current run is compared to the one from the entry:
         1. If they're different, the entry is updated with the current `Correlation ID` and a new `Sync Start Time`, and the `State` is set to `Pending`.  
         1. Otherwise, the message is skipped.  

      > [!Note] 
      > All messages that belong to a single synchronization run have the same `Correlation ID`. This configuration ensures that each object is updated only one time per run. It assumes that there are no partial updates. You should consider how this behavior affects your implementation.
1. The object is created or updated in Microsoft Purview.
1. The unique identifier of the object, `Purview Object ID`, and the `Sync End Time` are written to synchronization state, and the `State` is changed to `Completed`. If the import fails, `State` is set to `Failed`. 

You could use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview?tabs=csharp-inproc) instead of the synchronization state intermediate storage. 

## Deletion  

The process for deletion is based on `Sync Start Time` and `Sync End Time` in the synchronization state storage. Because the synchronization framework is triggered on a schedule, the objects in synchronization state that haven't been updated for a given time, even when multiple synchronizations have run during that time, have been removed from the external catalog. Therefore, those objects should also be removed from Microsoft Purview. 

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Julien Corioland](https://www.linkedin.com/in/juliencorioland) | Principal Software Engineer 
- [Adina Stoll](https://www.linkedin.com/in/adina-stoll) | Software Engineer 2 

Other contributors: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat) | Software Engineer 2 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Get all type definitions - REST API (Microsoft Purview)](/rest/api/purview/catalogdataplane/types/get-all-type-definitions)  
- [Design a scalable partitioning strategy for Azure Table Storage (REST API)](/rest/api/storageservices/designing-a-scalable-partitioning-strategy-for-azure-table-storage) 
- [Triggers and bindings in Azure Functions](/azure/azure-functions/functions-triggers-bindings)  
- [Tutorial: How to use the Microsoft Purview Python SDK](/azure/purview/tutorial-using-python-sdk) 
- [Compare Azure messaging services](/azure/event-grid/compare-messaging-services) 

## Related resources

- [Design a collection structure for a Microsoft Purview federated catalog](/azure/architecture/guides/collection-structure-federated-catalog)
- [Design Event Hubs and Functions for resilience](../../serverless/event-hubs-functions/resilient-design.md) 
- [Data governance with Profisee and Microsoft Purview](../../reference-architectures/data/profisee-master-data-management-purview.yml)
