- [AI technology overview](/azure/architecture/ai-ml/ai-overview): Provides an overview of AI concepts, development platforms, and architecture patterns to help you design AI workloads on Azure.

### Select an AI service

The following articles help you evaluate and select the best AI technologies for your workload requirements:

- [Choose an AI services technology](/azure/architecture/data-guide/technology-choices/ai-services): Compares AI services and machine learning solutions to help you choose the right service or model for your use case.

- [Choose an Azure AI targeted language processing technology](/azure/architecture/data-guide/ai-services/targeted-language-processing): Compares Azure services for targeted language-processing tasks such as translation, entity recognition, and text analytics.

- [Choose an Azure speech recognition and generation technology](/azure/architecture/data-guide/ai-services/speech-recognition-generation): Compares Azure services for speech-to-text, text-to-speech, and speech translation scenarios.

- [Choose an Azure AI image and video processing and generation technology](/azure/architecture/data-guide/ai-services/image-video-processing): Compares Azure services for image and video analysis, generation, and processing.

- [Choose a natural language processing technology](/azure/architecture/data-guide/technology-choices/natural-language-processing): Compares Azure natural language processing technologies to help you choose the right platform for text understanding and generation tasks.

- [Microsoft AI and machine learning products](/azure/architecture/ai-ml/guide/data-science-and-machine-learning): Compares Microsoft machine learning products to help you choose a platform for building, deploying, and managing AI applications, agents, and machine learning models.

- [Choose the right AI model for your workload](/azure/architecture/ai-ml/guide/choose-ai-model): Describes strategies for selecting the right AI model from the many available options for deployment.

### AI solution ideas

The following AI solution ideas demonstrate implementation patterns and possibilities to explore.

#### Audio processing

- [Unlock insights from conversational data](/azure/architecture/ai-ml/idea/unlock-insights-from-conversational-data): Extracts actionable insights from conversational audio data.

#### Image processing

- [Image classification](/azure/architecture/ai-ml/idea/intelligent-apps-image-processing): Classifies images by using intelligent application patterns.

#### Predictive analytics

- [Customer order forecasting](/azure/architecture/ai-ml/idea/next-order-forecasting): Predicts future customer orders by using machine learning.

#### MLOps solution ideas

- [Use Azure Databricks to orchestrate machine learning operations](/azure/architecture/ai-ml/idea/orchestrate-machine-learning-azure-databricks): Orchestrates machine learning operations by using Azure Databricks.

- [Many models with Machine Learning](/azure/architecture/ai-ml/idea/many-models-machine-learning-azure-machine-learning): Trains and manages many models at scale by using Azure Machine Learning.

#### Document processing and enrichment

- [Extract and map information from unstructured content](/azure/architecture/ai-ml/idea/multi-modal-content-processing): Extracts and maps information from multimodal unstructured content.

- [Generate documents from your data](/azure/architecture/ai-ml/idea/generate-documents-from-your-data): Generates structured documents from data sources.

- [Use AI enrichment with Azure AI Search](/azure/architecture/solution-ideas/articles/ai-search-skillsets): Enriches content by using AI skill sets in Azure AI Search indexing pipelines.

#### Workflow automation

- [Build a multiple-agent workflow automation solution by using Microsoft Agent Framework](/azure/architecture/ai-ml/idea/multiple-agent-workflow-automation): Automates workflows by using multiple AI agents orchestrated through Microsoft Agent Framework.

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

- [Extract text by using Power Automate](/azure/architecture/example-scenario/ai/extract-object-text): Extracts text from objects by using Power Automate and AI capabilities.

- [Multiple indexers with Azure AI Search](/azure/architecture/ai-ml/architecture/search-blob-metadata): Uses multiple indexers to process and index blob metadata by using Azure AI Search.

#### Video and image classification

- [Automate video analysis](/azure/architecture/ai-ml/architecture/analyze-video-computer-vision-machine-learning): Analyzes video content by using computer vision and machine learning.

#### Audio processing

- [Extract and analyze call center data](/azure/architecture/ai-ml/openai/architecture/call-center-openai-analytics): Extracts and analyzes call center conversations by using Azure OpenAI.

#### Regulatory

- [Secure research for regulated data](/azure/architecture/ai-ml/architecture/secure-compute-for-research): Provides a secure compute environment for research workloads that handle regulated data.

### AI guides

- [Dynamic AI agents at scale pattern](/azure/architecture/solution-ideas/articles/ai-agents-at-scale): Describes how to dynamically select and orchestrate AI agents from a pool by using Microsoft Foundry, Azure AI Search, and Azure OpenAI to build multiagent systems.

- [Microsoft AI and machine learning products](/azure/architecture/ai-ml/guide/data-science-and-machine-learning): Compares Microsoft machine learning products to help you choose a platform for building, deploying, and managing AI applications, agents, and machine learning models.

- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns): Describes design patterns for orchestrating AI agents in complex scenarios.

- [Design a secure multitenant RAG inferencing solution](/azure/architecture/ai-ml/guide/secure-multitenant-rag): Provides guidance for securing RAG solutions in multitenant environments.

- [Design to support foundation model life cycles](/azure/architecture/ai-ml/guide/manage-foundation-models-lifecycle): Provides guidance for managing foundation model updates, deprecations, and transitions.

#### Developing and evaluating RAG solutions

- [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide): Provides an overview of how to design and evaluate RAG solutions.

- [Preparation phase](/azure/architecture/ai-ml/guide/rag/rag-preparation-phase): Covers data preparation for RAG implementations.

- [Chunking phase](/azure/architecture/ai-ml/guide/rag/rag-chunking-phase): Describes strategies for chunking content in RAG pipelines.

- [Chunk enrichment phase](/azure/architecture/ai-ml/guide/rag/rag-enrichment-phase): Covers enrichment techniques applied to content chunks.

- [Embedding phase](/azure/architecture/ai-ml/guide/rag/rag-generate-embeddings): Describes how to generate embeddings for RAG retrieval.

- [Information-retrieval phase](/azure/architecture/ai-ml/guide/rag/rag-information-retrieval): Covers information retrieval strategies in RAG architectures.

- [Prompt engineering](/azure/architecture/ai-ml/guide/rag/rag-prompt-engineering): Describes how to design effective prompts for RAG solutions, including prompt structure, grounding techniques, and context management.

- [Model end-to-end evaluation phase](/azure/architecture/ai-ml/guide/rag/rag-llm-evaluation-phase): Describes how to evaluate RAG models end to end.

- [Agentic RAG](/azure/architecture/ai-ml/guide/rag/rag-agentic): Describes how to shift from a standard RAG pipeline to an agentic RAG architecture for dynamic query planning and multistep reasoning.

#### MLOps guides

- [Machine learning operations](/azure/architecture/ai-ml/guide/machine-learning-operations-v2): Describes the machine learning operations v2 approach for operationalizing machine learning workflows.

- [Generative AI operations for organizations with MLOps investments](/azure/architecture/ai-ml/guide/genaiops-for-mlops): Extends machine learning operations practices to generative AI workloads.

- [MLOps maturity model](/azure/architecture/ai-ml/guide/mlops-maturity-model): Defines maturity levels for machine learning operations adoption.

#### Proxy generative AI models

- [Use a gateway in front of generative models](/azure/architecture/ai-ml/guide/azure-openai-gateway-guide): Describes the benefits and architecture of placing a gateway in front of generative AI model endpoints.

- [Use a gateway in front of multiple model deployments or instances](/azure/architecture/ai-ml/guide/azure-openai-gateway-multi-backend): Extends the gateway pattern to route requests across multiple model back ends.

- [Provide custom authentication to Foundry Models through a gateway](/azure/architecture/ai-ml/guide/azure-openai-gateway-custom-authentication): Implements custom authentication flows for model access through a gateway.

- [Implement advanced monitoring for Foundry Models through a gateway](/azure/architecture/ai-ml/guide/azure-openai-gateway-monitoring): Adds monitoring and observability to generative AI model traffic through a gateway.

