---
title: Choose a Stream Processing Technology
description: Compare options for real-time message stream processing in Azure, with key selection criteria and a capability matrix.
author: pratimav0420
ms.author: prvalava
ms.date: 06/06/2025
ms.topic: conceptual
ms.subservice: architecture-guide
---

<!-- cSpell:ignore HDFS -->
# Choose a stream processing technology in Azure

This article compares technology choices for real-time stream processing in Azure.

## Streaming data overview

Organizations often have various data sources that simultaneously emit messages, records, or data. The amount of data can range from a few bytes to several megabytes (MB). Streaming data is emitted at high volume in a continuous, incremental manner that can be processed in near real-time. This type of data includes information that companies use for real-time analytics and visibility into various aspects of their business, such as application logs, geolocation updates, events, and sensor readings.

Streaming data often has the following characteristics:

- **Imperfect data integrity:** Temporary errors at the source might result in missing data elements. The continuous nature of the stream can introduce data inconsistency. So stream processing and analytics systems typically include logic for data validation to mitigate these errors.

- **Continuous dataflow:** A data stream has no beginning or end, so you have to constantly collect data. For example, server activity logs accumulate as long as the server runs.

- **Diverse data formats:** You might stream data in multiple formats, such as JSON, Avro, and CSV. And it might include various data types, such as strings, numbers, dates, and binary types. Stream-processing systems must handle these data variations.

- **Time-sensitive data order:** Individual elements in a data stream contain timestamps. And the data stream itself might be time-sensitive and lose value after a specific time. In some cases, you need to preserve the data processing order.

## Technology options for real-time processing

To help you choose the right technology, this section outlines common options in Azure, from ingestion to consumption. Each subsection highlights recommended technologies based on their role within the streaming processing flow.

### High-level stream processing flow

:::image type="complex" source="../images/stream-processing.svg" alt-text="A diagram that shows the dataflow for the end-to-end data processing solution." lightbox="../images/stream-processing.svg" border="false":::
The flow starts with mobile apps and customer-facing apps. Step 1 is labeled stream producers. It includes three subsections. The subsection labeled device endpoint telemetry contains Azure IoT Hub and Azure IoT Edge. The subsection labeled CDC generated from databases contains Azure Cosmos DB and Azure SQL Database. These two subsections point to step 2. The subsection labeled telemetry and events from custom applications contains Azure Kubernetes Service (AKS) and Azure Functions. This subsection points to the line that goes from the first two subsections to step 2. Step 2 is labeled stream ingestion. It contains Azure Event Hubs, Azure Event Grid, Kafka on HDInsight, and Kafka on Confluent. This step points to step 3, which is labeled stream processing. It contains Azure Stream Analytics, Fabric eventstream, and Azure Functions. It includes a subsection labeled Spark Structured Streaming, which contains Microsoft Fabric, Azure Synapse Analytics, and Azure Databricks. Step 3 points to step 4, which is labeled streaming sinks. This step contains Azure Data Explorer, Azure Cosmos DB, Azure Blob Storage, One Lake, and Fabric eventhouse.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/stream-processing.vsdx) of this architecture.*

### Stream producers

Stream producers generate and push data into Azure ingestion services. They continuously produce data from sources like Internet of Things (IoT) devices, application logs, or databases.

Stream producers provide the following benefits:

- **Capture near real-time data.** Producers can continually collect data from sources such as IoT devices, user interactions, and application logs. They stream the data into Azure services like Azure Event Hubs or Azure IoT Hub.

- **Optimize throughput with batching and compression.** Producers can batch messages and apply compression to minimize data size during transmission. These capabilities enhance efficiency.
- **Ensure reliable transmission with error handling and retries.** Producers can manage network disruptions or broker failures through automatic retries to ensure dependable data delivery.
- **Guarantee data integrity with idempotence.** You can configure producers to support *exactly once delivery*, which prevents duplicate messages and ensures a consistent dataflow.

#### Components

- [IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) ingests IoT data. It provides features like bi-directional communication, device authentication, and offline message buffering. It's ideal for managing IoT devices and their data streams.

- [Change data capture (CDC)](/sql/relational-databases/track-changes/about-change-data-capture-sql-server) producers include Azure databases such as [Azure SQL Database](/azure/azure-sql/database/change-data-capture-overview) and [Azure Cosmos DB](/azure/cosmos-db/change-feed).

  To access CDC data, you can use connectors, such as Debezium for SQL Database or the Azure Cosmos DB change feed. These connectors are often hosted on Azure Functions or Azure App Service environments. If you use the Microsoft Fabric eventstreams feature, you don't need separate applications, such as Debezium, to connect CDC producers with downstream consumers.

- [Custom applications](/azure/well-architected/service-guides/app-service-web-apps) like Debezium can also be hosted as standalone applications on managed services, such as Azure Kubernetes Service (AKS) or App Service environments. This approach provides more control or customization.

#### General capabilities

| Capability | IoT Hub  | CDC producers |Custom applications|
| --- | --- | --- | --- | 
| Device telemetry | Yes | No | No | 
| Managed service | Yes | No | No | 
| Scalability | Yes | Yes | Yes | 

### Stream ingestion
  
Producers, such as web and mobile applications, IoT devices, and sensors, continuously generate data. The stream processing pipeline must efficiently ingest this data for real-time and batch analysis.

Consider the following factors:
  
- **Data velocity:** Determine how to handle high-frequency data from multiple sources, which often varies in format and size.

- **Scalability:** Ensure that the ingestion layer can scale dynamically as data volume, variety, and velocity increase.
- **Data integrity and reliability:** Prevent data loss or duplication during transmission.

#### Components

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a real-time data ingestion service that can handle millions of events per second, which makes it ideal for high-throughput scenarios. It can scale dynamically and process massive volumes of data with low latency.

  Event Hubs supports features like partitioning for parallel processing and data retention policies. It integrates with Azure services like Azure Stream Analytics, Fabric, Azure Databricks, and Azure Functions. Event Hubs also integrates with Apache Kafka, and you can run existing Kafka workloads without any code changes.

- [Event Grid](/azure/well-architected/service-guides/event-grid/operational-excellence) is a fully managed event-routing service. It ingests, distributes, and reacts to events from various sources, so it's ideal for real-time, event-driven architectures. It efficiently handles event notifications and integrates with Azure services, custom applications, and partner systems. Event Grid plays a critical role in stream ingestion.

- [Kafka on Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is a managed Apache Kafka service for real-time data ingestion and processing at scale. Use this service to capture and store streaming data from various sources, such as IoT devices, application logs, and social media feeds. This service provides extra control of a Kakfa configuration on a managed infrastructure.

- [Apache Kafka on Confluent Cloud](/azure/partner-solutions/apache-kafka-confluent-cloud/overview) is a fully managed Apache Kafka service for real-time data ingestion. It integrates with Azure to simplify deployment and scaling. This solution includes features like schema registry, ksqlDB for stream queries, and enterprise-grade security. Use this option if you use Confluent's extended ecosystem of connectors and stream processing tools.

#### General capabilities

| Capability | Event Hubs  | Kafka on HDInsight | Kafka on Confluent|
| --- | --- | --- | --- | 
| Message retention | Yes | Yes | Yes | 
| Message size limit| 1 MB | Configurable | Configurable |
| Managed service | Yes | Managed infrastructure as a service | Yes | 
| Autoscale | Yes | Yes | Yes | 
| Partner offering | No | No | Yes |
| Pricing model | [Based on tier](https://azure.microsoft.com/pricing/details/event-hubs/) | [Per cluster hour](https://azure.microsoft.com/pricing/details/hdinsight/) | [Consumption models](https://azuremarketplace.microsoft.com/marketplace/apps/confluentinc.confluent-cloud-azure-prod?tab=PlansAndPrice) |

### Stream processing

This step involves processes that transform data in real-time and filter, aggregate, enrich, or analyze ingested data.

Consider the following factors:

- **Stateful versus stateless processing:** Decide whether your processing depends on previously seen data (stateful) or independent events (stateless).

- **Event time handling:** Account for scenarios where you must process data streams from multiple sources together, especially for late-arriving records.
- **Windowing:** Use sliding or tumbling windows to manage time-based aggregations and analytics.
- **Fault tolerance:** Ensure that the system can recover from failures without data loss or reprocessing errors.

#### Components

- [Stream Analytics](/azure/stream-analytics/stream-analytics-introduction) is a managed service that uses a SQL-based query language to enable real-time analytics. Use this service for simple processing tasks like filtering, aggregating, and joining data streams. It integrates seamlessly with Event Hubs, IoT Hub, and Azure Blob Storage for input and output. Stream Analytics best suits low-complexity, real-time tasks where a simple, managed solution with SQL-based queries is sufficient.

- [Spark Structured Streaming](https://spark.apache.org/streaming/) is supported by services such as [Fabric](/azure/well-architected/service-guides/iot-hub/reliability), [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security), and [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is). These services provide a unified analytics platform that's built on Apache Spark and can handle complex data transformations, machine learning pipelines, and big data workloads. Spark streaming APIs support deep integration with Delta Lake for data versioning and consistency.

- [Fabric eventstreams](/fabric/real-time-intelligence/event-streams/overview) is a real-time data streaming capability within Fabric, which is a unified analytics platform. Eventstreams enables seamless ingestion, processing, and integration of streaming data for real-time analytics and applications. Users can access eventstreams with minimal technical expertise. It provides drag-and-drop interfaces to set up data pipelines.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a  serverless compute service for event-driven processing. It's useful for lightweight tasks, like transforming data or triggering workflows based on real-time events. Azure functions are stateless by design. The durable functions feature extends capabilities to support stateful workflows for complex event coordination.

#### General capabilities

| Capability | Stream Analytics | Spark Structured Streaming (Fabric, Azure Databricks, Azure Synapse Analytics) | Fabric eventstreams| Azure Functions|
| --- | --- | --- | --- | --- | 
| Micro-batch processing| Yes | Yes | Yes| No | 
| Event-based processing| No | No | Yes| Yes | 
| Stateful processing | Yes | Yes | Yes| No | 
| Support for check pointing | Yes | Yes | Yes| No |
| Low-code interface | Yes| No | Yes | No | 
| Pricing model | [Streaming units](/azure/stream-analytics/stream-analytics-streaming-unit-consumption) | Yes | [Fabric SKU](https://azure.microsoft.com/pricing/details/microsoft-fabric/)| Yes |

### Streaming sinks

After the system processes the data, it directs the data to appropriate destinations, or *sinks*, for storage, further analysis, or use in real-time applications. These destinations can include databases, data lakes, analytics tools, or dashboards for visualization.

Consider the following factors:

- **Data consumption and usage:** Use Power BI for real-time analytics or reporting dashboards. It integrates well with Azure services and provides live visualizations of data streams.

- **Low-latency requirements:** Determine whether your system must deliver analytics on real-time data streams, such as device telemetry and application logs. Some applications might also require ultra-low latency for reads and writes, which makes them suitable for operational analytics or real-time applications.
- **Scalability and volume:** Assess your workload's need to ingest large volumes of data, support diverse data formats, and scale efficiently and cost-effectively.

#### Components

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable, distributed, and cost-effective solution for storing unstructured and semi-structured data. It supports petabyte-scale storage and high-throughput workloads for storing large volumes of streaming data. It also enables fast read and write operations, which support analytics on streaming data and real-time data pipelines.

- A [Fabric eventhouse](/fabric/real-time-intelligence/eventhouse) is a KQL database for real-time analytics and exploration on vent-based data, such as telemetry and log data, time-series data, and IoT data. It supports ingestion of millions of events per second with low latency. This feature enables near-instant access to streaming data. An eventhouse deeply integrates with the Fabric ecosystem. It enables users to query and analyze streaming data immediately by using tools like Power BI.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a NoSQL database for low-latency, globally distributed, and highly scalable data storage. It's compatible with multiple APIs, such as SQL, MongoDB, Cassandra, Table, and Gremlin, which provides flexibility for diverse applications. Azure Cosmos DB delivers high throughput and can handle large volumes of streaming data with consistent performance.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed, cloud-based relational database service. It's built on the SQL Server engine. So it provides the capabilities of a traditional SQL Server database with the benefits of cloud-based scalability, reliability, and reduced management overhead. 

#### General capabilities

| Capability | Data Lake Storage | Fabric eventhouse | Azure Cosmos DB|SQL Database|
| --- | --- | --- | --- | --- | 
| General purpose object store | Yes | No | No | No|
| Streaming data aggregations | No | Yes | No | No|
| Low-latency reads and writes for JSON documents | No | Yes | Yes | No|
| Structured data aggregations for Power BI | No | Yes | No | Yes|
| Pricing model | Per GB or TB | [Fabric SKU](https://azure.microsoft.com/pricing/details/microsoft-fabric/) | [Request units](/azure/cosmos-db/request-units) |[Database transaction unit (DTU) or vCore](https://azure.microsoft.com/pricing/details/azure-sql-database/single/)|

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Pratima Valavala](https://www.linkedin.com/in/pratimavalavala) | Principal Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Fabric Eventhouse](/fabric/real-time-intelligence/eventhouse)
- [Fabric](/azure/well-architected/service-guides/iot-hub/reliability)
- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)

Explore the following training modules:
- [Explore Azure Functions](/training/modules/explore-azure-functions)
- [Get started with Stream Analytics](/training/modules/introduction-to-data-streaming)
- [Perform advanced streaming data transformations](/training/modules/perform-advanced-streaming-data-transformations-with-spark-kafka)
- [Use Apache Spark in Azure Databricks](/training/modules/use-apache-spark-azure-databricks)

## Related resource

- [Stream processing with Stream Analytics](../../reference-architectures/data/stream-processing-stream-analytics.yml)
