Transparency builds on top of [visibility patterns](./iiot-visibility-patterns.yml) and enables contextual data processing. It helps build the data hierarchy to enable digital twins and consistent business key performance indicator (KPI) calculation flow.

This article contains a common transparency pattern for industrial solutions.

*Apache®, [Apache Spark](https://spark.apache.org), [PySpark](https://spark.apache.org/docs/latest/api/python), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-patterns-transparency.pptx) for the following patterns.*

## Business KPI calculation engine

Calculate business metrics by using IoT telemetry and other business systems data.

:::image type="content" source="images/overall-equipment-effectiveness.png" alt-text="Diagram that shows how to calculate overall equipment effectiveness by using Azure Synapse and Azure Data Explorer." lightbox="images/overall-equipment-effectiveness.png":::

- Dataflow:
    1. The edgeHub module sends the machine availability data to Azure IoT Hub or Azure IoT Central by using advanced message queuing protocol (AMQP) or MQTT. IoT Hub or Azure IoT Central sends module updates to the edge and provides an edge management control plan.
    2. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.
    3. Azure Data Explorer dashboards use Kusto Query Language (KQL) to fetch the data from the cluster and build a near real-time dashboard around machine availability.
    4. Data from IoT Hub or Azure IoT Central is pushed to Azure Data Lake Storage by using message routing or data export. Data Lake Storage provides long-term storage and processing.
    5. An Azure Synapse Analytics pipeline fetches the production quality data—after every shift—from an on-premises system.
    6. The Azure Synapse pipeline stores the data in the data lake for calculation.
    7. The Azure Synapse pipeline runs PySpark code, which contains the overall equipment effectiveness (OEE) calculation business logic.
    8. The PySpark code fetches the machine availability data from Azure Data Explorer, and then calculates the availability.
    9. The PySpark code fetches the production quality data from Data Lake Storage, and then calculates quality, performance, and OEE per shift.
    10. The PySpark code stores the OEE data in Azure SQL Database.
    11. Power BI connects with SQL Database for reporting and visualization.

- Use this pattern when:
  - You're using Azure Synapse for data fabric aspects like data lake management, data pipeline management, serverless data processing, data warehousing, and data governance.
  - You need to combine both real-time and batch data pipelines and perform business KPI calculations.
  - You need to standardize KPI calculations across factories and business units.

- Considerations:
  - For more information on data flows, see [Data flows in Azure Synapse](/azure/synapse-analytics/concepts-data-flow-overview).
  - For more information on spark connectors, see [Azure Data Explorer (Kusto) spark connector](/azure/synapse-analytics/quickstart-connect-azure-data-explorer).
  - For a less compute intensive and serverless calculation engine, use [Azure Functions](https://azure.microsoft.com/en-us/services/functions) instead of an Azure Synapse spark pool.

- Deployment sample:
  - [OEE and KPI calculation engine](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/3_OEECalculationEngine)

## Next steps

- [Integrate SQL and Apache Spark pools in Azure Synapse Analytics](/training/modules/integrate-sql-apache-spark-pools-azure-synapse-analytics)
- [Introduction to Azure IoT Hub](/training/modules/introduction-to-iot-hub)
- [Introduction to Azure Synapse Analytics](/training/modules/introduction-azure-synapse-analytics)

## Related resources

- [Industrial IoT patterns overview](./iiot-patterns-overview.yml)
- [Industrial IoT connectivity patterns](./iiot-connectivity-patterns.yml)
- [Industrial IoT visibility patterns](./iiot-visibility-patterns.yml)
- [Industrial IoT prediction patterns](./iiot-prediction-patterns.yml)
- [Solutions for the manufacturing industry](../../industries/manufacturing.md)
- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
