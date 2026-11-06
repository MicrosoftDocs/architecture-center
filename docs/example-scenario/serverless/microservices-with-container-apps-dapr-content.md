This article describes a solution for running an order management system as a set of containerized services on Azure Container Apps. The solution uses Distributed Application Runtime (Dapr) building blocks for communication and state access, and Kubernetes Event-driven Autoscaling (KEDA) for event-driven scaling.

*Dapr is a trademark of its respective company. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="complex" border="false" source="./media/microservices-with-container-apps-dapr.png" alt-text="Diagram that shows an order management system that uses microservices on Container Apps." lightbox="./media/microservices-with-container-apps-dapr.png":::
   The image shows an order management system with microservices on Container Apps. It shows 9 steps. An arrow points from a user icon to managed ingress. Two arrows point from managed ingress to the accounting service section and the Makeline service section. A double-sided arrow connects managed ingress to the UI section. An arrow points from the virtual customer section to the order service section. An arrow points from the order service section to the publish-subscribe topic section. Four arrows point from the publish-subscribe topic section: to the accounting service section, to the receipt service section, to the loyalty service section, and to the Makeline service section. An arrow points from the accounting service section to SQL Database via Entity Framework. A line points from the receipt service section to Blob Storage binding. A line points from the loyalty service section to Azure Cosmos DB. A line points from the Makeline service section to Azure Managed Redis. A double-sided arrow connects the Makeline service section to the virtual worker section.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/microservices-with-container-apps-dapr.pptx) of this architecture.*

### Data flow

This solution describes a fictitious order management system and its supporting Azure infrastructure. The architecture uses one Container Apps environment that hosts the .NET services, a Vue.js UI, and a bootstrapper. Container Apps provides a managed Envoy-based ingress layer, so the workload doesn't deploy its own proxy tier. Internal service-to-service calls use [Dapr service invocation](/azure/container-apps/connect-apps#dapr-service-invocation), which routes through the environment's proxy infrastructure. The solution uses the Dapr SDK to integrate with Azure resources through publish-subscribe, state, service invocation, and binding building blocks. The services use KEDA-based scale rules to scale in response to HTTP traffic and Azure Service Bus message volume.

The following data flow corresponds to the previous diagram.

1. **Managed ingress:** Container Apps provides a managed Envoy-based ingress layer. An environment-level [rule-based routing](/azure/container-apps/rule-based-routing) configuration publishes one hostname, serves the UI from the root path, and forwards the dashboard's API paths to the accounting and Makeline services. Those two services use internal ingress because a route configuration can target an app that isn't externally exposed.

1. **UI:** A dashboard that shows real-time order and aggregated sales data for the order management system.

1. **Virtual customer:** A customer simulation program that simulates customers placing orders via the order service.

1. **Order service:** A create, read, update, and delete API for placing and managing orders.

1. **Accounting service:** A service that processes, stores, and aggregates order data. It transforms customer orders into meaningful sales metrics that the UI displays.

1. **Receipt service:** An archival program that generates and stores order receipts for auditing and historical purposes.

1. **Loyalty service:** A service that manages the loyalty program by tracking customer reward points based on order spend.

1. **Makeline service:** A service that manages a queue of current orders waiting to be fulfilled. It tracks the processing and completion of the orders by the virtual worker service.

1. **Virtual worker:** A *worker simulation* program that simulates the completion of customer orders.

| Service | Ingress | Dapr integration | KEDA scale rules |
| :--- | :--- | :--- | :--- |
| UI | External | Dapr not enabled | HTTP |
| Virtual customer | None | Service-to-service invocation | Not applicable |
| Order service | Internal | Publish-subscribe: Service Bus | HTTP |
| Accounting service | Internal | Publish-subscribe: Service Bus | Service Bus subscription message count, HTTP |
| Receipt service | Internal | Publish-subscribe: Service Bus <br> Binding: Azure Blob Storage | Service Bus subscription message count |
| Loyalty service | Internal | Publish-subscribe: Service Bus <br> State: Azure Cosmos DB | Service Bus subscription message count |
| Makeline service | Internal | Publish-subscribe: Service Bus <br> State: Azure Managed Redis | Service Bus subscription message count, HTTP |
| Virtual worker | None | Service-to-service invocation <br> Binding: Cron | Not applicable |

> [!NOTE]
> This example runs the bootstrapper as a container app that creates the Azure SQL Database objects and then scales to zero. For a production deployment, run finite initialization work as an idempotent [manual Container Apps job](/azure/container-apps/jobs#manual-jobs) or as a controlled database migration stage in the deployment pipeline.

Container Apps supports only a subset of the components that are available in the Dapr open-source project. The Service Bus, Azure Cosmos DB, and Blob Storage components in this architecture are Tier 1 components. The Redis state store and Cron binding are Tier 2 components, which receive a lower support priority. Review the current [Dapr component support levels in Container Apps](/azure/container-apps/dapr-overview#dapr-components) and confirm that each component meets your workload's support requirements.

### Components

- [Application Insights](/azure/well-architected/service-guides/application-insights) is an application performance management service. In this architecture, you instrument the application code to send requests, dependencies, exceptions, and distributed traces to Application Insights. Container Apps doesn't provide Application Insights auto-instrumentation.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is object storage for unstructured data. In this architecture, the receipt service uses a Dapr output binding to store order receipts in Blob Storage.

- [Azure Managed Redis](/azure/well-architected/service-guides/azure-managed-redis) provides an in-memory data store based on Redis Enterprise software. In this architecture, it's used as a Dapr state store component for the Makeline service to store data about the orders being processed.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a managed distributed database service. In this architecture, the loyalty service uses it through a Dapr state store component to store customer loyalty data.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) collects and analyzes telemetry from Azure resources and applications. In this architecture, you use Azure Monitor for Container Apps platform metrics, console and system logs, alerts, and Application Insights application telemetry.

- [Service Bus](/azure/well-architected/service-guides/azure-service-bus) is a fully managed enterprise message broker that provides queues and publish-subscribe topics. In this architecture, you use Service Bus for the Dapr publish-subscribe component implementation. Multiple services use this component. The order service publishes messages on the bus, and the Makeline, accounting, loyalty, and receipt services subscribe to these messages.

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a fully managed, serverless container service for containerized applications. In this architecture, it hosts all the container apps in one environment and provides managed Envoy-based ingress for external routing to the UI. Treat an environment as a shared network, deployment, and trust boundary, and place workloads that require isolation in separate environments.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database service. In this architecture, it serves as the data store for the accounting service, which uses [Entity Framework Core](/ef/core/) to access the database. The bootstrapper creates the required database objects before the accounting service starts processing orders.

- [Dapr](/azure/container-apps/dapr-overview) is an open-source runtime that provides APIs for distributed application tasks. In this architecture, Container Apps runs a managed Dapr sidecar alongside each enabled service, and the services use the publish-subscribe, state, binding, and service invocation building blocks.

- [KEDA](https://keda.sh/docs/) is an open-source event-driven autoscaler. In this architecture, the managed KEDA integration in Container Apps scales services based on HTTP concurrency and Service Bus subscription message count.

### Alternatives

This architecture uses the built-in Container Apps ingress layer, which runs as a managed Envoy proxy, together with an environment-level route configuration. This combination replaces a proxy container that the workload team would otherwise deploy, scale, and patch. Route configuration permissions are scoped to the environment rather than to individual apps, and an environment-level route can expose an app that otherwise has internal ingress, so restrict who can create routes and review every route target.

For internet-facing production workloads, use a managed ingress service with WAF capabilities, such as Azure Application Gateway or Azure Front Door, based on regional or global routing requirements. Prefer managed ingress over a self-hosted proxy so that the workload team doesn't own the proxy image, vulnerability patching, high-availability configuration, and scaling lifecycle. Use a self-hosted proxy only when a required capability isn't available in the managed options, and document its hardening, patching, monitoring, and recovery processes.

The services reach Service Bus, Azure Cosmos DB, Azure Managed Redis, and Blob Storage through Dapr components, and the accounting service connects to SQL Database directly through Entity Framework Core. When two components implement compatible Dapr API behavior, you can often change the component configuration without changing application code. Component capabilities, consistency models, authentication methods, operational behavior, and Container Apps support tiers differ, so validate the replacement before switching. The Dapr documentation lists alternative [publish-subscribe brokers](https://docs.dapr.io/reference/components-reference/supported-pubsub), [state stores](https://docs.dapr.io/reference/components-reference/supported-state-stores), and [output bindings](https://docs.dapr.io/reference/components-reference/supported-bindings).

## Scenario details

Microservices provide independent deployment and scaling boundaries, but they also introduce distributed-system and operational complexity. Containerized services need a platform that provides deployment, networking, scaling, and observability capabilities.

This architecture uses the managed [Dapr](https://dapr.io/) integration in Container Apps. Dapr provides APIs for distributed application concerns such as state management, publish-subscribe messaging, bindings, and service invocation.

Container Apps uses [KEDA](https://keda.sh/) to scale container apps based on HTTP traffic and events from services such as Service Bus and Azure Managed Redis.

Container Apps built-in ingress provides HTTPS endpoints, internal service discovery, load balancing, and traffic splitting between revisions. This architecture uses [rule-based routing](/azure/container-apps/rule-based-routing) so that the UI and the dashboard APIs share one hostname while the backend services use internal ingress. Add Azure Front Door or Application Gateway when the workload needs a WAF, global routing, or other edge controls.

For more information, see [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options).

### Potential use cases

Consider this design for event-driven order and fulfillment systems that need independently deployable HTTP and background services, asynchronous messaging, and managed state stores. The scenario is relevant to retail, consumer packaged goods, and manufacturing workloads.

Related architectural approaches include:

- Microservices architecture on Azure Kubernetes Service (AKS)
- Microservices architecture on Azure Functions
- Event-driven architectures

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture uses one Container Apps environment in one Azure region, so a regional outage makes the workload unavailable. For a production deployment, use the following reliability practices:

- Enable [zone redundancy](/azure/reliability/reliability-container-apps#resilience-to-availability-zone-failures) when you create the Container Apps environment. Configure at least two replicas for services that must remain available during a zone failure. For ingress-exposed services, consider at least three replicas, based on your availability target and capacity tests.

- Configure startup, readiness, and liveness [health probes](/azure/container-apps/health-probes) for every service. Probes enable Container Apps to restart failed containers and remove unhealthy replicas from load balancing.

- Set minimum replica counts and [scaling rules](/azure/container-apps/scale-app) that preserve required capacity after a replica or zone failure. Scale-to-zero is appropriate only for services that can tolerate cold-start latency and periods with no running replicas.

- Apply [transient fault handling](/azure/well-architected/design-guides/handle-transient-faults) to calls between services and to Azure dependencies. Use bounded retries with backoff, timeouts, and circuit breakers. Coordinate retry policies across layers to avoid multiplying attempts. Make retried operations and message handlers idempotent because retries and Service Bus redelivery can repeat work.

- Configure the reliability and recovery features of SQL Database, Azure Cosmos DB, Azure Managed Redis, Service Bus, and Blob Storage to meet the workload's recovery objectives. Container Apps doesn't replicate application data or provide data backup.

- Don't use Azure Managed Redis as the [authoritative system of record](/azure/well-architected/service-guides/azure-managed-redis#reliability) for data that you can't reconstruct. The accounting service stores every order and records its completion date, while Azure Managed Redis holds only the Makeline service's working queue. If the Redis state is lost, the pending queue must be rebuilt.

If the workload must tolerate a regional outage, deploy separate Container Apps environments and dependent resources across regions. Use Azure Front Door or Azure Traffic Manager for traffic failover, and define a cross-region data replication and recovery strategy.

Container Apps provides [service discovery resiliency policies](/azure/container-apps/service-discovery-resiliency) (preview) for calls made through Container Apps service discovery. These policies don't apply to Dapr service invocation. For this architecture's Dapr calls, implement timeouts, bounded retries, and circuit breakers in the calling application.

For Dapr-enabled services, enable and configure [Dapr app health checks](/azure/container-apps/enable-dapr) alongside Container Apps health probes. Dapr links sidecar health to the application's health status.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This example architecture prioritizes demonstrating Dapr and event-driven scaling. It uses administrator credentials or access keys for several data services, doesn't deploy the Container Apps environment into a virtual network, and doesn't include a WAF. Don't use those settings for a production deployment.

- Assign a separate [managed identity](/azure/container-apps/managed-identity) to each container app. Grant each identity only the data-plane roles that its service requires. Use Microsoft Entra authentication for SQL Database, Service Bus, Blob Storage, Azure Cosmos DB, and Azure Managed Redis where the selected client or Dapr component supports it.

- Configure Azure-backed [Dapr components to use managed identity](/azure/container-apps/dapr-component-connect-services). If a component doesn't support managed identity, store its credential in Azure Key Vault and reference it through a Dapr secret store. Scope each Dapr component to only the apps that use it.

- Use managed identity for Service Bus [KEDA scale-rule authentication](/azure/container-apps/scale-app#authentication). Don't place namespace-level connection strings in container app secrets.

- Deploy the Container Apps environment into a [virtual network](/azure/container-apps/networking). Use private endpoints for supported data services and disable their public network access. Control outbound traffic with user-defined routes and Azure Firewall when the workload requires egress inspection or restrictions.

- Protect public HTTP traffic with Azure Web Application Firewall. Use [Application Gateway with Web Application Firewall](/azure/container-apps/waf-app-gateway) for regional ingress, or use [Azure Front Door Premium with Azure Private Link](/azure/container-apps/front-door-custom-virtual-network-private-link) for global ingress. Private Link origins require the Premium tier and a workload profiles environment. Disable public network access on the Container Apps environment when all inbound traffic uses private connectivity.

- Enable [Container Apps authentication and authorization](/azure/container-apps/authentication) for user-facing endpoints when it meets the workload's identity requirements. Apply authorization in the workload for resource-level decisions. Dapr service invocation provides mutual TLS for calls between Dapr-enabled apps, but it doesn't replace application authorization.

- Store images in a private Azure Container Registry instance. Pull images by using managed identity, pin deployable images by digest or an immutable version tag, scan images in the delivery pipeline, and avoid privileged containers.

- Scrub credentials, personal data, and sensitive business data from application and Dapr logs. Send security-relevant logs to a central destination, and configure alerts for authentication failures, unexpected outbound traffic, and changes to identities or network access.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use this [preconfigured estimate in the Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/?shared-estimate=3ea695bd3d824d3ab97c0e4091cdf4ee) as a starting point for a representative single-region production deployment. The estimate covers the container apps and their Dapr sidecar resource allocations, KEDA-based scaling, SQL Database, Azure Cosmos DB, Azure Managed Redis, Service Bus, Blob Storage, Azure Monitor, Application Insights, Key Vault, Container Registry, private endpoints, and Azure Front Door Premium with WAF and Private Link support.

The estimate uses pay-as-you-go pricing and representative request volume, replica counts, data capacity, messaging capacity, and telemetry ingestion. It excludes support plans, development and test environments, disaster recovery in a second region, and Application Gateway. Adjust the region, capacity, availability, data transfer, and usage assumptions to match your workload.

- Choose the Container Apps plan and workload profiles based on measured CPU, memory, and traffic requirements. Scale services to zero only when their availability and cold-start requirements allow it. Setting a higher minimum replica count can improve reliability but also increases compute costs. Account for the virtual worker's continuously running replica and its polling of the Makeline service. Stopping customer and dashboard traffic doesn't eliminate compute costs for these two services.

- Account for how each [workload profile](/azure/container-apps/workload-profiles-overview) bills. Consumption bills for the resources that running replicas use. Dedicated bills for every allocated profile instance, regardless of whether apps on it are busy, plus a Dedicated plan management fee for the environment. Private endpoints on the environment also incur the management fee, even if you don't use Dedicated profiles. For more information, see [Billing in Container Apps](/azure/container-apps/billing).

- Include Dapr sidecar resource consumption when you size each replica. Set explicit CPU and memory allocations for application containers, monitor actual use, and account for managed sidecar overhead in capacity planning.

- Treat SQL Database, Azure Cosmos DB, Azure Managed Redis, Service Bus, Blob Storage, Log Analytics, Application Insights, private endpoints, and an edge WAF as separate cost drivers. These services can continue to incur charges when container apps scale to zero.

- Set telemetry sampling, log categories, and retention periods deliberately. High-volume console, HTTP, dependency, and trace data can create significant ingestion and retention costs.

- Create budgets and cost alerts. Use consistent tags to allocate costs to the workload and its environments, and regularly compare provisioned capacity with observed use.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Define the Container Apps environment, container apps, Dapr components, identities, role assignments, scale rules, and monitoring configuration by using infrastructure as code. Use immutable image versions and Container Apps revisions to support staged deployments, health validation, rollback, and traffic splitting.

Configure the environment to use the Azure Monitor logging destination and route console and system logs through diagnostic settings. The legacy Log Analytics destination writes to the `ContainerAppConsoleLogs_CL` and `ContainerAppSystemLogs_CL` custom tables. Its underlying HTTP Data Collector API reached end of support on September 14, 2026. Ingestion continues for clients that use TLS 1.2 or later, but the API receives only critical security fixes, so migrate to remove the dependency. For migration guidance, see [Change Container Apps logging from Log Analytics to Azure Monitor](/azure/container-apps/migrate-logs-azure-monitor).

The following query uses the Azure Monitor resource-specific table to show recent Makeline service logs:

```kusto
ContainerAppConsoleLogs
| where ContainerAppName == "make-line-service"
| project TimeGenerated, RevisionName, ContainerName, Log
| order by TimeGenerated desc
```

Instrument each application with OpenTelemetry or an Application Insights SDK. Container Apps doesn't automatically instrument application code. You can use the managed [OpenTelemetry agent](/azure/container-apps/opentelemetry-agents) to route emitted logs and traces to Application Insights or another supported destination, but the application must still emit the telemetry.

When distributed tracing is configured across services, the Application Insights application map visualizes service and dependency relationships. Use it with logs and metrics to investigate failures and latency.

The following screenshot shows an application map in Application Insights.

:::image type="complex" border="false" source="./media/microservices-with-container-apps-dapr-appmap.png" alt-text="Screenshot that shows an application map in Application Insights." lightbox="./media/microservices-with-container-apps-dapr-appmap.png":::
   The screenshot shows an application map in Application Insights. The image includes seven circles that represent instances. The names of the instances are virtual-customers, order-service, receipt-generation-service, virtual-worker, make-line-service, loyalty-service, and accounting-service. Multiple lines flow between these instances. The image also shows dependencies for Dapr state and Dapr bindings.
:::image-end:::

Create alerts for failed revisions, unhealthy or restarting replicas, request failures and latency, replica saturation, scale-rule failures, Service Bus dead-letter growth, Dapr component errors, and failed dependencies. Connect alerts to an incident response process and test the notifications. For more information, see [Observability in Container Apps](/azure/container-apps/observability).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This solution uses the KEDA implementation in Container Apps for event-driven scaling. The virtual customer service places orders through the order service, which scales based on HTTP concurrency. The order service publishes messages to a Service Bus topic. The accounting, receipt, Makeline, and loyalty services scale based on the active message count in their subscriptions. The UI container app scales based on HTTP concurrency.

Set the target message count, HTTP concurrency, minimum replicas, maximum replicas, polling interval, and cooldown period based on load-test results. Include Dapr sidecar resource use and startup time in the test. Replica counts are scaling targets, not availability guarantees, so verify that the configured maximum can meet peak demand and that downstream data services can handle the resulting concurrency.

Make message handlers idempotent, define retry and dead-letter behavior, and tune message lock duration and concurrency so that scale-out doesn't cause duplicate processing or dependency throttling.

When the virtual customer isn't running, no users are accessing the UI, and the Service Bus subscriptions have no remaining messages, the order, accounting, receipt, loyalty, and UI services can scale to zero if their minimum replica counts are zero.

This example keeps the virtual worker at one replica because the worker continuously polls the Makeline service for order fulfillment. Those Dapr invocation calls count as incoming traffic for Makeline's HTTP scale rule, even when no orders are pending. For Makeline to remain scaled to zero, stop virtual worker polling as well as customer and dashboard traffic, drain its Service Bus subscription, and set its minimum replica count to zero. For services that must avoid cold starts or remain available during failures, set the minimum replica count to at least one. For more information, see [Set scaling rules in Container Apps](/azure/container-apps/scale-app).

#### Workload profiles

Use workload profiles to separate services that need warm capacity from services that benefit most from serverless elasticity. In the architecture diagram, the order service and accounting service are shown running in a Dedicated profile because they handle transactional work and support live business metrics. The receipt service and loyalty service are shown running in a Consumption profile because they're event-driven services that can take better advantage of serverless elasticity.

This split is illustrative. The services in this example don't have the sustained utilization, resource requirements, or isolation needs that require a Dedicated profile, and a Consumption profile with a minimum replica count that's greater than zero also keeps capacity warm. Choose a Dedicated profile when a service needs single-tenant compute isolation, more CPU or memory per replica than the Consumption profile provides, or sustained utilization high enough that per-instance billing costs less than consumption billing.

KEDA-based scale rules work across both Consumption and Dedicated workload profiles. Consumption is best for services that can scale to zero, while Dedicated is better for services that still benefit from autoscaling but need warm capacity or steadier performance.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Alice Gibbons](https://www.linkedin.com/in/alicejgibbons/) | Cloud Native Global Black Belt

Other contributors:

- [Lynn Orrell](https://www.linkedin.com/in/lynn-orrell/) | Principal Solution Specialist (GBB)
- [Kendall Roden](https://www.linkedin.com/in/kendallroden/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Container Apps documentation](/azure/container-apps/)
- [Compare Container Apps with other Azure container options](/azure/container-apps/compare-options)

## Related resources

- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [Build a CI/CD pipeline for AKS apps by using Azure Pipelines](../../guide/aks/aks-cicd-azure-pipelines.md)
