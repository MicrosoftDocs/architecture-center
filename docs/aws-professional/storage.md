---
title: Compare Storage Services on Azure and AWS
description: Review storage technology differences between Azure and AWS. Compare Azure Storage with S3, EBS, EFS, and Glacier.
author: splitfinity-zz-zz
ms.author: adamcerini
ms.date: 11/13/2024
ms.topic: conceptual
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

## Regional redunandacy and replication for object storage

Organizations often want to protect their storage objects by using redundant copies. In both AWS and Azure, data is replicated in a particular region. On Azure, you control how data is replicated by using locally redundant storage (LRS) or zone-redundant storage (ZRS). If you use LRS, copies are stored in the same datacenter for cost or compliance reasons. ZRS is similar to AWS replication: it replicates data across availability zones within a region.

AWS customers often replicate their S3 buckets to another region by using cross-region replication. You can implement this type of replication in Azure by using Azure blob replication. Another option is to configure geo-redundant storage (GRS) or geo-zone-redundant storage (GZRS). GRS and GZRS synchronously replicate data to a secondary region without requiring a replication configuration. The data isn't accessible unless a planned or unplanned failover occurs.

## Comparing block storage choices

Both platforms provide different types of disks to meet particular performance needs. Although the performance characteristics don't match exactly, the following table provides a generalized comparison. You should always perform testing to determine which storage configurations best suit your application. For higher-performing disks, on both AWS and Azure you need to match the storage performance of the VM with the provisioned disk type and configuration.

| AWS EBS volume type | Azure Managed disk | Use | Can this managed disk be used as an OS Disk |
| ----------- | ------------- | ----------- | ----------- |
| gp2/gp3 |  Standard SSD | Web servers and lightly used application servers or dev/test environments | Yes |
| gp2/gp3 |  Premium SSD | Production and performance-sensitive workloads | Yes |
| io1 |  Premium SSD v2 | Performance-sensitive workloads or workloads that require high IOPS and low latency | No |
| io2 |  Ultra Disk Storage | IO-intensive workloads, performance-demanding databases, and very high transaction workloads that demand high throughput and IOPS | No |
| st1/sc1 |  Standard HDD | Infrequently accessed workloads | Yes |

On Azure, you can configure many VM types for host caching. When host caching is enabled, cache storage is made available to the VM and can be configured for read-only or read/write mode. For some workloads, the cache can improve storage performance.

## Storage comparison

[!INCLUDE [Storage components](../../includes/aws/storage.md)]

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
