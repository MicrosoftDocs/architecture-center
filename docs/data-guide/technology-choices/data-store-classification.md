---
title: Data store classification for Azure workloads
titleSuffix: Azure Architecture Center
description: Learn how to choose the right data store classification for Azure workloads. This article describes simple storage solutions and transactional and analytical databases.
author: joaria
categories: azure
ms.author: pnp
ms.reviewer: ambers
ms.date: 08/20/2024
ms.topic: conceptual
ms.subservice: architecture-guide
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

This article describes Azure Storage options. It doesn't cover Internet of Things (IoT) storage options. For more information about IoT-related storage, see [Azure IoT](https://azure.microsoft.com/solutions/iot) and [IoT architectures](/azure/architecture/browse/?azure_categories=iot). This article also doesn't cover workloads that use vectorized data, like most AI workloads. For more information, see [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search).

Azure Storage categories include *simple storage solutions*, *database and analytics storage*, and *IoT storage*. The following sections describe simple storage and database and analytics storage.

:::image type="content" source="../images/azure-storage-options.svg" alt-text="Diagram that illustrates data store classifications in Azure." lightbox="../images/azure-storage-options.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-storage-options.vsdx) of this architecture.*

## Simple storage solutions

Use simple storage solutions like [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) (Azure Data Lake Storage excluded), [Azure Files](/azure/storage/files/storage-files-introduction), [Azure disks](/azure/virtual-machines/managed-disks-overview), [Azure Queue Storage](/azure/storage/queues/), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), and [Azure Table Storage](/azure/storage/tables/). These solutions are ideal for storing large amounts of data that don't require [atomicity, consistency, isolation, and durability (ACID) capabilities](/windows/win32/cossdk/acid-properties). Simple storage solutions usually cost less than databases or analytics services. Use simple storage for file shares, data that needs minimal structured querying and transactional capabilities, and long-term file retention.

## Database and analytics storage

Use databases when you need [ACID capabilities](/windows/win32/cossdk/acid-properties). Azure databases include *analytical databases or data stores* and *transactional databases or data stores*.

- Azure analytical databases and data stores, also known as online analytical processing (OLAP) workloads, are specialized services designed to store, manage, and analyze large volumes of data. These specialized tools store, manage, and analyze large volumes of data. Analytical databases provide the infrastructure for data warehousing, big data analytics, and real-time analytics. They are optimized for reading large amounts of data and often use columnar storage. For more information, see [Choose an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores).

- Transactional databases in Azure, also known as *online transaction processing (OLTP) systems*, support workloads that need quick, reliable, and secure transaction processing. Transactional databases are optimized for reading and writing data and typically use row storage, but there are exceptions. This optimization ensures data integrity and consistency. For more information about how to deploy a transactional database, see [OLTP solutions](/azure/architecture/data-guide/relational-data/online-transaction-processing).

The two types of transactional databases include relational databases, also known as *SQL databases*, and nonrelational databases, also known as *NoSQL databases*.

:::image type="content" source="../images/choose-data-store.svg" alt-text="Diagram that compares relational database management systems and big data solutions." lightbox="../images/choose-data-store.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/choose-data-store.vsdx) of this architecture.*

- Use relational databases to store and organize data points that have defined relationships for quick and easy access. These databases have tables that represent predefined categories. The rows and columns contain information about each entity. This structure provides efficient and flexible access to data. Examples of these databases in Azure include:

  - [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview).

  - [SQL Database](/azure/azure-sql).

  - [Azure Database for PostgreSQL](/azure/postgresql/) and PostgreSQL.

  - [Azure Database for MySQL](/azure/mysql) and MySQL in their infrastructure as a service and platform-as-a-service versions.

- Nonrelational databases store, manage, and retrieve data that isn't necessarily structured in a tabular form like relational databases. NoSQL databases can handle a wide variety of data types, including structured, semi-structured, and unstructured data. Examples of these databases in Azure include [Azure Cosmos DB](/azure/cosmos-db) and [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/).

You might need a hybrid database or data store for analytical and transactional purposes. These use cases are known as *hybrid transactional and analytical processing*. For these use cases, use products like [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/) or [Azure SQL Database Hyperscale](/azure/azure-sql/database/service-tier-hyperscale).

## Next step

> [!div class="nextstepaction"]
> [Databases architecture design](/azure/architecture/databases/)

## Related resources

- [Choose an Azure data service](../../guide/technology-choices/data-options.md)
- [Criteria to choose a data store](../../guide/technology-choices/data-store-considerations.md)
