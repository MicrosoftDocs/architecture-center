This article describes a solution for running an order management system that has 10 microservices on Azure Container Apps. The solution also uses microservices best practices through Distributed Application Runtime (Dapr) and event-driven scaling with Kubernetes event-driven autoscaling (KEDA).

*Dapr and Traefik are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="complex" border="false" source="./media/microservices-with-container-apps-dapr.svg" alt-text="Diagram that shows an order management system with microservices on Container Apps." lightbox="./media/microservices-with-container-apps-dapr.svg":::
   The image shows an order management system with microservices on Container Apps. It contains steps 1 through 9. An arrow points from the user icon to Traefik. Two arrows point from Traefik to the accounting service section and the Makeline service section. A double-sided arrow points from Traefik to the UI section. An arrow points from the virtual customer section to the order service section. An arrow points from the order service section to the Publish-subscribe topic section. Four arrows point from the Publish-subscribe topic section: to the accounting service section, to the receipt service section, to the loyalty service section, and to the Makeline service section. An arrow points from the accounting service section to Azure SQL Database via the Entity Framework. A line points from the receipt service section to Azure Blob Storage binding. A line points from the loyalty service section to Azure Cosmos DB. A line points from the Makeline service section to Azure Managed Redis. And a double-sided arrow points from the Makeline service section to the virtual worker section.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/microservices-with-container-apps-dapr.pptx) of this architecture.*

### Dataflow

This solution describes a fictitious Red Dog order management system and its supporting Azure infrastructure. The architecture is composed of a single Container Apps environment that hosts 10 .NET Core microservice applications. The solution uses the Dapr SDK to integrate with Azure resources via publish-subscribe, state, and binding building blocks. The services also use KEDA scale rules to allow for scaling based on event triggers and scale-to-zero scenarios.

The following dataflow corresponds to the previous diagram:

1. **Traefik:** The basic proxy for routing user requests from the UI to the accounting and Makeline services for the interactive dashboard.

1. **UI:** A dashboard that shows real-time order and aggregated sales data for the Red Dog order management system.

1. **Virtual customer:** A customer simulation program that simulates customers placing orders via the order service.

1. **Order service:** A create, read, update, and delete API to place and manage orders.

1. **Accounting service:** A service that processes, stores, and aggregates order data. It transforms customer orders into meaningful sales metrics that the UI showcases.

1. **Receipt service:** An archival program that generates and stores order receipts for auditing and historical purposes.

1. **Loyalty service:** A service that manages the loyalty program by tracking customer reward points based on order spend.

1. **Makeline service:** A service that manages a queue of current orders waiting to be fulfilled. It tracks the processing and completion of the orders by the virtual worker service.

1. **Virtual worker:** A *worker simulation* program that simulates the completion of customer orders.

| Service | Ingress | Dapr components | KEDA scale rules |
| :---| :---| :---| :---|
| Traefik | External | Dapr not enabled | HTTP |
| UI | Internal | Dapr not enabled | HTTP |
| Virtual customer | None | Service-to-service invocation | N/A |
| Order service | Internal | Publish-subscribe: Azure Service Bus | HTTP |
| Accounting service | Internal | Publish-subscribe: Service Bus | Service Bus topic length, HTTP |
| Receipt service | Internal | Publish-subscribe: Service Bus <br> Binding: Azure Blob Storage | Service Bus topic length |
| Loyalty service | Internal | Publish-subscribe: Service Bus <br> State: Azure Cosmos DB | Service Bus topic length |
| Makeline service | Internal | Publish-subscribe: Service Bus <br> State: Azure Cache for Redis | Service Bus topic length, HTTP |
| Virtual worker | None | Service-to-service invocation <br> Binding: Cron | N/A |

> [!NOTE]
> You can also implement Bootstrap in a container app. However, this service runs one time to perform the database creation and then scales to zero after it creates the necessary objects in Azure SQL Database.

### Components

- [Application Insights](/azure/well-architected/service-guides/application-insights) is an extensible application performance management service that you can use to monitor live applications and automatically detect performance anomalies. In this architecture, you use Application Insights with Azure Monitor to view the container logs and collect metrics from the microservices.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud-based solution for storing massive amounts of unstructured data like text or binary files. In this architecture, a receipt service uses Blob Storage via a Dapr output binding to store the order receipts.

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a distributed, in-memory, scalable managed Redis cache. In this architecture, it's used as a Dapr state store component for the Makeline service to store data on the orders that are being processed.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a NoSQL, multiple-model managed database service. In this architecture, it's used as a Dapr state store component for the loyalty service to store customers' loyalty data.

- [Azure Monitor](/azure/azure-monitor/overview) is a unified platform that enables you to collect, analyze, and act on customer content data from your Azure infrastructure environments. In this architecture, you use Azure Monitor with [Application Insights](/azure/well-architected/service-guides/application-insights) to view the container logs and collect metrics from the microservices.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a fully managed enterprise message broker that has queues and publish-subscribe topics. In this architecture, you use Service Bus for the Dapr publish-subscribe component implementation. Multiple services use this component. The order service publishes messages on the bus, and the Makeline, accounting, loyalty, and receipt services subscribe to these messages.

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a fully managed, serverless container service used to build and deploy modern apps at scale. In this architecture, you host all 10 microservices on Container Apps and deploy them into a single Container Apps environment. This environment serves as a secure boundary around the system.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is an intelligent, scalable, relational database service built for the cloud. In this architecture, it serves as the data store for the accounting service, which uses [Entity Framework Core](/ef/core/) to interface with the database. The bootstrapper service is responsible for setting up the SQL tables in the database. Then it runs one time before it establishes the connection to the accounting service.

- [Traefik](https://traefik.io/traefik) is a reverse proxy and load balancer used to route network traffic to microservices. In this architecture, use Traefik's dynamic configuration feature to do path-based routing from the UI, which is a Vue.js single-page application. This configuration also enables direct API calls to the back-end services for testing.

### Alternatives

In this architecture, you deploy a Traefik proxy to enable path-based routing for the Vue.js API. There are many alternative open-source proxies that you can use for this purpose. Two other common projects are [NGINX](https://www.nginx.com) and [HAProxy](https://www.haproxy.com).

All Azure infrastructure, except for SQL Database, uses Dapr components for interoperability. One benefit of Dapr is that you can swap all these components by changing the container apps deployment configuration. In this scenario, Service Bus, Azure Cosmos DB, Azure Cache for Redis, and Blob Storage showcase some of the more than 70 available Dapr components. A list of alternative [publish-subscribe brokers](https://docs.dapr.io/reference/components-reference/supported-pubsub), [state stores](https://docs.dapr.io/reference/components-reference/supported-state-stores), and [output bindings](https://docs.dapr.io/reference/components-reference/supported-bindings) are available in the Dapr docs.

## Scenario details

Microservices are a widely adopted architectural style. They provide benefits such as scalability, agility, and independent deployments. You can use containers as a mechanism to deploy microservices applications, and then use a container orchestrator like Kubernetes to simplify operations. There are many factors to consider for large-scale microservices architectures. Typically, the infrastructure platform requires a significant understanding of complex technologies like container orchestrators.

[Container Apps](/azure/container-apps/overview) is a fully managed serverless container service for running modern applications at scale. It enables you to deploy containerized apps through an abstraction of the underlying platform. By using this method, you don't need to manage a complicated infrastructure. 

This architecture uses Container Apps integration with a managed version of the [Dapr](https://dapr.io/). Dapr is an open-source project that helps developers overcome the inherent challenges in distributed applications, like state management and service invocation. 

Container Apps also provides a managed version of [KEDA](https://keda.sh/). KEDA lets your containers scale automatically based on incoming events from external services like Service Bus and Azure Cache for Redis.

You can also enable HTTPS ingress in Container Apps without creating more Azure networking resources. You can use [Envoy proxy](https://www.envoyproxy.io/), which also allows traffic splitting scenarios.

For more information, see [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options).

This article describes a solution for running an order management system that has 10 microservices on Container Apps. The solution also uses microservices best practices through Dapr and event-driven scaling with KEDA.

### Potential use cases

This solution applies to any organization that uses stateless and stateful microservices for distributed systems. The solution is best for consumer packaged goods and manufacturing industries that have an ordering and fulfillment system.

The following solutions have similar designs:

- Microservices architecture on Azure Kubernetes Service (AKS)
- Microservices architecture on Azure Functions
- Event-driven architectures

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Container Apps is built on a Kubernetes foundation, which operates as the underlying infrastructure. Resiliency mechanisms are built into Kubernetes that monitor and restart containers, or pods, if there are problems. The resiliency mechanisms include a built-in load balancer that distributes traffic across multiple replicas of each container app. This redundancy allows the system to remain operational, even if one replica becomes unavailable.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The following list outlines several security features that are omitted in this architecture, along with other recommendations and considerations:

- This architecture doesn't use [private endpoints](/azure/private-link/private-link-overview), which allow more secure, private connectivity to Azure services by assigning them an IP address from your virtual network. When private endpoints are used, public network access can be disabled. This approach keeps traffic on the Microsoft backbone and enhances security and compliance.

- Network activity should be continuously monitored to detect and prevent abuse. You can achieve this approach by using an [Azure Firewall](/azure/firewall/) and route tables. The route tables enable traffic that leaves a virtual network to be passed through the firewall first. This process is an important step in ensuring that your architecture isn't vulnerable to data exfiltration attacks.

- Use a web application firewall (WAF) to protect against common vulnerabilities. Use Azure Front Door or Azure Application Gateway to [implement a WAF](/azure/web-application-firewall/) in this architecture.

- Consider using the built-in authentication and authorization feature for Container Apps, known as *Easy Auth*. Easy Auth handles integration with identity providers outside your web app, which can reduce the amount of code you need to maintain.

- Use managed identity for workload identities. Managed identity eliminates the need for developers to manage authentication credentials. For example, the basic architecture authenticates to SQL Server via password in a connection string. When possible, use Microsoft Entra IDs to authenticate to Azure SQL Server.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of the services in this architecture.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

You can use Azure Monitor and Application Insights to monitor Container Apps. You can view container logs by navigating in the portal to the **Logs** pane in each container app and then running the following Kusto query. This example shows logs for the Makeline service app.

```kusto
ContainerAppConsoleLogs_CL |
    where ContainerAppName_s contains "make-line-service" |
    project TimeGenerated, _timestamp_d, ContainerGroupName_s, Log_s |
    order by _timestamp_d asc
```

The application map in Application Insights also shows how the services communicate in real time. You can then use them for debugging scenarios. Navigate to the application map under the Application Insights resource to view something like the following map.

:::image type="complex" border="false" source="./media/microservices-with-container-apps-dapr-appmap.png" alt-text="Screenshot that shows an application map in Application Insights." lightbox="./media/microservices-with-container-apps-dapr-appmap.png":::
   The screenshot shows an application map in Application Insights. The image includes seven circles that represent instances. The names of the instances are virtual-customers, order-service, receipt-gen...ion-service, virtual-worker, make-line-service, loyalty-service, and accounting-service. Multiple curvy lines flow between these instances. The image also contains Dapr state and Dapr bindings.
:::image-end:::

For more information, see [Monitor an app in Container Apps](/azure/container-apps/monitor).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This solution relies heavily on the KEDA implementation in Container Apps for event-driven scaling. When you deploy the virtual customer service, it continuously places orders. This scaling causes the order service to scale up via the HTTP [KEDA scaler](https://keda.sh/docs/latest/scalers). As the order service publishes the orders on the service bus, the service bus KEDA scalers cause the accounting, receipt, Makeline, and loyalty services to scale up. The UI and Traefik container apps also configure HTTP KEDA scalers so that the apps scale as more users access the dashboard.

When the virtual customer isn't running, all microservices in this solution scale to zero except for virtual worker and Makeline services. Virtual worker doesn't scale down because it continuously checks for order fulfillment. For more information, see [Set scaling rules in Container Apps](/azure/container-apps/scale-app).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Alice Gibbons](https://www.linkedin.com/in/alicejgibbons) | Cloud Native Global Black Belt

Other contributors:

- [Lynn Orrell](https://www.linkedin.com/in/lynn-orrell) | Principal Solution Specialist (GBB)
- [Kendall Roden](https://www.linkedin.com/in/kendallroden) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Container Apps docs](/azure/container-apps)
- [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options)

## Related resources

- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [Continuous integration and continuous delivery for AKS apps with Azure Pipelines](../../guide/aks/aks-cicd-azure-pipelines.md)
