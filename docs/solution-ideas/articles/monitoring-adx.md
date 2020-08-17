---
title: End-to-End Monitoring Solution with Azure Data Explorer
titleSuffix: Azure Solution Ideas
description: End-to-end monitoring solution with Azure Data Explorer demonstrates a hybrid monitoring solution integrated with Azure Sentinel and Azure Monitor for ingesting streaming and batched logs from diverse sources within an enterprise ecosystem. 
author: orspod
ms.date: 08/11/2020
ms.topic: solution-ideas
ms.service: architecture-center
ms.subservice: solution-ideas
ms.custom:
- fcp
---

# End-to-end monitoring solution with Azure Data Explorer

This architecture pattern demonstrates a hybrid end-to-end monitoring solution integrated with Azure Sentinel and Azure Monitor for ingesting streamed and batched logs from diverse sources, on-premises or any cloud, within an enterprise ecosystem. 

:::image type="content" source="../media/monitoring-adx.png" alt-text="![Monitoring solution with Azure Data Explorer](../images/monitoring-adx.png)":::

## Key features of this architecture pattern

1. Combine features provided by Azure Sentinel and Azure Monitor with Azure Data Explorer to build a flexible and cost-optimized end-to-end monitoring solution. 
For example:
   * Use Azure Sentinel as a SIEM and SOAR component in the overall monitoring solution where you can ingest security logs from firewalls, security center, and so on.
   * Use Azure Monitor’s native capabilities for IT asset monitoring, dashboarding, and alerting so you can ingest logs from VMs, services, and so on.
   * Use Azure Data Explorer for full flexibility and control in all aspects for all log types in the following scenarios:  
     * No out of the box features provided by Azure Sentinel and Azure Monitor SaaS solutions such as application trace logs.
     * Greater flexibility for building quick and easy near-real-time analytics dashboards, granular role-based access control, [time series analysis](https://docs.microsoft.com/azure/data-explorer/time-series-analysis), pattern recognition, [anomaly detection and forecasting](https://docs.microsoft.com/azure/data-explorer/anomaly-detection), and [machine learning](https://docs.microsoft.com/azure/data-explorer/machine-learning-clustering). Azure Data Explorer is also well integrated with ML services such as Databricks and Azure Machine Learning. This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.  
     - Longer data retention in cost effective manner
     * Centralized repository for different types of logs. Azure Data Explorer, as a unified big data analytics platform, allows you to build advanced analytics scenarios.
1. Query across different products without moving data using the [Azure Data Explorer proxy](https://docs.microsoft.com/azure/data-explorer/query-monitor-data) feature to analyze data from Azure Sentinel, Azure Monitor, and Azure Data Explorer in a single query.
1. To ingest logs from on-premises or any other cloud, use native Azure Data Explorer connectors such as [Logstash](https://docs.microsoft.com/azure/data-explorer/ingest-data-logstash), [Azure Event Hub](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-hub), or [Kafka](https://docs.microsoft.com/azure/data-explorer/ingest-data-kafka).
1. Alternatively, ingest data through Azure Storage (Blob or ADLS Gen2) using Apache Nifi, Fluentd, or Fluentbit connectors. Then use [Azure Event Grid](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-grid) to trigger the ingestion pipeline to Azure Data Explorer. 
1. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in [Azure Data Explorer external tables and continuous export](https://docs.microsoft.com/azure/data-explorer/kusto/management/data-export/continuous-data-export).

> [!NOTE]
> Azure Sentinel is built on Azure Monitor (Log Analytics) which is built on Azure Data Explorer. Therefore, switching between these services is seamless. This allows you to reuse Kusto query language queries and dashboards across these services.

## Components

1. [Azure Event Hub](https://azure.microsoft.com/services/event-hubs/)
2. [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/)
3. [Kafka on HDInsight](https://docs.microsoft.com/azure/hdinsight/kafka/apache-kafka-introduction)
4. [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/)
5. [Azure Data Explorer Dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards)
6. [Azure Sentinel](https://azure.microsoft.com/services/azure-sentinel/)
7. [Azure Monitor](https://azure.microsoft.com/services/monitor/)
