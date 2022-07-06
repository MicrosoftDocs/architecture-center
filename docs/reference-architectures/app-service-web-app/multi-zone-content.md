<!-- cSpell:ignore CNAME -->


This reference architecture shows how to run an Azure App Service application in a zone-redundant configuration to achieve high availability. Zone-redundant services replicate your services and data across Availability Zones to protect from single points of failure.

![Reference architecture for a web application with high availability](./images/multi-zone-web-app-diagram.png)

<!-- *See a [full working sample of this architecture in Azure Samples], including Visio file, Bicep template and Bill of materials.* -->

## Architecture

This architecture builds on the [Availability Zones infrastructure][azs] found in many Azure regions today. For a list of Azure regions that support Availability Zones see [Azure regions with Availability Zones][az-regions].

Availability Zones spread a solution across multiple zones within a region, allowing for an application to continue functioning when one zone fails. Most foundational and mainstream Azure services, and many Specialized Azure services provide support for Availability Zones today. All of the Azure services in this architecture are [zone-redundant], simplifying deployment and management. For a list of Azure services that support Availability Zones see [Azure Services that support Availability Zones][az-services].

Zone-redundant Azure services automatically manage and mitigate failures, including zone failures, within SLA. Zone-redundancy offers an effective RTO and RPO for zone (datacenter) failure of zero.

### Front Door

Azure Front Door is a global, scalable entry-point that uses the Microsoft global edge network to create fast, secure, and widely scalable web applications. Front Door is resilient to failures, including failures to an entire Azure region.

Front Door effectively improves availability by simplifying and centralizing operations into one easy to configure service, including certificate management, CDN cache, WAF and WAN acceleration. Front Door offers a convenient front-end HTTP load balancer which operators can use to perform zero-downtime releases and migrations.

Front Door offers a financially backed SLA of 99.99%. The risk of Front Door service downtime can be mitigated with a runbook that changes DNS CNAME records to point to an alternative reverse HTTP Proxy like Azure App Gateway for example.

### App Services & Functions

[App Service Premium v2, Premium v3][app-services-zr], [Isolated v3][ise-zr] and [Azure Functions Elastic Premium SKUs][functions-zr] can be deployed in a zone-redundant configuration. In this configuration App Service Plan instances are distributed across multiple availability zones to protect from zone failure. A zone-redundancy enabled App Service plan, Isolated App Service Plan, or Elastic Premium plan should be deployed with at least three instances to achieve zone-redundancy. 

Function Apps should either be hosted in a dedicated App Service Plan (alongside other apps) with zone-redundancy enabled, or as Premium Functions in a zone-redundant Elastic Premium plan.

### SQL Database

Azure SQL DB offers zone-redundancy in the General Purpose, Premium, and Business Critical tiers. For example, Azure SQL DB [Premium and Business Critical zone-redundancy][sql-bc-zr] can be enabled with no downtime and at no extra cost (to a locally redundant Premium and Business Critical service). By selecting a zone-redundant configuration you make your databases more resilient to failures, including catastrophic datacenter outages, with no changes to application logic.

Azure SQL Database Premium or Business Critical tiers with zone-redundancy offer an availability guarantee of at least 99.995%. The recovery point objective (RPO) and recovery time objective (RTO) for zone failure is effectively zero. Data and log files are synchronously copied across three physically isolated Azure availability zones. The availability of the database engine is orchestrated by a Service Fabric cluster (General Purpose) or an Always-on Availability Group (Premium and Business Critical).

### Cosmos DB

Enable zone-redundancy in Azure Cosmos DB when selecting a region to associate with your Azure Cosmos account. With Availability Zone (AZ) support, Azure Cosmos DB will ensure replicas are placed across multiple zones within a given region to provide high availability and resiliency to zonal failures with a 99.99% SLA. When a Cosmos DB account is deployed using [availability zones][cosmos-ha], Cosmos DB provides an RTO and RPO of zero in the event of a zone outage.

### Storage

For Azure Storage, use [Zone-Redundant Storage][zrs] (ZRS). With ZRS storage, Azure replicates your data synchronously across three Azure availability zones in the region. ZRS offers durability for Azure Storage data objects of at least 99.9999999999% (12 9's) over a given year.

### Service Bus

The [Service Bus Premium SKU supports Availability Zones][servicebus-az], providing fault-isolated locations within the same Azure region. Service Bus manages three copies of messaging store (1 primary and 2 secondary). Service Bus keeps all the three copies in sync for data and management operations. If the primary copy fails, one of the secondary copies is promoted to primary with no perceived downtime.

### Cache for Redis

Cache for Redis supports [zone-redundancy][redis-zr] in the Premium and Enterprise tiers. A zone-redundant cache can place its nodes across different Azure Availability Zones in the same region. It eliminates datacenter or AZ outage as a single point of failure and increases the overall availability of your cache.

### Cognitive Search

You can utilize [Availability Zones with Azure Cognitive Search][cog-search-az] by adding two or more replicas to your search service. Each replica will be placed in a different Availability Zone within the region. If you have more replicas than Availability Zones, the replicas will be distributed across Availability Zones as evenly as possible.

### Key Vault

Key Vault is automatically zone-redundant in any region where Availability zones are available.

## Disaster recovery

Multi-zone designs based on Availability zones offer levels of availability and resilience that meet or exceed the business requirements of most customers. However, for customers who want to replicate data to a secondary region for disaster recovery, several options are available including [Object replication for block blobs][object-replication]. Azure data services like Cosmos DB also offer replication of data to other Azure regions with continuous backup to be used in the event of a disaster. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB][cosmos-continuous-backup].

> Use the [Azure Well-Architected Framework][waf] to evaluate an Architecture across five pillars: Reliability, Security, Cost optimization, Operation excellence, and Performance efficiency.


<!-- links -->

[azs]:https://azure.microsoft.com/global-infrastructure/availability-zones/
[zrs]: https://docs.microsoft.com/azure/storage/common/storage-redundancy#zone-redundant-storage
[az-regions]:https://docs.microsoft.com/azure/availability-zones/az-region#azure-regions-with-availability-zones
[az-services]:https://docs.microsoft.com/azure/availability-zones/az-region
[servicebus-az]:https://docs.microsoft.com/azure/service-bus-messaging/service-bus-outages-disasters#availability-zones
[redis-zr]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-high-availability#zone-redundancy
[cog-search-az]:https://docs.microsoft.com/azure/search/search-performance-optimization#availability-zones
[app-services-zr]:https://docs.microsoft.com/azure/app-service/how-to-zone-redundancy
[functions-zr]:https://docs.microsoft.com/azure/azure-functions/azure-functions-az-redundancy
[ise-zr]:https://docs.microsoft.com/azure/app-service/environment/overview-zone-redundancy
[sql-bc-zr]:https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla#premium-and-business-critical-service-tier-zone-redundant-availability
[cosmos-ha]:https://docs.microsoft.com/azure/cosmos-db/high-availability
[waf]:https://docs.microsoft.com/azure/architecture/framework/
[object-replication]:https://docs.microsoft.com/azure/storage/blobs/object-replication-overview
[cosmos-continuous-backup]:https://docs.microsoft.com/azure/cosmos-db/continuous-backup-restore-introduction