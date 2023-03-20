This article describes a highly scalable architecture to ingest metadata from external catalogs (such as: [Acryl Data](https://www.acryldata.io/), [data.world](https://data.world/) etc) into [Microsoft Purview](https://www.microsoft.com/security/business/microsoft-purview). 

### Potential use cases

Data has an increasingly important role nowadays and it brings huge benefits to the organizations who unlock its potential.  

For example, Contoso, like many large companies, would like to create a holistic view of their data assets to enable data driven business scenarios. Contoso is composed of multiple subdivisions / subsidiaries which work independently, resulting in data silos and limited collaboration. 

For example, as an employee in division A, you are about to create a new project. Data assets such as web site logs, trends analysis, social network analysis might be relevant to your project. However, these assets belong to other subsidiaries, and you are not even aware of their existence - which limits the success of your project. 

This is exactly the type of situation Contoso would like to avoid by creating a federated metadata catalog. An example of metadata is the name and schema of a SQL Table - without revealing the content of the table itself. 

Microsoft Purview has been chosen as the perfect solution for this - which allows searching and discovering metadata about data assets. Such a catalog would enable collaboration and would break down organizational boundaries. Subdivisions / subsidiaries will continue owning their data, however, by sharing metadata about their data, collaboration is enabled, and, on a case-by-case basis, data can be potentially shared. Some subdivisions have already invested time and effort in implementing their own catalog, scanning and enriching metadata, sometimes with other technologies, including custom solutions. The challenge Contoso is facing right now is how to import metadata from other catalogs into Microsoft Purview?  

To overcome this challenge, Contoso uses the architecture proposed in the rest of the article to ingest metadata from external catalogs into Microsoft Purview.  

## Architecture

image 

*Download a [Visio file]() of this architecture.*  

### Workflow 

The proposed solution imports into Purview three types of objects from external catalogs, namely: [assets](/azure/purview/catalog-asset-details), [glossary terms](/azure/purview/concept-business-glossary) and [classifications](/azure/purview/concept-classification).  

The architecture consists of two main building blocks:  

- A connector (steps 1 and 2). 
- Import module (step 3). 

**The connector** is specific to each external catalog, and it consists of the first two steps (extract and transform). Due to the nature of these steps and the fact that they have specific knowledge of the external catalog (how to extract the metadata, using, for example, APIs, as well as how the metadata is structured), a connector needs to be written for each catalog that the synchronization framework works with. Therefore, the services part of the connector (Azure Functions, Event Hubs), as seen in the architecture diagram above, will be needed per external catalog. The output of the connector building block is written in a catalog-agnostic format, referred to as the **Pivot** format.

**Import module** represents the last step in the synchronization framework (step 3). It is catalog agnostic and works with metadata in Pivot format. All the metadata that was previously extracted and transformed to Pivot format will be streamed to three services buses - for classifications, glossary terms and assets, respectively. An Azure Function will listen to each service bus queue and will import the received object into Purview in an upsert fashion using [Purview API](/rest/api/purview/catalogdataplane/entity) or [SDKs](/azure/purview/tutorial-using-python-sdk). The functions will also populate the **Synchronization State** with information about the imported objects. Deletion will be handled on a scheduled basis using an Azure Function, based on the information from the Synchronization State. 

1. **Extract** 

   The extract step (1) supports two scenarios, pull and push-based, as follows: 

- **Pull-based scenario** uses an Azure Function and an Event Hub as output binding. The Azure Function pulls **all** the metadata from the external catalog (such as Acryl Data, data.world etc) and is triggered on a [scheduled basis](/azure/azure-functions/functions-bindings-timer?tabs=in-process&pivots=programming-language-csharp).  

  - As part of the Azure Function, the extracted metadata can be split into separate messages, as appropriate. For example, if the external catalog contains metadata about 6 Azure SQL Tables, you can choose to split the information in 6 messages, each concerning one SQL Table. This choice should be made based on the structure of the metadata from the external catalog.
  - **Push-based scenario**: the subdivision owns the extraction step by implementing a mechanism which directly pushes the metadata to an Event Hub topic through Kafka.  

  Note: One Event Hub Topic is used per external catalog.  

2. **Transform** 

   The transform step (2) converts the metadata received from the external catalog into a common format - called pivot, which is described further below. This step consists of an Azure Function per external catalog with Event Hub as input binding. The result of this step is a set of assets, glossary terms or classifications in the pivot format, which is streamed to the corresponding Service Bus queue, [using Azure Service Bus output binding](/azure/azure-functions/functions-bindings-service-bus-output?tabs=in-process%2Cextensionv5&pivots=programming-language-python).  

   For example, if the message received in the Event Hub contains a glossary term, the transformation step will transform the term in its pivot format and send it to the **Pivot Glossary Terms queue**. 

3. **Import** 

   The last step is catalog agnostic and is responsible for loading the objects into Microsoft Purview based on the intermediate format, called pivot. It consists of three Azure Functions, each listening to its specific Service Bus queue. Every function implements an upsert operation (create/update) for that type of object, avoiding creating duplicates. Purview REST API or Purview SDKs, such as [Microsoft Purview Python SDK](/azure/purview/tutorial-using-python-sdk), can be used for the implementation.
 
   For this step we are using [Azure Table storage](/azure/storage/tables/) as an intermediate storage, referred to as **Synchronization State** in this article. As part of the import, the Synchronization State will be updated with information concerning the imported object.  

   The Synchronization Framework assumes that all the metadata from the external catalog is imported in each run. Creation and updates are handled by the upsert operation. Deletion is implemented using an Azure Function, based on the Synchronization State. Since the synchronization framework is triggered on a scheduled basis, a cleanup mechanism can run which would identify the objects in the Synchronization State that were not updated since x days despite multiple synchronizations being run in between. In such a case, it means that the metadata does not exist in the external catalog and should be removed from Purview as well. 

### Components

The synchronization framework uses the following components: 

- [Azure Functions](https://azure.microsoft.com/products/functions) are used for all compute steps (1,2,3). They can easily be triggered on a scheduled basis or by specific events, which is particularly useful in a synchronization framework. 
- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs) is used between the extract (1) and transform (2) step. It streams the metadata that was extracted from the external catalog which is consumed in the transformation step. An Event Hub is used per external catalog.  Event Hubs provides [an interface that can consume events produced with Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview).  
   - This enables an external catalog to seamlessly enter the system with the protocol and language of its choice, without bothering about the internals of the system that uses exclusively the Event Hubs protocol. 
   - This makes Event Hubs suitable for both pull-based and push-based scenarios 
- [Azure Service Bus](https://azure.microsoft.com/products/service-bus) is used as the message broker between the transform (2) and import step (3). A dedicated queue is used for assets, glossary terms and classification, respectively. It offers high scalability and comes with built-in mechanisms, such as: peek & lock, dead lettering or message delaying that are particularly useful in an event driven distributed system. 
- [Microsoft Purview](https://azure.microsoft.com/products/purview/) is a data governance solution which enables a holistic map of metadata assets. 
- [Azure Table storage](https://azure.microsoft.com/products/storage/tables) stores the state of the objects that are synchronized between the external source and Microsoft Purview. It provides high-scale data storage, simple API, strong consistency and is very cost effective. 
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) are used for all Azure functions when using the corresponding event hub and service bus. Follow this tutorial to see how to use Purview Rest API with a Service Principal: [How to use REST APIs for Microsoft Purview Data Planes](/azure/purview/tutorial-using-rest-apis). This article will provide more information on access control in Microsoft Purview: [Understand access and permissions in the Microsoft Purview governance portal](/azure/purview/catalog-permissions). 
- [Application Insights](/azure/azure-monitor/app/app-insights-overview?tabs=net) is used for collecting telemetry, which is a feature of [Azure Monitor](https://azure.microsoft.com/products/monitor). Monitoring is a key aspect in a distributed system. For more information on distributed tracing: [Distributed tracing in Azure Application Insights](/azure/azure-monitor/app/distributed-tracing).

## Scenario details

The entire process is fully idempotent, which means that re-triggering the process from any step would be enough to make the system eventually consistent. [Here](../../serverless/event-hubs-functions/event-hubs-functions.yml) you can find more information about Event Hubs with Azure Functions. The architecture is also highly scalable:

- On top of offering plans for scale needs, Event Hubs provides an [auto-inflate feature](/azure/event-hubs/event-hubs-auto-inflate) to increase the number of throughput units if needed. Similarly, Service Bus has an automatic scaling feature that adapts the number of messaging units. 
- We rely on Event Hubs and Service bus triggers, which enables Azure Functions to scale in or out, balance the load and process incoming messages concurrently if required. Throughput testing is very important to be performed to avoid lock contention and to achieve the highest performance.  
- The Azure Functions use the Event Hubs trigger that is compatible with the use of a [consumption plan](https://azure.microsoft.com/en-us/pricing/details/functions/#:~:text=Azure%20Functions%20consumption%20plan%20is,function%20apps%20in%20that%20subscription.) that bills on per-second resource consumption and executions, making this architecture scalable and cost-efficient.

The following sections provide additional information about applying and implementing the synchronization framework.

## Pivot classes 

When it comes to metadata exchange between different catalogs, we need to speak the same language at some point. We call **pivot** a set of custom classes which represents the output of step 2) and the input for step 3). 

The class diagram can be seen below:

image 

*PivotItem* is the base class, and *PivotClassificationItem*, *PivotAssetItem* and *PivotGlossaryItem* inherit from it.

Based on the information passed in the pivot classes, in this step one [can create or update an entity](/rest/api/purview/catalogdataplane/entity/create-or-update-entities?tabs=HTTP), [a glossary term](/rest/api/purview/catalogdataplane/glossary/create-glossary-term?tabs=HTTP) or a [classification](/rest/api/purview/scanningdataplane/classification-rules/create-or-update?tabs=HTTP) using, for example, the REST API. 

Furthermore, based on the *PivotAssetItem* relationships can be created between assets. In addition, [glossary terms](/rest/api/purview/catalogdataplane/glossary/assign-term-to-entities?tabs=HTTP) or [classifications](/rest/api/purview/catalogdataplane/entity/add-classification?tabs=HTTP) can be assigned to the assets, based on the property *glossary_items* and *classification_items*, respectively.

Purview relies on the underlying [Apache Atlas](https://atlas.apache.org/2.0.0/index.html) format and, as a result, each metadata object supported in Microsoft Purview has a type. 

The **Type** can be seen as **Class** definition from Object Oriented Programming (OOP). All metadata objects managed by Purview (out of the box or through custom types) are modeled using type definitions. For a further understanding of type system in Purview as well as how to create custom types, you can follow this tutorial: [Type definitions and how to create custom types in Microsoft Purview]().