[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Learn how car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.

## Architecture

![Architecture Diagram show the flow of information through the different computer systems that help with the predictive insights of vehicle telematics.](../media/predictive-insights-with-vehicle-telematics.svg)

*Download a [Visio file](https://arch-center.azureedge.net/predictive-insights-with-vehicle-telematics.vsdx) of this architecture.*

### Components

* [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs). Event Hubs ingests diagnostic events and passes them on to Stream Analytics and an Azure ML Web Service.
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics). Stream Analytics accepts the input stream from Event Hubs, calls an Azure ML Web Service to do predictions, and sends the stream to Azure Storage and Power BI.
* [Azure Machine Learning](https://azure.microsoft.com/free/machine-learning). Machine Learning helps you design, test, operationalize, and manage predictive analytics solutions in the cloud and deploy web services that can be called by Stream Analytics and Azure Data Factory.
* [Azure Storage Accounts](https://azure.microsoft.com/free/storage). Azure Storage stores diagnostic events stream data from Stream Analytics.
* [Azure HDInsight](https://azure.microsoft.com/free/hdinsight). HDInsight helps you process massive amounts of data in an easy, fast, and cost-effective way. This solution has Azure Data Factory using HDInsight to run Hive queries to process data and load it into Azure SQL Database, but others can also use Azure Databricks.
* [Data Factory](https://azure.microsoft.com/services/data-factory). Data Factory uses HDInsight to process data and load it into Azure SQL Database.
* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics). Azure Synapse Analytics is used to store and data processed by Data Factory and HDInsight and is accessed by Power BI for analysis of the telemetry data.
* [Power BI](https://powerbi.microsoft.com). Power BI is used to create data visualizations for reporting needs. This solution uses Power BI, but others use [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded) to analyze the telemetry data.

## Scenario details

This solution is built on the Azure managed services: [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), [Storage Accounts](https://azure.microsoft.com/services/storage), [HDInsight](https://azure.microsoft.com/services/hdinsight), [Data Factory](https://azure.microsoft.com/services/data-factory), [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, which allows you to focus on your solution instead of the environment it runs in.

### Potential use cases

This solution is ideal for the automotive, manufacturing, and insurance/finance industries. Organizations can utilize predictive insights to determine when vehicle maintenance needs to be done and when to refurbish their fleet of company vehicles.

## Next steps

* [What is Azure Event Hubs?](/azure/event-hubs/event-hubs-about)
* [Welcome to Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
* [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
* [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
* [What is Azure Data Factory?](/azure/data-factory/introduction)
* [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
* [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resources

* [Demand Forecasting](./demand-forecasting.yml)
* [Oil and gas tank level forecasting](./oil-and-gas-tank-level-forecasting.yml)
* [Predicting Length of Stay in Hospitals](/azure/architecture/example-scenario/digital-health/predict-patient-length-of-stay)
* [Predictive Aircraft Engine Monitoring](./aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)
