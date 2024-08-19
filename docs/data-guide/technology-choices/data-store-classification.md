---
title: Data store classification for Azure workloads
description: Learn how to choose the right data store classification for Azure workloads. This article covers storage options like Blob Storage and Azure Files, and transactional and analytical databases.
author: joaria
categories: azure
ms.author: pnp
ms.reviewer: ambers
ms.date: 08/19/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - analytics
  - databases
  - datastores
products:
  - fabric
  - azure-synapse-analytics
  - azure-databricks
  - azure-sql-database
  - azure-cosmos-db
ms.custom:
  - guide
  - engagement-fy24
ai-usage: ai-assisted
---

# Data store classification

This article doesn't cover Internet of Things (IoT) scenarios. For more information about IoT-related storage, see [Azure IoT](https://azure.microsoft.com/solutions/iot) and [IoT architectures](../../reference-architectures/iot/iot-architecture-overview.md). It also doesn’t cover workloads that use vectorized data, like most AI workloads. For guidance about how to choose the right vector search database for your workload, see [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search).

For this architecture specifically, we can generally divide Azure storage into two unofficial categories. These categories are *simple storage solutions* and *database and analytics storage*.

:::image type="content" source="../images/azure-storage-options.png" alt-text="Diagram that illustrates data store classifications in Azure." lightbox="../images/azure-storage-options.png" border="false":::

## Simple storage solutions

Use simple storage solutions like [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) (Azure Data Lake Storage excluded), [Azure Files](/azure/storage/files/storage-files-introduction), [Azure disks](/azure/virtual-machines/managed-disks-overview), [Azure Queue Storage](/azure/storage/queues/), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), and [Azure Table Storage](/azure/storage/tables/). These solutions are ideal for storing large amounts of data that don’t require [atomicity, consistency, isolation, and durability (ACID)](/windows/win32/cossdk/acid-properties) capabilities. Simple storage solutions usually cost less than databases or analytics services. Use cases include file shares, data that doesn’t need as much structured querying or transactional capabilities, and long-term file retention.

## Databases in Azure

:::image type="content" source="../images/choose-data-store.png" alt-text="Diagram that compares relational database management systems and big data solutions." lightbox="../images/choose-data-store.png" border="false":::

Use databases when you need [ACID capabilities](/windows/win32/cossdk/acid-properties). Databases in Azure can be divided into two categories. These categories are *analytics databases and data stores* and *transactional databases and data stores*.

- Azure analytical databases and data stores support online analytical processing (OLAP) workloads. These specialized services store, manage, and analyze large volumes of data. These services provide the infrastructure for data warehousing, big data analytics, and real-time analytics. These workloads are optimized for reading large amounts of data and often use columnar storage. For more information about how to perform analytics with your workloads, see [Choose an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores).

- Transactional databases in Azure, also known as *online transaction processing (OLTP) systems*, support workloads that need quick, reliable, and secure transaction processing. These databases are optimized for operations that include frequent reads and writes. This optimization ensures data integrity and consistency. These workloads are optimized for reading and writing data, and typically use row storage, though there are exceptions. For more information about how to deploy a transactional database, see [OLTP solutions](/azure/architecture/data-guide/relational-data/online-transaction-processing).

There are two types of transactional databases. These databases are relational databases, also known as *SQL databases*, and nonrelational databases, also known as *NoSQL databases*.

- Relational databases are databases that store and organize data points with defined relationships for quick and easy access. These databases are structured into tables that represent predefined categories by using rows and columns that contain information about each entity. This organization enables efficient and flexible access to data. Examples of these databases in Azure include:

  - [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview).
  
  - [SQL Database](/azure/azure-sql).
  
  - [Azure Database for PostgreSQL](/azure/postgresql/) and PostgreSQL.
  
  - [Azure Database for MySQL](/azure/mysql) and MySQL in their infrastructure as a service and platform as a service versions.

- NoSQL databases, also known as *nonrelational databases* or *non-SQL databases*, store, manage, and retrieve data that isn't necessarily structured in a tabular form like relational databases. NoSQL databases can handle a wide variety of data types, including structured, semi-structured, and unstructured data. Examples of these databases in Azure are [Azure Cosmos DB](/azure/cosmos-db) and [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/).

You might need a hybrid database or data store for analytics and transactional purposes. These use cases are known as *hybrid transactional analytical processing*. Products like [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/) or [Azure SQL Hyperscale](/azure/azure-sql/database/service-tier-hyperscale) are good choices for these use cases.

## Next step

> [!div class="nextstepaction"]
> [Databases architecture design](/azure/architecture/databases/)

## Related resources

- [Choose an Azure data service](/azure/architecture/guide/technology-choices/data-options)
- [Criteria to choose a data store](/azure/architecture/guide/technology-choices/data-store-considerations)
