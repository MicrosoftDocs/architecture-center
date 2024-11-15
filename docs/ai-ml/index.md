---
title: Artificial intelligence (AI) architecture
description: Get started with artificial intelligence (AI). Use high-level architectural types, see Azure AI platform offerings, and find customer success stories.
author: RobBagby
ms.author: robbag
ms.date: 11/14/2024
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure-machine-learning
ms.custom:
  - guide
  - arb-aiml
categories:
  - ai-machine-learning
---


# Artificial intelligence (AI) architecture design

*Artificial intelligence (AI)* is a technology that allows machines to imitate intelligent human behavior. With AI, machines can:

- Analyze data to create images and videos.
- Analyze and synthesize speech.
- Verbally interact in natural ways.
- Make predictions and generate new data.

Architects design workloads that use artificial intelligence to perform functions or make decisions where traditional logic or processing would be prohibitive, or even nearly impossible, to implement. As an architect designing a solution, it's important to understand the AI and machine learning landscape and how Azure offers solutions to integration into your workload design.

## AI concepts

### Algorithms

*Algorithms* or *machine learning algorithms* are pieces of code that help humans explore, analyze, and find meaning in complex data sets. Each algorithm is a finite set of unambiguous step-by-step instructions that a machine can follow to achieve a certain goal. In a machine learning model, the goal is to establish or discover patterns that humans can use to make predictions or categorize information. An algorithm may describe how to determine whether a pet is a cat, dog, fish, bird, or lizard. Another far more complicated algorithm may describe how to identify a written or spoken language, analyze its words, translate them into a different language, and then check the translation for accuracy.

- [What are machine learning algorithms?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-are-machine-learning-algorithms)

### Machine learning

*Machine learning* is an AI technique that uses machine learning algorithms to create predictive models. The machine learning algorithm is used to parse data fields and to "learn" from that data by using patterns found within it to generate models. Those models are then used to make informed predictions or decisions about new data.

The predictive models are validated against known data, measured by performance metrics selected for specific business scenarios, and then adjusted as needed. This process of learning and validation is called *training*. Through periodic retraining, ML models are improved over time.

- [What is machine learning?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-machine-learning-platform/)


### Deep learning

*Deep learning* is a type of ML that can learn through its own data processing. Like machine learning, it also uses algorithms to analyze data, but it does by using artificial neural networks that contains many inputs, outputs, and layers of processing. Each layer can process the data in a different way, and the output of one layer becomes the input for the next. This allows deep learning to create more complex models than traditional machine learning.

- [What is Deep Learning?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-deep-learning)

- [Deep learning versus machine learning](https://azure.microsoft.com/resources/cloud-computing-dictionary/artificial-intelligence-vs-machine-learning)


### Generative AI

*Generative AI* is a form of artificial intelligence in which models are trained to generate new original content based on natural language input. With generative AI, you can describe a desired output in normal everyday language, and the model can respond by creating appropriate text, image, code, and more. Some examples of generative AI applications are:

- [Microsoft Copilot](https://m365.cloud.microsoft/chat/) is primarily a user interface that can assist users in writing code, documents, and other text-based content. It's based on OpenAI's GPT-3 model and is integrated into a wide range of Microsoft applications and user experiences.

- [Azure OpenAI](/azure/ai-services/openai/overview) is a development platform as a service that provides access to OpenAI's powerful language models such as o1-preview, o1-mini, GPT-4o, GPT-4o mini, GPT-4 Turbo with Vision, GPT-4, GPT-3.5-Turbo, and Embeddings model series. These models can be easily adapted to your specific task such as:

    - Content generation 
    - Content summarization
    - Image understanding 
    - Semantic search 
    - Natural language to code translation. 


### Language models

*Language models* are powerful machine learning models used for natural language processing (NLP) tasks, such as text generation and sentiment analysis. These models represent natural language based on the probability of words or sequences of words occurring in a given context.

Conventional language models hare used in supervised settings for research purposes where the models are trained on well-labeled text datasets for specific tasks. Pretrained language models offer an accessible way to get started with AI and have become more widely used in recent years. These models are trained on large-scale text corpora from the internet using deep learning neural networks and can be fine-tuned on smaller datasets for specific tasks.

The size of a language model is determined by its number of parameters, or weights, that determine how the model processes input data and generates output. Parameters are learned during the training process by adjusting the weights within layers of the model to minimize the difference between the model's predictions and the actual data. The more parameters a model has, the more complex and expressive it is, but also the more computationally expensive it is to train and use.

In general, small language models have fewer than 10 billion parameters, and large language models have more than 10 billion parameters. For example, the new Microsoft Phi-3 model family has three versions with different sizes: mini (3.8 billion parameters), small (7 billion parameters), and medium (14 billion parameters).

- [Language model catalog](https://ai.azure.com/explore/models)

### Copilots

The availability of language models led to the emergence of new ways to interact with applications and systems through digital copilots. Copilots are generative AI assistants that are integrated into applications often as chat interfaces. They provide contextualized support for common tasks in those applications.

[Microsoft Copilot](https://m365.cloud.microsoft/chat/) is integrated into a wide range of Microsoft applications and user experiences. It's based on an open architecture that enables third-party developers to create their own plug-ins to extend or customize the user experience with Microsoft Copilot. Additionally, third-party developers can create their own copilots using the same open architecture.

- [Adopt, extend, and build Copilot experiences across the Microsoft Cloud](/microsoft-cloud/dev/copilot/overview).

- [Microsoft Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)

- [Azure AI Studio](https://azure.microsoft.com/products/ai-studio/)


### Retrieval Augmented Generation (RAG) 

*Retrieval Augmented Generation (RAG)* is an architecture that augments the capabilities of a Large Language Model (LLM) like ChatGPT by adding an information retrieval system that provides grounding data. Adding an information retrieval system gives you control over grounding data used by an LLM when it formulates a response. For an enterprise solution, RAG architecture lets you can constrain generative AI to enterprise content thats sourced from vectorized documents, images, and other data formats.

- [Retrieval Augmented Generation (RAG) in Azure AI Search](/azure/search/retrieval-augmented-generation-overview)

### Automated machine learning (AutoML)

*Automated machine learning*, also referred to as automated ML or AutoML, is the process of automating the time-consuming, iterative tasks of machine learning model development. It allows data scientists, analysts, and developers to build ML models with high scale, efficiency, and productivity all while sustaining model quality. 

- [What is automated machine learning?](/azure/machine-learning/concept-automated-ml)

## AI services

With [Azure AI services](https://azure.microsoft.com/services/ai-services/) developers and organizations can create intelligent, market-ready, and responsible applications with out-of-the-box, prebuilt and customizable APIs and models. Usages include natural language processing for conversations, search, monitoring, translation, speech, vision, and decision-making.

- [Choose an Azure AI services technology](../data-guide/technology-choices/ai-services.md)

- [Azure AI services documentation](/azure/ai-services/what-are-ai-services)

- [Try Azure AI services for free](https://azure.microsoft.com/solutions/ai)

- [Choosing a natural language processing technology in Azure](../data-guide/technology-choices/natural-language-processing.yml)


## AI Language models

- *Large Language Models (LLMs)*, such as GPT-3, are powerful tools that can generate natural language across various domains and tasks. However, they aren't perfect and have limitations and risks that need to be considered before deciding to use them for real-world use cases. For more information, see [Understanding LLMs](/ai/playbook/technology-guidance/generative-ai/getting-started/use-case-recommend).

- [Phi open models](https://azure.microsoft.com/blog/new-models-added-to-the-phi-3-family-available-on-microsoft-azure/) are small, less compute-intensive models for generative AI solutions. A small language model (SLM) may be more efficient, interpretable, and explainable than a large language model. For more information, see [Smaller models might work better than LLMs](/ai/playbook/technology-guidance/generative-ai/getting-started/use-case-recommend#smaller-models-might-work-better-than-llms).



## AI development platforms and tools

### Azure Machine Learning service

Azure Machine Learning is an enterprise-grade machine learning service to build and deploy models faster. Azure Machine Learning offers web interfaces and SDKs so you can quickly train and deploy your machine learning models and pipelines at scale. Use these capabilities with open-source Python frameworks, such as PyTorch, TensorFlow, and scikit-learn.

- [What are the machine learning products at Microsoft?](../ai-ml/guide/data-science-and-machine-learning.md)

- [Azure Machine Learning product home page](https://azure.microsoft.com/services/machine-learning/)

- [Azure Machine Learning documentation overview](/azure/machine-learning/)

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml) General orientation with links to many learning resources, SDKs, documentation, and more

#### Machine learning reference architectures for Azure

- [Baseline OpenAI end-to-end chat reference architecture](../ai-ml/architecture/baseline-openai-e2e-chat.yml) is a reference architecture that shows how to build an end-to-end chat architecture with OpenAI's GPT models.

    :::image type="complex" source="architecture/_images/openai-end-to-end-aml-deployment.svg" border="false" lightbox="architecture/_images/openai-end-to-end-aml-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI.":::
    The diagram shows the App Service baseline architecture with a private endpoint that connects to a managed online endpoint in a Machine Learning managed virtual network. The managed online endpoint sits in front of a Machine Learning compute cluster. The diagram shows the Machine Learning workspace with a dotted line that points to the compute cluster. This arrow represents that the executable flow is deployed to the compute cluster. The managed virtual network uses managed private endpoints that provide private connectivity to resources that are required by the executable flow, such as Container Registry and Storage. The diagram further shows user-defined private endpoints that provide private connectivity to the Azure OpenAI Service and Azure AI Search.
:::image-end:::

- [Azure OpenAI chat baseline architecture in an Azure landing zone](../ai-ml/architecture/baseline-openai-e2e-chat.yml) shows you how to build on the Azure OpenAI baseline architecture to address changes and expectations when you deploy it in an Azure landing zone.

- [Machine learning operationalization (MLOps) for Python models using Azure Machine Learning](../ai-ml/guide/mlops-python.yml)

- [Batch scoring of Spark machine learning models on Azure Databricks](../ai-ml/architecture/batch-scoring-databricks.yml)

- [Enterprise-grade conversational bot](../ai-ml/architecture/conversational-bot.yml)

### Automated machine learning (AutoML)

Quickly build ML models at scale using the AutoML capability in Azure Machine Learning to automate tasks

- [Azure automated machine learning product home page](https://azure.microsoft.com/services/machine-learning/automatedml/)

- [Azure automated ML infographic (PDF)](https://aka.ms/automlinfographic/)

- [Tutorial: Create a classification model with automated ML in Azure Machine Learning](/azure/machine-learning/tutorial-first-experiment-automated-ml)

- [Configure automated ML experiments in Python](/azure/machine-learning/how-to-configure-auto-train)

- [Use the CLI extension for Azure Machine Learning](/azure/machine-learning/reference-azure-machine-learning-cli)

- [Automate machine learning activities with the Azure Machine Learning CLI](/azure/machine-learning/reference-azure-machine-learning-cli)

### Generative AI tools

- [Azure AI Studio](https://azure.microsoft.com/services/ai-studio/) helps you experiment, develop, and deploy generative AI apps and APIs responsibly with a comprehensive platform. With Azure AI Studio, you have access to Azure AI Services, LLMs, playground, and resources to help you build, train, and deploy AI models.

- [Azure Copilot Studio](/microsoft-copilot-studio/)is used to extend Microsoft Copilot in Microsoft 365 and build custom copilots for internal and external scenarios. With Copilot Studio, makers can design, test, and publish copilots using the comprehensive authoring canvas. Makers can easily create generative AI-enabled conversations, provide greater control to responses for existing copilots, and accelerate productivity with specific automated workflows.

- [Prompt flow](https://microsoft.github.io/promptflow/index.html) is a suite of development tools designed to streamline the end-to-end development cycle of LLM-based AI applications, from ideation, prototyping, testing, evaluation to production deployment and monitoring. It makes prompt engineering easier and enables you to build LLM apps with production quality.


## Data platforms for AI

### Microsoft Fabric

Microsoft Fabric is an end-to-end analytics and data platform designed for enterprises that require a unified solution. It encompasses data movement, processing, ingestion, transformation, real-time event routing, and report building. It offers a comprehensive suite of services including Data Engineering, Data Factory, Data Science, Real-Time Analytics, Data Warehouse, and Databases.

Microsoft Fabric integrates separate components into a cohesive stack. Instead of relying on different databases or data warehouses, you can centralize data storage with OneLake. AI capabilities are seamlessly embedded within Fabric, eliminating the need for manual integration. With Fabric, you can easily transition your raw data into actionable insights for business users.


- [What is Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview)

- [Learning Path - Get started with Microsoft Fabric](/training/paths/get-started-fabric/) 

- [AI services in Fabric](/fabric/data-science/ai-services/ai-services-overview)

- [Use Azure OpenAI in Fabric with REST API](/fabric/data-science/ai-services/how-to-use-openai-via-rest-api)

- [Using Microsoft Fabric for Generative AI: A Guide to Building and Improving RAG Systems](https://blog.fabric.microsoft.com/en-US/blog/using-microsoft-fabric-for-generative-ai-a-guide-to-building-and-improving-rag-systems?WT.mc_id=DP-MVP-5004564)

- [Building Custom AI Applications with Microsoft Fabric: Implementing Retrieval Augmented Generation for Enhanced Language Models](https://blog.fabric.microsoft.com/en-US/blog/building-custom-ai-applications-with-microsoft-fabric-implementing-retrieval-augmented-generation-for-enhanced-language-models/)

#### Copilots in Fabric

Copilot and other generative AI features let you transform and analyze data, generate insights, and create visualizations and reports in Microsoft Fabric and Power BI. You can either build your own copilot, or choose one of the following prebuilt copilots:

- [Overview of Copilot in Fabric](/fabric/get-started/copilot-fabric-overview)

- [Copilot for Data Science and Data Engineering](/fabric/get-started/copilot-notebooks-overview)

- [Copilot for Data Factory](/fabric/get-started/copilot-fabric-data-factory)

- [Copilot for Data Warehouse](/fabric/data-warehouse/copilot)

- [Copilot for Power BI](/power-bi/create-reports/copilot-introduction)

- [Copilot for Real-Time Intelligence](/fabric/get-started/copilot-real-time-intelligence)




#### AI skills in Fabric

With a Microsoft Fabric AI skill, you can configure a generative AI system to generate queries that answer questions about your data. After you configure the AI skill, you can share it with your colleagues, who can then ask their questions in plain English. Based on their questions, the AI generates queries over your data that answer those questions.

- [What is the AI skill in Fabric? (preview)](/fabric/data-science/concept-ai-skill)
- [How to create an AI Skill](/fabric/data-science/how-to-create-ai-skill)
- [AI skill example](/fabric/data-science/ai-skill-scenario)
- [Difference between an AI skill and a copilot](/fabric/data-science/concept-ai-skill#difference-between-an-ai-skill-and-a-copilot)

### Apache Spark-based data platforms for AI

Apache Spark is a parallel processing framework that supports in-memory processing to boost the performance of big data analytic applications. Spark provides primitives for in-memory cluster computing. A Spark job can load and cache data into memory and query it repeatedly, which is faster than disk-based applications, such as Hadoop.


#### Apache Spark in Azure Fabric

Microsoft Fabric Runtime is an Azure-integrated platform based on Apache Spark that enables the execution and management of data engineering and data science experiences. It combines key components from both internal and open-source sources, providing customers with a comprehensive solution. 

Major components of Fabric Runtime:

- **Apache Spark** - a powerful open-source distributed computing library that enables large-scale data processing and analytics tasks. Apache Spark provides a versatile and high-performance platform for data engineering and data science experiences.

- **Delta Lake** - an open-source storage layer that brings ACID transactions and other data reliability features to Apache Spark. Integrated within Fabric Runtime, Delta Lake enhances data processing capabilities and ensures data consistency across multiple concurrent operations.

- **Default-level packages for Java/Scala, Python, and R** - packages that support diverse programming languages and environments. These packages are automatically installed and configured, allowing developers to apply their preferred programming languages for data processing tasks.

The Microsoft Fabric Runtime is built upon a robust open-source operating system, ensuring compatibility with various hardware configurations and system requirements.


- [Apache Spark Runtimes in Fabric](/fabric/data-engineering/runtime)


#### Azure Databricks Runtime for Machine Learning

[Azure Databricks](https://azure.microsoft.com/services/databricks/) is an Apache Spark–based analytics platform with one-click setup, streamlined workflows, and an interactive workspace for collaboration between data scientists, engineers, and business analysts.

[Databricks Runtime for Machine Learning (Databricks Runtime ML)](/azure/databricks/runtime/mlruntime) lets you start a Databricks cluster with all of the libraries required for distributed training. It provides a ready-to-go environment for machine learning and data science. Plus, it contains multiple popular libraries, including TensorFlow, PyTorch, Keras, and XGBoost. It also supports distributed training using Horovod.

- [Azure Databricks product home page](https://azure.microsoft.com/services/databricks/)

- [Azure Databricks documentation](/azure/azure-databricks/)

- [Machine learning capabilities in Azure Databricks](/azure/databricks/applications/machine-learning/)

- [How-to guide: Databricks Runtime for Machine Learning](/azure/databricks/runtime/mlruntime)

- [Batch scoring of Spark machine learning models on Azure Databricks](../ai-ml/architecture/batch-scoring-databricks.yml)

- [Deep learning overview for Azure Databricks](/azure/databricks/applications/deep-learning/)


#### Apache Spark in Azure HDInsight

[Apache Spark in Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview) is the Microsoft implementation of Apache Spark in the cloud. Spark clusters in HDInsight are compatible with Azure Storage and Azure Data Lake Storage, so you can use HDInsight Spark clusters to process your data stored in Azure.

The Microsoft machine learning library for Apache Spark is [SynapseML](https://github.com/microsoft/SynapseML) (formerly known as MMLSpark). This open-source library adds many deep learning and data science tools, networking capabilities, and production-grade performance to the Spark ecosystem. Learn more about [SynapseML features and capabilities](../ai-ml/guide/data-science-and-machine-learning.md#synapseml).

- [Azure HDInsight overview](/azure/hdinsight/hdinsight-overview). Basic information about features, cluster architecture, and use cases, with pointers to quickstarts and tutorials.

- [Tutorial: Build an Apache Spark machine learning application in Azure HDInsight](/azure/hdinsight/spark/apache-spark-ipython-notebook-machine-learning)

- [Apache Spark best practices on HDInsight](/azure/hdinsight/spark/spark-best-practices)

- [Configure HDInsight Apache Spark Cluster settings](/azure/hdinsight/spark/apache-spark-settings)

- [Machine learning on HDInsight](/azure/hdinsight/hdinsight-machine-learning-overview)

- [GitHub repo for SynapseML: Microsoft machine learning library for Apache Spark](https://github.com/microsoft/SynapseML)

- [Create an Apache Spark machine learning pipeline on HDInsight](/azure/hdinsight/spark/apache-spark-creating-ml-pipelines)



## Data storage for AI

### Microsoft Fabric OneLake

OneLake is a single, unified, logical data lake for your whole organization. A data Lake processes large volumes of data from various sources. Like OneDrive, OneLake comes automatically with every Microsoft Fabric tenant and is designed to be the single place for all your analytics data. OneLake offers one data lake for the entire organization, and  a copy of data for use with multiple analytical engines.

- [OneLake, the OneDrive for data](/fabric/onelake/onelake-overview)


### Azure Data Lake Storage

Azure Data Lake Storage is a set of capabilities dedicated to and optimized for big data analytics, built on [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction).

Azure Data Lake Storage converges the capabilities of [Azure Data Lake Storage Gen1](/previous-versions/azure/data-lake-store/data-lake-store-overview) with Azure Blob Storage. For example, Data Lake Storage provides file system semantics, file-level security, and scale. Because these capabilities are built on Blob storage, you also get low-cost, tiered storage, with high availability/disaster recovery capabilities.


- [Introduction to Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)

- [Tutorial: Azure Data Lake Storage, Azure Databricks & Spark](/azure/storage/blobs/data-lake-storage-use-databricks-spark)



## Data processing for AI

### Microsoft Fabric Data Factory

With Data Factory, you can ingest, prepare, and transform data from multiple data sources (for example, databases, data warehouse, Lakehouse, real-time data, and more). 

Data Factory supports both code and no/low code solutions:

- [*Data pipelines*](/fabric/data-factory/data-factory-overview#data-pipelines) let you create powerful workflow capabilities at cloud-scale. With data pipelines, you can use the drag-and-drop interface to build complex workflows that can refresh your dataflow, move PB-size data, and define sophisticated control flow pipelines.

- [*Dataflows*](/fabric/data-factory/data-factory-overview#dataflows) provide a low-code interface for ingesting data from hundreds of data sources, transforming your data using 300+ data transformations. 


Also see:
- [Data Factory end-to-end scenario: introduction and architecture](/fabric/data-factory/tutorial-end-to-end-introduction)



### Azure Databricks

With Databricks Data Intelligence Platform, you can write code to create a machine learning workflow using *feature engineering*:

- Data pipelines ingest raw data, create feature tables, train models, and perform batch inference. When you train and log a model using feature engineering in Unity Catalog, the model is packaged with feature metadata. When you use the model for batch scoring or online inference, it automatically retrieves feature values. The caller doesn't need to know about them or include logic to look up or join features to score new data.
- Model and feature serving endpoints are available with a single click and provide milliseconds of latency.
- Data and model monitoring.

You can also use [Mosaic AI Vector Search], which is optimized for storing and retrieving embeddings. Embeddings are crucial for applications that require similarity searches, such as RAG (Retrieval Augmented Generation), recommendation systems, and image recognition.


- [Azure Databricks - Serve data for ML and AI](/azure/databricks/machine-learning/serve-data-ai)

- [Mosaic AI Vector Search](/azure/databricks/generative-ai/vector-search)

## Data connectors for AI

Azure Data Factory and Azure Synapse Analytics pipelines support many data stores and formats via Copy, Data Flow, Look up, Get Metadata, and Delete activities. To see the available data store connectors, the supported capabilities and the corresponding configurations, and generic ODBC connection options, see [Azure Data Factory and Azure Synapse Analytics connector overview](/azure/data-factory/connector-overview).


## Custom AI


### Azure Machine Learning

Azure Machine Learning is a cloud service for accelerating and managing the machine learning (ML) project lifecycle. ML professionals, data scientists, and engineers can use it in their day-to-day workflows to train and deploy models and manage machine learning operations (MLOps).

Azure Machine Learning offer the following capabilities:


- **Algorithm selection** Some algorithms make particular assumptions about the structure of the data or the desired results. If you can find one that fits your needs, it can give you more useful results, more accurate predictions, or faster training times.

    [How to select algorithms for Azure Machine Learning](/azure/machine-learning/how-to-select-algorithms)

- **Hyperparameter tuning or optimization** is the process of finding the configuration of hyperparameters that results in the best performance. The process is computationally expensive and manual. *Hyperparameters* are adjustable parameters that let you control the model training process. For example, with neural networks, you decide the number of hidden layers and the number of nodes in each layer. Model performance depends heavily on hyperparameters.

    Azure Machine Learning lets you automate hyperparameter tuning and run experiments in parallel to efficiently optimize hyperparameters.
    
    - [Hyperparameter tuning a model with Azure Machine Learning (v1)](/azure/machine-learning/how-to-tune-hyperparameters)
    - [Upgrade hyperparameter tuning to SDK v2](/azure/machine-learning/migrate-to-v2-execution-hyperdrive)
    - [Learning Path: Perform hyperparameter tuning with Azure Machine Learning](/training/modules/perform-hyperparameter-tuning-azure-machine-learning-pipelines/)


- **Model training.** With Azure Machine Learning, you can iteratively use an algorithm to create or "teach" models. Once trained, these models can then be used to analyze data from which predictions can be made. During the training phase, a quality set of known data is tagged so that individual fields are identifiable. The tagged data is fed to an algorithm configured to make a particular prediction. When finished, the algorithm outputs a model that describes the patterns it found as a set of parameters. During validation, fresh data is tagged and used to test the model. The algorithm is adjusted as needed and possibly put through more training. Finally, the testing phase uses real-world data without any tags or preselected targets. Assuming the model's results are accurate, It's considered ready for use and can be deployed.
    
    - [Train models with Azure Machine Learning](/azure/machine-learning/concept-train-machine-learning-model)
    - [Tutorial: Train a model in Azure Machine Learning](/azure/machine-learning/tutorial-train-model)
    - [Deep learning and distributed training with Azure Machine Learning](/azure/machine-learning/concept-distributed-training)

- **Automated machine learning (AutoML)** is the process of automating the time-consuming, iterative tasks of machine learning model development. It can significantly reduce the time it takes to get production-ready ML models. Automated ML can assist with model selection, hyperparameter tuning, model training, and other tasks, without requiring extensive programming or domain knowledge.

    - [What is automated machine learning?](/azure/machine-learning/concept-automated-ml)

- **Scoring** is also called *prediction* and is the process of generating values based on a trained machine learning model, given some new input data. The values, or scores, that are created can represent predictions of future values,  but they might also represent a likely category or outcome. 

  - [Score Model](/azure/machine-learning/component-reference/score-model)
  - [Deploy models for scoring in batch endpoints0](/azure/machine-learning/how-to-use-batch-model-deployments)
  - [Batch scoring of Spark models on Azure Databricks](/azure/architecture/ai-ml/architecture/batch-scoring-databricks)



### Azure OpenAI


Azure OpenAI Service lets you tailor our models to your personal datasets by using a process known as *fine-tuning*. This customization step lets you get more out of the service by providing:

- Higher quality results than what you can get just from [prompt engineering](/azure/ai-services/openai/concepts/prompt-engineering)
- The ability to train on more examples than can fit into a model's max request context limit.
- Token savings due to shorter prompts
- Lower-latency requests, particularly when using smaller models.


For more information, see:

- [Customize a model with fine-tuning](/azure/ai-services/openai/how-to/fine-tuning)
- [Azure OpenAI GPT-4o-mini fine-tuning tutorial](/azure/ai-services/openai/tutorials/fine-tune)
- [Baseline OpenAI end-to-end chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat)


### Azure AI services for Custom AI

[Azure AI services](https://azure.microsoft.com/services/ai-services/) offers features that let you build custom AI models and applications. This section provides an overview some of these key features.



#### Custom Speech

[Custom speech](/azure/ai-services/speech-service/custom-speech-overview) is a feature of the Azure AI Speech service. With custom speech, you can evaluate and improve the accuracy of speech recognition for your applications and products. A custom speech model can be used for real-time speech to text, speech translation, and batch transcription.

Out of the box, speech recognition utilizes a Universal Language Model as a base model that is trained with Microsoft-owned data and reflects commonly used spoken language. The base model is pretrained with dialects and phonetics representing various common domains. When you make a speech recognition request, the most recent base model for each supported language is used by default. The base model works well in most speech recognition scenarios.

A custom model can be used to augment the base model to improve recognition of domain-specific vocabulary specific to the application by providing text data to train the model. It can also be used to improve recognition based for the specific audio conditions of the application by providing audio data with reference transcriptions.

You can also train a model with structured text when the data follows a pattern, to specify custom pronunciations, and to customize display text formatting with custom inverse text normalization, custom rewrite, and custom profanity filtering.


#### Custom Translator

[Custom Translator](/azure/ai-services/translator/custom-translator/overview) is a feature of the [Azure AI Translator](/azure/ai-services/translator/translator-overview) service. With Custom Translator, enterprises, app developers, and language service providers can build customized neural machine translation (NMT) systems. The customized translation systems seamlessly integrate into existing applications, workflows, and websites.

The platform enables users to build and publish custom translation systems to and from English. Custom Translator supports more than three dozen languages that map directly to the languages available for NMT. For a complete list, see [Translator language support](/azure/ai-services/translator/language-support).


Custom Translator offers the following features:

|Feature  |Description  |
|---------|---------|
|[Apply neural machine translation technology](https://www.microsoft.com/translator/blog/2016/11/15/microsoft-translator-launching-neural-network-based-translations-for-all-its-speech-languages/)     |  Improve your translation by applying neural machine translation (NMT) provided by Custom translator.       |
|[Build systems that knows your business terminology](/azure/ai-services/translator/custom-translator/beginners-guide)     |  Customize and build translation systems using parallel documents that understand the terminologies used in your own business and industry.       |
|[Use a dictionary to build your models](/azure/ai-services/translator/custom-translator/how-to/train-custom-model#when-to-select-dictionary-only-training)     |   If you don't have training data set, you can train a model with only dictionary data.       |
|[Collaborate with others](/azure/ai-services/translator/custom-translator/how-to/create-manage-workspace#manage-workspace-settings)     |   Collaborate with your team by sharing your work with different people.     |
|[Access your custom translation model](/azure/ai-services/translator/custom-translator/how-to/translate-with-custom-model)     |  You can access your custom translation model anytime using your existing applications/ programs via Microsoft Translator Text API V3.       |


#### Document Intelligence custom models

[Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) uses advanced machine learning technology to identify documents, detect and extract information from forms and documents, and return the extracted data in a structured JSON output. With Document Intelligence, you can use document analysis models, prebuilt/pretrained, or your trained standalone custom models.

[Document Intelligence custom models](/azure/ai-services/document-intelligence/train/custom-model) now include [custom classification models](/azure/ai-services/document-intelligence/train/custom-classifier) for scenarios where you need to identify the document type before invoking the extraction model. Classifier models are available starting with the ```2023-07-31 (GA)``` API. A classification model can be paired with a custom extraction model to analyze and extract fields from forms and documents specific to your business. Standalone custom extraction models can be combined to create [composed models](/azure/ai-services/document-intelligence/train/composed-models).


### Custom AI tools

Although prebuilt AI models are useful and increasingly flexible, the best way to get what you need from AI is to build a model that's tailored to your specific needs. There are two primary tools for creating custom AI models: Generative AI and traditional machine learning:

#### Azure Machine Learning studio

[Azure Machine Learning studio](https://ml.azure.com/home) Azure Machine Learning is a cloud service for accelerating and managing the machine learning (ML) project lifecycle. ML professionals, data scientists, and engineers can use it in their day-to-day workflows to train and deploy models and manage machine learning operations (MLOps).:

- Build and train Azure Machine Learning model with any type of compute including Spark and GPUs for cloud-scale large AI workloads.
- Run automated Azure Machine Learning (AutoML) and drag-and-drop UI for low-code Azure Machine Learning.
- Implement end-to-end Azure Machine LearningOps and repeatable Azure Machine Learning pipelines.
- Use responsible AI dashboard for bias detection and error analysis.
- Orchestrate and manage prompt engineering and LLM flows.
- Deploy models with REST API endpoints, real-time, and batch inference.
- Use Hubs (Preview) to share compute, quota, security, and connectivity to company resources with a group of workspaces, while centralizing governance for IT. Set up a hub once, then create secure workspaces directly from the Studio for each project. Use hubs to manage your team's work in both ML Studio and AI Studio.
  
#### Azure AI Studio

[Azure AI Studio](/azure/ai-studio/what-is-ai-studio) is designed to help you efficiently build and deploy custom generative AI applications with the power of Azure's broad AI offerings:
  
- Build together as one team. Your AI Studio hub provides enterprise-grade security, and a collaborative environment with shared resources and connections to pretrained models, data and compute.
- Organize your work. Your AI Studio project helps you save state, allowing you to iterate from first idea, to first prototype, and then first production deployment. Also easily invite others to collaborate along this journey.
- Use your preferred development platform and frameworks, including GitHub, Visual Studio Code, LangChain, Semantic Kernel, AutoGen, and more.
- Discover and benchmark from over 1,600 models.
- Provision Models-as-a-Service (MaaS) through serverless APIs and hosted fine-tuning.
- Incorporate multiple models, data sources, and modalities.
- Build Retrieval Augmented Generation (RAG) using your protected enterprise data without the need for fine-tuning.
- Orchestrate and manage prompts engineering and Large Language Model (LLM) flows.
- Design and safeguard apps and APIs with configurable filters and controls.
- Evaluate model responses with built-in and custom evaluation flows.
- Deploy AI innovations to Azure’s managed infrastructure with continuous monitoring and governance across environments.
- Continuously monitor deployed apps for safety, quality, and token consumption in production.|


For a detailed comparison between Azure Machine Learning and Azure AI Studio, see [Azure Machine Learning vs. Azure AI Studio](/ai/ai-studio-experiences-overview).

#### Prompt flow in Azure AI Studio

[Prompt flow in Azure AI Studio](/azure/ai-studio/how-to/prompt-flow) is a development tool designed to streamline the entire development cycle of AI applications powered by Large Language Models (LLMs). Prompt flow provides a comprehensive solution that simplifies the process of prototyping, experimenting, iterating, and deploying your AI applications.

- Prompt flow is a feature that can be used to generate, customize, or run a flow.
- A flow is an executable instruction set that can implement the AI logic. Flows can be created or run via multiple tools, like a prebuilt canvas, LangChain, etcetera. Iterations of a flow can be saved as assets; once deployed a flow becomes an API. Not all flows are prompt flows; rather, prompt flow is one way to create a flow.
- A prompt is a package of input sent to a model, consisting of the user input, system message, and any examples. User input is text submitted in the chat window. System message is a set of instructions to the model scoping its behaviors and functionality.
- A sample flow is a simple, prebuilt orchestration flow that shows how flows work, and can be customized.
- A sample prompt is a defined prompt for a specific scenario that can be copied from a library and used as-is or modified in prompt design.

### Custom AI code languages

The core concept of AI is the use of algorithms to analyze data and generate models to describe (or *score*) it in ways that are useful. Algorithms are written by developers and data scientists (and sometimes by other algorithms) using programming code. Two of the most popular programming languages for AI development are currently Python and R.

[Python](https://www.python.org/) is a general-purpose, high-level programming language. It has a simple, easy-to-learn syntax that emphasizes readability. There is no compiling step. Python has a large standard library, but it also supports the ability to add modules and packages. This encourages modularity and lets you expand capabilities when needed. There is a large and growing ecosystem of AI and ML libraries for Python, including many that are readily available in Azure.

- [Python on Azure product home page](https://azure.microsoft.com/develop/python/)

- [Azure for Python developers](/azure/python/)

- [Azure Machine Learning SDK for Python](/python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true)

- [Introduction to machine learning with Python and Azure Notebooks](/training/paths/intro-to-ml-with-python/)

- [`scikit-learn`](https://scikit-learn.org/stable/). An open-source ML library for Python

- [PyTorch](https://pytorch.org/). An open-source Python library with a rich ecosystem that can be used for deep learning, computer vision, natural language processing, and more

- [TensorFlow](https://www.tensorflow.org/). An open-source symbolic math library also used for ML applications and neural networks

- [Tutorial: Apply machine learning models in Azure Functions with Python and TensorFlow](/azure/azure-functions/functions-machine-learning-tensorflow?tabs=bash)


[R is a language and environment](https://www.r-project.org/) for statistical computing and graphics. It can be used for everything from mapping broad social and marketing trends online to developing financial and climate models.

Microsoft has fully embraced the R programming language and provides many different options for R developers to run their code in Azure.

- [Use R interactively on Azure Machine Learning](/azure/machine-learning/how-to-r-interactive-development).

- [Tutorial: Create a logistic regression model in R with Azure Machine Learning](/azure/machine-learning/tutorial-1st-r-experiment)



### General info on custom AI on Azure

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)

- [Azure Machine Learning SDK for Python](/python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true)

- [Azure Machine Learning Python SDK notebooks](https://github.com/Azure/MachineLearningNotebooks). A GitHub repo of example notebooks demonstrating the Azure Machine Learning Python SDK.

- [Train R models using the Azure Machine Learning CLI (v2)](https://github.com/Azure/azureml-examples/tree/main/cli/jobs/single-step/r)



## Customer stories

Different industries are applying AI in innovative and inspiring ways. Following are a few customer case studies and success stories:


- [Volkswagen: Machine translation speaks Volkswagen – in 40 languages](https://customers.microsoft.com/story/779468-volkswagen-azure-automotive-en)
- [Healthcare for All with Kry using Azure Open AI](https://customers.microsoft.com/story/1693712644049090392-kry-azure-open-ai-service-sweden)
- [PIMCO boosts client service with an AI-powered search platform built on Azure AI](https://customers.microsoft.com/story/1834023197365666109-pimco-azure-ai-search-banking-and-capital-markets-en-united-states)
- [Legrand and Azure OpenAI Service: Powering smarter solutions with AI-driven tools](https://customers.microsoft.com/story/1833247205652391288-legrand-cloud-for-manufacturing-discrete-manufacturing-en-france)
- [C.H. Robinson overcomes decades-old barriers to automate the logistics industry using Azure AI](https://customers.microsoft.com/story/1833509185850734713-chrobinson-azure-ai-studio-other-en-united-states)

[Browse more AI customer stories](https://customers.microsoft.com/search?sq=AI&ff=&p=0&so=story_publish_date%20desc)

## General info on Microsoft AI

Learn more about Microsoft AI, and keep up-to-date with related news:

- [Microsoft AI](https://www.microsoft.com/ai/)

- [AI learning hub](/ai/).

- [Azure AI](https://azure.microsoft.com/solutions/ai/)

- [Microsoft AI News](https://news.microsoft.com/source/topics/ai/)

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)

- [Azure Architecture Center](../index.yml)

## Next steps

- To learn about the artificial intelligence development products available from Microsoft, go to [Microsoft AI](https://www.microsoft.com/ai).

- For training in how to develop AI solutions, go to [AI learning hub](/ai/).

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI) organizes the Microsoft open source AI-based repositories, providing tutorials and learning materials.

- [Find architecture diagrams and technology descriptions for AI solutions reference architectures](/azure/architecture/browse/?azure_categories=ai-machine-learning).


