---
title: Choose an Azure service for vector search
description: Learn how to use this information to decide which Azure service for vector search best suits your application.
author: konabuta
ms.author: keonabut
ms.reviewer: krmeht
ms.date: 01/10/2025
ms.update-cycle: 180-days
ms.subservice: architecture-guide
ms.topic: product-comparison
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure service for vector search

Vector search is a method of finding information stored in a database in the shape of vectors. Vectors are groups of numbers that represent features or characteristics of media, such as text or images. Vectors are a significant advancement over traditional keyword-based search methods. They offer faster, more accurate results by understanding the semantic relationships within the information.

Azure offers multiple ways to store and search vectorized data. This article helps architects and developers who need to understand and choose the right Azure service for vector search for their application.

This article compares the following services based on their vector search capabilities:

- [Azure AI Search](/azure/search/)
- [Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/)
- [Azure Cosmos DB for MongoDB (vCore)](/azure/cosmos-db/mongodb/vcore/)
- [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/)
- [Azure Database for PostgreSQL](/azure/postgresql/)
- [Azure SQL Database](/azure/azure-sql/)

Architects and developers should compare the available services from the perspective of system requirements in [Choose a candidate service](#choose-a-candidate-service) and in [Capability matrix](#capability-matrix).

## Choose a candidate service

This section helps you select the most likely services for your needs. To narrow the choices, start by considering the system requirements.

### Key requirements

:::image type="content" source="./images/vector-search-flow-chart.png" alt-text="A flow chart that helps you choose the right Azure service for vector search." lightbox="./images/vector-search-flow-chart.png" border="false":::

When deciding whether to use a traditional database solution or Azure AI Search service, consider your requirements and whether you can perform live or real-time vector searching on your data. A traditional relational or NoSQL database is the best fit for your scenario if you change values in vectorized fields frequently and the changes need to be searchable in real time or near real time. Likewise, using your existing database might be the best solution for you to meet your performance targets. On the other hand, if your workload doesn't require real-time or near real-time vector searchability, and you accept managing an index of vectors, AI Search can be a compelling choice.

If you choose a traditional database solution, the specific type of database service you decide to use mostly depends on your team's skill set and the databases that you currently operate. If you already use a specific type of database, like MongoDB for example, then using that same type of database might be the easiest solution for your scenario. As shown in the [Capability matrix](#capability-matrix) section, each database service has some unique capabilities and limitations for vector search. Review that information to ensure that your preferred database type supports the functionality you require.

If cost concerns are a driving factor, maintaining your existing design is likely the best fit for your scenario because introducing new services or other instances of a database service can add new net costs and complexity. Using your current databases for vector search likely affects your costs less than using a dedicated service.

If you choose to use a traditional database instead of AI Search, some advanced search features aren't available by default. For example, if you want to do reranking or hybrid search, enable that functionality through Transact-SQL (T-SQL) or other coding.

## Capability matrix

The tables in this section summarize the key differences in capabilities.

### Basic features

Native support for vector data types, approximate nearest neighbor (ANN) vector indexes, vector dimension limits, multiple vector fields, and multiple vector indexes are sometimes different between the services. Your workload requirements might require some of these specific features. Understand the basic vector features of each Azure service, as shown in the following table.

| Capability                                      | Azure Cosmos DB for PostgreSQL                | Azure Cosmos DB for NoSQL                 | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex)          | Azure AI Search                    | Azure SQL Database                           |
| :---------------------------------------------- | :-------------------------------------------- | :---------------------------------------- | :---------------------------------- | :-------------------------------------------- | :--------------------------------- | :------------------------------------------- |
| Built-in vector search                          | Yes <a href="#a1"><sup>1</sup></a>            | Yes                                       | Yes <a href="#a2"><sup>2</sup></a>  | Yes <a href="#a1"><sup>1</sup></a>            | Yes <a href="#a3"><sup>3</sup></a> | Yes <a href="#a4"><sup>4</sup></a>           |
| Vector data type                                | Yes                                           | Yes                                       | Yes                                 | Yes                                           | Yes                                | Yes <a href="#a9"><sup>9</sup></a>           |
| Dimension limits <a href="#a6"><sup>6</sup></a> | 16,000 <a href="#a7"><sup>7</sup></a> or 2000 | 505<a href="#a8"><sup>8</sup></a> or 4096 | 2,000                               | 16,000 <a href="#a7"><sup>7</sup></a> or 2000 | 3,072                              | 1998 (preview)<a href="#a5"><sup>5</sup></a> |
| Multiple vector fields                          | Yes                                           | Yes                                       | No                                  | Yes                                           | Yes                                | Yes                                          |
| Multiple vector indexes                         | Yes                                           | Yes                                       | No                                  | Yes                                           | Yes                                | Yes                                          |

1. <span id="a1">"pgvector" supports vector search, which is the [extension of PostgreSQL](/azure/postgresql/flexible-server/how-to-use-pgvector).</span>
1. <span id="a2">[Use vector search on embeddings](/azure/cosmos-db/mongodb/vcore/vector-search) in Azure Cosmos DB for MongoDB vCore</span>
1. <span id="a3">Vectors in Azure AI Search</span>
1. <span id="a4">Native vector search is available with Azure SQL Database [Early adopter preview](https://devblogs.microsoft.com/azure-sql/announcing-eap-native-vector-support-in-azure-sql-database/)</span>
1. <span id="a5">Vectors can be stored in a *VARBINARY(8000) column or variable*.</span>
1. <span id="a6">Embedding models from OpenAI, 1536 for both text-embedding-ada-002 and text-embedding-3-small, and 3072 for text-embedding-3-large. For [Azure AI Vision multimodal embedding models](/azure/ai-services/computer-vision/concept-image-retrieval), 1024 for both image and text.</span>
1. <span id="a7">Vectors can have up to [16,000 dimensions](https://github.com/pgvector/pgvector?tab=readme-ov-file#vector-type). But index using "IVFFlat" and "HNSW" supports vectors with up to 2,000 dimensions.</span>
1. <span id="a8">Vectors indexed with the flat index type can be at most 505 dimensions. Vectors indexed with the quantizedFlat or DiskANN index type can be at most 4,096 dimensions.</span>
1. <span id="a9">SQL Database [Vector Data Type](/sql/t-sql/data-types/vector-data-type)</span>

### Search methods

Workloads often need to combine vector search with full text search or even a hybrid search (full text search or semantic search plus vector search). The combination of hybrid search and reranking achieves high accuracy for workloads. You can manually implement hybrid search and reranking with your own code, or you can consider how your vector store supports this workload requirement.

| Search method      | Azure Cosmos DB for PostgreSQL     | Azure Cosmos DB for NoSQL | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search                    | Azure SQL Database                 |
| :----------------- | :--------------------------------- | :------------------------ | :---------------------------------- | :----------------------------------- | :--------------------------------- | :--------------------------------- |
| Full text search   | Yes <a href="#b1"><sup>1</sup></a> | Yes <a href="#b9"><sup>9</sup></a>   | Yes <a href="#b2"><sup>2</sup></a>  | Yes <a href="#b1"><sup>1</sup></a>   | Yes <a href="#b3"><sup>3</sup></a> | Yes <a href="#b4"><sup>4</sup></a> |
| Hybrid search      | Yes <a href="#b5"><sup>5</sup></a> | Yes <a href="#b10"><sup>10</sup></a> | No                                  | Yes <a href="#b5"><sup>5</sup></a>   | Yes <a href="#b6"><sup>6</sup></a> | Yes <a href="#b7"><sup>7</sup></a> |
| Built-in reranking | No                                 | Yes <a href="#b9"><sup>9</sup></a>   | No                                  | No                                   | Yes <a href="#b8"><sup>8</sup></a> | No                                 |

1. <span id="b1">PostgreSQL [Full Text Search](https://www.postgresql.org/docs/current/textsearch-intro.html)</span>
1. <span id="b2">[Search and query with text indexes](/azure/cosmos-db/mongodb/vcore/how-to-create-text-index) in Azure Cosmos DB for MongoDB vCore</span>
1. <span id="b3">Get started with [Full-Text Search](/sql/relational-databases/search/get-started-with-full-text-search)</span>
1. <span id="b4">[Vector data](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications) on SQL Server</span>
1. <span id="b5">Not provided as a first-class feature but [sample codes](https://github.com/pgvector/pgvector-python/blob/master/examples/hybrid_search/rrf.py) are provided.</span>
1. <span id="b6">[Hybrid search (combination of full text search, vector search, and semantic ranking)](/azure/search/hybrid-search-how-to-query) is provided as a first-class feature.</span>
1. <span id="b7">Hybrid search [example](https://github.com/Azure-Samples/azure-sql-db-openai/blob/main/python/README.md) for Azure SQL database and SQL Server.</span>
1. <span id="b8">Reranking called [Semantic Ranking](/azure/search/semantic-search-overview) is a first-class feature for reranking the result of full text search and/or vector search.</span>
1. <span id="b9">Cosmos DB NoSQL [Full Text Search with full text scoring](/azure/cosmos-db/gen-ai/full-text-search)</span>
1. <span id="b10">Cosmos DB NoSQL [Hybrid Search](/azure/cosmos-db/gen-ai/hybrid-search)</span>

### Vector data indexing algorithms

Vector data indexing is the ability to efficiently store and retrieve vectors. This capability is important because indexing influences speed and accuracy of similarity searches and nearest neighbor queries on data sources.

Indexes are typically based on an exhaustive k-nearest neighbor (Ek-NN) or an ANN algorithm. Ek-NN does an exhaustive search on all data points one by one and returns the accurate *K* nearest neighbors. Ek-NN works in milliseconds with a small amount of data but can cause latency for large amounts of data.

[DiskANN](https://www.microsoft.com/research/project/project-akupara-approximate-nearest-neighbor-search-for-large-scale-semantic-search/), [HNSW](https://wikipedia.org/wiki/Hierarchical_Navigable_Small_World_graphs) and [IVFFlat](https://wikipedia.org/wiki/Nearest_neighbor_search) are ANN algorithm indexes. Selecting the appropriate indexing strategy involves a careful consideration of various factors such as the nature of the dataset, the specific requirements of the queries, and the available resources. DiskANN can adapt to change in the dataset and save computational resources. HNSW excels in systems that require fast query responses and can adapt to changes in the dataset. IVFFlat is effective in environments where hardware resources are limited, or query volumes aren't high.

Understand what kinds of vector data indexing are provided from the following table.

| Indexing approach                         | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL                         | Azure Cosmos DB for MongoDB (vCore)                                                                                 | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database                                             |
| ----------------------------------------- | ------------------------------ | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | --------------- | -------------------------------------------------------------- |
| DiskANN                                   | Yes                            | Yes                                               | Yes (preview) <a href="#e2"><sup>2</sup></a>                                                                        | Yes <a href="#e1"><sup>1</sup></a>   | No              | No                                                             |
| Exhaustive K-nearest Neighbor (EKNN)      | Yes                            | Yes                                               | Yes                                                                                                                 | Yes                                  | Yes             | Yes                                                            |
| Hierarchical Navigable Small World (HNSW) | Yes                            | No                                                | Yes <a href="#e2"><sup>2</sup></a>                                                                                  | Yes                                  | Yes             | No                                                             |
| IVFflat                                   | Yes                            | No                                                | Yes                                                                                                                 | Yes                                  | No              | No                                                             |
| Other                                     | -                              | flat, quantizedFlat<a href="#e3"><sup>3</sup></a> | Vector field limitation <a href="#e4"><sup>4</sup></a> </br> Vector index limitation <a href="#e5"><sup>5</sup></a> | -                                    | -               | External libraries are available<a href="#e6"><sup>6</sup></a> |

1. <span id="e1">[DiskANN for Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server/how-to-use-pgdiskann)</span>
1. <span id="e2">[Azure Cosmos DB for MongoDB - Vector search overview](/azure/cosmos-db/mongodb/vcore/vector-search)</span>
1. <span id="e3">[Vector indexing policies](/azure/cosmos-db/nosql/vector-search#vector-indexing-policies)</span>
1. <span id="e4">Only one vector field is available per container.</span>
1. <span id="e5">Only one vector index is available per container.</span>
1. <span id="e6">Index can be created with the aid of external libraries like [Scikit Learn](https://github.com/Azure-Samples/azure-sql-db-vectors-kmeans) or [FAISS](https://github.com/Azure-Samples/azure-sql-db-vectors-faiss)</span>

### Similarity and distance calculation capabilities

There are [Cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity), [Dot product](https://en.wikipedia.org/wiki/Dot_product), and [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance) calculation methods for vector search. These methods are used to calculate the similarity between two vectors or the distance between two vectors.

Preliminary data analysis benefits from both metrics and Euclidean distances, which allow for the extraction of different insights on data structure, whereas text classification generally performs better under Euclidean distances. Retrieval of the most similar texts to a given text typically functions better with cosine similarity.

Azure OpenAI Service embeddings rely on cosine similarity to compute similarity between documents and a query.

| Built-in vector comparison calculation | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL         | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search | Azure SQL Database                 |
| -------------------------------------- | ------------------------------ | --------------------------------- | ----------------------------------- | ------------------------------------ | --------------- | ---------------------------------- |
| Cosine similarity                      | Yes                            | Yes<a href="#e1"><sup>1</sup></a> | Yes                                 | Yes                                  | Yes             | Yes <a href="#e2"><sup>2</sup></a> |
| Euclidean distance (L2 distance)       | Yes                            | Yes<a href="#e1"><sup>1</sup></a> | Yes                                 | Yes                                  | Yes             | Yes <a href="#e2"><sup>2</sup></a> |
| Dot product                            | Yes                            | Yes<a href="#e1"><sup>1</sup></a> | Yes                                 | Yes                                  | Yes             | Yes <a href="#e2"><sup>2</sup></a> |

1. <span id="e1">[Vector Distance Calculation](/azure/cosmos-db/nosql/query/vectordistance) for Azure Cosmos DB for NoSQL. </span>
1. <span id="e2">Distance calculation [examples](https://github.com/Azure-Samples/azure-sql-db-openai/blob/main/distance-calculations-in-tsql.md) for Azure SQL database and SQL Server.</span>

### Integration with Azure OpenAI and other components

When implementing vector search, you can also consider linking with other Microsoft components. For example, Azure OpenAI Service helps you create vectors for your data and input queries for vector similarity search.

| Capability                               | Azure Cosmos DB for PostgreSQL     | Azure Cosmos DB for NoSQL         | Azure Cosmos DB for MongoDB (vCore) | Azure Database for PostgreSQL (Flex) | Azure AI Search                      | Azure SQL Database                   |
| ---------------------------------------- | ---------------------------------- | --------------------------------- | ----------------------------------- | ------------------------------------ | ------------------------------------ | ------------------------------------ |
| Azure OpenAI Service - add your own data | No                                 | No                                | Yes <a href="#g1"><sup>1</sup></a>  | No                                   | Yes <a href="#g2"><sup>2</sup></a>   | No                                   |
| Vector embedding with Azure OpenAI       | No                                 | No                                | No                                  | Yes <a href="#g3"><sup>3</sup></a>   | Yes <a href="#g4"><sup>4</sup></a>   | Yes <a href="#g5"><sup>5</sup></a>   |
| Integration with Semantic Kernel         | Yes <a href="#g6"><sup>6</sup></a> | Yes<a href="#g7"><sup>7</sup></a> | Yes<a href="#g8"><sup>8</sup></a>   | Yes <a href="#g6"><sup>6</sup></a>   | Yes <a href="#g9"><sup>9</sup></a> | Yes <a href="#g10"><sup>10</sup></a> |

1. <span id="g1">Azure Cosmos DB for MongoDB (vCore) is [supported as a data source](/azure/ai-services/openai/concepts/use-your-data?tabs=mongo-db#supported-data-sources) for Azure OpenAI on Your Data.</span>
2. <span id="g2">Azure AI Search is [supported as a data source](/azure/ai-services/openai/concepts/use-your-data?tabs=mongo-db#supported-data-sources) for Azure OpenAI on Your Data.</span>
3. <span id="g3">[Azure AI Extension (preview)](/azure/postgresql/flexible-server/generative-ai-azure-openai) is available.</span>
4. <span id="g4">Azure AI Search provides a skill to vectorize the chunked text.</span>
5. <span id="g5">You can create a [stored procedure for your embedding model deployment](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).</span>
6. <span id="g6">Supported as a memory connector, and a vector database connector ([C#](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/src/Connectors)).</span>
7. <span id="g7">Supported as a memory connector, and a vector database connector ([C#](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/src/Connectors), [Python](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/memory_stores/azure_cosmosdb_no_sql)).</span>
8. <span id="g8">Supported as a vector database connector ([C#](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/src/Connectors), [Python](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/memory_stores/azure_cosmosdb)).</span>
9. <span id="g9">Supported as a memory connector, and a vector database connector ([C#](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/src/Connectors), [Python](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/memory_stores/azure_cognitive_search)).</span>
10. <span id="g10">Supported as a [memory connector](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).</span>

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Keita Onabuta](https://www.linkedin.com/in/keita-onabuta/) | Senior Customer Engineer
- [Gary Lee](https://www.linkedin.com/in/gary3207/) | Senior Customer Engineer

Other contributors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta/) | Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

[Implement knowledge mining with Azure AI Search](/training/paths/implement-knowledge-mining-azure-cognitive-search). This learning path explores how to use Azure AI Search.

## Related resources

- [Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)
- [Technology choices for Azure solutions](/azure/architecture/guide/technology-choices/technology-choices-overview)
- [Intelligent Application and AI](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications)
- [Vector similarity search with Azure SQL & Azure OpenAI](/samples/azure-samples/azure-sql-db-openai/azure-sql-db-openai/)
- [Native Vector Support in Azure SQL and SQL Server](https://github.com/Azure-Samples/azure-sql-db-vector-search?tab=readme-ov-file)
- [Vector database in Azure Cosmos DB](/azure/cosmos-db/vector-database)
- [Vector Search in Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/vector-search)
- [Azure Vector Database Samples](https://github.com/Azure-Samples/azure-vector-database-samples/)
