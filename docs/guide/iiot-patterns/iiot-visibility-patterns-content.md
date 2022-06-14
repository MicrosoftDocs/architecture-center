Visibility helps manufacturers gain insight and drive decision-making to improve quality, safety, and efficiency. It involves visualizing and correlating IoT data with multiple other business systems including process historians, manufacturing execution systems (MES), enterprise resource planning (ERP), and quality management systems.This data to impact metrics like Overall Equipment Effectiveness(OEE), energy costs, machine downtime, labor efficiency which directly impacts the business value.

Following section includes common visibility patterns for industrial solutions.

## Time Series Analysis

Analyze IoT telemetry data using time series techniques.

:::image type="content" source="images/time-series-analysis.png" alt-text="Diagram that shows how to analyze time series data by using Azure Data Explorer":::

- Dataflow
    1. edgeHub sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Explorer dashboards use KQL query language to fetch data from the clusters and build near real-time dashboards.
    4. Use Power BI or Grafana to build custom dashboards with query builder and integrate with other data sources.

- Use this pattern when you:
  - Need a time series analysis for large scale Industrial IoT (IIoT) telemetry data.
  - Need real-time dashboards and querying capabilities on the factory floor.
  - Perform univariate anomaly detection and correlation between sensors.

- Considerations
  - IoT Central includes dashboards for basic time series analysis on the last 30 days of data. For analysis on datasets beyond 30 days, use Azure Data Explorer.
  - Azure Data explorer is an append-only platform, which [isn't suitable for data that requires updates or deletions](/azure/data-explorer/data-explorer-overview).
  - [Time Series Analysis in Data Explorer](/azure/data-explorer/time-series-analysis)
  - [Considerations around Streaming Ingestion for Data Explorer](/azure/data-explorer/ingest-data-streaming?tabs=azure-portal%2Ccsharp)
  - [Disaster recovery configurations for Data Explorer](/azure/data-explorer/business-continuity-overview#disaster-recovery-configurations)
  - [Migrating from Time Series Insights (TSI)](/azure/time-series-insights/migration-to-adx)

- Deployment Sample
  - [Operational visibility with anomaly detection and root cause analysis](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/2_OperationalVisibility)

## Anomaly detection and root cause analysis

Detect anomalies and identify a root cause analysis for anomaly incidents.

:::image type="content" source="images/anomaly-detection.png" alt-text="Diagram that shows detection anomalies in time series data and the performance of a root cause analysis by using a metrics advisor.":::

- Dataflow
    1. edgeHub sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Explorer dashboards use KQL query language to fetch data from the clusters and build near real-time dashboards.
    4. Azure Metrics Advisor fetches data from Azure Data Explorer by using a data feed configuration. It configures the metrics level configuration for anomaly detection and an alert that links to a webhook.
    5. The Metrics Advisor web hook connects to an HTTP-triggered logic app, which is called when an anomaly is detected.

- Use this pattern when you:
  - Need automatic anomaly detection based on machine learning algorithms and range thresholds.
  - Need a no code or low code way to build time series machine learning models.
  - Need anomaly incident management and business action alerts.
  - Perform root cause analysis and correlation mapping.

- Considerations
  - [Onboard metric data to Metrics Advisor](/azure/applied-ai-services/metrics-advisor/how-tos/onboard-your-data)
  - [Data feed management for Metrics Advisor](/azure/applied-ai-services/metrics-advisor/how-tos/manage-data-feeds)
  - [Data requirements for Metrics Advisor anomaly detection](/azure/applied-ai-services/metrics-advisor/faq#how-much-data-is-needed-for-metrics-advisor-to-start-anomaly-detection-)
  - [Cost management for Metrics Advisor](/azure/applied-ai-services/metrics-advisor/cost-management#key-points-about-cost-management-and-pricing)

- Deployment Sample
  - [Operational visibility with anomaly detection and root cause analysis](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/2_OperationalVisibility)

## Next steps

- [Industrial IoT patterns overview](./iiot-patterns-overview.yml)

- [Industrial IoT connectivity patterns](./iiot-connectivity-patterns.yml)

- [Industrial IoT transparency patterns](./iiot-transparency-patterns.yml)

- [Industrial IoT prediction patterns](./iiot-prediction-patterns.yml)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
