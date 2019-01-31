---
title: Recover from data corruption or accidental deletion
description: Understanding how to recover from data corruption of data or accidental data deletion to and designing resilient, highly available, fault tolerant applications as well as planning for disaster recovery.
author: MikeWasson
ms.date: 11/11/2018
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: resiliency
---

# Recover from data corruption or accidental deletion

Part of a robust business continuity plan is having a plan if your data gets corrupted or accidentally deleted. The following is information about recovery after data has been corrupted or accidentally deleted, due to application errors or operator error.

## Virtual Machines

To protect Azure Virtual Machines (VMs) from application errors or accidental deletion, use [Azure Backup](/azure/backup/). Azure Backup enables the creation of backups that are consistent across multiple VM disks. In addition, the Backup Vault can be replicated across regions to provide recovery from region loss.

## Storage

Azure Storage provides data resiliency through automated replicas. However, this does not prevent application code or users from corrupting data, whether accidentally or maliciously. Maintaining data fidelity in the face of application or user error requires more advanced techniques, such as copying the data to a secondary storage location with an audit log.

- **Block blobs**. Create a point-in-time snapshot of each block blob. For more information, see [Creating a Snapshot of a Blob](/rest/api/storageservices/creating-a-snapshot-of-a-blob). For each snapshot, you are only charged for the storage required to store the differences within the blob since the last snapshot state. The snapshots are dependent on the existence of the original blob they are based on, so a copy operation to another blob or even another storage account is advisable. This ensures that backup data is properly protected against accidental deletion. You can use [AzCopy](/azure/storage/common/storage-use-azcopy) or [Azure PowerShell](/azure/storage/common/storage-powershell-guide-full) to copy the blobs to another storage account.

- **Files**. Use [share snapshots](/azure/storage/files/storage-snapshots-files), or use AzCopy or PowerShell to copy your files to another storage account.

- **Tables**. Use AzCopy to export the table data into another storage account in another region.

## Database

### Azure SQL Database

SQL Database automatically performs a combination of full database backups weekly, differential database backups hourly, and transaction log backups every five - ten minutes to protect your business from data loss. Use point-in-time restore to restore a database to an earlier time. For more information, see:

- [Recover an Azure SQL database using automated database backups](/azure/sql-database/sql-database-recovery-using-backups)

- [Overview of business continuity with Azure SQL Database](/azure/sql-database/sql-database-business-continuity)

### SQL Server on VMs

For SQL Server running on VMs, there are two options: traditional backups and log shipping. Traditional backups enables you to restore to a specific point in time, but the recovery process is slow. Restoring traditional backups requires starting with an initial full backup, and then applying any backups taken after that. The second option is to configure a log shipping session to delay the restore of log backups (for example, by two hours). This provides a window to recover from errors made on the primary.

### Azure Cosmos DB

Azure Cosmos DB automatically takes backups at regular intervals. Backups are stored separately in another storage service, and those backups are globally replicated for resiliency against regional disasters. If you accidentally delete your database or collection, you can file a support ticket or call Azure support to restore the data from the last automatic backup. For more information, see [Automatic online backup and restore with Azure Cosmos DB](/azure/cosmos-db/online-backup-and-restore).

### Azure Database for MySQL, Azure Database for PostgreSQL

When using Azure Database for MySQL or Azure Database for PostgreSQL, the database service automatically makes a backup of the service every five minutes. Using this automatic backup feature you may restore the server and all its databases into a new server to an earlier point-in-time. For more information, see:

- [How to back up and restore a server in Azure Database for MySQL by using the Azure portal](/azure/mysql/howto-restore-server-portal)

- [How to backup and restore a server in Azure Database for PostgreSQL using the Azure portal](/azure/postgresql/howto-restore-server-portal)
