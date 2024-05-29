---
ms.custom: devx-track-dotnet
---

This article shows you how to apply the Reliable Web App pattern. The Reliable Web App pattern is a set of [principles and implementation techniques](../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the minimal code updates you need to make to be successful in the cloud.

To facilitate the application of this guidance, there's a **[reference implementation](https://aka.ms/eap/rwa/dotnet)** of the Reliable Web App pattern that you can deploy.

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-dotnet.svg)](../../_images/reliable-web-app-dotnet.svg)
*Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

The following guidance uses the reference implementation as an example throughout. To plan an implementation of the Reliable Web App pattern, follow these steps:

## Define business goals

The initial step in transitioning to cloud computing is to articulate your business objectives. The Reliable Web App pattern emphasizes the importance of setting both immediate and future objectives for your web application. These objectives influence your choice of cloud services and the architecture of your web application in the cloud.

*Example:* The fictional company Relecloud sells tickets through its on-premises web application. Relecloud has a positive sales forecast and anticipates increased demand on their ticketing web app. To meet this demand, they defined the goals for the web application:

- Apply low-cost, high-value code changes
- Reach a service level objective (SLO) of 99.9%
- Adopt DevOps practices
- Create cost-optimized environments
- Improve reliability and security

Relecloud's on-premises infrastructure wasn't a cost-effective solution to reach these goals. So, they decided that migrating their web application to Azure was the most cost effective way to achieve their immediate and future objectives.

## Choose the right managed services

When you move a web app to the cloud, you should select Azure services that meet your business requirements and align with the current features of the on-premises web app. The alignment helps minimize the replatforming effort. For example, use services that allow you to keep the same database engine and support existing middleware and frameworks. The following sections provide guidance for selecting the right Azure services for your web app.

*Example:* Before the move to the cloud, Relecloud's ticketing web app was an on-premises, monolithic, ASP.NET app. It ran on two virtual machines and had a Microsoft SQL Server database. The web app suffered from common challenges in scalability and feature deployment. This starting point, their business goals, and SLO drove their service choices.

### Application platform

Choose the best application hosting platform for your web app. Azure has many different compute options to meet a range of web apps requirements. For help with narrowing options, see the Azure [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree).

*Example:* Relecloud chose [Azure App Service](/azure/app-service/overview) as the application platform for the following reasons:

- *High service level agreement (SLA):* It has a high SLA that meets the production environment SLO of 99.9%.

- *Reduced management overhead:* It's a fully managed solution that handles scaling, health checks, and load balancing.

- *.NET support:* It supports the version of .NET that the application is written in.

- *Containerization capability:* The web app can converge on the cloud without containerizing, but the application platform also supports containerization without changing Azure services

- *Autoscaling:* The web app can automatically scale up, down, in, and out based on user traffic and settings.

### Identity management

Choose the best identity management solution for your web app. For more information, see [compare identity management solutions](/entra/identity/domain-services/compare-identity-solutions) and [authentication methods](/entra/identity/hybrid/connect/choose-ad-authn).

*Example:* Relecloud chose [Microsoft Entra ID](/entra/fundamentals/whatis) for the following reasons:

- *Authentication and authorization:* The application needs to authenticate and authorize call center employees.

- *Scalable:* It scales to support larger scenarios.

- *User-identity control:* Call center employees can use their existing enterprise identities.

- *Authorization protocol support:* It supports OAuth 2.0 for managed identities.

### Database

Choose the best database for your web app. For help with narrowing the options, see the Azure [data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree).

*Example:* The web app used SQL Server on-premises, and Relecloud wanted to use the existing database schema, stored procedures, and functions. Several SQL products are available on Azure, but Relecloud chose [Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql) for the following reasons:

- *Reliability:* The general-purpose tier provides a high SLA and multi-region redundancy. It can support a high user load.

- *Reduced management overhead:* It provides a managed SQL database instance.

- *Migration support:* It supports database migration from on-premises SQL Server.

- *Consistency with on-premises configurations:* It supports the existing stored procedures, functions, and views.

- *Resiliency:* It supports backups and point-in-time restore.

- *Expertise and minimal rework:* SQL Database takes advantage of in-house expertise and requires minimal work to adopt.

### Application performance monitoring

Choose to an application performance monitoring for your web app. [Application Insights](/azure/azure-monitor/app/app-insights-overview) is the Azure-native application performance management (APM) solution. It's a feature of Azure's monitoring solution, [Azure Monitor](/azure/azure-monitor/overview).

*Example:* Relecloud chose to use Application Insights for the following reasons:

- *Integration with Azure Monitor:* It provides the best integration with Azure Monitor.

- *Anomaly detection:* It automatically detects performance anomalies.

- *Troubleshooting:* It helps you diagnose problems in the running app.

- *Monitoring:* It collects information about how users are using the app and allows you to easily track custom events.

- *Visibility gap:* The on-premises solution didn't have application performance monitoring solution. Application Insights provides easy integration with the application platform and code.

### Cache

Choose whether to add cache to your web app architecture. [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is Azure's primary cache solution. It's a managed in-memory data store based on the Redis software.

*Example:* Relecloud's web app load is heavily skewed toward viewing concerts and venue details. It added Azure Cache for Redis for the following reasons:

- *Reduced management overhead:* It's a fully managed service.

- *Speed and volume:* It has high-data throughput and low latency reads for commonly accessed, slow changing data.

- *Diverse supportability:* It's a unified cache location for all instances of the web app to use.

- *External data store:* The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.

- *Nonsticky sessions:* Externalizing session state supports nonsticky sessions.

### Load balancer

Choose the best load balancer for your web app. Azure has several load balancers. For help with narrowing the options, see [choose the best load balancer for your app](/azure/architecture/guide/technology-choices/load-balancing-overview).

*Example:* Relecloud needed a layer-7 load balancer that could route traffic across multiple regions. Relecloud needed a multi-region web app to meet the SLO of 99.9%. Relecloud chose [Azure Front Door](/azure/frontdoor/front-door-overview) for the following reasons:

- *Global load balancing:* It's a layer-7 load balancer that can route traffic across multiple regions.

- *Web application firewall:* It integrates natively with Azure Web Application Firewall.

- *Routing flexibility:* It allows the application team to configure ingress needs to support future changes in the application.

- *Traffic acceleration:* It uses anycast to reach the nearest Azure point of presence and find the fastest route to the web app.

- *Custom domains:* It supports custom domain names with flexible domain validation.

- *Health probes:* The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.

- *Monitoring support:* It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.

- *DDoS protection:* It has built-in layer 3-4 DDoS protection.

- *Content delivery network:* It positions Relecloud to use a content delivery network. The content delivery network provides site acceleration.

### Web application firewall

Choose a web application firewall to protect your web app from web attacks. [Azure Web Application Firewall](/azure/web-application-firewall/overview) is Azure's web application firewall (WAF) and provides centralized protection of from common web exploits and vulnerabilities.

*Example:* Relecloud needed to protect the web app from web attacks. They used Azure Web Application Firewall for the following reasons:

- *Global protection:* It provides improved global web app protection without sacrificing performance.

- *Botnet protection:* The team can monitor and configure to address security concerns from botnets.

- *Parity with on-premises:* The on-premises solution was running behind a web application firewall managed by IT.

- *Ease of use:* Web Application Firewall integrates with Azure Front Door.

### Configuration storage

Choose whether to add app configuration storage to your web app. [Azure App Configuration](/azure/azure-app-configuration/overview) is a service for centrally managing application settings and feature flags. Review [App Configuration best practices](/azure/azure-app-configuration/howto-best-practices#app-configuration-bootstrap) to decide whether this service is a good fit for your app.

*Example:* Relecloud wanted to replace file-based configuration with a central configuration store that integrates with the application platform and code. They added App Configuration to the architecture for the following reasons:

- *Flexibility:* It supports feature flags. Feature flags allow users to opt in and out of early preview features in a production environment without redeploying the app.

- *Supports Git pipeline:* The source of truth for configuration data needed to be a Git repository. The pipeline needed to update the data in the central configuration store.

- *Supports managed identities:* It supports managed identities to simplify and help secure the connection to the configuration store.

### Secrets manager

Use [Azure Key Vault](/azure/key-vault/general/overview) if you have secrets to manage in Azure. You can incorporate Key Vault in .NET apps by using the [ConfigurationBuilder object](/azure/azure-app-configuration/quickstart-dotnet-core-app).

*Example:* Relecloud's on-premises web app stored secrets in code configuration files, but it's a better security practice to externalize secrets. While [managed identities](/entra/architecture/service-accounts-managed-identities) are the preferred solution for connecting to Azure resources, Relecloud had application secrets they needed to manage. Relecloud used Key Vault for the following reasons:

- *Encryption:* It supports encryption at rest and in transit.

- *Managed identities:* The application services can use managed identities to access the secret store.

- *Monitoring and logging:* It facilitates audit access and generates alerts when stored secrets change.

- *Integration:* It provides native integration with the Azure configuration store (App Configuration) and web hosting platform (App Service).

### Storage solution

Choose the best storage solution for your web app. For more information, see [Review your storage options](/azure/architecture/guide/technology-choices/storage-options).

*Example:* On-premises, the web app had disk storage mounted to each web server, but the team wanted to use an external data storage solution. Relecloud chose [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for the following reasons:

- *Secure access:* The web app can eliminate endpoints for accessing storage exposed to the public internet with anonymous access.

- *Encryption:* It encrypts data at rest and in transit.

- *Resiliency:* It supports zone-redundant storage (ZRS). Zone-redundant storage replicates data synchronously across three Azure availability zones in the primary region. Each availability zone is in a separate physical location that has independent power, cooling, and networking. This configuration should make the ticketing images resilient against loss.

### Endpoint security

Choose to enable private only access to Azure services. [Azure Private Link](/azure/private-link/private-link-overview) provides access to platform-as-a-service solutions over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network.

*Example:* Relecloud used Private Link for the following reasons:

- *Enhanced security communication:* It lets the application privately access services on the Azure platform and reduces the network footprint of data stores to help protect against data leakage.

- *Minimal effort:* The private endpoints support the web app platform and database platform the web app uses. Both platforms mirror existing on-premises configurations for minimal change.

### Network security

Choose whether to add network security services to your virtual networks. [Azure Firewall](/azure/firewall/overview) is stateful, network firewall that inspects network traffic. [Azure Bastion](/azure/bastion/bastion-overview) allows you to connect to virtual machines securely without exposing RDP/SSH ports.

*Example:* Relecloud adopted a hub and spoke network topology and wanted to put shared network security services in the hub. Azure Firewall improves security by inspecting all outbound traffic from the spokes to increase network security. Relecloud needed Azure Bastion for secure deployments from a jump host in the DevOps subnet.

## Choose the right architecture

After you define what *available* means for your web app and select the best cloud services, you need to determine the best architecture for your web app. Your architecture needs to support your business requirements, technical requirements, and SLO.

### Choose architecture redundancy

The business goals determine the level of infrastructure and data redundancy your web app needs. The web app SLO provides a good baseline for understanding your redundancy requirements. Calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) all the dependencies on the critical path of *availability*. Dependencies should include Azure services and non-Microsoft solutions.

Assign an availability estimate for each dependency. Service level agreements (SLAs) provide a good starting point, but SLAs don't account for code, deployment strategies, and architectural connectivity decisions.

*Example:* Relecloud identified the services on the critical path of availability. They used Azure SLAs for availability estimates. Based on the composite SLA calculation, Relecloud needed a multi-region architecture to meet the SLO of 99.9%.

### Choose a network topology

Choose the right network topology for your web and networking requirements. A hub and spoke network topology is standard configuration in Azure. It provides cost, management, and security benefits. It also supports hybrid connectivity options to on-premises networks.

*Example:* Relecloud chose a hub and spoke network topology to increase the security of their multi-region deployment at reduced cost and management overhead.

### Choose data redundancy

Ensure data reliability by distributing it across Azure's regions and availability zones; the greater their geographical separation, the higher the reliability.

- *Set a recovery point objective (RPO).* RPO defines the maximum tolerable data loss during an outage, guiding how frequently data needs replication. For instance, an RPO of one hour means accepting up to an hour's worth of recent data loss.

- *Implement data replication.* Align data replication with your architecture and RPO. Azure typically supports synchronous replication within availability zones. Utilize multiple zones to enhance reliability easily. For multi-region web apps in an active-passive setup, replicate data to the passive region as per the web app's RPO, ensuring replication frequency surpasses the RPO. Active-active configurations require near real-time data synchronization across regions, which might necessitate code adjustments.

- *Create a failover plan.* Develop a failover (disaster recovery) plan outlining response strategies to outages, determined by downtime or functionality loss. Specify the recovery time objectives (RTO) for maximum acceptable downtime. Ensure the failover process is quicker than RTO. Decide on automated or manual failover mechanisms for consistency and control, and detail the return to normal operations process. Test the failover plan to ensure effectiveness.

## Next step

This article showed you how plan an implementation of the Reliable Web App pattern. The next step is to apply the implementation techniques of the Reliable Web App pattern.

>[!div class="nextstepaction"]
> [Apply the Reliable Web App pattern](apply-pattern.yml)
