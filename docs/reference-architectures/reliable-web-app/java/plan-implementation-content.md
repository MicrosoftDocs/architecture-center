This article shows you how to plan the implementation of the reliable web app pattern for Java. The companion article shows you how to [apply the pattern](apply-pattern.yml). The reliable web app pattern shows developers how to modify web applications that have recently migrated to the cloud. The pattern focuses on the minimal, essential changes you should make to ensure the success of your web app in the cloud. For more information, see [Overview of the reliable web app pattern](../overview.md).

There's a [reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java) that you can deploy. It applies the reliable web app pattern to an employee-facing, line of business (LOB) web application.

## Architecture and pattern

The business context, existing web app, service level objective (SLO), and coding language determine (1) how you apply the reliable web app pattern and (2) the architecture of the web app. We applied the reliable web app pattern to the reference implementation. The following diagram illustrates how the reference implementation should look in your environment.

[![Diagram showing the architecture of the reference implementation](images/reliable-web-app-java.png)](images/reliable-web-app-java.png)
*Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java.vsdx) of this architecture. For the estimated cost, see:*

- [Production environment estimated cost](https://azure.com/e/c530c133f36c423e9774de286f7dd28a)
- [Non-production environment estimated cost](https://azure.com/e/48201e05118243e089ded6855839594a)

The following table lists the principles of the reliable web app pattern and how the reference implementation applied these principles.

| Reliable web app principles | Implementation for Java |
| --- | --- |
|▪ Low-cost, high-value updates<br>▪ Minimal code changes to:<ol>▫ Meet security best practices<br>▫ Apply reliability design patterns<br>▫ Improve operational excellence</ol>▪ Cost-optimized environment(s)<br>▪ Follow Azure Well-Architected Framework principles<br>▪ Business-driven service level objective |▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Right-size resource <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Repeatable infrastructure <br>▪ Telemetry, logging, monitoring |

## Business context

The implementation guidance mirrors the cloud journey of a fictional company, Proseware, Inc. Proseware wants to take its on-premises, line of business (LOB), web application to the cloud. It's a customized version of the open-source monolithic Airsonic web-based media streamer. For the purposes of this scenario, we imagine that Proseware developed the application and owns all the code. Company leadership decided to expand their business into the EdTech application market. After their initial technical research, they concluded they could use their existing internal training platform as a starting point and modernize them into a B2C EdTech App. To expand its business into a highly competitive EdTech market, the on-premises infrastructure needs to provide a cost-efficient means to scale, and a migration to the cloud offers the most return on investment. The migration of their application should meet the increasing business demand with minimal investments in the existing monolithic app. Here are some short-term and long-term goals for the application.

| Short term goals | Long term goals |
| --- | --- |
| ▪ Apply low-cost, high-value code changes to the LOB web application. <br> ▪ Mature development team practices for cloud development and operations. <br> ▪ Create cost-optimized production and development environments. <br> ▪ Implement reliability and security best practices in the cloud. <br> ▪ Service-level objective of 99.86%.| ▪ Open the application directly to online customers through multiple web and mobile experiences. <br> ▪ Improve availability. <br> ▪ Reduce time required to deliver new features. <br> ▪ Independently scale different components of the system based on traffic.

## Web application starting point

The on-premises starting point is a monolithic Java web application running on an Apache Tomcat web server with a PostgreSQL database. It’s an employee-facing LOB training application. Proseware employees use the application to complete required HR training. The web application suffers from common legacy challenges, including extended timelines to build and ship new features and difficulty scaling different application components under higher load.

## Service level objective

A service level objective (SLO) for availability defines how available you want a web app to be for users. Proseware has a target SLO of 99.86% for availability. You need to define what it means to be available for your web application. For Proseware, the web app is available when employees can watch training videos 99.86% of the time. When you have a definition of available, list all the dependencies on the critical path of availability. Dependencies should include Azure services and third-party solutions.

For each dependency in the critical path, you need to assign an availability goal. Service Level Agreements (SLAs) from Azure provide a good starting point. SLAs don't factor in (1) downtime associated with the application code run on those services, (2) deployment and operations methodologies, or (3) architecture choices to connect the services. The availability metric you assign to a dependency shouldn't exceed the SLA.

For example, Proseware used Azure SLAs for Azure services. The following diagram illustrates Proseware's dependency list with availability goals for each dependency.

[![Diagram showing Proseware's dependencies on the critical path and the assigned availability metric for each dependency.](images/java-slo-dependecies.png)](images/java-slo-dependecies.png)

Finally, use the formulas for composite SLAs to estimate the composite availability of the dependencies on the critical path. This number should meet or exceed your SLO. For more information, see:

- [Composite SLA formula](/azure/architecture/framework/resiliency/business-metrics#composite-slas)
- [Multiregional SLA formula](/azure/architecture/framework/resiliency/business-metrics#slas-for-multiregion-deployments)

## Choose the right services

The Azure services you choose should support your short-term objectives while preparing your application to meet any long-term goals. You should pick services that (1) meet the SLO for the production environment, (2) require minimal migration effort, and (3) support planned modernization efforts. At this phase, it's important select Azure services that mirror key on-premises choices to minimize the migration effort. At this phase, it's important to select the Azure services that mirror key on-premises choices. For example, you should keep the same database engine (PostgreSQL -> Azure Database for PostgreSQL Flexible Server). Containerization of your application typically doesn't meet the short-term objectives of the reliable web app pattern, but the application platform you choose now should support containerization if it's a long-term goal. The two main requirements Proseware used when choosing Azure services were (1) an SLA of 99.9% for the production environment and (2) an average load of 1,000 users daily.

### Application platform

[Azure App Service](/azure/app-service/overview) is an HTTP-based, managed service for hosting web applications, REST APIs, and mobile back ends. Azure has many viable[compute options](/azure/architecture/guide/technology-choices/compute-decision-tree). The web app uses Azure App Service because it meets the following requirements:

- **Broad Java support:** App Service supports Java Platform Standard Edition (SE), Apache Tomcat, and JBoss Enterprise Application Platform (EAP) web apps. You can deploy Maven plugins from the command line or in editors (IntelliJ, Eclipse, or Visual Studio Code).
- **High SLA:** It has a 99.95% uptime SLA and meets our requirements for the production environment.
- **Reduced management overhead:** It’s a fully managed hosting solution.
- **Containerization capability:** App Service works with private container image registries like Azure Container Registry. Proseware can use these registries to containerize the web app in the future.
- **Autoscaling:** The web app can rapidly scale up, down, in, and out based on user traffic.

Azure has a fully managed service specifically for Spring Boot apps, Azure Spring Apps. Proseware concluded that the Spring Apps platform introduces key hosting benefits but a came with an undesired larger operations disparity between their on-premises Tomcat servers than Azure App Service for the team's current level of cloud experience.

### Identity management

[Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) is a cloud-based identity and access management service. It authenticates and authorizes users based on roles that integrate with our application. Azure AD provides the application with the following abilities:

- **Authentication and authorization:** The application needed to authenticate and authorize employees.
- **Scalable:** It scales to support larger scenarios.
- **User-identity control:** Employees can use their existing enterprise identity.
- **Support authorization protocols:** It supports OAuth 2.0 for managed identities and OpenID Connect for future B2C support.

### Database

[Azure Database for PostgreSQL](/azure/postgresql/flexible-server/overview) is a fully managed database service with single-server and Flexible Server options. We chose Azure Database for PostgreSQL and the flexible server options for the following benefits:

- **Reliability.** The flexible server deployment model supports high availability within a single availability zone and across multiple availability zones. For a high SLO, choose the zone redundant high availability configuration. This configuration and maintains a warm standby server across availability zone within the same Azure region. Data replicates synchronously to the standby server to improve reliability.
- **Performance.** It provides your apps with predictable performance and intelligent tuning to improve your database's performance based on real usage data.
- **Reduced management overhead.** It's a fully managed Azure service that reduces the management obligations.
- **Migration support.** It supports database migration from on-premises, single-server PostgreSQL databases. You can use the [migration tool](/azure/postgresql/migrate/concepts-single-to-flexible) to simplify the migration process.
- **Consistency with on-premises configurations.** It supports [different community versions of PostgreSQL](/azure/postgresql/flexible-server/concepts-supported-versions), including the version that Proseware uses today.
- **Resiliency.** It automatically creates [server backups](/azure/postgresql/flexible-server/concepts-backup-restore) and stores them on zone redundant storage (ZRS) within the same region. You can restore your database to any point-in-time within the backup retention period. The backup and restoration capability creates a better recovery point objective (RPO) (acceptable amount of data loss) than was possible on-premises.

### Application performance monitoring

[Application Insights](/azure/azure-monitor/app/app-insights-overview) is a feature of Azure Monitor that provides extensible application performance management (APM) and monitoring for live web apps. The web app uses Application Insights for the following reasons:

- **Anomaly detection:** It automatically detects performance anomalies.
- **Troubleshooting:** It helps diagnose issues in the running app.
- **Telemetry:** It collects information about how users are using the app and allows us to easily send custom events we want to track in our app.
- **Solving an on-premises visibility gap.** The on-premises solution didn't have APM. Application Insights provides easy integration with the application platform and code.

Azure Monitor is a comprehensive suite of monitoring tools to collect data from various Azure services. For more information, see:

- [Application Monitoring for Azure App Service and Java](/azure/azure-monitor/app/azure-web-apps-java)
- [Smart detection in application insights](/azure/azure-monitor/alerts/proactive-diagnostics)
- [Application Map: Triaging Distributed Applications](/azure/azure-monitor/app/app-map?tabs=java)
- [Usage analysis with Application Insights](/azure/azure-monitor/app/usage-overview)
- [Getting started with Azure Metrics Explorer](/azure/azure-monitor/essentials/metrics-getting-started)
- [Application Insights Overview dashboard](/azure/azure-monitor/app/overview-dashboard)
- [Log queries in Azure Monitor](/azure/azure-monitor/logs/log-query-overview)

### Cache

[Azure Cache for Redis](/azure-cache-for-redis/cache-overview) is a managed in-memory data store based on the Redis software. The web app needed a cache that provided the following benefits:

- **Speed and volume:** It has high-data throughput and low latency reads for commonly accessed, slow changing data.
- **Diverse supportability:** It's a unified cache location for all instances of our web app to use.
- **Externalized:** The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.

### Global ingress gateway

[Azure Front Door](/azure/frontdoor/front-door-overview) is a content deliver network that uses the Azure backbone network to route traffic between regions. This choice sets up extra features such as Web Application Firewall and positions you to use a content delivery network to provide site acceleration as traffic to the web app increases. The web app uses Azure Front Door because it provides the following benefits:

- **Internet-facing security.** It provides built-in layer 3-4 DDoS protection and integrates with Azure Web Application Firewall (WAF) to protect web apps against common web attacks.
- **Traffic acceleration.** It uses anycast to reach the nearest Azure point of presence and find the fastest route to our web app.
- **Custom domains.** It supports custom domain names with flexible domain validation.
- **Health probes.** The application needed intelligent health probe monitoring. Azure Front Door then uses these responses from the probe to determine the "best" origin to route your client requests.
- **Monitoring support.** It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.

### Web application firewall

[Azure Web Application Firewall](/azure/web-application-firewall/overview) helps provide centralized protection of your web applications from common exploits and vulnerabilities. It's built into Azure Front Door and helps prevent malicious attacks close to the attack sources before they enter your virtual network. Web Application Firewall provides the following benefit

- **Global protection:** It provides global web app protection without sacrificing performance.
- **Botnet protection:** The team can monitor and configure to address security concerns from botnets.
- **Parity with on-premises**: The service allowed us to maintain parity with our on-premises solution, which was running behind a web application firewall managed by IT.

### Secrets manager

[Azure Key Vault](/azure/key-vault/general/overview) provides centralized storage of application secrets to control their distribution. It supports X.509 certificates, connection strings, and API keys to integrate with third-party services. Managed identities are the preferred solution for intra-Azure service communication, but the application still has secrets to manage. The on-premises web app stored secrets on-premises in code configuration files, but it's a better security practice to externalize secrets. The web app uses Key Vault because it provides the following features:

- **Encryption:** It supports encryption at rest and in transit.
- **Supports managed identities:** The application services can use managed identities to access the secret store.
- **Monitoring and logging:** It facilitates audit access and generate alert us when stored secrets change.
- **Integration.** It provides native integration with the web hosting platform (App Service).

### Object storage

Azure Files offers fully managed file shares in the cloud that are accessible via Server Message Block (SMB) protocol, Network File System (NFS) protocol, and Azure Files REST API. Proseware needed a file system to save uploaded training videos and chose Azure Files for the following reasons:

- **Replace existing file server:** Azure Files allows us to replace our existing file server without having to modify our code to use an alternative blob storage mechanism. It's good fit because it simplified the process of getting our app running on the cloud.
- **Fully managed:** Azure file shares allow us to maintain compatibility without needing to manage hardware or operating system for a file server.
- **Resiliency:** Azure Files has been built from the ground up to be always available.
- **Durability.** Azure Files has zone-redundant storage to improve data redundancy and application resiliency. For more information, see [Data redundancy](/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region) and [Zone-redundant storage](/azure/storage/common/storage-redundancy#zone-redundant-storage).

### Endpoint security

[Azure Private Link](/azure/private-link/private-link-overview) provides access to PaaS Services (such as, Azure Cache for Redis and Azure Database for PostgreSQL) over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network. Azure Private DNS with Azure Private Link enables your solution to communicate securely with Azure services without application changes. The web app uses Azure Private Link for the following reasons:

- **Secure communication:** It lets the application privately access services on the Azure platform and reduces the network footprint of data stores to protect against data leakage.
- **Minimal effort:** The private endpoints support the web application platform and database platform the web app uses. Both platforms mirror existing on-premises setup for minimal change.

## Deploy the reference implementation

You can deploy the reference implementation by following the instructions in the [reliable web app pattern for Java repository](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java). Follow the deployment guide to set up a local development environment and deploy the solution to Azure.

## Next step

You learned how to plan the implementation for the reliable web app pattern. The next step is to apply the reliable web app pattern.

>[!div class="nextstepaction"]
>[Apply the pattern](plan-implementation.yml)
