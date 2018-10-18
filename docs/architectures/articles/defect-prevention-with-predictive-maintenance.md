---
title: Defect prevention with predictive maintenance 
description: Learn how to use Azure Machine Learning to predict failures before they happen with real-time assembly line data.
author: adamboeglin
ms.date: 10/18/2018
---
# Defect prevention with predictive maintenance 
Learn how to use Azure Machine Learning to predict failures before they happen with real-time assembly line data.
This solution is built on the Azure managed services: Stream Analytics, Event Hubs, Machine Learning Studio, SQL Data Warehouse and Power BI. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/defect-prevention-with-predictive-maintenance.svg" alt='architecture diagram' />

## Components
* [Stream Analytics](http://azure.microsoft.com/services/stream-analytics/) provides near real-time analytics on the input stream from the Azure Event Hub. Input data is filtered and passed to a Machine Learning endpoint, finally sending the results to the Power BI dashboard.
* [Event Hubs](http://azure.microsoft.com/services/event-hubs/) ingests raw assembly-line data and passes it on to Stream Analytics.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): Machine Learning predicts potential failures based on real-time assembly-line data from Stream Analytics.
* [SQL Data Warehouse](http://azure.microsoft.com/services/sql-data-warehouse/) stores assembly-line data along with failure predictions.
* [Power BI](https://powerbi.microsoft.com) visualizes real-time assembly-line data from Stream Analytics and the predicted failures and alerts from Data Warehouse.

## Next Steps
* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about SQL Data Warehouse](https://docs.microsoft.com/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)