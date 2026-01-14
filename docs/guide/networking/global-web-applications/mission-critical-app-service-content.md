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

:::image type="content" source="./media/mission-critical-web-apps/app-service-architecture.svg" alt-text="A diagram that shows the reliable web app pattern with a scale unit applied." lightbox="./media/mission-critical-web-apps/app-service-architecture.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/reliable-webapp-pattern1.vsdx) of this architecture.*

The red box represents a scale unit with services that scale together. To effectively scale them together, optimize each service's size, SKU, and available IP addresses. For example, the maximum number of requests that Azure App Configuration serves correlates to the number of requests per second that a scale unit provides. When you add more capacity in a region, you must also add more individual scale units.

These individual scale units don't have any dependencies on one another and only communicate with shared services outside of the individual scale unit. You can use these scale units in a [blue-green deployment](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-deploy-test#deployment-zero-downtime-updates) by rolling out new scale units, validating that they function correctly, and gradually moving production traffic onto them.

In this scenario, we consider scale units as temporary, which optimizes the rollout processes and provides scalability within and across regions. When you take this approach, you should store data only in the database because the database is replicated to the secondary region. For this purpose, **Azure Managed Redis (AMR)** can be used within or alongside a scale unit to store auxiliary application state such as caching data, session state, rate-limiting counters, feature flags, and coordination metadata. Because AMR is based on Redis Enterprise, it supports high availability, clustering, optional persistence, and **Active Geo-Replication**, allowing Redis-backed state to participate safely in mission-critical designs.

When required, Active Geo-Replication enables Redis data to be asynchronously replicated across regions to improve resiliency and reduce recovery time objectives (RTO) during regional failover scenarios. This capability is typically applied to auxiliary state that must survive regional outages, while purely rebuildable cache data can remain local to a scale unit or region.

When scale units are replaced or abandoned, applications must be able to reconnect transparently to Redis. Redis-backed data should be designed as either:
- **Rebuildable state**, such as cache entries that can be repopulated without affecting availability, or
- **Durable auxiliary state**, protected by Redis Enterprise availability, persistence, and geo-replication features.

Application Insights is excluded from the scale unit. Exclude services that store or monitor data. Separate them into their own resource group with their own life cycle.

When you replace a scale unit or deploy a new one, keep historical data and use one instance for each region.

For more information, see [Application design of mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-application-design).

## Components

This architecture uses the following components.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web apps. In this architecture, App Service serves as the application-hosting platform within each scale unit. It provides the compute infrastructure for mission-critical web applications that have high availability and scalability requirements.

- [Azure Managed Redis](/azure/redis/overview) is a Redis Enterprise–based, fully managed, in-memory data platform. In this architecture, AMR provides low-latency access to auxiliary application state within or alongside each scale unit, such as caching, session data, rate limiting, feature flags, and distributed coordination. It supports clustering, availability zones, optional persistence, and Active Geo-Replication, making it suitable for mission-critical workloads.

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

The data platform that you choose affects the overall workload architecture, especially the platform’s support for active-active or active-passive deployment models. In the reliable web app pattern, Azure SQL is used as the primary relational data platform. Azure SQL does not natively support active-active deployments with concurrent writes in more than one region. As a result, this pattern typically follows an active-passive strategy at the database layer. A partial active-active approach is possible at the application tier by deploying read-only replicas in multiple regions while directing all write operations to a single primary region.

:::image type="content" source="./media/mission-critical-web-apps/data-replication-architecture.svg" alt-text="A diagram that shows the architecture with Azure SQL Database replicated in each region." lightbox="./media/mission-critical-web-apps/data-replication-architecture.svg" border="false":::

For some mission-critical workloads, particularly those that are write-heavy or require very low write latency, writing directly to the relational database in the request path can become a scalability or latency bottleneck. In these scenarios, Azure Managed Redis can be introduced as an application-tier data platform to accelerate write throughput and protect the system-of-record database.

With this approach, Azure Managed Redis serves as the initial write target for selected data domains, while data is persisted asynchronously to Azure SQL using a **write-behind (write-back) pattern**. This design allows the application to absorb bursts of writes with low latency, while maintaining Azure SQL as the authoritative system of record. Typical use cases include session updates, counters, rate limiting, state transitions, telemetry aggregation, and other data that can tolerate eventual consistency.

Azure Managed Redis, based on Redis Enterprise, also supports **Active Geo-Replication**, enabling Redis-backed data to be replicated asynchronously across regions. When applied selectively, Active Geo-Replication allows certain categories of application state to participate in active-active application designs, even when the primary relational database remains active-passive. This capability can significantly reduce recovery time objectives (RTO) during regional failover scenarios.

In addition to write-behind, mission-critical workloads often use **prefetch (read-ahead) caching** to proactively load data into Azure Managed Redis based on predicted access patterns, scheduled jobs, or change events. Prefetching reduces cold-start latency for newly deployed scale units and improves tail latency during traffic spikes, which is particularly important when scale units are treated as ephemeral.

Complex architectures commonly use multiple data platforms, such as microservices architectures where each service owns its own data store. Using multiple databases allows workloads to adopt specialized data technologies—such as Azure SQL for relational consistency, Azure Managed Redis for low-latency and high-throughput state, or Azure Cosmos DB for multi-primary writes—based on each service’s requirements. When making these choices, it is critical to evaluate nonfunctional requirements including consistency, availability, latency, operability, cost, and overall complexity.

For more information, see [Data platform considerations for mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-data-platform).

## Define a health model

In complex multitier workloads that spread across multiple datacenters and geographical regions, you must define a health model.

To define a health model:

- Define user and system flows
- Specify and understand the dependencies between the services
- Understand the effect that outages or a performance degradation on one of the services can have on the overall workload
- Monitor and visualize the customer experience to enable proper monitoring and improve manual and automated actions.

:::image type="content" source="./media/mission-critical-web-apps/outage-example.svg" alt-text="A diagram that shows how an App Configuration outage creates outages for other services." lightbox="./media/mission-critical-web-apps/outage-example.svg" border="false":::

The previous diagram shows how an outage or a degradation of a single component, like App Configuration, can cause potential performance degradation for the customer. When you separate components into scale units, it allows you to stop sending traffic to the affected part of the application, such as an affected scale unit or the complete region.

The criteria for determining the health of a scale unit are defined in the health model. This model is then connected to the _health endpoint_ of the scale unit, which allows the global load balancer to query the health state of a scale unit and use that information for routing decisions. 

For more information, see [Health modeling and observability of mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-health-modeling).

## Security and networking

Mission-critical workloads have strict networking and security requirements. Apply diligence especially to workloads migrated from an on-premises environment because not all established on-premises security practices translate to a cloud environment. We recommend that you reevaluate security requirements during the application migration.

Identity is often the primary security perimeter for cloud-native patterns. Enterprise customers might need more substantial security measures. To address their network security requirements, Azure PaaS services can use Azure Private Link to implement the network as a security perimeter. Private Link helps ensure that services are only accessible from within a virtual network. All services are then accessible via private endpoints only. The following diagram shows how the only public internet-facing endpoint is Azure Front Door.

:::image type="content" source="./media/mission-critical-web-apps/front-end-architecture.svg" alt-text="A diagram that shows the internet-facing endpoints in this architecture." lightbox="./media/mission-critical-web-apps/front-end-architecture.svg" border="false":::

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