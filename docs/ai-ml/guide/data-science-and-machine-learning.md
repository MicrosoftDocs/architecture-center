---
title: AI and Machine Learning Products
description: Compare Microsoft AI and machine learning products for building, deploying, and managing AI applications, agents, and machine learning models.
author: msetbar
ms.author: pnp
ms.date: 07/30/2026
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml

# customer intent: As an AI professional, I want to become familiar with Microsoft AI and machine learning products so that I can build, deploy, and manage AI applications, agents, and machine learning models.
---

# Microsoft AI and machine learning products

Microsoft offers several platforms for AI and machine learning. Each platform targets a different combination of the audience, workload, data foundation, and deployment model. This article helps solution architects, machine learning engineers, data scientists, and application developers choose a starting platform, understand how the platforms differ, and learn how to combine them in real-world architectures. Coverage includes classical machine learning, analytics-integrated machine learning, and generative AI workloads across Azure, Microsoft Fabric, and Microsoft Foundry. This article focuses on Microsoft-provided solutions.

Use this article to compare options and design an end-to-end solution.

> [!NOTE]
> This article focuses on custom AI and machine learning platforms, not packaged software as a service (SaaS) assistants, low-code SaaS authoring tools, or in-product end-user experiences.

## Primary workload scenarios

Start with the AI or machine learning feature that you need to add to your workload. The following table maps common feature scenarios to a recommended starting platform for custom AI and machine learning capabilities. Use it as an initial orientation before you review platform capabilities and walk through the decision tree.

| Primary scenario | Recommended starting point | Rationale |
|---|---|---|
| Build generative AI applications or AI agents | [Microsoft Foundry](/azure/foundry/) | Provides model discovery, fine-tuning, retrieval-augmented generation (RAG), agent orchestration, evaluation, and safety tooling in one platform. |
| Add AI features through a prebuilt API for vision, speech, language, search, or content safety | [Foundry Tools](/azure/ai-services/what-are-ai-services) | Offers pretrained APIs that require no custom training. Use them before building a custom model. |
| Train, deploy, and manage a custom machine-learning or deep learning model | [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) | Covers the full machine learning lifecycle, including MLOps, online and batch endpoints, and responsible AI tooling. |
| Run analytics-integrated machine learning on a unified data and business intelligence (BI) platform | [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) | Provides a SaaS analytics platform that supports Apache Spark notebooks, AutoML, and Microsoft OneLake&#8211;backed integration with Power BI. |
| Run machine learning on Spark, lakehouse data, or large distributed training jobs | [Azure Databricks](/azure/databricks/introduction/) or [Apache Spark in Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview) | Azure Databricks: Supports lakehouse-scale Spark with native MLflow and Unity Catalog integration.<br><br>Azure HDInsight: Supports Azure-managed Spark clusters with native storage and security integration. |
| Keep machine learning inside a SQL database, on edge devices, or in desktop applications | [SQL intelligent applications and AI](/sql/sql-server/ai/artificial-intelligence-intelligent-applications), [Azure SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview), [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services), or [local machine learning tools](#edge-local-and-on-premises-machine-learning) | Provides a way to keep data in place and add in-database prediction, vector retrieval, or AI endpoint integration. |

### Compare platform capabilities

The following matrix summarizes where each platform is the primary fit, where it offers complementary support, and where the capability isn't a focus. The matrix uses these icons:

- ✅ Primary capability
- ⚠️ Supported or complementary capability
- ❌ Not a focus

| Capability | Microsoft Foundry | Azure Machine Learning | Microsoft Fabric | Azure Databricks | Foundry Tools | SQL machine learning | Edge or local machine learning |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Generative AI and agents | ✅ | ⚠️ (Not primary platform) | ❌ | ⚠️ (Lakehouse-scoped) | ⚠️ (Building blocks only) | ❌ | ⚠️ (On-device only) |
| Foundation model discovery and evaluation | ✅ | ⚠️ (Not primary platform) | ❌ | ⚠️ (Lakehouse-scoped) | ❌ | ❌ | ❌ |
| Custom model training (classical or deep learning) | ⚠️ (Fine-tuning only) | ✅ | ⚠️ (Analytics-scoped) | ✅ | ❌ | ⚠️ (Database-scoped) | ⚠️ (Local only) |
| Large-scale or distributed training compute | ❌ | ✅ | ⚠️ (Smaller scale) | ✅ | ❌ | ❌ | ❌ |
| AutoML | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ | ⚠️ (.NET only) |
| MLOps lifecycle (registry, pipelines, continuous integration and continuous delivery (CI/CD)) | ⚠️ (Via Azure Machine Learning) | ✅ | ⚠️ (Via Azure Machine Learning) | ✅ | ❌ | ❌ | ❌ |
| Real-time (online) inference | ✅ | ✅ | ⚠️ (Model endpoints in preview) | ✅ | ✅ | ⚠️ (In-database only) | ✅ |
| Batch (offline) inference | ⚠️ (Online-first) | ✅ | ✅ | ✅ | ❌ | ✅ | ⚠️ (Local only) |
| On-premises or offline deployment | ⚠️ (Edge subset only) | ⚠️ (Via Azure Arc) | ❌ | ❌ | ⚠️ (Containers only) | ✅ | ✅ |
| Governance and security tooling | ✅ | ✅ | ⚠️ (Limited model governance) | ✅ | ⚠️ (Service-scoped) | ⚠️ (Database-scoped) | ❌ |

The following notes clarify specific ratings in the matrix:

- Foundry Tools is rated as complementary for generative AI and agents because services like Azure AI Search, Content Safety in Foundry Control Plane, and Azure Document Intelligence in Foundry Tools are common building blocks for RAG and agent solutions. The primary platform for generative AI development is Microsoft Foundry.

- Microsoft Foundry governance comes primarily from Foundry Control Plane, which provides observability, runtime controls, security integration, and fleet management for agents and applications.

- Azure Machine Learning supports generative AI through access to Foundry Models, managed endpoints, evaluation capabilities, and fine-tuning for supported foundation models. It isn't the primary platform for generative AI development.

- Azure Databricks earns a primary rating for governance because Unity Catalog provides unified data and model governance with role-based access control (RBAC) and OpenSharing.

- Microsoft Fabric is rated as complementary for governance because OneLake, Microsoft Purview integration, sensitivity labels, and domain-based controls cover data assets well. Microsoft Fabric includes a built-in MLflow-based model registry for storing and tracking models. Microsoft Fabric also has a built-in lineage view for machine learning models and experiments, including relationships to lakehouses and code items. But Microsoft Fabric doesn't include a responsible AI dashboard. For broader model lifecycle governance, pair Microsoft Fabric with Azure Machine Learning.

- Microsoft Fabric is rated as complementary for real-time inference because Microsoft Fabric Real-Time Intelligence covers streaming analytics, and [Microsoft Fabric machine learning model endpoints](/fabric/data-science/model-endpoints) provide managed online REST endpoints for real-time predictions. Model endpoints are in preview and support a limited set of model flavors. For broad production online serving, you can also pair Microsoft Fabric with Azure Machine Learning managed online endpoints or Microsoft Foundry.

- Foundry Local extends Microsoft Foundry to on-device inference for edge and offline scenarios.

- Azure Arc extends Azure Machine Learning to on-premises Kubernetes clusters for hybrid training or scoring.

- Microsoft Fabric Data Science includes a low-code AutoML experience. Code-first AutoML is available through Fast and Lightweight AutoML (FLAML) APIs in Microsoft Fabric notebooks. For the current status, check the [Microsoft Fabric documentation](/fabric/fundamentals).

## Narrow your platform choice

Use the following decision tree to narrow your choice of starting platform. The tree helps you select a *primary* platform for a workload. Most production solutions combine more than one platform, so use the product-specific sections in this article to refine your choice. Also consider using a compound architecture pattern. For more information, see [Combine platforms](#combine-platforms).

:::image type="complex" source="_images/data-science-decision-tree.svg" border="false" alt-text="Decision tree for a primary Microsoft AI or machine learning platform based on the scenario, developer profile, and training and inference locations." lightbox="_images/data-science-decision-tree.svg":::
    At the top, "What's your primary scenario?" branches into four paths. The first scenario, Generative AI or agents, asks for the developer profile and then routes to Azure OpenAI for an LLM API, Microsoft Agent Framework with Foundry Agent Service for code-first agents, or Microsoft Foundry for the full platform. The second scenario, Prebuilt features, routes to Foundry Tools. The third scenario, Custom machine learning, asks where training and inference run. Edge or Windows routes to Windows ML, ML.NET, Foundry Local, Azure IoT Edge, Azure Local, or Azure Stack Edge; inside a SQL database routes to SQL intelligent applications and AI, SQL Server Machine Learning Services, and Azure SQL Managed Instance Machine Learning Services; Kubernetes routes to Azure Machine Learning on Azure Arc; and cloud compute routes to Azure Machine Learning. Distributed compute branches to Azure Databricks for a lakehouse or Azure HDInsight for managed Spark. The fourth scenario, Analytics-integrated machine learning, routes by data foundation to Microsoft Fabric, Azure Synapse Analytics, or Azure Databricks.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/data-science-decision-tree.vsdx) of this decision tree.*

### Step-by-step walkthrough

Use the following steps to walk through the decision tree. When you reach a platform choice, skip the remaining steps.

1. Identify the feature scenario.

   Make platform choices at the feature level within your workload. Each feature can have unique functional and nonfunctional requirements that one or more technologies can serve. When you use this flowchart, consider the requirements of the specific use case that you want to solve.

   - If prebuilt AI features such as vision, speech, language, search, document understanding, or content safety meet your workload's needs, use [Foundry Tools](/azure/ai-services/what-are-ai-services). Many services in Foundry Tools support customization, such as custom text classification in Azure Language or custom models in Azure Document Intelligence. Consider these services before you commit to full custom training or a broader approach like using a language model to simulate a specialized service. For service-specific documentation, see the following articles:
     - [Azure Vision in Foundry Tools](/azure/ai-services/computer-vision/overview)
     - [Azure Speech in Foundry Tools](/azure/ai-services/speech-service/overview)
     - [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview)
     - [Azure AI Search](/azure/search/search-what-is-azure-search)
     - [Azure Document Intelligence in Foundry Tools](/azure/ai-services/document-intelligence/overview)
     - [Azure Content Understanding in Foundry Tools](/azure/ai-services/content-understanding/overview)
     - [Content Safety in Foundry Control Plane](/azure/ai-services/content-safety/overview)
   - If your workload requires generative AI or custom AI agents to add nondeterministic behavior, continue to step 2.
   - If the feature requires custom machine learning or deep learning capabilities, such as classical machine learning, computer vision, forecasting, or fine-tuning your own models, continue to step 3.
   - If you need to integrate machine learning into a broader data and BI workflow, continue to step 4.

1. For generative AI and agents, choose the Microsoft platform that matches your developer profile.

   - **Direct large language model (LLM) API access only**: Use [Azure OpenAI in Microsoft Foundry](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure).

   - **Code-first agent or multi-agent development**: Use the [Microsoft Agent Framework](/agent-framework/) SDK paired with the Foundry Agent Service for hosting and orchestration.

   - **Full generative AI platform** (Foundry Models, fine-tuning, evaluation, safety, observability, and governance): Use [Microsoft Foundry](/azure/foundry/).

1. For custom machine learning and deep learning, base your decision on where training and inference must run.

   - **On a Windows app or device**: Use [Microsoft Foundry on Windows](/windows/ai/) and [Windows ML](/windows/ai/new-windows-ml/overview) for local model inference with hardware acceleration. Use [ML.NET](/dotnet/machine-learning/) when a .NET application needs local classical machine learning, AutoML, or Open Neural Network Exchange (ONNX) model integration.

   - **On an IoT gateway or edge appliance**: Use [Azure IoT Edge](/azure/iot-edge/), [Foundry Local](/azure/foundry-local/get-started), [Azure Local](/azure/azure-local/overview), or [Azure Stack Edge](/azure/databox-online/) for local or hardware-accelerated inference.

   - **Inside a SQL database**: Use [SQL intelligent applications and AI](/sql/sql-server/ai/artificial-intelligence-intelligent-applications) for in-database prediction, vector retrieval, and AI endpoint integration. Use [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services) or [Azure SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview) when you need Python or R execution in the database.

   - **In an on-premises or multicloud Kubernetes cluster**: Attach the cluster to Azure Machine Learning through [Azure Arc](/azure/machine-learning/how-to-attach-kubernetes-anywhere) so that data stays in place while training and inference are orchestrated through Azure.

   - **On Spark-based or distributed compute**: Continue to step 5.

   - **On cloud-managed compute with full MLOps**: Use [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning).

1. For analytics-integrated machine learning, choose the solution that matches your data and BI pattern.

   - **Unified SaaS with Power BI on OneLake**: Use the [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) Data Science workload.

   - **Existing Azure Synapse Analytics investment**: Use [Machine learning in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/what-is-machine-learning). For new investments, prefer Microsoft Fabric.

   - **Lakehouse-scale Spark and machine learning**: Use [Azure Databricks](/azure/databricks/introduction/).

1. For Spark-based or distributed compute, base your decision on whether you use lakehouse or managed Spark clusters.

   - **Lakehouse with MLflow and Unity Catalog governance**: Use [Azure Databricks](/azure/databricks/introduction/). You can still publish models through Azure Machine Learning managed endpoints for serving and governance.

   - **Managed Spark clusters on Azure with native storage and security integration**: Use [Apache Spark in Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview).

> [!NOTE]
> For architectures that span cloud and on-premises environments, attach on-premises or multicloud Kubernetes clusters to an Azure Machine Learning workspace through Azure Arc. This setup keeps data on-premises while orchestrating training and inferencing through Azure. For detailed information, see [Configure Kubernetes cluster for Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere).

## Azure Machine Learning

[Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) is a fully managed cloud service for training, deploying, and managing machine learning models at scale. It supports tens of thousands of open-source Python packages, including TensorFlow, PyTorch, and scikit-learn. It provides tooling for the full machine learning lifecycle, from data preparation through deployment, MLOps, and responsible AI.

Use Azure Machine Learning when you need the following capabilities:

- **Custom training.** You use custom model training for classical machine learning, deep learning, or fine-tuning of open-source LLMs.

- **Production MLOps.** You use a production MLOps lifecycle that includes experiment tracking, model versioning, governed registries, CI/CD pipelines, and production monitoring.

- **Managed endpoints.** You use managed online or batch inferencing endpoints that are hosted in an environment that provides autoscaling, managed identity, and monitoring.

- **Hybrid compute.** You use hybrid training or inferencing on Azure Arc&#8211;enabled Kubernetes clusters.

The following table summarizes the platform capabilities that Azure Machine Learning provides across the machine learning lifecycle.

| Capability | Description |
|---|---|
| Workspaces and data stores | A central resource for organizing experiments, compute, datasets, models, and connections to external data stores. Assets and run history are versioned for reproducibility. |
| Compute clusters and instances | Provisioned CPU and GPU compute for distributed training (compute clusters) and interactive notebook development (compute instances). |
| Serverless compute | On-demand managed compute that Azure Machine Learning creates and scales automatically for training jobs. |
| Automated machine learning | Generation of models, pipelines, hyperparameter tuning, and feature engineering for classification, regression, forecasting, computer vision, and natural language processing. |
| Pipelines and designer | Code-based and drag-and-drop orchestration for data preparation, training, evaluation, and deployment. Integrates with CI/CD tools. |
| Foundry Models access | A platform for discovering, evaluating, fine-tuning, and deploying supported foundation models from Microsoft, OpenAI, Meta, Hugging Face, and other providers through Foundry Models in Azure Machine Learning. |
| MLflow experiment tracking and model management | Tracking of experiments, runs, metrics, parameters, artifacts, and models by using MLflow-compatible APIs with an Azure Machine Learning workspace. |
| Online and batch endpoints | Managed REST endpoints for real-time inference and invokable endpoints for batch scoring, with autoscaling and managed identity support. |
| Responsible AI tools | Fairness, explainability, and error analysis dashboards. |
| Security and hybrid support | Integration with Azure Virtual Network, Azure Key Vault, Azure Container Registry, RBAC, managed identities, and Azure Arc. |

The following table summarizes core adoption details for Azure Machine Learning.

| Aspect | Details |
|---|---|
| Type | Cloud-based machine learning platform. |
| Supported languages | Python and [R](/azure/machine-learning/component-reference/execute-r-script). A command-line interface (CLI) and REST APIs are also supported. |
| Machine learning phases | Data preparation, training, deployment, MLOps, and responsible AI. |
| Key benefits | Code-first SDK and CLI workflows. Studio-based authoring. Central management of scripts, experiments, and run history. Scalable training and deployment. Hybrid options through Azure Arc. |
| Considerations | Some familiarity with the workspace and asset model is helpful before adopting full MLOps. |

Azure Machine Learning isn't the best fit in the following situations:

- You only need to consume pretrained APIs for vision, speech, or language. In this case, use Foundry Tools.

- Machine learning is a small extension of an analytics workload. In this case, Microsoft Fabric or Azure Databricks might be a better starting point.

- Your workload is end-to-end generative AI (model selection, agent orchestration, evaluation, deployment, and monitoring). Also, you don't need classical machine learning training or the Azure Machine Learning asset, run, and MLflow model. In this case, Microsoft Foundry alone can be sufficient. An Azure Machine Learning workspace is required only when you need Azure Machine Learning training compute, MLOps lifecycle, or managed online or batch endpoints for custom models.

## Microsoft Foundry

[Microsoft Foundry](/azure/foundry/) is the unified Azure platform for building, optimizing, and governing generative AI applications and AI agents. Microsoft Foundry combines the Foundry model catalog, agent and orchestration services, evaluation and safety tooling, and a control plane for runtime governance. For code-first agent development, Microsoft Foundry pairs with the [Microsoft Agent Framework](/agent-framework/), the unified Microsoft SDK that supersedes the prior split between Semantic Kernel and AutoGen.

Use Microsoft Foundry when you need the following capabilities:

- **Generative AI or agents.** You build generative AI or agent-based solutions, such as multimodel chatbots or orchestrated LLM workflows.

- **Model discovery and evaluation.** You need to be able to discover, compare, and evaluate foundation models from multiple providers.

- **Model customization and governance.** You want to fine-tune, evaluate, and deploy foundation models in a managed environment that provides built-in observability, content safety, and runtime controls.

The following table summarizes the Microsoft Foundry capabilities that support generative AI applications and agent development.

| Capability | Description |
|---|---|
| Foundry Models | A catalog of pretrained models from providers such as Azure OpenAI, Hugging Face, and Meta, plus the Microsoft Phi small language model family, with benchmarks and deployment options. |
| Model customization | The ability to fine-tune or customize supported foundation models on your own data. Deployment options depend on the model and include standard and provisioned types where available. |
| Foundry Agent Service | A platform for hosting and orchestrating AI agents that automate multistep business processes. Pairs with the Microsoft Agent Framework SDK for code-first agent development. Implements the OpenAI-compatible Responses API for broad client SDK support. |
| Foundry IQ | A managed knowledge layer that grounds agents on enterprise data. Builds multisource knowledge bases and uses agentic retrieval to return permission-aware answers with citations. Built on Azure AI Search. Knowledge sources include indexed sources (such as an existing Azure AI Search index, Azure Blob Storage, directly uploaded files, OneLake, Azure SQL, and indexed SharePoint) and remote sources queried at runtime (such as remote SharePoint, Microsoft Fabric ontology, Work IQ, Microsoft Bing web data, Model Context Protocol (MCP) servers, and Microsoft Fabric data agents). Several of these connectors are currently in preview. For the current preview status and supported connectors, see [agentic knowledge sources in Azure AI Search](/azure/search/agentic-knowledge-source-overview). For data-store options, see [Choose an Azure service for vector search](../../guide/technology-choices/vector-search.md). |
| Foundry Control Plane | An interface that provides observability, runtime controls, security integration, and fleet management across Microsoft Foundry agents and applications. |
| Content Safety | An AI service that detects harmful user-generated and AI-generated content. See [Content Safety](/azure/ai-services/content-safety/overview). |
| Foundry Local | A solution for on-device AI inference for edge and offline scenarios where performance, privacy, or cost is important. |

### Foundry Toolkit for Visual Studio Code

[Foundry Toolkit for Visual Studio Code](https://code.visualstudio.com/docs/intelligentapps/overview) is the primary developer experience for Microsoft Foundry. Use it when you want a local-first workflow for generative AI applications and agents. The toolkit supports model discovery, local model execution, prompt and agent development, tool integration, debugging, tracing, evaluation, fine-tuning, and deployment to Microsoft Foundry from Visual Studio Code.

Start in Foundry Toolkit when the solution needs code, source control, local iteration, agent inspection, MCP tool integration, or model testing before deployment. Use the Foundry portal for proof-of-concept exploration, project setup, resource review, evaluation review, and operational visibility after applications and agents are running.

### Foundry portal and Azure Machine Learning studio

The Foundry portal and Azure Machine Learning studio are complementary web experiences. Use them for prototyping, project and resource management, evaluation review, and operational visibility.

| Category | Foundry portal | Azure Machine Learning studio |
|---|---|---|
| Best-suited workload | Proofs of concept, model exploration, agent review, evaluation review, and operational visibility for generative AI applications and agents. | Custom machine learning, classical machine learning, deep learning, and broader machine learning platform workflows. |
| Data handling | Functionality for connecting project resources and supported data sources, including Blob Storage, OneLake, and Azure Data Lake Storage. | Workspace storage, data assets, and connected Azure storage accounts. |
| Authoring experiences | Portal-based prototyping, playgrounds, model exploration, evaluation review, and project resource management. | Notebooks, designer, AutoML, model management, and SDK and CLI workflows. |
| Supported languages and SDKs | Python, C#, JavaScript, and Java SDKs. REST APIs. | Python, R, and the Azure CLI. REST APIs. |
| Core training strength | Model evaluation and supported fine-tuning. | AutoML and custom training across classical machine learning, deep learning, and LLM fine-tuning. |
| Compute and deployment | Managed compute and serverless APIs for supported foundation models. | Managed compute, serverless compute, online endpoints, batch endpoints, and Azure Arc options. |
| Generative AI surface | A web surface for Foundry Models exploration, evaluation review, observability, and safety tooling. | Foundry Models access, managed endpoints, evaluation, and fine-tuning for supported foundation models inside the Azure Machine Learning platform. |
| Governance | Foundry Control Plane for agent and application governance. | Responsible AI dashboard, lineage, model management, and MLOps controls. |

The following table summarizes core adoption details for Microsoft Foundry.

| Aspect | Details |
|---|---|
| Type | A unified platform for foundation models, agents, and generative AI applications. |
| Supported languages | Python, C#, JavaScript, and Java SDKs. REST APIs. |
| Machine learning phases | Model discovery and evaluation, application and agent development, fine-tuning of supported models, deployment, monitoring, and safety. |
| Key benefits | A consolidated Foundry model catalog. Integrated evaluation, safety, and observability. Agent and RAG support. Project-based collaboration. |

Microsoft Foundry isn't the best fit in the following situations:

- You consume prebuilt AI capabilities such as optical character recognition (OCR), speech-to-text transcription, translation, or content moderation through an API, and you don't require model selection, orchestration, or agents. In this case, use [Foundry Tools](/azure/ai-services/what-are-ai-services).

- Your solution requires custom model training, for classical machine learning or deep learning, and full MLOps capabilities. In this case, use Azure Machine Learning. Microsoft Foundry doesn't offer broad provisioned training compute or AutoML for tabular data.

- Your solution requires Spark-scale data engineering. In this case, use Azure Databricks or Microsoft Fabric.

## Foundry Tools

[Foundry Tools](/azure/ai-services/what-are-ai-services), formerly Azure AI services and Cognitive Services, is a family of pretrained AI capabilities that you consume through REST APIs and SDKs. Each tool targets a specific capability, so you can add intelligent features to applications without building or training a custom model. For help deciding which service to use, see [Choose an AI services technology](../../data-guide/technology-choices/ai-services.md).

> [!TIP]
> Foundry Tools provides pretrained APIs for common probabilistic tasks. For generative AI models, agents, and orchestration, work in Microsoft Foundry instead of using Foundry Tools directly. Many services in Foundry Tools share the same underlying Azure resource type (`Microsoft.CognitiveServices/accounts`) as Microsoft Foundry, but they're distinct products.

Use Foundry Tools in the following situations:

- A pretrained API covers the scenario, so you don't need to train a custom model.

- You need standard, managed APIs and API-based integration with existing applications.

The following table groups commonly used services by capability area. Generative AI models, agents, and orchestration are part of [Microsoft Foundry](/azure/foundry/) and are listed separately for reference.

| Capability area | Representative services |
|---|---|
| Vision | [Azure Vision](/azure/ai-services/computer-vision/) and [Azure Face in Foundry Tools](/azure/ai-services/face/overview-identity). |
| Document and content understanding | [Azure Document Intelligence](/azure/ai-services/document-intelligence/) and [Azure Content Understanding](/azure/ai-services/content-understanding/). |
| Speech | [Azure Speech](/azure/ai-services/speech-service/) for speech-to-text transcription, text-to-speech voice generation, and speaker recognition. |
| Language | [Azure Language](/azure/ai-services/language-service/) for named entity recognition, personal-data detection, and language detection. [Azure Translator in Foundry Tools](/azure/ai-services/translator/) for translation. |
| Search and knowledge | [Azure AI Search](/azure/search/) for AI-powered search and RAG retrieval. |
| Content Safety | [Content Safety](/azure/ai-services/content-safety/) for harmful-content detection in user-generated and AI-generated content. |
| Video | [Azure AI Video Indexer](/azure/azure-video-indexer/) for video analysis and indexing. |
| Generative AI models and agents | [Microsoft Foundry](/azure/foundry/). Includes the Foundry Agent Service and Foundry Models. |

To compare the services within a capability area and choose one, see the following detailed selection guides:

- [Image and video processing](../../data-guide/ai-services/image-video-processing.md)
- [Targeted language processing](../../data-guide/ai-services/targeted-language-processing.md)
- [Speech recognition and generation](../../data-guide/ai-services/speech-recognition-generation.md)
- [Vector search](../../guide/technology-choices/vector-search.md)
- [AI services technology](../../data-guide/technology-choices/ai-services.md)

The following table summarizes core adoption details for Foundry Tools.

| Aspect | Details |
|---|---|
| Type | Pretrained APIs for building intelligent applications. |
| Supported languages | C#, Java, JavaScript, and Python SDKs depending on the service. REST APIs. |
| Machine learning phases | Consumption through APIs. Some services support customization. |
| Key benefits | The ability to add prebuilt AI capabilities through APIs. Minimal data science expertise required. Managed scaling. |

Foundry Tools isn't the best fit in the following situation: Your scenario requires custom model architectures or training data beyond the supported customization options. In these cases, use Azure Machine Learning for classical or deep learning models, or use Microsoft Foundry for generative AI fine-tuning.

## Microsoft Fabric

[Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a unified, SaaS-based analytics platform. It integrates data engineering, data science, data warehousing, real-time intelligence, and Power BI on a shared OneLake data foundation. Data engineers, data scientists, and business analysts who use Microsoft Fabric collaborate in the same managed environment.

The Microsoft Fabric Data Science workload is the part that's most relevant to machine learning. It provides Spark notebooks, AutoML, a built-in MLflow experience for experiment tracking, and a model registry. For detailed information, see [What is Data Science in Microsoft Fabric?](/fabric/data-science/data-science-overview).

Use Microsoft Fabric when you need the following capabilities:

- **Analytics-integrated machine learning.** Machine learning is part of a broader analytics workflow in your solution, such as building a model on data in a lakehouse and serving predictions to Power BI.

- **Fully managed SaaS.** You want a fully managed SaaS experience with minimal infrastructure to manage.

- **Shared data foundation.** Your team works across data engineering, data science, and BI on the same OneLake foundation.

The following table summarizes Microsoft Fabric capabilities that are most relevant to analytics-integrated machine learning.

| Capability | Description |
|---|---|
| OneLake foundation | A single, logical data lake shared by Microsoft Fabric workloads, including Data Engineering, Data Science, Data Warehouse, and Power BI. |
| Data science workload | A managed Spark runtime with notebooks for Python, R, SQL, and Scala for analysis and model training. Includes a built-in [MLflow experience for experiment tracking](/fabric/data-science/machine-learning-experiment) and a [model registry](/fabric/data-science/machine-learning-model). You can also [log MLflow experiments and models across workspaces and platforms](/fabric/data-science/machine-learning-cross-workspace-logging), including into Microsoft Fabric from an Azure Machine Learning workspace. |
| AutoML | Low-code AutoML for classification, regression, and forecasting. Code-first AutoML is available through FLAML APIs in Microsoft Fabric notebooks. |
| Real-Time Intelligence and Fabric Activator | Streaming analytics and no-code event detection that can trigger Microsoft Fabric pipelines, notebooks, or downstream actions. |
| Machine learning model endpoints | Managed online REST endpoints that serve real-time predictions from registered Microsoft Fabric models. This functionality is in preview and limited to a set of model flavors, but AutoML-trained models are supported. For detailed information, see [Serve real-time predictions with machine learning model endpoints](/fabric/data-science/model-endpoints). |
| Power BI integration | A means for exposing machine learning outputs to Power BI through semantic models and reports, including Direct Lake when Microsoft Fabric data stays in OneLake, and import or DirectQuery patterns when needed. Use this integration to incorporate predictions, anomaly scores, and forecast metrics in business dashboards and decision workflows. |
| Microsoft Foundry integration | A way to feed Microsoft Fabric data or model outputs to a Microsoft Foundry&#8211;based application or agent, such as a grounded copilot, summarization workflow, or RAG experience. In practice, Microsoft Foundry can connect to Microsoft Fabric data through a Microsoft Fabric data agent or another supported data connection. Then Microsoft Foundry can use that context when generating agent responses. If your workload only needs classical machine learning inside Microsoft Fabric and doesn't require LLMs or agents, this integration is usually unnecessary. |

The following table summarizes core adoption details for Microsoft Fabric.

| Aspect | Details |
|---|---|
| Type | A unified SaaS analytics platform. |
| Supported languages | Python, R, SQL, and Scala. |
| Machine learning phases | Data preparation, training, registration, batch scoring, real-time serving (preview), real-time analytics, and BI consumption. |
| Key benefits | A shared OneLake foundation. Low operational overhead. Integration with Power BI and the broader Microsoft data estate. |

Microsoft Fabric isn't the best fit in the following situation: You need deep learning at scale, comprehensive MLOps with governed registries, or fine-grained compute control. In these cases, complement Microsoft Fabric with Azure Machine Learning or Azure Databricks. Microsoft Fabric covers analytics-integrated machine learning well, but it isn't a replacement for a dedicated machine learning platform.

> [!NOTE]
> Microsoft Fabric is the recommended platform for new analytics-integrated machine learning investments. For existing investments in Azure Synapse Analytics, see [Machine learning in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/what-is-machine-learning). For dedicated SQL pool migration to Microsoft Fabric Data Warehouse, see [Fabric Migration Assistant for Data Warehouse](/fabric/data-warehouse/migration-assistant).

## Azure Databricks

[Azure Databricks](/azure/databricks/introduction/) is a unified, open analytics platform for building, deploying, sharing, and maintaining data, analytics, and AI solutions. It combines data warehousing and data lake capabilities in a lakehouse architecture and integrates with Azure storage and security.

Use Azure Databricks when you need the following capabilities:

- **Spark-scale machine learning.** You need to run machine learning on very large datasets or distributed Spark clusters.

- **Unified lakehouse workflow.** You combine data engineering, feature engineering, experimentation, and model development in one lakehouse workflow.

- **Production machine learning operations.** You want to deploy, manage, and monitor machine learning solutions in production by using managed serving endpoints, automated workflows, and MLOps pipelines.

- **Unity Catalog governance.** You want to govern data, features, models, and functions in Unity Catalog, which provides centralized access control and lineage.

- **Generative AI and agents.** You build generative AI and [AI agent workloads](/azure/databricks/agents/) in Azure Databricks, including custom and foundation model scenarios.

The following table lists notable Azure Databricks capabilities:

| Capability | Description |
|---|---|
| Managed integration with open-source projects | Includes Delta Lake, OpenSharing, MLflow, Spark, Apache Spark Structured Streaming, and Unity Catalog. |
| Azure Databricks Runtime for Machine Learning | Offers preinstalled libraries for classical machine learning and deep learning, including Hugging Face Transformers. |
| MLflow tracking and models in Unity Catalog | Supports experiment tracking, model lifecycle management, and governed model discovery. |
| Feature engineering and feature serving patterns | Supports reusable training and inference features. |
| [Azure Databricks Model Serving](/azure/databricks/machine-learning/model-serving/) | Offers managed real-time inference endpoints with autoscaling, versioned deployments, traffic controls, and production monitoring. |
| AI Gateway | Provides model access governance, usage tracking, and payload logging across served and external models. Supports developing, evaluating, and serving custom or open models in a lakehouse environment. |
| AI functions in SQL | Provides a way for analysts to call LLMs from data pipelines. |
| Foundation model APIs | Integrates external models and provides unified access patterns across model providers. |
| Unity Catalog governance | Provides unified governance of data, features, models, and functions through capabilities such as RBAC and OpenSharing. |
| Streaming analytics | Offers real-time and streaming analytics through Structured Streaming and Delta Lake. |
| Lakeflow Jobs and MLOps | Provides jobs and workflows for automated training, evaluation, deployment, and retraining pipelines. |

The following table summarizes core adoption details for Azure Databricks.

| Aspect | Details |
|---|---|
| Type | A lakehouse platform built on Spark. |
| Supported languages | Python, R, Scala, and SQL. |
| Machine learning phases | Data preparation, training, fine-tuning, evaluation, model serving, and governance. |
| Key benefits | End-to-end machine learning lifecycle on a lakehouse. Native MLflow integration. Managed serving and operations. Unity Catalog governance. Spark-scale machine learning and generative AI support. |
| Considerations | Serverless Model Serving can reduce inference infrastructure overhead, but the cost of Spark-based data preparation, feature engineering, and model training remains an important consideration. For non-Spark workloads, Azure Machine Learning or Foundry Tools might be more straightforward. |

Azure Databricks isn't the best fit in the following situations:

- Your team doesn't need Spark-scale processing. In this case, the cluster overhead might not be justified.

- Your scenario uses purely API-driven AI. In this case, Foundry Tools or Microsoft Foundry offers a more direct path.

- You need Azure Machine Learning&#8211;specific governance controls, endpoint capabilities, or a standardized endpoint layer across teams. In these cases, use Azure Machine Learning managed endpoints in a hybrid design.

## SQL intelligent applications and machine learning

SQL in-database AI keeps governed relational data where it already lives and adds prediction, vector retrieval, and AI endpoint integration directly in Transact-SQL (T-SQL).

Use SQL in-database AI in the following situations:

- Data must remain inside your relational database for security, privacy, latency, or regulatory reasons.

- You need low-latency scoring close to transactions, such as fraud checks or next-best-action decisions.

- You want vector search and retrieval directly in the database for RAG and semantic matching patterns.

- You need database-native invocation of external AI endpoints from T-SQL for orchestration or agent-callable workflows.

The following table lists current platforms and tools:

| Capability | Role in architecture |
|---|---|
| [`PREDICT` in T-SQL](/sql/t-sql/queries/predict-transact-sql) | Performs native in-database scoring for supported models, including ONNX-based runtime patterns where available. |
| [Vector data type](/sql/t-sql/data-types/vector-data-type) and [vector functions](/sql/t-sql/functions/vector-functions-transact-sql) | Stores embeddings and performs vector similarity operations inside the relational engine. |
| [`sp_invoke_external_rest_endpoint`](/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql) | Calls external AI endpoints from T-SQL with credentials, headers, retry options, and governed outbound controls. |
| [AI functions (Transact-SQL)](/sql/t-sql/functions/ai-functions-transact-sql), including [`AI_GENERATE_EMBEDDINGS`](/sql/t-sql/functions/ai-generate-embeddings-transact-sql) | Adds database-native AI operations for chunking, embedding generation, and related SQL AI workflows. |
| [Azure SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview) | Supports in-database execution of Python and R code for existing Machine Learning Services&#8211;style workloads. |

The following table summarizes core adoption details for Azure SQL machine learning.

| Aspect | Details |
|---|---|
| Type | Relational in-database AI capabilities for prediction, vector retrieval, and AI endpoint integration. |
| Supported languages | T-SQL first. Python and R are available through Azure SQL Managed Instance Machine Learning Services. |
| Machine learning phases | In-database data preparation, training, inference, vector retrieval, and endpoint orchestration. |
| Key benefits | Keeps governed transactional data in place. Reduces data movement. Enables low-latency AI enrichment in existing SQL workflows. |
| Considerations | The availability of capabilities varies by SQL platform and version. Large-scale model training and distributed deep learning are typically better handled in Azure Machine Learning, Azure Databricks, or Microsoft Fabric. |

Combine Azure SQL machine learning with another platform when you want to take the following approach:

- **Train externally, score in SQL.** For large-scale or deep learning training, use Azure Machine Learning, Azure Databricks, or Microsoft Fabric for training. Then bring inference artifacts back to SQL for in-database scoring.

- **Cloud-train, database-deploy, SQL-predict.** Train externally, export a scoring artifact supported by the target SQL platform, and then use `PREDICT` to execute predictions in SQL close to transactional data.

- **Generate embeddings in SQL, call endpoints for generation.** For RAG and agent scenarios, generate embeddings and vector retrieval in SQL. Then, if you need response generation, use `sp_invoke_external_rest_endpoint` to call external model endpoints from SQL.

## Edge, local, and on-premises machine learning

For machine learning that runs outside the cloud, on local devices, in offline environments, embedded in applications, or inside on-premises infrastructure, Microsoft provides several options.

Use edge, local, and on-premises machine learning when you need the following capabilities:

- **Local inference.** To meet latency, offline operation, or data privacy requirements, your scenario needs inference to run locally. For example, predictive maintenance solutions in environments with intermittent connectivity require local inference.

- **The ability to embed machine learning in applications.** You build desktop or mobile applications that need embedded machine learning capabilities.

- **On-premises execution.** Your scenario needs machine learning execution to stay inside an on-premises environment, such as a local SQL Server deployment.

Microsoft provides these options:

- [Microsoft Foundry on Windows](/windows/ai/) includes [Windows ML](/windows/ai/new-windows-ml/overview) for local inference on Windows devices with hardware acceleration across CPUs, GPUs, and NPUs. Use Windows ML for new Windows app and device inference workloads.

- [ML.NET](/dotnet/machine-learning/) is an open-source, cross-platform machine learning framework for .NET developers. It supports data loading, training (including AutoML for .NET), and local inference. Use ML.NET when the application needs .NET-native model training or inference, including ONNX model integration.

- [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services) supports training and scoring inside on-premises SQL Server when data must remain in the local data tier.

- [Foundry Local](/azure/foundry-local/get-started) is an on-device AI inference solution that extends Microsoft Foundry to edge and offline scenarios.

- [Azure Local](/azure/azure-local/overview) provides Azure-managed infrastructure for local virtual machines (VMs) and containers. Use it to host edge AI components close to data, such as Foundry Local workloads, RAG retrieval components, or ONNX models exported from Azure Machine Learning.

- [Kubernetes compute for Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere) attaches Azure Arc&#8211;enabled Kubernetes clusters to an Azure Machine Learning workspace so that on-premises or multicloud clusters run training and inference while orchestration stays in Azure.

- [Azure IoT Edge](/azure/iot-edge/) deploys containerized machine learning models to edge devices so that inference runs locally.

- [Azure Stack Edge](/azure/databox-online/azure-stack-edge-gpu-overview) provides Microsoft-managed edge appliances that you can use for hardware-accelerated machine learning and VM or containerized workloads. Devices are available only for validated partner workloads or deployments of at least 100 nodes.

A typical pattern trains an exportable model in the cloud by using Azure Machine Learning or Azure Databricks. The model is then converted to ONNX when the model and target runtime support that format. Finally, the model is deployed for edge inference through Windows ML, ML.NET, an Azure IoT Edge module, Foundry Local, or Azure Local infrastructure.

## Combine platforms

Production solutions can combine more than one platform. The flowchart earlier in this article helps you pick a *primary* starting platform. Use the following table to plan compound architectures and identify the supporting Microsoft components that each scenario typically requires.

| Combined scenario | Primary platform | Supporting Microsoft components | Pattern |
|---|---|---|---|
| Enterprise RAG or chat-with-your-data | Microsoft Foundry | Azure AI Search (and Foundry IQ for grounding), Azure Document Intelligence (ingestion), Microsoft Fabric or Azure Cosmos DB (data store), Content Safety | Ingest enterprise content, index it for vector and hybrid retrieval, and ground a Microsoft Foundry&#8211;hosted agent or LLM application against it. For data-store options, see [Choose an Azure service for vector search](../../guide/technology-choices/vector-search.md). |
| Generative AI on top of governed analytics | Microsoft Fabric | Microsoft Foundry (agents, models), Power BI (consumption), Azure AI Search | Use Microsoft Fabric to ingest and store governed data in OneLake. Then build agents or RAG applications in Microsoft Foundry over that data. Display results in Power BI. |
| Custom machine learning enriched with prebuilt AI features | Azure Machine Learning | Azure Vision, Azure Document Intelligence, Azure Speech, Azure Language, Azure AI Search | Use Foundry Tools for preprocessing, feature extraction, or retrieval, and use Azure Machine Learning to train, deploy, and govern the custom model that builds on those features. |
| Spark-scale training with managed serving | Azure Databricks | Azure Databricks Model Serving, MLflow, Unity Catalog, optional Azure Machine Learning (governance or endpoint standardization) | Run feature engineering and distributed training in Azure Databricks. Then use Azure Databricks Model Serving to deploy and serve trained models. Add Azure Machine Learning managed endpoints when you need Azure Machine Learning&#8211;specific governance or endpoint standardization across teams. |
| Cloud-train, edge-deploy | Azure Machine Learning or Azure Databricks | ONNX (model exchange), Windows ML, ML.NET, Foundry Local, Azure IoT Edge, Azure Local, Azure Stack Edge | Train an exportable model in the cloud, convert it to ONNX when supported, and deploy it to devices, on-premises gateways, or hardware-accelerated edge appliances for offline or low-latency inference. |
| Hybrid on-premises and cloud machine learning | Azure Machine Learning on Azure Arc | Azure Arc&#8211;enabled Kubernetes clusters, an Azure Machine Learning workspace, Container Registry, Key Vault | Keep data on-premises while using an Azure Machine Learning workspace attached to Azure Arc&#8211;enabled Kubernetes to orchestrate training and inferencing. |
| In-database scoring with cloud-trained models | SQL machine learning | Azure Machine Learning or Azure Databricks (training), ONNX, SQL Managed Instance or SQL Server | Train in the cloud, export to ONNX, and use the SQL `PREDICT` function for low-latency, in-database scoring next to operational data. |
| Multi-agent automation | Microsoft Agent Framework and Foundry Agent Service | Foundry Models, Foundry IQ, Azure AI Search, Azure Functions or Azure Logic Apps (tools), Azure API Management | Build multi-agent workflows in code by using the Microsoft Agent Framework, use the Foundry Agent Service to host and orchestrate them, and integrate enterprise tools and APIs. |

## Development platforms and tools

Most teams use cross-cutting development tools and supporting services alongside the platform they pick as the primary one. These tools influence where AI and machine learning work is developed, tested, and packaged before it runs. The supporting services influence where inference is hosted or where compute attaches to data that can't move to a managed cloud platform.

This section separates the primary developer tools, which are the day-to-day development and operational platforms, from the adjacent supporting services that host self-managed inference, accelerate Spark-based machine learning, or extend training and scoring to on-premises infrastructure.

The following tools support development across the cloud and on-premises platforms.

| Tool | Description |
| ---- | ----------- |
| [Foundry Toolkit for Visual Studio Code](https://code.visualstudio.com/docs/intelligentapps/overview) | A developer experience in VS Code for building, testing, debugging, evaluating, and deploying generative AI applications and agents. Supports local models, model catalogs, agent development, tool integration, tracing, and evaluation. |
| [Foundry portal](/azure/foundry/what-is-foundry) | A web environment for proof-of-concept work, model exploration, project resource management, evaluation review, and operational visibility across Microsoft Foundry applications and agents. |
| [Azure Machine Learning studio](/azure/machine-learning/overview-what-is-azure-machine-learning#studio) | A web UI for the Azure Machine Learning platform. Includes notebooks, the pipeline designer, AutoML, model management, and data labeling. |
| [Azure Data Science Virtual Machine](/azure/machine-learning/data-science-virtual-machine/overview) | A preconfigured VM image with data science tools such as Jupyter, R, and Python preinstalled. |
| [ML.NET](/dotnet/machine-learning/) | An open-source, cross-platform machine learning framework for .NET applications. |
| [Microsoft Foundry on Windows](/windows/ai/) | Windows ML for hardware-accelerated local model inference on Windows devices. |
| [SynapseML](https://microsoft.github.io/SynapseML/) | An open-source distributed machine learning and microservices framework for Spark. |

Adjacent supporting services help with experimentation, self-managed inference hosting, Spark-based machine learning, or hybrid operation, but they aren't the primary platform choices in the decision flow.

| Service | Role in the machine learning and AI ecosystem |
|---|---|
| [Azure Kubernetes Service (AKS)](/azure/aks/) and [Azure Container Apps](/azure/container-apps/) | Solutions for hosting self-managed inference containers in Azure. Use Container Apps for more straightforward managed container hosting, or AKS when you need more control over the serving runtime and cluster environment. Common examples include open-source serving stacks such as vLLM, Triton Inference Server, or BentoML. |
| [SynapseML](https://microsoft.github.io/SynapseML/) | An open-source, distributed machine learning and microservices framework for Spark. Works on Azure Databricks, Microsoft Fabric, and other Spark clusters. |
| [Azure Arc&#8211;enabled machine learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere) | A solution for attaching on-premises or multicloud Kubernetes clusters to an Azure Machine Learning workspace for hybrid training and inference. |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Microsoft Foundry documentation](/azure/foundry/)
- [What is Microsoft Fabric?](/fabric/fundamentals/microsoft-fabric-overview)
- [What are Foundry Tools?](/azure/ai-services/what-are-ai-services)
- [How Azure Machine Learning works](/azure/machine-learning/concept-azure-machine-learning-v2)
- [Microsoft AI](https://www.microsoft.com/ai)
- [Microsoft Learn training for AI engineers and data scientists](/training/browse/?roles=ai-engineer,data-scientist)

## Related resources

- [Choose an AI services technology](../../data-guide/technology-choices/ai-services.md)
- [Choose an Azure service for vector search](../../guide/technology-choices/vector-search.md)
- [AI technology overview](../ai-overview.md)