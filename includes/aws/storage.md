---
author: RobBagby
ms.author: pnp
ms.topic: include
---

### Object storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Simple Storage Services (S3)](https://aws.amazon.com/s3/) | [Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service for use cases that include cloud applications, content distribution, backup, archive, immutable storage, disaster recovery, and big data analytics. |

### Virtual server disks

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Block Store (EBS)](https://aws.amazon.com/ebs/) | [Managed Disks](https://azure.microsoft.com/services/storage/disks/) | SSD storage that's optimized for I/O-intensive read/write operations. For use as high-performance Azure virtual machine storage. |
| [Amazon FSX for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/) iSCSI or NVMe/TCP LUNs | [Azure Elastic SAN](https://azure.microsoft.com/products/storage/elastic-san/?msockid=20b4ccc8ef0360d20a2dd85cee9a6140) |  Storage area network (SAN) capabilities in the cloud. Uses industry-standard storage protocols. |

### Shared files

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic File System](https://aws.amazon.com/efs/) | [Files](https://azure.microsoft.com/services/storage/files/) | Provides a simple interface for creating and configuring file systems quickly and sharing common files. Supports NFS protocol for connectivity. |
| [Amazon FSx for Windows File Server](https://aws.amazon.com/fsx/windows/) | [Files](https://azure.microsoft.com/services/storage/files/) | Provides a managed SMB file share that can work with Active Directory for access control. Azure Files can also natively integrate with Microsoft Entra ID. |
| [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/) | [Azure Managed Lustre](https://azure.microsoft.com/products/managed-lustre/) | Provides a managed Lustre file system that integrates with object storage. Primary use cases include HPC, machine learning, and analytics. |
| [Amazon FSx for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/) | [Azure NetApp Files](https://azure.microsoft.com/products/netapp/) | Provides managed NetApp capabilities in the cloud. Includes dual-protocol high-performance file storage. |

### Archiving and backup

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [S3 Infrequent Access (IA)](https://aws.amazon.com/s3/storage-classes) | [Storage cool tier](/azure/storage/blobs/access-tiers-overview) | Cool storage is a lower-cost tier for storing data that is infrequently accessed and long-lived. |
| [S3 Glacier](https://aws.amazon.com/s3/storage-classes)| [Cold access storage tier](/azure/storage/blobs/access-tiers-overview) | Cold storage has lower storage costs and higher access costs. Access times remain in the milliseconds. |
| [S3 Glacier Deep Archive](https://aws.amazon.com/s3/storage-classes) | [Storage archive access tier](/azure/storage/blobs/access-tiers-overview) | Archive storage has the lowest storage cost and higher data retrieval costs. It can take hours to retrieve data.|
| [Backup](https://aws.amazon.com/backup/) | [Backup](https://azure.microsoft.com/services/backup/) | This option is used to back up and recover files, databases, disks, and virtual machines. Azure Backup also supports backing up compatible on-premises Windows systems. |

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
| [Snowball Edge](https://aws.amazon.com/snowball-edge/) | [Data Box](https://azure.microsoft.com/services/storage/databox/) | Petabyte-scale to exabyte-scale data transport solution that uses enhanced-security data storage devices to transfer large amounts of data to and from Azure. |