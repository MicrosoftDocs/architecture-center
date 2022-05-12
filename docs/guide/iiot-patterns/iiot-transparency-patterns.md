Transparency builds on top of visibilty and enables contextual data processing. It helps build the data hierarchy for enabling digital twins and also enables consistent business KPI calculcation flow.

Following section includes common transparency patterns for industrial solutions. 

## Business KPI Calculation Engine

![Overall Equipment Effectiveness](images/oee.png)

- Dataflow
    1. EdgeHub sends the machine availability data to IoT Hub/ Central using AMQP or MQTT.
    1. Data from IoT Hub / Central is pushed to Data Explorer using Data Connection in IoT Hub or Data Export in IoT Central.
    1. Data Explorer dashboards use kql query langauge to fetch the data from the cluster and build near real-time dashboard around machine availability.
    1. Data from IoT Hub / Central is also routed to a Data Lake for long term storage and processing.
    1. Synapse pipeline fetches the production quality data (after every shift) from on-premises system and stores the data in the Data Lake.
    1. Synapse pipeline executes pyspark code, which contains the OEE calculation business logic.
    1. The pyspark code fetches the machine availability data from Data Explorer, and calculates Availabiltiy
    1. The pyspark code fetches the production quality data from Data Lake, and calculates Quality, Performance and OEE per shift.
    1. The pyspark code stores the OEE data in a SQL Database.
    1. PowerBI is connected with SQL Database for reporting and visualization.

- Use this pattern when:
    - Using Synapse Analytics for data fabric aspects like data lake, data pipeline management, serverless data processing, data warehousing, data governace. 
    - Need to combine both real-time and batch data pipelines and perform business KPI calculations.
    - Standardize KPI calculations across factories and business units.
    
- Considerations
    - [Data flows in Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/concepts-data-flow-overview)
    - [Data Explorer (Kusto) Spark connector](https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-connect-azure-data-explorer?toc=/azure/data-explorer/toc.json&bc=/azure/data-explorer/breadcrumb/toc.json)
    - For less compute intentive and serverless calculation engine, consider Functions. 
    
- Deployment Sample
    - [Overall Equipment Effectiveness(OEE) and KPI Calculation Engine](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/3_OEECalculationEngine)


# Next steps

- [Synapse Analytics Overview](https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is)


# Related resources

- [Industrial IoT Connectivity Patterns](./iiot-connectivity-patterns.md)

- [Industrial IoT Visibiilty Patterns](./iiot-visibility-patterns.md)

- [Industrial IoT Prediction Patterns](./iiot-prediction-patterns.md)

- [Solutions for the manufacturing industry](https://docs.microsoft.com/en-us/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/iot/iot-overview)