


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Accurately forecasting spikes in demand for products and services can give a company a competitive advantage. This solution focuses on demand forecasting within the energy sector.

## Architecture

![Architecture diagram](../media/demand-forecasting.png)
*Download an [SVG](../media/demand-forecasting.svg) of this architecture.*

## Overview

Accurately forecasting spikes in demand for products and services can give a company a competitive advantage. The better the forecasting, the more they can scale as demand increases, and the less they risk holding onto unneeded inventory. Use cases include predicting demand for a product in a retail/online store, forecasting hospital visits, and anticipating power consumption.

This solution focuses on demand forecasting within the energy sector. Storing energy is not cost-effective, so utilities and power generators need to forecast future power consumption so that they can efficiently balance the supply with the demand. During peak hours, short supply can result in power outages. Conversely, too much supply can result in waste of resources. Advanced demand forecasting techniques detail hourly demand and peak hours for a particular day, allowing an energy provider to optimize the power generation process. This solution using Cortana Intelligence enables energy companies to quickly introduce powerful forecasting technology into their business.

## Details

The Cortana Intelligence Suite provides advanced analytics tools through Microsoft Azure - data ingestion, data storage, data processing and advanced analytics components - all of the essential elements for building an demand forecasting for energy solution.

This solution combines several Azure services to provide powerful advantages. Event Hubs collects real-time consumption data. Stream Analytics aggregates the streaming data and makes it available for visualization. Azure SQL stores and transforms the consumption data. Machine Learning implements and executes the forecasting model. PowerBI visualizes the real-time energy consumption as well as the forecast results. Finally, Data Factory orchestrates and schedules the entire data flow.

The 'Deploy' button will launch a workflow that will deploy an instance of the solution within a Resource Group in the Azure subscription you specify. The solution includes multiple Azure services (described below) along with a web job that simulates data so that immediately after deployment you have a working end-to-end solution. The sample data of this solution is simulated from publicly available data from the NYISO.

## Technical details and workflow

  1. The sample data is streamed by newly deployed Azure Web Jobs.
  2. This synthetic data feeds into the Azure Event Hubs and Azure SQL service as data points or events, that will be used in the rest of the solution flow.
  3. Azure Stream Analytics analyze the data to provide near real-time analytics on the input stream from the event hub and directly publish to PowerBI for visualization.
  4. Azure Machine Learning is used to make forecast on the energy demand of particular region given the inputs received.
  5. Azure SQL Database is used to store the prediction results received from Azure Machine Learning. These results are then consumed in the Power BI dashboard.
  6. Azure Data Factory handles orchestration, and scheduling of the hourly model retraining.
  7. Finally, Power BI is used for results visualization, so that users can monitor the energy consumption from a region in real time and use the forecast demand to optimize the power generation or distribution process.

## Pricing Info

Your Azure subscription used for the deployment will incur consumption charges on the services used in this solution. For pricing details, visit the [Azure Pricing Page](https://azure.microsoft.com/pricing/calculator).
