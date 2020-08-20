---
title: Content Delivery Network Analytics
titleSuffix: Azure Solution Ideas
description: Content Delivery Network Analytics with Azure Data Explorer demonstrates low-latency high throughput ingestion for large volumes of Content Delivery Network (CDN) logs for building near real-time analytics dashboards.
author: orspod
ms.date: 08/11/2020
ms.service: architecture-center
ms.subservice: solution-idea
ms.custom:
- fcp
---

# Content Delivery Network analytics with Azure Data Explorer

This architecture pattern demonstrates low-latency high throughput ingestion for large volumes of Content Delivery Network (CDN) logs for building near real-time analytics dashboards. 

:::image type="content" source="../media/cdn-adx.png" alt-text="![Content delivery network analytics with Azure Data Explorer](../images/cdn-adx.png)":::

## Data flow 

1. Content Delivery Network providers such as Verizon and Fastly ingest huge amounts of CDN logs into Azure Data Explorer to analyze latencies, health, and performance of CDN assets.
2. Most CDN scenarios ingest data through Azure Storage ([Blob](https://docs.microsoft.com/azure/storage/blobs/) or [ADLS Gen2](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction)), which uses [Azure Event Grid](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. Alternatively you can bulk ingest the data using the [LightIngest tool](https://docs.microsoft.com/azure/data-explorer/lightingest). You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in [Continuous data export overview](https://docs.microsoft.com/azure/data-explorer/kusto/management/data-export/continuous-data-export).
3. Azure Data Explorer provides easy to use native operators and functions to process, aggregate, and analyze time series and log data, as well as supply insights at lightning speed. You can build near real-time analytics dashboards using [Azure Data Explorer dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](https://docs.microsoft.com/azure/data-exlorer/power-bi-best-practices), or [Grafana](https://docs.microsoft.com/azure/data-explorer/grafana).
4. Create and schedule alerts and notifications using [Azure Data Explorer connector for Azure Logic Apps](https://docs.microsoft.com/azure/data-explorer/kusto/tools/logicapps).

## Components

1. [Azure Storage Azure Data Explorer connector](https://docs.microsoft.com/azure/data-explorer/ingest-data-event-grid)
2. [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/)
3. [Azure Data Explorer Dashboards](https://docs.microsoft.com/azure/data-explorer/azure-data-explorer-dashboards)
4. [Azure Logic Apps Azure Data Explorer connector](https://docs.microsoft.com/azure/data-explorer/kusto/tools/logicapps)
