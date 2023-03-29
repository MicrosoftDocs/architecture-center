Setting up [Azure Spring Apps](/azure/spring-apps/overview) clusters in multiple regions poses availability, automation, and traffic forwarding challenges. This reference architecture runs multiple Azure Spring Apps instances across multiple regions in an active/active and highly available configuration. For a templated deployment of this architecture, see [Deploy this scenario](#deploy-this-scenario).

## Architecture

![Diagram that shows a multiregion Azure Spring Apps reference architecture.](./_images/spring-apps-reference-architecture.png)

*Download a [Visio file](https://arch-center.azureedge.net/ha-zr-spring-apps-reference-architecture.vsdx) that contains this architecture diagram.*

### Workflow

1. The user accesses the application via browser by using the HTTP host name of the application, for example `www.contoso.com`. [Azure DNS](/azure/dns/dns-overview) or another public DNS service resolves the request for this host name to Azure Front Door.

1. [Azure Front Door](/azure/frontdoor/front-door-overview) uses various load balancing configurations to forward the requests to specific regions. This example uses an equal-weight load balancing rule between the two regions. Azure Front Door is configured with:

   - A custom domain and a transport-layer security (TLS) certificate that are named the same as the application host name, for example `www.contoso.com`.
   
   - One origin per region where the application is deployed. Each origin is an [Azure Application Gateway](/azure/application-gateway/overview) instance.

1. Application Gateway deploys with [Azure Web Application Firewall](/azure/web-application-firewall/overview) in each region. The Application Gateways are configured with the same custom domain name and TLS certificate name as Azure Front Door. Web Application Firewall allows incoming calls only from the specified Azure Front Door profile.

1. Application Gateway forwards allowed traffic to the Azure Spring Apps load balancers, which allow incoming calls only from the Application Gateway.

1. Azure Spring Apps runs the application workload inside a virtual network in each region.

1. The components inside the virtual networks use [private endpoints](/azure/private-link/private-endpoint-overview) to connect privately and securely to other Azure services. This solution uses private endpoints to connect to the databases and the key vaults.

   - The example uses [Azure Database for MySQL](/azure/mysql/single-server/overview) for data storage, but you can use any database. For alternatives, see [Backend database](#backend-database).

   - [Azure Key Vault](/azure/key-vault/general/overview) stores application secrets and certificates. The microservices running in Azure Spring Apps use the application secrets. Azure Spring Apps, Application Gateway, and Azure Front Door use the certificates for host name preservation.

### Design patterns

This reference architecture uses the following cloud design patterns:

- [Geographical nodes (Geodes)](../../patterns/geodes.yml), where any region can service any request
- [Deployment Stamps](../../patterns/deployment-stamp.yml), where multiple independent copies of an application or component can deploy from a single template

### Components

- [Azure DNS](https://azure.microsoft.com/products/dns) is a hosting service for Domain Name System (DNS) domains that provides name resolution by using Azure infrastructure. This solution uses Azure DNS for DNS resolution from your custom domain to your Azure Front Door endpoint.
- [Azure Front Door](https://azure.microsoft.com/products/frontdoor) helps you deliver higher availability, lower latency, greater scale, and more secure experiences to your users wherever they are. In this solution, Azure Front Door acts as a load balancer for incoming calls to the regions that host your workload.
- [Application Gateway](https://azure.microsoft.com/products/application-gateway) is a web traffic load balancer that enables you to manage traffic to your web applications. Application Gateway acts as a local reverse proxy in each region your application runs in. Application Gateway is optional in this solution. For alternatives, see [Reverse proxy setup](#reverse-proxy-setup).
- [Azure Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall) provides centralized protection of your web applications from common exploits and vulnerabilities. Web Application Firewall on the Application Gateway allows incoming calls only from Azure Front Door, and tracks Open Web Application Security Project (OWASP) exploits.
- [Azure Spring Apps](https://azure.microsoft.com/products/spring-apps) makes it easy to deploy Java Spring Boot applications to Azure without any code changes.
- [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a relational database service in the Azure cloud that's based on the MySQL Community Edition.
- [Key Vault](https://azure.microsoft.com/products/key-vault) is one of several key management solutions in Azure that help manage keys, secrets, and certificates. This solution uses Key Vault for storing application secrets and the certificates that Azure Front Door, Application Gateway, and Azure Spring Apps use.
- [Azure resource groups](https://azure.microsoft.com/get-started/azure-portal/resource-manager) are logical containers for Azure resources. In this solution, resource groups organize components per region. As a naming convention, the setup includes a short string for the component's region, so it's easy to identify which region the component is running in.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for a private network in Azure. This solution uses a virtual network for each region you deploy to.
- [Azure Private Link](https://azure.microsoft.com/products/private-link) provides private endpoints that connect privately and securely to services. These network interfaces use private IP addresses to bring the services into the virtual networks. This solution uses private endpoints for the database and the key vault.
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) in [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory) provide automatically managed identities that applications can use to connect to resources that support Azure AD authentication. Applications can use managed identities to get Azure AD tokens without having to manage any credentials. This architecture uses managed identities for several interactions, for example between Azure Spring Apps and the key vault.

## Alternatives

The following sections discuss alternatives for several aspects of this architecture.

### Multizone deployment

To increase application resilience and reliability, you can alternatively deploy the application to multiple [availability zones](/azure/availability-zones/az-overview#availability-zones) within a single region. The multiple zones spread the application workload across physically separate locations that can tolerate local failures within the Azure region.

Azure availability zones are connected by a high-performance network with a roundtrip latency of less than 2 ms. An added benefit is that you don't have to rely on asynchronous replication for data workloads, which often presents extra design challenges.

To deploy your workload to multiple zones instead of multiple regions:

- The region you're deploying to must support multiple zones. For a list of regions that support zones, see [Azure regions with availability zone support](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).

- Preferably, all services in your solution should support multiple zones. For a list of services that support zones, see [Azure services with availability zone support](/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support).

The following table shows the resiliency types for the services in this architecture. Zone-redundant services replicate or distribute resources across zones automatically. Always-available services are always available across all Azure geographies, and are resilient to both zone-wide and region-wide outages.

|Service|Resiliency|
|---|---|
|Azure DNS|Always available|
|Azure Front Door|Always available|
|Application Gateway|Zone redundant|
|Azure Spring Apps|Zone redundant|
|Azure Database for MySQL|Zone redundant|
|Key Vault|Zone redundant|
|Azure resource groups|Not applicable|
|Virtual Network|Zone redundant|
|Azure private endpoints|Zone redundant|

You can also combine a multizone solution with a multiregion solution.

### Backend database

This architecture uses a MySQL database for the backend database. You can also use other database technologies, like [Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview), [Azure Database for PostgreSQL](/azure/postgresql/single-server/overview), [Azure Database for MariaDB](/azure/mariadb/overview), or [Azure Cosmos DB](/azure/cosmos-db/introduction).

In many cases, you need to take data replication strategy into account when you design your application across regions, so users won't see stale data. The current architecture doesn't address data synchronization. For each of the database technologies, you should check how to best replicate and synchronize data between regions.

For example, the SQL Database [active geo-replication](/azure/azure-sql/database/active-geo-replication-overview) feature can provide a continuously synchronized, readable secondary database for a primary database. You can use this feature:

- If your secondary region is a cold standby that doesn't receive active requests.
- To fail over to if your primary region fails.
- To set up primary and secondary databases with private link connections to their respective regions, with [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) between the two regions. For more information, see [Multiregion web app with private connectivity to a database](../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml).

Azure Cosmos DB can [globally distribute](/azure/cosmos-db/distribute-data-globally) data by transparently replicating the data to all the regions in your Azure Cosmos DB account. You can also configure Azure Cosmos DB with [multiple write regions](/azure/cosmos-db/high-availability#multiple-write-regions). For more information, see [Geode pattern](../../patterns/geodes.yml) and [Globally distributed applications using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/globally-distributed-mission-critical-applications-using-cosmos-db).

### Backend application service

This architecture can apply not only to Azure Spring Apps, but to any Azure platform as a service (PaaS) back end. For example, you can use this architecture with [Azure App Service](/azure/app-service), [Azure Kubernetes Service (AKS)](/azure/aks), or [Azure Container Apps](/azure/container-apps). The most important guideline when you use a different PaaS service is to properly configure host name preservation for the custom domain in the service.

### Reverse proxy setup

Azure Front Door does global load balancing between regions. This reverse proxy helps distribute the traffic if you deploy a workload to multiple regions. As an alternative, you can use [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview). Traffic Manager is a DNS-based traffic load balancer that load balances only at the domain level.

The current solution uses two reverse proxies: Azure Front Door and Application Gateway. Application Gateway acts as a load balancer per region. Alternatively, you can remove Application Gateway from the setup if you address the following requirements:

- Because the Web Application Firewall is attached to the Application Gateway, you need to attach the firewall to the Azure Front Door service instead.

- You need a way to ensure that incoming calls originate only from the Azure Front Door instance. You can add the X-FDID header check and the Azure Front Door IP ranges check in the Spring Cloud Gateway app. For more information, see [Use Azure Front Door as the reverse proxy](spring-cloud-reverse-proxy.yml#scenario-4-using-azure-front-door-as-the-reverse-proxy).

For information about different reverse proxy scenarios, how to set them up, and their security considerations, see [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml).

### Routing between regions

This example configures Azure Front Door with equal routing between the two deployment regions. Azure Front Door also provides other [traffic routing methods to origin](/azure/frontdoor/routing-methods). If you want to route clients to their closest origin, latency-based routing makes the most sense. If you're designing for an active/passive solution, priority-based routing is more appropriate.

### High availability mode

How you set up this architecture is dependent on your business case. For example, if you're designing for global presence, you might want to use more than two regions. If you're designing for high availability, you can set up this architecture in an *active/active*, *active/passive with hot standby*, or *active/passive with cold standby* mode.

- **Active/active** is the mode in the current example. Two regions exist, and both answer requests.
  - The biggest challenge with this mode is keeping the data between the regions in sync.
  - Active/active is a costly solution, because you pay twice for almost all components.
  
- **Active/passive with hot standby** is similar to the current setup, but the secondary region doesn't receive any requests from Azure Front Door as long as the primary region is active. You make sure to properly replicate your application data from your primary to your secondary region. If a failure occurs in your primary region, you change the roles of your backend databases and fail over all traffic through Azure Front Door to your secondary region.
  - It's easier to keep all data in sync, because failover is expected to take some time.
  - This mode is as costly as active/active mode.
  
- **Active/passive with cold standby** might initially deploy fewer components, or components with lower compute resources, to the secondary region. Whether to use a more or less extended solution in your secondary region depends on how much downtime your business permits if there's a failure. The extent of your secondary region setup also affects costs. You should make sure that at least the application data is present in the secondary region.
  - It's easier to keep data in sync, because failover is expected to take some time.
  - This mode is the most cost effective, because you don't deploy all the resources to both regions.

  If your entire solution setup uses templates, you can easily deploy a cold standby secondary region by creating its resources on the fly. You can use Bicep/Azure Resource Manager (ARM) or Terraform templates, and automate infrastructure setup in a continuous integration/continuous deployment (CD/CD) pipeline. You should regularly test recreating your secondary region to make sure your templates are deployable in an emergency.

### Key vault

This solution stores the application secrets and certificates in a single key vault. However, because application secrets and the certificates for host name preservation are different concerns, you might want to store them in separate key vaults. This alternative adds another key vault per region to your architecture.

## Solution details

This architecture describes a multiregion design for Azure Spring Apps, and describes how to load balance incoming application requests to the regions your application is deployed in. This architecture is useful when you want to:

- Have global reach for your application, for example availability in Europe, Asia, and the Americas.
- Bring the workload closer to the end user, making latency as low as possible.
- Increase the overall resilience and service level objective (SLO) of your application.
- Use a secondary region as a failover site for your primary region, and opt for an active/passive design.

### Potential use cases

Private connectivity to a backend database and high availability in multiple regions make this solution applicable to the financial, healthcare, and defense industries. The following applications and use cases can also benefit from multiregion deployment:

- Track customer spending habits and retail shopping behavior.
- Analyze manufacturing internet of things (IoT) data.
- Use smart technology to monitor and display meter data.
- Design a business continuity and disaster recovery plan for line-of-business (LoB) applications.
- Deploy mission-critical applications.
- Improve user experience by keeping applications available.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have specific requirements that override them.

### Resource groups

Use Azure resource groups to manage resources deployed to each region as a single collection. Consider placing the primary region, secondary region, and Front Door into separate resource groups, as shown in the following diagram:

![Diagram that shows different resource groups.](./_images/spring-apps-resource-groups.png)

In this example:

- Azure Front Door is deployed in the `Application-shared` resource group.
- All resources hosted in West Europe are deployed in the `Application-weu` resource group.
- Resources hosted in East US are hosted in the `Application-eus` resource group.
- Resources hosted in Japan East are hosted in the `Application-jae` resource group.

Resources split up in this way share the same lifecycle and can be easily created and deleted together. Each region has its own set of resources, with a naming convention based on the region's name. Azure Front Door is in its own resource group, because it must exist even if regions are added or removed.

### Automated deployment

Automate your deployments as much as possible. You can automate infrastructure management in each region, and also automate application code deployments.

Automating infrastructure deployments guarantees that infrastructure in each region is configured the same, avoiding configuration drift between the regions. Infrastructure automation can also help you test failover and quickly bringing up a secondary region.

For application deployment, make sure your deployment systems target the multiple regions they need to deploy to. You can also use multiple regions in a [blue-green](../../example-scenario/blue-green-spring/blue-green-spring.yml) or canary deployment strategy. With these deployment strategies, you roll out new versions of applications to one region for testing, and to other regions after testing is successful.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This architecture explicitly increases the availability of your application over a single-region deployment. From an application workload viewpoint, you can use this architecture in either an active/passive or an active/active configuration. With an active/active approach, Azure Front Door routes traffic to both regions simultaneously.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

From a networking perspective, this architecture is locked down to allow incoming calls only from Azure Front Door. These calls are routed to the Application Gateway in each region. From the Application Gateway, the calls route to the backend Azure Spring Apps service. Communication from Azure Spring Apps to supporting services, like the backend database and the key vault, is also locked down by using private endpoints.

This architecture provides extra security by using a managed identity to connect between different components. For example, Azure Spring Apps uses a managed identity to connect to Key Vault. Key Vault allows Azure Spring Apps only minimal access to read the needed secrets, certificates, and keys.

You should also protect your virtual networks with [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview). DDoS Protection, combined with application design best practices, provides enhanced mitigations to defend against distributed denial-of-service (DDoS) attacks.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

This solution effectively doubles the cost of a single-region version. The following considerations can affect this estimate:

- The primary and secondary databases must use the same service tier. Otherwise, the secondary database might not keep up with replication changes.
- Significant cross-region traffic increases costs. Network traffic between Azure regions incurs charges.

To address costs:
- You can use scaled-down versions of resources like Azure Spring Apps and Application Gateway in the standby region, and scale up the resources only when the standby becomes active.
- You can deploy different applications and application types to a single instance of Azure Spring Apps.
- Azure Spring Apps supports application autoscaling triggered by metrics or schedules, which can improve utilization and cost efficiency.
- You can use Application Insights in [Azure Monitor](/azure/azure-monitor/overview) to lower operational costs. A comprehensive logging solution provides visibility for automation to scale components in real time. Analyzing log data can also reveal inefficiencies in application code that you can address to improve costs and performance.
- The alternative setup that uses only one reverse proxy can help save costs. You need to apply extra configuration to maintain the security of this alternative.
- An active/passive setup also saves costs. Whether active/passive is an option for you depends on your business case.
- A multizone setup in a single region can meet availability and resilience business needs and be more cost effective, because you only pay for most resources once.

All the services this architecture describes are pre-configured in an [Azure pricing calculator estimate](https://azure.com/e/b7876a2581f44431812751664b1249e1) with reasonable default values for a small scale application. You can update this estimate based on the throughput values you expect for your application.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

This architecture addresses the same aspects of operational excellence as the [single-region reference architecture for Azure Spring Apps](/azure/spring-cloud/reference-architecture). You can automate the full architecture rollout.

This architecture also follows the multiregion deployment recommendation in the [Release Engineering: Deployment](/azure/architecture/framework/devops/release-engineering-cd#consider-deploying-across-multiple-regions) section of the operational excellence pillar.

For operational excellence, integrate all components of this solution with Azure Monitor Logs to provide end-to-end insight into your application.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This multiregion architecture in an active/active configuration is better suited than a single-region deployment to meet application demands, because it spreads the load across regions. If you configure Azure Front Door to route requests based on latency, users get better response times, because requests are routed to the regions closest to them.

Depending on your database setup, you might incur extra latency when data needs to be synchronized between regions. You can overcome this latency by using Azure Cosmos DB with a more relaxed [consistency level](/azure/cosmos-db/consistency-levels).

This architecture has several components that can autoscale based on metrics:

- Azure Front Door can autoscale based on demand. You can use other Azure Front Door features, like traffic acceleration and caching capabilities, to bring assets closer to your end users.
- Application Gateway supports autoscaling. For more information, see [Scale Application Gateway v2 and WAF v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).
- Azure Spring Apps also supports autoscaling. For more information, see [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale).

## Deploy this scenario

A deployment for this reference architecture is available at [Azure Spring Apps multiregion reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-region) on GitHub. The deployment uses Terraform templates. To deploy the architecture, [follow the step-by-step instructions](https://github.com/Azure-Samples/azure-spring-apps-multi-region#getting-started).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

Other contributors:

 - [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | FastTrack for Azure Engineer
 - [Christof Claessens](https://www.linkedin.com/in/christofclaessens) | FastTrack for Azure Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What are Azure regions and availability zones?](/azure/reliability/availability-zones-overview)
- [Azure Spring Apps reference architecture](/azure/spring-cloud/reference-architecture)
- [Best practices for Azure Front Door](/azure/frontdoor/best-practices)
- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)

## Related resources

- [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml)
- [High-availability blue/green deployment](../../example-scenario/blue-green-spring/blue-green-spring.yml)
- [Preserve the original HTTP host name between a reverse proxy and its back-end web application](../../best-practices/host-name-preservation.yml)
- [Multiregion web app with private connectivity to a database](../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml)
