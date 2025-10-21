This article provides a basic architecture to help you learn how to run chat applications by using [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) and [Azure OpenAI in Azure AI Foundry models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#azure-openai-in-azure-ai-foundry-models). The architecture includes a client user interface (UI) that runs in Azure App Service. To fetch grounding data for the language model, the UI uses an agent hosted in Azure AI Foundry Agent Service to orchestrate the workflow from incoming prompts to data stores. The architecture is designed to operate out of a single region.

> [!IMPORTANT]
> This architecture isn't for production applications. It's an introductory architecture for learning and proof-of-concept (POC) purposes. When you design your production enterprise chat applications, use the [Baseline AI Foundry chat reference architecture](baseline-azure-ai-foundry-chat.yml), which adds production design decisions to this basic architecture.

> [!IMPORTANT]
> :::image type="icon" source="../../_images/github.svg"::: An [example implementation](https://github.com/Azure-Samples/openai-end-to-end-basic) supports this guidance. It includes deployment steps for a basic end-to-end chat implementation. You can use this implementation as a foundation for your POC to work with chat applications that use Azure AI Foundry agents.

## Architecture

:::image type="complex" source="./_images/openai-end-to-end-basic.svg" lightbox="./_images/openai-end-to-end-basic.svg" alt-text="Diagram that shows a basic end-to-end chat architecture." border= "false":::
    The diagram presents a flowchart of a basic chat application. To initiate interaction, an application user accesses a URL https://domainname.azurewebsites.net, which is labeled number 1. This request flows into an App Service instance that uses built-in authentication, which is labeled number 2. App Service has a component labeled managed identity, which indicates that the application uses managed identities for secure authentication.

    App Service points to Azure AI Foundry Agent Service, which is labeled number 3. Foundry Agent Service is in the same subsection as Azure AI Foundry project and managed identities. This subsection is in a larger section named Azure AI Foundry. The Azure AI Foundry section also contains an Azure AI Foundry account and an Azure OpenAI model. The Azure AI Foundry account has a dotted line that points to Foundry Agent Service. Foundry Agent Service points to the Azure OpenAI in Azure AI Foundry model, which is labeled number 5. An arrow points from the Azure AI Foundry project subsection to Azure AI Search, which falls outside of all sections. It's labeled number 4.

    A separate subsection called monitoring contains Application Insights and Azure Monitor. This subsection is labeled number 6.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end-basic.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. An application user interacts with a web application that contains chat functionality. They issue an HTTPS request to the App Service default domain on `azurewebsites.net`. This domain automatically points to the App Service built-in public IP address. The Transport Layer Security connection is established from the client directly to App Service. Azure fully manages the certificate.

1. The App Service feature called Easy Auth ensures that the user who accesses the website is authenticated via Microsoft Entra ID.
1. The application code deployed to App Service handles the request and renders a chat UI for the application user. The chat UI code connects to APIs that are also hosted in that same App Service instance. The API code connects to an Azure AI agent in Azure AI Foundry by using the [Azure AI Persistent Agents SDK](/dotnet/api/overview/azure/ai.agents.persistent-readme).
1. Azure AI Foundry Agent Service connects to Azure AI Search or requests up to date public knowledge to fetch grounding data for the query. The grounding data is added to the prompt that's sent to the Azure OpenAI model in the next step.
1. Foundry Agent Service connects to an Azure OpenAI model that's deployed in Azure AI Foundry and sends the prompt that includes the relevant grounding data and chat context.
1. Application Insights logs information about the original request to App Service and the call agent interactions.

### Components

Many of this architecture's components are the same as the [basic App Service web application architecture](../../web-apps/app-service/architectures/basic-web-app.yml) because the chat UI is based on that architecture. This section highlights data services, components that you can use to build and orchestrate chat flows, and services that expose language models.

- [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a platform that you use to build, test, and deploy AI solutions and models as a service (MaaS). This architecture uses Azure AI Foundry to deploy an Azure OpenAI model.

  - [Azure AI Foundry projects](/azure/ai-foundry/how-to/create-projects) establish connections to data sources, define agents, and invoke deployed models, including Azure OpenAI models. This architecture has only one Azure AI Foundry project within the Azure AI Foundry account.

  - [Foundry Agent Service](/azure/ai-foundry/agents/overview) is a capability hosted in Azure AI Foundry. You use this service to define and host agents to handle chat requests. It manages chat threads, orchestrates tool calls, enforces content safety, and integrates with identity, networking, and observability systems. In this architecture, Foundry Agent Service orchestrates the flow that fetches grounding data from an instance of AI Search and other connected knowledge sources and passes it along with the prompt to the deployed Azure OpenAI model.

    The agents defined in Foundry Agent Service are codeless and effectively nondeterministic. Your agent's system prompt, combined with `temperature` and `top_p` parameters, defines how the agent behave for requests.
  
  - [Azure AI Foundry models](/azure/ai-foundry/how-to/deploy-models-openai) allow you to deploy flagship models, including OpenAI models, from the Azure AI catalog in a Microsoft-hosted environment. This approach is considered an MaaS deployment. This architecture deploys models by using the [Global Standard](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) configuration with a fixed quota.

- [AI Search](/azure/search/search-what-is-azure-search) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/hybrid-search-overview). This architecture includes AI Search because it's commonly used in orchestrations behind chat applications. You can use AI Search to retrieve indexed data that's relevant for application user queries. AI Search serves as the knowledge store for the [Retrieval Augmented Generation](/azure/search/retrieval-augmented-generation-overview) pattern. This pattern extracts an appropriate query from a prompt, queries AI Search, and uses the results as grounding data for an Azure OpenAI model.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

This basic architecture isn't intended for production deployments. The architecture favors simplicity and cost efficiency over functionality so that you can learn how to build end-to-end chat applications by using Azure AI Foundry and Azure OpenAI. The following sections outline deficiencies of this basic architecture and describe recommendations and considerations.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The following list outlines critical reliability features that this architecture omits:

- This architecture uses the App Service Basic tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. The App Service instance becomes unavailable if there are any problems with the instance, the rack, or the datacenter that hosts the instance. As you move toward production, follow the [reliability guidance for App Service instances](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-services).

- This architecture doesn't enable autoscaling for the client UI. To prevent reliability problems because of inefficient compute resources, overprovision resources to always run with enough compute to handle maximum concurrent capacity.

- This architecture deploys Foundry Agent Service as a fully Microsoft-hosted solution. In this configuration, Microsoft hosts an Azure Cosmos DB database, an Azure Storage account container, and an AI Search index on your behalf. Your subscription doesn't show these dependent resources. You don't have any control over the reliability of Foundry Agent Service or its dependencies. For more information about bringing your own dependencies, see the [baseline architecture](baseline-azure-ai-foundry-chat.yml).

  > [!NOTE]
  > The AI Search instance in the components section and diagram is different from the instance that's a dependency of Foundry Agent Service. The instance in the components section stores your grounding data. The dependency does real-time chunking of files that are uploaded within a chat session or as part of an agent's definition.

- For a basic architecture that targets learning, you can use the Global Standard model deployment type. As you move toward production, you should have a better idea of your throughput and data residency requirements. After you understand your throughput requirements, consider using provisioned throughput by choosing a [Data Zone Provisioned](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-provisioned) or Global Provisioned deployment type. If you have data residency requirements, choose the Data Zone Provisioned deployment type.

- This architecture uses the AI Search Basic tier, which doesn't support [Azure availability zones](/azure/reliability/availability-zones-overview). To achieve zonal redundancy, deploy the AI Search Standard pricing tier or higher in a region that supports availability zones, and deploy three or more replicas.

For more information, see [Baseline AI Foundry chat reference architecture](baseline-azure-ai-foundry-chat.yml).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This section describes key recommendations that this architecture implements. These recommendations include content filtering and abuse monitoring, identity and access management, and role-based access control. This architecture isn't designed for production deployments, so this section also includes network security considerations. Network security is a key security feature that this architecture doesn't implement.

#### Content filtering and abuse monitoring

Azure AI Foundry includes a [content filtering system](/azure/ai-foundry/concepts/content-filtering) that uses a combination of classification models. This filtering detects and blocks specific categories of potentially harmful content in input prompts and output completions. This potentially harmful content includes hate, sexual content, self-harm, violence, profanity, and jailbreak (content designed to bypass language model restrictions) categories. You can configure the filtering strictness for each category by using low, medium, or high options. This reference architecture uses the `DefaultV2` content filter when deploying models. You should adjust the settings according to your requirements.

#### Identity and access management

The following guidance expands on the [identity and access management guidance](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#identity-and-access-management) in the App Service baseline architecture. The chat UI uses its managed identity to authenticate the chat UI API code to Foundry Agent Service by using the Azure AI Persistent Agents SDK.

The Azure AI Foundry project also has a managed identity. This identity authenticates to services such as AI Search through connection definitions. The project makes those connections available to Foundry Agent Service.

An Azure AI Foundry account can contain multiple Azure AI Foundry projects. Each project should use its own managed identity. If different workload components require isolated access to connected data sources, create separate Azure AI Foundry projects within the same account and avoid sharing connections across them. If your workload doesn't require isolation, use a single project.

#### Role-based access roles

You're responsible for creating the required role assignments for the managed identities. The following table summarizes the role assignment that you must add to App Service, the Azure AI Foundry project, and individuals who use the portal:

| Resource | Role | Scope |
| --- | --- | --- |
| App Service | Azure AI User | Azure AI Foundry account |
| Azure AI Foundry project | Search Index Data Reader | AI Search |
| Portal user (for each individual) | Azure AI Developer | Azure AI Foundry account |

#### Network security

To simplify the learning experience for building an end-to-end chat solution, this architecture doesn't implement network security. It uses identity as its perimeter and uses public cloud resources. Services such as AI Search, Azure AI Foundry, and App Service are reachable from the internet. This setup increases the attack surface of the architecture.

This architecture also doesn't restrict egress traffic. For example, an agent can be configured to connect to any public endpoint based on the endpoint's OpenAPI specification. So data exfiltration of private grounding data can't be prevented through network controls.

For more information about network security as an extra perimeter in your architecture, see [networking in the baseline architecture](baseline-azure-ai-foundry-chat.yml#networking).

If you want some network security during your evaluation of this solution, you should use the [network security perimeter support](/azure/ai-foundry/how-to/add-foundry-to-network-security-perimeter) on your Azure AI Foundry project. This approach provides ingress and egress control before you implement virtual network resources in your architecture. When the Foundry Agent Service is configured for standard, private deployment, the network security perimeter is replaced with Private Link connections.

#### Microsoft Defender for Cloud

For this basic architecture, you don't need to enable Microsoft Defender cloud workload protection plans for any services. When you move to production, follow the [security guidance in the baseline architecture](baseline-azure-ai-foundry-chat.yml#security) for Microsoft Defender, which uses multiple plans to cover your workload.

#### Governance through policy

This architecture doesn't implement governance through Azure Policy. As you move toward production, follow the [governance recommendations in the baseline architecture](baseline-azure-ai-foundry-chat.yml#governance-through-policy). Those recommendations add Azure Policy across your workload's components.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This basic architecture doesn't represent the costs for a production-ready solution. It also doesn't include controls to guard against cost overruns. The following considerations outline crucial features that this architecture doesn't include. These features affect cost.

- This architecture assumes that the deployed generative model receives limited calls. So we recommend that you use the Global Standard deployment type for pay-as-you-go pricing instead of a provisioned throughput deployment type. As you move toward a production solution, follow the [cost optimization guidance](baseline-azure-ai-foundry-chat.yml#cost-optimization) in the baseline architecture.

- Foundry Agent Service incurs costs for files uploaded during chat interactions. Don't make file upload functionality available to application users if it's not part of the desired user experience. Extra knowledge connections, such as the [Grounding with Bing tool](https://www.microsoft.com/bing/apis/grounding-pricing), have their own pricing structures.

  Foundry Agent Service is a no-code solution, which means that you can't deterministically control the tools or knowledge sources that each request invokes. In your cost modeling, assume maximum usage of each connection.

- This architecture uses the App Service Basic pricing tier on a single instance, which doesn't provide protection from an availability zone outage. The [baseline App Service architecture](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service) recommends that you use Premium plans that have three or more worker instances for high availability. This approach affects your costs.

- This architecture uses the AI Search Basic pricing tier with no added replicas. This topology can't withstand an Azure availability zone failure. The [baseline end-to-end chat architecture](baseline-azure-ai-foundry-chat.yml#reliability-in-ai-search-for-enterprise-knowledge) recommends that you deploy your workload with the Standard pricing tier or higher and deploy three or more replicas. This approach can affect your costs as you move toward production.

- This architecture doesn't include cost governance or containment controls. Make sure that you guard against ungoverned processes or usage that might incur high costs for pay-as-you-go services like deployed models in Azure AI Foundry.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Monitoring

This architecture configures diagnostics for all services. All services except App Service and Azure AI Foundry capture logs. App Service captures `AppServiceHTTPLogs`, `AppServiceConsoleLogs`, `AppServiceAppLogs`, and `AppServicePlatformLogs`. Azure AI Foundry captures `RequestResponse`. During the POC phase, you should understand which logs and metrics are available for collection. When you move to production, remove log sources that don't add value and only create noise and cost for your workload's log sink.

To use the monitoring capabilities in Azure AI Foundry, [connect an Application Insights resource to your Azure AI Foundry project](/azure/ai-foundry/how-to/monitor-applications#how-to-enable-monitoring).

This integration enables monitoring of the following data:

- Real-time monitoring of token usage, including prompt, completion, and total tokens
- Detailed request-response telemetry, including latency, exceptions, and response quality

You can also [trace agents by using OpenTelemetry](/azure/ai-foundry/how-to/develop/trace-agents-sdk).

#### Model operations

This architecture is optimized for learning and isn't intended for production use, so operational guidance like GenAIOps is out of scope. When you move toward production, have a plan for [Model deprecation and retirement for Azure AI Foundry Models](/azure/ai-foundry/concepts/model-lifecycle-retirement).

##### Development

For the basic architecture, you can create agents by using the browser-based experience in the Azure AI Foundry portal. When you move toward production, follow the [development and source control guidance](baseline-azure-ai-foundry-chat.yml#agent-versioning-and-life-cycle) in the baseline architecture. When you no longer need an agent, be sure to delete it. If the agent that you delete is the last one that uses a connection, also remove the connection.

##### Evaluation

You can evaluate your generative application in Azure AI Foundry. We recommend that you learn how to [use evaluators to evaluate your generative AI applications](/azure/ai-foundry/concepts/evaluation-evaluators/general-purpose-evaluators). This practice helps ensure that your chosen model meets customer and workload design requirements.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This architecture isn't designed for production deployments, so it omits critical performance efficiency features:

- Your POC results should help you choose the right App Service product for your workload. Design your workload to efficiently meet demand through horizontal scaling. You can use horizontal scaling to adjust the number of compute instances in the App Service plan. Don't design a system that requires you to change the compute product to align with demand.

- This architecture uses the consumption or pay-as-you-go model for most components. The consumption model is a best-effort model and might introduce noisy neighbor problems or other stressors on the platform. Determine whether your application requires [provisioned throughput](/azure/ai-foundry/openai/how-to/provisioned-throughput-onboarding) as you move toward production. Provisioned throughput helps reserve processing capacity for your model deployments. Reserved capacity provides predictable performance and throughput for your models.

### Other design recommendations

Architects should design AI and machine learning workloads, such as this one, with the Well-Architected Framework [AI workloads on Azure](/azure/well-architected/ai/get-started) design guidance in mind. As you move from ideation and POC into design, combine insights from this specific architecture with the broader AI and machine learning best practices in the Well-Architected Framework.

## Deploy this scenario

[Deploy a reference implementation](https://github.com/Azure-Samples/openai-end-to-end-basic/) that applies these recommendations and considerations.

## Next step

> [!div class="nextstepaction"]
> [Baseline AI Foundry chat reference architecture](baseline-azure-ai-foundry-chat.yml)

## Related resources

- [A Well-Architected Framework perspective on AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Deploy AI models in the Azure AI Foundry portal](/azure/ai-foundry/concepts/deployments-overview)
- [Explore Azure AI Foundry Models](/azure/ai-foundry/concepts/foundry-models-overview)
- [What is Azure AI Foundry Agent Service?](/azure/ai-foundry/concepts/agents-overview)
