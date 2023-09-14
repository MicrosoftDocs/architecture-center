[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for a multi-region web app where each region has its own Azure Cosmos DB database. Azure Cosmos DB replication keeps the databases in sync in the various regions.

## Architecture

:::image type="content" source="../media/multi-region-web-app-cosmos-db-replication.svg" lightbox="../media/multi-region-web-app-cosmos-db-replication.svg" alt-text="Architecture of a resilient system that uses Azure Cosmos DB. It can have multiple active regions and can fail over to a standby region.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1857597-PR-3334-multi-region-web-app-cosmos-db-replication.vsdx) of this architecture.*

### Dataflow

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer-7 load balancer, switches user traffic to a different Azure region if there's a regional outage.
1. App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate function apps to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The function apps hosted by Azure Functions perform the background tasks, triggered by the queued messages.
1. Azure Cache for Redis caches database data for the function apps. By using the cache, the solution offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds the data used by the web applications, and assures that changes to a database are replicated in all regions.

### Components

- [Azure AD](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge, close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. With App Service, you can build apps by using .NET, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. For more information about web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with IoT, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Queue Storage](https://azure.microsoft.com/services/storage/queues).
- [Queue Storage](https://azure.microsoft.com/services/storage/queues) provides simple, cost-effective, durable message queueing for large workloads.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve the performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that enables your solutions to scale throughput and storage across any number of geographic regions. Comprehensive service level agreements (SLAs) guarantee throughput, latency, availability, and consistency.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) is a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Scenario details

This article's solution increases availability compared to single region deployment. It provides two active regions, and a standby region that can become active if one of the two active regions fails. Each region has its own Azure Cosmos DB database. The replication capabilities of Azure Cosmos DB assure that any changes to a database in one region are also made to the corresponding databases in other regions. Because Azure Cosmos DB does the replication, application developers don't have to do it in their code, which greatly simplifies implementation.

The solution replicates databases to other regions that are configured in an Azure Storage account. In addition, Azure Cosmos DB further increases availability by maintaining four replicas of databases within each region.

Azure Cosmos DB supports limitless throughput and latency below 10 ms. This functionality helps your applications provide predictable responses and avoid failures due to latency issues. There's a cache for each database to reduce access load and improve application response.

> [!Note]
> Replication provides multiple consistency levels. For more information, see [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels).

### Potential use cases

This solution is appropriate for any application that uses a massive amount of data that's always available when it's needed. Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing Internet of Things (IoT) data.
- Display smart meter data or use smart technology to monitor meter data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- With Azure Cosmos DB, you have one-click data replication to any number of Azure regions.
- As the data grows, Azure Cosmos DB becomes more expensive. You might need to implement data tiering strategies to control cost.
- If you migrate data from another storage system, you need to write routines to copy the data to Azure Cosmos DB. Make sure that you have time stamp and copy flags to track the progress of data migration.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams) | Cloud Solution Architect - Digital and Application Innovation

## Next steps

See the following Training modules:

- [Design a geographically distributed application](/training/modules/design-a-geographically-distributed-application)
- [Work with Azure Cosmos DB](/training/modules/work-with-cosmos-db)
- [AZ-204: Develop solutions that use Azure Cosmos DB](/training/paths/az-204-develop-solutions-that-use-azure-cosmos-db)

See the following Azure Cosmos DB articles:

- [How to model and partition data on Azure Cosmos DB using a real-world example](/azure/cosmos-db/how-to-model-partition-example)
- [Options to migrate your on-premises or cloud data to Azure Cosmos DB](/azure/cosmos-db/cosmosdb-migrationchoices)
- [Migrate hundreds of terabytes of data into Azure Cosmos DB](/azure/cosmos-db/migrate-cosmosdb-data)

## Related resources

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.yml)
- [Choose an Azure data storage system](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels)
