This article presents a solution for using multiple storage services to optimize storage performance and cost. Azure Cosmos DB holds recent data and provides availability, performance, and resiliency. Azure Table Storage provides cost-effective storage for recent and historical data.

## Architecture

:::image type="content" source="../media/optimized-storage-time-based-multi-writes.svg" lightbox="../media/optimized-storage-time-based-multi-writes.svg" alt-text="Architecture of a resilient system that uses two types of storage to reduce costs.":::

*Download a [Visio file](https://arch-center.azureedge.net/optimized-storage-time-based-multi-writes.vsdx) of this architecture.*

### Dataflow

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer-7 load balancer, switches user traffic to a different Azure region if there's a regional outage.
1. App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate function apps to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The functions that are hosted by Azure Functions perform the background tasks, triggered by the queued messages. **The functions update both Azure Cosmos DB and Table Storage.**
1. Azure Cache for Redis caches database data for the function apps. By using the cache, the solution offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds three to four months of the most recent data used by the web applications.
1. Table Storage holds historical data used by the web applications.
1. Every three months, Azure Data Factory deletes old data from Azure Cosmos DB to reduce storage costs. The data remains in Table Storage.

### Components

- [Azure AD](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge, close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. App Service provides a framework for building apps by using .NET, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with Internet of Things (IoT) devices, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Table Storage](https://azure.microsoft.com/services/storage/tables), and [Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Queue Storage](https://azure.microsoft.com/services/storage/queues) provides simple, cost-effective, durable message queueing for large workloads.
- [Table Storage](https://azure.microsoft.com/services/storage/tables) is a NoSQL key-value store for rapid development that uses massive semi-structured datasets. The tables are schemaless and adapt readily as needs change. Access is fast and cost-effective for many types of applications, and typically costs less than other types of keyed storage.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve the performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that enables your solutions to scale throughput and storage across any number of geographic regions. Comprehensive service level agreements (SLAs) guarantee throughput, latency, availability, and consistency.
- [Data Factory](https://azure.microsoft.com/services/data-factory) is a managed service that orchestrates and automates data movement and data transformation.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) provides a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Scenario details

By using multiple storage services, this solution optimizes storage performance and cost:

- Azure Cosmos DB holds recent data. This database service also provides availability, performance, and resiliency. In this solution, native Storage replication capabilities replicate the Azure Cosmos DB data to other regions. Periodically, Data Factory deletes historical data from Azure Cosmos DB to reduce costs.
- Table Storage holds all data, both recent and historical. This approach provides cost-effective storage for the historical data. The Table Storage data is also replicated in this solution, by using either native replication or Data Factory.

This solution stores three months of data in Azure Cosmos DB for high availability and performance. To keep storage costs low, any data that's more than three months old is erased from Azure Cosmos DB. The application data is also written to Table Storage in the primary region, where it can be duplicated to another Azure region by using Data Factory.

Besides performance and cost optimization, other benefits of this approach include:

- Extra resiliency against individual storage service failures.
- The ability to classify data requests by priority level so that the appropriate storage service fulfills each request.

### Potential use cases

This solution is appropriate for any application that uses a massive amount of data that's always available when it's needed. Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing IoT data.
- Display smart meter data or use smart technology to monitor meter data.

This solution is also especially useful during a migration phase, when an organization is adopting a new storage technology platform. The outlined approach ensures that systems perform as expected during the migration.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- Your application developers must implement multi-writes to both data stores, which might complicate the implementation and management of the overall application.
- You need to configure Data Factory to delete data based on time stamps from Azure Cosmos DB. Make sure that you have a time stamp column defined in every entity.
- You can use native replication capabilities of Table Storage to simplify the architecture, but you're limited to specific Azure regions that support table replication.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams) | Cloud Solution Architect - Digital and Application Innovation

## Next steps

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.yml)
- [Design a geographically distributed application](/training/modules/design-a-geographically-distributed-application)
- [Distribute your data globally with Azure Cosmos DB](/training/modules/distribute-data-globally-with-cosmos-db)
- [Choose the appropriate API for Azure Cosmos DB](/training/modules/choose-api-for-cosmos-db)
- [Store and access NoSQL data with Azure Cosmos DB for Table](/training/modules/store-access-data-cosmos-table-api)
- [Work with NoSQL data in Azure Cosmos DB](/training/paths/work-with-nosql-data-in-azure-cosmos-db)
- [How to model and partition data on Azure Cosmos DB using a real-world example](/azure/cosmos-db/how-to-model-partition-example)
- [Options to migrate your on-premises or cloud data to Azure Cosmos DB](/azure/cosmos-db/cosmosdb-migrationchoices)
- [Migrate hundreds of terabytes of data into Azure Cosmos DB](/azure/cosmos-db/migrate-cosmosdb-data)
- [Introduction to Azure Data Factory](/training/modules/intro-to-azure-data-factory)
- [Orchestrate data movement and transformation in Azure Data Factory or Azure Synapse Pipeline](/training/modules/orchestrate-data-movement-transformation-azure-data-factory)
- [Guidelines for table design](/azure/storage/tables/table-storage-design-guidelines)

## Related resources

- [Build scalable database solutions with Azure services](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
