This article provides a basic architecture to help you learn how to run chat applications with [Azure AI Foundry](/azure/ai-foundry/what-is-ai-foundry) that use [Azure OpenAI language models](/azure/ai-services/openai/concepts/models). The architecture includes a client user interface (UI) that runs in Azure App Service and uses an Azure AI Agent to orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the language model. The architecture is designed to operate out of a single region.

> [!IMPORTANT]
> This architecture isn't meant for production applications. It's intended to be an introductory architecture that you can use for learning and proof of concept (POC) purposes. When you design your production enterprise chat applications, see the [Baseline OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml), which adds production design decisions to this basic architecture.

> [!IMPORTANT]
> :::image type="icon" source="../../_images/github.svg"::: The guidance is backed by an [example implementation](https://github.com/Azure-Samples/openai-end-to-end-basic) that includes deployment steps for this basic end-to-end chat implementation. You can use this implementation as a foundation for your POC to experience working with chat applications that use Azure OpenAI.

## Architecture

:::image type="complex" source="./_images/openai-end-to-end-basic.svg" lightbox="./_images/openai-end-to-end-basic.svg" alt-text="Diagram that shows a basic end-to-end chat architecture." border= "false":::
    The diagram presents a flowchart depicting a basic chat application. At the top left, a user initiates interaction by accessing a URL: "https://domainname.azurewebsites.net," labeled with the number 1. This request flows into an App Service that uses built-in authentication, labeled as "App Service built-in authentication (Easy Auth)," labeled with the number 2. The App Service box has a component labeled "Managed Identity," indicating that the application uses managed identities for secure authentication.

    The App Service has an arrrow pointing to an Azure AI Agent Service box, labeled with the number 3. This box is inside a larger box labeled Azure AI Foundry project which also has a Managed identities box. The Azure AI Foundry project box is inside a dashed box labeled "Azure AI Foundry", along with a box labeled "Azure AI Foundry account" that has a dotted line poining to the Azure AI Agent Service box. There's an arrow from the Azure AI foundry project box that points to an Azure AI Search box that falls outside of the Azure AI Foundry dashed box, labeled with the number 4. The Azure AI Agent Service box, inside the Azure AI Foundry project, has an arrow pointing to an "Azure OpenAI model" box, labeled with the number 5. The Azure OpenAI model falls inside the Azure AI Foundry dashed box. 

    There's a box at the left of the diagram labeled "Monitoring" that includes an icon labeled "Application Insights" and an icon labeled "Azure Monitor" with the descriptor "Monitoring"
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end-basic.vsdx) of this architecture.*

### Workflow

1. An end user wants to interact with the web application that contains the chat functionality. They issue an HTTPS request to the App Service default domain on azurewebsites.net. This domain automatically points to the App Service built-in public IP address. The Transport Layer Security connection is established from the client directly to App Service. Azure completely manages the certificate.
1. Easy Auth, a feature of App Service, ensures that the user who accesses the site is authenticated by using Microsoft Entra ID.
1. The application code deployed to App Service handles the request and presents the user a chat UI. The chat UI code connects to APIs that are also hosted in that same App Service instance. The API code connects to an Azure AI Agent in Azure AI Foundry using the Azure AI Agents SDK.
1. The Azure AI Agent Service connects to Azure AI Search to fetch grounding data for the query. The grounding data is added to the prompt that is sent to the Azure OpenAI model in the next step.
1. The Azure AI Agent Service connects to an Azure OpenAI model that was deployed in Azure AI Foundry and sends the prompt that includes the relevant grounding data and chat context.
1. Information about the original request to App Service and the call agent interactions are logged in Application Insights.

### Components

Many of the components of this architecture are the same as the resources in the [basic App Service web application architecture](../../web-apps/app-service/architectures/basic-web-app.yml) because the chat UI is based on that architecture. This section highlights the components that you can use to build and orchestrate chat flows, data services, and the services that expose the language models.

- [Azure AI Foundry](/azure/ai-foundry/what-is-ai-foundry) is a platform that you use to build, test, and deploy AI solutions and models as a service (MaaS). This architecture uses AI Foundry to deploy an Azure OpenAI model and uses the Azure AI Agent Service to orchestrate the flow that fetches grounding data from our instance of Azure AI Search and passes it along with the prompt to the deployed Azure OpenAI model.

  - [Azure AI Foundry projects](/azure/ai-foundry/how-to/create-projects) allow you to establish connections to data sources, define agents, and invoke deployed models, including Azure OpenAI. In this architecture, there is only one AI Foundry project within the Azure AI Foundry account.

  - [Azure AI Agent Service](/azure/ai-services/agents/overview) is a capability hosted in Azure AI Foundry. Developers define and host agents to handle chat requests. It manages chat threads, orchestrates tool calls, enforces content safety, and integrates with identity, networking, and observability systems. In this architecture, the Azure AI Agent Service is used to orchestrate the flow that fetches grounding data from Azure AI Search and passes it to a deployed Azure OpenAI model.

    The agents defined in this feature are codeless and effectively non-deterministic. Your system prompt, combined with `temperature` and `top_p` parameters, defines how they are to behave for all requests.
  
  - [Azure AI Foundry models](/azure/ai-foundry/concepts/deployments-overview) allow you to deploy flagship models, including OpenAI models, from the Azure AI catalog in a Microsoft hosted environment. This hosting is considered a Models as a Service (MaaS) deployment. In this architecture, models are deployed using Global Standard with a fixed quota.

- [AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/hybrid-search-overview). The architecture includes AI Search because it's a common service to use in the orchestrations behind chat applications. You can use AI Search to retrieve indexed data that's relevant for user queries. This is the knowledge store for the [Retrieval Augmented Generation](/azure/search/retrieval-augmented-generation-overview) pattern to extract the appropriate query from the prompt, query AI Search, and use the results as grounding data for the Azure OpenAI model.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

This basic architecture isn't intended for production deployments. The architecture favors simplicity and cost efficiency over functionality so that you can learn how to build end-to-end chat applications by using Azure AI Foundry and Azure OpenAI. The following sections outline some deficiencies of this basic architecture and describe recommendations and considerations.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture isn't designed for production deployments, so the following list outlines some of the critical reliability features that this architecture omits:

- The app service plan is configured for the Basic tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. The app service becomes unavailable if there are any problems with the instance, the rack, or the datacenter that hosts the instance. Follow the [reliability guidance for App Service instances](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-services) as you move toward production.

- Autoscaling for the client UI isn't enabled in this basic architecture. To prevent reliability problems caused by a lack of available compute resources, you need to overprovision resources to always run with enough compute to handle maximum concurrent capacity.

- The Azure AI Agent Service is deploying in this architecture as a fully Microsoft-hosted solution. In this configuration, Microsoft hosts an Azure Cosmos DB database, an Azure Storage account container, and Azure AI Search index on your behalf. The dependent resources aren't visible to you in your subscription. You don't have any control over the reliability of the Azure AI Agent Service or its dependencies - it's the responsibility of Microsoft. If you need control of the dependencies to, for example, implement a BCDR strategy, see the [baseline architecture](./baseline-openai-e2e-chat.yml) for guidance on bringing your own dependencies.

> [!NOTE]
> The Azure AI Search instance listed in components and seen in the diagram is a different instance than the instance that is a dependency of the Azure AI Agent Service. The instance listed in components is used to store your grounding data. The dependency for Azure AI Search is used to do real-time chunking of files uploaded within a chat session.

- For a basic architecture targeting learning, using the model deployment type of `Global Standard` is fine. As you move towards production, you should have a better idea of your throughput and data residency requirements. Once you understand your throughput requirements, consider using provisioned throughput by choosing a deployment type of `Data Zone Provisioned` or `Global Provisioned`. If you have data residency requirements, choose `Data Zone Provisioned`.

- AI Search is configured for the Basic tier, which doesn't support [Azure availability zones](/azure/reliability/availability-zones-overview). To achieve zonal redundancy, deploy AI Search with the Standard pricing tier or higher in a region that supports availability zones and deploy three or more replicas.

For more information, see [Baseline Azure OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This section describes some of the key recommendations that this architecture implements. These recommendations include content filtering and abuse monitoring, identity and access management, and role-based access controls. Because this architecture isn't designed for production deployments, this section also discusses network security. Network security is a key security feature that this architecture doesn't implement.

#### Content filtering and abuse monitoring

Azure AI Foundry includes a [content filtering system](/azure/ai-foundry/concepts/content-filtering) that uses an ensemble of classification models to detect and prevent specific categories of potentially harmful content in input prompts and output completions. This potentially harmful content includes hate, sexual, self harm, violence, profanity, and jailbreak (content designed to bypass the constraints of a language model) categories. You can configure the strictness of what you want to filter from the content for each category by using the low, medium, or high options. This reference architecture uses the `DefaultV2` content filter when deploying models. Adjust the settings according to your requirements.

#### Identity and access management

The following guidance expands on the [identity and access management guidance](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#identity-and-access-management) in the App Service baseline architecture. The chat UI uses its managed identity to authenticate the chat UI API code to the Azure AI Agent Service using the Azure AI Agent SDK.

The Azure AI Foundry project also has a managed identity. That identity is used to authenticate to services such as Azure AI Search through connection definitions. The project makes those connections available to the Azure AI Agent Service to use.

An AI Foundry account can contain multiple AI Foundry projects. Each project should use distinct identities by using system managed identities. If you require different features of your workload, to have isolated access to connected data sources, create different Azure AI Foundry projects within the account and do not share connections across projects. Otherwise, using a single project is fine.

#### Role-based access roles

You're responsible for creating the required role assignments for the system-assigned managed identities. The following table summarizes the role assignment you must add to the Azure App Service, the Azure AI foundry project, and any individuals that need to use the portal:

| Resource | Role | Scope |
| --- | --- | --- |
| Azure App Service | Azure AI User | Azure AI Foundry account |
| Azure AI Foundry project | Search Index Data Reader | Azure AI Search |
| Portal user (for each) | Azure AI Developer | Azure AI Foundry account |

#### Network security

To make it easier for you to learn how to build an end-to-end chat solution, this architecture doesn't implement network security. This architecture uses identity as its perimeter and uses public cloud constructs. Services such as AI Search, Azure Foundry, and App Service are all reachable from the internet. These configurations add surface area to the attack vector of the architecture.

In addition, egress traffic is uncontrolled in this architecture. For example, an agent could be deployed connecting to any public endpoint based on the endpoint's OpenAPI specification. Data exfiltration of private grounding data would be unmitigable through network controls.

To learn how to include network as an extra perimeter in your architecture, see the [networking](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#networking) section of the baseline architecture.

#### Defender

For the basic architecture, you don't need to enable the Microsoft Defender Cloud Workload Protection (CWP) plans for any services in this architecture. When you move to production, follow the [security guidance in the baseline architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#security) for Microsoft Defender which enables multiple plans to cover your workload.

#### Governance through policy

Governance through Azure Policy is not implemented in this architecture. As you move toward production, follow the [governance recommendations in the baseline architecture](./baseline-openai-e2e-chat.yml#governance-through-policy). Those recommendations will add Azure Policy across your workload's components.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This basic architecture doesn't represent the costs for a production-ready solution. The architecture also doesn't have controls in place to guard against cost overruns. The following considerations outline some of the crucial features that affect cost and that this architecture omits:

- This architecture assumes that there are limited calls to the deployed Azure OpenAI model. For this reason, we recommend that you use the `Global Standard` deployment type for pay-as-you-go pricing instead of any of the provisioned throughput deployment types. Follow the [Azure OpenAI cost optimization guidance](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#azure-openai) in the baseline architecture as you move toward a production solution.

- Azure AI Agent Service has a cost for files uploaded as part of chat experiences. Don't make file upload functionality available to end users if it's not part of the desired user experience. If you build agents with additional knowledge connections, such as [Grounding with Bing](https://www.microsoft.com/bing/apis/grounding-pricing), those will have their own pricing structures.

  Azure AI Agent service is a no-code solution, which means you cannot deterministically control which tools or knowledge sources will be invoked on each request. In your cost modeling, assume maximum usage of each connection.

- The app service plan is configured for the Basic pricing tier on a single instance, which doesn't provide protection from an availability zone outage. The [baseline App Service architecture](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service) recommends that you use Premium plans with three or more worker instances for high availability. This approach affects your costs.

- AI Search is configured for the Basic pricing tier with no added replicas. This topology can't withstand an Azure availability zone failure. The [baseline end-to-end chat architecture](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#ai-search---reliability) recommends that you deploy the workload with the Standard pricing tier or higher and deploy three or more replicas. This approach can affect your costs as you move toward production.

- There are no cost governance or containment controls in place in this architecture. Make sure that you guard against ungoverned processes or usage that might incur high costs for pay-as-you-go services like deployed models in Azure AI Foundry.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Monitoring

Diagnostics are configured for all services. All services except App Service and Azure AI Foundry are configured to capture all logs. App Service is configured to capture `AppServiceHTTPLogs`, `AppServiceConsoleLogs`, `AppServiceAppLogs`, and `AppServicePlatformLogs` and Azure AI Foundry is configured to capture `RequestResponse`. During the POC phase, it's important to understand which logs and metrics are available for capture. When you move to production, remove log sources that don't add value and only create noise and cost for your workload's log sink.

Ensure that you [connect an Application Insights resource to your Azure AI Foundry project](/azure/ai-foundry/how-to/monitor-applications#how-to-enable-monitoring) to use the monitoring capabilities in Azure AI Foundry. This integration enables real-time monitoring of token usage—including prompt, completion, and total tokens—as well as detailed request-response telemetry, such as latency, exceptions, and response quality. You can also [trace agents using OpenTelemetry](/azure/ai-services/agents/concepts/tracing#trace-agents-using-opentelemetry-and-an-application-insights-resource).

#### Language model operations

Because this architecture is optimized for learning and isn't intended for production use, operational guidance like GenAIOps is out of scope. When you move toward production, follow the [language model operations guidance](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#language-model-operations) in the baseline architecture.

##### Development

For the basic architecture, it's fine to use the browser-based agent creation experience in the Azure AI Foundry portal. When you start moving toward production, follow the [development and source control guidance](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#development) in the baseline architecture. When you no longer need an agent, be sure to delete it. If the agent you're deleting is the last agent using a connection, remove the connection.

##### Evaluation

You can evaluate your generative application in AI Foundry. We recommend that you become familiar with how to [use evaluators to evaluate your generative AI applications](/azure/ai-foundry/concepts/evaluation-approach-gen-ai) to help ensure that the model that you choose meets customer and workload design requirements.

##### Deployment

This basic architecture implements a single instance for the deployed orchestrator. When you deploy changes, the new deployment takes the place of the existing deployment. When you start moving toward production, read the [deployment flow](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-flow) and [deployment guidance](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-guidance) in the baseline architecture. This guidance helps you understand and implement more advanced deployment approaches, such as blue-green deployments.

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Because this architecture isn't designed for production deployments, this section outlines some of the critical performance efficiency features that the architecture omits.

One outcome of your POC should be the selection of a product that suits the workload for your app service. You should design your workload to efficiently meet demand through horizontal scaling. Horizontal scaling allows you to adjust the number of compute instances that are deployed in the app service plan. Don't design a system that depends on changing the compute product to align with demand.

- This architecture uses the consumption or pay-as-you-go model for most components. The consumption model is a best-effort model and might be subject to noisy neighbor problems or other stressors on the platform. Determine whether your application requires [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) as you move toward production. Provisioned throughput helps ensure that processing capacity is reserved for your Azure OpenAI model deployments. Reserved capacity provides predictable performance and throughput for your models.

### Additional design recommendations

AI/ML workloads, such as this one, should be designed by an architect that understands the design guidance found in the Azure Well-Architected Framework's [AI workloads on Azure](/azure/well-architected/ai/get-started). As you move from ideation and proof of technology into design, be sure to combine both the specifics of the learnings you have from this architecture and the general AI/ML workload guidance found in the Well-Architected Framework.

## Deploy this scenario

A deployment for a reference architecture that implements these recommendations and considerations is available on [GitHub](https://github.com/Azure-Samples/openai-end-to-end-basic/).

## Next step

> [!div class="nextstepaction"]
> [Baseline Azure OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml)

## Related resources

- A Well-Architected Framework perspective on [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Deploy AI models in Azure AI Foundry portal](/azure/ai-foundry/concepts/deployments-overview)
- [Explore Azure AI Foundry Models](/azure/ai-foundry/concepts/foundry-models-overview)
- [What is Azure AI Foundry Agent Service?](/azure/ai-services/agents/overview)
