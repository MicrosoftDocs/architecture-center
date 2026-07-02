---
title: Get Started with AI Architecture Design
description: Get started with AI architecture design on Azure. Explore AI services, reference architectures, best practices, readiness guidance, and learning resources.
author: davihern
ms.author: pnp
ms.update-cycle: 1095-days
ms.date: 06/15/2026
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: category-get-started
ms.custom: arb-aiml
ai-usage: ai-assisted
---

# Get started with AI architecture design

AI enables machines to analyze data, generate content, synthesize speech, make predictions, and support decision-making across industries. As AI capabilities expand through generative models, language models, and agent-based architectures, organizations need architectural guidance to design reliable, secure, cost-effective, and operationally stable AI workloads.

This article helps you get started with AI on Azure. It introduces AI services, reference architectures, best practices, and learning resources so that you can design and build AI solutions that meet your workload requirements.

## Azure services for AI

Azure provides a range of services for building, deploying, and managing AI workloads. These services span development platforms, prebuilt AI capabilities, data platforms, and tools for creating custom models. Use the following services to integrate AI into your workload design.

### AI development platforms

- [Microsoft Foundry](/azure/foundry/what-is-foundry): A unified platform as a service (PaaS) for developing and deploying generative AI applications and agents. Microsoft Foundry provides access to a model catalog, agent hosting through Foundry Agent Service, fine-tuning, evaluation tools, and responsible AI capabilities. Use the [Foundry portal](https://ai.azure.com) to experiment, build, and deploy AI models and agents.

- [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning): A cloud service for building, training, and deploying machine learning models at scale. Azure Machine Learning supports open-source frameworks like PyTorch, TensorFlow, and scikit-learn. It also provides capabilities for AutoML, hyperparameter tuning, distributed training, machine learning operations, and responsible AI.

- [Microsoft Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio): A low-code platform for building, customizing, and deploying AI-powered agents. Use Microsoft Copilot Studio to create conversational agents for internal and external scenarios and to extend Microsoft 365 Copilot with enterprise data and custom workflows.

### Prebuilt AI services

- [Foundry Tools](/azure/ai-services/what-are-ai-services): A suite of prebuilt and customizable APIs and models for adding intelligent features to applications. Foundry Tools includes capabilities for speech, translation, language understanding, document intelligence, content understanding, vision, content safety, and search.

- [Azure OpenAI](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure): Provides access to OpenAI models, including GPT and DALL-E, through Azure-managed infrastructure with enterprise security, networking, and responsible AI controls.

### Data platforms for AI

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview): An end-to-end analytics and data platform that covers data ingestion, transformation, real-time event routing, and reporting. Microsoft Fabric provides OneLake as a unified data lake and includes embedded AI capabilities, Microsoft Copilot features, and integration with Foundry Tools.

- [Azure Databricks](/azure/databricks/introduction/): A Spark-based analytics platform for data engineering, data science, and machine learning. Azure Databricks provides Databricks Runtime for Azure Machine Learning, MLflow integration, AutoML, foundation model fine-tuning, and Mosaic AI Vector Search for embedding-based retrieval.

- [Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview): A managed Apache Spark service for big data processing and analytics. Azure HDInsight Spark clusters support machine learning workloads through MLlib, are compatible with Azure Storage and Azure Data Lake Storage, and support SynapseML for deep learning.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction): A scalable, centralized repository for storing structured and unstructured data. Azure Data Lake Storage provides file system semantics, file-level security, and tiered storage built on Azure Blob Storage.

### Enterprise Intelligence Layers

AI architecture at Microsoft introduces three complementary intelligence layers or *IQs* that represent key sources of context for AI systems:

- [Work IQ](/microsoft-365/copilot/extensibility/work-iq/) captures intelligence about how work happens inside an organization. It uses signals from Microsoft 365 such as emails, chats, meetings, documents, and collaboration patterns.

   This layer is essential for grounding AI in human activity and organizational behavior rather than treating interactions as isolated prompts.

- [Fabric IQ](/fabric/iq/overview) provides intelligence derived from structured enterprise data managed in Microsoft Fabric, including analytics models, key performance indicators (KPIs), and business entities.

   Fabric IQ enables AI to answer complex analytical questions and interpret results in the context of business operations.

- [Foundry IQ](/azure/foundry/agents/concepts/what-is-foundry-iq?tabs=portal) provides a unified, multisource knowledge layer that allows AI agents to retrieve and ground responses in enterprise data.

   This layer is critical for implementing patterns like retrieval-augmented generation (RAG) to help ensure that AI outputs are accurate, current, and compliant.

## Architecture

The following diagram shows a baseline end-to-end chat architecture that uses Microsoft Foundry. This reference architecture demonstrates how AI services comprise a production-ready solution on Azure. It includes identity, networking, monitoring, and governance layers.

:::image type="complex" source="./architecture/_images/baseline-microsoft-foundry.svg" border="false" lightbox="./architecture/_images/baseline-microsoft-foundry.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture that uses Microsoft Foundry.":::
   The diagram presents a detailed Azure architecture for deploying an AI solution. On the left, a user connects through an application gateway with a web application firewall (WAF), which is part of a virtual network. This gateway links to private Domain Name System (DNS) zones. Azure DDoS Protection protects the gateway. Below the gateway, private endpoints connect to services like Azure App Service, Azure Key Vault, and Azure Storage, which are used for client app deployment. Azure App Service is managed with identity and spans three zones. Application Insights and Azure Monitor provide monitoring, and Microsoft Entra ID handles authentication. To the right, the virtual network has several subnets: App Service integration, a private endpoint, Microsoft Foundry integration, Azure AI agent integration, Azure Bastion, a jump box, build agents, and Azure Firewall. Each subnet hosts specific endpoints or services, like storage, Microsoft Foundry, Azure AI Search, Azure Cosmos DB, and knowledge stores, that connect via private endpoints. Outbound traffic from the network passes through Azure Firewall to reach internet sources. To the far right, a separate box represents Microsoft Foundry, which includes an account and a project. Managed identities connect Foundry Agent Service to the Microsoft Foundry project, which in turn accesses Azure OpenAI. The diagram uses numbered circles to indicate the logical flow, which shows how user requests traverse the network, interact with different endpoints, and connect to Foundry Tools and storage.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-microsoft-foundry.vsdx) of this architecture.*

The previous diagram demonstrates a typical baseline AI implementation. For real-world solutions that you can build in Azure, see [AI architectures](#ai-architectures).

## Explore AI architectures and guides

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your AI proof-of-concept (POC) development. These articles can help you decide how to use AI technologies in Azure.

### AI guides

The following article helps you evaluate and select the best AI technologies for your workload requirements:

- [Machine learning options](/azure/architecture/ai-ml/guide/data-science-and-machine-learning): Compares Azure Machine Learning products and technologies to help you choose the right platform for model training and deployment.

#### AI agent design

- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns): Describes design patterns for orchestrating AI agents in complex scenarios.

#### RAG solution development and evaluation

- [Design a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide): Provides an overview of how to design and evaluate RAG solutions.

- [Preparation phase](/azure/architecture/ai-ml/guide/rag/rag-preparation-phase): Covers data preparation for RAG implementations.

- [Chunking phase](/azure/architecture/ai-ml/guide/rag/rag-chunking-phase): Describes strategies for chunking content in RAG pipelines.

- [Chunk enrichment phase](/azure/architecture/ai-ml/guide/rag/rag-enrichment-phase): Covers enrichment techniques applied to content chunks.

- [Embedding phase](/azure/architecture/ai-ml/guide/rag/rag-generate-embeddings): Describes how to generate embeddings for RAG retrieval.

- [Information-retrieval phase](/azure/architecture/ai-ml/guide/rag/rag-information-retrieval): Covers information retrieval strategies in RAG architectures.

- [Model end-to-end evaluation phase](/azure/architecture/ai-ml/guide/rag/rag-llm-evaluation-phase): Describes how to evaluate RAG models end to end.

#### Multitenant RAG solution

- [Design a secure multitenant RAG inferencing solution](/azure/architecture/ai-ml/guide/secure-multitenant-rag): Provides guidance for securing RAG solutions in multitenant environments.

#### Machine learning operations

- [Machine learning operations v2](/azure/architecture/ai-ml/guide/machine-learning-operations-v2): Describes the machine learning operations v2 approach for operationalizing machine learning workflows.

- [Generative AI operations with machine learning operations](/azure/architecture/ai-ml/guide/genaiops-for-mlops): Extends machine learning operations practices to generative AI workloads.

- [Machine learning operations maturity model](/azure/architecture/ai-ml/guide/mlops-maturity-model): Defines maturity levels for machine learning operations adoption.

#### Proxy generative AI models

- [Use a gateway in front of generative models](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide): Describes the benefits and architecture of placing a gateway in front of generative AI model endpoints.

- [Use a gateway in front of multiple models](/azure/architecture/ai-ml/guide/azure-openai-gateway-multi-backend): Extends the gateway pattern to route requests across multiple model back ends.

- [Provide custom authentication to models through a gateway](/azure/architecture/ai-ml/guide/azure-openai-gateway-custom-authentication): Implements custom authentication flows for model access through a gateway.

- [Implement advanced model monitoring through a gateway](/azure/architecture/ai-ml/guide/azure-openai-gateway-monitoring): Adds monitoring and observability to generative AI model traffic through a gateway.

#### Foundation model life cycle

- [Design to support foundation model life cycles](/azure/architecture/ai-ml/guide/manage-foundation-models-lifecycle): Provides guidance for managing foundation model updates, deprecations, and transitions.

### AI architectures

The following production-ready architectures demonstrate end-to-end AI solutions that you can deploy and customize.

#### Chat with data

- [Basic Microsoft Foundry chat reference architecture](/azure/architecture/ai-ml/architecture/basic-microsoft-foundry-chat): A basic RAG chat architecture that uses Microsoft Foundry and Azure OpenAI.

- [Baseline Microsoft Foundry chat reference architecture](/azure/architecture/ai-ml/architecture/baseline-microsoft-foundry-chat): A production-ready end-to-end chat architecture that uses Microsoft Foundry with enterprise security, networking, and monitoring.

- [Baseline Microsoft Foundry chat architecture in an Azure landing zone](/azure/architecture/ai-ml/architecture/baseline-microsoft-foundry-landing-zone): Deploys the baseline Microsoft Foundry chat architecture within an Azure landing zone for enterprise-scale governance.

#### Document processing

- [Automate document classification](/azure/architecture/ai-ml/architecture/automate-document-classification-durable-functions): Uses Durable Functions to automate document classification workflows.

- [Automate PDF form processing](/azure/architecture/ai-ml/architecture/automate-pdf-forms-processing): Automates the extraction and processing of data from PDF forms.

- [Build custom document processing models](/azure/architecture/ai-ml/architecture/build-deploy-custom-models): Builds and deploys custom models for document processing scenarios.

- [Multiple indexers with Azure AI Search](/azure/architecture/ai-ml/architecture/search-blob-metadata): Uses multiple indexers to process and index blob metadata by using Azure AI Search.

#### Video and image classification

- [Automate video analysis](/azure/architecture/ai-ml/architecture/analyze-video-computer-vision-machine-learning): Analyzes video content by using computer vision and machine learning.

#### Audio processing

- [Extract and analyze call center data](/azure/architecture/ai-ml/openai/architecture/call-center-openai-analytics): Extracts and analyzes call center conversations by using Azure OpenAI.

#### Regulatory requirements

- [Secure research for regulated data](/azure/architecture/ai-ml/architecture/secure-compute-for-research): Provides a secure compute environment for research workloads that handle regulated data.

### AI solution ideas

The following AI solution ideas demonstrate implementation patterns and possibilities to explore.

#### Audio processing

- [Unlock insights from conversational data](/azure/architecture/ai-ml/idea/unlock-insights-from-conversational-data): Extracts actionable insights from conversational audio data.

#### Image processing

- [Image classification](/azure/architecture/ai-ml/idea/intelligent-apps-image-processing): Classifies images by using intelligent application patterns.

#### Predictive analytics

- [Customer order forecasting](/azure/architecture/ai-ml/idea/next-order-forecasting): Predicts future customer orders by using machine learning.

#### Machine learning operations

- [Use Azure Databricks to orchestrate machine learning operations](/azure/architecture/ai-ml/idea/orchestrate-machine-learning-azure-databricks): Orchestrates machine learning operations by using Azure Databricks.

- [Many models with Machine Learning](/azure/architecture/ai-ml/idea/many-models-machine-learning-azure-machine-learning): Trains and manages many models at scale by using Azure Machine Learning.

#### Document processing and enrichment

- [Extract and map information from unstructured content](/azure/architecture/ai-ml/idea/multi-modal-content-processing): Extracts and maps information from multimodal unstructured content.

- [Generate documents from your data](/azure/architecture/ai-ml/idea/generate-documents-from-your-data): Generates structured documents from data sources.

- [Use AI enrichment with Azure AI Search](/azure/architecture/solution-ideas/articles/ai-search-skillsets): Enriches content by using AI skill sets in Azure AI Search indexing pipelines.

- [Extract text by using Power Automate](/azure/architecture/example-scenario/ai/extract-object-text): Extracts text from objects by using Power Automate and AI capabilities.

#### Workflow automation

- [Build a multiple-agent workflow automation solution by using Semantic Kernel](/azure/architecture/ai-ml/idea/multiple-agent-workflow-automation): Automates workflows by using multiple AI agents orchestrated through Semantic Kernel.

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

For AI-specific adoption guidance, see the following Cloud Adoption Framework resources:

- [AI adoption](/azure/cloud-adoption-framework/ai/): Provides a structured process for adopting AI solutions in Azure, including strategy, planning, readiness, governance, security, and management.

- [AI ready](/azure/cloud-adoption-framework/ai/ready): Outlines the organizational process for building AI workloads in Azure, including resource organization, networking, reliability, and governance.

To help ensure the quality of your AI solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

For AI-specific guidance, see the following Well-Architected Framework resource:

- [AI workloads on Azure](/azure/well-architected/ai/get-started): Addresses architectural challenges of designing AI workloads, including nondeterministic functionality, data and application design, and operations across the five Well-Architected Framework pillars.

For AI-related Well-Architected Framework service guides, see:

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning)
- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks)

## Best practices

Follow these best practices to improve the reliability, security, cost effectiveness, operational quality, and performance of your AI workloads on Azure:

- [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide): Follow a structured, phase-by-phase approach to designing RAG solutions, including chunking, embedding, information retrieval, and end-to-end evaluation.

- [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search): Evaluate Azure services that support vector search to find the best fit for your retrieval and similarity search requirements.

- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns): Learn proven orchestration patterns for architectures that use multiple agents, including sequential, concurrent, group chat, handoff, and magentic patterns. Review implementation considerations for reliability, security, cost, and observability.

- [Use a gateway in front of generative AI models](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide): Implement gateway patterns for proxying, load balancing, and monitoring generative model endpoints.

- [Machine learning operations v2](/azure/architecture/ai-ml/guide/machine-learning-operations-v2): Apply end-to-end machine learning operations life cycle guidance for training, deploying, and managing machine learning models at scale.

- [Generative AI operations with machine learning operations](/azure/architecture/ai-ml/guide/genaiops-for-mlops): Extend machine learning operations practices to generative AI workloads, including prompt management, evaluation, and deployment.

- [Design a secure multitenant RAG inferencing solution](/azure/architecture/ai-ml/guide/secure-multitenant-rag): Apply multitenancy patterns for RAG solutions that enforce data isolation and secure inferencing across tenants.

- [Design to support foundation model life cycles](/azure/architecture/ai-ml/guide/manage-foundation-models-lifecycle): Manage model versioning, deprecation, and rotation to keep AI workloads current and resilient.

- [Machine learning options](/azure/architecture/ai-ml/guide/data-science-and-machine-learning): Compare machine learning training and deployment options in Azure to choose the right services for your workload.

- [Apache Spark guidelines](/azure/hdinsight/spark/spark-best-practices): Review guidelines for running, monitoring, debugging, and optimizing Apache Spark jobs on Azure HDInsight.

## Stay current with AI

Azure AI services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key AI services, see the following articles:

- [What's new in Azure OpenAI in Foundry Models](/azure/foundry-classic/openai/whats-new): Provides a summary of the latest releases and documentation updates for Azure OpenAI, including new model availability, API versions, and feature announcements.

- [What's new in Microsoft Foundry](/azure/foundry/whats-new-foundry): Highlights key article and product updates in Microsoft Foundry, including agent governance, observability features, and new capabilities.

- [What's new in Azure AI Search](/azure/search/whats-new): Covers the latest updates to Azure AI Search functionality, including new API versions, agentic retrieval features, and indexing capabilities.

- [What's new in Azure Language in Foundry Tools](/azure/ai-services/language-service/whats-new): Covers updates to Azure Language in Foundry Tools capabilities, including new SDK versions, orchestration workflows, and Microsoft Foundry integration.

- [What's new in Microsoft Fabric](/fabric/fundamentals/whats-new): Covers updates across Microsoft Fabric capabilities, including data science, MLflow integration, data agents, and analytics features.

- [Azure Machine Learning CLI and SDK release notes](/azure/machine-learning/azure-machine-learning-release-notes-cli-v2): Provides release notes for the Azure Machine Learning CLI (v2) and Python SDK, including new features, bug fixes, and breaking changes.

- [Azure Databricks platform release notes](/azure/databricks/release-notes/product/): Covers updates to the Azure Databricks platform, including runtime versions, workspace features, and integration capabilities.

- [What's new in Microsoft Copilot Studio](/microsoft-copilot-studio/whats-new): Highlights new features and updates for Microsoft Copilot Studio, including agent building capabilities and connector updates.

- [What's new in Azure Document Intelligence in Foundry Tools](/azure/ai-services/document-intelligence/whats-new): Covers updates to Azure Document Intelligence in Foundry Tools, including new prebuilt models, API versions, and extraction capabilities.

- [What's new in Azure Content Understanding in Foundry Tools](/azure/ai-services/content-understanding/whats-new): Covers updates to Azure Content Understanding in Foundry Tools, including new content analysis features and Microsoft Foundry integration.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you ramp up quickly, the following articles compare Azure AI options to other cloud services:

- [Data and AI](/azure/architecture/aws-professional/data-ai): Compares AWS data and AI services, including machine learning, generative AI, and AI platform services, to their Azure counterparts.

- [AI and machine learning](/azure/architecture/gcp-professional/services#ai-and-machine-learning): Compares Google Cloud AI and machine learning services, including Vertex AI, Dialogflow, and Gemini, to their Azure counterparts.
