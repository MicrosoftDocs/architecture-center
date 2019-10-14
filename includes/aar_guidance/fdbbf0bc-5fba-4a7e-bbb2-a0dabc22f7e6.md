---
ms.author: dastanfo
author: david-stanford
ms.date: 10/14/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.uid: fdbbf0bc-5fba-4a7e-bbb2-a0dabc22f7e6
ms.assessment_question: You understand what to do when data is corrupted or deleted
---
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

To protect your business from data loss, SQL Database automatically performs a combination of full database backups weekly, differential database backups hourly, and transaction log backups every 5 to 10 minutes. For the Basic, Standard, and Premium SQL Database tiers, use point-in-time restore to restore a database to an earlier time. See the following articles for more information:

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
