## Architecture

Somewhere mention that the solution proposes two options to trigger the Synapse pipeline.


### Dataflow

1. Changes occur in the operational and transactional data that's stored in MongoDB Atlas. The Mongo Atlas change stream APIs notify subscribed applications about the changes in real time.

1. A custom Azure App Service web app subscribes to the MongoDB change stream. There are two versions of the web app, *event grid* and *storage*, one for each version of the solution. Both app versions listen for changes that are caused by an insert, update, or delete operation in Atlas. When the apps detect a change, they write the changed document as a blob to Azure Data Lake Storage, which is integrated with Synapse. The event grid version of the app also creates a new event in Event Grid when it detects a change in Atlas.

1. Both versions of the solution trigger the Synapse pipeline:
   1. In the event grid version, a custom event-based trigger is configured in Azure Synapse Analytics. That trigger subscribes to the Event Grid topic that the web app publishes to. The new event on that topic activates the Synapse Analytics trigger, which causes the Synapse Analytics data pipeline to run.
   1. In the storage version, a storage-based trigger is configured in Azure Synapse Analytics. When the new blob is detected on the integrated Data Lake Storage folder, that trigger is activated, which causes the Synapse Analytics data pipeline to run.

1. In a copy activity, the Synapse data Pipeline copies the full changed document from the Data Lake Storage blob to the dedicated SQL pool. This operation is configured to do an *upsert* on a selected column. If the column exists in the dedicated SQL pool, the upsert updates the column. If the column doesn't exist, the upsert inserts the column.

1. The dedicated SQL pool is the enterprise data warehousing feature that hosts the table that the data pipeline updates. The copy data activity of the pipeline keeps that table in sync with its corresponding Atlas collection.

1. Power BI reports and visualizations display current and near real-time analytics. They also feed downstream applications with the current data. MongoDB Atlas serves as a sink to feed real-time data to custom apps by using a Synapse data pipeline sink connector.

### Components

- [MongoDB Atlas](https://www.mongodb.com/atlas/database) is a database-as-a-service offering from MongoDB. This multi-cloud application data platform combines transactional processing, relevance-based search, real-time analytics, and mobile-to-cloud data synchronization in an elegant and integrated data architecture. MongoDB also offers an on-premises solution, MongoDB Enterprise Advanced.

- [Change streams](https://www.mongodb.com/docs/manual/changeStreams/) in MongoDB Atlas gives applications access to real-time data changes so that the apps can immediately react to those changes. The change streams provide a way for applications to receive notifcations about changes to a particular collection, database, or entire deployment cluster.

- [App Service](https://azure.microsoft.com/services/app-service) and its Web Apps, Mobile Apps, and API Apps features provide a framework for building, deploying, and scaling web apps, mobile apps, and REST APIs. This solution uses web apps that are programmed in ASP.NET. The code is available on GitHub:

  - [Event grid version](https://github.com/Azure/SynapseRTSEventGrid)
  - [Storage version](https://github.com/Azure/SynapseRTSStorage)

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is the core service that this solution uses for data ingestion, processing, and analytics.

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides capabilities for storing and processing data. As a data lake that's built on top of [Blob Storage](https://azure.microsoft.com/services/storage/blobs), Data Lake Storage provides a scalable and secure solution for managing large volumes of data from multiple, heterogeneous sources.

- [Azure Synapse Analytics pipelines](/azure/synapse-analytics/get-started-pipelines) are logical groupings of activities that you use to work with data. This solution uses a pipeline to copy data from Data Lake Storage into a dedicated SQL pool.

- [Dedicated SQL pool](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) provides data warehousing capabilities for data after it has been processed and normalized. This feature of Azure Synapse Analytics was formerly known as SQL Data Warehouse. It makes the data available for use by your end users and applications.

- [Azure Synapse Analytics triggers](/azure/data-factory/concepts-pipeline-execution-triggers) provide an automated way to run pipelines. You can schedule these triggers. You can also set up event-based triggers, such as [storage event triggers](/azure/data-factory/how-to-create-event-trigger) and [custom event triggers](/azure/data-factory/how-to-create-custom-event-trigger). The solution uses both types of event-based triggers.

- [Azure Event Grid](https://azure.microsoft.com/services/event-grid/) is a highly scalable, serverless event broker. You can use Event Grid to deliver events to subscriber destinations.

- [Power BI](https://powerbi.microsoft.com/en-us/) is a collection of software services and apps that display analytics information. In this solution, Power BI provides a way to use the processed data to perform advanced analysis and to derive insights.

## Scenario details

MongoDB Atlas serves as the operational data layer of many enterprise applications. This cloud database stores data from internal applications, customer-facing services, and third-party APIs from multiple channels. By using Azure Synapse Analytics pipelines, you can combine this data with relational data from other traditional applications and unstructured data from sources like logs.

### Batch integration

In Azure Synapse Analytics, you can seamlessly integrate MongoDB on-premises instances and MongoDB Atlas as a source or sink resource. MongoDB is the only NoSQL database that has source and sink connectors for Azure Synapse Analytics and Azure Data Factory.

You can retrieve the entire historical data at once, or you can retrieve data incrementally for a period of time by using a filter in batch mode. Then you can use SQL pools and Spark pools in Azure Synapse Analytics to transform and analyze the data. If you need to store the analytics or query results in an analytics data store, you can use the sink resource in Azure Synapse Analytics.

For more information about how to set up and configure the connectors, see these resources:

- [Copy data from or to MongoDB Atlas using Azure Data Factory or Synapse Analytics](/azure/data-factory/connector-mongodb-atlas)
- [Copy data from or to MongoDB using Azure Data Factory or Synapse Analytics](/azure/data-factory/connector-mongodb)

The source connector provides a convenient way to run Azure Synapse Analytics on top of operational data that's stored in MongoDB or Atlas. After you use the source connector to retrieve data from Atlas, you can load the data into Data Lake Storage blob storage as a Parquet, Avro, JSON, text, or CSV file. You can then transform these files or join them with other files from other data sources in multi-database, multi-cloud or hybrid cloud environments.

You can use the data that you retrieve from MongoDB Enterprise Advanced or MongoDB Atlas in the following scenarios: 

- To retrieve all data as of a particular date from MongoDB in a batch. You then load the data into an Azure Data Lake dedicated SQL pool or use a serverless SQL pool or Spark pool for analysis. After you retrieve this batch, you can apply changes to the data as they occur. This capability makes real-time insights possible for just-in-time decision making and conclusions. This functionality is useful for analytics of sensitive and critical information such as financial transactions and fraud detection data. A *Storage-CopyPipeline_mdb_synapse_ded_pool_RTS* sample pipeline is available as part of this solution. You can export it from the gallery for this one-time load purpose.

- To produce insights at a particular frequency such as a daily or hourly report. For this scenario, you schedule a pipeline to retrieve data on a regular basis before you run the analytics pipelines. You can use a MongoDB query to apply filter criteria and only retrieve a certain subset of data. This functionality is useful in retail scenarios such as updating inventory levels with daily sales data. In such cases, analytics reports and dashboards aren't of critical importance, and real-time analysis isn't worth the effort.


## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The solution is based on Azure products. For detailed information about security requirements and controls, see the security section of each product's documentation.

Maybe add links to each product's security docs or Azure security baseline:

- [Azure security baseline for Azure Synapse dedicated SQL pool (formerly SQL DW)](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/synapse-analytics-security-baseline?toc=%2Fazure%2Fsynapse-analytics%2Ftoc.json)

- https://docs.microsoft.com/en-us/azure/data-factory/data-movement-security-considerations

But it's hard to find a single doc about security for each product:
Azure Synapse Analytics
Azure Data Factory
App Service Web App
Event Grid
Azure Data Lake Storage
Power BI


### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- To estimate the cost of Azure products and configurations, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).
- Azure helps you avoid unnecessary costs by identifying the correct number of resources for your needs, analysing spending over time, and scaling to meet business needs without overspending. For example, you can pause the dedicated SQL pools when you don't expect any load. You can resume them later.
- You can replace Azure App Service with Azure Functions. By orchestrating the functions within Azure Synapse Pipeline, you can reduce costs.
- To reduce the Spark cluster cost, choose the right data flow compute type. The options are general and memory optimized. Also choose appropriate core count and time-to-live (TTL) values.
- To find out more about the managing costs of key solution components, see these resources:
  - [Plan and manage costs for Azure Synapse Analytics](/azure/synapse-analytics/plan-manage-costs)
  - [Plan to manage costs for Azure Data Factory](/azure/data-factory/plan-manage-costs)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

When there's a high volume of changes, running thousands of pipelines in Synapse for every change in the collection can result in a backlog of queued pipelines. To improve performance in this scenario, consider the following approaches:

- Use the storage-based App Service code, which writes the delta change JSON documents to Data Lake Storage. Don't link the storage-based trigger with the pipeline. Instead, use a scheduled trigger at a short interval, such as every two or five minutes. When the scheduled trigger runs, it takes all the files in the specified Data Lake Storage directory and updates the dedicated SQL pool for each of them.
- Modify the Event grid App service code. Program it to add a micro-batch of around 100 delta changes to the blob storage before it adds the new topic with the metadata that includes the filename to the event. With this modification, you trigger only one pipeline for one blob with the 100 delta changes. Based on your scenario, you can adjust the micro-batch size. Use small micro-batches at a high frequency to provide updates that are close to real time. Or use larger micro-batches at a lower frequency for delayed updates and reduced overhead.

For more information on improving the performance and scalability of Synapse pipeline copy activity, see [Copy activity performance and scalability guide](/azure/data-factory/copy-activity-performance).

## Deploy this scenario

For information about implementing this solution, see [Real-Time Sync Solution for MongoDB Atlas Integration with Synapse](https://github.com/Azure/RealTimeSync_Synapse-MongoDB).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Diana Annie Jenosh](https://www.linkedin.com/in/diana-jenosh-0b014814) | Senior Solutions Architect
- [Babu Srinivasan](https://www.linkedin.com/in/babusrinivasan) | Senior Solutions Architect
- [Utsay Talwar](https://www.linkedin.com/in/utsav-talwar) | Associate Solutions Architect

Other contributors:

- [Krishnakumar Rukmangathan](https://www.linkedin.com/in/krishnakumar-rukmangathan) | Senior Program Manager
- [Sunil Sabat](https://www.linkedin.com/in/sunilsabat) | Principal Program Manager
- [Wee Hyong T.](https://www.linkedin.com/in/weehyongtok) | Principal Director
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

 
## Related resources

