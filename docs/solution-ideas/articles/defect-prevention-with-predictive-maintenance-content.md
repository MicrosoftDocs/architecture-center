[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article shows you how to use Azure Machine Learning and Azure Synapse Analytics to predict failures before they happen with real-time assembly line data.

## Architecture

:::image type="content" alt-text="Architecture diagram: defect prevention with predictive maintenance." source="../media/defect-prevention-with-predictive-maintenance.png" lightbox="../media/defect-prevention-with-predictive-maintenance.png":::

*Download a [Visio file](https://arch-center.azureedge.net/defect-prevention-with-predictive-maintenance.vsdx) of this architecture.*

### Components

* [Event Hubs](https://azure.microsoft.com/services/event-hubs) ingests raw assembly-line data and passes it on to Azure Stream Analytics.
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) provides near real-time analytics on the input stream from Event Hubs. Input data is filtered and passed to an Azure Machine Learning endpoint. Results of machine learning are sent to a Power BI dashboard.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) predicts potential failures based on real-time assembly-line data from Stream Analytics.
* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) stores assembly-line data along with failure predictions.
* [Power BI](https://powerbi.microsoft.com) enables visualization of real-time assembly-line data from Stream Analytics, and the predicted failures and alerts from Data Warehouse.

## Scenario details

This solution is built on the Azure-managed services described in the preceding [Components](#components) section. These services run in a high-availability environment, patched and supported, which lets you focus on your solution instead of the environment they run in.

### Potential use cases

Industries that benefit from this solution include:

- Manufacturing processes
- Airline maintenance scheduling

## Next steps

See the product documentation:

* [Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Synapse Analytics](/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is)
* [Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)

## Related resources

See the following related Azure Architecture Center articles:

* [Artificial intelligence (AI) Overview](../../data-guide/big-data/ai-overview.md)
* [Predictive maintenance](./predictive-maintenance.yml)
* [Predictive marketing with machine learning](./predictive-marketing-campaigns-with-machine-learning-and-spark.yml)
* [Predictive maintenance for industrial IoT](./iot-predictive-maintenance.yml)
