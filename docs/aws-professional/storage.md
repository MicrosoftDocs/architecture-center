---
title: Compare storage services on Azure and AWS
description: Review storage technology differences between Azure and AWS. Compare Azure Storage with S3, EBS, EFS, and Glacier.
author: splitfinity-zz-zz
ms.author: yubaijna, adamcerini
ms.date: 9/23/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
categories:
  - storage
products:
  - azure-storage
---

# Compare storage on Azure and AWS

The audience for this guide are organizations or individuals who are migrating from AWS to Azure or adopting a multi-cloud strategy. This guide aims to help AWS architects understand the storage capabilities of Azure by comparing to familiar services on AWS.  

## S3/EBS/EFS and Azure Storage

In the AWS platform, cloud storage is typically deployed in three ways:

- **Simple Storage Service (S3)**: Basic object storage that makes data available through an API.

- **Elastic Block Storage (EBS)**: Block level storage typically intended for access by a single VM. It is possible to to attach to multiple volumes using specific storage classes and file systems.

- **Shared Storage**: AWS offers various shared storage services such as EFS and the FSX family of managed file systems.

In Azure Storage, subscription-bound [storage accounts](/azure/storage/common/storage-quickstart-create-account) allow you to create and manage the following storage services:

- [Blob storage](/azure/storage/common/storage-quickstart-create-account) stores any type of text or binary data, such as a document, media file, or application installer. You can set Blob storage for private access or share contents publicly to the Internet. Blob storage serves the same purpose as both AWS S3 and EBS.
- [Table storage](/azure/cosmos-db/table-storage-how-to-use-nodejs) stores structured datasets. Table storage is a NoSQL key-attribute data store that allows for rapid development and fast access to large quantities of data. Similar to AWS' SimpleDB and DynamoDB services.

- [Queue storage](/azure/storage/queues/storage-quickstart-queues-nodejs?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli) provides messaging for workflow processing and for communication between components of cloud services.

- [File storage](/azure/storage/files/storage-java-how-to-use-file-storage) offers shared storage for applications using the standard Server Message Block (SMB) or Network File System (NFS)protocol. File storage is used in a similar manner to EFS or FSX for Windows File Server.

Azure also offers additional managed file systems including Azure Managed Lustre, Azure NetApp Files, and Azure Native Qumulo. See the [storage components](../../includes/aws/storage.md) page for a more direct compairon.

## Glacier and Azure Storage

[Azure Archive Blob Storage](/azure/storage/blobs/access-tiers-overview#archive-access-tier) is comparable to AWS Glacier storage service. It is intended for rarely accessed data that is stored for at least 180 days and can tolerate several hours of retrieval latency.

For data that is infrequently accessed but must be available immediately when accessed, [Azure Cool Blob Storage tier](/azure/storage/blobs/access-tiers-overview#cool-access-tier) provides cheaper storage than standard blob storage. This storage tier is comparable to AWS S3 - Infrequent Access storage service.

## Object Storage Access Control

In AWS access to S3 is typically granted via either an IAM role or directly in the S3 Bucket Policy. Data plane network access is typically controlled using S3 Bucket policies.

When using Azure blob storage there is a layered approach. Azure storage firewall is used to control data plane network access.

Using [pre-signed URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html) to give time-bound permission limited access is a common technique when using Amazon S3. When using Azure Blob storage, you can achieve a similar result using a [shared access signature](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview).

## Object Storage Regional Redunandacy and Replication

Customers often want to protect their storage objects with rendudant copies. In both AWS and Azure, data is replicated in a particular region. When using Azure, you control how data is replicated using Locally Redundant Storage (LRS) or Zone-redundant storage (ZRS). LRS keeps copies within the same DC for cost or compliance reasons, while ZRS is similar to AWS in that it replicates data across AZs within a region.

AWS customers often replicate their S3 buckets to another region using cross-region replication. This is possible in Azure using Azure blob replication, another options is to configure Geo-redundant storage (GRS) or Geo-Zone-redundant storage (GZRS). GRS and GZRS will synchronously replicate data to a secondary region without requiring a replication configuration. The data is not accessible unless a planned or unplanned failover occurs.

## Comparing block storage choices

Both platforms have different types of disks to meet particular performance needs. While the performance characteristics are not an exact match, a generalized comparison is below. You should always perform testing to determine which storage configurations suit your application best. For higher performing disks, on both AWS and Azure you need to match the storage performance of the VM with the provisioned disk type and configuration. 

| AWS EBS volume type | Azure Managed disk | Description |
| ----------- | ------------- | ----------- |
| gp2/gp3 |  Standard SSD | Web servers and lightly used application servers or dev/test environments |
| gp2/gp3 |  Premium SSD | Production and performance sensitive workloads |
| io1 |  Premium SSD v2 | Performance sensitive workloads or workloads that require high IOPS and low latency |
| io2 |  Ultra Disk | IO-intensive workloads, performance demanding databases, and very high transaction workloads that demand high throughput and IOPS |
| st1/sc1 |  Standard HDD | Non-critical or infrequent access systems. |

On Azure, many VMs also have the option to be configured for host caching. When enabled, the cache storage is made available to the VM and be configured for read-only or read/write mode. For some workloads the cache can improve storage performance.

## Storage comparison


[!INCLUDE [Storage components](../../includes/aws/storage.md)]
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini)

Other contributor:

- [Yuri Baijnath](https://www.linkedin.com/in/yuri-baijnath-za)

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## See also

- [Microsoft Azure Storage Performance and Scalability Checklist](/azure/storage/common/storage-performance-checklist)

- [Azure Storage security guide](/azure/storage/common/storage-security-guide)

- [Best practices for using content delivery networks (CDNs)](../best-practices/cdn.yml)