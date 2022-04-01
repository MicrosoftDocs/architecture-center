---
title: Forecast energy and power demand
titleSuffix: Azure Solution Ideas
author: carlosasantos
ms.date: 04/01/2022
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

The energy consumption and energy demand change over time. The monitoring of this change over time, results in time-series that can be leveraged to understand patterns, and to forecast future behaviors. Learn how Microsoft Azure can help accurately forecast spikes in demand for energy products and services to give your company a competitive advantage.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Data Factory](https://azure.microsoft.com/services/data-factory), and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture diagram: using Azure services like Machine Learning in a solution that forecasts energy and power demand.](../media/forecast-energy-power-demand.png)
*Download an [SVG](../media/forecast-energy-power-demand.svg) of this architecture.*

### Workflow

1. Time series data can be stored in various formats, depending on its original source. Data can be stored as files within Azure Data Lake Storage or in tabular form in Azure Synapse or Azure SQL Database.
2. Read: Azure Machine Learning (ML) can connect and read from such sources. Ingestion of time series data into Azure Machine Learning, enables Automated Machine Learning (AutoML) to pre-process the data, train and register a model.
3. The first step within AutoML is configuration and preprocessing the time series data. In this step, the provided data is prepared for training, and drives the featurization and forecasting configuration:
    - Impute missing values
    - Holiday and DateTime feature engineering
    - Lags and rolling windows
    - Rolling Origin Cross Validation
4. During the training stage, AutoML leverages the preprocessed dataset to train, select and explain the best forecasting model.
    - Model Training: a wide range of machine learning models can be used, ranging from classical forecasting, deep neural networks, and regression models.
    - Model Evaluation: The evaluation of models allows AutoML to assess the performance of each trained model, and enables the best performing model to be selected for deployment.
    - Explainability: AutoML provides the ability to provide explainability for the selected model. This enables users to better understand what features are driving model outcomes.
5. The model with best performance is registered in Azure Machine Learning using AutoML, making it available for deployment.  
6. Deploy: The model registered in Azure Machine Learning can be deployed, providing a live endpoint that can be exposed for inferencing.
7. The deployment can be done through Azure Kubernetes Service (AKS), while running a Kubernetes-managed cluster where the containers are deployed from images that are stored in Azure Container Registry. Alternatively, Azure Container Instances can be used instead of AKS 
8. Inference: Once the model is deployed, the inferencing of new data can be done via the available endpoint. Near real time and batch predictions can be supported. The inference results can be stored as documents within Azure Data Lake Storage or in tabular form in Azure Synapse or Azure SQL Database.
9. Visualize: Stored model results can be consumed through user interfaces, such as Power BI dashboards, or custom built web applications.  written to a storage option in file or tabular format, then properly indexed by Azure Cognitive Search. The model would run as batch inference and store the results in the respective datastore.

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

* Set up AutoML to train a time-series forecasting model with Python [Set up AutoML to train a time-series forecasting model with Python](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-forecast).
* Try the Machine Learning notebook for [forecasting using the Energy Demand Dataset](https://github.com/Azure/MachineLearningNotebooks/blob/master/how-to-use-azureml/automated-machine-learning/forecasting-energy-demand/auto-ml-forecasting-energy-demand.ipynb).
* Try the Microsoft Learn module, [Use automated machine learning in Azure Machine Learning](/learn/modules/use-automated-machine-learning/).
