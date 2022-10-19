---
author: svchandramohan
ms.author: schandra
ms.topic: include
ms.service: architecture-center
---

| Type | AWS Service | Azure Service | Description |
| -----| ----------- | ------------- | ----------- |
| Relational database | [RDS](https://aws.amazon.com/rds) | [SQL Database](https://azure.microsoft.com/services/sql-database)<br/><br/>[Database for MySQL](https://azure.microsoft.com/services/mysql)<br/><br/>[Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)<br/><br/>[Database for MariaDB](https://azure.microsoft.com/services/mariadb) | Managed relational database services in which resiliency, scale and maintenance are primarily handled by the Azure platform. |
| Serverless relational database | [Amazon Aurora Serverless](https://aws.amazon.com/rds/aurora/serverless) | [Azure SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview)<br/><br/>[Serverless SQL pool in Azure Synapse Analytics](/azure/synapse-analytics/sql/on-demand-workspace-overview) | Database offerings that automatically scales compute based on the workload demand. You're billed per second for the actual compute used (Azure SQL)/data that's processed by your queries (Azure Synapse Analytics Serverless). |
| NoSQL | [DynamoDB](https://aws.amazon.com/dynamodb) (Key-Value)<br/><br/>[SimpleDB](https://aws.amazon.com/simpledb/)<br/><br/>[Amazon DocumentDB](https://aws.amazon.com/documentdb) (Document)<br /><br />[Amazon Neptune](https://aws.amazon.com/neptune/) (Graph) | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) | Azure Cosmos DB is a globally distributed, multi-model database that natively supports multiple data models including key-value pairs, documents, graphs, and columnar. |
| Caching | [ElastiCache](https://aws.amazon.com/elasticache)<br /><br />[Amazon MemoryDB for Redis](https://aws.amazon.com/memorydb/) | [Cache for Redis](https://azure.microsoft.com/services/cache) | An in-memory–based, distributed caching service that provides a high-performance store that's typically used to offload nontransactional work from a database. |
| Database migration | [Database Migration Service](https://aws.amazon.com/dms) | [Database Migration Service](https://azure.microsoft.com/campaigns/database-migration) | A service that executes the migration of database schema and data from one database format to a specific database technology in the cloud. |

### Database architectures

<ul class="grid">

[!INCLUDE [Gaming using Azure Cosmos DB](../../includes/cards/gaming-using-cosmos-db.md)]
[!INCLUDE [Oracle Database Migration to Azure](../../includes/cards/reference-architecture-for-oracle-database-migration-to-azure.md)]
[!INCLUDE [Retail and e-commerce using Azure MySQL](../../includes/cards/retail-and-ecommerce-using-azure-database-for-mysql.md)]

</ul>

[view all](/azure/architecture/browse/#databases)
