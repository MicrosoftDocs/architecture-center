[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for using Azure Kubernetes Service (AKS) to quickly process and analyze a large volume of streaming data from devices.

*Apache®, [Apache Kafka](https://kafka.apache.org/), and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

![Architecture diagram that shows how streaming data from devices is ingested, processed, and analyzed.](../media/data-streaming-scenario.svg)

*Download a [Visio file](https://arch-center.azureedge.net/data-streaming-scenario.vsdx) of this architecture.*

### Dataflow

1. Sensors generate data and stream it to Azure API Management.
1. An AKS cluster runs microservices that are deployed as containers behind a service mesh. The containers are built by using a DevOps process and are stored in Azure Container Registry.
1. An ingest service stores data in Azure Cosmos DB.
1. Asynchronously, an analysis service receives the data and streams it to Apache Kafka and Azure HDInsight.
1. Data scientists use machine learning models and the Splunk platform to analyze the data.
1. A processing service processes the data and stores the result in Azure Database for PostgreSQL. The service also caches the data in Azure Cache for Redis.
1. A web app that runs in Azure App Service creates visualizations of the results.

### Components

The solution uses the following key technologies:

- [API Management](https://azure.microsoft.com/services/api-management)
- [App Service](https://azure.microsoft.com/services/app-service)
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache)
- [Container Registry](https://azure.microsoft.com/services/container-registry)
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
- [HDInsight](https://azure.microsoft.com/services/hdinsight)
- [AKS](https://azure.microsoft.com/services/kubernetes-service)
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines)

## Scenario details

This solution is a good fit for a scenario that involves millions of data points, where data sources include Internet of Things (IoT) devices, sensors, and vehicles. In such a situation, processing the large volume of data is one challenge. Quickly analyzing the data is another demanding task, as organizations seek to gain insight into complex scenarios.

Containerized microservices in AKS form a key part of the solution. These self-contained services ingest and process the real-time data stream. They also scale as needed. The containers' portability makes it possible for the services to run in different environments and process data from multiple sources. To develop and deploy the microservices, DevOps and continuous integration/continuous delivery (CI/CD) are used. These approaches shorten the development cycle.

To store the ingested data, the solution uses Azure Cosmos DB. This database elastically scales throughput and storage, which makes it a good choice for large volumes of data.

The solution also uses Kafka. This low-latency streaming platform handles real-time data feeds at extremely high speeds.

Another key solution component is HDInsight, which is a managed, open-source cloud analytics service. HDInsight simplifies running big data frameworks in large volume and velocity while using Apache Spark in Azure. Splunk helps in the data analysis process. This platform creates visualizations from real-time data and provides business intelligence.

### Potential use cases

This solution benefits the following areas:

- Vehicle safety, especially in the automotive industry
- Customer service in retail and other industries
- Healthcare cloud solutions
- Financial technology solutions in the finance industry

## Next steps

Product documentation:

- [About Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview)
- [What is Azure API Management?](/azure/api-management/api-management-key-concepts)
- [App Service overview](/azure/app-service/overview)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [Introduction to private Docker container registries in Azure](/azure/container-registry/container-registry-intro)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [What is Azure Database for PostgreSQL?](/azure/postgresql/overview)
- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)

Microsoft training modules:

- [Build and store container images with Azure Container Registry](/training/modules/build-and-store-container-images)
- [Configure Azure App Service plans](/training/modules/configure-app-service-plans)
- [Work with Azure Cosmos DB](/training/modules/work-with-cosmos-db)
- [Create and connect to an Azure Database for PostgreSQL](/training/modules/create-connect-to-postgres)
- [Develop for Azure Cache for Redis](/training/modules/develop-for-azure-cache-for-redis)
- [Explore API Management](/training/modules/explore-api-management)
- [Manage infrastructure as code using Azure and DSC](/training/paths/az-400-manage-infrastructure-as-code-using-azure)
- [Introduction to Azure HDInsight](/training/modules/intro-to-azure-hdinsight)

## Related resources

- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)
- [Azure Kubernetes in event stream processing](serverless-event-processing-aks.yml)
- [Instant IoT data streaming with AKS](aks-iot-data-streaming.yml)
