---
title: Anomaly Detection with Machine Learning 
description: Microsoft Azures IT Anomaly Insights can help automate and scale anomaly detection for IT departments to quickly detect and fix issues.
author: adamboeglin
ms.date: 10/18/2018
---
# Anomaly Detection with Machine Learning 
Microsoft Azures IT Anomaly Insights can help automate and scale anomaly detection for IT departments to quickly detect and fix issues.
This solution is built on the Azure managed services: Event Hubs, Stream Analytics, Storage, Data Factory, Azure SQL Database, Machine Learning Studio, Service Bus, Application Insights and Power BI. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/anomaly-detection-with-machine-learning.svg" alt='architecture diagram' />

## Components
* [Event Hubs](href="http://azure.microsoft.com/services/event-hubs/): This is the entry point of the pipeline, where the raw timeseries data is ingested.
* [Stream Analytics](http://azure.microsoft.com/services/stream-analytics/) performs aggregation at 5-minute intervals, and aggregates raw data points by metric name.
* Azure [Storage](http://azure.microsoft.com/services/storage/) stores data aggregated by the Stream Analytics job.
* [Data Factory](http://azure.microsoft.com/services/data-factory/) calls the Anomaly Detection API at regular intervals (every 15 minutes by default) on the data in Azure Storage. It stores the results in a SQL database.
* [Azure SQL Database](href="http://azure.microsoft.com/services/sql-database/): SQL Database stores the results from the Anomaly Detection API, including binary detections and detection scores. It also stores optional metadata sent with the raw data points to allow for more complicated reporting.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): This hosts the Anomaly Detection API. Note that the API itself is stateless and requires historical data points to be sent in each API call.
* [Service Bus](href="http://azure.microsoft.com/services/service-bus/): Detected anomalies are published to a service bus topic to enable consumption by external monitoring services.
* Application Insights: Application Insights allows for monitoring of the pipeline.
* [Power BI](https://powerbi.microsoft.com) provides dashboards showing the raw data, as well as detected anomalies.

## Next Steps
* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Azure Storage](https://docs.microsoft.com/azure/storage/storage-introduction)
* [Learn more about Azure Data Factory](https://docs.microsoft.com/azure/data-factory/data-factory-introduction)
* [Learn more about SQL Database](https://docs.microsoft.com/azure/sql-database/)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about Service Bus](https://docs.microsoft.com/azure/service-bus-messaging/)
* [Learn more about Application Insights](https://docs.microsoft.com/azure/application-insights/)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)