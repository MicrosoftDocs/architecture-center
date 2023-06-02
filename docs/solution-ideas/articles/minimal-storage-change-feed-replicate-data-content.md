This article presents a high-availability solution for a web application that uses massive amounts of data that must be available for a specific time period. It stores the data in Azure Cosmos DB, and uses the Azure Cosmos DB change feed to replicate the data to secondary storage. After the specified time period elapses, Azure Functions is used to delete the data from Azure Cosmos DB.

## Architecture

[ ![Architecture of a resilient system that uses two types of storage to reduce costs.](../media/minimal-storage-change-feed-replicate-data.svg)](../media/minimal-storage-change-feed-replicate-data.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/minimal-storage-change-feed-replicate-data.vsdx) of this architecture.*

## Dataflow

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer-7 load balancer, switches user traffic to the standby region if there's a regional outage.
1. App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate responsibility to code hosted by Functions to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The queued messages trigger the functions, which perform the background tasks.
1. Azure Cache for Redis caches database data for the functions. By using the cache, the solution offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds recently generated data.
1. Azure Cosmos DB issues a change feed that can be used to replicate changes.
1. A function app reads the change feed and replicates the changes to Azure Table Storage tables. Another function app periodically removes expired data from Azure Cosmos DB.
1. Table Storage provides low-cost storage.

### Components

- [Azure Azure AD](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with Internet of Things (IoT) devices, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Table Storage](https://azure.microsoft.com/services/storage/tables), and [Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Queue Storage](https://azure.microsoft.com/services/storage/queues) provides simple, cost-effective, durable message queueing for large workloads.
- [Table Storage](https://azure.microsoft.com/services/storage/tables) is a NoSQL key-value store for rapid development that uses massive semi-structured datasets. The tables are schemaless and adapt readily as needs change. Access is fast and cost-effective for many types of applications, and typically costs less than other types of keyed storage.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve the performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database from Microsoft that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements (SLAs).

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn) caches static content in edge servers for quick response, and uses network optimizations to improve response for dynamic content. Content Delivery Network is especially useful when the user base is global.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) provides a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Scenario details

This solution uses Azure Cosmos DB to store the large volume of data that the web application uses. Web apps that handle massive amounts of data benefit from the ability of Azure Cosmos DB to elastically and independently scale throughput and storage.

Another key solution component is the Azure Cosmos DB change feed. When changes are made to the database, the change feed stream is sent to an event-driven Functions trigger. A function then runs and replicates the changes to Table Storage tables, which provide a low-cost storage solution.

The web app needs the data for only a limited amount of time. The solution takes advantage of that fact to further reduce costs. Specifically, another function periodically runs and deletes expired data from Azure Cosmos DB. Besides being triggered, functions can also be scheduled to run at set times.

### Potential use cases

The architecture is appropriate for any application that:

- Uses a massive amount of data.
- Requires that data is always available when it's needed.
- Uses data that expires.

Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing IoT data.
- Display smart meter data or use smart technology to monitor meter data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- When you implement and maintain this solution, you incur extra costs.
- Using the change feed for replication requires less code maintenance than doing the replication in the core application.
- You need to migrate existing data. The migration process requires ad-hoc scripts or routines to copy old data to storage accounts. When you migrate the data, make sure that you use time stamps and copy flags to track migration progress.
- To avoid deleting entries from the Azure Table secondary storage, ignore delete feeds that are generated when your functions delete entries from Azure Cosmos DB.

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
- [Change feed design patterns in Azure Cosmos DB](/azure/cosmos-db/change-feed-design-patterns)
- [Serverless event-based architectures with Azure Cosmos DB and Azure Functions](/azure/cosmos-db/change-feed-functions)
- [Introduction to Azure Data Factory](/training/modules/intro-to-azure-data-factory)
- [Orchestrate data movement and transformation in Azure Data Factory or Azure Synapse Pipeline](/training/modules/orchestrate-data-movement-transformation-azure-data-factory)

## Related resources

- [Build scalable database solutions with Azure services](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
