---
ms.custom: devx-track-extended-java, devx-track-javaee
---
This article shows you how to plan an implementation of the Reliable Web App pattern. The Reliable Web App pattern is a set of [principles and implementation techniques](../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the minimal code updates you need to make to be successful in the cloud.

To facilitate the application of this guidance, there's a **[reference implementation](https://aka.ms/eap/rwa/java)** of the Reliable Web App pattern that you can deploy.

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-java.svg)](../../_images/reliable-web-app-java.svg#lightbox)
*Architecture of reference implementation architecture. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java-1.1.vsdx) of this architecture.*

The following guidance uses the reference implementation as an example throughout. To plan an implementation of the Reliable Web App pattern, follow these steps:

## Define business goals

The initial step in transitioning to cloud computing is to articulate your business objectives. The Reliable Web App pattern emphasizes the importance of setting both immediate and future objectives for your web application. These objectives influence your choice of cloud services and the architecture of your web application in the cloud.

*Example:* The fictional company, Contoso Fiber, wanted to expand their on-premises Customer Account Management System (CAMS) web app to reach other regions. To meet the increased demand on the web app, they established the following goals:

- Apply low-cost, high-value code changes
- Reach a service level objective (SLO) of 99.9%
- Adopt DevOps practices
- Create cost-optimized environments
- Improve reliability and security

Contoso Fiber determined that their on-premises infrastructure wasn't a cost-effective solution for scaling the application. So, they decided that migrating their CAMS web application to Azure was the most cost effective way to achieve their immediate and future objectives.

## Choose the right managed services

When you move a web app to the cloud, you should select Azure services that meet your business requirements and align with the current features of the on-premises web app. The alignment helps minimize the replatforming effort. For example, use services that allow you to keep the same database engine and support existing middleware and frameworks. The following sections provide guidance for selecting the right Azure services for your web app.

*Example:* Before the move to the cloud, Contoso Fiber's CAMS web app was an on-premises, monolithic Java web app. It's a Spring Boot app with a PostgreSQL database. The web app is a line-of-business support app. It's employee-facing. Contoso Fiber employees use the application to manage support cases from their customers. The on-premises web app suffers from common challenges. These challenges include extended timelines to build and ship new features and difficulty scaling different application components under higher load.

### Application platform

Choose the best application hosting platform for your web app. Azure has many different compute options to meet a range of web apps requirements. For help with narrowing options, see the Azure [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree).

*Example:* Contoso Fiber chose [Azure App Service](/azure/app-service/overview) as the application platform for the following reasons:

- *Natural progression.* Contoso Fiber deployed a Spring Boot `jar` file on their on-premises server and wanted to minimize the amount of rearchitecting for that deployment model. App Service provides robust support for running Spring Boot apps, and it was a natural progression for Contoso Fiber to use App Service. Azure Spring Apps is also an attractive alternative for this app. If the Contoso Fiber CAMS web app used Jakarta EE instead of Spring Boot, Azure Spring Apps would be a better fit. For more information, see [What is Azure Spring Apps?](/azure/spring-apps/overview) and [Java EE, Jakarta EE, and MicroProfile on Azure](/azure/developer/java/ee/).

- *High SLA.* It has a high SLA that meets the requirements for the production environment.

- *Reduced management overhead.* It's a fully managed hosting solution.

- *Containerization capability.* App Service works with private container image registries like Azure Container Registry. Contoso Fiber can use these registries to containerize the web app in the future.

- *Autoscaling.* The web app can rapidly scale up, down, in, and out based on user traffic.

### Identity management

Choose the best identity management solution for your web app. For more information, see [compare identity management solutions](/entra/identity/domain-services/compare-identity-solutions) and [authentication methods](/entra/identity/hybrid/connect/choose-ad-authn).

*Example:* Contoso Fiber chose [Microsoft Entra ID](/entra/fundamentals/whatis) for the following reasons:

- *Authentication and authorization.* It handles authentication and authorization of employees.

- *Scalability.* It scales to support larger scenarios.

- *User-identity control.* Employees can use their existing enterprise identities.

- *Support for authorization protocols.* It supports OAuth 2.0 for managed identities.

### Database

Choose the best database for your web app. For help with narrowing the options, see the Azure [data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree).

*Example:* Contoso Fiber chose Azure Database for PostgreSQL and the flexible-server option for the following reasons:

- *Reliability.* The flexible-server deployment model supports zone-redundant high availability across multiple availability zones. This configuration and maintains a warm standby server in a different availability zone within the same Azure region. The configuration replicates data synchronously to the standby server.

- *Cross-region replication.* It has a read replica feature that allows you to asynchronously replicate data to a [read-only replica database in another region](/azure/postgresql/flexible-server/concepts-read-replicas).

- *Performance.* It provides predictable performance and intelligent tuning to improve your database performance by using real usage data.

- *Reduced management overhead.* It's a fully managed Azure service that reduces management obligations.

- *Migration support.* It supports database migration from on-premises single-server PostgreSQL databases. They can use the [migration tool](/azure/postgresql/migrate/concepts-single-to-flexible) to simplify the migration process.

- *Consistency with on-premises configurations.* It supports [different community versions of PostgreSQL](/azure/postgresql/flexible-server/concepts-supported-versions), including the version that Contoso Fiber currently uses.

- *Resiliency.* The flexible server deployment automatically creates [server backups](/azure/postgresql/flexible-server/concepts-backup-restore) and stores them using zone-redundant storage (ZRS) within the same region. They can restore their database to any point-in-time within the backup retention period. The backup and restoration capability creates a better RPO (acceptable amount of data loss) than Contoso Fiber could create on-premises.

### Application performance monitoring

Choose to an application performance monitoring for your web app. [Application Insights](/azure/azure-monitor/app/app-insights-overview) is the Azure-native application performance management (APM) solution. It's a feature of Azure's monitoring solution, [Azure Monitor](/azure/azure-monitor/overview).

*Example:* Contoso Fiber added Application Insights for the following reasons:

- *Anomaly detection.* It automatically detects performance anomalies.

- *Troubleshooting.* It helps diagnose problems in the running app.

- *Telemetry.* It collects information about how users are using the app and allows you to easily send custom events that you want to track in your app.

- *On-premises visibility gap.* The on-premises solution didn't have an application performance monitoring solution. Application Insights provides easy integration with the application platform and code.

### Cache

Choose whether to add cache to your web app architecture. [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is Azure's primary cache solution. It's a managed in-memory data store based on the Redis software.

*Example:* Contoso Fiber needed a cache that provides the following benefits:

- *Speed and volume.* It has high-data throughput and low latency reads for commonly accessed, slow-changing data.

- *Diverse supportability.* It's a unified cache location that all instances of the web app can use.

- *External data store.* The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.

- *Nonsticky sessions.* The cache allows the web app to externalize session state use nonsticky sessions. Most Java web app running on premises use in-memory, client-side caching. In-memory, client-side caching doesn't scale well and increases the memory footprint on the host. By using Azure Cache for Redis, Contoso Fiber has a fully managed, scalable cache service to improve scalability and performance of their applications. Contoso Fiber was using a cache abstraction framework (Spring Cache) and only needed minimal configuration changes to swap out the cache provider. It allowed them to switch from an Ehcache provider to the Redis provider.

### Load balancer

Choose the best load balancer for your web app. Azure has several load balancers. For help with narrowing the options, see [choose the best load balancer for your app](/azure/architecture/guide/technology-choices/load-balancing-overview).

*Example:* Contoso Fiber chose Front Door as the global load balancer for following reasons:

- *Routing flexibility.* It allows the application team to configure ingress needs to support future changes in the application.

- *Traffic acceleration.* It uses anycast to reach the nearest Azure point of presence and find the fastest route to the web app.

- *Custom domains.* It supports custom domain names with flexible domain validation.

- *Health probes.* The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.

- *Monitoring support.* It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.

- *DDoS protection.* It has built-in layer 3-4 DDoS protection.

### Web application firewall

Choose a web application firewall to protect your web app from web attacks. [Azure Web Application Firewall](/azure/web-application-firewall/overview) (WAF) is Azure's web application firewall and provides centralized protection of from common web exploits and vulnerabilities.

*Example:* Contoso Fiber chose the Web Application Firewall for the following benefits:

- *Global protection.* It provides increased global web app protection without sacrificing performance.

- *Botnet protection.* You can configure bot protection rules to monitor for botnet attacks.

- *Parity with on-premises.* The on-premises solution was running behind a web application firewall managed by IT.

### Secrets manager

Use [Azure Key Vault](/azure/key-vault/general/overview) if you have secrets to manage in Azure.

*Example:* Contoso Fiber has secrets to manage. They used Key Vault for the following reasons:

- *Encryption.* It supports encryption at rest and in transit.

- *Supports managed identities.* The application services can use managed identities to access the secret store.

- *Monitoring and logging.* It facilitates audit access and generates alerts when stored secrets change.

- *Integration.* It supports two methods for the web app to access secrets. Contoso Fiber can use app settings in the hosting platform (App Service), or they can reference the secret in their application code (app properties file).

### Endpoint security

Choose to enable private only access to Azure services. [Azure Private Link](/azure/private-link/private-link-overview) provides access to platform-as-a-service solutions over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network.

*Example:* Contoso Fiber chose Private Link for the following reasons:

- *Enhanced security.* It lets the application privately access services on Azure and reduces the network footprint of data stores to help protect against data leakage.

- *Minimal effort.* Private endpoints support the web app platform and the database platform that the web app uses. Both platforms mirror the existing on-premises setup, so minimal changes are required.

## Choose the right architecture

After you define what *available* means for your web app and select the right cloud services, you need to determine the best architecture for your web app. Your architecture needs to support your business requirements, technical requirements, and service-level objective.

### Choose architecture redundancy

The business goals determine the level of infrastructure and data redundancy your web app needs. The web app SLO provides a good baseline for understanding your redundancy requirements. Calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) all the dependencies on the critical path of *availability*. Dependencies should include Azure services and non-Microsoft solutions.

Assign an availability estimate for each dependency. Service level agreements (SLAs) provide a good starting point, but SLAs don't account for code, deployment strategies, and architectural connectivity decisions.

*Example:* The reference implementation uses two regions in an active-passive configuration. Contoso Fiber had a 99.9% SLO and needed to use two regions to meet the SLO. The active-passive configuration aligns with Contoso Fiber's goal of minimal code changes for this phase in the cloud journey. The active-passive configuration provides a simple data strategy. It avoids needing to set up event-based data synchronization, data shards, or some other data management strategy. All inbound traffic heads to the active region. If a failure occurs in the active region, Contoso Fiber manually initiates its failover plan and routes all traffic to the passive region.

### Choose a network topology

Choose the right network topology for your web and networking requirements. A hub and spoke network topology is standard configuration in Azure. It provides cost, management, and security benefits. It also supports hybrid connectivity options to on-premises networks.

*Example:* Contoso Fiber chose a hub and spoke network topology to increase the security of their multi-region deployment at reduced cost and management overhead.

### Choose data redundancy

Ensure data reliability by distributing it across Azure's regions and availability zones; the greater their geographical separation, the higher the reliability.

- *Set a recovery point objective (RPO).* RPO defines the maximum tolerable data loss during an outage, guiding how frequently data needs replication. For instance, an RPO of one hour means accepting up to an hour's worth of recent data loss.

- *Implement data replication.* Align data replication with your architecture and RPO. Azure typically supports synchronous replication within availability zones. Utilize multiple zones to enhance reliability easily. For multi-region web apps in an active-passive setup, replicate data to the passive region as per the web app's RPO, ensuring replication frequency surpasses the RPO. Active-active configurations require near real-time data synchronization across regions, which might necessitate code adjustments.

- *Create a failover plan.* Develop a failover (disaster recovery) plan outlining response strategies to outages, determined by downtime or functionality loss. Specify the recovery time objectives (RTO) for maximum acceptable downtime. Ensure the failover process is quicker than RTO. Decide on automated or manual failover mechanisms for consistency and control, and detail the return to normal operations process. Test the failover plan to ensure effectiveness.

*Example:* For the Azure Database for PostgreSQL, the reference implementation uses zone redundant high availability with standby servers in two availability zones. The database also asynchronously replicates to the read-replica in the passive region. Contoso Fiber created a [sample failover plan](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/plan.md). The Azure Database for PostgreSQL read replica are central to Contoso Fiber's failover plan.

## Next step

This article showed you how plan an implementation of the Reliable Web App pattern. The next step is to apply the implementation techniques of the Reliable Web App pattern.

>[!div class="nextstepaction"]
>[Apply the Reliable Web App pattern](apply-pattern.yml)
