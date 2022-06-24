[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Ingest and process millions of streaming events per second with Apache Kafka, Apache Storm, and Apache Spark Streaming.

## Potential use cases

Insurance companies use this solution to retrieve (or ingest) data from multiple sources that include:

- Individual and/or enterprise history
- Market conditions
- Competitor analysis
- Previous claims (finance industry)
- Local demographics (retail and government industries)
- Weather conditions (agriculture industry)

## Architecture

![Architecture Diagram shows the flow of data through the different processes.](../media/streaming-using-hdinsight.png)
*Download an [SVG](../media/streaming-using-hdinsight.svg) of this architecture.*

### Dataflow

1. Streaming data is ingested by Apache Kafka.
1. The data is sent to Apache Spark Streaming and Apache Storm for processing.
1. The data is stored in Apache HBase, which acts as a NoSQL database.
1. The data is consumed by the user in the related apps.
1. The data is visualized in Power BI.
1. The data is sent to and back from Azure HDInsight and Azure Data Lake Storage to securely autoscale processing in the cloud and to perform further analysis.

### Components

Key technologies used to implement this architecture:

- [Azure HDInsight](https://azure.microsoft.com/services/hdinsight)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Power BI](https://powerbi.microsoft.com)

/ Note to Chad - I think we should get rid of these other services that were added in, right? These ones:
- [API Management](https://azure.microsoft.com/services/api-management)
- [App Service](https://azure.microsoft.com/services/app-service)
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache)
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry)
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service)
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines)

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
