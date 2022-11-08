Visibility helps manufacturers gain insight and drive decision making to improve quality, safety, and efficiency. It involves visualizing and correlating IoT data with multiple other business systems including process historians, manufacturing execution systems (MES), enterprise resource planning (ERP), and quality management systems. This data directly impacts the business value of metrics like overall equipment effectiveness (OEE), energy costs, machine downtime, and labor efficiency.

The following section includes common visibility patterns for industrial solutions.

*Grafana is a trademark of its respective company. No endorsement is implied by the use of this mark.*

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-patterns-visibility.pptx) for the following patterns.*

## Time series analysis

Analyze IoT telemetry data by using time series techniques.

:::image type="content" source="images/time-series-analysis.png" alt-text="Diagram that shows how to analyze time series data by using Azure Data Explorer." lightbox="images/time-series-analysis.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-patterns-visibility.pptx) of this pattern.*

### Dataflow

    1. The edgeHub module sends the data to Azure IoT Hub or Azure IoT Central by using advanced message queuing protocol (AMQP) or MQTT.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Explorer dashboards use Kusto Query Language (KQL) to fetch data from the clusters and build near real-time dashboards.
    4. Power BI or Grafana is used to build custom dashboards with query builder and integrate with other data sources.

### Potential use cases

- Use this pattern when you:
  - Need a time series analysis for large scale Industrial IoT (IIoT) telemetry data.
  - Need real-time dashboards and querying capabilities on the factory floor.
  - Perform univariate anomaly detection and correlation between sensors.

### Considerations

  - IoT Central includes dashboards for basic time series analysis on the last 30 days of data. For analysis on datasets beyond 30 days, use Azure Data Explorer.
  - Azure Data explorer is an append-only platform, which [isn't suitable for data that requires updates or deletions](/azure/data-explorer/data-explorer-overview).
  - For more information on time series analysis, see [Time series analysis in Azure Data Explorer](/azure/data-explorer/time-series-analysis).
  - For more information on streaming ingestion considerations, see [Configure streaming ingestion on your Azure Data Explorer cluster](/azure/data-explorer/ingest-data-streaming?tabs=azure-portal%2Ccsharp).
  - For more information on disaster recovery, see [Disaster recovery configurations for Azure Data Explorer](/azure/data-explorer/business-continuity-overview#disaster-recovery-configurations).
  - For more information on Time Series Insights, see [Migrating to Azure Data Explorer](/azure/time-series-insights/migration-to-adx).

### Deploy this scenario

- Deployment sample:
  - [Operational visibility with anomaly detection and root cause analysis](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/2_OperationalVisibility)

## Anomaly detection and root cause analysis

Detect anomalies and identify a root cause for anomaly incidents.

:::image type="content" source="images/anomaly-detection.png" alt-text="Diagram that shows detection anomalies in time series data and the performance of a root cause analysis by using a metrics advisor." lightbox="images/anomaly-detection.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-patterns-visibility.pptx) of this pattern.*

### Dataflow

    1. The edgeHub module sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Explorer dashboards use KQL to fetch data from the clusters and build near real-time dashboards.
    4. Azure Metrics Advisor fetches data from Azure Data Explorer by using a data feed configuration. It configures the metrics level configuration for anomaly detection and creates an alert that links to a webhook.
    5. The Metrics Advisor web hook connects to an HTTP-triggered logic app. The logic app is called when an anomaly is detected.

### Potential use cases

- Use this pattern when you:
  - Need automatic anomaly detection based on machine learning algorithms and range thresholds.
  - Need a no-code or low-code way to build time series machine learning models.
  - Need anomaly incident management and business action alerts.
  - Perform root cause analysis and correlation mapping.

### Considerations

  - [How-to: Onboard your metric data to Metrics Advisor](/azure/applied-ai-services/metrics-advisor/how-tos/onboard-your-data)
  - [How to: Manage your data feeds](/azure/applied-ai-services/metrics-advisor/how-tos/manage-data-feeds)
  - [Data requirements for Metrics Advisor anomaly detection](/azure/applied-ai-services/metrics-advisor/faq#how-much-data-is-needed-for-metrics-advisor-to-start-anomaly-detection-)
  - [Key points about cost management and pricing for Metrics Advisor](/azure/applied-ai-services/metrics-advisor/cost-management#key-points-about-cost-management-and-pricing)

### Deploy this scenario

- Deployment sample
  - [Operational visibility with anomaly detection and root cause analysis](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/2_OperationalVisibility)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Jomit Vaghela](https://www.linkedin.com/in/jomit) | Principal Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Explore Time Series Insights integration](/training/modules/explore-time-series-insights-integration)
- [Identify abnormal time-series data with Anomaly Detector](/training/modules/identify-abnormal-time-series-data-anomaly-detector)
- [Introduction to Azure Data Explorer](/training/modules/intro-to-azure-data-explorer)

## Related resources

- [Industrial IoT patterns overview](./iiot-patterns-overview.yml)
- [Industrial IoT connectivity patterns](./iiot-connectivity-patterns.yml)
- [Industrial IoT transparency patterns](./iiot-transparency-patterns.yml)
- [Industrial IoT prediction patterns](./iiot-prediction-patterns.yml)
- [Solutions for the manufacturing industry](../../industries/manufacturing.md)
- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
