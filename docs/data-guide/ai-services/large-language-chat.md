---
title: Choose an Azure AI large language chat model technology 
description: Learn about Azure AI large language chat models such as chatbots, document search, and content generation.
author: robbagby
ms.author: pnp
categories:
  - analytics
ms.date: 09/16/2024
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
products:
  - ai-services
ms.custom:
  - analytics
  - guide
  - arb-aiml
---

# Choose an Azure AI large language chat model technology 

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models. 

This article covers Azure AI services that offer large language chat models that offer natural conversation with users. Chat models can answer questions, provide information, and guide users through scripts. They can also generate text based on prompts. These models are useful for chatbots, document search, and content generation.


## Services

The following services provide large language chat model capabilities for Azure AI services:

- [Azure AI Search](#azure-ai-search) lets you to use your own content for generative AI search applications. It turns your data into a chat searchable index you can use to add conversational search to your application. 
    - **Use** Azure AI Search when you have documents you want to make searchable through natural language chat embedded in your applications.
    - **Don't use** Azure AI Search for traditional searching. It's also not intended to analyze images, for sentiment analysis, or for other types of textual analysis.

- [Azure OpenAI](#azure-openai) provides REST API access to all of OpenAI's powerful language models. It allows you to use choose models tailored for different tasks and at different cost ranges.
    - **Use** Azure OpenAI when you want to work with OpenAI's powerful models using REST APIs in your applications. Its offerings cover a wide range of budgets.
    - **Use** Azure OpenAI if you want Enterprise-grade security features, such as private networking and managed identity through Microsoft Entra ID.
    - **Don't use** Azure OpenAI if you want to use open source models.
    - **Don't use** Azure OpenAI for any specific use cases such as content safety, where it's cheaper to use optimized, task-specific models. While you could use an OpenAI model to moderate content safety, it would be much more expensive than using a custom solution like the Content Safety service.


### Azure AI Search

[Azure AI Speech service](/azure/ai-services/speech-service/overview) provides secure information retrieval at scale over user-owned content in traditional and generative AI search applications.


#### Capabilities

The following list provides the capabilities available in Azure AI Search service.

+ A search engine for [vector search](/azure/search/vector-search-overview) and [full text](/azure/search/search-lucene-query-architecture) and [hybrid search](/azure/search/hybrid-search-overview) over a search index 
+ Rich indexing with [integrated data chunking and vectorization](/azure/search/vector-search-integrated-vectorization), [lexical analysis](/azure/search/search-analyzers) for text, and [optional applied AI](/azure/search/cognitive-search-concept-intro) for content extraction and transformation
+ Rich query syntax for [vector queries](/azure/search/vector-search-how-to-query), text search, [hybrid queries](/azure/search/hybrid-search-how-to-query), fuzzy search, autocomplete, geo-search and others
+ Relevance and query performance tuning with [semantic ranking](/azure/search/semantic-search-overview), [scoring profiles](/azure/search/index-add-scoring-profiles), [quantization for vector queries](/azure/search/vector-search-how-to-configure-compression-storage), and parameters for controlling query behaviors at runtime 
+ Azure scale, security, and reach
+ Azure integration at the data layer, machine learning layer, Azure AI services and Azure OpenAI|


For more information on Azure AI Search service, see the [Azure AI Search service documentation](/azure/search/search-what-is-azure-search).


### Azure OpenAI

[Azure OpenAI service](/azure/ai-services/openai/index) provides REST API access to all of OpenAI's powerful language models. It allows you to use the full breadth of models to fit any solution or budget. Following are a list of supported text models by Azure OpenAI:

- [GPT-4o & GPT-4 Turbo NEW](/azure/ai-services/openai/concepts/models#gpt-4o-and-gpt-4-turbo) The latest and most capable Azure OpenAI models.
- [GPT-4](/azure/ai-services/openai/concepts/models#gpt-4) Models that improve on `GPT-3.5` and are more cost-effective than later `GPT-4o` or `GPT-4 Turbo` models.
- [GPT-3.5](/azure/ai-services/openai/concepts/models#gpt-35) Models that improve on `GPT-3` and are more cost-effective than `GPT-4` and later models.
- [Embeddings](/azure/ai-services/openai/concepts/models#embeddings-models) Models to convert text to vector form for text similarity comparison.
- [Text to speech (Preview)](/azure/ai-services/openai/concepts/models#text-to-speech-models-preview) Models in preview that can synthesize text to speech
- [Whisper](/azure/ai-services/openai/concepts/models#whisper-models) A series of models in preview that can transcribe and translate speech to text.





## Next steps

- [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide)


## Related resources

- [Azure AI Language capabilities guide](targeted-language-processing.md)
- [Azure AI Vision capabilities guide](image-video-processing.md)
- [Baseline OpenAI end-to-end chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat)
