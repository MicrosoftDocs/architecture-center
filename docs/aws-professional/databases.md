---
title: Compare AWS and Azure database technology
description: Compare database technology differences between Azure and AWS. Review the Amazon RDS and Azure relational database services. See equivalents for analytics and big data.
author: splitfinity81
ms.author: yubaijna
ms.date: 06/02/2025
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
---

# Relational database technologies on Azure and AWS

This article helps map familiar AWS database services to the equivalent offerings from Microsoft.

## Amazon RDS and Azure relational database services

Azure provides several different relational database services that are the equivalent of AWS' Relational Database Service (Amazon RDS). These include:

- [Azure SQL Database](/azure/sql-database/sql-database-technical-overview)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Database for PostgreSQL](/azure/postgresql/overview)
- [SQL Database in Microsoft Fabric](/fabric/database/sql/overview)

Other database engines such as [SQL Server](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview), [Oracle](https://azure.microsoft.com/campaigns/oracle), and [MySQL](/azure/mysql) can be deployed using Azure VM instances.

Costs for Amazon RDS are determined by the amount of hardware resources that your instance uses, like CPU, RAM, storage, and network bandwidth. In the Azure database services, cost depends on your database size, concurrent connections, and throughput levels. In Microsoft Fabric, the cost is based on the capacity SKU purchased, which entitles you to a set of Capacity Units (CUs). These CUs are shared across all Fabric workloads, such as SQL Database in Microsoft Fabric.

### See also

- [Azure SQL Database Tutorials](/azure/azure-sql/database/single-database-create-quickstart)

- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)

- [SQL Database in Microsoft Fabric tutorial](/fabric/database/sql/tutorial-introduction)

- [Configure geo-replication for Azure SQL Database with the Azure portal](/azure/azure-sql/database/active-geo-replication-configure-portal)

- [Introduction to Azure Cosmos DB: A NoSQL JSON Database](/azure/cosmos-db/sql-api-introduction)

- [How to use Azure Table storage from Node.js](/azure/cosmos-db/table-storage-how-to-use-nodejs)

## Analytics and big data

Azure provides a package of products and services designed to capture, organize, analyze, and visualize large amounts of data consisting of the following services:

- [Azure HDInsight](/azure/hdinsight): managed Apache distribution that includes Hadoop, Spark, Storm, or HBase.

- [Azure Data Factory](/azure/data-factory): provides data orchestration and data pipeline functionality.

- [Microsoft Fabric](https://www.microsoft.com/microsoft-fabric): a unified data platform that accelerates time to value across data engineering, data warehouse, lakehouse, real-time analytics, data science and business intelligence.

- [Azure Databricks](/azure/databricks/): a unified analytics platform for data analysts, data engineers, data scientists, and machine learning engineers.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction): a modern data lake solution in Azure that combines the scalability and durability of Blob Storage with hierarchical namespace support. It is optimized for big data analytics and integrates with services like Azure Databricks, and Microsoft Fabric.

- [Azure Machine Learning](/azure/machine-learning): used to build and apply predictive analytics on data.

- [Azure Stream Analytics](/azure/stream-analytics): real-time data analysis.

- [Power BI](https://powerbi.microsoft.com): a business analytics service that provides the capabilities to create rich interactive data visualizations.

## Service comparison

| Type | AWS Service | Azure Service | Description |
| -----| ----------- | ------------- | ----------- |
| Relational database | [Amazon RDS](https://aws.amazon.com/rds) | [Azure SQL Database](https://azure.microsoft.com/services/sql-database)<br/><br/>[Azure Database for MySQL](https://azure.microsoft.com/services/mysql)<br/><br/>[Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) | Managed relational database services in which resiliency, scale and maintenance are primarily handled by the Azure platform. |
| Serverless relational database | [Amazon Aurora Serverless](https://aws.amazon.com/rds/aurora/serverless) | [Azure SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview)<br/><br/>[SQL Database in Microsoft Fabric](/fabric/database/sql/overview) | Database offering that automatically scales compute based on the workload demand. You're billed per second for the actual compute used. |
| Data Warehouse | [Amazon Redshift](https://aws.amazon.com/redshift/) | [Warehouse in Microsoft Fabric](/fabric/data-warehouse/data-warehousing) | Warehouse in Microsoft Fabric is a lake-centric, distributed relational data warehouse that supports scalable SQL-based analytics and integrates tightly with Fabric workloads for unified analytics experience. |
| NoSQL | [DynamoDB](https://aws.amazon.com/dynamodb) (Key-Value)<br/><br/>[SimpleDB](https://aws.amazon.com/simpledb/)<br/><br/>[Amazon DocumentDB](https://aws.amazon.com/documentdb) (Document)<br/><br/>[Amazon Neptune](https://aws.amazon.com/neptune/) (Graph) | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)<br/><br/> [Cosmos DB in Microsoft Fabric](/fabric/database/cosmos-db/overview)| Azure Cosmos DB is a globally distributed, multi-model database that natively supports multiple data models including key-value pairs, documents, graphs, and columnar. Cosmos DB in Microsoft Fabric uses the same architecture as Azure Cosmos DB for NoSQL but is tightly integrated into the Microsoft Fabric platform. |
| Caching | [ElastiCache](https://aws.amazon.com/elasticache)<br/><br/>[Amazon MemoryDB for Redis](https://aws.amazon.com/memorydb/) | [Azure Managed Redis](https://azure.microsoft.com/products/managed-redis) | Azure Managed Redis is an in-memory data store that offloads nontransactional work from databases and acts as a real-time memory layer for intelligent apps and AI agents. |
| Database migration | [Database Migration Service](https://aws.amazon.com/dms) | [Azure Database Migration Service](https://azure.microsoft.com/campaigns/database-migration)<br/><br/>[Microsoft Fabric Migration Assistant for Data Warehouse](/fabric/data-warehouse/migration-assistant) | A service that executes the migration of database schema and data from one database format to a specific database technology in the cloud. |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Yuri Baijnath](https://www.linkedin.com/in/yuri-baijnath-za/) | Senior Cloud Solution Architect Manager

Other contributor:

- [Richard Fitzgerald](https://www.linkedin.com/in/richard-fitzgerald-uk/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

### Additional resources

- [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/)

- [Big data architecture style](../guide/architecture-styles/big-data.md)

- [Microsoft Fabric community blogs](https://community.fabric.microsoft.com/t5/Fabric-community-blogs/ct-p/fabricblogs)
