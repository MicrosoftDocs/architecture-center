[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This gaming solution idea elastically scales your database to accommodate unpredictable bursts of traffic and deliver low-latency multi-player experiences on a global scale.

## Architecture

[ ![Architecture diagram that shows gaming solution idea using Azure Cosmos DB.](../media/gaming-using-cosmos-db.svg)](../media/gaming-using-cosmos-db.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/gaming-using-cosmos-db.vsdx) of this architecture.*

### Dataflow

1. [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) routes a user's game traffic to the apps hosted in [Azure App Service](/azure/app-service-web/app-service-web-overview), Functions, or Containers, and to APIs that are published via Azure API Gateway.
1. [Azure CDN](/azure/cdn/cdn-overview) serves static images and game content to the user that are stored in [Azure Blob Storage](/azure/storage/blobs/storage-blobs-overview).
1. [Azure Cosmos DB](/azure/cosmos-db/introduction) stores user's game state data.
1. [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) correlates, cleanses, and transforms game state data.
1. [Azure Functions](/azure/azure-functions/functions-overview) processes the insights derived from Azure Databricks and pushes notifications to mobile devices, by using [Azure Notification Hubs](/azure/notification-hubs/notification-hubs-push-notification-overview).

### Components

This architecture includes the following components:

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) is a DNS-based load balancer that controls the distribution of user traffic for service endpoints in different Azure regions. During normal operations, it routes requests to the primary region. If that region becomes unavailable, Traffic Manager can fail over to secondary region as needed.

- [Azure API Management](https://azure.microsoft.com/services/api-management) provides an API gateway that sits in front of the Gaming APIs. API Management also can be used to implement concerns, such as:
    - Enforcing usage quotas and rate limits
    - Validating OAuth tokens for authentication
    - Enabling cross-origin requests (CORS)
    - Caching responses
    - Monitoring and logging requests

- [Azure App Service](https://azure.microsoft.com/services/app-service) hosts API applications allowing autoscale and high availability without having to manage infrastructure.

- [Azure CDN](https://azure.microsoft.com/services/cdn) delivers static, cached content from locations close to users to reduce latency.

- [Azure Blob Storage](https://azure.microsoft.com/services/storage) are optimized to store large amounts of unstructured data, such as static gaming media.

- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database service for building and modernizing scalable, high-performance applications.

- [Azure Databricks](https://azure.microsoft.com/services/databricks) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform.

- [Azure Functions](https://azure.microsoft.com/services/functions) is a serverless compute option that allows applications to run on-demand without having to manage infrastructure.

- [Azure Notification Hubs](https://azure.microsoft.com/services/notification-hubs/#overview) is a massively scalable push notification engine for quickly sending notifications to variety of mobile devices and platforms.

## Scenario details

### Potential use cases

This specific scenario is based on a gaming scenario, for the game development industry. The design patterns are relevant for many industries that are required to process high-traffic web calls and API requests, such as e-commerce and retail applications.

## Next steps

Review the following articles on Azure Cosmos DB:

- [Common Azure Cosmos DB Use Cases](/azure/cosmos-db/use-cases)
- [Change feed in Azure Cosmos DB](/azure/cosmos-db/change-feed)
- [Time to Live (TTL) in Azure Cosmos DB](/azure/cosmos-db/time-to-live)
- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels)
- [Request Units in Azure Cosmos DB](/azure/cosmos-db/request-units)
- [Partitioning and horizontal scaling in Azure Cosmos DB](/azure/cosmos-db/partition-data)

Product documentation:

- [What is Azure Traffic Manager?](/azure/traffic-manager/traffic-manager-overview)
- [Azure API Management](/azure/api-management/api-management-key-concepts)
- [Azure App Service overview](/azure/app-service-web/app-service-web-overview)
- [What is Azure CDN?](/azure/cdn/cdn-overview)
- [What is Azure Blob Storage?](/azure/storage/blobs/storage-blobs-overview)
- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [What is Azure Notification Hubs?](/azure/notification-hubs/notification-hubs-push-notification-overview)

## Related resources

The following solution ideas feature Azure Cosmos DB:

* [Globally distributed applications using Azure Cosmos DB](./globally-distributed-mission-critical-applications-using-cosmos-db.yml)
* [Retail and e-commerce using Azure Cosmos DB](./retail-and-e-commerce-using-cosmos-db.yml)
* [Serverless apps using Azure Cosmos DB](./serverless-apps-using-cosmos-db.yml)
