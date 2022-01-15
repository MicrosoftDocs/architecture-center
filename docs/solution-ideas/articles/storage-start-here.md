---
title: Storage design
titleSuffix: Azure Architecture Center
description: 
author:
ms.author:
ms.date: 01/20/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: reference-architecture
categories:
products:
ms.custom: 
- overview
- fcp
--- 

# Storage architecture design
intro 

diagram? 

## Introduction to storage on Azure
If you're new to storage on Azure, the best place to learn more is with [Microsoft Learn](/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive learning for Microsoft products and more. The **Store Data in Azure** learning path 

[Store data in Azure](/learn/paths/store-data-in-azure)

## Path to production
Choose the storage approach that best meets your needs and then create an account see [Storage account overview - Azure Storage](/azure/storage/common/storage-account-overview?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

Be sure you understand security and reliability. see 
- [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)
- [Use private endpoints - Azure Storage](/azure/storage/common/storage-private-endpoints?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)
- [Data redundancy - Azure Storage](/azure/storage/common/storage-redundancy?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 
- [Disaster recovery and storage account failover - Azure Storage](/azure/storage/common/storage-disaster-recovery-guidance?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)

migrate existing data 
- [Azure Storage migration guide](/azure/storage/common/storage-migration-overview?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

## Best practices
Blob storage ... if you plan to use blob storage, see 
[Performance and scalability checklist for Blob storage - Azure Storage](/azure/storage/blobs/storage-performance-checklist?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

Azure Data Lake Storage Gen2 is a set of capabilities that support high throughput analytic workloads. if your architecture uses... check out the  
- [Best practices for using Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-best-practices?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

Azure Files... Azure Files can be deployed in two main ways...
- [Planning for an Azure Files deployment Docs](/azure/storage/files/storage-files-planning?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json)

Queue Storage... If you use... 
- [Performance and scalability checklist for Queue Storage - Azure Storage](/azure/storage/queues/storage-performance-checklist?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

table... 
- [Azure storage table design patterns](/azure/storage/tables/table-storage-design-patterns?toc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fen-us%2fazure%2farchitecture%2fbread%2ftoc.json) 

## Stay current with storage 
Get the latest updates on Azure storage products and features

https://azure.microsoft.com/en-us/updates/?category=storage 

## Additional resources

### Example solutions

any other subcategories

### AWS or GCP professionals

These articles provide service mapping and comparison between Azure and other cloud services. They can help you ramp up quickly on Azure.  
- [Compare AWS and Azure storage services](/azure/architecture/aws-professional/storage)
- [Google Cloud to Azure services comparison - Storage](/azure/architecture/gcp-professional/services#storage)