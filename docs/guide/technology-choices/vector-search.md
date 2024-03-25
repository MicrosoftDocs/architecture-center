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

- **You need to do Inert/Update/Delete the vector fields frequently and the vector search result must be always up to dated:** 
  - If your scenarios require CRUD the vector data and if the vector search result must be always up-to-date, you can ***keep vector fields in database systems***.
  - In these scenarios, you can deploy ***RDBMS database or NoSQL database*** for vector store which based on your preference.
  - You need to ***develope advanced search features and need to optimize search quality by yourself***.
  - Choosing database for vector store has advantage in ***Cost Optimization*** perspective than choosing search engine.
- **You have MongoDB already or you are familiar with MongoDB:** 
  - If so, Azure Cosmos DB supports [MongoDB](/azure/cosmos-db/mongodb/introduction) and APIs to take advantage of the many benefits that Azure Cosmos DB offers, including Azure Open AI Service integration and instantaneous scalability.
  - JSON(BSON) format is more flexible than RDBMS to keep other relavant data along with vector fields.
  - Azure Cosmos DB for MongoDB vCore supports ANN vector index such as HNSW and IVFflat.
  - ***Limitation:***
    - ***Only one vector field is available per Container.***
    - ***Only one vector index is available per container.***
    - ***You have to create vector index with empty container and you can not modify vector index if you have large vector dataset.***
- **You have Apache Cassandra already or you are familiar with Column Family:** 
  - If so, [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) offers a fully managed Apache Cassandra cluster that can extend your existing datacenters into Azure or act as a cloud-only cluster and datacenter.
- **You have PostgreSQL already or you prefer OSS technology:** 
  -  In Azure, [Azure Database for PostgreSQL](/azure/postgresql/overview) deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MySQL database service, or migrate MySQL workloads to the cloud.
  - Azure Database for PostgreSQL supports ANN vector index such as HNSW and IVFflat.
  - You can define multiple vector fields in single table.
  - You can create multiple vector indexes in single table with different ANN algorithm and similarity/distance calculation.
  - If you are using Azure Open AI Service, embedding feature is integrated and ready to use.
- **You have PostgreSQL already or you prefer OSS technology:** 
  -  In Azure, [Azure Database for PostgreSQL](/azure/postgresql/overview) deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MySQL database service, or migrate MySQL workloads to the cloud.
  - Azure Database for PostgreSQL supports ANN vector index such as HNSW and IVFflat.
  - You can define multiple vector fields in single table.
  - You can create multiple vector indexes in single table with different ANN algorithm and similarity/distance calculation.
  - If you are using Azure Open AI Service, embedding feature is already integrated and ready to use.
- **You have SQL Database already or you prefer SQL Server technology:** 
  - In Azure, you can have your workloads running in IaaS-based [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/) or on the PaaS-based [Azure SQL Database hosted service](/azure/azure-sql/database/sql-database-paas-overview). Choosing which option to use is primarily a question of whether you want to manage your database, apply patches, and take backups, or if you want to delegate these operations to Azure. In some scenarios, compatibility issues might require the use of IaaS-hosted SQL Server. For more information about how to choose the correct option for your workloads, see [Choose the right SQL Server option in Azure](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview).
- **Your application requires advanced search features with high quality:** 
  -  In Azure, [Azure AI Search](/azure/postgresql/overview) provides secure information retrieval at scale over user-owned content in traditional and generative AI search applications.
  - If you need to index ***unstructured data(e.g. images, docx, PDF and etc.)***, Azure AI search has ***skill set which can help collect insightfull metadata*** from them.
  - Azure AI Search supports ANN vector index such as HNSW and Exhaustive KNN.
  - You can define multiple vector fields in single index.
  - You can create multiple vector indexes in search index.
  - If you are using Azure ***Open AI Service, embedding feature is integrated and ready to use***.
  - ***Operational Cost can be higher*** than keeping vectore data in database systems
> [!NOTE]
> Learn more about how to assess database options for each of your applications or services in the [Azure application architecture guide](./data-store-overview.md).

### Common Vector Search Scenarios

The following table lists common use-scenario requirements and the recommended database services for handling them.

| If you want to | Use this database service|
|---|---|
| Perform advanced search operations (such as vector search, reranking) on text, images, and other content types. | [Azure AI Search]() |
| Integrate vector search with Azure OpenAI Service for vectorization out-of-the-box. | [Azure AI Search, Azure Cosmos DB for MongoDB]() |
| Store operational data and vector data in a same schema. | [Azure Cosmos DB for MongoDB]() |
| Insert/update/delete vector field very frequently and perform vector search for this data.| [Azure Cosmos DB for MongoDB, Azure Cosmos DB for PostgreSQL, Azure Database for PostgreSQL]() |
| Build generative application while maintaining existing SQL database for vector search. | [Azure SQL Database]() |


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
