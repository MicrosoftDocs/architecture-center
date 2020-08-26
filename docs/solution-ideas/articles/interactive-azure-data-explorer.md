---
title: Azure Data Explorer interactive analytics 
titleSuffix: Azure Solution Ideas
description: Interactive Analytics with Azure Data Explorer focuses on its integration with the rest of the data platform ecosystem.
author: orspod
ms.date: 08/11/2020
ms.service: architecture-center
ms.subservice: solution-idea
ms.custom:
- fcp
---

# Interactive analytics with Azure Data Explorer

This architecture pattern demonstrates interactive analytics with Azure Data Explorer to explore data with ad hoc, interactive, and lightning fast queries over small to extremely large volumes of data. This data exploration can be performed using native Azure Data Explorer tools or alternative tools of your choice. This architecture focuses on the integration of Azure Data Explorer with rest of the data platform ecosystem.

This pattern is already being used by Microsoft customers to track user activity, manage user profiles and user segmentation scenarios. For example, [global software company Episerver uses Azure Data Explorer to gain enhanced consumer insight](https://customers.microsoft.com/story/817285-episerver-professional-services-azure-sweden).

:::image type="content" source="../media/interactive-adx.png" alt-text="Interactive Analytics with Azure Data Explorer":::

## Data flow 

1. Raw structured, semi-structured, and unstructured (free text) data such as, any type of logs, business events, and user activities can be ingested into Azure Data Explorer from various sources. Ingest the data in streaming or batch mode using various methods.
1. Ingest data into Azure Data Explorer with low-latency and high-throughput using its connectors for [Azure Data Factory](https://docs.microsoft.com/azure/data-explorer/data-factory-integration), [Azure Event Hub](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-hub), [Azure IoT Hub](https://docs.microsoft.com/azure/data-explorer/ingest-data-iot-hub), [Kafka](https://docs.microsoft.com/azure/data-explorer/ingest-data-kafka), and so on. Alternatively, ingest data through Azure Storage (Blob or ADLS Gen2), which uses [Azure Event Grid](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in [continuous data export overview](https://docs.microsoft.com/azure/data-explorer/kusto/management/data-export/continuous-data-export).
1. Run interactive queries over small to extremely large volumes of data using native Azure Data Explorer tools or alternative tools of your choice. [Azure Data Explorer provides many plugins and integrations with the rest of the data platform ecosystem](https://docs.microsoft.com/azure/data-explorer/tools-integrations-overview). Use any of the following tools and integrations:
    * For interactive analytics, use [Azure Data Explorer Web UI](https://docs.microsoft.com/azure/data-explorer/web-query-data), web client for Azure Data Explorer, or [Kusto.Explorer](https://docs.microsoft.com/azure/data-explorer/kusto/tools/kusto-explorer), rich windows client for Azure Data Explorer.
    * To connect to your Azure Data Explorer cluster, use [Jupyter notebooks](https://docs.microsoft.com/azure/data-explorer/kqlmagic), [Spark connector](https://docs.microsoft.com/azure/data-explorer/spark-connector), any [TDS-compliant SQL client](https://docs.microsoft.com/azure/data-explorer/kusto/api/tds/clients/), as well as JDBC and ODBC connections.
    * To build new apps or integrate with existing apps or frameworks, use Azure Data Explorer [REST APIs and SDKs available in different languages](https://docs.microsoft.com/azure/data-explorer/kusto/api/client-libraries). 
    * Build near real-time analytics dashboards using [Azure Data Explorer dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](https://docs.microsoft.com/azure/data-exlorer/power-bi-best-practices), or [Grafana](https://docs.microsoft.com/azure/data-explorer/grafana).
1. Enrich data running federated queries by combining data from SQL database and Azure Cosmos DB using Azure Data Explorer plugins.

## Components

- [Azure Event Hub](https://azure.microsoft.com/services/event-hubs/): Fully managed, real-time data ingestion service that’s simple, trusted, and scalable.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/): Managed service to enable bi-directional communication between IoT devices and Azure.
- [Kafka on HDInsight](https://docs.microsoft.com/azure/hdinsight/kafka/apache-kafka-introduction): Easy, cost-effective, enterprise-grade service for open source analytics with Apache Kafka.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/): Hybrid data integration service that simplifies ETL at scale.
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Explorer Dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards): Natively export Kusto queries that were explored in the Web UI to optimized dashboards. 
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/): Fully managed fast NoSQL database service for modern app development with open APIs for any scale.
- [Azure SQL DB](https://azure.microsoft.com/services/sql-database/): Build apps that scale with the pace of your business with managed and intelligent SQL in the cloud.

## Next steps

For more information, see [Azure Data Explorer documentation](https://docs.microsoft.com/azure/data-explorer/).
