[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a solution for ingesting and processing millions of streaming events per second. Core components include Azure HDInsight, Apache Kafka, Apache Storm, and Apache Spark.

*Apache®, [Apache Kafka](https://kafka.apache.org/), [Apache Storm](https://storm.apache.org/), [Apache Spark](https://spark.apache.org/), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

![Architecture Diagram shows the flow of data through the different processes.](../media/streaming-using-hdinsight-new.png)

*Download a [Visio file](https://arch-center.azureedge.net/streaming-using-hdinsight.vsdx) of this architecture.*

### Dataflow

- Streaming data is ingested, processed, and the results are stored by the following:
    - Apache Kafka for data ingestion
    - Apache Spark Streaming or Apache Storm for processing
    - Apache HBase, which is a NoSQL database, for the storage of analyzed results
- The data is consumed by the user in the related apps.
- The data is visualized in Power BI.
- The data used by Azure HDInsight is stored in Azure Data Lake Storage for secure and scalable processing in the cloud.

### Components

- [Azure HDInsight](https://azure.microsoft.com/services/hdinsight)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Power BI](https://powerbi.microsoft.com)

## Scenario details




### Potential use cases

Companies can use this solution to retrieve or ingest data from multiple sources and make real-time business decisions. Scenarios include:

- Analyzing data from IoT sensors for quality detection, fault analysis, maintenance event prediction.
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

To learn more about these services, see the following articles:

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [What is streaming in HDInsight?](/azure/hdinsight/hdinsight-streaming-at-scale-overview)
- [Create Apache Hadoop cluster in HDInsight](/azure/hdinsight/hadoop/apache-hadoop-linux-create-cluster-get-started-portal)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Create Apache Spark cluster - Portal](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql-use-portal)
- [Enterprise security in Azure HDInsight](/azure/hdinsight/domain-joined/hdinsight-security-overview)

## Related resources

- [Extend your on-premises big data investments with HDInsight](/azure/architecture/solution-ideas/articles/extend-your-on-premises-big-data-investments-with-hdinsight)
- [Extract, transform, and load (ETL) using HDInsight](/azure/architecture/solution-ideas/articles/extract-transform-and-load-using-hdinsight)
- [Campaign optimization with Azure HDInsight Spark clusters](/azure/architecture/solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters)
- [Loan charge-off prediction with Azure HDInsight Spark clusters](/azure/architecture/solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters)
- [Interactive querying with HDInsight](/azure/architecture/solution-ideas/articles/interactive-querying-with-hdinsight)
- [Azure Kubernetes in event stream processing](serverless-event-processing-aks.yml)
- [Instant IoT data streaming with AKS](aks-iot-data-streaming.yml)
