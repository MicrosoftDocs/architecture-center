---
title: Big data analytics with Azure Data Explorer
titleSuffix: Azure Solution Ideas
description: Big Data Analytics with Azure Data Explorer demonstrates Azure Data Explorer's abilities to cater to volume, velocity, and variety of data, the three V's of big data.
author: orspod
ms.date: 08/11/2020
ms.service: architecture-center
ms.subservice: solution-idea
ms.custom:
- fcp
---

# Big data analytics with Azure Data Explorer

This architecture pattern demonstrates big data analytics over large volumes of high velocity data from various sources. This pattern illustrates how Azure Data Explorer and Azure Synapse Analytics complement each other for near real-time analytics and modern data warehousing use cases.

This pattern is already being used by Microsoft customers. For example, the Singapore-based ride-hailing company, Grab, implemented real-time analytics over a huge amount of data collected from their taxi and food delivery services as well as merchant partner apps. The [team from Grab presented their solution at MS Ignite in this video (20:30 onwards)](https://www.youtube.com/watch?v=K9FYqprpzRE&t=1230&ab_channel=MicrosoftIgnite). Using this pattern, Grab processed more than a trillion events per day.

:::image type="content" source="../media/big-data-azure-data-explorer.png" alt-text="Big data analytics with Azure Data Explorer" lightbox="../media/big-data-azure-data-explorer.png":::

## Data flow
 
1. Raw structured, semi-structured, and unstructured (free text) data such as any type of logs, business events, and user activities can be ingested into Azure Data Explorer from various sources.
1. Ingest data into Azure Data Explorer with low-latency and high throughput using its connectors for [Azure Data Factory](/azure/data-explorer/data-factory-integration), [Azure Event Hub](/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](/azure/data-explorer/ingest-data-iot-hub), [Kafka](/azure/data-explorer/ingest-data-kafka), and so on. Alternatively, ingest data through Azure Storage ([Blob](/azure/storage/blobs/) or [ADLS Gen2](/azure/storage/blobs/data-lake-storage-introduction)), which uses [Azure Event Grid](/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in the [Continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).
1. Export pre-aggregated data from Azure Data Explorer to Azure Storage, and then ingest the data into Synapse Analytics to build data models and reports.
1. Use Azure Data Explorer’s native capabilities to process, aggregate, and analyze data. To get insights at a lightning speed, build near real-time analytics dashboards using [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](/power-bi/transform-model/service-dataflows-best-practices), [Grafana](/azure/data-explorer/grafana), or other tools. Use Azure Synapse Analytics to build a modern data warehouse and combine it with the Azure Data Explorer data to generate BI reports on curated and aggregated data models.
1. Azure Data Explorer provides native advanced analytics capabilities for [time series analysis](/azure/data-explorer/time-series-analysis), pattern recognition, [anomaly detection and forecasting](/azure/data-explorer/anomaly-detection), and [machine learning](/azure/data-explorer/machine-learning-clustering). Azure Data Explorer is also well integrated with ML services such as [Databricks](/azure/databricks/) and [Azure Machine Learning](/azure/machine-learning/). This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.  

## Components

- [Azure Event Hub](https://azure.microsoft.com/services/event-hubs/): Fully managed, real-time data ingestion service that’s simple, trusted, and scalable.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/): Managed service to enable bi-directional communication between IoT devices and Azure.
- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction): Easy, cost-effective, enterprise-grade service for open source analytics with Apache Kafka. 
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Explorer Dashboards](/azure/data-explorer/azure-data-explorer-dashboards): Natively export Kusto queries that were explored in the Web UI to optimized dashboards. 
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/): Analytics service that brings together enterprise data warehousing and Big Data analytics.

## Next steps

For more information, see [Azure Data Explorer documentation](/azure/data-explorer/).