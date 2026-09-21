---
title: Compare AWS and Azure database services
description: Compare relational and non-relational database services on Azure and AWS, including document, key-value, wide-column, graph, and in-memory data stores.
author: splitfinity81
ms.author: yubaijna
ms.date: 08/21/2026
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
ms.collection: 
 - migration
 - aws-to-azure
---

# Database services on Azure and AWS

This article compares operational database services on Amazon Web Services (AWS) and Azure. It covers relational databases and non-relational data stores for document, key-value, wide-column, graph, and in-memory workloads.

For data integration, data lakes, data warehouses, stream processing, and business intelligence, see [Analytics services on Azure and AWS](./analytics.md).

## Amazon RDS and Azure relational database services

Amazon Relational Database Service (Amazon RDS) provides managed relational database engines. Azure provides managed services for several corresponding engines:

- [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)
- [Azure Database for MySQL](/azure/mysql/flexible-server/overview)
- [Azure Database for PostgreSQL](/azure/postgresql/overview)
- [SQL Database in Microsoft Fabric](/fabric/database/sql/overview)

You can also run [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview). For Oracle workloads, evaluate [Oracle AI Database@Azure](/azure/oracle/oracle-db/database-overview) and Oracle software on Azure infrastructure based on engine, support, and migration requirements.

Don't select a service based only on engine compatibility. Compare availability and disaster recovery requirements, scaling model, maintenance control, network isolation, authentication, extension support, migration downtime, and pricing.

## Non-relational database services

AWS and Azure provide non-relational services for distinct data models. A compatible API doesn't guarantee feature or operational parity. Before migration, compare partitioning, consistency, transactions, indexing, query behavior, change streams, global distribution, throughput units, and client-driver compatibility.

[Azure Cosmos DB](/azure/cosmos-db/overview) supports multiple APIs and data models. Create a separate account for each API, and use the same API for all access to the data in that account. Azure also provides [Azure DocumentDB](/azure/documentdb/overview) for MongoDB-compatible, vCore-based document workloads and [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/) for managed open-source Cassandra clusters.

For in-memory caching and temporary data, [Azure Managed Redis](/azure/redis/overview) provides a managed service based on Redis Enterprise. Don't use it as the authoritative persistent database for a workload.

## Service comparison

| Data model or capability | AWS service | Azure service | Selection guidance |
| --- | --- | --- | --- |
| Managed relational database | [Amazon RDS](https://aws.amazon.com/rds/) | [Azure SQL Database](/azure/azure-sql/database/), [Azure Database for MySQL](/azure/mysql/flexible-server/overview), or [Azure Database for PostgreSQL](/azure/postgresql/overview) | Select by database engine first. Then compare high availability, read replicas, scaling, maintenance, extensions, and migration support. |
| Serverless relational database | [Amazon Aurora Serverless](https://aws.amazon.com/rds/aurora/serverless/) | [Azure SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview) or [SQL Database in Microsoft Fabric](/fabric/database/sql/overview) | These services use different scaling and billing models. SQL Database serverless can automatically scale compute and pause during inactivity. SQL Database in Fabric consumes shared Fabric capacity and integrates operational data with Fabric analytics. |
| Key-value and document database | [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) | [Azure Cosmos DB for NoSQL](/azure/cosmos-db/) | Both services distribute data by partition key and provide change streams. Their consistency, indexing, query, transaction, capacity, and pricing models differ. Plan application and data-model changes instead of assuming API compatibility. |
| MongoDB-compatible document database | [Amazon DocumentDB](https://aws.amazon.com/documentdb/) | [Azure DocumentDB](/azure/documentdb/overview) or [Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/overview) | Azure DocumentDB uses a vCore model and the MongoDB wire protocol. Azure Cosmos DB for MongoDB provides a distributed, request-unit or vCore-based service. Validate supported MongoDB versions, commands, extensions, scaling, and migration tooling. |
| Wide-column database | [Amazon Keyspaces for Apache Cassandra](https://aws.amazon.com/keyspaces/) | [Azure Cosmos DB for Apache Cassandra](/azure/cosmos-db/cassandra/overview) or [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/) | Use Cosmos DB for Apache Cassandra when you want a managed Azure Cosmos DB service with Cassandra protocol compatibility. Use Managed Instance when you need managed open-source Cassandra clusters and greater engine-level compatibility. |
| Graph database | [Amazon Neptune](https://aws.amazon.com/neptune/) | [Azure Cosmos DB for Apache Gremlin](/azure/cosmos-db/gremlin/overview) | Neptune supports property graph and RDF workloads. Cosmos DB for Gremlin supports the property graph model and Gremlin query language. RDF and SPARQL workloads require another design. |
| Table data | [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) | [Azure Table Storage](/azure/storage/tables/table-storage-overview) or [Azure Cosmos DB for Table](/azure/cosmos-db/table/overview) | Use Table Storage for basic key-attribute storage. Use Cosmos DB for Table when you need globally distributed throughput, multiple consistency options, and Azure Cosmos DB capabilities. |
| In-memory cache and temporary data store | [Amazon ElastiCache](https://aws.amazon.com/elasticache/) | [Azure Managed Redis](/azure/redis/overview) | Use Azure Managed Redis for caching, sessions, messaging, and other low-latency temporary-data patterns. Keep authoritative data in a persistent database. |
| Durable Redis-compatible database | [Amazon MemoryDB](https://aws.amazon.com/memorydb/) | No direct equivalent | Amazon MemoryDB is designed as a durable primary database. Azure Managed Redis is a cache and temporary data store. On Azure, evaluate Azure Cosmos DB or another persistent database as the system of record, with Azure Managed Redis as an optional cache. |
| Database migration | [AWS Database Migration Service](https://aws.amazon.com/dms/) | [Azure Database Migration Service](/azure/dms/dms-overview) | Support varies by source, target, and online or offline migration mode. Verify the current [supported Azure migration scenarios](/azure/dms/resource-scenario-status) before you select a tool. |

## Migration considerations

Database migration requires more than moving data. Inventory engine features, stored procedures, extensions, indexes, consistency assumptions, partition keys, transaction boundaries, change-data-capture dependencies, and operational processes. Test application behavior and performance against the target service before cutover.

If you plan to migrate an AWS workload to Azure, see [Migrate databases from Amazon Web Services to Azure](/azure/migration/migrate-databases-from-aws) and its [example migration scenarios](/azure/migration/migrate-databases-from-aws#migration-scenarios).

## Related resources

- [Understand Azure data store models](/azure/architecture/data-guide/technology-choices/understand-data-store-models)
- [Migrate an application from DynamoDB to Azure Cosmos DB](/azure/cosmos-db/dynamo-to-cosmos)
- [Compare Azure SQL deployment options](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Yuri Baijnath](https://www.linkedin.com/in/yuri-baijnath-za/) | Senior Cloud Solution Architect Manager

Other contributor:

- [Richard Fitzgerald](https://www.linkedin.com/in/richard-fitzgerald-uk/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
