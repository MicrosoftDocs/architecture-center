[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a solution for ingesting and processing millions of streaming events per second and writing them to a Delta Lake table. Core components include Apache Spark and Apache Kafka in Azure HDInsight.

*Apache®, [Apache Kafka](https://kafka.apache.org), and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*[Delta Lake](https://delta.io/) is the registered trademark of The Linux Foundation in the U.S. and/or other countries.*

## Architecture

![Diagram that shows the architecture for ingesting and processing streaming data.](../media/hdinsight-kafka-spark-deltalake.png)


### Dataflow

The following dataflow corresponds to the architecture diagram.

1. Real-time event data, such as IoT event data, is ingested to Kafka via a [Kafka producer](https://kafka.apache.org/documentation/#producerapi).

1. [Apache Spark Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html) processes the data in near real time.
1. Apache Spark provides sinks for writing transformed and calculated analytics. Processed data is stored in an [Azure Data Lake Storage account](https://azure.microsoft.com/services/storage/data-lake-storage) in [Delta Lake table format](https://delta.io/).
1. Processed data is continuously ingested into Apache Kafka. 
1. The data in the Azure Data Lake Storage account can provide insights for:
   - Near real-time dashboards in Power BI.
   - [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) for machine learning services. 
   - Jupyter Notebook by using PySpark or Scala to consume Delta Lake tables.

### Components

- [HDInsight](/azure/hdinsight/) provides [open-source components](/azure/hdinsight/hdinsight-5x-component-versioning) for enterprise analytics. You can run these Apache components in an Azure environment with [enterprise-grade security](/azure/hdinsight/domain-joined/hdinsight-security-overview). HDInsight also offers [other benefits](/azure/hdinsight/hdinsight-overview#why-should-i-use-azure-hdinsight) including scalability, security, centralized monitoring, global availability, and extensibility.

- [Apache Kafka in HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is a managed open-source distributed platform that you can use to build real-time streaming data pipelines and applications. Apache Kafka provides high performance and durability so that you can group records into topics, partitions, and consumer groups and multiplex streams of events from producers to consumers.
- [Apache Spark in HDInsight](/azure/hdinsight/spark/apache-spark-overview) is a managed Microsoft implementation of Apache Spark in the cloud and is one of several Spark offerings in Azure.
  
- *Apache Spark Structured Streaming* is a scalable, exactly-once fault-tolerance engine for processing streams. It's built on the Spark SQL engine. Structured Streaming queries are near real time and have low latency. Apache Spark Structured Streaming provides several connectors for data sources and data sinks, and you can join multiple streams from various source types.
  
  Use Apache Spark Structured Streaming integration with Kafka to batch and stream queries and store them in the storage layer, a database, or Kafka.
- A [Delta Lake format](https://delta.io/) storage layer provides reliability to data lakes by adding a transactional storage layer on top of data that's stored in cloud storage (Azure Storage). This storage layer extends Apache Parquet data files with file-based transaction logs. Store data in Delta Lake format to get several benefits, including ACID transactions, schema evolution, and history versions.
- Use the [Power BI Delta Lake table connector](https://github.com/delta-io/delta/tree/master/connectors/powerbi) tou read Delta Lake table data from [Power BI](https://powerbi.microsoft.com).
- [Machine Learning](/azure/hdinsight/hadoop/apache-hadoop-deep-dive-advanced-analytics#machine-learning-and-apache-spark)

## Scenario details

Event streaming is a continuous unbounded sequence of immutable events; where events flow from event publisher to subscribers. Business use case(s) may require storing these events in raw format and cleaning, transformation, and aggregation for various analytics needs. Event streaming allows you to perform near real-time processing and analysis of events to generate immediate insights.

### Potential use cases

This solution provides an exponential opportunity for businesses to process immutable exactly-once fault-tolerant event streams in near real-time by using Kafka as an input source for Spark Structured Streaming and Delta Lake as a storage layer.

Business scenarios include:

- Smart manufacturing and Industrial IoT (IIoT)
- Middleware for enterprise big data solutions
- Credit card fraud detection 
- Short-sale risk calculation
- Digital image and video processing
- Account login fraud detection
- Analysis of real-time stock market data
- Analysis of current market conditions
- Drug research and discovery

This solution applies to the following industries:

- Retail
- Finance
- Insurance
- Health care
- Agriculture
- Consumer packaged goods (CPG)
- Logistics
- Manufacturing
- Cyber security

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Arun Sethia](https://www.linkedin.com/in/arun-sethia-0a91aa5/) | Principal Program Manager 
- [Sairam Yeturi](https://www.linkedin.com/in/sairam-y-78a4202a/) | Principal Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [Streaming at scale in HDInsight](/azure/hdinsight/hdinsight-streaming-at-scale-overview)
- [Quickstart: Create Apache Spark cluster in Azure HDInsight](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql-use-portal)
- [Quickstart: Create Apache Kafka cluster in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-get-started)
- [Overview of enterprise security in Azure HDInsight](/azure/hdinsight/domain-joined/hdinsight-security-overview)
- [HDInsight 5.0 with Spark 3.x—Part 1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/hdinsight-5-0-with-spark-3-x-part-1/ba-p/3777416)
- [HDInsight—Iceberg Open-Source Table Format](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/hdinsight-iceberg-open-source-table-format/ba-p/3754126)	
- [Building a Data Lakehouse Using Azure HDInsight](https://murggu.medium.com/building-a-data-lakehouse-using-azure-hdinsight-d41f7c3547d8)
- [Using a Shared Hive Metastore Across Azure Synapse, HDInsight, and Databricks](https://murggu.medium.com/using-a-shared-hive-metastore-across-azure-synapse-hdinsight-and-databricks-72c53acda778)
