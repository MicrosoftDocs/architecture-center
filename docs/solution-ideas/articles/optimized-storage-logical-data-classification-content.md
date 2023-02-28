This architecture is for a high-availability solution that handles massive amounts of data. It uses an optimized tiering strategy to reduce storage costs.

## Architecture

:::image type="content" source="../media/optimized-storage-logical-data-classification.svg" lightbox="../media/optimized-storage-logical-data-classification.png" alt-text="Architecture of a resilient system that uses two types of storage to reduce costs.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1857597-PR-3334-optimized-storage-logical-data-classification.vsdx) of this architecture.*

### Workflow

The application data is stored in Azure Cosmos DB, which replicates data to different Azure regions, with the chosen consistency level. The data replication can be achieved with a one-click operation that simplifies the overall implementation of the solution. Azure Data Factory is used to move historical data from Azure Cosmos DB to Azure Table Storage to reduce cost. You can also move data to any other storage, like Azure Data Lake, for reporting. Later, you can archive data using backup or the Azure Storage archive tier, to further reduce cost.

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer 7 load balancer, switches user traffic to a different Azure region if there is a regional outage.
1. Azure App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate function apps to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The function apps hosted by Azure Functions perform the background tasks, triggered by the queued messages.
1. Azure Cache for Redis caches database data for the function apps. This offloads database activity and speeds up the function apps and web apps.
1. Azure Cosmos DB holds the data used by the web applications, and assures that any changes to a database are also made to replica databases.
1. Azure Data Factory is used to move historical data from Azure Cosmos DB to Azure Table Storage to reduce cost.

### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Azure Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with IoT, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues) provides simple, cost-effective, durable message queueing for large workloads.
- [Azure Table Storage](https://azure.microsoft.com/services/storage/tables) is a NoSQL key-value store for rapid development that uses massive semi-structured datasets. The tables are schemaless and adapt readily as needs change. Access is fast and cost-effective for many types of applications, and typically costs less than other types of keyed storage.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that enables your solutions to scale throughput and storage capacity across any number of geographic regions. Comprehensive service level agreements (SLAs) guarantee throughput, latency, availability, and consistency.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a managed service that orchestrates and automates data movement and data transformation.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn) (CDN) caches static content in edge servers for quick response, and uses network optimizations to improve response for dynamic content. CDN is especially useful when the user base is global.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) provides a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Scenario details

Understanding the data usage patterns is critical for designing an optimized tiering strategy. The right data-tiering strategy can help you save money and scale your application without adding costs. In the following diagram, the application data is segregated by customer and further divided into different categories based on usage patterns.

:::image type="content" source="../media/optimized-storage-logical-data-classification-usage.svg" alt-text="Diagram of data segregated by customer and category.":::

1. The hot tier has data that needs to remain highly available and accessible. Configuration data, customer profiles, current student courses, and current marketing campaigns are examples of hot tier data.
1. The cool tier has data with lower availability requirements—data that can be stored at lower cost than hot tier data. For example, Azure Table storage, with latency above 10 ms, is cool tier storage compared to Azure Cosmos DB.
1. Archive data is classified as historical data that is kept for a specific period for legal and compliance requirements. You can keep archive data in Azure Data Lake Storage for long retention periods at low cost.

### Potential use cases

The following architecture can be appropriate for any application that uses massive amounts of data that must always be available. Examples include apps used for:

1. Running multiple campaigns or promotions
1. Performing global surveys
1. Running research experiments
1. Running multiple projects, managing documents and resourcing
1. Managing university enrollment and scheduling

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- Azure Data Factory or a third-party tool can migrate data from Azure Cosmos DB to Azure Table storage.
- If you're migrating data from an old storage system, you need to write routines to copy old data to Azure Cosmos DB. Make sure that you have timestamp and copy flags to track the progress of migration of data.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams) | Cloud Solution Architect - Digital and Application Innovation

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

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
- [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design?toc=%2Fazure%2Fstorage%2Ftables%2Ftoc.json&tabs=current)

## Related resources

- [Build scalable database solutions with Azure services](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
