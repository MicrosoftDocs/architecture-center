[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Back up data and applications from an on-premises system to Azure using Azure Backup or a partner solution. An internet connection to Azure is used to connect to Azure Backup or to Azure Blob storage. Azure Backup Server can write backups directly to Azure Backup. Alternatively, a partner solution such as Commvault Simpana or Veeam Availability Suite, hosted on-premises, can write backups to Blob storage directly or via a cloud endpoint such as Veeam Cloud Connect.

This solution is built on the Azure managed services: [Backup Server](https://azure.microsoft.com/services/backup), [Azure Backup](https://azure.microsoft.com/services/backup), and [Blob Storage](https://azure.microsoft.com/services/storage/blobs). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/backup-archive-cloud-application.png)
*Download an [SVG](../media/backup-archive-cloud-application.svg) of this architecture.*

### Components

* Azure [Backup Server](https://azure.microsoft.com/services/backup) orchestrates the backup of machines and manages the configuration of the restore procedures. It also has two days of backup data for operational recovery.
* [Azure Backup](https://azure.microsoft.com/services/backup) service runs on the cloud and holds the recovery points, enforces policies, and enables you to manage data and application protection. You don't need to create or manage an Azure Blob storage account when using [Azure Backup](https://azure.microsoft.com/services/backup).
* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): Blob storage that partner solutions such as Commvault connect to for backing up data and applications. You must create and manage Azure Blob storage when using partner solutions.

## Next steps

* [Back up workloads using Azure Backup Server](/azure/backup/backup-azure-microsoft-azure-backup)
* [Back up files and folders using Azure Backup](/azure/backup/backup-configure-vault)
* [Store backed up files in Blob storage](/azure/storage/blobs/storage-quickstart-blobs-dotnet)
