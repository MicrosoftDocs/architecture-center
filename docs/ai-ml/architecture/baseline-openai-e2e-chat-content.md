Enterprise chat applications have seen a resurgence of interest from companies, thanks to the advent of advanced Large Language Models such as GPT-3 and GPT-4. These chat applications consist of a user interface for chatting, data repositories containing domain-specific information pertinent to the user’s queries, Large Language Models (LLMs) that reason over the domain-specific data to produce a relevant response, and an orchestrator that oversees the interaction between these components.

This article provides a baseline architecture for building and deploying enterprise chat applications that use OpenAI Large Language Models (LLMs). The architecture employs Azure Machine Learning (AML) prompt flow to create executable flows that orchestrate the workflow from incoming prompts to data stores to fetch grounding data for the LLMs, along with any other Python logic required. The executable flow is deployed to an Azure Machine Learning compute cluster behind a managed online endpoint.

The chat UI follows the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant) guidance for deploying a secure, zone-redundant, and highly available web application on Azure App Services. In that architecture the App Service communicates to Azure PaaS services through virtual network integration over private endpoints. Likewise, the chat UI App Service communicates with the managed online endpoint for the flow over a private endpoint and public access to the Azure Machine Learning workspace is disabled.

> [!IMPORTANT]
> The article does not cover the components or architecture decisions from the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant). Please read that article for architectural guidance for the client UI.

The Machine Learning workspace is configured with [managed virtual network isolation](/azure/machine-learning/how-to-managed-network) that requires all outbound connections to be approved. With this configuration, a managed virtual network is created, along with managed private endpoints that enable connectivity to private resources such as the workplace Azure Storage, Azure Container Registry or Azure OpenAI. These private connections are used during flow authoring and testing, as well as by flows deployed to Azure Machine Learning compute.

> [!TIP]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by an [example implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline) which showcases a baseline end-to-end chat implementation on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Architecture

:::image type="complex" source="_images/openai-end-to-end-aml-deployment.svg" lightbox="_images/openai-end-to-end-aml-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI.":::
    The diagram shows the App Service baseline architecture with a private endpoint connecting to a managed online endpoint in an Azure Machine Learning managed virtual network. The managed online endpoint sits in front of an Azure Machine Learning compute cluster. The diagram show that the machine learning workspace has a dotted line pointing to the compute cluster, representing that the executable flow is deployed to the compute cluster. The managed virtual network has managed private endpoints that provide private connectivity to resources required by the executable flow such as the Azure Container Registry and Azure Storage. the diagram further shows user-defined private endpoints providing private connectivity to the Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 1: Baseline end-to-end chat architecture with OpenAI*

*Download a [Visio file](https://arch-center.azureedge.net/) of this architecture.*

## Components

Many of the components of this architecture are the same as those in the [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant), as the chat UI in this architecture follows the baseline app service web application's architecture. The components highlighted in this section focus on the components used to build and orchestrate chat flows, as well as data services and the services that expose the LLMs.

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a managed cloud service that's used to train, deploy, and manage machine learning models. This architecture uses several additional features of Azure Machine Learning used to develop and deploy executable flows for AI applications powered by Large Language Models:
  - [Azure Machine Learning prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) is a development tool that allows you to build, test, and deploy flows that link user prompts, actions through Python code and LLMs.
  - [Managed online endpoints](/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference) allow you to deploy a flow for real-time inference.
- [Azure Storage](https://azure.microsoft.com/services/storage) is used to persist the prompt flow source files for prompt flow development.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) enables you to build, store, and manage container images and artifacts in a private registry for all types of container deployments.
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) is a fully managed service that provides REST API access to OpenAI’s powerful language models, including the GPT-4, GPT-3.5-Turbo, and Embeddings model series1. In addition to model access, it adds enterprise features such as [virtual network and private link](/azure/ai-services/cognitive-services-virtual-networks), as well as [managed identity](/azure/ai-services/openai/how-to/managed-identity) support.
- [Azure AI Search](/azure/search/) is a cloud search service that supports [full-text search](/azure/search/search-lucene-query-architecture), [semantic search](/azure/search/semantic-search-overview), [vector search](/azure/search/vector-search-overview), and [hybrid search](/azure/search/vector-search-ranking#hybrid-search). This is included in the architecture, as it will be a common service used in chat applications.

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

Two flows in this diagram are covered in [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant): 1. the inbound flow and 2. the App Service to Azure PaaS services flow. Please see that article for details on those flows. This section focuses on the Azure Machine Learning online endpoint flow. The following details the flow from the client UI running in the baseline app services web application to the flow deployed to Azure Machine Learning compute:

> [!NOTE]
> The baseline app services web application's [App Service to Azure PaaS services flow](../../web-apps/web-apps/app-service/architectures/baseline-zone-redundant#app-service-to-azure-paas-services-flow) details how the App Service is able to connect to Azure PaaS services over private endpoints. This section discusses the specific connectivity to the Azure Machine Learning online endpoint.

1. The call from the App Service application is routed through a private endpoint to the Azure Machine Learning online endpoint.
1. The online endpoint routes the call to a web server running the deployed flow. The online endpoint acts as both a load balancer, as well as a router.
1. Calls to Azure PaaS services required by the deployed flow are routed through managed private endpoints.

### Ingress to Azure Machine Learning

In this architecture, public access to the Azure Machine Learning workspace is disabled. You must [configure a private endpoint for the Azure Machine Learning workspace](/azure/machine-learning/how-to-configure-private-link). Private endpoints are used throughout this architecture to improve security by allowing your App Service to connect to Private Link services, including Azure Machine Learning, directly from your private virtual network without using public IP addressing.

Private endpoint access is also required for connecting to the Azure Machine Learning workspace for flow authoring.

:::image type="complex" source="_images/openai-end-to-end-aml-flow-authoring.svg" lightbox="_images/openai-end-to-end-aml-flow-authoring.svg" alt-text="Diagram that shows a user connecting to an Azure Machine Learning workspace through a jumpbox to author a flow OpenAI with flow numbers.":::
    The diagram shows a user connecting to a jumpbox virtual machine through Azure Bastion. There is an arrow from the jumpbox to an Azure Machine Learning workspace private endpoint. There is another arrow from the private endpoint to the Azure Machine Learning workspace. From the workspace, there are four arrows pointed to four private endpoints that connect to Azure Container Registry, Azure Storage, Azure OpenAI service and Azure AI Search.
:::image-end:::
*Figure 3: Network flows for an Azure Machine Learning prompt flow author*

The diagram above shows a prompt flow author connecting through Azure Bastion to a virtual machine jumpbox. From that jumpbox, the author can connect to the Machine Learning Workspace through a private endpoint in the same network as the jumpbox. Connectivity to the virtual network is more commonly done in enterprises through ExpressRoute or virtual network peering.

### Flow from the Azure Machine Learning managed virtual network to Azure PaaS services

The Azure Machine Learning workspace was configured for [managed virtual network isolation](/azure/machine-learning/how-to-managed-network) with a configuration that requires all outbound connections to be approved. There are 2 types of approved outbound rules. *Required outbound rules* are to resources required for the solution to work, such as Azure Container Registry and Azure Storage. *User-defined outbound rules* are to resources, such as Azure OpenAI or Azure AI Search, that your workflow might take advantage of. It is your responsibility to configure user-defined outbound rules, while required outbound rules are configured when the managed virtual network is created.

The outbound rules can be private endpoints, service tags or FQDNs. In this architecture, connectivity to Azure services that support Private Link such as Azure Container Registry, Azure Storage, Azure Key Vault, Azure OpenAI service, and Azure AI Search are connected through via private link.

### Virtual network segmentation and security

TODO: Add differences between the baseline and this architecture

## Reliability

The [baseline app services web application](../../web-apps/app-service/architectures/baseline-zone-redundant) architecture focuses on zonal redundancy for key regional services. Availability zones are physically separate locations within a region. They provide zonal redundancy for supporting services when two or more instances are deployed in supporting regions. When one zone experiences downtime, the other zones may still be unaffected. The architecture also ensures enough instances of Azure services to meet demand. Please see the [baseline](../../web-apps/app-service/architectures/baseline-zone-redundant) to review that guidance.

This section addresses reliability from the perspective of the components in this architecture not addressed in the app services baseline, including Azure Machine Learning, Azure OpenAI, and Azure AI Search.

### Azure Machine Learning

Enterprise deployments usually require at least zonal redundancy. To achieve this in Azure, resources must support [availability zones](/azure/availability-zones/az-overview) and you must deploy at least 3 instances of the resource. Currently, Azure Machine Learning compute doesn’t offer support for availability zones. To mitigate the potential impact of a datacenter-level catastrophe on AML compute clusters, it’s necessary to establish clusters in various regions along with deploying a load balancer to distribute calls among these clusters. You would use health checks to help ensure that calls are only routed to clusters that are functioning properly.

Deploying prompt flows is not limited to Azure Machine Learning compute clusters. The executable flow, being a containerized application, can be deployed to any Azure service that is compatible with containers. This includes services like Azure Kubernetes Service (AKS), Azure Functions, Azure Container Apps (ACA), and Azure App Service. Each of the above named services have support for availability zones. To achieve zonal redundancy without the added complexity of a multi-region deployment, consider deploying your flows to one of the above services.

The following is an alternate architecture where prompt flows are deployed to Azure App Service. We chose App Service, because the architecture already supports it. Customers who have experience with AKS should also consider deploying in that environment.

:::image type="complex" source="_images/openai-end-to-end-app-service-deployment.svg" lightbox="_images/openai-end-to-end-app-service-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture with OpenAI with prompt flow deployed to Azure App Service.":::
    The diagram shows the App Service baseline architecture with 3 instances of a client App Service and 3 instances of a prompt flow app service. In addition to what is in the app service baseline architecture, this architecture includes private endpoints for Azure Container Registry, Azure AI Search, and Azure OpenAI. The architecture also shows an Azure Machine Learning workspace, used for authoring flows, running in a managed virtual network. The managed virtual network has managed private endpoints that provide private connectivity to resources required by the executable flow such as the Azure  Storage. The diagram further shows user-defined private endpoints providing private connectivity to the Azure OpenAI service and Azure AI Search. Lastly, there is a dotted line from the Machine Learning Workspace to the Azure Container Registry (ACR). This indicates that executable flows are deployed to ACR, where the prompt flow App Service can load it.
:::image-end:::
*Figure 4: Alternate end-to-end chat architecture with OpenAI deploying prompt flows to Azure App Services*

The diagram is numbered for areas that are noteworthy in this architecture:

1. Flows are still authored in Azure Machine Learning prompt flow and nothing has changed regarding the Azure Machine Learning network architecture. Flow authors still connect to AML through a private endpoint and the managed private endpoints are used to connect to Azure services when testing flows.
1. This dotted line indicates that containerized executable flows are pushed to Azure Container Registry (ACR). Not shown in the diagram are the pipelines that containerize the flows and push to ACR.
1. There are 3 additional instances of Azure App Service deployed to host the containerized prompt flow. These App Service instances will connect to ACR over a private endpoint when loading the container image.
1. The prompt flow App Service will connect to Azure AI Search and Azure OpenAI service over private endpoints deployed in our virtual network.

### Azure OpenAI

Azure OpenAI does not currently support availability zones. To mitigate the potential impact of a datacenter-level catastrophe on models deployed in Azure OpenAI, it’s necessary to deploy Azure OpenAI to various regions along with deploying a load balancer to distribute calls among the regions. You would use health checks to help ensure that calls are only routed to clusters that are functioning properly.

### Azure AI Search

Deploy Azure AI Search with Standard pricing tier or above in a [region that supports availability zones](/azure/search/search-reliability#prerequisites) and deploy 3 or more replicas. The replicas will automatically spread evenly across availability zones.

