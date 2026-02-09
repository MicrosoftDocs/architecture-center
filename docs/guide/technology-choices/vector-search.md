---
title: Choose an Azure Service for Vector Search
description: Learn how to use this information to decide which Azure service for vector search best suits your application.
author: konabuta
ms.author: keonabut
ms.reviewer: saitoyu
ms.date: 10/20/2025
ms.update-cycle: 180-days
ms.subservice: architecture-guide
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure service for vector search

Vector search is a method of finding information stored in a database in the shape of vectors. Vectors are groups of numbers that represent features or characteristics of media, such as text or images. Vectors are a significant advancement over traditional keyword-based search methods. They provide faster, more accurate results by capturing and comparing semantic relationships within the information.

Azure provides multiple ways to store and search vectorized data. This article helps architects and developers who need to understand and choose the right Azure service for vector search for their application.

This article compares the following services based on their vector search capabilities:

- [Azure AI Search](/azure/search/)
- [Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/)
- [Azure DocumentDB](/azure/documentdb/overview)
- [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/)
- [Azure Database for PostgreSQL](/azure/postgresql/)
- [Azure SQL Database](/azure/azure-sql/)

Architects and developers should compare the available services from the perspective of system requirements in [Choose a candidate service](#choose-a-candidate-service) and in [Capability matrix](#capability-matrix).

## Choose a candidate service

This section helps you select the most likely services for your needs. To narrow the choices, start by considering the system requirements.

### Key requirements

:::image type="complex" border="false" source="./images/vector-search-flow-chart.svg" alt-text="A flow chart that helps you choose the right Azure service for vector search." lightbox="./images/vector-search-flow-chart.svg":::
  Flow chart that guides the selection of an Azure vector search service. The process begins by determining if vectors change frequently and require immediate reflection of updates. These decisions lead to appropriate database services: Azure Cosmos DB for PostgreSQL, Azure Database for PostgreSQL flexible server, Azure SQL Database, Azure Cosmos DB for NoSQL, or Azure DocumentDB, based on factors such as existing skills, relational versus NoSQL preference, and indexing needs. If no, it evaluates other criteria like cost, reuse of existing systems, advanced search features, and support for unstructured content or high-dimensional embeddings. This choice leads to Azure AI Search for scenarios that prioritize hybrid search, semantic ranking, or unstructured indexing. A side path refines database choices based on the relational database management system (RDBMS) preference, approximate nearest neighbor (ANN) indexing, large dimensions, or parallel processing. The flow concludes by grouping database services into solutions tailored to specific needs, such as Azure Cosmos DB for PostgreSQL, Azure Database for PostgreSQL flexible server, SQL Database, Azure Cosmos DB for NoSQL, Azure DocumentDB, and AI Search.
:::image-end:::

To decide whether to use a traditional database solution or Azure AI Search, consider your requirements and whether you can perform live or real-time vector searching on your data. A traditional relational or NoSQL database is the best fit for your scenario if you change values in vectorized fields frequently and the changes need to be searchable in real time or near real time. Similarly, the best solution for you to meet your performance target might be to use your existing database. However, if your workload doesn't require real-time or near real-time vector searchability, and you can manage an index of vectors, AI Search can be a good choice.

If you choose a traditional database solution, the specific type of database service that you decide to use mostly depends on your team's skill set and the databases that you currently operate. If you already use a specific type of database, like MongoDB for example, then using that same type of database might be the easiest solution for your scenario. As shown in the [Capability matrix](#capability-matrix) section, each database service has some unique capabilities and limitations for vector search. Review that information to ensure that your preferred database type supports the functionality that you require.

If cost concerns are a driving factor, maintaining your existing design is likely the best fit for your scenario because introducing new services or other instances of a database service can add new net costs and complexity. Using your current databases for vector search likely affects your costs less than using a dedicated service.

If you choose to use a traditional database instead of AI Search, some advanced search features aren't available by default. For example, if you want to do reranking or hybrid search, enable that functionality through Transact-SQL (T-SQL) or other coding.

## Capability matrix

The tables in this section summarize the key differences in capabilities.

### Basic features

Native support for vector data types, approximate nearest neighbor (ANN) vector indexes, vector dimension limits, multiple vector fields, and multiple vector indexes is sometimes different between the services. Your workload might depend on some of these specific features. Understand the basic vector features of each Azure service, which are shown in the following table.

| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL flexible server | AI Search | Azure SQL Database |
| :---- | :--- | :--- | :--- | :--- | :--- | :--- |
| Built-in vector search | Yes<a href="#a1"><sup>1</sup></a> | Yes | Yes<a href="#a2"><sup>2</sup></a> | Yes<a href="#a1"><sup>1</sup></a> | Yes<a href="#a3"><sup>3</sup></a> | Yes |
| Vector data type | Yes | Yes | Yes | Yes | Yes | Yes<a href="#a8"><sup>8</sup></a> |
| Dimension limits<a href="#a5"><sup>5</sup></a> | 16,000<a href="#a6"><sup>6</sup></a> or 2,000 | 505<a href="#a7"><sup>7</sup></a> or 4,096 | 16,000 | 16,000<a href="#a6"><sup>6</sup></a> or 2,000 | 4,096 | 1,998 (preview)<a href="#a4"><sup>4</sup></a> |
| Multiple vector fields | Yes | Yes | No | Yes | Yes | Yes |
| Multiple vector indexes | Yes | Yes | No | Yes | Yes | Yes |

1. <span id="a1">Support for vector search is provided by `pgvector`, which is an extension of PostgreSQL.</span>
1. <span id="a2">Vector search on embeddings is supported in Azure DocumentDB.</span>
1. <span id="a3">AI Search supports the use of vectors.</span>
1. <span id="a4">Vectors can be stored in a `VARBINARY(8000)` column or variable in SQL Database.</span>
1. <span id="a5">Embedding models from OpenAI include 1,536 dimensions for both text-embedding-ada-002 and text-embedding-3-small, and 3,072 dimensions for text-embedding-3-large. Azure AI Vision multimodal embedding models have 1,024 dimensions for both image and text.</span>
1. <span id="a6">Vectors can have up to 16,000 dimensions. However, indexing by using inverted file flat (IVFFlat) and hierarchical navigable small world (HNSW) algorithms supports vectors with a maximum of 2,000 dimensions.</span>
1. <span id="a7">Vectors indexed by using the flat index type can have a maximum of 505 dimensions. Vectors indexed by using the quantizedFlat or DiskANN index type can have a maximum of 4,096 dimensions.</span>
1. <span id="a8">SQL Database supports a vector data type.</span>

### Search methods

Workloads often need to combine vector search with full-text search or even a hybrid search, which is a full-text search or semantic search plus vector search. The combination of hybrid search and reranking achieves high accuracy for workloads. You can manually implement hybrid search and reranking by using your own code, or you can consider how your vector store supports this workload requirement.

| Search method | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL flexible server | AI Search | Azure SQL Database |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Full-text search | Yes<a href="#b1"><sup>1</sup></a> | Yes<a href="#b9"><sup>9</sup></a> | Yes<a href="#b2"><sup>2</sup></a> | Yes<a href="#b1"><sup>1</sup></a> | Yes<a href="#b3"><sup>3</sup></a> | Yes<a href="#b4"><sup>4</sup></a> |
| Hybrid search | Yes<a href="#b5"><sup>5</sup></a> | Yes<a href="#b11"><sup>11</sup></a> | Yes<a href="#b6"><sup>6</sup></a> | Yes<a href="#b5"><sup>5</sup></a> | Yes<a href="#b7"><sup>7</sup></a> | Yes<a href="#b8"><sup>8</sup></a> |
| Built-in reranking | No | Yes<a href="#b10"><sup>10</sup></a> | No | No | Yes<a href="#b9"><sup>9</sup></a> | No |

1. <span id="b1">PostgreSQL supports full-text search.</span>
1. <span id="b2">Azure DocumentDB supports search and query by using text indexes.</span>
1. <span id="b3">Full-text search is supported in SQL Server.</span>
1. <span id="b4">SQL Server supports vector data.</span>
1. <span id="b5">Hybrid search isn't provided as a first-class feature, but sample codes are available.</span>
1. <span id="b6">Hybrid search that combines full-text and vector search with reciprocal rank fusion (RRF) is natively supported in Azure DocumentDB.</span>
1. <span id="b7">Hybrid search, which combines full-text search, vector search, and semantic ranking, is provided as a first-class feature in Azure AI Search.</span>
1. <span id="b8">An example of hybrid search for Azure SQL Database and SQL Server is available.</span>
1. <span id="b9">Semantic ranking is a first-class feature that reranks the results of full-text and vector searches.</span>
1. <span id="b10">Cosmos DB NoSQL supports full-text search with full-text scoring.</span>
1. <span id="b11">Cosmos DB NoSQL supports hybrid search.</span>

### Vector data indexing algorithms

Vector data indexing is the ability to efficiently store and retrieve vectors. This capability is important because indexing influences speed and accuracy of similarity searches and nearest neighbor queries on data sources.

Indexes are typically based on an exhaustive k-nearest neighbor (Ek-NN) or an ANN algorithm. Ek-NN does an exhaustive search on all data points one by one and returns the accurate *k* nearest neighbors. Ek-NN works in milliseconds with a small amount of data but can cause latency for large amounts of data.

[DiskANN](https://www.microsoft.com/research/project/project-akupara-approximate-nearest-neighbor-search-for-large-scale-semantic-search/), [HNSW](https://wikipedia.org/wiki/Hierarchical_Navigable_Small_World_graphs), and [IVFFlat](https://wikipedia.org/wiki/Nearest_neighbor_search) are ANN algorithm indexes. Selecting the appropriate indexing strategy requires careful consideration of various factors such as the nature of the dataset, the specific requirements of the queries, and the available resources. DiskANN can adapt to change in the dataset and save computational resources. HNSW excels in systems that require fast query responses and can adapt to changes in the dataset. IVFFlat is effective in environments where hardware resources are limited or query volumes aren't high.

The following table shows the provided types of vector data indexing.

| Indexing approach | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL flexible server | AI Search | Azure SQL Database |
| --- | --- | --- | --- | --- | --- | --- |
| DiskANN | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> | Yes<a href="#e1"><sup>1</sup></a> | No | Yes<a href="#e3"><sup>3</sup></a> |
| E-kNN | Yes | Yes | Yes | Yes | Yes | Yes |
| HNSW | Yes | No | Yes<a href="#e2"><sup>2</sup></a> | Yes | Yes | No |
| IVFFlat | Yes | No | Yes | Yes | No | No |
| Other | - | Flat, quantizedFlat<a href="#e4"><sup>4</sup></a> | Vector field limitation<a href="#e5"><sup>5</sup></a> </br> Vector index limitation<a href="#e6"><sup>6</sup></a> | - | - | External libraries are available<a href="#e7"><sup>7</sup></a> |

1. <span id="e1">For more information, see [DiskANN for Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/how-to-use-pgdiskann).</span>
1. <span id="e2">For more information, see [Azure DocumentDB - Vector search overview](/azure/documentdb/vector-search).</span>
1. <span id="e3">DiskANN-based vector indexing is currently available in [private preview](https://devblogs.microsoft.com/azure-sql/announcing-general-availability-of-native-vector-type-functions-in-azure-sql/) for Azure SQL.</span>
1. <span id="e4">For more information, see [Vector indexing policies](/azure/cosmos-db/nosql/vector-search#vector-indexing-policies).</span>
1. <span id="e5">Only one vector field is available for each container.</span>
1. <span id="e6">Only one vector index is available for each container.</span>
1. <span id="e7">An index can be created by using external libraries like [Scikit Learn](https://github.com/Azure-Samples/azure-sql-db-vectors-kmeans) or [FAISS](https://github.com/Azure-Samples/azure-sql-db-vectors-faiss).</span>

### Similarity and distance calculation capabilities

There are [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity), [dot product](https://en.wikipedia.org/wiki/Dot_product), and [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance) calculation methods for vector search. These methods are used to calculate the similarity between two vectors or the distance between two vectors.

Preliminary data analysis benefits from both metrics and Euclidean distances, which allow for the extraction of different insights on data structure. Text classification generally performs better under Euclidean distances. Retrieval of the most similar texts to a given text typically functions better with cosine similarity.

Azure OpenAI embeddings rely on cosine similarity to compute similarity between documents and a query.

| Built-in vector comparison calculation | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL flexible server | AI Search | Azure SQL Database |
| --- | --- | --- | --- | ---| --- | --- |
| Cosine similarity | Yes  | Yes<a href="#e1"><sup>1</sup></a> | Yes | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> |
| Euclidean distance (L2 distance) | Yes | Yes<a href="#e1"><sup>1</sup></a> | Yes | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> |
| Dot product | Yes | Yes<a href="#e1"><sup>1</sup></a> | Yes | Yes | Yes | Yes<a href="#e2"><sup>2</sup></a> |

1. <span id="e1">For more information, see the [vector distance calculation](/azure/cosmos-db/nosql/query/vectordistance) for Azure Cosmos DB for NoSQL. </span>
1. <span id="e2">For more information, see the [distance calculation examples](https://github.com/Azure-Samples/azure-sql-db-openai/blob/main/distance-calculations-in-tsql.md) for Azure SQL Database and SQL Server.</span>

### Integration with Azure OpenAI and other components

When you implement vector search, you can also consider linking with other Microsoft components. For example, Azure OpenAI helps you create vectors for your data and input queries for vector similarity search.

| Capability | Azure Cosmos DB for PostgreSQL | Azure Cosmos DB for NoSQL | Azure DocumentDB | Azure Database for PostgreSQL flexible server | AI Search | Azure SQL Database |
| --- | --- | --- | --- | --- | --- | --- |
| Azure OpenAI - add your own data | No | No | Yes<a href="#g1"><sup>1</sup></a> | No | Yes<a href="#g2"><sup>2</sup></a> | No |
| Vector embedding with Azure OpenAI | No | No | No | Yes<a href="#g3"><sup>3</sup></a> | Yes<a href="#g4"><sup>4</sup></a> | Yes<a href="#g5"><sup>5</sup></a> |
| Integration with Semantic Kernel | Yes<a href="#g6"><sup>6</sup></a> | Yes<a href="#g7"><sup>7</sup></a> | Yes<a href="#g8"><sup>8</sup></a> | Yes<a href="#g6"><sup>6</sup></a> | Yes<a href="#g9"><sup>9</sup></a> | Yes<a href="#g10"><sup>10</sup></a> |

1. <span id="g1">Azure DocumentDB is [supported as a data source](/azure/ai-foundry/openai/concepts/use-your-data?tabs=mongo-db#supported-data-sources) for Azure OpenAI on your data.</span>
1. <span id="g2">AI Search is [supported as a data source](/azure/ai-foundry/openai/concepts/use-your-data?tabs=mongo-db#supported-data-sources) for Azure OpenAI on your data.</span>
1. <span id="g3">The [Azure AI extension](/azure/postgresql/flexible-server/generative-ai-azure-openai) is available.</span>
1. <span id="g4">AI Search provides a skill to vectorize the chunked text.</span>
1. <span id="g5">You can create a [stored procedure for your embedding model deployment](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).</span>
1. <span id="g6">This service is supported as both a memory connector and a vector database connector. For more information, see the [C# documentation](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/postgres-connector?pivots=programming-language-csharp).</span>
1. <span id="g7">This service is supported as both a memory connector and a vector database connector. Documentation is available for both [C#](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-cosmosdb-nosql-connector?pivots=programming-language-csharp) and [Python](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-cosmosdb-nosql-connector?pivots=programming-language-python).</span>
1. <span id="g8">This service is supported as a vector database connector. Documentation is available for both [C#](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/mongodb-connector?pivots=programming-language-csharp) and [Python](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-cosmosdb-nosql-connector?pivots=programming-language-python).</span>
1. <span id="g9">This service is supported as both a memory connector and a vector database connector. Documentation is available for both [C#](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-ai-search-connector?pivots=programming-language-csharp) and [Python](/semantic-kernel/concepts/vector-store-connectors/out-of-the-box-connectors/azure-ai-search-connector?pivots=programming-language-python).</span>
1. <span id="g10">This service is supported as a [memory connector](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).</span>

> [!IMPORTANT]
> Azure OpenAI On Your Data is deprecated.
>
> We recommend that you migrate Azure OpenAI On Your Data workloads to [Foundry Agent Service](/azure/ai-foundry/agents/overview) with [Foundry IQ](/azure/ai-foundry/agents/concepts/what-is-foundry-iq) to retrieve content and generate grounded answers from your data.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Keita Onabuta](https://www.linkedin.com/in/keita-onabuta/) | Senior Solution Engineer
- [Yu Saito](https://www.linkedin.com/in/yu-saito-192-profile/) | Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Implement knowledge mining by using AI Search](/training/paths/implement-knowledge-mining-azure-cognitive-search)
- [Intelligent application and AI](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications)
- [Vector similarity search by using Azure SQL and Azure OpenAI](/samples/azure-samples/azure-sql-db-openai/azure-sql-db-openai/)
- [Native vector support in Azure SQL and SQL Server](https://github.com/Azure-Samples/azure-sql-db-vector-search?tab=readme-ov-file)
- [Vector database in Azure Cosmos DB](/azure/cosmos-db/vector-database)
- [Azure vector database samples](https://github.com/Azure-Samples/azure-vector-database-samples/)

## Related resources

- [Understand data store models](./data-store-overview.md)
- [Technology choices for Azure solutions](./technology-choices-overview.md)
- [Vector search in Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/vector-search)
