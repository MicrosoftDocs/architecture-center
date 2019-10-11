---
title: Failure and disaster recovery for Azure applications
description: Overview of disaster recovery approaches in Azure
author: MikeWasson
ms.date: 04/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
---

## Service-specific guidance

The following articles describe disaster recovery for specific Azure services:

| Service                       | Article                                                                                                                                                                                       |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Azure Database for MySQL      | [Overview of business continuity with Azure Database for MySQL](/azure/mysql/concepts-business-continuity)                                                  |
| Azure Database for PostgreSQL | [Overview of business continuity with Azure Database for PostgreSQL](/azure/postgresql/concepts-business-continuity)                                        |
| Azure Cloud Services          | [What to do in the event of an Azure service disruption that impacts Azure Cloud Services](/azure/cloud-services/cloud-services-disaster-recovery-guidance) |
| Cosmos DB                     | [High availability with Azure Cosmos DB](/azure/cosmos-db/high-availability)                                                                                |
| Azure Key Vault               | [Azure Key Vault availability and redundancy](/azure/key-vault/key-vault-disaster-recovery-guidance)                                                        |
| Azure Storage                 | [Disaster recovery and storage account failover (preview) in Azure Storage](/azure/storage/common/storage-disaster-recovery-guidance)                       |
| SQL Database                  | [Restore an Azure SQL Database or failover to a secondary region](/azure/sql-database/sql-database-disaster-recovery)                                       |
| Virtual Machines              | [What to do in the event of an Azure service disruption impacts Azure Cloud](/azure/cloud-services/cloud-services-disaster-recovery-guidance)               |
| Azure Virtual Network         | [Virtual Network – Business Continuity](/azure/virtual-network/virtual-network-disaster-recovery-guidance)                                                  |

## Next steps

- [Recover from data corruption or accidental deletion](../resiliency/recovery-data-corruption.md)
- [Recover from a region-wide service disruption](../resiliency/recovery-loss-azure-region.md)
