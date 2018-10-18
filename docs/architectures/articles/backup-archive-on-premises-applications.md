---
title: Back up on-premises applications and data to cloud
description: Back up on-premises applications and data with Azure Backup and Blob storage applications. Read documentation on implementing these archiving solutions today.
author: adamboeglin
ms.date: 10/18/2018
---
# Back up on-premises applications and data to cloud
Back up data and applications from an on-premises system to Azure using Azure Backup or a partner solution. An Internet connection to Azure is used to connect to Azure Backup or Azure Blob storage. Azure Backup Server can write backups directly to Azure Backup. Alternatively, a partner solution such as Commvault Simpana or Veeam Availability Suite, hosted on-premises, can write backups to Blob storage directly or via a cloud endpoint such as Veeam Cloud Connect.
This solution is built on the Azure managed services: Backup Server, Azure Backup and Blob Storage. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/backup-archive-on-premises-applications.svg" alt='architecture diagram' />

## Components
* Azure [Backup Server](http://azure.microsoft.com/services/backup/) orchestrates the backup of machines and manages the configuration of the restore procedures. It also has two days of backup data for operational recovery.
* [Azure Backup](http://azure.microsoft.com/services/backup/) service runs on the cloud and holds the recovery points, enforces policies, and enables you to manage data and application protection. You dont need to create or manage an Azure Blob storage account when using [Azure Backup](http://azure.microsoft.com/services/backup/).
* [Blob Storage](href="http://azure.microsoft.com/services/storage/blobs/): Blob storage that partner solutions such as Commvault connect to for backing up data and applications. You need to create and manage Azure Blob storage when using partner solutions.
* [Commvault](http://azure.microsoft.com/marketplace/partners/commvault/commvault/) Simpana is an example of a partner solution to back up or archive your data and applications to Azure. This runs on a virtual machine on-premises.

## Next Steps
* [Back up workloads using Azure Backup Server](https://docs.microsoft.com/api/Redirect/documentation/articles/backup-azure-microsoft-azure-backup/)
* [Back up files and folders using Azure Backup](https://docs.microsoft.com/api/Redirect/documentation/articles/backup-try-azure-backup-in-10-mins/)
* [Store backed up files in Blob storage](https://docs.microsoft.com/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs/)
* [Commvault Simpana Software Capabilities](https://documentation.commvault.com/commvault/v10/article?p=whats_new/c_commcell_features.htm)