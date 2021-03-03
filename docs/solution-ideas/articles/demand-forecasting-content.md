


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Time series forecasting is one of the most important topics in data science

## Architecture

![Architecture diagram](../media/demand-forecasting.png)
*Download an [SVG](../media/demand-forecasting.svg) of this architecture.*

## Overview

Almost every business needs to predict the future in order to make better decisions and allocate resources more effectively. As an example, accurately forecasting spikes in demand for products and services can give a company a competitive advantage. The better the forecasting, the more they can scale as demand increases, and the less they risk holding onto unneeded inventory. Use cases include predicting demand for a product in a retail/online store, forecasting hospital visits, and anticipating power consumption.

This article focuses on presenting some useful kinks to the forecasting best practices as well as an example of detailled architecture schema for end to end implemnetation in Azure.

## Details

The Microsoft AI Platform provides advanced analytics tools through Microsoft Azure - data ingestion, data storage, data processing and advanced analytics components - all of the essential elements for building an demand forecasting for energy solution.

This solution combines several Azure services to provide powerful advantages. 
  1. Event Hubs collects real-time consumption data. 
  2. Stream Analytics aggregates the streaming data and makes it available for visualization. 
  3. Azure SQL Database stores and transforms the consumption data. 
  4. Machine Learning implements and executes the forecasting model. 
  5. PowerBI visualizes the real-time energy consumption as well as the forecast results. 
  6. Finally, Data Factory orchestrates and schedules the entire data flow.

## Components

Key technologies used to implement this architecture:
* [Azure Event Hubs](https://azure.microsoft.com/en-gb/services/event-hubs/): Simple, secure and scalable real-time data ingestion
* [Azure Stream Analytics](https://azure.microsoft.com/en-us/services/stream-analytics/): Provide Serverless real-time analytics, from the cloud to the edge
* [Azure SQL Database](https://azure.microsoft.com/en-us/services/sql-database/): Manage your intelligent SQL in the cloud
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Build, deploy, and manage predictive analytics solutions
* [Azure PowerBI](https://azure.microsoft.com/en-us/services/developer-tools/power-bi/): Realize the value of your data and bring the insights discovered in Azure data and analytics tools to the organization.

## useful machine learning links

  1. [Forecasting Best Practices](https://github.com/microsoft/forecasting)
  2. [AutoML For Forecasting](https://github.com/Azure/MachineLearningNotebooks/tree/master/how-to-use-azureml/automated-machine-learning)
