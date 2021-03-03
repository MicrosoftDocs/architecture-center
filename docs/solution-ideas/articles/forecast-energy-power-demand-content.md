---
title: Forecast Energy and Power Demand
titleSuffix: Azure Solution Ideas
author: cartacios
ms.date: 3/2/2021
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

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Data Factory](https://azure.microsoft.com/services/data-factory) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/forecast-energy-power-demand.png)
*Download an [SVG](../media/forecast-energy-power-demand.svg) of this architecture.*

## Components

* [Azure Data Factory](https://azure.microsoft.com/services/data-factory): Handle data manipulation and preparation.
* [Azure Automated Machine Learning](https://azure.microsoft.com/services/machine-learning/automatedml): Leverage Azure ML to forecast the energy demand of a particular region.
* [MLOps](https://azure.microsoft.com/services/machine-learning/mlops): Design, deploy, and manage production model workflows.
* [Power BI](https://docs.microsoft.com/power-bi/connect-data/service-aml-integrate): Consume model prediction results in Power BI.

## Next steps

* [Learn more about Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn more about SQL Database](/azure/sql-database)
* [Learn more about Data Factory](/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)