[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how you can get insights from live streaming data. Capture data continuously from any IoT device, or logs from website clickstreams, and process it in near-real time.

## Architecture

:::image type="content" source="../media/real-time-analytics.png" alt-text="Diagram of a real-time analytics solution on big data architecture using Azure Synapse Analytics with Azure Data Lake Storage Gen2, Event Hubs, Azure Analysis Services, Azure Cosmos DB, and Power BI." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/real-time-analytics.vsdx) of this architecture.*

### Dataflow

1. Easily ingest live streaming data for an application, by using Azure Event Hubs.
1. Bring together all your structured data using Synapse Pipelines to Azure Blob Storage.
1. Take advantage of Apache Spark pools to clean, transform, and analyze the streaming data, and combine it with structured data from operational databases or data warehouses.
1. Use scalable machine learning/deep learning techniques, to derive deeper insights from this data, using Python, Scala, or .NET, with notebook experiences in Apache Spark pools.
1. Apply Apache Spark pool and Synapse Pipelines in Azure Synapse Analytics to access and move data at scale.
1. Build analytics dashboards and embedded reports in dedicated SQL pool to share insights within your organization and use Azure Analysis Services to serve this data to thousands of users.
1. Take the insights from Apache Spark pools to Azure Cosmos DB to make them accessible through real time apps.

### Components

* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.
* [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities) allows you to create, schedule, and orchestrate your ETL/ELT workflows.
* [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage): Massively scalable, secure data lake functionality built on Azure Blob Storage
* [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) is a fast, easy, and collaborative Apache Spark-based analytics platform.
* Azure [Azure Event Hubs Documentation](/azure/event-hubs/event-hubs-about)  is a big data streaming platform and event ingestion service.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database service. Then learn how to replicate your data across any number of Azure regions and scale your throughput independent from your storage.
* [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) enables you to run near real-time analytics over operational data in Azure Cosmos DB, **without any performance or cost impact on your transactional workload**, by using the two analytics engines available from your Azure Synapse workspace: [SQL Serverless](/azure/synapse-analytics/sql/on-demand-workspace-overview) and [Spark Pools](/azure/synapse-analytics/spark/apache-spark-overview).
* [Azure Analysis Services](https://azure.microsoft.com/services/analysis-services) is an enterprise grade analytics as a service that lets you govern, deploy, test, and deliver your BI solution with confidence.
* [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive unplanned analysis. Produce beautiful reports, then publish them for your organization to consume on the web and across mobile devices.

### Alternatives

- [Synapse Link](/azure/cosmos-db/synapse-link) is the Microsoft preferred solution for analytics on top of Azure Cosmos DB data.
- [Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) can be used instead of [Azure Event Hubs](/azure/event-hubs/event-hubs-about). IoT Hub is a managed service hosted in the cloud that acts as a central message hub for communication between an IoT application and its attached devices. You can connect millions of devices and their backend solutions reliably and securely. Almost any device can be connected to an IoT hub.

## Scenario details

This scenario illustrates how you can get insights from live streaming data. You can capture data continuously from any IoT device, or logs from website clickstreams, and process it in near-real time.

### Potential use cases

This solution is ideal for the media and entertainment industry. The scenario is for building analytics from live streaming data. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

You can use the [Azure pricing calculator](https://azure.com/e/f8f5bc2de0b64aa0ae2dd154e7b6b462) to get a customized pricing estimate.

## Next steps

* [Azure Synapse Analytics Documentation](/azure/sql-data-warehouse)
* [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities)
* [Azure Data Lake Storage documentation](/azure/storage/blobs/data-lake-storage-introduction)
* [Azure Data Explorer](/azure/data-explorer/data-explorer-overview)
* [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview)
* [Azure Event Hubs Documentation](/azure/event-hubs/event-hubs-about)
* [Azure Cosmos DB Documentation](/azure/cosmos-db)
* [Analysis Services Documentation](/azure/analysis-services)
* [Power BI Documentation](/power-bi)

## Related resources

* [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)
* [Geospatial analysis with Azure Synapse Analytics](/azure/architecture/industries/aerospace/geospatial-processing-analytics)
* [Big data analytics with enterprise-grade security using Azure Synapse](/azure/architecture/solution-ideas/articles/big-data-analytics-enterprise-grade-security)
* [High throughput stream ingestion to Azure Synapse](/azure/architecture/example-scenario/data/stream-ingestion-synapse)
* [Query a data lake or lakehouse by using Azure Synapse serverless](/azure/architecture/example-scenario/data/synapse-exploratory-data-analytics)
