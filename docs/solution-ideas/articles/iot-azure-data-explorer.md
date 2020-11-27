---
title: IoT analytics with Azure Data Explorer
titleSuffix: Azure Solution Ideas
description: IoT Telemetry Analytics with Azure Data Explorer demonstrates near real-time analytics over fast flowing, high volume, wide variety of streaming data from IoT devices.
author: orspod
ms.date: 08/11/2020
ms.service: architecture-center
ms.subservice: solution-idea
ms.custom:
- fcp
---

# IoT telemetry analytics with Azure Data Explorer

This architecture pattern demonstrates near real-time analytics over fast flowing, high volume streaming data from IoT devices, sensors, connected buildings and vehicles, and so on. It focuses on integration of Azure Data Explorer with other IoT services to cater to both operational and analytical workloads using Cosmos DB and Azure Data Explorer. 

This architecture is already being used by Microsoft customers for IoT device telemetry analytics. For example, [Bosch uses this to combine real-time road conditions with weather data for safer autonomous driving](https://customers.microsoft.com/story/816933-bosch-automotive-azure-germany).

:::image type="content" source="../media/iot-azure-data-explorer.png" alt-text="IoT telemetry analytics with Azure Data Explorer" lightbox="../media/iot-azure-data-explorer.png":::

## Data flow
 
1. Ingest a wide variety of fast-flowing streaming data such as logs, business events, and user activities from various sources such as Azure Event Hub, Azure IoT Hub, or Kafka.
1. Process data in real-time using Azure Functions or Azure Stream Analytics.
1. Store streamed JSON messages in Cosmos DB to serve a real-time operational application. 
1. Ingest data into Azure Data Explorer with low-latency and high throughput using its connectors for [Azure Event Hub](/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](/azure/data-explorer/ingest-data-iot-hub), [Kafka](/azure/data-explorer/ingest-data-kafka), and so on. Alternatively, ingest data through Azure Storage (Blob or ADLS Gen2), which uses [Azure Event Grid](/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in the [continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).
1. Azure Data Explorer is a big data analytics store for serving near real-time analytics applications and dashboards.
As this pattern serves both operational and analytical use cases, data can either be routed to Azure Data Explorer and Cosmos DB in parallel, or from Cosmos DB to Azure Data Explorer. 
   * Integrate Cosmos DB with Azure Data Explorer using change feed. Every transaction in Cosmos DB can trigger an Azure Function via this change feed. Data can then be streamed to Event Hub and ingested into Azure Data Explorer.
   * From Azure Function, invoke Azure Digital Twin (ADT) APIs. ADT is used for storing digital models of physical environments. This service streams data to Event Hub, which then gets ingested to Azure Data Explorer.
1. Gain insights from data stored in Azure Data Explorer by any of the following methods:
   * Build a custom analytics app that invokes APIs exposed by ADT and Azure Data Explorer to blend the data from both sources.
   * Build near real-time analytics dashboards using [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](/power-bi/transform-model/service-dataflows-best-practices), or [Grafana](/azure/data-explorer/grafana).
   * Create and schedule alerts and notifications using the [Azure Data Explorer connector for Azure Logic Apps](/azure/data-explorer/kusto/tools/logicapps).
   * Analyze data using [Azure Data Explorer Web UI](/azure/data-explorer/web-query-data), [Kusto.Explorer](/azure/data-explorer/kusto/tools/kusto-explorer), or [Jupyter notebooks](/azure/data-explorer/kqlmagic).
1. Azure Data Explorer provides native advanced analytics capabilities for [time series analysis](/azure/data-explorer/time-series-analysis), pattern recognition, [anomaly detection and forecasting](/azure/data-explorer/anomaly-detection), and [machine learning](/azure/data-explorer/machine-learning-clustering). Azure Data Explorer is also well integrated with ML services such as Databricks and Azure Machine Learning. This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.  

## Components

- [Azure Event Hub](https://azure.microsoft.com/services/event-hubs/): Fully managed, real-time data ingestion service that’s simple, trusted, and scalable.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/): Managed service to enable bi-directional communication between IoT devices and Azure.
- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction): Easy, cost-effective, enterprise-grade service for open source analytics with Apache Kafka. 
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/): Fully managed fast NoSQL database service for modern app development with open APIs for any scale.
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Explorer Dashboards](/azure/data-explorer/azure-data-explorer-dashboards): Natively export Kusto queries that were explored in the Web UI to optimized dashboards. 
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/): Create next-generation IoT solutions that model the real world.

## Next steps

For more information, see [Azure Data Explorer documentation](/azure/data-explorer/).