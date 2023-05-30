---
title: Types of language API services
description: Learn about using Azure Cognitive Service for Language to understand and analyze text. Learn which service to use for a specific use case. 
author: kruti-m
ms.author: krmeht
categories: 
- ai-machine-learning
ms.date: 06/01/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
  - azure-qna-maker
ms.custom:
  - analytics
  - guide
---

# Types of language API services

Azure Cognitive Service for Language is a cloud-based service that provides Natural Language Processing (NLP) features for understanding and analyzing text. This service can help you build intelligent applications. It provides tools like the web-based Language Studio, REST APIs, and client libraries.

## Services

Here are some details about language API services: 

- [Azure Cognitive Service for Language](/azure/cognitive-services/language-service/overview) provides several NLP features for understanding and analyzing text. This service brings together Text Analytics, QnA Maker, and LUIS. These features can be:
  - Preconfigured, which means that the AI models the feature uses aren't customizable. You just send your data and use the feature's output in your applications.
  - Customizable, which means that you use Azure Cognitive Services tools to train an AI model to fit your data.
- [Azure OpenAI Service](/azure/cognitive-services/openai/) provides REST API access to powerful OpenAI language models, including GPT-3, Codex, and embeddings. You can easily adopt these models to your specific task. Tasks include content generation, summarization, semantic search, and natural-language-to-code translation. You can access the service via REST APIs, a Python SDK, or the web-based interface in Azure OpenAI Studio.
- [Cognitive Services Translator](/azure/cognitive-services/translator/translator-overview) is a translation service that provides text-to-text APIs.
- [QnA Maker](/azure/cognitive-services/qnamaker/overview/overview) is a cloud-based NLP service that you can use to create a natural conversational layer over your data.

## Use cases

The following table provides recommended services for specific use cases.

| Use case | Service to use | Service category |
|----------|-----------------|---|
|**Translation**| | |
|Translate industry-specific text|[Cognitive Services Custom Translator](/azure/cognitive-services/translator/custom-translator/overview)| Translator |
|Translate generic text that isn't specific to an industry|[Cognitive Services  Translator](/azure/cognitive-services/translator/text-translation-overview)| Translator |
|Translate natural language into SQL queries|[Azure OpenAI natural language to SQL](/azure/cognitive-services/openai/how-to/work-with-code#explaining-an-sql-query)| Azure OpenAI |
|Enable apps to process and analyze natural language|[Cognitive Services conversational language understanding](/azure/cognitive-services/language-service/conversational-language-understanding/overview)| Language |
|**Identification**|| Language |
|Identify sensitive information and PII|[Cognitive Services Personally Identifiable Information (PII) detection](/azure/cognitive-services/language-service/personally-identifiable-information/overview)| Language |
|Identify sensitive information, PII, and PHI|[Cognitive Services Text Analytics for health](/azure/cognitive-services/language-service/text-analytics-for-health/overview)| Language |
|Identify entities in text and categorize them into predefined types|[Cognitive Services named entity recognition](/azure/cognitive-services/language-service/named-entity-recognition/overview)| Language |
|Extract domain-specific entities or information | [Cognitive Services custom named entity recognition](/azure/cognitive-services/language-service/custom-named-entity-recognition/overview) | Language |
|Extract the main key phrases from text |[Cognitive Services key phrase extraction](/azure/cognitive-services/language-service/key-phrase-extraction/overview)| Language |
|Summarize a document|[Azure OpenAI GPT-3 text summarization](/azure/cognitive-services/openai/quickstart#try-text-summarization)| Azure OpenAI |
|**Classification**||  |
| Classify text by using sentiment analysis | [Cognitive Services sentiment analysis](/azure/cognitive-services/language-service/sentiment-opinion-mining/quickstart) | Language |
| Classify text by using custom classes | [Cognitive Services custom text classification](/azure/cognitive-services/language-service/custom-text-classification/quickstart)| Language |
| Classify items into categories provided at inference time | [Azure OpenAI text classification](/azure/cognitive-services/openai/how-to/completions#classification) | Azure OpenAI |
| Classify text by detecting the language | [Cognitive Services language detection](/azure/cognitive-services/language-service/language-detection/overview) | Language |
| **Understanding context** | | |
|Link an entity with knowledge base articles | [Cognitive Services Entity Linking](/azure/search/cognitive-search-skill-entity-linking-v3) | Language |
| Understand questions and answers (generic) | [Cognitive Services question answering](/azure/cognitive-services/language-service/question-answering/overview) | QnA Maker |
| Understand questions and answers (custom) | [Cognitive Services custom question answering](/azure/cognitive-services/language-service/question-answering/overview) | QnA Maker |
| Combine multiple cognitive services | [Cognitive Services orchestration workflow](/azure/cognitive-services/language-service/orchestration-workflow/overview) | Language |

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

- [What is Azure Cognitive Service for Language?](/azure/cognitive-services/language-service/overview)
- [Language APIs blog post](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-language-api-s-azure-ai-applied/ba-p/3514278)
- [Learning path: Create a language understanding solution with Azure Cognitive Services](/training/paths/create-language-solution-azure-cognitive-services/)
- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)
- [Learning path: Identify principles and practices for responsible AI](/training/paths/responsible-ai-business-principles/)
- [Learning path: Introduction to responsible bots](/training/modules/responsible-bots-introduction/)

## Related resources

- [Types of decision APIs and Applied AI Services](decision-applied-ai.md)
- [Types of speech API services](speech-api.md)
- [Types of vision API services](vision-api.md)