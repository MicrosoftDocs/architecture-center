---
title: Compare AWS and Azure database technology
description: Compare database technology differences between Azure and AWS. Review the Amazon RDS and Azure relational database services. See equivalents for analytics and big data.
author: splitfinity-zz-zz
ms.author: yubaijna
ms.date: 06/02/2025
ms.topic: conceptual
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
 - gcp-to-azure
---

# Relational database technologies on Azure and AWS

## Amazon RDS and Azure relational database services

Azure provides several different relational database services that are the equivalent of AWS' Relational Database Service (Amazon RDS). These include:

- [SQL Database](/azure/sql-database/sql-database-technical-overview)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Database for PostgreSQL](/azure/postgresql/overview)

Other database engines such as [SQL Server](https://azure.microsoft.com/services/virtual-machines/sql-server), [Oracle](https://azure.microsoft.com/campaigns/oracle), and [MySQL](/azure/mysql) can be deployed using Azure VM Instances.

Costs for Amazon RDS are determined by the amount of hardware resources that your instance uses, like CPU, RAM, storage, and network bandwidth. In the Azure database services, cost depends on your database size, concurrent connections, and throughput levels.

### See also

- [Azure SQL Database Tutorials](/azure/azure-sql/database/single-database-create-quickstart)

- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)

- [Configure geo-replication for Azure SQL Database with the Azure portal](/azure/azure-sql/database/active-geo-replication-configure-portal)

- [Introduction to Azure Cosmos DB: A NoSQL JSON Database](/azure/cosmos-db/sql-api-introduction)

- [How to use Azure Table storage from Node.js](/azure/cosmos-db/table-storage-how-to-use-nodejs)

## Analytics and big data

Azure provides a package of products and services designed to capture, organize, analyze, and visualize large amounts of data consisting of the following services:

- [HDInsight](/azure/hdinsight): managed Apache distribution that includes Hadoop, Spark, Storm, or HBase.

- [Data Factory](/azure/data-factory): provides data orchestration and data pipeline functionality.

- [Microsoft Fabric](https://www.microsoft.com/microsoft-fabric): a unified data platform that accelerates time to value across data engineering, warehouse, real-time analytics, data science and business intelligence.

- [Azure Databricks](/azure/databricks/): a unified analytics platform for data analysts, data engineers, data scientists, and machine learning engineers.

- [Machine Learning](/azure/machine-learning): used to build and apply predictive analytics on data.

- [Stream Analytics](/azure/stream-analytics): real-time data analysis.

- [Power BI](https://powerbi.microsoft.com): a business analytics service that provides the capabilities to create rich interactive data visualizations.

## Service comparison

| Type | AWS Service | Azure Service | Description |
| -----| ----------- | ------------- | ----------- |
| Relational database | [RDS](https://aws.amazon.com/rds) | [SQL Database](https://azure.microsoft.com/services/sql-database)<br/><br/>[Database for MySQL](https://azure.microsoft.com/services/mysql)<br/><br/>[Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) | Managed relational database services in which resiliency, scale and maintenance are primarily handled by the Azure platform. |
| Serverless relational database | [Amazon Aurora Serverless](https://aws.amazon.com/rds/aurora/serverless) | [Azure SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview) | Database offering that automatically scales compute based on the workload demand. You're billed per second for the actual compute used. |
| NoSQL | [DynamoDB](https://aws.amazon.com/dynamodb) (Key-Value)<br/><br/>[SimpleDB](https://aws.amazon.com/simpledb/)<br/><br/>[Amazon DocumentDB](https://aws.amazon.com/documentdb) (Document)<br /><br />[Amazon Neptune](https://aws.amazon.com/neptune/) (Graph) | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)<br/><br/> [Cosmos DB in Microsoft Fabric](/fabric/database/cosmos-db/overview)| Azure Cosmos DB is a globally distributed, multi-model database that natively supports multiple data models including key-value pairs, documents, graphs, and columnar. Cosmos DB in Microsoft Fabric uses the same architecture as Azure CosmosDb for NoSQL but is tightly integrated into Microsoft Fabric platform. |
| Caching | [ElastiCache](https://aws.amazon.com/elasticache)<br /><br />[Amazon MemoryDB for Redis](https://aws.amazon.com/memorydb/) | [Cache for Redis](https://azure.microsoft.com/services/cache) | An in-memory–based, distributed caching service that provides a high-performance store that's typically used to offload nontransactional work from a database. |
| Database migration | [Database Migration Service](https://aws.amazon.com/dms) | [Database Migration Service](https://azure.microsoft.com/campaigns/database-migration) | A service that executes the migration of database schema and data from one database format to a specific database technology in the cloud. |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Yuri Baijnath](https://www.linkedin.com/in/yuri-baijnath-za) | Senior Cloud Solution Architect Manager

Other contributor:

- [Richard Fitzgerald](https://www.linkedin.com/in/richard-fitzgerald-94748b25/) |
Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

### See also

- [Cloud-scale analytics](https://azure.microsoft.com/solutions/big-data/#overview)

- [Big data architecture style](../guide/architecture-styles/big-data.md)

- [Microsoft Fabric overview](/fabric/fundamentals/microsoft-fabric-overview)

- [Microsoft Fabric Blog](https://www.microsoft.com/microsoft-fabric/blog/)
