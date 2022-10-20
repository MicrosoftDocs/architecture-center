This reference architecture details how to run multiple instances of an Azure Spring Apps service across multiple regions in an active/active and highly available configuration.

For some scenarios, you would like your application to be available in multiple Azure regions. This is the case when you would like to have global reach for your application and, for instance make it available in both Europe, Asia and the Americas. It brings the workload closer to the end user, making latency as low as possible. Or you can make use of multiple regions to increase the overall SLA of your application. You might also use a secondary region as a failover site for your first region and opt for an active/passive setup of one or more regions.

This architecture describes a multi region setup for Azure Spring Apps service. It also takes into account how you load balance the incoming requests to your application to one of the regions your application is deployed in. It also provides host name preservation all the way from the browser request to your application code. [**Deploy this scenario**.](#deploy-this-scenario)

## Architecture

![Multi region Azure Spring Apps reference architecture](./_images/ha-zr-spring-apps-reference-architecture.png)

Download a [Visio file](https://arch-center.azureedge.net/ha-zr-spring-apps-reference-architecture.vsdx) that contains this architecture diagram.

### Workflow

The following workflow corresponds to the above diagram:

- **User browser**. The user navigates to the application by using the applications HTTP host name, for instance `www.contoso.com`.

- **Azure DNS**. Either Azure DNS or another public DNS service will need to be configured to forward the request for this host name to the Azure Front Door service.

- **Azure Front Door**. Azure Front Door is configured with this same host name and a certificate signed by a certificate authority for this host name. Front door is also configured with multiple origins for the requests, one per region you want to deploy your application to. Each origin is pointing to an Application Gateway in this region. Azure Front Door service can use multiple load balancing configurations to forward the request to one region or the other. Currently the solution is configured with an equal weight load balancing rule between the two regions.

- **Application Gateway**. Each region you want to deploy to will have an Application Gateway configured with a Web Application Firewall. The Web Application Firewall will only allow incoming calls from your specific Azure Front Door service. The Application Gateway is also configured with the same host name, which is backed by the same certificate from a well known certificate authority. In each region, the Application Gateway will send the call to the Azure Spring Apps load balancer.

- **Azure Spring Apps**. Azure Spring Apps will be deployed inside a virtual network, in each region. Incoming calls to the Azure Spring Apps load balancer are only allowed from the Application Gateway. Azure Spring Apps is where your application workload will run.

- **MySQL Server**. As a database in this setup we're using Azure MySQL Server, however each database would be ok for data storage. Do note that data syncing may also be needed by your application, this architecture won't describe data sychonisation. You should double check with the data service of your choice what the best setup would be for syncing the data between regions. An other option would be using Azure Cosmos DB as a backend for storing data with multi master write enabled.

- **Key Vault**. Key Vault is used in this architecture to store both the application secrets and certificates. Application secrets are used by the microservices running in Azure Spring Apps. The certificate is used by Azure Spring Apps, Application Gateway and Azure Front Door service to provide the host name preservation.

### Design patterns

This reference architecture uses two cloud design patterns. [Geographical Node (geodes)](../../patterns/geodes.yml), where any region can service any request, and [Deployment Stamps](../../patterns/deployment-stamp.yml) where multiple independent copies of an application or application component are deployed from a single source (deployment template).

### Components

- [Azure DNS Service](https://learn.microsoft.com/azure/dns/dns-overview) is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. In this setup Azure DNS can be used for DNS resolution from your custom domain to your Azure Front Door endpoint.
- [Azure Front Door Service](https://learn.microsoft.com/azure/frontdoor/front-door-overview) can help you deliver higher availability, lower latency, greater scale, and more secure experiences to your users wherever they are. In this solution, it's used to load balance incoming calls to the regions that host your workload.
- [Azure Application Gateway Service](https://learn.microsoft.com/azure/application-gateway/overview) is a web traffic load balancer that enables you to manage traffic to your web applications. It is used as a local reverse proxy in each region you're running your application.
- [Azure Web Application Firewall](https://learn.microsoft.com/azure/web-application-firewall/overview) provides centralized protection of your web applications from common exploits and vulnerabilities. It is configured on the Application Gateway to only allow incoming calls from the Azure Front Door service and to track OWASP exploits.
- [Azure Spring Apps Service](https://learn.microsoft.com/azure/spring-apps/overview) makes it easy to deploy Java Spring Boot applications to Azure without any code changes.
- [Azure Database for MySQL](https://learn.microsoft.com/azure/mysql/single-server/overview) is a relational database service in the Microsoft cloud based on the MySQL Community Edition.
- [Azure Key Vault Service](https://learn.microsoft.com/azure/key-vault/general/overview) is one of several key management solutions in Azure, which helps solve keys, secrets and certificate management problems. In this setup, it's used for storing application secrets and the certificates used by Front Door, Application Gateway and Spring apps.
- [Resource Groups](https://learn.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal) is a logical container for Azure resources. We use resource groups to organize everything related to this setup per region. As a naming convention, the setup also contains a short string for the region a component is deployed to so it easy to identify which region a component is running in.
- [Virtual Network](https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview) is the fundamental building block for your private network in Azure. This setup contains a virtual network per region you deploy this solution to.
- [Private Endpoint](https://learn.microsoft.com/azure/private-link/private-endpoint-overview) is a network interface that uses a private IP address from your virtual network. This network interface connects you privately and securely to a service that's powered by Azure Private Link. By enabling a private endpoint, you're bringing the service into your virtual network. A private endpoint is used for the database and the Key Vault service.
- [Managed Identity](https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) provide an automatically managed identity in Azure Active Directory for applications to use when connecting to resources that support Azure Active Directory (Azure AD) authentication. Applications can use managed identities to obtain Azure AD tokens without having to manage any credentials. Managed Identities are used for multiple interactions in this architecture, for instance between the Spring Apps service and the Key Vault.

## Alternatives

### Multi zone deployment

For increasing the overall resilience and reliability of an application, setting up the application in multiple zones within the same region, can also be utilized. In this case, the application gets deployed in one region, however the multiple zones guarantee the application workload is spread across physically separate locations within each Azure region that are tolerant to local failures. Azure availability zones are connected by a high-performance network with a round-trip latency of less than two ms. The added benefit would be that for data workloads you don't have to rely on asynchronous replication, which in most cases calls for extra design concerns.

When deploying your workload to multiple zones, instead of multiple regions, take the following rules into account:
- The region you're deploying to should support multiple zones. For a list of supported regions, you can check the [list of Azure regions that support availability zones](https://learn.microsoft.com/azure/availability-zones/az-overview#azure-regions-with-availability-zones).
- Preferably all services in your setup should support a multi-zone setup. You can check the [list of Azure services that support availability zones](https://learn.microsoft.com/azure/availability-zones/az-region).

For the services used in this setup:

|Service|Resiliency|
|---|---|
|Azure DNS|Globally available|
|Azure Front Door|Globally available|
|Azure Application Gateway|Zone redundant|
|Azure Web Application Firewall|Zone redundant|
|Azure Spring Apps|Zone redundant|
|Azure Database for MySQL|Zone redundant|
|Azure Key Vault|Zone redundant|
|Azure Resource Groups|not applicable|
|Azure Virtual Network|Zone redundant|
|Azure Private Endpoint|???Zone redundant because Private Link is???|

When you deploy this setup to multiple zones instead of multiple regions for higher resilience and reliability, it still makes sense to front your single region setup with an Azure Front Door service. This Azure Front Door service allows for future expansion, and is an easy way to get a first version of a active/passive setup.

Additionally you can also combine a multi-zone setup with a multi-region setup.

### Backend database

For the backend database, this architecture currently uses a MySQL database. However, other database technologies can be used here, like [Azure SQL Database](https://learn.microsoft.com/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql), [Azure Database for PostgreSQL](https://learn.microsoft.com/azure/postgresql/single-server/overview), [Azure Database for MariaDB](https://learn.microsoft.com/azure/mariadb/overview) and [Azure Cosmos DB](https://learn.microsoft.com/azure/cosmos-db/introduction).

For each of these database technologies, you should double check how to best replicate and synchonize data between regions. In many cases, you'll need to take the replication strategy into account when designing your application across regions, so users don't get to see stale data.

For Azure SQL Database for instance, the [Active geo-replication](https://learn.microsoft.com/azure/azure-sql/database/active-geo-replication-overview?view=azuresql) feature can provide you with a continuously synchronized readable secondary database for a primary database. This feature can be used in case your secondary region is a cold-standby and not receiving active requests. You can use it to fail over to when your primary region is failing. Or you can set up your primary and secondary databases with a private link connection to each of your regions. This setup is described in [Multi-region web app with private connectivity to a database](https://learn.microsoft.com/azure/architecture/example-scenario/sql-failover/app-service-private-sql-multi-region).

Azure Cosmos DB has a feature to [globally distribute](https://learn.microsoft.com/azure/cosmos-db/distribute-data-globally) your data. Azure Cosmos DB transparently replicates the data to all the regions associated with your Azure Cosmos DB account. Additionally Azure Cosmos DB can be configured with [multiple write regions](https://learn.microsoft.com/azure/cosmos-db/high-availability#multiple-write-regions). This architecture is also described in the [geode pattern](https://learn.microsoft.com/azure/architecture/patterns/geodes) and the [Globally distributed applications using Azure Cosmos DB](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/globally-distributed-mission-critical-applications-using-cosmos-db) architecture.

### Backend application service

The principles explained in this architecture don't only apply to Azure Spring Apps, but as a backend any Azure PaaS service can be used. This guidance is also applicable to [App Service](https://learn.microsoft.com/azure/app-service/), [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/), [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/), ...

The most important guidance when switching out Azure Spring Apps for another PaaS service is to properly configure the custom domain in this PaaS service to properly configure the host name preservation.

### Reverse proxy setup

Currently this setup uses two reverse proxies: Azure Front Door and Application Gateway.

Azure Front Door is used to deliver the global load balancing between regions. This reverse proxy is mandatory if you deploy a workload to multiple regions. As an alternative to Azure Front Door, [Azure Traffic Manager](https://learn.microsoft.com/azure/traffic-manager/traffic-manager-overview) can be used. Azure Traffic Manager is a DNS-based traffic load balancer, so it will load balance only at the domain level.

Azure Application Gateway is used as a load balancer per region and could be removed from this architecture setup. If you do so, do take the following guidelines into account:

- The Web Application Firewall is currently attached to the Application Gateway, this will have to be changed to the Front Door service.
- If you remove Application Gateway, you'll need to use other means to determine that incoming calls originate only from your Azure Front Door instance. You can do this by adding the X-FDID header check and the Azure Front Door IP ranges check in the Azure Spring Apps api-gateway service. The [Expose Azure Spring Apps through a reverse proxy](https://learn.microsoft.com/azure/architecture/reference-architectures/microservices/spring-cloud-reverse-proxy) article describes the different scenario's. This article also explains how these scenario's can be set up and what you need to take into account from a security perspective in each.

### Routing between regions

Currently routing is configured in the Azure Front Door service with equal weight routing between the regions you deploy to. There are however different [traffic routing methods to origin](https://learn.microsoft.com/azure/frontdoor/routing-methods) available in Azure Front Door. If you want to route clients to the origin closest to them, latency-based routing will make more sense. If you're designing for an active/passive setup, priority-based routing will be better suited. 

### High availability mode

How you set up this architecture is dependent on your business case. In case global presence is what you're designing for, you may want to use even more regions than the two in this reference setup.

If high availability is what you're designing for, you still have the options to set up this architecture in a active/active, active/passive with hot standby or active/passive with cold standby mode.

- `active/active`: This mode is how the current reference architecture is set up. Two regions are used and both are able to answer requests.
  - Biggest challenge with this setup is keeping the data between the two (or more) regions in sync.
  - Active/active is a costly solution, since you pay twice for almost all components.
- `active/passive with hot standby`: This setup is similar to the current setup, however, your secondary region won't receive any requests from the Azure Front Door service as long as the primary region is active. In this setup, you make sure that the data of the application is properly replicated from your primary to your secondary region. In case a failure occurs in your primary region, you change the roles of your backend databases and fail over all the traffic through Azure Front Door to your secondary region.
  - This setup is easier as to keeping all data in sync, since the failover is allowed to take some time.
  - This setup is as costly as the active/active setup.
- `active/passive with cold standby`: In cold standby mode, you don't necessarily deploy all the needed components to the secondary region or you deploy them with lower compute resources. You may go for a more extended or less extended setup in your secondary region. How much you extend this setup will depend on how much downtime your business is allowed to have if there's a failure. It will also depend on the cost impact of the setup in your secondary region. You should at least make sure the data is present in the secondary region. In case you have your entire setup described in templates for the setup, you can easily enable the secondary region, by creating its resources on the fly. Doing so is something that you should test regularly, as to make sure your templates are deployable if there's an emergency.
  - This setup is easier as to keeping all data in sync, since the failover is allowed to take some time.
  - This setup will be the most cost effective, since you won't deploy all the resources to both regions.

## Solution details

### Potential use cases

With private connectivity to a backend database and high availability in multiple regions, this solution has applications in many areas. Examples include the financial, healthcare, defense industries and applications that:

- Track customer spending habits and shopping behavior.
- Analyze manufacturing Internet of Things (IoT) data.
- Display smart meter data or use smart technology to monitor meter data.

These use cases can additionaly benefit from a multi-region deployment:

- Design a business continuity and disaster recovery plan for LoB applications
- Deploy mission-critical applications
- Improve user experience by keeping applications available

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Regional pairing

Each Azure region is paired with another region within the same geography. In general, for availability, choose regions from the same regional pair (for example, East US 2 and Central US). Benefits of doing so include:

- If there's a broad outage, recovery of at least one region out of every pair is prioritized.
- Planned Azure system updates are rolled out to paired regions sequentially to minimize possible downtime.
- In most cases, regional pairs reside within the same geography to meet data residency requirements.

However, make sure that both regions support all of the Azure services needed for your application. See [Services by region](https://azure.microsoft.com/explore/global-infrastructure/geographies/#services). For more information about regional pairs, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions](https://learn.microsoft.com/azure/availability-zones/cross-region-replication-azure).

In case you're using this architecture to make your application globally available, you'll probably not choose paired regions. In that case choosing zone redundancy within each region you deploy to, makes more sense.

### Resource groups

Consider placing the primary region, secondary region, and Front Door into separate resource groups. Resource groups lets you manage the resources deployed to each region as a single collection.

### Deployment

Automate your deployments as much as possible. Automation can be done for the infrastructure in each of the regions, but also for your application code. When automating infrastructure deployments, you can guarantee that infrastructure in each of the regions you deploy to is configured in the same way. This avoids configuration drift between the regions.

The automation of infrastructure can also help you in testing out failovers and in quickly bringing up a secondary region.

For application deployment, make sure your deployment systems are aware of the multiple regions they need to deploy to. In case you have multiple regions available to deploy to, you can additionaly use them in a blue-green or canary deployment strategy. With these deployment strategies, you roll out a new version of the application to one region to test. After testing has proven successful, you roll out the version further across other regions.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This architecture explicitly will increase the overall availability of your application, than a single-region deployment does.

From the point of view of the application workload, you can use this architecture in either an active-passive configuration or an active-active configuration. With an active-active approach, Front Door routes traffic to both regions simultaneously.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This architecture is locked down from a networking perspective. It only allows incoming calls from the Azure Front Door service. These calls are routed to the Application Gateway in each region. Fron the Application Gateway the calls are then routed to the backend Azure Spring Apps service. From the Spring Apps service communication to supporting services, like the backend database and the Key Vault, is also locked down by usage of a Private Endpoint.

Extra security is provided by utilizing a Managed Identity for connecting between different components in this architecture. Azure Spring Apps for instance, uses a Managed Identity to connect to the Key Vault. Key Vault in its turn is configured to only allow Spring Apps minimal access to read the needed secrets, certificates and keys.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

This solution effectively doubles the cost of a single-region version. But certain circumstances can affect this estimate:

- You can use a scaled-down version of resources like Spring Apps and Application Gateway in the standby region and scale it up only when it becomes the active region.
- You have significant cross-region traffic. Network traffic between Azure regions incurs charges.

Make sure that the primary and secondary databases use the same service tier. Otherwise, the secondary database may not keep up with replication changes.

For cost saving, you can deploy different applications and application types to a single instance of Azure Spring Apps. The service supports autoscaling of applications triggered by metrics or schedules that can improve utilization and cost efficiency.

You can also use Application Insights and Azure Monitor to lower operational cost. With the visibility provided by the comprehensive logging solution, you can implement automation to scale the components of the system in real time. You can also analyze log data to reveal inefficiencies in the application code that you can address to improve the overall cost and performance of the system.

The alternative setup where you only utilize one reverse proxy can also help in saving costs. Do note that you'll need to apply extra configuration to maintain the same level of security of your setup.

With an active/passive setup cost savings can also be achieved. It will depend on your business case whether active passive is an option for you.

All the mentioned services are pre-configured in an [Azure pricing calculator estimate](https://azure.com/e/b7876a2581f44431812751664b1249e1) with reasonable default values for a small scale application. You should update this estimate based on the values you would have for the throughput you expect for your application.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

As with the single-region reference architecture for Azure Spring Apps, this architecture addresses the same aspects of operational excellence. Additionaly, as you'll see in the [deploy this scenario](#deploy-this-scenario) section, the full architecture roll-out can also be automated.

This architecture also follows the multi region deployment recommendation, described in the [DevOps section of the Azure Well Architected Framework](https://learn.microsoft.com/azure/architecture/framework/devops/release-engineering-cd#consider-deploying-across-multiple-regions).

For operational excellence, you should also make sure to integrate all components of this setup with Azure Monitor and Log Analytics to provide insight into your application front to back.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

First of, this architecture, when deployed in multiple active regions, will be better suited to answer to your application demands as opposed to a single-region deployment, since load will be spread across multiple regions. In case Azure Front Door is configured to route requests based on latency, customers will get better response times, since a request is routed to a region closest to them.

Depending on your database setup, you might experience extra latency. This extra latency is there when data needs to be synchronized between regions. This latency can be overcome when using Azure Cosmos DB with a more relaxed [consistency level](https://learn.microsoft.com/azure/cosmos-db/consistency-levels).

This architecture additionaly contains multiple components where you can auto-scale individual components based on metrics: 

- `Azure Front Door` will autoscale for you based on demand. Additionally you can use features from Azure Front Door, like its caching capabilities to bring assets even closer to your end users and traffic acceleration.
- `Azure Application Gateway` supports [autoscaling](https://learn.microsoft.com/azure/application-gateway/application-gateway-autoscaling-zone-redundant)
- `Azure Spring Apps` supports [autoscaling](https://learn.microsoft.com/azure/spring-apps/how-to-setup-autoscale)

## Deploy this scenario

A deployment for a reference architecture that implements these recommendations and considerations is available on [GitHub](https://github.com/Azure-Samples/azure-spring-apps-multi-region).

This architecture is fully templated. Execution steps for the setup are included in the [GitHub repository](https://github.com/Azure-Samples/azure-spring-apps-multi-region#getting-started)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 - [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

Other contributors:

 - [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | FastTrack for Azure Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

Related architectures:

* [Spring Apps via reverse proxy](/reference-architectures/microservices/spring-cloud-reverse-proxy)
* [High-availability blue/green deployment](/example-scenario/blue-green-spring/blue-green-spring)
* [Microservices with Azure Spring Apps](/azure/spring-cloud/reference-architectur)
- [Preserve the original HTTP host name between a reverse proxy and its back-end web application](/best-practices/host-name-preservation)