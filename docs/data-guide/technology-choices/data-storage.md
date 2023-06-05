---
title: Choose a data storage technology
description: Compare big data storage technology options in Azure, including key selection criteria and a capability matrix.
author: martinekuan
mas.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-storage
  - azure-blob-storage
ms.custom:
  - guide
  - internal-intro
---

<!-- cSpell:ignore VHDs HDFS WASB HMAC POSIX ACLs JDBC -->

# Choose a big data storage technology in Azure

> [!NOTE]
> On **Feb 29, 2024** Azure Data Lake Storage Gen1 will be retired. For more information, see the [official announcement](https://azure.microsoft.com/updates/action-required-switch-to-azure-data-lake-storage-gen2-by-29-february-2024/). If you use Azure Data Lake Storage Gen1, make sure to migrate to Azure Data Lake Storage Gen2 prior to that date. To learn how, see [Migrate Azure Data Lake Storage from Gen1 to Gen2 by using the Azure portal](/azure/storage/blobs/data-lake-storage-migrate-gen1-to-gen2-azure-portal).
>
> Unless you already have an Azure Data Lake Storage Gen1 account, you cannot create new ones.

This topic compares options for data storage for big data solutions—specifically, data storage for bulk data ingestion and batch processing, as opposed to [analytical data stores](./analytical-data-stores.md) or [real-time streaming ingestion](./real-time-ingestion.md).

## What are your options when choosing data storage in Azure?

There are several options for ingesting data into Azure, depending on your needs.

**File storage:**

- [Azure Storage blobs](/azure/storage/blobs/storage-blobs-introduction)
- [Azure Data Lake Storage Gen1](/azure/data-lake-store)

**NoSQL databases:**

- [Azure Cosmos DB](/azure/cosmos-db)
- [HBase on HDInsight](https://hbase.apache.org)

**Analytical databases:**

[Azure Data Explorer](/azure/data-explorer/)

## Azure Storage blobs

Azure Storage is a managed storage service that is highly available, secure, durable, scalable, and redundant. Microsoft takes care of maintenance and handles critical problems for you. Azure Storage is the most ubiquitous storage solution Azure provides, due to the number of services and tools that can be used with it.

There are various Azure Storage services you can use to store data. The most flexible option for storing blobs from many data sources is [Blob storage](/azure/storage/blobs/storage-blobs-introduction). Blobs are basically files. They store pictures, documents, HTML files, virtual hard disks (VHDs), big data such as logs, database backups—pretty much anything. Blobs are stored in containers, which are similar to folders. A container provides a grouping of a set of blobs. A storage account can contain an unlimited number of containers, and a container can store an unlimited number of blobs.

Azure Storage is a good choice for big data and analytics solutions, because of its flexibility, high availability, and low cost. It provides hot, cool, and archive storage tiers for different use cases. For more information, see [Azure Blob Storage: Hot, cool, and archive storage tiers](/azure/storage/blobs/access-tiers-overview).

Azure Blob storage can be accessed from Hadoop (available through HDInsight). HDInsight can use a blob container in Azure Storage as the default file system for the cluster. Through a Hadoop distributed file system (HDFS) interface provided by a WASB driver, the full set of components in HDInsight can operate directly on structured or unstructured data stored as blobs. Azure Blob storage can also be accessed via Azure Synapse Analytics using its PolyBase feature.

Other features that make Azure Storage a good choice are:

- [Multiple concurrency strategies](/azure/storage/common/storage-concurrency).
- [Disaster recovery and high availability options](/azure/storage/common/storage-disaster-recovery-guidance).
- [Encryption at rest](/azure/storage/common/storage-service-encryption).
- [Azure role-based access control (Azure RBAC)](/azure/storage/blobs/security-recommendations#data-protection) to control access using Azure Active Directory users and groups.

## Azure Data Lake Storage Gen1

[Azure Data Lake Storage Gen1](/azure/data-lake-store) is an enterprise-wide hyperscale repository for big data analytic workloads. Data Lake enables you to capture data of any size, type, and ingestion speed in one single [secure](/azure/data-lake-store/data-lake-store-overview#DataLakeStoreSecurity) location for operational and exploratory analytics.

Azure Data Lake Storage Gen1 doesn't impose any limits on account sizes, file sizes, or the amount of data that can be stored in a data lake. Data is stored durably by making multiple copies and there's no limit on the duration of time that the data can be stored in the Data Lake. In addition to making multiple copies of files to guard against any unexpected failures, Data lake spreads parts of a file over a number of individual storage servers. This improves the read throughput when reading the file in parallel for performing data analytics.

Azure Data Lake Storage Gen1 can be accessed from Hadoop (available through HDInsight) using the WebHDFS-compatible REST APIs. You may consider using this as an alternative to Azure Storage when your individual or combined file sizes exceed that which is supported by Azure Storage. However, there are [performance tuning guidelines](/azure/data-lake-store/data-lake-store-performance-tuning-guidance#optimize-io-intensive-jobs-on-hadoop-and-spark-workloads-on-hdinsight) you should follow when using Azure Data Lake Storage Gen1 as your primary storage for an HDInsight cluster, with specific guidelines for [Spark](/azure/data-lake-store/data-lake-store-performance-tuning-spark), [Hive](/azure/data-lake-store/data-lake-store-performance-tuning-hive), and [MapReduce](/azure/data-lake-store/data-lake-store-performance-tuning-mapreduce). Also, be sure to check Azure Data Lake Storage Gen1's [regional availability](https://azure.microsoft.com/regions/#services), because it isn't available in as many regions as Azure Storage, and it needs to be located in the same region as your HDInsight cluster.

Coupled with Azure Data Lake Analytics, Azure Data Lake Storage Gen1 is designed to enable analytics on the stored data and is tuned for performance for data analytics scenarios. Azure Data Lake Storage Gen1 can also be accessed via Azure Synapse using its PolyBase feature.

## Azure Cosmos DB

[Azure Cosmos DB](/azure/cosmos-db) is Microsoft's globally distributed multi-model database. Azure Cosmos DB guarantees single-digit-millisecond latencies at the 99th percentile anywhere in the world, offers multiple well-defined consistency models to fine-tune performance, and guarantees high availability with multi-homing capabilities.

Azure Cosmos DB is schema-agnostic. It automatically indexes all the data without requiring you to deal with schema and index management. It's also multi-model, natively supporting document, key-value, graph, and column-family data models.

Azure Cosmos DB features:

- [Geo-replication](/azure/cosmos-db/distribute-data-globally)
- [Elastic scaling of throughput and storage](/azure/cosmos-db/partition-data) worldwide
- [Five well-defined consistency levels](/azure/cosmos-db/consistency-levels)

## HBase on HDInsight

[Apache HBase](https://hbase.apache.org) is an open-source, NoSQL database that is built on Hadoop and modeled after Google BigTable. HBase provides random access and strong consistency for large amounts of unstructured and semi-structured data in a schemaless database organized by column families.

Data is stored in the rows of a table, and data within a row is grouped by column family. HBase is schemaless in the sense that neither the columns nor the type of data stored in them need to be defined before using them. The open-source code scales linearly to handle petabytes of data on thousands of nodes. It can rely on data redundancy, batch processing, and other features that are provided by distributed applications in the Hadoop ecosystem.

The [HDInsight implementation](/azure/hdinsight/hbase/apache-hbase-overview) leverages the scale-out architecture of HBase to provide automatic sharding of tables, strong consistency for reads and writes, and automatic failover. Performance is enhanced by in-memory caching for reads and high-throughput streaming for writes. In most cases, you'll want to [create the HBase cluster inside a virtual network](/azure/hdinsight/hbase/apache-hbase-provision-vnet) so other HDInsight clusters and applications can directly access the tables.

## Azure Data Explorer

[Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/) is a fast and highly scalable data exploration service for log and telemetry data. It helps you handle the many data streams emitted by modern software so you can collect, store, and analyze data. Azure Data Explorer is ideal for analyzing large volumes of diverse data from any data source, such as websites, applications, IoT devices, and more. This data is used for diagnostics, monitoring, reporting, machine learning, and additional analytics capabilities. Azure Data Explorer makes it simple to ingest this data and enables you to do complex ad hoc queries on the data in seconds.

Azure Data Explorer can be linearly [scaled out](/azure/data-explorer/manage-cluster-horizontal-scaling) for increasing ingestion and query processing throughput. An Azure Data Explorer cluster can be [deployed to a Virtual Network](/azure/data-explorer/vnet-deployment) for enabling private networks.

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you need managed, high-speed, cloud-based storage for any type of text or binary data? If yes, then select one of the file storage or analytics options.

- Do you need file storage that is optimized for parallel analytics workloads and high throughput/IOPS? If yes, then choose an option that is tuned to analytics workload performance.

- Do you need to store unstructured or semi-structured data in a schemaless database? If so, select one of the non-relational or analytics options. Compare options for indexing and database models. Depending on the type of data you need to store, the primary database models may be the largest factor.

- Can you use the service in your region? Check the regional availability for each Azure service. See [Products available by region](https://azure.microsoft.com/regions/services).

## Capability matrix

The following tables summarize the key differences in capabilities.

### File storage capabilities

| Capability | Azure Data Lake Storage Gen1 | Azure Blob Storage containers |
| --- | --- | --- |
| Purpose | Optimized storage for big data analytics workloads |General purpose object store for a wide variety of storage scenarios |
| Use cases | Batch, streaming analytics, and machine learning data such as log files, IoT data, click streams, large datasets | Any type of text or binary data, such as application back end, backup data, media storage for streaming, and general purpose data |
| Structure | Hierarchical file system | Object store with flat namespace |
| Authentication | Based on [Azure Active Directory Identities](/azure/active-directory/active-directory-authentication-scenarios) | Based on shared secrets [Account Access Keys](/azure/storage/common/storage-account-keys-manage) and [Shared Access Signature Keys](/azure/storage/common/storage-dotnet-shared-access-signature-part-1), and [Azure role-based access control (Azure RBAC)](/azure/security/security-storage-overview) |
| Authentication protocol | OAuth 2.0. Calls must contain a valid JWT (JSON web token) issued by Azure Active Directory | Hash-based message authentication code (HMAC). Calls must contain a Base64-encoded SHA-256 hash over a part of the HTTP request. |
| Authorization | POSIX access control lists (ACLs). ACLs based on Azure Active Directory identities can be set file and folder level. | For account-level authorization use [Account Access Keys](/azure/storage/common/storage-account-keys-manage). For account, container, or blob authorization use [Shared Access Signature Keys](/azure/storage/common/storage-dotnet-shared-access-signature-part-1). |
| Auditing | Available.  |Available |
| Encryption at rest | Transparent, server side | Transparent, server side; Client-side encryption |
| Developer SDKs | .NET, Java, Python, Node.js | .NET, Java, Python, Node.js, C++, Ruby |
| Analytics workload performance | Optimized performance for parallel analytics workloads, High Throughput and IOPS | Not optimized for analytics workloads |
| Size limits | No limits on account sizes, file sizes or number of files | Specific limits documented [here](/azure/azure-subscription-service-limits#storage-limits) |
| Geo-redundancy | Locally-redundant (LRS), globally redundant (GRS), read-access globally redundant (RA-GRS), zone-redundant (ZRS). | Locally redundant (LRS), globally redundant (GRS), read-access globally redundant (RA-GRS), zone-redundant (ZRS). See [here](/azure/storage/common/storage-redundancy) for more information |

### NoSQL database capabilities

|Capability|Azure Cosmos DB|HBase on HDInsight|
|---|---|---|
|Primary database model|Document store, graph, key-value store, wide column store|Wide column store|
|Secondary indexes|Yes|No|
|SQL language support|Yes|Yes (using the [Phoenix](https://phoenix.apache.org) JDBC driver)|
|Consistency|Strong, bounded-staleness, session, consistent prefix, eventual|Strong|
|Native Azure Functions integration|[Yes](/azure/cosmos-db/serverless-computing-database)|No|
|Automatic global distribution|[Yes](/azure/cosmos-db/distribute-data-globally)|No[HBase cluster replication can be configured](/azure/hdinsight/hbase/apache-hbase-replication) across regions with eventual consistency|
|Pricing model|Elastically scalable request units (RUs) charged per-second as needed, elastically scalable storage|Per-minute pricing for HDInsight cluster (horizontal scaling of nodes), storage|

## Analytical database capabilities

|Capability|Azure Data Explorer|
| --- | --- |
| Primary database model|Relational (column store), telemetry, and time series store|
| SQL language support|Yes|
| Pricing model| Elastically scalable cluster instances|
| Authentication| Based on [Azure Active Directory identities](https://github.com/uglide/azure-content/blob/master/articles/active-directory/active-directory-authentication-scenarios.md)|
| Encryption at rest| Supported, customer managed keys|
| Analytics workload performance| Optimized performance for parallel analytics workloads|
| Size limits| Linearly scalable|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Azure Cloud Storage Solutions and Services](https://azure.microsoft.com/products/category/storage)
- [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options)
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [Introduction to Azure Data Explorer](/training/modules/intro-to-azure-data-explorer)

## Related resources

- [Big data architectures](../big-data/index.yml)
- [Big data architecture style](../../guide/architecture-styles/big-data.yml)
- [Understand data store models](../../guide/technology-choices/data-store-overview.md)
- [Real-time analytics on big data architecture](../../solution-ideas/articles/real-time-analytics.yml)
