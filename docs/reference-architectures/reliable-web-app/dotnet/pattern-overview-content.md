The reliable web app pattern is a set of objectives to help your web application converge on the cloud. The overarching objective of the pattern is to your web application harness the value of the cloud fast and create a foundation for modernization. The reliable web app pattern addresses code and architecture decisions from the developer perspective, and it details the entire cloud convergence process from planning to implementation. The pattern applies to most web applications converging on the cloud. While it's a viable stopping point for some web applications, it's an essential first step for most applications in a strategic modernization journey.

This article defines objectives of the reliable web app pattern and walks you through the business drivers, on-premises context, and reason we chose each Azure service. There's a companion article that shows you [how to apply the reliable web app pattern for .NET](./apply-pattern.yml) and a [reference implementation](https://github.com/Azure/reliable-web-app-pattern-dotnet) you can deploy. The following diagram shows the architecture of the reliable web app pattern for .NET.

For more information, see the [Reliable web app pattern video series (YouTube)](https://aka.ms/eap/rwa/dotnet/videos)

![Diagram showing the architecture of the reliable web app pattern for .NET.](images/reliable-web-app-dotnet.png)

*Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet.vsdx) of this architecture. For the estimated cost of the reference implementation by environment, see:*

- [Production environment estimated cost](https://azure.com/e/26f1165c5e9344a4bf814cfe6c85ed8d)
- [Non-production environment estimated cost](https://azure.com/e/8a574d4811a74928b55956838db71093)

## Pattern definition

The reliable web app pattern is a set of objectives that adheres to the pillars of [Azure Well-Architected Framework](/azure/architecture/framework/). How you implement this pattern might vary between web application and languages. The following table outlines the pattern objectives and how the reference implementation met these objectives.



| Objectives | Implementation for .NET |
| --- | --- |
|▪ Low-cost high-value wins<br>▪ Minimal code changes<br>▪ Security best practices<br> ▪ Reliability design patterns<br>▪ Improve operational excellence<br>▪ Cost-optimized environments<br>▪ Well Architected Framework principles<br>▪ Service level objective: 99.9% |▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Right-size resource <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Repeatable infrastructure <br>▪ Telemetry, logging, monitoring <br>▪ Multi-region deployment|

## Web application starting point

This guidance mirrors the journey of a web application converging on the cloud. It's essential to define the on-premises web application. It's a monolithic ASP.NET application that runs on two virtual machines with a Microsoft SQL Server database. It's an employee-facing and LOB eCommerce web application. The employees are call-center users, and they use the application to buy tickets on behalf of Relecloud customers. The on-premises web application suffers from common challenges. These challenges include extended timelines to build and ship new features difficulty scaling different components of the application under higher load.

## Business context

The goal of the pattern is to meet increasing business demand with minimal investments in the existing monolithic app. It reflects a common scenario where traffic to an on-premises application has increased due to higher-than-expected sales with continued increases forecasted. The on-premises infrastructure doesn’t provide a cost-efficient means to scale, and a migration to the cloud offers the most return on investment. Here are some short-term and long-term business goals for the application.

| Short term goals | Long term goals |
| --- | --- |
| ▪ Apply low-cost, high-value code changes to the LOB web application. <br> ▪ Mature development team practices for modern development and operations. <br> ▪ Create cost-optimized production and development environments. <br> ▪ Implement reliability and security best practices in the cloud. <br> ▪ Service-level objective of 99.9%.| ▪ Open the application directly to online customers through multiple web and mobile experiences. <br> ▪ Improve availability. <br> ▪ Reduce time required to deliver new features. <br> ▪ Independently scale different components of the system based on traffic

## Service level objective

Before calculating your service level objective (SLO), you need to define what it means to be available for your web application. Find all the Azure services that support your definition of availability. For Relecloud, available is when customers can purchase tickets. A service like Azure Monitor is outside the scope of the SLO of 99.9% because it doesn’t directly support ticket purchases.

To determine availability, we need some metric to measure the predicted availability of a service and, for that, we use Azure's service level agreements (SLAs). Make a list of the services that support the essential functions of your application and find their SLA. Next, calculate the composite SLA of the services. For more information, see:

- [Service Level Agreements](https://azure.microsoft.com/support/legal/sla/)
- [Composite SLAs](/azure/architecture/framework/resiliency/business-metrics#composite-slas)
- [Multiregional availability formula](/azure/architecture/framework/resiliency/business-metrics#slas-for-multiregion-deployments)

 The following table shows the SLA for each service in the availability path.

| Azure Service | SLA |
| --- | --- |
| [Azure Active Directory](https://azure.microsoft.com/support/legal/sla/active-directory/v1_1/) | 99.99% |
| [Azure App Configuration](<https://azure.microsoft.com/support/legal/sla/app-configuration/v1_0/>) | 99.9% |
| [Azure App Service](https://azure.microsoft.com/support/legal/sla/app-service/) | 99.95% |
| [Azure Cache for Redis](https://azure.microsoft.com/support/legal/sla/cache/) |99.9% |
| [Azure Key Vault](https://azure.microsoft.com/support/legal/sla/key-vault/v1_0/) | 99.99% |
| [Azure Private Link](https://azure.microsoft.com/support/legal/sla/private-link/v1_0/) | 99.99%|
| [Azure Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/) |  99.9% |
| [Azure SQL Database](https://azure.microsoft.com/support/legal/sla/azure-sql-database/v1_8/) |  99.99% |

If the composite SLA doesn’t meet or exceed your SLO, then you need to reconsider the services you use or adjust the architecture. Relecloud adjusted the architecture and added a second region to improve availability. There’s a separate formula multi-region availability. Calculating the composite SLA for a single-region deployment resulted in an SLA of 99.52%, 42 hours of downtime per year. This SLA created unacceptable business risk. So they deployed the web app to two regions. The multi-region availability formula is `(1 - (1 − N) ^ R)`. `N` represents the composite SLA and `R` the number of regions. Two regions improve the composite SLA to 99.99%. However, now there's a need for a global load balancer, Azure Front Door, to route traffic between the two regions. Front Door has an SLA of 99.99%. With Front Door, the composite availability for the multi-region web app becomes 99.98% and exceeds the SLO of 99.9%.

## Choose the right services

The Azure services you choose should support your short-term objectives while preparing your application to meet any long-term goals. You should pick services that meet the SLO for the production environment, require minimal migration effort, and support aspired modernizations efforts. At this phase, it's important select Azure services that mirror key on-premises choices. For example, you should keep the same database engine (SQL Server -> Azure SQL Database) and app hosting platform (IIS on Windows Server -> Azure Web Apps). Containerization of your application typically doesn't meet the short-term objectives of the reliable web app pattern, but the application platform you choose now should support containerization if it's a long-term goal.

### Application platform

[Azure App Service](/azure/app-service/overview) is an HTTP-based, managed service for hosting web applications, REST APIs, and mobile back ends. Azure has many viable compute options. For more information, see the [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree). But we chose Azure App Service because it met the following requirements:

- **High SLA:** It has a 99.95% uptime SLA and met the production environment SLO.
- **Reduced management overhead:** It's a fully managed solution that handles scaling, health checks, and load balancing.
- **.NET support:** It supports the version of .NET the application was written in.
- **Containerization capability:** We can converge on the cloud without containerizing the app, but we can also containerize in the future without changing Azure services.
- **Autoscaling:** The web app can automatically scale up, down, in, and out based on user traffic and settings we control.

### Identity management

[Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) is a cloud-based identity and access management service. It authenticates and authorizes users based on roles that integrate with our application. Azure AD provides the application with the following abilities.

- **Authentication and authorization:** The application needed to authenticate and authorize call center employees.
- **Scalable:** We wanted a proven solution that could scale to support larger scenarios.
- **User-identity control:** We wanted the call center employee to use their existing enterprise identity.
- **Support authorization protocols:** We needed to support OAuth 2.0 for managed identities and OpenID Connect for future B2C support.

### Database

[Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql) is a general-purpose relational database and managed service in that supports relational and spatial data, JSON, spatial, and XML. We were using SQL Server on premises and wanted to keep the database schema, stored procedures, and functions. There are different SQL products in Azure, but we selected Azure SQL Database because it met the following requirements.

- **Reliability:** the general-purpose tier provides a 99.99% uptime SLA and multi-region redundancy. It can support a high user load.
- **Reduced management overhead:** It provides a managed SQL database instance.
- **Migration support:** It supports database migration from on-premises SQL Server.
- **Consistency with on-premises configurations:** Azure SQL Server existing stored procedures, functions, and views.
- **Resiliency:** It supports backups and point-in-time restore.
- **Expertise and minimal rework:** Azure SQL Database is the database platform that maximized in-house expertise and minimal rework.

### Application performance monitoring

[Application Insights](/azure/azure-monitor/app/app-insights-overview) is a feature of Azure Monitor that provides extensible application performance management (APM) and monitoring for live web apps.  solution We chose to incorporate Application Insights for the following reasons.

- **Anomaly detection:** It automatically detects performance anomalies
- **Troubleshooting:** It helps diagnose issues in our running app.
- **Telemetry:** It collects information about how users are using the app and allows us to easily send custom events we want to track in our app.
- **Solving an on-premises visibility gap:** The on-premises solution didn't have APM, and Application Insights provided an easy integration to the application platform and code.

Azure Monitor is a comprehensive suite of monitoring tools to collect data from various Azure services. Review the following concepts to quickly come up to speed on its capabilities:

- [Smart detection in application insights](/azure/azure-monitor/alerts/proactive-diagnostics)
- [Application Map: Triaging Distributed Applications](/azure/azure-monitor/app/app-map?tabs=net)
- [Profile live App Service apps with Application Insights](/azure/azure-monitor/profiler/profiler)
- [Usage analysis with Application Insights](/azure/azure-monitor/app/usage-overview)
- [Getting started with Azure Metrics Explorer](/azure/azure-monitor/essentials/metrics-getting-started)
- [Application Insights Overview dashboard](https://learn.mi/azure/azure-monitor/app/overview-dashboard)
- [Log queries in Azure Monitor](/azure/azure-monitor/logs/log-query-overview)

### Cache

[Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a managed in-memory data store based on the Redis software. Our load is heavily skewed toward viewing concerts and venue details. We wanted to implement a cache that provided the following benefits.

- **Reduce management overhead:** It’s a fully managed service.
- **Speed and volume:** It has high-data throughput and low latency reads for commonly accessed, slow changing data.
- **Diverse supportability:** It's a unified cache location for all instances of our web app to use.
- **Externalized:** The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data nor could that data be invalidated.
- **Enabling non-sticky sessions:** Externalizing session state supports non-sticky sessions.

### Global load balancer

[Azure Front Door](/azure/frontdoor/front-door-overview) is a layer-seven, global load balancer that uses the Azure backbone network to route traffic between regions. This choice sets up extra features such as Web Application Firewall and positions us to use a content delivery network to provide site acceleration as traffic to the web app increases. We chose Azure Front Door because it provides the following capabilities.

- **Routing flexibility:** It allows the application team to configure ingress needs to support future changes inside the application.
- **Traffic acceleration:** It uses anycast to reach the nearest Azure point of presence and find the fastest route to our web app.
- **Custom domains:** It supports custom domain names with flexible domain validation.
- **Health probes:** The application needed intelligent health probe monitoring. Azure Front Door then uses these responses from the probe to determine the "best" origin to route your client requests.
- **Monitoring support:** We wanted built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.
- **DDoS protection:** It has built-in layer 3-4 DDoS protection.

Azure has several load balancer options. Make note of your current system capabilities and what requirements you have for your new app running in Azure, then [choose the best load balancer option for your app](/azure/architecture/guide/technology-choices/load-balancing-overview).

### Web application firewall

[Azure Web Application Firewall](/azure/web-application-firewall/overview) provides centralized protection of your web applications from common exploits and vulnerabilities. It’s built into Azure Front Door and prevents malicious attacks close to the attack sources before they enter your virtual network. Azure Web Application Firewall provided the following benefits.

- **Global protection:** We wanted global web app protection without sacrificing performance.
- **Botnet protection:** The team can monitor and configure to address security concerns from botnets.
- **Parity with on-premises**: The service allowed us to maintain parity with our on-premises solution, which was running behind a web application firewall managed by IT.

### Configuration storage

[Azure App Configuration](/azure/azure-app-configuration/overview) is a service to centrally manage application settings and feature flags. We chose to take a dependency on Azure App Configuration to manage our configuration data. We wanted to replace our file-based configuration with a central configuration store that integrated with the application platform and code. App Config provided the following benefits.

- **Flexibility:** It supports feature flags. Feature flags allow users to opt in and opt-out of early preview features in a production environment without redeploying the app.
- **Supports git pipeline:** The source of truth for configuration data needed to be a git repository. The pipeline needed to update the data in the central configuration store.
- **Supports managed identities:** We want to use managed identities to simplify and secure our connection to our configuration store.

Review [App Configuration best practices](/azure/azure-app-configuration/howto-best-practices#app-configuration-bootstrap) to decide if this service is a fit for your app.

### Secrets manager

[Azure Key Vault](/azure/key-vault/general/overview) provides centralized storage of application secrets to control their distribution. Our solution requires use of X.509 certificates, connection strings, and API keys to integrate with third party services. We prefer managed identities for intra-Azure service communication, but the application still has secrets to manage. We stored secrets on-premises in our code configuration files, and we needed to externalize those secrets. Key Vault met our needs for the following reasons:

- **Encryption:** It supports encryption at rest and in transit.
- **Supports managed identities:** The application services can use managed identities to access the secret store.
- **Monitoring and logging:** We wanted the secret store to facilitate audit access and generate alert us when stored secrets change.
- **Certificate support:** We wanted to import PFX and PEM formatted certificates.
- **Integration:** It provides native integration with the Azure configuration store (Azure App Configuration) and web hosting platform (Azure App Service).

You can incorporate Azure Key Vault in .NET apps using the [ConfigurationBuilder object](/azure/azure-app-configuration/quickstart-dotnet-core-app).

### Object storage

[Azure Storage](/azure/storage/common/storage-introduction) provides storage queue storage for message driven communication and file storage. We use Azure Storage for both. Azure Storage Queues holds purchases that are pending PDF generation and Blob Storage stores the resulting ticket PDFs. On-premises, we had disk storage mounted to each web server and wanted to externalize. The following requirements led us to use Azure Storage Queues for our queuing needs. If you have a queue scenario in your app, review the [messaging options available](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

- **Random ordering:** The app doesn't need to ensure a specific order for message deliver, so random ordering supports the needs of the app.
- **Idempotency at consumer:** Message consumption is idempotent, so at-most-once delivery isn't required.
- **Batch processing:** We wanted to pull a batch of work items from the queue for each operation.
- **Auditing:** We need to audit server-side transaction logs.
- **Azure RBAC authentication:** We wanted to authenticate to our queue using managed identities.

For Blob Storage, we chose Zone-redundant storage (ZRS). Zone-redundant storage replicates data synchronously across three Azure availability zones in the primary region. Each availability zone is in a separate physical location with independent power, cooling, and networking. The app uses Blob Storage to meet the following requirements:

- **Eliminate anonymous access:** We didn’t want endpoints for accessing storage exposed to the public internet with anonymous access.
- **Encryption:** It encrypts data at rest and in transit.
- **Resiliency:** Blob storage should make our ticketing PDF resilient against loss.

### Endpoint security

[Azure Private Link](/azure/private-link/private-link-overview) provides access to PaaS Services (such as, Azure Cache for Redis and SQL Database) over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network. You can avoid exposing your service to the public internet. You use Azure Private DNS with Azure Private Link enables your solution to communicate securely with Azure services like Azure SQL Database. Azure Private DNS integrates with Azure App Service to extend DNS resolution so that the private IP address is provided for a public hostname. This integration enables a web app to connect to Azure SQL Database, which requires connections to use the public hostname when connecting to the private IP address. We chose Azure Private Link for the following benefits.

- **Secure communication:** It lets the application privately access services on the Azure platform and reduces the network footprint of data stores to protect against data leakage.

## Deploy the reference implementation

You can deploy the reference implementation by following the instructions in the [reliable web app pattern for .NET repository](https://github.com/Azure/reliable-web-app-pattern-dotnet). Follow the deployment guide to set up a local development environment and deploy the solution to Azure.

## Next Steps

This article covered the architecture and planning details around the reliable web app pattern for .NET. The following article shows you how to apply the reliable web app pattern with specific design patterns structured around the well-architected pillars.

>[!div class="nextstepaction"]
> [How to apply the reliable web app pattern for .NET](apply-pattern.yml)
