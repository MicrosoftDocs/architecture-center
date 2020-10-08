---
title: Azure data platform end-to-end
titleSuffix: Azure Example Scenarios
description: Use Azure services to ingest, process, store, serve, and visualize data from different sources.
author: fabragaMS
ms.date: 01/31/2020
ms.category:
  - databases
  - analytics
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
  - fcp
  - data-analytics
social_image_url: /azure/architecture/example-scenario/dataplate2e/media/azure-data-platform-end-to-end.jpg
---

<!-- cSpell:ignore fabraga -->

# Azure data platform end-to-end

This example scenario demonstrates how to use the extensive family of Azure Data Services to build a modern data platform capable of handling the most common data challenges in an organization.

The solution described in this article combines a range of Azure services that will ingest, process, store, serve, and visualize data from different sources, both structured and unstructured.

This solution architecture demonstrates how a single, unified data platform can be used to meet the most common requirements for:

- Traditional relational data pipelines
- Big data transformations
- Unstructured data ingestion and enrichment with AI-based functions
- Stream ingestion and processing following the Lambda architecture
- Serving insights for data-driven applications and rich data visualization

## Relevant use cases

This approach can also be used to:

- Establish an enterprise-wide data hub consisting of a data warehouse for structured data and a data lake for semi-structured and unstructured data. This data hub becomes the single source of truth for your data.
- Integrate relational data sources with other unstructured datasets with the use of big data processing technologies;
- Use semantic modeling and powerful visualization tools for simpler data analysis.

## Architecture

[![Architecture for a modern data platform using Azure data services](./media/azure-data-platform-end-to-end.jpg)](./media/azure-data-platform-end-to-end.jpg#lightbox)

> [!NOTE]
>
>- The services covered by this architecture are only a subset of a much larger family of Azure services. Similar outcomes can be achieved by using other services or features not covered by this design.
>- Specific business requirements for your analytics use case may also ask for the use of different services or features not considered in this design.

The data flows through the solution as follows (from bottom-up):

### Relational databases

1. Use Azure Data Factory pipelines to pull data from a wide variety of databases, both on-premises and in the cloud. Pipelines can be triggered based on a pre-defined schedule, in response to an event or be explicitly called via REST APIs.

1. Still part of the Azure Data Factory pipeline, use Azure Data Lake Store Gen 2 to stage the data copied from the relational databases. You can save the data in delimited text format or compressed as Parquet files.

1. Use Azure Synapse PolyBase capabilities for fast ingestion into your data warehouse tables.

1. Load relevant data from the Azure Synapse data warehouse into Power BI datasets for data visualization. Power BI models implement a semantic model to simplify the analysis of business data and relationships.

1. Business analysts use Power BI reports and dashboards to analyze data and derive business insights.

### Semi-structured data sources

1. Use Azure Data Factory pipelines to pull data from a wide variety of semi-structured data sources, both on-premises and in the cloud. For example, you can ingest data from file-based locations containing CSV or JSON files. You can connect to No-SQL databases such as Cosmos DB or Mongo DB. Or you call REST APIs provided by SaaS applications that will function as your data source for the pipeline.

1. Still part of the Azure Data Factory pipeline, use Azure Data Lake Store Gen 2 to save the original data copied from the semi-structured data source.

1. Azure Data Factory Mapping Data Flows or Azure Databricks notebooks can now be used to process the semi-structured data and apply the necessary transformations before data can be used for reporting. You can save the resulting dataset as Parquet files in the data lake.

1. Use Azure Synapse PolyBase capabilities for fast ingestion into your data warehouse tables.

1. Load relevant data from the Azure Synapse data warehouse into Power BI datasets for data visualization. Power BI models implement a semantic model to simplify the analysis of business data and relationships.

1. Business analysts use Power BI reports and dashboards to analyze data and derive business insights.

### Non-structured data sources

1. Use Azure Data Factory pipelines to pull data from a wide variety of unstructured data sources, both on-premises and in the cloud. For example, you can ingest video, image or free text log data from file-based locations. You can also call REST APIs provided by SaaS applications that will function as your data source for the pipeline.

1. Still part of the Azure Data Factory pipeline, use Azure Data Lake Store Gen 2 to save the original data copied from the unstructured data source.

1. You can invoke Azure Databricks notebooks from your pipeline to process the unstructured data. The notebook can make use of Cognitive Services APIs or invoke custom Azure Machine Learning Service models to generate insights from the unstructured data. You can save the resulting dataset as Parquet files in the data lake.

1. Use Azure Synapse PolyBase capabilities for fast ingestion into your data warehouse tables.

1. Load relevant data from the Azure Synapse data warehouse into Power BI datasets for data visualization. Power BI models implement a semantic model to simplify the analysis of business data and relationships.

1. Business analysts use Power BI reports and dashboards to analyze data and derive business insights.

### Streaming

1. Use Azure Event Hubs to ingest data streams generated by a client application. The Event Hub will then ingest and store streaming data preserving the sequence of events received. Consumers can then connect to Event Hub and retrieve the messages for processing.

1. Configure the Event Hub Capture to save a copy of the events in your data lake. This feature implements the "Cold Path" of the Lambda architecture pattern and allows you to perform historical and trend analysis on the stream data saved in your data lake using tools such as Azure Databricks notebooks.

1. Use a Stream Analytics job to implement the "Hot Path" of the Lambda architecture pattern and derive insights from the stream data in transit. Define at least one input for the data stream coming from your Event Hub, one query to process the input data stream and one Power BI output to where the query results will be sent to.

1. Business analysts then use Power BI real-time datasets and dashboard capabilities for to visualize the fast changing insights generated by your Stream Analytics query.

## Architecture components

The following Azure services have been used in the architecture:

- Azure Data Factory
- Azure Data Lake Gen2
- Azure Synapse Analytics
- Azure Databricks
- Azure Cosmos DB
- Azure Cognitive Services
- Azure Event Hubs
- Azure Stream Analytics
- Microsoft Power BI

If you need further training resources or access to technical documentation, the table below links to Microsoft Learn and to each service's Technical Documentation.

Azure Service | Microsoft Learn | Technical Documentation|
--------------|-----------------|------------------------|
Azure Data Factory | [Data ingestion with Azure Data Factory][adf-learn]| [Azure Data Factory Technical Documentation][adf-techdoc]
Azure Synapse Analytics | [Implement a Data Warehouse with Azure Synapse Analytics][synapse-learn] | [Azure Synapse Analytics Technical Documentation][synapse-techdoc]
Azure Data Lake Storage Gen2 | [Large Scale Data Processing with Azure Data Lake Storage Gen2][adls-learn] | [Azure Data Lake Storage Gen2 Technical Documentation][adls-techdoc]
Azure Cognitive Services | [Cognitive Services Learning Paths and Modules][cognitive-learn] | [Azure Cognitive Services Technical Documentation][cognitive-techdoc]
Azure Cosmos DB | [Work with NoSQL data in Azure Cosmos DB][cosmos-learn] | [Azure Cosmos DB Technical Documentation][cosmos-techdoc]
Azure Databricks | [Perform data engineering with Azure Databricks][databricks-learn] | [Azure Databricks Technical Documentation][databricks-techdoc]
Azure Event Hubs | [Enable reliable messaging for Big Data applications using Azure Event Hubs][eventhubs-learn] | [Azure Event Hubs Technical Documentation][eventhubs-techdoc]
Azure Stream Analytics | [Implement a Data Streaming Solution with Azure Streaming Analytics][asa-learn] | [Azure Stream Analytics Technical Documentation][asa-techdoc]
Power BI | [Create and use analytics reports with Power BI][pbi-learn] | [Power BI Technical Documentation][pbi-techdoc]

### Alternatives

- For situations where device management, authentication, and provisioning are required, [Azure IOT Hub](/azure/iot-hub/) may be a preferred solution over Event Hubs.  Event Hubs should still be considered for other streaming data sources.

- In the architecture above, Azure Data Factory is the service responsible for data pipeline orchestration. Azure Databricks can also be used to perform the same role through the execution of nested notebooks.

- In the architecture above, Azure Stream Analytics is the service responsible for processing streaming data. Azure Databricks can also be used to perform the same role through the execution of notebooks.

- In the architecture above, Azure Databricks was used to invoke Cognitive Services. You can also make use of Azure Functions to invoke Azure Cognitive Services from an Azure Data Factory Pipeline.

- For comparisons of other alternatives, see:

  - [Choosing a data pipeline orchestration technology in Azure](../../data-guide/technology-choices/pipeline-orchestration-data-movement.md)
  - [Choosing a batch processing technology in Azure](../../data-guide/technology-choices/batch-processing.md)
  - [Choosing an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
  - [Choosing a data analytics technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)

## Considerations

The technologies in this architecture were chosen because each of them provide the necessary functionality to handle the vast majority of data challenges in an organization. These services meet the requirements for scalability and availability, while helping them control costs.

- The [massively parallel processing architecture](/azure/sql-data-warehouse/massively-parallel-processing-mpp-architecture) of Azure Synapse provides scalability and high performance.
- Azure Synapse has [guaranteed SLAs](https://azure.microsoft.com/support/legal/sla/sql-data-warehouse) and [recommended practices for achieving high availability](/azure/sql-data-warehouse/sql-data-warehouse-best-practices).
- When analysis activity is low, the company can [scale Azure Synapse on demand](/azure/sql-data-warehouse/sql-data-warehouse-manage-compute-overview), reducing or even pausing compute to lower costs.
analysis-services-bcdr).
- The [Azure Synapse security model](/azure/sql-data-warehouse/sql-data-warehouse-overview-manage-security) provides connection security, [authentication and authorization](/azure/sql-data-warehouse/sql-data-warehouse-authentication) via Azure AD or SQL Server authentication, and encryption.

## Pricing

The ideal individual pricing tier and the total overall cost of each service included in the architecture is dependent on the amount of data to be processed and stored and the acceptable performance level expected. Use the guide below to learn more about how each service is priced:

- [Azure Synapse](https://azure.microsoft.com/pricing/details/sql-data-warehouse/gen2) allows you to scale your compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs will increase as you ingest more data.
- [Data Factory](https://azure.microsoft.com/pricing/details/data-factory) costs are based on the number of read/write operations, monitoring operations, and orchestration activities performed in a workload. Your Data Factory costs will increase with each additional data stream and the amount of data processed by each one.
- [Power BI](https://powerbi.microsoft.com/pricing) has different product options for different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality inside your applications. A Power BI Embedded instance is included in the pricing sample above.

## Next steps

- Find comprehensive architectural guidance on data pipelines, data warehousing, online analytical processing (OLAP), and big data in the [Azure Data Architecture Guide](../../data-guide/index.md).

<!-- links -->

[adf-learn]: /learn/modules/data-ingestion-with-azure-data-factory
[adf-techdoc]: /azure/data-factory
[synapse-learn]: /learn/paths/implement-sql-data-warehouse
[synapse-techdoc]: /azure/sql-data-warehouse
[adls-learn]: /learn/paths/data-processing-with-azure-adls
[adls-techdoc]: /azure/storage/blobs/data-lake-storage-introduction
[cognitive-learn]: /learn/browse/?term=cognitive
[cognitive-techdoc]: /azure/cognitive-services
[cosmos-learn]: /learn/paths/work-with-nosql-data-in-azure-cosmos-db
[cosmos-techdoc]: /azure/cosmos-db
[databricks-learn]: /learn/paths/data-engineering-with-databricks
[databricks-techdoc]: /azure/azure-databricks
[eventhubs-learn]: /learn/modules/enable-reliable-messaging-for-big-data-apps-using-event-hubs
[eventhubs-techdoc]: /azure/event-hubs
[asa-learn]: /learn/paths/implement-data-streaming-with-asa
[asa-techdoc]: /azure/stream-analytics
[pbi-learn]: /learn/paths/create-use-analytics-reports-power-bi
[pbi-techdoc]: /power-bi
