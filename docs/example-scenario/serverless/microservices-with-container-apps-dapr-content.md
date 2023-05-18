This article describes a solution for running an order management system with 10 microservices on Azure Container Apps. The solution also uses microservices best practices through Dapr and event-driven scaling with KEDA.

*Dapr and Traefik are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/microservices-with-container-apps-dapr.svg" alt-text="Diagram that shows an order management system with microservices on Container Apps." lightbox="./media/microservices-with-container-apps-dapr.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/microservices-with-container-apps-dapr.pptx) of this architecture.*

### Dataflow

This solution uses Bicep templates to execute the deployment of the Reddog order management system and its supporting Azure infrastructure. The architecture is composed of a single Azure Container Apps environment that hosts 10 .NET Core microservice applications. You'll use the .NET Core Dapr SDK to integrate with Azure resources through publish-subscribe (pub/sub) and State and Binding building blocks. Although Dapr typically provides flexibility when you implement components, this solution is based on an opinion. The services also make use of KEDA scale rules to allow for scaling based on event triggers and scale to zero scenarios.

The following list describes each microservice and the Azure Container Apps configuration it deploys with. See the [reddog-code repo on GitHub](https://github.com/Azure/reddog-code) to view the code.

1. **Traefik:** The basic proxy for routing user requests from the UI to the accounting and Makeline services for the interactive dashboard.

1. **UI:** A dashboard that shows real-time order and aggregated sales data for the Reddog order management system.

1. **Virtual customer:** A customer simulation program that simulates customers placing orders via the order service.

1. **Order service:** A CRUD API to place and manage orders.

1. **Accounting service:** A service that processes, stores, and aggregates order data. It transforms customer orders into meaningful sales metrics that are showcased by the UI.

1. **Receipt service:** An archival program that generates and stores order receipts for auditing and historical purposes.

1. **Loyalty service:** A service that manages the loyalty program by tracking customer reward points based on order spend.

1. **Makeline service:** A service that's responsible for managing a queue of current orders awaiting fulfillment. It tracks the processing and completion of the orders by the virtual worker service.

1. **Virtual worker:** A *worker simulation* program that simulates the completion of customer orders.

1. **Bootstrapper (not shown):** A service that uses Entity Framework Core to initialize the tables within Azure SQL Database for use with the accounting service.

| Service          | Ingress |  Dapr components | KEDA scale rules |
|------------------|---------|--------------------|--------------------|
| Traefik | External | Dapr not enabled | HTTP |
| UI | Internal | Dapr not enabled | HTTP |
| Virtual customer | None | Service to service invocation | N/A |
| Order service | Internal | Pub/sub: Azure Service Bus | HTTP |
| Accounting service | Internal | Pub/sub: Azure Service Bus | Azure Service Bus topic length, HTTP |
| Receipt service | Internal | Pub/sub: Azure Service Bus <br> Binding: Azure Blob | Azure Service Bus topic length |
| Loyalty service | Internal | Pub/sub: Azure Service Bus <br> State: Azure Cosmos DB | Azure Service Bus topic length |
| Makeline service | Internal | Pub/sub: Azure Service Bus <br> State: Azure Redis | Azure Service Bus topic length, HTTP |
| Virtual worker | None | Service to service invocation <br> Binding: Cron | N/A |

> [!NOTE]
> You can also execute Bootstrapper in a container app. However, this service is run once to perform the database creation, and then scaled to zero after creating the necessary objects in Azure SQL Database.

### Components

This solution uses the following components:

- [Azure resource groups](/azure/azure-resource-manager/management/manage-resource-groups-portal) are logical containers for Azure resources. You use a single resource group to structure everything related to this solution in the Azure portal.
- [Azure Container Apps](https://azure.microsoft.com/services/container-apps) is a fully managed, serverless container service used to build and deploy modern apps at scale. In this solution, you're hosting all 10 microservices on Azure Container Apps and deploying them into a single Container App environment. This environment acts as a secure boundary around the system.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a fully managed enterprise message broker complete with queues and publish-subscribe topics. In this solution, use it for the Dapr pub/sub component implementation. Multiple services use this component. The order service publishes messages on the bus, and the Makeline, accounting, loyalty, and receipt services subscribe to these messages.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a NoSQL, multi-model managed database service. Use it as a Dapr state store component for the loyalty service to store customer's loyalty data.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a distributed, in-memory, scalable managed Redis cache. It's used as a Dapr state store component for the Makeline Service to store data on the orders that are being processed.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is an intelligent, scalable, relational database service built for the cloud. Create it for the accounting service, which uses [Entity Framework Core](/ef/core/) to interface with the database. The Bootstrapper service is responsible for setting up the SQL tables in the database, and then runs once before establishing the connection to the accounting service.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) stores massive amounts of unstructured data like text or binary files. The receipt service uses Blob Storage via a Dapr output binding to store the order receipts.
- [Traefik](https://traefik.io/traefik) is a leading modern reverse proxy and load balancer that makes it easy to deploy microservices. In this solution, use Traefik's dynamic configuration feature to do path-based routing from the UI, which is a Vue.js single-page application (SPA). This configuration also enables direct API calls to the backend services for testing.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) enables you to collect, analyze, and act on customer content data from your Azure infrastructure environments. You'll use it with [Application Insights](/azure/azure-monitor/app/app-insights-overview) to view the container logs and collect metrics from the microservices.

### Alternatives

In this architecture, you deploy a Traefik proxy to enable path-based routing for the Vue.js API. There are many alternative open-source proxies that you can use for this purpose. Two other popular projects are [NGINX](https://www.nginx.com) and [HAProxy](https://www.haproxy.com).

All Azure infrastructure, except Azure SQL Database, use Dapr components for interoperability. One benefit of Dapr is that you can swap all these components by changing the container apps deployment configuration. In this case, Azure Service Bus, Azure Cosmos DB, Cache for Redis, and Blob Storage were chosen to showcase some of the 70+ Dapr components available. A list of alternative [pub/sub brokers](https://docs.dapr.io/reference/components-reference/supported-pubsub), [state stores](https://docs.dapr.io/reference/components-reference/supported-state-stores) and [output bindings](https://docs.dapr.io/reference/components-reference/supported-bindings) are in the Dapr docs.

## Scenario details

Microservices are an increasingly popular architecture style that can have many benefits, including high scalability, shorter development cycles, and increased simplicity. You can use containers as a mechanism to deploy microservices applications, and then use a container orchestrator like Kubernetes to simplify operations. There are many factors to consider for large scale microservices architectures. Typically, the infrastructure platform requires significant understanding of complex technologies like the container orchestrators.

[Azure Container Apps](/azure/container-apps/overview) is a fully managed serverless container service for running modern applications at scale. It enables you to deploy containerized apps through abstraction of the underlying platform. This way, you won't need to manage a complicated infrastructure. Azure Container Apps is powered by open-source technologies.

This architecture uses Azure Container Apps integration with a managed version of the [Distributed Application Runtime (Dapr)](https://dapr.io/). Dapr is an open source project that helps developers with the inherent challenges in distributed applications, like state management and service invocation.

Azure Container Apps also provides a managed version of [Kubernetes Event-driven Autoscaling (KEDA)](https://keda.sh/). KEDA lets your containers autoscale based on incoming events from external services like Azure Service Bus and Azure Cache for Redis.

You can also enable HTTPS ingress in Azure Container Apps without creating more Azure networking resources. You can use [Envoy proxy](https://www.envoyproxy.io/), which also allows traffic splitting scenarios.

To explore how Azure Container Apps compares to other container hosting platforms in Azure, see [Comparing Container Apps with other Azure container options](/azure/container-apps/compare-options).

This article describes a solution for running an order management system with 10 microservices on Azure Container Apps. The solution also uses microservices best practices through Dapr and event-driven scaling with KEDA.

### Potential use cases

This solution applies to any organization that uses stateless and stateful microservices for distributed systems. The solution is best for consumer packaged goods and manufacturing industries that have an ordering and fulfillment system.

These other solutions have similar designs:

- Microservices architecture on Azure Kubernetes Service (AKS)
- Microservices architecture on Azure Functions
- Event-driven architectures

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure Container Apps runs on Kubernetes behind the scenes. Resiliency mechanisms are built into Kubernetes that monitor and restart containers, or pods, if there are issues. The resiliency mechanisms combine with the built-in load balancer to run multiple replicas of each container app. With this redundancy, the solution can tolerate an instance being unavailable.

You can use Azure Monitor and Application Insights to monitor Azure Container Apps. You can view container logs by navigating in the portal to the **Logs** pane in each container app, and then run the following Kusto query. This example shows logs for the Makeline service app.

```kusto
ContainerAppConsoleLogs_CL |
    where ContainerAppName_s contains "make-line-service" |
    project TimeGenerated, _timestamp_d, ContainerGroupName_s, Log_s |
    order by _timestamp_d asc
```

The application map in Application Insights also shows how the services communicate in real time. You can then use them for debugging scenarios. Navigate to the application map under the Application Insights resource to view something like the following.

:::image type="content" source="./media/microservices-with-container-apps-dapr-appmap.png" alt-text="Screenshot that shows an application map in Application Insights." lightbox="./media/microservices-with-container-apps-dapr-appmap.png":::

For more information on monitoring Azure Container Apps, see [Monitor an app in Azure Container Apps](/azure/container-apps/monitor).

### Cost optimization

Optimize costs by looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of the services in this architecture.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands you place on it in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This solution relies heavily on the KEDA implementation in Azure Container Apps for event-driven scaling. When you deploy the virtual customer service, it will continuously place orders, which cause the order service to scale up via the HTTP KEDA scaler. As the order service publishes the orders on the service bus, the service bus KEDA scalers cause the accounting, receipt, Makeline, and loyalty services to scale up. The UI and Traefik container apps also configure HTTP KEDA scalers so that the apps scale as more users access the dashboard.

When the virtual customer isn't running, all microservices in this solution scale to zero except for virtual worker and Makeline services. Virtual worker doesn't scale down since it's constantly checking for order fulfillment. For more information on scaling in container apps, see [Set scaling rules in Azure Container Apps](/azure/container-apps/scale-app). For more information on KEDA Scalers, read the [KEDA documentation on Scalers](https://keda.sh/docs/latest/scalers).

## Deploy this scenario

For deployment instructions, see the [Red Dog Demo: Azure Container Apps Deployment](https://github.com/Azure/reddog-containerapps/blob/main/README.md) on GitHub.

The [Red Dog Demo: Microservices integration](https://github.com/Azure-Samples/app-templates-microservices-integration) is a packaged [app template](https://github.com/microsoft/App-Templates) that builds on the preceding code assets to demonstrate the integration of Azure Container Apps, App Service, Functions, and API Management and provisions the infra, deploys the code using GitHub Actions.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Alice Gibbons](https://www.linkedin.com/in/alicejgibbons) | Cloud Native Global Black Belt

Other contributors:

- [Kendall Roden](https://www.linkedin.com/in/kendallroden) | Senior Program Manager
- [Lynn Orrell](https://www.linkedin.com/in/lynn-orrell) | Principal Solution Specialist (GBB)

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Container Apps docs](/azure/container-apps)
- [Comparing container offerings in Azure](/azure/container-apps/compare-options)
- Other Reddog order management system implementations:
  - [Azure Arc hybrid deployment](https://github.com/Azure/reddog-hybrid-arc)
  - [AKS deployment](https://github.com/Azure/reddog-aks)
  - [Local development](https://github.com/Azure/reddog-code/blob/master/docs/local-dev.md)

## Related resources

- [Microservices architecture on Azure Kubernetes Service](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [CI/CD for AKS apps with Azure Pipelines](../../guide/aks/aks-cicd-azure-pipelines)
