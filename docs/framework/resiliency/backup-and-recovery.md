---
title: Backup and disaster recover for Azure applications
description: Overview of disaster recovery approaches in Azure
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you handling DR (Backup & Restore) for this workload? 
---

# Backup and disaster recover for Azure applications

*Disaster recovery* is the process of restoring application functionality in the wake of a catastrophic loss.

Your tolerance for reduced functionality during a disaster is a business decision that varies from one application to the next. It might be acceptable for some applications to be unavailable or to be partially available with reduced functionality or delayed processing for a period of time. For other applications, any reduced functionality is unacceptable.

## Dependent service outage

For each dependent service, you should understand the implications of a service disruption and the way that the application will respond. Many services include features that support resiliency and availability, so evaluating each service independently is likely to improve your disaster recovery plan. For example, Azure Event Hubs supports [failing over](/azure/event-hubs/event-hubs-geo-dr#setup-and-failover-flow) to the secondary namespace.

## Network outage

When parts of the Azure network are inaccessible, you might not be able to access your application or data. In this situation, we recommend designing the disaster recovery strategy to run most applications with reduced functionality.

If reducing functionality isn't an option, the remaining options are application downtime or failover to an alternate region.

In a reduced functionality scenario:

- If your application can't access its data because of an Azure network outage, you might be able to run locally with reduced application functionality by using cached data.
- You might be able to store data in an alternate location until connectivity is restored.

## Manual responses

Although automation is ideal, some strategies for disaster recovery require manual responses.

### Alerts

Monitor your application for warning signs that may require proactive intervention. For example, if Azure SQL Database or Azure Cosmos DB consistently throttles your application, you might need to increase your database capacity or optimize your queries. Even though the application might handle the throttling errors transparently, your telemetry should still raise an alert so that you can follow up.

For service limits and quota thresholds, we recommend configuring alerts on Azure resources metrics and diagnostics logs. When possible, set up alerts on metrics, which are lower latency than diagnostics logs.

Through [Resource Health](/azure/service-health/resource-health-checks-resource-types), Azure provides some built-in health status checks that can help you diagnose Azure service throttling issues.

### Failover

Configure a disaster recovery strategy for each Azure application and its Azure services. Acceptable deployment strategies to support disaster recovery may vary based on the SLAs required for all components of each application.  

Azure provides different features within many Azure services to allow for manual failover, such as [redis cache geo-replicas](/azure/azure-cache-for-redis/cache-how-to-geo-replication), or for automated failover, such as [SQL auto-failover groups](/azure/sql-database/sql-database-auto-failover-group). For example:

- For an application that mainly uses virtual machines, you can use Azure Site Recovery for the web and logic tiers. For more information, see [Azure to Azure disaster recovery architecture](/azure/site-recovery/azure-to-azure-architecture). For SQL Server on VMs, use [SQL Server Always On availability groups](/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-availability-group-dr).
- For an application that uses App Service and Azure SQL Database, you can use a smaller tier App Service plan configured in the secondary region, which autoscales when a failover occurs. Use failover groups for the database tier.

In either scenario, an [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) profile provides for the automated failover across regions. [Load balancers](/azure/load-balancer/load-balancer-overview) or [application gateways](/azure/application-gateway/overview) should be set up in the secondary region to support faster availability on failover.

### Operational readiness testing

Perform an operational readiness test for failover to the secondary region and for failback to the primary region. Many Azure services support manual failover or test failover for disaster recovery drills. Alternatively, you can simulate an outage by shutting down or removing Azure services.

## Data corruption and restoration

If a data store fails, there might be data inconsistencies when it becomes available again, especially if the data was replicated. Understanding the recovery time objective (RTO) and recovery point objective (RPO) of replicated data stores can help you predict the amount of data loss.

To understand whether the cross-regional failover is started manually or by Microsoft, review the Azure service SLAs. For services with no SLAs for cross-regional failover, Microsoft typically decides when to fail over and usually prioritizes recovery of data in the primary region. If data in the primary region is deemed unrecoverable, Microsoft fails over to the secondary region.

### Restoring data from backups

Backups protect you from losing a component of the application because of accidental deletion or data corruption. They preserve a functional version of the component from an earlier time, which you can use to restore it.

Disaster recovery strategies are not a replacement for backups, but regular backups of application data support some disaster recovery scenarios. Your backup storage choices should be based on your disaster recovery strategy.

The frequency of running the backup process determines your RPO. For example, if you perform hourly backups and a disaster occurs two minutes before the backup, you will lose 58 minutes of data. Your disaster recovery plan should include how you will address lost data.

It's common for data in one data store to reference data in another store. For example, consider a SQL Database with a column that links to a blob in Azure Storage. If backups don't happen simultaneously, the database might have a pointer to a blob that wasn't backed up before the failure. The application or the disaster recovery plan must implement processes to handle this inconsistency after a recovery.

> [!NOTE]
> In some scenarios, such as that of VMs backed up using [Azure Backup](/azure/backup/backup-azure-vms-first-look-arm), you can restore only from a backup in the same region. Other Azure services, such as [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-how-to-geo-replication), provide geo-replicated backups, which you can use to restore services across regions.

### Azure Storage and Azure SQL Database

Azure automatically stores Azure Storage and SQL Database data three times within different fault domains in the same region. If you use geo-replication, the data is stored three additional times in a different region. However, if the data is corrupted or deleted in the primary copy (for example, because of user error), the changes replicate to the other copies.

You have two options for managing potential data corruption or deletion:

- **Create a custom backup strategy.** You can store your backups in Azure or on-premises, depending on your business requirements and governance regulations.
- **Use the point-in-time restore option** to recover a SQL Database.

#### Azure Storage recovery

You can develop a custom backup process for Azure Storage or use one of many third-party backup tools.

Azure Storage provides data resiliency through automated replicas, but it doesn't prevent application code or users from corrupting data. Maintaining data fidelity after application or user error requires more advanced techniques, such as copying the data to a secondary storage location with an audit log. You have several options:

- [**Block blobs.**](/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs) Create a point-in-time snapshot of each block blob. For each snapshot, you are charged only for the storage required to store the differences within the blob since the previous snapshot state. The snapshots are dependent on the original blob, so we recommend copying to another blob or even to another storage account. This approach ensures that backup data is protected against accidental deletion. Use [AzCopy](/azure/storage/common/storage-use-azcopy) or [Azure PowerShell](/azure/storage/common/storage-powershell-guide-full) to copy the blobs to another storage account.

    For more information, see [Creating a Snapshot of a Blob](/rest/api/storageservices/creating-a-snapshot-of-a-blob).

- [**Azure Files.**](/azure/storage/files/storage-files-introduction) Use [share snapshots](/azure/storage/files/storage-snapshots-files), AzCopy, or PowerShell to copy your files to another storage account.
- [**Azure Table storage.**](/azure/storage/tables/table-storage-overview) Use AzCopy to export the table data into another storage account in another region.

#### SQL Database recovery

To protect your business from data loss, SQL Database automatically performs a combination of full database backups weekly, differential database backups hourly, and transaction log backups every 5 to 10 minutes. For the Basic, Standard, and Premium SQL Database tiers, use point-in-time restore to restore a database to an earlier time. Review the following articles for more information:

- [Recover an Azure SQL database using automated database backups](/azure/sql-database/sql-database-recovery-using-backups)
- [Overview of business continuity with Azure SQL Database](/azure/sql-database/sql-database-business-continuity)

Another option is to use active geo-replication for SQL Database, which automatically replicates database changes to secondary databases in the same or different Azure region. For more information, see [Creating and using active geo-replication](/azure/sql-database/sql-database-active-geo-replication).

You can also use a more manual approach for backup and restore:

- Use the **DATABASE COPY** command to create a backup copy of the database with transactional consistency.
- Use the Azure SQL Database Import/Export Service, which supports exporting databases to BACPAC files (compressed files containing your database schema and associated data) that are stored in Azure Blob storage. To protect against a region-wide service disruption, copy the BACPAC files to an alternate region.

### SQL Server on VMs

For SQL Server running on VMs, you have two options: traditional backups and log shipping.

- With traditional backups, you can restore to a specific point in time, but the recovery process is slow. Restoring traditional backups requires that you start with an initial full backup and then apply any incremental backups.
- You can configure a log shipping session to delay the restore of log backups. This provides a window to recover from errors made on the primary replica.

### Azure Database for MySQL and Azure Database for PostgreSQL

In Azure Database for MySQL and Azure Database for PostgreSQL, the database service automatically makes a backup every five minutes. You can use these automated backups to restore the server and its databases from an earlier point in time to a new server. For more information, see:

- [How to back up and restore a server in Azure Database for MySQL by using the Azure portal](/azure/mysql/howto-restore-server-portal)
- [How to back up and restore a server in Azure Database for PostgreSQL using the Azure portal](/azure/postgresql/howto-restore-server-portal)

### Azure Cosmos DB

Cosmos DB automatically makes a backup at regular intervals. Backups are stored separately in another storage service and are replicated globally to protect against regional disasters. If you accidentally delete your database or collection, you can file a support ticket or call Azure support to restore the data from the last automatic backup. For more information, see [Online backup and on-demand restore in Azure Cosmos DB](/azure/cosmos-db/online-backup-and-restore).

### Azure Virtual Machines

To protect Azure Virtual Machines from application errors or accidental deletion, use [Azure Backup](/azure/backup/). The created backups are consistent across multiple VM disks. In addition, the Azure Backup vault can be replicated across regions to support recovery from a regional loss.

## Disaster recovery plan

Start by creating a recovery plan. The plan is considered complete after it has been fully tested. Include the people, processes, and applications needed to restore functionality within the service-level agreement (SLA) you've defined for your customers.

Consider the following suggestions when creating and testing your disaster recovery plan:

- In your plan, include the process for contacting support and for escalating issues. This information will help to avoid prolonged downtime as you work out the recovery process for the first time.
- Evaluate the business impact of application failures.
- Choose a cross-region recovery architecture for mission-critical applications.
- Identify a specific owner of the disaster recovery plan, including automation and testing.
- Document the process, especially any manual steps.
- Automate the process as much as possible.
- Establish a backup strategy for all reference and transactional data, and test backup restoration regularly.
- Set up alerts for the stack of the Azure services consumed by your application.
- Train operations staff to execute the plan.
- Perform regular disaster simulations to validate and improve the plan.

If you're using [Azure Site Recovery](/azure/site-recovery/) to replicate virtual machines (VMs), create a fully automated recovery plan to fail over the entire application.

## Backup strategy

Many alternative strategies are available for implementing distributed compute across regions. These must be tailored to the specific business requirements and circumstances of the application. At a high level, the approaches can be divided into the following categories:

- **Redeploy on disaster**: In this approach, the application is redeployed from scratch at the time of disaster. This is appropriate for non-critical applications that don’t require a guaranteed recovery time.

- **Warm Spare (Active/Passive)**: A secondary hosted service is created in an alternate region, and roles are deployed to guarantee minimal capacity; however, the roles don’t receive production traffic. This approach is useful for applications that have not been designed to distribute traffic across regions.

- **Hot Spare (Active/Active)**: The application is designed to receive production load in multiple regions. The cloud services in each region might be configured for higher capacity than required for disaster recovery purposes. Alternatively, the cloud services might scale out as necessary at the time of a disaster and failover. This approach requires substantial investment in application design, but it has significant benefits. These include low and guaranteed recovery time, continuous testing of all recovery locations, and efficient usage of capacity.

A complete discussion of distributed design is outside the scope of this document. For more information, see [Disaster Recovery and High Availability for Azure Applications](https://aka.ms/drtechguide).

## Resource management

You can distribute compute instances across regions by creating a separate cloud service in each target region, and then publishing the deployment package to each cloud service. However, distributing traffic across cloud services in different regions must be implemented by the application developer or with a traffic management service.

Determining the number of spare role instances to deploy in advance for disaster recovery is an important aspect of capacity planning. Having a full-scale secondary deployment ensures that capacity is already available when needed; however, this effectively doubles the cost. A common pattern is to have a small, secondary deployment, just large enough to run critical services. This small secondary deployment is a good idea, both to reserve capacity, and for testing the configuration of the secondary environment.

> [!NOTE]
> The subscription quota is not a capacity guarantee. The quota is simply a credit limit. To guarantee capacity, the required number of roles must be defined in the service model, and the roles must be deployed.

## Failover and failback testing

Test failover and failback to verify that your application's dependent services come back up in a synchronized manner during disaster recovery. Changes to systems and operations may affect failover and failback functions, but the impact may not be detected until the main system fails or becomes overloaded. Test failover capabilities *before* they are required to compensate for a live problem. Also be sure that dependent services fail over and fail back in the correct order.

If you are using [Azure Site Recovery](/azure/site-recovery/) to replicate VMs, run disaster recovery drills periodically by doing test failovers to validate your replication strategy. A test failover does not affect the ongoing VM replication or your production environment. For more information, see [Run a disaster recovery drill to Azure](/azure/site-recovery/site-recovery-test-failover-to-azure).

## Validating backups

Regularly verify that your backup data is what you expect by running a script to validate data integrity, schema, and queries. There's no point having a backup if it's not useful to restore your data sources. Log and report any inconsistencies so the backup service can be repaired.

## Backup Storage

Backups are about protecting data, applications, and systems that are important to the organization. In operations environments, it’s easy to provide backups: pick the workload that needs hyper-availability and back it up. Operations environments are relatively static – in that, the systems and applications used remain relatively consistent, with only the data changing daily.

## Application archives

It’s important to remember, that a DR plan is more than just an ordered restoration from backup and validation process. Applications may require post-restoration configuration due to site changes, or reinstallation may be necessary with restored data imported after.

## Outage retrospectives

No amount of safeguards or preparation can prevent every possible incident, and sometimes simple human error can have significant consequences to a development project. You can't avoid it, but you can learn from it and take steps to minimize the chances of a similar incident in the future. The question is how software organizations can best go about learning from mistakes with agile postmortems.

## Planning for regional failures

Azure is divided physically and logically into units called regions. A region consists of one or more datacenters in close proximity.

Under rare circumstances, it is possible that facilities in an entire region can become inaccessible, for example due to network failures. Or facilities can be lost entirely, for example due to a natural disaster. This section explains the capabilities of Azure for creating applications that are distributed across regions. Such distribution helps to minimize the possibility that a failure in one region could affect other regions.

Review [Recover from loss of an Azure region](/azure/architecture/resiliency/recovery-loss-azure-region) for guidance on specific Azure services.

## Service-specific guidance

The following articles describe disaster recovery for specific Azure services:

| Service                       | Article                                                                                                                                                                                       |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Azure Database for MySQL      | [Overview of business continuity with Azure Database for MySQL](/azure/mysql/concepts-business-continuity)                                                  |
| Azure Database for PostgreSQL | [Overview of business continuity with Azure Database for PostgreSQL](/azure/postgresql/concepts-business-continuity)                                        |
| Azure Cloud Services          | [What to do in the event of an Azure service disruption that impacts Azure Cloud Services](/azure/cloud-services/cloud-services-disaster-recovery-guidance) |
| Cosmos DB                     | [High availability with Azure Cosmos DB](/azure/cosmos-db/high-availability)                                                                                |
| Azure Key Vault               | [Azure Key Vault availability and redundancy](/azure/key-vault/key-vault-disaster-recovery-guidance)                                                        |
| Azure Storage                 | [Disaster recovery and storage account failover (preview) in Azure Storage](/azure/storage/common/storage-disaster-recovery-guidance)                       |
| SQL Database                  | [Restore an Azure SQL Database or failover to a secondary region](/azure/sql-database/sql-database-disaster-recovery)                                       |
| Virtual Machines              | [What to do in the event of an Azure service disruption impacts Azure Cloud](/azure/cloud-services/cloud-services-disaster-recovery-guidance)               |
| Azure Virtual Network         | [Virtual Network – Business Continuity](/azure/virtual-network/virtual-network-disaster-recovery-guidance)                                                  |

## Next steps

- [Recover from data corruption or accidental deletion](./data-management.md)
- [Recover from a region-wide service disruption](../../resiliency/recovery-loss-azure-region.md)