---
title: Choose an Azure AI Targeted Language Processing Technology
description: Learn about Azure AI services targeted language processing capabilities, including NLP, text analytics, translation, and document data extraction.
author: ritesh-modi
ms.author: rimod
ms.date: 03/20/2025
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure AI targeted language processing technology

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers AI services that provide targeted language processing capabilities such as natural language processing (NLP), text analytics, language understanding, translation, and document data extraction. Microsoft Azure AI Language is one of the broadest categories in AI services. You can use the APIs in your workload to incorporate language features like named entity recognition (NER), sentiment analysis, language detection, and text summarization.

## Services

The following services provide targeted language processing capabilities for AI services:

- [Language](#language) provides NLP for text analysis.

  - **Use** Language when you need to work with structured or unstructured documents for the wide array of language-related tasks described in this article.

  - **Don't use** Language if you need to search documents with chat, check them for content safety, or translate them.

- [Microsoft Azure AI Translator](#translator) is a machine translation service. It can perform [real-time text translation](/azure/ai-services/translator/text-translation-overview), batch and single file [document translation](/azure/ai-services/translator/document-translation/overview), and [custom translations](/azure/ai-services/translator/custom-translator/overview) that you can use to incorporate specialized terminology or industry-specific language for your scenario. Translator [supports multiple languages](/azure/ai-services/translator/language-support).

  - **Use** Translator when you need to perform translation specifically. You can use other general purpose foundation language models to perform translation. But using Translator for its specialized purpose can be more effective and cost effective because of its targeted translation models.
  
  - **Don't use** Translator if you need to engage with chat, analyze content for sentiment, or moderate content. For sentiment analysis, use Language instead. For content moderation, use Microsoft Azure AI Content Safety.

- [Azure AI Document Intelligence](#document-intelligence) is a service that can convert images directly into electronic forms. You can specify expected fields and then search images that you provide to capture those fields without human intervention. Document Intelligence hosts many prebuilt models and also allows you to build custom models of your own.

  - **Use** Document Intelligence when you know exactly which fields you need to extract from scanned documents to fill electronic forms appropriately.

  - **Use** Document Intelligence to identify key structures, like headers, footers, and chapter breaks, in varied collections of documents to further programmatically interact with the document, such as in a retrieval augmented generation (RAG) implementation.

  - **Don't use** Document Intelligence as a real-time search API.

### Azure OpenAI in Foundry Models

[Azure OpenAI in Foundry Models](/azure/ai-services/openai/overview) provides REST API access to OpenAI's powerful language models. These models include O3-Mini, O1, O1-Mini, GPT-4o, GPT-4o Mini, GPT-4 Turbo with Vision, GPT-4, GPT-3.5-Turbo, and the Embeddings model series. These models are highly adaptable, which allows you to tailor them for tasks like content generation, summarization, image analysis, and semantic search. They also support natural language to code translation, which makes them versatile for various applications.

#### Capabilities

The following table provides a list of capabilities available in Azure OpenAI.

| Capability | Description |
| :----------| :-------------|
| [Text generation and completion](/azure/ai-services/openai/concepts/prompt-engineering) | Generates humanlike text based on prompts, automatically completes sentences or paragraphs, summarizes long documents into concise summaries, and answers questions based on context. |
| [Chat](/azure/ai-services/openai/chatgpt-quickstart) | Build chatbots and virtual assistants, maintain context in multiple-turn conversations, and personalize responses based on user interaction. |
| [Assistants](/azure/ai-services/openai/concepts/assistants) | Create a copilot-like experience that maintains a consistent personality across user interactions. Enable the use of multiple tools simultaneously, such as code implementation and knowledge search. |
| [Embeddings](/azure/ai-services/openai/concepts/understand-embeddings) | Convert text into numerical vectors where similar meanings are positioned close together in vector space. This process enables powerful similarity search in services such as Azure AI Search, Azure Cosmos DB, Azure SQL Database, and Azure Database for PostgreSQL. |
| [Content filtering](/azure/ai-services/openai/concepts/content-filter) | Screens both user inputs and AI outputs for harmful content in categories such as hate, sexual content, violence, and self-harm, with support for multiple languages. It also monitors usage patterns to help ensure compliance. |
| [LLM customization](/azure/ai-services/openai/concepts/customizing-llms) | Provides model adaptation techniques, including prompt engineering for quick adjustments, RAG for incorporating external information, and fine-tuning to train the model on specialized tasks. You can combine these methods to optimize performance for specific use cases. |

### Language

[Language](/azure/ai-services/language-service/overview) is a cloud-based service that provides NLP features for understanding and analyzing text. Use this service to help build intelligent applications by using the web-based Language Studio, REST APIs, and client libraries.

#### Capabilities

The following table provides a list of capabilities available in Language.

| Capability | Description |
| :----------| :-------------|
| [Custom question answering](/azure/ai-services/language-service/question-answering/overview) | Finds the most appropriate answer for inputs from your users. It's commonly used to build conversational client applications, such as social media applications, chat bots, and speech-enabled desktop applications. |
| [Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) | Builds custom AI models to classify unstructured text documents into custom classes that you define. |
| [Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview)| Build custom natural language understanding models to predict the overall intention of an incoming message and extract important information from it. |
| [Entity linking](/azure/ai-services/language-service/entity-linking/overview) | Disambiguates the identity of words or phrases found in unstructured text and returns links to Wikipedia. |
| [Language detection](/azure/ai-services/language-service/language-detection/overview) | Detects the language a document is written in and returns a language code for a wide range of languages, variants, dialects, and some regional or cultural languages. |
| [Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview) | Evaluates and returns the main concepts in unstructured text and returns them as a list. |
| [NER](/azure/ai-services/language-service/named-entity-recognition/overview) | Categorizes words or phrases in unstructured text across several predefined [category groups](/azure/ai-services/language-service/named-entity-recognition/concepts/named-entity-categories), such as people, events, places, and dates. |
| [Orchestration workflow](/azure/ai-services/language-service/language-detection/overview) | Use to connect [CLU](/azure/ai-services/language-service/conversational-language-understanding/overview). |
| [Personally identifying information (PII) and personally identifying health information detection](/azure/ai-services/language-service/personally-identifiable-information/overview)| Identifies, categorizes, and redacts sensitive information in both [unstructured text documents](/azure/ai-services/language-service/personally-identifiable-information/how-to-call) and [conversation transcripts](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations), such as phone numbers, email addresses, and forms of identification. For more information, see [Supported PII entity categories](/azure/ai-services/language-service/personally-identifiable-information/concepts/entity-categories). |
| [Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview) | Helps you understand what people think of your brand or topic by analyzing text for signs of positive or negative sentiment and linking them to specific aspects of the content.|
| [Summarization](/azure/ai-services/language-service/summarization/overview)| Uses extractive text summarization to produce a summary of documents and conversation transcriptions. It extracts sentences that collectively represent the most important or relevant information within the original content. |
| [Text analysis for health](/azure/ai-services/language-service/text-analytics-for-health/overview) | Extracts and labels relevant medical information from unstructured texts such as doctor's notes, discharge summaries, clinical documents, and electronic health records. When you design your workload, evaluate the processing location and data residency of this cloud-hosted feature to ensure that it aligns with your compliance expectations. Some workloads might be restricted in their capacity to send healthcare data to a cloud-hosted platform. You can use this API as a Docker container to host in your own compute in the cloud or on-premises. This process might help address compliance concerns that include platform as a service. For more information, see [Use Text Analytics for health containers](/azure/ai-services/language-service/text-analytics-for-health/how-to/use-containers). |

#### Use cases

The following table provides a list of possible use cases for Language.

| Use case | Customizable |
| :----------|:-----------------|
| [Predict the intention of user inputs and extract information from them](/azure/ai-services/language-service/conversational-language-understanding/overview). |  Yes |
| [Identify and redact sensitive information such as PII](/azure/ai-services/language-service/personally-identifiable-information/overview). |  |
| [Identify the language that a text was written in](/azure/ai-services/language-service/language-detection/overview). | |
| [Extract medical information from clinical or medical documents without building a model](/azure/ai-services/language-service/text-analytics-for-health/overview). |   |
| [Extract medical information from clinical or medical documents by using a model that's trained on your data](/azure/ai-services/language-service/custom-text-analytics-for-health/overview). | Yes |
| [Extract categories of information without creating a custom model](/azure/ai-services/language-service/named-entity-recognition/overview). |   |
| [Extract categories of information by using a model specific to your data](/azure/ai-services/language-service/custom-named-entity-recognition/overview). | Yes |
| [Extract main topics and important phrases](/azure/ai-services/language-service/key-phrase-extraction/overview). |  |
| [Summarize a document](/azure/ai-services/language-service/summarization/quickstart?tabs=text-summarization). |   |
| [Classify text by using sentiment analysis](/azure/ai-services/language-service/sentiment-opinion-mining/quickstart). | Yes |
| [Classify text by using custom classes](/azure/ai-services/language-service/custom-text-classification/quickstart). | Yes |
| [Classify items into categories provided at inference time](/azure/ai-services/openai/how-to/completions#classification). |  |
| [Link an entity with knowledge base articles](/azure/ai-services/language-service/entity-linking/overview). | |
| [Understand questions and answers (generic)](/azure/ai-services/language-service/question-answering/overview). | Yes |
| [Build a conversational application that responds to user inputs](/azure/ai-services/language-service/question-answering/overview). |   |
| [Connect apps from CLU and question answering](/azure/ai-services/language-service/orchestration-workflow/overview). | Yes |

If a feature is customizable, you can train an AI model by using our tools to fit your specific data. Otherwise, the feature is preconfigured, which means that its AI models remain unchanged. You provide your data and use the feature's output in your applications.

### Translator

[Translator](https://azure.microsoft.com/products/ai-services/ai-translator) is a machine translation service that is part of AI services. Translator powers many Microsoft products and services.

#### Capabilities

The following table provides a list of capabilities available in Translator.

| Capability | Description |
| :----------| :-------------|
| [Azure Text translation](/azure/ai-services/translator/text-translation-overview) | Perform text translation between supported source and target languages in real time. Create a [dynamic dictionary](/azure/ai-services/translator/dynamic-dictionary) and learn how to [prevent translations](/azure/ai-services/translator/prevent-translation) by using the Translator API. |
| [Document translation](/azure/ai-services/translator/document-translation/overview)| **Asynchronous batch translation:** Translate batch and complex files while preserving the structure and format of the original documents. The batch translation process requires an Azure Blob Storage account that has containers for your source and translated documents. </br> **Synchronous single file translation:** Translate a single document file alone or with a glossary file while preserving the structure and format of the original document. The file translation process doesn't require a Blob Storage account. The final response contains the translated document and is returned directly to the calling client. |
| [Custom Translator](/azure/ai-services/translator/custom-translator/overview) | Build customized models to translate domain- and industry-specific language, terminology, and style. [Create a dictionary (phrase or sentence)](/azure/ai-services/translator/custom-translator/concepts/dictionaries) for custom translations. |

#### Use cases

The following table provides a list of possible use cases for Translator.

| Use case | Documentation |
| :----------| :-----------------|
|Translate industry-specific text. | [Custom Translator](/azure/ai-services/translator/custom-translator/overview) |
|Translate generic text that isn't specific to an industry. | [Azure Text translation](/azure/ai-services/translator/text-translation-overview) |

### Document Intelligence

[Language](/azure/ai-services/document-intelligence/overview) is a cloud-based service that provides NLP features for understanding and analyzing text. Use this service to help build intelligent applications by using the web-based Language Studio, REST APIs, and client libraries.

#### Capabilities

The following table provides a list of some of the capabilities available in Document Intelligence.

| Capability | Description|
| :----------| :-------------|
| [Business card extraction](/azure/ai-services/document-intelligence/concept-business-card) | The Document Intelligence business card model combines Optical Character Recognition (OCR) capabilities with deep learning models to analyze and extract data from business card images. The API analyzes printed business cards, extracts key information such as first name, surname, company name, email address, and phone number, and then returns a structured JSON data representation. |
| [Contract model extraction](/azure/ai-services/document-intelligence/concept-contract) | The Document Intelligence contract model uses OCR capabilities to analyze and extract key fields and line items from a select group of important contract entities. Contracts can be of various formats and quality, including phone-captured images, scanned documents, and digital PDFs. The API analyzes document text, extracts key information such as parties, jurisdictions, contract ID, and title, and then returns a structured JSON data representation. The model currently supports document formats in English. |
| [Credit card extraction](/azure/ai-services/document-intelligence/concept-credit-card) | The Document Intelligence credit/debit card model uses OCR capabilities to analyze and extract key fields from credit and debit cards. Credit and debit cards can appear in various formats and qualities, including images captured by phone, scanned documents, and digital PDFs. The API analyzes document text, extracts key information such as card number, issuing bank, and expiration date, and then returns a structured JSON data representation. The model currently supports document formats in English. |
| [Health insurance card extraction](/azure/ai-services/document-intelligence/concept-health-insurance-card) | The Document Intelligence health insurance card model combines OCR capabilities with deep learning models to analyze and extract key information from US health insurance cards. A health insurance card is a key document for care processing and can be digitally analyzed for patient onboarding, financial coverage information, cashless payments, and insurance claim processing. The health insurance card model analyzes health card images, extracts key information such as insurer, member, prescription, and group number, and then returns a structured JSON representation. Health insurance cards can appear in various formats and qualities, including images captured by phone, scanned documents, and digital PDFs. |
| [US tax document extraction](/azure/ai-services/document-intelligence/concept-tax-document) | The Document Intelligence contract model uses OCR capabilities to analyze and extract key fields and line items from a select group of tax documents. Tax documents can be of various formats and quality, including phone-captured images, scanned documents, and digital PDFs. The API analyzes document text, extracts key information such as customer name, billing address, due date, and amount due, and then returns a structured JSON data representation. The model currently supports specific tax document formats in English. |
| [Client libraries](/azure/ai-services/document-intelligence/concept-model-overview) | Document Intelligence supports a wide range of models that enable you to add intelligent document processing to your apps and flows. You can use a prebuilt domain-specific model or train a custom model tailored to your specific business need and use cases. Document Intelligence can be used with the REST API or Python, C#, Java, and JavaScript client libraries. |

For more information about model scenarios, see [Which model should I choose?](/azure/ai-services/document-intelligence/choose-model-feature)

## Next steps

- [What is Language?](/azure/ai-services/language-service/overview)
- [Learning path: Develop NLP solutions with AI services](/training/paths/develop-language-solutions-azure-ai/)
- [Learning path: Get started with AI services](/training/paths/get-started-azure-ai/)

## Related resources

- [Microsoft Azure AI Speech capabilities guide](speech-recognition-generation.md)
- [Microsoft Azure AI Vision capabilities guide](image-video-processing.md)
