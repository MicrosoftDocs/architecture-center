[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows you how to archive your on-premises data to Azure Blob storage.

## Architecture

![Architecture diagram that demonstrates how to archive on-premises data.](../media/backup-archive-cloud-application.png)
*Download an [SVG](../media/backup-archive-cloud-application.svg) of this architecture.*

### Components

* Azure [StorSimple](https://azure.microsoft.com/services/storsimple) appliance running on-premises that can tier data to Azure Blob storage (both hot and cool tier). [StorSimple](https://azure.microsoft.com/services/storsimple) can be used to archive data from on-premises to Azure.
* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): A cool or archive tier on Azure Blob storage is used to back up data that's less frequently accessed, while a hot tier is used to store data that's frequently accessed.

### Alternatives

For new solutions, you might also consider using [Azure File Sync](/azure/architecture/hybrid/azure-files-private). File Sync is a service that allows you to cache several Azure file shares on an on-premises Windows Server or cloud virtual machine (VM).

## Scenario details

This solution is built on the Azure managed services: [StorSimple](https://azure.microsoft.com/services/storsimple) and [Blob Storage](https://azure.microsoft.com/services/storage/blobs). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

### Potential use cases

Organizations can leverage Azure Blob storage to:

* Store structured and unstructured logs, images, videos, and other file types.
* Create cost effective solutions for petabytes of data.

## Next steps

* [Learning path for StorSimple](/azure/storsimple)
* [Azure Blob Storage: Hot, cool, and Archive storage tiers](/azure/storage/blobs/access-tiers-overview)
