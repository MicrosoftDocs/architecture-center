---
author: doodlemania2
ms.author: adboegli
ms.topic: include
ms.service: architecture-center
---

| Type | AWS Service | Azure Service | Description |
| -----| ----------- | ------------- | ----------- |
| Relational database | [RDS](https://aws.amazon.com/rds/) | [SQL Database](https://azure.microsoft.com/services/sql-database/)<br/><br/>[Database for MySQL](https://azure.microsoft.com/services/mysql/)<br/><br/>[Database for PostgreSQL](https://azure.microsoft.com/services/postgresql/) | Managed relational database service where resiliency, scale, and maintenance are primarily handled by the platform. |
| NoSQL / Document | [DynamoDB](https://aws.amazon.com/dynamodb/)<br/><br/>[SimpleDB](https://aws.amazon.com/simpledb/)<br/><br/>[Amazon DocumentDB](https://aws.amazon.com/documentdb/) | [Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) | A globally distributed, multi-model database that natively supports multiple data models: key-value, documents, graphs, and columnar. |
| Caching | [ElastiCache](https://aws.amazon.com/elasticache/) | [Cache for Redis](https://azure.microsoft.com/services/cache/) | An in-memory–based, distributed caching service that provides a high-performance store typically used to offload nontransactional work from a database. |
| Database migration | [Database Migration Service](https://aws.amazon.com/dms/) | [Database Migration Service](https://azure.microsoft.com/campaigns/database-migration/) | Migration of database schema and data from one database format to a specific database technology in the cloud. |

### Database architectures

<ul class="grid">

[!INCLUDE [Gaming using Cosmos DB](../../includes/cards/gaming-using-cosmos-db.md)]
[!INCLUDE [Oracle Database Migration to Azure](../../includes/cards/reference-architecture-for-oracle-database-migration-to-azure.md)]
[!INCLUDE [Retail and e-commerce using Azure MySQL](../../includes/cards/retail-and-ecommerce-using-azure-database-for-mysql.md)]

</ul>

[view all](/azure/architecture/browse/#databases)