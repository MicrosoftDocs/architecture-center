---
title: Azure AI language services
description: Learn about using Azure AI language services to understand and analyze text. Learn which service to use for a specific use case.
author: kruti-m
ms.author: krmeht
categories:
- ai-machine-learning
ms.date: 09/09/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.collection: ce-skilling-ai-copilot
products:
  - ai-services
ms.custom:
  - analytics
  - guide
---

# Azure AI language services

Azure AI language services provides Natural Language Processing (NLP) features for understanding and analyzing text such as language translation, natural-language-to-code translation, content generation, summarization and semantic search. 


## Services

Here are the Azure AI language services:

- [Azure AI Language](/azure/ai-services/language-service/overview) is a cloud-based service that provides Natural Language Processing (NLP) features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries.
  - *Preconfigured*, which means the AI models that the feature uses are not customizable. You just send your data, and use the feature's output in your applications.
  - *Customizable*, which means you'll train an AI model using our tools to fit your data specifically.

- [Azure OpenAI Service](/azure/ai-services/openai/) provides REST API access to OpenAI's powerful language models including GPT-4o, GPT-4 Turbo with Vision, GPT-4, GPT-3.5-Turbo, and Embeddings model series. These models can be easily adapted to your specific task including but not limited to content generation, summarization, image understanding, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the Azure OpenAI Studio.


- [Azure AI Translator](/azure/ai-services/translator/translator-overview) is a cloud-based machine translation service you can use to translate text and documents with a simple REST API call. The service uses modern neural machine translation technology. The Custom Translator interface allows you to use your translation memory to create customized neural translation systems. The customized translation system can be used to translate text and documents with the Translator service.


## Use cases

The following table provides recommended services for specific use cases.

| Use case | Service to use | Service category |
|----------|-----------------|---|
|**Translation**| | |
|Translate industry-specific text|[AI Services Custom Translator](/azure/ai-services/translator/custom-translator/overview)| Azure AI Translator |
|Translate generic text that isn't specific to an industry|[What is Azure Text Translation](/azure/ai-services/translator/text-translation-overview)| Azure AI Translator |
|Translate SQL queries into natural language|[Codex explaining a SQL query](/azure/ai-services/openai/how-to/work-with-code#explaining-an-sql-query)| Azure OpenAI |
|Enable apps to process and analyze natural language|[AI Services conversational language understanding](/azure/ai-services/language-service/conversational-language-understanding/overview)| Azure AI Language |
|**Identification**|| Language |
|Identify and/or redact sensitive information such as PII |[AI Services Personally Identifiable Information (PII) detection](/azure/ai-services/language-service/personally-identifiable-information/overview)|  Azure AI Language |
|Identify sensitive information, PII, and PHI|[AI Services Text Analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview)|  Azure AI Language |
|Identify entities in text and categorize them into predefined types|[AI Services named entity recognition (NER)](/azure/ai-services/language-service/named-entity-recognition/overview)|  Azure AI Language |
|Extract domain-specific entities or information | [AI Services custom named entity recognition](/azure/ai-services/language-service/custom-named-entity-recognition/overview) |  Azure AI Language |
|Extract the main key phrases from text |[AI Services key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview)|  Azure AI Language |
|Summarize a document|[Using text, document and conversation summarization](/azure/ai-services/language-service/summarization/quickstart?tabs=text-summarization)|  Azure AI Language |
|**Classification**||  |
| Classify text by using sentiment analysis | [Azure AI Language service sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/quickstart) | Azure AI Language |
| Classify text by using custom classes | [Azure AI Language service custom text classification](/azure/ai-services/language-service/custom-text-classification/quickstart)| Azure AI Language |
| Classify items into categories provided at inference time | [Azure AI Language service custom text classification](/azure/ai-services/openai/how-to/completions#classification) | Azure AI Language |
| Classify text by detecting the language | [Azure AI Language service language detection](/azure/ai-services/language-service/language-detection/overview) | Azure AI Language |
| **Understanding context** | | |
|Link an entity with knowledge base articles | [Azure AI Language service Entity Linking](/azure/search/ai-search-skill-entity-linking-v3) | Azure AI Search |
| Understand questions and answers (generic) | [Azure AI Language service question answering](/azure/ai-services/language-service/question-answering/overview) |  Azure AI Language |
| Understand questions and answers (custom) | [Azure AI Language service custom question answering](/azure/ai-services/language-service/question-answering/overview) |  Azure AI Language |
| Combine multiple ai services | [Azure AI Language service orchestration workflow](/azure/ai-services/language-service/orchestration-workflow/overview) |  Azure AI Language |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-Track Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-Track Engineer

 *To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Cognitive Service for Language?](/azure/ai-services/language-service/overview)
- [Language APIs blog post](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-ai-services-language-api-s-azure-ai-applied/ba-p/3514278)
- [Learning path: Create a language understanding solution with Azure Cognitive Services](/training/paths/create-language-solution-azure-ai-services/)
- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-ai-services)
- [Learning path: Identify principles and practices for responsible AI](/training/paths/responsible-ai-business-principles/)
- [Learning path: Introduction to responsible bots](/training/modules/responsible-bots-introduction/)

## Related resources

- [Types of decision APIs and Applied AI Services](decision-applied-ai.md)
- [Types of speech API services](speech-api.md)
- [Types of vision API services](vision-api.md)
