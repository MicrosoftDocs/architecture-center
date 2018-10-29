---
title: Archive on-premises data to cloud
description: Archive your on-premises data to Azure Blob storage.
author: adamboeglin
ms.date: 10/29/2018
---
# Archive on-premises data to cloud
Archive your on-premises data to Azure Blob storage.
This solution is built on the Azure managed services: StorSimple and Blob Storage. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/backup-archive-on-premises.svg" alt='architecture diagram' />

## Components
* [Veeam](https://www.veeam.com/data-center-availability-suite.html) availability suite hosted on-premises running on a virtual machine or physical machine.
* Azure [StorSimple](http://azure.microsoft.com/services/storsimple/) appliance running on-premises that can tier data to Azure Blob storage (both hot and cool tier). [StorSimple](http://azure.microsoft.com/services/storsimple/) can be used to archive data from on-premises to Azure.
* [Veeam](http://azure.microsoft.com/marketplace/partners/veeam/veeam-cloud-connect-enterprise/) Cloud Connect hosted on Azure and running on a virtual machine.
* [Blob Storage](href="http://azure.microsoft.com/services/storage/blobs/): A cool tier on Azure Blob storage is used to back up data thats less frequently accessed, while a hot tier on Azure Blob storage is used to store data thats frequently accessed.

## Next Steps
* [Veeam Availability Suite](https://www.veeam.com/data-center-availability-suite.html)
* [Learning path for StorSimple](https://docs.microsoft.com/azure/storsimple/)
* [Veeam Cloud Connect v9: A Reference Architecture](https://www.veeam.com/wp-cloud-connect-reference-architecture-v9.html)
* [Azure Blob Storage: Hot and cool storage tiers](https://docs.microsoft.com/api/Redirect/documentation/articles/storage-blob-storage-tiers/)