


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Generate personalized recommendations for customers in real time, using low-latency and tunable consistency settings for immediate insights

## Architecture

![Architecture Diagram](../media/personalization-using-cosmos-db.png)
*Download an [SVG](../media/personalization-using-cosmos-db.svg) of this architecture.*

### Architecture Components

[Azure Cosmos DB](/azure/cosmos-db/) is a globally distributed, scalable low latency NoSQL database service.

[Change Feed](/azure/cosmos-db/change-feed) provides a persistent record of changes to a container in the order they occur.

[Azure Databricks](/azure/databricks) is a development environment used to prepare input data and train the recommender model on a Spark cluster. Azure Databricks also provides an interactive workspace to run and collaborate on notebooks for any data processing or machine learning tasks.

[Azure Kubernetes Service](/azure/aks) automates deployment, scaling, and management of containerized applications, such as the Recommendation model.

### Considerations

API management, in front of the container service provides a number of benefits such as rate throttling, API versioning, policies.  For further information, please refer to [Azure API Management](/azure/api-management/api-management-key-concepts).

#### Scalability

In Azure Cosmos DB, you can configure either standard (manual) or autoscale provisioned throughput on your databases and containers. Autoscale provisioned throughput in Azure Cosmos DB allows you to scale the throughput (RU/s) of your database or container automatically and instantly. The throughput is scaled based on the usage, without affecting the availability, latency, throughput, or performance of the workload.

Azure Synapse also provides native Apache Spark capabilities and can be considered an alternative option for development and training of a recommendation model.

Scale the AKS cluster to meet your performance and throughput requirements. Take care to scale up the number of pods to fully utilize the cluster, and to scale the nodes of the cluster to meet the demand of your service.
