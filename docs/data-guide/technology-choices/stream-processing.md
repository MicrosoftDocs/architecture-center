---
title: Choosing a stream processing technology
description: 
author: zoinerTejada
ms.date: 02/12/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Choosing a stream processing technology in Azure

This article compares technology choices for real-time stream processing in Azure.

Real-time stream processing consumes messages from either queue or file-based storage, process the messages, and forward the result to another message queue, file store, or database. Processing may include querying, filtering, and aggregating messages. Stream processing engines must be able to consume an endless streams of data and produce results with minimal latency. For more information, see [Real time processing](../big-data/real-time-processing.md).

<!-- markdownlint-disable MD026 -->

## What are your options when choosing a technology for real-time processing?

<!-- markdownlint-enable MD026 -->

In Azure, all of the following data stores will meet the core requirements supporting real-time processing:

- [Azure Stream Analytics](/azure/stream-analytics/)
- [HDInsight with Spark Streaming](/azure/hdinsight/spark/apache-spark-streaming-overview)
- [Apache Spark in Azure Databricks](/azure/azure-databricks/)
- [HDInsight with Storm](/azure/hdinsight/storm/apache-storm-overview)
- [Azure Functions](/azure/azure-functions/functions-overview)
- [Azure App Service WebJobs](/azure/app-service/web-sites-create-web-jobs)

## Key Selection Criteria

For real-time processing scenarios, begin choosing the appropriate service for your needs by answering these questions:

- Do you prefer a declarative or imperative approach to authoring stream processing logic?

- Do you need built-in support for temporal processing or windowing?

- Does your data arrive in formats besides Avro, JSON, or CSV? If yes, consider options support any format using custom code.

- Do you need to scale your processing beyond 1 GB/s? If yes, consider the options that scale with the cluster size.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Azure Stream Analytics | HDInsight with Spark Streaming | Apache Spark in Azure Databricks | HDInsight with Storm | Azure Functions | Azure App Service WebJobs |
| --- | --- | --- | --- | --- | --- | --- |
| Programmability | Stream analytics query language, JavaScript | [C#/F#][dotnet-spark], Java, Python, Scala | [C#/F#][dotnet-spark], Java, Python, R, Scala | C#, Java | C#, F#, Java, Node.js, Python | C#, Java, Node.js, PHP, Python |
| Programming paradigm | Declarative | Mixture of declarative and imperative | Mixture of declarative and imperative | Imperative | Imperative | Imperative |
| Pricing model | [Streaming units](https://azure.microsoft.com/pricing/details/stream-analytics/) | Per cluster hour | [Databricks units](https://azure.microsoft.com/pricing/details/databricks/) | Per cluster hour | Per function execution and resource consumption | Per app service plan hour |  

### Integration capabilities

| Capability | Azure Stream Analytics | HDInsight with Spark Streaming | Apache Spark in Azure Databricks | HDInsight with Storm | Azure Functions | Azure App Service WebJobs |
| --- | --- | --- | --- | --- | --- | --- |
| Inputs | Azure Event Hubs, Azure IoT Hub, Azure Blob storage  | Event Hubs, IoT Hub, Kafka, HDFS, Storage Blobs, Azure Data Lake Store  | Event Hubs, IoT Hub, Kafka, HDFS, Storage Blobs, Azure Data Lake Store  | Event Hubs, IoT Hub, Storage Blobs, Azure Data Lake Store  | [Supported bindings](/azure/azure-functions/functions-triggers-bindings#supported-bindings) | Service Bus, Storage Queues, Storage Blobs, Event Hubs, WebHooks, Cosmos DB, Files |
| Sinks |  Azure Data Lake Store, Azure SQL Database, Storage Blobs, Event Hubs, Power BI, Table Storage, Service Bus Queues, Service Bus Topics, Cosmos DB, Azure Functions  | HDFS, Kafka, Storage Blobs, Azure Data Lake Store, Cosmos DB | HDFS, Kafka, Storage Blobs, Azure Data Lake Store, Cosmos DB | Event Hubs, Service Bus, Kafka | [Supported bindings](/azure/azure-functions/functions-triggers-bindings#supported-bindings) | Service Bus, Storage Queues, Storage Blobs, Event Hubs, WebHooks, Cosmos DB, Files |

### Processing capabilities

| Capability | Azure Stream Analytics | HDInsight with Spark Streaming | Apache Spark in Azure Databricks | HDInsight with Storm | Azure Functions | Azure App Service WebJobs |
| --- | --- | --- | --- | --- | --- | --- |
| Built-in temporal/windowing support | Yes | Yes | Yes | Yes | No | No |
| Input data formats | Avro, JSON or CSV, UTF-8 encoded | Any format using custom code | Any format using custom code | Any format using custom code | Any format using custom code | Any format using custom code |
| Scalability | [Query partitions](/azure/stream-analytics/stream-analytics-parallelization) | Bounded by cluster size | Bounded by Databricks cluster scale configuration | Bounded by cluster size | Up to 200 function app instances processing in parallel | Bounded by app service plan capacity |
| Late arrival and out of order event handling support | Yes | Yes | Yes | Yes | No | No |

See also:

- [Choosing a real-time message ingestion technology](./real-time-ingestion.md)
- [Real time processing](../big-data/real-time-processing.md)


[dotnet-spark]: https://github.com/dotnet/spark