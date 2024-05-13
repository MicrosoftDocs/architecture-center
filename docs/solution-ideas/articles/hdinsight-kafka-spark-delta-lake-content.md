[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a solution that you can use to ingest and process millions of streaming events per second and then write the events to a Delta Lake table. This solution uses Apache Spark and Apache Kafka in Azure HDInsight.

*Apache®, [Apache Kafka](https://kafka.apache.org), and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries or regions. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*[Delta Lake](https://delta.io/) Project is the registered trademark of The Linux Foundation in the U.S. and/or other countries.*

## Architecture

:::image type="content" source="../media/hdinsight-kafka-spark-delta-lake.svg" alt-text="Diagram that shows the architecture for ingesting and processing streaming data." lightbox="../media/hdinsight-kafka-spark-delta-lake.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hdinsight-kafka-spark-delta-lake.vsdx) of this architecture.*

*The [Jupyter Notebook](https://jupyter.org/) logo is a trademark of their respective company. No endorsement is implied by the use of this mark.*
 

### Dataflow

The following dataflow corresponds to the preceding architecture.

1. Real-time event data, such as IoT event data, is ingested to Apache Kafka via an [Apache Kafka producer](https://kafka.apache.org/documentation/#producerapi).

1. [Apache Spark Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html) processes the data in near real-time.
1. Apache Spark provides sinks for writing transformed and calculated analytics. Processed data is stored in an [Azure Data Lake Storage account](https://azure.microsoft.com/services/storage/data-lake-storage) in [Delta Lake table format](https://delta.io/).
1. Processed data is continuously ingested into Apache Kafka. 
1. The data in the Azure Data Lake Storage account can provide insights for:
   - Near real-time dashboards in Power BI.
   - [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) to use with machine learning tools. 
   - Jupyter Notebook by using PySpark or Scala to consume Delta Lake tables.

### Components

- [HDInsight](https://azure.microsoft.com/products/hdinsight/) provides [open-source components](/azure/hdinsight/hdinsight-5x-component-versioning) for enterprise analytics. You can run these Apache components in an Azure environment with [enterprise-grade security](/azure/hdinsight/domain-joined/hdinsight-security-overview). HDInsight also offers [other benefits](/azure/hdinsight/hdinsight-overview#why-should-i-use-azure-hdinsight) including scalability, security, centralized monitoring, global availability, and extensibility.

- [Apache Kafka in HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is a managed open-source distributed platform that you can use to build real-time streaming data pipelines and applications. Apache Kafka provides high performance and durability so that you can group records into topics, partitions, and consumer groups and multiplex event streams from producers to consumers.
- [Apache Spark in HDInsight](/azure/hdinsight/spark/apache-spark-overview) is a managed Microsoft implementation of Apache Spark in the cloud and is one of several Spark offerings in Azure.
- [Apache Spark Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html) is a scalable, exactly-once fault-tolerance engine for processing streams. It's built on the Spark SQL engine. Structured Streaming queries are near real-time and have low latency. Apache Spark Structured Streaming provides several connectors for data sources and data sinks. You can also join multiple streams from various source types.
- [Apache Spark Structured Streaming in Apache Kafka](https://spark.apache.org/docs/latest/structured-streaming-kafka-integration.html) is used to batch and stream queries and store them in a storage layer, a database, or Apache Kafka.
- A [Delta Lake](https://delta.io/) storage layer provides reliability for data lakes by adding a transactional storage layer on top of data that's stored in cloud storage, such as Azure Storage. This storage layer extends Apache Parquet data files with file-based transaction logs. You can store data in Delta Lake table format to take advantage of benefits like atomicity, consistency, isolation, and durability (ACID) transactions, schema evolution, and history versions.
- A [Power BI Delta Lake table connector](https://github.com/delta-io/delta/tree/master/connectors/powerbi) is used to read Delta Lake table data from [Power BI](https://powerbi.microsoft.com).
- [Machine Learning](https://azure.microsoft.com/products/machine-learning/) is an Azure service where you can [send the data](/azure/hdinsight/hadoop/apache-hadoop-deep-dive-advanced-analytics#machine-learning-and-apache-spark) that you collect to then use for machine learning models.

## Scenario details

Event streaming is a continuous unbounded sequence of immutable events that flow from the event publisher to subscribers. In some business use cases, you must store these events in raw format and then clean, transform, and aggregate the events for various analytics needs. Use event streaming to perform near real-time processing and analysis of events, which generates immediate insights.

### Potential use cases

This solution provides an opportunity for your business to process immutable exactly-once fault-tolerant event streams in near real-time. This approach uses Apache Kafka as an input source for Spark Structured Streaming and uses Delta Lake as a storage layer.

Business scenarios include:

- Account sign-in fraud detection
- Analysis of current market conditions
- Analysis of real-time stock market data
- Credit card fraud detection 
- Digital image and video processing
- Drug research and discovery
- Middleware for enterprise big data solutions
- Short-sale risk calculation
- Smart manufacturing and industrial IoT (IIoT)

This solution applies to the following industries:

- Agriculture
- Consumer packaged goods (CPG)
- Cyber security
- Finance
- Healthcare
- Insurance
- Logistics
- Manufacturing
- Retail

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Arun Sethia](https://www.linkedin.com/in/arun-sethia-0a91aa5/) | Principal Program Manager 
- [Sairam Yeturi](https://www.linkedin.com/in/sairam-y-78a4202a/) | Principal Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [Stream at scale in HDInsight](/azure/hdinsight/hdinsight-streaming-at-scale-overview)
- [Quickstart: Create an Apache Spark cluster in Azure HDInsight](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql-use-portal)
- [Quickstart: Create an Apache Kafka cluster in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-get-started)
- [Overview of enterprise security in Azure HDInsight](/azure/hdinsight/domain-joined/hdinsight-security-overview)
- [HDInsight 5.0 with Spark 3.x—Part 1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/hdinsight-5-0-with-spark-3-x-part-1/ba-p/3777416)
- [HDInsight—Iceberg open-source table format](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/hdinsight-iceberg-open-source-table-format/ba-p/3754126)	
- [Build a data lakehouse by using Azure HDInsight](https://murggu.medium.com/building-a-data-lakehouse-using-azure-hdinsight-d41f7c3547d8)
- [Use a shared Hive metastore across Azure Synapse, HDInsight, and Databricks](https://murggu.medium.com/using-a-shared-hive-metastore-across-azure-synapse-hdinsight-and-databricks-72c53acda778)

## Related resources

- [Event-driven architecture style](../../guide/architecture-styles/event-driven.yml)
- [Partitioning in Azure Event Hubs and Kafka](../../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.yml)
- [Apache Kafka open-source scenarios on Azure](../../guide/apache-scenarios.md#apache-kafka)
