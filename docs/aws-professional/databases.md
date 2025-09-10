---
title: Compare AWS and Azure database technology
description: Compare database technology differences between Azure and AWS. Review the Amazon RDS and Azure relational database services. See equivalents for analytics and big data.
author: splitfinity-zz-zz
ms.author: yubaijna
ms.date: 09/08/2025
ms.topic: conceptual
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
- [Azure Database for MariaDB](/azure/mariadb/overview) (retiring September 19, 2025 - migrate to Azure Database for MySQL)

Azure also offers hybrid and specialized database solutions:

- [SQL Server enabled by Azure Arc](/sql/sql-server/azure-arc/overview) - Manage on-premises SQL Server instances through Azure
- [SQL Managed Instance enabled by Azure Arc](/azure/azure-arc/data/managed-instance-overview) - Near 100% SQL Server compatibility for hybrid scenarios
- [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) - Fully managed open-source Apache Cassandra clusters

Recent major updates include Azure SQL Database's native JSON data type support (May 2025), MySQL 8.4 LTS and 9.1 Innovation versions with vector data type support, and PostgreSQL's enhanced DiskANN Vector Indexing capabilities for AI workloads.

Other database engines such as [SQL Server](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview), [Oracle](https://azure.microsoft.com/campaigns/oracle), and [MySQL](/azure/mysql) can be deployed using Azure VM instances.

Costs for Amazon RDS are determined by the amount of hardware resources that your instance uses, like CPU, RAM, storage, and network bandwidth. AWS Aurora Serverless v2 now supports up to 256 Aurora Capacity Units (ACUs) for better scaling. In the Azure database services, cost depends on your database size, concurrent connections, and throughput levels. In Microsoft Fabric, the cost is based on the capacity SKU purchased, which entitles you to a set of Capacity Units (CUs). These CUs are shared across all Fabric workloads, such as SQL Database in Microsoft Fabric.

### See also

- [Azure SQL Database Tutorials](/azure/azure-sql/database/single-database-create-quickstart)

- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)

- [SQL Database in Microsoft Fabric tutorial](/fabric/database/sql/tutorial-introduction)

- [Configure geo-replication for Azure SQL Database with the Azure portal](/azure/azure-sql/database/active-geo-replication-configure-portal)

- [Introduction to Azure Cosmos DB: A NoSQL JSON Database](/azure/cosmos-db/sql-api-introduction)

- [How to use Azure Table storage from Node.js](/azure/cosmos-db/table-storage-how-to-use-nodejs)

## Recent developments in 2024-2025

Both AWS and Azure have introduced significant database enhancements:

### AWS Updates

- **Amazon Aurora Serverless v2**: Now supports up to 256 Aurora Capacity Units (ACUs) for better scaling
- **Amazon DynamoDB**: Major price reductions (50% for on-demand throughput, up to 67% for global tables), multi-region strong consistency preview, and enhanced security features
- **Zero-ETL integrations**: DynamoDB now integrates with Amazon Redshift and Amazon SageMaker Lakehouse

### Azure Updates

- **Azure SQL Database**: Native JSON data type support, JSON aggregate functions, Hyperscale enhancements up to 128 TB
- **Azure Database for MySQL**: MySQL 8.4 LTS and 9.1 Innovation support with vector data types, accelerated logs for Business Critical tier
- **Azure Database for PostgreSQL**: DiskANN Vector Indexing, elastic clusters preview, enhanced monitoring metrics
- **Microsoft Fabric**: Open mirroring capabilities, Spark connector for Data Warehouse, OPENROWSET and BULK INSERT support, enhanced SQL audit logs
- **Azure Arc**: Enhanced SQL Server management for on-premises instances, SQL Managed Instance for hybrid scenarios
- **Service retirements**: Azure Database for MariaDB retiring September 19, 2025 (migrate to MySQL), Azure SQL Edge retiring September 30, 2025

## Analytics and big data

Azure provides a comprehensive suite of products and services designed to capture, organize, analyze, and visualize large amounts of data consisting of the following services:

- [Azure HDInsight](/azure/hdinsight): managed Apache distribution that includes Hadoop, Spark, Storm, or HBase.

- [Azure Data Factory](/azure/data-factory): provides data orchestration and data pipeline functionality.

- [Microsoft Fabric](https://www.microsoft.com/microsoft-fabric): a unified data platform that accelerates time to value across data engineering, data warehouse, lakehouse, real-time analytics, data science and business intelligence. Recent updates include open mirroring capabilities, enhanced Spark connector for Data Warehouse, and OPENROWSET support.

- [Azure Databricks](/azure/databricks/): a unified analytics platform for data analysts, data engineers, data scientists, and machine learning engineers.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction): a modern data lake solution in Azure that combines the scalability and durability of Blob Storage with hierarchical namespace support. It is optimized for big data analytics and integrates with services like Azure Databricks, and Microsoft Fabric.

- [Azure Machine Learning](/azure/machine-learning): used to build and apply predictive analytics on data.

- [Azure Stream Analytics](/azure/stream-analytics): real-time data analysis.

- [Power BI](https://powerbi.microsoft.com): a business analytics service that provides the capabilities to create rich interactive data visualizations.

## Hybrid and edge database solutions

Azure provides unique database offerings that extend Azure database capabilities to on-premises, edge, and multi-cloud environments:

- **[SQL Server enabled by Azure Arc](/sql/sql-server/azure-arc/overview)**: Brings Azure management capabilities to SQL Server instances running on-premises, in other clouds, or at the edge. Features include inventory management, best practices assessment, migration readiness assessment, and Microsoft Defender for Cloud integration.

- **[SQL Managed Instance enabled by Azure Arc](/azure/azure-arc/data/managed-instance-overview)**: Provides near 100% SQL Server compatibility while running on your infrastructure of choice using Kubernetes. Offers cloud-like elasticity, unified management, and self-service provisioning for on-premises scenarios.

- **[Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction)**: A fully managed service for pure open-source Apache Cassandra clusters that can be deployed in hybrid configurations, connecting on-premises Cassandra rings with cloud-managed data centers.

## Service comparison

| Type | AWS Service | Azure Service | Description |
| -----| ----------- | ------------- | ----------- |
| Relational database | [Amazon RDS](https://aws.amazon.com/rds) | [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Azure Database for MySQL](https://azure.microsoft.com/services/mysql), [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) | Managed relational database services in which resiliency, scale and maintenance are primarily handled by the Azure platform. Azure SQL Database now supports native JSON data type (2025), while MySQL supports versions 8.4 LTS and 9.1 with vector data types. |
| Serverless relational database | [Amazon Aurora Serverless v2](https://aws.amazon.com/rds/aurora/serverless) | [Azure SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview), [SQL Database in Microsoft Fabric](/fabric/database/sql/overview) | Database offering that automatically scales compute based on the workload demand. Aurora Serverless v2 now supports up to 256 ACUs (October 2024). You're billed per second for the actual compute used. |
| Hybrid/On-premises SQL | [Amazon RDS on AWS Outposts](https://aws.amazon.com/rds/outposts/) | [SQL Server enabled by Azure Arc](/sql/sql-server/azure-arc/overview), [SQL Managed Instance enabled by Azure Arc](/azure/azure-arc/data/managed-instance-overview) | Azure Arc services enable you to manage on-premises SQL Server instances and run SQL Managed Instance on your infrastructure while maintaining Azure management capabilities. |
| Data Warehouse | [Amazon Redshift](https://aws.amazon.com/redshift/) | [Warehouse in Microsoft Fabric](/fabric/data-warehouse/data-warehousing), [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) | Warehouse in Microsoft Fabric is a lake-centric, distributed relational data warehouse that supports scalable SQL-based analytics and integrates tightly with Fabric workloads for unified analytics experience. Azure Synapse Analytics provides enterprise data warehousing and big data analytics. Recent updates include OPENROWSET and BULK INSERT support in Fabric. |
| NoSQL | [DynamoDB](https://aws.amazon.com/dynamodb) (Key-Value), [Amazon DocumentDB](https://aws.amazon.com/documentdb) (Document), [Amazon Neptune](https://aws.amazon.com/neptune/) (Graph) | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db), [Cosmos DB in Microsoft Fabric](/fabric/database/cosmos-db/overview), [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) | Azure Cosmos DB is a globally distributed, multi-model database that natively supports multiple data models including key-value pairs, documents, graphs, and columnar. Azure Managed Instance for Apache Cassandra offers pure open-source Cassandra with full management. DynamoDB introduced significant price reductions (50% for on-demand, up to 67% for global tables) and multi-region strong consistency in 2024. |
| Caching | [ElastiCache](https://aws.amazon.com/elasticache), [Amazon MemoryDB for Redis](https://aws.amazon.com/memorydb/) | [Azure Cache for Redis](https://azure.microsoft.com/services/cache) | An in-memory–based, distributed caching service that provides a high-performance store that's typically used to offload nontransactional work from a database. |
| Database migration | [Database Migration Service](https://aws.amazon.com/dms) | [Azure Database Migration Service](https://azure.microsoft.com/campaigns/database-migration), [Microsoft Fabric Migration Assistant for Data Warehouse](/fabric/data-warehouse/migration-assistant) | A service that executes the migration of database schema and data from one database format to a specific database technology in the cloud. Microsoft Fabric now includes enhanced migration tools and open mirroring capabilities. |

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

- [What's new in Azure SQL Database](/azure/azure-sql/database/doc-changes-updates-release-notes-whats-new)

- [What's new in Azure Database for MySQL](/azure/mysql/flexible-server/whats-new)

- [What's new in Azure Database for PostgreSQL](/azure/postgresql/flexible-server/release-notes)

- [What's new in Microsoft Fabric](/fabric/fundamentals/whats-new)
