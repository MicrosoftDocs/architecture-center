Enterprise chat applications have the ability empower employees through conversational interaction, especially due to the continuous advancement of large language models such as OpenAI's GPT models and Meta's LLaMA models. These chat applications consist of a user interface for chatting, data repositories containing domain-specific information pertinent to the user’s queries, large language models (LLMs) that reason over the domain-specific data to produce a relevant response, and an orchestrator that oversees the interaction between these components.

This article provides a baseline architecture for building and deploying enterprise chat applications that use OpenAI large language models. The architecture employs Azure Machine Learning (AML) prompt flow to create executable flows that orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the LLMs, along with any other Python logic required. The executable flow is deployed to an Azure Machine Learning compute cluster behind a managed online endpoint.

The hosting of the custom chat user interface (UI) follows the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) guidance for deploying a secure, zone-redundant, and highly available web application on Azure App Services. In that architecture the App Service communicates to Azure PaaS services through virtual network integration over private endpoints. Likewise, the chat UI App Service communicates with the managed online endpoint for the flow over a private endpoint and public access to the Azure Machine Learning workspace is disabled.

> [!IMPORTANT]
> The article does not cover the components or architecture decisions from the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). Please read that article for architectural guidance for hosting the chat UI.

The Machine Learning workspace is configured with [managed virtual network isolation](/azure/machine-learning/how-to-managed-network) that requires all outbound connections to be approved. With this configuration, a managed virtual network is created, along with managed private endpoints that enable connectivity to private resources such as the workplace Azure Storage, Azure Container Registry, and Azure OpenAI. These private connections are used during flow authoring and testing, as well as by flows deployed to Azure Machine Learning compute.

> [!TIP]
> ![GitHub logo](../../_images/github.svg) This article is backed by a [reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline) which showcases a baseline end-to-end chat implementation on Azure. This implementation can be used as a basis for custom solution development in your first step towards production.

## Architecture

:::image type="complex" source="_images/openai-end-to-end-aml-deployment.svg" lightbox="_images/openai-end-to-end-aml-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI.":::
    The diagram shows the App Service baseline architecture with a private endpoint connecting to a managed online endpoint in an Azure Machine Learning managed virtual network. The managed online endpoint sits in front of an Azure Machine Learning compute cluster. The diagram show that the machine learning workspace has a dotted line pointing to the compute cluster, representing that the executable flow is deployed to the compute cluster. The managed virtual network has managed private endpoints that provide private connectivity to resources required by the executable flow such as the Azure Container Registry and Azure Storage. the diagram further shows user-defined private endpoints providing private connectivity to the Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 1: Baseline end-to-end chat architecture with OpenAI*

*Download a [Visio file](https://arch-center.azureedge.net/) of this architecture.*

## Components

Many of the components of this architecture are the same as those in the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml), as the chat UI hosting in this architecture follows the baseline App Service web application's architecture. The components highlighted in this section focus on the components used to build and orchestrate chat flows, as well as data services and the services that expose the LLMs.

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a managed cloud service that's used to train, deploy, and manage machine learning models. This architecture uses several additional features of Azure Machine Learning used to develop and deploy executable flows for AI applications powered by Large Language Models:
  - [Azure Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) is a development tool that allows you to build, test, and deploy flows that link user prompts, actions through Python code and LLMs. Prompt flow is used in this architecture as the layer that orchestrates flows between the prompt, different data stores, and the LLM model.
  - [Managed online endpoints](/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference) allow you to deploy a flow for real-time inference. In this architecture, they are used to as a PaaS endpoint for the chat UI to invoke the prompt flows hosted by Azure Machine Learning.
- [Azure Storage](https://azure.microsoft.com/services/storage) is used to persist the prompt flow source files for prompt flow development.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) enables you to build, store, and manage container images and artifacts in a private registry for all types of container deployments.
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) is a fully managed service that provides REST API access to OpenAI's large language models, including the GPT-4, GPT-3.5-Turbo, and Embeddings model series1. In this architecture, in addition to model access, it's used to add common enterprise features such as [virtual network and private link](/azure/ai-services/cognitive-services-virtual-networks), [managed identity](/azure/ai-services/openai/how-to/managed-identity) support, and content filtering.
- [Azure AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search). This is included in the architecture as it is a common service used in the flows behind chat applications. Azure AI Search can be used to store data that is relevant for user queries. The prompt flow will extract the appropriate query from the prompt, query AI Search, and use the results as grounding data for the Azure OpenAI model.

### Azure Machine Learning prompt flow

The back end for enterprise chat applications generally follow a pattern similar to the following:

- The user enters a prompt in a custom chat user interface (UI)
- That prompt is sent to the back end by the interface code
- The user intent (question or directive) is extracted from the prompt by the back end
- (optional) The back end determines the data store(s) that holds data that is relevant to the user prompt
- The back end queries the relevant data store(s)
- The back end sends the intent, the relevant grounding data, and any history provided in the prompt to the LLM model
- The back end returns the result to so that it can be displayed on the user interface

The back end could be implemented in any number of languages and deployed to a variety of Azure services. In this architecture, Azure Machine Learning prompt flow was chosen because it provides a [streamlined experience](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) to build, test, and deploy flows that orchestrate between prompts, back end data stores, and LLMs.

## Networking

Network security is at the core of the baseline end-to-end chat architecture using OpenAI. From a high level, the network architecture ensures the following:

1. A single secure entry point for client traffic
1. Network traffic is filtered
1. Data in transit is encrypted end-to-end with TLS
1. Data exfiltration is minimized by keeping traffic in Azure through the use of Private Link
1. Network resources are logically grouped and isolated from each other through network segmentation

### Network flows

:::image type="complex" source="_images/openai-end-to-end-aml-deployment-flows.svg" lightbox="_images/openai-end-to-end-aml-deployment-flows.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI with flow numbers.":::
    The diagram resembles the baseline end-to-end chat architecture with OpenAI architecture with three numbered network flows. The inbound flow and the flow from App Service to Azure PaaS services are duplicated from the Baseline Azure App Service web architecture. The Azure Machine Learning managed online endpoint flow shows an arrow from the Compute Instance private endpoint in the client UI virtual network pointing to the managed online endpoint. The second number shows an arrow pointed from the managed online endpoint to the compute cluster. The third shows arrows from the compute cluster to private endpoints that point to the Azure Container Registry, Azure Storage, Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 2: Network flows for the baseline end-to-end chat architecture with OpenAI*

Two flows in this diagram are covered in [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml): 1. the inbound flow from the end user to the chat UI and 2. the App Service to [Azure PaaS services flow](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#app-service-to-azure-paas-services-flow). Please see that article for details on those flows. This section focuses on the Azure Machine Learning online endpoint flow. The following details the flow from the chat UI running in the baseline App Service web application to the flow deployed to Azure Machine Learning compute:

1. The call from the App Service hosted chat UI is routed through a private endpoint to the Azure Machine Learning online endpoint.
1. The online endpoint routes the call to a server running the deployed flow. The online endpoint acts as both a load balancer, as well as a router.
1. Calls to Azure PaaS services required by the deployed flow are routed through managed private endpoints.

### Ingress to Azure Machine Learning

In this architecture, public access to the Azure Machine Learning workspace is disabled and access can occur through private access as it follows the [private endpoint for the Azure Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link) configuration. In fact, private endpoints are used throughout this architecture to compliment identity-based security. For example, by allowing your chat UI hosted in App Service to connect to PaaS services not exposed to the public Internet, including Azure Machine Learning endpoints.

Private endpoint access is also required for connecting to the Azure Machine Learning workspace for flow authoring.

:::image type="complex" source="_images/openai-end-to-end-aml-flow-authoring.svg" lightbox="_images/openai-end-to-end-aml-flow-authoring.svg" alt-text="Diagram that shows a user connecting to an Azure Machine Learning workspace through a jumpbox to author a flow OpenAI with flow numbers.":::
    The diagram shows a user connecting to a jumpbox virtual machine through Azure Bastion. There is an arrow from the jumpbox to an Azure Machine Learning workspace private endpoint. There is another arrow from the private endpoint to the Azure Machine Learning workspace. From the workspace, there are four arrows pointed to four private endpoints that connect to Azure Container Registry, Azure Storage, Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 3: Network flows for an Azure Machine Learning prompt flow author*

The diagram above shows a prompt flow author connecting through Azure Bastion to a virtual machine jumpbox. From that jumpbox, the author can connect to the Machine Learning Workspace through a private endpoint in the same network as the jumpbox. Connectivity to the virtual network is more commonly done in enterprises through ExpressRoute or virtual network peering.

### Flow from the Azure Machine Learning managed virtual network to Azure PaaS services

It's recommended that the Azure Machine Learning workspace is configured for [managed virtual network isolation](/azure/machine-learning/how-to-managed-network) with a configuration that requires all outbound connections to be approved. This architecture follows that recommendation. There are two types of approved outbound rules. *Required outbound rules* are to resources required for the solution to work, such as Azure Container Registry and Azure Storage. *User-defined outbound rules* are to custom resources, such as Azure OpenAI or Azure AI Search, that your workflow is going to use. It is your responsibility to configure user-defined outbound rules, while required outbound rules are configured when the managed virtual network is created.

The outbound rules can be private endpoints, service tags, or FQDNs for external public endpoints. In this architecture, connectivity to Azure services such as Azure Container Registry, Azure Storage, Azure Key Vault, Azure OpenAI service, and Azure AI Search are connected through private link.

### Virtual network segmentation and security

The network in this architecture has separate subnets for the following:

- Application Gateway
- App Service integration components
- Private endpoints
- Azure Bastion
- Jumpbox virtual machine
- Training
- Scoring

Each subnet has a network security group that limits both inbound and outbound traffic for those subnets to just what is required. The following table shows a simplified view of the NSG rules the baseline adds to each subnet. The table gives the rule name and function.

| Subnet   | Inbound | Outbound |
| -------  | ---- | ---- |
| snet-appGateway    | `AppGw.In.Allow.ControlPlane`: Allow inbound control plane access<br><br>`AppGw.In.Allow443.Internet`: Allow inbound internet HTTPS access<br><br>`AppGw.In.AllowLoadBalancer`: Allow inbound traffic from azure load balancer<br><br>`DenyAllInBound`: Deny all other inbound traffic | `AppGw.Out.Allow.AppServices`: Allow outbound access to AppServicesSubnet<br><br>`AppGw.Out.Allow.PrivateEndpoints`: Allow outbound access to PrivateEndpointsSubnet<br><br>`AppPlan.Out.Allow.AzureMonitor`: Allow outbound access to Azure Monitor |
| snet-PrivateEndpoints | Default rules: Allow inbound from virtual network | Default rules: Allow outbound to virtual network |
| snet-AppService | Default rules: Allow inbound from vnet  | `AppPlan.Out.Allow.PrivateEndpoints`: Allow outbound access to PrivateEndpointsSubnet<br><br>`AppPlan.Out.Allow.AzureMonitor`: Allow outbound access to Azure Monitor |
| AzureBastionSubnet | See guidance in [working with NSG access and Azure Bastion](/azure/bastion/bastion-nsg) | See guidance in [working with NSG access and Azure Bastion](/azure/bastion/bastion-nsg) |
| snet-jumpbox | `Jumpbox.In.Allow.SshRdp`: Allow inbound RDP and SSH from the Bastion Host subnet | `Jumpbox.Out.Allow.PrivateEndpoints`: Allow outbound traffic from the jumpbox subnet to the Private Endpoints subnet.<br><br>`Jumpbox.Out.Allow.Internet1`: Allow outbound traffic from all VMs to Internet<br><br>`DenyAllOutBound`: Deny all other outbound traffic |
| snet-agents | Default rules: Allow inbound from virtual network | Default rules: Allow outbound to virtual network |
| snet-training | Default rules: Allow inbound from virtual network | Default rules: Allow outbound to virtual network |
| snet-scoring | Default rules: Allow inbound from virtual network | Default rules: Allow outbound to virtual network |

Consider the following points when implementing virtual network segmentation and security.

- Enable [DDoS protection](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa7aca53f-2ed4-4466-a25e-0b45ade68efd) for the virtual network with a subnet that is part of an application gateway with a public IP.
- [Add an NSG](/azure/virtual-network/network-security-groups-overview) to every subnet where possible. You should use the strictest rules that enable full solution functionality.
- Use [application security groups](/azure/virtual-network/tutorial-filter-network-traffic#create-application-security-groups). Application security groups allow you to group NSGs, making rule creation easier for complex environments.

## Content filtering

Azure OpenAI service includes a [content filtering system](/azure/ai-services/openai/concepts/content-filter) that uses an ensemble of classification models to detect and prevent specific categories of potentially harmful content in both input prompts and output completions. Categories for this potentially harmful content include hate, sexual, self harm, violence, profanity, and jailbreak or content designed to bypass the constraints of an LLM. You are able to configure the severity you want to filter content for each category, with options being low, medium, or high. While this reference architecture adopts a stringent approach, you should adjust the settings according to your requirements.

## Reliability

The [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) architecture focuses on zonal redundancy for key regional services. Availability zones are physically separate locations within a region. They provide zonal redundancy for supporting services when two or more instances are deployed in supporting regions. When one zone experiences downtime, the other zones may still be unaffected. The architecture also ensures enough instances of Azure services to meet demand. Please see the [baseline](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) to review that guidance.

This section addresses reliability from the perspective of the components in this architecture not addressed in the App Service baseline, including Azure Machine Learning, Azure OpenAI, and Azure AI Search.

### Zonal redundancy for flow deployments

Enterprise deployments usually require at least zonal redundancy. To achieve this in Azure, resources must support [availability zones](/azure/availability-zones/az-overview) and you must deploy at least the instances of the resource or enable the platform support when instance control isn't available. Currently, Azure Machine Learning compute doesn’t offer support for availability zones. To mitigate the potential impact of a datacenter-level catastrophe on AML components, it's necessary to establish clusters in various regions along with deploying a load balancer to distribute calls among these clusters. You would use health checks to help ensure that calls are only routed to clusters that are functioning properly.

Deploying prompt flows is not limited to Azure Machine Learning compute clusters. The executable flow, being a containerized application, can be deployed to any Azure service that is compatible with containers. This includes services like Azure Kubernetes Service (AKS), Azure Functions, Azure Container Apps (ACA), and Azure App Service. Each of those services support availability zones. To achieve zonal redundancy for prompt flow execution, without the added complexity of a multi-region deployment, you should deploy your flows to one of those services.

The following is an alternate architecture where prompt flows are deployed to Azure App Service. App Service is used in this architecture because the workload already uses it for the chat UI and wouldn't benefit from introducing a new technology into the workload. Workload teams who have experience with AKS should consider deploying in that environment, especially if AKS is being used for other components in the workload.

:::image type="complex" source="_images/openai-end-to-end-app-service-deployment.svg" lightbox="_images/openai-end-to-end-app-service-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI with prompt flow deployed to Azure App Service.":::
    The diagram shows the App Service baseline architecture with 3 instances of a client App Service and 3 instances of a prompt flow app service. In addition to what is in the app service baseline architecture, this architecture includes private endpoints for Azure Container Registry, Azure AI Search, and Azure OpenAI. The architecture also shows an Azure Machine Learning workspace, used for authoring flows, running in a managed virtual network. The managed virtual network has managed private endpoints that provide private connectivity to resources required by the executable flow such as the Azure  Storage. The diagram further shows user-defined private endpoints providing private connectivity to the Azure OpenAI service and Azure AI Search. Lastly, there is a dotted line from the Machine Learning Workspace to the Azure Container Registry (ACR). This indicates that executable flows are deployed to ACR, where the prompt flow App Service can load it.
:::image-end:::
*Figure 4: Alternate end-to-end chat architecture with OpenAI deploying prompt flows to Azure App Services*

The diagram is numbered for areas that are noteworthy in this architecture:

1. Flows are still authored in Azure Machine Learning prompt flow and nothing has changed regarding the Azure Machine Learning network architecture. Flow authors still connect to the workspace authoring experience through a private endpoint and the managed private endpoints are used to connect to Azure services when testing flows.
1. This dotted line indicates that containerized executable flows are pushed to Azure Container Registry (ACR). Not shown in the diagram are the pipelines that containerize the flows and push to ACR.
1. There is an additional Web App deployed to the same App Service plan that is already hosting the chat UI. The new Web App hosts the containerized prompt flow, co-located on the same App Service plan that already runs at a minimum of three instances, spread across availability zones.  These App Service instances will connect to ACR over a private endpoint when loading the prompt flow container image.
1. The prompt flow container will connect to Azure AI Search and Azure OpenAI service over private endpoints deployed in your virtual network.

### Azure OpenAI - reliability

Azure OpenAI does not currently support availability zones. To mitigate the potential impact of a datacenter-level catastrophe on model deployments in Azure OpenAI, it's necessary to deploy Azure OpenAI to various regions along with deploying a load balancer to distribute calls among the regions. You would use health checks to help ensure that calls are only routed to clusters that are functioning properly.

In order to support multiple instances effectively, it's recommended to have fine-tuning files externalized, such as to a geo-redundant Azure Storage account to minimize the state stored in the Azure OpenAI service per region. Fine-tuning would still need to be done per instance in order to host the model deployment.

It is important to monitor the required throughput in terms of Tokens per Minute (TPM) and Requests per Minute (RPM) to ensure you have assigned enough TPM from your quota to meet the demand for your deployments and prevent calls to your deployed models from being throttled. A gateway such as Azure API Management (APIM) can be deployed in front of your OpenAI service(s) and can be configured for retry in the case of transient errors and throttling. APIM can also be used as a [circuit breaker](/azure/api-management/backends?tabs=bicep#circuit-breaker-preview) to prevent the service from getting overwhelmed with call, exceeding it's quota.

### Azure AI Search - reliability

Deploy Azure AI Search with Standard pricing tier or above in a [region that supports availability zones](/azure/search/search-reliability#prerequisites) and deploy three or more replicas. The replicas will automatically spread evenly across availability zones.

Consider the following guidance for determining the appropriate amount of replicas and partitions:

- Follow the guidance to [monitor Azure AI Search](/azure/search/monitor-azure-cognitive-search).
- Use monitoring metrics and logs and performance analysis to determine the appropriate amount of replicas to avoid query-based throttling and partitions to avoid index-based throttling.

### Azure Machine Learning - reliability

If you deploy to compute clusters behind the Azure Machine Learning managed online endpoint, consider the following guidance regarding scaling: 

- Follow the guidance to [autoscale your online endpoints](/azure/machine-learning/how-to-autoscale-endpoints) to ensure enough capacity is available to meet demand. If usage signals are not timely enough due to burst usage, consider overprovisioning to prevent reliability impact from too few instances being available.
- Consider creating scaling rules based on [deployment metrics](/azure/machine-learning/how-to-autoscale-endpoints#create-a-rule-to-scale-out-using-metrics) such as CPU load and [endpoint metrics](/azure/machine-learning/how-to-autoscale-endpoints#create-a-scaling-rule-based-on-endpoint-metrics) such as request latency.
- No less than three instances should be deployed for an active production deployment.
- Avoid deployments against in-use instances. Instead deploy to a new deployment and shift traffic over after the deployment is ready to receive traffic.

> [!NOTE]
> The same [App Service scalability guidance](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service) from the baseline architecture applies if you deploy your flow to Azure App Service.

## Security

### Identity and access management

The following guidance extends the [identity and access management guidance in the App Service baseline](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#identity-and-access-management):

- Create separate managed identities for the following AML resources, where applicable:
  - Workspace - used during flow authoring and management
  - Compute instance - used when testing flows
  - Online endpoint - used by the deployed flow if deployed to a managed online endpoint

### OpenAI RBAC roles

There are 5 [default roles](/azure/machine-learning/how-to-assign-roles#default-roles) you can use to manage access to your Azure Machine Learning workspace: AzureML Data Scientist, AzureML Compute Operator, Reader, Contributor, and Owner. Along with these default roles, there is an AzureML Workspace Connection Secrets Reader and an AzureML Registry User that grant access to workspace resources such as the workspace secrets and registry.

This architecture follows the least privilege principle by only assigning roles to the above identities where they are required. The following are the role assignments.

| Managed identity | Scope | Role assignments |
| --- | --- | --- |
| Workspace managed identity | Resource group | Contributor |
| Workspace managed identity | Workspace Storage Account | Storage Blob Data Contributor |
| Workspace managed identity | Workspace Storage Account | Storage File Data Contributor |
| Workspace managed identity | Workspace Key Vault | Key Vault Administrator |
| Workspace managed identity | Workspace Container Registry | ACRPush |
| Online endpoint managed identity | Workspace Container Registry | AcrPull |
| Online endpoint managed identity | Workspace Storage Account | Storage Blob Data Reader |
| Online endpoint managed identity | Machine Learning workspace | AzureML Workspace Connection Secrets Reader |
| Compute instance managed identity | Workspace Container Registry | ACRPull |
| Compute instance managed identity | Workspace Storage Account | Storage Blob Data Reader |

### OpenAI key rotation

There are two services in this architecture that use key-based authentication: Azure OpenAI and the Azure Machine Learning managed online endpoint. Because you are using key-based authentication for these services, it is important to:

- Store the key in a secure store like Azure Key Vault for on-demand access from authorized clients (such as the Azure Web App hosting the prompt flow container).
- Implement a key rotation strategy. If you [manually rotate the keys](/azure/storage/common/storage-account-keys-manage?tabs=azure-portal#manually-rotate-access-keys), you should create a key expiration policy and use Azure policy to monitor whether the key has been rotated.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/well-architected/performance-efficiency/).

This section discusses performance efficiency from the perspective of Azure Search, Azure OpenAI and Azure Machine Learning.

### Azure Machine Learning - performance efficiency

If deploying to Azure Machine Learning online endpoints:

- Follow the guidance on how to [autoscale an online endpoint](/azure/machine-learning/how-to-autoscale-endpoints) to stay closely aligned with demand, without excessive overprovisioning, especially in low-usage periods.
- Choose the appropriate virtual machine SKU for the online endpoint to meet your performance targets. You'll want to test performance of both lower instance count and bigger SKUs vs larger instance count and smaller SKUs to find an optimal configuration.

### Azure OpenAI - performance efficiency

- Determine whether your application requires [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) or will use the shared hosting (consumption) model. Provisioned throughput offers reserved processing capacity for your OpenAI model deployments, providing predictable performance and throughput for your models, unlike the shared hosting (consumption) model which is best-effort and might be subject to noisy neighbor or other stressors on the platform.
- For provisioned throughput, you should monitor [provision-managed utilization](/azure/ai-services/openai/how-to/monitoring)

### Azure Search - performance efficiency

Follow the guidance to [analyze performance in Azure AI Search](/azure/search/search-performance-analysis).

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see Overview of the [cost optimization pillar](/azure/well-architected/cost-optimization/). 

To see a pricing example for this scenario, use the [Azure pricing calculator](https://azure.com/e/a5a243c3b0794b2787e611c65957217f). You will need to customize the example to match your usage, as this example just includes the components included in the architecture. The most expensive components in the scenario are the chat UI & prompt flow compute and Azure AI Search, so look to optimization around those resources to save the most cost.

### Compute

Azure Machine Learning prompt flow supports multiple options to host the executable flows, including managed online endpoints in Azure Machine Learning, Azure Kubernetes Service, Azure App Service, and Azure Container Service. Each of these options has their own billing model. The choice of compute will impact the overall cost of the solution.

### Azure OpenAI

The following are some cost optimization considerations for OpenAI:

- Start with [pay-as-you-go pricing](/pricing/details/cognitive-services/openai-service/) for OpenAI models. When your token utilization is high and predictable, consider the [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) pricing model.
- Fine-tune the design by prioritizing the use of the right model for the given task. Models have different token limits and cost-per-token. Further, models have different fine-tuning costs which should be taken into account if fine-tuning is required in your solution.
- Optimize prompt input and response length. Longer prompts consume more tokens, raising the cost, yet prompts that are missing sufficient context will not help the models yield good results. Create concise prompts that provide enough context to allow the model to generate a useful response. Likewise, ensure you optimize the limit of the response length.
- Set up the appropriate governance processes to track, limit, and inform, to ensure appropriate usage.

## Large language model operations (LLMOps)

Deployment for the baseline Azure OpenAI end-to-end chat components follows the guidance in [LLMOps with prompt flow with Azure DevOps](/azure/machine-learning/prompt-flow/how-to-end-to-end-azure-devops-with-prompt-flow) and [GitHub](/azure/machine-learning/prompt-flow/how-to-end-to-end-llmops-with-prompt-flow). Additionally, it considers best practices for CI/CD and network-secured architectures. This guidance addresses the implementation of Flows and their associated infrastructure. It does not include the front-end application elements, which are discussed in the [Baseline highly available zone-redundant web application architecture](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#deployment).

### Development

Azure Machine Learning prompt flow offers both a browser-based authoring experience in Azure Machine Learning Studio or through a [VS Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension). Both options store the flow code as files. When using Azure Machine Learning Studio, the files are stored in an Azure Storage Account. When working in VS Code, the files are stored on your local filesystem.

In order to follow [best practices for collaborative development](/azure/machine-learning/prompt-flow/how-to-integrate-with-llm-app-devops#best-practice-for-collaborative-development), the source files should be maintained in an online source code repository such as GitHub. This facilitates tracking of all code changes, collaboration between flow authors and integration with [deployment flows](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-flow) that test and validate all code changes.

For enterprise development, you should consider using the [VS Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension) and the [prompt flow SDK/CLI](/azure/machine-learning/prompt-flow/community-ecosystem#prompt-flow-sdkcli) for development. Prompt flow authors can build and test their flows from VSCode and seamlessly integrate the locally stored files with the online source control system and pipelines. While the browser-based experience is well suited for exploratory development, with some work, it can be integrated with the source control system. The flow folder can be downloaded from the flow page in the ```Files``` panel, unzipped, and pushed to the source control system.

### Evaluation

TODO: 

### Deployment Flow

:::image type="complex" source="_images/openai-end-to-end-deployment-flow.svg" lightbox="_images/openai-end-to-end-deployment-flow.svg" alt-text="Diagram that shows the deployment flow for a prompt flow.":::
  The diagram shows the deployment flow for a prompt flow. The following are annotated with numbers: 1. The local development step, 2. A box containing a PR pipeline, 3. A manual approval, 4. Development environment, 5. Test environment, 6. Production environment, 7. a list of monitoring tasks, and a. CI pipeline and b. CD pipeline.
:::image-end:::
*Figure 5: Prompt flow deployment*

1. The prompt engineer/data scientist opens a feature branch where they will work on the specific task or feature. The prompt engineer/data scientist iterates on the flow using Prompt flow for VS Code, periodically committing changes and pushing those changes to the feature branch.
2. Once local development and experimentation is completed, the prompt engineer/data scientist opens a pull request from the Feature branch to the Main branch. The pull request (PR) triggers a PR pipeline. This pipeline runs fast quality checks that should include:
  
    - Execution of experimentation flows
    - Execution of configured unit tests
    - Compilation of the codebase
    - Static code analysis

3. The pipeline can contain a step that requires at least one team member aside from the committer with prompt flow expertise and familiarity with the project requirements to manually approve the PR before merging. If the PR is not approved, the merge is blocked. If the PR is approved, or there is no approval step, the feature branch is merged into the Main branch.
4. The merge to Main triggers the build and release process for the Development environment. Specifically:

    a. The CI pipeline is triggered from the merge to Main. The CI pipeline performs all the steps done in the PR pipeline, as well as the following steps:

        - Experimentation flow
        - Evaluation flow
        - Registers the flows in the Azure Machine Learning Registry when changes are detected

    b. The CD pipeline is triggered after the completion of the CI pipeline. This flow performs the following steps:

        - Deploys the flow from the Azure Machine Learning Registry to an Azure Machine Learning online endpoint
        - Runs integration tests that target the online endpoint
        - Runs smoke tests that target the online endpoint

5. An approval process is built into the code promotion process – upon approval, the CI & CD processes described in steps 4.a. & 4.b. are repeated, targeting the Test environment. Steps a. and b. are the same, except that User Acceptance tests are run after the Smoke tests in the Test environment.
6. The  CI & CD processes described in steps 4.a. & 4.b. are run in the Production Environment after the Test environment is verified and approved.
7. After release into a live environment, the operational tasks of monitoring performance metrics and evaluating the deployed LLM take place. This includes but is not limited to:

    - Detecting data drifts
    - Observing the infrastructure
    - Managing costs
    - Communicating the model's performance to stakeholders
