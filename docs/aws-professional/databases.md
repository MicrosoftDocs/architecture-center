---
title: Comparing AWS and Azure database technology
description: A comparison of the differences between database technologies between Azure and AWS
author: adamboeglin
ms.date: 05/21/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Database technologies on Azure and AWS

## RDS and Azure relational database services

Azure provides several different relational database services that are the equivalent of AWS' Relational Database Service (RDS).

- [SQL Database](https://docs.microsoft.com/azure/sql-database/sql-database-technical-overview)
- [Azure Database for MySQL](https://docs.microsoft.com/azure/mysql/overview)
- [Azure Database for PostgreSQL](https://docs.microsoft.com/azure/postgresql/overview)

Other database engines such as [SQL Server](https://azure.microsoft.com/services/virtual-machines/sql-server), [Oracle](https://azure.microsoft.com/campaigns/oracle), and [MySQL](https://azure.microsoft.com/documentation/articles/virtual-machines-windows-classic-mysql-2008r2) can be deployed using Azure VM Instances.

Costs for AWS RDS are determined by the amount of hardware resources that your instance uses, like CPU, RAM, storage, and network bandwidth. In the Azure database services, cost depends on your database size, concurrent connections, and throughput levels.

### See also

- [Azure SQL Database Tutorials](https://azure.microsoft.com/documentation/articles/sql-database-explore-tutorials)

- [Configure geo-replication for Azure SQL Database with the Azure portal](https://azure.microsoft.com/documentation/articles/sql-database-geo-replication-portal)

- [Introduction to Cosmos DB: A NoSQL JSON Database](https://docs.microsoft.com/azure/cosmos-db/sql-api-introduction)

- [How to use Azure Table storage from Node.js](https://azure.microsoft.com/documentation/articles/storage-nodejs-how-to-use-table-storage)

## Analytics and big data

[The Cortana Intelligence Suite](https://azure.microsoft.com/suites/cortana-intelligence-suite) is Azure's package of products and services designed to capture, organize, analyze, and visualize large amounts of data. The Cortana suite consists of the following services:

- [HDInsight](https://azure.microsoft.com/documentation/services/hdinsight): managed Apache distribution that includes Hadoop, Spark, Storm, or HBase.

- [Data Factory](https://azure.microsoft.com/documentation/services/data-factory): provides data orchestration and data pipeline functionality.

- [SQL Data Warehouse](https://azure.microsoft.com/documentation/services/sql-data-warehouse): large-scale relational data storage.

- [Data Lake Store](https://azure.microsoft.com/documentation/services/data-lake-store): large-scale storage optimized for big data analytics workloads.

- [Machine Learning](https://azure.microsoft.com/documentation/services/machine-learning): used to build and apply predictive analytics on data.

- [Stream Analytics](https://azure.microsoft.com/documentation/services/stream-analytics): real-time data analysis.

- [Data Lake Analytics](https://azure.microsoft.com/documentation/articles/data-lake-analytics-overview): large-scale analytics service optimized to work with Data Lake Store

- [Power BI](https://powerbi.microsoft.com): used to power data visualization.

## Service comparison

[!INCLUDE [Database Services](../../includes/aws/databases.md)]

### See also

- [Cortana Intelligence Gallery](https://gallery.cortanaintelligence.com)

- [Understanding Microsoft big data solutions](https://msdn.microsoft.com/library/dn749804.aspx)

- [Azure Data Lake and Azure HDInsight Blog](https://blogs.msdn.microsoft.com/azuredatalake)

