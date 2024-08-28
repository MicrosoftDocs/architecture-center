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

### Machine Learning prompt flow

The workflow above includes the flow for the chat application, however the list below outlines a typical prompt flow in a more detail.

- The user enters a prompt in a custom chat user interface (UI).
- That prompt is sent to the back end by the interface code.
- The user intent, either question or directive, is extracted from the prompt by the back end.
- Optionally, the back end determines the data stores that hold data that's relevant to the user prompt
- The back end queries the relevant data stores.
- The back end sends the intent, the relevant grounding data, and any history provided in the prompt to the language model.
- The back end returns the result so that it can be displayed on the UI.

The back end could be implemented in any number of languages and deployed to various Azure services. This architecture uses Machine Learning prompt flow because it provides a [streamlined experience](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) to build, test, and deploy flows that orchestrate between prompts, back end data stores, and language models.

### Components

Many of the components of this architecture are the same as the resources in the [basic App Service web application architecture](../../web-apps/app-service/architectures/basic-web-app.yml) because the method that you use to host the chat UI is the same in both architectures. The components highlighted in this section focus on the components used to build and orchestrate chat flows, data services, and the services that expose the language models.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a managed cloud service that you can use to train, deploy, and manage machine learning models. This architecture uses several other features of Machine Learning that are used to develop and deploy executable flows for AI applications that are powered by language models:

  - [Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) is a development tool that you can use to build, evaluate, and deploy flows that link user prompts, actions through Python code, and calls to language learning models. Prompt flow is used in this architecture as the layer that orchestrates flows between the prompt, different data stores, and the language model. Machine Learning can directly host two types of prompt flow runtimes.

    - **Automatic runtime:** A serverless compute option that manages the lifecycle and performance characteristics of the compute and allows flow-driven customization of the environment.

    - **Compute instance runtime:** An always-on compute option in which the workload team must select the performance characteristics. This runtime offers more customization and control of the environment.

  - [Managed online endpoints](/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference) let you deploy a flow for real-time inference. In this architecture, they're used as a PaaS endpoint for the chat UI to invoke the prompt flows hosted by Machine Learning.

- [Storage](https://azure.microsoft.com/services/storage) is used to persist the prompt flow source files for prompt flow development.

- [Container Registry](https://azure.microsoft.com/services/container-registry) lets you build, store, and manage container images and artifacts in a private registry for all types of container deployments. In this architecture, flows are packaged as container images and stored in Container Registry.

- [Azure OpenAI](/azure/well-architected/service-guides/azure-openai) is a fully managed service that provides REST API access to Azure OpenAI's language models, including the GPT-4, GPT-3.5-Turbo, and embeddings set of models. In this architecture, in addition to model access, it's used to add common enterprise features such as [managed identity](/azure/ai-services/openai/how-to/managed-identity) support, and content filtering.

- [Azure AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search). AI Search is included in the architecture because it's a common service used in the flows behind chat applications. AI Search can be used to retrieve and index data that's relevant for user queries. The prompt flow implements the RAG [Retrieval Augmented Generation](/azure/search/retrieval-augmented-generation-overview) pattern to extract the appropriate query from the prompt, query AI Search, and use the results as grounding data for the Azure OpenAI model.

## Recommendations and considerations

The [components](#components) listed in this architecture link to Azure Well-Architected service guides. Service guides detail recommendations and considerations for specific services. This section extends that guidance by highlighting key Azure Well-Architected Framework recommendations and considerations that apply to this architecture. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

This *basic architecture* isn't intended for production deployments. The architecture favors simplicity and cost efficiency over functionality to allow you to evaluate and learn how to build end-to-end chat applications with Azure OpenAI. The following sections outline some deficiencies of this basic architecture, along with recommendations and considerations.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Because this architecture isn't designed for production deployments, the following outlines some of the critical reliability features that are omitted in this architecture:

- The App Service Plan is configured for the `Standard` tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. The App Service becomes unavailable in the event of any issue with the instance, the rack, or the datacenter hosting the instance.
- Autoscaling for the client user interface is not enabled in this basic architecture. To prevent reliability issues due to lack of available compute resources, you'd need to overprovision to always run with enough compute to handle max concurrent capacity.
- Azure Machine Learning compute doesn't offer support for [availability zones](/azure/reliability/availability-zones-overview). The orchestrator becomes unavailable in the event of any issue with the instance, the rack, or the datacenter hosting the instance. See the [zonal redundancy for flow deployments](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#zonal-redundancy-for-flow-deployments) in the baseline architecture to learn how to deploy the orchestration logic to infrastructure that supports availability zones.
- Azure OpenAI is not implemented in a highly available configuration. See [Azure OpenAI - reliability](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#azure-openai---reliability) in the baseline architecture to learn how to implement Azure OpenAI in a reliable manner.
- Azure AI Search is configured for the `Basic` tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. To achieve zonal redundancy, deploy AI Search with the Standard pricing tier or higher in a region that supports availability zones, and deploy three or more replicas.
- Autocaling is not implemented for the Machine Learning compute. See [machine learning reliability guidance in the baseline architecture](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#machine-learning---reliability).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This section touches on some of the key recommendations that were implemented in this architecture, including content filtering and abuse monitoring, identity and access management, and role-based access controls. Because this architecture isn't designed for production deployments, this section will cover a key security feature
While this architecture isn't designed for production deployments, network security.

#### Content filtering and abuse monitoring

Azure OpenAI includes a [content filtering system](/azure/ai-services/openai/concepts/content-filter) that uses an ensemble of classification models to detect and prevent specific categories of potentially harmful content in both input prompts and output completions. Categories for this potentially harmful content include hate, sexual, self harm, violence, profanity, and jailbreak (content designed to bypass the constraints of a language model). You can configure the strictness of what you want to filter the content for each category, with options being low, medium, or high. This reference architecture adopts a stringent approach. Adjust the settings according to your requirements.

In addition to content filtering, the Azure OpenAI implements abuse monitoring features. Abuse monitoring is an asynchronous operation designed to detect and mitigate instances of recurring content or behaviors that suggest the use of the service in a manner that might violate the [Azure OpenAI code of conduct](/legal/cognitive-services/openai/code-of-conduct). You can request an [exemption of abuse monitoring and human review](/legal/cognitive-services/openai/data-privacy#how-can-customers-get-an-exemption-from-abuse-monitoring-and-human-review) if your data is highly sensitive or if there are internal policies or applicable legal regulations that prevent the processing of data for abuse detection.

### Identity and access management

The following guidance extends the [identity and access management guidance in the App Service baseline](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#identity-and-access-management):

- Create separate managed identities for the following Machine Learning resources, where applicable:
  - Workspaces for flow authoring and management
  - Compute instances for testing flows
  - Online endpoints in the deployed flow if the flow is deployed to a managed online endpoint
- Implement identity-access controls for the chat UI by using Microsoft Entra ID

### Machine Learning role-based access roles

There are five [default roles](/azure/machine-learning/how-to-assign-roles#default-roles) that you can use to manage access to your Machine Learning workspace: AzureML Data Scientist, AzureML Compute Operator, Reader, Contributor, and Owner. Along with these default roles, there's an AzureML Learning Workspace Connection Secrets Reader and an AzureML Registry User that can grant access to workspace resources such as the workspace secrets and registry.

This architecture follows the principle of least privilege by only assigning roles to the preceding identities where they're required. Consider the following role assignments.

| Managed identity | Scope | Role assignments |
| --- | --- | --- |
| Workspace managed identity | Resource group | Contributor |
| Workspace managed identity | Workspace Storage Account | Storage Blob Data Contributor |
| Workspace managed identity | Workspace Storage Account | Storage File Data Privileged Contributor |
| Workspace managed identity | Workspace Key Vault | Key Vault Administrator |
| Workspace managed identity | Workspace Container Registry | AcrPush |
| Online endpoint managed identity | Workspace Container Registry | AcrPull |
| Online endpoint managed identity | Workspace Storage Account | Storage Blob Data Reader |
| Online endpoint managed identity | Machine Learning workspace | AzureML Workspace Connection Secrets Reader |
| Compute instance managed identity | Workspace Container Registry | AcrPull |
| Compute instance managed identity | Workspace Storage Account | Storage Blob Data Reader | 

#### Network security

In order to make it easy for you to learn how to build an end-to-end chat solution, this architecture does not implement network security. Services such as Azure AI Search, Azure OpenAI, and Azure App Service are all reachable from the internet. This adds significantly to the attack vector of the architecture. See the [networking section of the baseline architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#networking) to learn how to architect a more secure network infrastructure.