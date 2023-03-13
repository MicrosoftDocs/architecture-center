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

The following table helps summarize the API service based on the what is it that you need to process

| What do you need to process | Type of Service to Use |
|----------|-----------------|
|**Translation Needs**| |
|Translate text from an industry specific point of view|Cognitive Services Customize Translator|
|Translate text from a generic point of view|Cognitive Services  Translator|
|Translate natural language into SQL queries|Azure OpenAI Natural Language to SQL|
|Enable my apps to interact using Natural Language|Cognitive Services Conversational Language understanding|
|**Identification Needs**||
|Identify Sensitive and PII|Cognitive Services Extract PII|
|Identify Sensitive, PII and PHI|Cognitive Services Extract Health Information|
|Identify entities in text and categorize them into pre-defined types|Cognitive Services Extract named entities|
|Extract domain specific entities or information | Cognitive Services Custom named entity recognition |
|Extract the main Key Phrases from text |Cognitive Services Extract Key Phrases|
|Extract document summary|Azure OpenAI Summarize Text|
|**Classification Needs**||
| Classify text using sentiment analysis | Cognitive Services Sentiment Analysis |
| Classify text using custom classes | Cognitive Services Custom Text Classification|
| Classify items into categories provided at inference time | Azure OpenAI Classify Text |
| Classify text by detecting the language | Cognitive Services Detect Language |
| **Understanding or Linking Needs** | |
|Link the identity of an entity found with a knowledge base | Cognitive Services Find Linked Entities |
| Understand Questions and Answers (generic) | Cognitive Services Answer Questions |
| Understand Questions and Answers (specific) | Cognitive Services Custom Question Answering |
| Generate Product Names | Azure OpenAI generate new product names |
| Combine Multiple Cognitive Services | Cognitive Services Orchestration workflow |

[Language Studio](https://aka.ms/languageStudio) is a set of UI-based tools that lets you explore, build, and integrate features from Azure Cognitive Service for Language into your applications.

Language Studio provides you with a platform to try several service features, and see what they return in a visual manner. It also provides you with an easy-to-use experience to create custom projects and models to work on your data. Using the Studio, you can get started without needing to write code, and then use the available client libraries and REST APIs in your application. The quickstart can be found [her

Go to the [Language Studio](https://aka.ms/languageStudio) to begin using features offered by the service.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-track Engineer
- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect

Co-authors:

- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-track Engineer
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer

## Next steps

- [What is Azure Cognitive Service for Language](/azure/cognitive-services/language-service/overview)
- [Create Language Understanding solution with Azure Cognitive Services](/training/paths/create-language-solution-azure-cognitive-services/)
- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)]
- [Language API's Bifercations](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-language-api-s-azure-ai-applied/ba-p/3514278)
