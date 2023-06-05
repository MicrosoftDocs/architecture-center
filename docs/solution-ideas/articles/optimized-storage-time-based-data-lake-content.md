This article presents a solution for using multiple Azure services to optimize storage performance and cost. Azure Cosmos DB holds recent data and meets availability, performance, and resiliency requirements. Azure Data Factory transports data, and Azure Data Lake Storage provides cost-effective storage.

## Architecture

:::image type="content" source="../media/optimized-storage-time-based-data-lake.svg" lightbox="../media/optimized-storage-time-based-data-lake.png" alt-text="Architecture of a resilient system that uses two types of storage to reduce costs.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1857597-PR-3334-optimized-storage-time-based-data-lake.vsdx) of this architecture.*

### Dataflow

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer-7 load balancer, switches user traffic to a different Azure region if there's a regional outage.
1. App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate functions to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The functions that are hosted by Azure Functions perform the background tasks, triggered by the queued messages.
1. Azure Cache for Redis caches database data for the function apps. By using a cache, the solution offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds three to four months of the most recent data used by the web applications.
1. Data Lake Storage holds historical data used by the web applications.
1. Periodically, Data Factory moves data from Azure Cosmos DB to Data Lake Storage to reduce storage costs.

### Components

- [Azure AD](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. App Service provides a framework for building apps by using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information about web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with Internet of Things (IoT) devices, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), [Queue Storage](https://azure.microsoft.com/services/storage/queues), and [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). Azure Files is often an effective tool for migrating mainframe workloads.
- [Queue Storage](https://azure.microsoft.com/services/storage/queues) provides simple, cost-effective, durable message queueing for large workloads.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve the performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements (SLAs).
- [Data Factory](https://azure.microsoft.com/services/data-factory) is a managed service that orchestrates and automates data movement and data transformation.
- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) offers secure and massively scalable data lake functionality that's built on Azure Blob Storage.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn) caches static content in edge servers for quick response, and uses network optimizations to improve response for dynamic content. Content Delivery Network is especially useful when the user base is global.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) provides a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).
- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is a cloud-based data warehouse that uses massively parallel processing to quickly run complex queries across petabytes of data. Azure Synapse Analytics provides serverless or dedicated querying options at scale. Its Spark pools support elastic pool storage.
- [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) is a cloud-native hybrid transactional and analytical processing (HTAP) capability that enables you to run near real-time analytics over operational data in Azure Cosmos DB. Azure Synapse Link creates a tight, seamless integration between Azure Cosmos DB and Azure Synapse Analytics.

## Scenario details

By using multiple Azure services, this solution optimizes storage performance and cost:

- Azure Cosmos DB holds recent data. This database service also meets web app availability, performance, and resiliency requirements. Native replication capabilities in Azure Cosmos DB replicate its data to other regions.
- Data Lake Storage provides cost-effective storage for older data.
- Data Factory periodically moves older data from Azure Cosmos DB to Data Lake Storage.

### Potential use cases

This solution is appropriate for any application that uses a massive amount of data that's always available when it's needed. Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing IoT data.
- Display smart meter data or use smart technology to monitor meter data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- You need to migrate historical data to Data Lake Storage as a one-time activity to ensure the cost effectiveness of the solution.
- Your application developers must implement data migration routines that use Data Factory to move data from Azure Cosmos DB to Data Lake Storage.
- If you're migrating data from an old storage system, you might need to write routines to copy a portion of the old data to Azure Cosmos DB. Make sure that you use time stamps and copy flags to track the progress of the migration.
- You can further optimize the overall architecture by replacing Azure Cache for Redis with an Azure Cosmos DB integrated cache.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams) | Cloud Solution Architect - Digital and Application Innovation

## Next steps

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.yml)
- [Design a geographically distributed application](/training/modules/design-a-geographically-distributed-application)
- [Work with Azure Cosmos DB](/training/modules/work-with-cosmos-db)
- [Develop solutions that use Azure Cosmos DB](/training/paths/az-204-develop-solutions-that-use-azure-cosmos-db)
- [How to model and partition data on Azure Cosmos DB using a real-world example](/azure/cosmos-db/how-to-model-partition-example)
- [Options to migrate your on-premises or cloud data to Azure Cosmos DB](/azure/cosmos-db/cosmosdb-migrationchoices)
- [Migrate hundreds of terabytes of data into Azure Cosmos DB](/azure/cosmos-db/migrate-cosmosdb-data)
- [Introduction to Azure Data Factory](/training/modules/intro-to-azure-data-factory)
- [Orchestrate data movement and transformation in Azure Data Factory or Azure Synapse Pipeline](/training/modules/orchestrate-data-movement-transformation-azure-data-factory)

## Related resources

- [Build scalable database solutions with Azure services](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
