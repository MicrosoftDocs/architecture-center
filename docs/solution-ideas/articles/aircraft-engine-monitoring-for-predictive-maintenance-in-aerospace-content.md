[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Azure's Predictive Maintenance solution demonstrates how to combine real-time aircraft data with analytics to monitor aircraft health.

This solution is built with [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics), [Event Hubs](https://azure.microsoft.com/services/event-hubs), [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning), [HDInsight](https://azure.microsoft.com/services/hdinsight), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Data Factory](https://azure.microsoft.com/services/data-factory), and [Power BI](https://powerbi.microsoft.com). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

:::image type="content" source="../media/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.svg" alt-text="Architecture diagram: aircraft engine monitoring for predictive aircraft maintenance with Azure." lightbox="../media/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/aircraft-engine-monitoring-for-predictive-maintenance.vsdx) of this architecture.*

### Components

* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) provides near real-time analytics on the input stream from Azure Event Hubs. Input data is filtered and passed to a Machine Learning endpoint, finally sending the results to the Power BI dashboard.
* [Event Hubs](https://azure.microsoft.com/services/event-hubs) ingests raw assembly-line data and passes it on to Stream Analytics.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) predicts potential failures based on real-time assembly-line data from Stream Analytics.
* [HDInsight](https://azure.microsoft.com/services/hdinsight) runs Hive scripts to provide aggregations on the raw events that were archived by Stream Analytics.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database) stores prediction results received from Machine Learning and publishes data to Power BI.
* [Data Factory](https://azure.microsoft.com/services/data-factory) handles orchestration, scheduling, and monitoring of the batch processing pipeline.
* [Power BI](https://powerbi.microsoft.com) enables visualization of real-time assembly-line data from Stream Analytics and the predicted failures and alerts from Data Warehouse.

## Scenario details

### Potential use cases

This solution is ideal for the aircraft and aerospace industries.

With the right information, it's possible to determine the condition of equipment in order to predict when maintenance should be performed. Predictive maintenance can be used for the following items:

* Real-time diagnostics.
* Real-time flight assistance.
* Prognostics.
* Cost reduction.

## Next steps

See product documentation:

* [Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [HDInsight](/azure/hdinsight)
* [SQL Database](/azure/sql-database)
* [Azure Data Factory](/azure/data-factory/data-factory-introduction)
* [Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)

## Related resources

Read other Azure Architecture Center articles about predictive maintenance and prediction with machine learning:

* [Predictive maintenance](./predictive-maintenance.yml)
* [Predictive maintenance for industrial IoT](./iot-predictive-maintenance.yml)
* [Predictive marketing with machine learning](./predictive-marketing-campaigns-with-machine-learning-and-spark.yml)
* [Predict length of stay and patient flow](/azure/architecture/example-scenario/digital-health/predict-patient-length-of-stay)