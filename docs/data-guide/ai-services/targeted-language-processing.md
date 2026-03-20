---
title: Choose an Azure AI Targeted Language Processing Technology
description: Learn about targeted language processing capabilities in Foundry Tools, including natural language processing, text analytics, translation, and document data extraction.
author: hudua
ms.author: hudua
ms.date: 03/20/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure AI targeted language processing technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) helps developers and organizations create AI-based, advanced, production-ready applications that align with responsible AI practices by using out-of-the-box, prebuilt, and customizable APIs and models.

This article describes targeted language processing capabilities that Tools provides, including natural language processing, text analytics, language understanding, translation, and document data extraction. It includes the following services: 

- [Azure Language in Foundry Tools](#azure-language) is a cloud-based service that provides natural language processing features for understanding and analyzing text, including named entity recognition (NER), sentiment analysis, language detection, summarization, and question answering.

- [Azure Translator in Foundry Tools](#azure-translator) is a machine translation service. It provides [real-time text translation](/azure/ai-services/translator/text-translation/overview), batch and single-file [document translation](/azure/ai-services/translator/document-translation/overview), and [custom translations](/azure/ai-services/translator/custom-translator/overview) that you can use to incorporate specialized terminology or industry-specific language for your use case. Azure Translator [supports multiple languages](/azure/ai-services/translator/language-support).

- [Azure Document Intelligence in Foundry Tools](#azure-document-intelligence) is a service that converts images directly into electronic forms. You can specify expected fields and search images that you provide to capture those fields without human intervention. Azure Document Intelligence hosts many prebuilt models. You can also use it to build your own custom models.

- [Azure Content Understanding in Foundry Tools](#azure-content-understanding) is a service that uses generative AI to extract schema-defined fields from documents by using natural language descriptions. Use Azure Content Understanding when your document type has no prebuilt Azure Document Intelligence model, when you need confidence scores and grounding for automated workflows, or when you need retrieval-augmented generation (RAG)-ready Markdown output.

- [Foundry Models](#models) is a service that provides AI models that you can use directly through APIs for language tasks like content generation, summarization, and translation.

## Azure Language

[Azure Language](/azure/ai-services/language-service/overview) provides specialized tools that connect agents to language processing services through standardized protocols.

| Use Azure Language for these tasks | Don't use Azure Language for these tasks |
| :----------| :-------------|
| Build intelligent applications by using the web-based Microsoft Foundry, REST APIs, and client libraries. | Search documents by using chat. Use [Azure AI Search](/azure/search/search-what-is-azure-search) instead. |
| Work with structured or unstructured documents for the wide range of language-related tasks that this article describes. | Check documents for content safety. Use [Content Safety in Foundry Control Plane](/azure/ai-services/content-safety/overview) instead. |
| | Translate documents. For translation, use [Azure Translator](#azure-translator). |

### Available Azure Language tools

The [Azure Language model context protocol (MCP) server](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-mcp-server-preview) connects agents directly to Azure Language services through the MCP. This integration allows developers to build conversational applications that have reliable natural language processing capabilities while ensuring enterprise-grade compliance, data protection, and processing accuracy throughout AI workflows. Azure Language provides both remote and local MCP server options:

- **Remote server:** Available through the Tools catalog for cloud-hosted deployments.
- **Local server:** Available for developers who prefer to host the server in their own environment.

### Available Azure Language agents

The following table provides a list of agents available in Azure Language for conversational AI scenarios.

| Agent | Description |
| :----------| :-------------|
| [Intent Routing agent](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-intent-routing-agent-preview) | Manages conversation flows by understanding user intentions and delivering accurate responses in conversational AI applications. Uses predictable decision-making processes combined with controlled response generation to ensure consistent, reliable interactions. |
| [Exact Question Answering agent](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-exact-question-answering-agent-preview) | Provides reliable, word-for-word responses to important business questions. Automates frequently asked questions while maintaining human oversight and quality control to ensure accuracy and compliance. |

### Available Azure Language features

The following table provides a list of features available in Azure Language.

| Feature | Description |
| :----------| :-------------|
| [NER](/azure/ai-services/language-service/named-entity-recognition/overview) | Identifies different entries in text and categorizes them into predefined types, like people, events, places, and dates. |
| [Personal data and health data detection](/azure/ai-services/language-service/personally-identifiable-information/overview)| Identifies entities in text and conversations, including chat or transcripts, associated with individuals. Detects and redacts sensitive information like phone numbers, email addresses, and forms of identification. |
| [Language detection](/azure/ai-services/language-service/language-detection/overview) | Evaluates text and detects a wide range of languages and dialects. |
| [Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview) | Helps you understand public perception of your brand or topic by analyzing text for signs of positive or negative sentiment and linking them to specific aspects of the content.|
| [Summarization](/azure/ai-services/language-service/summarization/overview)| Condenses information for text and conversations. Supports extractive summarization that selects key sentences, abstractive summarization that generates concise new sentences, conversation summarization that recaps meetings with timestamps, and call center summarization. |
| [Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview) | Evaluates and returns the main concepts in unstructured text as a list. |
| [Entity linking](/azure/ai-services/language-service/entity-linking/overview) | Disambiguates entity identities, like words or phrases, found in unstructured text and returns links to Wikipedia. Entity linking retires September 1, 2028. We recommend that you migrate existing workloads to NER. |
| [Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview) | Extracts and labels relevant medical information from unstructured texts like doctor's notes, discharge summaries, clinical documents, and electronic health records. <br><br> When you design your workload, evaluate the processing location and data residency of this cloud-hosted feature to ensure that it aligns with your compliance expectations. Some workloads might face restrictions that limit their capacity to send healthcare data to a cloud-hosted platform. <br><br> You can use this API as a Docker container to host in your own compute in the cloud or on-premises. This process can help address compliance concerns related to the use of platform as a service (PaaS) offerings. For more information, see [Use text analytics for health containers](/azure/ai-services/language-service/text-analytics-for-health/how-to/use-containers). |
| [Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) | Builds custom AI models to classify unstructured text documents into custom classes that you define. |
| [Custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/overview) | Builds custom AI models to extract custom entity categories, like labels for words or phrases, by using unstructured text that you provide. |
| [Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview)| Builds custom natural language processing models to predict the user's intent from each input and extract important information from it. |
| [Orchestration workflow](/azure/ai-services/language-service/orchestration-workflow/overview) | Connects [CLU](/azure/ai-services/language-service/conversational-language-understanding/overview) and [question answering](/azure/ai-services/language-service/question-answering/overview) applications. |
| [Question answering](/azure/ai-services/language-service/question-answering/overview) | Identifies the most suitable answer for user inputs. Commonly used to build conversational client applications, like social media applications, chatbots, and speech-enabled desktop applications. |

### Choose an Azure Language feature

The following table provides a list of possible use cases for Azure Language. If a feature is customizable, you can train an AI model by using Microsoft tools to fit your specific data. Otherwise, the feature is preconfigured, which means that its AI models remain unchanged. You provide your data and use the feature's output in your applications.

| Use case | Customizable |
| :----------|:-----------------|
| [Predict the intention of user inputs and extract information from them](/azure/ai-services/language-service/conversational-language-understanding/overview). |  Yes |
| [Identify and redact sensitive information like personal data](/azure/ai-services/language-service/personally-identifiable-information/overview). | No |
| [Identify the language that text is written in](/azure/ai-services/language-service/language-detection/overview). | No |
| [Extract medical information from clinical or medical documents without building a model](/azure/ai-services/language-service/text-analytics-for-health/overview). | No |
| [Extract medical information from clinical or medical documents by using a model trained on your data](/azure/ai-services/language-service/text-analytics-for-health/overview). | Yes |
| [Extract categories of information without creating a custom model](/azure/ai-services/language-service/named-entity-recognition/overview). | No |
| [Extract categories of information by using a model specific to your data](/azure/ai-services/language-service/custom-named-entity-recognition/overview). | Yes |
| [Extract main topics and important phrases](/azure/ai-services/language-service/key-phrase-extraction/overview). | No |
| [Summarize a document](/azure/ai-services/language-service/summarization/quickstart). | No |
| [Classify text by using sentiment analysis](/azure/ai-services/language-service/sentiment-opinion-mining/quickstart). | Yes |
| [Classify text by using custom classes](/azure/ai-services/language-service/custom-text-classification/quickstart). | Yes |
| [Classify items into categories provided at inference time](/azure/foundry/openai/how-to/responses). | No |
| [Link an entity with knowledge base articles](/azure/ai-services/language-service/entity-linking/overview). | No |
| [Understand generic questions and answers](/azure/ai-services/language-service/question-answering/overview). | Yes |
| [Build a conversational application that responds to user inputs](/azure/ai-services/language-service/question-answering/overview). | No |
| [Connect apps from CLU and question answering](/azure/ai-services/language-service/orchestration-workflow/overview). | Yes |

## Azure Translator

[Azure Translator](/azure/ai-services/translator/overview) is a cloud-based neural machine translation (NMT) service. Azure Translator powers many Microsoft products and services that businesses worldwide use for language translation and other language-related tasks.

| Use Azure Translator for these tasks | Don't use Azure Translator for these tasks |
| :----------| :-------------|
| Do translation specifically. Azure Translator is more effective and cost effective than general-purpose foundation language models because of its targeted translation models. | Engage with chat. |
| | Analyze content for sentiment. For sentiment analysis, use [Azure Language](/azure/ai-services/language-service/overview). |
| | Moderate content. For content moderation, use [Content Safety](/azure/ai-services/content-safety/overview). |

### Features and development options

The following table provides a list of features available in Azure Translator.

| Feature | Description |
| :----------| :-------------|
| [Text translation (preview)](/azure/ai-services/translator/text-translation/overview) | Use the 2025-10-01-preview version to select either standard NMT or a language model deployment (GPT-4o-mini or GPT-4o) to translate text. You need a Foundry resource to use a language model deployment. |
| [Text translation v3 (GA)](/azure/ai-services/translator/text-translation/overview) | Translate text between supported source and target languages in real time. Create a [dynamic dictionary](/azure/ai-services/translator/text-translation/how-to/use-dynamic-dictionary) and learn how to [prevent translations](/azure/ai-services/translator/text-translation/how-to/prevent-translation) by using the Azure Translator API. |
| [Asynchronous document translation](/azure/ai-services/translator/document-translation/overview)| Translate batch and complex files while preserving the structure and format of the original documents. The batch translation process requires an Azure Blob Storage account that has containers for your source and translated documents. |
| [Synchronous document translation](/azure/ai-services/translator/document-translation/overview)| Translate a single document file alone or with a glossary file while preserving the structure and format of the original document. The file translation process doesn't require a Blob Storage account. The final response contains the translated document and is returned directly to the calling client. |
| [Custom Translator](/azure/ai-services/translator/custom-translator/overview) | Build customized models to translate domain-specific and industry-specific language, terminology, and style. [Create a dictionary of phrases or sentences](/azure/ai-services/translator/custom-translator/concepts/dictionaries) for custom translations. |

> [!TIP]
> Use [Foundry](https://ai.azure.com/) for text and synchronous document translation tasks via a no-code interface.

### Use cases

The following table provides a list of possible use cases for Azure Translator.

| Use case | Documentation |
| :----------| :-----------------|
| Translate industry-specific text. | [Custom Translator](/azure/ai-services/translator/custom-translator/overview) |
| Translate generic text that isn't specific to an industry. | [Text translation](/azure/ai-services/translator/text-translation/overview) |

## Azure Document Intelligence

Use [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) to automate document processing in applications and workflows, enhance data-driven strategies, and enrich document search capabilities.

| Use Azure Document Intelligence for these tasks | Don't use Azure Document Intelligence for these tasks |
| :----------| :-------------|
| Extract specific fields from known document types that have a prebuilt model, like invoices, receipts, W-2s, or ID documents. | Extract fields from custom document types that have no prebuilt model and require flexible, schema-defined extraction. Use [Azure Content Understanding](#azure-content-understanding) instead. |
| Process high volumes of structured or semistructured documents when you need deterministic, low-variability extraction. | Build RAG pipelines that require Markdown-formatted output that has embedded figures, section hierarchy, and chunk-ready structure. Use [Azure Content Understanding](#azure-content-understanding) instead. |
| Train custom neural or template models on labeled datasets for document types specific to your business. | Require confidence scores and grounding for each extracted field to drive human-in-the-loop review workflows. Use [Azure Content Understanding](#azure-content-understanding) instead. |
| Identify key structures, like headers, footers, and chapter breaks, in varied collections of documents to further programmatically interact with the document. | |

### Document analysis models

Document analysis models extract text from forms and documents and return structured, business-ready content.

| Model | Description |
| :----------| :-------------|
| [Read](/azure/ai-services/document-intelligence/prebuilt/read) | Extract printed and handwritten text from documents. Use for digitizing documents, compliance and auditing tasks, and processing handwritten notes. |
| [Layout](/azure/ai-services/document-intelligence/prebuilt/layout) | Extract text, tables, and document structure. Use for document indexing and retrieval by structure and for financial and medical report analysis. |

### Document prebuilt models

Prebuilt models add intelligent document processing to your apps and flows without having to train and build your own models.

| Model | Description |
| :----------| :-------------|
| [Invoice](/azure/ai-services/document-intelligence/prebuilt/invoice) | Extract customer and vendor details from invoices. Use for accounts payable processing and automated tax recording and reporting. |
| [Receipt](/azure/ai-services/document-intelligence/prebuilt/receipt) | Extract sales transaction details from receipts. Use for expense management, consumer behavior data analysis, and merchandise return processing. |
| [Identity](/azure/ai-services/document-intelligence/prebuilt/id-document) | Extract key information from passports, ID cards, and driver's licenses. Use for Know Your Customer (KYC) compliance, medical account management, and identity checkpoints. |
| [Health insurance card](/azure/ai-services/document-intelligence/prebuilt/health-insurance-card) | Extract key information from US health insurance cards, like insurer, member, and group number. Use for coverage and eligibility verification and value-based analytics. |
| [Contract](/azure/ai-services/document-intelligence/prebuilt/contract) | Extract agreement and party details from contracts in various formats, including scanned documents and digital PDFs. |
| [Credit card](/azure/ai-services/document-intelligence/prebuilt/credit-card) | Extract key fields from credit and debit cards, like card number, issuing bank, and expiration date. |
| [Bank statement](/azure/ai-services/document-intelligence/prebuilt/bank-statement) | Extract account information and transaction details from bank statements. Use for tax processing, accounting management, and loan documentation processing. |
| [Bank check](/azure/ai-services/document-intelligence/prebuilt/bank-check) | Extract relevant information from checks. Use for credit management and automated lender management. |
| [Pay stub](/azure/ai-services/document-intelligence/prebuilt/pay-stub) | Extract pay stub details. Use for employee payroll detail verification and fraud detection. |
| [Marriage certificate](/azure/ai-services/document-intelligence/prebuilt/marriage-certificate) | Extract certified marriage information from US marriage certificates. |
| [US mortgage documents](/azure/ai-services/document-intelligence/prebuilt/mortgage-documents) | Extract loan application details from 1003, 1004, 1005, and 1008 forms and closing disclosures. Use for Fannie Mae and Freddie Mac documentation requirements. |
| [US tax documents](/azure/ai-services/document-intelligence/prebuilt/tax-document) | Extract information from W-2, 1098, 1099, and 1040 tax form variations. Use for automated tax document management and mortgage loan application processing. |

### Custom models

Train custom models by using your labeled datasets to extract distinct data from forms and documents specific to your use cases.

| Model | Description |
| :----------| :-------------|
| [Custom neural](/azure/ai-services/document-intelligence/train/custom-neural) | Extract data from mixed-type documents, including structured documents like surveys and questionnaires, semistructured documents like invoices and purchase orders, and unstructured documents like contracts and letters. |
| [Custom template](/azure/ai-services/document-intelligence/train/custom-template) | Extract labeled values and fields from structured and semistructured documents that have defined visual templates or common visual layouts. |
| [Custom composed](/azure/ai-services/document-intelligence/train/composed-models) | Combine a collection of custom models to analyze similar form types, like purchase orders. |
| [Custom classifier](/azure/ai-services/document-intelligence/train/custom-classifier) | Identify designated document types or classes before you invoke an extraction model. Use for loan application packages that contain application forms, pay slips, and bank statements. |

### Add-on capabilities

Azure Document Intelligence supports the following optional features that you can turn on or turn off depending on the document extraction scenario:

- High-resolution extraction
- Formula extraction
- Font property extraction
- Barcode property extraction
- Searchable PDF
- Query fields
- Key-value pairs

For more information about model scenarios, see [Choose an Azure Document Intelligence model](/azure/ai-services/document-intelligence/concept/choose-model-feature).

## Azure Content Understanding

[Azure Content Understanding](/azure/ai-services/content-understanding/overview) uses generative AI to extract structured fields from documents based on a schema that you define in natural language. Unlike Azure Document Intelligence, which relies on pretrained or custom-trained machine learning models tied to specific document layouts, Azure Content Understanding uses generative models to reason over document content and produce schema-aligned JSON or RAG-ready Markdown output. It also provides per-field confidence scores and grounding. Use these features to automate workflows with targeted human review.

| Use Azure Content Understanding for these tasks | Don't use Azure Content Understanding for these tasks |
| :----------| :-------------|
| Extract fields from document types that have no Azure Document Intelligence prebuilt model by using schema definitions written in natural language. | Extract fields from standard document types that have an existing Azure Document Intelligence prebuilt model. [Azure Document Intelligence](#azure-document-intelligence) is more cost-effective and deterministic for these scenarios. |
| Build RAG pipelines that require Markdown output that preserves layout, headings, tables, figures, and annotations for vector indexing. | Process high volumes of simple, structured documents when you need to minimize language model variability and cost. Use [Azure Document Intelligence](#azure-document-intelligence) instead. |
| Drive automation workflows that require per-field confidence scores and grounding to route low-confidence records to human review. | Do general-purpose language tasks like summarization or sentiment analysis. Use [Azure Language](#azure-language) or [Models](#models) instead. |
| Classify document types before you route them to the appropriate analyzer in a mixed-document pipeline. | |

### Available Azure Content Understanding features for documents

The following table provides a list of document features available in Azure Content Understanding.

| Feature | Description |
| :----------| :-------------|
| [Content extraction](/azure/ai-services/content-understanding/document/overview#content-extraction) | Transforms unstructured documents into structured, machine-readable data. Captures printed and handwritten text, selection marks, barcodes, mathematical formulas, image elements, hyperlinks, and annotations. Preserves document structure, including paragraphs, tables, hierarchical sections, and figure elements. |
| [Field extraction](/azure/ai-services/content-understanding/document/overview#field-extraction) | Extracts structured key-value pairs from documents based on a schema that you define. Extract fields directly from the source, classify them from a predefined set of categories, or generate them by using a generative model. Confidence scores and grounding are available for each field as an opt-in feature. |
| [Prebuilt document analyzers](/azure/ai-services/content-understanding/concepts/prebuilt-analyzers) | Ready-to-use analyzers for common enterprise scenarios, including contract life cycle management, loan and mortgage applications, financial reports, expense management, and knowledge base scenarios. |
| [RAG output](/azure/ai-services/content-understanding/document/overview#document-analyzer-capabilities) | Produces Markdown-formatted output that preserves document structure for use in vector stores and search indexes. Supports figure descriptions, layout analysis, and annotation detection so that retrieval workflows can access content that standard chunking overlooks. |

### Use cases

The following table provides a list of possible use cases for Azure Content Understanding for documents.

| Use case | Description |
| :----------| :-------------|
| [Contract life cycle management](/azure/ai-services/content-understanding/document/overview#business-use-cases) | Extract key fields, clauses, and obligations from various contract types without training a layout-specific model. |
| [Loan and mortgage application processing](/azure/ai-services/content-understanding/document/overview#business-use-cases) | Automate processing of supplementary supporting documentation from different formats and templates that go beyond what Azure Document Intelligence mortgage prebuilt models support. |
| [Expense management](/azure/ai-services/content-understanding/document/overview#business-use-cases) | Parse receipts and invoices from various retailers and formats by using schema-defined extraction with confidence scores to flag records that need human review. |
| [RAG document ingestion](/azure/ai-services/content-understanding/tutorial/build-rag-solution) | Convert unstructured documents into structured, searchable data assets with layout-preserving Markdown output for use in RAG search pipelines and agent workflows. |
| [Mixed-document classification and routing](/azure/ai-services/content-understanding/document/overview#document-analyzer-capabilities) | Classify incoming documents by type and route each type to the appropriate analyzer. This approach allows end-to-end automation of pipelines that receive multiple document types. |

## Models

[Models](/azure/foundry-classic/concepts/foundry-models-overview) provides access to a catalog of foundation models from Microsoft, OpenAI, and other leading providers. These models can do general-purpose language tasks like content generation, summarization, translation, and conversational interactions.

| Use Models for these tasks | Consider specialized services when you need these capabilities |
| :----------| :-------------|
| Generate creative content, drafts, or variations of text. | Consistent, repeatable natural language processing tasks like NER or sentiment analysis at scale. [Azure Language](#azure-language) provides optimized, cost-effective APIs for these specific tasks. |
| Summarize long documents or conversations. | Translation for large volumes of documents while preserving formatting. [Azure Translator](#azure-translator) is optimized for translation quality and document structure preservation. |
| Build conversational AI experiences and chatbots. | Structured data extraction from forms and invoices with high accuracy. [Azure Document Intelligence](#azure-document-intelligence) provides prebuilt models trained specifically for document types. |
| Answer general questions based on provided context. | |
| Do unplanned language tasks with flexible prompting. | |

### Available models

Models includes the following AI models from multiple providers.

| Model family | Description |
| :----------| :-------------|
| GPT-4o and GPT-4o mini | OpenAI multimodal models that can process both text and images, with enhanced accuracy and responsiveness for English text and coding tasks. |
| GPT-4.1 series | OpenAI text and image processing models with large context windows (up to one million tokens) for handling extensive documents. |
| GPT-5 family | OpenAI's latest generation flagship models with advanced reasoning, multimodal capabilities, and improved instruction following. These models suit complex, multiple-step language tasks that require high accuracy. |
| o-series (o3, o4-mini) | OpenAI reasoning models designed for advanced problem-solving tasks that require increased focus and capability in areas like science, coding, and math. |
| Phi-4 family | Small language models (SLMs) from Microsoft optimized for complex reasoning. Phi-4 (14B parameters) excels in low-latency scenarios, while Phi-4-reasoning and Phi-4-mini-reasoning provide specialized reasoning capabilities for multiple-step problem solving tasks that require fewer resources. Supports more than 40 languages. |
| DeepSeek | Open-weight models, including DeepSeek-R1 for reasoning tasks and DeepSeek-V3 series for general-purpose language understanding. Known for strong performance on coding and mathematical reasoning benchmarks. |
| Grok | xAI models, including Grok-3, Grok-4, and specialized variants for reasoning and coding tasks. Available in fast-reasoning and nonreasoning configurations. |
| Llama | Meta's open models, including Llama-3.3-70B-Instruct and Llama-4-Maverick for general-purpose language tasks. |
| Mistral | European AI models, including Mistral-Large-3 and mistral-document-ai for document-processing scenarios. |
| Embeddings models | Models from multiple providers that convert text into numerical vector form to facilitate text similarity and semantic search. |

For a complete list of available models and regional availability, see [Models sold directly by Azure](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure).

### Get started

To start using Models for language tasks, take one of the following approaches:

- **No-code approach:** Use the [chat playground](/azure/foundry-classic/quickstarts/get-started-playground) in the Foundry portal to deploy models and test prompts interactively.

- **Code-based approach:** Use the [Foundry SDK](/azure/foundry/quickstarts/get-started-code) to integrate models into your applications by using Python, C#, TypeScript, or Java.

## Related resources

- [Azure Speech in Foundry Tools capabilities guide](speech-recognition-generation.md)
- [Azure Vision in Foundry Tools capabilities guide](image-video-processing.md)
