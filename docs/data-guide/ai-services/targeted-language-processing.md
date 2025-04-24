---
title: Choose an Azure AI Targeted Language Processing Technology
description: Learn about Azure AI services targeted language processing capabilities, including NLP, text analytics, translation, and document data extraction. Determine which service aligns best with your specific use case.
author: ritesh-modi
ms.author: rimod
categories:
- ai-machine-learning
ms.date: 03/20/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
products:
  - ai-services
ms.custom:
  - analytics
  - guide
  - arb-aiml
---

# Choose an Azure AI targeted language processing technology

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Azure AI services that provide targeted language processing capabilities such as natural language processing (NLP), text analytics, language understanding, translation, and document data extraction. Microsoft Azure AI Language is one of the broadest categories in Azure AI services. You can use the APIs in your workload to incorporate language features like named entity recognition, sentiment analysis, language detection, and text summarization.

## Services

The following services provide targeted language processing capabilities for Azure AI services:

- [Language](#language) provides NLP for text analysis.

  - **Use** Language when you need to work with structured or unstructured documents for the wide array of language related tasks described.

  - **Don't use** Language if you need to search documents with chat, check them for content safety, or translate them.

- [Microsoft Azure AI Translator](#translator) is a machine translation service. It can perform [real-time text translation](/azure/ai-services/translator/text-translation-overview), batch and single file [document translation](/azure/ai-services/translator/document-translation/overview), and [custom translations](/azure/ai-services/translator/custom-translator/overview) that you can use to incorporate specialized terminology or industry-specific language for your scenario. It supports [many languages](/azure/ai-services/translator/language-support).

  - **Use** Translator when you need to perform translation specifically. While you could use other general purpose foundation language models to perform translation, using the translator for its specialized purpose can prove more reliably effective and can be more cost effective by using targeted translation models.
  
  - **Don't use** Translator if you need engage with chat, analyze content for sentiment, or moderate content. For sentiment analysis, use Language instead. For content moderation, use Microsoft Azure AI Content Safety.

- [Azure AI Document Intelligence](#document-intelligence) is a service that can convert images directly into electronic forms. You can specify expected fields and then searches images you provide to capture those fields without human intervention. The service hosts many prebuilt models, and also allows you to build custom form models of your own.

  - **Use** Document Intelligence service when you know exactly which fields you need to extract from scanned documents to fill electronic forms appropriately.

  - **Use** Document Intelligence to identify key structures, like headers, footers, and chapter breaks, in varied collections of documents to further programmatically interact with the document, such as in a retrieval augmented generation (RAG) implementation.

  - **Don't use** Document Intelligence as a real-time search API.

### Azure OpenAI

[Azure OpenAI](/azure/ai-services/openai/overview) Azure OpenAI Service provides REST API access to OpenAI's powerful language models including o3-mini, o1, o1-mini, GPT-4o, GPT-4o mini, GPT-4 Turbo with Vision, GPT-4, GPT-3.5-Turbo, and Embeddings model series. These models can be easily adapted to your specific task including, but not limited to, content generation, summarization, image understanding, semantic search, and natural language to code translation.

#### Capabilities

The following table provides a list of capabilities available in Azure OpenAI.

| Capability | Description |
| :----------| :-------------|
| [Text generation and completion](/azure/ai-services/openai/concepts/prompt-engineering) | Generates human-like text based on prompts, automatically completes sentences or paragraphs, summarizes long documents into concise summaries, and answers questions based on context. |
| [Chat](/azure/ai-services/openai/chatgpt-quickstart) | Build chatbots and virtual assistants, maintain context in multiple-turn conversations, and personalize responses based on user interaction. |
| [Assistants](/azure/ai-services/openai/concepts/assistants) | Create a copilot-like experience that maintains a consistent personality across user interactions. Enable the use of multiple tools simultaneously, such as code implementation and knowledge search. |
| [Embeddings](/azure/ai-services/openai/concepts/understand-embeddings) | Convert text into numerical vectors where similar meanings are positioned close together in vector space. This process enables powerful similarity search in services such as Azure AI Search, Cosmos DB, SQL Database, and PostgreSQL. |
| [Content filtering](/azure/ai-services/openai/concepts/content-filter) | Screens both user inputs and AI outputs for harmful content in categories such as hate, sexual content, violence, and self-harm, with support for multiple languages. It also monitors usage patterns to ensure compliance. |
| [LLM customization](/azure/ai-services/openai/concepts/customizing-llms) | Provides model adaptation techniques, including prompt engineering for quick adjustments, RAG for incorporating external information, and fine-tuning to train the model on specialized tasks. These methods can be combined to optimize performance for specific use cases. |

### Language

[Language](/azure/ai-services/language-service/overview) is a cloud-based service that provides NLP features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries.

#### Capabilities

The following table provides a list of capabilities available in Language.

| Capability | Description |
| :----------| :-------------|
| [Custom question answering](/azure/ai-services/language-service/question-answering/overview) | Finds the most appropriate answer for inputs from your users, and is commonly used to build conversational client applications, such as social media applications, chat bots, and speech-enabled desktop applications. |
| [Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) | Use to build custom AI models to classify unstructured text documents into custom classes you define. |
| [Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview)| Use to build custom natural language understanding models to predict the overall intention of an incoming utterance and extract important information from it. |
| [Entity linking](/azure/ai-services/language-service/entity-linking/overview) | Disambiguates the identity of entities (words or phrases) found in unstructured text and returns links to Wikipedia. |
| [Language detection](/azure/ai-services/language-service/language-detection/overview) | Detects the language a document is written in, and returns a language code for a wide range of languages, variants, dialects, and some regional/cultural languages. |
| [Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview) | Evaluates and returns the main concepts in unstructured text, and returns them as a list. |
| [Named entity recognition (NER)](/azure/ai-services/language-service/named-entity-recognition/overview) | Categorizes entities (words or phrases) in unstructured text across several predefined category groups. For example: people, events, places, dates, [and more](/azure/ai-services/language-service/named-entity-recognition/concepts/named-entity-categories). |
| [Orchestration workflow](/azure/ai-services/language-service/language-detection/overview) | Use to connect [Conversational Language Understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview). |
| [Personally identifying (PII) and health (PHI) information detection](/azure/ai-services/language-service/personally-identifiable-information/overview)| Identifies, categorizes, and redacts sensitive information in both [unstructured text documents](/azure/ai-services/language-service/personally-identifiable-information/how-to-call), and [conversation transcripts](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations). For example: phone numbers, email addresses, forms of identification, [and more](/azure/ai-services/language-service/personally-identifiable-information/concepts/entity-categories). |
| [Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview) |Help you find out what people think of your brand or topic by mining text for clues about positive or negative sentiment, and can associate them with specific aspects of the text. |
| [Summarization](/azure/ai-services/language-service/summarization/overview)| Uses extractive text summarization to produce a summary of documents and conversation transcriptions. It extracts sentences that collectively represent the most important or relevant information within the original content. |
| [Text analysis for health](/azure/ai-services/language-service/text-analytics-for-health/overview) | Extracts and labels relevant medical information from unstructured texts such as doctor's notes, discharge summaries, clinical documents, and electronic health records. When designing your workload, evaluate the processing location and data residency of this cloud-hosted feature to ensure it aligns with your compliance expectations. Some workloads might be restricted in their capacity to send healthcare data to a cloud-hosted platform. You can use this API as a Docker container to host in your own compute in the cloud or on-premises, which might help address compliance concerns involving PaaS. For more information, see  [Use Text Analytics for health containers](/azure/ai-services/language-service/text-analytics-for-health/how-to/use-containers)|

#### Use cases

The following table provides a list of possible use cases for Language.

| Use case | Customizable |
| :----------|:-----------------|
| [Predict the intention of user inputs and extract information from them](/azure/ai-services/language-service/conversational-language-understanding/overview). |  Yes
| [Identify and/or redact sensitive information such as PII](/azure/ai-services/language-service/personally-identifiable-information/overview). |  |
| [Identify the language that a text was written in](/azure/ai-services/language-service/language-detection/overview). | |
| [Extract medical information from clinical/medical documents, without building a model](/azure/ai-services/language-service/text-analytics-for-health/overview) |   |
| [Extract medical information from clinical/medical documents using a model that's trained on your data](/azure/ai-services/language-service/custom-text-analytics-for-health/overview). | Yes |
| [Extract categories of information without creating a custom model](/azure/ai-services/language-service/named-entity-recognition/overview). |   |
| [Extract categories of information using a model specific to your data](/azure/ai-services/language-service/custom-named-entity-recognition/overview). | Yes |
| [Extract main topics and important phrases](/azure/ai-services/language-service/key-phrase-extraction/overview). |  |
| [Summarize a document](/azure/ai-services/language-service/summarization/quickstart?tabs=text-summarization)|   |
| [Classify text by using sentiment analysis](/azure/ai-services/language-service/sentiment-opinion-mining/quickstart). | Yes |
| [Classify text by using custom classes](/azure/ai-services/language-service/custom-text-classification/quickstart). | Yes |
| [Classify items into categories provided at inference time](/azure/ai-services/openai/how-to/completions#classification). |  |
| [Link an entity with knowledge base articles](/azure/ai-services/language-service/entity-linking/overview). | |
| [Understand questions and answers (generic)](/azure/ai-services/language-service/question-answering/overview). | Yes |
| [Build a conversational application that responds to user inputs](/azure/ai-services/language-service/question-answering/overview). |   |
| [Connect apps from conversational language understanding and question answering](/azure/ai-services/language-service/orchestration-workflow/overview). | Yes |

If a feature is customizable, you can train an AI model by using our tools to fit your data specifically. Otherwise, a feature is preconfigured, meaning the AI models it uses cannot be changed. You just send your data, and use the feature's output in your applications.

### Translator

[Translator](https://azure.microsoft.com/products/ai-services/ai-translator) is a machine translation service that is part of the Azure AI services family. Translator powers many Microsoft products and services.

#### Capabilities

The following table provides a list of capabilities available in Translator.

| Capability | Description |
| :----------| :-------------|
| [Text Translation](/azure/ai-services/translator/text-translation-overview) | Execute text translation between supported source and target languages in real time. Create a [dynamic dictionary](/azure/ai-services/translator/dynamic-dictionary) and learn how to [prevent translations](/azure/ai-services/translator/prevent-translation) using the Translator API. |
| [Document Translation](/azure/ai-services/translator/document-translation/overview)| **Asynchronous batch translation:** Translate batch and complex files while preserving the structure and format of the original documents. The batch translation process requires an Azure Blob storage account with containers for your source and translated documents. </br>**Synchronous single file translation:** Translate a single document file alone or with a glossary file while preserving the structure and format of the original document. The file translation process doesn't require an Azure Blob storage account. The final response contains the translated document and is returned directly to the calling client. |
| [Custom Translator](/azure/ai-services/translator/custom-translator/overview) | Build customized models to translate domain- and industry-specific language, terminology, and style. [Create a dictionary (phrase or sentence)](/azure/ai-services/translator/custom-translator/concepts/dictionaries) for custom translations. |

#### Use cases

The following table provides a list of possible use cases for Translator.

| Use case | Documentation |
| :----------| :-----------------|
|Translate industry-specific text. | [AI Services Custom Translator](/azure/ai-services/translator/custom-translator/overview)|
|Translate generic text that isn't specific to an industry. | [What is Azure Text Translation?](/azure/ai-services/translator/text-translation-overview)|

### Document Intelligence

[Language](/azure/ai-services/document-intelligence/overview) is a cloud-based service that provides NLP features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries.

#### Capabilities

The following table provides a list of some of the capabilities available in AI Document Intelligence.

| Capability | Description|
| :----------| :-------------|
| [Business card extraction](/azure/ai-services/document-intelligence/concept-business-card) | The Document Intelligence business card model combines Optical Character Recognition (OCR) capabilities with deep learning models to analyze and extract data from business card images. The API analyzes printed business cards; extracts key information such as first name, surname, company name, email address, and phone number; and returns a structured JSON data representation. |
| [Contract model extraction](/azure/ai-services/document-intelligence/concept-contract) |The Document Intelligence contract model uses Optical Character Recognition (OCR) capabilities to analyze and extract key fields and line items from a select group of important contract entities. Contracts can be of various formats and quality including phone-captured images, scanned documents, and digital PDFs. The API analyzes document text; extracts key information such as Parties, Jurisdictions, Contract ID, and Title; and returns a structured JSON data representation. The model currently supports English-language document formats. |
| [Credit card extraction](/azure/ai-services/document-intelligence/concept-credit-card) | The Document Intelligence credit/debit card model uses Optical Character Recognition (OCR) capabilities to analyze and extract key fields from credit and debit cards. Credit cards and debit cards can be of various formats and quality including phone-captured images, scanned documents, and digital PDFs. The API analyzes document text; extracts key information such as card number, issuing bank, and expiration date; and returns a structured JSON data representation. The model currently supports English-language document formats. |
| [Health insurance card extraction](/azure/ai-services/document-intelligence/concept-health-insurance-card) | The Document Intelligence health insurance card model combines Optical Character Recognition (OCR) capabilities with deep learning models to analyze and extract key information from US health insurance cards. A health insurance card is a key document for care processing and can be digitally analyzed for patient onboarding, financial coverage information, cashless payments, and insurance claim processing. The health insurance card model analyzes health card images; extracts key information such as insurer, member, prescription, and group number; and returns a structured JSON representation. Health insurance cards can be presented in various formats and quality including phone-captured images, scanned documents, and digital PDFs. |
| [US tax document extraction](/azure/ai-services/document-intelligence/concept-tax-document) | The Document Intelligence contract model uses Optical Character Recognition (OCR) capabilities to analyze and extract key fields and line items from a select group of tax documents. Tax documents can be of various formats and quality including phone-captured images, scanned documents, and digital PDFs. The API analyzes document text; extracts key information such as customer name, billing address, due date, and amount due; and returns a structured JSON data representation. The model currently supports certain English tax document formats. |
| [Many more](/azure/ai-services/document-intelligence/concept-model-overview). | Document Intelligence supports a wide variety of models that enable you to add intelligent document processing to your apps and flows. You can use a prebuilt domain-specific model or train a custom model tailored to your specific business need and use cases. Document Intelligence can be used with the REST API or Python, C#, Java, and JavaScript client libraries. |

To learn more about how to choose a model that works for your scenario, see [Which model should I choose?](/azure/ai-services/document-intelligence/choose-model-feature)

## Next steps

- [What is Language?](/azure/ai-services/language-service/overview)
- [Learning path: Develop NLP solutions with Azure AI Services](/training/paths/develop-language-solutions-azure-ai/)
- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai/)

## Related resources

- [Azure AI Speech service capabilities guide](speech-recognition-generation.md)
- [Azure AI Vision capabilities guide](image-video-processing.md)
