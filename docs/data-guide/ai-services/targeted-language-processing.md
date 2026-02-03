---
title: Choose an Azure AI Targeted Language Processing Technology
description: Learn about Azure Foundry Tools targeted language processing capabilities, including NLP, text analytics, translation, and document data extraction.
author: ritesh-modi
ms.author: rimod
ms.date: 02/03/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure AI targeted language processing technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Foundry Tools that provide targeted language processing capabilities such as natural language processing (NLP), text analytics, language understanding, translation, and document data extraction, including: 

- [Azure OpenAI in Foundry Models](#azure-openai-in-foundry-models) provides REST API access to OpenAI's powerful language models for tasks like content generation, summarization, image analysis, semantic search, and natural language to code translation.

- [Azure Language](#azure-language) is a cloud-based service that provides NLP features for understanding and analyzing text, including named entity recognition, sentiment analysis, language detection, summarization, and question answering.

- [Azure Translator](#azure-translator) is a machine translation service. It can perform [real-time text translation](/azure/ai-services/translator/text-translation-overview), batch and single file [document translation](/azure/ai-services/translator/document-translation/overview), and [custom translations](/azure/ai-services/translator/custom-translator/overview) that you can use to incorporate specialized terminology or industry-specific language for your scenario. Azure Translator [supports multiple languages](/azure/ai-services/translator/language-support).

- [Azure AI Document Intelligence](#document-intelligence) is a service that can convert images directly into electronic forms. You can specify expected fields and then search images that you provide to capture those fields without human intervention. Document Intelligence hosts many prebuilt models and also allows you to build custom models of your own.

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

### Azure Language

[Azure Language](/azure/ai-services/language-service/overview) provides specialized tools that enable seamless integration between AI agents and language processing services through standardized protocols.

| Use Azure Language to | Don't use Azure Language to |
| :----------| :-------------|
| Build intelligent applications using the web-based Microsoft Foundry, REST APIs, and client libraries. | Search documents with chat. |
| Work with structured or unstructured documents for the wide array of language-related tasks described in this article. | Check documents for content safety. |
| | Translate documents. For translation, use Azure Translator instead. |

#### Available Azure Language tools

The [Azure Language MCP server](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-mcp-server-) creates a standardized bridge that connects AI agents directly to Azure Language services through industry-standard protocols. This integration enables developers to build conversational applications with reliable NLP capabilities while ensuring enterprise-grade compliance, data protection, and processing accuracy throughout AI workflows. Azure Language provides both remote and local MCP server options:

- **Remote server**: Available through Foundry Tool Catalog for cloud-hosted deployments.
- **Local server**: Available for developers who prefer to host the server in their own environment.

#### Available Azure Language agents

The following table provides a list of agents available in Azure Language for conversational AI scenarios.

| Agent | Description |
| :----------| :-------------|
| [Intent Routing agent](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-intent-routing-agent-) | Manages conversation flows by understanding user intentions and delivering accurate responses in conversational AI applications. Uses predictable decision-making processes combined with controlled response generation to ensure consistent, reliable interactions. |
| [Exact Question Answering agent](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-exact-question-answering-agent-) | Provides reliable, word-for-word responses to important business questions. Automates frequently asked questions while maintaining human oversight and quality control to ensure accuracy and compliance. |

#### Available Azure Language features

The following table provides a list of features available in Azure Language.

| Feature | Description |
| :----------| :-------------|
| [Named entity recognition (NER)](/azure/ai-services/language-service/named-entity-recognition/overview) | Identifies different entries in text and categorizes them into predefined types such as people, events, places, and dates. |
| [PII and health data detection](/azure/ai-services/language-service/personally-identifiable-information/overview)| Identifies entities in text and conversations (chat or transcripts) that are associated with individuals. Detects and redacts sensitive information such as phone numbers, email addresses, and forms of identification. |
| [Language detection](/azure/ai-services/language-service/language-detection/overview) | Evaluates text and detects a wide range of languages and variant dialects. |
| [Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview) | Helps you understand public perception of your brand or topic by analyzing text for signs of positive or negative sentiment and linking them to specific aspects of the content.|
| [Summarization](/azure/ai-services/language-service/summarization/overview)| Condenses information for text and conversations. Supports extractive summarization (selecting key sentences), abstractive summarization (generating new concise sentences), conversation summarization (recapping meetings with timestamps), and call center summarization. |
| [Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview) | Evaluates and returns the main concepts in unstructured text as a list. |
| [Entity linking](/azure/ai-services/language-service/entity-linking/overview) | Disambiguates the identity of entities (words or phrases) found in unstructured text and returns links to Wikipedia. Entity linking is retiring effective September 1, 2028. We recommend that you migrate existing workloads to NER. |
| [Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview) | Extracts and labels relevant medical information from unstructured texts such as doctor's notes, discharge summaries, clinical documents, and electronic health records. When you design your workload, evaluate the processing location and data residency of this cloud-hosted feature to ensure that it aligns with your compliance expectations. Some workloads might be restricted in their capacity to send healthcare data to a cloud-hosted platform. You can use this API as a Docker container to host in your own compute in the cloud or on-premises. This process might help address compliance concerns that include platform as a service. For more information, see [Use Text Analytics for health containers](/azure/ai-services/language-service/text-analytics-for-health/how-to/use-containers). |
| [Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) | Builds custom AI models to classify unstructured text documents into custom classes that you define. |
| [Custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/overview) | Builds custom AI models to extract custom entity categories (labels for words or phrases) using unstructured text that you provide. |
| [Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview)| Builds custom natural language understanding models to predict the overall intention of an incoming utterance and extract important information from it. |
| [Orchestration workflow](/azure/ai-services/language-service/orchestration-workflow/overview) | Connects [CLU](/azure/ai-services/language-service/conversational-language-understanding/overview), [question answering](/azure/ai-services/language-service/question-answering/overview), and [LUIS](/azure/ai-services/luis/what-is-luis) applications. |
| [Question answering](/azure/ai-services/language-service/question-answering/overview) | Identifies the most suitable answer for user inputs. Commonly used to build conversational client applications, such as social media applications, chat bots, and speech-enabled desktop applications. |

#### Which Language feature should I use?

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

*\* If a feature is customizable, you can train an AI model by using our tools to fit your specific data. Otherwise, the feature is preconfigured, which means that its AI models remain unchanged. You provide your data and use the feature's output in your applications.*



### Azure Translator

[Azure Translator](/azure/ai-services/translator/overview) is a cloud-based neural machine translation service that's part of Foundry Tools. Azure Translator powers many Microsoft products and services used by thousands of businesses worldwide for language translation and other language-related operations.

| Use Azure Translator to | Don't use Azure Translator to |
| :----------| :-------------|
| Perform translation specifically. Azure Translator is more effective and cost effective than general purpose foundation language models because of its targeted translation models. | Engage with chat. |
| | Analyze content for sentiment. For sentiment analysis, use Azure Language instead. |
| | Moderate content. For content moderation, use Microsoft Azure AI Content Safety. |

#### Features and development options

The following table provides a list of features available in Azure Translator.

| Feature | Description |
| :----------| :-------------|
| [Text translation (preview)](/azure/ai-services/translator/text-translation-overview) | The 2025-10-01-preview version introduces the newest cloud-based, multilingual, neural machine translation service. Key enhancements include the option to select specified large language models (LLM), adaptive custom translation, and expanded parameters for translation requests. |
| [Text translation v3 (GA)](/azure/ai-services/translator/text-translation-overview) | Perform text translation between supported source and target languages in real time. Create a [dynamic dictionary](/azure/ai-services/translator/dynamic-dictionary) and learn how to [prevent translations](/azure/ai-services/translator/prevent-translation) by using the Azure Translator API. |
| [Document translation (asynchronous)](/azure/ai-services/translator/document-translation/overview)| Translate batch and complex files while preserving the structure and format of the original documents. The batch translation process requires an Azure Blob Storage account that has containers for your source and translated documents. |
| [Document translation (synchronous)](/azure/ai-services/translator/document-translation/overview)| Translate a single document file alone or with a glossary file while preserving the structure and format of the original document. The file translation process doesn't require a Blob Storage account. The final response contains the translated document and is returned directly to the calling client. |
| [Custom Translator](/azure/ai-services/translator/custom-translator/overview) | Build customized models to translate domain- and industry-specific language, terminology, and style. [Create a dictionary (phrase or sentence)](/azure/ai-services/translator/custom-translator/concepts/dictionaries) for custom translations. |

> [!TIP]
> Use [Microsoft Foundry](https://ai.azure.com/) for text and synchronous document translation operations via a no-code interface.

#### Use cases

The following table provides a list of possible use cases for Azure Translator.

| Use case | Documentation |
| :----------| :-----------------|
| Translate industry-specific text. | [Custom Translator](/azure/ai-services/translator/custom-translator/overview) |
| Translate generic text that isn't specific to an industry. | [Text translation](/azure/ai-services/translator/text-translation-overview) |

### Document Intelligence

[Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) is a cloud-based Foundry Tools service that you can use to build intelligent document processing solutions. Use Document Intelligence to automate document processing in applications and workflows, enhance data-driven strategies, and enrich document search capabilities.

| Use Document Intelligence to | Don't use Document Intelligence to |
| :----------| :-------------|
| Extract specific fields from scanned documents to fill electronic forms appropriately. | Perform real-time search. |
| Identify key structures, like headers, footers, and chapter breaks, in varied collections of documents to further programmatically interact with the document, such as in a RAG implementation. | |

#### Document analysis models

Document analysis models enable text extraction from forms and documents and return structured business-ready content.

| Model | Description |
| :----------| :-------------|
| [Read](/azure/ai-services/document-intelligence/prebuilt/read) | Extract printed and handwritten text from documents. Use for digitizing documents, compliance and auditing, and processing handwritten notes. |
| [Layout](/azure/ai-services/document-intelligence/prebuilt/layout) | Extract text, tables, and document structure. Use for document indexing and retrieval by structure, and financial and medical report analysis. |

#### Prebuilt models

Prebuilt models add intelligent document processing to your apps and flows without having to train and build your own models.

| Model | Description |
| :----------| :-------------|
| [Invoice](/azure/ai-services/document-intelligence/prebuilt/invoice) | Extract customer and vendor details from invoices. Use for accounts payable processing and automated tax recording and reporting. |
| [Receipt](/azure/ai-services/document-intelligence/prebuilt/receipt) | Extract sales transaction details from receipts. Use for expense management, consumer behavior data analysis, and merchandise return processing. |
| [Identity](/azure/ai-services/document-intelligence/prebuilt/id-document) | Extract key information from passports, ID cards, and driver's licenses. Use for Know your customer (KYC) compliance, medical account management, and identity checkpoints. |
| [Health insurance card](/azure/ai-services/document-intelligence/prebuilt/health-insurance-card) | Extract key information from US health insurance cards such as insurer, member, and group number. Use for coverage and eligibility verification, and value-based analytics. |
| [Contract](/azure/ai-services/document-intelligence/prebuilt/contract) | Extract agreement and party details from contracts of various formats including scanned documents and digital PDFs. |
| [Credit card](/azure/ai-services/document-intelligence/prebuilt/credit-card) | Extract key fields from credit and debit cards such as card number, issuing bank, and expiration date. |
| [Bank statement](/azure/ai-services/document-intelligence/prebuilt/bank-statement) | Extract account information and transaction details from bank statements. Use for tax processing, accounting management, and loan documentation processing. |
| [Bank Check](/azure/ai-services/document-intelligence/prebuilt/bank-check) | Extract relevant information from checks. Use for credit management and automated lender management. |
| [Pay stub](/azure/ai-services/document-intelligence/prebuilt/pay-stub) | Extract pay stub details. Use for employee payroll detail verification and fraud detection. |
| [Marriage certificate](/azure/ai-services/document-intelligence/prebuilt/marriage-certificate) | Extract certified marriage information from US marriage certificates. |
| [US mortgage documents](/azure/ai-services/document-intelligence/prebuilt/mortgage-documents) | Extract loan application details from 1003, 1004, 1005, 1008 forms and closing disclosures. Use for Fannie Mae and Freddie Mac documentation requirements. |
| [US tax documents](/azure/ai-services/document-intelligence/prebuilt/tax-document) | Extract information from W-2, 1098, 1099, and 1040 tax form variations. Use for automated tax document management and mortgage loan application processing. |

#### Custom models

Custom models are trained by using your labeled datasets to extract distinct data from forms and documents that are specific to your use cases.

| Model | Description |
| :----------| :-------------|
| [Custom neural](/azure/ai-services/document-intelligence/train/custom-neural) | Extract data from mixed-type documents including structured (surveys, questionnaires), semistructured (invoices, purchase orders), and unstructured documents (contracts, letters). |
| [Custom template](/azure/ai-services/document-intelligence/train/custom-template) | Extract labeled values and fields from structured and semistructured documents with defined visual templates or common visual layouts. |
| [Custom composed](/azure/ai-services/document-intelligence/train/composed-models) | Combine a collection of custom models to analyze similar form types, like purchase orders. |
| [Custom classifier](/azure/ai-services/document-intelligence/train/custom-classifier) | Identify designated document types (classes) before invoking an extraction model. Use for loan application packages that contain application forms, pay slips, and bank statements. |

#### Add-on capabilities

Document Intelligence supports optional features that you can enable or disable depending on the document extraction scenario:

- High-resolution extraction
- Formula extraction
- Font property extraction
- Barcode property extraction
- Searchable PDF
- Query fields
- Key-value pairs

For more information about model scenarios, see [Which model should I choose?](/azure/ai-services/document-intelligence/choose-model-feature)


## Related resources

- [Microsoft Azure AI Speech capabilities guide](speech-recognition-generation.md)
- [Microsoft Azure AI Vision capabilities guide](image-video-processing.md)
