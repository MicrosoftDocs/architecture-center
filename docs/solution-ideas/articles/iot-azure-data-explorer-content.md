[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea demonstrates near real-time analytics over fast flowing, high volume streaming data from IoT devices, sensors, connected buildings and vehicles, and so on. It focuses on integration of Azure Data Explorer with other IoT services to cater to both operational and analytical workloads using Cosmos DB and Azure Data Explorer.

This solution is already being used by Microsoft customers for IoT device telemetry analytics. For example, [Bosch uses this to combine real-time road conditions with weather data for safer autonomous driving](https://customers.microsoft.com/story/816933-bosch-automotive-azure-germany).

## Architecture

:::image type="content" source="../media/iot-azure-data-explorer.png" alt-text="IoT telemetry analytics with Azure Data Explorer" lightbox="../media/iot-azure-data-explorer.png":::

### Data flow

1. Ingest a wide variety of fast-flowing streaming data such as logs, business events, and user activities from various sources such as Azure Event Hub, Azure IoT Hub, or Kafka.
1. Process data in real-time using Azure Functions or Azure Stream Analytics.
1. Store streamed JSON messages in Cosmos DB to serve a real-time operational application.
1. Ingest data into Azure Data Explorer with low-latency and high throughput using its connectors for [Azure Event Hub](/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](/azure/data-explorer/ingest-data-iot-hub), [Kafka](/azure/data-explorer/ingest-data-kafka), and so on. Alternatively, ingest data through Azure Storage (Blob or ADLS Gen2), which uses [Azure Event Grid](/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in the [continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).
1. Azure Data Explorer is a big data analytics store for serving near real-time analytics applications and dashboards. As this pattern serves both operational and analytical use cases, data can either be routed to Azure Data Explorer and Cosmos DB in parallel, or from Cosmos DB to Azure Data Explorer.
   * Integrate Cosmos DB with Azure Data Explorer using change feed. Every transaction in Cosmos DB can trigger an Azure Function via this change feed. Data can then be streamed to Event Hub and ingested into Azure Data Explorer.
   * From Azure Function, invoke Azure Digital Twin (ADT) APIs. ADT is used for storing digital models of physical environments. This service streams data to Event Hub, which then gets ingested to Azure Data Explorer.
1. Gain insights from data stored in Azure Data Explorer by any of the following methods:
   * Build a custom analytics app that invokes APIs exposed by ADT and Azure Data Explorer to blend the data from both sources.
   * Build near real-time analytics dashboards using [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](/power-bi/transform-model/service-dataflows-best-practices), or [Grafana](/azure/data-explorer/grafana).
   * Create and schedule alerts and notifications using the [Azure Data Explorer connector for Azure Logic Apps](/azure/data-explorer/kusto/tools/logicapps).
   * Analyze data using [Azure Data Explorer Web UI](/azure/data-explorer/web-query-data), [Kusto.Explorer](/azure/data-explorer/kusto/tools/kusto-explorer), or [Jupyter notebooks](/azure/data-explorer/kqlmagic).
1. Azure Data Explorer provides native advanced analytics capabilities for [time series analysis](/azure/data-explorer/time-series-analysis), pattern recognition, [anomaly detection and forecasting](/azure/data-explorer/anomaly-detection), and [machine learning](/azure/data-explorer/machine-learning-clustering). Azure Data Explorer is also well integrated with ML services such as Databricks and Azure Machine Learning. This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.

### Components

- [Azure Event Hub](https://azure.microsoft.com/services/event-hubs): Fully managed, real-time data ingestion service that's simple, trusted, and scalable.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub): Managed service to enable bi-directional communication between IoT devices and Azure.
- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction): Easy, cost-effective, enterprise-grade service for open source analytics with Apache Kafka.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db): Fully managed fast NoSQL database service for modern app development with open APIs for any scale.
- [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) enables you to run near real-time analytics over operational data in Azure Cosmos DB, **without any performance or cost impact on your transactional workload**, by using the two analytics engines available from your Azure Synapse workspace: [SQL Serverless](/azure/synapse-analytics/sql/on-demand-workspace-overview) and [Spark Pools](/azure/synapse-analytics/spark/apache-spark-overview).
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Explorer Dashboards](/azure/data-explorer/azure-data-explorer-dashboards): Natively export Kusto queries that were explored in the Web UI to optimized dashboards.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins): Create next-generation IoT solutions that model the real world.

### Alternatives

- [Synapse Link](/azure/cosmos-db/synapse-link) is the Microsoft preferred solution for analytics on top of Cosmos DB data.

## Next steps

Product documentation:

- [Azure Event Hubs](/azure/event-hubs/event-hubs-about)
- [IoT Concepts and Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub)
- [Visualize data with Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards)
- [What is Azure Data Explorer?](/azure/data-explorer/data-explorer-overview)
- [What is Azure Digital Twins?](/azure/digital-twins/overview)
- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)

Microsoft Learn modules:

- [Explore Azure Digital Twins implementation](/learn/modules/explore-azure-digital-twins-implementation)
- [Explore Azure Event Hubs](/learn/modules/azure-event-hubs)
- [Insert and query data in your Azure Cosmos DB database](/learn/modules/access-data-with-cosmos-db-and-sql-api)
- [Introduction to Azure IoT Hub](/learn/modules/introduction-to-iot-hub)
- [Transform data by using Azure Stream Analytics](/learn/modules/transform-data-with-azure-stream-analytics)
- [Upload, download, and manage data with Azure Storage Explorer](/learn/modules/upload-download-and-manage-data-with-azure-storage-explorer)

## Related resources

- [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
- [Big data analytics with Azure Data Explorer](big-data-azure-data-explorer.yml)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
- [Real-time analytics on big data architecture](real-time-analytics.yml)
