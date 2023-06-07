---
title: Build large language model pipelines with memory 
description: 
author: brandoncowenms
ms.author: brandoncowen
ms.date: 06/09/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - <Choose 1-5 products from the list at https://review.learn.microsoft.com/help/contribute/architecture-center/aac-browser-authoring#products>
  - <1-5 products>
  - <1-5 products>
categories:
  - <Choose at least one category from the list at https://review.learn.microsoft.com/help/contribute/architecture-center/aac-browser-authoring#azure-categories>
  - <There can be more than one category>
---

# Build large language model pipelines with memory

In today's fast-paced market, staying ahead of the competition is essential. A critical aspect of this is ensuring that you have a deep understanding of your products and the competitor products. An AI/ML pipeline comes in handy to help you quickly and efficiently gather, analyze, and summarize relevant information. This architecture includes several powerful Azure OpenAI models and services. It's paired with the popular open-source LangChain framework that's used for developing applications that are powered by language models.

This article describes an AI/ML pipeline that uses LangChain and large language models (LLMs) to provide a comprehensive analysis of how your product compares to competitor's similar products. The pipeline consists of two main components, a batch pipeline and a real-time, asynchronous pipeline. When you send a query to the real-time pipeline, the *orchestrator LLM*, often GPT-4, or the most powerful available LLM, derives a set of tasks to answer your question. These sub-tasks invoke other LLMs and APIs to mine the internal company product database and the public internet to build a report that shows the competitive position of your products versus the competitors. This pipeline is detailed in the following [Architecture section](#architecture).

> [!NOTE]
> Some of this article's introduction, key concepts, and workflow were generated with the help of ChatGPT! [Try it yourself](https://chat.openai.com), or [try it for your enterprise](/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio&tabs=command-line).

## Key concepts and components

## Azure OpenAI

Azure OpenAI Service provides REST API access to OpenAI's powerful language models including the GPT-3/3.5/4 and Embeddings model series. You can easily adapt these models to your specific task, such as content generation, summarization, semantic search, converting text to semantically powerful embeddings vectors, and natural language to code translation.

## LangChain

LangChain is an external, open-source framework that you can use to develop applications that are powered by language models. LangChain makes the complicated parts of working and building with AI models easier by providing the pipeline orchestration framework and helper utilities to run powerful, multiple-model pipelines.

## Memory

By default, language modeling chains (or pipelines) and agents operate in a stateless manner, which means they handle each incoming query independently, just like the underlying language models and chat models they utilize. However, in certain applications, such as chatbots, it becomes crucial to retain information from past interactions, both in the short term and the long term. This is where the concept of "Memory" comes into play.

LangChain offers memory components in two different forms. Firstly, it provides convenient utility tools for managing and manipulating previous chat messages. These utilities are designed to be modular and valuable regardless of their specific usage. Secondly, LangChain offers seamless methods to integrate these utilities into the memory of Chains using Large Language Models [Memory with Large Language Models](https://python.langchain.com/en/latest/modules/memory/how_to_guides.html).

Microsoft has open-sourced [Semantic Kernel](/semantic-kernel) that helps orchestrate and deploy large language models, and could be useful to explore as a LangChain alternative.

## Architecture

## How does my product compare to my competitor’s similar products

:::image type="content" source="media/language-model-pipelines-architecture.png" alt-text="{alt-text}" lightbox="https://dev.azure.com/msft-skilling/Content/_workitems/edit/96720" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

## Workflow

The ***batch pipeline*** is responsible for storing internal company product information in a fast vector search database. To achieve this, the following steps are taken:

1. The first part of this pipeline involves importing internal company documents around products and converting them into searchable vectors. The process starts by collecting product-related documents from different departments, such as sales, marketing, and product development. These documents are then scanned and converted into text using optical character recognition (OCR) technology.
1. Next, a LangChain chunking utility is used to chunk the documents into smaller, more manageable pieces. Chunking involves breaking down the text into meaningful phrases or sentences that can be analyzed separately. This is essential for improving the accuracy of the pipeline's search capabilities.
1. Once the documents are chunked, LLM is used to convert each chunk into a vectorized embedding. Embeddings are a type of representation used to capture the meaning and context of the text. By converting each chunk into a vectorized embedding, we can store and search for documents based on their meaning rather than just their raw text. LangChain also provides several utilities for this text splitting step, including capabilities for sliding windows / specifying text overlap, to prevent loss of context within each document chunk. Further, utilities for tagging chunks with document metadata, for optimizing the document retrieval step, and downstream reference are key features in many use cases.
1. Create an index in a vector store database to store the doc raw text, embeddings vectors, and metadata - The resulting embeddings are stored in a vector store database, along with the raw text of the document and any relevant metadata, such as the document's title and source.

Once the batch pipeline has been completed, the ***real-time, asynchronous*** ***pipeline*** can be used to search for relevant information. The following steps are taken:

5. A user enters their query and relevant metadata, such as their role in the company or business unit they are working in.
An embeddings model then converts the user's query into a vectorized embedding.
6. The *orchestrator LLM* decomposes the query, or main task, into the set of sub-tasks required to answer the user query. Converting the main task into a series of simpler sub-tasks, allows the LLM to address each task more accurately, resulting in a better answers, with less tendency for hallucination
7. The resulting embedding, and decomposed sub-tasks, are stored in the LangChain model's memory.
   1. The first designated task is retrieving top internal document chunks from customer internal database, relevant to the user’s query. A fast vector search for top n similar documents, stored as vectors within Cache for Redis will, will be performed.
   1. In parallel, a web search for externally similar products is executed, via LangChain’s Bing Search LLM plugin, with a generated search query composed by the *orchestrator LLM.*
All results are then stored back into the external model memory component
8. The vector store database is queried and returns top relevant product information pages (chunks and references) - The system queries the vector store database using the user's query embedding and returns the most relevant product information pages, along with the relevant text chunks and references.
The relevant information is stored in LangChain's model memory.
9. The system uses the information stored in LangChain's model memory to create a new prompt, which is sent to the *orchestrator LLM* to build a summary report based on the user query and company internal knowledge base + external web results.
10. *Optionally*, the output from the previous step is passed to a moderation filter to remove unwanted information.
The final competitive product report is then passed back to the user.

## Potential use cases

- Comparing internal company product information with an internal knowledgebase, to competitor products with information retrieved from a Bing web search
- Document search and information retrieval
- Internal chatbot with internal knowledgebase, enhanced by external web search

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Specialized AI Cloud Solution Architect

Other contributor:

- [Ashish Chauhun](https://www.linkedin.com/in/a69171115/) | Senior Specialized AI Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Get started at for your enterprise at [Quickstart: Get started generating text using Azure OpenAI Service](/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio&tabs=command-line). And leverage LangChain

## Related resources

- [Azure OpenAI Embeddings QnA](https://github.com/ruoccofabrizio/azure-open-ai-embeddings-qna)
- [Enterprise Search with OpenAI Architecture](https://github.com/MSUSAzureAccelerators/Knowledge-Mining-with-OpenAI)
- [Azure Business Process Accelerator](https://github.com/Azure/business-process-automation)
- [Semantic Kernel](/semantic-kernel/overview/)
- [Revolutionize your Enterprise Data with ChatGPT: Next-gen Apps w/ Azure OpenAI and Cognitive Search](https://techcommunity.microsoft.com/t5/ai-applied-ai-blog/revolutionize-your-enterprise-data-with-chatgpt-next-gen-apps-w/ba-p/3762087)
- [Generative AI for Developers: Exploring New Tools and APIs in Azure OpenAI Service](https://techcommunity.microsoft.com/t5/ai-cognitive-services-blog/generative-ai-for-developers-exploring-new-tools-and-apis-in/ba-p/3817003)
# References
- [Azure OpenAI](/azure/cognitive-services/openai/)
- [LangChain](https://python.langchain.com/en/latest/index.html)
- [Memory with Large Language Models](https://python.langchain.com/en/latest/modules/memory/how_to_guides.html)
- [Redis on Azure OpenAI](https://github.com/openai/openai-cookbook/tree/main/examples/vector_databases/redis)
- [Vector Databases with Azure OpenAI](https://github.com/openai/openai-cookbook/tree/main/examples/vector_databases)
- <https://chat.openai.com/>
