---
title: Forecast Energy and Power Demand
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.
ms.custom: acom-architecture, energy demand, power forecast, energy forecast, ai-ml, 'https://azure.microsoft.com/solutions/architecture/forecast-energy-power-demand/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
  - integration
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/forecast-energy-power-demand.png
---

# Forecast Energy and Power Demand

[!INCLUDE [header_file](../header.md)]

Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Data Factory](https://azure.microsoft.com/services/data-factory) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/forecast-energy-power-demand.png)
*Download an [SVG](../media/forecast-energy-power-demand.svg) of this architecture.*

## Components

* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics): Stream Analytics aggregates energy consumption data in near real-time to write to Power BI.
* [Event Hubs](https://azure.microsoft.com/services/event-hubs) ingests raw energy consumption data and passes it on to Stream Analytics.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio): Machine Learning forecasts the energy demand of a particular region given the inputs received.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database): SQL Database stores the prediction results received from Azure Machine Learning. These results are then consumed in the Power BI dashboard.
* [Data Factory](https://azure.microsoft.com/services/data-factory) handles orchestration and scheduling of the hourly model retraining.
* [Power BI](https://powerbi.microsoft.com) visualizes energy consumption data from Stream Analytics as well as predicted energy demand from SQL Database.

## Next steps

* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn more about SQL Database](https://docs.microsoft.com/azure/sql-database)
* [Learn more about Data Factory](https://docs.microsoft.com/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)
