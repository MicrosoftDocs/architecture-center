[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Generate personalized recommendations for customers in real time, using low-latency and tunable consistency settings for immediate insights.

## Architecture

![Architecture Diagram](../media/personalization-using-cosmos-db.png)
*Download an [SVG](../media/personalization-using-cosmos-db.svg) of this architecture.*

### Data flow
1. Shopper/User signs in to e-commerce app using their own credentials.
2. Shopper/User places the order and order goes to Azure API Apps.
3. Data gets stored in Cosmos DB (Customer Order).
4. The change feed is enabled on the Cosmos DB and processes all the changes for available events.
5. Using Apache Spark on Azure Data Bricks, data is trained and stored in Cosmos DB (Product+ User Vectors)
6. Latest Recommendation will be fetched by the e-commerce store UI using Azure Container Service (Recommendation APIs).

### Components

This architecture includes the following components:

* [**Azure Web App**](/azure/app-service/overview) is part of Azure App Service. It is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. You can develop in your favorite language, be it .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications run and scale with ease on both Windows and Linux-based environments.

* [**Azure Cosmos DB**](/azure/cosmos-db/introduction) is a multiple model database that can serve data elastically at a massive scale. Azure Cosmos DB was designed for applications that are globally distributed in a multi-write model.

* [**Change feed**](/azure/cosmos-db/change-feed) provides a persistent record of changes to a container in the order they occur.

* [**Azure Container Instances**](/azure/container-instances/container-instances-overview) runs containers on-demand in a serverless Microsoft Azure environment. Azure Container Instances is a low-friction method of running containers that doesn't require a full Docker host or Kubernetes installation.

* [**Azure Kubernetes Service**](/azure/aks) automates deployment, scaling, and management of containerized applications, such as the Recommendation model.

* [**Azure Databricks**](/azure/databricks/) is a data analytics platform optimized for the Microsoft Azure cloud services platform. Azure Databricks offers two environments for developing data intensive applications: Azure Databricks SQL Analytics and Azure Databricks Workspace.

## Considerations

API management, in front of the container service provides a number of benefits such as rate throttling, API versioning, policies.  For further information, please refer to [Azure API Management](/azure/api-management/api-management-key-concepts).

### Scalability

In Azure Cosmos DB, you can configure either standard (manual) or autoscale provisioned throughput on your databases and containers. Autoscale provisioned throughput in Azure Cosmos DB allows you to scale the throughput (RU/s) of your database or container automatically and instantly. The throughput is scaled based on the usage, without affecting the availability, latency, throughput, or performance of the workload.

Azure Synapse also provides native Apache Spark capabilities and can be considered an alternative option for development and training of a recommendation model.

Scale the AKS cluster to meet your performance and throughput requirements. Take care to scale up the number of pods to fully utilize the cluster, and to scale the nodes of the cluster to meet the demand of your service.

## Next Steps

* [Basic Web App Azure Reference Architecture](../../reference-architectures/app-service-web-app/basic-web-app.yml?tabs=cli)

* [Common Azure Cosmos DB Use Cases](/azure/cosmos-db/use-cases)

* [Stream Processing with Azure DataBricks](../../reference-architectures/data/stream-processing-databricks.yml)
