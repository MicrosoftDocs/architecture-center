
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Ingest and process millions of streaming events per second with Apache Kafka, Apache Storm, and Apache Spark Streaming.

## Potential use cases

Insurance companies use this solution to retrieve (or ingest) data from multiple sources that include:

- Individual and/or enterprise history
- Market conditions
- Competitor analysis
- Previous claims
- Local demographics
- Weather conditions

## Architecture

![Architecture Diagram shows the flow of data through the different processes.](../media/streaming-using-hdinsight.png)
*Download an [SVG](../media/streaming-using-hdinsight.svg) of this architecture.*

### Dataflow - NOTE - This section needs some work. I did what I could with the diagram above

1. Streaming Data is ingested by Apache Kafka.
1. The data is sent to Apache Spark Streaming and Apache Storm for processing.

### Components - NOTE - I might be missing some or there might be better ones

Key technologies used to implement this architecture:

- [Azure HDInsight](https://azure.microsoft.com/services/hdinsight)
- [API Management](https://azure.microsoft.com/services/api-management)
- [App Service](https://azure.microsoft.com/services/app-service)
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache)
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry)
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service)
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines)

## Next steps - NOTE - I might be missing some or there might be better ones

To learn more about these services, see the following articles:

- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [What is streaming in HDInsight?](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-streaming-at-scale-overview)
- [Create Apache Hadoop cluster in HDInsight](./hadoop/apache-hadoop-linux-create-cluster-get-started-portal.md)
- [Create Apache Spark cluster - Portal](./spark/apache-spark-jupyter-spark-sql-use-portal.md)
- [Enterprise security in Azure HDInsight](./domain-joined/hdinsight-security-overview.md)

## Related resources - NOTE - I might be missing some or there might be better ones

- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)
- [Azure Kubernetes in event stream processing](serverless-event-processing-aks.yml)
- [Instant IoT data streaming with AKS](aks-iot-data-streaming.yml)