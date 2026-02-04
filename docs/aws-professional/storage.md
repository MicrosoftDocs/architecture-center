---
title: Compare Storage Services on Azure and AWS
description: Review storage technology differences between Azure and AWS. Compare Azure Storage with S3, EBS, EFS, and Glacier.
author: splitfinity81
ms.author: yubaijna
ms.date: 11/13/2024
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare storage on Azure and AWS

The audience for this guide is organizations or individuals who are migrating from AWS to Azure or adopting a multicloud strategy. The goal of this guide is to help AWS architects understand the storage capabilities of Azure by comparing Azure services to AWS services.

## S3/EBS/EFS and Azure Storage

On the AWS platform, cloud storage is typically deployed in three ways:

- **Simple Storage Service (S3)**. Basic object storage that makes data available through an API.

- **Elastic Block Store (EBS)**. Block-level storage that's typically intended for access by a single virtual machine (VM). You can attach it to multiple volumes by using specific storage classes and file systems.

- **Shared storage**. Various shared storage services that AWS provides, like Elastic File System (EFS) and the FSx family of managed file systems.

In Azure Storage, subscription-bound [storage accounts](/azure/storage/common/storage-quickstart-create-account) allow you to create and manage the following storage services:

- [Blob storage](/azure/storage/common/storage-quickstart-create-account) stores any type of text or binary data, such as a document, media file, or application installer. You can set Blob storage for private access or share contents publicly to the Internet. Blob storage serves the same purpose as both AWS S3 and EBS.
- [Table storage](/azure/cosmos-db/table-storage-how-to-use-nodejs) stores structured datasets. Table storage is a NoSQL key-attribute data store that allows for rapid development and fast access to large quantities of data. Similar to AWS' SimpleDB and DynamoDB services.

- [Queue storage](/azure/storage/queues/storage-quickstart-queues-nodejs?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli) provides messaging for workflow processing and for communication between components of cloud services.

- [File storage](/azure/storage/files/storage-java-how-to-use-file-storage) provides shared storage for applications. It uses the standard Server Message Block (SMB) or Network File System (NFS) protocol. File storage is used in a way that's similar to how EFS or FSx for Windows File Server are used.

Azure also provides other managed file systems, including Azure Managed Lustre, Azure NetApp Files, and Azure Native Qumulo. For more information, see [Storage comparison](#storage-comparison).

## Glacier and Azure Storage

[Azure Archive Blob Storage](/azure/storage/blobs/access-tiers-overview#archive-access-tier) is comparable to AWS Glacier storage service. It's intended for rarely accessed data that is stored for at least 180 days and can tolerate several hours of retrieval latency.

For data that is infrequently accessed but must be available immediately when accessed, [Azure Cool Blob Storage tier](/azure/storage/blobs/access-tiers-overview#cool-access-tier) provides cheaper storage than standard blob storage. This storage tier is comparable to AWS S3 - Infrequent Access storage service.

## Object storage access control

In AWS, access to S3 is typically granted via either an Identity and Access Management (IAM) role or directly in the S3 bucket policy. Data plane network access is typically controlled via S3 bucket policies.

With Azure Blob Storage, a layered approach is used. The Azure Storage firewall is used to control data plane network access.

In Amazon S3, it's common to use [pre-signed URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html) to give time-limited permission access. In Azure Blob storage, you can achieve a similar result by using a [shared access signature](/azure/storage/common/storage-sas-overview).

## Regional redundancy and replication for object storage

Organizations often want to protect their storage objects by using redundant copies. In both AWS and Azure, data is replicated in a particular region. On Azure, you control how data is replicated by using locally redundant storage (LRS) or zone-redundant storage (ZRS). If you use LRS, copies are stored in the same datacenter for cost or compliance reasons. ZRS is similar to AWS replication: it replicates data across availability zones within a region.

AWS customers often replicate their S3 buckets to another region by using cross-region replication. You can implement this type of replication in Azure by using Azure blob replication. Another option is to configure geo-redundant storage (GRS) or geo-zone-redundant storage (GZRS). GRS and GZRS synchronously replicate data to a secondary region without requiring a replication configuration. The data isn't accessible unless a planned or unplanned failover occurs.

## Comparing block storage choices

Both platforms provide different types of disks to meet particular performance needs. Although the performance characteristics don't match exactly, the following table provides a generalized comparison. You should always perform testing to determine which storage configurations best suit your application. For higher-performing disks, on both AWS and Azure you need to match the storage performance of the VM with the provisioned disk type and configuration.

| AWS EBS volume type | Azure Managed disk | Use | Can this managed disk be used as an OS Disk |
| ----------- | ------------- | ----------- | ----------- |
| gp2/gp3 |  Standard SSD | Web servers and lightly used application servers or dev/test environments | Yes |
| gp2 |  Premium SSD | Production and performance-sensitive workloads | Yes |
| gp3 |  Premium SSD v2 | Performance-sensitive workloads or workloads that require high IOPS and low latency | No |
| io2 |  Ultra Disk Storage | IO-intensive workloads, performance-demanding databases, and high-transaction workloads that require high throughput and IOPS | No |

On Azure, you can configure many VM types for host caching. When host caching is enabled, cache storage is made available to the VM and can be configured for read-only or read/write mode. For some workloads, the cache can improve storage performance.

## Storage comparison

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
| [Elastic File System](https://aws.amazon.com/efs/) | [Files](https://azure.microsoft.com/services/storage/files/) | Provides a basic interface for creating and configuring file systems quickly and sharing common files. Supports NFS protocol for connectivity. |
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

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) |
Director, Partner Technology Strategist

Other contributor:

- [Yuri Baijnath](https://www.linkedin.com/in/yuri-baijnath-za) | Senior CSA Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## See also

- [Microsoft Azure Storage Performance and Scalability Checklist](/azure/storage/common/storage-performance-checklist)
- [Azure Storage security guide](/azure/storage/common/storage-security-guide)
- [Best practices for using content delivery networks (CDNs)](../best-practices/cdn.yml)
