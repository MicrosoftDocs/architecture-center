---
title: Forecast energy and power demand
titleSuffix: Azure Solution Ideas
author: cartacios
ms.date: 3/2/2021
description: Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services.
ms.custom: acom-architecture, energy demand, power forecast, energy forecast, ai-ml, 'https://azure.microsoft.com/solutions/architecture/forecast-energy-power-demand/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
  - integration
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/forecast-energy-power-demand.png
---

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Data Factory](https://azure.microsoft.com/services/data-factory), and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture diagram: using Azure services like Machine Learning in a solution that forecasts energy and power demand.](../media/forecast-energy-power-demand.png)
*Download an [SVG](../media/forecast-energy-power-demand.svg) of this architecture.*

### Components

* [Azure Data Factory](https://azure.microsoft.com/services/data-factory): Handle data manipulation and preparation.
* [Azure Automated Machine Learning](https://azure.microsoft.com/services/machine-learning/automatedml): Use Azure ML to forecast the energy demand of a particular region.
* [MLOps](https://azure.microsoft.com/services/machine-learning/mlops): Design, deploy, and manage production model workflows.
* [Power BI](/power-bi/connect-data/service-aml-integrate): Consume model prediction results in Power BI.

## Next steps

See product documentation:

* [Welcome to Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [What is Event Hubs?](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Azure SQL documentation](/azure/sql-database)
* [Learn more about Data Factory](/azure/data-factory/data-factory-introduction)
* [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
* [Machine Learning and time series forecasting](/azure/machine-learning/concept-automated-ml#time-series-forecasting)
* [Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)

Learn more:

* Try the Machine Learning notebook for [forecasting using the Energy Demand Dataset](https://github.com/Azure/MachineLearningNotebooks/blob/master/how-to-use-azureml/automated-machine-learning/forecasting-energy-demand/auto-ml-forecasting-energy-demand.ipynb).
* Try the Microsoft Learn module, [Use automated machine learning in Azure Machine Learning](/learn/modules/use-automated-machine-learning/).
