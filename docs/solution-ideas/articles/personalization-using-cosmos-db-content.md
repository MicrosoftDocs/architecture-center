


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

[Azure Web App](https://docs.microsoft.com/en-us/azure/app-service/overview)

[Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction) 

[Azure Conatiner Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)

[Azure DataBricks](https://docs.microsoft.com/en-us/azure/databricks/)

**Next Steps**

[What is Azure Web App](https://docs.microsoft.com/en-us/azure/app-service/overview)

[Welcome to Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction) 

[What is Azure Conatiner Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)

[Welcome to Azure DataBricks](https://docs.microsoft.com/en-us/azure/databricks/)
