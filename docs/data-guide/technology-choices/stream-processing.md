---
title: Choose a stream processing technology
description: Compare options for real-time message stream processing in Azure, with key selection criteria and a capability matrix.
author: pratimav0420
ms.author: prvalava
categories: azure
ms.date: 11/06/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-databricks
  - azure-app-service
ms.custom:
  - guide
---

<!-- cSpell:ignore HDFS -->
# Choose a stream processing technology in Azure

This article compares technology choices for real-time stream processing in Azure.

# What is streaming data

Organizations often have variety of data sources simultaneously emitting messages, records, or data ranging from a few bytes to several megabytes (MB). Streaming data is emitted at high volume in a continuous, incremental manner with the goal of low-latency processing. This type of data includes changes coming from applications, locations, events, and sensor information that companies use for real-time analytics and visibility into various aspects of their business.

# Streaming Data Characteristics

- Imperfect Data Integrity

  Temporary errors at the source may result in  missing data elements. Guaranteeing data consistency is challenging due to the continuous nature of the stream, so stream processing and analytics systems typically include logic for data validation to mitigate these errors.

- Continous data flow
  
  A data stream has no beginning or end, collecting data constantly is required. For example, server activity logs accumulate as long as the server runs

- Nonhomogeneous Data Formats
  
  Data may be streamed in multiple formats, such as JSON, Avro, and CSV, with various data types including strings, numbers, dates, and binary types. Stream processing systems must handle these data variations.

- Data Order 
  
  Individual elements in a data stream contain timestamps, and the data stream itself may be time-sensitive with diminished significance after a specific interval. In certain cases, there would be a need to preserve the order in which data gets processed.

## What are your options when choosing a technology for real-time processing?

Inorder to choose the right technology lets start exploring te different options we have across the stack from ingestion to consumption. Below, we have provided options segmented by using a highlevel stream processing flow.

# Highlevel Stream processing flow

[![A diagram that shows the dataflow for the end-to-end data processing solution.](../images/StreamProcessing.svg)](../images/StreamProcessing.svg#lightbox)

- ## Stream Producers

  Streaming producers are responsible for generating and pushing data into Azure's ingestion services. They continuously produce data from external sources like IoT devices, application logs, or databases.

- Key Considerations:

  - Capturing Real-time Data: Producers continuously collect data from sources such as IoT devices, user interactions, and application logs, streaming it into Azure services like Event Hubs or IoT Hub.
  - Optimizing Throughput with Batching & Compression: Producers enhance efficiency by batching messages and applying compression to minimize data size during transmission.
   - Ensuring Reliable Transmission with Error Handling & Retries: Producers in Azure Event Hubs are equipped to manage network disruptions or broker failures through automatic retries, ensuring dependable data delivery.
  - Guaranteeing Data Integrity with Idempotence: Producers can be configured to support exactly-once delivery, preventing duplicate messages and ensuring consistent data flow.

*Azure databases such as SQLDB and CosmosDB support Change data capture. This data has to be read using connectors such as debezium  or change feed for CosmosDB hosted on fuctions or App service enviroments. 

** Debezium can be hosted as stand alone applcations on managed services such as (AKS, Azure App service environments)

### General capabilities

| Capability | Azure IOT Hub  | CDC Producers |Custom Applications|
| --- | --- | --- | --- | 
| Device Telemetry | Yes | No | No | 
| Managed Service | Yes | No* | No* | 
| Scalability | Yes | Yes** | Yes** | 


- ## Stream Ingestion
  
  Data that is continuously generated from producers like web and mobile applications, IoT devices, and sensors must be ingested efficiently into the stream processing pipeline for real-time and batch analysis.

- Key Considerations:
  
    - Data Velocity: High-frequency data arrival from multiple sources, format compatability and size
    - Scalability: Ability to scale ingestion buffer as data volume, variety and veocity grows.
    - Data Integrity & Reliability: Ensuring data is not lost or duplicated during transmission.

### General capabilities

| Capability | Azure Event Hubs  | Kafka on HdInsight | Confluent Kafka|
| --- | --- | --- | --- | 
| Message retention | Yes | Yes | Yes | 
| Managed Service | Yes | Managed Iaas | Yes | 
| Auto Scale | Yes | Yes | Yes | 
| Pricing model | [Based on Tier](https://azure.microsoft.com/en-us/pricing/details/event-hubs/) | [Per Cluster Hour]() | [Consumption models](https://azuremarketplace.microsoft.com/en/marketplace/apps/confluentinc.confluent-cloud-azure-prod?tab=PlansAndPrice) |
| Partner Offering | No | No | Yes |

- ## Stream Processing

  This step involves real-time transformation, filtering, aggregating, enriching, or analytics on the ingested data.

- Key Considerations:

  - Stateful vs Stateless Processing: Deciding between processing that depends on previously seen data (stateful) versus independent events (stateless).
  - Windowing: Managing time-based aggregations and analytics using sliding or tumbling windows.
  - Fault Tolerance: Ensuring the system can recover from failures without losing data or processing steps.

  ### General capabilities

| Capability |Stream Analytics | * Spark Structured Streaming (Fabric, Databricks, Synapse) | Azure Functions|
| --- | --- | --- | --- | 
| Stateful Processing | Yes | Yes | Yes | 
| Check Pointing | Yes | Managed Iaas | Yes | 
| Scalability |  | Yes** | Yes** | Yes|
| Pricing model | [Streaming Units](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-streaming-unit-consumption) | Yes** | Yes** |


- ## Streaming Sinks

  After data has been processed, it needs to be directed to appropriate destinations (sinks) where it can be stored, analyzed further, or used in real-time applications. These destinations may include databases, data lakes, analytics tools, or dashboards for visualization.

- Key Considerations:

  - Data Consumption and Usage: For real-time analytics or reporting dashboards, Power BI is highly integrated and allows live visualizations of data streams.
  - Low-Latency Requirements: Many systems will need to efficiently provide analytics over real-time data streams such as device telemetry, application logs. There may be other applications that need ultra-low latency reads and writes, suitable for operational analytics or real-time applications.
  - Scalability & Volume: Requirements for ingesting large volume of data, providing compatibility for various formats and need to scale cost-effectively.

### General capabilities

| Capability |Azure Datalake Storage | Fabric Event Store | CosmosDB|SQLDB|
| --- | --- | --- | --- | --| 
| General purpose object store | Yes | No | No | No|
| Streaming data aggregations | No | Yes | No | No|
| Low latency reads and writes for Json docuemnts | No | Yes | Yes | No|
| Structured data aggregations for PowerBI | No | Yes | No | Yes|
| Pricing model | Per GB/TB | [Fabric SKU](https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/) | [Request Units](https://learn.microsoft.com/en-us/azure/cosmos-db/request-units) |[DTU/Vcpus](https://azure.microsoft.com/en-us/pricing/details/azure-sql-database/single/)|


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Pratima Valavala]() | Principal Solution Architect

## Next steps

- [App Service overview](/azure/app-service/overview)
- [Explore Azure Functions](/training/modules/explore-azure-functions)
- [Get started with Azure Stream Analytics](/training/modules/introduction-to-data-streaming)
- [Perform advanced streaming data transformations](/training/modules/perform-advanced-streaming-data-transformations-with-spark-kafka)
- [Set up clusters in HDInsight](/azure/hdinsight/hdinsight-hadoop-provision-linux-clusters)
- [Use Apache Spark in Azure Databricks](/training/modules/use-apache-spark-azure-databricks)

## Related resources

- [Real time processing](../big-data/real-time-processing.yml)
- [Stream processing with Azure Stream Analytics](../../reference-architectures/data/stream-processing-stream-analytics.yml)

[dotnet-spark]: https://github.com/dotnet/spark
