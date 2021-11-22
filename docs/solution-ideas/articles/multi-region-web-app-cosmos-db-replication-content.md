[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The architecture described in this article increases availability compared to single region deployment. It provides two active regions, and a standby region that can become active if one of the two active regions fails. Each region has its own Azure Cosmos DB database. The replication capabilities of Azure Cosmos DB assure that any changes to a database in one region are also made to the corresponding databases in other regions.  Because Azure Cosmos DB does the replication, application developers don't have to do it in their code, greatly simplifying implementation.

In addition to replicating databases to other regions configured in an Azure Storage account, Azure Cosmos DB further increases availability by maintaining four replicas of databases within each region.

Azure Cosmos DB supports limitless throughput and latency below 10 ms to help your applications provide predictable response and avoid failures due to latency issues. There is a cache for each database to reduce access load and improve application response.

> [!Note]
> Replication provides five consistency levels. For more information, see [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels).

## Potential use cases

The architecture may be appropriate for any application that uses massive amounts of data that must always be available. Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing Internet of Things (IoT) data.
- Display smart meter data or use smart technology to monitor meter data.

## Architecture

:::image type="content" source="../media/multi-region-web-app-cosmos-db-replication.svg" lightbox="../media/multi-region-web-app-cosmos-db-replication.png" alt-text="Architecture of a resilient system that uses Azure Cosmos DB. It can have multiple active regions and can fail over to a standby region.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1857597-PR-3334-multi-region-web-app-cosmos-db-replication.vsdx) of this architecture.*

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer 7 load balancer, switches user traffic to a different Azure region in case of a regional outage.
1. Azure App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate function apps to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The function apps hosted by Azure Functions perform the background tasks, triggered by the queued messages.
1. Azure Cache for Redis caches database data for the function apps. This offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds the data used by the web applications, and assures that changes to a database are replicated in all regions.

### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Azure Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with IoT, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues/) provides simple, cost-effective, durable message queueing for large workloads.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that enables your solutions to scale throughput and storage across any number of geographic regions. Comprehensive service level agreements (SLAs) guarantee throughput, latency, availability, and consistency.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn) (CDN) caches static content in edge servers for quick response, and uses network optimizations to improve response for dynamic content. CDN is especially useful when the user base is global.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) is a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Considerations

- With Azure Cosmos DB, you have one-click data replication to any number of Azure regions.
- As the data grows, Cosmos DB becomes more expensive. You may need to implement data tiering strategies to control cost.
- If you're migrating data from another storage system, you need to write routines to copy the data to Azure Cosmos DB. Make sure that you have timestamp and copy flags to track the progress of data migration.

## Next steps

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.md)
- [Design a geographically distributed application](/learn/modules/design-a-geographically-distributed-application)
- [Distribute your data globally with Azure Cosmos DB](/learn/modules/distribute-data-globally-with-cosmos-db)
- [Choose the appropriate API for Azure Cosmos DB](/learn/modules/choose-api-for-cosmos-db)
- [Store and Access NoSQL Data with Azure Cosmos DB and the Table API](/learn/modules/store-access-data-cosmos-table-api)
- [Work with NoSQL data in Azure Cosmos DB](/learn/paths/work-with-nosql-data-in-azure-cosmos-db)
- [How to model and partition data on Azure Cosmos DB using a real-world example](/azure/cosmos-db/how-to-model-partition-example)
- [Options to migrate your on-premises or cloud data to Azure Cosmos DB](/azure/cosmos-db/cosmosdb-migrationchoices)
- [Migrate hundreds of terabytes of data into Azure Cosmos DB](/azure/cosmos-db/migrate-cosmosdb-data)

## Related resources

- [Build scalable database solutions with Azure services](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels)
