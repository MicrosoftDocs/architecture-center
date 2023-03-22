This article describes a highly scalable architecture for ingesting metadata from external catalogs, like [Acryl Data](https://www.acryldata.io/) and [data.world](https://data.world/), into [Microsoft Purview](https://www.microsoft.com/security/business/microsoft-purview). 

## Architecture

:::image type="content" source="../media/synchronization-framework.png" alt-text="Image alt text." lightbox="../media/synchronization-framework.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/synchronization-framework.vsdx) of this architecture.*  

### Workflow 

This solution imports three types of objects from external catalogs into Microsoft Purview: [assets](/azure/purview/catalog-asset-details), [glossary terms](/azure/purview/concept-business-glossary), and [classifications](/azure/purview/concept-classification).  

The architecture has two main components:  

- Connectors (steps 1 and 2) 
- An import module (step 3) 

The **connectors** are specific to each external catalog. They're responsible for the first two steps: extract and transform. Because of the nature of these steps, and because the connectors depend on details that are specific to the external catalog, you need to create a connector for each catalog that the synchronization framework works with. Catalog-specific details include how to extract the metadata, by using, for example, APIs, and how the metadata is structured. You therefore need one of each of the services components of the connectors shown in the diagram (Azure Functions, Azure Event Hubs) per external catalog. The output of the connector component is written in a catalog-agnostic format, referred in this article to as the *pivot* format.

The **import module** is the last step in the synchronization framework (step 3). It's catalog agnostic and works with metadata in pivot format. All metadata that was extracted and transformed to pivot format is streamed to three services buses, for classifications, glossary terms, and assets. An Azure function listens to each service bus queue and imports the received object into Microsoft Purview as an upsert operation by using the [Microsoft Purview API](/rest/api/purview/catalogdataplane/entity) or [SDKs](/azure/purview/tutorial-using-python-sdk). The functions also populate intermediate storage, referred to as *synchronization state* in this article, with information about the imported objects. Deletion is handled on a scheduled basis, via an Azure function, based on information from synchronization state.

1. **Extract** 

   The extract step is accomplished in one of two ways: pull-based or push-based.

   - **Pull-based** extraction uses an Azure function and an event hub as output binding. The Azure function pulls all the metadata from the external catalog and is triggered on a [scheduled basis](/azure/azure-functions/functions-bindings-timer?tabs=in-process&pivots=programming-language-csharp).  

     - The Azure function can split the extracted metadata into separate messages, as appropriate. For example, if the external catalog contains metadata about six Azure SQL tables, you can split the information into six messages, one for each table. Use the structure of the metadata from the external catalog to determine whether splitting the messages makes sense.
     - Each message is then sent to the Event Hubs topic that corresponds to that external catalog via [Event Hubs output binding](/azure/azure-functions/functions-bindings-event-hubs-output?tabs=in-process%2Cfunctionsv2%2Cextensionv5&pivots=programming-language-python).  
   - **Push-based** extraction: The subdivision owns the extraction step. The subdivision implements a mechanism that uses Kafka to directly push the metadata to an Event Hubs topic.  

   > [!Note] 
   > One Event Hub topic is used per external catalog.  

2. **Transform**

   During the transform step, the metadata received from the external catalog is converted into a common format, called *[pivot](#pivot-classes)* in this article. This step consists of one Azure function, with an event hub as an input binding, for each external catalog. The output of this step is a set of assets, glossary terms, or classifications in the pivot format. This set is streamed to the corresponding Azure Service Bus queue via a [Service Bus output binding](/azure/azure-functions/functions-bindings-service-bus-output?tabs=in-process%2Cextensionv5&pivots=programming-language-python).  

   For example, if the message received in the event hub contains a glossary term, the term is transformed to its pivot format and sent to the pivot glossary terms queue. 

3. **Import** 

   The last step is catalog agnostic and is responsible for loading the objects into Microsoft Purview based on the intermediate pivot format. It consists of three Azure functions, each listening to its corresponding Service Bus queue. Every function implements an upsert operation (create/update) for one of the three object types, to avoid creating duplicates. The Microsoft Purview REST API or SDKs, like the [Microsoft Purview Python SDK](/azure/purview/tutorial-using-python-sdk), is used for the import.
 
   [Azure Table Storage](/azure/storage/tables/) is used for the synchronization state intermediate storage. During the import, the synchronization state is updated with information about the imported object.  

   This synchronization framework operates based on the assumption that all metadata from the external catalog is imported during each run. Object creation and updates are handled by the upsert operation. An Azure function uses synchronization state to handle deletion. Because the synchronization framework is triggered on a schedule, a cleanup mechanism can run that identifies objects in synchronization state that weren't updated in a given number of days, although multiple synchronizations ran during that time. In such a case, the metadata doesn't exist in the external catalog and should be removed from Microsoft Purview as well. 

### Components

- [Azure Functions](https://azure.microsoft.com/products/functions) is used in all compute steps. You can easily trigger Azure functions based on a schedule or specific events, functionality that's particularly useful in a synchronization framework. 
- [Event Hubs](https://azure.microsoft.com/products/event-hubs) is used between the extract and transform steps. It streams the metadata that's extracted from the external catalog and is consumed during the transformation step. Event Hubs provides [an interface that can consume events produced by Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview).  
   - An external catalog can communicate with the system by using its own protocol and language, without needing to know the internals of the system that uses exclusively the Event Hubs protocol. 
   - Event Hubs is suitable for both pull-based and push-based scenarios.
- [Service Bus](https://azure.microsoft.com/products/service-bus) is used as the message broker between the transform and import steps. Separate queues are used for assets, glossary terms, and classification. Service Bus provides high scalability and built-in mechanisms that are useful in an event-driven distributed system, like Peek-Lock, a dead letter queue, and message deferral. 
- [Microsoft Purview](https://azure.microsoft.com/products/purview/) is a data governance solution that provides a holistic map of metadata assets. 
- [Table Storage](https://azure.microsoft.com/products/storage/tables) stores the state of the objects that are synchronized between the external source and Microsoft Purview. It's cost effective and provides highly scalable data storage, a simple API, and a strong consistency model. 
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) are used for all Azure functions when they communicate with the corresponding event hubs and service bus queues. For information about using the Microsoft Purview Rest API with a service principal, see [How to use REST APIs for Microsoft Purview Data Planes](/azure/purview/tutorial-using-rest-apis). For more information about access control in Microsoft Purview, see [Understand access and permissions in the Microsoft Purview governance portal](/azure/purview/catalog-permissions).
- [Application Insights](/azure/azure-monitor/app/app-insights-overview?tabs=net), a feature of [Azure Monitor](https://azure.microsoft.com/products/monitor), is used to collect telemetry. Monitoring is important in distributed systems. For more information, see [Distributed tracing in Application Insights](/azure/azure-monitor/app/distributed-tracing).

## Scenario details

This entire process is fully idempotent, which means that re-triggering the process from any step is enough to make the system eventually consistent. For more information about using Event Hubs with Azure Functions, see [Integrate Event Hubs with serverless functions on Azure](../../serverless/event-hubs-functions/event-hubs-functions.yml). 

This architecture is also highly scalable:

- In addition to offering plans for scalability, Event Hubs provides an [Auto-inflate feature](/azure/event-hubs/event-hubs-auto-inflate) that increases the number of throughput units as needed. Similarly, Service Bus has an automatic scaling feature that adapts the number of messaging units. 
- The architecture uses Event Hubs and Service Bus triggers, which enables Azure Functions to scale in or out, balance the load, and process incoming messages concurrently as needed. To avoid lock contention and achieve the highest performance, you need to perform throughput testing.  
- The Azure functions use the Event Hubs triggers, which are compatible with the use of a [consumption plan](https://azure.microsoft.com/pricing/details/functions/#:~:text=Azure%20Functions%20consumption%20plan%20is,function%20apps%20in%20that%20subscription.) that billed based on per-second resource consumption and executions. Using this plan makes this architecture scalable and cost-efficient.

### Potential use cases

Organizations that unlock data's potential can gain significant benefits.  

For example, Contoso, like many large companies, would like to create a holistic view of their data assets to enable data driven business scenarios. Contoso is composed of multiple subdivisions / subsidiaries which work independently, resulting in data silos and limited collaboration. 

For example, as an employee in division A, you are about to create a new project. Data assets such as web site logs, trends analysis, social network analysis might be relevant to your project. However, these assets belong to other subsidiaries, and you are not even aware of their existence - which limits the success of your project. 

This is exactly the type of situation Contoso would like to avoid by creating a federated metadata catalog. An example of metadata is the name and schema of a SQL Table - without revealing the content of the table itself. 

Microsoft Purview has been chosen as the perfect solution for this - which allows searching and discovering metadata about data assets. Such a catalog would enable collaboration and would break down organizational boundaries. Subdivisions / subsidiaries will continue owning their data, however, by sharing metadata about their data, collaboration is enabled, and, on a case-by-case basis, data can be potentially shared. Some subdivisions have already invested time and effort in implementing their own catalog, scanning and enriching metadata, sometimes with other technologies, including custom solutions. The challenge Contoso is facing right now is how to import metadata from other catalogs into Microsoft Purview?  

To overcome this challenge, Contoso uses the architecture proposed in the rest of the article to ingest metadata from external catalogs into Microsoft Purview. 

The following sections provide additional information about applying and implementing this synchronization framework.

## Pivot classes 

When it comes to metadata exchange between different catalogs, we need to speak the same language at some point. We call **pivot** a set of custom classes which represents the output of step 2) and the input for step 3). 

The class diagram can be seen below:

image 

*PivotItem* is the base class, and *PivotClassificationItem*, *PivotAssetItem* and *PivotGlossaryItem* inherit from it.

Based on the information passed in the pivot classes, in this step one [can create or update an entity](/rest/api/purview/catalogdataplane/entity/create-or-update-entities?tabs=HTTP), [a glossary term](/rest/api/purview/catalogdataplane/glossary/create-glossary-term?tabs=HTTP) or a [classification](/rest/api/purview/scanningdataplane/classification-rules/create-or-update?tabs=HTTP) using, for example, the REST API. 

Furthermore, based on the *PivotAssetItem* relationships can be created between assets. In addition, [glossary terms](/rest/api/purview/catalogdataplane/glossary/assign-term-to-entities?tabs=HTTP) or [classifications](/rest/api/purview/catalogdataplane/entity/add-classification?tabs=HTTP) can be assigned to the assets, based on the property *glossary_items* and *classification_items*, respectively.

Purview relies on the underlying [Apache Atlas](https://atlas.apache.org/2.0.0/index.html) format and, as a result, each metadata object supported in Microsoft Purview has a type. 

The **Type** can be seen as **Class** definition from Object Oriented Programming (OOP). All metadata objects managed by Purview (out of the box or through custom types) are modeled using type definitions. For a further understanding of type system in Purview as well as how to create custom types, you can follow this tutorial: [Type definitions and how to create custom types in Microsoft Purview](/azure/purview/tutorial-custom-types).

Note: For even better scalability, ingestion can also be done using the Atlas hook, as this [tutorial showcases](/azure/purview/how-to-lineage-spark-atlas-connector). Microsoft Purview can also have an optional underlying Event hub with Kafka surface enabled. However, the import step would only amount to send Kafka messages to a topic and would have no visibility on whether the sent data is actually ingested further down the line. This is possible by adding a logic to make these checks which brings additional complexity. For the sake of a better UX, we favored the REST APIs that provide return statuses and rely on the Azure Functions ability to scale-out if required. 

**Further details on some properties:**

**type** is the **Type** of the asset you want to create. For example, if you want to create an asset of type SQL Table, then it would be **azure_sql_table**. For an overview of all the types in Purview, you can use: [Types - Get All Type Definitions - REST API](/rest/api/purview/catalogdataplane/types/get-all-type-definitions?tabs=HTTP).  

- **target_collection** is the name of the collection where the asset should land in Purview. 

- **external_catalog_id** is the unique identifier of the object in the external catalog. 

All these properties will be set in the connector so the Import step can use them. 

## Synchronization State 

The Synchronization State maintains the state of synchronization by storing the mapping between the source metadata and Purview metadata objects as follows: 


|Partition Key| Row Key| Sync Start Time| Correlation ID|State|Purview Object ID|Sync End Time |
|-|-|-|-|-|-|-|
|*CatalogName*_Asset |123..a1c|2023—10-24T21:05:32Z|456..def|Pending| |
|*CatalogName*_Glossary |7c3…bdf|2023-10-25T22:12:27Z|er3..2d4|Completed|5f9…sds|2023-10-25T22:13:02Z| 
|*CatalogName*_Classification|de3…85f|2023-11-25T22:12:27Z|ce4...13c|Failed||2023-11-25T22:13:02Z| 

Note: The state is used to reflect the last run of the synchronization framework, and not to have historic data of all runs. Therefore, there will be only one entry per imported object from external catalogs which will reflect the state of the last synchronization (Completed/Pending/Failed). 

- **Partition Key**: consists of the name of the external catalog and the type of the object (Asset/Glossary/Classification). For example: 
  - **CatalogA_Asset** - assets coming from a catalog called “Catalog A”. 
  - **CatalogB_Glossary** - glossary terms coming from a catalog called “CatalogB”. 
  - **CatalogC_Classification** – classifications coming from a catalog called “Catalog C” 
- **Row Key:** the unique identifier of the metadata object in the external catalog - such as the GUID, is used as the row key in every partition. 

  Note: [Azure Table store](https://azure.microsoft.com/products/storage/tables/) is used for the Synchronization State, due to its strong consistency which ensures that there is only one unique record per object for a given partition.

- [Correlation ID](/azure/azure-monitor/app/correlation): the unique identifier of the synchronization operation created at the very beginning of the workflow and passed from one step to another. 
- **Sync Start Time, Sync End Time:** the start time of the synchronization operation (UTC) and the end time, respectively. 
- **State:** the state of the synchronization operation (Pending, Completed, Failed). 
- **Purview Object ID:** the unique identifier of the object in Microsoft Purview. 

**Partition Key** and **Row Key** will be used as a tuple to uniquely identify an object from the external catalog. It will link the extracted object from the external catalog to the created object in Purview through **Purview Object ID** property. 

This structure ensures that: 

- Only one unique record exists per object for a given partition. i.e., if three glossary terms were imported from CatalogA then there will be three entries in the Synchronization State with **CatalogA_Glossary** as partition key. Each entry will have a different **Row Key** - based on the unique identifier of that item in the external catalog. 
- Synchronization State is used as a locking mechanism so that two messages cannot import the same object at the same time. The usage of Azure Table storage is particularly useful for this purpose.

### Import step and Synchronization State

Below we can zoom into the **import** flow of an asset and see how the Synchronization State is being used:

image 

*Download a [Visio file] of this architecture.*

The import consists of the following steps: 

1. When the import step is triggered, it first queries the Synchronization State by **Partition Key** and **Row Key**:  
   1. If no entry exists, the import process initializes a new line with the **State** set to *Pending*. The **Row Key** is set to the unique identifier of the object in the external catalog and the **Partition Key** is set accordingly. This ensures that no other process can import the same metadata object at the same time (lock). **Sync Start Time** and **Correlation ID** are also initialized, accordingly. 
   1. If an entry already exists: 
      1. If the **State** is *Failed*, the entry is updated with the new **Correlation ID**, a new **Sync Start Time** and the **State** is set to *Pending*.  
      1. If the **State** is *Pending*, the message is scheduled to be replayed later. For this purpose, the [dead-lettering queue](/azure/service-bus-messaging/service-bus-dead-letter-queues) and re-queue mechanism that [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) offers by default is very convenient. 
      1. If the **State** is *Completed*, the **Correlation ID** of the current run is compared against the one from the entry:
         1. If they are different, the entry is updated with the current **Correlation ID**, a new **Sync Start Time** and the **State** is set to *Pending*.  
         1. Otherwise, the message can be considered to be skipped.  

      Note: all messages part of a Synchronization run will have the same Correlation ID. This step ensures that each object is updated only one time per run. It assumes that there are no partial updates, and it should be considered based on the implementation. 

1. The object is created or updated in Microsoft Purview. 
1. Upon completion of previous step, the unique identifier of the object is written into the Synchronization State (**Purview Object ID**), alongside the **Sync End Time** and the **State** changed to *Completed*. If the import fails, the line is set to **State** *Failed*. 

[Durable Functions](/azure/azure-functions/durable/durable-functions-overview?tabs=csharp-inproc) can be considered as an alternative to the Synchronization State. 

## Deletion  

Deletion is implemented based on the Synchronization State by using **SyncStartTime** and **SyncEndTime**. Since the synchronization framework is triggered on a scheduled basis, the objects from the Synchronization State that were not updated for a given time, despite multiple synchronizations being run in between, symbolizes the fact that they were removed in the external catalog. Therefore, those objects should be removed from Purview as well. 

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

Julien Corioland | Principal Software Engineer 

Adina Stoll | Software Engineer 2 

Other contributors: 

Raouf Aliouat | Software Engineer 2 

## Next steps 

For an overview of all the type definitions in Purview you can use Types - Get All Type Definitions - REST API (Azure Purview) | Microsoft Learn 

For more information about partitioning and querying strategy with Azure Table Storage: Design a scalable partitioning strategy for Azure Table storage (REST API) - Azure Storage | Microsoft Learn 

For more information on Azure Functions triggers and bindings: Triggers and bindings in Azure Functions | Microsoft Learn 

Tutorial: How to use Microsoft Purview Python SDK - Microsoft Purview | Microsoft Learn 

Compare Azure messaging services - Azure Event Grid | Microsoft Learn 

Resilient design guidance for Event Hubs and Functions - Azure Architecture Center | Microsoft Learn 

## Related resources 

TODO: Link Raouf’s article about observability in distributed systems : proposal-guide-obs-e2e.docx 

TODO: Link the article about collection structures: Collection Structure.docx 

 