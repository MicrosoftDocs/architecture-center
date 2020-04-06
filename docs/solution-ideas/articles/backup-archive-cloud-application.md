---
title: Back up cloud applications and data to cloud
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Back up data and applications running in Azure to another Azure location by using Azure Backup or a partner solution.
ms.custom: acom-architecture, bcdr, 'https://azure.microsoft.com/solutions/architecture/backup-archive-cloud-application/'
ms.service: architecture-center
ms.category:
  - management-and-governance
  - hybrid
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/backup-archive-cloud-application.png
---

# Back up cloud applications and data to cloud

[!INCLUDE [header_file](../header.md)]

Back up data and applications running in Azure to another Azure location by using Azure Backup or a partner solution.

This solution is built on the Azure managed services: [Azure Backup](https://azure.microsoft.com/services/backup) and [Blob Storage](https://azure.microsoft.com/services/storage/blobs). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/backup-archive-cloud-application.png)
*Download an [SVG](../media/backup-archive-cloud-application.svg) of this architecture.*

## Components

* [Azure Backup](https://azure.microsoft.com/services/backup) service runs on the cloud and holds the recovery points, enforces policies, and enables you to manage data and application protection. You don't need to create or manage an Azure Blob storage account when using [Azure Backup](https://azure.microsoft.com/services/backup).
* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): Blob storage that partner solutions such as Commvault connect to for backing up data and applications. You need to create and manage Azure Blob storage when using partner solutions.

## Next steps

* [Back up files and folders using Azure Backup](/api/Redirect/documentation/articles/backup-try-azure-backup-in-10-mins)
* [Store backed up files in Blob storage](/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs)
