<!-- cSpell:ignore CNAME -->

This reference architecture shows how to run an Azure App Service application in multiple regions to achieve high availability.

There are several general approaches to achieve high availability across regions:

- Active/Passive with hot standby: traffic goes to one region, while the other waits on hot standby. Hot standby means the VMs in the secondary region are allocated and running at all times.

- Active/Passive with cold standby: traffic goes to one region, while the other waits on cold standby. Cold standby means the VMs in the secondary region are not allocated until needed for failover. This approach costs less to run, but will generally take longer to come online during a failure.

- Active/Active: both regions are active, and requests are load balanced between them. If one region becomes unavailable, it is taken out of rotation.

This reference focuses on active/passive with hot standby. It extends the single region design for a scalable web application. See [Improve scalability in a web application][guidance-web-apps-scalability] for information on the base architecture.

### Potential use cases

These use cases can benefit from a multi-region deployment:

- Design a business continuity and disaster recovery plan for LoB applications

- Deploy mission-critical applications running on Windows or Linux

- Improve user experience by keeping applications available

## Architecture

![Diagram showing the reference architecture for a web application with high availability.](./images/multi-region-web-app-diagram.png)

*Download a [Visio file][visio-download] of this architecture.*

This architecture builds on the one shown in [Improve scalability in a web application][guidance-web-apps-scalability]. The main differences are:

- **Primary and secondary regions**. This architecture uses two regions to achieve higher availability. The application is deployed to each region. During normal operations, network traffic is routed to the primary region. If the primary region becomes unavailable, traffic is routed to the secondary region.
- **Front Door**. [Front Door](/azure/frontdoor) routes incoming requests to the primary region. If the application running that region becomes unavailable, Front Door fails over to the secondary region.
- **Geo-replication** of SQL Database and/or Cosmos DB.

A multi-region architecture can provide higher availability than deploying to a single region. If a regional outage affects the primary region, you can use [Front Door](/azure/frontdoor) to fail over to the secondary region. This architecture can also help if an individual subsystem of the application fails.

### Components

Key technologies used to implement this architecture:

- [Azure Active Directory][Azure-Active-Directory]
- [Azure DNS][Azure-DNS]
- [Azure Content Delivery Network][Azure-Content-Delivery-Network]
- [Azure Front Door][Azure-Front-Door]
- [Azure AppService][Azure-AppService]
- [Azure Function][Azure-Function]
- [Azure Storage][Azure-Storage]
- [Azure Redis Cache][Azure-Redis-Cache]
- [Azure SQL Database][Azure-SQL-Database]
- [Azure Cosmos DB][Azure-Cosmos-DB]
- [Azure Search][Azure-Search]

## Recommendations

Your requirements might differ from the architecture described here. Use the recommendations in this section as a starting point.

### Regional pairing

Each Azure region is paired with another region within the same geography. In general, choose regions from the same regional pair (for example, East US 2 and Central US). Benefits of doing so include:

- If there is a broad outage, recovery of at least one region out of every pair is prioritized.
- Planned Azure system updates are rolled out to paired regions sequentially to minimize possible downtime.
- In most cases, regional pairs reside within the same geography to meet data residency requirements.

However, make sure that both regions support all of the Azure services needed for your application. See [Services by region][services-by-region]. For more information about regional pairs, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions][regional-pairs].

### Resource groups

Consider placing the primary region, secondary region, and Traffic Manager into separate [resource groups][resource groups]. This lets you manage the resources deployed to each region as a single collection.

### Front Door configuration

**Routing**. Front Door supports several [routing mechanisms](/azure/frontdoor/front-door-routing-methods#priority-based-traffic-routing). For the scenario described in this article, use *priority* routing. With this setting, Front Door sends all requests to the primary region unless the endpoint for that region becomes unreachable. At that point, it automatically fails over to the secondary region. Set the backend pool with different priority values, 1 for the active region and 2 or higher for the standby or passive region.

**Health probe**. Front Door uses an HTTP (or HTTPS) probe to monitor the availability of each back end. The probe gives Front Door a pass/fail test for failing over to the secondary region. It works by sending a request to a specified URL path. If it gets a non-200 response within a timeout period, the probe fails. You can configure the health probe frequency, number of samples required for evaluation, and the number of successful samples required for the backend to be marked as healthy. If Front Door marks the backend as degraded, it fails over to the other backend. For details, see [Health Probes](/azure/frontdoor/front-door-health-probes).

As a best practice, create a health probe path in your application backend that reports the overall health of the application. This health probe should check critical dependencies such as the App Service apps, storage queue, and SQL Database. Otherwise, the probe might report a healthy backend when critical parts of the application are actually failing. On the other hand, don't use the health probe to check lower priority services. For example, if an email service goes down the application can switch to a second provider or just send emails later. For further discussion of this design pattern, see [Health Endpoint Monitoring Pattern](/azure/architecture/patterns/health-endpoint-monitoring).

### SQL Database

Use [Active Geo-Replication][sql-replication] to create a readable secondary replica in a different region. You can have up to four readable secondary replicas. Fail over to a secondary database if your primary database fails or needs to be taken offline. Active Geo-Replication can be configured for any database in any elastic database pool.

### Cosmos DB

Cosmos DB supports geo-replication across regions in active-active pattern with multiple write regions. Alternatively, you can designate one region as the writable region and the others as read-only replicas. If there is a regional outage, you can fail over by selecting another region to be the write region. The client SDK automatically sends write requests to the current write region, so you don't need to update the client configuration after a failover. For more information, see [Global data distribution with Azure Cosmos DB][cosmosdb-geo].

> [!NOTE]
> All of the replicas belong to the same resource group.
>

### Storage

For Azure Storage, use [read-access geo-redundant storage][ra-grs] (RA-GRS). With RA-GRS storage, the data is replicated to a secondary region. You have read-only access to the data in the secondary region through a separate endpoint. If there is a regional outage or disaster, the Azure Storage team might decide to perform a geo-failover to the secondary region. There is no customer action required for this failover.

For Queue storage, create a backup queue in the secondary region. During failover, the app can use the backup queue until the primary region becomes available again. That way, the application can still process new requests.

## Availability considerations

Consider these points when designing for high availability across regions.

### Azure Front Door

Azure Front Door automatically fails over if the primary region becomes unavailable. When Front Door fails over, there is a period of time (usually about 20-60 seconds) when clients cannot reach the application. The duration is affected by the following factors:

- **Frequency of health probes**. The more frequent the health probes are sent, the faster Front Door can detect downtime or the backend coming back healthy.
- **Sample size configuration**. This configuration controls how many samples are required for the health probe to detect that the primary backend has become unreachable. If this value is too low, you could get false positives from intermittent issues.

Front Door is a possible failure point in the system. If the service fails, clients cannot access your application during the downtime. Review the [Front Door service level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/frontdoor) and determine whether using Front Door alone meets your business requirements for high availability. If not, consider adding another traffic management solution as a fallback. If the Front Door service fails, change your canonical name (CNAME) records in DNS to point to the other traffic management service. This step must be performed manually, and your application will be unavailable until the DNS changes are propagated.

<!-- markdownlint-disable MD024 -->

### SQL Database

The recovery point objective (RPO) and estimated recovery time (ERT) for SQL Database are documented in [Overview of business continuity with Azure SQL Database][sql-rpo].

### Cosmos DB

RPO and recovery time objective (RTO) for Cosmos DB are configurable via the consistency levels used, which provide trade-offs between availability, data durability, and throughput. Cosmos DB provides a minimum RTO of 0 for a relaxed consistency level with multi-master or an RPO of 0 for strong consistency with single-master. To learn more about Cosmos DB consistency levels, see [Consistency levels and data durability in Cosmos DB](/azure/cosmos-db/consistency-levels-tradeoffs#rto).

### Storage

RA-GRS storage provides durable storage, but it's important to understand what can happen during an outage:

- If a storage outage occurs, there will be a period of time when you don't have write-access to the data. You can still read from the secondary endpoint during the outage.
- If a regional outage or disaster affects the primary location and the data there cannot be recovered, the Azure Storage team may decide to perform a geo-failover to the secondary region.
- Data replication to the secondary region is performed asynchronously. Therefore, if a geo-failover is performed, some data loss is possible if the data can't be recovered from the primary region.
- Transient failures, such as a network outage, will not trigger a storage failover. Design your application to be resilient to transient failures. Mitigation options include:

  - Read from the secondary region.
  - Temporarily switch to another storage account for new write operations (for example, to queue messages).
  - Copy data from the secondary region to another storage account.
  - Provide reduced functionality until the system fails back.

For more information, see [What to do if an Azure Storage outage occurs][storage-outage].

## Cost considerations

Use the [pricing calculator][pricing-calculator] to estimate costs. These recommendations in this section may help you to reduce cost.

### Azure Front Door

Azure Front Door billing has three pricing tiers: outbound data transfers, inbound data transfers, and routing rules. For more info See [Azure Front Door Pricing][AFD-pricing]. The pricing chart does not include the cost of accessing data from the backend services and transferring to Front Door. Those costs are billed based on data transfer charges, described in [Bandwidth Pricing Details][bandwidth-pricing].

### Azure Cosmos DB

There are two factors that determine Azure Cosmos DB pricing:

- The provisioned throughput or [Request Units per second (RU/s)](/azure/cosmos-db/request-units).

    There are two types of throughput that can be provisioned in Cosmos DB, standard and autoscale. Standard throughput allocates the resources required to guarantee the RU/s that you specify. For autoscale, you provision the maximum throughput, and Cosmos DB instantly scales up or down depending on the load, with a minimum of 10% of the maximum autoscale throughput. Standard throughput is billed for the throughput provisioned hourly. Autoscale throughput is billed for the maximum throughput consumed hourly.

- Consumed storage. You are billed a flat rate for the total amount of storage (GBs) consumed for data and the indexes for a given hour.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework](../../framework/cost/overview.md).

## Manageability considerations

If the primary database fails, perform a manual failover to the secondary database. See [Restore an Azure SQL Database or failover to a secondary][sql-failover]. The secondary database remains read-only until you fail over.

## DevOps considerations

This architecture follows the multi region deployment recommendation, described in the [DevOps section of the Azure Well Architected Framework][AAF-devops-deployment-multi-region].

This architecture builds on the one shown in [Improve scalability in a web application][guidance-web-apps-scalability], see [DevOps considerations section][guidance-web-apps-scalability-devops].

## Next steps

- Deep dive on [Azure Front Door - traffic routing methods][front-door-routing]

- Create health probes that report the overall health of the application based on [endpoint monitoring patterns][endpoint-monitoring]

- Enable [Azure SQL auto-failover groups][sql-failover]

## Related resources

- [Multi-region N-tier application](../n-tier/multi-region-sql-server.yml) is a similar scenario. It shows an N-tier application running in multiple Azure regions

- [Design principles for Azure Application][Design-principles-for-Azure-Application] summarize design principles for Azure applications

- [Ensure business continuity & disaster recovery using Azure Paired Regions](/azure/best-practices-availability-paired-regions)


<!-- links -->

[AFD-pricing]: https://azure.microsoft.com/pricing/details/frontdoor
[AAF-devops-deployment-multi-region]: ../../framework/devops/release-engineering-cd.md#consider-deploying-across-multiple-regions
[bandwidth-pricing]: https://azure.microsoft.com/pricing/details/bandwidth
[cosmosdb-geo]: /azure/cosmos-db/distribute-data-globally
[guidance-web-apps-scalability]: ./scalable-web-app.yml
[guidance-web-apps-scalability-devops]: ./scalable-web-app.yml#devops-considerations
[pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[ra-grs]: /azure/storage/common/storage-designing-ha-apps-with-ragrs
[regional-pairs]: /azure/best-practices-availability-paired-regions
[resource groups]: /azure/azure-resource-manager/resource-group-overview#resource-groups
[services-by-region]: https://azure.microsoft.com/regions/#services
[sql-failover]: /azure/sql-database/sql-database-disaster-recovery
[sql-replication]: /azure/sql-database/sql-database-geo-replication-overview
[sql-rpo]: /azure/sql-database/sql-database-business-continuity#sql-database-features-that-you-can-use-to-provide-business-continuity
[storage-outage]: /azure/storage/storage-disaster-recovery-guidance
[visio-download]: https://arch-center.azureedge.net/app-service-reference-architectures.vsdx
[Azure-Active-Directory]: https://azure.microsoft.com/services/active-directory/
[Azure-DNS]: https://azure.microsoft.com/services/dns/#overview
[Azure-Content-Delivery-Network]: https://azure.microsoft.com/services/cdn/#overview
[Azure-Front-Door]: https://azure.microsoft.com/services/frontdoor/#overview
[Azure-AppService]: https://azure.microsoft.com/services/app-service/#overview 
[Azure-Function]: https://azure.microsoft.com/services/functions/#overview
[Azure-Storage]: https://azure.microsoft.com/product-categories/storage/
[Azure-Redis-Cache]: https://azure.microsoft.com/services/cache/#overview
[Azure-SQL-Database]: https://azure.microsoft.com/products/azure-sql/database/#overview
[Azure-Cosmos-DB]: https://azure.microsoft.com/services/cosmos-db/#overview
[Azure-Search]: https://azure.microsoft.com/services/search/#overview
[front-door-routing]: /azure/frontdoor/front-door-routing-methods
[endpoint-monitoring]: /azure/architecture/patterns/health-endpoint-monitoring
[Design-principles-for-Azure-Application]: /azure/architecture/guide/design-principles
