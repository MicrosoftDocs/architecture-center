This article describes how to deploy mission-critical web applications by using Azure App Service. The architecture uses the [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview) as a starting point. Use this architecture if you have a legacy workload and want to adopt platform-as-a-service (PaaS) services.

[Reliable web app pattern for .NET](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern) provides guidance for updating or replatforming web apps that you move to the cloud, minimizing required code changes, and targeting a service-level objective (SLO) of 99.9%. Mission-critical workloads have high reliability and availability requirements. To reach an SLO of 99.95%, 99.99%, or higher, you need to apply supplemental mission-critical design patterns and operational rigor. This article describes key technical areas and how to implement and introduce mission-critical design practices.

> [!NOTE]
> The guidance in this article is based on the design methodology and best practices in the [Well-Architected Framework mission-critical workload](/azure/architecture/framework/mission-critical/mission-critical-overview) series.

The following sections describe how to:

- Review the existing workload to understand its components, user and system flows, and availability and scalability requirements.
- Develop and implement a [scale-unit architecture](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) to optimize end-to-end scalability through compartmentalization and to standardize the process of adding and removing capacity.
- Implement stateless, ephemeral scale units or deployment stamps to enable scalability and zero-downtime deployments.
- Determine if you can split the workload into components to prepare for scalability. Individual components are required for scalability and decoupling flows.
- Prepare for [global distribution](/azure/well-architected/mission-critical/mission-critical-application-design#global-distribution) by deploying a workload across more than one Azure region to improve proximity to the customer and prepare for potential regional outages.
- Decouple components and implement an event-driven architecture.

## Architecture

The following diagram applies the previous considerations to the [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern).

:::image type="content" source="./media/mission-critical-web-apps/scale-unit-architecture.svg" alt-text="A diagram that shows the reliable we app pattern with a scale unit applied." lightbox="./media/mission-critical-web-apps/scale-unit-architecture.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/reliable-webapp-pattern.vsdx) of this architecture.*

The red box represents a scale unit with services that scale together. To effectively scale them together, optimize each service's size, SKU, and available IP addresses. For example, the maximum number of requests that Azure App Configuration serves correlates to the number of requests per second that a scale unit provides. When you add more capacity in a region, you must also add more individual scale units.

These individual scale units don't have any inter-dependencies and only communicate with shared services outside of the individual scale unit. You can test independent scale units upfront. To avoid affecting other areas of deployment, roll out independent scale units and introduce the option to replace services in a new release.

For mission-critical workloads, independent scale units are temporary, which optimizes the rollout processes and provides scalability within and across regions. Avoid storing state in independent scale units. Consider using Azure Cache for Redis for storage in the scale unit, and only store critical state or data that's also stored in the database. If there's a scale-unit outage or you switch to another scale unit, there might be a slowdown or a new sign in required, but Azure Cache for Redis still runs.

Application Insights is excluded from the scale unit. Exclude services that store or monitor data. Separate them into their own resource group with their own lifecycle.

When you replace a scale unit or deploy a new one, keep historical data and use one instance per region.

For more information, see [Application design of mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-application-design).

## Components

This architecture uses the following components.

- [App Service](https://azure.microsoft.com/products/app-service) is the application-hosting platform.
- [Azure Cache for Redis](https://azure.microsoft.com/products/cache) caches requests.
- [App Configuration](https://azure.microsoft.com/products/app-configuration) stores configuration settings.
- [Azure SQL](https://azure.microsoft.com/products/azure-sql) is the back-end database.
- [Application Insights](https://azuremarketplace.microsoft.com/marketplace/apps/Microsoft.AppInsights) gets telemetry from the application.

## Alternatives

In the reliable web app pattern, you can:

- Use Azure Kubernetes Service (AKS) instead of App Service. This option works well for complex workloads that have a large number of microservices. AKS provides more control over the underlying infrastructure and allows complex multitier setups.
- Containerize the workload. App Service supports containerization, but in this example the workload isn't containerized. Use containers to increase reliability and portability.

For more information, see [Application platform considerations for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-application-platform).

## Choose the application platform

The level of availability depends on your choice and configuration of the application platform. Consider the following mission-critical guidance:

- Use availability zones when possible.
- Select the right platform service for your workload.
- Containerize the workload.

*Availability sets* spread deployments across multiple fault and update domains within a datacenter. *Availability zones* spread deployments across individual datacenters within an Azure region. Availability zones are often prioritized, but which strategy you use depends on your workload. For example, latency-sensitive or chatty workloads might benefit from prioritizing availability sets. If you spread the workload across availability zones, it can increase latency and cost for cross-zone traffic. When you use availability zones, ensure that all services in a scale unit support them. All services in the reliable web app pattern support availability zones.

## Choose the data platform

The database platform you choose affects the overall workload architecture, especially the platform's active-active or active-passive configuration support. The reliable web app pattern uses Azure SQL, which doesn't natively support active-active deployments with write operations in more than one instance. So the database level is limited to an active-passive strategy. An active-active strategy on the application level is possible if there are read-only replicas and you write to a single region only.

:::image type="content" source="./media/mission-critical-web-apps/data-replication-workload.svg" alt-text="A diagram that shows the architecture with SQL Database replicated in each region." lightbox="./media/mission-critical-web-apps/data-replication-workload.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/reliable-webapp-pattern.vsdx) of this architecture.*

Multiple databases are common in complex architectures, such as microservices architectures that have a database for each service. Multiple databases allow the adoption of a multi-primary write database like Azure Cosmos DB, which improves high availability and low latency. Cross-region latency can create limitations. It's crucial to consider nonfunctional requirements and factors like consistency, operability, cost, and complexity. Enable individual services to use separate data stores and specialized data technologies to meet their unique requirements. For more information, see [Data platform considerations for mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-data-platform).

## Define a health model

In complex multitier workloads that spread across multiple datacenters and geographical regions, you must define a health model. Define user and system flows, specify and understand the dependencies between the services, understand the effect that outages or a performance degradation on one of the services can have on the overall workload, and monitor and visualize the customer experience to enable proper monitoring and improve manual and automated actions.

:::image type="content" source="./media/mission-critical-web-apps/outage-example.svg" alt-text="A diagram that shows how an App Configuration outage creates outages for other services." lightbox="./media/mission-critical-web-apps/outage-example.svg" border="false":::

The previous diagram shows how an outage or a degradation of a single component, like App Configuration, can cause potential performance degradation for the customer.

:::image type="content" source="./media/mission-critical-web-apps/outage-example-2.svg" alt-text="A diagram that shows how the outages can be split into separate scale units." lightbox="./media/mission-critical-web-apps/outage-example-2.svg" border="false":::

When you separate components into scale units, it allows you to stop sending traffic to the affected part of the application, such as an affected scale unit or the complete region.

For more information, see [Health modeling and observability of mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-health-modeling).

## Security and networking

There are strict networking and security requirements for workloads that migrate from an on-premises enterprise deployment. Not all established on-premises processes translate into a cloud environment. Evaluate these requirements if they're applicable in cloud environments.

Identity is often the primary security perimeter for cloud-native patterns. Enterprise customers might need more substantial security measures. To address their network security requirements, most of the Azure PaaS services can use Azure Private Link to implement the network as a security perimeter. Private Link can ensure that services are only accessible from within a virtual network. All services are accessible via private endpoints only. The following diagram shows how the only public internet-facing endpoint is Azure Front Door.

:::image type="content" source="./media/mission-critical-web-apps/front-end-workload.svg" alt-text="A diagram that shows the internet-facing endpoints in the architecture." lightbox="./media/mission-critical-web-apps/front-end-workload.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/reliable-webapp-pattern.vsdx) of this architecture.*

For the reliable web app pattern to set up a network as a security perimeter, it must use:

- Private Link for all services that support it.
- Azure Front Door premium as the only internet-facing public endpoint.
- Jumpboxes to access services via Azure Bastion.
- Self-hosted build agents that can access the services.

Another common network requirement for mission-critical applications is to restrict egress traffic to prevent data exfiltration. Restrict egress traffic by routing an Azure firewall through a proper firewall device and filtering it with the device. The [Azure mission-critical baseline architecture with network controls](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture) uses a firewall and Private Link.

## Deployment and testing

Downtime caused by erroneous releases or human error can be an issue for a workload that needs to always be available. Here are some key areas to consider:

- Zero-downtime deployments
- Ephemeral blue/green deployments
- Analyzing the lifecycle of individual components and grouping them together
- Continuous validation

[Zero-downtime deployments](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#zero-downtime-deployment) are key for mission-critical workloads. A workload that needs to always be up and running can't have a maintenance window to roll out newer versions. To work around this limitation, the Azure mission-critical architecture follows the zero-downtime deployments pattern. Changes are rolled out as new scale units or stamps that are tested end to end before traffic is incrementally routed to them. After all traffic is routed to the new stamp, old stamps are disabled and removed.

For more information, see [Deployment and testing for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Derya Aydin](https://www.linkedin.com/in/deryaaydin1) | Principal Technical Program Manager
- [Heyko Oelrichs](https://www.linkedin.com/in/heyko) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learning path: Build mission-critical workloads on Azure](/training/paths/build-mission-critical-workloads)
- [Challenge project: Design a mission-critical web application](/training/modules/azure-mission-critical)
- [The Azure enablement show: Designing a mission-critical workload on Azure](/shows/azure-enablement/designing-a-mission-critical-workload-on-azure)
- [Learn module: Design a health model for your mission-critical workload](/training/modules/design-health-model-mission-critical-workload)

## Related resources

- [Mission-critical baseline architecture on Azure](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)
- [Mission-critical baseline architecture with network controls](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture)
- [Mission-critical baseline architecture in an Azure landing zone](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-landing-zone)
- [Continuous validation with Azure Load Testing and Azure Chaos Studio](/azure/architecture/guide/testing/mission-critical-deployment-testing)
