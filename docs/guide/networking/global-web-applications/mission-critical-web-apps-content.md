This article builds on the [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview) to support mission-critical workloads. It provides guidance for deploying mission-critical web applications by using the Web Apps feature of Azure App Service.

> [!NOTE]
> The [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern) for .NET provides guidance for updating or replatforming web apps that you move to the cloud, minimizing required code changes, and targeting a service-level objective (SLO) of 99.9%.

The reliable web app pattern is a good place to start if you have a legacy workload and want to adopt platform-as-a-service (PaaS) services. The example uses services such as App Service for the application hosting platform, Azure Cache for Redis to cache requests, Azure App Configuration to store configuration settings, Azure SQL as the back-end database, and Application Insights to get telemetry from the application.

While that is sufficient for many scenarios, mission-critical workloads have greater reliability and availability requirements. To reach an SLO of 99.95%, 99.99% or higher, you need to apply supplemental mission-critical design patterns and operational rigor. This article describes key technical areas and how to implement and introduce mission-critical design practices.

> [!NOTE]
> The guidance in this article is based on the design methodology and best practices in the [Well-Architected mission-critical workload](/azure/architecture/framework/mission-critical/mission-critical-overview) series.

## Application design

- Review the existing workload to understand its components, **user and system flows**, and the availability and scalability requirements.
- Develop and implement a [**scale-unit architecture**](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) to optimize end-to-end scalability through compartmentalization and to standardize the process of adding and removing capacity.
- Implement stateless, ephemeral scale-units or deployment stamps to enable scalability and zero-downtime deployments.
- Determine if the workload can be split into components to prepare for scalability. Individual components are a key prerequisite for **scalability and decoupling flows**.
- Prepare for [**global distribution**](/azure/well-architected/mission-critical/mission-critical-application-design#global-distribution)by deploying a workload across more than one Azure region to improve proximity to the end user and prepare for potential regional outages.
- Decouple components and implement an event-driven architecture.

Let's apply those considerations to the [reliable web app pattern](/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern).

![](RackMultipart20230731-1-egai8a_html_15a60303a5c8aebf.png)

The red box represents a scale unit. The scale-unit services should scale together, and each service, its sizing, SKU, available IP addresses should be optimized to scale together. For example, the maximum number of requests App Configuration can serve impacts the numbers of requests per second a scale unit can provide. The process of adding new capacity in a region translates into adding an additional scale unit.

These individual scale units shouldn't have any inter-dependencies and should only communicate with shared services outside of the individual scale unit. Independent scale units can be tested upfront, rolled out independently and introduce the ability to replace services as part of a new release without affecting the rest of the deployment.

Avoid storing state within these scale units because for mission-critical workloads, they are expected to be ephemeral or temporary. This is a prerequisite for scalability within and especially across regions and to optimize rollout processes. You can consider having Azure Cache for Redis as part of the scale unit. In that case, no critical state or data should be stored that isn't already stored in the database. An outage or switch to another scale unit could result in a slowdown or require a new login but should not cause an outage.

Note that Application Insights was excluded from the scale unit. You might want to exclude services that store data, including monitoring data from the scale unit and separate them into their own resource group with their own lifecycle.

When replacing a scale unit or deploying a new one, you might want to keep historical data and use one instance per region.

For more information, see [Application design of mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-application-design).

### Application platform

The level of availability depends on your choice and configuration of the application platform. Consider the following mission-critical guidance:

- Use availability zones when possible.
- Select the right platform service for your workload.
- Containerize the workload.

**Availability sets** spread deployments across multiple fault and update domains within a datacenter. **Availability zones** spread deployments across individual datacenters within an Azure region. Though availability zones should be prioritized, selecting one over the other depends on the workload. For latency-sensitive or very chatty workloads it might be a bad idea to spread it across availability zones, as this introduces latency and additional cost for cross-zone traffic. When using availability zones, ensure that all services used in a scale-unit support availability zones.

All the services used in the reliable web app pattern support availability zones.

## Alternatives

In the web app pattern, you can:

- Use Azure Kubernetes Service (AKS) instead of App Service. This option might work well for complex workloads that consist of a large number of different (micro) services. AKS provides more control over the underlying infrastructure and allows complex multitier setups.
- Containerize the workload. App Service supports containerization, but in this example the workload isn't containerized. Use containers to increase reliability and portability.

For more information, see [Application platform considerations for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-application-platform).

### Data platform

The selection of the database platform has key implications for the overall workload architecture, especially the platform's support for active-active or active-passive configuration. The reliable web app pattern uses Azure SQL. Azure SQL doesn't natively support active-active deployments with write operations in more than one instance. This limits us, at least on the database level, to an active/passive strategy. On the application level, it could be considered if read/write can be separated benefit from read-only replicas while writing to a single region only.

![](RackMultipart20230731-1-egai8a_html_fa7865485aad3796.png)

Multiple databases are common in complex architectures, such as a microservices architecture that has a database for each service. This allows the adoption of a multi-master write database like Azure Cosmos DB, which enhances high availability and low latency, but limitations exist due to cross-region latency. It is crucial to consider nonfunctional requirements alongside factors like consistency, operability, cost, and complexity. By enabling individual services to use separate data stores and specialized data technologies, their unique requirements can be effectively met. For more information, see [Data platform considerations for mission-critical workloads on Azure](/azure/well-architected/mission-critical/mission-critical-data-platform).

### Define a health model

In complex multitier workloads that spread across multiple datacenters and geographical regions, you must define a health model. Define user and system flows, specify and understand the dependencies between the services, understand the impact that outages or a performance degradation on one of the services can have on the overall workload, and monitor and visualize the end user experience to enable proper monitoring and improve manual and automated actions.

![](RackMultipart20230731-1-egai8a_html_e6f20040182e88b0.png)

The previous diagram shows how an outage, or a degradation, of a single component, like App Configuration, can bubble up to the top and cause potential performance degradation for the end user.

![](RackMultipart20230731-1-egai8a_html_e9604882d49ba167.png)

Manual or automated actions based on this could be to stop sending traffic to the affected part of the application, for example an affected scale unit or the complete region.

For more information, see [Health modeling and observability of mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-health-modeling).

### Security and Networking

- Private link / network security perimeter
- Restrict egress traffic

There are strict networking and security requirements for workloads that migrate from an on-premises enterprise deployment. Not all established on-premises processes translate into a cloud environment. Evaluate these requirements if they're applicable in cloud environments.

Identity is often the primary security perimeter for cloud-native patterns. This may not be acceptable for enterprise customers. To address their network security requirements, most Azure's PaaS services can use Azure Private Link to keep the network as a security perimeter. Private Link can ensure that services are only accessible from within a virtual network. The [Azure mission-critical baseline architecture with network controls](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture) factors this in.

All services are accessible via private endpoints only. The only public, internet-facing endpoint is Azure Front Door.

![](RackMultipart20230731-1-egai8a_html_561c646b8522ab48.png)

For the reliable web app pattern to implement network as a security perimeter, it must use:

- Private Link for all services that support it.
- Azure Front Door premium as the only internet-facing public endpoint.
- Jumpboxes to access services via Azure Bastion.
- Self-hosted build agents that can access the services.

Another common network requirement for mission-critical applications is to restrict egress traffic to prevent data exfiltration. Restrict egress traffic by routing an Azure firewall through a proper firewall device and filtering it with the device. The Azure mission-critical baseline architecture with network controls follows this guidance.

### Deployment and testing

Deployment and testing is an important design area for mission-critical workloads. Erroneous releases or human error during manual activities can cause downtimes which might not be acceptable for a workload that needs to be available 24x7. Here are some key areas that should be taken into consideration:

- Zero-downtime deployments
- Ephemeral blue/green deployments
- Analyze the lifecycle of individual components and group them together.
- Continuous validation

[Zero-downtime deployments](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#zero-downtime-deployment) are key for mission-critical workloads. A workload that needs to be up 24x7x365 cannot accept a maintenance window to rollout newer versions. To avoid that, the Azure Mission-critical architecture follows the "zero-downtime deployments" pattern. Changes are rolled out as new scale-units (or stamps) that can be tested end-to-end before traffic is incrementally routed to them. Once all traffic is routed to the new stamp, old stamps can be disabled and removed.

For more information, please see [Deployment and testing for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#zero-downtime-deployment).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Derya Aydin](https://www.linkedin.com/in/deryaaydin1) | Principal Technical Program Manager
- [Heyko Oelrichs](https://www.linkedin.com/in/heyko) | Senior Software Engineer

## Next steps

## Related resources
