This article shows how you can use [Azure OpenAI Service](/azure/ai-services/openai/overview) to enable searching documents over your own enterprise data (largely unstructured data of different formats pdf, image, excel, csv, docx, and pptx) and using the results to provide the context for a QnA and ChatGPT-style experience. This solution describes two approaches:

- **Embeddings approach:** Azure OpenAI embedding model is used to create vectorized data. Vector search is a proven technique for significantly increasing the semantic relevance of search results.

- **Azure Cognitive Search approach**: [Azure Cognitive Search](/azure/search/search-what-is-azure-search) is used to search and retrieve relevant data (text) based on the user query. This search service supports [full text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview) and [hybrid search](/azure/search/vector-search-ranking#hybrid-search).

> [!NOTE]
> In Azure Cognitive Search, [semantic search](/azure/search/semantic-search-overview) and [vector search](/azure/search/vector-search-overview) are currently in public preview.

## Embeddings approach architecture

:::image type="content" source="{source}" alt-text="{alt-text}" lightbox="" border="false":::

### Workflow

Documents can be ingested from multiple sources like files in FTP Server, attachments from emails or web applications. These documents can be ingested to [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) using orchestrators like [Logic Apps](/azure/logic-apps/logic-apps-overview), [Azure functions](/azure/azure-functions/functions-scenarios) or [Azure Data Factory](/azure/data-factory/introduction) (especially for bulk movement).

Embedding creation:

1. As soon as the document lands in Azure Blob Storage, an Azure Function is triggered to extract text from the documents.

2. If documents are in languages other than English and translation is required, [Azure Translator](/azure/cognitive-services/translator/translator-overview) can be called by the Azure function to perform that translation.

3. If the documents are PDFs or images, the Azure function can call [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) to extract the text. If the document is an Excel /csv /word/text file, simple python code can be used to extract the text.

4. The extracted text is then [chunked](/azure/search/vector-search-how-to-chunk-documents) appropriately, and each chunk is converted to embeddings using [Azure openAI embeddings](/azure/cognitive-services/openai/concepts/models#embeddings-models).

5. These embeddings are persisted to the vector database. In this solution, [Azure cache for Redis Enterprise](/azure/azure-cache-for-redis/cache-redis-modules) is used, however, any vector database can be used.

Query and retrieval:

1. The user sends a query through the user application.

2. The query is converted into vector embeddings using the Azure OpenAI Embeddings model.

3. A vector similarity search using this query vector in the vector database will return the top "k" matching content. The amount of matching content to be retrieved can also be set according to the threshold defined by the similarity measure like Cosine Similarity.

4. The top k retrieved content is sent to the Azure OpenAI models, like [GPT-3.5 Turbo or GPT-4)](/azure/cognitive-services/openai/how-to/chatgpt), along with the [system prompt](/azure/ai-services/openai/concepts/system-message).

5. The search results will be served as the answer to the search query initiated by the user or can serve as [the grounding data](/azure/cognitive-services/openai/concepts/advanced-prompt-engineering#provide-grounding-context) for the multiturn conversation scenario.

## Azure Cognitive Search: Pull approach architecture

:::image type="content" source="{source}" alt-text="{alt-text}" lightbox="" border="false":::

Index creation:

1. In this flow, [a search index](/azure/search/search-how-to-create-search-index) will be created in [Azure Cognitive Search](/azure/search/search-what-is-azure-search) on the documents in the Azure Blob Storage. Since Azure Blob Storage is a [source supported](/azure/search/search-indexer-overview#supported-data-sources) by Azure Cognitive Search, the content will be crawled using the ["pull" model](/azure/search/search-indexer-overview) and the capability is implemented through [indexers](/azure/search/search-indexer-overview).

> *note that there are multiple additional [data sources](/azure/search/search-data-sources-gallery) that are supported by Azure Cognitive Search for indexing using the pull model. It is also possible to index documents from [multiple data sources](/azure/search/tutorial-multiple-data-sources) into a single consolidated index.*
>
> If the documents are non-searchable, like scanned PDF's or Images, then AI can be applied with the help of [built-in](/azure/search/cognitive-search-predefined-skills) or [custom](/azure/search/cognitive-search-custom-skill-interface) skills as skillsets in Azure Cognitive Search which is termed as [AI Enrichment](/azure/search/cognitive-search-concept-intro). [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) can be added as a custom skill to extract text from PDF's or images using different [document analysis models](/azure/ai-services/document-intelligence/overview#document-analysis-models), [prebuilt models](/azure/ai-services/document-intelligence/overview) or [custom extraction](/azure/ai-services/document-intelligence/overview) models depending on the requirement. If certain scenarios require translation of documents (*e.g*. to English), then [Azure Translator](/azure/search/cognitive-search-skill-text-translation) can be used, which is a part of the built-in skill. If AI enrichment is a requirement, then pull model (indexers) must be used to load an index.
>
> Additionally, *vector* *search* can be enabled by [indexing the vector data,](/azure/search/vector-search-how-to-create-index) where vector fields are added to index schema and subsequently load the vector data for indexing. Vector data can be generated using Azure OpenAI embeddings.

Query and retrieval:

1. User sends a query through the user application.

2. The query is passed to Azure Cognitive Search through the [Search Documents](/rest/api/searchservice/search-documents) Rest API where the query type can be [simple](/azure/search/search-query-simple-examples) (optimal for full text search) or [full](/azure/search/search-query-lucene-examples) (for advanced query constructs like regular expressions, fuzzy and wild card search and proximity search). If the query type is set to "semantic", then [semantic search](/azure/search/semantic-search-overview) is done on the documents and retrieves the relevant content. Since Azure Cognitive Search also supports [vector search](/azure/search/vector-search-overview) and [hybrid search](/azure/search/vector-search-ranking#hybrid-search) to retrieve the relevant content, where the user query also must be converted to vector embeddings.

3. The retrieved content will be sent to the Azure OpenAI language models, like [GPT-3.5 or GPT-4](/azure/cognitive-services/openai/how-to/chatgpt), along with the system prompt.

4. The search results will be served as the answer to the search query or can serve as the [grounding data](/azure/cognitive-services/openai/concepts/advanced-prompt-engineering#provide-grounding-context) for a multiturn conversation scenario.

## Azure Cognitive Search: Push approach architecture

:::image type="content" source="{source}" alt-text="{alt-text}" lightbox="" border="false":::

Index creation:

1. Alternatively, if the data source is not of the supported type, you may also use the ["push" mode](/azure/search/tutorial-optimize-indexing-push-api)l to upload the data to [Azure Cognitive Search](/azure/search/search-what-is-azure-search). If the document must be translated, then [Azure Translator](/azure/ai-services/translator/translator-overview) can be used to translate or if the document is in unsearchable formats like pdf or image then [Azure AI Document Intelligence services](/azure/ai-services/document-intelligence/overview) can be used to extract text. The extracted text can also be vectorized using Azure OpenAI embeddings [Vector Search](/azure/search/vector-search-overview) and the data can be pushed to Azure Cognitive Search index using [Rest API](/rest/api/searchservice/AddUpdate-or-Delete-Documents) or [Azure SDKs](/azure/search/search-get-started-text).

Query and retrieval:

The query and retrieval in this approach is the same as in the case of pull approach above.

### Components

- [Azure OpenAI](/azure/ai-services/openai/overview) provides REST API access to Azure OpenAI's powerful language models including the GPT-3, Codex, and the embeddings model series for content generation, summarization, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the [Azure OpenAI Studio](https://oai.azure.com).

- [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence), part of [Azure AI services](https://azure.microsoft.com/products/ai-services), has in-built document analysis capabilities to extract printed and handwritten text, tables, and key-value pairs. Form Recognizer has prebuilt models for extracting data from invoices, documents, receipts, ID cards, and business cards. Form Recognizer can also train and deploy custom models by using either a [custom template](/azure/applied-ai-services/form-recognizer/concept-custom-template) form model or a [custom neural](/azure/applied-ai-services/form-recognizer/concept-custom-neural) document model.

> [Document Intelligence Studio](https://formrecognizer.appliedai.azure.com/studio) provides a UI for exploring Azure AI Document Intelligence features and models, and for building, tagging, training, and deploying custom models.

- [Azure Cognitive Search](https://azure.microsoft.com/services/search) is a cloud search service that supplies infrastructure, APIs, and tools for searching. You can use Azure Cognitive Search to build search experiences over private, heterogeneous content in web, mobile, and enterprise applications.

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for multiple languages, such as .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) to support cost optimization for storing large amounts of data.

- [Azure Cache for Redis: Enterprise tier](https://azure.microsoft.com/products/cache) provides managed [Redis Enterprise modules](/azure/azure-cache-for-redis/cache-redis-modules#scope-of-redis-modules) like RedisSearch, RedisBloom, RedisTimeSeries, RedisJson on Azure. Vector fields allow Vector similarity search which supports real-time vector indexing (FLAT --Brut Force Algorithm and Hierarchical Navigable Small World algorithm- HNSW), real-time vector updates and K-Nearest Neighbour search. Redis brings a critical low-latency and high-throughput data storage solution to modern applications.

### Alternatives

Depending on your scenario, you can add the following workflows.

- You can use [question answering](/azure/ai-services/language-service/question-answering/overview) and [conversational language understanding](/azure/ai-services/language-service/conversational-language-understanding/overview) which are available as part of [Azure AI Language](/azure/ai-services/language-service/overview) for building natural conversational layer over your data. It is used to find the most appropriate answer for any input from your custom knowledge base (KB) of information.

- To create vectorized data, you can use any embedding model. You can also use [Azure AI services Vision image retrieval API](/azure/ai-services/computer-vision/how-to/image-retrieval) for images which is in private preview.

- You can use durable function extension of [Azure Functions](/azure/azure-functions/create-first-function-vs-code-python) as a code-first integration tool to do text processing steps like read handwriting, text, tables, and process language to extract entities on extracted data depending on the size and scale of the workload.

- You can use any database for persistent storage of the extracted embeddings, including:

  - [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)

  - [Azure Cosmos DB](/azure/cosmos-db/introduction)

  - [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)

  - [Azure Database for MySQL](https://azure.microsoft.com/services/mysql)

## Scenario details

Manual processing has become increasingly time-consuming, error-prone, and resource-intensive due to the sheer volume of documents. So, organizations that deal with huge volumes of documents are facing a significant challenge in processing scanned and handwritten documents and forms received from their customers.

These documents and forms contain a vast amount of critical information, such as personal details, medical history, and damage assessment reports, which must be accurately extracted and processed.

Also, organizations do have their own large Knowledge base of information which can be used for answering most appropriate answer.

So, you can use the services and pipeline described above to create a source for search mechanism of the documents and provide context for the QnA and ChatGPT-style experience.

### Potential use cases

This solution can provide value to organizations in many industries, including pharmaceutical companies, financial services, and government. It applies to any industry where companies have a large corpus of documents with information embedded on them and AI powered end-to-end search solution could be leveraged to extract meaningful information from the document corpus based on the user query and provides ChatGPT-style QnA experience.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- Dixit Arora | Senior Customer Engineer, FastTrack for Azure
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure AI Document Intelligence?](/azure/ai-services/document-intelligence/overview)
- [What is Azure OpenAI?](/azure/ai-services/openai/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure AI Language?](/azure/ai-services/language-service/overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [QnA Maker client library](/azure/ai-services/qnamaker/quickstarts/quickstart-sdk)
- [Create, train, and publish your QnA Maker knowledge base](/azure/ai-services/qnamaker/quickstarts/create-publish-knowledge-base)
- [What is question answering?](/azure/ai-services/language-service/question-answering/overview)

## Related resources
