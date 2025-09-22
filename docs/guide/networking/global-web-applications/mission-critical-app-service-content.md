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

In this scenario, we consider scale units as temporary, which optimizes the rollout processes and provides scalability within and across regions. When you take this approach, you should store data only in the database because the database is replicated to the secondary region. If you need to store data in the scale unit, consider using Azure Cache for Redis for storage in the scale unit. If a scale unit must be abandoned, repopulating the cache might increase latency, but it doesn't cause outages.  

Application Insights is excluded from the scale unit. Exclude services that store or monitor data. Separate them into their own resource group with their own life cycle.

When you replace a scale unit or deploy a new one, keep historical data and use one instance for each region.

For more information, see [Application design of mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-application-design).

## Components

This architecture uses the following components.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web apps. In this architecture, App Service serves as the application-hosting platform within each scale unit. It provides the compute infrastructure for mission-critical web applications that have high availability and scalability requirements.

- [Azure Cache for Redis](/azure/well-architected/service-guides/azure-cache-redis/reliability) is an in-memory data structure store used as a database, cache, and message broker. In this architecture, Azure Cache for Redis caches requests within each scale unit to improve application performance. It can also serve as temporary storage for scale unit data that needs to be quickly repopulated if a scale unit is replaced.

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

The database platform that you choose affects the overall workload architecture, especially the platform's active-active or active-passive configuration support. The reliable web app pattern uses Azure SQL, which doesn't natively support active-active deployments that have write operations in more than one instance. In this configuration, the data platform is limited to an active-passive strategy. A (partial) active-active strategy on the application level is possible if there are read-only replicas in all regions and you only write to a single region.

:::image type="content" source="./media/mission-critical-web-apps/data-replication-architecture.svg" alt-text="A diagram that shows the architecture with Azure SQL Database replicated in each region." lightbox="./media/mission-critical-web-apps/data-replication-architecture.svg" border="false":::

Multiple databases are common in complex architectures, such as microservices architectures that have a database for each service. Multiple databases allow the adoption of a multiple-primary write database like Azure Cosmos DB, which improves high availability and low latency. Cross-region latency can create limitations. It's crucial to consider nonfunctional requirements and factors like consistency, operability, cost, and complexity. Enable individual services to use separate data stores and specialized data technologies to meet their unique requirements. For more information, see [Data platform considerations for mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-data-platform).

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