[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

You can use Azure Functions and Azure Cosmos DB to build globally distributed, scalable serverless applications.

## Architecture

:::image type="content" source="../media/serverless-apps-using-cosmos-db.png" alt-text="Architecture diagram that shows the functions that are triggered by an online order and a database change feed." border="false":::

*Download an [SVG](../media/serverless-apps-using-cosmos-db.svg) of this architecture.*

### Dataflow

- A customer places an order in an e-commerce website.
- The order triggers an instance of Functions. The function processes the customer's checkout and stores information about the order in Azure Cosmos DB.
- The database insert operation triggers an Azure Cosmos DB change feed event.
- Systems that subscribe to change feed events are notified.
- The change feed notifications trigger Functions:

  - A function applies taxes to the order.
  - A function processes payment for the order.
  - A function fulfills the order.

### Components

- [Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform. With Functions, you can use triggers and bindings to integrate services at scale.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database. With Azure Cosmos DB, your solutions can elastically scale throughput and storage across any number of geographic regions.

## Scenario details

Microservices offer many benefits:

- They provide highly scalable solutions.
- You can deploy each service independently.
- Fault isolation is straightforward when you confine functionality to separate containers.
- They fit well in a DevOps environment.
- They decrease time to market by speeding up the software development lifecycle.

An efficient way to implement microservices is to use a serverless technology. This solution uses Functions, an Azure offering that provides a serverless compute experience. The solution uses Azure Cosmos DB for data storage. Azure Cosmos DB offers a change feed that integrates with Functions.

### Potential use cases

This solution applies to many areas:

- E-commerce
- Retail
- Inventory management

## Next steps

- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Change feed in Azure Cosmos DB](/azure/cosmos-db/change-feed)
- [Create a function triggered by Azure Cosmos DB](/azure/azure-functions/functions-create-cosmos-db-triggered-function)
- [Connect Azure Functions to Azure Cosmos DB using Visual Studio Code](/azure/azure-functions/functions-add-output-binding-cosmos-db-vs-code)

## Related resources

See the following architectures that include Functions and Azure Cosmos DB:

- [Azure Cosmos DB in IoT workloads](/azure/architecture/solution-ideas/articles/iot-using-cosmos-db)
- [Multi-region web application with Azure Cosmos DB replication](/azure/architecture/solution-ideas/articles/multi-region-web-app-cosmos-db-replication)
- [Transactional Outbox pattern with Azure Cosmos DB](/azure/architecture/best-practices/transactional-outbox-cosmos)
- [Gaming using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/gaming-using-cosmos-db)
- [Globally distributed applications using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/globally-distributed-mission-critical-applications-using-cosmos-db)
- [Code walkthrough: Serverless application with Functions](/azure/architecture/serverless/code)
- [Build cloud native applications](/azure/architecture/solution-ideas/articles/cloud-native-apps)
- [Analyze news feeds with near real-time analytics using image and natural language processing](/azure/architecture/example-scenario/ai/news-feed-ingestion-and-near-real-time-analysis)

See the following architectures that feature Functions:

- [Integrate Event Hubs with serverless functions on Azure](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)
- [Azure Functions in a hybrid environment](/azure/architecture/hybrid/azure-functions-hybrid)
- [Monitor Azure Functions and Event Hubs](/azure/architecture/serverless/event-hubs-functions/observability)
- [Azure App Service and Azure Functions considerations for multitenancy](/azure/architecture/guide/multitenant/service/app-service)
- [Performance and scale for Event Hubs and Azure Functions](/azure/architecture/serverless/event-hubs-functions/performance-scale)

See the following architectures that feature Azure Cosmos DB:

- [Retail and e-commerce using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/retail-and-e-commerce-using-cosmos-db)
- [Visual search in retail with Azure Cosmos DB](/azure/architecture/industries/retail/visual-search-use-case-overview)
- [Personalization using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/personalization-using-cosmos-db)
- [Scalable order processing](/azure/architecture/example-scenario/data/ecommerce-order-processing)
- [Deliver highly scalable customer service and ERP applications](/azure/architecture/solution-ideas/articles/erp-customer-service)
- [CI/CD pipeline for container-based workloads](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops)
