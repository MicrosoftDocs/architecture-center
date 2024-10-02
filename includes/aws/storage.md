---
author: doodlemania2
ms.author: adboegli
ms.topic: include
ms.service: architecture-center
---

### Object storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Simple Storage Services (S3)](https://aws.amazon.com/s3/) | [Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service, for use cases including cloud applications, content distribution, backup, archiving, immutable storage, disaster recovery, and big data analytics. |

### Virtual server disks

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Block Store (EBS)](https://aws.amazon.com/ebs/) | [Managed Disks](https://azure.microsoft.com/services/storage/disks/) | SSD storage optimized for I/O intensive read/write operations. For use as high-performance Azure virtual machine storage. |
| [Amazon FSX for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/) iSCSI or NVMe/TCP LUNs | [Azure SAN](https://azure.microsoft.com/en-us/products/storage/elastic-san/?msockid=20b4ccc8ef0360d20a2dd85cee9a6140) | Providing Storage Area Network capabilities in cloud using industry standard storage protocols. |

### Shared files

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic File System](https://aws.amazon.com/efs/) | [Files](https://azure.microsoft.com/services/storage/files/) | Provides a simple interface to create and configure file systems quickly, and share common files. Supports NFS protocol for connectivity. |
| [Amazon FSX for Windows File Server](https://aws.amazon.com/fsx/windows/) | [Files](https://azure.microsoft.com/services/storage/files/) | Provides a managed SMB file share which can work with Active Directory for access control. Azure Files can also natively integrate with Entra ID. |
| [Amazon FSX for Lustre](https://aws.amazon.com/fsx/lustre/) | [Azure Managed Lustre](https://azure.microsoft.com/en-us/products/managed-lustre/) | Managed Lustre filesystem that integrates with object storage. Primary use cases are HPC, ML, and analytics. |
| [Amazon FSX for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/) | [Azure NetApp Files](https://azure.microsoft.com/en-us/products/netapp/) | Managed NetApp capabilities in the cloud, includes dual protocol high performance file storage. |

### Archiving and backup

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [S3 Infrequent Access (IA)](https://aws.amazon.com/s3/storage-classes) | [Storage cool tier](/azure/storage/blobs/access-tiers-overview) | Cool storage is a lower-cost tier for storing data that is infrequently accessed and long-lived. |
| [S3 Glacier](https://aws.amazon.com/s3/storage-classes), Deep Archive | [Storage cold access tier](/azure/storage/blobs/access-tiers-overview) | Cold storage has lower storage costs and higher access costs. It still retains millisecond access time. |
| [S3 Deep Glacier](https://aws.amazon.com/s3/storage-classes), Deep Archive | [Storage archive access tier](/azure/storage/blobs/access-tiers-overview) | Archive storage has the lowest storage cost and higher data retrieval costs. It can take hours to retrieve data.|
| [Backup](https://aws.amazon.com/backup/) | [Backup](https://azure.microsoft.com/services/backup/) | Back up and recover files, databases, disks and virtual machines. Azure Backup also supports backing up comptatible on-premises Windows systems. |

### Hybrid storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Storage Gateway: S3 File Gateway](https://aws.amazon.com/storagegateway/file/s3/) | [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview), [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | Provides on-premises, locally cached NFS and SMB file shares that are cloud-backed. |
| [AWS Storage Gateway: Tape Gateway](https://aws.amazon.com/storagegateway/vtl/) | *None* | Replaces on-premises physical tapes with on-premises, cloud-backed virtual tapes. |
| [AWS Storage Gateway: Volume Gateway](https://aws.amazon.com/storagegateway/volume/) | *None* | Provides on-premises iSCSI based block storage that is cloud-backed. |
| [DataSync](https://aws.amazon.com/datasync/) | [File Sync](/azure/storage/file-sync/file-sync-introduction) | Azure Files can be deployed in two main ways: by directly mounting the serverless Azure file shares or by caching Azure file shares on-premises using Azure File Sync.|

### Bulk data transfer

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Import/Export Disk](https://aws.amazon.com/snowball/disk/details/) | [Import/Export](/azure/storage/common/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. Also offers data protection during transit. |
| [Snowball Edge](https://aws.amazon.com/snowball-edge/) | [Data Box](https://azure.microsoft.com/services/storage/databox/) | Petabyte- to exabyte-scale data transport solution that uses secure data storage devices to transfer large amounts of data to and from Azure. |

#### Storage architectures

| Architecture | Description |
|----|----|
| [HIPAA and HITRUST-compliant health data AI](/azure/architecture/solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai) | Manage HIPAA and HITRUST-compliant health data and medical records with the highest level of built-in security. |
| [HPC log](/azure/architecture/solution-ideas/articles/azure-batch-rendering) | Optimize the media rendering process with a step-by-step HPC solution architecture from Azure that combines Azure CycleCloud and HPC Cache. |
| [Medical data storage solutions](/azure/architecture/solution-ideas/articles/medical-data-storage) | Store healthcare data effectively and affordably with cloud-based solutions from Azure. Manage medical records with the highest level of built-in security. |

[view all](/azure/architecture/browse/#storage)