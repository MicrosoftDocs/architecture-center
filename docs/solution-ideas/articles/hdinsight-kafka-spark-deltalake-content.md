[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a solution for ingesting and processing millions of streaming events per second and writing them to a Delta Lake table. Core components include Azure HDInsight Spark and Kafka clusters.

*Apache®, [Apache Kafka](https://kafka.apache.org), and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*


*[Delta Lake](https://delta.io/) Project is the registered trademark of The Linux Foundation in the U.S. and/or other countries.*

## Architecture

![Architecture diagram that shows how streaming data is ingested and processed using Apache Spark Structured Streaming in an Azure environment and then store them in Delta Lake Table format for the user consumption.](../media/hdinsight-kafka-spark-deltalake.png)


### Dataflow

1. Real time event data (like IoT, etc.) ingested to Kafka using [Kafka Producer](https://kafka.apache.org/documentation/#producerapi).
1. [Apache Spark Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html) to process the data in near real time.
1. Apache Spark provides multiple sinks for writing transformed, and calculated analytics. Store Processed data into [Azure Data Lake Storage account](https://azure.microsoft.com/services/storage/data-lake-storage) in [Delta Lake Table Format](https://delta.io/).
1. You can also continuously ingest processed data into Apache Kafka. 
1. The following interfaces get insights from data stored in Azure Data Lake Storage account:
   1. Near real-timedashboards using Power BI
   1. Integrates with [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) to provide machine learning (ML) services. 
   1. Consume Delta Lake from Jupyter Notebook using PySpark/Scala Spark.

### Components

- [Azure HDInsight](/azure/hdinsight/) offers these [open source frameworks](/azure/hdinsight/hdinsight-5x-component-versioning) part of HDInsight managed service for the enterprise analytics need. Moreover, you can run these Apache components in an Azure environment with [Enterprise-grade security](/azure/hdinsight/domain-joined/hdinsight-security-overview). Azure HDInsight also offers [other benefits](/azure/hdinsight/hdinsight-overview#why-should-i-use-azure-hdinsight), including scalability, security, centralized monitoring, global availability, and extensibility.
- [HDInsight Apache Kafka](/azure/hdinsight/kafka/apache-kafka-introduction) is a managed open-source distributed streaming platform that can be used to build real-time streaming data pipelines and applications.  Apache Kafka provides a high-performance, durable, distributed event-streaming platform. It multiplex streams of events from producers to consumers using Topics, Partitions, and Consumer Groups.
- [HDInsight Apache Spark](/azure/hdinsight/spark/apache-spark-overview) is a managed Microsoft implementation of Apache Spark in the cloud, and is one of several Spark offerings in Azure.
  - **Apache Spark Structured Streaming** is a scalable, exactly-once fault-tolerance stream processing engine built on the Spark SQL Engine. Structured Streaming queries are near real-time and have low latency. It provides a large set of connectors for data sources and sinks. In addition, Spark Structured streaming allows joining multiple streams from similar or different source types.
  - **Apache Spark Structured Streaming integration with Kafka** allows to batch and stream queries and sink to the storage layer, database, Kafka, etc.
- [Delta Lake Format](https://delta.io/) storage layer that brings reliability to data lakes by adding a transactional storage layer on top of data stored in cloud storage (Azure Storage). This storage layer extends Apache Parquet data files with file-based transaction logs. Storing data in Delta Lake format has several benefits, including ACID transactions, Schema evolution, history versions, and many more.
- [Power BI](https://powerbi.microsoft.com), including the [PowerBI Delta Lake Table connector](https://github.com/delta-io/delta/tree/master/connectors/powerbi) lets you read Delta Lake Table data from PowerBI.
- [Machine Learning](/azure/hdinsight/hadoop/apache-hadoop-deep-dive-advanced-analytics#machine-learning-and-apache-spark)

## Scenario details

Event streaming is a continuous unbounded sequence of immutable events; where events flow from event publisher to subscribers. Business use case(s) may require storing these events in raw format and cleaning, transformation, and aggregation for various analytics needs. Event streaming allows you to perform near real-time processing and analysis of events to generate immediate insights.

### Potential use cases

This solution provides an exponential opportunity for businesses to process immutable exactly-once fault-tolerant event streams in near real-time by using Kafka as an input source for Spark Structured Streaming and Delta Lake as a storage layer.

A Few business scenarios are:

- Smart manufacturing and IIoT (Industrial IoT)
- Middleware for enterprise big data solutions
- Credit card fraud detection 
- Short-Sale Risk Calculation
- Digital Image and Video Processing
- Account login fraud detection
- Analysis of real-time stock market data.
- Analysis of current market conditions.
- Drug Research and discovery

The solution applies to the following few industries:

- Retail
- Finance
- Insurance
- Health Care
- Agriculture
- CPG (Consumer packaged goods)
- Logistic
- Manufacturing
- Cyber Security

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Arun Sethia](https://www.linkedin.com/in/arun-sethia-0a91aa5/) | Principal Program Manager 
- [Sairam Yeturi](https://www.linkedin.com/in/sairam-y-78a4202a/) | Principal Product Manager

## Next steps

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [Streaming at scale in HDInsight](/azure/hdinsight/hdinsight-streaming-at-scale-overview)
- [Quickstart: Create Apache Spark cluster in Azure HDInsight](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql-use-portal)
- [Quickstart: Create Apache Kafka cluster in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-get-started)
- [Overview of enterprise security in Azure HDInsight](/azure/hdinsight/domain-joined/hdinsight-security-overview)


## Related resources

- [HDInsight 5.0 with Spark 3.x – Part 1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/hdinsight-5-0-with-spark-3-x-part-1/ba-p/3777416)
- [HDInsight - Iceberg Open-Source Table Format](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/hdinsight-iceberg-open-source-table-format/ba-p/3754126)	
- [Building a Data Lakehouse Using Azure HDInsight](https://murggu.medium.com/building-a-data-lakehouse-using-azure-hdinsight-d41f7c3547d8)
- [Using a Shared Hive Metastore Across Azure Synapse, HDInsight, and Databricks](https://murggu.medium.com/using-a-shared-hive-metastore-across-azure-synapse-hdinsight-and-databricks-72c53acda778)
