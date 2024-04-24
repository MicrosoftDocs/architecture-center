---
title: Choose an Azure service for vector search
description: Use this information to decide which Azure service for vector search best suits your application.
author: konabuta
ms.author: yongl
ms.reviewer: krmeht
ms.service: architecture-center
ms.subservice: azure-guide
products: azure-machine-learning
categories: ai-machine-learning
ms.topic: product-comparison
ms.date: 03/28/2024
#customer intent: As an architect designing a generative AI application using vector search, I want to know the differences between Azure services for vector search so that I can select the most appropriate service for my workload.
---

# Choose an Azure service for vector search

Vector search is a method of finding information stored in a database in the shape of vectors. Vectors are groups of numbers that represent features or characteristics of media, for example text or images. It’s a significant advancement over traditional keyword-based search methods, offering faster and more accurate results by understanding the semantic relationships within the information.

Azure offers multiple ways to store and search vectorized data. This guide is written for architects and developers who need to understand and choose the right Azure service for vector search for their application.

This article compares the following services based on their vector search capabilities:

- [Azure AI Search](/azure/search/)
- [Azure Cosmos DB for MongoDB (vCore)](/azure/cosmos-db/mongodb/vcore/)
- [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/)
- [Azure Database for PostgreSQL](/azure/postgresql/)
- [Azure SQL Database](/azure/azure-sql/)

Architects and developers should compare the available services from the perspective of system requirements in the [Choose a candidate service](#choose-a-candidate-service) section and in the [Capability Matrix](#capability-matrix) section.

## Choose a candidate service

This section helps you select the most likely services for your needs. To narrow the choices, start by considering these system requirements.

### Key Requirements

![Vector Search Flow Chart](./images/vector-search-flow-chart.png "Vector Search Flow Chart")

- **You insert, update, or delete the values in vectorized fields frequently and the search result must always up to date with those changes:**
  - If your scenarios would benefit from keep vector data living directly with OLTP/operational data, you should **_keep vector fields in your existing database systems_**, which can be because of cost optimization or overhead of additional technology in the workload.
  - In these scenarios, you would choose the same **_RDBMS database or NoSQL database_** technology for vector store that your workload expects to use for its OLTP or non-relational store.
  - You can **_optimize search quality by developing and applying advanced search functions such as Re-Ranking or Hybrid Search yourself through SQL or Coding_**.
  - Typically, **_database operating costs are cheaper_** than search engine under the same condition.
  - **You have MongoDB already or you are familiar with MongoDB:**
    - If so, Azure Cosmos DB supports [MongoDB](/azure/cosmos-db/mongodb/introduction) and APIs to take advantage of the many benefits that Azure Cosmos DB offers, including Azure OpenAI Service integration and instantaneous scalability.
    - JSON(BSON) format is flexible to keep other relevant data along with vector fields.
    - Azure Cosmos DB for MongoDB vCore supports native ANN vector index such as "HNSW" and "IVFflat". Native ANN vector index allows you to get fast search performance even with a large amount of data.
    - **_Only one vector field and index is available_** per container.
  - **You have PostgreSQL already or you prefer OSS technology:**
    - Azure Database for PostgreSQL supports native ANN vector index such as "HNSW" and "IVFflat". Native ANN vector index allows you to get fast search performance even with a large amount of data.
    - You can define multiple vector fields in single table.
    - You can create multiple vector indexes in single table with different ANN algorithm and similarity/distance calculation.
    - If you're using Azure OpenAI Service, embedding feature is integrated and ready to use.
    - If you're considering multitenant SaaS apps, high throughput transactional app or if you need high performance distributed PostgreSQL with scale-out to multiple nodes, Azure Cosmos DB for PostgreSQL is the best choice.
  - **You have SQL Database already or you prefer SQL Server technology:**
    - In Azure, you can have your workloads running in IaaS-based [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/) or on the PaaS-based [Azure SQL Database hosted service](/azure/azure-sql/database/sql-database-paas-overview). Choosing which option to use is primarily a question of whether you want to manage your database, apply patches, and take backups, or if you want to delegate these operations to Azure. In some scenarios, compatibility issues might require the use of IaaS-hosted SQL Server. For more information about how to choose the correct option for your workloads, see [Choose the right SQL Server option in Azure](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview).
    - You already have data in SQL Database or SQL Server and **_you want to perform exact match searches on existing fields along with similarity search on vectors_**.
    - SQL Server **_doesn't support vector data type and native vector index_**.  An index can be created with the aid of external libraries like [Scikit Learn](https://github.com/Azure-Samples/azure-sql-db-vectors-kmeans) or [FAISS](https://github.com/Azure-Samples/azure-sql-db-vectors-faiss). You need to [unpivot vector data into a table with column store index](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).
    - Pure vector search performance **_can be slower on a large dataset(> 10M of vectors) compares to using native vector index_**.
> [!NOTE]
> Learn more about how to assess database options for each of your applications or services in the [Azure application architecture guide](./data-store-overview.md).
- **Your application requires 'advanced search features' such as Re-Ranking or Built-In Hybrid Search for higher accuracy and fast search results:**
  - In Azure, [Azure AI Search](/azure/postgresql/overview) provides information retrieval at scale over user-owned content in traditional and AI search scenarios.
  - If you need to index **_unstructured data(e.g. images, docx, PDF and etc.)_**, Azure AI search has **_skill set which can help collect insightful metadata_** from them.
  - Azure AI Search supports ANN vector index such as "HNSW" and "Exhaustive KNN".
  - You can define multiple vector fields in single index.
  - You can create multiple vector indexes in search index.
  - If you're using Azure **_OpenAI Service, embedding feature is integrated and ready to use_**.
  - AI Search provides excellent performance in relation to vector search and comes with features for high search result quality, but **_operating costs can be higher than databases under the same conditions_**.

## Capability Matrix
The following tables summarize the key differences in capabilities.

### Basic features

Native support for **vector data type**, **ANN vector index**, vector **dimension limit**, multiple vector fields and multiple vector indexes are sometimes different between the services. Your workload requirements might require some of these specific features.
Understand the basic vector features of each Azure service from the following table.


| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
| :----- | :---------- | :---------- | :---------- | :---------- | :---------- |
| Built-in vector search | Yes <a href="#a1"><sup>1</sup></a> | Yes <a href="#a2"><sup>2</sup></a> | Yes <a href="#a1"><sup>1</sup></a> | Yes <a href="#a3"><sup>3</sup></a> | No <a href="#a4"><sup>4</sup></a> |
| Vector data type | Yes | Yes | Yes | Yes | No <a href="#a5"><sup>5</sup></a> |
| Dimension limits <a href="#a6"><sup>6</sup></a> | 16,000 <a href="#a7"><sup>7</sup></a> or 2000 | 2,000                               | 16,000 <a href="#a7"><sup>7</sup></a> or 2000 | 3,072 | Unlimited |
| Multiple Vector Fields | Yes | No | Yes | Yes | N/A |
| Multiple Vector Indexes | Yes | No | Yes | Yes | N/A |

1. <span id="a1">"pgvector" supports vector search, which is the [extension of PostgreSQL](/azure/postgresql/flexible-server/how-to-use-pgvector).</span>
1. <span id="a2">[Use vector search on embeddings](/azure/cosmos-db/mongodb/vcore/vector-search) in Azure Cosmos DB for MongoDB vCore</span>
1. <span id="a3">Vectors in Azure AI Search</span>
1. <span id="a4">Vector search isn't provided as a first-class feature, but it can be implemented by [using columnstore indexes and functions for cosine similarity](https://devblogs.microsoft.com/azure-sql/vector-similarity-search-with-azure-sql-database-and-openai/)</span>
1. <span id="a5">Need to unpivot dimension(array) to table row. [Vectors are stored with columnstore index](https://devblogs.microsoft.com/azure-sql/vector-similarity-search-with-azure-sql-database-and-openai/).</span>
1. <span id="a6">Embedding models from OpenAI, 1536 for both text-embedding-ada-002 and text-embedding-3-small, and 3072 for text-embedding-3-large. For [Azure AI Vision multimodal embedding models](/azure/ai-services/computer-vision/concept-image-retrieval), 1024 for both image and text.</span>
1. <span id="a7">Vectors can have up to [16,000 dimensions](https://github.com/pgvector/pgvector?tab=readme-ov-file#vector-type). But index using "IVFFlat" and "HNSW" supports vectors with up to 2,000 dimensions.</span>

### Search methods

Workloads often need to combine vector search with full-text search or even a hybrid search (full text search or semantic search + vector search). The combination of hybrid search and reranking achieves high accuracy for workloads. You can manually implement hybrid search and re-ranking with your own code or you can consider how your vector store supports this workload requirement.

| Search method | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
| :---------- | :---------- | :---------- | :---------- | :---------- | :---------- |
| Full text search       | Yes <a href="#b1"><sup>1</sup></a> | Yes <a href="#b2"><sup>2</sup></a>  | Yes <a href="#b1"><sup>1</sup></a>   | Yes <a href="#b3"><sup>3</sup></a> | Yes <a href="#b4"><sup>4</sup></a> |
| Hybrid search | Yes <a href="#b5"><sup>5</sup></a>  | No                                  | Yes <a href="#b5"><sup>5</sup></a>    | Yes <a href="#b6"><sup>6</sup></a> | Yes <a href="#b7"><sup>7</sup></a>                                 |
| Built-in reranking | No | No | No | Yes <a href="#b8"><sup>8</sup></a> | No |

1. <span id="b1">PostgreSQL [Full Text Search](https://www.postgresql.org/docs/current/textsearch-intro.html)</span>
1. <span id="b2">[Search and query with text indexes](/azure/cosmos-db/mongodb/vcore/how-to-create-text-index) in Azure Cosmos DB for MongoDB vCore</span>
1. <span id="b3">Get Started with [Full-Text Search](/sql/relational-databases/search/get-started-with-full-text-search)</span>
1. <span id="b4">[Vector Data](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications) on SQL Server</span>
1. <span id="b5">Not provided as a first-class feature but [sample codes](https://github.com/pgvector/pgvector-python/blob/master/examples/hybrid_search_rrf.py) are provided.</span>
1. <span id="b6">[Hybrid search (combination of Full Text search, Vector search, and Semantic Ranking)](/azure/search/hybrid-search-how-to-query) is provided as a first-class feature.</span>
1. <span id="b7">Hybrid search [example](https://github.com/Azure-Samples/azure-sql-db-openai/blob/main/python/README.md) for Azure SQL database and SQL Server.</span>
1. <span id="b8">Reranking called [Semantic Ranking](/azure/search/semantic-search-overview) is a first-class feature for reranking the result of full text search and/or vector search.</span>

### Vector data indexing algorithms

Vector data indexing is the ability to efficiently store and retrieve vectors. This capability is important because indexing influences speed and accuracy of similarity searches and nearest neighbor queries on data sources.

Indexes are typically based on an Exhaustive K-nearest Neighbor (EKNN) or an artificial neural network (ANN) algorithm. 
EKNN does exhaustive search on all data points one by one and returns the accurate _K_ nearest neighbors. EKNN works in the milliseconds with small number of data but can cause latency for large amounts of data.

[Hierarchical Navigable Small World (HNSW)](https://en.wikipedia.org/wiki/Hierarchical_Navigable_Small_World_graphs) and [IVFflat](https://en.wikipedia.org/wiki/Nearest_neighbor_search) are ANN algorithm indexes. Selecting the appropriate indexing strategy involves a careful consideration of various factors such as the nature of the dataset, the specific requirements of the queries, and the available resources. IVFFlat is effective in environments where hardware resources are limited or query volumes aren't high, whereas HNSW excels in systems that require fast query responses and can adapt to changes in the dataset.

Understand what kinds of vector data indexing are provided from the following table.

| Indexing approach | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
|---|---|---|---|---|---|
| Exhaustive K-nearest Neighbor (EKNN) | Yes | Yes | Yes | Yes | Yes |
| Hierarchical Navigable Small World (HNSW) | Yes | Yes (preview)<a href="#e1"><sup>1</sup></a> | Yes | Yes | No |
| IVFflat | Yes | Yes | Yes | No | No |
| Other | - | Vector field limitation <a href="#e2"><sup>2</sup></a> </br> Vector index limitation <a href="#e3"><sup>3</sup></a> | - | - | No native vector index support<a href="#e4"><sup>4</sup></a> |

1. <span id="e1">[Azure Cosmos DB for MongoDB - Vector search overview](/azure/cosmos-db/mongodb/vcore/vector-search)</span>
1. <span id="e2">Only one vector field is available per container.</span>
1. <span id="e3">Only one vector index is available per container.</span>
1. <span id="e4">Azure SQL Database doesn't have vector data type. But you can store vectors into a column. Each row holds each element of vectors. Then you can use columnstore index to efficiently store and search for vectors.</span>

### Similarity and distance calculation capabilities

There are [Cosine Similarity](https://en.wikipedia.org/wiki/Cosine_similarity), [Dot Product](https://en.wikipedia.org/wiki/Dot_product) and [Euclidean Distance](https://en.wikipedia.org/wiki/Euclidean_distance) calculation methods for vector search. These methods are used to calculate the similarity between two vectors or the distance between two vectors.

Preliminary data analysis benefits from both metrics and Euclidean distances, which allow for the extraction of different insights on data structure, whereas text classification generally performs better under Euclidean distances, and retrieval of the most similar texts to a given text typically functions better with cosine similarity.

Azure OpenAI embeddings rely on cosine similarity to compute similarity between documents and a query.

| Built-in vector comparison calculation | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
| ---------------------------------------------- | ------------------------------ | ----------------------------------- | ------------------------------------ | --------------- | ------------------ |
| Cosine similarity                              | Yes                            | Yes                                 | Yes                                  | Yes             | Yes <a href="#e1"><sup>1</sup></a>                |
| Euclidean distance (L2 distance)   | Yes                            | Yes                                 | Yes                                  | Yes             | Yes <a href="#e1"><sup>1</sup></a>                 |
| Dot product                                    | Yes                            | Yes                                 | Yes                                  | Yes             | Yes <a href="#e1"><sup>1</sup></a>                 |

1. <span id="e1">Distance calculation [examples](https://github.com/Azure-Samples/azure-sql-db-openai/blob/main/distance-calculations-in-tsql.md) for Azure SQL database and SQL Server. </span>

### Integration with Azure OpenAI and other components

When implementing vector search, you can also consider linkage with other Microsoft components. For example, Azure OpenAI Service helps you to create vectors for your data and input queries for vector similarity search.  

| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database |
|---|---|---|---|---|---|
| Azure OpenAI Service - add your own data | No | Yes <a href="#g1"><sup>1</sup></a> | No | Yes <a href="#g2"><sup>2</sup></a>| No |
| Vector Embedding with Azure OpenAI | No | No | Yes <a href="#g3"><sup>3</sup></a>| Yes <a href="#g4"><sup>4</sup></a>| Yes <a href="#g5"><sup>5</sup></a> |
| Integration with Prompt flow | No | No | No | Yes <a href="#g6"><sup>6</sup></a>| No |
| Integration with Semantic Kernel | Yes <a href="#g7"><sup>7</sup></a> | Yes <a href="#g8"><sup>8</sup></a>| Yes <a href="#g7"><sup>7</sup></a>| Yes <a href="#g9"><sup>9</sup></a> | Yes <a href="#g10"><sup>10</sup></a> |

1. <span id="g1">Azure Cosmos DB for MongoDB (vCore) is [supported as a data source](/azure/ai-services/openai/concepts/use-your-data?tabs=mongo-db#supported-data-sources) for Azure OpenAI on Your Data.</span>
2. <span id="g2">Azure AI Search is [supported as a data source](/azure/ai-services/openai/concepts/use-your-data?tabs=mongo-db#supported-data-sources) for Azure OpenAI on Your Data.</span>
3. <span id="g3">[Azure AI Extension (preview)](/azure/postgresql/flexible-server/generative-ai-azure-openai) is available.</span>
4. <span id="g4">Azure AI Search provides a skill to vectorize the chunked text.</span>
5. <span id="g5">You can create [stored procedure for your embedding model deployment](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications)</span>
6. <span id="g6">Supported as a vector database in [Vector DB Lookup](https://microsoft.github.io/promptflow/reference/tools-reference/vector_db_lookup_tool.html#vector-db-lookup) tool.</span>
7. <span id="g7">Supported as a memory connector, and a vector database connector ([C#](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/src/Connectors/Connectors.Memory.Postgres)).</span>
8. <span id="g8">Supported as a vector database connector ([Python](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/memory/azure_cosmosdb)).</span>
9. <span id="g9">Supported as a memory connector, and a vector database connector ([C#](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/src/Connectors/Connectors.Memory.AzureAISearch), [Python](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/memory/azure_cognitive_search)).</span>
10. <span id="g10">Supported as a [memory connector](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Keita Onabuta](https://www.linkedin.com/in/keita-onabuta/) | Senior Customer Engineer
- [Gary Lee](https://www.linkedin.com/in/gary3207/) | Senior Customer Engineer

Other contributors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta/) | Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

[Implement knowledge mining with Azure AI Search](/training/paths/implement-knowledge-mining-azure-cognitive-search/). This learning path explores how to use Azure AI Search.

## Related resources

- [Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)
- [Technology choices for Azure solutions](/azure/architecture/guide/technology-choices/technology-choices-overview)
- [Vector database](/azure/cosmos-db/vector-database)

