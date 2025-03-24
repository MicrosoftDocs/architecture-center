Enterprise chat applications can empower employees through conversational interaction. This point is especially true because of the continuous advancement of language models, such as OpenAI's GPT models and Meta's Llama models. These chat applications consist of:

- A chat user interface (UI).
- Data repositories that contain domain-specific information that's pertinent to the user's queries.
- Language models that reason over the domain-specific data to produce a relevant response.
- An orchestrator that oversees the interactions between components.

This article provides a baseline architecture to help you build and deploy enterprise chat applications that use [Azure OpenAI Service language models](/azure/ai-services/openai/concepts/models). The architecture uses prompt flow to create executable flows. These executable flows orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the language models and other required Python logic. The executable flow is deployed to a managed online endpoint that uses managed compute.

The hosting of the custom chat UI follows the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) guidance for how to deploy a secure, zone-redundant, and highly available web application on Azure App Service. In that architecture, App Service communicates to the Azure platform as a service (PaaS) solution through virtual network integration over private endpoints. In the chat UI architecture, App Service communicates with the managed online endpoint for the flow over a private endpoint. Public access to Azure AI Foundry portal is disabled.

> [!IMPORTANT]
> This article doesn't describe the components or architecture decisions from the [baseline App Service web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). Read that article for architectural guidance about how to host the chat UI.

The Azure AI Foundry hub is configured by using [managed virtual network isolation](/azure/ai-foundry/how-to/configure-managed-network) that requires approval for all outbound connections. In this configuration, a managed virtual network is created and managed private endpoints are established to enable connectivity to private resources, such as the workplace Azure Storage, Azure Container Registry, and Azure OpenAI. These private connections are used during flow authoring and testing by flows that are deployed to Azure Machine Learning compute.

A hub is the top-level Azure AI Foundry resource that provides a central way to help govern security, connectivity, and other concerns across multiple projects. This architecture requires only one project for its workload. If you have more experiences that require different prompt flows that use different logic and potentially different back-end resources such as data stores, you might consider implementing those experiences in a different project.

> [!TIP]
> ![GitHub logo.](../../_images/github.svg) This [reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline) showcases a baseline end-to-end chat implementation on Azure. You can use this implementation as a basis for custom solution development in your first step toward production.

## Architecture

:::image type="complex" source="_images/openai-end-to-end-aml-deployment.svg" border="false" lightbox="_images/openai-end-to-end-aml-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture that uses OpenAI.":::
    The diagram shows the App Service baseline architecture, which has a private endpoint that connects to a managed online endpoint in a Machine Learning managed virtual network. The managed online endpoint sits in front of a Machine Learning compute cluster. The diagram shows the Machine Learning workspace and a dotted line that points to the compute cluster. This arrow shows that the executable flow is deployed to the compute cluster. The managed virtual network uses managed private endpoints that provide private connectivity to resources that the executable flow requires, such as Container Registry and Storage. The diagram also shows user-defined private endpoints that provide private connectivity to Azure OpenAI and Azure AI Search.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end.vsdx) of this architecture.*

### Components

Many of the components of this architecture are the same as the resources in the [basic Azure OpenAI end-to-end chat architecture](./basic-openai-e2e-chat.yml#components). The following list highlights the differences between the basic architecture and the baseline architecture.

- [Azure OpenAI](/azure/well-architected/service-guides/azure-openai) is used in both architectures. Azure OpenAI is a fully managed service that provides REST API access to Azure OpenAI language models, including the GPT-4, GPT-3.5-Turbo, and embeddings set of models. The baseline architecture uses enterprise features like [virtual networks and private links](/azure/ai-services/cognitive-services-virtual-networks) that the basic architecture doesn't implement.

- [Azure AI Foundry](/azure/ai-foundry/what-is-ai-foundry) is a platform that you can use to build, test, and deploy AI solutions. This architecture uses Azure AI Foundry portal to build, test, and deploy the prompt flow orchestration logic for the chat application. In this architecture, Azure AI Foundry provides the [managed virtual network](/azure/ai-foundry/how-to/configure-managed-network) for network security. For more information, see the [networking](#networking) section in this article.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a layer 7 (HTTP/S) load balancer and web traffic router. It uses URL path-based routing to distribute incoming traffic across availability zones and offloads encryption to improve application performance.

- [Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) is a cloud-native service that helps protect web apps from common exploits such as SQL injection and cross-site scripting. Web Application Firewall provides visibility into the traffic to and from your web application. This visibility helps you monitor and secure your application.

- [Azure Key Vault](/azure/key-vault/general/overview) is a service that securely stores and manages secrets, encryption keys, and certificates. It centralizes the management of sensitive information.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a service that you can use to create isolated and more secure private virtual networks in Azure. For a web application on App Service, you need a virtual network subnet to use private endpoints for network-secure communication between resources.

- [Azure Private Link](/azure/private-link/private-link-overview) allows clients to access Azure PaaS services directly from private virtual networks without using public IP addresses.

- [Azure DNS](/azure/dns/dns-overview) is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. Private DNS zones provide a way to map a service's fully qualified domain name (FQDN) to a private endpoint's IP address.

### Alternatives

This architecture includes multiple components that can be served by other Azure services that might better align with the functional and nonfunctional requirements of your workload. 

#### Machine Learning workspaces and portal experiences

This architecture uses [Azure AI Foundry portal](/azure/ai-foundry/what-is-ai-foundry) to build, test, and deploy prompt flows. Alternatively, you can use [Machine Learning workspaces](/azure/well-architected/service-guides/azure-machine-learning). Both services have features that overlap. The portal is a good choice for designing a prompt flow solution, but Machine Learning currently has better support for some features. For more information, see [Detailed feature comparison](/ai/ai-studio-experiences-overview). We recommend that you don't mix and match the portal and Machine Learning studio. If your work can be done completely in Azure AI Foundry portal, use the portal. If you need features from Machine Learning studio, use the studio instead.

#### Application tier components

Azure provides several managed application services that can serve as an application tier for the chat UI front end. These services include [compute options](/azure/architecture/guide/technology-choices/compute-decision-tree) and [container solutions](/azure/architecture/guide/choose-azure-container-service). For example, this architecture uses Web Apps and Web App for Containers for the chat UI API and the prompt flow host respectively. You might achieve similar results by using Azure Kubernetes Service (AKS) or Azure Container Apps. Choose the application platform for your workload based on its specific functional and nonfunctional requirements.

#### Prompt flow hosting

Deploying prompt flows isn't limited to Machine Learning compute clusters. This architecture illustrates this point by using an alternative solution in App Service. Flows are ultimately a containerized application that can be deployed to any Azure service that's compatible with containers. These options include services like AKS, Container Apps, and App Service. [Choose an Azure container service](/azure/architecture/guide/choose-azure-container-service) based on the requirements of your orchestration layer.

An example of why you can consider deploying prompt flow hosting on an alternative compute is discussed later in this article.

#### Grounding data store

This architecture leads with AI Search, but your choice of data store for your grounding data is an architectural decision that's specific to your workload. Many workloads use several languages and have disparate sources and technologies for grounding data. These data platforms include existing online transaction processing data stores, cloud-native databases like Azure Cosmos DB, and specialized solutions like AI Search. Vector search is a common characteristic for this type of data store, but it isn't required. For more information, see [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

Apply this architecture and the design guidance in [AI workloads on Azure](/azure/well-architected/ai/get-started) during the design process for your specific workload.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The baseline App Service web application architecture focuses on zonal redundancy for key regional services. Availability zones are physically separate locations within a region. They provide redundancy within a region for supporting services when two or more instances are deployed between them. When downtime happens in one zone, the other zones within the region might be unaffected. The architecture also helps ensure that enough instances and configurations of Azure services are spread across availability zones. For more information, see [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml).

This section addresses reliability from the perspective of the components in this architecture that aren't addressed in the App Service baseline architecture, including Machine Learning, Azure OpenAI, and AI Search.

#### Zonal redundancy for flow deployments

Enterprise deployments usually require zonal redundancy. To achieve zonal redundancy in Azure, resources must support [availability zones](/azure/reliability/availability-zones-overview), and you must deploy at least three instances of the resource or enable platform support when instance control isn't available. Machine Learning compute doesn't support availability zones. To mitigate the potential effects of a datacenter-level catastrophe on Machine Learning components, you must establish clusters in various regions and deploy a load balancer to distribute calls among these clusters. You can use health checks to help ensure that calls are only routed to clusters that are functioning properly.

Alternatives to Machine Learning compute clusters include AKS, Azure Functions, Container Apps, and App Service. Each of those services supports availability zones. To achieve zonal redundancy for prompt flow execution without the added complexity of a multiple-region deployment, you can deploy your flows to one of those services.

The following diagram shows an alternative architecture in which prompt flows are deployed to App Service. This architecture uses App Service because the workload already uses it for the chat UI and doesn't benefit from introducing a new technology into the workload. Workload teams who have experience with AKS should consider deploying in that environment, especially if they use AKS for other components in the workload.

:::image type="complex" source="_images/openai-end-to-end-app-service-deployment.svg" border="false" lightbox="_images/openai-end-to-end-app-service-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture that uses OpenAI and deploys the prompt flow to App Service.":::
    The diagram shows the App Service baseline architecture with three instances of a client app service and three instances of a prompt flow app service. In addition to what's in the App Service baseline architecture, this architecture includes private endpoints for Container Registry, AI Search, and Azure OpenAI. The architecture also shows a Machine Learning workspace that's used for authoring flows and runs in a managed virtual network. The managed virtual network uses managed private endpoints that provide private connectivity to resources, such as Storage, that the executable flow requires. The diagram also shows user-defined private endpoints that provide private connectivity to Azure OpenAI and AI Search. Lastly, there's a dotted line from the Machine Learning workspace to Container Registry. It indicates that executable flows are deployed to Container Registry, where the prompt flow app service can load it.
:::image-end:::

The following dataflow corresponds to the previous diagram:

1. Flows are authored in prompt flow and the network architecture is unchanged. Flow authors connect to the authoring experience in the Azure AI Foundry project through a private endpoint, and the managed private endpoints are used to connect to Azure services when you test flows.

1. This dotted line indicates that containerized executable flows are pushed to Container Registry. The diagram doesn't show the pipelines that containerize the flows and push to Container Registry. The compute in which those pipelines run must have network line of sight to resources such as the Azure container registry and the Azure AI Foundry project.

1. Another web app is deployed to the same app service plan that hosts the chat UI. The new web app hosts the containerized prompt flow, which is colocated on the same app service plan. This service plan already runs at a minimum of three instances that are spread across availability zones. These App Service instances connect to Container Registry over a private endpoint when loading the prompt flow container image.

1. The prompt flow container needs to connect to all dependent services for flow execution. In this architecture, the prompt flow container connects to AI Search and Azure OpenAI. PaaS services that are exposed only to the Machine Learning managed private endpoint subnet now also need exposure in the virtual network to establish line of sight from App Service.

#### Reliability in Azure OpenAI

Azure OpenAI doesn't support availability zones. To mitigate the potential effects of a datacenter-level catastrophe on model deployments in Azure OpenAI, you must deploy Azure OpenAI to various regions and deploy a load balancer to distribute calls among the regions. You can use health checks to help ensure that calls are only routed to clusters that are functioning properly.

To support multiple instances effectively, we recommend that you externalize fine-tuning files, such as to a geographically redundant Storage account. This approach minimizes the state that's stored in Azure OpenAI for each region. You must fine-tune files for each instance to host the model deployment.

It's important to monitor the required throughput in terms of tokens per minute (TPM) and requests per minute (RPM). Assign sufficient TPM from your quota to meet the demand for your deployments and prevent calls to your deployed models from being throttled. You can deploy a gateway like Azure API Management in front of your Azure OpenAI service or services and configure it for retry if transient errors and throttling occur. You can also use API Management as a [circuit breaker](/azure/api-management/backends?tabs=bicep#circuit-breaker-preview) to prevent the service from getting overwhelmed with calls and exceeding its quota. For more information, see [Use a gateway in front of multiple Azure OpenAI deployments or instances](../guide/azure-openai-gateway-multi-backend.yml).

#### Reliability in AI Search

Deploy AI Search with the Standard pricing tier or higher in a [region that supports availability zones](/azure/search/search-reliability#prerequisites), and deploy three or more replicas. The replicas automatically spread evenly across availability zones.

Use the following guidance to determine the appropriate number of replicas and partitions:

- [Monitor AI Search](/azure/search/monitor-azure-cognitive-search).

- Use monitoring metrics and logs and performance analysis to determine the appropriate number of replicas. This approach helps you avoid query-based throttling and partitions and index-based throttling.

#### Reliability in Azure AI Foundry

If you deploy to compute clusters behind the Machine Learning managed online endpoint, consider the following scaling guidance:

- [Automatically scale your online endpoints](/azure/machine-learning/how-to-autoscale-endpoints) to ensure enough capacity is available to meet demand. If usage signals aren't timely enough because of burst usage, consider overprovisioning. This approach helps improve reliability by ensuring that enough instances are available.

- Create scaling rules based on [deployment metrics](/azure/machine-learning/how-to-autoscale-endpoints#create-scale-out-rule-based-on-deployment-metrics) like CPU load and [endpoint metrics](/azure/machine-learning/how-to-autoscale-endpoints#create-scale-rule-based-on-endpoint-metrics) like request latency.

- Deploy no fewer than three instances for an active production deployment.

- Avoid deployments against in-use instances. Deploy to a new deployment instead, and shift traffic over after the other deployment is ready to receive traffic.

Managed online endpoints serve as a load balancer and router for the managed compute that runs behind them. You can configure the percentage of traffic that should be routed to each deployment as long as the percentage adds up to 100%. You can also deploy a managed online endpoint with 0% traffic being routed to any deployment. 

If you use infrastructure as code (IaC) to deploy your resources, including your managed online endpoints, there's a reliability concern. This concern is highlighted in the provided reference implementation. If you have traffic configured to route to deployments that were created via CLI or Azure AI Foundry portal, and you perform a subsequent IaC deployment that includes the managed online endpoint, even if it doesn't update the managed online endpoint in any way, the endpoint traffic reverts to routing 0% traffic. Effectively, this scenario means that your deployed prompt flows aren't reachable until you adjust the traffic back to where you want it.

> [!NOTE]
> The same [App Service scalability guidance](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service) from the baseline architecture applies if you deploy your flow to App Service.

#### Multiple-region design

This architecture doesn't serve as a regional stamp in a multiple-region architecture. It provides high availability within a single region because it uses availability zones completely, but it lacks some key components to make this design ready for a multiple-region solution. This architecture doesn't include the following components and considerations:

- Global ingress and routing
- A DNS management strategy
- A data replication or isolation strategy
- An active-active, active-passive, or active-cold designation
- A failover and failback strategy to achieve your workload's recovery time objective and recovery point objective
- Considerations about region availability for developer experiences in the Azure AI Foundry hub resource

If your workload requires a multiple-region strategy, you need to invest in component and operational process design in addition to the design that's presented in this architecture. Your design needs to support load balancing or failover at the following layers:

- Grounding data
- Model hosting
- Orchestration layer, which is the prompt flow in this architecture
- Client-facing UI

You also need to maintain business continuity in observability, portal experiences, and responsible AI, such as content safety.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture extends the security footprint implemented in [Basic OpenAI end-to-end chat reference architecture](./basic-openai-e2e-chat.yml). The basic architecture uses system-assigned managed identities and system-assigned role assignments. This architecture uses user-assigned identities and manually created role assignments.

This architecture implements a network security perimeter in addition to the identity perimeter that the basic architecture implements. From a network perspective, only the chat UI should be accessible from the internet via Application Gateway. From an identity perspective, the chat UI should authenticate and authorize requests. Use managed identities when possible to authenticate applications to Azure services.

This section describes networking and security considerations for key rotation and Azure OpenAI model fine-tuning.

#### Identity and access management

When you use user-assigned managed identities, consider the following guidance:

- Create separate managed identities for the following Azure AI Foundry and Machine Learning resources, where applicable:

  - Azure AI Foundry hub
  - Azure AI Foundry projects for flow authoring and management
  - Online endpoints in the deployed flow if the flow is deployed to a managed online endpoint

- Implement identity-access controls for the chat UI by using Microsoft Entra ID

If you want to isolate permissions for prompt flows, create separate projects and online endpoints for different prompt flows. Create a separate managed identity for each project and managed online endpoint. Give prompt flow authors access to only the projects that they require.

When you onboard users to Azure AI Foundry projects to perform functions like authoring flows, assign least-privilege roles for the resources that they need.

### Machine Learning role-based access roles

Like in the basic architecture, the system automatically creates role assignments for the system-assigned managed identities. Because the system doesn't know which features of the hub and projects you might use, it creates role assignments that support all the potential features. The automatically created role assignments might overprovision privileges based on your use case. One example is when the system assigns the Contributor role to the hub for the container registry, but the hub likely only requires Reader access to the control plane. If you need to limit permissions for least-privilege goals, you must use user-assigned identities. You create and maintain these role assignments yourself.

Because of the maintenance burden of managing all the required assignments, this architecture favors operational excellence over absolute least privilege role assignments. You have to make all the assignments listed in the table.

| Managed identity | Scope | Role assignments |
| --- | --- | --- |
| Hub managed identity | Contributor | Resource Group |
| Hub managed identity | Hub | Azure AI Administrator |
| Hub managed identity | Container Registry | Contributor |
| Hub managed identity | Key Vault | Contributor |
| Hub managed identity | Key Vault | Administrator |
| Hub managed identity | Storage account | Reader |
| Hub managed identity | Storage account | Storage Account Contributor |
| Hub managed identity | Storage account | Storage Blob Data Contributor |
| Hub managed identity | Storage account | Storage File Data Privileged Contributor |
| Hub managed identity | Storage account | Storage Table Data Contributor |
| Project managed identity | Project | Azure AI Administrator |
| Project managed identity | Container Registry | Contributor |
| Project managed identity | Key Vault | Contributor |
| Project managed identity | Key Vault | Administrator |
| Project managed identity | Storage account | Reader |
| Project managed identity | Storage account | Storage Account Contributor |
| Project managed identity | Storage account | Storage Blob Data Contributor |
| Project managed identity | Storage account | Storage File Data Privileged Contributor |
| Project managed identity | Storage account | Storage Table Data Contributor |
| Online endpoint managed identity | Project | Azure Machine Learning Workspace Connection Secrets |
| Online endpoint managed identity | Project | AzureML Metrics Writer |
| Online endpoint managed identity | Container Registry | ACRPull |
| Online endpoint managed identity | Azure OpenAI | Cognitive Services OpenAI User |
| Online endpoint managed identity | Storage account | Storage Blob Data Contributor |
| Online endpoint managed identity | Storage account | Storage Blob Data Reader |
| App Service (when prompt flow is deployed to App Service) | Azure OpenAI | Cognitive Services OpenAI User |
| Portal User (prompt flow development) | Azure OpenAI | Cognitive Services OpenAI User |
| Portal User (prompt flow development) | Storage account | Storage Blob Data Contributor (use conditional access) |
| Portal User (prompt flow development) | Storage account | Storage File Data Privileged Contributor |

It's important to understand that the Azure AI Foundry hub shares Azure resources, such as Storage accounts and Container Registry, across projects. If you have users that only need access to a subset of the projects, consider using [role assignment conditions](/azure/role-based-access-control/conditions-role-assignments-portal), for Azure services that support them, to provide least privilege access to resources. For example, blobs in Storage support role assignment conditions. If a user requires access to a subset of the projects, use role access conditions to limit permissions to the blob containers that those projects use instead of assigning permissions on a per-container basis. Each project has a unique GUID that serves as a prefix for the names of the blob containers used in that project. That GUID can be used as part of the role assignment conditions.

The hub requires `Contributor` access to the hub resource group so that it can create and manage hub and project resources. `Contributor` access also gives the hub control plane access to any resource that's in the resource group. Create any Azure resources that aren't directly related to the hub and its projects in a separate resource group. We recommend that you create a minimum of two resource groups for a workload team that uses a self-managed Azure AI Foundry hub. One resource group contains the hub, its projects, and all of its direct dependencies like the Azure container registry and Key Vault. The other resource group contains everything else in your workload.

We recommend that you minimize the use of Azure resources needed for the hub's operation by other components in your workloads. For example, if you need to store secrets as part of your workload, you should create a separate Key Vault instance from the one that's associated with the hub. Only the hub should use the hub key vault to store hub and project secrets.

Ensure that for each distinct project, the role assignments for its dependencies don't provide access to resources the portal user and the managed online endpoint managed identity don't require. For example, the `Cognitive Services OpenAI User` role assignment to Azure OpenAI grants access to all deployments for that resource. There's no way to restrict flow authors or managed online endpoint managed identities that have that role assignment to specific model deployments in Azure OpenAI. For these scenarios, we recommend that you deploy services like Azure OpenAI and AI Search for each project and don't deploy resources to those services that flow authors or managed online endpoint managed identities shouldn't have access to. For example, only deploy models to the Azure OpenAI instance that the project requires access to. Only deploy indexes to the AI Search instance that the project should have access to.

#### Networking

In addition to identity-based access, network security is at the core of the baseline end-to-end chat architecture that uses OpenAI. From a high level, the network architecture ensures that:

- Only a single, secure entry point exists for chat UI traffic.
- Network traffic is filtered.
- Data in transit is encrypted end to end with Transport Layer Security.
- Data exfiltration is minimized by using Private Link to keep traffic in Azure.
- Network resources are logically grouped and isolated from each other through network segmentation.

##### Network flows

:::image type="complex" source="_images/openai-end-to-end-aml-deployment-flows.svg" border="false" lightbox="_images/openai-end-to-end-aml-deployment-flows.svg" alt-text="Diagram that shows a numbered flow in a baseline end-to-end chat architecture that uses OpenAI.":::
    The diagram resembles the baseline end-to-end chat architecture. It includes the Azure OpenAI architecture and three numbered network flows. The inbound flow and the flow from App Service to Azure PaaS services are copied from the baseline App Service web architecture. The Machine Learning managed online endpoint flow shows an arrow from the compute instance private endpoint in the client UI virtual network. The arrow points to the managed online endpoint. The second flow shows an arrow that points from the managed online endpoint to the compute cluster. The third flow shows arrows from the compute cluster to private endpoints that point to Container Registry, Storage, Azure OpenAI, and AI Search.
:::image-end:::

The inbound flow from the end user to the chat UI and the flow from App Service to [Azure PaaS services](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#app-service-to-azure-paas-services-flow) are described in the [baseline App Service web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). This section focuses on the Machine Learning online endpoint flow. It goes from the chat UI that runs in the baseline App Service web application to the flow that's deployed to Machine Learning compute:

1. The call from the App Service-hosted chat UI is routed through a private endpoint to the Machine Learning online endpoint.
1. The online endpoint routes the call to a server that runs the deployed flow. The online endpoint serves as both a load balancer and a router.
1. Calls to Azure PaaS services that the deployed flow requires are routed through managed private endpoints.

##### Ingress to Machine Learning

In this architecture, public access to the Machine Learning workspace is disabled. Users can access the workspace via private access because the architecture follows the [private endpoint for the Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link) configuration. Private endpoints are used throughout this architecture to complement identity-based security. For example, your App Service-hosted chat UI can connect to PaaS services that aren't exposed to the public internet, including Machine Learning endpoints.

Private endpoint access is also required to connect to the Machine Learning workspace for flow authoring.

:::image type="complex" source="_images/openai-end-to-end-aml-flow-authoring.svg" border="false" lightbox="_images/openai-end-to-end-aml-flow-authoring.svg" alt-text="Diagram that shows a user connecting to a Machine Learning workspace through a jump box to author a flow OpenAI.":::
    The diagram shows a user connecting to a jump box virtual machine through Azure Bastion. An arrow points from the jump box to a Machine Learning workspace private endpoint. Another arrow points from the private endpoint to the Machine Learning workspace. From the workspace, four arrows point to four private endpoints that connect to Container Registry, Storage, Azure OpenAI, and AI Search.
:::image-end:::

The diagram shows a prompt flow author that connects through Azure Bastion to a virtual machine (VM) jump box. From that jump box, the author can connect to the Machine Learning workspace through a private endpoint in the same network as the jump box. The author can also connect to the virtual network through Azure ExpressRoute or VPN gateways and virtual network peering.

##### Flow from the Azure AI Foundry managed virtual network to Azure PaaS services

We recommend that you configure the Azure AI Foundry hub for [managed virtual network isolation](/azure/ai-foundry/how-to/configure-managed-network), which requires the approval of all outbound connections. This architecture follows that recommendation. There are two types of approved outbound rules. *Required outbound rules* are for resources that the solution requires, such as Container Registry and Storage. *User-defined outbound rules* are for custom resources that your workflow uses, such as Azure OpenAI or AI Search. You must configure user-defined outbound rules. The required outbound rules are configured when the managed virtual network is created. The managed virtual network is deployed on demand when you first use it and is persistent from then on.

The outbound rules can be private endpoints, service tags, or FQDNs for external public endpoints. In this architecture, connectivity to Azure services is established through Private Link. This architecture doesn't include some common operations that might require you to configure an FQDN outbound rule, download a pip package, clone a GitHub repo, or download base container images from external repositories.

An Azure Firewall instance that's managed by Microsoft implements the outbound FQDN control and is deployed into an Azure AI Foundry managed network. Choose the Basic pricing tier if you need to control only HTTP (port 80) or HTTPS (port 443) egress traffic. If your egress traffic requires custom protocols or ports, choose the Standard pricing tier. This architecture uses the Basic pricing tier because the only egress traffic is to HTTPS endpoints on port 443.

##### Virtual network segmentation and security

The network in this architecture has separate subnets for the following purposes:

- Application Gateway
- App Service integration components
- Private endpoints
- Azure Bastion
- Jump box VMs
- Scoring
- Training and Scoring subnets
   > [!NOTE]
   > Training and Scoring subnets are designed so that you can use your own compute resources for training and inferencing. However, this architecture uses managed compute and doesn't do any training.

Each subnet has a network security group (NSG) that limits both inbound and outbound traffic for those subnets to only what they require. The following table shows a simplified view of the NSG rules that the baseline adds to each subnet. The table provides the rule name and function.

| Subnet   | Inbound traffic | Outbound traffic |
| -------  | ---- | ---- |
| snet-appGateway    | Allowances for chat UI user source IP addresses, such as the public internet, and required items for the service. | Access to the App Service private endpoint and required items for the service. |
| snet-PrivateEndpoints | Allow only traffic from the virtual network. | Allow only traffic to the virtual network. |
| snet-AppService | Allow only traffic from the virtual network. | Allow access to the private endpoints and Azure Monitor. |
| AzureBastionSubnet | See [Working with NSG access and Azure Bastion](/azure/bastion/bastion-nsg). | See [Working with NSG access and Azure Bastion](/azure/bastion/bastion-nsg). |
| snet-jumpbox |  Allow inbound Remote Desktop Protocol and Secure Shell Protocol from the Azure Bastion host subnet. | Allow access to the private endpoints. |
| snet-agents | Allow only traffic from the virtual network. | Allow only traffic to the virtual network. |
| snet-training | Allow only traffic from the virtual network. | Allow only traffic to the virtual network. |
| snet-scoring | Allow only traffic from the virtual network. | Allow only traffic to the virtual network. |

All other traffic is explicitly denied.

<!-- docutune:ignoredChange "public IP address" -->

Consider the following points when you implement virtual network segmentation and security.

- Enable [Azure DDoS Protection](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa7aca53f-2ed4-4466-a25e-0b45ade68efd) for the virtual network with a subnet that's part of an application gateway that has a public IP address.

- [Add an NSG](/azure/virtual-network/network-security-groups-overview) to every subnet when possible. Use the strictest rules that enable full solution functionality.

- Use [application security groups](/azure/virtual-network/tutorial-filter-network-traffic#create-application-security-groups) to group NSGs. Grouping NSGs simplifies rule creation for complex environments.

#### Key rotation

In this architecture, the Machine Learning managed online endpoint uses key-based authentication, so it's important to:

- Store the key in a secure store, like Key Vault, for on-demand access from authorized clients, such as the Azure web app that hosts the prompt flow container.

- Implement a key rotation strategy. If you [manually rotate the keys](/azure/storage/common/storage-account-keys-manage?tabs=azure-portal#manually-rotate-access-keys), create a key expiration policy and use Azure Policy to monitor whether the key was rotated.

#### OpenAI model fine-tuning

If you fine-tune OpenAI models in your implementation, consider the following guidance:

- If you upload training data for fine-tuning, use [customer-managed keys](/azure/ai-services/openai/encrypt-data-at-rest#customer-managed-keys-with-azure-key-vault) to encrypt that data.

- If you store training data in a store, such as Azure Blob Storage, use a customer-managed key for data encryption, a managed identity to control access to the data, and a private endpoint to connect to the data.

#### Governance through policy

To help ensure alignment with security, consider using Azure Policy and network policies so that deployments align to the requirements of the workload. The use of platform automation through policy reduces the burden of manual validation steps and helps ensure governance, even if pipelines are bypassed. Consider the following security policies:

- Disable key or other local authentication access in services like Azure AI services and Key Vault.

- Require specific configuration of network access rules or NSGs.

- Require encryption, such as the use of customer-managed keys.

#### Azure AI Foundry role assignments for Key Vault

The Azure AI Foundry managed identity requires both control plane (`Contributor`) and data plane (`Key Vault Administrator`) role assignments. These assignments give this identity read and write access to all secrets, keys, and certificates stored in the Azure Key Vault. If your workload uses services other than Azure AI Foundry that require access to secrets, keys, or certificates in Key Vault, your workload or security team might prefer that the Azure AI Foundry hub managed identity doesn't have access to those artifacts. In this scenario, consider deploying a Key Vault instance specifically for the Azure AI Foundry hub and other Key Vault instances as appropriate for other parts of your workload.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To see a pricing example for this scenario, use the [Azure pricing calculator](https://azure.com/e/a5a243c3b0794b2787e611c65957217f). You need to customize the example to match your usage because this example only includes the components that this architecture uses. The most expensive components in the scenario are DDoS Protection and the firewall that's deployed as part of the managed online endpoint. Other notable costs include the chat UI, prompt flow compute, and AI Search. Optimize those resources to reduce costs.

#### Compute

Prompt flow supports multiple options to host the executable flows. The options include managed online endpoints in Machine Learning, AKS, and App Service. Each of these options has its own billing model. The compute that you choose affects the overall cost of the solution.

#### Azure OpenAI

Azure OpenAI is a consumption-based service, so matching demand with supply is the primary way to control costs. To do that in Azure OpenAI, you need to use a combination of approaches:

- **Control clients.** Client requests are the primary source of cost in a consumption model, so controlling client behavior is crucial. All clients should:

  - Be approved. Avoid exposing the service in a way that supports free-for-all access. Limit access through network and identity controls, such as keys or role-based access control.

  - Be self controlled. Require clients to use the token-limiting constraints that API calls provide, such as max_tokens and max_completions.

  - Use batching, when practical. Review clients to ensure that they appropriately batch prompts.

  - Optimize prompt input and response length. Longer prompts consume more tokens, which increases cost. Prompts that lack sufficient context don't help the models produce good results. Create concise prompts that provide enough context to allow the model to generate a useful response. Ensure that you optimize the limit of the response length.

- **Use Azure OpenAI playground only as necessary.** You should only use the playground on preproduction instances so that those activities don't incur production costs.

- **Choose the right AI model.** The model that you choose affects the overall cost of Azure OpenAI. All models have strengths and weaknesses and are individually priced. Use the correct model for the use case to help prevent overspending on a more expensive model when a less expensive model produces acceptable results. This chat reference implementation uses GPT 3.5-turbo instead of GPT-4 to save model deployment costs while achieving sufficient results.

- **Understand billing breakpoints.** Fine-tuning is charged per hour. For maximum efficiency, use as much of that hour to improve the fine-tuning results before you reach the next billing hour. Similarly, the cost for 100 images from image generation is the same as the cost for one image. Maximize the price break points to your advantage.

- **Understand billing models.** Azure OpenAI is also available in a commitment-based billing model through the [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) offering. After you have predictable usage patterns, consider switching to this pre-purchase billing model if it's more cost-effective at your usage volume.

- **Set provisioning limits.** Allocate all provisioning quota only to models expected to be part of the workload, on a per-model basis. Throughput to already deployed models isn't limited to this provisioned quota while dynamic quota is enabled. Quota doesn't directly map to costs, and those costs might vary.

- **Monitor pay-as-you-go usage.** If you use pay-as-you-go pricing, [monitor usage](/azure/ai-services/openai/how-to/quota?tabs=rest#view-and-request-quota) of TPM and RPM. Use that information to inform architectural design decisions, like which models to use, and optimize prompt sizes.

- **Monitor provisioned throughput usage.** If you use [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput), monitor [provision-managed usage](/azure/ai-services/openai/how-to/monitoring) to help ensure that you don't underuse the provisioned throughput that you purchased.

- **Manage costs.** Follow the guidance about [using cost management features with OpenAI](/azure/ai-services/openai/how-to/manage-costs) to monitor costs, set budgets, and create alerts to notify stakeholders of risks or anomalies.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Built-in prompt flow runtimes

Like in the basic architecture, this architecture uses automatic runtime to minimize operational burden. The automatic runtime is a serverless compute option within Machine Learning that simplifies compute management and delegates most of the prompt flow configuration to the running application's `requirements.txt` file and `flow.dag.yaml` configuration. This choice is low maintenance, temporary, and application-driven. This architecture uses compute instance runtime or externalized compute, which requires the workload team to manage the lifecycle of the compute. You should use a compute instance runtime when your workload requirements exceed the configuration capabilities of the automatic runtime option.

#### Monitoring

Like in the basic architecture, diagnostics are configured for all services. All services except App Service are configured to capture all logs. App Service is configured to capture `AppServiceHTTPLogs`, `AppServiceConsoleLogs`, `AppServiceAppLogs`, and `AppServicePlatformLogs`. In production, all logs are likely excessive. Tune log streams to your operational needs. For this architecture, the Azure AI Foundry project uses the `AmlComputeClusterEvent`, `AmlDataSetEvent`, `AmlEnvironmentEvent`, and `AmlModelsEvent` Machine Learning logs.

Evaluate building custom alerts, such as those found in the Azure Monitor baseline alerts, for the resources in this architecture. For example:

- [Container Registry alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/ContainerRegistry/registries/)
- [Machine Learning and Azure OpenAI alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/CognitiveServices/accounts/)
- [Web Apps alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/Web/serverFarms/)

Be sure to monitor the usage of tokens against your Azure OpenAI model deployments. In this architecture, prompt flow tracks [token usage](/azure/ai-foundry/how-to/monitor-quality-safety) through its integration with Application Insights.

#### Language model operations

Deployment for Azure OpenAI-based chat solutions like this architecture should follow the guidance in [GenAIOps with prompt flow and Azure DevOps](/azure/machine-learning/prompt-flow/how-to-end-to-end-azure-devops-with-prompt-flow) and [GenAIOps with prompt flow and GitHub](/azure/machine-learning/prompt-flow/how-to-end-to-end-llmops-with-prompt-flow). Also, it must consider best practices for continuous integration and continuous delivery (CI/CD) and network-secured architectures. The following guidance addresses the implementation of flows and their associated infrastructure based on the GenAIOps recommendations. This deployment guidance doesn't include the front-end application elements, which are unchanged from the [baseline highly available zone-redundant web application architecture](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#deployment-flow).

##### Development

Prompt flow provides both a browser-based authoring experience in Azure AI Foundry portal or through a [Visual Studio Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension). Both of these options store the flow code as files. When you use the portal, the files are stored in a Storage account. When you work in VS Code, the files are stored in your local file system.

To follow [best practices for collaborative development](/azure/machine-learning/prompt-flow/how-to-integrate-with-llm-app-devops#follow-collaborative-development-best-practices),  maintain the source files in an online source code repository like GitHub. This approach helps track code changes, collaborate between flow authors, and integrate with [deployment flows](/azure/architecture/ai-ml/architecture/baseline-openai-e2e-chat#deployment-flow) that test and validate all code changes.

For enterprise development, use the [VS Code extension](/azure/machine-learning/prompt-flow/community-ecosystem#vs-code-extension) and the [prompt flow SDK/CLI](/azure/machine-learning/prompt-flow/community-ecosystem#prompt-flow-sdkcli) for development. Prompt flow authors can build and test their flows from VS Code and integrate the locally stored files with the online source control system and pipelines. The browser-based experience is designed for exploratory development, but you can work to integrate it with the source control system. You can download the flow folder from the flow page in the `Files` panel, unzip the folder, and push it to the source control system.

##### Evaluation

Test the flows that the chat application uses by using the same methods that you use to test other software artifacts. It's challenging to specify and assert a single correct answer for language model outputs, but you can use a language model to evaluate responses. Consider implementing the following automated evaluations of your language model flows:

- **Classification accuracy** evaluates whether the language model gives a correct or incorrect score and aggregates the outcomes to produce an accuracy grade.

- **Coherence** evaluates how well the sentences in a model's predicted answer are written and how they coherently connect with each other.

- **Fluency** assesses the model's predicted answer for its grammatical and linguistic accuracy.

- **Groundedness against context** evaluates how well the model's predicted answers are based on preconfigured context. Even if the language model responses are correct, if they can't be validated against the given context, then the responses aren't grounded.

- **Relevance** evaluates how well the model's predicted answers align with the question asked.

Consider the following guidance when you implement automated evaluations:

- Produce scores from evaluations and measure them against a predefined success threshold. Use these scores to report whether the tests pass or fail in your pipelines.

- Some of these tests require preconfigured data inputs of questions, context, and ground truth.

- Include enough question-and-answer pairs to help ensure that the results of the tests are reliable. We recommend that you include at least 100-150 pairs. These questions and answers are also known as your *golden dataset*. A larger number of pairs might be required, depending on the size and domain of your dataset.

- Avoid using language models to generate any of the data in your golden dataset.

##### Deployment flow

:::image type="complex" source="_images/openai-end-to-end-deployment-flow.svg" border="false" lightbox="_images/openai-end-to-end-deployment-flow.svg" alt-text="Diagram that shows the deployment flow for a prompt flow.":::
  The diagram shows the deployment flow for a prompt flow. It separates the flow into boxes, and arrows that show the direction of the flow connect the boxes. The diagram includes a local development step, a box that contains a pull request pipeline, a manual approval step, a development environment, a test environment, a production environment, a list of monitoring tasks, a CI pipeline, and a CD pipeline.
:::image-end:::

The following dataflow corresponds to the previous diagram:

1. The prompt engineer or data scientist opens a feature branch where they work on a specific task or feature. The prompt engineer or data scientist iterates on the flow by using prompt flow for VS Code and periodically commits changes and pushes those changes to the feature branch.

1. After local development and experimentation are complete, the prompt engineer or data scientist opens a pull request (PR) from the feature branch to the main branch. The PR triggers a PR pipeline. This pipeline runs fast quality checks that should include:

    - Execution of experimentation flows.
    - Execution of configured unit tests.
    - Compilation of the codebase.
    - Static code analysis.

1. The pipeline can contain a step that requires at least one team member to manually approve the PR before merging. The approver can't be the committer, and they must have prompt flow expertise and familiarity with the project's requirements. If the PR isn't approved, the merge is blocked. If the PR is approved, or if there's no approval step, the feature branch is merged into the main branch.

1. The merge to the main branch triggers the build and release process for the development environment.

   a. The CI pipeline is triggered from the merge to the main branch. The CI pipeline performs all the steps in the PR pipeline, and the following steps:

      - Experimentation flow
      - Evaluation flow
      - Flow registration in the Machine Learning registry when changes are detected

   b. The CI pipeline completes and then triggers the CD pipeline. This flow performs the following steps:

      - Deploys the flow from the Machine Learning registry to a Machine Learning online endpoint
      - Runs integration tests that target the online endpoint
      - Runs smoke tests that target the online endpoint

1. An approval process is built into the release promotion process. After approval, the CI/CD processes repeat, targeting the test environment. Steps *a.* and *b.* are the same, except that user acceptance tests run after the smoke tests in the test environment.

1. The CI/CD processes run to promote the release to the production environment after the test environment is verified and approved.

1. After release into a live environment, the operational tasks of monitoring performance metrics and evaluating the deployed language models occur. These tasks include:

    - Data drift detection.
    - Infrastructure observation.
    - Cost management.
    - Communication of the model's performance to stakeholders.

##### Deployment guidance

You can use Machine Learning endpoints to deploy models in a way that enables flexibility when you release them to production. Consider the following strategies to help ensure high model performance and quality:

- Use blue-green deployments to safely deploy your new version of the web service to a limited group of users or requests before you direct all traffic to the new deployment.

- Use A/B testing to deploy new behavior. A/B testing allows a subset of users to evaluate the effects of the change.

- Include linting of Python files that are part of the prompt flow in your pipelines. Linting checks for compliance with style standards, errors, code complexity, unused imports, and variable naming.

- Use a self-hosted agent to deploy artifacts to your Azure resources when you deploy your flow to the network-isolated Machine Learning workspace.

- Only update the Machine Learning model registry when there are changes to the model.

- Ensure that the language models, flows, and client UI are loosely coupled. You should be able to update the flows and the client UI without affecting the model and vice versa.

- When you develop and deploy multiple flows, each flow should have its own lifecycle. This approach helps keep flows loosely coupled when you promote them from experimentation to production.

##### Infrastructure

When you deploy the baseline Azure OpenAI end-to-end chat components, some of the provisioned services are foundational and permanent within the architecture. The lifecycles of other components are tied to a deployment. The managed virtual network is foundational and is automatically provisioned when you create a compute instance, so you need to consider the following components.

###### Foundational components

Some components in this architecture exist with a lifecycle that extends beyond any individual prompt flow or model deployment. These resources are typically deployed one time as part of the foundational deployment by the workload team. The workload team then maintains these resources separately from creating, removing, or updating the prompt flows or model deployments. These components include:

- The Machine Learning workspace.
- The Storage account for the Machine Learning workspace.
- Container Registry.
- AI Search.
- Azure OpenAI.
- Application Insights.
- Azure Bastion.
- The Azure VM for the jump box.

###### Temporary components

Some Azure resources are more tightly coupled with the design of specific prompt flows. This approach allows these resources to be bound to the lifecycle of the component and become temporary in this architecture. Azure resources are affected when the workload evolves, such as when flows are added or removed or when new models are introduced. These resources are re-created, and previous instances of them are removed. Some of these resources are Azure resources and some are data plane manifestations within their containing service.

- The model in the Machine Learning model registry should be updated, if it changes, as part of the CD pipeline.

- The container image should be updated in the container registry as part of the CD pipeline.

- A Machine Learning endpoint is created when a prompt flow is deployed if the deployment references an endpoint that doesn't exist. That endpoint needs to be updated to [turn off public access](/azure/machine-learning/concept-secure-online-endpoint#secure-inbound-scoring-requests).

- The Machine Learning endpoint's deployments are updated when a flow is deployed or deleted.

- The key vault for the client UI must be updated with the key to the endpoint when a new endpoint is created.

###### On-demand managed virtual network

The managed virtual network is automatically provisioned when you first create a compute instance. If you use IaC to deploy your hub, and you don't have Azure AI Foundry compute resources in Bicep, the managed virtual network isn't deployed and you receive an error when you connect to Azure AI Foundry portal. You need to [manually provision the managed virtual network](/azure/ai-foundry/how-to/configure-managed-network#manually-provision-a-managed-vnet) after your IaC deployment.

#### Resource organization

If you have a scenario where the hub is centrally owned by a team other than the workload team, you might choose to deploy projects to separate resource groups. If you use IaC, you can deploy projects to separate resource groups by setting a different resource group in Bicep. If you use the portal, you can set the `defaultWorkspaceResourceGroup` property under the `workspaceHubConfig` to the resource group you where you want to create your projects.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This section describes performance efficiency from the perspective of AI Search, Azure OpenAI, and Machine Learning.

#### Performance Efficiency in AI Search

Follow the guidance to [analyze performance in AI Search](/azure/search/search-performance-analysis).

#### Performance Efficiency in Azure OpenAI

- Determine whether your application requires [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) or the shared hosting, or consumption, model. Provisioned throughput helps ensure reserved processing capacity for your OpenAI model deployments. Reserved capacity provides predictable performance and throughput for your models. This billing model is unlike the shared hosting, or consumption, model. The consumption model is best-effort and might be subject to noisy neighbor or other problems on the platform.

- Monitor [provision-managed utilization](/azure/ai-services/openai/how-to/monitoring) for provisioned throughput.

#### Performance Efficiency in Machine Learning

If you deploy to Machine Learning online endpoints:

- Follow the guidance about how to [autoscale an online endpoint](/azure/machine-learning/how-to-autoscale-endpoints). Autoscaling helps you closely align with demand without overprovisioning, especially in low-usage periods.

- Choose the appropriate VM SKU for the online endpoint to meet your performance targets. To find an optimal configuration, test the performance of both lower instance counts and larger SKUs versus larger instance counts and smaller SKUs.

## Deploy this scenario

To deploy and run this reference implementation, follow the steps in the [OpenAI end-to-end baseline reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline/).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/) | Software Engineer II - Microsoft
- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) | Cloud Solution Architect - Microsoft
- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Patterns & Practices - Microsoft
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/) | Senior Software Engineer - Microsoft
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer - Microsoft
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/) | Senior Solution Architect - Microsoft

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

[Azure OpenAI baseline in an Azure landing zone](./azure-openai-baseline-landing-zone.yml)

## Related resources

- A Well-Architected Framework perspective on [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service)
- [Azure OpenAI language models](/azure/ai-services/openai/concepts/models)
- [Prompt flow in Azure AI Foundry portal](/azure/ai-foundry/how-to/prompt-flow)
- [Workspace managed virtual network isolation](/azure/machine-learning/how-to-managed-network)
- [Configure a private endpoint for a Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link)
- [Content filtering](/azure/ai-services/openai/concepts/content-filter)
