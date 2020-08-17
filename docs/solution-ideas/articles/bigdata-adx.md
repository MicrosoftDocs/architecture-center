---
title: Big Data Analytics with Azure Data Explorer
titleSuffix: Azure Solution Ideas
description: Big Data Analytics with Azure Data Explorer demonstrates Azure Data Explorer's abilities to supply the three V's of big data - volume, velocity, and variety of data.
author: orspod
ms.date: 08/11/2020
ms.topic: solution-ideas
ms.service: architecture-center
ms.subservice: solution-ideas
ms.custom:
- fcp
---

# Big Data analytics with Azure Data Explorer

This architecture pattern demonstrates big data analytics over large volumes of high velocity data from various sources. This pattern illustrates how Azure Data Explorer and Azure Synapse Analytics complement each other for near real-time analytics and modern data warehousing use cases.

This pattern is already being used by Microsoft customers. For example, see how Grab implemented real-time analytics over a huge amount of data collected from their taxi and food delivery services as well as merchant partner apps. The [team from Grab presented their solution at MS Ignite in this video (20:30 onwards)](https://myignite.techcommunity.microsoft.com/sessions/81060?source=sessions) Using this pattern, Grab processed more than trillion events per day.

:::image type="content" source="../media/bigdata-adx.png" alt-text="![Big Data analytics with Azure Data Explorer](../images/bigdata-adx.png)":::

## Data flow
 
1. Raw structured, semi-structured, and unstructured (free text) data such as any type of logs, business events, and user activities can be ingested into Azure Data Explorer from various sources.
1. Ingest data into Azure Data Explorer with low-latency and high throughput using its connectors for [Azure Data Factory](https://docs.microsoft.com/azure/data-explorer/data-factory-integration), [Azure Event Hub](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](https://docs.microsoft.com/azure/data-explorer/ingest-data-iot-hub), [Kafka](https://docs.microsoft.com/azure/data-explorer/ingest-data-kafka), and so on. Alternatively, ingest data through Azure Storage (Blob or ADLS Gen2), which uses [Azure Event Grid](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in [Azure Data Explorer external tables and continuous export](https://docs.microsoft.com/azure/data-explorer/kusto/management/data-export/continuous-data-export).
1. Export pre-aggregated data from Azure Data Explorer to Azure Storage and then ingest the data into Synapse Analytics to build data models and reports.
1. Use Azure Data Explorer’s native capabilities to process, aggregate, and analyze data. To get insights at a lightning speed, build near real-time analytics dashboards using [Azure Data Explorer dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](https://docs.microsoft.com/azure/data-exlorer/power-bi-best-practices), [Grafana](https://docs.microsoft.com/azure/data-explorer/grafana), or other tools. Use Azure Synapse Analytics to build a modern data warehouse and combine it with the Azure Data Explorer data to generate BI reports on curated and aggregated data models.
1. Azure Data Explorer provides native advanced analytics capabilities for [time series analysis](https://docs.microsoft.com/azure/data-explorer/time-series-analysis), pattern recognition, [anomaly detection and forecasting](https://docs.microsoft.com/azure/data-explorer/anomaly-detection), and [machine learning](https://docs.microsoft.com/azure/data-explorer/machine-learning-clustering). Azure Data Explorer is also well integrated with ML services such as Databricks and Azure Machine Learning. This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.  

## Components

1. [Azure Event Hub](https://azure.microsoft.com/services/event-hubs/)
2. [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/)
3. [Kafka on HDInsight](https://docs.microsoft.com/azure/hdinsight/kafka/apache-kafka-introduction)
4. [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/)
5. [Azure Data Explorer Dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards)
6. [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/)
