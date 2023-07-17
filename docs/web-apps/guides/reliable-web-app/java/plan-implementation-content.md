The reliable web app pattern provides essential implementation guidance for web apps moving to the cloud. It defines how you should update (re-platform) your web app to be successful in the cloud.

There are two articles on the reliable web app pattern for Java. This article explains important decisions to plan the implementation of the pattern. The companion article provides code and architecture guidance to [apply the pattern](apply-pattern.yml). There's a [reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java) (sample web app) of the pattern that you can deploy.

## Architecture

The reliable web app pattern is a set of principles with implementation guidance. It's not a specific architecture. Your business context, existing web app, and desired service level objective (SLO) are critical factors that shape the architecture of your web app. The following diagram (*figure 1*) represents the architecture of the [reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java). It's one example that illustrates the principles of the reliable web app pattern. It's important that your web app adheres to the principles of the reliable web app pattern, not necessarily this specific architecture.
[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-java.svg)](../../_images/reliable-web-app-java.svg#lightbox)
*Figure 1. Target reference implementation architecture. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java.vsdx) of this architecture. For the estimated cost of this architecture, see the [production environment cost](https://azure.com/e/4e27d768a5924e3d93252eeceb4af4ad) and [nonproduction environment cost](https://azure.com/e/b6ac4fdb62f3475cb1c2dee388dc4b9a).*

## Principles and implementation

The following table lists the principles of the reliable web app pattern and how to implement those principles in your web app. For more information, see [Reliable web app pattern overview](../overview.md).

*Table 1. Pattern principles and how to implement them.*

| Reliable web app pattern principles | How to implement the principles |
| --- | --- |
| *Reliable web app pattern principles:*<br>▪ Minimal code changes<br>▪ Reliability design patterns<br>▪ Managed services<br><br>*Well Architected Framework principles:*<br>▪ Cost optimized<br>▪ Observable<br>▪ Ingress secure<br>▪ Infrastructure as code<br>▪ Identity-centric security|▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsized resources <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Terraform deployment <br>▪ Telemetry, logging, monitoring |

## Business context

For business context, the guidance follows the cloud journey of a fictional company called Proseware. Company leadership at Proseware wants to expand their business into the education technology application market. After their initial technical research, they concluded that they can use their existing internal training web app as a starting point. The long term plan is to make the web app a customer facing application. Proseware needs to update the application to handle that increase in user load.

To reach these long term goals, Proseware calculated that moving the web app to the cloud offered the best return on investment. The cloud offered them a way to meet the increased business demand with minimal investments in the existing web app.

*Table 2. Short and long-term web app goals.*

| Short-term app goals | Long-term app goals |
| --- | --- |
| ▪ Apply low-cost, high-value code changes<br>▪ Reach a service level objective of 99.9%<br>▪ Adopt DevOps practices<br>▪ Create cost-optimized environments <br>▪ Improve reliability and security|▪ Expose the application customers<br>▪ Develop web and mobile experiences<br>▪ Improve availability<br> ▪ Expedite new feature delivery<br>▪ Scale components based on traffic.

## Existing web app

The existing web app is on premises. It's a monolithic Java web app that runs a web based media stream called Airsonic. Airsonic is a well-known open-source project, but in this scenario, Proseware owns the code. Code ownership is a more common scenario than an upstream dependency. The on-premises web app runs on an Apache Tomcat web server with a PostgreSQL database.

The web app is a line-of-business training app. It's employee-facing. Proseware employees use the application to complete required HR training. The on-premises web app suffers from common challenges. These challenges include extended timelines to build and ship new features and difficulty scaling different application components under higher load.

## Service level objective

A service level objective (SLO) for availability defines how available you want a web app to be for users. You need to define an SLO and what *available* means for your web app. Proseware has a target SLO of 99.9% for availability, about 8.7 hours of downtime per year. For Proseware, the web app is considered available when employees can watch training videos 99.9% of the time. When you have a definition of *available*, list all the dependencies on the critical path of availability. Dependencies should include Azure services and third-party solutions.

For each dependency in the critical path, you need to assign an availability goal. Service Level Agreements (SLAs) from Azure provide a good starting point. However, SLAs don't factor in (1) downtime associated with the application code run on those services, (2) deployment and operations methodologies, or (3) architecture choices to connect the services. The availability metric you assign to a dependency shouldn't exceed the SLA.

Proseware used Azure SLAs for Azure services. The following diagram illustrates Proseware's dependency list with availability goals for each dependency (*see figure 2*).

[![Diagram showing Proseware's dependencies on the critical path and the assigned availability metric for each dependency.](../../_images/java-slo-dependecies.svg)](../../_images/java-slo-dependecies.svg#lightbox)
*Figure 2. SLA dependency map. Azure SLAs are subject to change. The SLAs shown here are examples used to illustrate the process of estimating composite availability. For information, see [SLAs for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).*

When you have an SLA dependency map, you need to use the formulas for composite SLAs to estimate the composite availability of the dependencies on the critical path. This number should meet or exceed your SLO. Proseware needed a multi-region architecture to meet the 99.9% SLO. For more information, see [Composite SLA formula](/azure/architecture/framework/resiliency/business-metrics#composite-slas) and [Multiregional SLA formula](/azure/architecture/framework/resiliency/business-metrics#slas-for-multiregion-deployments).

## Choose the right services

The Azure services you choose should support your short-term objectives. They should also prepare you to reach any long-term goals. To accomplish both, you should pick services that (1) meet your SLO, (2) require minimal re-platforming effort, and (3) support future modernization plans.

When you move a web app to the cloud, you should select Azure services that mirror key on-premises features. The alignment helps minimize the re-platforming effort. For example, you should keep the same database engine (from PostgreSQL to Azure Database for PostgreSQL Flexible Server). Containerization of your application typically doesn't meet the short-term objectives of the reliable web app pattern, but the application platform you choose now should support containerization if it's a long-term goal. The two main requirements Proseware used when choosing Azure services were (1) an SLO of 99.9% for the production environment and (2) an average load of 1,000 users daily.

### Application platform

[Azure App Service](/azure/app-service/overview) is an HTTP-based managed service for hosting web apps, REST APIs, and mobile back ends. Azure has many viable [compute options](/azure/architecture/guide/technology-choices/compute-decision-tree). Proseware chose Azure App Service because it meets the following requirements:

- **Natural progression.** On-premises, Proseware deployed a `war` file to a Tomcat server and wanted to minimize the amount of rearchitecting for that deployment model. App Service was a natural progression for Proseware, but Azure Spring Apps is an alternative.
- **High SLA.** It has a high SLA that meets the requirements for the production environment.
- **Reduced management overhead.** It's a fully managed hosting solution.
- **Containerization capability.** App Service works with private container image registries like Azure Container Registry. Proseware can use these registries to containerize the web app in the future.
- **Autoscaling.** The web app can rapidly scale up, down, in, and out based on user traffic.

Azure has a fully managed service specifically for Spring Boot apps (Azure Spring Apps), but Proseware concluded that the App Service platform introduces key hosting benefits of Spring Apps. Spring Apps introduces a larger disparity between the on-premises Tomcat servers than App Service. App Service also aligns better with the team's current level of cloud experience.

### Identity management

[Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) is a cloud-based identity and access management service. It authenticates and authorizes users based on roles that integrate with applications. Azure AD provides the following features for Proseware's web app:

- **Authentication and authorization.** It handles authentication and authorization of employees.
- **Scalability.** It scales to support larger scenarios.
- **User-identity control.** Employees can use their existing enterprise identities.
- **Support for authorization protocols.** It supports OAuth 2.0 for managed identities and OpenID Connect for future B2C support.

### Database

[Azure Database for PostgreSQL](/azure/postgresql/flexible-server/overview) is a fully managed database service that provides single-server and flexible-server options. Proseware chose Azure Database for PostgreSQL and the flexible-server option to get the following benefits:

- **Reliability.** The flexible-server deployment model supports zone-redundant high availability across multiple availability zones. This configuration and maintains a warm standby server in a different availability zone within the same Azure region. The configuration replicates data synchronously to the standby server.
- **Cross-region replication.** It has a read replica feature that allows you to asynchronously replicate data to a [read-only replica database in another region](/azure/postgresql/flexible-server/concepts-read-replicas).
- **Performance.** It provides predictable performance and intelligent tuning to improve your database performance by using real usage data.
- **Reduced management overhead.** It's a fully managed Azure service that reduces management obligations.
- **Migration support.** It supports database migration from on-premises single-server PostgreSQL databases. You can use the [migration tool](/azure/postgresql/migrate/concepts-single-to-flexible) to simplify the migration process.
- **Consistency with on-premises configurations.** It supports [different community versions of PostgreSQL](/azure/postgresql/flexible-server/concepts-supported-versions), including the version that Proseware currently uses.
- **Resiliency.** The flexible server deployment automatically creates [server backups](/azure/postgresql/flexible-server/concepts-backup-restore) and stores them using zone-redundant storage (ZRS) within the same region. You can restore your database to any point-in-time within the backup retention period. The backup and restoration capability creates a better RPO (acceptable amount of data loss) than Proseware could create on-premises.

### Application performance monitoring

[Application Insights](/azure/azure-monitor/app/app-insights-overview) is a feature of Azure Monitor that provides extensible application performance management (APM) and monitoring for live web apps. Proseware added Application Insights for the following reasons:

- **Anomaly detection.** It automatically detects performance anomalies.
- **Troubleshooting.** It helps diagnose problems in the running app.
- **Telemetry.** It collects information about how users are using the app and allows you to easily send custom events that you want to track in your app.
- **Solving an on-premises visibility gap.** The on-premises solution didn't have APM. Application Insights provides easy integration with the application platform and code.

Azure Monitor is a comprehensive suite of monitoring tools for collecting data from various Azure services. For more information, see:

- [Application Monitoring for Azure App Service and Java](/azure/azure-monitor/app/azure-web-apps-java)
- [Smart detection in Application Insights](/azure/azure-monitor/alerts/proactive-diagnostics)
- [Application Map: Triage distributed applications](/azure/azure-monitor/app/app-map?tabs=java)
- [Usage analysis with Application Insights](/azure/azure-monitor/app/usage-overview)
- [Getting started with metrics explorer](/azure/azure-monitor/essentials/metrics-getting-started)
- [Application Insights Overview dashboard](/azure/azure-monitor/app/overview-dashboard)
- [Log queries in Azure Monitor](/azure/azure-monitor/logs/log-query-overview)

### Cache

[Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a managed in-memory data store that's based on Redis software. Proseware needed a cache that provides the following benefits:

- **Speed and volume.** It has high-data throughput and low latency reads for commonly accessed, slow-changing data.
- **Diverse supportability.** It's a unified cache location that all instances of the web app can use.
- **Externalized.** The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.
- **Enabling non-sticky sessions:** The cache allows the web app to externalize session state use nonsticky sessions. Most Java web app running on premises use in-memory, client-side caching. In-memory, client-side caching doesn't scale well and increases the memory footprint on the host. By using Azure Cache for Redis, Proseware has a fully managed, scalable cache service to improve scalability and performance of their applications. Proseware was using a cache abstraction framework (Spring Cache) and only needed minimal configuration changes to swap out the cache provider. It allowed them to switch from an Ehcache provider to the Redis provider.

### Global load balancer

Proseware needed a multi-region architecture to meet their 99.9% SLO. They chose an active-passive configuration to avoid the code changes needed for an active-active configuration. To route traffic across regions, they needed a global load balancer. Azure has two primary global load balancing architectures: (1) Azure Front Door and (2) Azure Traffic Manager.

Front Door is a modern content delivery network and global load balancer that routes HTTP traffic. Traffic Manager is a global load balancer that uses DNS to route traffic across regions. Proseware chose Front Door as the global load balancer for following benefits:

- **Routing flexibility.** It allows the application team to configure ingress needs to support future changes in the application.
- **Traffic acceleration.** It uses anycast to reach the nearest Azure point of presence and find the fastest route to the web app.
- **Custom domains.** It supports custom domain names with flexible domain validation.
- **Health probes.** The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.
- **Monitoring support.** It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.
- **DDoS protection.** It has built-in layer 3-4 DDoS protection.

### Web application firewall

[Azure Web Application Firewall](/azure/web-application-firewall/overview) helps provide centralized protection of your web app from common exploits and vulnerabilities. WAF integrates with Application Gateway and Front Door. It helps prevent malicious attacks close to the attack sources before they enter your virtual network. Proseare chose the Web Application Firewall for the following benefits:

- **Global protection.** It provides increased global web app protection without sacrificing performance.
- **Botnet protection.** You can configure bot protection rules to monitor for botnet attacks.
- **Parity with on-premises.** The on-premises solution was running behind a web application firewall managed by IT.

### Secrets manager

[Azure Key Vault](/azure/key-vault/general/overview) provides centralized storage of application secrets so that you can control their distribution. It supports X.509 certificates, connection strings, and API keys to integrate with third-party services. Managed identities are the preferred solution for intra-Azure service communication, but the application still has secrets to manage. The on-premises web app stored secrets on-premises in code configuration files, but it's a better security practice to externalize secrets. Proseware chose Key Vault because it provides the following features:

- **Encryption.** It supports encryption at rest and in transit.
- **Supports managed identities.** The application services can use managed identities to access the secret store.
- **Monitoring and logging.** It facilitates audit access and generates alerts when stored secrets change.
- **Integration.** It supports two methods for the web app to access secrets. You can use app settings in the hosting platform (App Service), or you can reference the secret in your application code (app properties file).

### File storage

Azure Files offers fully managed file shares in the cloud that are accessible via Server Message Block (SMB) protocol, Network File System (NFS) protocol, and Azure Files REST API. Proseware needs a file system for saving uploaded training videos. Proseware chose Azure Files for the following reasons:

- **Replaces existing file server.** Azure Files is a drop-in replacement for our on-premises network attached storage (NAS) solution. Azure Files allows Proseware to replace the existing file server without needing to modify code if they wanted to add blob storage. Azure Files simplifies the process of getting the app running on the cloud.
- **Fully managed service.** It enables Proseware to maintain compatibility without needing to manage hardware or an operating system for a file server.
- **Resiliency:** It has a geo-zone-redundant storage (GZRS) option that supports Proseware's disaster recovery plan. In the primary region, the GZRS option copies data synchronously across three Azure availability zones. In the secondary region, GZRS copies your data asynchronously to a single physical location in the secondary region. Within the secondary region, your data is copied synchronously three times.
- **Durability.** It has zone-redundant storage to improve data redundancy and application resiliency. For more information, see [Data redundancy](/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region) and [Zone-redundant storage](/azure/storage/common/storage-redundancy#zone-redundant-storage).

### Endpoint security

[Azure Private Link](/azure/private-link/private-link-overview) provides access to PaaS services (like Azure Cache for Redis and Azure Database for PostgreSQL) over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network. Azure Private DNS with Azure Private Link enables your solution to communicate with Azure services without requiring application changes. Proseware chose Private Link for the following reasons:

- **Enhanced security.** It lets the application privately access services on Azure and reduces the network footprint of data stores to help protect against data leakage.
- **Minimal effort.** Private endpoints support the web app platform and the database platform that the web app uses. Both platforms mirror the existing on-premises setup, so minimal changes are required.

## Next step

This article showed you how plan an implementation of the reliable web app pattern. Now you need to apply the reliable web app pattern.

>[!div class="nextstepaction"]
>[Apply the reliable web app pattern](apply-pattern.yml)
