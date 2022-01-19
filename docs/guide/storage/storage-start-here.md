---
title: Storage design
titleSuffix: Azure Architecture Center
description: Get an overview of Azure Storage technologies, guidance offerings, solution ideas, and reference architectures.  
author: EdPrice-MSFT
ms.author: edprice 
ms.date: 01/20/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
- storage
- analytics
- databases
products:
- azure-blob-storage
- azure-files
- azure-queue-storage
- azure-table-storage
- azure-disk-storage
ms.custom: 
- overview
- fcp
--- 

# Storage architecture design

The Azure Storage platform is the Microsoft cloud storage solution for modern data storage scenarios. Core storage services offer a massively scalable object store for data objects, disk storage for Azure virtual machines (VMs), a file system service for the cloud, a messaging store for reliable messaging, and a NoSQL store. 

The Azure Storage platform includes the following data services:

- [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction): A massively scalable object store for text and binary data. Also includes support for big data analytics through Azure Data Lake Storage Gen2.
- [Azure Files](/azure/storage/files/storage-files-introduction): Managed file shares for cloud or on-premises deployments.
- [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction): A messaging store for reliable messaging between application components.
- [Azure Table Storage](/azure/storage/tables/table-storage-overview): A NoSQL store for schemaless storage of structured data.
- [Azure managed disks](/azure/virtual-machines/managed-disks-overview): Block-level storage volumes for Azure VMs.

## Introduction to storage on Azure
If you're new to storage on Azure, the best way to learn more is with [Microsoft Learn](/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive learning for Microsoft products and more. Check out the 
[Store data in Azure](/learn/paths/store-data-in-azure) learning path. 

## Path to production
- Choose the storage approach that best meets your needs and then create an account. For more information, see [Storage account overview](/azure/storage/common/storage-account-overview?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json). 

- Be sure you understand security and reliability. See these articles: 
  - [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)
  - [Use private endpoints - Azure Storage](/azure/storage/common/storage-private-endpoints?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)
  - [Data redundancy - Azure Storage](/azure/storage/common/storage-redundancy?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 
  - [Disaster recovery and storage account failover - Azure Storage](/azure/storage/common/storage-disaster-recovery-guidance?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)

- For information about migrating existing data, see the [Azure Storage migration guide](/azure/storage/common/storage-migration-overview?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json). 

## Best practices
Depending on the storage technology you use, see the following best practices resources:
- [Performance and scalability checklist for Blob Storage](/azure/storage/blobs/storage-performance-checklist?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 
- [Best practices for using Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-best-practices?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 
- [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)
- [Performance and scalability checklist for Queue Storage](/azure/storage/queues/storage-performance-checklist?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)  
- [Azure Storage table design patterns](/azure/storage/tables/table-storage-design-patterns?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

## Blob Storage
See the following guides for information about Blob Storage:
- [Authorize access to blobs using Azure Active Directory](/azure/storage/blobs/authorize-access-azure-active-directory)
- [Security recommendations for Blob Storage](/azure/storage/blobs/security-recommendations)

## Azure Data Lake Storage
See the following guides for information about Data Lake Storage:
- [Best practices for using Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-best-practices?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure Policy Regulatory Compliance controls for Azure Data Lake Storage Gen1](/azure/data-lake-store/security-controls-policy?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Azure Files
See the following guides for information about Azure Files: 
- [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Overview of Azure Files identity-based authentication options for SMB access](/azure/storage/files/storage-files-active-directory-overview?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Disaster recovery and storage account failover](/azure/storage/common/storage-disaster-recovery-guidance?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [About Azure file share backup](/azure/backup/azure-file-share-backup-overview?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Queue Storage
See the following guides for information about Queue Storage: 
- [Authorize access to queues using Azure Active Directory](/azure/storage/queues/authorize-access-azure-active-directory?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Performance and scalability checklist for Queue Storage](/azure/storage/queues/storage-performance-checklist?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Table Storage
See the following guides for information about Table Storage:
- [Authorize access to tables using Azure Active Directory (preview)](/azure/storage/tables/authorize-access-azure-active-directory?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Performance and scalability checklist for Table storage](/azure/storage/tables/storage-performance-checklist?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Design scalable and performant tables](/azure/storage/tables/table-storage-design?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Design for querying](/azure/storage/tables/table-storage-design-for-query?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Azure managed disks
See the following guides for information about Azure managed disks:
- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure premium storage: design for high performance](/azure/virtual-machines/premium-storage-performance?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Scalability and performance targets for VM disks](/azure/virtual-machines/disks-scalability-targets?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Stay current with storage 
Get the [latest updates on Azure Storage products and features](https://azure.microsoft.com/updates/?category=storage).

## Additional resources
To plan for your storage needs, see [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options).

### Example solutions
Here are a few sample implementations of storage on Azure:
- [Using Azure file shares in a hybrid environment](/azure/architecture/hybrid/azure-file-share)
- [Azure files accessed on-premises and secured by AD DS](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication)
- [Enterprise file shares with disaster recovery](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery)
- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services)
- [Optimized storage with logical data classification](/azure/architecture/solution-ideas/articles/optimized-storage-logical-data-classification)
- [Medical data storage solutions](/azure/architecture/solution-ideas/articles/medical-data-storage)
- [HPC media rendering](/azure/architecture/solution-ideas/articles/azure-batch-rendering)

[See more storage examples in the Azure Architecture Center.](/azure/architecture/browse/?azure_categories=analytics%2Cstorage)

### AWS or GCP professionals

These articles provide service mapping and comparison between Azure and other cloud services. They can help you ramp up quickly on Azure.  
- [Compare AWS and Azure Storage services](/azure/architecture/aws-professional/storage)
- [Google Cloud to Azure services comparison - Storage](/azure/architecture/gcp-professional/services#storage)