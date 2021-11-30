---
title: Storage Accounts and reliability
description: Focuses on the Storage Accounts service used in the Storage solution to provide best-practice, configuration recommendations, and design considerations related to Reliability.
author: v-stacywray
ms.date: 11/29/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - storage-accounts
categories:
  - storage
  - management-and-governance
---

# Storage Accounts and reliability

[Azure Storage Accounts](/azure/storage/common/storage-account-overview?toc=/azure/storage/blobs/toc.json) contain all your Azure Storage data objects, which include:

- Blobs
- File shares
- Queues
- Tables
- Disks

Storage accounts provide a unique namespace for your data that's accessible anywhere over `HTTP` or `HTTPS`.

For more information about the different types of storage accounts that support different features, reference [Types of storage accounts](/azure/storage/common/storage-account-overview?toc=/azure/storage/blobs/toc.json#types-of-storage-accounts).

To understand how an Azure storage account supports resiliency for your application workload, reference the following articles:

- [Azure storage redundancy](/storage/common/storage-redundancy?toc=/azure/storage/blobs/toc.json)
- [Disaster recovery and storage account failover](/azure/storage/common/storage-disaster-recovery-guidance?toc=/azure/storage/blobs/toc.json)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure storage accounts and reliability.

## Design considerations

Azure storage accounts include the following design considerations:

- General purpose v1 storage accounts provide access to all Azure Storage services, but may not have the latest features or the lower per-gigabyte pricing. It's recommended to use general purpose v2 storage accounts, in most cases. Reasons to use v1 include:
  
  - Applications require the classic deployment model.
  - Applications are transaction intensive or use significant geo-replication bandwidth, but don't require large capacity.
  - The use of a Storage Service REST API that is earlier than February 14, 2014, or a client library with a version earlier than `4.x` is required. An application upgrade isn't possible.
  
For more information, reference the [Storage account overview](/azure/storage/common/storage-account-overview).

- Storage account names must be between three and 24 characters and may contain numbers, and lowercase letters only.
- For current SLA specifications, reference [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/).
- Go to [Azure Storage redundancy](/azure/storage/common/storage-redundancy) to determine which redundancy option is best for a specific scenario.
- Storage account names must be unique within Azure. No two storage accounts can have the same name.