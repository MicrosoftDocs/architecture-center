---
title: “Choose an Azure service for vector search”
description: Use this information to decide which Azure service for vector search best suits your application
author: konabuta,
ms.author: keonabut, yongl, krmeht
ms.service: azure database for postgresql, azure sql database, azure cosmos db for postgresql, azure cosmos db for mongodb, azure ai search
ms.topic: product-comparison
ms.date: 03/18/2024
#customer intent: As a developer building generative AI application using vector search, I want to know the differences between Azure services for vector search so that I can select the most appropriate service for my project.
---

# Choose an Azure service for vector search

Vector search is a method of finding information in the shape of vectors (vectors are groups of numbers that show features or characteristics of things like text or images). It’s a significant advancement over traditional keyword-based search methods, offering faster and more accurate results by understanding the semantic relationships within the data.

Azure offers many ways to search vectors. This guide is written for developers who want to understand and choose an Azure service for vector search for your application.

This article compares the following services:  
- [Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/)
- [Azure SQL Database](http://Azure%20SQL%20documentation%20-%20Azure%20SQL%20|%20Microsoft%20Learn)
- [Azure Cosmos DB for PostgreSQL](https://learn.microsoft.com/en-us/azure/cosmos-db/postgresql/)
- [Azure Cosmos DB for MongoDB (vCore)](https://learn.microsoft.com/en-us/azure/cosmos-db/mongodb/vcore/) 
- [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/)
 
## Choose a candidate service – Key selection criteria 

This section helps you select the most likely services for your needs. To narrow the choices, start by answering these questions and scenarios

Answer the following questions about your workloads to help you make decisions based on the Azure database services decision tree:

### Key Questions

![images/vector-search-decision-tree.png](./images/vector-search-decision-tree.png)

- **What is the level of control of the OS and database engine required?** Some scenarios require you to have a high degree of control or ownership of the software configuration and host servers for your database workloads. In these scenarios, you can deploy custom infrastructure as a service (IaaS) virtual machines to fully control the deployment and configuration of data services. You might not require this level of control, but maybe you're not ready to move to a full platform as a service (PaaS) solution. In that case, a managed instance can provide higher compatibility with your on-premises database engine while offering the benefits of a fully managed platform.
- **Will your workloads use a relational database technology?** If so, what technology do you plan to use? Azure provides managed PaaS database capabilities for [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview), [MySQL](/azure/mysql/overview), [PostgreSQL](/azure/postgresql/overview), and [MariaDB](/azure/mariadb/overview).
    - Azure Cosmos DB supports [MongoDB](/azure/cosmos-db/mongodb/introduction) and [PostgreSQL](/azure/cosmos-db/postgresql/introduction) APIs to take advantage of the many benefits that Azure Cosmos DB offers, including automatic high availability and instantaneous scalability.
- **Will your workloads use SQL Server?** In Azure, you can have your workloads running in IaaS-based [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/) or on the PaaS-based [Azure SQL Database hosted service](/azure/azure-sql/database/sql-database-paas-overview). Choosing which option to use is primarily a question of whether you want to manage your database, apply patches, and take backups, or if you want to delegate these operations to Azure. In some scenarios, compatibility issues might require the use of IaaS-hosted SQL Server. For more information about how to choose the correct option for your workloads, see [Choose the right SQL Server option in Azure](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview).
- **Will your workloads use key/value database storage?** [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) offers a high-performance cached key/value data storage solution that can power fast, scalable applications. [Azure Cosmos DB](/azure/cosmos-db/introduction) also provides general-purpose key/value storage capabilities.
- **Will your workloads use document or graph data?** [Azure Cosmos DB](/azure/cosmos-db/introduction) is a multimodel database service that supports various data types and APIs. Azure Cosmos DB also provides document and graph database capabilities.
    - [MongoDB](/azure/cosmos-db/mongodb/introduction) and [Apache Gremlin](/azure/cosmos-db/gremlin/introduction) are document and graph APIs that are supported by Azure Cosmos DB.
- **Will your workloads use column-family data?** [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) offers a fully managed Apache Cassandra cluster that can extend your existing datacenters into Azure or act as a cloud-only cluster and datacenter.
    - [Apache Cassandra](/azure/cosmos-db/cassandra/introduction) API is also supported by Azure Cosmos DB. See the [product comparison](/azure/managed-instance-apache-cassandra/compare-cosmosdb-managed-instance?source=recommendations) documentation to help guide your decision on the best fit for your workload.
- **Will your workloads require high-capacity data analytics capabilities?** You can use [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) to effectively store and query structured petabyte-scale data. For unstructured big data workloads, you can use [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/) to store and analyze petabyte-size files and trillions of objects.
- **Will your workloads require search engine capabilities?** You can use [Azure Cognitive Search](/azure/search/search-what-is-azure-search) to build AI-enhanced cloud-based search indexes that you can integrate into your applications.
- **Will your workloads use time series data?** [Azure Time Series Insights](/azure/time-series-insights/time-series-insights-overview) is built to store, visualize, and query large amounts of time series data, such as data generated by IoT devices.

> [!NOTE]
> Learn more about how to assess database options for each of your applications or services in the [Azure application architecture guide](./data-store-overview.md).

### Common Vector Search Scenarios

The following table lists common use-scenario requirements and the recommended database services for handling them.

| If you want to | Use this database service|
|---|---|
| Build apps that scale with a managed and intelligent SQL database in the cloud. | [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) |
| Modernize SQL Server applications with a managed, always-up-to-date SQL instance in the cloud. | [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql&preserve-view=true) |
| Migrate your SQL workloads to Azure while maintaining complete SQL Server compatibility and operating system-level access. | [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresql&preserve-view=true) |
| Build scalable, secure, and fully managed enterprise-ready apps on open-source PostgreSQL, scale out single-node PostgreSQL with high performance, or migrate PostgreSQL and Oracle workloads to the cloud. | [Azure Database for PostgreSQL](/azure/postgresql/overview) |
| Deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MySQL database service, or migrate MySQL workloads to the cloud. | [Azure Database for MySQL](/azure/mysql/overview) |
| Deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MariaDB database service. | [Azure Database for MariaDB](/azure/mariadb/overview) |
| Build applications with guaranteed low latency and high availability anywhere, at any scale, or migrate Cassandra, MongoDB, Gremlin, and other NoSQL workloads to the cloud. | [Azure Cosmos DB](/azure/cosmos-db/introduction) |
| Modernize existing Cassandra data clusters and apps, and enjoy flexibility and freedom with managed instance service. | [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) |
| Build a fully managed elastic data warehouse that has security at every level of scale at no extra cost. | [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) |
| Power fast, scalable applications with an open-source-compatible in-memory data store. | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |


### Capability Matrix

Understand the basic features of each Azure service from the following table.
| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
|---|---|---|---|---|---|
| Built-In Vector Search | Yes [(1)]() | Yes [(2)]() | Yes [(1)]() | Yes [(3)]() | No [(4)]() |
| Data Type for Vectors | Yes | Yes | Yes | Yes | No [(5)]() |
| Dimensions Limits [(6)]() | 16,000 [(7)]() or 2000 (HNSW & IVFflat) | 2,000 | 16,000 (7) or 2000 (HNSW & IVFflat) | 2,048 | Unlimited |
| Multiple Vector Fields | Yes | No | Yes | Yes | N/A |
| Multiple Vector Indexes | Yes | No | Yes | Yes | N/A |

- (1) Vector search is supported by pgvector which is the extension of PostgreSQL. 
- (2) Use vector search on embeddings in Azure Cosmos DB for MongoDB vCore 
- (3) Vectors in Azure AI Search 
- (4) Vector search is not provided as a first-class feature, but it can be implemented (using columnstore indexes and functions for cosine similarity) 
- (5) Need to unpivot dimension(array) to table row. Vectors are stored with columnstore index. 
- (6) For embedding models from OpenAI, 1536 for both text-embedding-ada-002 and text-embedding-3-small, and 3072 for text-embedding-3-large. For Azure AI Vision multimodal embedding models, 1024 for both image and text. 
- (7) Vectors can have up to 16,000. But index using IVFFlat and HNSW supports vectors with up to 2,000 dimensions. 

### Search methods 

Not only vector search, but also full-text search and hybrid search (full text search + vector search) functions are important. It is because in general the combination of hybrid search and reranking achieves high accuracy. 

Understand what kind of search methods are provided from the following table.
| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
|---|---|---|---|---|---|
| Full Text Search | Yes [(1)]() | Yes [(2)]() | Yes [(1)]() | Yes [(3)]() | Yes [(4)]() |
| Built-In Hybrid Search | No [(5)]() | No | No [(5)]() | Yes [(6)]() | No |
| Reranking | No | No | No | Yes [(7)]() | No |

- (1) PostgreSQL Full Text Search 
- (2) Search and query with text indexes in Azure Cosmos DB for MongoDB vCore 
- (3) Get Started with Full-Text Search 
- (4) Vector Data on SQL Server 
- (5) Not provided as a first-class feature but sample codes are provided (reciprocal rank fusion, cross-encoder) 
- (6) Hybrid search (Semantic search + Re-ranker, Etc.) is provided as a first-class feature. 
- (7) Semantic Ranking is a first-class feature for reranking the result of full text search and/or vector search.

### Vector data Indexing capabilities 

Vector data indexing is the ability to efficiently store and retrieve vectors. This capability is important because indexing helps us perform fast and accurate similarity searches and nearest neighbor queries on data sources. 

Understand what kinds of vector data indexing are provided from the following table.
| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
|---|---|---|---|---|---|
| Exhaustive KNN (brute-force search) | Yes | Yes | Yes | Yes | Yes |
| HNSW | Yes| Yes | Yes | Yes | No |
| IVFflat | Yes | Yes | Yes | No | No |
| Cosine Similarity  | Yes | Yes | Yes | Yes | Yes |
| L2 Distance | Yes| Yes | Yes | Yes | No |
| Dot Product  | Yes | Yes | Yes | Yes | No |

- (1) Document Link 
- (2) Only one index can be created per container. 
- (3) Azure SQL Database doesn't have vector data type. But you can store vectors into a column. Each row holds each element of vectors. Then you can use columnstore index to efficiently store and search for vectors. 

### Integration with Microsoft technology 

Some technologies from Microsoft will be useful to build systems using vector search. For example, Azure OpenAI Service helps you to create vectors for your data and input queries for vector similarity search.   
Understand the useful services/tools from Microsoft which can be integrated into each Azure service.
| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
|---|---|---|---|---|---|
| Azure Open AI Service - add your own data | No | Yes | No | Yes | No |
| Vector Embedding with Azure OpenAI | No | No | Yes | Yes | Yes |
| Integration with Prompt flow | No | No | No | Yes | No |
| Integration with Semantic Kernel | Yes | Yes | Yes | Yes | No |
- (1) Azure Cosmos DB for MongoDB (vCore) is supported as a DataSource for Azure OpenAI on your data. 
- (2) Azure AI Search is supported as a DataSource for Azure OpenAI on your data. 
- (3) Azure AI Extension (preview) is available. 
- (4) Azure AI Search provides a skill to vectorize the chunked text. 
- (5) Stored Procedure 
- (6) Supported as a vector database in "Index Lookup" tool. 
- (7) Supported as a vector database connector (C#). 
- (8) Supported as a vector database connector (Python). 
- (9) Supported as a memory connector, and a vector database connector.