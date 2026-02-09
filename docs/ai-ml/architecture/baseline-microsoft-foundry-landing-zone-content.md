This article is part of a series that builds on the [Baseline Microsoft Foundry chat reference architecture](baseline-microsoft-foundry-chat.yml). Review the baseline architecture so that you can identify necessary adjustments before you deploy it in an Azure application landing zone subscription.

This article describes a generative AI workload architecture that deploys the baseline chat application but uses resources that are outside the workload team's scope. Platform teams centrally manage the resources, and multiple workload teams use them. Shared resources include networking resources for cross-premises connections, identity access management systems, and policies. This guidance helps organizations that use Azure landing zones maintain consistent governance and cost efficiency.

Foundry uses resources and projects to organize AI development and deployment. For example, a landing zone implementation might use a Foundry resource as a centralized resource at a business group level and projects as a delegated resource for each workload in that business group. Because of resource organization factors, and cost allocation limitations, we don't recommend this topology, and this article doesn't provide guidance about it. Instead, this architecture treats the workload as the owner of the Foundry resource, which is the recommended approach.

As a workload owner, you delegate shared resource management to platform teams so that you can focus on workload development efforts. This article presents the workload team's perspective and specifies recommendations for the platform team.

> [!IMPORTANT]
> **What are Azure landing zones?**
>
> Azure landing zones divide your organization's cloud footprint into two key areas:
>
> - An application landing zone is one or more Azure subscriptions where a workload runs. An application landing zone connects to your organization's shared platform resources. That connection provides the landing zone with access to the infrastructure that supports the workload, such as networking, identity access management, policies, and monitoring.
>
> - A platform landing zone is a collection of various subscriptions that multiple platform teams can manage. Each subscription has a specific function. For example, a connectivity subscription provides centralized Domain Name System (DNS) resolution, cross-premises connectivity, and network virtual appliances (NVAs) for platform teams.
>
> To help you implement this architecture, understand [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone), their [design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles), and their [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

## Article layout

| Architecture | Design decisions | Azure Well-Architected Framework approach |
| --- | --- | --- |
|&#9642; [Architecture diagram](#architecture)<br>&#9642; [Workload resources](#workload-team-owned-resources)<br>&#9642; [Federated resources](#platform-team-owned-resources) |&#9642; [Subscription setup](#subscription-setup)<br>&#9642; [Networking](#networking)<br>&#9642; [Data scientist access](#data-scientist-and-agent-developer-access)<br>&#9642; [Monitor resources](#monitor-resources)<br>&#9642; [Organizational governance](#azure-policy)<br>&#9642; [Change management](#manage-changes-over-time)|&#9642; [Reliability](#reliability)<br>&#9642; [Security](#security)<br>&#9642; [Cost Optimization](#cost-optimization)<br>&#9642; [Operational Excellence](#operational-excellence)<br>&#9642; [Performance Efficiency](#performance-efficiency) |

> [!TIP]
> :::image type="icon" source="../../_images/github.svg"::: The [Foundry Agent Service chat baseline reference implementation](https://github.com/Azure-Samples/microsoft-foundry-baseline-landing-zone) demonstrates the best practices described in this article. Review and try these deployment resources before you choose and implement your design decisions.

## Architecture

:::image type="complex" source="./_images/baseline-microsoft-foundry-landing-zone.svg" lightbox="./_images/baseline-microsoft-foundry-landing-zone.svg" alt-text="Architecture diagram of the workload, including select platform subscription resources." border="false":::
    This architecture diagram contains two primary sections. The top blue section is labeled application landing zone subscription. The bottom yellow section is labeled platform landing zone subscription. The top box contains both workload-created resources and subscription-vending resources. The workload resources consist of Azure Application Gateway and Azure Web Application Firewall, App Service and its integration subnet, and private endpoints for platform as a service (PaaS) solutions such as Azure Storage, Azure Key Vault, Azure AI Search, Foundry, Azure Cosmos DB, and Azure Storage. The workload resources also have a Foundry project with Agent Service and monitoring resources. App Service has three instances in different Azure zones. The platform subscription contains a hub virtual network, Azure Firewall, Azure Bastion, and a grayed-out Azure VPN Gateway and Azure ExpressRoute. A spoke virtual network in the application landing zone and the hub virtual network connect via virtual network peering. Controlled egress traffic goes from the application landing zone to Azure Firewall in the platform landing zone. A flow goes from App Service to the App Service integration subnet, to private endpoints, and then to the services of the private endpoints.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-microsoft-foundry-landing-zone.vsdx) of this architecture.*

### Components

All Azure landing zone architectures separate ownership between the platform team and the workload team, which is referred to as [subscription democratization](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization). Application architects, data scientists, and DevOps teams must clearly understand this division to determine what falls under their direct influence or control and what doesn't.

Like most application landing zone implementations, the workload team primarily manages the configuration, deployment, and oversight of workload components, including the AI services in this architecture.

#### Workload team-owned resources

The following resources remain mostly unchanged from the [baseline architecture](./baseline-microsoft-foundry-chat.yml#components).

- **[Foundry resource](/azure/ai-foundry/what-is-foundry)** and **[projects](/azure/ai-foundry/how-to/create-projects)** is an application platform for AI developers and data scientists to build, evaluate, and deploy AI models and host agents. In this architecture, the Foundry resource enables the workload team to host generative AI models as a service (MaaS), implement content safety, and establish workload-specific connections to knowledge sources and tools.

  If your organization's AI Center of Excellence restricts access to AI model deployments, the workload team might not host models in their own Foundry resource. Instead, they might need to use [centralized AI resources](/azure/cloud-adoption-framework/scenarios/ai/plan) such as an AI hub. In this scenario, all model consumption usually flows through an AI gateway that your AI platform team provides.

  This article assumes that generative AI models in this scenario are workload owned and hosted resources. If they're not, the model host or an [AI gateway](/azure/api-management/genai-gateway-capabilities) becomes a workload dependency. The platform team must maintain reliable network connectivity from your virtual network to their virtual network or a private endpoint must be established.

- **[Agent Service](/azure/ai-services/agents/overview)** is a cloud-native runtime environment that enables intelligent agents to operate securely and autonomously. In this architecture, Agent Service provides the orchestration layer for chat interactions. It hosts and manages the chat agent that processes user requests. This architecture supports both declarative and containerized agents.

  Use the [standard agent setup](/azure/ai-services/agents/concepts/standard-agent-setup) in this architecture. Connect your agent to a dedicated subnet in your spoke virtual network, and route egress traffic through your connectivity subscription.

  The workload team supplies dedicated Azure resources for agent state, chat history, and file storage. These resources are [Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db), [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage), and [Azure AI Search](/azure/search/search-what-is-azure-search). Your Agent Service instance manages these resources and their data exclusively. Other application components in your workload or other workloads in your organization shouldn't use them.

- **[Azure App Service](/azure/app-service/overview)** enables developers to build web and mobile apps and automate business processes with API apps. In this architecture, it hosts the web application that contains the chat user interface (UI) and delivers the user-facing component, with multiple instances across zones for availability.

  An Azure Storage account hosts the web application's code as a ZIP file, which mounts within App Service.

- **[AI Search](/azure/search/search-what-is-azure-search)** is a scalable search infrastructure that indexes heterogeneous content and enables data retrieval through APIs, applications, and AI agents. In this architecture, Foundry IQ powered by AI Search serves as the workload knowledge store for the [Retrieval Augmented Generation pattern](/azure/search/retrieval-augmented-generation-overview). This pattern extracts an appropriate query from a prompt, queries AI Search, and uses the results as grounding data for a generative AI foundation model.

- **[Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)** is a web traffic load balancer and application delivery controller. In this architecture, it acts as the reverse proxy to route user requests to the chat UI hosted in App Service. It hosts an Azure web application firewall to help protect the front-end application from potentially malicious traffic.

- **[Azure Key Vault](/azure/key-vault/general/basic-concepts)** is a cloud service for securely storing and accessing secrets, keys, and certificates. In this architecture, it stores the application gateway's Transport Layer Security (TLS) certificate.

- **[Azure Monitor](/azure/azure-monitor/fundamentals/overview)**, **[Azure Monitor Logs](/azure/azure-monitor/logs/get-started-queries)**, and **[Application Insights](/azure/well-architected/service-guides/application-insights)** collect, store, and visualize observability data. In this architecture, they enable monitoring, diagnostics, and operational insights for all workload components.

- **[Azure Policy](/azure/governance/policy/overview)** applies workload-specific policies to help govern, secure, and apply controls at scale. In this architecture, it enforces governance and compliance rules on resources that the workload team manages.

The workload team also maintains the following resources:

- **Spoke virtual network subnets and the network security groups (NSGs)** maintain segmentation and control traffic flow between subnets. In this architecture, they enforce network boundaries and security between workload components.

- **Private endpoints** secure connectivity to platform as a service (PaaS) solutions. In this architecture, they ensure that sensitive services are only accessible within the private network, which reduces exposure to the public internet. Additional dependencies, such as state stores owned by other team, can be exposed to your workload as a private endpoint, avoiding transitive routing through the connectivity subscription.

#### Platform team-owned resources

The platform team owns and maintains the following centralized resources. This architecture assumes that these resources are pre-provisioned and treats them as dependencies.

- **[Azure Firewall](/azure/well-architected/service-guides/azure-firewall)** is a managed, cloud-based network security service. In this architecture, Azure Firewall in the hub network routes, inspects, and restricts egress traffic that originates from the workload, including agent traffic. Workload egress traffic goes to the internet, cross-premises destinations, or to other application landing zones.

  *Change from the baseline:* In the baseline architecture, the workload team owns this component. In this architecture, the platform team manages it under the connectivity subscription.

- **[Azure Bastion](/azure/bastion/bastion-overview)** is a managed PaaS service that you use to connect to virtual machines via private IP address. In this architecture, Azure Bastion in the hub network provides secure operational access to workload components and allows access to Foundry components. It ensures that administrators and support staff can securely connect to virtual machines without exposing RDP/SSH ports to the public internet.

  *Change from the baseline:* In the baseline architecture, the workload team owns this component.

- The **spoke virtual network** is where the workload is deployed.

  *Change from the baseline:* In the baseline architecture, the workload team owns this network.

- **User-defined routes (UDRs)** enforce tunneling to the hub network's firewall.

  *Change from the baseline:* In the baseline architecture, the workload team owns this routing.

- **Azure Policy-based governance constraints** and `DeployIfNotExists` (DINE) policies apply to the workload subscription. You can apply these policies at the platform team-owned management group level or to the workload's subscription directly.

  *Change from the baseline:* These policies are new in this architecture. The platform team applies policies that constrain your workload. Some policies might duplicate existing workload constraints or introduce new constraints.

- **Azure private DNS zones** host `A` records for private endpoints so that workload components can securely resolve the FQDN of PaaS services used within the workload. For more information, see [Azure Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).

  *Change from the baseline:* In the baseline architecture, the workload team owns this network. In this architecture, the platform team manages this component under the connectivity subscription.

- **DNS resolution service** supports spoke virtual networks and cross-premises workstations. This service typically uses Azure Firewall as a DNS proxy or Azure DNS Private Resolver. In this architecture, the service resolves private endpoint DNS records for all DNS requests from the spoke. DNS Private Resolver and linked rulesets is the recommended way for the platform team to enable this architecture resolution requirements due to the DNS resolution characteristics of Agent Service.

- **[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview)** helps protect public IP addresses from distributed attacks. In this architecture, DDoS Protection helps safeguard the public IP address that's associated with Application Gateway.

  *Change from the baseline:* In the baseline architecture, the workload team purchases DDoS Protection.

> [!IMPORTANT]
> Azure landing zones provide some of the preceding resources as part of the platform landing zone subscriptions. Your workload subscription provides other resources. Many of these resources reside in the connectivity subscription, which also includes Azure ExpressRoute, Azure VPN Gateway, and DNS Private Resolver. These resources provide cross-premises access and name resolution. The management of these resources falls outside the scope of this article.

## Subscription setup

The workload team must inform the platform team of specific landing zone requirements to implement this architecture. And the platform team must communicate its requirements to the workload team.

For example, the workload team must provide detailed information about the required networking space. The platform team uses this information to allocate the necessary resources. The workload team defines the requirements, and the platform team assigns the appropriate IP addresses within the virtual network.

The platform team assigns a management group based on the workload's business criticality and technical needs. For instance, if the workload is exposed to the internet, like this architecture, the platform team selects an appropriate management group. To establish governance, the platform team also configures and implements management groups. The workload team must design and operate the workload within the constraints of this governance. For more information about typical management group distinctions, see [Tailor the Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/tailoring-alz).

The platform team sets up the subscription for this architecture. The following sections provide guidance about the initial subscription setup.

### Workload requirements and fulfillment

The workload team and platform team must collaborate on details like management group assignment, Azure Policy governance, and networking setup. Prepare a checklist of requirements to initiate discussion and negotiation with the platform team. The following checklist serves as an example.

| &nbsp; | Design consideration | Workload requirement for this architecture |
| ------ | :------------------- | :----------------------------------------- |
|&#9744;|**The number of spoke virtual networks and their size:** The platform team creates and configures the virtual network, then peers it to the regional hub to designate it as a spoke. They also need to ensure that the network can accommodate future workload growth. To carry out these tasks effectively, they must know the number of spokes required. | Deploy all resources in a single, dedicated spoke virtual network. Request `/22` contiguous address space to support full-scale operations and scenarios like side-by-side deployments. <br><br> The following factors determine most IP address needs: <br><br> - Application Gateway requirements for the subnet size (fixed size). <br><br>- Private endpoints with single IP addresses for PaaS services (fixed size). <br><br> - The subnet size for build agents (fixed size). <br><br> - Agent Service requires a subnet within a `/24` prefix. |
|&#9744;|**Virtual network address prefixes:** Typically, the platform team assigns IP addresses based on existing conventions, avoidance of overlap with peered networks, and availability within the IP address management (IPAM) system. | The agent integration subnet must use a valid private address prefix. Agent Service supports subnets that use `10.0.0.0/8`, `172.16.0.0/12`, or `192.168.0.0/16`. Ask your platform team to provide a spoke that has a valid address prefix for your agent subnet. |
|&#9744;|**Deployment region:** The platform team needs to deploy a hub in the same region as the workload resources. | Communicate the selected region for the workload and the regions for underlying compute resources. Ensure that the regions support availability zones. [Azure OpenAI in Foundry Models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#model-summary-table-and-region-availability) has limited regional availability. |
|&#9744;|**Data sovereignty:** The platform team needs to honor all data residency requirements the workload has. | If your workload requires strict data residency, ensure the platform team isn't duplicating Azure Diagnostics logs or sending data to Purview in a region not allowed by your requirements. |
|&#9744;|**Type, volume, and pattern of traffic:** The platform team needs to determine the ingress and egress requirements of your workload's shared resources. | Provide information about the following factors: <br><br> - How users should consume this workload. <br><br> - How this workload consumes its surrounding resources. <br><br> - The configured transport protocol. <br><br> - The traffic pattern and the expected peak and off-peak hours. Communicate when you expect a high number of concurrent connections to the internet (chatty) and when you expect the workload to generate minimal network traffic (background noise). |
|&#9744;|**Firewall configuration:** The platform team needs to set rules to allow legitimate egress traffic.| Share details about outbound traffic from the spoke network, including agent traffic. <br><br> Build agent and jump box machines need regular OS patching. <br><br> Agents might need to interact with internet grounding sources, tools, or other agents hosted outside the workload. |
|&#9744;|**Ingress traffic from specialized roles:** The platform team needs to provide the specified roles with network access to the workload and implement proper segmentation.|Work with the platform team to determine the best way to allow authorized access for the following roles: <br><br> - Data scientists and developers that access the Foundry portal from their workstations on corporate network connections <br><br> - Operators that access the compute layer through a workload-managed jump box |
|&#9744;|**Public internet access to the workload:** The platform team uses this information for risk assessment, which drives several decisions: <br><br> - The placement of the workload in a management group with appropriate guardrails <br><br> - Distributed denial-of-service (DDoS) protection for the public IP address reported by the workload team <br><br> - TLS certificate procurement and management | Inform the platform team about the ingress traffic profile: <br><br> - Internet-sourced traffic that targets the public IP address on Application Gateway <br><br> - Fully qualified domain names (FQDNs) associated with the public IP address for TLS certificate procurement |
|&#9744;|**Private endpoint usage:** The platform team needs to set up Azure private DNS zones for the private endpoints and ensure that the firewall in the hub network performs DNS resolution correctly. | Inform the platform team about all resources that use private endpoints, including the following resources: <br> - AI search <br> - Azure Cosmos DB for NoSQL <br> - Key Vault <br> - Foundry <br> - Storage accounts <br><br> Understand how the hub handles DNS resolution, and define the workload team's responsibilities for the management of private DNS zone records and DNS Private Resolver ruleset linking. |
|&#9744;|**Centralized AI resources:** The platform team must understand the expected usage of models and hosting platforms. They use this information to establish networking to centralized AI resources within your organization. <br><br> Each organization defines its own [AI adoption and governance plans](/azure/cloud-adoption-framework/scenarios/ai/plan), and the workload team must operate within those constraints. | Inform the platform team about AI and machine learning resources that you plan to use. This architecture uses Foundry, Agent Service, and generative foundation models hosted in Foundry Models. <br><br> Clearly understand which centralized AI services you must use and how those dependencies affect your workload. |

> [!IMPORTANT]
> The platform team should follow a subscription vending process that uses a structured set of questions to collect information from the workload team. These questions might vary across organizations, but the goal is to gather the necessary input to implement subscriptions effectively. For more information, see [Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).

## Compute

The orchestration layer and chat UI hosting remain the same as the [baseline architecture](./baseline-microsoft-foundry-chat.yml).

## Networking

In the [baseline architecture](./baseline-microsoft-foundry-chat.yml#networking), the workload is provisioned in a single virtual network.

*Change from the baseline:* This architecture divides the workload over two virtual networks. One network hosts workload components. The other network manages internet and hybrid connectivity. The platform team determines how the workload's virtual network integrates with the organization's larger network architecture, which typically follows a hub-spoke topology.

:::image type="complex" source="./_images/baseline-landing-zone-networking.svg" lightbox="./_images/baseline-landing-zone-networking.svg" alt-text="Architecture diagram that focuses mostly on network ingress flows." border="false":::
    This architecture diagram has a top blue section labeled application landing zone subscription that contains a spoke virtual network. The virtual network contains six subnets. The subnets are labeled snet-appGateway, snet-buildAgents, snet-jumpBoxes, snet-appServicePlan, snet-agentsEgress, and snet-privateEndpoints. The snet-privateEndpoints subnet has private endpoints for App Service, Azure Storage, Key Vault, Foundry, a knowledge store, Azure AI Search, Azure Cosmos DB, and another Azure Storage instance. The last three private endpoints are labeled Agent Service dependencies. Each subnet has an NSG, and all but the snet-appGateway subnet has a UDR that goes to the hub. Ingress traffic from on-premises and off-premises users points to the application gateway. A data scientist user connects the VPN gateway or ExpressRoute in the bottom section that's labeled connectivity subscription. The connectivity subscription contains private DNS zones for Private Link, DNS Private Resolver, and DDoS Protection. The hub virtual network in the connectivity subscription connects to the spoke virtual network via virtual network peering. The hub provides DNS to the spoke virtual network.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-landing-zone-networking.vsdx) of this architecture.*

- **Hub virtual network:** This virtual network serves as a regional hub that contains centralized, and often shared, services that communicate with workload resources in the same region. The hub resides in the [connectivity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity). The platform team owns the resources in this network.

- **Spoke virtual network:** In this architecture, the single virtual network from the baseline architecture essentially becomes the spoke virtual network. The platform team peers this spoke network to the hub network. They own and manage the spoke network, including its peering and DNS configuration. The workload team owns the resources in this network, including its subnets. This network contains many of the [workload resources](#workload-team-owned-resources).

Because of this division of management and ownership, the workload team must clearly [communicate the workload's requirements](#subscription-setup) to the platform team.

> [!IMPORTANT]
> **For the platform team:**
> Don't directly peer the spoke network to another spoke network, unless the workload specifically requires it. This practice protects the segmentation goals of the workload. Your team must facilitate all transitive virtual network connections. However, if application landing zone teams directly connect their networks by using self-managed private endpoints, your team doesn't manage those connections.
>
> Understand which workload resources external teams manage. For example, understand the network connectivity between the chat agents and a grounding context vector database that another team manages.

### Virtual network subnets

In the spoke virtual network, you create and allocate the subnets based on the workload requirements. To provide segmentation, apply controls that restrict traffic into and out of the subnets. This architecture doesn't add subnets beyond the [subnets in the baseline architecture](./baseline-microsoft-foundry-chat.yml#virtual-network-segmentation-and-security). However, the network architecture no longer requires the `AzureBastionSubnet` or `AzureFirewallSubnet` subnets because the platform team likely hosts this capability in their subscriptions.

You still have to implement local network controls when you deploy your workload in an Azure landing zone. Your organization might impose further network restrictions to safeguard against data exfiltration and ensure visibility for the central security operations center and the IT network team.

### Ingress traffic

The [ingress traffic flow remains the same as the baseline architecture](./baseline-microsoft-foundry-chat.yml#network-flows).

You manage resources related to public internet ingress into the workload. For example, in this architecture, Application Gateway and its public IP address reside in the spoke network rather than the hub network. Some organizations place ingress-facing resources in a connectivity subscription by using a centralized perimeter network (also known as DMZ, demilitarized zone, and screened subnet) implementation. Integration with that specific topology falls outside the scope of this article.

#### Alternate approach to inspecting incoming traffic

This architecture doesn't use Azure Firewall to inspect incoming traffic, but sometimes organizational governance requires it. In those cases, the platform team supports the implementation to provide workload teams with an extra layer of intrusion detection and prevention. This layer helps block unwanted inbound traffic. To support this topology, this architecture requires more UDR configurations. For more information, see [Zero Trust network for web applications with Azure Firewall and Application Gateway](../../example-scenario/gateway/application-gateway-before-azure-firewall.md).

### DNS configuration

In the baseline architecture, all components use Azure DNS directly for DNS resolution.

*Change from the baseline:* In this architecture, typically one or more DNS servers in the hub handle DNS resolution. When the virtual network is created, the DNS properties on the virtual network should already be set accordingly. The workload team doesn't need to understand the implementation details of the DNS service.

This architecture configures the workload components with DNS in the following ways.

| Component | DNS configuration |
| :-------- | :---------------- |
| Application Gateway | Inherited from virtual network |
| App Service (chat UI) | Inherited from virtual network |
| AI Search | Can't be overridden, uses Azure DNS |
| Foundry | Can't be overridden, uses Azure DNS |
| Agent Service | Can't be overridden, uses Azure DNS |
| Azure Cosmos DB | Can't be overridden, uses Azure DNS |
| Jump box | Inherited from virtual network |
| Build agents | Inherited from virtual network |

This architecture doesn't configure DNS settings for components that don't initiate outbound communication. These components don't require DNS resolution.

Many components in this architecture rely on DNS records hosted in the hub's DNS servers to resolve this workload's private endpoints. For more information, see [Azure private DNS zones](#private-dns-zones).

When hub-based DNS resolution isn't possible, those components face the following limitations:

- The platform team can't log DNS requests, which might violate an organizational security team requirement.

- Resolving to Private Link-exposed services in your landing zone or other application landing zones might be impossible.

We recommend that you familiarize yourself with how the platform team manages DNS. For more information, see [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale). When you add component features that directly depend on Azure DNS, you might introduce complexities in the platform-provided DNS topology. You can redesign components or negotiate exceptions to minimize complexity.

### Egress traffic

In the baseline architecture, all egress traffic routes to the internet through Azure Firewall.

*Change from the baseline:* In this architecture, the platform provides a UDR that points to an Azure Firewall instance that it hosts. Apply this UDR to the same subnets in the baseline architecture.

All traffic that leaves the spoke virtual network, including traffic from the agent integration subnet, reroutes through the peered hub network via an egress firewall.

:::image type="complex" source="./_images/baseline-landing-zone-networking-egress.svg" lightbox="./_images/baseline-landing-zone-networking-egress.svg" alt-text="Architecture diagram that focuses mostly on network egress flows." border="false":::
    The top blue section of this architecture diagram is labeled application landing zone subscription and contains a spoke virtual network. The spoke virtual network contains six subnets: snet-appGateway, snet-buildAgents, snet-jumpBoxes, snet-appServicePlan, snet-agentsEgress, and snet-privateEndpoints. The snet-privateEndpoints subnet has private endpoints for App Service, Azure Storage, Key Vault, Foundry, a knowledge store, AI Search, Azure Cosmos DB, and another Azure Storage instance. The last three private endpoints are labeled Agent Service dependencies. All the subnets, except for snet-appGateway, have a dashed line to Azure Firewall, which is in the bottom section. The bottom section is labeled Connectivity subscription. Azure Firewall has a dashed line that points to the internet represented as a cloud. The top section reads Where possible, all workload-originated, internet-bound traffic flows through the hub because of the 0.0.0.0/0 UDR. The hub virtual network in the bottom section and the spoke virtual network in the top section connect via virtual network peering.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-landing-zone-networking-egress.vsdx) of this architecture.*

East-west client communication to the private endpoints for Key Vault, Foundry, and other services remains the same as the [baseline architecture](./baseline-microsoft-foundry-chat.yml#networking). The preceding diagram doesn't include that path.

#### Route internet traffic to the firewall

All subnets in the spoke network include a route that directs all internet-bound traffic, or `0.0.0.0/0` traffic, to the hub's Azure Firewall instance.

| Component | Mechanism to force internet traffic through the hub |
| :-------- | :---------------- |
| Application Gateway | None. Internet-bound traffic that originates from this service can't be forced through the platform team's firewall. |
| App Service (chat UI) | [Regional virtual network integration](/azure/app-service/configure-vnet-integration-enable) and the [vnetRouteAllEnabled](/azure/app-service/configure-vnet-integration-routing#configure-application-routing) setting are enabled. |
| AI Search | None. Traffic that originates from this service can't be forced through a firewall. This architecture doesn't use skills. |
| Agent Service | A UDR applied to the snet-agentsEgress subnet. |
| Jump boxes | A UDR applied to the snet-jumpbox subnet. |
| Build agents | A UDR applied to the snet-agents subnet. |

This architecture doesn't configure force tunneling for components that don't initiate outbound communication.

For components or features that can't route egress traffic through the hub, your workload team must align with organizational requirements. To meet those requirements, use compensating controls, redesign the workload to exclude unsupported features, or request formal exceptions. You're responsible for mitigating data exfiltration and abuse.

Apply the platform-provided internet route to all subnets, even if you don't expect the subnet to have outgoing traffic. This approach ensures that unexpected deployments in that subnet go through routine egress filtering. For subnets that contain private endpoints, enable network policies to support full routing and NSG control.

This route configuration ensures that all outbound connections from App Service, Foundry and its projects, and any other services that originate from the workload's virtual network are inspected and controlled.

<a name='private-dns-zones'></a>

### Azure private DNS zones

Workloads that use private endpoints for east-west traffic require DNS zone records in the configured DNS provider. To support Private Link, this architecture relies on many DNS zone records for services such as Key Vault, Foundry, and Azure Storage.

*Change from the baseline:* In the baseline architecture, the workload team directly manages the private DNS zones. In this architecture, the platform team typically maintains private DNS zones. The workload team must clearly understand the platform team's requirements and expectations for the management of the private DNS zone records. The platform team can use other technology instead of private DNS zone records.

In this architecture, the platform team must set up DNS for the following Foundry FQDN API endpoints:

- `privatelink.services.ai.azure.com`
- `privatelink.openai.azure.com`
- `privatelink.cognitiveservices.azure.com`

The platform team must also set up DNS for the following FQDNs, which are Agent Service dependencies:

- `privatelink.search.windows.net`
- `privatelink.blob.core.windows.net`
- `privatelink.documents.azure.com`

> [!IMPORTANT]
> DNS resolution must function correctly from within the spoke virtual before you deploy the capability host for Agent Service and during operation of the Agent Service. The Agent Service capability doesn't use your spoke virtual network's DNS configuration. Therefore, it's recommended that your platform team configure a ruleset for the workload's private DNS zones in DNS Private Resolver, linking those rules to your application landing zone spoke.
>
> Before you deploy Foundry and its agent capability, you must wait until the Agent Service dependencies are fully resolvable to their private endpoints from within the spoke network. This requirement is especially important if DINE policies handle updates to DNS private zones. If you attempt to deploy the Agent Service capability before the private DNS records are resolvable from within your subnet, the deployment fails.

The platform team must also host the private DNS zones for other workload dependencies in this architecture:

- `privatelink.vaultcore.azure.net`
- `privatelink.azurewebsites.net`

## Data scientist and agent developer access

Like the [baseline architecture](./baseline-microsoft-foundry-chat.yml#ingress-to-foundry), this architecture disables public ingress access to the Foundry portal and other browser-based experiences. The baseline architecture deploys a jump box to provide a browser with a source IP address from the virtual network that various workload roles use.

When your workload connects to an Azure landing zone, your team gains more access options. Work with the platform team to see if you can get private access to various browser-based Foundry portals without managing and governing a virtual machine (VM). This access might be possible through transitive routing from an existing ExpressRoute or VPN Gateway connection.

Native workstation-based access requires cross-premises routing and DNS resolution, which the platform team can help provide. Include this requirement in your subscription vending request.

Providing native workstation-based access to these portals improves productivity and simplifies maintenance compared to managing VM jump boxes.

### The role of the jump box

The jump box in this architecture provides value for operational support, not for runtime purposes or AI and machine learning development. The jump box can troubleshoot DNS and network routing problems because it provides internal network access to otherwise externally inaccessible components.

In the baseline architecture, Azure Bastion accesses the jump box, which you manage.

In this architecture, Azure Bastion is deployed in the connectivity subscription as a shared regional resource that the platform team manages. To demonstrate that use case in this architecture, Azure Bastion is in the connectivity subscription and your team doesn't deploy it.

The VM that serves as the jump box must comply with organizational requirements for VMs. These requirements might include items such as corporate identities in Microsoft Entra ID, specific base images, and patching regimes.

## Monitor resources

The Azure landing zone platform provides shared observability resources as part of the management subscription. However, we recommend that you provision your own monitoring resources to facilitate ownership responsibilities of the workload. This approach aligns with the [baseline architecture](./baseline-microsoft-foundry-chat.yml#monitoring).

You provision the following monitoring resources:

- Application Insights serves as the application performance management (APM) service for your team. You configure this service in the chat UI, Agent Service, and models.

- The Azure Monitor Logs workspace serves as the unified sink for all logs and metrics from workload-owned Azure resources.

Similar to the baseline architecture, all resources must send Azure diagnostics logs to the Azure Monitor Logs workspace that your team provisions. This configuration is part of the infrastructure as code (IaC) deployment of the resources. You might also need to send logs to a central Azure Monitor Logs workspace. In Azure landing zones, that workspace typically resides in the management subscription.

The platform team might have more processes that affect resources in the application landing zone. For example, they might use DINE policies to configure diagnostics and send logs to centralized management subscriptions. They might also apply [Azure Monitor baseline alerts](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Introduction-to-deploying-the-ALZ-Pattern/) through policy. Ensure that your implementation doesn't block these extra logging and alerting flows.

## Azure Policy

The baseline architecture recommends [general policies](./baseline-microsoft-foundry-chat.yml#governance-through-policy) to help govern the workload. When you deploy this architecture into an application landing zone, you don't need to add or remove extra policies. To help enforce governance and enhance the security of this workload, continue to apply policies to your subscription, resource groups, or resources.

Expect the application landing zone subscription to have existing policies, even before you deploy the workload. Some policies help organizational governance by auditing or blocking specific configurations in deployments.

The following example policies might lead to workload deployment complexities:

- **Policy:** *Secrets [in Key Vault] should have the specified maximum validity period.*

  **Complication:** Foundry can store secrets related to knowledge and tool connections in a connected Key Vault. Those secrets don't have an expiry date set by the service. The baseline architecture doesn't use these types of connections, but you can extend the architecture to support them.

- **Policy:** *AI Search services should use customer-managed keys to encrypt data at rest.*

  **Complication:** This architecture doesn't require customer-managed keys. But you can extend the architecture to support them.

- **Policy:** *Foundry models should not be preview.*

  **Complication:** During development, you might use a preview model that you expect to be generally available by the time that you enable agent capability in your production workload.

Platform teams might apply DINE policies to handle automated deployments into an application landing zone subscription. Preemptively incorporate and test the platform-initiated restrictions and changes into your IaC templates. If the platform team uses Azure policies that conflict with the requirements of the application, you can negotiate a resolution.

## Manage changes over time

In this architecture, platform-provided services and operations serve as external dependencies. The platform team continues to apply changes, onboard landing zones, and apply cost controls. The platform team might not prioritize individual workloads. Changes to those dependencies, such as firewall modifications, can affect multiple workloads.

You must communicate with platform teams in an efficient and timely manner to manage all external dependencies. It's important to test changes beforehand so that they don't negatively affect workloads.

### Platform changes that affect the workload

In this architecture, the platform team manages the following resources. Changes to these resources can potentially affect the workload's reliability, security, operations, and performance targets. Evaluate these changes before the platform team implements them to determine how they affect the workload.

- **Azure policies:** Changes to Azure policies can affect workload resources and their dependencies. These changes might include direct policy updates or movement of the landing zone into a new management group hierarchy. These changes might go unnoticed until a new deployment occurs, so you must thoroughly test them.

  *Example:* A policy no longer allows the deployment of Azure Cosmos DB instances that require customer-managed key encryption, and your architecture uses Microsoft-managed key encryption.

- **Firewall rules:** Modifications to firewall rules can affect the workload's virtual network or rules that apply broadly across all traffic. These modifications can result in blocked traffic and even silent process failures. These potential problems apply to both the egress firewall and Azure Virtual Network Manager-applied NSG rules.

  *Example:* Blocked traffic to Bing APIs leads to failed agent tool invocations for internet grounding data.

- **Routing in the hub network:** Changes in the transitive nature of routing in the hub can potentially affect the workload functionality if a workload depends on routing to other virtual networks.

  *Example:* A routing change prevents Foundry agents from accessing a vector store that's operated by another team or prevents data science teams from accessing the Foundry portal from their workstations.

- **Azure Bastion host:** Changes to the Azure Bastion host availability or configuration.

  *Example*: A configuration change prevents access to jump boxes and build agent VMs.

### Workload changes that affect the platform

The following examples describe workload changes that you should communicate to the platform team. The platform team must validate the platform service's reliability, security, operations, and performance targets against your new changes before they go into effect.

- **Network egress:** Monitor any significant increase in network egress to prevent the workload from becoming a noisy neighbor on network devices. This problem can potentially affect the performance or reliability targets of other workloads. This architecture is mostly self-contained and is unlikely to experience a significant change in outbound traffic patterns.

- **Public access:** Changes to public access for workload components might require extra testing. The platform team might relocate the workload to a different management group.

  *Example:* In this architecture, if you remove the public IP address from Application Gateway and make this application internal only, the workload's exposure to the internet changes. Another example is exposing the browser-based AI portals to the internet, which we don't recommend.

- **Business criticality rating:** Changes to the workload's service-level agreements (SLAs) might require a new collaboration approach between the platform and workload teams.

  *Example:* Your workload might transition from low to high business critically because of increased adoption and success.

- **Data sovereignty:** Changes to requirements around data sovereignty might require the platform team to change their log collection plan, their support of your workload's Purview integration, or their support of the organization's security information and event management (SIEM) solution.

  *Example:* Your workload might now require that all agent thread data stay within a geographical boundary. If your Foundry is connected to Purview or a SIEM, you'd need to ensure that your users' data doesn't get replicated to a region that violates your regulatory requirements.

## Enterprise architecture team

Some organizations have an enterprise architecture team that might influence the design of your workload and its architecture. That team understands the enterprise's [AI adoption](/azure/cloud-adoption-framework/scenarios/ai/) strategy and the principles and recommendations in the [AI workloads on Azure](/azure/well-architected/ai/get-started) design. Work with this team to ensure that this chat workload meets scenario-specific objectives and aligns with organizational strategy and recommendations.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture maintains the [reliability guarantees in the baseline architecture](./baseline-microsoft-foundry-chat.yml#reliability). It doesn't introduce new reliability considerations for the core workload components.

#### Critical dependencies

Treat all functionality that the workload performs in the platform and application landing zone as dependencies. Maintain incident response plans that include contact methods and escalation paths for each dependency. Include these dependencies in the workload's failure mode analysis (FMA).

Consider the following workload dependencies and example scenarios that might occur:

- **Egress firewall:** The centralized egress firewall undergoes changes unrelated to the workload. Multiple workloads share the firewall.

- **DNS resolution:** This architecture uses DNS provided by the platform team for most resources, combined with Azure DNS and linked DNS Private Resolver rulesets for Agent Service. As a result, the workload depends on timely updates to DNS records for private endpoints and availability of DNS services.

- **DINE policies:** DINE policies for Azure private DNS zones, or any other platform-provided dependency, operate on a *best-effort* basis and don't include an SLA. For example, a delay in DNS configuration for this architecture's private endpoints can prevent the chat UI from becoming traffic-ready or block agents from completing Agent Service queries.

- **Management group policies:** Consistent policies among environments support reliability. Ensure that preproduction environments match production environments to provide accurate testing and prevent environment-specific deviations that can block a deployment or scale. For more information, see [Manage application development environments in Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments).

Many of these considerations might exist without Azure landing zones. You need to work with platform teams collaboratively to address these problems and ensure that you meet all requirements. For more information, see [Identify dependencies](/azure/well-architected/reliability/failure-mode-analysis#identify-dependencies).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Ingress traffic control

To isolate your workload from other workload spokes within your organization, apply NSGs on your subnets and use the nontransitive nature or controls in the regional hub. Construct comprehensive NSGs that only permit the inbound network requirements of your application and its infrastructure. We recommend that you don't solely rely on the nontransitive nature of the hub network for security.

The platform team implements Azure policies for security. For example, a policy might ensure that Application Gateway has a web application firewall set to *deny mode*, which restricts the number of public IP addresses available to your subscription. In addition to those policies, you should deploy more workload-centric policies that reinforce the ingress security posture.

The following table shows examples of ingress controls in this architecture.

| Source | Purpose | Workload control | Platform control |
| :----- | :------ | :--------------- | :--------------- |
| Internet | Application traffic flows | Funnel all workload requests through an NSG, a web application firewall, and routing rules before allowing public traffic to transition to private traffic for the chat UI. | None |
| Internet | Foundry portal access and data plane REST API access | Deny all access through service-level configuration. | None |
| Internet | Data plane access to all services except Application Gateway | Deny all access through NSG rules and service-level configuration. | None |
| Azure Bastion | Jump box and build agent access | Apply an NSG on the jump box subnet that blocks all traffic to remote access ports, unless the source is the platform's designated Azure Bastion subnet. | None |
| Cross-premises | Foundry portal access and data plane REST API access | Deny all access. If you don't use the jump box, allow access only from workstations in authorized subnets for data scientists. | Enforce nontransitive routing or use Azure Firewall in an Azure Virtual WAN secured hub |
| Other spokes | None | Blocked via NSG rules. | Enforce nontransitive routing or use Azure Firewall in a Virtual WAN secured hub |

#### Egress traffic control

Apply NSG rules that express the required outbound connectivity requirements of your solution and deny everything else. Don't rely only on the hub network controls. As a workload operator, you must stop undesired egress traffic as close to the source as possible.

You own your workload's subnets within the virtual network, but the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture remain compatible with your original request. Work with your network team to ensure continuity of least-access egress control.

The following table shows examples of egress controls in this architecture.

| Endpoint | Purpose | Workload control | Platform control |
| :------- | :------ | :---------- | :---------- |
| Public internet sources | Your agent might require internet search to ground an Azure OpenAI request | Apply NSGs on the agent integration subnet | Apply firewall application rules for external knowledge stores and tools |
| Foundry data plane | The chat UI interacts with the chat agent | Allow TCP/443 from the App Service integration subnet to the Foundry private endpoint subnet | None |
| Azure Cosmos DB | To access the memory database from Agent Service | Allow TCP on every port to the Azure Cosmos DB private endpoint subnet | None |

For traffic that leaves the workload's virtual network, this architecture applies controls at the workload level via NSGs and at the platform level via a hub network firewall. The NSGs provide initial, broad network traffic rules. In the platform's hub, the firewall applies more specific rules for added security.

This architecture doesn't require east-west traffic between internal components, such as Agent Service and its dependent AI Search instance, to route through the hub network.

#### DDoS Protection

Determine who should apply the DDoS Protection plan that covers your solution's public IP addresses. The platform team might use IP address protection plans, or they might use Azure Policy to enforce virtual network protection plans. This architecture requires DDoS Protection coverage because it has a public IP address for ingress from the internet. For more information, see [Recommendations for networking and connectivity](/azure/well-architected/security/networking).

#### Identity and access management

Unless the platform team's governance automation requires extra controls, this architecture doesn't introduce new authorization requirements because of the platform team's involvement. Azure role-based access control (Azure RBAC) should continue to fulfill the principle of least privilege, which grants limited access only to individuals who need it and only when needed. For more information, see [Recommendations for identity and access management](/azure/well-architected/security/identity-access).

#### Certificates and encryption

Your team typically procures the TLS certificate for the public IP address on Application Gateway. Work with the platform team to understand how the certificate procurement and management processes should align with organizational expectations.

All data storage services in this architecture support Microsoft-managed or customer-managed encryption keys. Use customer-managed encryption keys if your workload design or organization requires more control. Azure landing zones themselves don't mandate a specific method.

#### Microsoft Defender for Cloud

Use the same configuration for Microsoft Defender for Cloud as discussed in the [baseline architecture](./baseline-microsoft-foundry-chat.yml#microsoft-defender-for-cloud). If your subscription vending process doesn't automatically enable these Defender plans, ensure you take on this responsibility as the workload team.

#### Microsoft Purview

It's expected that you'll be required to use the native integration of Microsoft Purview when deploying Foundry. During deployment, ensure you enable Microsoft Purview Data Security in the Microsoft Foundry Control Plane. See [Use Microsoft Purview to manage data security & compliance for Microsoft Foundry](/purview/ai-azure-foundry).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

All [cost optimization strategies in the baseline architecture](./baseline-microsoft-foundry-chat.yml#cost-optimization) apply to the workload resources in this architecture.

This architecture greatly benefits from Azure landing zone [platform resources](#platform-team-owned-resources). For example, resources such as Azure Firewall and DDoS Protection transition from workload to platform resources. Even if you use those resources through a chargeback model, the added security and cross-premises connectivity are more cost-effective than self-managing those resources. Take advantage of other centralized offerings from your platform team to extend those benefits to your workload without compromising its service-level objective, recovery time objective, or recovery point objective.

> [!IMPORTANT]
> Don't try to optimize costs by consolidating Foundry dependencies as platform resources. These services must remain workload resources.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

You remain responsible for all [operational excellence considerations from the baseline architecture](./baseline-microsoft-foundry-chat.yml#operational-excellence). These responsibilities include monitoring, GenAIOps, quality assurance, and safe deployment practices.

#### Correlate data from multiple sinks

The workload's Azure Monitor Logs workspace stores the workload's logs and metrics and its infrastructure components. However, a central Azure Monitor Logs workspace often stores logs and metrics from centralized services, such as Azure Firewall, DNS Private Resolver, and Azure Bastion. Correlating data from multiple sinks can be a complex task.

Correlated data helps support incident response. The triage runbook for this architecture should address this situation and include organizational contact information if the problem extends beyond workload resources. Workload administrators might require assistance from platform administrators to correlate log entries from enterprise networking, security, or other platform services.

> [!IMPORTANT]
> **For the platform team:** When possible, grant Azure RBAC permissions to query and read log sinks for relevant platform resources. Enable firewall logs for network and application rule evaluations and DNS proxy. The application teams can use this information to troubleshoot tasks. For more information, see [Recommendations for monitoring and threat detection](/azure/well-architected/security/monitor-threats).

#### Build agents

Many services in this architecture use private endpoints. Similar to the baseline architecture, this design might require build agents. Your team deploys the build agents safely and reliably. The platform team isn't involved in this process.

Make sure that the build agent management complies with organizational standards. These standards might include the use of platform-approved operating system images, patching schedules, compliance reporting, and user authentication methods.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The [performance efficiency considerations in the baseline architecture](./baseline-microsoft-foundry-chat.yml#performance-efficiency) also apply to this architecture. Your team retains control over the resources in the application flows, not the platform team. Scale the chat UI host, language models, and other components according to the workload and cost constraints. Depending on the final implementation of your architecture, consider the following factors when you measure your performance against performance targets:

- Egress and cross-premises latency
- SKU limitations from cost containment governance

## Deploy this scenario

Deploy a landing zone implementation of this reference architecture.

> [!div class="nextstepaction"]
> [Agent Service chat baseline reference implementation](https://github.com/Azure-Samples/microsoft-foundry-baseline-landing-zone)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Bilal Amjad](https://www.linkedin.com/in/mbilalamjad/) | Microsoft Cloud Solution Architect
- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) | Microsoft Cloud Solution Architect
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

Learn how to collaborate on technical details with the platform team.

> [!div class="nextstepaction"]
> [Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)

## Related resource

- A Well-Architected Framework perspective on [AI workloads on Azure](/azure/well-architected/ai/get-started)
