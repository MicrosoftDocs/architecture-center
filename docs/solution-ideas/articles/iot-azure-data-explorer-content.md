[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how Azure Data Explorer provides near real-time analytics for fast flowing, high volume streaming data from internet of things (IoT) devices and sensors. This analytics workflow is part of an overall IoT solution that integrates operational and analytical workloads with Azure Cosmos DB and Azure Data Explorer.

Jupyter is a trademark of its respective company. No endorsement is implied by the use of this mark.
Apache® and Apache Kafka® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Architecture

:::image type="content" source="../media/iot-azure-data-explorer-new.svg" alt-text="Diagram showing IoT telemetry analytics with Azure Data Explorer." lightbox="../media/iot-azure-data-explorer-new.svg" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/iot-azure-data-explorer.vsdx) of this architecture.*

### Dataflow

1. Azure Event Hubs, Azure IoT Hub, or Kafka ingest a wide variety of fast-flowing streaming data such as logs, business events, and user activities.

1. Azure Functions or Azure Stream Analytics process the data in near real time.

1. Azure Cosmos DB stores streamed messages in JSON format to serve a real-time operational application.

1. Azure Data Explorer ingests data for analytics, using its connectors for [Azure Event Hubs](/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](/azure/data-explorer/ingest-data-iot-hub), or [Kafka](/azure/data-explorer/ingest-data-kafka) for low latency and high throughput.

   Alternatively, you can ingest blobs from your [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) or [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) account into Azure Data Explorer by using an [Event Grid data connection](/azure/data-explorer/ingest-data-event-grid).
   
   You can also continuously export data to Azure Storage in compressed, partitioned [Apache Parquet](https://parquet.apache.org) format, and seamlessly query the data with Azure Data Explorer. For details, see [Continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).

1. To serve both the operational and analytical use cases, data can either route to Azure Data Explorer and Azure Cosmos DB in parallel, or from Azure Cosmos DB to Azure Data Explorer.

   - Azure Cosmos DB transactions can trigger Azure Functions via change feed. Functions will stream data to Event Hubs for ingestion into Azure Data Explorer.

     or

   - Azure Functions can invoke Azure Digital Twins through its API, which then streams data to Event Hubs for ingestion into Azure Data Explorer.

1. The following interfaces get insights from data stored in Azure Data Explorer:

   - Custom analytics apps that blend data from Azure Digital Twins and Azure Data Explorer APIs
   - Near real-time analytics dashboards that use Azure Data Explorer dashboards, [Power BI](/power-bi/transform-model/service-dataflows-best-practices), or [Grafana](/azure/data-explorer/grafana)
   - Alerts and notifications from the [Azure Data Explorer connector for Azure Logic Apps](/azure/data-explorer/kusto/tools/logicapps)
   - The Azure Data Explorer Web UI, [Kusto.Explorer](/azure/data-explorer/kusto/tools/kusto-explorer), and [Jupyter notebooks](/azure/data-explorer/kqlmagic)

1. Azure Data Explorer integrates with [Azure Databricks](https://azure.microsoft.com/services/databricks) and [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) to provide machine learning (ML) services. You can also build ML models using other tools and services, and export them to Azure Data Explorer for scoring data.

### Components

This solution idea uses the following Azure components:

#### Azure Data Explorer

[Azure Data Explorer](https://azure.microsoft.com/services/data-explorer) is a fast, fully managed, and highly scalable big data analytics service. Azure Data Explorer can analyze large volumes of streaming data from applications, websites, and IoT devices in near real-time to serve analytics applications and dashboards.

Azure Data Explorer provides native advanced analytics for:

- [Time series analysis](/azure/data-explorer/time-series-analysis).
- Pattern recognition.
- [Anomaly detection and forecasting](/azure/data-explorer/anomaly-detection).
- [Machine learning (ML)](/azure/data-explorer/machine-learning-clustering).

The [Azure Data Explorer Web UI](/azure/data-explorer/web-query-data) connects to Azure Data Explorer clusters to help write, run, and share Kusto Query Language commands and queries. [Azure Data Explorer Dashboards](/azure/data-explorer/azure-data-explorer-dashboards) are a feature in the Data Explorer Web UI that natively exports Kusto queries to optimized dashboards.

#### Other Azure components

- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed, fast NoSQL database service for modern app development with open APIs for any scale.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) stores digital models of physical environments, to help create next-generation IoT solutions that model the real world.
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a fully managed, real-time data ingestion service.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) enables bi-directional communication between IoT devices and the Azure cloud.
- [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) runs near real-time analytics over operational data in Azure Cosmos DB, without any performance or cost impact on transactional workloads. Synapse Link uses the [SQL Serverless](/azure/synapse-analytics/sql/on-demand-workspace-overview) and [Spark Pools](/azure/synapse-analytics/spark/apache-spark-overview) analytics engines from the Azure Synapse workspace.
- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is an easy, cost-effective, enterprise-grade service for open-source analytics with Apache Kafka.

## Scenario details

This solution uses Azure Data Explorer to get near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices.

### Potential use cases

- Fleet management, for predictive maintenance of vehicle parts. This solution is ideal for the automotive and transportation industry.
- Facilities management, for energy and environment optimization.
- [Combining real-time road conditions with weather data for safer autonomous driving](https://customers.microsoft.com/story/816933-bosch-automotive-azure-germany).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Ornat Spodek](https://www.linkedin.com/in/ornat-s-89123544) | Senior Content Manager

## Next steps

- [What is Azure Data Explorer?](/azure/data-explorer/data-explorer-overview)
- [Visualize data with Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards)

## Related resources

- [Azure Cosmos DB in IoT workloads](iot-using-cosmos-db.yml)
- [Big data analytics with Azure Data Explorer](big-data-azure-data-explorer.yml)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
- [Real-time analytics on big data architecture](real-time-analytics.yml)
