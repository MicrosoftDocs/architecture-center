---
author: doodlemania2
ms.author: adboegli
ms.topic: include
ms.service: architecture-center
---

### Object storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Simple Storage Services (S3)](https://aws.amazon.com/s3/) | [Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service, for use cases including cloud applications, content distribution, backup, archiving, disaster recovery, and big data analytics. |

### Virtual server disks

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Block Store (EBS)](https://aws.amazon.com/ebs/) | [managed disks](https://azure.microsoft.com/services/storage/disks/) | SSD storage optimized for I/O intensive read/write operations. For use as high-performance Azure virtual machine storage. |

### Shared files

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic File System](https://aws.amazon.com/efs/) | [Files](https://azure.microsoft.com/services/storage/files/) | Provides a simple interface to create and configure file systems quickly, and share common files. Can be used with traditional protocols that access files over a network. |

### Archiving and backup

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [S3 Infrequent Access (IA)](https://aws.amazon.com/s3/storage-classes) | [Storage cool tier](/azure/storage/blobs/access-tiers-overview) | Cool storage is a lower-cost tier for storing data that is infrequently accessed and long-lived. |
| [S3 Glacier](https://aws.amazon.com/s3/storage-classes), Deep Archive | [Storage archive access tier](/azure/storage/blobs/access-tiers-overview) | Archive storage has the lowest storage cost and higher data retrieval costs compared to hot and cool storage. |
| [Backup](https://aws.amazon.com/backup/) | [Backup](https://azure.microsoft.com/services/backup/) | Back up and recover files and folders from the cloud, and provide offsite protection against data loss. |

### Hybrid storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Storage Gateway](https://aws.amazon.com/storagegateway/) | [StorSimple](https://azure.microsoft.com/services/storsimple/) | Integrates on-premises IT environments with cloud storage. Automates data management and storage, plus supports disaster recovery. |
| [DataSync](https://aws.amazon.com/datasync/) | [File Sync](/azure/storage/files/storage-sync-files-planning) | Azure Files can be deployed in two main ways: by directly mounting the serverless Azure file shares or by caching Azure file shares on-premises using Azure File Sync.|

### Bulk data transfer

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Import/Export Disk](https://aws.amazon.com/snowball/disk/details/) | [Import/Export](/azure/storage/common/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. Also offers data protection during transit. |
| [Import/Export Snowball](https://aws.amazon.com/snowball/), [Snowball Edge](https://aws.amazon.com/snowball-edge/), [Snowmobile](https://aws.amazon.com/snowmobile/) | [Data Box](https://azure.microsoft.com/services/storage/databox/) | Petabyte- to exabyte-scale data transport solution that uses secure data storage devices to transfer large amounts of data to and from Azure. |

#### Storage architectures

<ul class="grid">

[!INCLUDE [HIPAA and HITRUST compliant health data AI](../../includes/cards/security-compliance-blueprint-hipaa-hitrust-health-data-ai.md)]
[!INCLUDE [Media Rendering – HPC Solution Architecture](../../includes/cards/azure-batch-rendering.md)]
[!INCLUDE [Medical Data Storage Solutions](../../includes/cards/medical-data-storage.md)]

</ul>

[view all](/azure/architecture/browse/#storage)
