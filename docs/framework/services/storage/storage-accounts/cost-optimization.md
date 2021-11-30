---
title: Storage Accounts and cost optimization
description: Focuses on the Storage Accounts service used in the Storage solution to provide best-practice, configuration recommendations, and design considerations related to Cost optimization.
author: v-stacywray
ms.date: 11/30/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - storage-accounts
categories:
  - storage
  - management-and-governance
---

# Storage Accounts and cost optimization

[Azure Storage Accounts](/azure/storage/common/storage-account-overview?toc=/azure/storage/blobs/toc.json) are ideal for workloads that require fast and consistent response times, or that have a high number of input output (IOP) operations per second. Storage accounts contain all your Azure Storage data objects, which include:

- Blobs
- File shares
- Queues
- Tables
- Disks

Storage accounts provide a unique namespace for your data that's accessible anywhere over `HTTP` or `HTTPS`.

For more information about the different types of storage accounts that support different features, reference [Types of storage accounts](/azure/storage/common/storage-account-overview?toc=/azure/storage/blobs/toc.json#types-of-storage-accounts).

To understand how an Azure storage account can optimize costs for your workload, reference the following articles:

- [Plan and manage costs for Azure Blob Storage](/azure/storage/common/storage-plan-manage-costs)
- [Optimize costs for Blob storage with reserved capacity](/azure/storage/blobs/storage-blob-reserved-capacity)
- [Understand how reservation discounts are applied to Azure storage services](/azure/cost-management-billing/reservations/understand-storage-charges)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure storage accounts and cost optimization.

## Design considerations

Azure storage accounts include the following design considerations:

- Periodically dispose and clean up unused storage resources, such as unattached disks and old snapshots.
- Consider Azure Blob access time tracking and access time-based lifecycle management.
- Transition your data from a hotter access tier to a cooler access tier if there's no access for a period.
- Delete your data if there's no access for an extended period.

|Considerations|Description|
|--------------|-----------|
|Periodically dispose and clean up unused storage resources, such as unattached disks and old snapshots.|Unused storage resources can incur cost and it's a good idea to regularly perform cleanup to reduce cost.
|Consider Azure Blob access time tracking and access time-based lifecycle management.|Minimize your storage cost automatically by setting up a policy based on last access time to: cost-effective backup storage options.|
|Transition your data from a hotter access tier to a cooler access tier if there's no access for a period|For example:<br>- Hot to cool<br>- Cool to archive <br>- Hot to archive|

## Checklist

**Have you configured your Azure Storage Account with cost optimization in mind?**

> [!div class="checklist"]
> - Consider cost savings by reserving data capacity for block blob storage.
> - Organize data into access tiers.
> - Use lifecycle policy to move data between access tiers.

## Configuration recommendations

Consider the following recommendations to optimize costs when configuring your Azure Storage Account:

|Recommendation|Description|
|--------------|-----------|
|Consider cost savings by reserving data capacity for block blob storage.|Save money by reserving capacity for block blob and for Azure Data Lake Storage gen 2 data in standard storage account when customer commits to one or three years reservation.|
|Organize data into access tiers.|You can reduce cost by placing blob data into the most cost-effective access tier. Place frequently accessed data in a hot tier, less frequent in a cold or archive tier. Use Premium storage for workloads with high transaction volumes or workloads where latency is critical.|
|Use lifecycle policy to move data between access tiers.|Lifecycle management policy periodically moves data between tiers. Policies can move data based on rules specified by the user. For example, you can create rules that move blobs to the archive tier if that blob has been modified in 90 days. Unused data can be removed completely using a policy. By creating policies that adjust the access tier of your data, you can design the least expensive storage options for your requirements.|

## Next step

> [!div class="nextstepaction"]
> [Storage Accounts and operational excellence](operational-excellence.md)

