---
title: Compare Storage Services on Azure and AWS
description: Review storage technology differences between Azure and AWS. Compare Azure Storage with S3, EBS, EFS, and Glacier.
author: WernerRall147
ms.author: weral
ms.date: 10/05/2026
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare storage on Azure and AWS

This guide is for organizations or individuals who are migrating from Amazon Web Services (AWS) to Azure or adopting a multicloud strategy. The goal of this guide is to help AWS architects understand the storage capabilities of Azure by comparing Azure services to AWS services.

## S3, EBS, EFS, and Azure Storage

On the AWS platform, cloud storage is typically deployed in three ways:

- **Amazon Simple Storage Service (S3)**. Basic object storage that makes data available through an API.

- **Amazon Elastic Block Store (EBS)**. Block-level storage that's typically intended for access by a single virtual machine (VM). You can attach it to multiple volumes by using specific storage classes and file systems.

- **Shared storage**. Various shared storage services that AWS provides, like Amazon Elastic File System (EFS) and the Amazon FSx family of managed file systems.

In Azure Storage, subscription-bound [storage accounts](/azure/storage/common/storage-account-create) allow you to create and manage the following storage services:

- [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) stores any type of text or binary data, such as a document, media file, or application installer. You can set Blob Storage for private access or share content publicly to the internet. Blob Storage is object storage, so it serves the same purpose as AWS S3. The Azure equivalent of EBS is [managed disks](/azure/virtual-machines/managed-disks-overview), which aren't part of a storage account.

- [Azure Table Storage](/azure/storage/tables/table-storage-overview) stores structured datasets. Table Storage is a NoSQL key-attribute data store that allows for rapid development and fast access to large quantities of data. It's similar to the AWS SimpleDB and DynamoDB services.

- [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction) provides messaging for workflow processing and for communication between components of cloud services.

- [Azure Files](/azure/storage/files/storage-files-introduction) provides shared storage for applications. It uses the standard Server Message Block (SMB) or Network File System (NFS) protocol. Use Azure Files in a way that's similar to how you use EFS or FSx for Windows File Server.

Azure also provides other managed file systems, including Azure Managed Lustre, Azure NetApp Files, and Azure Native Qumulo. For more information, see [Storage comparison](#storage-comparison).

## Glacier and Azure Storage

Azure Blob Storage provides three tiers below hot, and the AWS S3 Glacier storage classes map to two of them rather than one.

[Azure archive Blob Storage](/azure/storage/blobs/access-tiers-overview#archive-access-tier) is comparable to S3 Glacier Flexible Retrieval and S3 Glacier Deep Archive. Blob Storage archive is an offline tier, so you must rehydrate a blob before you can read it. Store data there for at least 180 days and expect retrieval latency measured in hours.

The [cold tier](/azure/storage/blobs/access-tiers-overview#online-access-tiers) is comparable to S3 Glacier Instant Retrieval. It's an online tier for rarely accessed data that still needs millisecond retrieval. It has a 90-day minimum retention period.

For data that's infrequently accessed but must be available immediately when accessed, the [cool tier](/azure/storage/blobs/access-tiers-overview#online-access-tiers) provides cheaper storage than the hot tier, with a 30-day minimum retention period. This tier is comparable to S3 Standard-Infrequent Access.

Each tier below the hot tier charges an early deletion fee if you delete or move data before its minimum retention period elapses.

## Object storage access control

In AWS, access to S3 is typically granted via either an Identity and Access Management (IAM) role or directly in the S3 bucket policy. Data plane network access is typically controlled via S3 bucket policies.

With Azure Blob Storage, a layered approach is used. The Azure Storage firewall is used to control data plane network access.

In Amazon S3, it's common to use [presigned URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html) to give time-limited permission access. In Azure Blob Storage, you can achieve a similar result by using a [shared access signature](/azure/storage/common/storage-sas-overview).

## Regional redundancy and replication for object storage

Organizations often protect their storage objects by using redundant copies. In both AWS and Azure, data is replicated in a particular region. On Azure, you control how data is replicated by using locally redundant storage (LRS) or zone-redundant storage (ZRS). If you use LRS, copies are stored in the same datacenter for cost or compliance reasons. ZRS is similar to AWS replication: it replicates data across availability zones within a region.

AWS customers often replicate their S3 buckets to another region by using cross-region replication. You can implement this type of replication in Azure by using Azure blob replication. Another option is to configure geo-redundant storage (GRS) or geo-zone-redundant storage (GZRS). GRS and GZRS synchronously replicate data to a secondary region without requiring a replication configuration. The data can't be accessed unless a planned or unplanned failover occurs.

## Comparing block storage choices

Both platforms provide different types of disks to meet particular performance needs. Although the performance characteristics don't match exactly, the following table provides a generalized comparison. You should always perform testing to determine which storage configurations best suit your application. For higher-performing disks, on both AWS and Azure you need to match the storage performance of the VM with the provisioned disk type and configuration.

| AWS EBS volume type | Azure managed disk | Use for | Can this managed disk be used as an OS disk? |
| ----------- | ------------- | ----------- | ----------- |
| gp2/gp3 |  Standard SSD | Web servers and lightly used application servers or dev/test environments | Yes |
| gp2 |  Premium SSD | Production and performance-sensitive workloads | Yes |
| gp3 |  Premium SSD v2 | Performance-sensitive workloads or workloads that require high IOPS and low latency | No |
| io2 |  Ultra Disk Storage | IO-intensive workloads, performance-demanding databases, and high-transaction workloads that require high throughput and IOPS | No |

On Azure, you can configure many VM types for host caching. When host caching is enabled, cache storage is made available to the VM and can be configured for read-only or read/write mode. For some workloads, the cache can improve storage performance.

For the current capacity, throughput, and IOPS limits of each disk type, see [Azure managed disk types](/azure/virtual-machines/disks-types).

## Storage comparison

### Object storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Simple Storage Service (S3)](https://aws.amazon.com/s3/) | [Blob Storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service for use cases that include cloud applications, content distribution, backup, archive, immutable storage, disaster recovery, and big data analytics. |

### Virtual server disks

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Block Store (EBS)](https://aws.amazon.com/ebs/) | [Managed disks](https://azure.microsoft.com/services/storage/disks/) | SSD storage that's optimized for I/O-intensive read/write operations. For use as high-performance virtual machine storage. |
| [Amazon FSx for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/) iSCSI or NVMe/TCP LUNs | [Azure Elastic SAN](https://azure.microsoft.com/products/storage/elastic-san/?msockid=20b4ccc8ef0360d20a2dd85cee9a6140) |  Storage area network (SAN) capabilities in the cloud. Uses industry-standard storage protocols. |

### Shared files

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic File System (EFS)](https://aws.amazon.com/efs/) | [Azure Files](https://azure.microsoft.com/services/storage/files/) | Provides a basic interface for creating and configuring file systems quickly and sharing common files. Supports NFS protocol for connectivity. |
| [Amazon FSx for Windows File Server](https://aws.amazon.com/fsx/windows/) | [Azure Files](https://azure.microsoft.com/services/storage/files/) | Provides a managed SMB file share that can work with Active Directory for access control. Azure Files can also natively integrate with Microsoft Entra ID. |
| [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/) | [Azure Managed Lustre](https://azure.microsoft.com/products/managed-lustre/) | Provides a managed Lustre file system that integrates with object storage. Primary use cases include HPC, machine learning, and analytics. |
| [Amazon FSx for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/) | [Azure NetApp Files](https://azure.microsoft.com/products/netapp/) | Provides managed NetApp capabilities in the cloud. Includes dual-protocol high-performance file storage. |

### Archiving and backup

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [S3 Standard-Infrequent Access](https://aws.amazon.com/s3/storage-classes/) | [Cool tier](/azure/storage/blobs/access-tiers-overview) | An online tier for infrequently accessed, long-lived data. Minimum retention is 30 days. |
| [S3 Glacier Instant Retrieval](https://aws.amazon.com/s3/storage-classes/) | [Cold tier](/azure/storage/blobs/access-tiers-overview) | An online tier for rarely accessed data that needs millisecond retrieval. Minimum retention is 90 days. |
| [S3 Glacier Flexible Retrieval and S3 Glacier Deep Archive](https://aws.amazon.com/s3/storage-classes/) | [Archive tier](/azure/storage/blobs/access-tiers-overview) | An offline tier with the lowest storage cost and the highest retrieval cost. You must rehydrate a blob before reading it, which takes hours. Minimum retention is 180 days. |
| [Backup](https://aws.amazon.com/backup/) | [Azure Backup](https://azure.microsoft.com/services/backup/) | This option is used to back up and recover files, databases, disks, and virtual machines. Azure Backup also supports backing up compatible on-premises Windows systems. |

### Hybrid storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Storage Gateway: S3 File Gateway](https://aws.amazon.com/storagegateway/file/s3/) | [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview), [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | Provides on-premises, locally cached NFS and SMB file shares that are cloud-backed. |
| [AWS Storage Gateway: Tape Gateway](https://aws.amazon.com/storagegateway/vtl/) | *None* | Replaces on-premises physical tapes with on-premises, cloud-backed virtual tapes. |
| [AWS Storage Gateway: Volume Gateway](https://aws.amazon.com/storagegateway/volume/) | *None* | Provides on-premises iSCSI-based block storage that's cloud-backed. |
| [AWS DataSync](https://aws.amazon.com/datasync/) | [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | Azure Files can be deployed in two main ways: by directly mounting the serverless Azure file shares or by caching Azure file shares on-premises with Azure File Sync.|

### Bulk data transfer

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Import/Export Disk](https://aws.amazon.com/snowball/) | [Azure Import/Export](/azure/import-export/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. It also offers data protection during transit. In Azure, you create and track Import/Export jobs via Data Box. |
| [AWS Snowball Edge](https://aws.amazon.com/snowball/) | [Azure Data Box](/azure/databox/data-box-overview) | Petabyte-scale to exabyte-scale data transport solution that uses enhanced-security data storage devices to transfer large amounts of data to and from the cloud. |

> [!NOTE]
> Snowball Edge is closed to new customers. AWS directs new customers to [DataSync](https://aws.amazon.com/datasync/) for online transfers and [AWS Data Transfer Terminal](https://aws.amazon.com/data-transfer-terminal/) for physical transfers. The information about Snowball Edge in the preceding table still applies if you're migrating an existing Snow Family workflow. If you're planning a new transfer, compare Data Box and [Azure Storage Mover](/azure/storage-mover/service-overview) against those AWS options instead.

## Migration

If you plan to migrate an AWS workload to Azure, see [Migrate storage from Amazon Web Services to Azure](/azure/migration/migrate-storage-from-aws), which includes specific [example migration scenarios](/azure/migration/migrate-storage-from-aws#migration-scenarios) that might align to your use case.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | Director, Partner Technology Strategist

Other contributor:

- [Yuri Baijnath](https://www.linkedin.com/in/yuri-baijnath-za) | Senior CSA Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Performance checklist for Blob Storage](/azure/storage/blobs/storage-performance-checklist)
- [Security recommendations for Blob Storage](/azure/storage/blobs/security-recommendations)
- [Best practices for using content delivery networks (CDNs)](../best-practices/cdn.yml)
