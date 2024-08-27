This article provides a basic architecture intended for learning about running chat applications that use [Azure OpenAI Service language models](/azure/ai-services/openai/concepts/models) in a single region. The architecture includes a client user interface running in Azure App Service and uses Azure Machine Learning prompt flow to orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the language model. The executable flow is deployed to a Machine Learning compute cluster behind a managed online endpoint.

> [!IMPORTANT]
> This architecture isn't meant to be used for production applications. It's intended to be an introductory architecture you can use for learning and proof of concept (POC) purposes. When designing your production enterprise chat applications, see the [Baseline OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml).

> [!IMPORTANT]
> ![GitHub logo](../../_images/github.svg) The guidance is backed by an [example implementation](https://github.com/Azure-Samples/openai-end-to-end-basic) which showcases this basic end-to-end chat implementation on Azure. This implementation can be used as a basis for your POC to experience working with chat applications that use Azure OpenAI.

## Architecture

:::image type="complex" source="./_images/openai-end-to-end-basic.svg" lightbox="./_images/openai-end-to-end-basic.png" alt-text="Diagram that shows a basic end-to-end chat architecture.":::
    The diagram shows an Azure App Service connecting directly to an Azure Machine Learning managed online endpoint that is sitting in front of compute instances. There is an arrow from the compute instances to Azure AI Search and an arrow pointing to Azure OpenAI Service. The diagram also shows Azure App Insights and Azure Monitor, Azure Key Vault, Azure Container Registry, and Azure Storage.
:::image-end:::
*Figure 1: Basic end-to-end chat architecture with Azure OpenAI*

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end-basic.vsdx) of this architecture.*

### Workflow

1. A user issues an HTTPS request to the App Service's default domain on azurewebsites.net. This domain automatically points to the App Service's built-in public IP. The TLS connection is established from the client directly to app service. The certificate is managed completely by Azure.
1. Easy Auth, a feature of Azure App Service, ensures that the user accessing the site is authenticated with Microsoft Entra ID.
1. The client application code deployed to App Service handles the request. The code connects to an Azure Machine Learning managed online endpoint.
1. The managed online endpoint routes the request to an Azure Machine Learning compute instance where the Azure Machine Learning prompt flow orchestration logic is deployed.
1. The Azure Machine Learning prompt flow orchestration code begins executing. Among other things, the logic extracts the query from the request.
1. The orchestration logic connects to Azure AI Search to fetch grounding data for the query. The grounding data is added to the prompt that will be sent to Azure OpenAI in the next step.
1. The orchestration logic connects to Azure OpenAI and sends the prompt that includes the relevant grounding data.
1. The information about original request to App Service and the call to the managed online endpoint (LA), and the call to Azure OpenAI are logged in Application Insights.

## Components

Many of the components of this architecture are the same as the resources in the [basic App Service web application architecture](../../web-apps/app-service/architectures/basic-web-app.yml) because the method that you use to host the chat UI is the same in both architectures. The components highlighted in this section focus on the components used to build and orchestrate chat flows, data services, and the services that expose the language models.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a managed cloud service that you can use to train, deploy, and manage machine learning models. This architecture uses several other features of Machine Learning that are used to develop and deploy executable flows for AI applications that are powered by language models:

  - [Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) is a development tool that you can use to build, evaluate, and deploy flows that link user prompts, actions through Python code, and calls to language learning models. Prompt flow is used in this architecture as the layer that orchestrates flows between the prompt, different data stores, and the language model.

  - [Managed online endpoints](/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference) let you deploy a flow for real-time inference. In this architecture, they're used as a PaaS endpoint for the chat UI to invoke the prompt flows hosted by Machine Learning.

- [Storage](https://azure.microsoft.com/services/storage) is used to persist the prompt flow source files for prompt flow development.

- [Container Registry](https://azure.microsoft.com/services/container-registry) lets you build, store, and manage container images and artifacts in a private registry for all types of container deployments. In this architecture, flows are packaged as container images and stored in Container Registry.

- [Azure OpenAI](/azure/well-architected/service-guides/azure-openai) is a fully managed service that provides REST API access to Azure OpenAI's language models, including the GPT-4, GPT-3.5-Turbo, and embeddings set of models. In this architecture, in addition to model access, it's used to add common enterprise features such as [managed identity](/azure/ai-services/openai/how-to/managed-identity) support, and content filtering.

- [Azure AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search). AI Search is included in the architecture because it's a common service used in the flows behind chat applications. AI Search can be used to retrieve and index data that's relevant for user queries. The prompt flow implements the RAG [Retrieval Augmented Generation](/azure/search/retrieval-augmented-generation-overview) pattern to extract the appropriate query from the prompt, query AI Search, and use the results as grounding data for the Azure OpenAI model.