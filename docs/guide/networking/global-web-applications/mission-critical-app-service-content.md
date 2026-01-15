This article describes how to deploy mission-critical web applications by using Azure App Service. The architecture uses the [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview) as a starting point. Use this architecture if you have a legacy workload and want to adopt platform as a service (PaaS) services.

[Reliable web app pattern for .NET](/azure/architecture/web-apps/guides/enterprise-app-patterns/reliable-web-app/dotnet/guidance) provides guidance for updating or replatforming web apps that you move to the cloud. This approach helps you minimize required code changes and target a service-level objective (SLO) of 99.9%. Mission-critical workloads have high reliability and availability requirements. To reach an SLO of 99.95%, 99.99%, or higher, you need to apply supplemental mission-critical design patterns and operational rigor. This article describes key technical areas and how to introduce and implement mission-critical design practices.

> [!NOTE]
> The guidance in this article is based on the design methodology and best practices in the [Well-Architected Framework mission-critical workload](/azure/architecture/framework/mission-critical/mission-critical-overview) series.

The following sections describe how to:

- Review an existing workload to understand its components, user and system flows, and availability and scalability requirements.
- Develop and implement a [scale-unit architecture](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) to optimize end-to-end scalability through compartmentalization and to standardize the process of adding and removing capacity.
- Implement stateless, ephemeral scale units or deployment stamps to enable scalability and zero-downtime deployments.
- Determine whether you can split the workload into components to prepare for scalability. Individual components are required for scalability and decoupling flows.
- Prepare for [global distribution](/azure/well-architected/mission-critical/mission-critical-application-design#global-distribution) by deploying a workload across more than one Azure region to improve proximity to the customer and prepare for potential regional outages.
- Decouple components and implement an event-driven architecture.

## Architecture

The following diagram applies the previous considerations to the [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern).

:::image type="complex" border="false" source="./media/mission-critical-web-apps/app-service-architecture.svg" alt-text="Diagram that shows the reliable web app pattern that has a scale unit applied." lightbox="./media/mission-critical-web-apps/app-service-architecture.svg":::
   The diagram shows a mission-critical web application architecture that spans two Azure regions and uses the reliable web app pattern. At the top, the diagram shows two user groups. Call center users on the left connect through Microsoft Entra ID, and Relecloud customers on the right connect directly. Both user groups connect to Azure Front Door and Web Application Firewall, which serves as the global entry point. Traffic flows from Azure Front Door to two parallel regional deployments. Each region exists within a Web Apps resource group. Within each region, the architecture contains multiple layers. The top layer includes Azure Front Door and Firewall components. Below that layer, each region has a Configuration section that includesAzure Key Vault and Azure App Configuration. The middle layer contains the application tier that has Web Apps for the web front end and Web Apps for the Web API. Both web apps connect to Application Insights for telemetry. Each region also includes a code deployment component. The network layer contains four subnets: Front-end App Service subnet at the top, API App Service subnet below it, and two private endpoint subnets at the bottom. Azure Private Link connections link the services to the private endpoint subnets. The bottom of each region contains a data layer that has Azure SQL Database on the left and Azure Storage on the right. Private endpoints provide access to both data services. Between the two regions, the diagram shows DNS zones and Azure Managed Redis in a central position. Dotted lines show network traffic flow between components. Arrows indicate the direction from users through Azure Front Door and down through the application layers to the data services. The architecture demonstrates high availability through regional redundancy, security through private endpoints, and global distribution through managed Azure services across multiple regions.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/reliable-webapp-pattern1.vsdx) of this architecture.*

The red box represents a scale unit with services that scale together. To effectively scale them together, optimize each service's size, SKU, and available IP addresses. For example, the maximum number of requests that Azure App Configuration serves correlates to the number of requests per second that a scale unit provides. When you add more capacity in a region, you must also add more individual scale units.

These individual scale units don't have any dependencies on one another and only communicate with shared services outside of the individual scale unit. You can use these scale units in a [blue-green deployment](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-deploy-test#deployment-zero-downtime-updates) by rolling out new scale units, validating that they function correctly, and gradually moving production traffic onto them.

In this scenario, scale units are temporary, which improves rollout processes and provides scalability within and across regions. With this approach, store persistent system-of-record (SOR) data only in the database because the database replicates to the secondary region.

In addition, use Azure Managed Redis within or alongside a scale unit to store auxiliary application state like cache data, session state, rate-limit counters, feature flags, and coordination metadata within the scale unit. Active geo-replication lets Redis data replicate asynchronously across regions to improve resiliency and reduce recovery time objectives (RTO) during regional failover scenarios. This capability typically applies to auxiliary state that must survive regional outages, while entirely rebuildable cache data should remain local to a scale unit.

When scale units are replaced or retired, applications must be able to reconnect transparently to the Redis endpoint. Design cached data in one of the following ways:

- **Rebuildable state**, which includes cache entries that you can repopulate without affecting availability

- **Durable auxiliary state**, which your cache's availability, persistence, and geo-replication features protect

Application Insights is excluded from the scale unit. Exclude services that store or monitor data. Separate them into their own resource group with their own life cycle.

When you replace a scale unit or deploy a new one, keep historical data and use one instance for each region.

For more information, see [Application design of mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-application-design).

## Components

This architecture uses the following components.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web apps. In this architecture, App Service serves as the application-hosting platform within each scale unit. It provides the compute infrastructure for mission-critical web applications that have high availability and scalability requirements.

- [Azure Managed Redis](/azure/redis/overview) is a Redis Enterprise-based, fully managed, in-memory data platform. In this architecture, Azure Managed Redis provides low-latency access to auxiliary application state within or alongside each scale unit, like caching, session data, rate limiting, feature flags, and distributed coordination. It supports clustering, availability zones, optional persistence, and active geo-replication, which makes it suitable for mission-critical workloads.

- [App Configuration](/azure/azure-app-configuration/overview) is a service that centrally manages application settings and feature flags. In this architecture, App Configuration stores configuration settings for the application within the scale unit. Its capacity directly correlates to the number of requests per second that each scale unit can handle.

- [Azure SQL](/azure/azure-sql/) is a collection of managed SQL database services built on the SQL Server database engine. In this architecture, Azure SQL serves as the back-end database that stores persistent data and is replicated to secondary regions.

- [Application Insights](/azure/well-architected/service-guides/application-insights) is an application performance management service that provides monitoring and analytics capabilities. In this architecture, Application Insights collects telemetry from the application. It's excluded from the scale units to maintain its own life cycle for historical data retention and cross-stamp monitoring.

## Alternatives

In the reliable web app pattern, you can:

- Use Azure Kubernetes Service (AKS) instead of App Service. This option works well for complex workloads that have a large number of microservices. AKS provides more control over the underlying infrastructure and allows complex multitier setups.
- Containerize the workload. App Service supports containerization, but in this example the workload isn't containerized. Use containers to increase reliability and portability.

For more information, see [Application platform considerations for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-application-platform).

## Considerations for high availability

Regardless of the application platform that you choose, we recommend that you prioritize the use of availability zones for production workloads.

*Availability sets* spread deployments across multiple fault and update domains within a datacenter. *Availability zones* spread deployments across individual datacenters within an Azure region. Availability zones are often prioritized, but which strategy you use depends on your workload. For example, latency-sensitive or chatty workloads might benefit from prioritizing availability sets. If you spread the workload across availability zones, it can increase latency and cost for cross-zone traffic. When you use availability zones, ensure that all services in a scale unit support them. All services in the reliable web app pattern support availability zones.

## Choose the data platform

The data platform that you choose affects the overall workload architecture, especially the platform's support for active-active or active-passive deployment models. In the reliable web app pattern, Azure SQL serves as the primary relational data platform. Azure SQL doesn't natively support active-active deployments that have concurrent writes in more than one region. As a result, this pattern typically follows an active-passive strategy at the database layer. A partial active-active approach is possible at the application tier by deploying read-only replicas in multiple regions while directing all write operations to a single primary region.

:::image type="complex" border="false" source="./media/mission-critical-web-apps/data-replication-architecture.svg" alt-text="Diagram that shows the architecture that has Azure SQL Database replicated in each region." lightbox="./media/mission-critical-web-apps/data-replication-architecture.svg":::
   The diagram shows a data replication architecture for a mission-critical web application that deploys across two Azure regions and uses an active-passive database strategy. At the top of the diagram, user traffic enters through Azure Front Door, which serves as the global entry point and load balancer. Below Azure Front Door, the architecture splits into two parallel regional deployments labeled Region 1 on the left and Region 2 on the right. Each region contains an identical application tier that has App Service instances that host the web application and API layers. In the center between the two regions, Azure Managed Redis serves as a shared caching layer that spans both regions and supports active geo-replication for auxiliary application state. At the bottom of each region, Azure SQL Database instances form the data persistence layer. The SQL Database in Region 1 serves as the primary database that has read-write capabilities. The SQL Database in Region 2 serves as a read-only replica. A dashed line connects the two database instances to represent the asynchronous replication relationship. All write operations from both regional application tiers direct to the primary database in Region 1. The read-only replica in Region 2 serves read operations locally. This configuration demonstrates an active-passive database pattern where only one region accepts writes while both regions serve read traffic, which enables high availability and geographic distribution and maintains data consistency through a single write endpoint.
:::image-end:::

Multiple databases are common in complex architectures, such as microservices architectures that have a database for each service. Multiple databases allow the adoption of a multiple-primary write database like Azure Cosmos DB, which improves high availability and low latency. Cross-region latency can create limitations. It's crucial to consider nonfunctional requirements and factors like consistency, operability, cost, and complexity. Enable individual services to use separate data stores and specialized data technologies to meet their unique requirements. For more information, see [Data platform considerations for mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-data-platform).

### Caching platform

In write-heavy workloads or workloads that require very low write latency, writing directly to the relational database in the request path can create a scalability or latency bottleneck. In these scenarios, introduce Azure Managed Redis as an application-tier data platform to accelerate write throughput and protect the SOR database.

With this approach, Azure Managed Redis serves as the initial write target for selected data domains, while data persists asynchronously to Azure SQL by using a **write-behind (write-back) pattern**. This design allows the application to absorb bursts of writes with low latency while maintaining Azure SQL as the authoritative SOR. Typical use cases include session updates, counters, rate limiting, state transitions, telemetry aggregation, and other data that can tolerate eventual consistency.

Azure Managed Redis also supports active geo-replication, which lets Redis-backed data replicate asynchronously across regions. When applied selectively, active geo-replication allows specific categories of application state to participate in active-active application designs, even when the primary relational database remains active-passive. This capability can significantly reduce RTOs during regional failover scenarios.

In addition to write-behind caching, mission-critical workloads often use **prefetch (read-ahead) caching** to proactively load data into Azure Managed Redis based on predicted access patterns, scheduled jobs, or change events. Prefetching reduces cold-start latency for new scale units and improves tail latency during traffic spikes, which is especially important when scale units are ephemeral.

## Define a health model

In complex multitier workloads that spread across multiple datacenters and geographical regions, you must define a health model.

To define a health model:

- Define user and system flows
- Specify and understand the dependencies between the services
- Understand the effect that outages or a performance degradation on one of the services can have on the overall workload
- Monitor and visualize the customer experience to enable proper monitoring and improve manual and automated actions.

:::image type="complex" border="false" source="./media/mission-critical-web-apps/outage-example.svg" alt-text="Diagram that shows how an App Configuration outage creates outages for other services." lightbox="./media/mission-critical-web-apps/outage-example.svg":::
   The diagram shows a dependency flow that illustrates how a single component failure cascades through a mission-critical application architecture. At the top of the diagram, App Configuration appears as the initial point of failure. A red indicator marks it to denote an outage state. Below App Configuration, the diagram shows two parallel App Service instances that sit side by side in the middle layer, which represent the application tier. Arrows flow downward from App Configuration to both App Service instances to indicate that both services depend on App Configuration for their configuration data. Because App Configuration experiences an outage, both App Service instances inherit a degraded or failed state. Red indicators mark these instances. At the bottom of the diagram, users appear as the final component in the dependency chain. Arrows flow downward from both App Service instances to the users to show that user traffic routes through these application services. The red indicators extend to the user layer to demonstrate that the App Configuration outage ultimately affects the customer experience.
:::image-end:::

The previous diagram shows how an outage or a degradation of a single component, like App Configuration, can cause potential performance degradation for the customer. When you separate components into scale units, it allows you to stop sending traffic to the affected part of the application, such as an affected scale unit or the complete region.

The criteria for determining the health of a scale unit are defined in the health model. This model is then connected to the _health endpoint_ of the scale unit, which allows the global load balancer to query the health state of a scale unit and use that information for routing decisions. 

For more information, see [Health modeling and observability of mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-health-modeling).

## Security and networking

Mission-critical workloads have strict networking and security requirements. Apply diligence especially to workloads migrated from an on-premises environment because not all established on-premises security practices translate to a cloud environment. We recommend that you reevaluate security requirements during the application migration.

Identity is often the primary security perimeter for cloud-native patterns. Enterprise customers might need more substantial security measures. To address their network security requirements, Azure PaaS services can use Azure Private Link to implement the network as a security perimeter. Private Link helps ensure that services are only accessible from within a virtual network. All services are then accessible via private endpoints only. The following diagram shows how the only public internet-facing endpoint is Azure Front Door.

:::image type="complex" source="./media/mission-critical-web-apps/front-end-architecture.svg" alt-text="A diagram that shows the internet-facing endpoints in this architecture." lightbox="./media/mission-critical-web-apps/front-end-architecture.svg" border="false":::
   The diagram shows a network security architecture that implements a network perimeter through Private Link and private endpoints, where Azure Front Door serves as the sole public internet-facing component. At the top left of the diagram, external users from the public internet appear as the entry point. Arrows flow from these users to Azure Front Door, positioned at the top center, which serves as the single public endpoint that accepts inbound traffic from the internet. A cloud boundary icon separates the public internet from the Azure environment to indicate the security perimeter. From Azure Front Door, traffic flows into a virtual network. A large box represents the virtual network and contains all internal Azure services. Inside the virtual network boundary on the left side, the diagram shows a vertical arrangement of private Azure PaaS services that include App Service, Azure SQL Database, Azure Storage, and App Configuration. Each of these services connects to the virtual network through Private Link. On the right side of the virtual network, the diagram shows App Service instances and other compute resources that communicate through the internal virtual network fabric rather than over the public internet to reach the PaaS services. Dotted lines that have arrows connect these internal services to show the private communication paths that flow between services within the virtual network. At the bottom right, Azure Bastion appears and includes a jump box to illustrate administrative access to internal resources without direct internet exposure. All arrows that connect services inside the virtual network remain within the network boundary to emphasize that no internal service exposes a public endpoint.
:::image-end:::

For the reliable web app pattern to set up a network as a security perimeter, it must use:

- Private Link for all services that support it.
- Azure Front Door Premium as the only internet-facing public endpoint.
- Jump boxes to access services via Azure Bastion.
- Self-hosted build agents that can access the services.

Another common network requirement for mission-critical applications is to restrict egress traffic to help prevent data exfiltration. Restrict egress traffic by routing all traffic leaving the subnet through a firewall device where the traffic is filtered before continuing to its next hop.

## Deployment and testing

Downtime that's caused by erroneous releases or human error can be a problem for a workload that needs to always be available. Here are some key areas to consider:

- Zero-downtime deployments
- Ephemeral blue-green deployments
- Life cycle analysis of individual and grouped components
- Continuous validation

[Zero-downtime deployments](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#zero-downtime-deployment) are key for mission-critical workloads. A workload that needs to always be up and running can't have a maintenance window to roll out newer versions. To work around this limitation, the Azure mission-critical architecture follows the zero-downtime deployments pattern. Changes are rolled out as new scale units or stamps that are tested end to end before traffic is incrementally routed to them. After all traffic is routed to the new stamp, the old stamps are disabled and removed.

For more information, see [Deployment and testing for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing).

## Next steps

- [Learning path: Build mission-critical workloads on Azure](/training/paths/build-mission-critical-workloads)
- [Challenge project: Design a mission-critical web application](/training/modules/azure-mission-critical)
- [Learn module: Design a health model for your mission-critical workload](/training/modules/design-health-model-mission-critical-workload)

## Related resources

- [Mission-critical architecture on Azure](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)
- [Continuous validation with Azure Load Testing and Azure Chaos Studio](/azure/architecture/guide/testing/mission-critical-deployment-testing)