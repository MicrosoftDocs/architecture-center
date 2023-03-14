---
title: Different Types of Language API Services
description: Learn about Azure Cognitive Service for Language for understanding and analyzing text.
author: krmeht
ms.author: architectures
categories: azure
ms.date: 03/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
  - language-service
ms.custom:
  - analytics
  - guide
---
Azure Cognitive Service for Language is a cloud-based service that provides Natural Language Processing (NLP) features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries.

- **A Language resource** - Choose this resource type if you only plan to use natural language processing services, or if you want to manage access and billing for the resource separately from other services
- **A Cognitive Service resource** - Choose this resource type if you plan to use the Language service in combination with other cognitive services, and you want to manage access and billing for these services together.

The following table helps summarize the API service based on your processing needs

| What do you need to process | Type of Service to Use |
|----------|-----------------|
|**Translation Needs**| |
|Translate text from an industry specific point of view|[Cognitive Services Customize Translator](/azure/cognitive-services/translator/custom-translator/overview)|
|Translate text from a generic point of view|[Cognitive Services  Translator](/azure/cognitive-services/translator/text-translation-overview)|
|Translate natural language into SQL queries|[Azure OpenAI Natural Language to SQL](/azure/cognitive-services/openai/how-to/work-with-code#explaining-an-sql-query)|
|Enable my apps to interact using Natural Language|[Cognitive Services Conversational Language understanding](/azure/cognitive-services/language-service/conversational-language-understanding/overview)|
|**Identification Needs**||
|Identify Sensitive and PII|[Cognitive Services Extract PII](/azure/cognitive-services/language-service/personally-identifiable-information/overview)|
|Identify Sensitive, PII and PHI|[Cognitive Services Extract Health Information](/azure/cognitive-services/language-service/text-analytics-for-health/overview?tabs=relation-extraction)|
|Identify entities in text and categorize them into pre-defined types|[Cognitive Services Extract named entities](/azure/cognitive-services/language-service/named-entity-recognition/overview)|
|Extract domain specific entities or information | [Cognitive Services Custom named entity recognition](/azure/cognitive-services/language-service/custom-named-entity-recognition/overview) |
|Extract the main Key Phrases from text |[Cognitive Services Extract Key Phrases](/azure/cognitive-services/language-service/key-phrase-extraction/overview)|
|Extract document summary|[Azure OpenAI Summarize Text-GPT3](https://learn.microsoft.com/azure/cognitive-services/openai/quickstart?pivots=programming-language-studio#try-text-summarization)|
|**Classification Needs**||
| Classify text using sentiment analysis | [Cognitive Services Sentiment Analysis](/azure/cognitive-services/language-service/sentiment-opinion-mining/quickstart?source=recommendations&tabs=windows&pivots=programming-language-csharp) |
| Classify text using custom classes | [Cognitive Services Custom Text Classification](/azure/cognitive-services/language-service/custom-text-classification/quickstart?tabs=multi-classification&pivots=language-studio)|
| Classify items into categories provided at inference time | [Azure OpenAI Classify Text](/azure/cognitive-services/openai/how-to/completions#classification) |
| Classify text by detecting the language | [Cognitive Services Detect Language](/azure/cognitive-services/language-service/language-detection/overview) |
| **Understanding the Context Needs** | |
|Link the identity of an entity found with a knowledge base | [Cognitive Services Find Linked Entities](/azure/search/cognitive-search-skill-entity-linking-v3) |
| Understand Questions and Answers (generic) | [Cognitive Services Answer Questions](/azure/cognitive-services/language-service/question-answering/overview) |
| Understand Questions and Answers (specific) | [Cognitive Services Custom Question Answering](/azure/cognitive-services/language-service/question-answering/overview) |
| Combine Multiple Cognitive Services | [Cognitive Services Orchestration workflow](/azure/cognitive-services/language-service/orchestration-workflow/overview) |

At a high Level you can think of Language API's to be categorized as follows

1. **Language Service** -Azure Language service provides several Natural Language Processing (NLP) features to understand and analyze text. Language service unifies Text Analytics, QnA Maker, and LUIS. These features can either be:
    - Pre-configured, which means the AI models that the feature uses are not customizable. You just send your data, and use the feature's output in your applications.
    - Customizable, which means you'll train an AI model using our tools to fit your data specifically.

2. **Azure Open AI Service**-Azure OpenAI Service provides REST API access to OpenAI's powerful language models including the GPT-3, Codex and Embeddings model series. These models can be easily adapted to your specific task including but not limited to content generation, summarization, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the Azure OpenAI Studio

3. **Translator Service** -Translator Service falling under Language API's provides Text-To-Text API's but this too involves language detection and conversion

4. **QnA Maker** - QnA Maker is a cloud-based Natural Language Processing (NLP) service that allows you to create a natural conversational layer over your data.

### Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-track Engineer
- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect

Co-authors:

- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-track Engineer
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect

### Next steps

- [What is Azure Cognitive Service for Language](/azure/cognitive-services/language-service/overview)
- [Language API's Bifurcations](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-language-api-s-azure-ai-applied/ba-p/3514278)

### Learning Paths

- [Create Language Understanding solution with Azure Cognitive Services](/training/paths/create-language-solution-azure-cognitive-services/)
- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)]
- [Learning path: Identify principals and practices for Responsible AI](/training/paths/responsible-ai-business-principles/)
- [Learning path: Introduction to responsible bots](/training/modules/responsible-bots-introduction/)

