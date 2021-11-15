

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Cache for Redis perfectly complements Azure database services such as Cosmos DB. It provides a cost-effective solution to scale read and write throughput of your data tier. Store and share database query results, session states, static contents, and more using a common cache-aside pattern.

## Architecture

![Architecture Diagram](../media/data-cache-with-redis-cache.png)
*Download an [SVG](../media/data-cache-with-redis-cache.svg) of this architecture.*

### Data flow

1. When an application needs to retrieve data, it will first search to see if it exists in Azure Cache for Redis
1. If the data is found in Azure Cache for Redis (cache hit), the application will use this data 
1. If the data is not found in Azure Cache for Redis (cache miss) then the application will need to retrieve the data from the appropriate Azure database service
1. For cache miss scenarios, the requesting application should add the data retrieved from the Azure Database service to Azure Cache for Redis


### Components

Key technologies used to implement this architecture:

* [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) Complement database services such as Azure SQL Database and Azure Cosmos DB by enabling your data tier to scale throughput at a lower cost than through expanded database instances. Store and share database query results, session states and static content by using a common cache-aside pattern and make your application nimbler and more scalable.
* [Azure App Service](https://azure.microsoft.com/services/app-service) Azure App Service is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends.  You can develop in your favorite language, be it .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications run and scale with ease on both Windows and Linux-based environments.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) Azure Cosmos DB is a fully managed NoSQL database service for modern app development.
* [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) Part of the Azure SQL family, Azure SQL Database is an intelligent, scalable, relational database service built for the cloud. 
* [Azure Database for PostgreSQL](https://azure.microsoft.com/en-gb/services/postgresql/) Part of the Azure SQL family, Azure SQL Database is an intelligent, scalable, relational database service built for the cloud. 


## Next Steps

* [Cache-Aside Pattern](../../patterns/cache-aside.md)
* [Caching Best Practice](../../best-practices/caching.md?toc=%2fazure%2fredis-cache%2ftoc.json)

