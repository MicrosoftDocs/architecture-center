---
ms.custom: devx-track-extended-java, devx-track-javaee
---
The reliable web app pattern provides essential guidance on how to move web apps to the cloud. The pattern is a set of principles and implementation techniques. They define how you should update (replatform) your web app to be successful in the cloud.

This article helps you plan the implementation of the reliable web app pattern. The companion article provides the implementation guidance to **[apply the reliable web app pattern](apply-pattern.yml)**. There's a **[reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java)** in GitHub that you can deploy.

## Architecture

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-java.svg)](../../_images/reliable-web-app-java.svg#lightbox)
*Figure 1. Target reference implementation architecture. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java.vsdx) of this architecture. For the estimated cost of this architecture, see the [production environment cost](https://azure.com/e/4e27d768a5924e3d93252eeceb4af4ad) and [nonproduction environment cost](https://azure.com/e/1721b2f3f2bd4340a00115e79057177a).*

## Define business goals

The initial step in transitioning to cloud computing is to clearly articulate your business objectives. The reliable web app pattern emphasizes the importance of setting both immediate and future objectives for your web application. These objectives influence your choice of cloud services and how your web application will be structured in the cloud.

*Reference implementation:* Consider the example of a fictional company named Proseware. Company leadership at Proseware wants to expand their business into the education technology application market. After their initial technical research, they concluded that they can use their existing internal training web app as a starting point. The long term plan is to make the web app a customer facing application. Proseware needs to update the application to handle that increase in user load.

To reach these long term goals, Proseware calculated that moving the web app to the cloud offered the best return on investment. The cloud offered them a way to meet the increased business demand with minimal investments in the existing web app.

| Immediate app goals | Future app goals |
| --- | --- |
| ▪ Apply low-cost, high-value code changes<br>▪ Reach a service level objective of 99.9%<br>▪ Adopt DevOps practices<br>▪ Create cost-optimized environments <br>▪ Improve reliability and security|▪ Improve availability<br>▪ Expedite new feature delivery<br>▪ Scale components based on traffic.|

## Define a service level objective

A service level objective (SLO) for availability defines how available you want a web app to be for users. The definition of what *available* means is different for every web app. You need to define what available means for your web app. It might be a core functionality of your web app, such as when customers can purchase products. After you define *available* for your web app, you need to figure out how available you need your web app to be in percentage uptime (for example, 99.9%). This percentage is the web app SLO. The SLO plays a significant role in the services you choose and the architecture you adopt.

*Reference implementation:* For Proseware, the web app is considered available when employees can watch training videos. Proseware set a target SLO of 99.9% (about 8.7 hours of downtime per year).

## Choose the right managed services

When you move a web app to the cloud, you should select Azure services that meet your business requirements and align with the current features of the on-premises web app. The alignment helps minimize the replatforming effort. For example, keep the same database engine and application hosting platform. The following sections provide guidance for selecting the right Azure services for your web app.

*Reference implementation:* Proseware's existing web app is on premises. It's a monolithic Java web app that runs a web based media stream called Airsonic. Airsonic is a well-known open-source project, but in this fictional scenario, Proseware owns the code. Code ownership is a more common scenario than an upstream dependency. The on-premises web app is a Spring Boot app, which runs on an Apache Tomcat web server with a PostgreSQL database.  It's important to take the Java middleware and frameworks used by the web app into account when you move it to the cloud. The web app is a line-of-business training app. It's employee-facing. Proseware employees use the application to complete required HR training. The on-premises web app suffers from common challenges. These challenges include extended timelines to build and ship new features and difficulty scaling different application components under higher load.

### Application platform

Choose the best application hosting platform for your web app. Azure has many different compute options to meet a range of web apps requirements. For help with narrowing options, see the Azure [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree).

*Reference implementation:* Proseware chose [Azure App Service](/azure/app-service/overview) as the application platform for the following reasons:

- *Natural progression.* On-premises, Proseware deployed a Spring Boot `war` file to a Tomcat server and wanted to minimize the amount of rearchitecting for that deployment model. Because App Service has great support for Tomcat, it's a natural progression for Proseware.  Azure Spring Apps is also an attractive alternative for this app. For more information on Azure Spring Apps, see [What is Azure Spring Apps?](/azure/spring-apps/overview). If the Proseware app happened to use Jakarta EE instead of Spring Boot, you might consider the options for running Jakarta EE on Azure. For more information, see [Java EE, Jakarta EE, and MicroProfile on Azure](/azure/developer/java/ee/).
- *High SLA.* It has a high SLA that meets the requirements for the production environment.
- *Reduced management overhead.* It's a fully managed hosting solution.
- *Containerization capability.* App Service works with private container image registries like Azure Container Registry. Proseware can use these registries to containerize the web app in the future.
- *Autoscaling.* The web app can rapidly scale up, down, in, and out based on user traffic.

### Identity management

Choose the best identity management solution for your web app. For more information, see [compare identity management solutions](/entra/identity/domain-services/compare-identity-solutions) and [authentication methods](/entra/identity/hybrid/connect/choose-ad-authn).

*Reference implementation:* Proseware chose [Microsoft Entra ID](/entra/fundamentals/whatis) for the following reasons:

- *Authentication and authorization.* It handles authentication and authorization of employees.
- *Scalability.* It scales to support larger scenarios.
- *User-identity control.* Employees can use their existing enterprise identities.
- *Support for authorization protocols.* It supports OAuth 2.0 for managed identities and OpenID Connect for future B2C support.

### Database

Choose the best database for your web app. For help with narrowing the options, see the Azure [data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree).

*Reference implementation:* Proseware chose Azure Database for PostgreSQL and the flexible-server option for the following reasons:

- *Reliability.* The flexible-server deployment model supports zone-redundant high availability across multiple availability zones. This configuration and maintains a warm standby server in a different availability zone within the same Azure region. The configuration replicates data synchronously to the standby server.
- *Cross-region replication.* It has a read replica feature that allows you to asynchronously replicate data to a [read-only replica database in another region](/azure/postgresql/flexible-server/concepts-read-replicas).
- *Performance.* It provides predictable performance and intelligent tuning to improve your database performance by using real usage data.
- *Reduced management overhead.* It's a fully managed Azure service that reduces management obligations.
- *Migration support.* It supports database migration from on-premises single-server PostgreSQL databases. You can use the [migration tool](/azure/postgresql/migrate/concepts-single-to-flexible) to simplify the migration process.
- *Consistency with on-premises configurations.* It supports [different community versions of PostgreSQL](/azure/postgresql/flexible-server/concepts-supported-versions), including the version that Proseware currently uses.
- *Resiliency.* The flexible server deployment automatically creates [server backups](/azure/postgresql/flexible-server/concepts-backup-restore) and stores them using zone-redundant storage (ZRS) within the same region. You can restore your database to any point-in-time within the backup retention period. The backup and restoration capability creates a better RPO (acceptable amount of data loss) than Proseware could create on-premises.

### Application performance monitoring

Choose to an application performance monitoring for your web app. [Application Insights](/azure/azure-monitor/app/app-insights-overview) is the Azure-native application performance management (APM) solution. It's a feature of Azure's monitoring solution, [Azure Monitor](/azure/azure-monitor/overview).

*Reference implementation:* Proseware added Application Insights for the following reasons:

- *Anomaly detection.* It automatically detects performance anomalies.
- *Troubleshooting.* It helps diagnose problems in the running app.
- *Telemetry.* It collects information about how users are using the app and allows you to easily send custom events that you want to track in your app.
- *Solving an on-premises visibility gap.* The on-premises solution didn't have APM. Application Insights provides easy integration with the application platform and code.

### Cache

Choose whether to add cache to your web app architecture. [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is Azure's primary cache solution. It's a managed in-memory data store based on the Redis software.

*Reference implementation:* Proseware needed a cache that provides the following benefits:

- *Speed and volume.* It has high-data throughput and low latency reads for commonly accessed, slow-changing data.
- *Diverse supportability.* It's a unified cache location that all instances of the web app can use.
- *Externalized.* The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.
- *Enabling non-sticky sessions.* The cache allows the web app to externalize session state use nonsticky sessions. Most Java web app running on premises use in-memory, client-side caching. In-memory, client-side caching doesn't scale well and increases the memory footprint on the host. By using Azure Cache for Redis, Proseware has a fully managed, scalable cache service to improve scalability and performance of their applications. Proseware was using a cache abstraction framework (Spring Cache) and only needed minimal configuration changes to swap out the cache provider. It allowed them to switch from an Ehcache provider to the Redis provider.

### Load balancer

Choose the best load balancer for your web app. Azure has several load balancers. For help with narrowing the options, see [choose the best load balancer for your app](/azure/architecture/guide/technology-choices/load-balancing-overview).

*Reference implementation:* Proseware chose Front Door as the global load balancer for following reasons:

- *Routing flexibility.* It allows the application team to configure ingress needs to support future changes in the application.
- *Traffic acceleration.* It uses anycast to reach the nearest Azure point of presence and find the fastest route to the web app.
- *Custom domains.* It supports custom domain names with flexible domain validation.
- *Health probes.* The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.
- *Monitoring support.* It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.
- *DDoS protection.* It has built-in layer 3-4 DDoS protection.

### Web application firewall

Choose a web application firewall to protect your web app from web attacks. [Azure Web Application Firewall](/azure/web-application-firewall/overview) (WAF) is Azure's web application firewall and provides centralized protection of from common web exploits and vulnerabilities.

*Reference implementation:* Proseware chose the Web Application Firewall for the following benefits:

- *Global protection.* It provides increased global web app protection without sacrificing performance.
- *Botnet protection.* You can configure bot protection rules to monitor for botnet attacks.
- *Parity with on-premises.* The on-premises solution was running behind a web application firewall managed by IT.

### Secrets manager

Use [Azure Key Vault](/azure/key-vault/general/overview) if you have secrets to manage in Azure.

*Reference implementation:* Proseware has secrets to manage. They used Key Vault for the following reasons:

- *Encryption.* It supports encryption at rest and in transit.
- *Supports managed identities.* The application services can use managed identities to access the secret store.
- *Monitoring and logging.* It facilitates audit access and generates alerts when stored secrets change.
- *Integration.* It supports two methods for the web app to access secrets. You can use app settings in the hosting platform (App Service), or you can reference the secret in your application code (app properties file).

### File storage

Choose the best storage solution for your web app. For help deciding, see [Review your storage options](/azure/architecture/guide/technology-choices/storage-options).

*Reference implementation:* Proseware needed a file system for saving uploaded training videos. Proseware chose Azure Files for the following reasons:

- *Replaces existing file server.* Azure Files is a drop-in replacement for our on-premises network attached storage (NAS) solution. Azure Files allows Proseware to replace the existing file server without needing to modify code if they wanted to add blob storage. Azure Files simplifies the process of getting the app running on the cloud.
- *Fully managed service.* It enables Proseware to maintain compatibility without needing to manage hardware or an operating system for a file server.
- *Resiliency.* It has a geo-zone-redundant storage (GZRS) option that supports Proseware's disaster recovery plan. In the primary region, the GZRS option copies data synchronously across three Azure availability zones. In the secondary region, GZRS copies your data asynchronously to a single physical location in the secondary region. Within the secondary region, your data is copied synchronously three times.
- *Durability.* It has zone-redundant storage to improve data redundancy and application resiliency. For more information, see [Data redundancy](/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region) and [Zone-redundant storage](/azure/storage/common/storage-redundancy#zone-redundant-storage).

### Endpoint security

Choose to enable private only access to Azure services. [Azure Private Link](/azure/private-link/private-link-overview) provides access to platform-as-a-service solutions over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network.

*Reference implementation:* Proseware chose Private Link for the following reasons:

- *Enhanced security.* It lets the application privately access services on Azure and reduces the network footprint of data stores to help protect against data leakage.
- *Minimal effort.* Private endpoints support the web app platform and the database platform that the web app uses. Both platforms mirror the existing on-premises setup, so minimal changes are required.

## Choose the right architecture

After you define what *available* means for your web app and select the best cloud services, you need to determine the best architecture for your web app. Your architecture needs to support your business requirements, technical requirements, and SLO.

### Choose architecture redundancy

The business goals determine the level of infrastructure and data redundancy your web app needs. The web app SLO provides a good baseline for understanding your redundancy requirements. Calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) all the dependencies on the critical path of *availability*. Dependencies should include Azure services and non-Microsoft solutions.

Assign an availability estimate for each dependency. Service level agreements (SLAs) provide a good starting point. SLAs don't account for code, deployment strategies, and architectural connectivity decisions.

*Reference implementation:* The reference implementation uses two regions in an active-passive configuration. Proseware had a 99.9% SLO and needed to use two regions to meet the SLO. The active-passive configuration aligns with Proseware's goal of minimal code changes for this phase in the cloud journey. The active-passive configuration provides a simple data strategy. It avoids needing to set up event-based data synchronization, data shards, or some other data management strategy. All inbound traffic heads to the active region. If a failure occurs in the active region, Proseware manually initiates its failover plan and routes all traffic to the passive region.

### Choose data redundancy

Ensure data reliability by distributing it across Azure's regions and availability zones; the greater their geographical separation, the higher the reliability.

- *Set a recovery point objective (RPO).* RPO defines the maximum tolerable data loss during an outage, guiding how frequently data needs replication. For instance, an RPO of one hour means accepting up to an hour's worth of recent data loss.

- *Implement data replication.* Align data replication with your architecture and RPO. Azure typically supports synchronous replication within availability zones. Utilize multiple zones to enhance reliability easily. For multi-region web apps in an active-passive setup, replicate data to the passive region as per the web app's RPO, ensuring replication frequency surpasses the RPO. Active-active configurations require near real-time data synchronization across regions, which might necessitate code adjustments.

- *Create a failover plan.* Develop a failover (disaster recovery) plan outlining response strategies to outages, determined by downtime or functionality loss. Specify the recovery time objectives (RTO) for maximum acceptable downtime. Ensure the failover process is quicker than RTO. Decide on automated or manual failover mechanisms for consistency and control, and detail the return to normal operations process. Test the failover plan to ensure effectiveness.

*Reference implementation:* The reference implementation has two main data stores: Azure Files and PostgreSQL database. The reference implementation uses geo-zone-redundnant storage (GZRS) with Azure Files. GZRS asynchronously creates a copy of Azure Files data in the passive region. Check the [last sync time property](/azure/storage/common/last-sync-time-get) to get an estimated RPO for the synchronization. For the Azure Database for PostgreSQL, the reference implementation uses zone redundant high availability with standby servers in two availability zones. The database also asynchronously replicates to the read replica in the passive region. Proseware created a [sample failover plan](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/plan.md). Azure Files GZRS and the Azure Database for PostgreSQL read replica are central to Proseware's failover plan.

## Next step

This article showed you how plan an implementation of the reliable web app pattern. The next step is to apply the implementation techniques of the reliable web app pattern.

>[!div class="nextstepaction"]
>[Apply the reliable web app pattern](apply-pattern.yml)
