---
title: Data Streaming scenario
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Data Streaming scenario
ms.custom: acom-architecture, data streaming scenario, interactive-diagram, data, 'https://azure.microsoft.com/solutions/architecture/data-streaming-scenario/'
ms.service: architecture-center
ms.category:
  - databases
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/data-streaming-scenario.png
---

# Data Streaming scenario

[!INCLUDE [header_file](../header.md)]

Use AKS to easily ingest & process a real-time data stream with millions of data points collected via sensors. Perform fast analysis and computations to develop insights into complex scenarios quickly.

## Architecture

![Architecture Diagram](../media/data-streaming-scenario.png)
*Download an [SVG](../media/data-streaming-scenario.svg) of this architecture.*

## Data Flow

1. Sensor data is generated and streamed to Azure API Management.
1. AKS cluster runs microservice that are deployed as containers behind a service mesh. Containers are built using a DevOps process and stored in Azure Container Registry.
1. Ingest service stores data in a Azure Cosmos DB
1. Asynchronously, the Analysis service receives the data and streams it to Apache Kafka and Azure HDInsight.
1. Data scientists can analyze the large big data for use in machine learning models using Splunk.
1. Data is processed by the processing service which stores the result in Azure Database for PostgreSQL and caches the data in an Azure Cache for Redis.
1. A web app running in Azure App Service is used to visualize the results.
