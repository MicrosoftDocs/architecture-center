This article presents a solution for deriving insights from MongoDB Atlas operational data. The solution connects MongoDB Atlas to Azure Synapse Analytics. The connection makes it possible to transfer data in batches and in real time. The real-time approach keeps Azure Synapse Analytics dedicated SQL pools in sync with changes in the MongoDB Atlas data source.

*Apache®, [Apache Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*The MongoDB Atlas logo is a trademark of MongoDB. No endorsement is implied by the use of this mark.*

## Architecture

The following diagram shows how to sync MongoDB Atlas data to Azure Synapse Analytics in real time.

:::image type="content" source="./media/azure-synapse-analytics-integrate-mongodb-atlas-architecture.svg" alt-text="Architecture diagram that shows data flow from MongoDB Atlas to analysis apps. Interim stages include a change stream API and Azure Synapse Analytics." lightbox="./media/azure-synapse-analytics-integrate-mongodb-atlas-architecture.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-synapse-analytics-integrate-mongodb-atlas.pptx) of all diagrams in this article.*

### Dataflow

The solution presents two options for triggering the pipelines that capture the real-time changes in the MongoDB Atlas operational data store (ODS) and sync the data. The following steps outline both options.

1. Changes occur in the operational and transactional data that's stored in MongoDB Atlas. The Mongo Atlas change stream APIs notify subscribed applications about the changes in real time.

1. A custom Azure App Service web app subscribes to the MongoDB change stream. There are two versions of the web app, *Event Grid* and *storage*, one for each version of the solution. Both app versions listen for changes that are caused by an insert, update, or delete operation in Atlas. When the apps detect a change, they write the changed document as a blob to Azure Data Lake Storage, which is integrated with Azure Synapse Analytics. The Event Grid version of the app also creates a new event in Azure Event Grid when it detects a change in Atlas.

1. Both versions of the solution trigger the Azure Synapse Analytics pipeline:
   1. In the Event Grid version, a custom event-based trigger is configured in Azure Synapse Analytics. That trigger subscribes to the Event Grid topic that the web app publishes to. The new event on that topic activates the Azure Synapse Analytics trigger, which causes the Azure Synapse Analytics data pipeline to run.
   1. In the storage version, a storage-based trigger is configured in Azure Synapse Analytics. When the new blob is detected in the integrated Data Lake Storage folder, that trigger is activated, which causes the Azure Synapse Analytics data pipeline to run.

1. In a copy activity, the Azure Synapse Analytics pipeline copies the full changed document from the Data Lake Storage blob to the dedicated SQL pool. This operation is configured to do an *upsert* on a selected column. If the column exists in the dedicated SQL pool, the upsert updates the column. If the column doesn't exist, the upsert inserts the column.

1. The dedicated SQL pool is the enterprise data warehousing feature that hosts the table that the data pipeline updates. The copy data activity of the pipeline keeps that table in sync with its corresponding Atlas collection.

1. Power BI reports and visualizations display current and near real-time analytics. The data also feeds into downstream applications. MongoDB Atlas functions as a sink by using an Azure Synapse Analytics data pipeline sink connector. Atlas then provides custom apps with the real-time data.

### Components

- [MongoDB Atlas](https://www.mongodb.com/atlas/database) is a database-as-a-service offering from MongoDB. This multicloud application data platform offers transactional processing, relevance-based search, real-time analytics, and mobile-to-cloud data synchronization. MongoDB also offers an on-premises solution, MongoDB Enterprise Advanced.

- [Change streams](https://www.mongodb.com/docs/manual/changeStreams) in MongoDB Atlas give applications access to real-time data changes so that the apps can immediately react to those changes. The change streams provide a way for applications to receive notifications about changes to a particular collection, database, or entire deployment cluster.

- [App Service](https://azure.microsoft.com/services/app-service) and its Web Apps, Mobile Apps, and API Apps features provide a framework for building, deploying, and scaling web apps, mobile apps, and REST APIs. This solution uses web apps that are programmed in ASP.NET. The code is available on GitHub:

  - [Event Grid version](https://github.com/Azure/SynapseRTSEventGrid)
  - [Storage version](https://github.com/Azure/SynapseRTSStorage)

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is the core service that this solution uses for data ingestion, processing, and analytics.

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides capabilities for storing and processing data. As a data lake that's built on top of [Blob Storage](https://azure.microsoft.com/services/storage/blobs), Data Lake Storage provides a scalable solution for managing large volumes of data from multiple, heterogeneous sources.

- [Azure Synapse Analytics pipelines](/azure/synapse-analytics/get-started-pipelines) are used to perform extract, transform, and load (ETL) operations on data. Azure Data Factory provides a similar service, but you can create Azure Synapse Analytics pipelines within Synapse Studio. You can use multiple activities within the same pipeline. You can also create dependency endpoints to connect one activity with another activity in the pipeline.

- [Mapping data flows](/azure/data-factory/concepts-data-flow-overview) are visually designed data transformations in Azure Synapse Analytics. Data flows provide a way for data engineers to develop data transformation logic without writing code. You can run the resulting data flows as activities within Azure Synapse Analytics pipelines that use scaled-out Apache Spark clusters. You can put data flow activities into operation by using existing Azure Synapse Analytics scheduling, control, flow, and monitoring capabilities.

- [Dedicated SQL pool](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) provides data warehousing capabilities for data after the data is processed and normalized. This feature of Azure Synapse Analytics was formerly known as SQL Data Warehouse. Dedicated SQL pools make the refined data available to your end users and applications.

- [Azure Synapse Analytics triggers](/azure/data-factory/concepts-pipeline-execution-triggers) provide an automated way to run pipelines. You can schedule these triggers. You can also set up event-based triggers, such as [storage event triggers](/azure/data-factory/how-to-create-event-trigger) and [custom event triggers](/azure/data-factory/how-to-create-custom-event-trigger). The solution uses both types of event-based triggers.

- [Event Grid](https://azure.microsoft.com/services/event-grid) is a highly scalable, serverless event broker. You can use Event Grid to deliver events to subscriber destinations.

- [Power BI](https://powerbi.microsoft.com) is a collection of software services and apps that display analytics information. In this solution, Power BI provides a way to use the processed data to perform advanced analysis and to derive insights.

## Scenario details

MongoDB Atlas serves as the operational data layer of many enterprise applications. This cloud database stores data from internal applications, customer-facing services, and third-party APIs from multiple channels. By using Azure Synapse Analytics pipelines, you can combine MongoDB Atlas data with relational data from other traditional applications and unstructured data from sources like logs.

### Batch integration

In Azure Synapse Analytics, you can seamlessly integrate MongoDB on-premises instances and MongoDB Atlas as a source or sink resource. MongoDB is the only NoSQL database that has source and sink connectors for Azure Synapse Analytics and Data Factory.

With historical data, you can retrieve all the data at once. You can also retrieve data incrementally for specific periods by using a filter in batch mode. Then you can use SQL pools and Apache Spark pools in Azure Synapse Analytics to transform and analyze the data. If you need to store the analytics or query results in an analytics data store, you can use the sink resource in Azure Synapse Analytics.

:::image type="content" source="./media/azure-synapse-analytics-mongodb-connectors.svg" alt-text="Architecture diagram that shows the source and sink connectors that connect data from consumers to Azure Synapse Analytics and MongoDB data storage." lightbox="./media/azure-synapse-analytics-mongodb-connectors.svg" border="false":::

For more information about how to set up and configure the connectors, see these resources:

- [Copy data from or to MongoDB Atlas using Azure Data Factory or Azure Synapse Analytics](/azure/data-factory/connector-mongodb-atlas)
- [Copy data from or to MongoDB using Azure Data Factory or Azure Synapse Analytics](/azure/data-factory/connector-mongodb)

The source connector provides a convenient way to run Azure Synapse Analytics on top of operational data that's stored in MongoDB or Atlas. After you use the source connector to retrieve data from Atlas, you can load the data into Data Lake Storage blob storage as a Parquet, Avro, JSON, text, or CSV file. You can then transform these files or join them with other files from other data sources in multi-database, multicloud, or hybrid cloud environments.

You can use the data that you retrieve from MongoDB Enterprise Advanced or MongoDB Atlas in the following scenarios:

- To retrieve all data from a particular date from MongoDB in a batch. You then load the data into Data Lake Storage. From there, you use a serverless SQL pool or Spark pool for analysis, or you copy the data into a dedicated SQL pool. After you retrieve this batch, you can apply changes to the data as they occur, as described in [Dataflow](#dataflow). A [Storage-CopyPipeline_mdb_synapse_ded_pool_RTS sample pipeline](https://github.com/Azure/RealTimeSync_Synapse-MongoDB/blob/main/Storage-CopyPipeline_mdb_synapse_ded_pool_RTS.zip) is available as part of this solution. You can export the pipeline from GitHub for this one-time load purpose.

- To produce insights at a particular frequency, for instance, for a daily or hourly report. For this scenario, you schedule a pipeline to retrieve data on a regular basis before you run the analytics pipelines. You can use a MongoDB query to apply filter criteria and only retrieve a certain subset of data.

### Real-time sync

Enterprises need insights that are based on real-time data, not stale data. A delay of a few hours in insight delivery can hold up the decision-making process and result in a loss of competitive advantage. This solution fuels critical decision making by propagating changes that occur in the MongoDB transactional database to the dedicated SQL pool in real time.

This solution has three parts, which the following sections describe.

#### Capture the MongoDB Atlas changes

The MongoDB change stream captures changes that occur in the database. The change stream APIs make information about changes available to App Service web apps that subscribe to the change stream. These apps write the changes to the Data Lake Storage blob storage.

#### Trigger a pipeline to propagate the changes to Azure Synapse Analytics

The solution presents two options for triggering an Azure Synapse Analytics pipeline after the blob is written to Data Lake Storage:

- A storage-based trigger. Use this option if you need real-time analytics, because the pipeline gets triggered as soon as the blob with the change is written. But this option might not be the preferred approach when you have a high volume of data changes. Azure Synapse Analytics limits the number of pipelines that can run concurrently. When you have a large number of data changes, you might hit that limit.

- An event-based custom trigger. This type of trigger has the advantage that it's outside Azure Synapse Analytics, so it's easier to control. The Event Grid version of the web app writes the changed data document to the blob storage. At the same time, the app creates a new Event Grid event. The data in the event contains the file name of the blob. The pipeline that the event triggers receives the file name as a parameter and then uses the file to update the dedicated SQL pool.

#### Propagate the changes to a dedicated SQL pool

An Azure Synapse Analytics pipeline propagates the changes to a dedicated SQL pool. The solution provides a *CopyPipeline_mdb_synapse_ded_pool_RTS* pipeline on GitHub that copies the change in the blob from Data Lake Storage to the dedicated SQL pool. This pipeline is triggered by either the storage or Event Grid trigger.

### Potential use cases

The use cases for this solution span many industries and areas:

- Retail
  - Building intelligence into product bundling and product promotion
  - Optimizing cold storage that uses IoT streaming
  - Optimizing inventory replenishment
  - Adding value to omnichannel distribution

- Banking and finance
  - Customizing customer financial services
  - Detecting potentially fraudulent transactions

- Telecommunications
  - Optimizing next-generation networks
  - Maximizing the value of edge networks

- Automotive
  - Optimizing parameterization of connected vehicles
  - Detecting anomalies in IoT communication in connected vehicles

- Manufacturing
  - Providing predictive maintenance for machinery
  - Optimizing storage and inventory management

Here are two specific examples:

- As this article describes earlier in [Batch integration](#batch-integration), you can retrieve MongoDB data in a batch and then update the data as changes occur. This capability makes real-time insights possible for just-in-time decision making and conclusions. This functionality is useful for analytics of sensitive and critical information such as financial transactions and fraud detection data.
- As [Batch integration](#batch-integration) also describes, you can schedule a pipeline to retrieve MongoDB data on a regular basis. This functionality is useful in retail scenarios such as updating inventory levels with daily sales data. In such cases, analytics reports and dashboards aren't of critical importance, and real-time analysis isn't worth the effort.

The following sections take a closer look at two retail industry use cases.

#### Product bundling

To promote the sale of a product, you can sell the product as part of a bundle together with other related products. The objective is to use sales pattern data to develop strategies for bundling a product into packages.

There are two sources of data:

- The product catalog data from MongoDB
- Sales data from Azure SQL

Both sets of data are migrated to an Azure Synapse Analytics dedicated SQL pool by using an Azure Synapse Analytics pipeline. Triggers and change data captures are used to achieve a near real-time data sync on top of the one-time migrated data.

The following Power BI charts show the affinity between the products and sales patterns. The affinity of the pen and ink-based refill is high. The sales data shows that the pen has a high sales volume in the specified area.

:::image type="content" source="./media/product-bundling-use-case-visualization.png" alt-text="Diagram that shows pipeline stages and charts that show pen sales by product, year, region, and affinity. Pen sales are highest in 2022 in the South." lightbox="./media/product-bundling-use-case-visualization.png" border="false":::

The analysis makes two suggestions for yielding better sales:

- Bundling the pen and ink-based refill
- Promoting the bundle in certain areas

#### Product promotion

To promote the sale of a product, you can recommend the product to customers who are interested in related products. The objective is to use sales data and customer buying pattern data to develop strategies for recommending a product to customers.

By using Azure Synapse Analytics, you can develop AI and machine learning models to determine which products to recommend to customers.

The following diagrams show the use of various types of data to create a model to determine alternate product recommendations. The data includes customer buying patterns, profits, product affinities, the sales volume of the products, and product catalog parameters.

:::image type="content" source="./media/product-promotion-use-case-visualization.png" alt-text="Diagrams that show pipeline stages and a workflow for an AI model. Data fields include the customer ID, price, sales, and profit." lightbox="./media/product-promotion-use-case-visualization.png" border="false":::

If your model achieves high accuracy, it provides a list of products that you can recommend to the customer.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For detailed information about the security requirements and controls of the Azure components in the solution, see the security section of each product's documentation.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- To estimate the cost of Azure products and configurations, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).
- Azure helps you avoid unnecessary costs by identifying the correct number of resources for your needs, by analyzing spending over time, and by scaling to meet business needs without overspending. For example, you can pause the dedicated SQL pools when you don't expect any load. You can resume them later.
- You can replace App Service with Azure Functions. By orchestrating the functions within an Azure Synapse Analytics pipeline, you can reduce costs.
- To reduce the Spark cluster cost, choose the right data flow compute type. General and memory-optimized options are available. Also choose appropriate core count and time-to-live (TTL) values.
- To find out more about managing the costs of key solution components, see these resources:
  - [Plan and manage costs for Azure Synapse Analytics](/azure/synapse-analytics/plan-manage-costs)
  - [Plan to manage costs for Azure Data Factory](/azure/data-factory/plan-manage-costs)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands that are placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

When there's a high volume of changes, running thousands of pipelines in Azure Synapse Analytics for every change in the collection can result in a backlog of queued pipelines. To improve performance in this scenario, consider the following approaches:

- Use the storage-based App Service code, which writes the JSON documents with the changes to Data Lake Storage. Don't link the storage-based trigger with the pipeline. Instead, use a scheduled trigger at a short interval, such as every two or five minutes. When the scheduled trigger runs, it takes all the files in the specified Data Lake Storage directory and updates the dedicated SQL pool for each of them.
- Modify the Event Grid App Service code. Program it to add a micro-batch of around 100 changes to the blob storage before it adds the new topic to the event with the metadata that includes the filename. With this modification, you trigger only one pipeline for one blob with the 100 changes. You can adjust the micro-batch size to suit your scenario. Use small micro-batches at a high frequency to provide updates that are close to real time. Or use larger micro-batches at a lower frequency for delayed updates and reduced overhead.

For more information on improving the performance and scalability of Azure Synapse Analytics pipeline copy activity, see [Copy activity performance and scalability guide](/azure/data-factory/copy-activity-performance).

## Deploy this scenario

For information about implementing this solution, see [Real-Time Sync Solution for MongoDB Atlas Integration with Synapse](https://github.com/Azure/RealTimeSync_Synapse-MongoDB).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Diana Annie Jenosh](https://www.linkedin.com/in/diana-jenosh-0b014814) | Senior Solutions Architect
- [Babu Srinivasan](https://www.linkedin.com/in/babusrinivasan) | Senior Solutions Architect
- [Utsav Talwar](https://www.linkedin.com/in/utsav-talwar) | Associate Solutions Architect

Other contributors:

- [Krishnakumar Rukmangathan](https://www.linkedin.com/in/krishnakumar-rukmangathan) | Senior Program Manager
- [Sunil Sabat](https://www.linkedin.com/in/sunilsabat) | Principal Program Manager
- [Wee Hyong T.](https://www.linkedin.com/in/weehyongtok) | Principal Director
- [Paresh Saraf](https://www.linkedin.com/in/pareshsaraf) | Technical Director

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about the solution, contact [partners@mongodb.com](mailto:partners@mongodb.com).

For information about MongoDB, see these resources:

- [MongoDB](https://www.mongodb.com)
- [MongoDB Atlas](https://www.mongodb.com/atlas/database)
- [MongoDB horizontal use cases](https://www.mongodb.com/use-cases)
- [MongoDB industry-specific use cases](https://www.mongodb.com/industries)

For information about Azure solution components, see these resources:

- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Azure Synapse Analytics use cases](https://azure.microsoft.com/services/synapse-analytics/#use-cases)
- [Azure Synapse Analytics industry-specific use cases](https://azure.microsoft.com/services/synapse-analytics/#industry)
- [Azure Synapse Analytics connectors](/azure/data-factory/connector-mongodb)
- [App Service overview](/azure/app-service/overview)
- [What is Power BI?](https://powerbi.microsoft.com/what-is-power-bi)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Azure Event Grid?](/azure/event-grid/overview)

## Related resources

- [Enterprise business intelligence](./enterprise-bi-synapse.yml)
- [Automated enterprise BI](../../reference-architectures/data/enterprise-bi-adf.yml)
- [Enterprise data warehouse](../../solution-ideas/articles/enterprise-data-warehouse.yml)
- [Real-time analytics on big data architecture](../../solution-ideas/articles/real-time-analytics.yml)
- [Use a speech-to-text transcription pipeline to analyze recorded conversations](../ai/speech-to-text-transcription-analytics.yml)
- [Data warehousing in Microsoft Azure](../../data-guide/relational-data/data-warehousing.yml)
