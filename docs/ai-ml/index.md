---
title: AI Architecture Design
description: Get started with AI. Use high-level architectural types, see Azure AI platform offerings, and find customer success stories.
author: davihern
ms.author: davihern
ms.date: 15/12/2025
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# AI architecture design

AI is a technology that enables machines to imitate intelligent human behavior. Machines can use AI to:

- Analyze data to create images and videos.
- Analyze and synthesize speech.
- Verbally interact in natural ways.
- Make predictions and generate new data.

You can incorporate AI into applications to perform functions or make decisions that traditional logic or processing can't handle effectively. As an architect that designs solutions, it's important to understand the AI and machine learning landscape and how you can integrate Azure solutions into your workload design.

## Get started

Azure Architecture Center provides example architectures, architecture guides, architectural baselines, and ideas that you can apply to your scenario. Workloads that involve AI and machine learning components should follow the Azure Well-Architected Framework [AI workloads](/azure/well-architected/ai/get-started) guidance. This guidance includes principles and design guides that influence the AI and machine learning workload across the five architecture pillars. You should implement those recommendations in the scenarios and content in the Azure Architecture Center.

## AI concepts

AI concepts encompass a wide range of technologies and methodologies that enable machines to perform tasks that typically require human intelligence. The following sections provide an overview of key AI concepts.

### Algorithms

*Algorithms* or *machine learning algorithms* are pieces of code that help people explore, analyze, and find meaning in complex datasets. Each algorithm is a finite set of unambiguous step-by-step instructions that a machine can follow to achieve a specific goal. The goal of a machine learning model is to establish or discover patterns that humans can use to make predictions or categorize information. An algorithm might describe how to determine whether a pet is a cat, dog, fish, bird, or lizard. Another far more complicated algorithm might describe how to identify a written or spoken language, analyze its words, translate them into a different language, and then check the translation for accuracy.

Choose an algorithm family that best suits your task. Evaluate the various algorithms within the family to find the appropriate fit for your workload. For more information, see [What are machine learning algorithms?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-are-machine-learning-algorithms).

### Machine learning

*Machine learning* is an AI technique that uses algorithms to create predictive models. These algorithms parse data fields and "learn" from the patterns within data to generate models. The models can then make informed predictions or decisions based on new data.

The predictive models are validated against known data, measured by performance metrics for specific business scenarios, and then adjusted as needed. This process of learning and validation is called *training*. Through periodic retraining, machine learning models improve over time.

In your workload design, you might use machine learning if your scenario includes past observations that you can reliably use to predict future situations. These observations can be universal truths, such as computer vision that detects one form of animal from another. Or these observations can be specific to your situation, such as computer vision that detects a potential assembly mistake on your assembly lines based on past warranty claim data. 

For more information, see [What is machine learning?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-machine-learning-platform/).

### Deep learning

*Deep learning* is a type of machine learning that can learn through its own data processing. Like machine learning, it also uses algorithms to analyze data. But it analyzes data through artificial neural networks that contain many inputs, outputs, and layers of processing. Each layer can process the data in a different way. The output of one layer becomes the input for the next. This process enables deep learning to create more complex models than traditional machine learning.

Deep learning requires a large investment to generate highly customized or exploratory models. You might consider other solutions in this article before you add deep learning to your workload.

For more information, see [What is deep learning?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-deep-learning).

### Generative AI

*Generative AI* trains models to generate original content based on many forms of content, such as natural language, computer vision, audio, or image input. With generative AI, you can describe a desired output in everyday language, and the model can respond by creating appropriate text, image, and code. Examples of generative AI applications include M365 Copilot and Microsoft Foundry.

- [M365 Copilot](https://m365.cloud.microsoft/chat/) is primarily a user interface that helps you write code, documents, and other text-based content. It's based on popular models from OpenAI and Anthropic and is integrated into a wide range of Microsoft applications and user experiences.

- [Microsoft Foundry](/azure/ai-services/openai/overview) is a development platform as a service that provides access to more that 11,000 language models, such as OpenAI's gpt-5.2, Sora2, Anthropic's Claude, Microsoft's Phi, xAI's Grok, etc... You can adapt these models to your specific tasks, such as:

  - Content generation.
  - Content summarization.
  - Image understanding.
  - Semantic search.
  - Natural language to code translation.
  - Video generation.
  - Speech to Speech

### Language models

*Language models* are a subset of generative AI that focus on natural language processing tasks, such as text generation and sentiment analysis. These models represent natural language based on the probability of words or sequences of words occurring in a given context.

Conventional language models are used in supervised settings for research purposes where the models are trained on well-labeled text datasets for specific tasks. Pretrained language models offer an accessible way to get started with AI. They're more widely used in recent years. These models are trained on large-scale text collections from the internet via deep learning neural networks. You can fine-tune them on smaller datasets for specific tasks.

The number of parameters, or weights, determine the size of a language model. Parameters influence how the model processes input data and generates output. During training, the model adjusts the weights to minimize the difference between its predictions and the actual data. This process is how the model learns parameters. The more parameters a model has, the more complex and expressive it is. But it's also more computationally expensive to train and use.

In general, small language models generally have fewer than 10 billion parameters, and large language models have more than 10 billion parameters. For example, the Microsoft Phi-4 model family has several versions like:

- Phi-4-Mini, 3.8 billion parameters
- Phi-4-Multimodal-instruct, 5.6 billion parameters
- Phi-4 (base model), 14 billion parameters

For more information, see [Language model catalog](https://ai.azure.com/explore/models).

### Copilots

The availability of language models led to the emergence of new ways to interact with applications and systems through digital copilots and connected, domain-specific agents. *Copilots* are generative AI assistants that integrate into applications, often as chat interfaces. They provide contextualized support for common tasks in those applications.

[Microsoft Copilot](https://m365.cloud.microsoft/chat/) integrates with a wide range of Microsoft applications and user experiences. It's based on an open architecture where non-Microsoft developers can create their own plug-ins to extend or customize the user experience with Copilot. Partner developers can also create their own copilots by using the same open architecture.

For more information, see the following resources:

- [Adopt, extend, and build Copilot experiences across the Microsoft Cloud](/microsoft-cloud/dev/copilot/overview)
- [Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)
- [Microsoft Foundry](/azure/ai-foundry/what-is-ai-foundry)

### Retrieval Augmented Generation

*Retrieval Augmented Generation (RAG)* is an architecture pattern that augments the capabilities of a large language model (LLM), like ChatGPT, that's trained only on public data. You can use this pattern to add a retrieval system that provides relevant grounding data in the context with the user request. An information retrieval system provides control over grounding data that a language model uses when it formulates a response. RAG architecture helps you scope generative AI to content that's sourced from vectorized documents, images, and other data formats. RAG isn't limited to vector search storage. You can use any data store technology.

For more information, see [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) and [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search).

## Agent-based architecture

For guidance about how to coordinate multiple agents in complex AI scenarios, see [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns).

## Foundry tools

With [Foundry tools](https://azure.microsoft.com/en-us/products/ai-foundry/tools), developers and organizations can use ready-made, prebuilt, and customizable APIs and models to create intelligent, market-ready, and responsible applications. Use cases include natural language processing for conversations, search, monitoring, translation, speech, vision, and decision-making.

For more information, see the following resources:

- [Choose an Azure AI services technology](../data-guide/technology-choices/ai-services.md)
- [What are Foundry tools?](/azure/ai-services/what-are-ai-services)
- [Choose a natural language processing technology in Azure](../data-guide/technology-choices/natural-language-processing.md)

## AI language models

*LLMs*, such as the OpenAI GPT models, are powerful tools that can generate natural language across various domains and tasks. To choose a model, consider factors such as data privacy, ethical use, accuracy, and bias.

[Phi open models](https://azure.microsoft.com/en-us/products/phi/) are small, less compute-intensive models for generative AI solutions. A small language model might be more efficient, interpretable, and explainable than an LLM.

When you design a workload, you can use language models as a hosted solution behind a metered API. Alternatively, for many small language models, you can host language models in-process or at least on the same compute as the consumer. When you use language models in your solution, consider your choice of language model and its available hosting options to help ensure an optimized solution for your use case.

## AI development platforms and tools

The following AI development platforms and tools can help you build, deploy, and manage machine learning and AI models.

### Azure Machine Learning

Azure Machine Learning is a machine learning service that you can use to build and deploy models. Machine Learning offers web interfaces and SDKs for you to train and deploy your machine learning models and pipelines at scale. Use these capabilities with open-source Python frameworks, such as PyTorch, TensorFlow, and scikit-learn.

For more information, see the following resources:

- [Compare Microsoft machine learning products and technologies](../ai-ml/guide/data-science-and-machine-learning.md)
- [Machine Learning documentation](/azure/machine-learning/)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)

#### AI and Machine learning reference architectures for Azure

- [Microsoft Foundry chat architecture in an Azure landing zone](./architecture/baseline-azure-ai-foundry-landing-zone.yml)
- [Baseline Microsoft Foundry chat reference architecture](./architecture/baseline-azure-ai-foundry-chat.yml) describes how to build an end-to-end chat architecture by using OpenAI's GPT models in Microsoft Foundry. It incorporates grounding via enterprise data sources to enrich responses with contextual information.

  :::image type="complex" source="./architecture/_images/baseline-azure-ai-foundry.svg" border="false" lightbox="./architecture/_images/baseline-azure-ai-foundry.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture that uses Microsoft Foundry.":::
  The diagram presents a detailed Azure architecture for deploying an AI solution. On the left, a user connects through an Application Gateway with a web application firewall, which is part of a virtual network. This gateway is linked to private DNS zones and protected by Azure DDoS Protection. Below the gateway, private endpoints connect to services such as App Service, Azure Key Vault, and Storage, which are used for client app deployment. The App Service is managed with identity and spans three zones. Monitoring is provided by Application Insights and Azure Monitor, and authentication is handled by Microsoft Entra ID.

  Moving right, the virtual network contains several subnets: App Service integration, private endpoint, Microsoft Foundry integration, Azure AI agent integration, Azure Bastion, jump box, build agents, and Azure firewall. Each subnet hosts specific endpoints or services, such as storage, Foundry, AI Search, Azure Cosmos DB, and knowledge store, all connected via private endpoints. Outbound traffic from the network passes through the Azure Firewall to reach internet sources.

  To the far right, a separate box represents Microsoft Foundry, which includes an account and a project. Managed identities are used to connect the Foundry Agent Service to the Foundry project, which in turn accesses an Azure OpenAI model. The diagram uses numbered green circles to indicate the logical flow, showing how user requests traverse the network, interact with various endpoints, and ultimately connect to Azure AI services and storage, with dependencies clearly grouped and labeled.
  :::image-end:::

### Automated machine learning

*Automated machine learning (AutoML)* is the process of automating the time-consuming, iterative tasks of machine learning model development. Data scientists, analysts, and developers can use AutoML to build machine learning models that have high scale, efficiency, and productivity while sustaining model quality.

For more information, see the following resources:

- [What is AutoML?](/azure/machine-learning/concept-automated-ml)
- [Tutorial: Train a classification model with AutoML in Machine Learning studio](/azure/machine-learning/tutorial-first-experiment-automated-ml)
- [Configure AutoML experiments in Python](/azure/machine-learning/how-to-configure-auto-train)
- [Use the CLI extension for Machine Learning](/azure/machine-learning/reference-azure-machine-learning-cli)

### MLflow

Machine Learning workspaces are MLflow-compatible, which means that you can use a Machine Learning workspace the same way that you use an MLflow server. This compatibility provides the following advantages:

- Machine Learning doesn't host MLflow server instances but can use the MLflow APIs directly.
- You can use a Machine Learning workspace as your tracking server for any MLflow code, whether or not it runs in Machine Learning. You need to configure MLflow to point to the workspace where the tracking should occur.
- You can run training routines that use MLflow in Machine Learning without making any changes.

For more information, see [MLflow and Machine Learning](/azure/machine-learning/concept-mlflow) and [MLflow](https://www.mlflow.org/).

### Generative AI tools

- [Microsoft Foundry](https://azure.microsoft.com/products/ai-foundry) helps you experiment, develop, and deploy generative AI apps and APIs responsibly with a comprehensive platform. The [Microsoft Foundry portal](https://ai.azure.com?cid=learnDocs) provides access to Azure AI services, foundation models, a playground, and resources to help you fine-tune, evaluate, and deploy AI models and AI agents.

  [Foundry Agent Service](/azure/ai-foundry/agents/overview) hosts no-code agents that you define, connected to a foundation model in the AI model catalog and optionally your own custom knowledge stores or APIs. This capability is hosted within Foundry.

- [Copilot Studio](/microsoft-copilot-studio/) extends Copilot in Microsoft 365. You can use Copilot Studio to build custom copilots for internal and external scenarios. Use a comprehensive authoring canvas to design, test, and publish copilots. You can easily create generative AI-enabled conversations, provide greater control of responses for existing copilots, and accelerate productivity by using automated workflows.

## Data platforms for AI

The following platforms offer comprehensive solutions for data movement, processing, ingestion, transformation, real-time analytics, and reporting.

### Microsoft Fabric

Microsoft Fabric is an end-to-end analytics and data platform for enterprises that require a unified solution. You can grant workload teams access to data within Fabric. The platform covers data movement, processing, ingestion, transformation, real-time event routing, and report building. It offers a comprehensive suite of services, including Fabric Data Engineer, Fabric Data Factory, Fabric Data Science, Fabric Real-Time Intelligence, Fabric Data Warehouse, and Fabric Databases.

Fabric integrates separate components into a cohesive stack. Instead of relying on different databases or data warehouses, you can centralize data storage with OneLake. AI capabilities are embedded within Fabric, which eliminates the need for manual integration.

For more information, see the following resources:

- [What is Fabric?](/fabric/get-started/microsoft-fabric-overview)
- [Learning path: Get started with Fabric](/training/paths/get-started-fabric/)
- [AI services in Fabric](/fabric/data-science/ai-services/ai-services-overview)
- [Use Azure OpenAI in Fabric with REST API](/fabric/data-science/ai-services/how-to-use-openai-via-rest-api)
- [Use Fabric for generative AI: A guide to building and improving RAG systems](https://blog.fabric.microsoft.com/blog/using-microsoft-fabric-for-generative-ai-a-guide-to-building-and-improving-rag-systems)
- [Build custom AI applications with Fabric: Implement RAG for enhanced language models](https://blog.fabric.microsoft.com/blog/building-custom-ai-applications-with-microsoft-fabric-implementing-retrieval-augmented-generation-for-enhanced-language-models)

#### Copilots in Fabric

You can use Copilot and other generative AI features to transform and analyze data, generate insights, and create visualizations and reports in Fabric and Power BI. You can build your own copilot or choose one of the following prebuilt copilots:

- [Copilot in Fabric](/fabric/get-started/copilot-fabric-overview)
- [Copilot for Data Science and Data Engineer](/fabric/get-started/copilot-notebooks-overview)
- [Copilot for Data Factory](/fabric/get-started/copilot-fabric-data-factory)
- [Copilot for Data Warehouse](/fabric/data-warehouse/copilot)
- [Copilot for Power BI](/power-bi/create-reports/copilot-introduction)
- [Copilot for Real-Time Intelligence](/fabric/real-time-intelligence/copilot-writing-queries)

#### AI skills in Fabric

You can use the Fabric AI skill feature to configure a generative AI system to generate queries that answer questions about your data. After you configure an AI skill, you can share it with your colleagues, who can then ask their questions in simple language. Based on their questions, the AI generates queries on the data that answers those questions.

For more information, see the following resources:

- [What is the AI skill feature in Fabric?](/fabric/data-science/concept-ai-skill)
- [How to create an AI skill](/fabric/data-science/how-to-create-ai-skill)
- [AI skill example](/fabric/data-science/ai-skill-scenario)
- [Difference between an AI skill and a copilot](/fabric/data-science/concept-ai-skill#difference-between-an-ai-skill-and-a-copilot)

### Apache Spark-based data platforms for AI

Apache Spark is a parallel processing framework that supports in-memory processing to boost the performance of big data analytic applications. Spark provides basic building blocks for in-memory cluster computing. A Spark job can load and cache data into memory and query it repeatedly, which is faster than disk-based applications, such as Hadoop.

#### Apache Spark in Microsoft Fabric

Fabric Runtime is an Azure-integrated platform based on Apache Spark that enables the implementation and management of data engineering and data science experiences. Fabric Runtime combines key components from internal and open-source sources, which provides a comprehensive solution.

Fabric Runtime has the following key components:

- **Apache Spark** is a powerful open-source distributed computing library that enables large-scale data processing and analytics tasks. Apache Spark provides a versatile and high-performance platform for data engineering and data science experiences.

- **Delta Lake** is an open-source storage layer that integrates atomicity, consistency, isolation, and durability (ACID) transactions and other data reliability features with Apache Spark. Integrated within Fabric Runtime, Delta Lake enhances data processing capabilities and helps ensure data consistency across multiple concurrent operations.

- **Default-level packages for Java, Scala, Python, and R** are packages that support diverse programming languages and environments. These packages are automatically installed and configured, so developers can apply their preferred programming languages for data processing tasks.

Fabric Runtime is built on a robust open-source operating system to help ensure compatibility with various hardware configurations and system requirements.

For more information, see [Apache Spark runtimes in Fabric](/fabric/data-engineering/runtime).

#### Azure Databricks Runtime for Machine Learning

[Azure Databricks](https://azure.microsoft.com/services/databricks/) is an Apache Spark–based analytics platform that has one-click setup, streamlined workflows, and an interactive workspace for collaboration between data scientists, engineers, and business analysts.

You can use [Databricks Runtime for Machine Learning](/azure/databricks/machine-learning/databricks-runtime-ml) to start a Databricks cluster with all the libraries required for distributed training. This feature provides an environment for machine learning and data science. It contains multiple popular libraries, including TensorFlow, PyTorch, Keras, and XGBoost. It also supports distributed training via Horovod.

For more information, see the following resources:

- [Azure Databricks documentation](/azure/azure-databricks/)
- [Machine learning capabilities in Azure Databricks](/azure/databricks/applications/machine-learning/)
- [Deep learning overview for Azure Databricks](/azure/databricks/applications/deep-learning/)

#### Apache Spark in Azure HDInsight

[Apache Spark in Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview) is the Microsoft implementation of Apache Spark in the cloud. Spark clusters in HDInsight are compatible with Azure Storage and Azure Data Lake Storage, so you can use HDInsight Spark clusters to process data that you store in Azure.

[SynapseML](https://github.com/microsoft/SynapseML), formerly known as MMLSpark, is the Microsoft machine learning library for Apache Spark. This open-source library adds many deep learning and data science tools, networking capabilities, and production-grade performance to the Spark ecosystem.

For more information, see the following resources:

- [SynapseML features and capabilities](../ai-ml/guide/data-science-and-machine-learning.md#synapseml)
- [HDInsight overview](/azure/hdinsight/hdinsight-overview)
- [Tutorial: Build an Apache Spark machine learning application in HDInsight](/azure/hdinsight/spark/apache-spark-ipython-notebook-machine-learning)
- [Apache Spark best practices on HDInsight](/azure/hdinsight/spark/spark-best-practices)
- [Configure HDInsight Apache Spark cluster settings](/azure/hdinsight/spark/apache-spark-settings)
- [Create an Apache Spark machine learning pipeline on HDInsight](/azure/hdinsight/spark/apache-spark-creating-ml-pipelines)

## Data storage for AI

You can use the following platforms to efficiently store, access, and analyze large volumes of data.

### Fabric OneLake

OneLake in Fabric is a unified and logical data lake that you can tailor to your entire organization. It serves as the central hub for all analytics data and is included with every Fabric tenant. OneLake in Fabric is built on the foundation of Data Lake Storage.

OneLake in Fabric:

- Supports structured and unstructured file types.
- Stores all tabular data in Delta-Parquet format.
- Provides a single data lake within tenant boundaries that's governed by default.
- Supports the creation of workspaces within a tenant so that your organization can distribute ownership and access policies.
- Supports the creation of various data items, such as lakehouses and warehouses, from which you can access data.

For more information, see [OneLake, the OneDrive for data](/fabric/onelake/onelake-overview).

### Data Lake Storage

Data Lake Storage is a single, centralized repository where you can store your structured and unstructured data. Use a data lake to quickly and easily store, access, and analyze a wide variety of data in a single location. You don't need to conform your data to fit an existing structure. Instead, you can store your data in its raw or native format, usually as files or as binary large objects, or blobs.

Data Lake Storage provides file system semantics, file-level security, and scale. Because these capabilities are built on Azure Blob Storage, you also get low-cost, tiered storage that has high availability and disaster recovery capabilities.

Data Lake Storage uses the infrastructure of Azure Storage to create a foundation for building enterprise data lakes on Azure. Data Lake Storage can service multiple petabytes of information while sustaining hundreds of gigabits of throughput so that you can manage massive amounts of data.

For more information, see the following resources:

- [Introduction to Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Tutorial: Data Lake Storage, Azure Databricks, and Spark](/azure/storage/blobs/data-lake-storage-use-databricks-spark)

## Data processing for AI

You can use the following tools to prepare data for machine learning and AI applications. Ensure that your data is clean and structured so that you can use it for advanced analytics.

### Fabric Data Factory

You can use Fabric Data Factory to ingest, prepare, and transform data from multiple data sources, such as databases, data warehouses, lakehouses, and real-time data streams. This service can help you meet your data operations requirements when you design workloads.

Fabric Data Factory supports code solutions and no-code or low-code solutions:

- Use [data pipelines](/fabric/data-factory/pipeline-overview) to create workflow capabilities at cloud scale. Use the drag-and-drop interface to build workflows that can refresh your dataflow, move petabyte-size data, and define control-flow pipelines.

- Use [dataflows](/fabric/data-factory/dataflows-gen2-overview) as a low-code interface to ingest data from hundreds of data sources and transform it by using over 300 data transformations.

For more information, see [Data Factory end-to-end scenario: Introduction and architecture](/fabric/data-factory/tutorial-end-to-end-introduction).

### Azure Databricks

You can use the Databricks Data Intelligence Platform to write code to create a machine learning workflow by using feature engineering. *Feature engineering* is the process of transforming raw data into features that you can use to train machine learning models. Databricks Data Intelligence Platform includes key features that support feature engineering:

- **Data pipelines** ingest raw data, create feature tables, train models, and perform batch inference. When you use feature engineering in Unity Catalog to train and log a model, the model is packaged with feature metadata. When you use the model for batch scoring or online inference, it automatically retrieves feature values. The caller doesn't need to know about the values or include logic to look up or join features to score new data.

- **Model and feature serving endpoints** are instantly accessible and provide milliseconds of latency.
- **Monitoring** helps ensure the performance and accuracy of data and models.

You can also use [Mosaic AI Vector Search](/azure/databricks/generative-ai/vector-search) to store and retrieve embeddings. Embeddings are crucial for applications that require similarity searches, such as RAG, recommendation systems, and image recognition.

For more information, see [Azure Databricks: Serve data for machine learning and AI](/azure/databricks/machine-learning/serve-data-ai).

## Data connectors for AI

Azure Data Factory and Azure Synapse Analytics pipelines support many data stores and formats via copy, data flow, look up, get metadata, and delete activities. To see the available data store connectors, supported capabilities including the corresponding configurations, and generic Open Database Connectivity options, see [Azure Data Factory and Azure Synapse Analytics connector overview](/azure/data-factory/connector-overview).

## Custom AI

Custom AI solutions help you address specific business needs and challenges. The following sections provide an overview of various tools and services that you can use to build and manage custom AI models. 

### Azure Machine Learning

Azure Machine Learning is a cloud service for accelerating and managing the machine learning project lifecycle. Machine learning professionals, data scientists, and engineers can use this service in their day-to-day workflows to train and deploy models and manage machine learning operations.

Machine Learning offers the following capabilities:

- **Algorithm selection:** Some algorithms make specific assumptions about data structure or desired results. Choose an algorithm that fits your needs so that you can get more useful results, more accurate predictions, and faster training times. For more information, see [How to select algorithms for Machine Learning](/azure/machine-learning/how-to-select-algorithms).

- **Hyperparameter tuning or optimization:** You can use this manual process to find hyperparameter configurations that result in the best performance. This optimization incurs significant computational costs. *Hyperparameters* are adjustable parameters that provide control in the model training process. For example, you can choose the number of hidden layers and the number of nodes in each layer of neural networks. Model performance depends heavily on hyperparameters.

  You can use Machine Learning to automate hyperparameter tuning and run experiments in parallel to efficiently optimize hyperparameters.

  For more information, see the following resources:

  - [Hyperparameter tuning a model with Machine Learning](/azure/machine-learning/how-to-tune-hyperparameters)
  - [Upgrade hyperparameter tuning to SDK v2](/azure/machine-learning/migrate-to-v2-execution-hyperdrive)
  - [Learning path: Perform hyperparameter tuning with Machine Learning](/training/modules/perform-hyperparameter-tuning-azure-machine-learning-pipelines/)

- **Model training:** You can iteratively use an algorithm to create or *teach* models. After models are trained, you can use them to analyze data and make predictions.

  During the training phase:
  1. A quality set of known data is tagged so that individual fields are identifiable.

  1. An algorithm that's configured to make a particular prediction receives the tagged data.
  1. The algorithm outputs a model that captures the patterns that it identified in the data. The model uses a set of parameters to represent these patterns.
  
  During validation:
    1. Fresh data is tagged and used to test the model.

    1. The algorithm is adjusted as needed and possibly does more training.
    1. The testing phase uses real-world data without any tags or preselected targets. If the model's results are accurate, it's ready for use and can be deployed.

  For more information, see the following resources:

  - [Train models with Machine Learning](/azure/machine-learning/concept-train-machine-learning-model)
  - [Tutorial: Train a model in Machine Learning](/azure/machine-learning/tutorial-train-model)
  - [Deep learning and distributed training with Machine Learning](/azure/machine-learning/concept-distributed-training)

- **AutoML:** This process automates the time-consuming, iterative tasks of machine learning model development. It can significantly reduce the time that it takes to produce production-ready machine learning models. AutoML can assist with model selection, hyperparameter tuning, model training, and other tasks, without requiring extensive programming or domain knowledge.

  You can use AutoML when you want Machine Learning to use a specified target metric to train and tune a model. You don't need data science expertise to identify an end-to-end machine learning pipeline for problems.

  Machine learning professionals and developers across industries can use AutoML to:

  - Implement machine learning solutions without extensive programming or machine learning knowledge.
  - Save time and resources.
  - Apply data science best practices.
  - Provide agile problem-solving.

  For more information, see [What is AutoML?](/azure/machine-learning/concept-automated-ml).

- **Scoring:** This process, also called *prediction*, uses a trained machine learning model to generate values based on new input data. The values, or scores, can represent predictions of future values, but they might also represent a likely category or outcome.

  For more information, see the following resources:

  - [Score model](/azure/machine-learning/component-reference/score-model)
  - [Deploy models for scoring in batch endpoints](/azure/machine-learning/how-to-use-batch-model-deployments)

- **Feature engineering and featurization:** Training data consists of rows and columns. Each row is an observation or record, and the columns of each row are the features that describe each record. Typically, the features that best characterize the patterns in the data are selected to create predictive models.

Although you can use many of the raw data fields to train a model, you might need to create other engineered features that provide information to better differentiate patterns in the data. This process is called feature engineering, where you use domain knowledge of the data to create features that help machine learning algorithms learn better.

In Machine Learning, data-scaling and normalization techniques are applied to make feature engineering easier. Collectively, these techniques and feature engineering are called *featurization* in AutoML experiments. For more information, see [Data featurization in automated machine learning](/azure/machine-learning/concept-automated-ml?view=azureml-api-2#feature-engineering).

### Microsoft Foundry

In Microsoft Foundry, you can use a process known as *fine-tuning* to tailor models to your personal datasets. This customization step optimizes the service by providing:

- Higher quality results compared to [prompt engineering](/azure/ai-services/openai/concepts/prompt-engineering) only.
- The ability to train on more examples than a model's maximum request context limit typically permits.
- Token savings because of shorter prompts.
- Lower-latency requests, particularly when you use smaller models.

For more information, see the following resources:

- [Customize a model with fine-tuning](/azure/ai-services/openai/how-to/fine-tuning)
- [Tutorial: Azure OpenAI GPT-4o-mini fine-tuning](/azure/ai-services/openai/tutorials/fine-tune)
- [Baseline Microsoft Foundry chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-azure-ai-foundry-chat)

### Foundry toold for custom AI

[Foundry tools](https://azure.microsoft.com/en-us/products/ai-foundry/tools) provides features to build custom AI models and applications. The following sections provide an overview of these key features.

#### Custom speech

[Custom speech](/azure/ai-services/speech-service/custom-speech-overview) is a feature of the Azure AI Speech service. You can use custom speech to evaluate and improve the accuracy of speech recognition for your applications and products. Use a custom speech model for real-time speech to text, speech translation, and batch transcription.

By default, speech recognition uses a universal language model as a base model. This model is trained with Microsoft-owned data and reflects commonly used spoken language. The base model is pretrained with dialects and phonetics that represent various common domains. When you make a speech recognition request, the most recent base model for your supported language is used by default. The base model works well in most speech recognition scenarios.

You can use a custom model to augment the base model. For example, you can improve the recognition of domain-specific vocabulary that's specific to an application by providing text data to train the model. You can also improve recognition for specific audio conditions of an application by providing audio data, including reference transcriptions.

If the data follows a pattern, you can use structured text to train a model. You can specify custom pronunciations and customize display text formatting with custom inverse text normalization, custom rewrite, and custom profanity filtering.

#### Custom translator

[Custom translator](/azure/ai-services/translator/custom-translator/overview) is a feature of the [Azure AI Translator](/azure/ai-services/translator/translator-overview) service. Enterprises, app developers, and language service providers can use custom translator to build customized neural machine translation (NMT) systems. The customized translation systems integrate into existing applications, workflows, and websites.

You can use this feature to build and publish custom translation systems to and from English. Custom translator supports more than three dozen languages that map directly to the languages for NMT. For a complete list of languages, see [Translator language support](/azure/ai-services/translator/language-support).

Custom translator offers the following features.

|Feature  |Description  |
|---------|---------|
|[Apply NMT technology](https://www.microsoft.com/translator/blog/2016/11/15/microsoft-translator-launching-neural-network-based-translations-for-all-its-speech-languages/)     |  Apply NMT from the custom translator to improve your translation.       |
|[Build systems that know your business terminology](/azure/ai-services/translator/custom-translator/beginners-guide)     |  Customize and build translation systems by using parallel documents that understand the terminology in your business and industry.       |
|[Use a dictionary to build your models](/azure/ai-services/translator/custom-translator/how-to/train-custom-model#when-to-select-dictionary-only-training)     |   Train a model with only dictionary data if you don't have a training dataset.       |
|[Collaborate with others](/azure/ai-services/translator/custom-translator/how-to/create-manage-workspace#manage-workspace-settings)     |   Collaborate with your team by sharing your work with various people.     |
|[Access your custom translation model](/azure/ai-services/translator/custom-translator/how-to/translate-with-custom-model)     |  Access your custom translation model anytime by using your existing applications or programs via Microsoft Translator Text API V3.       |

#### Azure Document Intelligence custom models

[Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) uses advanced machine learning technology to identify documents, detect and extract information from forms and documents, and return the extracted data in a structured JSON output. Use Document Intelligence to take advantage of prebuilt or pretrained document analysis models or trained standalone custom models.

[Document Intelligence custom models](/azure/ai-services/document-intelligence/train/custom-model) include custom classification models for scenarios where you need to identify the document type before you invoke the extraction model. You can pair a classification model with a custom extraction model to analyze and extract fields from forms and documents that are specific to your business. Combine standalone custom extraction models to create [composed models](/azure/ai-services/document-intelligence/train/composed-models).

### Custom AI tools

Prebuilt AI models are useful and increasingly flexible, but the best way to optimize AI is to tailor a model to your specific needs. Two primary tools to create custom AI models are generative AI and traditional machine learning.

#### Azure Machine Learning studio

[Azure Machine Learning studio](https://ml.azure.com/home) is a cloud service for accelerating and managing the machine learning project lifecycle. Machine learning professionals, data scientists, and engineers can use it in their day-to-day workflows to train and deploy models and manage machine learning operations.

- Build and train Machine Learning models by using any type of compute, including Spark and GPUs for cloud-scale large AI workloads.

- Run AutoML and use the drag-and-drop UI for low-code Machine Learning.
- Implement end-to-end Machine Learning operations and repeatable pipelines.
- Use the responsible AI dashboard for bias detection and error analysis.
- Orchestrate and manage prompt engineering and LLM flows.
- Deploy models via REST API endpoints, real-time inference, and batch inference.
- Use hub workspaces to share compute, quota, security, and connectivity to company resources, while centralizing governance for IT. Set up a hub once, then create secure workspaces directly from the studio for each project. Use hubs to manage your team's work in the studio and the [Microsoft Foundry portal](https://ai.azure.com?cid=learnDocs).

#### Microsoft Foundry

[Microsoft Foundry](/azure/ai-foundry/what-is-ai-foundry) helps you efficiently build and deploy custom generative AI applications with the power of broad Azure AI offerings.

- Build together as one team. Your Foundry account provides enterprise-grade security and a collaborative environment that includes shared resources and connections to pretrained models, data, and compute.

- Organize your work. Your Foundry project helps you save state so that you can iterate from the first idea to the first prototype and first production deployment. Easily invite others to collaborate with you.
- Use your preferred development platform and frameworks, including GitHub, Visual Studio Code, Microsoft Agent Framework, Semantic Kernel, and AutoGen.
- Discover and benchmark from over 1,600 models.
- Provision models as a service (MaaS) through serverless APIs and hosted fine-tuning.
- Incorporate multiple models, data sources, and modalities.
- Build RAG by using your protected enterprise data, without the need for fine-tuning.
- Orchestrate and manage prompt engineering and LLM flows.
- Design and safeguard apps and APIs via configurable filters and controls.
- Evaluate model responses by using built-in and custom evaluation flows.
- Deploy AI innovations to the Azure-managed infrastructure to provide continuous monitoring and governance across environments.
- Continuously monitor deployed apps for safety, quality, and token consumption in production.

For more information, see [Foundry portal versus Machine Learning studio](/ai/ai-studio-experiences-overview).

#### Azure AI Agent Service in the Foundry portal

Azure AI Agent Service is a tool that use to create AI agents using a no-code and nondeterminsitic approach. The agents are exposed as microservices on the Foundry account.

Each agent connects to a foundation model from the Azure AI model catalog. Agents can optionally connect to your own custom private knowledge stores or public data. Likewise, agents can invoke tools to perform tasks to call into custom code.

### Custom AI code languages

The core concept of AI is the use of algorithms to analyze data and generate models to describe, or score, it in useful ways. Developers and data scientists, and sometimes other algorithms, use programming code to write algorithms. Two of the most popular programming languages for AI development are Python and R.

[Python](https://www.python.org/) is a general-purpose, high-level programming language. It has a simple, easy-to-learn syntax that emphasizes readability. There's no compiling step. Python has a large standard library, and it supports the ability to add modules and packages. This feature encourages modularity and lets you expand capabilities when needed. There's a large and growing ecosystem of AI and machine learning libraries for Python, including many in Azure.

For more information, see the following resources:

- [Python on Azure product home page](https://azure.microsoft.com/develop/python/)
- [Azure for Python developers](/azure/python/)
- [Machine Learning SDK for Python](/python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true)
- [Introduction to machine learning with Python and notebooks](/training/paths/intro-to-ml-with-python/)
- [scikit-learn open-source machine learning library for Python](https://scikit-learn.org/stable/)
- [PyTorch open-source Python library](https://pytorch.org/)
- [TensorFlow open-source symbolic math library](https://www.tensorflow.org/)
- [Tutorial: Apply machine learning models in Azure Functions with Python and TensorFlow](/azure/azure-functions/functions-machine-learning-tensorflow)

[R](https://www.r-project.org/) is a language and environment for statistical computing and graphics. You can use it for everything from mapping broad social and marketing trends online to developing financial and climate models.

Microsoft fully embraces the R programming language and provides many options for R developers to run their code in Azure.

For more information, see [Use R interactively on Machine Learning](/azure/machine-learning/how-to-r-interactive-development).

For general information about custom AI on Azure, see the following resources:

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)
- [Machine Learning SDK for Python](/python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true)
- [Machine Learning examples repository](https://github.com/Azure/azureml-examples)
- [Train R models by using the Machine Learning CLI v2](https://github.com/Azure/azureml-examples/tree/main/cli/jobs/single-step/r)

## Customer stories

Many industries apply AI in innovative and inspiring ways. Consider the following customer case studies and success stories:

- [NSF enables life-saving treatments to get to patients faster with Azure AI](https://www.microsoft.com/en/customers/story/25862-nsf-international-azure-openai)
- [PIMCO boosts client service with an AI-powered search platform built on Azure AI](https://www.microsoft.com/en/customers/story/19744-pimco-sharepoint)
- [Legrand and Azure OpenAI: Powering smarter solutions with AI-driven tools](https://www.microsoft.com/en/customers/story/19697-legrand-azure-cloud-services)
- [C.H. Robinson overcomes decades-old barriers to automate the logistics industry by using Azure AI](https://www.microsoft.com/en/customers/story/19575-ch-robinson-azure-ai-studio)

[Browse more AI customer stories](https://customers.microsoft.com/search?sq=AI&ff=&p=0&so=story_publish_date%20desc)

## General information about Microsoft AI

Learn more about Microsoft AI, and stay up to date with related news:

- [Microsoft AI](https://www.microsoft.com/ai/)
- [AI learning hub](/ai/)
- [Azure AI](https://azure.microsoft.com/solutions/ai/)
- [Microsoft AI news](https://news.microsoft.com/source/topics/ai/)
- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)

## Next step

- [AI workloads on Azure](/azure/well-architected/ai/get-started)

## Related resource

- [Architecture diagrams and technology descriptions for AI solutions reference architectures](/azure/architecture/browse/index?azure_categories=ai-machine-learning)
