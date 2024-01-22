---
title: Compare AWS and Azure storage services
description: Review storage technology differences between Azure and AWS. Compare Azure Storage with S3, EBS, EFS, and Glacier.
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
categories:
  - storage
products:
  - azure-blob-storage
  - azure-storage
---

# Compare storage on Azure and AWS

## S3/EBS/EFS and Azure Storage

In the AWS platform, cloud storage is primarily broken down into three services:

- **Simple Storage Service (S3)**. Basic object storage that makes data available through an Internet accessible API.

- **Elastic Block Storage (EBS)**. Block level storage intended for access by a single VM.

- **Elastic File System (EFS)**. File storage meant for use as shared storage for up to thousands of EC2 instances.

In Azure Storage, subscription-bound [storage accounts](/azure/storage/common/storage-quickstart-create-account) allow you to create and manage the following storage services:

- [Blob storage](/azure/storage/common/storage-quickstart-create-account) stores any type of text or binary data, such as a document, media file, or application installer. You can set Blob storage for private access or share contents publicly to the Internet. Blob storage serves the same purpose as both AWS S3 and EBS.
- [Table storage](/azure/cosmos-db/table-storage-how-to-use-nodejs) stores structured datasets. Table storage is a NoSQL key-attribute data store that allows for rapid development and fast access to large quantities of data. Similar to AWS' SimpleDB and DynamoDB services.

- [Queue storage](/azure/storage/queues/storage-quickstart-queues-nodejs?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli) provides messaging for workflow processing and for communication between components of cloud services.

- [File storage](/azure/storage/files/storage-java-how-to-use-file-storage) offers shared storage for legacy applications using the standard server message block (SMB) protocol. File storage is used in a similar manner to EFS in the AWS platform.

## Glacier and Azure Storage

[Azure Archive Blob Storage](/azure/storage/blobs/access-tiers-overview#archive-access-tier) is comparable to AWS Glacier storage service. It is intended for rarely accessed data that is stored for at least 180 days and can tolerate several hours of retrieval latency.

For data that is infrequently accessed but must be available immediately when accessed, [Azure Cool Blob Storage tier](/azure/storage/blobs/access-tiers-overview#cool-access-tier) provides cheaper storage than standard blob storage. This storage tier is comparable to AWS S3 - Infrequent Access storage service.

## Storage comparison

[!INCLUDE [Storage components](../../includes/aws/storage.md)]

## See also

- [Microsoft Azure Storage Performance and Scalability Checklist](/azure/storage/common/storage-performance-checklist)

- [Azure Storage security guide](/azure/storage/common/storage-security-guide)

- [Best practices for using content delivery networks (CDNs)](../best-practices/cdn.yml)
