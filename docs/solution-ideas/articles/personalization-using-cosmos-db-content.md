


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Generate personalized recommendations for customers in real time, using low-latency and tunable consistency settings for immediate insights

## Architecture

![Architecture Diagram](../media/personalization-using-cosmos-db.png)
*Download an [SVG](../media/personalization-using-cosmos-db.svg) of this architecture.*

**Data Flow**
1. Shopper/User signs in to e-commerce app using their own credentials.
2. Shopper/User places the order and order goes to Azure API Apps.
3. Data gets stored in Cosmos DB (Customer Order).
4. The change feed is enabled on the Cosmos DB and processes all the changes for available events.
5. Using Apache Spark on Azure Data Bricks, data is trained and stored in Cosmos DB (Product+ User Vectors)
6. Latest Recommendation will be fetched by the e-commerce store UI using Azure Container Service (Recommendation APIs).

**Components**

This architecture includes the following components:

[**Azure Web App**](https://docs.microsoft.com/en-us/azure/app-service/overview)-
Azure App Service is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. You can develop in your favorite language, be it .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications run and scale with ease on both Windows and Linux-based environments.

[**Azure Cosmos DB**](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)- 
Azure Cosmos DB is a multiple model database that can serve data elastically at a massive scale. Azure Cosmos DB was designed for applications that are globally distributed in a multi-write model.

[**Azure Container Instances**](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)-
Azure Container Instances runs containers on-demand in a serverless Microsoft Azure environment. Azure Container Instances is a low-friction method of running containers that doesn't require a full Docker host or Kubernetes installation.

[**Azure DataBricks**](https://docs.microsoft.com/en-us/azure/databricks/)-
Azure Databricks is a data analytics platform optimized for the Microsoft Azure cloud services platform. Azure Databricks offers two environments for developing data intensive applications: Azure Databricks SQL Analytics and Azure Databricks Workspace.

**Next Steps**

[Basic Web App Azure Reference Architecture](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/basic-web-app?tabs=cli)

[Common Azure Cosmos DB Use Cases](https://docs.microsoft.com/en-us/azure/cosmos-db/use-cases) 

[Stream Processing with Azure DataBricks](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/data/stream-processing-databricks)
