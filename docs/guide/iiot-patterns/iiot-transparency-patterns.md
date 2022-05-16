Transparency builds on top of [visibility patterns](./iiot-patterns-visibility-patterns.yml) and enables contextual data processing. It helps build the data hierarchy for enabling digital twins and also enables consistent business KPI calculation flow.

Following section includes common transparency patterns for industrial solutions. 

## Business KPI Calculation Engine

Calculate business metrics using IoT telemetry and other business system(s) data

![Calculate Overall Equipment Effectiveness using Synapse and Data Explorer](images/oee.png)

- Dataflow
    1. EdgeHub sends the machine availability data to IoT Hub/ Central using AMQP or MQTT.
    1. Data from IoT Hub / Central goes to Data Explorer using Data Connection in IoT Hub or Data Export in IoT Central.
    1. Data Explorer dashboards use kql query langauge to fetch the data from the cluster and build near real-time dashboard around machine availability.
    1. Data from IoT Hub / Central is pushed to a Data Lake using message routing in IoT Hub and Data Export in IoT Central, for long term storage and processing.
    1. Synapse pipeline fetches the production quality data (after every shift) from on-premises system and stores the data in the Data Lake.
    1. Synapse pipeline executes pyspark code, which contains the Overall equipment effectiveness (OEE) calculation business logic.
    1. The pyspark code fetches the machine availability data from Data Explorer, and calculates Availabiltiy
    1. The pyspark code fetches the production quality data from Data Lake, and calculates Quality, Performance and OEE per shift.
    1. The pyspark code stores the OEE data in a SQL Database.
    1. PowerBI is connected with SQL Database for reporting and visualization.

- Use this pattern when:
    - Using Synapse Analytics for data fabric aspects like data lake, data pipeline management, serverless data processing, data warehousing, data governace. 
    - Need to combine both real-time and batch data pipelines and perform business KPI calculations.
    - Standardize KPI calculations across factories and business units.
    
- Considerations
    - [Data flows in Synapse Analytics](/azure/synapse-analytics/concepts-data-flow-overview)
    - [Data Explorer (Kusto) Spark connector](/azure/synapse-analytics/quickstart-connect-azure-data-explorer)
    - For less compute intentive and serverless calculation engine, consider using Functions instead of Synapse spark pool 
    
- Deployment Sample
    - [Overall Equipment Effectiveness (OEE) and KPI Calculation Engine](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/3_OEECalculationEngine)


## Next steps

- [Industrial IoT Patterns Overview](./iiot-patterns-overview.md)

- [Industrial IoT Connectivity Patterns](./iiot-connectivity-patterns.md)

- [Industrial IoT Visibiilty Patterns](./iiot-visibility-patterns.md)

- [Industrial IoT Prediction Patterns](./iiot-prediction-patterns.md)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)