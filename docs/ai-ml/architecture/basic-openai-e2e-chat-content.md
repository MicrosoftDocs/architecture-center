This article provides a basic architecture intended for learning about running chat applications that use [Azure OpenAI Service language models](/azure/ai-services/openai/concepts/models). The architecture includes a client user interface running in Azure App Service and uses Azure Machine Learning prompt flow to orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the language model. The executable flow is deployed to a managed online endpoint with managed compute.  The architecture is designed to operate out of a single region.

> [!IMPORTANT]
> This architecture isn't meant to be used for production applications. It's intended to be an introductory architecture you can use for learning and proof of concept (POC) purposes. When designing your production enterprise chat applications, see the [Baseline OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml), which extends this basic architecture with additional production design decisions.

> [!IMPORTANT]
> :::image type="icon" source="../../_images/github.svg"::: The guidance is backed by an [example implementation](https://github.com/Azure-Samples/openai-end-to-end-basic) which includes deployments steps for this basic end-to-end chat implementation. This implementation can be used as a basis for your POC to experience working with chat applications that use Azure OpenAI.

## Architecture

:::image type="complex" source="./_images/openai-end-to-end-basic.svg" lightbox="./_images/openai-end-to-end-basic.png" alt-text="Diagram that shows a basic end-to-end chat architecture.":::
    The diagram shows an Azure App Service connecting directly to an Azure Machine Learning managed online endpoint that is sitting in front of compute instances. There's an arrow from the compute instances to Azure AI Search and an arrow pointing to Azure OpenAI Service. The diagram also shows Azure App Insights and Azure Monitor, Azure Key Vault, Azure Container Registry, and Azure Storage.
:::image-end:::
*Figure 1: Basic end-to-end chat architecture with Azure OpenAI*

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end-basic.vsdx) of this architecture.*

### Workflow

1. A user issues an HTTPS request to the App Service's default domain on azurewebsites.net. This domain automatically points to the App Service's built-in public IP. The transport layer security (TLS) connection is established from the client directly to app service. The certificate is managed completely by Azure.
1. Easy Auth, a feature of Azure App Service, ensures that the user accessing the site is authenticated with Microsoft Entra ID.
1. The client application code deployed to App Service handles the request and presents the user a chat UI. The chat UI code connects to APIs also hosted in that same App Service instance. The API code connects to an Azure Machine Learning managed online endpoint to handle user interactions.
1. The managed online endpoint routes the request to an Azure Machine Learning compute instance where the Azure Machine Learning prompt flow orchestration logic is deployed.
1. The Azure Machine Learning prompt flow orchestration code begins executing. Among other things, the logic extracts the user's query from the request.
1. The orchestration logic connects to Azure AI Search to fetch grounding data for the query. The grounding data is added to the prompt that will be sent to Azure OpenAI in the next step.
1. The orchestration logic connects to Azure OpenAI and sends the prompt that includes the relevant grounding data.
1. The information about original request to App Service and the call to the managed online endpoint are logged in Application Insights, using the same Log Analytics workspace that Azure OpenAI telemetry flows to.

### Machine Learning prompt flow

While the workflow includes the flow for the chat application, the following list outlines a typical prompt flow in a more detail.

> [!NOTE]
> The numbers in this flow do not correspond to the numbers in the architecture diagram.

1. The user enters a prompt in a custom chat user interface (UI).
1. The interface's API code sends that text to prompt flow.
1. Prompt flow extracts the user intent, either a question or directive, from the prompt.
1. Optionally, prompt flow determines the data store(s) that hold data that's relevant to the user prompt.
1. Prompt flow queries the relevant data stores.
1. Prompt flow sends the intent, the relevant grounding data, and any history provided in the prompt to the language model.
1. Prompt flow returns the result so that it can be displayed on the UI.

The flow orchestrator could be implemented in any number of languages and deployed to various Azure services. This architecture uses Machine Learning prompt flow because it provides a [streamlined experience](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) to build, test, and deploy flows that orchestrate between prompts, back end data stores, and language models.

### Components

Many of the components of this architecture are the same as the resources in the [basic App Service web application architecture](../../web-apps/app-service/architectures/basic-web-app.yml) because the chat UI is based on that architecture. The components highlighted in this section focus on the components used to build and orchestrate chat flows, data services, and the services that expose the language models.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a managed cloud service that you can use to train, deploy, and manage machine learning models. This architecture uses several other features of Machine Learning that are used to develop and deploy executable flows for AI applications that are powered by language models:

  - [Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) is a development tool that you can use to build, evaluate, and deploy flows that link user prompts, actions through Python code, and calls to language learning models. Prompt flow is used in this architecture as the layer that orchestrates flows between the prompt, different data stores, and the language model. Machine Learning can directly host two types of prompt flow runtimes.

    - **Automatic runtime:** A serverless compute option that manages the lifecycle and performance characteristics of the compute and allows flow-driven customization of the environment. This architecture uses the automatic runtime for simplicity.

    - **Compute instance runtime:** An always-on compute option in which the workload team must select the performance characteristics. This runtime offers more customization and control of the environment.

  - [Managed online endpoints](/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference) let you deploy a flow for real-time inferencing. In this architecture, they're used as a PaaS endpoint for the chat UI to invoke the prompt flows hosted by the Machine Learning automatic runtime.

- [Storage](https://azure.microsoft.com/services/storage) is used to persist the prompt flow source files for prompt flow development.

- [Container Registry](https://azure.microsoft.com/services/container-registry) lets you build, store, and manage container images and artifacts in a private registry for all types of container deployments. In this architecture, flows are packaged as container images and stored in Container Registry.

- [Azure OpenAI](/azure/well-architected/service-guides/azure-openai) is a fully managed service that provides REST API access to Azure OpenAI's language models, including the GPT-4, GPT-3.5-Turbo, and embeddings set of models. In this architecture, in addition to model access, it's used to add common enterprise features such as [managed identity](/azure/ai-services/openai/how-to/managed-identity) support, and content filtering.

- [Azure AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search). AI Search is included in the architecture because it's a common service used in the flows behind chat applications. AI Search can be used to retrieve and index data that's relevant for user queries. The prompt flow implements the RAG [Retrieval Augmented Generation](/azure/search/retrieval-augmented-generation-overview) pattern to extract the appropriate query from the prompt, query AI Search, and use the results as grounding data for the Azure OpenAI model.

## Recommendations and considerations

The [components](#components) listed in this architecture link to Azure Well-Architected service guides where they exist. Service guides detail recommendations and considerations for specific services. This section extends that guidance by highlighting key Azure Well-Architected Framework recommendations and considerations that apply to this architecture. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

This _basic_ architecture isn't intended for production deployments. The architecture favors simplicity and cost efficiency over functionality to allow you to evaluate and learn how to build end-to-end chat applications with Azure OpenAI. The following sections outline some deficiencies of this basic architecture, along with recommendations and considerations.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Because this architecture isn't designed for production deployments, the following outlines some of the critical reliability features that are omitted in this architecture:

- The App Service Plan is configured for the `Standard` tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. The App Service becomes unavailable in the event of any issue with the instance, the rack, or the datacenter hosting the instance. As you move toward production, follow guidance in the [reliability section of the baseline highly available zone-redundant web application](https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-services).
- Autoscaling for the client user interface isn't enabled in this basic architecture. To prevent reliability issues due to lack of available compute resources, you'd need to overprovision to always run with enough compute to handle max concurrent capacity.
- Azure Machine Learning compute doesn't offer support for [availability zones](/azure/reliability/availability-zones-overview). The orchestrator becomes unavailable in the event of any issue with the instance, the rack, or the datacenter hosting the instance. See the [zonal redundancy for flow deployments](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#zonal-redundancy-for-flow-deployments) in the baseline architecture to learn how to deploy the orchestration logic to infrastructure that supports availability zones.
- Azure OpenAI isn't implemented in a highly available configuration. To learn how to implement Azure OpenAI in a reliable manner, see [Azure OpenAI - reliability](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#azure-openai---reliability) in the baseline architecture.
- Azure AI Search is configured for the `Basic` tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. To achieve zonal redundancy, deploy AI Search with the Standard pricing tier or higher in a region that supports availability zones, and deploy three or more replicas.
- Autoscaling isn't implemented for the Machine Learning compute. See [machine learning reliability guidance in the baseline architecture](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#machine-learning---reliability).

These reliability concerns are addressed in the [Baseline Azure OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml) design.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This section touches on some of the key recommendations implemented in this architecture. These recommendations include content filtering and abuse monitoring, identity and access management, and role-based access controls. Because this architecture isn't designed for production deployments, this section discusses a key security feature that wasn't implemented in this architecture, network security.

#### Content filtering and abuse monitoring

Azure OpenAI includes a [content filtering system](/azure/ai-services/openai/concepts/content-filter) that uses an ensemble of classification models to detect and prevent specific categories of potentially harmful content in both input prompts and output completions. Categories for this potentially harmful content include hate, sexual, self harm, violence, profanity, and jailbreak (content designed to bypass the constraints of a language model). You can configure the strictness of what you want to filter from the content for each category, with options being low, medium, or high. This reference architecture adopts a stringent approach. Adjust the settings according to your requirements.

In addition to content filtering, the Azure OpenAI implements abuse monitoring features. Abuse monitoring is an asynchronous operation that detects and mitigates instances of recurring content or behaviors that suggest the use of the service in a manner that might violate the [Azure OpenAI code of conduct](/legal/cognitive-services/openai/code-of-conduct). You can request an [exemption of abuse monitoring and human review](/legal/cognitive-services/openai/data-privacy#how-can-customers-get-an-exemption-from-abuse-monitoring-and-human-review) if your data is highly sensitive or if there are internal policies or applicable legal regulations that prevent the processing of data for abuse detection.

### Identity and access management

The following guidance extends the [identity and access management guidance in the App Service baseline](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#identity-and-access-management):

- Create separate managed identities for the following Machine Learning resources, where applicable:
  - Workspaces for flow authoring and management
  - Compute instances for testing flows
  - Online endpoints in the deployed flow if the flow is deployed to a managed online endpoint
- Implement identity-access controls for the chat UI by using Microsoft Entra ID

### Machine Learning role-based access roles

There are five [default roles](/azure/machine-learning/how-to-assign-roles#default-roles) that you can use to manage access to your Machine Learning workspace: AzureML Data Scientist, AzureML Compute Operator, Reader, Contributor, and Owner. Along with these default roles, there's an Azure Machine Learning Workspace Connection Secrets Reader and an AzureML Registry User that can grant access to workspace resources such as the workspace secrets and registry.

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

In order to make it easy for you to learn how to build an end-to-end chat solution, this architecture doesn't implement network security. This architecture uses identity as its perimeter and uses public cloud constructs. Services such as Azure AI Search, Azure OpenAI, and Azure App Service are all reachable from the internet. This adds surface area to the attack vector of the architecture. To learn how to include network as an additional perimeter in your architecture, see the [networking section of the baseline architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#networking).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This _basic_ architecture is designed to allow you to evaluate and learn how to build end-to-end chat applications with Azure OpenAI. The architecture doesn't represent the costs for a production ready solution. Further, the architecture doesn't have controls in place to guard against cost overruns. The following outline some of the critical features that are omitted in this architecture that impact cost:

- This architecture assumes that there are limited calls to Azure OpenAI. For this reason, we suggest you use pay-as-you-go pricing and not provisioned throughput. As you move toward a production solution, follow the [Azure OpenAI cost optimization guidance in the baseline architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#azure-openai).

- The App Service plan is configured for the Standard pricing tier on a single instance, which doesn't offer protection from an Availability Zone outage. The [baseline App Service architecture](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service) recommends you use Standard or Premium plans with three or more worker instances for high availability which will impact your cost.

- Scaling isn't configured for the managed online endpoint managed compute. For production deployments, you should configure auto scaling. Further, the [baseline end-to-end chat architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#zonal-redundancy-for-flow-deployments) recommends deploying to Azure App Service in a zonal redundant configuration. Both of these architectural changes affect your cost when moving to production.

- Azure AI Search is configured for the Basic pricing tier with no added replicas. This topology could not withstand an Azure availability zone failure. The [baseline end-to-end chat architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#ai-search---reliability) recommends you deploy with the Standard pricing tier or higher and deploy three or more replicas, which impact your cost as you move toward production.

- There are no cost governance or containment controls in place in this architecture. Make sure you guard against ungoverned processes or usage that could incur high costs for pay-as-you-go services like Azure OpenAI.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Machine Learning - built-in prompt flow runtimes

To minimize operational burdens, this architecture uses the **Automatic Runtime**, a serverless compute option within Machine Learning that simplifies compute management and delegates most of the prompt flow configuration to the running application's `requirements.txt` file and `flow.dag.yaml` configuration. The automatic runtime is low maintenance, ephemeral, and application-driven.

#### Monitoring

Diagnostics are configured for all services. All services but Machine Learning and App Service are configured to capture all logs. The Machine Learning diagnostics are configured to capture the audit logs that are all resource logs that record customer interactions with data or the settings of the service. App Service is configured to capture AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs, and AppServicePlatformLogs. During the proof of concept phase, it's important to get an understanding of what logs and metrics are available to be captured. When you move to production, you should eliminate log sources that are not adding value and are adding noise and cost to your workload's log sink.

#### Language model operations

Because this architecture is optimized for learning and isn't intended for production use, operational guidance such as GenAIOps is out of scope. When you do move toward production, follow the [language model operations guidance in the baseline architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#language-model-operations).

##### Development

Machine Learning prompt flow offers both a browser-based authoring experience in Machine Learning studio or through a [Visual Studio Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension). Both options store the flow code as files. When you use Machine Learning studio, the files are stored in a Storage account. When you work in Microsoft Visual Studio Code, the files are stored in your local file system.

Because this architecture is meant for learning, it's fine to use the browser-based authoring experience. As you start moving toward production, follow the [guidance in the baseline architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#development) around development and source control best practices.

##### Evaluation

Evaluation of how your Azure OpenAI model deployment can be conducted through a user experience in Azure AI studio. Microsoft suggests becoming familiar with the how to [evaluate of generative AI applications](/azure/ai-studio/concepts/evaluation-approach-gen-ai) to ensure your model selection is meeting user and workload design requirements.

One important evaluation tool to familiarize yourself with in your workload development phases is the [Responsible AI dashboards in Azure Machine Learning](/azure/machine-learning/how-to-responsible-ai-dashboard?view=azureml-api-2). This tool will help you evaluate the fairness, model interpretability, and other key assessments of your deployments and is useful in establishing an early baseline to prevent future regressions.

##### Deployment

This _basic_ architecture implements a single instance for the deployed orchestrator. When you deploy changes, the new deployment takes the place of the existing deployment. When you start moving toward production, read the [deployment flow](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-flow) and [deployment guidance](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-guidance) in the baseline architecture for guidance on understanding and implementing more advanced deployment approaches such as blue/green deployments.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Because this architecture isn't designed for production deployments, the following outlines some of the critical performance efficiency features that were omitted in this architecture, along with other recommendations and considerations.

An outcome of your proof of concept should be SKU selection that you estimate is suitable for your workload for both your App Service and your Azure Machine Learning compute. You should design your workload to efficiently meet demand through horizontal scaling. Horizontal scaling allows you to adjust the number of compute instances that are deployed in the App Service Plan and instances deployed behind the online endpoint. Don't design the system to depend on changing the compute SKU to align with demand.

- This architecture uses the consumption or pay-as-you-go model for most components. The consumption model is best-effort and might be subject to noisy neighbor or other stressors on the platform. As you move toward production, you should determine whether your application requires [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) which ensures reserved processing capacity for your Azure OpenAI model deployments. Reserved capacity provides predictable performance and throughput for your models.

- The Azure Machine Learning online endpoint doesn't have automatic scaling implemented so you'd need to provision a SKU and instance quantity that can handle peak load. The service, as configured, doesn't dynamically scale in to efficiently keep supply aligned with demand. As you move toward production, follow the guidance about how to [autoscale an online endpoint](/azure/machine-learning/how-to-autoscale-endpoints).

## Deploy this scenario

To deploy and run the reference implementation, follow the steps in the [Azure OpenAI end-to-end basic reference implementation](https://github.com/Azure-Samples/openai-end-to-end-basic/).

## Next step

> [!div class="nextstepaction"]
> [Baseline OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml)

## Related resources

- [Azure OpenAI language models](/azure/ai-services/openai/concepts/models)
- [Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow)
- [Workspace managed virtual network isolation](/azure/machine-learning/how-to-managed-network)
- [Configure a private endpoint for a Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link)
- [Content filtering](/azure/ai-services/openai/concepts/content-filter)
