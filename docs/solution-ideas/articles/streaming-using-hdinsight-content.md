[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a solution for ingesting and processing millions of streaming events per second. Core components include Azure HDInsight, Apache Kafka, Apache Storm, and Apache Spark.

*Apache®, [Apache Kafka](https://kafka.apache.org), [Apache Storm](https://storm.apache.org), [Apache Spark](https://spark.apache.org), [Apache HBase](https://hbase.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

![Architecture diagram that shows how streaming data is ingested and processed in an Azure environment and then presented to users.](../media/streaming-using-hdinsight-new.png)

*Download a [Visio file](https://arch-center.azureedge.net/streaming-using-hdinsight.vsdx) of this architecture.*

### Dataflow

- Kafka ingests streaming data.
- Storm and Spark process the data.
- Apache HBase, which is a NoSQL database, stores results.
- Users consume the data in apps.
- The data is visualized in Power BI.
- HDInsight stores data in Azure Data Lake Storage for secure and scalable processing in the cloud.

### Components

- [HDInsight](https://azure.microsoft.com/services/hdinsight)
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Power BI](https://powerbi.microsoft.com)

## Scenario details

Many Apache components are a good fit for systems that stream a large volume of data:

- Kafka is a widely used high-performance event-streaming platform.
- Storm is a computation system that quickly processes large volumes of data in real time.
- Spark is a data processing framework that uses in-memory data sharing.
- HBase is a schemaless database that provides random access and strong consistency for large amounts of data.

These components offer the added advantage of being open source. By using HDInsight, you can run these Apache components in an Azure environment.

HDInsight is an enterprise-scale analytics service in the cloud. This managed-cluster platform simplifies the process of running big data frameworks that use Apache components:

- You can use HDInsight to create optimized clusters for Spark, Kafka, and HBase.
- An HDInsight Spark cluster can use a Spark HBase connector to query an HDInsight HBase cluster.
- HDInsight also offers [other benefits](/azure/hdinsight/hdinsight-overview#why-should-i-use-azure-hdinsight), including scalability, security, centralized monitoring, global availability, and extensibility.

### Potential use cases

Companies can use this solution to retrieve or ingest data from multiple sources and make real-time business decisions. Scenarios include:

- Analyzing data from Internet of Things (IoT) sensors for quality detection, fault analysis, and maintenance event prediction.
- Business integration of weather feed or sensor data.
- Analysis of real-time stock market data.
- Analysis of current market conditions.
- Trend analysis over real-time sales.

The solution applies to the following industries:

- Agriculture
- Retail
- Finance
- Insurance

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Sam Lamberson](https://www.linkedin.com/in/sam-lamberson-b28a7b17b) | Technical Writer / Editor
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Program Manager

## Next steps

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [Streaming at scale in HDInsight](/azure/hdinsight/hdinsight-streaming-at-scale-overview)
- [Quickstart: Create Apache Hadoop cluster in Azure HDInsight using Azure portal](/azure/hdinsight/hadoop/apache-hadoop-linux-create-cluster-get-started-portal)
- [Quickstart: Create Apache Spark cluster in Azure HDInsight using Azure portal](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql-use-portal)
- [Tutorial: Use Apache HBase in Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-tutorial-get-started-linux)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Overview of enterprise security in Azure HDInsight](/azure/hdinsight/domain-joined/hdinsight-security-overview)

## Related resources

- [Extend your on-premises big data investments with HDInsight](./extend-your-on-premises-big-data-investments-with-hdinsight.yml)
- [Extract, transform, and load (ETL) using HDInsight](./extract-transform-and-load-using-hdinsight.yml)
- [Optimize marketing with machine learning](./optimize-marketing-with-machine-learning.yml)
- [Loan charge-off prediction with Azure HDInsight Spark clusters](./loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)
- [Interactive querying with HDInsight](./interactive-querying-with-hdinsight.yml)
- [Azure Kubernetes in event stream processing](./serverless-event-processing-aks.yml)
- [Instant IoT data streaming with AKS](./aks-iot-data-streaming.yml)
