---
title: Azure SQL Database and operational excellence
description: Focuses on the Azure SQL Database service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Operational Excellence.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-sql-database
categories:
  - data
  - management-and-governance
---

# Azure SQL Database and operational excellence

[Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions without user involvement. Management functions include:

- Upgrades
- Patches
- Backups
- Monitoring

This service allows you to create a highly available and high-performance data storage layer for your Azure applications and workloads. Azure SQL Database provides advanced monitoring and tuning capabilities backed by artificial intelligence to help you troubleshoot and maximize the performance of your databases and solutions.

For more information about how Azure SQL Database promotes operational excellence and enables your business to continue operating during disruptions, reference [Monitoring and performance tuning in Azure SQL Database](/en-us/azure/azure-sql/database/monitor-tune-overview).

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure SQL Database, and operational excellence.

## Design considerations

Azure SQL Database includes the following design considerations:

- Azure SQL Database Business Critical tier configured with geo-replication has a guaranteed Recovery time objective (RTO) of `30` seconds for `100%` of deployed hours.
- Use *sharding* to distribute data and processes across many identically structured databases. Sharding provides an alternative to traditional scale-up approaches for cost and elasticity. Consider using sharding to partition the database horizontally. Sharding can provide fault isolation. For more information, reference [Scaling out with Azure SQL Database](/azure/azure-sql/database/elastic-scale-introduction).
- Azure SQL Database Business Critical or Premium tiers not configured for Zone Redundant Deployments, General Purpose, Standard, or Basic tiers, or Hyperscale tier with two or more replicas have an availability guarantee. For more information, reference [SLA for Azure SQL Database](https://azure.microsoft.com/support/legal/sla/azure-sql-database/v1_6/).
- Provides built-in regional high availability and turnkey geo-replication to any Azure region. It includes intelligence to support self-driving features, such as:
  - Performance tuning
  - Threat monitoring
  - Vulnerability assessments
  - Fully automated patching and updating of the code base

- Define an application performance SLA and monitor it with alerts. Quickly detect when your application performance inadvertently degrades below an acceptable level, which is important to maintain high resiliency. Use the monitoring solution previously defined to set alerts on key query performance metrics so you can take action when the performance breaks the SLA. Go to [Monitor Your Database](/azure/azure-sql/database/monitor-tune-overview) for more information.
- Use geo-restore to recover from a service outage. You can restore a database on any SQL Database server or an instance database on any managed instance in any Azure region from the most recent geo-replicated backups. Geo-restore uses a geo-replicated backup as its source. You can request geo-restore even if the database or datacenter is inaccessible because of an outage. Geo-restore restores a database from a geo-redundant backup. For more information, reference [Recover an Azure SQL database using automated database backups](/azure/azure-sql/database/recovery-using-backups).
- Use the Business Critical tier configured with geo-replication, which has a guaranteed Recovery point objective (RPO) of `5` seconds for `100%` of deployed hours.
- PaaS capabilities built into Azure SQL Database enable you to focus on the domain-specific database administration and optimization activities that are critical for your business.
- Use point-in-time restore to recover from human error. Point-in-time restore returns your database to an earlier point in time to recover data from changes done inadvertently. For more information, read the [Point-in-time restore (PITR)](/azure/azure-sql/database/recovery-using-backups#point-in-time-restore) documentation.
- Business Critical or Premium tiers are configured as Zone Redundant Deployments. For more information about the availability guarantee, reference [SLA for Azure SQL Database](https://azure.microsoft.com/support/legal/sla/azure-sql-database/v1_6/) .

## Checklist

**Have you configured Azure SQL Database with operational excellence in mind?**

> [!div class="checklist"]
> - Use Active Geo-Replication to create a readable secondary in a different region.
> - Use Auto Failover Groups that can include one or multiple databases, typically used by the same application.
> - Use a Zone-Redundant database.
> - Monitor your Azure SQL Database in near-real time to detect reliability incidents.
> - Implement Retry Logic.
> - Back up your keys.

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure SQL Database configuration for operational excellence:

|Recommendation|Description|
|--------------|-----------|
|Use Active Geo-Replication to create a readable secondary in a different region.|If your primary database fails, perform a manual failover to the secondary database. Until you fail over, the secondary database remains read-only. [Active geo-replication](/azure/azure-sql/database/active-geo-replication-overview) enables you to create readable replicas and manually failover to any replica if there is a datacenter outage or application upgrade. Up to four secondaries are supported in the same or different regions, and the secondaries can also be used for read-only access queries. The failover must be initiated manually by the application or the user. After failover, the new primary has a different connection end point.|
|Use Auto Failover Groups that can include one or multiple databases, typically used by the same application.|You can use the readable secondary databases to offload read-only query workloads. Because autofailover groups involve multiple databases, these databases must be configured on the primary server. Autofailover groups support replication of all databases in the group to only one secondary server or instance in a different region. Learn more about [Auto-Failover Groups](/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell) and [DR design](/azure/azure-sql/database/designing-cloud-solutions-for-disaster-recovery).|
|Use a Zone-Redundant database.|By default, the cluster of nodes for the premium availability model is created in the same datacenter. With the introduction of Azure Availability Zones, SQL Database can place different replicas of the Business Critical database to different availability zones in the same region. To eliminate a single point of failure, the control ring is also duplicated across multiple zones as three gateway rings (GW). The routing to a specific gateway ring is controlled by [Azure Traffic Manager (ATM)](/azure/traffic-manager/traffic-manager-overview). Because the zone redundant configuration in the Premium or Business Critical service tiers doesn't create extra database redundancy, you can enable it at no extra cost. Learn more about [Zone-redundant databases](/azure/azure-sql/database/high-availability-sla).|
|Monitor your Azure SQL Database in near-real time to detect reliability incidents.|Use one of the available solutions to monitor SQL DB to detect potential reliability incidents early and make your databases more reliable. Choose a near real-time monitoring solution to quickly react to incidents. Reference [Azure SQL Analytics](/azure/azure-monitor/insights/azure-sql#analyze-data-and-create-alerts) for more information.|
|Implement Retry Logic.|Although Azure SQL Database is resilient when it concerns transitive infrastructure failures, these failures might affect your connectivity. When a transient error occurs while working with SQL Database, make sure your code can retry the call. For more information, reference [how to implement retry logic](/azure/azure-sql/database/troubleshoot-common-connectivity-issues).|
|Back up your keys.|If you're not [using encryption keys in Azure Key Vault to protect your data](/azure/azure-sql/database/always-encrypted-azure-key-vault-configure?tabs=azure-powershell), back up your keys.|

## Next step

> [!div class="nextstepaction"]
> [Azure SQL Managed Instance and reliability](../azure-sql-managed-instance/reliability.md)
