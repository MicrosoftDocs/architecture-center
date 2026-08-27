---
title: Choose an Azure Service for Vector Search
description: Compare capabilities, indexing methods, and integration options to determine which Azure vector search service best fits your application.
author: miyamam
ms.author: miyamam
ms.date: 07/13/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure service for vector search

Vector search is a way to find information stored in a database in the shape of vectors. Vectors are groups of numbers that represent features or characteristics of media, such as text or images. They capture semantic relationships within the information, which enables similarity search beyond exact keyword matching.

Azure provides multiple ways to store and search vectorized data. This article helps you choose the right Azure vector search service for your applications.

This article compares the following services based on their vector search capabilities:

- [Azure AI Search](/azure/search/)
- [Azure Cosmos DB for NoSQL](/azure/cosmos-db/)
- [Azure DocumentDB](/azure/documentdb/overview)
- [Azure Database for PostgreSQL](/azure/postgresql/)
- [Azure Managed Redis](/azure/redis/)
- [Azure SQL Database](/azure/azure-sql/)

To compare the system requirements for each service, see [Choose a candidate service](#choose-a-candidate-service) and [Capability matrix](#capability-matrix).

## Choose a candidate service

This section helps you select the best service or services for your needs. To narrow the choices, start by considering the system requirements.

### Key requirements

:::image type="complex" border="false" source="./images/vector-search-flowchart.svg" alt-text="Flowchart that helps you choose the right Azure vector search service." lightbox="./images/vector-search-flowchart.svg":::
  Flowchart that helps you choose the right Azure vector search service. The flowchart asks if you frequently insert, update, or delete vector data, and need search results in real time or near real time. If you answer no, it asks two further questions about first-class hybrid search that uses semantic reranking, large-scale unstructured content indexing, cost optimization, and your existing database service. If cost optimization is a priority, or if you already operate a database service that supports vector search, the flowchart guides you to use your existing database service. If cost optimization isn't a priority, or if you don't currently operate a database service that supports vector search, the flowchart guides you to Azure AI Search. If you answer yes to the first question, the flowchart asks if you need ultra-low latency in-memory vector search, or if you already use Azure Managed Redis. If you answer yes, the flowchart guides you to use, or to continue using, Azure Managed Redis. If you answer no, the flowchart asks if you prefer to use a relational database management system (RDBMS). If you answer yes, the flowchart asks if your embeddings exceed 1,998 dimensions. If you answer yes, the flowchart asks if you need horizontal sharding for very large vector datasets. If you answer yes, the flowchart guides you to Azure Database for PostgreSQL with Elastic Clusters. If you answer no, the flowchart guides you to Azure Database for PostgreSQL. If your embeddings don't exceed 1,998 dimensions, the flowchart asks if you prefer Azure SQL Database or Azure Database for PostgreSQL, and guides you to either of these options based on your answer. If you don't prefer to use an RDBMS, the flowchart asks if you want to keep operational data and vector search in the same store, with hybrid search and built-in reranking. If you answer yes, the flowchart guides you to Azure Cosmos DB for NoSQL. If you answer no, the flowchart asks if you need vector dimensions up to 16,000, or MongoDB-compatible APIs. If you answer yes, the flowchart guides you to Azure DocumentDB. If you answer no, the flowchart guides you to Azure Cosmos DB for NoSQL.
:::image-end:::

To decide whether to use a traditional database solution or AI Search, consider your requirements and whether you can perform live or real-time vector searches on your data. If you frequently change values in vectorized fields, and if those changes need to be searchable in real time or near real time, a traditional relational or NoSQL database is the best fit for your scenario. Similarly, your existing database might be the best way to meet your performance target. However, if your workload doesn't require real-time or near-real-time vector searchability, and you can manage an index of vectors, you can use AI Search.

If you choose a traditional database solution, choose a database service based on your team's skill set and your existing databases. If you already use a database service, such as Azure Cosmos DB for NoSQL, that service might be the easiest solution for your scenario.

- Azure Cosmos DB for NoSQL is a good fit if you want to keep operational data and vector search in the same system and if you need full-text scoring, hybrid search, or built-in reranking.

- AI Search might be a good choice if your workload requires first-class hybrid search and semantic ranking.

- Azure Database for PostgreSQL supports horizontal scaling by using elastic clusters, a managed offering of the open-source Citus extension that supports horizontal sharding. This capability distributes vector data across multiple nodes, which can be useful for large vector datasets.

- Consider Azure Managed Redis when you need ultra-low-latency, in-memory vector search or when Redis is already deployed for caching or session management.

Each database service has [unique capabilities and limitations](#capability-matrix) for vector search. Check that your database type has the required functionality.

New services and extra database instances can increase cost and complexity. To reduce overhead, you can continue to use your existing design. Vector search in your current databases might be more cost effective than a dedicated vector search service. However, some advanced search features aren't available by default in traditional databases. For example, if you need reranking or hybrid search, you can implement these capabilities by using code, such as Transact-SQL (T-SQL).

## Capability matrix

The tables in this section summarize Azure vector search service capabilities. Compare the available services with your requirements. Some services are a better fit for specific scenarios, so consider the trade-offs shown in each table.

If you're working in Microsoft Fabric, you can use Real-Time Intelligence for vector similarity search (VSS) by using an eventhouse as a vector database. For more information, see the [Fabric documentation](/fabric/real-time-intelligence/vector-database).

### Basic features

Native support for vector data types, approximate nearest neighbor (ANN) vector indexes, vector dimension limits, multiple vector fields, and multiple vector indexes varies across services. Your workload might require one or more of these features.

The following table shows the vector capabilities of each Azure service.

| Capability | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL | Azure Managed Redis | AI Search | SQL Database |
| :---- | :--- | :--- | :--- | :--- | :--- | :--- |
| Built-in vector search | Yes | Yes<a href="#a1"><sup>1</sup></a> | Yes<a href="#a2"><sup>2</sup></a> | Yes<a href="#a3"><sup>3</sup></a> | Yes<a href="#a4"><sup>4</sup></a> | Yes |
| Vector data type | Yes | Yes | Yes | Yes | Yes | Yes<a href="#a5"><sup>5</sup></a> |
| Dimension limits<a href="#a6"><sup>6</sup></a> | 505<a href="#a7"><sup>7</sup></a> or 4,096 | 16,000<a href="#a8"><sup>8</sup></a>, 4,000, or 2,000, depending on the configuration | 16,000<a href="#a9"><sup>9</sup></a> or 2,000 | 32,768 | 4,096<a href="#a10"><sup>10</sup></a> | 1,998 <a href="#a11"><sup>11</sup></a> |
| Multiple vector fields | Yes | No | Yes | Yes | Yes | Yes |
| Multiple vector indexes | Yes | No | Yes | Yes | Yes | Yes |

1. <span id="a1">Azure DocumentDB supports vector search on embeddings.</span>
1. <span id="a2">`pgvector`, an extension of PostgreSQL, supports vector search. The `pg_diskann` extension offers DiskANN-based vector indexing for efficient ANN search at scale.</span>
1. <span id="a3">The [RediSearch module](/azure/redis/redis-modules) in Azure Managed Redis provides vector search.</span>
1. <span id="a4">AI Search supports vectors.</span>
1. <span id="a5">SQL Database supports a vector data type.</span>
1. <span id="a6">OpenAI embedding models include 1,536 dimensions for text-embedding-ada-002 and for text-embedding-3-small, and 3,072 dimensions for text-embedding-3-large. Azure Vision multimodal embedding models have 1,024 dimensions for both image and text.</span>
1. <span id="a7">Vectors indexed by using the flat index type can have up to 505 dimensions. Vectors indexed by using the quantizedFlat or DiskANN index type can have up to 4,096 dimensions.</span>
1. <span id="a8">You can index vectors up to 16,000 dimensions by using DiskANN and product quantization. Hierarchical navigable small world (HNSW) or IVFFlat with half-precision supports vector indexes of up to 4,000 dimensions. Without compression, the default maximum vector dimension for indexing is 2,000. For more information, see the [vector dimensions](/azure/documentdb/vector-search) for Azure DocumentDB.</span>
1. <span id="a9">Vectors can have up to 16,000 dimensions. However, indexing by using IVFFlat and HNSW algorithms supports vectors with up to 2,000 dimensions.</span>
1. <span id="a10">AI Search supports Matryoshka Representation Learning-based [dimension truncation](/azure/search/vector-search-how-to-truncate-dimensions). Text-embedding-3 models can reduce vector dimensions. For example, you can use 256 or 512 dimensions.</span>
1. <span id="a11">SQL Database supports a native vector data type with up to 1,998 dimensions.</span>

### Search methods

Workloads often need to combine vector search with full-text search or hybrid search. Hybrid search is a full-text search or semantic search combined with a vector search. When combined, hybrid search and reranking achieve high accuracy for workloads. You can manually implement hybrid search and reranking by using your own code, or you can consider how your vector store supports this workload requirement.

| Search method | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL | Azure Managed Redis | AI Search | SQL Database |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Full-text search | Yes<a href="#b12"><sup>12</sup></a> | Yes<a href="#b2"><sup>2</sup></a> | Yes<a href="#b3"><sup>3</sup></a> | Yes<a href="#b4"><sup>4</sup></a> | Yes | Yes<a href="#b5"><sup>5</sup></a> |
| Hybrid search | Yes<a href="#b6"><sup>6</sup></a> | Yes<a href="#b7"><sup>7</sup></a> | Yes<a href="#b8"><sup>8</sup></a> | Yes<a href="#b9"><sup>9</sup></a> | Yes<a href="#b10"><sup>10</sup></a> | Yes<a href="#b11"><sup>11</sup></a> |
| Built-in reranking | Yes | No | No | No | Yes<a href="#b1"><sup>1</sup></a> | No |

1. <span id="b1">Semantic ranking reranks results of full-text and vector searches.</span>
1. <span id="b2">Azure DocumentDB supports search and query by using text indexes.</span>
1. <span id="b3">PostgreSQL supports full-text search.</span>
1. <span id="b4">Azure Managed Redis supports full-text search by using the [RediSearch](/azure/redis/redis-modules#redisearch) module, including text tokenization, stemming, and ranking.</span>
1. <span id="b5">SQL Server supports full-text search.</span>
1. <span id="b6">Azure Cosmos DB for NoSQL supports hybrid search.</span>
1. <span id="b7">Azure DocumentDB natively supports hybrid search that combines full-text and vector search with reciprocal rank fusion.</span>
1. <span id="b8">Hybrid search isn't built in, but sample code is available.</span>
1. <span id="b9">Azure Managed Redis supports hybrid search by using VSS combined with attribute filtering on text, numeric, tag, and geo fields.</span>
1. <span id="b10">Hybrid search, which combines full-text search, vector search, and semantic ranking, is a feature in AI Search.</span>
1. <span id="b11">An example of hybrid search for SQL Database and SQL Server is available.</span>
1. <span id="b12">Azure Cosmos DB for NoSQL supports full-text search and full-text scoring.</span>

### Vector data indexing algorithms

Vector data indexing is the ability to efficiently store and retrieve vectors. Indexing influences the speed and accuracy of similarity searches and nearest neighbor queries on data sources.

Indexes typically use either an exhaustive k-nearest neighbor (Ek-NN) algorithm or an ANN algorithm. Ek-NN performs an exhaustive search on all data points and returns the accurate *k* nearest neighbors. When searching a small amount of data, Ek-NN works in milliseconds. For larger datasets, you might experience latency.

[DiskANN](https://www.microsoft.com/research/project/project-akupara-approximate-nearest-neighbor-search-for-large-scale-semantic-search/), [HNSW](https://wikipedia.org/wiki/Hierarchical_navigable_small_world), and [IVFFlat](https://wikipedia.org/wiki/Nearest_neighbor_search) are ANN algorithm indexes. Selecting the appropriate indexing strategy requires careful consideration of various factors such as the nature of the dataset, the specific requirements of the queries, and the available resources. DiskANN can adapt to change in the dataset and save computational resources. HNSW excels in systems that require fast query responses and can adapt to changes in the dataset. IVFFlat is effective in environments where hardware resources are limited or query volumes aren't high.

The following table shows the available vector data indexing types.

| Indexing approach | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL | Azure Managed Redis | AI Search | SQL Database |
| --- | --- | --- | --- | --- | --- | --- |
| DiskANN | Yes | Yes<a href="#c1"><sup>1</sup></a> | Yes<a href="#c2"><sup>2</sup></a> | No | No | Yes<a href="#c3"><sup>3</sup></a> |
| Ek-NN | Yes | Yes | Yes | Yes<a href="#c4"><sup>4</sup></a> | Yes | Yes |
| HNSW | No | Yes<a href="#c1"><sup>1</sup></a> | Yes | Yes<a href="#c5"><sup>5</sup></a> | Yes | No |
| IVFFlat | No | Yes | Yes | No | No | No |
| Other | Flat, quantizedFlat<a href="#c6"><sup>6</sup></a> | Vector field limitation,<a href="#c7"><sup>7</sup></a> <br> vector index limitation<a href="#c8"><sup>8</sup></a> | - | - | Scalar quantization, binary quantization<a href="#c9"><sup>9</sup></a> | - |

1. <span id="c1">For more information, see [Integrated vector store in Azure DocumentDB](/azure/documentdb/vector-search).</span>
1. <span id="c2">For more information, see [DiskANN for Azure Database for PostgreSQL](/azure/postgresql/extensions/how-to-use-pgdiskann).</span>
1. <span id="c3">Native DiskANN vector indexing is in preview. For more information, see [Vector search and vector indexes in the SQL Database Engine](/sql/sql-server/ai/vectors?view=azuresqldb-current&preserve-view=true).</span>
1. <span id="c4">Azure Managed Redis supports Ek-NN search by using the FLAT index type for brute-force search.</span>
1. <span id="c5">Azure Managed Redis supports HNSW for ANN search. For more information, see [VSS](/azure/redis/overview-vector-similarity).</span>
1. <span id="c6">For more information, see [Vector indexing policies](/azure/cosmos-db/vector-search#vector-indexing-policies).</span>
1. <span id="c7">Indexing applies to only one vector per path.</span>
1. <span id="c8">You can create only one index per vector path.</span>
1. <span id="c9">AI Search supports [scalar and binary quantization](/azure/search/vector-search-how-to-quantization) to reduce vector size in a search index.</span>

### Similarity and distance calculation capabilities

Vector search supports [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity), [dot product](https://en.wikipedia.org/wiki/Dot_product), and [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance) calculation methods. Use these methods to calculate the similarity or distance between two vectors.

Preliminary data analysis uses metrics and Euclidean distances so that you can extract a variety of data structure insights. Text classification generally performs better under Euclidean distances. Retrieval of the most similar texts to a given text typically functions better with cosine similarity.

Azure OpenAI embeddings rely on cosine similarity to compute similarity between documents and a query.

| Built-in vector comparison calculation | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL | Azure Managed Redis | AI Search | SQL Database |
| --- | --- | --- | --- | --- | --- | --- |
| Cosine similarity | Yes<a href="#e1"><sup>1</sup></a> | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> | Yes | Yes<a href="#e3"><sup>3</sup></a> |
| Euclidean distance | Yes<a href="#e1"><sup>1</sup></a> | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> | Yes | Yes<a href="#e3"><sup>3</sup></a> |
| Dot product | Yes<a href="#e1"><sup>1</sup></a> | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> | Yes | Yes<a href="#e3"><sup>3</sup></a> |

1. <span id="e1">For more information, see the [vector distance calculation](/cosmos-db/query/vectordistance) for Azure Cosmos DB for NoSQL.</span>
1. <span id="e2">Azure Managed Redis supports cosine similarity, Euclidean distance, and inner product distance metrics. For more information, see [VSS](/azure/redis/overview-vector-similarity).</span>
1. <span id="e3">For more information, see the [distance calculation examples](https://github.com/Azure-Samples/azure-sql-db-openai/blob/main/distance-calculations-in-tsql.md) for SQL Database and SQL Server.</span>

### Integration with Azure OpenAI and other components

You can link vector search to other Microsoft components. For example, Azure OpenAI helps you create vectors for your data and input queries for VSS.

| Capability | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL | Azure Managed Redis | AI Search | SQL Database |
| --- | --- | --- | --- | --- | --- | --- |
| Foundry IQ integration | No | No | No | No | Yes | No |
| Foundry Agent Service integration | Yes<a href="#g1"><sup>1</sup></a> | No | Yes<a href="#g2"><sup>2</sup></a> | Yes<a href="#g2"><sup>2</sup></a> | Yes<a href="#g3"><sup>3</sup></a> | Yes<a href="#g2"><sup>2</sup></a> |
| Integrated Azure OpenAI embedding generation | No | No | Yes<a href="#g4"><sup>4</sup></a> | No | Yes<a href="#g5"><sup>5</sup></a> | Yes<a href="#g6"><sup>6</sup></a> |
| Semantic Kernel integration | Yes<a href="#g7"><sup>7</sup></a> | Yes<a href="#g8"><sup>8</sup></a> | Yes<a href="#g9"><sup>9</sup></a> | Yes<a href="#g10"><sup>10</sup></a> | Yes<a href="#g11"><sup>11</sup></a> | Yes<a href="#g12"><sup>12</sup></a> |

1. <span id="g1">Foundry Agent Service integration is provided through agent state storage.</span>
1. <span id="g2">Foundry Agent Service integration is provided through data, vector search, or tool access.</span>
1. <span id="g3">Foundry Agent Service integration is provided through knowledge retrieval and vector search.</span>
1. <span id="g4">The [Azure AI extension](/azure/postgresql/azure-ai/generative-ai-azure-openai) is available.</span>
1. <span id="g5">AI Search includes a skill that vectorizes text chunks.</span>
1. <span id="g6">You can create a [stored procedure for your embedding model deployment](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).</span>
1. <span id="g7">This service is supported as a memory connector and a vector database connector. For more information, see the [C# documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-cosmosdb-nosql-connector?pivots=programming-language-csharp) and the [Python documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-cosmosdb-nosql-connector?pivots=programming-language-python).</span>
1. <span id="g8">This service is supported as a vector database connector. For more information, see the [C# documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/mongodb-connector?pivots=programming-language-csharp) and the [Python documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/mongodb-connector?pivots=programming-language-python).</span>
1. <span id="g9">This service is supported as a memory connector and a vector database connector. For more information, see the [C# documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/postgres-connector?pivots=programming-language-csharp).</span>
1. <span id="g10">This service is supported as a vector database connector. For more information, see [Using the Redis connector](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/redis-connector).</span>
1. <span id="g11">This service is supported as a memory connector and a vector database connector. For more information, see the [C# documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-ai-search-connector?pivots=programming-language-csharp) and the [Python documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-ai-search-connector?pivots=programming-language-python).</span>
1. <span id="g12">This service is supported as a memory connector.</span>

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Yu Saito](https://www.linkedin.com/in/yu-saito-192-profile/) | Solution Engineer
- [Miho Yamamoto](https://www.linkedin.com/in/mihoyamamoto/) | Senior Solution Engineer

Other contributor:

- [Keita Onabuta](https://www.linkedin.com/in/keita-onabuta/) | Senior Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Intelligent applications and AI](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications)
- [VSS by using Azure SQL and Azure OpenAI](/samples/azure-samples/azure-sql-db-openai/azure-sql-db-openai/)
- [Native vector support in Azure SQL and SQL Server](https://github.com/Azure-Samples/azure-sql-db-vector-search?tab=readme-ov-file)
- [Vector database in Azure Cosmos DB](/azure/cosmos-db/vector-database)
- [VSS in Azure Managed Redis](/azure/redis/overview-vector-similarity)
- [Vector search in Azure AI Search](/azure/search/vector-search-overview)
- [Vector search in Azure Cosmos DB for NoSQL](/azure/cosmos-db/vector-search)

## Related resources

- [Understand data models](../../data-guide/technology-choices/understand-data-store-models.md)
- [Technology choices for Azure solutions](./technology-choices-overview.md)
