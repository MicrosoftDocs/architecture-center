Enterprise chat applications have the ability to empower employees through conversational interaction. This is especially true due to the continuous advancement of large language models such as OpenAI's GPT models and Meta's LLaMA models. These chat applications consist of a user interface for chatting, data repositories containing domain-specific information pertinent to the user's queries, large language models (LLMs) that reason over the domain-specific data to produce a relevant response, and an orchestrator that oversees the interaction between these components.

This article provides a baseline architecture for building and deploying enterprise chat applications that use [Azure OpenAI large language models](/azure/ai-services/openai/concepts/models). The architecture employs Azure Machine Learning (AML) prompt flow to create executable flows that orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the LLMs, along with any other Python logic required. The executable flow is deployed to an Azure Machine Learning compute cluster behind a managed online endpoint.

The hosting of the custom chat user interface (UI) follows the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) guidance for deploying a secure, zone-redundant, and highly available web application on Azure App Services. In that architecture the App Service communicates to Azure PaaS services through virtual network integration over private endpoints. Likewise, the chat UI App Service communicates with the managed online endpoint for the flow over a private endpoint and public access to the Azure Machine Learning workspace is disabled.

> [!IMPORTANT]
> The article doesn't cover the components or architecture decisions from the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). Please read that article for architectural guidance for hosting the chat UI.

The Machine Learning workspace is configured with [managed virtual network isolation](/azure/machine-learning/how-to-managed-network) that requires all outbound connections to be approved. With this configuration, a managed virtual network is created, along with managed private endpoints that enable connectivity to private resources such as the workplace Azure Storage, Azure Container Registry, and Azure OpenAI. These private connections are used during flow authoring and testing, and by flows deployed to Azure Machine Learning compute.

> [!TIP]
> ![GitHub logo](../../_images/github.svg) This article is backed by a [reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline) which showcases a baseline end-to-end chat implementation on Azure. This implementation can be used as a basis for custom solution development in your first step towards production.

## Architecture

:::image type="complex" source="_images/openai-end-to-end-aml-deployment.svg" lightbox="_images/openai-end-to-end-aml-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI.":::
    The diagram shows the App Service baseline architecture with a private endpoint connecting to a managed online endpoint in an Azure Machine Learning managed virtual network. The managed online endpoint sits in front of an Azure Machine Learning compute cluster. The diagram show that the machine learning workspace has a dotted line pointing to the compute cluster, representing that the executable flow is deployed to the compute cluster. The managed virtual network uses managed private endpoints that provide private connectivity to resources required by the executable flow such as the Azure Container Registry and Azure Storage. the diagram further shows user-defined private endpoints providing private connectivity to the Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 1: Baseline end-to-end chat architecture with OpenAI*

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end.vsdx) of this architecture.*

## Components

Many of the components of this architecture are the same as the resources in the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml), as the chat UI hosting in this architecture follows the baseline App Service web application's architecture. The components highlighted in this section focus on the components used to build and orchestrate chat flows, and data services and the services that expose the LLMs.

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a managed cloud service that's used to train, deploy, and manage machine learning models. This architecture uses several other features of Azure Machine Learning used to develop and deploy executable flows for AI applications powered by Large Language Models:
  - [Azure Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) is a development tool that allows you to build, evaluate, and deploy flows that link user prompts, actions through Python code, and calls to LLMs. Prompt flow is used in this architecture as the layer that orchestrates flows between the prompt, different data stores, and the LLM.
  - [Managed online endpoints](/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference) allow you to deploy a flow for real-time inference. In this architecture, they're used to as a PaaS endpoint for the chat UI to invoke the prompt flows hosted by Azure Machine Learning.
- [Azure Storage](https://azure.microsoft.com/services/storage) is used to persist the prompt flow source files for prompt flow development.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) enables you to build, store, and manage container images and artifacts in a private registry for all types of container deployments. In this architecture, flows are packaged as container images and stored in Azure Container Registry.
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) is a fully managed service that provides REST API access to Azure OpenAI's large language models, including the GPT-4, GPT-3.5-Turbo, and Embeddings set of models. In this architecture, in addition to model access, it's used to add common enterprise features such as [virtual network and private link](/azure/ai-services/cognitive-services-virtual-networks), [managed identity](/azure/ai-services/openai/how-to/managed-identity) support, and content filtering.
- [Azure AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search). Azure AI Search is included in the architecture as It's a common service used in the flows behind chat applications. Azure AI Search can be used to retrieve and index data that is relevant for user queries. The prompt flow implements the RAG pattern [Retrieval Augmented Generation](/azure/search/retrieval-augmented-generation-overview) to extract the appropriate query from the prompt, query AI Search, and use the results as grounding data for the Azure OpenAI model.

### Azure Machine Learning prompt flow

The back end for enterprise chat applications generally follows a pattern similar to the following flow:

- The user enters a prompt in a custom chat user interface (UI)
- That prompt is sent to the back end by the interface code
- The user intent (question or directive) is extracted from the prompt by the back end
- (optional) The back end determines the data store(s) that holds data that is relevant to the user prompt
- The back end queries the relevant data store(s)
- The back end sends the intent, the relevant grounding data, and any history provided in the prompt to the LLM.
- The back end returns the result to so that it can be displayed on the user interface

The back end could be implemented in any number of languages and deployed to various Azure services. In this architecture, Azure Machine Learning prompt flow was chosen because it provides a [streamlined experience](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) to build, test, and deploy flows that orchestrate between prompts, back end data stores, and LLMs.

## Networking

Along with identity-based access, network security is at the core of the baseline end-to-end chat architecture using OpenAI. From a high level, the network architecture ensures the following:

- A single secure entry point for chat UI traffic
- Network traffic is filtered
- Data in transit is encrypted end-to-end with TLS
- Data exfiltration is minimized by keeping traffic in Azure by using Private Link
- Network resources are logically grouped and isolated from each other through network segmentation

### Network flows

:::image type="complex" source="_images/openai-end-to-end-aml-deployment-flows.svg" lightbox="_images/openai-end-to-end-aml-deployment-flows.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI with flow numbers.":::
    The diagram resembles the baseline end-to-end chat architecture with Azure OpenAI architecture with three numbered network flows. The inbound flow and the flow from App Service to Azure PaaS services are duplicated from the Baseline Azure App Service web architecture. The Azure Machine Learning managed online endpoint flow shows an arrow from the Compute Instance private endpoint in the client UI virtual network pointing to the managed online endpoint. The second number shows an arrow pointed from the managed online endpoint to the compute cluster. The third shows arrows from the compute cluster to private endpoints that point to the Azure Container Registry, Azure Storage, Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 2: Network flows for the baseline end-to-end chat architecture with OpenAI*

Two flows in this diagram are covered in [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml): 1. the inbound flow from the end user to the chat UI and 2. the App Service to [Azure PaaS services flow](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#app-service-to-azure-paas-services-flow). See that article for details on those flows. This section focuses on the Azure Machine Learning online endpoint flow. The following details the flow from the chat UI running in the baseline App Service web application to the flow deployed to Azure Machine Learning compute:

1. The call from the App Service hosted chat UI is routed through a private endpoint to the Azure Machine Learning online endpoint.
1. The online endpoint routes the call to a server running the deployed flow. The online endpoint acts as both a load balancer, and a router.
1. Calls to Azure PaaS services required by the deployed flow are routed through managed private endpoints.

### Ingress to Azure Machine Learning

In this architecture, public access to the Azure Machine Learning workspace is disabled and access can occur through private access as it follows the [private endpoint for the Azure Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link) configuration. In fact, private endpoints are used throughout this architecture to complement identity-based security. For example, by allowing your chat UI hosted in App Service to connect to PaaS services not exposed to the public Internet, including Azure Machine Learning endpoints.

Private endpoint access is also required for connecting to the Azure Machine Learning workspace for flow authoring.

:::image type="complex" source="_images/openai-end-to-end-aml-flow-authoring.svg" lightbox="_images/openai-end-to-end-aml-flow-authoring.svg" alt-text="Diagram that shows a user connecting to an Azure Machine Learning workspace through a jump box to author a flow OpenAI with flow numbers.":::
    The diagram shows a user connecting to a jump box virtual machine through Azure Bastion. There's an arrow from the jump box to an Azure Machine Learning workspace private endpoint. There's another arrow from the private endpoint to the Azure Machine Learning workspace. From the workspace, there are four arrows pointed to four private endpoints that connect to Azure Container Registry, Azure Storage, Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 3: Network flows for an Azure Machine Learning prompt flow author*

The diagram shows a prompt flow author connecting through Azure Bastion to a virtual machine jump box. From that jump box, the author can connect to the Machine Learning Workspace through a private endpoint in the same network as the jump box. Connectivity to the virtual network could also be accomplished through ExpressRoute or VPN gateways and virtual network peering.

### Flow from the Azure Machine Learning managed virtual network to Azure PaaS services

It's recommended that the Azure Machine Learning workspace is configured for [managed virtual network isolation](/azure/machine-learning/how-to-managed-network) with a configuration that requires all outbound connections to be approved. This architecture follows that recommendation. There are two types of approved outbound rules. *Required outbound rules* are to resources required for the solution to work, such as Azure Container Registry and Azure Storage. *User-defined outbound rules* are to custom resources, such as Azure OpenAI or Azure AI Search, that your workflow is going to use. It's your responsibility to configure user-defined outbound rules, while required outbound rules are configured when the managed virtual network is created.

The outbound rules can be private endpoints, service tags, or FQDNs for external public endpoints. In this architecture, connectivity to Azure services such as Azure Container Registry, Azure Storage, Azure Key Vault, Azure OpenAI service, and Azure AI Search are connected through private link. Although not in this architecture, some common operations that might require configuring an FQDN outbound rule are downloading a pip package, cloning a GitHub repo, downloading base container images from external repositories.

### Virtual network segmentation and security

The network in this architecture has separate subnets for the following:

- Application Gateway
- App Service integration components
- Private endpoints
- Azure Bastion
- Jump box virtual machine
- Training - not used for model training in this architecture
- Scoring

Each subnet has a network security group that limits both inbound and outbound traffic for those subnets to just what is required. The following table shows a simplified view of the NSG rules the baseline adds to each subnet. The table gives the rule name and function.

| Subnet   | Inbound | Outbound |
| -------  | ---- | ---- |
| snet-appGateway    | Allowances for our chat UI users source IPs (such as public internet), plus required items for the service | Access to the Azure App Service private endpoint, plus required items for the service. |
| snet-PrivateEndpoints | Allow only traffic from the virtual network. | Allow only traffic to the virtual network.
| snet-AppService | Allow only traffic from the virtual network. | Allow access to the private endpoints and Azure Monitor. |
| AzureBastionSubnet | See guidance in [working with NSG access and Azure Bastion](/azure/bastion/bastion-nsg) | See guidance in [working with NSG access and Azure Bastion](/azure/bastion/bastion-nsg) |
| snet-jumpbox |  Allow inbound RDP and SSH from the Bastion Host subnet. | Allow access to the private endpoints |
| snet-agents | Allow only traffic from the virtual network. | Allow only traffic to the virtual network.
| snet-training | Allow only traffic from the virtual network. | Allow only traffic to the virtual network.
| snet-scoring | Allow only traffic from the virtual network. | Allow only traffic to the virtual network.

All other traffic is explicitly denied.

Consider the following points when implementing virtual network segmentation and security.

- Enable [DDoS protection](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa7aca53f-2ed4-4466-a25e-0b45ade68efd) for the virtual network with a subnet that is part of an application gateway with a public IP.
- [Add an NSG](/azure/virtual-network/network-security-groups-overview) to every subnet where possible. You should use the strictest rules that enable full solution functionality.
- Use [application security groups](/azure/virtual-network/tutorial-filter-network-traffic#create-application-security-groups). Application security groups allow you to group NSGs, making rule creation easier for complex environments.

## Content filtering and abuse monitoring

Azure OpenAI service includes a [content filtering system](/azure/ai-services/openai/concepts/content-filter) that uses an ensemble of classification models to detect and prevent specific categories of potentially harmful content in both input prompts and output completions. Categories for this potentially harmful content include hate, sexual, self harm, violence, profanity, and jailbreak (content designed to bypass the constraints of an LLM). You can configure the strictness of what you want to filter the content for each category, with options being low, medium, or high. This reference architecture adopts a stringent approach. You should adjust the settings according to your requirements.

In addition to content filtering, the Azure OpenAI service implements abuse monitoring features. Abuse monitoring is an asynchronous operation designed to detect and mitigate instances of recurring content and/or behaviors that suggest use of the service in a manner that may violate the [Azure OpenAI code of conduct](/legal/cognitive-services/openai/code-of-conduct). You can request an [exemption of abuse monitoring and human review](/legal/cognitive-services/openai/data-privacy#how-can-customers-get-an-exemption-from-abuse-monitoring-and-human-review) for example if your data is highly sensitive or if there are internal policies or applicable legal regulations that prevent the processing of data for abuse detection.

## Reliability

The [baseline App Service web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) architecture focuses on zonal redundancy for key regional services. Availability zones are physically separate locations within a region. They provide redundancy within a region for supporting services when two or more instances are deployed in across them. When one zone experiences downtime, the other zones within the region may still be unaffected. The architecture also ensures enough instances of Azure services and configuration of those services to be spread across availability zones. Please see the [baseline](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) to review that guidance.

This section addresses reliability from the perspective of the components in this architecture not addressed in the App Service baseline, including Azure Machine Learning, Azure OpenAI, and Azure AI Search.

### Zonal redundancy for flow deployments

Enterprise deployments usually require at least zonal redundancy. To achieve this in Azure, resources must support [availability zones](/azure/availability-zones/az-overview) and you must deploy at least the instances of the resource or enable the platform support when instance control isn't available. Currently, Azure Machine Learning compute doesn't offer support for availability zones. To mitigate the potential impact of a datacenter-level catastrophe on AML components, it's necessary to establish clusters in various regions along with deploying a load balancer to distribute calls among these clusters. You would use health checks to help ensure that calls are only routed to clusters that are functioning properly.

Deploying prompt flows isn't limited to Azure Machine Learning compute clusters. The executable flow, being a containerized application, can be deployed to any Azure service that is compatible with containers. These options include services like Azure Kubernetes Service (AKS), Azure Functions, Azure Container Apps (ACA), and Azure App Service. Each of those services support availability zones. To achieve zonal redundancy for prompt flow execution, without the added complexity of a multi-region deployment, you should deploy your flows to one of those services.

The following is an alternate architecture where prompt flows are deployed to Azure App Service. App Service is used in this architecture because the workload already uses it for the chat UI and wouldn't benefit from introducing a new technology into the workload. Workload teams who have experience with AKS should consider deploying in that environment, especially if AKS is being used for other components in the workload.

:::image type="complex" source="_images/openai-end-to-end-app-service-deployment.svg" lightbox="_images/openai-end-to-end-app-service-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI with prompt flow deployed to Azure App Service.":::
    The diagram shows the App Service baseline architecture with 3 instances of a client App Service and 3 instances of a prompt flow app service. In addition to what is in the app service baseline architecture, this architecture includes private endpoints for Azure Container Registry, Azure AI Search, and Azure OpenAI. The architecture also shows an Azure Machine Learning workspace, used for authoring flows, running in a managed virtual network. The managed virtual network uses managed private endpoints that provide private connectivity to resources required by the executable flow such as the Azure  Storage. The diagram further shows user-defined private endpoints providing private connectivity to the Azure OpenAI service and Azure AI Search. Lastly, there's a dotted line from the Machine Learning Workspace to the Azure Container Registry (ACR) which indicates that executable flows are deployed to ACR, where the prompt flow App Service can load it.
:::image-end:::
*Figure 4: Alternate end-to-end chat architecture with OpenAI deploying prompt flows to Azure App Services*

The diagram is numbered for areas that are noteworthy in this architecture:

1. Flows are still authored in Azure Machine Learning prompt flow and the Azure Machine Learning network architecture is unchanged. Flow authors still connect to the workspace authoring experience through a private endpoint and the managed private endpoints are used to connect to Azure services when testing flows.
1. This dotted line indicates that containerized executable flows are pushed to Azure Container Registry (ACR). Not shown in the diagram are the pipelines that containerize the flows and push to ACR.
1. There's another Web App deployed to the same App Service plan that is already hosting the chat UI. The new Web App hosts the containerized prompt flow, colocated on the same App Service plan that already runs at a minimum of three instances, spread across availability zones.  These App Service instances connect to ACR over a private endpoint when loading the prompt flow container image.
1. The prompt flow container needs to connect to all dependent services for flow execution. In this architecture that would be to Azure AI Search and Azure OpenAI service. PaaS services that were exposed only to the AML managed private endpoint subnet now also need to be exposed in the virtual network so line of sight can be established from App Service.

### Azure OpenAI - reliability

Azure OpenAI doesn't currently support availability zones. To mitigate the potential impact of a datacenter-level catastrophe on model deployments in Azure OpenAI, it's necessary to deploy Azure OpenAI to various regions along with deploying a load balancer to distribute calls among the regions. You would use health checks to help ensure that calls are only routed to clusters that are functioning properly.

In order to support multiple instances effectively, we recommend that you externalize fine-tuning files, such as to a geo-redundant Azure Storage account. This will minimize the state stored in the Azure OpenAI service per region. Fine-tuning will still need to be done per instance in order to host the model deployment.

It's important to monitor the required throughput in terms of Tokens per Minute (TPM) and Requests per Minute (RPM) to ensure you have assigned enough TPM from your quota to meet the demand for your deployments and prevent calls to your deployed models from being throttled. A gateway such as Azure API Management (APIM) can be deployed in front of your OpenAI service(s) and can be configured for retry in the case of transient errors and throttling. APIM can also be used as a [circuit breaker](/azure/api-management/backends?tabs=bicep#circuit-breaker-preview) to prevent the service from getting overwhelmed with call, exceeding it's quota.

### Azure AI Search - reliability

Deploy Azure AI Search with Standard pricing tier or above in a [region that supports availability zones](/azure/search/search-reliability#prerequisites) and deploy three or more replicas. The replicas automatically spread evenly across availability zones.

Consider the following guidance for determining the appropriate number of replicas and partitions:

- Follow the guidance to [monitor Azure AI Search](/azure/search/monitor-azure-cognitive-search).
- Use monitoring metrics and logs and performance analysis to determine the appropriate number of replicas to avoid query-based throttling and partitions to avoid index-based throttling.

### Azure Machine Learning - reliability

If you deploy to compute clusters behind the Azure Machine Learning managed online endpoint, consider the following guidance regarding scaling: 

- Follow the guidance to [autoscale your online endpoints](/azure/machine-learning/how-to-autoscale-endpoints) to ensure enough capacity is available to meet demand. If usage signals aren't timely enough due to burst usage, consider overprovisioning to prevent reliability impact from too few instances being available.
- Consider creating scaling rules based on [deployment metrics](/azure/machine-learning/how-to-autoscale-endpoints#create-a-rule-to-scale-out-using-metrics) such as CPU load and [endpoint metrics](/azure/machine-learning/how-to-autoscale-endpoints#create-a-scaling-rule-based-on-endpoint-metrics) such as request latency.
- No less than three instances should be deployed for an active production deployment.
- Avoid deployments against in-use instances. Instead deploy to a new deployment and shift traffic over after the deployment is ready to receive traffic.

> [!NOTE]
> The same [App Service scalability guidance](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service) from the baseline architecture applies if you deploy your flow to Azure App Service.

## Security

This architecture implements both a network and an identity security perimeter. From a network perspective, the only thing that should be accessible from the internet is the chat UI via the App Gateway. From an identity perspective, the chat UI should authenticate and authorize requests. Managed identities are used, where possible, to authenticate applications to Azure services.

Network security was discussed in the networking section. This section discusses identity and access management, and security considerations for key rotation and Azure OpenAI model fine tuning.

### Identity and access management

The following guidance extends the [identity and access management guidance in the App Service baseline](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#identity-and-access-management):

- Create separate managed identities for the following AML resources, where applicable:
  - Workspace - used during flow authoring and management
  - Compute instance - used when testing flows
  - Online endpoint - used by the deployed flow if deployed to a managed online endpoint
- Implement identity-access controls for the chat UI using Microsoft Entra ID

### Azure Machine Learning RBAC roles

There are five [default roles](/azure/machine-learning/how-to-assign-roles#default-roles) you can use to manage access to your Azure Machine Learning workspace: AzureML Data Scientist, AzureML Compute Operator, Reader, Contributor, and Owner. Along with these default roles, there's an AzureML Workspace Connection Secrets Reader and an AzureML Registry User that grant access to workspace resources such as the workspace secrets and registry.

This architecture follows the least privilege principle by only assigning roles to the above identities where they're required. The following are the role assignments.

| Managed identity | Scope | Role assignments |
| --- | --- | --- |
| Workspace managed identity | Resource group | Contributor |
| Workspace managed identity | Workspace Storage Account | Storage Blob Data Contributor |
| Workspace managed identity | Workspace Storage Account | Storage File Data Privileged Contributor |
| Workspace managed identity | Workspace Key Vault | Key Vault Administrator |
| Workspace managed identity | Workspace Container Registry | ACRPush |
| Online endpoint managed identity | Workspace Container Registry | AcrPull |
| Online endpoint managed identity | Workspace Storage Account | Storage Blob Data Reader |
| Online endpoint managed identity | Machine Learning workspace | AzureML Workspace Connection Secrets Reader |
| Compute instance managed identity | Workspace Container Registry | ACRPull |
| Compute instance managed identity | Workspace Storage Account | Storage Blob Data Reader |

### Key rotation

There are two services in this architecture that use key-based authentication: Azure OpenAI and the Azure Machine Learning managed online endpoint. Because you're using key-based authentication for these services, It's important to:

- Store the key in a secure store like Azure Key Vault for on-demand access from authorized clients (such as the Azure Web App hosting the prompt flow container).
- Implement a key rotation strategy. If you [manually rotate the keys](/azure/storage/common/storage-account-keys-manage?tabs=azure-portal#manually-rotate-access-keys), you should create a key expiration policy and use Azure policy to monitor whether the key has been rotated.

### OpenAI model fine-tuning

If you're fine-tuning OpenAI models in your implementation, consider the following guidance:

- If you're uploading training data for fine-tuning, consider using [customer managed keys](/azure/ai-services/openai/encrypt-data-at-rest#customer-managed-keys-with-azure-key-vault) for encrypting that data.
- If you're storing training data in a store such as Azure Blob Storage, consider using a customer managed key for data encryption, use a managed identity to control access to the data, and a private endpoint to connect to the data.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/well-architected/performance-efficiency/).

This section discusses performance efficiency from the perspective of Azure Search, Azure OpenAI and Azure Machine Learning.

### Azure Search - performance efficiency

Follow the guidance to [analyze performance in Azure AI Search](/azure/search/search-performance-analysis).

### Azure OpenAI - performance efficiency

- Determine whether your application requires [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) or will use the shared hosting (consumption) model. Provisioned throughput offers reserved processing capacity for your OpenAI model deployments, providing predictable performance and throughput for your models. This billing model is unlike the shared hosting (consumption) model, which is best-effort and might be subject to noisy neighbor or other stressors on the platform.
- For provisioned throughput, you should monitor [provision-managed utilization](/azure/ai-services/openai/how-to/monitoring)

### Azure Machine Learning - performance efficiency

If deploying to Azure Machine Learning online endpoints:

- Follow the guidance on how to [autoscale an online endpoint](/azure/machine-learning/how-to-autoscale-endpoints) to stay closely aligned with demand, without excessive overprovisioning, especially in low-usage periods.
- Choose the appropriate virtual machine SKU for the online endpoint to meet your performance targets. You want to test performance of both lower instance count and bigger SKUs vs larger instance count and smaller SKUs to find an optimal configuration.

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see Overview of the [cost optimization pillar](/azure/well-architected/cost-optimization/). 

To see a pricing example for this scenario, use the [Azure pricing calculator](https://azure.com/e/a5a243c3b0794b2787e611c65957217f). You'll need to customize the example to match your usage, as this example just includes the components included in the architecture. The most expensive components in the scenario are the chat UI & prompt flow compute and Azure AI Search, so look to optimization around those resources to save the most cost.

### Compute

Azure Machine Learning prompt flow supports multiple options to host the executable flows. The options include managed online endpoints in Azure Machine Learning, Azure Kubernetes Service, Azure App Service, and Azure Container Service. Each of these options has their own billing model. The choice of compute impacts the overall cost of the solution.

### Azure OpenAI

Azure OpenAI is a consumption-based service, and as with any consumption-based service, controlling demand against supply is the primary cost control. To do that in the Azure OpenAI service specifically you need to employ a combination of approaches:

- **Control clients.** Client requests are the primary source of cost in a consumption model, as such controlling client behavior is critical.  All clients should:
  - Be approved. Avoid exposing the service in such a way that supports free-for-all access. Limit access both through network and identity controls (key or RBAC).
  - Be self-controlled. Require clients to use the token-limiting constraints offered by the API calls, such as max_tokens and max_completions.
  - Use batching, where practical. Review clients to ensure they're appropriately batching prompts.
  - Optimize prompt input and response length. Longer prompts consume more tokens, raising the cost, yet prompts that are missing sufficient context don't help the models yield good results. Create concise prompts that provide enough context to allow the model to generate a useful response. Likewise, ensure you optimize the limit of the response length.
- **Azure OpenAI playground** usage should be as-necessary and on preproduction instances, so those activities aren't incurring production costs.
- **Select the right AI model.** Model selection also plays a large role in the overall cost of Azure OpenAI. All models have strengths and weaknesses and are individually priced. Using the correct model for the use case can make sure you're not overspending on a more expensive model when a less expensive model yields acceptable results. In this chat reference implementation, GPT 3.5-turbo was chosen over GPT-4 to save about an order of magnitude of model deployment costs while achieving sufficient results.
- **Understand billing breakpoints** - Fine-tuning is charged per-hour. To be the most efficient, you'll want to utilize as much of that time available per hour to improve the fine-tuning results while avoiding just slipping into the next billing period. Likewise, the cost for 100 images from image generation is the same as the cost for 1 image.  Maximize the price break points to your advantage.
- **Understand billing models** - Azure OpenAI is also available in a commitment-based billing model through the [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) offering. Once you have predictable usage patterns, evaluate switching to this prepurchase billing model if it calculates to be more cost effective at your usage volume.
- **Set provisioning limits** - Ensure that all provisioning quota is allocated only to models that are expected to be part of the workload, on a per-model basis. Throughput to already deployed models are not limited to this provisioned quota while dynamic quota is enabled. Note that quota does not directly map to costs and cost might vary.
- **Monitor pay-as-you-go usage** - If using pay-as-you-go, [monitor usage](/azure/ai-services/openai/how-to/quota?tabs=rest#view-and-request-quota) of Tokens per Minute (TPM) and Requests per Minute (RPM). Use that information to inform architectural design decisions such as what models to use, as well as optimize prompt sizes.
- **Monitor provisioned throughput usage** - If using [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput), monitor [provision-managed utilization](/azure/ai-services/openai/how-to/monitoring) to ensure you are not underutilizing the provisioned throughput you have purchased.
- **Cost management** - Follow the guidance on [using cost management features with OpenAI](/azure/ai-services/openai/how-to/manage-costs) to monitor costs, set budgets to manage costs, and create alerts to notify stakeholders of risks or anomalies.

## Large language model operations (LLMOps)

Deployment for Azure OpenAI based chat solutions like this architecture should follow the guidance in [LLMOps with prompt flow with Azure DevOps](/azure/machine-learning/prompt-flow/how-to-end-to-end-azure-devops-with-prompt-flow) and [GitHub](/azure/machine-learning/prompt-flow/how-to-end-to-end-llmops-with-prompt-flow). Additionally, it must consider best practices for CI/CD and network-secured architectures. The following guidance addresses the implementation of Flows and their associated infrastructure based on the LLMOps recommendations. This deployment guidance doesn't include the front-end application elements, which are unchanged from in the [Baseline highly available zone-redundant web application architecture](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#deployment).

### Development

Azure Machine Learning prompt flow offers both a browser-based authoring experience in Azure Machine Learning studio or through a [VS Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension). Both options store the flow code as files. When using Azure Machine Learning studio, the files are stored in an Azure Storage Account. When working in VS Code, the files are stored on your local filesystem.

In order to follow [best practices for collaborative development](/azure/machine-learning/prompt-flow/how-to-integrate-with-llm-app-devops#best-practice-for-collaborative-development), the source files should be maintained in an online source code repository such as GitHub. This approach facilitates tracking of all code changes, collaboration between flow authors and integration with [deployment flows](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-flow) that test and validate all code changes.

For enterprise development, you should use the [VS Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension) and the [prompt flow SDK/CLI](/azure/machine-learning/prompt-flow/community-ecosystem#prompt-flow-sdkcli) for development. Prompt flow authors can build and test their flows from VS Code and integrate the locally stored files with the online source control system and pipelines. While the browser-based experience is well suited for exploratory development, with some work, it can be integrated with the source control system. The flow folder can be downloaded from the flow page in the ```Files``` panel, unzipped, and pushed to the source control system.

### Evaluation

You should test the flows used in a chat application just as you test other software artifacts. It's challenging to specify and assert a single "right" answer for LLM outputs, but you can use an LLM itself to evaluate responses. Consider implementing the following automated evaluations of your LLM flows:

- **Classification Accuracy**: Evaluates whether the LLM gives a "correct" or "incorrect" score and aggregates the outcomes to produce an accuracy grade.
- **Coherence**: Evaluates how well the sentences in a model's predicted answer are written and how they coherently connect with each other.
- **Fluency**: Assesses the model's predicted answer for its grammatical and linguistic accuracy.
- **Groundedness Against Context**: Evaluates how well the model's predicted answers are based on preconfigured context. Even if LLM's responses are correct, if they can't be validated against the given context, then such responses aren't grounded.
- **Relevance**: Evaluates how well the model's predicted answers align with the question asked.

Consider the following guidance when implementing automated evaluations:

- Produce scores from evaluations and measure them against a predefined success threshold. Use these scores to report test pass/fail in your pipelines.
- Some of these tests require preconfigured data inputs of questions, context, and ground truth.
- Include enough question-answer pairs to ensure the results of the tests are reliable, with at least 100-150 pairs recommended. These question-answer pairs are referred to as your "golden dataset." A larger population might be required depending on the size and domain of your dataset.
- Avoid using LLMs to generate any of the data in your golden dataset.

### Deployment Flow

:::image type="complex" source="_images/openai-end-to-end-deployment-flow.svg" lightbox="_images/openai-end-to-end-deployment-flow.svg" alt-text="Diagram that shows the deployment flow for a prompt flow.":::
  The diagram shows the deployment flow for a prompt flow. The following are annotated with numbers: 1. The local development step, 2. A box containing a PR pipeline, 3. A manual approval, 4. Development environment, 5. Test environment, 6. Production environment, 7. a list of monitoring tasks, and a. CI pipeline and b. CD pipeline.
:::image-end:::
*Figure 5: Prompt flow deployment*

1. The prompt engineer/data scientist opens a feature branch where they work on the specific task or feature. The prompt engineer/data scientist iterates on the flow using Prompt flow for VS Code, periodically committing changes and pushing those changes to the feature branch.
2. Once local development and experimentation are completed, the prompt engineer/data scientist opens a pull request from the Feature branch to the Main branch. The pull request (PR) triggers a PR pipeline. This pipeline runs fast quality checks that should include:
  
    - Execution of experimentation flows
    - Execution of configured unit tests
    - Compilation of the codebase
    - Static code analysis

3. The pipeline can contain a step that requires at least one team member to manually approve the PR before merging. The approver can't be the committer and they mush have prompt flow expertise and familiarity with the project requirements. If the PR isn't approved, the merge is blocked. If the PR is approved, or there's no approval step, the feature branch is merged into the Main branch.
4. The merge to Main triggers the build and release process for the Development environment. Specifically:

    a. The CI pipeline is triggered from the merge to Main. The CI pipeline performs all the steps done in the PR pipeline, and the following steps:

      - Experimentation flow
      - Evaluation flow
      - Registers the flows in the Azure Machine Learning Registry when changes are detected

    b. The CD pipeline is triggered after the completion of the CI pipeline. This flow performs the following steps:

      - Deploys the flow from the Azure Machine Learning Registry to an Azure Machine Learning online endpoint
      - Runs integration tests that target the online endpoint
      - Runs smoke tests that target the online endpoint

5. An approval process is built into the release promotion process – upon approval, the CI & CD processes described in steps 4.a. & 4.b. are repeated, targeting the Test environment. Steps a. and b. are the same, except that user acceptance tests are run after the smoke tests in the Test environment.
6. The CI & CD processes described in steps 4.a. & 4.b. are run to promote the release to the Production environment after the Test environment is verified and approved.
7. After release into a live environment, the operational tasks of monitoring performance metrics and evaluating the deployed LLM take place. This includes but isn't limited to:

    - Detecting data drifts
    - Observing the infrastructure
    - Managing costs
    - Communicating the model's performance to stakeholders

### Deployment Guidance

Azure Machine Learning Endpoints allow you to deploy models in a way that enables flexibility when releasing to production. Consider the following strategies to ensure the best model performance and quality:

- Blue/green deployments: With this strategy, you can safely deploy your new version of the web service to a limited group of users or requests before directing all traffic over to the new deployment.
- A/B Testing: Not only are Blue/Green deployments effective for safely rolling out changes, they can also be used to deploy new behavior that allows a subset of users to evaluate the impact of the change.
- Include linting of Python files that are part of the prompt flow in your pipelines. Linting checks for compliance with style standards, errors, code complexity, unused imports, and variable naming.
- When deploying your flow to the network-isolated Azure Machine Learning workspace, use a self-hosted agent to deploy artifacts to your Azure resources.
- The Azure Machine Learning model registry should only be updated when there are changes to the model.
- The LLM, the flows, and the client UI should be loosely coupled. Updates to the flows and the client UI can and should be able to be made without affecting the model and vice versa.
- When developing and deploying multiple flows, each flow should have its own lifecycle, which allows for a loosely coupled experience when promoting flows from experimentation to production.

### Infrastructure

When deploying the baseline Azure OpenAI end-to-end chat components, some of the services provisioned are foundational and permanent within the architecture, whereas other components are more ephemeral in nature, their existence tied to a deployment.

#### Foundational components

Some components in this architecture exist with a lifecycle that extends beyond any individual prompt flow or any model deployment. These resources are typically deployed once as part of the foundational deployment by the workload team, and maintained apart from new, removed, or updates to the prompt flows or model deployments.

- Azure Machine Learning workspace
- Azure Storage account for the Azure Machine Learning workspace
- Azure Container Registry
- Azure AI Search
- Azure OpenAI
- Azure Application Insights
- Azure Bastion
- Azure Virtual Machine for the jump box

#### Ephemeral components

Some Azure resources are more tightly coupled to the design of specific prompt flows, allowing these resources to be bound to the lifecycle of the component and become ephemeral in this architecture. They're affected when the workload evolves, such as when flows are added or removed or when new models are introduced. These resources get recreated and prior instances removed. Some of these resources are direct Azure resources and some are data plane manifestations within their containing service.

- The model in the Azure Machine Learning model registry should be updated, if changed, as part of the CD pipeline.
- The container image should be updated in the container registry as part of the CD pipeline.
- An Azure Machine Learning endpoint is created when a prompt flow is deployed if the deployment references an endpoint that doesn't exist. That [endpoint needs to be updated to turn off public access](/azure/machine-learning/concept-secure-online-endpoint#secure-inbound-scoring-requests).
- The Azure Machine Learning endpoint's deployments are updated when a flow is deployed or deleted.
- The Key Vault for the client UI must be updated with the key to the endpoint when a new endpoint is created.

### Monitoring

Diagnostics are configured for all services. All services but Azure Machine Learning and Azure App Service are configured to capture all logs. The Azure Machine Learning diagnostics is configured to capture the audit logs which are all resource logs that record customer interactions with data or the settings of the service. Azure App Service is configured to capture AppServiceHTTPLogs, AppServiceConsoleLogs, AppServiceAppLogs and AppServicePlatformLogs.

## Deploy this scenario

To the deploy and run the reference implementation, follow the steps in the [OpenAI end-to-end baseline reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline/).

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Patterns & Practices - Microsoft
- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) | Cloud Solution Architect - Microsoft
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/) | Senior Software Engineer - Microsoft
- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/) | Software Engineer II - Microsoft
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer - Microsoft
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/) | Senior Solution Architect - Microsoft

_To see non-public LinkedIn profiles, sign in to LinkedIn._

## Next steps

[Read more about Azure OpenAI](/azure/ai-services/openai/overview)

## Related resources

- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service)
- [Azure OpenAI large language models](/azure/ai-services/openai/concepts/models)
- [Azure Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow)
- [Workspace managed virtual network isolation](/azure/machine-learning/how-to-managed-network)
- [Configure a private endpoint for an Azure Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link)
- [Content filtering](/azure/ai-services/openai/concepts/content-filter)
