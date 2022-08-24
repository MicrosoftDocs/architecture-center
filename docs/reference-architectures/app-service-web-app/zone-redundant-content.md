This reference architecture shows how to run a web-app workload on Azure App Services in a zone-redundant configuration. [Zone-redundant services][az-ha-services] provide high-availability by replicating your services and data across Availability zones to protect from single points of failure. [**Deploy this scenario**.](#deploy-this-scenario)

## Architecture

![Reference architecture for a web application with high availability](./images/zone-redundant-web-app-diagram.png)

_Download a [Visio file](https://arch-center.azureedge.net/architecture.vsdx) that contains this architecture diagram._

This architecture builds on [Availability zones infrastructure][azs] found in many Azure regions today. For a list of Azure regions that support Availability Zones, see [Azure regions with Availability Zones][az-regions].

Availability zones spread a solution across multiple independent zones within a region, allowing for an application to continue functioning when one zone fails. Most foundational and mainstream Azure services, and many specialized Azure services provide support for availability zones today. 

All of the Azure services in this architecture are either always-available or zone-redundant services. Azure Front Door, Azure Active Directory (Azure AD), Azure DNS and Static Web Apps are always-available (non-regional) services, resilient to zone and region-wide outages. All other services are zone-redundant.

Zone-redundant Azure services automatically manage and mitigate failures, including zone failures, to maintain their [service level agreements (SLAs)](https://azure.microsoft.com/support/legal/sla/). Zone-redundancy offers effective recovery times of zero for zone failure. If a single zone within a region becomes unavailable, you shouldn't expect to lose any data, and your workload should continue to run.

For a list of highly available services in Azure, see [Azure Services that support Availability Zones][az-services].

### Workflow and components

A SPA (single page application) running in a browser requests static assets including scripts, stylesheets and media assets. Once loaded, the SPA makes API calls that provide functionality.

* SPA users are authenticated by [Azure Active Directory (Azure AD)][aad] or [Azure AD B2C][aad-b2c]. The browser performs DNS lookups to resolve addresses to Azure Front Door.
* [Azure Front Door][afd] is the public front-end for all internet requests, acting as a global HTTP reverse proxy and cache in front of several Azure services. Front Door also provides automatic protection from layer 4 DDoS attacks, and a range of other features to enhance the security and performance of your application.
* [Azure Static Web Apps][swa] hosts all of the SPA assets, including scripts, stylesheets and media.
* [Azure App Service][app-services] hosts the "front-end" API applications that are called by the SPA. Deployment slots are used to provide zero-downtime releases.
* App Services and Functions Apps use [Virtual Network (VNet) Integration][vnet-integration] to connect to backend Azure services over a private VNet.
* [Azure Functions][functions] provides a data access layer for Azure SQL Database. APIs hosted in App Services trigger these functions synchronously via HTTPS requests and asynchronously via Service Bus messages.
* [Azure Cache for Redis][redis] provides a high-performance distributed cache for output, session and general-purpose caching.
* [Azure Service Bus][service-bus] acts as an asynchronous high-speed bus between front-end and back-end application services.
* [Azure Cosmos DB][cosmos-db] provides NoSQL document databases for front-end application services.
* [Azure SQL DB][sql-db] provides a transactional and relational database for back-end application services.
* [Azure Cognitive Search][cog-search] indexes Cosmos DB documents, allowing them to be searched via an API.
* [Azure Blob Storage][storage] stores meta-data and trigger state for Function Apps.
* [Private Endpoints][peps] allow connections to Azure services from private VNets, and allow the public endpoints on these services to be disabled.
* [Azure private DNS][private-dns] automatically configures and updates the DNS records required by private endpoint services.
* [Azure Key Vault][akv] securely stores secrets and certificates to be accessed by Azure services.
* [Azure Monitor][azmon] and [Application Insights][insights] collects service logs and application performance metrics for observability.

### Networking

Private endpoints are used throughout this architecture to improve security. While private endpoints don't directly improve (or reduce) the availability of this solution, they allow important security principals to be applied. For more information about security design principals, see [Azure well architected framework - Security pillar][waf-security].   

Network segmentation boundaries are established along public and private lines. Azure Front Door, Azure Static Web Apps and Azure App Service are designed to operate on the public internet. These services have their public endpoints enabled. However, App Service has access restrictions in place to ensure that only traffic allowed by Front Door WAF (Web Application Firewall) is allowed to ingress into the App Service. 

Azure services that don't require access from the public internet have private endpoints enabled and public endpoints disabled. The Azure data services Cosmos DB, SQL DB, Azure Cache for Redis, Cognitive Search and Storage all have public endpoints disabled. Each private endpoint is deployed into its own subnet. Azure service firewalls are used to only allow traffic from other authorized Azure services. 

> For network and subnet topology details, see the [Azure quickstart template][quickstart] for this architecture.

### Alternatives

* Either Azure Active Directory (Azure AD) or Azure AD B2C can be used as an IDP in this scenario. Azure AD is designed for internal applications and business-to-business (B2B) scenarios, while Azure AD B2C is designed for business-to-consumer (B2C) scenarios.
* You can choose to use Azure-managed DNS, which we recommend, or your own DNS provider.
* [Azure Application Gateway][appgw] can be used instead of Azure Front Door when most users are located close to the Azure region that hosts your workload, and content caching isn't required.
* Azure Static Web Apps provides direct integration with Azure App Service for secure and seamless routing. When Static Web Apps is linked to App Service, only requests made from the static web app will resolve, and public access to the App Service will be rejected. For more information about Static Web Apps integration with Azure App Service, see [Overview of API support in Azure Static Web Apps][swa-apis]. In this architecture
* [Static website hosting in Azure Storage][storage-spa] may be considered in place of Azure Static Web Apps, if already using Azure CDN for example. However static website hosting in Azure Storage does have limitations. For more information, see [Static website hosting in Azure Storage][storage-spa]. Azure Static Web Apps was chosen for its global high availability, and its simple deployment and configuration.
* A premium [Azure API Manager][apim] instance deployed with zone-redundancy enabled is a good alternative for hosting frontend APIs, backend APIs or both. For more information about zone-redundancy in API Manager, see [availability zone support][apim-zr].

### Solution details

Customers want the convenience of websites and apps that are available when they need them. Traditionally, it's been hard to keep hosting platforms highly available at scale. High availability has historically required complex and expensive multi-region deployments, and require considering tradeoffs between data consistency and high performance.

[Availability zones][azs] resolve these issues. Availability zones are physically separate locations within each Azure region that are tolerant to local failures. Use zone-redundant deployments to spread workloads across multiple independent zones, improving availability. Azure automatically replicates data between the zones, and automatically fails over if a zone fails.

This architecture shows how to combine zone-redundant services into a solution that provides high availability and is resilient to zone failure. The solution is less complex than multi-region alternatives, offering more cost-optimization opportunities and simplifying operational requirements. There are many more benefits including:

* **You don't need to manage zone pinning or zonal deployments.** Zone redundancy is configured at deployment time and is automatically managed by services throughout their lifetime.
* **Recovery time from a zone failure is much shorter than a cross-region failover.** Recovery time from zone-failure for zone-redundant services is practically zero. In a multi-region deployment, you need to carefully manage the failover process, and deal with any data replication delays that might result in data loss.
* **Simplified networking.** All VNet traffic can remain in the same Azure region.

### Potential use cases

* Public website hosting
* Mobile app hosting
* E-commerce
* Business critical systems with high availability requirements

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Front Door

Azure Front Door is a global service, always available across all Azure geographies and resilient to zone-wide outages and region-wide outages.

* Use [Azure managed certificates][afd-certs] on all frontends to prevent certificate mis-configuration and expiration issues.
* Enable [Caching][afd-cache] on routes where appropriate to improve availability. Front Door's cache distributes your content to the Azure PoP (point of presence) edge nodes. In addition to improving your performance, caching reduces the load on your origin servers.
* Deploy Azure Front Door Premium and configure a [WAF policy][afd-waf] with a Microsoft-managed ruleset. Apply the policy to all custom domains. Use Prevention mode to mitigate web attacks that might cause an origin service to become unavailable.
* Use [Private link in Azure Front Door Premium][afd-pep] to secure connectivity to Azure App Service.

### Azure Static Web Apps

Azure Static Web Apps is a global service resilient to zone and region failures. Deploy a Standard plan for production apps. API support and Enterprise-grade edge aren't required for this architecture as Premium Functions and Azure Front Door are used instead. 

### App Services

[App Service Premium v2, Premium v3][app-services-zr] and [Isolated v3][ise-zr] App Service Plans offer zone redundancy. You must deploy a minimum of three instances of the plan. In this configuration, App Service Plan instances are distributed across multiple availability zones to protect from zone failure. App Service automatically balances your load across the instances and zones.

* Deploy a minimum of three instances for zone-redundancy.
* Add App Service access restrictions so that only Front Door traffic is allowed. Access restrictions ensure that requests aren't able to bypass the Azure Front Door WAF (Web Application Firewall). For more information about restricting access to a specific Azure Front Door instance, see [App Service access restrictions][app-service-controls].
* Enable [Virtual Network (VNet) Integration][appservice-vnet] for private networking with backend Azure services.

### Azure Functions

[Azure Functions Elastic Premium][functions-zr] offers zone redundancy  when you deploy a minimum of three instances of your plan and opt into zone redundancy.

* Deploy a minimum of three instances for zone-redundancy.
* Enable a Private endpoint and deny access to public endpoint traffic.
* Integrate the Private endpoint with an Azure Private DNS zone.
* Enable Virtual Network (VNet) Integration for private networking with backend services.

For more information about Private endpoints and VNet integration in Azure Functions, see [Integrate Azure Functions with an Azure virtual network][func-vnet].

### SQL Database

[Zone-redundancy in Azure SQL DB][sql-gp-zr] is supported in General Purpose, Premium, and Business Critical tiers.

* Deploy Azure SQL DB General Purpose, Premium, or Business Critical with zone-redundancy enabled.
* [Configure SQL DB backups][sql-backups-zr] to use ZRS (zone-redundant storage) or GZRS (geo-zone-redundant storage).
* [Create a Private link for Azure SQL DB][sql-pep] and disable the public endpoint.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Cosmos DB

Enable [zone-redundancy in Azure Cosmos DB][cosmos-ha] when selecting a region to associate with your Azure Cosmos account.

* Enable zone-redundancy when adding the local read/write region to the Azure Cosmos account.
* [Enable continuous backups][cosmos-backup].
* [Configure private link for the Cosmos DB account][cosmos-pep]. Enabling the private endpoint will disable the public endpoint.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Blob Storage

Azure [Zone-Redundant Storage][zrs] (ZRS) replicates your data synchronously across three Azure availability zones in the region.

* Create a Standard ZRS or Standard GZRS storage account for hosting web assets. By using these storage account SKUs, you ensure that your data is replicated across availability zones.
* Create separate storage accounts for web assets, Azure Functions meta-data, and other data, so that the accounts can be managed and configured separately.
* [Use private endpoints for Azure Storage][storage-pep].
* Configure the Storage firewall to deny public internet traffic.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Service Bus

[Service Bus Premium][servicebus-az] supports Availability Zones, providing fault-isolated locations within the same Azure region.

* Enable zone-redundancy on a new Azure Service Bus Premium namespace.
* [Configure private link][sb-pep] for the Azure Service Bus namespace.
* Integrate the Private endpoint with an Azure Private DNS zone.
* Specify at least one IP rule or virtual network rule for the namespace to allow traffic only from the specified IP addresses or subnet of a virtual network. Adding a rule will disable the public endpoint.

### Cache for Redis

Cache for Redis supports [zone-redundancy][redis-zr] in certain tiers. To enable zone redundancy for Azure Cache for Redis, follow the instructions in [Enable zone redundancy for Azure Cache for Redis][enable-redis-zr].

In this architecture, Azure Cache for Redis is deployed with a private endpoint and the public endpoint is disabled.

* Deploy a new Azure Cache for Redis with a private endpoint, or add a private endpoint to an existing cache.
* Set the `publicNetworkAccess` flag to `Disabled` to disable the public endpoint.

For more information about private endpoints on Azure Redis Cache, see [Azure Cache for Redis with Azure Private Link][redis-pep].

### Cognitive Search

You can utilize [Availability Zones with Azure Cognitive Search][cog-search-az] by adding more replicas to your search service. Each replica will be placed in a different Availability Zone within the region.

* Deploy a minimum of three replicas for zone-redundancy.
* [Create a private endpoint for Azure Cognitive Search][cog-search-pep]. Adding a private endpoint will disable the public endpoint.
* Integrate the private endpoint with an Azure Private DNS zone.

### Key Vault

Key Vault is automatically zone-redundant in any region where Availability zones are available. The Key Vault used in this architecture is deployed with a private endpoint enabled and public disabled for backend services to access secrets. For more information about Private endpoints for Azure Key Vault, see [Integrate Key Vault with Azure Private Link][akv-pep].

### Azure DNS Private Zones

Integrate Private Endpoints with Azure DNS Private Zones to simplify DNS management. For more information, see [Azure Private Endpoint DNS configuration][pep-dns].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Availability

This reference architecture is designed to provide high availability through availability zone infrastructure. When implemented properly this architecture will provide excellent availability for lower cost and operational overhead than other solutions. However, improvements can always be made. The risk of a zone failure in an Azure region is mitigated by this design. Zone redundant services in Azure are designed to withstand a zone failure while still operating within SLA. 

Region failures are unlikely, but possible. Region failures are where services are unavailable throughout all availability zones in a region. It's important to understand the types of risks that you mitigate by using multi-zone and multi-region architectures.

Mitigate the risk of region failure by combining this zone-redundant architecture with a multi-region architecture. You should understand how to plan your multi-region architecture to reduce your solution's recovery time if an entire region is unavailable.

Multi-region designs are more complex and often more expensive than multi-zone designs within a single region.

> [!NOTE]
> You should perform a risk assessment to determine if a multi-region architecture is required for your solution.

#### Resilience

Multi-zone designs based on Availability zones offer levels of availability and resilience that meet or exceed the business requirements of most customers. However, for customers who want to replicate data to a secondary region for disaster recovery, the options you have available depend on the Azure services that you use.

For example, Azure Storage supports [object replication for block blobs][object-replication]. Azure data services like Cosmos DB also offer replication of data to other Azure regions with continuous backup. You can use these features to restore your solution if a disaster occurs. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB][cosmos-continuous-backup].

#### Global services

Failures in global services like Azure Front Door and Azure Active Directory (Azure AD) are rare, but impact can be high. Improve recovery by preparing and rehearsing runbooks to be used if failure occurs. 

For example, Front Door service downtime can be mitigated with a runbook that deploys an [Azure Application Gateway][appgw] and changes DNS records, redirecting traffic until Front Door service is restored.

See also this important guidance for increasing resilience to Azure AD failures by [building resilience in identity and access management infrastructure][aad-resilience].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

* Private endpoints are used on Azure services that don't need to be accessed from the public internet. 
* Deployments with higher security requirements could also use [Private link in Azure Front Door Premium][afd-pep] to secure connectivity to Azure App Service.
* Access restrictions on Azure App Service should be configured to only allow Front Door traffic. Access restrictions ensure that requests aren't able to bypass the Azure Front Door WAF (Web Application Firewall). 
* All service-to-service communication in Azure is TLS (transport layer security) encrypted by default. Azure Front Door, Azure App Services and Azure Static Web Apps should be configured to accept HTTPS traffic only.
* Managed identities are used for authenticating Azure service-to-service communication. For more information about managed identities, see [What are managed identities for Azure resources?][msi].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Zone-redundant architectures are less expensive than multi-region alternatives because services can be deployed in a single region. However, there are several cost implications that customers should be aware of:

* Some zone-redundant services incur charges for inter-zone bandwidth. For more information, see [Bandwidth pricing][bandwidth-pricing].
* Some services require a minimum number of instances or replicas to be deployed to achieve zone-redundancy.
* Zone redundant storage (ZRS) is priced differently to Locally redundant storage (LRS). For more information, see [Storage pricing][storage-pricing].
* Private endpoints are mostly available on Premium Azure service SKUs. Private endpoints incur hourly and bandwidth (data) charges. For more information, see [Private Link pricing][pep-pricing].

Some cost optimization considerations include:

* Save money when you reserve resources in advance. Several services in this architecture are eligible for Reserved capacity pricing. For more information about Reserved capacity, see [Reservations][reservations].
* Function Apps can be hosted in the same dedicated App Service Plan as the API Apps. Combining the plans removes the segmentation of frontend and backend services and introduces risk of noisy neighbor effect; backend services could consume resources needed by frontend services, and vice-versa. Hosting Functions in an App Service plans also negates the elasticity benefits the Elastic Premium plan.
* Private endpoints can be removed to save costs. Conduct a risk assessment to determine the risk of enabling public endpoints on backend services. Use managed identities and enable service firewalls to provide defense in depth.

> An example bill of materials for this architecture can be viewed in [Azure Pricing Calculator][bom].

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

All Azure PaaS (Platform as a Service) services are integrated with [Azure Monitor][azmon]. Follow [Azure monitor best practices][azmon-bp] to:

* Configure the right amount of log data collection.
* Create Azure Dashboards for "single pane of glass" views for operations teams.
* Create a successful alerting strategy.
* Integrate [Application Insights][insights] into apps to track application performance metrics.  

Azure App Services and Azure Functions provide deployment slots. Practice [staged deployments][app-service-staging] for zero-downtime releases.

Automate service deployments with [Bicep][bicep], a template language for deploying Infrastructure as Code. A [Quickstart Bicep file][quickstart] is provided for this architecture that can be used to automatically deploy the entire solution.

Test the performance and resilience of the entire solution with [Azure Load Testing][load-tests] and [Azure Chaos Studio][chaos].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This architecture can be highly optimized for performance and scale:

* Develop web apps as Single page applications (SPAs)
* Host SPAs in Azure Static Web Apps
* Cache SPA assets in Azure Front Door to distribute workloads to the Azure Edge.
* Use premium services for maximum performance and scale, including App Services Premium and Azure Functions Premium.
* Use Azure Front Door as a global HTTP load balancer in front of multiple Premium App Service Plans to unlock even greater scale.
* Review [subscription limits and quotas][quotas] to ensure services will scale to demand.
* Consider [Azure monitor autoscale][autoscale] rules to scale App Service and Functions instances based on a schedule and/or CPU load.
* Monitor application performance using [Azure Monitor - Application Insights][insights]

## Deploy this scenario

Deploy this reference architecture using the [Azure Quickstart Template][quickstart]. 

* Azure AD / Azure AD B2C and Azure DNS aren't deployed by this sample. 
* Custom domain names and TLS/SSL certificates aren't created and configured. Default frontend DNS names are used instead.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 - [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz/) | FastTrack for Azure Customer Engineer
 
Other contributors: 

 - [John Downs](https://www.linkedin.com/in/john-downs/) | FastTrack for Azure Customer Engineer

## Next steps

* [Microsoft Azure Well-Architected Framework - Reliability][learn-ha] - Learn module.
* [Find an Availability Zone region near you][region-roadmap]


## Related resources

* [Highly available multi-region web app](./multi-region.yml)
* [Design principles for Azure applications](/azure/architecture/guide/design-principles)


<!-- links -->
[aad]:https://azure.microsoft.com/services/active-directory/
[aad-b2c]:https://azure.microsoft.com/services/active-directory/external-identities/b2c/
[afd]:https://azure.microsoft.com/services/frontdoor/
[swa]:https://azure.microsoft.com/services/app-service/static/
[app-services]:https://azure.microsoft.com/services/app-service/
[vnet-integration]:https://docs.microsoft.com/azure/app-service/overview-vnet-integration#regional-virtual-network-integration
[functions]:https://azure.microsoft.com/services/functions/
[redis]:https://azure.microsoft.com/services/cache/
[service-bus]:https://azure.microsoft.com/services/service-bus/
[cosmos-db]:https://azure.microsoft.com/services/cosmos-db/
[sql-db]:https://azure.microsoft.com/products/azure-sql/database/
[cog-search]:https://azure.microsoft.com/services/search/
[storage]:https://azure.microsoft.com/services/storage/blobs/
[peps]:https://docs.microsoft.com/azure/private-link/private-endpoint-overview
[akv]:https://azure.microsoft.com/services/key-vault/
[insights]:https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview
[appgw]:https://azure.microsoft.com/services/application-gateway/
[cdn]:https://azure.microsoft.com/services/cdn/
[storage-spa]:https://docs.microsoft.com/azure/storage/blobs/storage-blob-static-website
[azs]:https://azure.microsoft.com/global-infrastructure/availability-zones/
[az-ha-services]:https://docs.microsoft.com/azure/availability-zones/az-region#highly-available-services
[zrs]: https://docs.microsoft.com/azure/storage/common/storage-redundancy#zone-redundant-storage
[storage-pep]:https://docs.microsoft.com/azure/storage/common/storage-private-endpoints
[az-regions]:https://docs.microsoft.com/azure/availability-zones/az-region#azure-regions-with-availability-zones
[az-services]:https://docs.microsoft.com/azure/availability-zones/az-region
[servicebus-az]:https://docs.microsoft.com/azure/service-bus-messaging/service-bus-outages-disasters#availability-zones
[redis-zr]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-high-availability#zone-redundancy
[enable-redis-zr]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-how-to-zone-redundancy
[redis-pep]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-private-link
[cog-search-az]:https://docs.microsoft.com/azure/search/search-performance-optimization#availability-zones
[cog-search-pep]:https://docs.microsoft.com/azure/search/service-create-private-endpoint
[akv-pep]:https://docs.microsoft.com/azure/key-vault/general/private-link-service
[app-services-zr]:https://docs.microsoft.com/azure/app-service/how-to-zone-redundancy
[functions-zr]:https://docs.microsoft.com/azure/azure-functions/azure-functions-az-redundancy
[func-vnet]:https://docs.microsoft.com/azure/azure-functions/functions-create-vnet
[ise-zr]:https://docs.microsoft.com/azure/app-service/environment/overview-zone-redundancy
[sql-gp-zr]:https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability
[cosmos-ha]:https://docs.microsoft.com/azure/cosmos-db/high-availability
[waf]:https://docs.microsoft.com/azure/architecture/framework/
[object-replication]:https://docs.microsoft.com/azure/storage/blobs/object-replication-overview
[cosmos-continuous-backup]:https://docs.microsoft.com/azure/cosmos-db/continuous-backup-restore-introduction
[afd-certs]:https://docs.microsoft.com/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#azure-managed-certificates
[afd-cache]:https://docs.microsoft.com/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium
[afd-waf]:https://docs.microsoft.com/azure/web-application-firewall/afds/afds-overview
[app-service-staging]:https://docs.microsoft.com/azure/app-service/deploy-staging-slots
[appservice-vnet]:https://docs.microsoft.com/azure/app-service/configure-vnet-integration-enable
[sql-backups-zr]:https://docs.microsoft.com/azure/azure-sql/database/automated-backups-overview?view=azuresql&tabs=single-database#configure-backup-storage-redundancy-by-using-the-azure-cli
[sql-pep]:https://docs.microsoft.com/azure/azure-sql/database/private-endpoint-overview?view=azuresql
[cosmos-backup]:https://docs.microsoft.com/azure/cosmos-db/provision-account-continuous-backup
[cosmos-pep]:https://docs.microsoft.com/azure/cosmos-db/how-to-configure-private-endpoints
[storage-spa]:https://docs.microsoft.com/azure/storage/blobs/storage-blob-static-website
[sb-pep]:https://docs.microsoft.com/azure/service-bus-messaging/private-link-service
[swa-apis]:https://docs.microsoft.com/azure/static-web-apps/apis-overview
[pep-dns]:https://docs.microsoft.com/azure/key-vault/general/private-link-service
[aad-resilience]:https://docs.microsoft.com/azure/active-directory/fundamentals/resilience-in-infrastructure
[bandwidth-pricing]:https://azure.microsoft.com/pricing/details/bandwidth/
[storage-pricing]:https://azure.microsoft.com/pricing/details/storage/blobs/
[pep-pricing]:https://azure.microsoft.com/pricing/details/private-link/
[reservations]:https://azure.microsoft.com/reservations/
[bom]:https://azure.com/e/3aeac3eda5d44a85baea8d335ce23772
[msi]:https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview
[azmon]:https://azure.microsoft.com/services/monitor/
[azmon-bp]:https://docs.microsoft.com/azure/azure-monitor/best-practices
[quickstart]:https://azure.microsoft.com/resources/templates/zone-redundant-web-app
[load-tests]:https://azure.microsoft.com/services/load-testing/
[chaos]:https://azure.microsoft.com/services/chaos-studio/
[quotas]:https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits
[autoscale]:https://docs.microsoft.com/azure/azure-monitor/autoscale/autoscale-get-started
[learn-ha]:https://docs.microsoft.com/learn/modules/azure-well-architected-reliability/
[region-roadmap]:https://azure.microsoft.com/global-infrastructure/geographies/
[apim-zr]:https://docs.microsoft.com/azure/availability-zones/migrate-api-mgt
[app-service-controls]:https://docs.microsoft.com/azure/app-service/app-service-ip-restrictions#restrict-access-to-a-specific-azure-front-door-instance
[private-dns]:https://docs.microsoft.com/azure/dns/private-dns-overview
[apim]:https://azure.microsoft.com/services/api-management/
[afd-pep]:https://docs.microsoft.com/azure/frontdoor/private-link
[waf-security]:https://docs.microsoft.com/azure/architecture/framework/security/security-principles