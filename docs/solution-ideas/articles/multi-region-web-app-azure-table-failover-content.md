[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture provides a high-availability solution for a web application that uses massive amounts of data. A secondary region serves as a standby to the primary, improving availability. The primary region sends its data to the secondary by using the built-in replication capabilities of Azure Storage.

Data is stored in Azure Table Storage tables. As with any Azure Storage service, Table Storage data is replicated synchronously three times in the primary region. To make it available for standby use, it's also replicated asynchronously three times in the secondary region. For information about Azure Storage replication, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).

The architecture includes a cache for the tables to reduce access load and improve application response.

> [!Note]
> Your application may require multiple storage accounts under some circumstances. See [Considerations](#considerations) for more information.

## Potential use cases

The architecture may be appropriate for any application that uses massive amounts of data that must always be available. Examples include apps that:

- Track customer spending habits and shopping behavior.
- Forecast weather.
- Offer smart traffic systems or implement smart traffic systems or use smart technology to monitor traffic.
- Analyze manufacturing Internet of Things (IoT) data.
- Display smart meter data or use smart technology to monitor meter data.

## Architecture

:::image type="content" source="../media/multi-region-web-app-azure-table-failover.svg" lightbox="../media/multi-region-web-app-azure-table-failover.png" alt-text="Architecture of a resilient system that can fail over to a standby region.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1857597-PR-3334-multi-region-web-app-azure-table-failover.vsdx) of this architecture.*

1. The client authenticates with Azure Active Directory (Azure AD) and is granted access to web applications hosted on Azure App Service.
1. Azure Front Door, a firewall and layer 7 load balancer, switches user traffic to the standby region in case of a regional outage.
1. Azure App Service hosts websites and RESTful web APIs. Browser clients run AJAX applications that use the APIs.
1. Web APIs delegate function apps to handle background tasks. The tasks are queued in Azure Queue Storage queues.
1. The function apps hosted by Azure Functions perform the background tasks, triggered by the queued messages.
1. Azure Cache for Redis caches table data for the function apps. This offloads database activity and speeds up the function apps and web apps.
1. Azure Table Storage holds the data used by the web applications.
1. Table Storage supports synchronous replication of data across availability zones in the region to mitigate data center outages. It also uses asynchronous replication for replicating data across different Azure regions to remediate regional outages and improve application availability.

### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a high-availability hosting service for DNS domains that provides apps with fast DNS queries and quick updates to DNS records. Managing Azure DNS is like managing other Azure services, and uses the same credentials, APIs, tools, and billing.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor) is a secure content delivery network (CDN) and load balancer with instant failover. It operates at the edge close to users, accelerating content delivery while protecting apps, APIs, and websites from cyber threats.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Azure Functions](https://azure.microsoft.com/services/functions) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with IoT, and build simple APIs and microservices. With microservices, you can create servers that connect to Azure services and are always up to date.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues/) provides simple, cost-effective, durable message queueing for large workloads.
- [Azure Table Storage](https://azure.microsoft.com/services/storage/tables/) is a NoSQL key-value store for rapid development that uses massive semi-structured datasets. The tables are schemaless and adapt readily as needs change. Access is fast and cost-effective for many types of applications, and typically costs less than other types of keyed storage.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed in-memory caching service and message broker for sharing data and state among compute resources. It includes both the open-source Redis and a commercial product from Redis Labs as managed services. You can improve performance of high-throughput online transaction processing applications by designing them to scale and to make use of an in-memory data store such as Azure Cache for Redis.

### Alternatives

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn) caches static content in edge servers for quick response, and uses network optimizations to quicken response for dynamic content. Content Delivery Network is especially useful when the user base is global.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. You can use it to implement a microservices architecture whose components scale independently on demand.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) provides a quick and simple way to run tasks without having to manage infrastructure. It's useful during development or for running unscheduled tasks.
- [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) is a platform for scaling and orchestrating containers and microservices.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Considerations

- There are performance limits on Table Storage that can be overcome by adding Storage accounts. The following circumstances may require additional accounts:
   - To implement multi-tenancy to support multiple customers
   - To support customers with higher transaction rates
   - To support customers with large datasets
   - To speed up data access by distributing data across multiple storage accounts
   - To segregate data into hot, cold, and archive tiers
   - To make copies of data for backup and reporting purposes

   For more information, see [Scalability and performance targets for Table Storage](/azure/storage/tables/scalability-targets).
- Table Storage replication isn't available in some Azure regions.
- The data in a secondary region has eventual consistency, which means that there's a lag between the time an update occurs in a primary region and when it's seen in the secondary region. Because replication from the primary region to the secondary region is asynchronous, data can be lost if the primary region fails and does not recover. There is currently no service level agreement (SLA) on how long it takes to replicate data to the secondary region. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).

## Next steps

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.md)
- [Data partitioning strategies](../../best-practices/data-partitioning-strategies.md)
- [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design?toc=%2Fazure%2Fstorage%2Ftables%2Ftoc.json&tabs=current)
- [Guidelines for table design](/azure/storage/tables/table-storage-design-guidelines)

## Related resources

- [Build a scalable system for massive data](../../data-guide/scenarios/build-scalable-database-solutions-azure-services.md)
- [RESTful web API design](../../best-practices/api-design.md)
