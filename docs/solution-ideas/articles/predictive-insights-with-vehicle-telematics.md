---
title: Predictive Insights with Vehicle Telematics
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Learn how car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.
ms.custom: acom-architecture, vehicle telematics, automotive telematics, anomaly-detection, ai-ml, 'https://azure.microsoft.com/solutions/architecture/predictive-insights-with-vehicle-telematics/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
  - storage
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/predictive-insights-with-vehicle-telematics.png
---

# Predictive Insights with Vehicle Telematics

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Learn how car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.

This solution is built on the Azure managed services: [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio), [Storage Accounts](https://azure.microsoft.com/services/storage), [HDInsight](https://azure.microsoft.com/services/hdinsight), [Data Factory](https://azure.microsoft.com/services/data-factory), [Azure SQL Database](https://azure.microsoft.com/services/sql-database) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/predictive-insights-with-vehicle-telematics.png)
*Download an [SVG](../media/predictive-insights-with-vehicle-telematics.svg) of this architecture.*

## Components

* [Event Hubs](https://azure.microsoft.com/services/event-hubs) ingests diagnostic events and passes them on to Stream Analytics and an Azure ML Web Service.
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics): Stream Analytics accepts the input stream from Event Hubs, calls an Azure ML Web Service to do predictions, and sends the stream to Azure Storage and Power BI.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud and deploy web services that can be called by Stream Analytics and Azure Data Factory.
* [Storage Accounts](https://azure.microsoft.com/services/storage): Azure Storage stores diagnostic events stream data from Stream Analytics.
* Azure Data Factory uses [HDInsight](https://azure.microsoft.com/services/hdinsight) to run Hive queries to process the data and load it into Azure SQL Database.
* [Data Factory](https://azure.microsoft.com/services/data-factory) uses HDInsight to process data and load it into Azure SQL Database.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database): SQL Database is used to store and data processed by Data Factory and HDInsight and is accessed by Power BI for analysis of the telemetry data.
* This solution uses [Power BI](https://powerbi.microsoft.com), but others use [Power BI](https://powerbi.microsoft.com) Embedded to analyze the telemetry data.

## Next steps

* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn more about Azure Storage](https://docs.microsoft.com/azure/storage/common/storage-introduction)
* [Learn more about HDInsight](https://docs.microsoft.com/azure/hdinsight)
* [Learn more about Azure Data Factory](https://docs.microsoft.com/azure/data-factory/data-factory-introduction)
* [Learn more about SQL Database](https://docs.microsoft.com/azure/sql-database)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)
