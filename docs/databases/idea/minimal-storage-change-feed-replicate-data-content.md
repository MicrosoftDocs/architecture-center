This article presents a high-availability solution for a web application that manages large volumes of data that need to be accessible within a specific time frame. The solution uses Azure Cosmos DB as the primary data store and uses the Azure Cosmos DB change feed to replicate data to low-cost secondary storage. After the specified time period, the solution uses Azure Functions to delete the data from Azure Cosmos DB. The data in secondary storage remains available for longer for auditing and analysis by other solutions. The solution replicates data to different data services, which provides high durability.

## Architecture

:::image type="complex" border="false" source="_images/minimal-storage-change-feed-replicate-data.svg" alt-text="Diagram that shows the minimal storage architecture." lightbox="_images/minimal-storage-change-feed-replicate-data.svg":::
   Diagram that shows an internet icon that is connected by dotted arrows to Microsoft Entra ID and Azure DNS and a solid arrow to Azure Front Door. Azure Front Door then connects to two active regions. Both active regions contain a box that houses the Azure App Service web app, which feeds Azure Queue Storage, which feeds Azure Functions. The larger active region contains a box that's labeled delete and houses Azure Cosmos DB, which feeds the change feed and is connected by a dotted arrow to Azure Cosmos DB in the smaller active region. The dotted arrow is labeled geo-replication. The delete box feeds Azure Managed Redis, which connects back to the larger active region's first box. The delete box also feeds the Functions app box, which feeds Azure Table Storage in both active regions. In the smaller active region, the first box feeds Azure Cosmos DB, which feeds Azure Managed Redis, which is connected back to the smaller active region's first box. 
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/minimal-storage-change-feed-replicate-data.vsdx) of this architecture.*

## Data flow

The following data flow corresponds to the previous diagram:

1. The client authenticates by using Microsoft Entra ID and is granted access to web applications that are hosted on Azure App Service.

1. Azure Front Door, which is a firewall and layer-7 load balancer, switches user traffic to the standby region if there's a regional outage.

1. App Service hosts websites and RESTful web APIs. Browser clients run asynchronous JavaScript and XML applications that use the APIs.

1. Web APIs delegate responsibility to Functions-hosted code to handle background tasks. The tasks are queued in Azure Queue Storage queues.

1. The queued messages trigger the functions, which perform the background tasks.

1. Azure Managed Redis caches database data for the functions. The solution offloads database reads for slowly changing data and accelerates the function apps and web apps by using the cache.

1. Azure Cosmos DB holds recently generated data.

1. Azure Cosmos DB issues a change feed that can be used to replicate changes.

1. A function app reads the change feed and replicates the changes to Azure Table Storage tables. Another function app periodically removes expired data from Azure Cosmos DB.

1. Table Storage provides low-cost storage.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that can synchronize with an on-premises directory. In this architecture, it authenticates users and grants access to web applications that are hosted on App Service.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a secure content delivery network and load balancer. In this architecture, it accelerates content delivery, provides failover capabilities, and protects apps from cyber threats.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed service that developers use to build, deploy, host, and scale web apps. You can build apps by using .NET, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In this architecture, App Service hosts the web interface and REST APIs for the application. For more information about web APIs, see [RESTful web API design](../../best-practices/api-design.md).

- [Functions](/azure/well-architected/service-guides/azure-functions) provides an environment to run small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with Internet of Things (IoT) devices, and build simple APIs and microservices. You can use microservices to create servers that connect to Azure services and always remain up to date. In this architecture, Functions runs background tasks like data replication and expired record deletion.

- [Azure Storage](/azure/storage/common/storage-introduction) is a set of scalable and secure cloud services for data, apps, and workloads. In this architecture, Storage provides Queue Storage for task messaging and Table Storage for low-cost replicated data storage.

  - [Queue Storage](/azure/storage/queues/storage-queues-introduction) provides simple, cost-effective, durable message queueing for large workloads. This architecture uses Queue Storage for task messaging.

  - [Table Storage](/azure/storage/tables/table-storage-overview) is a NoSQL key-value store for rapid development that uses massive semi-structured datasets. The tables are schemaless and adapt according to need. Access is fast and cost-effective for many applications. This architecture uses Table Storage to store a synchronized and restructured copy of the data in Azure Cosmos DB.

- [Azure Managed Redis](/azure/redis/overview) is a fully managed in-memory caching service and message broker for data and state sharing between compute resources. To improve the performance of high-throughput online transaction processing applications, design them to scale by using an in-memory data store, such as Azure Managed Redis. In this architecture, Azure Managed Redis accelerates access to frequently used data, which improves performance for function apps and web apps.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multimodel database that powers your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It provides throughput, latency, availability, and consistency guarantees with comprehensive service-level agreements. In this architecture, Azure Cosmos DB stores recent data and emits a change feed that you can use to replicate updates to Table Storage.

### Alternatives

- [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) directs incoming DNS requests across the global Azure regions based on your choice of traffic routing methods. It also provides automatic failover and performance routing.

- [Azure Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a fully managed, serverless container service that developers use to build and deploy modern apps at scale.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a fully managed Kubernetes service for containerized application deployment and management. You can use it to implement a microservices architecture with components that scale independently and on demand.

- [Azure Container Instances](/azure/container-instances/container-instances-overview) runs tasks without requiring infrastructure management. It's useful during development and to run unscheduled tasks.

- [Azure Service Bus](/azure/well-architected/service-guides/azure-service-bus) is a reliable cloud messaging service for simple hybrid integration. It can be used instead of Queue Storage in this architecture. For more information, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Scenario details

This solution uses Azure Cosmos DB to store the large volume of data that web applications use. Web apps that handle massive amounts of data use Azure Cosmos DB to elastically and independently scale throughput and storage.

When changes are made to the database, the Azure Cosmos DB change feed is sent to an event-driven Functions trigger. A function then runs and replicates the changes to Table Storage tables, which provide a low-cost storage solution. You can also orchestrate broader downstream data movement by using Azure Data Factory pipelines or Fabric Data Factory to land data in analytics zones.

The web app needs the data for only a limited amount of time. This solution periodically runs and deletes expired data from Azure Cosmos DB, which reduces costs. Functions can be triggered and they can be scheduled to run at specific times.

### Potential use cases

This solution is appropriate for any application that:

- Uses a massive amount of data.
- Requires that data is available in a specific time frame.
- Uses data that expires.

Examples include apps that:

- Personalize customer experience and drive engagement by using live data feeds and sensors in physical locations.

- Track customer spending habits and shopping behavior.

- Track vehicle fleets and improve efficiency and safety by using vehicle location, performance, and driver behavior data.

- Forecast weather.

- Monitor and manage traffic systems.

- Analyze manufacturing IoT data.

- Monitor smart meter data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- The Azure Cosmos DB change feed guarantees at-least-once delivery. Design your replication function to be idempotent so that duplicate events don't generate inconsistent data in Table Storage.

- Azure Front Door provides automatic regional failover. If the primary region becomes unavailable, traffic routes to the standby region without manual intervention.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The primary cost benefit comes from expired data removal from Azure Cosmos DB, which is billed per request unit (RU), and into Table Storage, which is billed per transaction and per GB stored. This process is cheaper for infrequently accessed data.

- If your workload has predictable throughput requirements, consider [reserved capacity](/azure/cosmos-db/reserved-capacity) for Azure Cosmos DB.

- Use the change feed for replication. This method reduces code maintenance when compared with replication in the core application.

- This solution incurs extra costs for secondary storage and for the functions that manage data replication and expiration.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- You need to migrate existing data. The migration process requires ad hoc scripts or routines to copy old data to storage accounts. When you migrate the data, use time stamps and copy flags to track migration progress.

- Ignore delete feeds that your functions generate when they delete entries from Azure Cosmos DB. This approach prevents removal of entries from Azure Table secondary storage.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Change-feed processing latency affects how quickly data becomes available in Table Storage. To meet your latency requirements, scale the function app plan and batch settings.

- To avoid hot partitions, choose an Azure Cosmos DB partition key that distributes write throughput evenly across logical partitions.

- Azure Managed Redis reduces read pressure on Azure Cosmos DB for slowly changing data, which lowers latency and RU consumption.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams/) | Cloud Solution Architect - Digital and Application Innovation

Other contributor:

- [Filipe Moreira](https://www.linkedin.com/in/filipefumaux/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Front Door and cloud content delivery network documentation](/azure/frontdoor/)
- [Use Azure Cosmos DB](/training/modules/distribute-data-globally-with-cosmos-db)
- [Choose the appropriate API for Azure Cosmos DB](/training/modules/work-with-cosmos-db)
- [Develop solutions by using Azure Cosmos DB](/training/paths/az-204-develop-solutions-that-use-azure-cosmos-db)
- [Migrate large volumes of data into Azure Cosmos DB](/azure/cosmos-db/migrate)
- [How to model and partition data by using a real-world example](/azure/cosmos-db/model-partition-example)
- [Change feed design patterns in Azure Cosmos DB](/azure/cosmos-db/change-feed-design-patterns)
- [Create a serverless event-based architecture by using Azure Cosmos DB and Functions](/azure/cosmos-db/change-feed-functions)
- [What is Fabric Data Factory?](/fabric/data-factory/data-factory-overview)
- [Orchestrate data movement and transformation by using Azure Data Factory](/training/modules/orchestrate-data-movement-transformation-azure-data-factory)
- [Fabric Data Factory documentation](/fabric/data-factory/)

## Related resources

- [Web-Queue-Worker architecture style](../../guide/architecture-styles/web-queue-worker.md)
- [RESTful web API design](../../best-practices/api-design.md)
- [Caching guidance](../../best-practices/caching.yml)