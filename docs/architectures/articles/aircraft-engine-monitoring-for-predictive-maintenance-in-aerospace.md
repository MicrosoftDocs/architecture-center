---
title: Predictive Aircraft Engine Monitoring 
description: Microsoft Azures Predictive Maintenance solution demonstrates how to combine real-time aircraft data with analytics to monitor aircraft health.
author: adamboeglin
ms.date: 10/18/2018
---
# Predictive Aircraft Engine Monitoring 
Microsoft Azures Predictive Maintenance solution demonstrates how to combine real-time aircraft data with analytics to monitor aircraft health.
This solution is built on the Azure managed services: Stream Analytics, Event Hubs, Machine Learning Studio, HDInsight, Azure SQL Database, Data Factory and Power BI. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.svg" alt='architecture diagram' />

## Components
* [Stream Analytics](http://azure.microsoft.com/services/stream-analytics/) provides near real-time analytics on the input stream from the Azure Event Hub. Input data is filtered and passed to a Machine Learning endpoint, finally sending the results to the Power BI dashboard.
* [Event Hubs](http://azure.microsoft.com/services/event-hubs/) ingests raw assembly-line data and passes it on to Stream Analytics.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): Machine Learning predicts potential failures based on real-time assembly-line data from Stream Analytics.
* [HDInsight](http://azure.microsoft.com/services/hdinsight/) runs Hive scripts to provide aggregations on the raw events that were archived by Stream Analytics.
* [Azure SQL Database](href="http://azure.microsoft.com/services/sql-database/): SQL Database stores prediction results received from Machine Learning and publishes data to Power BI.
* [Data Factory](http://azure.microsoft.com/services/data-factory/) handles orchestration, scheduling, and monitoring of the batch processing pipeline.
* [Power BI](https://powerbi.microsoft.com) visualizes real-time assembly-line data from Stream Analytics and the predicted failures and alerts from Data Warehouse.

## Next Steps
* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about HDInsight](https://docs.microsoft.com/azure/hdinsight/)
* [Learn more about SQL Database](https://docs.microsoft.com/azure/sql-database/)
* [Learn more about Azure Data Factory](https://docs.microsoft.com/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)