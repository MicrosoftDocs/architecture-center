---
title: Comparing AWS and Azure database technologies
description: A comparison of the differences between the database technologies of Azure and AWS.
author: splitfinity
ms.author: pnp
ms.date: 08/10/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Relational database technologies on Azure and AWS

## RDS and Azure relational database services

Azure provides several different relational database services that are the equivalent of AWS' Relational Database Service (RDS). These include: 

- [SQL Database](/azure/sql-database/sql-database-technical-overview)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Database for PostgreSQL](/azure/postgresql/overview)
- [Azure Database for MariaDB](/azure/mariadb/overview)

Other database engines such as [SQL Server](https://azure.microsoft.com/services/virtual-machines/sql-server), [Oracle](https://azure.microsoft.com/campaigns/oracle), and [MySQL](/azure/mysql) can be deployed using Azure VM Instances.

Costs for AWS RDS are determined by the amount of hardware resources that your instance uses, like CPU, RAM, storage, and network bandwidth. In the Azure database services, cost depends on your database size, concurrent connections, and throughput levels.

### See also

- [Azure SQL Database Tutorials](/azure/azure-sql/database/single-database-create-quickstart)

- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)

- [Configure geo-replication for Azure SQL Database with the Azure portal](/azure/azure-sql/database/active-geo-replication-configure-portal)

- [Introduction to Cosmos DB: A NoSQL JSON Database](/azure/cosmos-db/sql-api-introduction)

- [How to use Azure Table storage from Node.js](/azure/cosmos-db/table-storage-how-to-use-nodejs)

## Analytics and big data

Azure provides a package of products and services designed to capture, organize, analyze, and visualize large amounts of data consisting of the following services:

- [HDInsight](https://azure.microsoft.com/documentation/services/hdinsight): managed Apache distribution that includes Hadoop, Spark, Storm, or HBase.

- [Data Factory](https://azure.microsoft.com/documentation/services/data-factory): provides data orchestration and data pipeline functionality.

- [Azure Synapse Analytics](https://azure.microsoft.com/documentation/services/synapse-analytics): an enterprise analytics service that accelerates time to insight, across data warehouses and big data systems.

- [Azure Databricks](/azure/databricks/): a unified analytics platform for data analysts, data engineers, data scientists, and machine learning engineers.

- [Data Lake Store](https://azure.microsoft.com/documentation/services/data-lake-store): analytics service that brings together enterprise data warehousing and big data analytics. Query data on your terms, using either serverless or dedicated resources—at scale.

- [Machine Learning](https://azure.microsoft.com/documentation/services/machine-learning): used to build and apply predictive analytics on data.

- [Stream Analytics](https://azure.microsoft.com/documentation/services/stream-analytics): real-time data analysis.

- [Data Lake Analytics](/azure/data-lake-analytics/data-lake-analytics-overview): large-scale analytics service optimized to work with Data Lake Store

- [Power BI](https://powerbi.microsoft.com): a business analytics service that provides the capabilities to create rich interactive data visualizations.

## Service comparison

[!INCLUDE [Database Services](../../includes/aws/databases.md)]

### See also

- [Azure AI Gallery](https://gallery.azure.ai/)

- [Cloud-scale analytics](https://azure.microsoft.com/solutions/big-data/#overview)

- [Big data architecture style](/azure/architecture/guide/architecture-styles/big-data)

- [Azure Data Lake and Azure HDInsight blog](/archive/blogs/azuredatalake/)

