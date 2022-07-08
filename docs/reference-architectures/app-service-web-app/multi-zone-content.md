<!-- cSpell:ignore CNAME -->


This reference architecture shows how to run a web-app workload on Azure App Services in a zone-redundant configuration. [Zone-redundant services][az-ha-services] provide high-availability by replicating your services and data across Availability zones to protect from single points of failure.

![Reference architecture for a web application with high availability](./images/multi-zone-web-app-diagram.png)

<!-- *See a [full working sample of this architecture in Azure Samples], including Visio file, Bicep template and Bill of materials.* -->

## Architecture

This architecture builds on [Availability zones infrastructure][azs] found in many Azure regions today. For a list of Azure regions that support Availability Zones see [Azure regions with Availability Zones][az-regions].

Availability Zones spread a solution across multiple independent zones within a region, allowing for an application to continue functioning when one zone fails. Most foundational and mainstream Azure services, and many Specialized Azure services provide support for Availability Zones today. All of the Azure services in this architecture are zone-redundant, simplifying deployment and management. For a list of Azure services that support Availability Zones see [Azure Services that support Availability Zones][az-services].

Zone-redundant Azure services automatically manage and mitigate failures, including zone failures, to maintain their [service level agreements (SLAs)](https://azure.microsoft.com/support/legal/sla/). Zone-redundancy offers an effective RTO and RPO for zone (datacenter) failure of zero. This means that, if a single zone within a region becomes unavailable, you should not expect to lose any data and your workload should continue to run.

This architecture deploys the following services:

* **Front Door**: Deploy Front Door as a front-end for all origin services to simplify management, improve performance and provide protection from DDOS attacks.
* **App Services**: Host web apps and web API's in a App Service Plan to provide high-availability, enable zero-downtime releases, and simplify management.
* **Azure Functions**: Deploy Premium Function Apps in a virtual network to host private backend services and API's that are highly available, resilient and scalable. 
* **Azure SQL DB**: Azure SQL DB provides a highly-available relational data store for system of record and transactional systems.
* **Cosmos DB**: Cosmos DB provides no-sql databases for web, mobile and service databases with high throughput and scale.
* **Storage**: Zone-redundant storage (ZRS) provides a highly durable origin file-server for static web assets including SPA's (single page applications) and media content. 
* **Service Bus**: Use a Service Bus namespace for highly reliable queues for asynchronous messaging between frontend and backend services.
* **Azure Cache for Redis**: Azure Cache for Redis provides a high-performance general purpose distributed cache for frontend and backend services.
* **Cognitive Search**: Configure an Azure Cognitive Search indexer to import content from Cosmos DB and make it searchable.
* **Key Vault**: Use Key Vault for the secure storage of keys, certificates and secrets. 
* **Azure Monitor Application Insights**: Install the Application Insights SDK in all apps to realise a correlated end-to-end transaction view for observability, performance monitoring and trouble-shooting.

## Recommendations

### Front Door

Azure Front Door is a global, scalable entry-point that uses the Microsoft global edge network to create fast, secure, and widely scalable web applications. Front Door is resilient to failures, including failures to an entire Azure region.

Front Door effectively improves availability by simplifying and centralizing operations into one easy to configure service, including certificate management, CDN cache, WAF and WAN acceleration. Front Door offers a convenient front-end HTTP load balancer which operators can use to perform zero-downtime releases and migrations.

* Use [Azure managed certificates][afd-certs] on all frontends to prevent certificate mis-configuration and expiration issues.
* Enable [Caching][afd-cache] on routes where appropriate to improve avaiability by distributing content to the Azure POP (point of presense) edge nodes.
* Deploy Azure Front Door Premium and configure a [WAF policies][afd-waf] with a Microsoft-managed ruleset. Apply the policy to all frontends in Prevention mode to mitigate DDOS attacks that may cause an origin service to become unavailable.

### App Services

[App Service Premium v2, Premium v3][app-services-zr] and [Isolated v3][ise-zr] App Service Plans offer zone redundancy with a minimum of three instances. In this configuration App Service Plan instances are distributed across multiple availability zones to protect from zone failure.

* Deploy a minimum of three instances for zone-redundancy.
* Practice [staging slot deployments][app-service-staging] for zero-downtime releases.
* Enable Virtual Network (VNet) Integration for private networking with backend services.

### Azure Functions

[Azure Functions Elastic Premium SKUs][functions-zr] offer zone redundancy with a minimum of three instances.

* Deploy a minimum of three instances for zone-redundancy.
* Enable Private Endpoint and deny access to public endpoint traffic.
* Enable Virtual Network (VNet) Integration for private networking with backend services.

### SQL Database

Azure SQL DB Azure SQL DB offers zone-redundancy in the [General Purpose][sql-gp-zr], [Premium, and Business Critical tiers][sql-bc-zr]. By selecting a zone-redundant configuration you make your databases more resilient to failures, including catastrophic datacenter outages, with no changes to application logic. With zone redundancy enabled a customer can achieve a recovery point objective (RPO) and a recovery time objective (RTO) for zone failure of zero. Data and log files are synchronously copied across three physically isolated Azure availability zones. The availability of the database engine is orchestrated by a Service Fabric cluster (General Purpose) or an Always-on Availability Group (Premium and Business Critical).

* Deploy Azure SQL DB General Purpose, Premium, or Business Critical with zone-redundancy enabled.
* [Configure SQL DB backups][sql-backups-zr] to use ZRS (zone-redundant storage) or GZRS (geo-zone-redundant storage).
* [Create a Private link for Azure SQL DB][sql-pep] and disable the public endpoint.

### Cosmos DB

Enable zone-redundancy in Azure Cosmos DB when selecting a region to associate with your Azure Cosmos account. With Availability Zone (AZ) support, Azure Cosmos DB will ensure replicas are placed across multiple zones within a given region to provide high availability and resiliency to zonal failures. When a Cosmos DB account is deployed using [availability zones][cosmos-ha], an effective RTO and RPO of zero can be achieved in the event of a zone outage.

* Enable zone-redundancy when adding the local read/write region to the Azure Cosmos account.
* [Enable continuous backups][cosmos-backup].
* [Configure private link for the Cosmos account][cosmos-pep]. This will also disable the public endpoint.

### Storage

For Azure Storage, use [Zone-Redundant Storage][zrs] (ZRS). With ZRS storage, Azure replicates your data synchronously across three Azure availability zones in the region. ZRS offers durability for Azure Storage data objects of at least 99.9999999999% (12 9's) over a given year.

* Create a Standard ZRS or Standard GZRS storage account for hosting web assets.
* Create separate storage accounts for web assets, Azure Functions meta-data, and other data, so that the accounts can be managed and configured separately.
* [Enable Static website hosting][storage-spa].

### Service Bus

[Service Bus Premium][servicebus-az] supports Availability Zones, providing fault-isolated locations within the same Azure region. Service Bus manages three copies of messaging store (1 primary and 2 secondary). Service Bus keeps all the three copies in sync for data and management operations. If the primary copy fails, one of the secondary copies is promoted to primary with no perceived downtime.

* Enable zone-redundancy on a new Azure Service Bus Premium namespace.
* [Configure private link][sb-pep] for the Azure Service Bus namespace.
* Specify at least one IP rule or virtual network rule for the namespace to allow traffic only from the specified IP addresses or subnet of a virtual network. This will disable the public endpoint.

### Cache for Redis

Cache for Redis supports [zone-redundancy][redis-zr] in the Premium and Enterprise tiers. A zone-redundant cache can place its nodes across different Azure Availability Zones in the same region. It eliminates datacenter or AZ outage as a single point of failure and increases the overall availability of your cache.

<!-- TODO -->

### Cognitive Search

You can utilize [Availability Zones with Azure Cognitive Search][cog-search-az] by adding two or more replicas to your search service. Each replica will be placed in a different Availability Zone within the region. If you have more replicas than Availability Zones, the replicas will be distributed across Availability Zones as evenly as possible.

<!-- TODO -->

### Key Vault

Key Vault is automatically zone-redundant in any region where Availability zones are available.

<!-- TODO -->

<!-- 
## Considerations

### Performance

XXXX

### Scalability

XXXX

### Availability

Front Door offers a financially backed SLA of 99.99%. The risk of Front Door service downtime can be mitigated with a runbook that changes DNS CNAME records to point to an alternative reverse HTTP Proxy like Azure App Gateway for example.


Multi-zone designs based on Availability zones offer levels of availability and resilience that meet or exceed the business requirements of most customers. However, for customers who want to replicate data to a secondary region for disaster recovery, several options are available including [Object replication for block blobs][object-replication]. Azure data services like Cosmos DB also offer replication of data to other Azure regions with continuous backup to be used in the event of a disaster. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB][cosmos-continuous-backup].

### Manageability

XXXX

### Security

* (Only allow AFD traffic on App Services)
* (VNet Integration on App Services)
* (Private Endpoint / VNet Integration on Premium Functions)
* HTTPS only rule on AFD

### Cost

* (ISE is charged for 9 instances whether you use them or not)

Function Apps should either be hosted in a dedicated App Service Plan (alongside other apps) with zone-redundancy enabled, or as Premium Functions in a zone-redundant Elastic Premium plan.

Azure SQL DB [Premium and Business Critical zone-redundancy][sql-bc-zr] can be enabled with no downtime and at no extra cost (to a locally redundant Premium and Business Critical service). 

(Private endpoints pricing. Private endpoint costs can be reduced by operating services in the public address space)

-->

<!-- links -->

[azs]:https://azure.microsoft.com/global-infrastructure/availability-zones/
[az-ha-services]:https://docs.microsoft.com/azure/availability-zones/az-region#highly-available-services
[zrs]: https://docs.microsoft.com/azure/storage/common/storage-redundancy#zone-redundant-storage
[az-regions]:https://docs.microsoft.com/azure/availability-zones/az-region#azure-regions-with-availability-zones
[az-services]:https://docs.microsoft.com/azure/availability-zones/az-region
[servicebus-az]:https://docs.microsoft.com/azure/service-bus-messaging/service-bus-outages-disasters#availability-zones
[redis-zr]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-high-availability#zone-redundancy
[cog-search-az]:https://docs.microsoft.com/azure/search/search-performance-optimization#availability-zones
[app-services-zr]:https://docs.microsoft.com/azure/app-service/how-to-zone-redundancy
[functions-zr]:https://docs.microsoft.com/azure/azure-functions/azure-functions-az-redundancy
[ise-zr]:https://docs.microsoft.com/azure/app-service/environment/overview-zone-redundancy
[sql-gp-zr]:https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla?view=azuresql&tabs=azure-powershell#general-purpose-service-tier-zone-redundant-availability
[sql-bc-zr]:https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla#premium-and-business-critical-service-tier-zone-redundant-availability
[cosmos-ha]:https://docs.microsoft.com/azure/cosmos-db/high-availability
[waf]:https://docs.microsoft.com/azure/architecture/framework/
[object-replication]:https://docs.microsoft.com/azure/storage/blobs/object-replication-overview
[cosmos-continuous-backup]:https://docs.microsoft.com/azure/cosmos-db/continuous-backup-restore-introduction
[afd-certs]:https://docs.microsoft.com/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#azure-managed-certificates
[afd-cache]:https://docs.microsoft.com/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium
[afd-waf]:https://docs.microsoft.com/azure/web-application-firewall/afds/afds-overview
[app-service-staging]:https://docs.microsoft.com/azure/app-service/deploy-staging-slots
[sql-backups-zr]:https://docs.microsoft.com/azure/azure-sql/database/automated-backups-overview?view=azuresql&tabs=single-database#configure-backup-storage-redundancy-by-using-the-azure-cli
[sql-pep]:https://docs.microsoft.com/azure/azure-sql/database/private-endpoint-overview?view=azuresql
[cosmos-backup]:https://docs.microsoft.com/azure/cosmos-db/provision-account-continuous-backup
[cosmos-pep]:https://docs.microsoft.com/azure/cosmos-db/how-to-configure-private-endpoints
[storage-spa]:https://docs.microsoft.com/azure/storage/blobs/storage-blob-static-website
[sb-pep]:https://docs.microsoft.com/azure/service-bus-messaging/private-link-service