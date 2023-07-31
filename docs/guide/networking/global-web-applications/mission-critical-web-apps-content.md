# Mission-critical baseline with App Service

This article builds on the [reliable web app pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview) to support mission-critical workloads. It provides prescriptive guidance for deploying mission-critical web applications with Azure App Services.

[!IMPORTANT] The [reliable web app pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern) for .NET provides guidance on updating web apps moving to the cloud (re-platforming) with a focus on minimizing required code changes. It targets a Service Level Objective (SLO) of 99.9%.

The reliable web app pattern is a good place to start if you have a legacy workload and want to adopt PaaS services. The example uses services such as App Service for the application hosting platform, Redis Cache to cache requests, App Config to store configuration settings, Azure SQL as the backend database, and Application Insights to get telemetry from the application.

While that is sufficient for many scenarios, mission-critical workloads have greater reliability and availability requirements. To reach an SLO of 99.95%, 99.99% or higher, you need to apply supplemental mission-critical design patterns and operational rigor. In this article we'll take a deeper look at the key technical areas and how to implement and introduce mission-critical design practices.

[!IMPORTANT] The guidance within this article is based on the design methodology and best practices described in the [Well-Architected mission-critical workload](https://learn.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-overview) series.

## Application design

- Review the existing workload to understand its components, **user and system flows** and the availability and scalability requirements.
- Develop and implement a [**scale-unit architecture**](https://learn.microsoft.com/en-us/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) to optimize end-to-end scalability through compartmentalization, and to standardize the process of adding and removing capacity.
- Implement stateless, ephemeral scale-units or deployment stamps to enable scalability and zero-downtime deployments.
- Determine if the workload can be split into components to prepare for scalability. Individual components are a key prerequisite for **scalability and decoupling flows**.
- Prepare for [**global distribution**](https://learn.microsoft.com/en-us/azure/well-architected/mission-critical/mission-critical-application-design#global-distribution)by deploying a workload across more than one Azure region to improve proximity to the end user and prepare for potential regional outages.
- Decouple components and implement an event-driven architecture.

Let's apply those considerations to the [reliable web app pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/reliable-web-app/dotnet/pattern-overview#architecture-and-pattern).

![](RackMultipart20230731-1-egai8a_html_15a60303a5c8aebf.png)

The red box represents a scale unit. The scale-unit services should scale together, and each service, its sizing, SKU, available IP addresses should be optimized to scale together. For example, the maximum number of requests Azure App Configuration can serve impacts the numbers of requests per second a scale unit can provide. The process of adding new capacity in a region translates into adding an additional scale unit.

These individual scale units shouldn't have any inter-dependencies and should only communicate with shared services outside of the individual scale unit. Independent scale units can be tested upfront, rolled out independently and introduce the ability to replace services as part of a new release without affecting the rest of the deployment.

Avoid storing state within these scale units because for mission-critical workloads, they are expected to be ephemeral or temporary. This is a prerequisite for scalability within and especially across regions and to optimize rollout processes. You can consider having Redis Cache as part of the scale unit. In that case, no critical state or data should be stored that isn't already stored in the database. An outage or switch to another scale unit could result in a slowdown or require a new login but should not cause an outage.

Note that Application Insights was excluded from the scale-unit. You might want to exclude services that store data, including monitoring data from the scale unit and separate them into their own resource group with their own lifecycle.

When replacing a scale-unit or deploying a new one, you might want to keep historical data and use one instance per region.

For more information, see [Application design of mission-critical workloads on Azure](https://learn.microsoft.com/en-us/azure/well-architected/mission-critical/mission-critical-application-design).

### Application platform

Your choice and configuration of the application platform strongly influences availability. Consider the following Azure mission-critical guidance:

- Leverage Availability Zones when possible
- Select the right platform service for your workload
- Containerize the workload

**Availability Sets** spread deployments across multiple fault and update domains within a data center. **Availability Zones (AZs)** spread deployments across individual data centers within an Azure region. Though AZs should be prioritized, selecting one over the other depends on the workload. For latency-sensitive or very chatty workloads it might be a bad idea to spread it across AZs, as this introduces latency and additional cost for cross-zone traffic. When using AZs, ensure that all services used in a scale-unit support Availability Zones.

All the services used in the reliable web app pattern support Availability Zones.

Potential changes to the reliable web app pattern are:

- Azure App Service could be replaced with Azure Kubernetes Service - This especially makes sense for more complex workloads that consists of a large number of different (micro) services. Kubernetes provides more control over the underlying infrastructure and allows complex multi-tier setups.
- Containerize the workload – The workload is not yet containerized, although Azure App Service does support that. The use of containers is recommended to increase reliability and portability.

For more information, see [Application platform considerations for mission-critical workloads on Azure](https://learn.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-application-platform).

### Data platform

The selection of the database platform has key implications for the overall workload architecture, especially the platform's support for active-active or active-passive configuration. The reliable web app pattern uses Azure SQL. Azure SQL does not natively support active-active deployments with write operations in more than one instance. This limits us, at least on the database level, to an active/passive strategy. On the application level, it could be considered if read/write can be separated benefit from read-only replicas while writing to a single region only.

![](RackMultipart20230731-1-egai8a_html_fa7865485aad3796.png)

In complex workloads, it is common to utilize multiple databases, such as in a microservices architecture where each service can have its own database. This allows the adoption of a multi-master write database like Azure Cosmos DB, which enhances high availability and low latency, but limitations exist due to cross-region latency. It is crucial to consider non-functional requirements alongside factors like consistency, operability, cost, and complexity. By enabling individual services to use separate data stores and specialized data technologies, their unique requirements can be effectively met. For more information, see [Data platform considerations for mission-critical workloads on Azure](https://learn.microsoft.com/en-us/azure/well-architected/mission-critical/mission-critical-data-platform).

### Health modeling

In complex multi-tier workloads that spread across multiple data centers and geographical regions, you must define a health model. User and system flows should be defined, dependencies between the services must be known and understood, the impact outages or a performance degradation on one of the services can have on the overall workload and the end user experience should be monitored and visualized to enable proper monitoring and improve manual and automated actions.

![](RackMultipart20230731-1-egai8a_html_e6f20040182e88b0.png)

The diagram above illustrates how an outage (or a degradation) of a single component like in this example the App Configuration Service can bubble up to the top, causing a potential performance degradation for the end user.

![](RackMultipart20230731-1-egai8a_html_e9604882d49ba167.png)

Manual or automated actions based on this could be to stop sending traffic to the affected part of the application, for example an affected scale-unit or the complete region.

For more information, see [Health modeling and observability of mission-critical workloads on Azure](https://learn.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-health-modeling)

### Security and Networking

- Private link / network security perimeter
- Restrict egress traffic

For workloads that migrate from an on-premises enterprise deployment, there are strict requirements for networking and security. These requirements should be evaluated if they're still applicable in cloud environments. Not all established on-premises processes and translate 1:1 into a cloud environment.

Cloud-native patterns often use identity as the primary security perimeter. This may not be acceptable for enterprise customers. To address their network security requirements, most Azure's PaaS services can leverage Private Link to keep the network as a security perimeter. Private Link can be used to ensure services are only accessible from within a virtual network. The Azure Mission-critical baseline architecture with network controls factors this in: [Mission-critical baseline architecture with network controls - Azure Architecture Center | Microsoft Learn](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture)

All services are accessible via private endpoints only. The only public, internet-facing endpoint is Azure Front Door.

![](RackMultipart20230731-1-egai8a_html_561c646b8522ab48.png)

These changes are needed for the reliable web app pattern to implement network as a security perimeter:

- Use Private Link for all services that support them
- Use Azure Front Door premium as the only internet-facing public endpoint
- Introduce jump boxes to access services via Azure Bastion
- Introduce self-hosted build agents that can access the services

Another common network requirement for mission-critical applications is to restrict egress traffic to prevent data exfiltration. This can be achieved by extending the preceding networking changes with an Azure Firewall to restrict egress traffic by routing it through and filtering it by a proper firewall device.

The Azure Mission-critical baseline architecture with network controls follows this guidance.

### Deployment and testing

Deployment and testing is an important design area for mission-critical workloads. Erroneous releases or human error during manual activities can cause downtimes which might not be acceptable for a workload that needs to be available 24x7. Here are some key areas that should be taken into consideration:

- Zero-downtime deployments
- Ephemeral blue/green deployments
- Analyze the lifecycle of individual components and group them together.
- Continuous validation

[Zero-downtime deployments](https://learn.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#zero-downtime-deployment) are key for mission-critical workloads. A workload that needs to be up 24x7x365 cannot accept a maintenance window to rollout newer versions. To avoid that, the Azure Mission-critical architecture follows the "zero-downtime deployments" pattern. Changes are rolled out as new scale-units (or stamps) that can be tested end-to-end before traffic is incrementally routed to them. Once all traffic is routed to the new stamp, old stamps can be disabled and removed.

For more information, please see [Deployment and testing for mission-critical workloads on Azure](https://learn.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#zero-downtime-deployment).