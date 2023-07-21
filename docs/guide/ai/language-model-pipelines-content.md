Stay ahead of the competition by being informed and having a deep understanding of your products and competitor products. An AI/machine learning pipeline helps you quickly and efficiently gather, analyze, and summarize relevant information. This architecture includes several powerful Azure OpenAI Service models. These models pair with the popular open-source LangChain framework that's used to develop applications that are powered by language models.

> [!NOTE]
> Some parts in the introduction, components, and workflow of this article were generated with the help of ChatGPT! [Try it for yourself](https://chat.openai.com), or [try it for your enterprise](/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio&tabs=command-line).

## Architecture

:::image type="content" source="media/language-model-pipelines-architecture.png" alt-text="{alt-text}" lightbox="media/language-model-pipelines-architecture.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/language-model-pipelines-architecture.pptx) of this architecture.*

## Workflow

The ***batch pipeline*** stores internal company product information in a fast vector search database. To achieve this result, the following steps are taken:

1. Internal company documents for products are imported and converted into searchable vectors. Product-related documents are collected from departments, such as sales, marketing, and product development. These documents are then scanned and converted into text by using optical character recognition (OCR) technology.
1. A LangChain chunking utility chunks the documents into smaller, more manageable pieces. Chunking breaks down the text into meaningful phrases or sentences that can be analyzed separately and improves the accuracy of the pipeline's search capabilities.
1. The language model converts each chunk into a vectorized embedding. Embeddings are a type of representation that capture the meaning and context of the text. By converting each chunk into a vectorized embedding, you can store and search for documents based on their meaning rather than their raw text. To prevent loss of context within each document chunk, LangChain provides several utilities for this text splitting step, like capabilities for sliding windows or specifying text overlap. Some key features include utilities for tagging chunks with document metadata, optimizing the document retrieval step, and downstream reference.
1. Create an index in a vector store database to store the raw document text, embeddings vectors, and metadata. The resulting embeddings are stored in a vector store database along with the raw text of the document and any relevant metadata, such as the document's title and source.

After the batch pipeline is complete, the ***real-time, asynchronous*** ***pipeline*** searches for relevant information. The following steps are taken:

5. Enter a query and relevant metadata, such as your role in the company or the business unit that you work in. An embeddings model then converts your query into a vectorized embedding.
6. The orchestrator language model decomposes your query, or main task, into the set of subtasks that are required to answer your query. Converting the main task into a series of simpler subtasks allows the language model to address each task more accurately, which results in better answers with less tendency for inaccuracy.
7. The resulting embedding and decomposed subtasks are stored in the LangChain model's memory.
   1. Top internal document chunks that are relevant to your query are retrieved from your internal database. A fast vector search is performed for the top *n* similar documents that are stored as vectors in Azure Cache for Redis.
   1. In parallel, a web search for similar external products is performed via the LangChain Bing Search language model plugin with a generated search query that the orchestrator language model composes. Results are stored in the external model memory component.
8. The vector store database is queried and returns the top relevant product information pages (chunks and references). The system queries the vector store database by using your query embedding and returns the most relevant product information pages, along with the relevant text chunks and references. The relevant information is stored in LangChain's model memory.
9. The system uses the information that’s stored in LangChain's model memory to create a new prompt, which is sent to the orchestrator language model to build a summary report that’s based on your query, company internal knowledge base, and external web results.
10. Optionally, the output from the previous step is passed to a moderation filter to remove unwanted information. The final competitive product report is passed to you.

## Components

- [Azure OpenAI Service](https://azure.microsoft.com/products/cognitive-services/openai-service) provides REST API access to OpenAI's powerful language models, including the GPT-3, GPT-3.5, GPT-4, and embeddings model series. You can easily adapt these models to your specific task, such as content generation, summarization, semantic search, converting text to semantically powerful embeddings vectors, and natural-language-to-code translation.

- [LangChain](https://python.langchain.com/en/latest/index.html) is a third-party, open-source framework that you can use to develop applications that are powered by language models. LangChain makes the complexities of working and building with AI models easier by providing the pipeline orchestration framework and helper utilities to run powerful, multiple-model pipelines.

- Memory refers to capturing information. By default, language modeling chains (or pipelines) and agents operate in a stateless manner. They handle each incoming query independently, just like the underlying language models and chat models that they use. But in certain applications, such as chatbots, it's crucial to retain information from past interactions in the short term and the long term. This area is where the concept of "memory" comes into play. LangChain provides convenient utility tools to manage and manipulate past chat messages. These utilities are designed to be modular regardless of their specific usage. LangChain also offers seamless methods to integrate these utilities into the memory of chains by using [language models](https://python.langchain.com/docs/modules/memory/how_to/adding_memory).

- [Semantic Kernel](/semantic-kernel) is an open-source software development kit (SDK) that you can use to orchestrate and deploy language models. You can explore Semantic Kernel as a potential alternative to LangChain.

## Scenario details

This architecture uses an AI/machine learning pipeline, LangChain, and language models to create a comprehensive analysis of how your product compares to similar competitor products. The pipeline consists of two main components: a batch pipeline and a real-time, asynchronous pipeline. When you send a query to the real-time pipeline, the orchestrator language model, often GPT-4 or the most powerful available language model, derives a set of tasks to answer your question. These subtasks invoke other language models and APIs to mine the internal company product database and the public internet to build a report that shows the competitive position of your products versus the competitor products.

### Potential use cases

You can apply this solution to the following scenarios:

- Compare internal company product information that has an internal knowledge base to competitor products that has information that's retrieved from a Bing web search.
- Perform a document search and information retrieval.
- Create a chatbot for internal use that has an internal knowledge base and is also enhanced by an external web search.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b) | Senior Specialized AI Cloud Solution Architect

Other contributor:

- [Ashish Chauhun](https://www.linkedin.com/in/a69171115) | Senior Specialized AI Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Business Process Accelerator](https://github.com/Azure/business-process-automation)
- [Azure OpenAI](/azure/cognitive-services/openai)
- [Azure OpenAI embeddings QnA](https://github.com/ruoccofabrizio/azure-open-ai-embeddings-qna)
- [ChatGPT](https://chat.openai.com)
- [Enterprise search with OpenAI architecture](https://github.com/MSUSAzureAccelerators/Knowledge-Mining-with-OpenAI)
- [Generative AI for developers: Exploring new tools and APIs in Azure OpenAI Service](https://techcommunity.microsoft.com/t5/ai-cognitive-services-blog/generative-ai-for-developers-exploring-new-tools-and-apis-in/ba-p/3817003)
- [LangChain](https://python.langchain.com/en/latest/index.html)
- [Memory with language models](https://python.langchain.com/docs/modules/memory/how_to/adding_memory)
- [Quickstart: Get started generating text using Azure OpenAI Service](/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio&tabs=command-line)
- [Redis on Azure OpenAI](https://github.com/openai/openai-cookbook/tree/main/examples/vector_databases/redis)
- [Revolutionize your enterprise data with ChatGPT: Next-gen apps with Azure OpenAI and Azure Cognitive Search](https://techcommunity.microsoft.com/t5/ai-applied-ai-blog/revolutionize-your-enterprise-data-with-chatgpt-next-gen-apps-w/ba-p/3762087)
- [Semantic Kernel](/semantic-kernel/overview)
- [Vector databases with Azure OpenAI](https://github.com/openai/openai-cookbook/tree/main/examples/vector_databases)

## Related resources

- [AI architecture design](/azure/architecture/data-guide/big-data/ai-overview)
- [Batch processing](/azure/architecture/data-guide/big-data/batch-processing)
- [Types of language API services](/azure/architecture/data-guide/cognitive-services/language-api)
