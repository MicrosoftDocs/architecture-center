---
title: Language and document processing with Azure AI services
description: Learn about language and document processing capabilities of Azure AI services. Learn which service to use for a specific use cases.
author: robbagby
ms.author: pnp
categories:
- ai-machine-learning
ms.date: 09/09/2024
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

# Azure AI language and document processing capabilities guide 

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models. 

This article covers Azure AI services that offer language and document processing capabilities for Azure AI services.


## Services

The following services provide language and document processing capabilities for Azure AI services:

- [Azure AI Language service](#azure-ai-language-service)
- [Azure AI Translator service](#azure-ai-translator)
- [Azure AI Document Intelligence](#azure-ai-document-intelligence)

Each service has its own capabilities and use cases.

### Azure AI Language service

[Azure AI Language service](https://azure.microsoft.com/products/ai-services/ai-language) is a cloud-based service that provides Natural Language Processing (NLP) features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries.


#### Capabilities

The following table provides a list of capabilities available in Azure AI Language service.

| Capability | Description | 
|----------|-------------|
| [Named entity recognition (NER)](/azure/ai-services/language-service/named-entity-recognition/overview) | Categorizes entities (words or phrases) in unstructured text across several predefined category groups. For example: people, events, places, dates, [and more](/azure/ai-services/language-servicenamed-entity-recognition/concepts/named-entity-categories).|
| [Personally identifying (PII) and health (PHI) information detection](/azure/ai-services/language-service/personally-identifiable-information/overview)| Identifies, categorizes, and redacts sensitive information in both [unstructured text documents](/azure/ai-services/language-service/personally-identifiable-information/how-to-call), and [conversation transcripts](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations). For example: phone numbers, email addresses, forms of identification, [and more](/azure/ai-services/language-service/personally-identifiable-information/concepts/entity-categories).|
|[Language detection](/azure/ai-services/language-service//language-detection/overview)| Detects the language a document is written in, and returns a language code for a wide range of languages, variants, dialects, and some regional/cultural languages.|
|[Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview) |Help you find out what people think of your brand or topic by mining text for clues about positive or negative sentiment, and can associate them with specific aspects of the text.|
|[Summarization](/azure/ai-services/language-service/summarization/overview)| Uses extractive text summarization to produce a summary of documents and conversation transcriptions. It extracts sentences that collectively represent the most important or relevant information within the original content.|
|[Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview) |Evaluates and returns the main concepts in unstructured text, and returns them as a list.|
|[Entity linking](/azure/ai-services/language-service/entity-linking/overview) | Disambiguates the identity of entities (words or phrases) found in unstructured text and returns links to Wikipedia. |
|[Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview) | Extracts and labels relevant medical information from unstructured texts such as doctor's notes, discharge summaries, clinical documents, and electronic health records. |
| [Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) |Use to build custom AI models to classify unstructured text documents into custom classes you define.|
| [Custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/overview) | Use to build custom AI models to extract custom entity categories (labels for words or phrases), using unstructured text that you provide. |
|[Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview)| Use to build custom natural language understanding models to predict the overall intention of an incoming utterance and extract important information from it.|
| [Orchestration workflow](/azure/ai-services/language-service/language-detection/overview)| Use to connect [Conversational Language Understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview.md), [question answering](/azure/ai-services/language-service/question-answering/overview), and [LUIS](../LUIS/what-is-luis.md) applications.|
| [Question answering](/azure/ai-services/language-service/question-answering/overview)| Finds the most appropriate answer for inputs from your users, and is commonly used to build conversational client applications, such as social media applications, chat bots, and speech-enabled desktop applications. |
|[Custom text analytics for health](/azure/ai-services/language-service/custom-text-analytics-for-health/overview) |Extracts healthcare specific entities from unstructured text, using a model that you create.|  


#### Use cases

The following table provides a list of possible use cases for Azure AI Language service.

| Use case | Documentation |  Customizable* |
|----------|-----------------|---|
|Predict the intention of user inputs and extract information from them.|[AI Services conversational language understanding](/azure/ai-services/language-service/conversational-language-understanding/overview)|  Yes
|Identify and/or redact sensitive information such as PII. |[AI Services Personally Identifiable Information (PII) detection](/azure/ai-services/language-service/personally-identifiable-information/overview)|  |
|Identify the language that a text was written in.| [Azure AI Language service language detection](/azure/ai-services/language-service/language-detection/overview) | |
|Extract medical information from clinical/medical documents, without building a model.|[AI Services Text Analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview)|   |
|Extract medical information from clinical/medical documents using a model that's trained on your data. |[AI Services key phrase extraction](/azure/ai-services/language-service/custom-text-analytics-for-health/overview)|   |
|Extract categories of information without creating a custom model.|[Named Entity Recognition (NER) in Azure AI Language](/azure/ai-services/language-service/named-entity-recognition/overview)|   |
|Extract categories of information using a model specific to your data.|[Custom named entity recognition (NER)](/azure/ai-services/language-service/custom-named-entity-recognition/overview)|   Yes |
|Extract main topics and important phrases.|[AI Services key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview)|  |
|Summarize a document|[Using text, document and conversation summarization](/azure/ai-services/language-service/summarization/quickstart?tabs=text-summarization)|   |
| Classify text by using sentiment analysis. | [Azure AI Language service sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/quickstart) |  Yes |
| Classify text by using custom classes. | [Azure AI Language service custom text classification](/azure/ai-services/language-service/custom-text-classification/quickstart)|  Yes |
| Classify items into categories provided at inference time. | [Azure AI Language service custom text classification](/azure/ai-services/openai/how-to/completions#classification) |  |
|Link an entity with knowledge base articles. | [Azure AI Language service Entity Linking](/azure/ai-services/language-service/entity-linking/overview) | |
| Understand questions and answers (generic). | [Azure AI Language service question answering](/azure/ai-services/language-service/question-answering/overview) |   Yes| 
| Build a conversational application that responds to user inputs. | [Azure AI Language service custom question answering](/azure/ai-services/language-service/question-answering/overview) |   |
| Connect apps from conversational language understanding, LUIS, and question answering. | [Azure AI Language service orchestration workflow](/azure/ai-services/language-service/orchestration-workflow/overview) |   Yes |

*If a feature is customizable, you can train an AI model using our tools to fit your data specifically. Otherwise a feature is preconfigured, meaning the AI models it uses cannot be changed. You just send your data, and use the feature's output in your applications.


### Azure AI Translator

[Azure AI Translator](https://azure.microsoft.com/products/ai-services/ai-translator) is a cloud-based neural machine translation service that is part of the Azure AI services family and can be used with any operating system. Translator powers many Microsoft products and services used by thousands of businesses worldwide for language translation and other language-related operations.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Translator service.

| Capability | Description | 
|----------|-------------|
| [**Text Translation**](text-translation-overview.md) | Execute text translation between supported source and target languages in real time. Create a [dynamic dictionary](dynamic-dictionary.md) and learn how to [prevent translations](prevent-translation.md) using the Translator API. |
| [**Document Translation**](document-translation/overview.md)| &bullet; **Asynchronous batch translation**: Translate batch and complex files while preserving the structure and format of the original documents. The batch translation process requires an Azure Blob storage account with containers for your source and translated documents.</br>&bullet;**Synchronous single file translation**: Translate a single document file alone or with a glossary file while preserving the structure and format of the original document. The file translation process doesn't require an Azure Blob storage account. The final response contains the translated document and is returned directly to the calling client. |
| [**Custom Translator**](custom-translator/overview.md) | Build customized models to translate domain- and industry-specific language, terminology, and style. [Create a dictionary (phrase or sentence)](custom-translator/concepts/dictionaries.md) for custom translations. |

#### Use cases

The following table provides a list of possible use cases for Azure AI Translator service.


| Use case | Documentation | 
|----------|-----------------|
|Translate industry-specific text.|[AI Services Custom Translator](/azure/ai-services/translator/custom-translator/overview)| 
|Translate generic text that isn't specific to an industry.|[What is Azure Text Translation](/azure/ai-services/translator/text-translation-overview)|

###  Azure AI Document Intelligence

[Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence) is a cloud-based Azure AI service that enables you to build intelligent document processing solutions. Massive amounts of data, spanning a wide variety of data types, are stored in forms and documents. Document Intelligence enables you to effectively manage the velocity at which data is collected and processed and is key to improved operations, informed data-driven decisions, and enlightened innovation.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Translator service.


| Capability | Description | 
|----------|-------------|
| Use a variety of document processing models to add intelligent document processing to your apps and flows.| Choose between a prebuilt domain specific model or train a custom model tailored to your specific business need and use cases. [Use Document Intelligence models](/azure/ai-services/document-intelligence/how-to-guides/use-sdk-rest-api?view=doc-intel-4.0.0&tabs=windows&pivots=programming-language-csharp&preserve-view=true)|


#### Use cases

The following table provides a list of possible use cases for Azure AI Document Intelligence service.


| Use case | Documentation | 
|----------|-----------------|
|Digitize any document.|[Use Document Intelligence Read Optical Character Recognition (OCR) model](/azure/ai-services/document-intelligence/concept-read?view=doc-intel-4.0.0&tabs=sample-code&preserve-view=true)| 
|Process handwritten notes** before translation.|[Document Intelligence Read Optical Character Recognition (OCR) model](/azure/ai-services/document-intelligence/concept-read?view=doc-intel-4.0.0&tabs=sample-code)| 
|Invoice processing. Extract and analyze key fields and line items from sales invoices, utility bills, and purchase orders. Invoices can be of various formats and quality including phone-captured images, scanned documents, and digital PDFs. |[Document Intelligence invoice model](/azure/ai-services/document-intelligence/concept-invoice?view=doc-intel-4.0.0&preserve-view=true)| 
|Identity document processing. Extract and analyze key fields from identity documents such as passport books, drivers licenses, identification cards, and permits|[Document Intelligence ID document model](/azure/ai-services/document-intelligence/concept-id-document?view=doc-intel-4.0.0&preserve-view=true)| 
|US bank statement processing. Extract and analyze key fields from US bank statements.|[Document Intelligence bank statement model](/azure/ai-services/document-intelligence/concept-bank-statement?view=doc-intel-4.0.0&preserve-view=true)| 
|US printed check processing. Extract and analyze key fields from US printed checks.|[Document Intelligence bank check model](/azure/ai-services/document-intelligence/concept-bank-check?view=doc-intel-4.0.0&preserve-view=true)| 
| Build a generative model and extract the fields, clauses, and obligations from a wide array of contract types for contract lifecycle management.|  [Document Field extraction - custom generative AI model](/azure/ai-services/document-intelligence/concept-custom-generative?view=doc-intel-4.0.0)|  
| Use a custom generative AI model to automate the loan and mortgage application process.| [Document Field extraction - custom generative AI model](/azure/ai-services/document-intelligence/concept-custom-generative?view=doc-intel-4.0.0)&preserve-view=true| 
| Build a generative model to analyze complex documents like financial reports and asset management reports.| [Document Field extraction - custom generative AI model](/azure/ai-services/document-intelligence/concept-custom-generative?view=doc-intel-4.0.0&preserve-view=true)| 
| Build a generative model to parse, validate, and extract expenses across different formats and documents with varying template | [Document Field extraction - custom generative AI model](/azure/ai-services/document-intelligence/concept-custom-generative?view=doc-intel-4.0.0&preserve-view=true)| 




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

- [What is Azure AI Language?](/azure/ai-services/language-service/overview)
- [Learning path: Develop natural language processing solutions with Azure AI Services](/training/paths/develop-language-solutions-azure-ai/)
- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai/)

## Related resources

- [Azure AI Speech service capabilities guide ](speech-api.md)
- [Types of vision API services](vision-api.md)
