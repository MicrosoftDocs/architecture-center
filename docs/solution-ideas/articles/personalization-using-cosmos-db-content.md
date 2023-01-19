[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for generating personalized recommendations for customers in real time. Core solution components include Azure Cosmos DB and its change feed and Azure Databricks.

*Apache® and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

![Architecture diagram that shows how recommendations reach a customer when data flows from an e-commerce app through an API app to a database.](../media/personalization-using-cosmos-db.png)

*Download an [SVG](../media/personalization-using-cosmos-db.svg) of this architecture.*

### Dataflow

1. A shopper signs in to an e-commerce app by using their own credentials.
1. The shopper places an order, and the order goes to an API app.
1. Data from the customer order is stored in Azure Cosmos DB.
1. The change feed is enabled on Azure Cosmos DB and processes all the changes for available events.
1. Apache Spark on Azure Databricks is used to train and store product and user vector data in Azure Cosmos DB.
1. The e-commerce app uses a recommendation API in Azure Container Service to retrieve the latest recommendation for the shopper.

### Components

- The [Web Apps](https://azure.microsoft.com/products/app-service/web) feature of [Azure App Service](https://azure.microsoft.com/products/app-service/#overview) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. With Web Apps, you can develop in your favorite language, be it .NET, Java, Ruby, Node.js, PHP, or Python. Applications run and scale with ease on both Windows and Linux-based environments.

- The [API Apps](https://azure.microsoft.com/products/app-service/api) feature of [App Service](https://azure.microsoft.com/products/app-service/#overview) is used to build and consume cloud APIs. App Service provides cross-origin resource sharing (CORS) support for RESTful APIs. API Apps simplifies mobile app scenarios by enabling authentication, offline data sync, and push notifications.

- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a multiple-model database that can serve data elastically at a massive scale. Azure Cosmos DB was designed for applications that are globally distributed in a multi-write model. The Azure Cosmos DB [change feed](/azure/cosmos-db/change-feed) provides a persistent record of changes to a container while maintaining the order that the changes occur in.

- [Azure Container Instances](https://azure.microsoft.com/products/container-instances) runs containers on demand in a serverless Azure environment. Container Instances is a low-friction method of running containers that doesn't require a full Docker host or Kubernetes installation.

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service) automates deployment, scaling, and management of containerized applications, such as recommendation models.

- [Azure Databricks](https://azure.microsoft.com/products/databricks) is a data analytics platform optimized for the Azure cloud services platform. Azure Databricks offers various environments for developing data-intensive applications: Databricks Data Science & Engineering, Databricks Machine Learning, and Databricks SQL.

### Alternatives

Like Azure Databricks, Azure Synapse Analytics also provides native Apache Spark capabilities. As an alternative option for the development and training of a recommendation model, consider Azure Synapse Analytics.

## Scenario details

This solution uses Azure Cosmos DB to store data from customer orders. The Azure Cosmos DB change feed reacts to each order by triggering a process to generate recommendations. Apache Spark on Azure Databricks is used to train a machine learning model that recommends products based on customer data.

Azure Cosmos DB also stores the product and user vectors that the machine learning models use. Azure Cosmos DB offers five levels of consistency. You can adjust the consistency level to lower latency. Fast response times make it possible for the e-commerce site to make immediate recommendations to customers.

### Potential use cases

This solution is ideal for the retail industry. It applies to scenarios where organizations use customer shopping history to provide relevant product recommendations.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The solution uses Azure API Management in front of the container service. API Management provides many benefits such as rate throttling, API versioning, and policies. For more information, see [Azure API Management](/azure/api-management/api-management-key-concepts).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

In Azure Cosmos DB, you can configure either standard (manual) or autoscale-provisioned throughput on your databases and containers. When you use autoscale-provisioned throughput, you can scale the throughput of your database or container automatically and instantly. Azure Cosmos DB measures throughput in request units (RUs). The throughput is scaled based on the usage, without affecting the availability, latency, throughput, or performance of the workload.

Scale the AKS cluster to meet your performance and throughput requirements. Take care to scale up the number of pods to fully utilize the cluster, and to scale the nodes of the cluster to meet the demand of your service.

## Next steps

- [Use Apache Spark in Azure Databricks](/training/modules/use-apache-spark-azure-databricks)
- [Train a machine learning model with Azure Databricks](/training/modules/train-machine-learning-model-azure-databricks)
- [Common Azure Cosmos DB use cases](/azure/cosmos-db/use-cases)
- [App Service overview](/azure/app-service/overview)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Change feed in Azure Cosmos DB](/azure/cosmos-db/change-feed)
- [What is Azure Container Instances?](/azure/container-instances/container-instances-overview)
- [Azure Kubernetes Service (AKS)](/azure/aks)
- [Azure Databricks documentation](/azure/databricks)

## Related resources

- [Basic web application](../../reference-architectures/app-service-web-app/basic-web-app.yml)
- [Design great API developer experiences using API Management and GitHub](../../example-scenario/web/design-api-developer-experiences-management-github.yml)
- [Stream processing with Azure Databricks](../../reference-architectures/data/stream-processing-databricks.yml)
