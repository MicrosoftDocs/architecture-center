


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Azure's Predictive Maintenance solution demonstrates how to combine real-time aircraft data with analytics to monitor aircraft health.

This solution is built on the Azure managed services: [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), [HDInsight](https://azure.microsoft.com/services/hdinsight), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Data Factory](https://azure.microsoft.com/services/data-factory) and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.png)
*Download an [SVG](../media/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.svg) of this architecture.*

## Components

* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics): Stream Analytics provides near real-time analytics on the input stream from the Azure Event Hub. Input data is filtered and passed to a Machine Learning endpoint, finally sending the results to the Power BI dashboard.
* [Event Hubs](https://azure.microsoft.com/services/event-hubs) ingests raw assembly-line data and passes it on to Stream Analytics.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Machine Learning predicts potential failures based on real-time assembly-line data from Stream Analytics.
* [HDInsight](https://azure.microsoft.com/services/hdinsight) runs Hive scripts to provide aggregations on the raw events that were archived by Stream Analytics.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database): SQL Database stores prediction results received from Machine Learning and publishes data to Power BI.
* [Data Factory](https://azure.microsoft.com/services/data-factory) handles orchestration, scheduling, and monitoring of the batch processing pipeline.
* [Power BI](https://powerbi.microsoft.com) visualizes real-time assembly-line data from Stream Analytics and the predicted failures and alerts from Data Warehouse.

## Next steps

* [Learn more about Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Learn more about Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn more about HDInsight](/azure/hdinsight)
* [Learn more about SQL Database](/azure/sql-database)
* [Learn more about Azure Data Factory](/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)