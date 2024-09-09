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


## Capabilities

Here are the Azure AI language capabilities:


### Named Entity Recognition (NER)


[Named entity recognition](/azure/ai-services/language-service/named-entity-recognition/overview) is a preconfigured feature that categorizes entities (words or phrases) in unstructured text across several predefined category groups. For example: people, events, places, dates, [and more](./named-entity-recognition/concepts/named-entity-categories).


### Personally identifying (PII) and health (PHI) information detection


[PII detection](/azure/ai-services/language-service/personally-identifiable-information/overview) is a preconfigured feature that identifies, categorizes, and redacts sensitive information in both [unstructured text documents](/azure/ai-services/language-service/personally-identifiable-information/how-to-call), and [conversation transcripts](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations). For example: phone numbers, email addresses, forms of identification, [and more](/azure/ai-services/language-service/personally-identifiable-information/concepts/entity-categories).



### Language detection


[Language detection](/azure/ai-services/language-service//language-detection/overview) is a preconfigured feature that can detect the language a document is written in, and returns a language code for a wide range of languages, variants, dialects, and some regional/cultural languages.



### Sentiment Analysis and opinion mining


[Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview) are preconfigured features that help you find out what people think of your brand or topic by mining text for clues about positive or negative sentiment, and can associate them with specific aspects of the text.


### Summarization


[Summarization](/azure/ai-services/language-service/summarization/overview) is a preconfigured feature that uses extractive text summarization to produce a summary of documents and conversation transcriptions. It extracts sentences that collectively represent the most important or relevant information within the original content.


### Key phrase extraction


[Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview) is a preconfigured feature that evaluates and returns the main concepts in unstructured text, and returns them as a list.

### Entity linking

[Entity linking](/azure/ai-services/language-service/entity-linking/overview) is a preconfigured feature that disambiguates the identity of entities (words or phrases) found in unstructured text and returns links to Wikipedia. 


### Text analytics for health


[Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview) is a preconfigured feature that extracts and labels relevant medical information from unstructured texts such as doctor's notes, discharge summaries, clinical documents, and electronic health records. 

### Custom text classification


[Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) enables you to build custom AI models to classify unstructured text documents into custom classes you define.
 

### Custom Named Entity Recognition (Custom NER)


[Custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/overview) enables you to build custom AI models to extract custom entity categories (labels for words or phrases), using unstructured text that you provide. 


### Conversational language understanding

  [Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview) enables users to build custom natural language understanding models to predict the overall intention of an incoming utterance and extract important information from it.


### Orchestration workflow


  [Orchestration workflow](/azure/ai-services/language-service/language-detection/overview) is a custom feature that enables you to connect [Conversational Language Understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview.md), [question answering](./question-answering/overview), and [LUIS](../LUIS/what-is-luis.md) applications.

   :::column-end:::


### Question answering


  [Question answering](/azure/ai-services/language-service/question-answering/overview) is a custom feature that finds the most appropriate answer for inputs from your users, and is commonly used to build conversational client applications, such as social media applications, chat bots, and speech-enabled desktop applications. 



### Custom text analytics for health


  [Custom text analytics for health](/azure/ai-services/language-service/custom-text-analytics-for-health/overview) is a custom feature that extract healthcare specific entities from unstructured text, using a model you create.  


## Use cases

The following table provides recommended services for specific use cases.

| Use case | Service to use | Service category | Customizable |
|----------|-----------------|---|---|
|Translate industry-specific text.|[AI Services Custom Translator](/azure/ai-services/translator/custom-translator/overview)| Azure AI Translator | |
|Translate generic text that isn't specific to an industry.|[What is Azure Text Translation](/azure/ai-services/translator/text-translation-overview)| Azure AI Translator | |
|Predict the intention of user inputs and extract information from them.|[AI Services conversational language understanding](/azure/ai-services/language-service/conversational-language-understanding/overview)| Azure AI Language | Yes
|Identify and/or redact sensitive information such as PII. |[AI Services Personally Identifiable Information (PII) detection](/azure/ai-services/language-service/personally-identifiable-information/overview)|  Azure AI Language | |
|Identify the language that a text was written in.| [Azure AI Language service language detection](/azure/ai-services/language-service/language-detection/overview) | Azure AI Language | |
|Extract medical information from clinical/medical documents, without building a model.|[AI Services Text Analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview)|  Azure AI Language | |
|Extract medical information from clinical/medical documents using a model that's trained on your data. |[AI Services key phrase extraction](/azure/ai-services/language-service/custom-text-analytics-for-health/overview)|  Azure AI Language | |
|Extract categories of information without creating a custom model.|[Named Entity Recognition (NER) in Azure AI Language](/azure/ai-services/language-service/named-entity-recognition/overview)|  Azure AI Language | |
|Extract categories of information using a model specific to your data.|[Custom named entity recognition (NER)](/azure/ai-services/language-service/custom-named-entity-recognition/overview)|  Azure AI Language | Yes |
|Extract main topics and important phrases.|[AI Services key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview)|  Azure AI Language | |
|Summarize a document|[Using text, document and conversation summarization](/azure/ai-services/language-service/summarization/quickstart?tabs=text-summarization)|  Azure AI Language | |
| Classify text by using sentiment analysis. | [Azure AI Language service sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/quickstart) | Azure AI Language | Yes |
| Classify text by using custom classes. | [Azure AI Language service custom text classification](/azure/ai-services/language-service/custom-text-classification/quickstart)| Azure AI Language | Yes |
| Classify items into categories provided at inference time. | [Azure AI Language service custom text classification](/azure/ai-services/openai/how-to/completions#classification) | Azure AI Language | |
|Link an entity with knowledge base articles. | [Azure AI Language service Entity Linking](/azure/ai-services/language-service/entity-linking/overview) | Azure AI Language| |
| Understand questions and answers (generic). | [Azure AI Language service question answering](/azure/ai-services/language-service/question-answering/overview) |  Azure AI Language | Yes| 
| Build a conversational application that responds to user inputs. | [Azure AI Language service custom question answering](/azure/ai-services/language-service/question-answering/overview) |  Azure AI Language | |
| Connect apps from conversational language understanding, LUIS, and question answering. | [Azure AI Language service orchestration workflow](/azure/ai-services/language-service/orchestration-workflow/overview) |  Azure AI Language  |  Yes |

** If a feature is customizable, you can train an AI model using our tools to fit your data specifically. Otherwise a feature is preconfigured, meaning the AI models it uses cannot be changed. You just send your data, and use the feature's output in your applications.
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
