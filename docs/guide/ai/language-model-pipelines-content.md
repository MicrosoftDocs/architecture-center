# Build language model pipelines with memory

In today's fast-paced market, staying ahead of the competition is essential. A critical aspect of staying up to date is ensuring that you have a deep understanding of your products and competitor products. An AI/ML pipeline helps you quickly and efficiently gather, analyze, and summarize relevant information. This architecture includes several powerful Azure OpenAI models and services. It's paired with the popular open-source LangChain framework that's used to develop applications that are powered by language models.

This article describes how to use an AI/ML pipeline, LangChain, and language models to create a comprehensive analysis of how your product compares to competitor's similar products. The pipeline consists of two main components, a batch pipeline and a real-time, asynchronous pipeline. When you send a query to the real-time pipeline, the *orchestrator language model*, often GPT-4 or the most powerful available language model, derives a set of tasks to answer your question. These subtasks invoke other language models and APIs to mine the internal company product database and the public internet to build a report that shows the competitive position of your products versus the competitors.

> [!NOTE]
> Some parts in the introduction, components, and workflow of this article were generated with the help of ChatGPT! [Try it for yourself](https://chat.openai.com) or [try it for your enterprise](/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio&tabs=command-line).

## Architecture

:::image type="content" source="media/language-model-pipelines-architecture.png" alt-text="{alt-text}" lightbox="media/language-model-pipelines-architecture.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/language-model-pipelines-architecture.pptx) of this architecture.*

## Workflow

The ***batch pipeline*** stores internal company product information in a fast vector search database. To achieve this result, the following steps are taken:

1. Internal company documents for products are imported and converted into searchable vectors. Product-related documents are collected from departments, such as sales, marketing, and product development. These documents are then scanned and converted into text by using optical character recognition (OCR) technology.
1. A LangChain chunking utility is used to chunk the documents into smaller, more manageable pieces. Chunking involves breaking down the text into meaningful phrases or sentences that can be analyzed separately. Chunking improves the accuracy of the pipeline's search capabilities.
1. The language model converts each chunk into a vectorized embedding. Embeddings are a type of representation that capture the meaning and context of the text. By converting each chunk into a vectorized embedding, you can store and search for documents based on their meaning rather than their raw text. To prevent loss of context within each document chunk, LangChain provides several utilities for this text splitting step, like capabilities for sliding windows or specifying text overlap. Some key features in use cases include utilities for tagging chunks with document metadata, optimizing the document retrieval step, and downstream reference.
1. Create an index in a vector store database to store the raw document text, embeddings vectors, and metadata. The resulting embeddings are stored in a vector store database along with the raw text of the document and any relevant metadata, such as the document's title and source.

After the batch pipeline is complete, the ***real-time, asynchronous*** ***pipeline*** searches for relevant information. The following steps are taken:

5. A user enters a query and relevant metadata, such as their role in the company or business unit that they work in. An embeddings model then converts the user's query into a vectorized embedding.
6. The *orchestrator language model* decomposes the query, or main task, into the set of subtasks that are required to answer the user query. Converting the main task into a series of simpler subtasks allows the language model to address each task more accurately, which results in better answers with less tendency for inaccuracies.
7. The resulting embedding and decomposed subtasks are stored in the LangChain model's memory.
   1. Top internal document chunks that are relevant to the user’s query are retrieved from the customer's internal database. A fast vector search is performed for top n similar documents, stored as vectors within Azure Cache for Redis.
   1. In parallel, a web search for externally similar products is executed via LangChain’s Bing Search language model plugin with a generated search query that the *orchestrator language model* composes. Results are then stored in the external model memory component.
8. The vector store database is queried and returns the top relevant product information pages (chunks and references). The system queries the vector store database by using the user's query embedding and returns the most relevant product information pages, along with the relevant text chunks and references. The relevant information is stored in LangChain's model memory.
9. The system uses the information that’s stored in LangChain's model memory to create a new prompt, which is sent to the *orchestrator language model* to build a summary report that’s based on the user query, company internal knowledge base, and external web results.
10. *Optionally*, the output from the previous step is passed to a moderation filter to remove unwanted information. The final competitive product report is passed back to the user.

## Components

- [Azure OpenAI Service]() provides REST API access to OpenAI's powerful language models including the GPT-3/3.5/4 and Embeddings model series. You can easily adapt these models to your specific task, such as content generation, summarization, semantic search, converting text to semantically powerful embeddings vectors, and natural language to code translation.

- [LangChain]() is an external, open-source framework that you can use to develop applications that are powered by language models. LangChain makes the complexities of working and building with AI models easier by providing the pipeline orchestration framework and helper utilities to run powerful, multiple-model pipelines.

- Memory refers to capturing information. By default, language modeling chains (or pipelines) and agents operate in a stateless manner. They handle each incoming query independently, just like the underlying language models and chat models that they use. But in certain applications, such as chatbots, it's crucial to retain information from past interactions in the short term and the long term. This area is where the concept of "memory" comes into play. LangChain offers memory components in two forms. It provides convenient utility tools to manage and manipulate past chat messages. These utilities are designed to be modular and valuable regardless of their specific usage. LangChain also offers seamless methods to integrate these utilities into the memory of chains by using [language models](https://python.langchain.com/en/latest/modules/memory/how_to_guides.html).

- [Semantic Kernel](/semantic-kernel) is an open-source software development kit (SDK) that you can use to orchestrate and deploy language models. You can explore Semantic Kernel as a potential LangChain alternative.

## Potential use cases

You can apply this solution to the following scenarios:

- Compare internal company product information with an internal knowledge base to competitor products with information that's retrieved from a Bing web search.
- Perform a document search and information retrieval.
- Use an internal chatbot with an internal knowledge base that's enhanced by an external web search.

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
- [Memory with language models](https://python.langchain.com/en/latest/modules/memory/how_to_guides.html)
- [Quickstart: Get started generating text using Azure OpenAI Service](/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio&tabs=command-line)
- [Redis on Azure OpenAI](https://github.com/openai/openai-cookbook/tree/main/examples/vector_databases/redis)
- [Revolutionize your enterprise data with ChatGPT: Next-gen apps w/ Azure OpenAI and Azure Cognitive Search](https://techcommunity.microsoft.com/t5/ai-applied-ai-blog/revolutionize-your-enterprise-data-with-chatgpt-next-gen-apps-w/ba-p/3762087)
- [Semantic Kernel](/semantic-kernel/overview)
- [Vector databases with Azure OpenAI](https://github.com/openai/openai-cookbook/tree/main/examples/vector_databases)

## Related resources

- [AI architecture design](/azure/architecture/data-guide/big-data/ai-overview)
