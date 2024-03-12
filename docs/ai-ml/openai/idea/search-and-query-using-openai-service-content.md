This article describes how to use [Azure OpenAI Service](/azure/ai-services/openai/overview) or [Azure AI Search](/azure/search/search-what-is-azure-search) (formerly Azure Cognitive Search) to search documents in your enterprise data and retrieve results to provide a ChatGPT-style question and answer experience. This solution describes two approaches:

- **Embeddings approach:** Use the Azure OpenAI embedding model to create vectorized data. Vector search is a feature that significantly increases the semantic relevance of search results.

- **Azure AI Search approach**: Use [Azure AI Search](/azure/search/search-what-is-azure-search) to search and retrieve relevant text data based on a user query. This service supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search).

> [!NOTE]
> In Azure AI Search, the [semantic search](/azure/search/semantic-search-overview) and [vector search](/azure/search/vector-search-overview) features are currently in public preview.

## Architecture: Embedding approach

:::image type="content" source="_images/embedding-approach.svg" alt-text="Diagram that shows the embeddings approach." lightbox="_images/embedding-approach.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/search-and-query.vsdx) of this architecture.*

### Dataflow

Documents to be ingested can come from various sources, like files on an FTP server, email attachments, or web application attachments. These documents can be ingested to [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) via services like [Azure Logic Apps](/azure/logic-apps/logic-apps-overview), [Azure Functions](/azure/azure-functions/functions-scenarios), or [Azure Data Factory](/azure/data-factory/introduction). Data Factory is optimal for transferring bulk data.

Embedding creation:

1. The document is ingested into Blob Storage, and an Azure function is triggered to extract text from the documents.

1. If documents are in a non-English language and translation is required, an Azure function can call [Azure Translator](/azure/cognitive-services/translator/translator-overview) to perform the translation.

1. If the documents are PDFs or images, an Azure function can call [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) to extract the text. If the document is an Excel, CSV, Word, or text file, python code can be used to extract the text.

1. The extracted text is then [chunked](/azure/search/vector-search-how-to-chunk-documents) appropriately, and an [Azure OpenAI embedding model](/azure/cognitive-services/openai/concepts/models#embeddings-models) is used to convert each chunk to embeddings.

1. These embeddings are persisted to the vector database. This solution uses the Enterprise tier of [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview#service-tiers), but any vector database can be used.

Query and retrieval:

1. The user sends a query via a user application.

1. The Azure OpenAI embedding model is used to convert the query into vector embeddings.

1. A vector similarity search that uses this query vector in the vector database returns the top *k* matching content. The matching content to be retrieved can be set according to a threshold that’s defined by a similarity measure, like cosine similarity.

1. The top *k* retrieved content and the [system prompt](/azure/ai-services/openai/concepts/system-message) are sent to the Azure OpenAI language model, like [GPT-3.5 Turbo or GPT-4](/azure/cognitive-services/openai/how-to/chatgpt).

1. The search results are presented as the answer to the search query that was initiated by the user, or the search results can be used as [the grounding data](/azure/cognitive-services/openai/concepts/advanced-prompt-engineering#provide-grounding-context) for a multi-turn conversation scenario.

## Architecture: Azure AI Search pull approach

:::image type="content" source="_images/pull-approach.svg" alt-text="Diagram that shows the pull approach." lightbox="_images/pull-approach.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/search-and-query.vsdx) of this architecture.*

Index creation:

1. [Azure AI Search](/azure/search/search-what-is-azure-search) is used to create a [search index](/azure/search/search-how-to-create-search-index) of the documents in Blob Storage. Azure AI Search [supports Blob Storage](/azure/search/search-indexer-overview#supported-data-sources), so the pull model is used to crawl the content, and the capability is implemented via [indexers](/azure/search/search-indexer-overview).

   > [!NOTE]
   > Azure AI Search supports other [data sources](/azure/search/search-data-sources-gallery) for indexing when using the pull model. Documents can also be indexed from [multiple data sources](/azure/search/tutorial-multiple-data-sources) and consolidated into a single index.

1. If certain scenarios require translation of documents, [Azure Translator](/azure/search/cognitive-search-skill-text-translation) can be used, which is a feature that's included in the built-in skill.

1. If the documents are nonsearchable, like scanned PDFs or images, AI can be applied by using [built-in](/azure/search/cognitive-search-predefined-skills) or [custom](/azure/search/cognitive-search-custom-skill-interface) skills as skillsets in Azure AI Search. Applying AI over content that isn't full-text searchable is called [AI enrichment](/azure/search/cognitive-search-concept-intro). Depending on the requirement, [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) can be used as a custom skill to extract text from PDFs or images via [document analysis models](/azure/ai-services/document-intelligence/overview#document-analysis-models), [prebuilt models](/azure/ai-services/document-intelligence/overview#prebuilt-models), or [custom extraction](/azure/ai-services/document-intelligence/overview#custom-models) models.

   If AI enrichment is a requirement, pull model (indexers) must be used to load an index.

   If vector fields are added to the index schema, which loads the vector data for indexing, vector search can be enabled by [indexing that vector data](/azure/search/vector-search-how-to-create-index). Vector data can be generated via Azure OpenAI embeddings.

Query and retrieval:

1. A user sends a query via a user application.

1. The query is passed to Azure AI Search via the [search documents REST API](/rest/api/searchservice/search-documents). The query type can be [simple](/azure/search/search-query-simple-examples), which is optimal for full-text search, or [full](/azure/search/search-query-lucene-examples), which is for advanced query constructs like regular expressions, fuzzy and wild card search, and proximity search. If the query type is set to semantic, a [semantic search](/azure/search/semantic-search-overview) is performed on the documents, and the relevant content is retrieved. Azure AI Search also supports [vector search](/azure/search/vector-search-overview) and [hybrid search](/azure/search/vector-search-ranking#hybrid-search), which requires the user query to be converted to vector embeddings.

1. The retrieved content and the system prompt are sent to the Azure OpenAI language model, like [GPT-3.5 Turbo or GPT-4](/azure/cognitive-services/openai/how-to/chatgpt).

1. The search results are presented as the answer to the search query that was initiated by the user, or the search results can be used as [the grounding data](/azure/cognitive-services/openai/concepts/advanced-prompt-engineering#provide-grounding-context) for a multi-turn conversation scenario.

## Architecture: Azure AI Search push approach

If the data source isn't supported, you can use the [push model](/azure/search/tutorial-optimize-indexing-push-api) to upload the data to Azure AI Search.

:::image type="content" source="_images/push-approach.svg" alt-text="Diagram that shows the push approach." lightbox="_images/push-approach.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/search-and-query.vsdx) of this architecture.*

Index creation:

1. If the document to be ingested must be translated, [Azure Translator](/azure/ai-services/translator/translator-overview) can be used.
1. If the document is in a nonsearchable format, like a PDF or image, [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) can be used to extract text.
1. The extracted text can be vectorized via Azure OpenAI embeddings [vector search](/azure/search/vector-search-overview), and the data can be pushed to an Azure AI Search index via a [Rest API](/rest/api/searchservice/AddUpdate-or-Delete-Documents) or an [Azure SDK](/azure/search/search-get-started-text).

Query and retrieval:

The query and retrieval in this approach is the same as the pull approach earlier in this article.

### Components

- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service-b) provides REST API access to Azure OpenAI's language models including the GPT-3, Codex, and the embedding model series for content generation, summarization, semantic search, and natural language-to-code translation. Access the service by using a REST API, Python SDK, or the web-based interface in the [Azure OpenAI Studio](https://oai.azure.com).

- [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence) is an [Azure AI service](https://azure.microsoft.com/products/ai-services). It offers document analysis capabilities to extract printed and handwritten text, tables, and key-value pairs. Azure AI Document Intelligence provides prebuilt models that can extract data from invoices, documents, receipts, ID cards, and business cards. You can also use it to train and deploy custom models by using a [custom template](/azure/ai-services/document-intelligence/concept-custom-template) form model or a [custom neural](/azure/ai-services/document-intelligence/concept-custom-neural) document model.

- [Document Intelligence Studio](https://formrecognizer.appliedai.azure.com/studio) provides a UI for exploring Azure AI Document Intelligence features and models, and for building, tagging, training, and deploying custom models.

- [Azure AI Search](https://azure.microsoft.com/services/search) is a cloud service that provides infrastructure, APIs, and tools for searching. Use Azure AI Search to build search experiences over private disparate content in web, mobile, and enterprise applications.

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for various languages, such as .NET, Node.js, and Python. Applications can access files in Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) to support cost optimization for storing large amounts of data.

- The Enterprise tier of [Azure Cache for Redis](https://azure.microsoft.com/products/cache) provides managed [Redis Enterprise modules](/azure/azure-cache-for-redis/cache-redis-modules#scope-of-redis-modules), like RediSearch, RedisBloom, RedisTimeSeries, and RedisJSON. Vector fields allow vector similarity search, which supports real-time vector indexing (brute force algorithm (FLAT) and hierarchical navigable small world algorithm (HNSW)), real-time vector updates, and k-nearest neighbor search. Azure Cache for Redis brings a critical low-latency and high-throughput data storage solution to modern applications.

### Alternatives

Depending on your scenario, you can add the following workflows.

- Use the [Azure AI Language](/azure/ai-services/language-service/overview) features, [question answering](/azure/ai-services/language-service/question-answering/overview) and [conversational language understanding](/azure/ai-services/language-service/conversational-language-understanding/overview), to build a natural conversational layer over your data. These features find appropriate answers for the input from your custom knowledge base of information.

- To create vectorized data, you can use any embedding model. You can also use the [Azure AI services Vision image retrieval API](/azure/ai-services/computer-vision/how-to/image-retrieval) to vectorize images. This tool is available in private preview.

- Use the [Durable Functions extension](/azure/azure-functions/durable/durable-functions-overview) for [Azure Functions](/azure/azure-functions/create-first-function-vs-code-python) as a code-first integration tool to perform text-processing steps, like reading handwriting, text, and tables, and processing language to extract entities on data based on the size and scale of the workload.

- You can use any database for persistent storage of the extracted embeddings, including:

  - [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
  - [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db)
  - [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
  - [Azure Database for MySQL](https://azure.microsoft.com/services/mysql)

## Scenario details

Manual processing is increasingly time-consuming, error-prone, and resource-intensive due to the sheer volume of documents. Organizations that handle huge volumes of documents, largely unstructured data of different formats like PDF, Excel, CSV, Word, PowerPoint, and image formats, face a significant challenge processing scanned and handwritten documents and forms from their customers.

These documents and forms contain critical information, such as personal details, medical history, and damage assessment reports, which must be accurately extracted and processed.

Organizations often already have their own knowledge base of information, which can be used for answering questions with the most appropriate answer. You can use the services and pipelines described in these solutions to create a source for search mechanisms of documents.

### Potential use cases

This solution provides value to organizations in industries like pharmaceutical companies and financial services. It applies to any company that has a large number of documents with embedded information. This AI-powered end-to-end search solution can be used to extract meaningful information from the documents based on the user query to provide a ChatGPT-style question and answer experience.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- Dixit Arora | Senior Customer Engineer, ISV DN CoE
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Principal Customer Engineer, ISV DN CoE

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure AI Document Intelligence?](/azure/ai-services/document-intelligence/overview)
- [What is Azure OpenAI?](/azure/ai-services/openai/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure AI Language?](/azure/ai-services/language-service/overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure QnA Maker client library](/azure/ai-services/qnamaker/quickstarts/quickstart-sdk)
- [Create, train, and publish your QnA Maker knowledge base](/azure/ai-services/qnamaker/quickstarts/create-publish-knowledge-base)
- [What is question answering?](/azure/ai-services/language-service/question-answering/overview)

## Related resources

- [Query-based document summarization](../../guide/query-based-summarization.md)
- [Automate document identification, classification, and search by using Durable Functions](../../architecture/automate-document-classification-durable-functions.yml)
- [Index file content and metadata by using Azure AI Search](../../architecture/search-blob-metadata.yml)
- [AI enrichment with image and text processing](../../../solution-ideas/articles/cognitive-search-with-skillsets.yml)
