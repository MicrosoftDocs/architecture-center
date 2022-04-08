This architecture uses multiple Azure services to optimize storage performance and cost. Azure Cosmos DB holds recent data, and meets the application's availability, performance, and resiliency requirements. The native Azure Cosmos DB replication capabilities replicate the Azure Cosmos DB data to other regions.
Periodically, Azure Data Factory moves older data from Azure Cosmos DB to Azure Data Lake to reduce storage costs.

## Potential use cases

The architecture may be appropriate for any application that uses massive amounts of data that must always be available. Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing Internet of Things (IoT) data.
- Display smart meter data or use smart technology to monitor meter data.

## Architecture

:::image type="content" source="../media/optimized-storage-time-based-data-lake.svg" lightbox="../media/optimized-storage-time-based-data-lake.png" alt-text="Architecture of a resilient system that uses two types of storage to reduce costs.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1857597-PR-3334-optimized-storage-time-based-data-lake.vsdx) of this architecture.*

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer 7 load balancer, switches user traffic to a different Azure region in case of a regional outage.
1. Azure App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate function apps to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The function apps hosted by Azure Functions perform the background tasks, triggered by the queued messages.
1. Azure Cache for Redis caches database data for the function apps. This offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds 3 to 4 months of the most recent data used by the web applications.
1. Data Lake Storage holds historical data used by the web applications.
1. Periodically, Azure Data Factory moves data from Azure Cosmos DB to Azure Data Lake to reduce storage costs.

### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Azure Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with IoT, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues), and [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues/) provides simple, cost-effective, durable message queueing for large workloads.
- [Azure Table Storage](https://azure.microsoft.com/services/storage/tables/) is a NoSQL key-value store for rapid development that uses massive semi-structured datasets. The tables are schemaless and adapt readily as needs change. Access is fast and cost-effective for many types of applications, and typically costs less than other types of keyed storage.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is Microsoft's globally distributed, multi-model database that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements (SLAs).
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) is a managed service that orchestrates and automates data movement and data transformation.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is secure and massively scalable data lake functionality built on Azure Blob Storage.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn) (CDN) caches static content in edge servers for quick response, and uses network optimizations to improve response for dynamic content. CDN is especially useful when the user base is global.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) provides a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).
- Azure Synapse Link for Azure Cosmos DB is a cloud-native hybrid transactional and analytical processing (HTAP) capability that enables you to run near real-time analytics over operational data in Azure Cosmos DB. Azure Synapse Link creates a tight seamless integration between Azure Cosmos DB and Azure Synapse Analytics.
- Azure Synapse Analytics is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing.

## Considerations

- Historical data needs to be migrated to Azure Data Lake as a one-time activity to ensure cost effectiveness of the solution.
- Application developers must implement data migration routines that use Azure Data Factory to move data from Azure Cosmos DB to Azure Data Lake.
- If you're migrating data from old storage system, you may need to write routines to copy a portion of old data to Cosmos DB. Make sure that you have timestamp and copy flags to track the progress of migration of data.
- You can further optimize the overall architecture by replacing Azure Redis cache with Azure Cosmos DB integrated cache.

## Next steps

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.yml)
- [Design a geographically distributed application](/learn/modules/design-a-geographically-distributed-application)
- [Distribute your data globally with Azure Cosmos DB](/learn/modules/distribute-data-globally-with-cosmos-db)
- [Choose the appropriate API for Azure Cosmos DB](/learn/modules/choose-api-for-cosmos-db)
- [Store and Access NoSQL Data with Azure Cosmos DB and the Table API](/learn/modules/store-access-data-cosmos-table-api)
- [Work with NoSQL data in Azure Cosmos DB](/learn/paths/work-with-nosql-data-in-azure-cosmos-db)
- [How to model and partition data on Azure Cosmos DB using a real-world example](/azure/cosmos-db/how-to-model-partition-example)
- [Options to migrate your on-premises or cloud data to Azure Cosmos DB](/azure/cosmos-db/cosmosdb-migrationchoices)
- [Migrate hundreds of terabytes of data into Azure Cosmos DB](/azure/cosmos-db/migrate-cosmosdb-data)
- [Introduction to Azure Data Factory](/learn/modules/intro-to-azure-data-factory)
- [Orchestrate data movement and transformation in Azure Data Factory or Azure Synapse Pipeline](/learn/modules/orchestrate-data-movement-transformation-azure-data-factory)

## Related resources

- [Build scalable database solutions with Azure services](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
