---
title: Choose a Natural Language Processing Technology
description: Choose a natural language processing technology for sentiment analysis, topic and language detection, key phrase extraction, and document categorization.
author: ananyagc5
ms.author: ananyag
ms.reviewer: kmanchikanti
ms.date: 04/17/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
ai-usage: ai-assisted
---

# Choose a natural language processing technology

Natural language processing encompasses techniques that analyze, understand, and generate human language from text data. Azure provides managed API-driven services and distributed open-source frameworks that address natural language processing workloads that range from sentiment analysis and entity recognition to document classification and text summarization. This guide helps you evaluate and choose from the primary natural language processing options on Azure so that you can match the right technology to your workload requirements.

> [!NOTE]
> This guide focuses on natural language processing capabilities available through [Azure Language](/azure/ai-services/language-service/overview) and Apache Spark with Spark NLP on [Azure Databricks](/azure/databricks/introduction/) or [Microsoft Fabric](/fabric/data-engineering/spark-compute). It doesn't provide guidance for how to select language models or design Azure OpenAI solutions. Some platform descriptions might reference supported foundation-model or speech-model integrations as implementation details, but this guide focuses on natural language processing service selection. For more information, see [Choose an Azure AI services technology](/azure/architecture/data-guide/technology-choices/ai-services).

## Understand natural language processing and language models

Before you evaluate Azure services, understand what natural language processing is, how it differs from language models, and what tasks it addresses.

### Distinguish natural language processing from language models

This section clarifies the boundary between natural language processing and language models, and surveys the core capabilities that natural language processing techniques enable.

| Dimension | Natural language processing | Language models |
| :--- | :--- | :--- |
| Scope | A broad field that covers diverse text-processing techniques, including tokenization, stemming, entity recognition, sentiment analysis, and document classification | A deep-learning subset of natural language processing focused on high-level language understanding and generation tasks |
| Examples | Rule-based parsers, term frequency-inverse document frequency (TF-IDF) classifiers, named entity recognizers, sentiment analyzers | GPT, BERT, and similar transformer-based models that generate humanlike, contextually aware text |
| Output | Structured signals like labels, scores, extracted spans, and parsed syntax | Fluent natural language like generated text, summaries, answers, and completions |
| Relationship | The parent domain. Natural language processing encompasses the full spectrum of text-processing methods. | A tool within natural language processing. Language models enhance natural language processing without replacing it. They handle broader cognitive tasks but aren't synonymous with natural language processing. |

### Natural language processing capabilities

- **Classify documents by labeling them as sensitive or spam.** Natural language processing automatically categorizes documents based on content to support compliance and filtering workflows.

- **Summarize text by identifying entities in the document.** Natural language processing extracts key entities to produce concise summaries that capture the most important information.

- **Tag documents with keywords by using identified entities.** After you identify entities, you can generate keyword tags that simplify document organization. Use these tags for content-based search and retrieval.

- **Detect topics for navigation and related document discovery.** Natural language processing identifies key topics by using extracted entities, which supports document categorization and topic-based navigation.

- **Assess text sentiment.** Sentiment analysis evaluates the emotional tone of text, and classifies content as positive, negative, or neutral.

- **Feed natural language processing outputs into downstream workflows.** Results like extracted entities, sentiment scores, and topic labels serve as inputs for processing, search indexing, and analytics.

## Identify potential use cases

Business scenarios across many industries benefit from natural language processing solutions. The following use cases show how natural language processing techniques address real-world challenges, from processing unstructured documents to enabling emerging applications in cybersecurity and accessibility.

### Process documents and unstructured text

- **Extract intelligence from machine-created documents.** Natural language processing enables document processing across finance, healthcare, retail, government, and other sectors. You can analyze digitally created documents to extract structured information from unstructured inputs. For handwritten documents, use [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) to convert handwritten content to text before you apply natural language processing techniques.

- **Apply industry-agnostic natural language processing tasks for text processing.** Named entity recognition (NER), classification, summarization, and relation extraction help you automatically process and analyze unstructured document content. These tasks work across domains and don't require industry-specific customization.

- **Build domain-specific models for specialized analysis.** Examples of these tasks include risk stratification models for healthcare, ontology classification for knowledge management, and retail summarizations for product and customer data. Custom model training in [Azure Language](/azure/ai-services/language-service/overview) and Spark NLP helps improve accuracy for these domain-specific document formats.

- **Generate automated reports from structured data inputs.** You can synthesize and generate comprehensive textual reports from structured data. This capability helps sectors like finance and compliance that require thorough documentation.

### Enable search, translation, and analytics

- **Create knowledge graphs and enable semantic search through information retrieval.** Natural language processing supports knowledge graph creation and semantic search, which lets systems interpret query meaning rather than rely on keyword matching only.

- **Support drug discovery and clinical trials with medical knowledge graphs.** Natural language processing systems analyze clinical text. Medical knowledge graphs built from that text support drug discovery pipelines and clinical trial matching. These graphs connect entities like drugs, conditions, and outcomes to accelerate research workflows. [Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview) in Azure Language extracts medical entities, relations, and assertions that you can use to construct these graphs.

- **Translate text for conversational AI in customer-facing applications.** Text translation enables conversational AI across multiple industries. You can build multilingual customer-facing applications that process and respond in the user's preferred language. Spark NLP provides translation capabilities directly. On Azure, use [Azure Translator](/azure/ai-services/translator/overview), which is a separate service from Azure Language.

- **Analyze sentiment and emotional intelligence for brand perception.** Sentiment analysis helps you monitor brand perception and analyze customer feedback by surfacing positive, negative, and nuanced emotional signals from text.

### Extend natural language processing to emerging domains

- **Build voice-activated interfaces for Internet of Things (IoT) and smart devices.** Natural language processing handles the text output of speech recognition systems to understand user intent and extract meaning in IoT and smart device scenarios. Voice-activated scenarios require [Azure Speech](/azure/ai-services/speech-service/overview) for speech-to-text conversion before natural language processing.

- **Adjust language output dynamically by using adaptive language models.** Adaptive language models dynamically adjust language output to suit different audience comprehension levels, which supports educational content delivery and accessibility.

- **Detect phishing and misinformation through cybersecurity text analysis.** Natural language processing analyzes communication patterns and language usage in real time to identify potential security threats in digital communication. This analysis helps detect phishing attempts and misinformation campaigns.

## Evaluate Azure Language

[Azure Language](/azure/ai-services/language-service/overview) is a cloud-based service that provides natural language processing features for understanding and analyzing text. You can access it through the [Microsoft Foundry portal](https://ai.azure.com), REST APIs, and client libraries for Python, C#, Java, and JavaScript with no infrastructure to manage. For AI agent development, you can also access these capabilities through the Azure Language MCP server. You can access it as a remote server in the Microsoft Foundry tool catalog or as a local self-hosted server.

### Prebuilt features

Prebuilt features require no model training and are ready to use:

- **[NER](/azure/ai-services/language-service/named-entity-recognition/overview):** Identifies and categorizes entities in text into predefined types like people, organizations, locations, and dates.

- **[PII detection](/azure/ai-services/language-service/personally-identifiable-information/overview?tabs=text-pii):** Identifies and redacts personally identifiable information (PII), including sensitive personal and health data, in text and transcribed conversations.

- **[Language detection](/azure/ai-services/language-service/language-detection/overview):** Detects the language a document is written in across a wide range of languages and dialects.

- **[Sentiment analysis and opinion mining](/azure/ai-services/language-service/sentiment-opinion-mining/overview):** Identifies positive, negative, or neutral sentiment in text and links opinions to specific elements like product attributes or service aspects.

- **[Key phrase extraction](/azure/ai-services/language-service/key-phrase-extraction/overview):** Evaluates unstructured text and returns a list of main concepts and key phrases.

- **[Summarization](/azure/ai-services/language-service/summarization/overview?tabs=text-summarization):** Condenses documents and conversations by using extractive or abstractive approaches, which supports text, chat, and call center summarization.

- **[Text analytics for health](/azure/ai-services/language-service/text-analytics-for-health/overview?tabs=ner):** Extracts and labels relevant health information from unstructured clinical text, including medical entities, relations, and assertions.

- **[Entity linking](/azure/ai-services/language-service/entity-linking/overview):** Disambiguates entities found in unstructured text by linking them to a structured knowledge base.

> [!IMPORTANT]
> Entity Linking retires from Azure Language on September 1, 2028. We recommend that you migrate to NER or an alternative solution before that date.

### Train custom models

You can use customizable features to train models on your own data to handle domain-specific natural language processing tasks:

- **[Custom named entity recognition (CNER)](/azure/ai-services/language-service/custom-named-entity-recognition/overview):** Build custom models to extract domain-specific entity categories from unstructured text. Use CNER when prebuilt NER categories don't cover your domain vocabulary.

- **[Custom text classification](/azure/ai-services/language-service/custom-text-classification/overview):** Build custom models to classify documents into categories that you define. These models support single-label and multiple-label classification scenarios.

- **[Conversational language understanding (CLU)](/azure/ai-services/language-service/conversational-language-understanding/overview):** Build custom models to predict user intent and extract information from conversational inputs. CLU is the recommended replacement for Language Understanding (LUIS), which was retired October 1, 2025.

- **[Question answering](/azure/ai-services/language-service/question-answering/overview):** Build a knowledge base that identifies the most suitable answer for user inputs, typically used in chatbots and conversational applications that require precise, curated responses.

- **[Orchestration workflow](/azure/ai-services/language-service/orchestration-workflow/overview):** Connect CLU and question answering projects into a unified conversational pipeline that routes user inputs to the appropriate project based on intent.

### Azure Language MCP server and agents

> [!NOTE]
> The Azure Language MCP server and both the intent routing and exact question answering agents are in public preview. Preview features don't include a service-level agreement (SLA) and we don't recommend them for production workloads. Some features might not be supported or might have limited capabilities. For more information, see [Supplemental terms of use for Microsoft Azure previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/). Azure Language provides prebuilt agents and flexible deployment options for production natural language processing workloads:

- **Intent routing agent:** Manages conversation flows. It understands user intentions and routes to accurate responses through deterministic, auditable logic. Use this agent when you need transparent, deterministic conversational routing.

- **Exact question answering agent:** Provides reliable, word-for-word responses to business-critical questions while maintaining human oversight and quality control. Use this agent when response accuracy and consistency are essential.
You can access both agents through the Foundry tool catalog. For more information, see [Azure Language MCP server and agents (preview)](/azure/ai-services/language-service/concepts/foundry-tools-agents#azure-language-mcp-server-preview).

The Azure Language MCP server supports multiple deployment options:

- **Remote cloud-hosted Model Context Protocol (MCP) server:** The Foundry tool catalog lists this server and provides cloud-managed access to Azure Language capabilities and requires no local infrastructure.

- **Local self-hosted MCP server:** Supports on-premises or self-managed deployments for compliance, security, or data residency requirements.

- **Containerized deployment:** The following features support containerized deployment for scenarios that require local processing or air-gapped environments. For the full list of available containers and their availability status, see [Azure AI containers support](/azure/ai-services/cognitive-services-container-support).

  - Sentiment analysis
  - Language detection
  - Key phrase extraction
  - NER
  - PII detection
  - CNER
  - Text analytics for health
  - CLU
  - Summarization (public preview)

## Evaluate Apache Spark with Spark NLP

Apache Spark with Spark NLP is a distributed, open-source approach to natural language processing that operates at cluster scale. The Spark NLP platform architecture, performance, and prebuilt model ecosystem make it a strong option for large-scale, customizable natural language processing workloads on [Azure Databricks](/azure/databricks/introduction/) or [Fabric](/fabric/data-engineering/spark-compute).

### Understand platform and architecture

> [!IMPORTANT]
> Azure HDInsight 4.0 and 5.0 were retired on March 31, 2025. HDInsight 5.1 remains on Standard support, but we recommend that you use [Fabric](/fabric/data-engineering/spark-compute) or [Azure Databricks](/azure/databricks/introduction) for new Spark-based natural language processing workloads. For more information, see [HDInsight retirement](/azure/hdinsight/hdinsight-component-retirements-and-action-required).

- **Apache Spark provides parallel, in-memory processing for big-data analytics.** Fabric and Azure Databricks give you access to Spark processing capabilities for large-scale natural language processing workloads.

- **Spark NLP operates as a native extension of Spark ML on data frames.** This integration enables unified natural language processing and machine learning pipelines with improved performance on distributed clusters.

- **Spark NLP is an open-source library with Python, Java, and Scala support.** The library provides functionality comparable to [spaCy](https://spacy.io/) and [Natural Language Toolkit (NLTK)](https://www.nltk.org/), including spell check, sentiment analysis, and document classification.

  :::image type="complex" border="false" source="../images/natural-language-processing-functionality.png" alt-text="Diagram that shows areas of natural language processing functionality, like entity recognition, information extraction, summarization and translation." lightbox="../images/natural-language-processing-functionality.png":::
      The diagram has three vertical sections: annotators, models, and languages. At the top, eight capability tiles appear in two rows. The first row contains entity recognition, information extraction, spelling and grammar, and text classification. The second row contains translation, summarization, question answering, and emotion detection. Entity recognition, information extraction, translation, and summarization are color-coded to indicate annotator capabilities. Spelling and grammar, text classification, question answering, and emotion detection are color-coded to indicate model capabilities. The annotators section organizes annotators into four groups: split text, understand grammar, clean text, and find in text. The models section is labeled 5000+ pretrained pipelines, models and transformers. It lists BERT, ELMO, GloVe, ALBERT, XLNet, USE, Small BERT, ELECTRA, T5, NMT, LaBSE, DistilBERT, RoBERTa, XLM-RoBERTa, S-BERT, and XLING. The languages section indicates support for more than 200 languages. Sections at the bottom read trainable and tunable, scalable to a cluster, fast inference, hardware optimized, and community.
  :::image-end:::

*Apache®, [Apache Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

### Assess performance and scalability

- **[Public benchmarks](https://sparknlp.org/) show significant speed improvements over other natural language processing libraries.** Compared to frameworks like spaCy and NLTK, Spark NLP demonstrates faster training and inference on distributed clusters. Custom models that Spark NLP trains reach accuracy levels that match those of other natural language processing frameworks, which makes it suitable for production workloads that require speed and precision.

- **Optimized builds for CPUs, GPUs, and Intel Xeon chips fully use Spark clusters.** These builds enable training and inference to scale efficiently across cluster nodes.

- **MPNet embeddings and ONNX support enable precise, context-aware processing.** MPNet produces dense vector representations that capture semantic meaning, and [ONNX support](https://sparknlp.org/docs/en/concepts#onnx-support) lets you import and run optimized models for inference.

### Use prebuilt models and pipelines

- **Prebuilt deep learning models handle NER, document classification, and sentiment detection.** The library comes with prebuilt deep learning models for NER, document classification, and sentiment detection.

- **Pretrained language models support word, chunk, sentence, and document embeddings.** The library includes pretrained language models that support word, chunk, sentence, and document embedding levels. These embeddings provide dense vector representations that enable downstream tasks like similarity search and classification.

- **Unified natural language processing and machine learning pipelines support document classification and risk prediction.** The integration with Spark ML supports unified natural language processing and machine learning pipelines for tasks like document classification and risk prediction. With this unified approach, you can combine text processing with traditional machine learning models in a single pipeline, which reduces architectural complexity.

## Address common natural language processing challenges

Both [Azure Language](/azure/ai-services/language-service/overview) and Apache Spark with Spark NLP face common challenges in natural language processing at scale. If you understand these challenges, you can plan resources, design pipelines, and set accuracy expectations before you commit to either option.

### Resource processing

- **Processing free-form text requires significant computational resources and time.** Free-form text documents are computationally expensive and time intensive to analyze. Every document requires tokenization, normalization, and model inference before it produces usable results.

- **Spark NLP workloads often require GPU compute deployment.** For large-scale Spark NLP pipelines, GPU-accelerated clusters on [Azure Databricks](/azure/databricks/introduction) or [Fabric](/fabric/data-engineering/spark-compute) provide the parallel processing power needed for training and inference. Optimizations like Llama 3.x model quantization help reduce memory footprint and improve throughput for these intensive tasks.

- **Azure Language requires throughput planning and quota management.** The service handles resource management, but high-volume API calls require careful throughput planning. Monitor your request rates against service limits and rate limits to avoid throttling and ensure consistent processing performance.

### Document standardization

Real-world documents rarely follow a consistent structure. This inconsistency creates challenges for extraction pipelines and requires deliberate strategies to maintain accuracy across sources.

- **Inconsistent formats:** Without a standardized document format, extracting specific facts from free-form text can be difficult. For example, it can be a challenge to extract invoice numbers and dates from different vendors because field layouts, labels, and formatting vary across sources.

- **Custom model training:** When you train custom models in Spark NLP and [Azure Language](/azure/ai-services/language-service/overview), you can adapt to domain-specific document formats. When you train on representative samples of your actual documents, you can improve extraction accuracy for fields, entities, and patterns that prebuilt models don't handle well.

### Data variety and complexity

- **Diverse document structures and linguistic nuances add complexity.** Real-world text data comes in many formats, writing styles, and languages. Addressing these variations requires models that can handle ambiguity, slang, abbreviations, and domain-specific terminology while maintaining accuracy.

- **MPNet embeddings in Spark NLP provide enhanced contextual understanding.** MPNet embeddings capture contextual relationships between words and phrases, which helps Spark NLP pipelines handle nuanced text more effectively. These embeddings produce dense vector representations that preserve semantic meaning across different document formats.

- **Custom models in Azure Language adapt to domain-specific text patterns.** With [CNER](/azure/ai-services/language-service/custom-named-entity-recognition/overview) and [custom text classification](/azure/ai-services/language-service/custom-text-classification/overview), you can train models on your own labeled data to recognize patterns specific to your domain. This approach improves reliability by teaching the model to recognize entities and categories that prebuilt models miss.

## Apply key selection criteria

Use the following criteria to determine which Azure natural language processing option best fits your requirements. Each criterion describes a workload characteristic and identifies the service that addresses it.

- **Managed natural language processing capabilities:** Use [Azure Language](/azure/ai-services/language-service/overview) APIs for entity recognition, intent identification, topic detection, or sentiment analysis. These capabilities are available as managed services with minimal setup, and you don't need to provision or manage any infrastructure.

- **Prebuilt or pretrained models:** Use Azure Language if you plan to use prebuilt or pretrained models with no infrastructure to manage. This approach suits small to medium datasets and standard natural language processing tasks where prebuilt models deliver sufficient accuracy. It provides automatic scaling, built-in security, and pay-per-call pricing without cluster management overhead.

- **Custom model training on large text datasets:** Use [Azure Databricks](/azure/databricks/introduction) or [Fabric](/fabric/data-engineering/spark-compute) with Spark NLP. These platforms provide the computational power and flexibility that you need for extensive model training on large text datasets. You can also download models through Spark NLP, including Llama 3.x and MPNet.

- **Low-level natural language processing primitives:** Use Azure Databricks or Fabric with Spark NLP for tokenization, stemming, lemmatization, and TF-IDF. Alternatively, use an open-source library like spaCy or NLTK. Azure Language doesn't provide these low-level text-processing primitives.

## Build natural language processing pipelines with Spark NLP

Spark NLP follows the same development pattern as traditional Spark ML models when you run a natural language processing pipeline. You manage trained models by using [MLflow](https://mlflow.org) for experiment tracking and production deployment.

:::image type="complex" border="false" source="../images/spark-natural-language-processing-pipeline.png" alt-text="Diagram that shows the stages of a natural language processing pipeline, like document assembly, sentence detection, tokenization, normalization, and word embedding." lightbox="../images/spark-natural-language-processing-pipeline.png":::
    The diagram shows a Spark DataFrame that moves through five sequential pipeline stages, each shown as a column of fields. Dotted arrows connect the output of one stage to the input of the next, and new fields accumulate at each step. The DocumentAssembler takes raw text and creates a document field. The SentenceDetector uses the document field to produce sentences. The Tokenizer uses the sentences field to produce tokens. The Normalizer uses the tokens to produce a normal field. The WordEmbeddings stage uses the normal field to generate embeddings. By the final stage, the DataFrame contains the text, document, sentences, token, normal, and embeddings fields.
  :::image-end:::

### Assemble core pipeline components

A Spark NLP pipeline chains annotators in sequence. Each annotator transforms the output of the previous stage and builds from raw text to semantic vectors.

- **DocumentAssembler is the entry point for every Spark NLP pipeline.** Use `setCleanupMode` to apply optional text preprocessing, like HTML tag removal or whitespace normalization, before downstream annotators run.

- **SentenceDetector identifies sentence boundaries in the assembled document.** It returns detected sentences either as an `Array` within a single row or as separate rows, depending on your pipeline configuration. Accurate sentence detection is important because many downstream annotators operate at the sentence level.

- **Tokenizer divides raw text into discrete tokens like words, numbers, and symbols.** If the default rules are insufficient for your domain, add custom rules to handle specialized vocabulary, hyphenated terms, or domain-specific patterns.

- **Normalizer refines tokens by applying regular expressions and dictionary transformations.** It cleans text to reduce noise before embedding. For example, you can strip accents, convert to lowercase, or apply custom dictionary mappings to standardize terminology.

- **WordEmbeddings maps tokens to semantic vectors for contextual processing.** Each token is represented as a dense vector that captures its meaning relative to other tokens. Unresolved tokens that don't appear in the embeddings vocabulary default to zero vectors.

### Manage models with MLflow

- **Spark NLP uses Spark MLlib pipelines with native [MLflow](https://mlflow.org) support.** You don't need to write custom serialization or integration code.

- **MLflow manages experiment tracking, model versioning, and deployment.** You can log pipeline parameters, metrics, and artifacts during training runs. MLflow tracks each experiment, so you can compare results across iterations and reproduce successful configurations.

- **MLflow integrates directly with [Azure Databricks](/azure/databricks/introduction) and [Fabric](/fabric/data-science/data-science-overview).** On Azure Databricks, MLflow comes preinstalled and integrates tightly with the workspace. Fabric also provides a [built-in MLflow experience](/fabric/data-science/machine-learning-experiment) with native experiment tracking and autologging, so you don't need to install MLflow separately. If you run Spark NLP on another Spark-based environment, you can install MLflow separately and configure it to track experiments against a remote tracking server.

- **Use the MLflow Model Registry to promote models to production and maintain governance.** The Model Registry provides a central repository to manage model versions across your natural language processing pipelines. In classic deployments, transition models through stages like Staging, Production, and Archived. On [Azure Databricks](/azure/databricks/machine-learning/manage-model-lifecycle/), newer deployments use [Models in Unity Catalog](/azure/databricks/machine-learning/manage-model-lifecycle/), which replaces fixed stages with custom aliases and tags for more flexible life cycle management. On [Fabric](/fabric/data-science/data-science-overview), the workspace provides its own MLflow-based model registry.

## Capability matrix

The following tables summarize the key differences in capabilities between Spark NLP on Azure Databricks or Fabric and Azure Language.

### General capabilities

| Capability | Spark NLP (Azure Databricks or Fabric) | Azure Language |
| :--- | :--- | :--- |
| Pretrained models as a service | Yes | Yes |
| REST API | Yes | Yes |
| Programmability | Python, Scala | See [Supported programming languages](/azure/foundry-classic/foundry-models/supported-languages). |
| Supports processing of large datasets and large documents | Yes | Limited <sup>[1](#note1)</sup> |

<sup>1.</sup> <span id="note1">Language has per-request document size limits that vary by mode. Synchronous requests support up to 5,120 characters per document and asynchronous requests support up to 125,000 characters per document. Both modes support up to 25 documents per API call. You can process large dataset volumes through batching and pagination, but individual documents that exceed the character limit for your chosen mode require chunking. For more information, see [Data and rate limits for the Language service](/azure/ai-services/language-service/concepts/data-limits).</span>

### Annotator capabilities

| Capability | Spark NLP (Azure Databricks or Fabric) | Azure Language |
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
| TF-IDF | Yes | No |
| Regular expression matcher | Yes | Limited <sup>[2](#note2)</sup> |
| Date matcher | Yes | Limited <sup>[3](#note3)</sup> |
| Chunker | Yes | No |

<sup>2.</sup><span id="note2">Regular expression matching is embedded in the CLU feature rather than available as a standalone annotator.</span>

<sup>3.</sup> <span id="note3">CLU supports date matching through DateTime recognizers rather than as a dedicated annotator.</span>

### High-level natural language processing capabilities

| Capability | Spark NLP (Azure Databricks or Fabric) | Azure Language |
| :--- | :--- | :--- |
| Spell check | Yes | No |
| Summarization | Yes | Yes |
| Question answering | Yes | Yes |
| Sentiment detection | Yes | Yes |
| Emotion detection | Yes | Limited <sup>[4](#note4)</sup> |
| Token classification | Yes | Limited <sup>[5](#note5)</sup> |
| Text classification | Yes | Limited <sup>[5](#note5)</sup> |
| Text representation | Yes | No |
| NER | Yes | Yes (prebuilt). CNER is available through custom models. <sup>[5](#note5)</sup> |
| Language detection | Yes | Yes |
| Supports languages other than English | Yes. See [Spark NLP supported languages](https://sparknlp.org/models). | Yes. See [Azure Language supported languages](/azure/ai-services/language-service/concepts/language-support). |

<sup>4.</sup> <span id="note4">Azure Language supports opinion mining, which identifies sentiments linked to specific aspects of text, but doesn't provide dedicated emotion detection (like joy, anger, or sadness classification).</span>

<sup>5.</sup> <span id="note5">Available through custom models. You train CNER, custom text classification, or custom entity recognition models on your own labeled data.</span>

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Ananya Ghosh Chowdhury](https://www.linkedin.com/in/ananyaghoshchowdhury/) | Principal Cloud Solution Architect
- [Kranthi Manchikanti](https://www.linkedin.com/in/kranthimanchikanti/) | Senior AI Solutions Engineer

Other contributors:

- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) |  Cloud Solution Architect
- [Tincy Elias](https://www.linkedin.com/in/tincy-elias/) | Senior Cloud Solution Architect
- [Moritz Steller](https://www.linkedin.com/in/moritz-steller-426430116) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to AI in Azure](/training/paths/introduction-to-ai-on-azure)
- [Develop natural language processing solutions with Foundry Tools](/training/paths/develop-language-solutions-azure-ai)

## Related resources

- Azure Language documentation:

  - [Azure Language overview](/azure/ai-services/language-service/overview)
  - [Foundry documentation](/azure/foundry/what-is-foundry)

- Spark NLP documentation:

  - [Spark NLP](https://sparknlp.org/)
  - [Spark NLP general documentation](https://sparknlp.org/docs/en/quickstart)
  - [Spark NLP demo](https://github.com/JohnSnowLabs/spark-nlp-workshop)

- Azure components:

  - [Fabric](/fabric/)
  - [Azure Databricks](/azure/databricks/introduction)
  - [Foundry Tools](/azure/ai-services/what-are-ai-services)

- Learn resources:

  - [Choose an AI services technology](ai-services.md)
  - [Compare the machine learning products and technologies from Microsoft](../../ai-ml/guide/data-science-and-machine-learning.md)
  - [MLflow and Azure Machine Learning](/azure/machine-learning/concept-mlflow)
  - [AI enrichment with image and natural language processing in Azure AI Search](../../solution-ideas/articles/ai-search-skillsets.yml)
