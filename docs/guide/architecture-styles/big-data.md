---
title: Big Data Architecture Style
description: Learn about big data architectures on Azure with batch processing, real-time analytics, and IoT solutions. Explore benefits and best practices.
author: gurkamaldeep
ms.author: grakhra
ms.date: 12/12/2024
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-data
  - arb-iot
---

# Big data architecture style

A big data architecture is designed to handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.

:::image type="complex" border="false" source="./images/big-data-logical.svg" alt-text="Logical diagram of a big data architecture style." lightbox="./images/big-data-logical.svg":::
   The diagram shows two flow charts that run parallel. In the first flow chart, an arrow points from Data sources to Data storage. Two arrows point from Batch processing. One arrow points to Analytics and reporting. Another arrow points to Analytical data store and then from Analytical data store to Analytics and reporting. In the second flow chart, an arrow points from Data sources to Real-time message ingestion. Two arrows point from Stream processing. One arrow points to Analytical data store and then from Analytical data store to Analytics and reporting. The other arrow points from Stream processing to Analytics and reporting. A section that reads Orchestration spans the two flowcharts.
:::image-end:::

Big data solutions typically include one or more of the following types of workloads:

- Batch processing of big data sources at rest
- Real-time processing of big data in motion
- Interactive exploration of big data
- Predictive analytics and machine learning

Most big data architectures include some or all of the following components:

- **Data sources:** Big data solutions can start with one or more data sources.

  - Data stores, such as relational databases

  - Files that applications produce, such as web server log files and API responses

  - Real-time data sources, such as streaming devices, webhooks, or applications upstream of the relational database

- **Data storage:** Data for batch processing operations is typically stored in a distributed file store that can contain high volumes of large files in various formats. This kind of store is often known as a *data lake*. Options for implementing this storage include Azure Data Lake Storage or Microsoft Fabric OneLake.

- **Batch processing:** When data needs to be prepared for analysis and made available for reports that reflect past events or trends, batch processing is useful. Usually, these jobs involve reading source files, processing them, and writing the output to new files. Options include using data flows or data pipelines in Fabric.

- **Real-time processing:** If the solution includes real-time sources, the architecture must include a way to capture and store real-time messages for stream processing. Data can remain in motion from the moment it's generated through its cleaning, transformation, and eventual use in operational or analytical actions. Many solutions need to support scale-out processing, reliable delivery, and other message queuing semantics. Options include Fabric Real-Time Intelligence eventstreams, Azure Event Hubs, Azure IoT Hub, and Apache Kafka.

- **Analytical data store:** Many big data solutions prepare data for analysis and then serve the processed data in a structured format that can be queried by using analytical tools. Depending on your scenario, the analytical data store used to serve these queries can be an eventhouse in Microsoft Fabric to process data in motion and the stream is processed in flight. Or it could be a dimensional data warehouse, as seen in most traditional business intelligence (BI) solutions or a lakehouse (Bronze, Silver, and Gold). Microsoft Fabric provides several options, such as eventhouses, warehouses, and lakehouses. Each option can be queried by using SQL or Spark, depending on the use case. Use the [Fabric data store decision guide](/fabric/fundamentals/decision-guide-data-store) to help guide your decision.

- **Analysis and reporting:** One of the goals of data solutions should be to provide insights into the data through analysis and reporting. To empower users to analyze the data, the architecture might include a data modeling layer, such as a multidimensional online analytical processing (OLAP) cube or tabular data model in Azure Analysis Services. It might also support self-service BI by using the modeling and visualization technologies in Power BI or Excel. Analysis and reporting can also take the form of interactive data exploration by data scientists or data analysts. For these scenarios, Microsoft Fabric provides tools like notebooks, where users can choose SQL or a programming language of their choice.

- **Actions and alerting:** Another goal of a big data solution should be to provide operational insights into the current state of the business process. The architecture should include an action system layer, which takes real-time streams of data as it's being processed and detects exceptions and anomalies that occur within the organization. Instead of a user checking a report, you can use these alerting systems to proactively notify users and leadership of anomalous activities. Real-Time Intelligence activator alerts provide this kind of proactive monitoring.

- **Orchestration:** Big data solutions can consist of repeated data processing operations encapsulated in workflows. These workflows transform source data, move data between multiple sources and sinks, load the processed data into an analytical data store, or push the results directly to a report or dashboard. To automate these workflows, you can use an orchestration technology such Azure Data Factory or Microsoft Fabric pipelines.

Microsoft provides many services for big data architecture that are grouped roughly into the following categories:

- Software as a service (SaaS) solutions, such as Microsoft Fabric

- Managed services such as Data Lake Storage, Azure Stream Analytics, Event Hubs, IoT Hub, Azure Data Factory, Azure SQL Database, and Azure Cosmos DB
  
## When to use this architecture

Consider this architecture style when you need to take the following actions:

- Act on data in real time as data is being generated.
- Store and process data in volumes too large for a traditional database.
- Transform unstructured data for analysis and reporting.
- Use Azure Machine Learning or Azure AI services.

## Benefits

- **Technology choices:** Microsoft Fabric provides many of these services through a SaaS interface and connects the various components in advance. This approach simplifies the process of building end-to-end data solutions. You can also mix and match Azure managed services to take advantage of existing skills or technology investments.

- **Performance through parallelism:** Big data solutions take advantage of parallelism, which enables high-performance solutions that scale to large volumes of data.

- **Elastic scale:** All of the components in the big data architecture support scale-out provisioning. As a result, you can adjust your solution for small or large workloads and pay only for the resources you use.

- **Interoperability with existing solutions:** The components of the big data architecture are also used for Internet of Things (IoT) processing and enterprise BI solutions. This versatility enables you to create an integrated solution across data workloads.

## Challenges

- **Skillset:** Some big data technologies are highly specialized and rely on frameworks and languages that differ from those used in general application architectures. Alternatively, newer APIs are emerging that build on more established languages.

- **Security:** Big data solutions usually rely on storing all static data in a centralized data lake. Securing access to this data can be challenging, especially when multiple applications and platforms must ingest and consume the data.

## Best practices

- **Use parallelism.** Most big data processing technologies distribute the workload across multiple processing units. This distribution requires static data files to be created and stored in a splittable format. Distributed file systems such as Hadoop Distributed File System (HDFS) can optimize read and write performance. Multiple cluster nodes in parallel perform the actual processing, which reduces overall job times. We recommend that you use a splittable data format, such as Parquet.

- **Partition data.** Batch processing usually occurs on a recurring schedule, such as weekly or monthly. Partition data files and data structures, such as tables, based on temporal periods that align with the processing schedule. This strategy simplifies data ingestion and job scheduling, makes troubleshooting easier, and can significantly improve query performance.

- **Apply schema-on-read semantics.** Using a data lake lets you combine storage for files in multiple formats, whether structured, semi-structured, or unstructured. Apply *schema-on-read* semantics, which project a schema onto data during processing instead of at the time of storage. This approach adds flexibility to the solution and helps prevent bottlenecks during data ingestion that data validation and type checking cause.

- **Process batch data on arrival.** Traditional BI solutions often use an extract, transform, and load (ETL) process to move data into a data warehouse. However, with larger volumes of data and a wider range of formats, big data solutions typically adopt variations of ETL, such as extract, load, and transform (ELT).

- **Process streaming data in flight.** For streaming solutions, transform the payload while the data is being transmitted. Because you're dealing with much smaller packets over the network, it's much easier to transform these smaller rows sets during generation. Land the transformed stream in an engine that's optimized for event-based data, such as a Real-Time Intelligence eventhouse, which makes the data immediately available for action.

- **Balance usage and time costs.** For batch processing jobs, it's important to consider the per-unit cost of the compute nodes and the per-minute cost of using those nodes to complete the job. For example, a batch job might take eight hours with four cluster nodes. However, it might turn out that the job uses all four nodes only during the first two hours, and after that, only two nodes are required. In that case, running the entire job on two nodes increases the total job time but doesn't double it, so the total cost is less. In some business scenarios, a longer processing time might be preferable to the higher cost of using underutilized cluster resources.

- **Separate resources.** When possible, separate resources based on the workloads to avoid scenarios like one workload using all the resources while the other is waiting.

- **Orchestrate data ingestion.** In some cases, existing business applications might write data files for batch processing directly into Azure storage blob containers, where downstream services like Microsoft Fabric can consume them. However, you often need to orchestrate the ingestion of data from on-premises or external data sources into the data lake. Use an orchestration workflow or pipeline, such as those supported by Azure Data Factory or Microsoft Fabric, to achieve predictable and centrally managed data movement.

- **Scrub sensitive data early.** The data ingestion workflow should scrub sensitive data early in the process to avoid storing it in the data lake.

## IoT architecture

IoT is a specialized subset of big data solutions. The following diagram shows a possible logical architecture for IoT. The diagram emphasizes the event-streaming components of the architecture.

:::image type="complex" border="false" source="./images/iot.svg" alt-text="Diagram of an IoT architecture." lightbox="./images/iot.svg":::
   The diagram has three key sections. Three arrows point from the Application back end. One arrow points to Command and control. One arrow points to Provisioning API. One arrow points to Device registry. An arrow points from Provisioning API to Device registry. One arrow points from Command and control to Devices. An arrow splits from this line and points to Field gateway. A double-sided arrow points between Devices and Field gateway. An arrow points from Field gateway to Cloud gateway. An arrow points from Cloud gateway to Stream processing. Five arrows point from Stream processing. One arrow points to Application back end. One arrow points to Cold storage. One arrow points to Hot path analytics. One arrow points to Notifications. One arrow points to Machine learning. An arrow points from Batch analytics to Cold storage.
:::image-end:::

The **cloud gateway** ingests device events at the cloud boundary. It uses a reliable, low-latency messaging system to ensure efficient data transmission.

Devices might send events directly to the cloud gateway or through a **field gateway**. A field gateway is a specialized device or software, usually colocated with the devices, that receives events and forwards them to the cloud gateway. The field gateway might also preprocess raw device events by performing functions such as filtering, aggregation, or protocol transformation.

After ingestion, events go through one or more **stream processors** that can route the data or perform analytics and other processing.

Consider the following common types of processing:

- Data is loaded into an event-based data store such as an eventhouse in Real-Time Intelligence to contextualize the IoT device with metadata, such as the building location and device information.

- Analyzing the eventstream in real time to detect anomalies, recognize patterns over rolling time windows, or trigger alerts when specific conditions occur in the stream.

- Handling special types of nontelemetry messages from devices, such as notifications and alarms.

- Scoring events by using machine learning models to detect anomalies, predict failures, or classify device behavior.

The gray boxes show components of an IoT system that aren't directly related to eventstreaming. They're included here for completeness.

- The **device registry** is a database of provisioned devices. It includes device IDs and typically contains metadata such as location.

- The **provisioning API** is a common external interface for provisioning and registering new devices.

- Some IoT solutions allow **command and control messages** to be sent to devices.

## Related resources

- [IoT architectures](/azure/architecture/browse/?azure_categories=iot)
- [Big data architectures](../../databases/guide/big-data-architectures.md)
