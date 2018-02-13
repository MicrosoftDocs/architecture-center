---
title: Choosing an OLTP data store
description: 
author: zoinerTejada
ms:date: 02/12/2018
---

# Choosing an OLTP data store in Azure

Online transaction processing (OLTP) is the management of transactional data and transaction processing. This topic compares options for OLTP solutions in Azure.

> [!NOTE]
> For more information about when to use an OLTP data store, see [Online transaction processing](../scenarios/online-analytical-processing.md).

## What are your options when choosing an OLTP data store?

In Azure, all of the following data stores will meet the core requirements for OLTP and the management of transaction data:

- [Azure SQL Database](/azure/sql-database/)
- [SQL Server in an Azure virtual machine](/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-server-iaas-overview?toc=%2Fazure%2Fvirtual-machines%2Fwindows%2Ftoc.json)
- [Azure Database for MySQL](/azure/mysql/)
- [Azure Database for PostgreSQL](/azure/postgresql/)

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want a managed service rather than managing your own servers?

- Does your solution have specific dependencies for Microsoft SQL Server, MySQL or PostgreSQL compatibility? Your application may limit the data stores you can choose based on the drivers it supports for communicating with the data store, or the assumptions it makes about which database is used.

- Are your write throughput requirements particularly high? If yes, choose an option that provides in-memory tables. 

- Is your solution multi-tenant? If so, consider options that support capacity pools, where multiple database instances draw from an elastic pool of resources, instead of fixed resources per database. This can help you better distribute capacity across all database instances, and can make your solution more cost effective.

- Does your data need to be readable with low latency in multiple regions? If yes, choose an option that supports readable secondary replicas.

- Does your database need to be highly available across geo-graphic regions? If yes, choose an option that supports geographic replication. Also consider the options that support automatic failover from the primary replica to a secondary replica.

- Does your database have specific security needs? If yes, examine the options that provide capabilities like row level security, data masking, and transparent data encryption.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities 
| | Azure SQL Database | SQL Server in an Azure virtual machine | Azure Database for MySQL | Azure Database for PostgreSQL |
| --- | --- | --- | --- | --- | --- |
| Is Managed Service | Yes | No | Yes | Yes |
| Runs on Platform | N/A | Windows, Linux, Docker | N/A | N/A |
| Programmability <sup>1</sup> | T-SQL, .NET, R | T-SQL, .NET, R, Python | T-SQL, .NET, R, Python | SQL | SQL |

[1] Not including client driver support, which allows many programming languages to connect to and use the OLTP data store.

### Scalability capabilities
| | Azure SQL Database | SQL Server in an Azure virtual machine| Azure Database for MySQL | Azure Database for PostgreSQL|
| --- | --- | --- | --- | --- | --- |
| Maximum database instance size | [4 TB](/azure/sql-database/sql-database-resource-limits) | 256 TB | [1 TB](/azure/mysql/concepts-limits) | [1 TB](/azure/postgresql/concepts-limits) |
| Supports capacity pools  | Yes | Yes | No | No |
| Supports clusters scale out  | No | Yes | No | No |
| Dynamic scalability (scale up)  | Yes | No | Yes | Yes |

### Analytic workload capabilities
| | Azure SQL Database | SQL Server in an Azure virtual machine| Azure Database for MySQL | Azure Database for PostgreSQL|
| --- | --- | --- | --- | --- | --- | 
| Temporal tables | Yes | Yes | No | No |
| In-memory (memory-optimized) tables | Yes | Yes | No | No |
| Columnstore support | Yes | Yes | No | No |
| Adaptive query processing | Yes | Yes | No | No |

### Availability capabilities
| | Azure SQL Database | SQL Server in an Azure virtual machine| Azure Database for MySQL | Azure Database for PostgreSQL|
| --- | --- | --- | --- | --- | --- | 
| Readable secondaries | Yes | Yes | No | No | 
| Geographic replication | Yes | Yes | No | No | 
| Automatic failover to secondary | Yes | No | No | No|
| Point-in-time restore | Yes | Yes | Yes | Yes |

### Security capabilities
| | Azure SQL Database | SQL Server in an Azure virtual machine| Azure Database for MySQL | Azure Database for PostgreSQL|
| --- | --- | --- | --- | --- | --- | 
| Row level security | Yes | Yes | Yes | Yes |
| Data masking | Yes | Yes | No | No |
| Transparent data encryption | Yes | Yes | Yes | Yes |
| Restrict access to specific IP addresses | Yes | Yes | Yes | Yes |
| Restrict access to allow VNET access only | Yes | Yes | No | No |
| Azure Active Directory authentication | Yes | Yes | No | No |
| Active Directory authentication | No | Yes | No | No |
| Multi-factor authentication | Yes | Yes | No | No |
| Supports [Always Encrypted](/sql/relational-databases/security/encryption/always-encrypted-database-engine) | Yes | Yes | Yes | No | No |
| Private IP | No | Yes | Yes | No | No |

