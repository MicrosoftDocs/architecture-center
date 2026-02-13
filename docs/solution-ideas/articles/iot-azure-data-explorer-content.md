[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how Azure Data Explorer provides near real-time analytics for fast flowing, high volume streaming data from internet of things (IoT) devices and sensors. This analytics workflow is part of an overall IoT solution that integrates operational and analytical workloads with Azure Cosmos DB and Azure Data Explorer.

Jupyter is a trademark of its respective company. No endorsement is implied by the use of this mark. Apache® and Apache Kafka® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Architecture

:::image type="content" source="../media/iot-azure-data-explorer-new.svg" alt-text="Diagram showing an IoT telemetry analytics architecture with Azure Data Explorer processing data from Event Hubs and IoT Hub." lightbox="../media/iot-azure-data-explorer-new.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/iot-azure-data-explorer.vsdx) of this architecture.*

### Dataflow

1. Azure Event Hubs, Azure IoT Hub, or Kafka ingest a wide range of fast-flowing streaming data such as logs, business events, and user activities.

1. Azure Functions or Azure Stream Analytics process the data in near real time.

1. Azure Cosmos DB stores streamed messages in JSON format to serve a real-time operational application.

1. Azure Data Explorer ingests data for analytics, using its connectors for [Azure Event Hubs](/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](/azure/data-explorer/ingest-data-iot-hub), or [Kafka](/azure/data-explorer/ingest-data-kafka) for low latency and high throughput.

   Alternatively, you can ingest blobs from your [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) or [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) account into Azure Data Explorer by using an [Event Grid data connection](/azure/data-explorer/ingest-data-event-grid).

   You can also continuously export data to Azure Storage in compressed, partitioned [Apache Parquet](https://parquet.apache.org) format, and seamlessly query the data with Azure Data Explorer. For more information, see [Continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).

1. To serve both the operational and analytical use cases, route data either to Azure Data Explorer and Azure Cosmos DB in parallel, or from Azure Cosmos DB to Azure Data Explorer.

   - Azure Cosmos DB transactions can trigger Azure Functions via change feed. Functions stream data to Event Hubs for ingestion into Azure Data Explorer.

     -or-

   - Azure Functions can invoke Azure Digital Twins through its API, which then streams data to Event Hubs for ingestion into Azure Data Explorer.

1. The following interfaces get insights from data stored in Azure Data Explorer:

   - Custom analytics apps that blend data from Azure Digital Twins and Azure Data Explorer APIs
   - Near real-time analytics dashboards that use Azure Data Explorer dashboards, [Power BI](/power-bi/transform-model/service-dataflows-best-practices), or [Grafana](/azure/data-explorer/grafana)
   - Alerts and notifications from the [Azure Data Explorer connector for Azure Logic Apps](/azure/data-explorer/kusto/tools/logicapps)
   - The Azure Data Explorer Web UI, [Kusto.Explorer](/azure/data-explorer/kusto/tools/kusto-explorer), and [Jupyter notebooks](/azure/data-explorer/kqlmagic)

1. Azure Data Explorer integrates with [Azure Databricks](https://azure.microsoft.com/services/databricks) and [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) to provide machine learning (ML) services. You can also build ML models using other tools and services, and export them to Azure Data Explorer for scoring data.

### Components

This solution idea uses the following Azure components.

#### Azure Data Explorer

- [Anomaly detection and forecasting](/azure/data-explorer/anomaly-detection) is a built-in analytics feature in [Azure Data Explorer](/azure/data-explorer/data-explorer-overview). It detects outliers and predicts future values to support proactive monitoring and decision-making. In this architecture, it identifies unusual patterns in IoT telemetry and forecasts expected behavior over time.

- [Anomaly diagnosis for root analysis](/kusto/query/anomaly-diagnosis) is a Kusto Query Language (KQL) capability that helps identify the root causes of anomalies. It analyzes contributing dimensions and metrics to streamline troubleshooting. In this architecture, it isolates the source of anomalies detected in device data.

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a fully managed, high-performance analytics service. It processes large volumes of streaming data from applications, websites, and IoT devices in near real-time. In this architecture, it serves as the central analytics engine for ingesting, querying, and visualizing IoT data.

- [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards) are a visualization feature within the Web UI. They allow users to export Kusto queries into interactive dashboards for real-time data exploration. In this architecture, they display insights from IoT data streams and anomaly detection results.

- [Azure Data Explorer web UI](/azure/data-explorer/web-query-data) is a browser-based interface for working with Azure Data Explorer clusters. It supports writing, running, and sharing KQL commands and queries. In this architecture, it provides a workspace for analysts to query and explore IoT telemetry.

- [Time series analysis](/azure/data-explorer/time-series-analysis) is a built-in capability in Azure Data Explorer. It enables users to explore temporal patterns, trends, and seasonality in time-based data. In this architecture, it reveals long-term trends and cyclical behavior in IoT sensor readings.

#### Other Azure components

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed, fast NoSQL database service for modern app development with open APIs for any scale. In this architecture, it stores operational data from IoT devices for scalable, low-latency access.

- [Azure Digital Twins](/azure/digital-twins/overview) is a platform for modeling physical environments as digital representations. In this architecture, it maintains digital models of IoT-connected assets to support spatial analysis and contextual insights.

- [Azure IoT Hub](/azure/well-architected/service-guides/iot-hub) enables bi-directional communication between IoT devices and the Azure cloud. In this architecture, it serves as the central messaging hub for device telemetry and command-and-control operations.

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a fully managed, real-time data ingestion service. In this architecture, it ingests telemetry from IoT devices and streams it into the analytics pipeline.

- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is an enterprise-grade, cost-effective service for running Apache Kafka on Azure. In this architecture, it provides an alternative streaming backbone for ingesting and distributing IoT data.

## Scenario details

This solution uses Azure Data Explorer to get near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide range of IoT devices.

### Potential use cases

- Fleet management, for predictive maintenance of vehicle parts. This solution is ideal for the automotive and transportation industry.
- Facilities management, for energy and environment optimization.
- Combining real-time road conditions with weather data for safer autonomous driving.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Shlomo Sagir](https://www.linkedin.com/in/shlomo-sagir/) | Senior Content Developer

## Next steps

- [What is Azure Data Explorer?](/azure/data-explorer/data-explorer-overview)
- [Visualize data with Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards)

## Related resource

- [Analytics architecture design](analytics-get-started.md)
