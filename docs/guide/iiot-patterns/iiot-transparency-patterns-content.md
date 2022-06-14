Transparency builds on top of [visibility patterns](./iiot-visibility-patterns.yml) and enables contextual data processing. It helps build the data hierarchy for enabling digital twins and also enables consistent business KPI calculation flow.

This article contains a common transparency pattern for industrial solutions.

## Business KPI calculation engine

Calculate business metrics using IoT telemetry and other business systems data.

:::image type="content" source="images/oee.png" alt-text="Diagram that shows how to calculate overall equipment effectiveness using Azure Synapse and Azure Data Explorer.":::

- Dataflow
    1. edgeHub sends the machine availability data to Azure IoT Hub or Azure IoT Central using AMQP or MQTT. IoT Hub or Azure IoT Central sends module updates to the edge and provides an edge management control plan.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Explorer dashboards use KQL query language to fetch the data from the cluster and build a near real-time dashboard around machine availability.
    4. Data from IoT Hub or Azure IoT Central is pushed to an Azure Data Lake Storage data lake by using message routing in IoT Hub or data export in Azure IoT Central for long term storage and processing.
    5. An Azure Synapse Analytics pipeline fetches the production quality data—after every shift—from on-premises system.
    6. The Azure Synapse pipeline stores the data in the data lake for calculation.
    7. The Azure Synapse pipeline executes PySpark code, which contains the overall equipment effectiveness (OEE) calculation business logic.
    8. The PySpark code fetches the machine availability data from Azure Data Explorer, and then calculates the availability.
    9. The PySpark code fetches the production quality data from Data Lake Storage, and then calculates quality, performance, and OEE per shift.
    10. The PySpark code stores the OEE data in Azure SQL Database.
    11. Power BI connects with SQL Database for reporting and visualization.

- Use this pattern when:
  - You're using Azure Synapse for data fabric aspects like data lake, data pipeline management, serverless data processing, data warehousing, and data governance.
  - You need to combine both real-time and batch data pipelines and perform business KPI calculations.
  - You need to standardize KPI calculations across factories and business units.

- Considerations
  - [Data flows in Azure Synapse](/azure/synapse-analytics/concepts-data-flow-overview)
  - [Azure Data Explorer (Kusto) spark connector](/azure/synapse-analytics/quickstart-connect-azure-data-explorer)
  - For less compute intensive and serverless calculation engine, consider using Azure Functions instead of Azure Synapse spark pool.

- Deployment Sample
  - [Overall equipment effectiveness (OEE) and KPI calculation engine](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/3_OEECalculationEngine)

## Next steps

- [Industrial IoT patterns overview](./iiot-patterns-overview.yml)

- [Industrial IoT connectivity patterns](./iiot-connectivity-patterns.yml)

- [Industrial IoT visibility patterns](./iiot-visibility-patterns.yml)

- [Industrial IoT prediction patterns](./iiot-prediction-patterns.yml)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
