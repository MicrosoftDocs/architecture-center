---
title: Predictive Insights with Vehicle Telematics 
description: Learn how car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.
author: adamboeglin
ms.date: 10/18/2018
---
# Predictive Insights with Vehicle Telematics 
Learn how car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.
This solution is built on the Azure managed services: Event Hubs, Stream Analytics, Machine Learning Studio, Storage, HDInsight, Data Factory, Azure SQL Database and Power BI. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/predictive-insights-with-vehicle-telematics.svg" alt='architecture diagram' />

## Components
* [Event Hubs](http://azure.microsoft.com/services/event-hubs/) ingests diagnostic events and passes them on to Stream Analytics and an Azure ML Web Service.
* [Stream Analytics](http://azure.microsoft.com/services/stream-analytics/) accepts the input stream from Event Hubs, calls an Azure ML Web Service to do predictions, and sends the stream to Azure Storage and Power BI.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud and deploy web services that can be called by Stream Analytics and Azure Data Factory.
* Azure [Storage](http://azure.microsoft.com/services/storage/) stores diagnostic events stream data from Stream Analytics.
* Azure Data Factory uses [HDInsight](http://azure.microsoft.com/services/hdinsight/) to run Hive queries to process the data and load it into Azure SQL Database.
* [Data Factory](http://azure.microsoft.com/services/data-factory/) uses HDInsight to process data and load it into Azure SQL Database.
* [Azure SQL Database](href="http://azure.microsoft.com/services/sql-database/): SQL Database is used to store and data processed by Data Factory and HDInsight and is accessed by Power BI for analysis of the telemetry data.
* This solution uses [Power BI](https://powerbi.microsoft.com), but others use [Power BI](https://powerbi.microsoft.com) Embedded to analyze the telemetry data.

## Next Steps
* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about Azure Storage](https://docs.microsoft.com/azure/storage/storage-introduction)
* [Learn more about HDInsight](https://docs.microsoft.com/azure/hdinsight/)
* [Learn more about Azure Data Factory](https://docs.microsoft.com/azure/data-factory/data-factory-introduction)
* [Learn more about SQL Database](https://docs.microsoft.com/azure/sql-database/)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)