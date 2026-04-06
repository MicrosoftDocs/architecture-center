---
title: Choose a natural language processing technology
description: Choose a natural language processing technology for sentiment analysis, topic and language detection, key phrase extraction, and document categorization.
author: ogkranthi
ms.author: kmanchikanti
ms.reviewer: ananyagc5
ms.date: 02/24/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
ai-usage: ai-assisted
---

# Choose a natural language processing technology

Natural language processing (NLP) encompasses techniques for analyzing, understanding, and generating human language from text data. Azure provides managed API-driven services and distributed open-source frameworks that address NLP workloads ranging from sentiment analysis and entity recognition to document classification and text summarization. This guide helps you evaluate and choose between the primary NLP options on Azure so you can match the right technology to your workload requirements.

> [!NOTE]
> This guide focuses on NLP capabilities available through [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) and Apache Spark with Spark NLP on [Azure Databricks](/azure/databricks/introduction) or [Microsoft Fabric](/fabric/data-engineering/spark-compute). It doesn't provide guidance for selecting large language models (LLMs) or designing Azure OpenAI Service solutions. Some platform descriptions might reference supported foundation-model or speech-model integrations as implementation details, but this guide remains focused on NLP service selection. For guidance on choosing AI services more broadly, see [Choose an Azure AI services technology](/azure/architecture/data-guide/technology-choices/ai-services).

## Understand NLP and language models

Before evaluating Azure services, understand what NLP is, how it differs from language models, and what tasks it addresses. 

### Distinguish NLP from language models

This section clarifies the boundary between NLP and language models, and surveys the core capabilities that NLP techniques enable.

| Dimension | NLP | Language models |
|-----------|-----|-----------------|
| **Scope** | Broad field covering diverse text-processing techniques including tokenization, stemming, entity recognition, sentiment analysis, and document classification. | A deep-learning subset of NLP focused on high-level language understanding and generation tasks. |
| **Examples** | Rule-based parsers, TF-IDF classifiers, named entity recognizers, sentiment analyzers. | GPT, BERT, and similar transformer-based models that generate humanlike, contextually aware text. |
| **Output** | Structured signals: labels, scores, extracted spans, parsed syntax. | Fluent natural language: generated text, summaries, answers, and completions. |
| **Relationship** | The parent domain. NLP encompasses the full spectrum of text-processing methods. | A tool within NLP. Language models enhance NLP without replacing it — they handle broader cognitive tasks but are not synonymous with NLP itself. |

### NLP capabilities

- **Classify documents by labeling them as sensitive or spam.** NLP automatically categorizes documents based on content to support compliance and filtering workflows.
- **Summarize text by identifying entities in the document.** Key entities are extracted to produce concise summaries that capture the most important information.
- **Tag documents with keywords using identified entities.** After identifying entities, you can generate keyword tags that make documents easier to organize. Use these tags for content-based search and retrieval.
- **Detect topics for navigation and related document discovery.** NLP identifies key topics using extracted entities, enabling document categorization and topic-based navigation.
- **Assess text sentiment.** Sentiment analysis evaluates the emotional tone of text, classifying content as positive, negative, or neutral.
- **Feed NLP outputs into downstream workflows.** Results like extracted entities, sentiment scores, and topic labels serve as inputs for processing, search indexing, and analytics.

## Identify potential use cases

Business scenarios across many industries benefit from NLP solutions. The following use cases illustrate how NLP techniques address real-world challenges, from processing unstructured documents to enabling emerging applications in cybersecurity and accessibility.

### Process documents and unstructured text

- **Extract intelligence from machine-created documents.** NLP enables document processing across finance, healthcare, retail, government, and other sectors. You can analyze digitally created documents to extract structured information from unstructured inputs. For handwritten documents, use [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) to convert handwritten content to text before you apply NLP techniques.

- **Apply industry-agnostic NLP tasks for text processing.** Named-entity recognition (NER), classification, summarization, and relation extraction help you automatically process and analyze unstructured document content. These tasks work across domains without requiring industry-specific customization.
- **Build domain-specific models for specialized analysis.** Examples of these tasks include risk stratification models for healthcare, ontology classification for knowledge management, and retail summarizations for product and customer data. Custom model training in both [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) and Spark NLP helps improve accuracy for these domain-specific document formats.

- **Generate automated reports from structured data inputs.** You can synthesize and generate comprehensive textual reports from structured data. This capability helps sectors like finance and compliance that require thorough documentation.

### Enable search, translation, and analytics

- **Create knowledge graphs and enable semantic search through information retrieval.** NLP powers knowledge graph creation and semantic search, enabling systems that understand query meaning rather than relying on keyword matching alone.
- **Support drug discovery and clinical trials with medical knowledge graphs.** Medical knowledge graphs built from NLP-processed clinical text support drug discovery pipelines and clinical trial matching. These graphs connect entities like drugs, conditions, and outcomes to accelerate research workflows. [Text Analytics for Health](/azure/ai-services/language-service/text-analytics-for-health/overview) in Azure Language in Foundry Tools extracts medical entities, relations, and assertions that you can use to construct these graphs.

- **Translate text for conversational AI in customer-facing applications.** Text translation enables conversational AI across multiple industries. You can build multilingual customer-facing applications that process and respond in the user's preferred language. Spark NLP provides translation capabilities directly. On Azure, use [Azure AI Translator](/azure/ai-services/translator/overview), which is a separate service from Azure Language in Foundry Tools.

- **Analyze sentiment and emotional intelligence for brand perception.** Sentiment analysis helps you monitor brand perception and analyze customer feedback by surfacing positive, negative, and nuanced emotional signals from text.

### Extend NLP to emerging domains

- **Build voice-activated interfaces for IoT and smart devices.** NLP processes the text output of speech recognition systems to understand user intent and extract meaning in IoT and smart device scenarios. Voice-activated scenarios require [Azure AI Speech](/azure/ai-services/speech-service/overview) for speech-to-text conversion before NLP processing.

- **Adjust language output dynamically with adaptive language models.** Adaptive language models dynamically adjust language output to suit different audience comprehension levels, which supports educational content delivery and accessibility.
- **Detect phishing and misinformation through cybersecurity text analysis.** NLP analyzes communication patterns and language usage in real time to identify potential security threats in digital communication. This analysis helps detect phishing attempts and misinformation campaigns.

## Evaluate Azure Language in Foundry Tools

[Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) is a cloud-based service that provides NLP features for understanding and analyzing text. You can access it through the [Microsoft Foundry portal](https://ai.azure.com), REST APIs, and client libraries for Python, C#, Java, and JavaScript with no infrastructure to manage. For AI agent development, these capabilities are also available through the Azure Language MCP server. You can access it as a remote server in the Microsoft Foundry Tool Catalog or as a local self-hosted server.

### Prebuilt features

Prebuilt features require no model training and work out of the box:

- **[Named Entity Recognition (NER)](/azure/ai-services/language-service/named-entity-recognition/overview).** Identifies and categorizes entities in text into predefined types such as people, organizations, locations, and dates.

- **[PII detection](/azure/ai-services/language-service/personally-identifiable-information/overview?tabs=text-pii).** Identifies and redacts sensitive personal and health information in text and transcribed conversations.

- **[Language detection](/azure/ai-services/language-service/language-detection/overview).** Detects the language a document is written in across a wide range of languages and dialects.

- **[Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview).** Identifies positive, negative, or neutral sentiment in text and links opinions to specific elements such as product attributes or service aspects.
- **[Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview).** Evaluates unstructured text and returns a list of main concepts and key phrases.

- **[Summarization](/azure/ai-services/language-service/summarization/overview?tabs=text-summarization).** Condenses documents and conversations using extractive or abstractive approaches, supporting text, chat, and call center summarization.
- **[Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview?tabs=ner).** Extracts and labels relevant health information from unstructured clinical text, including medical entities, relations, and assertions.

- **[Entity linking](/azure/ai-services/language-service/entity-linking/overview).** Disambiguates entities found in unstructured text by linking them to a structured knowledge base.

> [!IMPORTANT]
> Entity Linking is retiring from Azure Language in Foundry Tools effective September 1, 2028. Microsoft recommends migrating to Named Entity Recognition or an alternative solution before that date.

### Train custom models

Customizable features let you train models on your own data to handle domain-specific NLP tasks:

- **[Custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/overview).** Build custom models to extract domain-specific entity categories from unstructured text. Use this when prebuilt NER categories don't cover your domain vocabulary.

- **[Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview).** Build custom models to classify documents into categories you define. Supports both single-label and multi-label classification scenarios.

- **[Conversational Language Understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview).** Build custom models to predict user intent and extract information from conversational inputs. CLU is the recommended replacement for LUIS, which retired October 1, 2025.

- **[Question Answering](/azure/ai-services/language-service/question-answering/overview).** Build a knowledge base that identifies the most suitable answer for user inputs, typically used in chatbots and conversational applications that require precise, curated responses.
- **[Orchestration Workflow](/azure/ai-services/language-service/orchestration-workflow/overview).** Connect CLU and Question Answering projects into a unified conversational pipeline that routes user inputs to the appropriate project based on intent.

### Azure Language MCP server and agents

> [!NOTE]
> The Azure Language MCP server and both agents (Intent Routing and Exact Question Answering) are currently in public preview. Preview features don't include a service-level agreement and aren't recommended for production workloads. Some features might not be supported or might have limited capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).
Azure Language provides prebuilt agents and flexible deployment options for production NLP workloads:

- **Intent Routing agent.** Manages conversation flows by understanding user intentions and routing to accurate responses through deterministic, auditable logic. This agent is useful when you need transparent, deterministic conversational routing.
- **Exact Question Answering agent.** Provides reliable, word-for-word responses to business-critical questions while maintaining human oversight and quality control. Use this agent when response accuracy and consistency are essential.
Both agents are accessible through the Microsoft Foundry Tool Catalog. For more information, see [Azure Language MCP server and agents](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-mcp-server-preview).

The Azure Language MCP server supports multiple deployment options:

- **Remote cloud-hosted MCP server.** Accessible from the Microsoft Foundry Tool Catalog and provides cloud-managed access to Azure Language capabilities without requiring local infrastructure.
- **Local self-hosted MCP server.** Supports on-premises or self-managed deployments for compliance, security, or data residency requirements.

- **Containerized deployment.** The following features support containerized deployment for scenarios that require local processing or air-gapped environments. For the full list of available containers and their availability status, see [Azure AI containers support](/azure/ai-services/cognitive-services-container-support).
  - Sentiment analysis
  - Language detection
  - Key phrase extraction
  - Named Entity Recognition (NER)
  - PII detection
  - Custom NER
  - Text analytics for health
  - Conversational Language Understanding (CLU)
  - Summarization (public preview)

## Evaluate Apache Spark with Spark NLP

Apache Spark with Spark NLP is a distributed, open-source approach to NLP that operates at cluster scale. Spark NLP's platform architecture, performance, and prebuilt model ecosystem make it a strong option for large-scale, customizable NLP workloads on [Azure Databricks](/azure/databricks/introduction) or [Microsoft Fabric](/fabric/data-engineering/spark-compute).

### Understand platform and architecture

> [!IMPORTANT]
> Azure HDInsight 4.0 and 5.0 were retired on March 31, 2025. HDInsight 5.1 remains on Standard support, but we recommend that you use [Microsoft Fabric](/fabric/data-engineering/spark-compute) or [Azure Databricks](/azure/databricks/introduction) for new Spark-based NLP workloads. For more information, see [Azure HDInsight retirement](/azure/hdinsight/hdinsight-component-retirements-and-action-required).

- **Apache Spark provides parallel, in-memory processing for big-data analytics.** Microsoft Fabric and Azure Databricks give you access to Spark's processing capabilities for large-scale NLP workloads.
- **Spark NLP operates as a native extension of Spark ML on data frames.** This integration enables unified NLP and machine learning pipelines with improved performance on distributed clusters.
- **Spark NLP is an open-source library with Python, Java, and Scala support.** The library provides functionality comparable to [spaCy](https://spacy.io/) and [Natural Language Toolkit (NLTK)](https://www.nltk.org/), including spell check, sentiment analysis, and document classification.
    :::image type="content" border="false" source="../images/natural-language-processing-functionality.png" alt-text="Diagram that shows areas of natural language processing functionality, such as entity recognition, information extraction, summarization and translation." lightbox="../images/natural-language-processing-functionality.png":::

*Apache®, [Apache Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

### Assess performance and scalability

- **[Public benchmarks](https://sparknlp.org/) show significant speed improvements over other NLP libraries.** Compared to frameworks like spaCy and NLTK, Spark NLP demonstrates faster training and inference on distributed clusters. Custom models trained with Spark NLP deliver accuracy on par with other NLP frameworks, making it suitable for production workloads that require both speed and precision.

- **Optimized builds for CPUs, GPUs, and Intel Xeon chips fully utilize Spark clusters.** These builds enable training and inference to scale efficiently across cluster nodes.

- **MPNet embeddings and ONNX support enable precise, context-aware processing.** MPNet produces dense vector representations that capture semantic meaning, and [ONNX support](https://sparknlp.org/docs/en/concepts#onnx-support) lets you import and run optimized models for inference.

### Use prebuilt models and pipelines

- **Prebuilt deep learning models handle NER, document classification, and sentiment detection.** The library comes with prebuilt deep learning models for named entity recognition, document classification, and sentiment detection.
- **Pretrained language models support word, chunk, sentence, and document embeddings.** The library includes pretrained language models that support multiple embedding levels: word, chunk, sentence, and document. These embeddings provide dense vector representations that enable downstream tasks like similarity search and classification.
- **Unified NLP and machine learning pipelines support document classification and risk prediction.** The integration with Spark ML supports the creation of unified NLP and machine learning pipelines for tasks like document classification and risk prediction. This unified approach lets you combine text processing with traditional ML models in a single pipeline, reducing architectural complexity.

## Address common NLP challenges

Both [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) and Apache Spark with Spark NLP face common challenges when processing natural language at scale. Understanding these challenges helps you plan resources, design pipelines, and set accuracy expectations before committing to either option.
### Resource processing

- **Processing free-form text requires significant computational resources and time.** Analyzing collections of free-form text documents is both computationally expensive and time intensive. Every document requires tokenization, normalization, and model inference before producing usable results.
- **Spark NLP workloads often require GPU compute deployment.** For large-scale Spark NLP pipelines, GPU-accelerated clusters on [Azure Databricks](/azure/databricks/introduction) or [Microsoft Fabric](/fabric/data-engineering/spark-compute) provide the parallel processing power needed for training and inference. Optimizations like Llama 3.x model quantization help reduce memory footprint and improve throughput for these intensive tasks.

- **Azure Language in Foundry Tools requires throughput planning and quota management.** The service handles resource management, but high-volume API calls require careful throughput planning. Monitor your request rates against service limits and rate limits to avoid throttling and ensure consistent processing performance.

### Document standardization

Real-world documents rarely follow a consistent structure. This inconsistency creates challenges for extraction pipelines and requires deliberate strategies to maintain accuracy across sources.

- **Inconsistent formats.** Without a standardized document format, extracting specific facts from free-form text consistently is difficult. For example, extracting invoice numbers and dates from different vendors is challenging because field layouts, labels, and formatting vary across sources.
- **Custom model training.** Custom model training in both Spark NLP and [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) helps you adapt to domain-specific document formats. By training on representative samples of your actual documents, you can improve extraction accuracy for fields, entities, and patterns that prebuilt models don't handle well.

### Data variety and complexity

- **Diverse document structures and linguistic nuances add complexity.** Real-world text data comes in many formats, writing styles, and languages. Addressing these variations requires models that can handle ambiguity, slang, abbreviations, and domain-specific terminology without degrading accuracy.

- **MPNet embeddings in Spark NLP provide enhanced contextual understanding.** MPNet embeddings capture contextual relationships between words and phrases, which helps Spark NLP pipelines handle nuanced text more effectively. These embeddings produce dense vector representations that preserve semantic meaning across different document formats.
- **Custom models in Azure Language in Foundry Tools adapt to domain-specific text patterns.** [Custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/overview) and [custom text classification](/azure/ai-services/language-service/custom-text-classification/overview) let you train models on your own labeled data to recognize patterns specific to your domain. This approach improves reliability by teaching the model to recognize entities and categories that prebuilt models miss.

## Apply key selection criteria


Use the following criteria to determine which Azure NLP option best fits your requirements. Each criterion describes a workload characteristic and points you toward the service that addresses it.

- **Managed NLP capabilities.** Use [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) APIs for entity recognition, intent identification, topic detection, or sentiment analysis. These capabilities are available as managed services with minimal setup, and you don't need to provision or manage any infrastructure.

- **Prebuilt or pretrained models.** Use Azure Language in Foundry Tools if you want to use prebuilt or pretrained models without managing infrastructure. This approach suits small to medium datasets and standard NLP tasks where out-of-the-box models deliver sufficient accuracy. It provides automatic scaling, built-in security, and pay-per-call pricing without cluster management overhead.
- **Custom model training on large text corpora.** Use [Azure Databricks](/azure/databricks/introduction) or [Microsoft Fabric](/fabric/data-engineering/spark-compute) with Spark NLP. These platforms provide the computational power and flexibility you need for extensive model training on large text corpora. You can also download your model of choice through Spark NLP, which includes advanced models like Llama 3.x and MPNet for enhanced capabilities.

- **Low-level NLP primitives.** Use Azure Databricks or Microsoft Fabric with Spark NLP for tokenization, stemming, lemmatization, and term frequency/inverse document frequency (TF/IDF). Alternatively, use an open-source library such as spaCy or NLTK. Azure Language in Foundry Tools doesn't provide these low-level text-processing primitives.

## Build NLP pipelines with Spark NLP

Spark NLP follows the same development pattern as traditional Spark ML models when running an NLP pipeline. You manage trained models by using [MLflow](https://mlflow.org) for experiment tracking and production deployment.
:::image type="content" border="false" source="../images/spark-natural-language-processing-pipeline.png" alt-text="Diagram that shows the stages of a natural language processing pipeline, such as document assembly, sentence detection, tokenization, normalization, and word embedding." lightbox="../images/spark-natural-language-processing-pipeline.png":::

### Assemble core pipeline components

A Spark NLP pipeline chains annotators together in sequence. Each annotator transforms the output of the previous stage, building from raw text to semantic vectors.

- **DocumentAssembler is the entry point for every Spark NLP pipeline.** Use `setCleanupMode` to apply optional text preprocessing, such as removing HTML tags or normalizing whitespace, before downstream annotators run.
- **SentenceDetector identifies sentence boundaries in the assembled document.** It returns detected sentences either as an `Array` within a single row or as separate rows, depending on your pipeline configuration. Accurate sentence detection is important because many downstream annotators operate at the sentence level.

- **Tokenizer divides raw text into discrete tokens such as words, numbers, and symbols.** If the default rules are insufficient for your domain, add custom rules to handle specialized vocabulary, hyphenated terms, or domain-specific patterns.
- **Normalizer refines tokens by applying regular expressions and dictionary transformations.** It cleans text to reduce noise before embedding. For example, you can strip accents, convert to lowercase, or apply custom dictionary mappings to standardize terminology.
- **WordEmbeddings maps tokens to semantic vectors to facilitate contextual processing.** Each token is represented as a dense vector that captures its meaning relative to other tokens. Unresolved tokens that don't appear in the embeddings vocabulary default to zero vectors.

### Manage models with MLflow

- **Spark NLP uses Spark MLlib pipelines with native [MLflow](https://mlflow.org) support.** You don't need to write custom serialization or integration code.
- **MLflow manages experiment tracking, model versioning, and deployment.** You can log pipeline parameters, metrics, and artifacts during training runs. MLflow tracks each experiment so you can compare results across iterations and reproduce successful configurations.

- **MLflow integrates directly with [Azure Databricks](/azure/databricks/introduction) and [Microsoft Fabric](/fabric/data-science/data-science-overview).** On Azure Databricks, MLflow is preinstalled and tightly integrated with the workspace. Microsoft Fabric also provides a [built-in MLflow experience](/fabric/data-science/machine-learning-experiment) with native experiment tracking and autologging, so you don't need to install MLflow separately. If you run Spark NLP on another Spark-based environment, you can install MLflow separately and configure it to track experiments against a remote tracking server.

- **Use the MLflow Model Registry to promote models to production and maintain governance.** The Model Registry provides a central repository for managing model versions across your NLP pipelines. In classic deployments, transition models through stages like Staging, Production, and Archived. On [Azure Databricks](/azure/databricks/machine-learning/manage-model-lifecycle/), newer deployments use [Models in Unity Catalog](/azure/databricks/machine-learning/manage-model-lifecycle/), which replaces fixed stages with custom aliases and tags for more flexible lifecycle management. On [Microsoft Fabric](/fabric/data-science/data-science-overview), the workspace provides its own MLflow-based model registry.

## Capability matrix

The following tables summarize the key differences in capabilities between Spark NLP on Azure Databricks or Microsoft Fabric and Azure Language in Foundry Tools.

### General capabilities

| Capability | Spark NLP (Azure Databricks or Microsoft Fabric) | Azure Language in Foundry Tools |
| :--- | :--- | :--- |
| Pretrained models as a service | Yes | Yes |
| REST API | Yes | Yes |
| Programmability | Python, Scala | See [Supported programming languages](/azure/foundry-classic/foundry-models/supported-languages) |
| Supports processing of large datasets and large documents | Yes | Limited [5] |

[5] Azure Language in Foundry Tools has per-request document size limits (typically 5,120 characters) and supports up to 25 documents per API call. You can process large dataset volumes through batching and pagination, but individual documents that exceed the character limit require chunking.

### Annotator capabilities

| Capability | Spark NLP (Azure Databricks or Microsoft Fabric) | Azure Language in Foundry Tools |
| :--- | :--- | :--- |
| Sentence detector | Yes | No |
| Deep sentence detector | Yes | No |
| Tokenizer | Yes | Yes |
| N-gram generator | Yes | No |
| Word segmentation | Yes | Yes |
| Stemmer | Yes | No |
| Lemmatizer | Yes | No |
| Part-of-speech tagging | Yes | No |
| Dependency parser | Yes | No |
| Translation | Yes | No |
| Stopword cleaner | Yes | No |
| Spell correction | Yes | No |
| Normalizer | Yes | Yes |
| Text matcher | Yes | No |
| TF/IDF | Yes | No |
| Regular expression matcher | Yes | Limited [1] |
| Date matcher | Yes | Limited [2] |
| Chunker | Yes | No |

[1] Regular expression matching is embedded in the conversational language understanding (CLU) feature rather than available as a standalone annotator.

[2] Date matching is possible in CLU through DateTime recognizers rather than as a dedicated annotator.

### High-level NLP capabilities

| Capability | Spark NLP (Azure Databricks or Microsoft Fabric) | Azure Language in Foundry Tools |
| :--- | :--- | :--- |
| Spell check | Yes | No |
| Summarization | Yes | Yes |
| Question answering | Yes | Yes |
| Sentiment detection | Yes | Yes |
| Emotion detection | Yes | Limited [3] |
| Token classification | Yes | Limited [4] |
| Text classification | Yes | Limited [4] |
| Text representation | Yes | No |
| Named entity recognition (NER) | Yes | Yes (prebuilt); custom NER available through custom models [4] |
| Language detection | Yes | Yes |
| Supports languages besides English | Yes. See [Spark NLP supported languages](https://sparknlp.org/models). | Yes. See [Azure Language supported languages](/azure/ai-services/language-service/concepts/language-support). |

[3] Azure Language in Foundry Tools supports opinion mining, which identifies sentiments linked to specific aspects of text, but doesn't provide dedicated emotion detection (such as joy, anger, or sadness classification).

[4] Available through custom models. You train custom NER, custom text classification, or custom entity recognition models on your own labeled data.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Ananya Ghosh Chowdhury](https://www.linkedin.com/in/ananyaghoshchowdhury/) | Principal Cloud Solution Architect
- [Kranthi Manchikanti](https://www.linkedin.com/in/kranthimanchikanti/) | Senior AI Solutions Engineer

Other contributors:

- [Tincy Elias](https://www.linkedin.com/in/tincy-elias/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to AI in Azure](/training/paths/introduction-to-ai-on-azure)
- [Develop natural language processing solutions with Foundry Tools](/training/paths/develop-language-solutions-azure-ai)

## Related resources

- Azure Language in Foundry Tools documentation:

  - [Azure Language overview](/azure/ai-services/language-service/overview)
  - [Microsoft Foundry documentation](/azure/foundry/what-is-foundry)

- Spark NLP documentation:

  - [Spark NLP](https://sparknlp.org/)
  - [Spark NLP general documentation](https://sparknlp.org/docs/en/quickstart)
  - [Spark NLP demo](https://github.com/JohnSnowLabs/spark-nlp-workshop)

- Azure components:

  - [Microsoft Fabric](/fabric/)
  - [Azure Databricks](/azure/databricks/introduction)
  - [Foundry Tools](/azure/ai-services/what-are-ai-services)

- Learn resources:

  - [Choose an AI services technology](/azure/architecture/data-guide/technology-choices/ai-services)
  - [Compare the machine learning products and technologies from Microsoft](/azure/architecture/ai-ml/guide/data-science-and-machine-learning)
  - [MLflow and Azure Machine Learning](/azure/machine-learning/concept-mlflow)
  - [AI enrichment with image and natural language processing in Azure AI Search](/azure/architecture/solution-ideas/articles/ai-search-skillsets)