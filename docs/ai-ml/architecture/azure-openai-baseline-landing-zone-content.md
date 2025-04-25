This article is part of a series that builds on the [Azure OpenAI Service end-to-end chat baseline architecture](baseline-openai-e2e-chat.yml). You should familiarize yourself with the baseline architecture so that you can understand the changes that you need to make when deploying the architecture in an Azure application landing zone subscription.

This article describes the architecture of a generative AI workload that deploys the same baseline chat application but uses resources that are outside the scope of the workload team. Those resources are shared among other workload teams and are centrally managed by the platform teams of an organization. Shared resources include networking resources for connecting to or from on-premises locations, identity access management resources, and policies. This guidance is for organizations that use Azure landing zones to ensure consistent governance and cost efficiency.

Azure AI Foundry has the concept of hubs and projects. A potential landing zone implementation might be to implement the hub as a centralized resource and projects as delegated workload resources. This architecture does not provide guidance on that approach. Instead, this architecture focuses on the workload as the owner of the Azure AI Foundry instance.

As a workload owner, you can offload the management of shared resources to platform teams so that you can focus on workload development efforts. This article presents the workload team's perspective. Recommendations for the platform team are specified.

> [!IMPORTANT]
> **What are Azure landing zones?**
>
> Azure landing zones present two areas of an organization's cloud footprint. An application landing zone is an Azure subscription in which a workload runs. An application landing zone is connected to the organization's shared platform resources. Through that connection, the landing zone has access to the infrastructure that supports the workload, such as networking, identity access management, policies, and monitoring. A platform landing zone is a collection of various subscriptions that multiple platform teams can manage. Each subscription has a specific function. For example, a connectivity subscription provides centralized Domain Name System (DNS) resolution, cross-premises connectivity, and network virtual appliances (NVAs) that are available for platform teams to use.
>
> We recommend that you understand [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone), their [design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles), and [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas) to help you implement this architecture.

## Article layout

| Architecture | Design decisions | Azure Well-Architected Framework approach |
| --- | --- | --- |
|&#9642; [Architecture diagram](#architecture)<br>&#9642; [Workload resources](#workload-team-owned-resources)<br>&#9642; [Federated resources](#platform-team-owned-resources) |&#9642; [Subscription setup](#subscription-setup)<br>&#9642; [Compute](#compute)<br>&#9642; [Networking](#networking)<br>&#9642; [Data scientist access](#data-scientist-and-prompt-flow-authorship-access)<br>&#9642; [Monitor resources](#monitor-resources)<br>&#9642; [Organizational governance](#azure-policy)<br>&#9642; [Change management](#manage-changes-over-time)|&#9642; [Reliability](#reliability)<br>&#9642; [Security](#security)<br>&#9642; [Cost Optimization](#cost-optimization)<br>&#9642; [Operational Excellence](#operational-excellence)<br>&#9642; [Performance Efficiency](#performance-efficiency) |

> [!TIP]
> :::image type="icon" source="../../_images/github.svg"::: The [Azure OpenAI chat baseline reference implementation](https://github.com/Azure-Samples/azure-openai-chat-baseline-landing-zone) demonstrates the best practices described in this article. Review this guidance before you make and implement your design decisions.

## Architecture

<!--docutune:ignore 'grayed-out VPN Gateway' -->

:::image type="complex" source="./_images/azure-openai-baseline-landing-zone.png" alt-text="Architecture diagram of the workload, including select platform subscription resources." border="false":::
    Architecture diagram that's broken up into two primary sections. The blue section is labeled application landing zone subscription. The bottom section is yellow and is labeled platform landing zone subscription. The top box contains both workload-created resources and subscription-vending resources. The workload resources consist of Application Gateway and web application firewall, App Service and its integration subnet, private endpoints for platform as a service (PaaS) solutions such as Azure Storage, Azure Key Vault, Azure AI Search, Azure OpenAI Service, and Container Registry. The workload resources also have Azure AI Foundry workspace and monitoring resources. Azure App Service shows three instances, each in a different Azure zone. The platform subscription contains a hub virtual network, Azure Firewall, Azure Bastion, and a grayed-out VPN Gateway and ExpressRoute. There's virtual network peering between a virtual network in the application landing zone and the hub virtual network.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-chat-baseline-alz.vsdx) of this architecture.*

### Components

All Azure landing zone architectures have a separation of ownership between the platform team and the workload team, referred to as [subscription democratization](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization). Application architects, data scientists, and DevOps teams need to have a strong understanding of this responsibility split to know what's under their direct influence or control and what's not.

Like most application landing zone implementations, the workload team is mostly responsible for the configuration, management, and deployment of the workload components, including all AI services that are used in this architecture.

#### Workload team-owned resources

The following resources remain mostly unchanged from the [baseline architecture](./baseline-openai-e2e-chat.yml#components).

- **Azure OpenAI** is a managed service that provides REST API access to Azure OpenAI language models, including the GPT-4, GPT-3.5 Turbo, and embedding models.

  Depending on how your organization's AI Center of Excellence has decided to constrain access to AI model deployments, the workload team might not own this resource, but instead the team be required to use [centralized AI resources](/azure/cloud-adoption-framework/scenarios/ai/plan). In that case, all model consumption usually flows through a gateway provided by your AI platform team. In this article, it is assumed that Azure OpenAI is a workload-owned resource. If it's not, then this resource, or a gateway to this resource, becomes a workload dependency. The platform team ensures you have reliable network connectivity to the APIs.

- **[Azure AI Foundry](/azure/ai-foundry/what-is-ai-foundry)** is a platform that you can use to build, test, and deploy AI solutions. AI Foundry is used in this architecture to build, test, and deploy the [prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) orchestration logic for the chat application. In this architecture, Azure AI Foundry provides the managed virtual network for network security. For more information, see the networking section for more details.

- **Managed online endpoints** are used as a platform as a service (PaaS) endpoint for the chat UI application, which invokes the prompt flows hosted by Azure AI Foundry.

- **Azure App Service** is used to host the example web application for the chat UI. In this architecture, it's also possible to use this service to host the containerized prompt flow for more control over the hosting environment that runs prompt flow. App Service has three instances, each in a different Azure zone.

- **AI Search** is a common service that's used in the flows behind chat applications. You can use AI Search to retrieve indexed data that's relevant for user queries.

- **Azure Storage** is used to persist the prompt flow source files for prompt flow development.

- **Azure Container Registry** is used to store flows that are packaged as container images.

- **Azure Application Gateway** is used as the reverse proxy to route user requests to the chat UI that's hosted in App Service. The selected SKU is also used to host an Azure web application firewall to protect the front-end application from potentially malicious traffic.

- **Key Vault** is used to store application secrets and certificates.

- **Azure Monitor, Azure Monitor Logs, and Application Insights** are used to collect, store, and visualize observability data.

- **Azure Policy** is used to apply policies that are specific to the workload to help govern, secure, and apply controls at scale.

The workload team maintains the following resources:

- **Spoke virtual network subnets and the network security groups (NSGs)** that are placed on those subnets to maintain segmentation and control traffic flow.

- **Private endpoints** to secure connectivity to PaaS solutions.

#### Platform team-owned resources

The platform team owns and maintains these centralized resources. This architecture assumes that these resources are pre-provisioned and considers them dependencies.

- **Azure Firewall in the hub network** is used to route, inspect, and restrict egress traffic. Workload egress traffic goes to the internet, cross-premises destinations, or to other application landing zones.

  *Change from the baseline:* This component is new in this architecture. Azure Firewall isn't cost-effective or practical for each workload team to manage their own instance.

- **Azure Bastion in the hub network** provides secure operational access to workload components and also allows access to Azure AI Foundry components.

  *Change from the baseline:* The workload team owns this component in the baseline architecture.

- The **spoke virtual network** is where the workload is deployed.

  *Change from the baseline:* The workload team owns this network in the baseline architecture.

- **User-defined routes (UDRs)** are used to force tunneling to the hub network.

  *Change from the baseline:* This component is new in this architecture.

- **Azure Policy-based governance constraints** and `DeployIfNotExists` (DINE) policies are part of the workload subscription. You can apply these policies at the platform team-owned management group level or apply them to the workload's subscription directly.

  *Change from the baseline:* These policies are new in this architecture.

- **Azure private DNS zones** host the `A` records for private endpoints. For more information, see [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).

  *Change from the baseline:* This component is moved to the hub and is platform managed.

- **DNS resolution service** for spoke virtual networks and cross-premises workstations. That service usually takes the form of Azure Firewall as a DNS proxy or Azure DNS Private Resolver. In this architecture, this service resolves private endpoint DNS records for all DNS requests that originate in the spoke.

- **Azure DDoS Protection** is used to protect public IP addresses against distributed attacks.

  *Change from the baseline:* The workload team purchases DDoS Protection in the baseline architecture.

> [!IMPORTANT]
> Azure landing zones provide some of the preceding resources as part of the platform landing zone subscriptions, and your workload subscription provides other resources. Many of the resources are part of the connectivity subscription. The subscription also has more resources, such as Azure ExpressRoute, Azure VPN Gateway, and DNS Private Resolver. These resources provide cross-premises access and name resolution. The management of these resources is outside the scope of this article.

## Subscription setup

In a landing zone context, the workload team that implements this architecture must inform the platform team of their specific requirements. The platform team must then communicate their requirements to the workload team.

For example, your workload team must include detailed information about the networking space that your workload needs, so that the platform team can allocate necessary resources. Your team determines the requirements, and the platform team determines the IP addresses to assign within the virtual network.

The platform team assigns an appropriate management group based on the workload's business criticality and technical requirements. An example would be if a workload is exposed to the internet like in this architecture. The platform team establishes governance by configuring and implementing management groups. Your workload team must design and operate the workload within the constraints of the governance. For more information on typical management group distinctions, see [Tailor the Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/tailoring-alz).

Ultimately, the platform team sets up the subscription for this architecture. The following sections provide guidance on the initial subscription setup as it relates to this architecture.

### Workload requirements and fulfillment

For this architecture, the workload team and platform team need to collaborate on a few topics: management group assignment, including the associated Azure Policy governance, and networking setup. Prepare a checklist of requirements to initiate discussion and negotiation with the platform team. This checklist serves as an example in the context of this architecture.

| &nbsp; | Topic | Workload requirement for this architecture |
|---|---|---|
|&#9744;|**Number of spoke virtual networks and their size.** The platform team needs to know the number of spokes because they create and configure the virtual network and make it a spoke by peering it to the central hub. They also need to make sure that the network is large enough to accommodate future growth. | Only one dedicated virtual network for a spoke is required. All resources are deployed in that network. <br><br> Request /22 contiguous address space to operate at full scale or accommodate situations, such as side-by-side deployments. Most IP address requirements are driven by: <br> - Application Gateway requirements for the subnet size (fixed size). <br>- Private endpoints with single IP addresses for PaaS services (fixed size). <br> - The subnet size for build agents (fixed size).<br> - Blue/green deployments of prompt flow compute (variable size). |
|&#9744;|**Deployment region.** The platform team uses this information to ensure that they have a hub deployed in the same region as the workload resources.| Availability is limited for [Azure OpenAI in certain regions](/azure/ai-services/openai/concepts/models#model-summary-table-and-region-availability). Communicate the chosen region. Also, communicate the region or regions where the underlying compute resources are deployed. The selected regions should support availability zones. |
|&#9744;|**Type, volume, and pattern of traffic.** The platform team uses this information to determine the ingress and egress requirements of the shared resources used by your workload. | Provide information about: <br> - How users should consume this workload. <br> - How this workload consumes its surrounding resources. <br> - The configured transport protocol. <br> - The traffic pattern and the expected peak and off-peak hours. When do you expect a high number of concurrent connections to the internet (chatty) and when do you expect the workload to generate minimal network traffic (background noise).|
|&#9744;|**Firewall configuration.** The platform team uses this information to set rules to allow legitimate egress traffic.| Inform the platform team of specific information that's related to the traffic that leaves the spoke network. <br> - Build agent and jump box machines need regular operating system patching.<br>- The compute sends out operating system telemetry.<br> - In an [alternate approach](#alternate-approach-to-hosting-the-prompt-flow-code), the prompt flow code hosted by App Service requires internet access. |
|&#9744;|**Ingress traffic from specialized roles.** The platform team uses this information to enable the specified roles to access the workload, while implementing proper segmentation.|Work with the platform team to determine the best way to allow authorized access for: <br> - Data scientists to access the Azure AI Foundry portal from their workstations on corporate network connections. <br> - Operators to access the compute layer through the jump box that's managed by the workload team. |
|&#9744;|**Public internet access to the workload.** The platform team uses this information for risk assessment, which drives decisions about: <br> - The placement of the workload in a management group with appropriate guardrails. <br> - Protection from DDoS for the public IP address reported by the workload team. <br> - Issuing and managing Transport Layer Security (TLS) certificates.| Inform the platform team about the ingress traffic profile: <br> - Internet-sourced traffic targets the public IP address on Application Gateway. <br> - Fully qualified domain names (FQDNs) associated with the public IP address for TLS certificate procurement. |
|&#9744;|**Private endpoint usage.** The platform team uses this information to set up Azure Private DNS zones for those endpoints and make sure that the firewall in the hub network can do DNS resolution. | Inform the platform team about all resources that use private endpoints, such as: <br> - AI search <br> - Container Registry <br> - Key Vault <br> - Azure OpenAI <br> - Storage accounts <br><br>Have a clear understanding of how DNS resolution is handled in the hub and the workload team's responsibilities for the management of the private DNS zone records.|
|&#9744;|**Centralized AI resources.** The platform team needs to be aware of expected model and hosting platform usage as the platform team uses this information to establish networking to any centralized AI resources established in the organization. Organizations build their own unique [AI adoption and governance plans](/azure/cloud-adoption-framework/scenarios/ai/plan) that workload teams will be constrained by. | Inform the platform team about all AI and ML resources that are planned to be used. In this architecture, those services are: <br> - Azure OpenAI <br> - Azure AI Foundry<br><br>Have a clear understanding of what centralized AI services are mandated to be used and what taking a dependency on those offerings means for your workload.|

> [!IMPORTANT]
> We recommend a subscription vending process for the platform team that involves a series of questions designed to capture information from the workload team. These questions might vary from one organization to another, but the intent is to gather the requirements to implement subscriptions. For more information, see [Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).

## Compute

The compute that hosts the prompt flow and the chat UI remains the same as the [baseline architecture](./baseline-openai-e2e-chat.yml).

An organization might impose requirements on the workload team that mandates the use of a specific Azure AI Foundry runtime. For example, the requirement might be to avoid automatic runtimes or compute instance runtimes and instead favors a prompt flow container host that fulfills compliance, security, and observability mandates.

The organization's governance might add more requirements for container base image maintenance and dependency package tracking than what the workload requirements indicate. Workload teams must ensure that the workload's runtime environment, the code deployed to it, and its operations align with these organizational standards.

### Alternate approach to hosting the prompt flow code

Instead of hosting the prompt flow code in an Azure AI Foundry runtime environment, you can host it in App Service. In this approach, egress traffic is controlled, when compared to Azure AI Foundry compute's managed virtual network. The logic itself doesn't change but the App Service instances need internet access.

## Networking

In the [baseline architecture](./baseline-openai-e2e-chat.yml#networking), the workload is provisioned in a single virtual network.

*Change from the baseline:* The workload is effectively split over two virtual networks. One network is for the workload components and one is for controlling internet and hybrid connectivity. The platform team determines how the workload's virtual network integrates with the organization's larger network architecture, which is usually with a hub-spoke topology.

:::image type="complex" source="./_images/azure-openai-baseline-landing-zone-networking.png" alt-text="Architecture diagram that focuses mostly on network ingress flows." border="false":::
    This architecture diagram has a blue box at the top labeled application landing zone subscription that contains a spoke virtual network. There are five boxes in the virtual network. The boxes are labeled snet-appGateway, snet-agents, snet-jumpbox, snet-appServicePlan, and snet-privateEndpoints. Each subnet has an NSG logo, and all but the snet-appGateway subnet has a UDR that says To hub. Ingress traffic from on-premises and off-premises users points to the application gateway. A data scientist user is connected to the VPN gateway or ExpressRoute in the bottom part of the diagram that's labeled connectivity subscription. The connectivity subscription contains private DNS zones for Private Link, DNS Private Resolver, and DDoS Protection. The hub virtual network that's contained in the connectivity subscription and the spoke virtual network are connected with a line labeled virtual network peering. There's text in the spoke virtual network that reads DNS provided by hub.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-chat-baseline-alz.vsdx) of this architecture.*

- **Hub virtual network:** A regional hub that contains centralized, and often shared, services that communicate with workload resources in the same region. The hub is located in the [connectivity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity). The platform team owns the resources in this network.

- **Spoke virtual network:** In this architecture, the single virtual network from the baseline architecture essentially becomes the spoke network. The virtual network is peered to the hub network by the platform team. The platform team owns and manages this spoke network, its peering, and DNS configuration. This network contains many of the [workload resources](#workload-team-owned-resources). The workload team owns the resources in this network, including its subnets.

Because of this management and ownership split, make sure that you clearly [communicate the workload's requirements](#subscription-setup) to the platform team.

> [!IMPORTANT]
> **For the platform team:**
> Unless specifically required by the workload, don't directly peer the spoke network to another spoke virtual network. This practice protects the segmentation goals of the workload. Unless the application landing zone teams have cross-connected with self-managed private endpoints, your team should facilitate all transitive virtual network connections. Have a good understanding of the resources used by this workload that are managed by teams outside the scope of this workload team. For example, understand the network connectivity between the prompt flow and a vector database that's managed by another team.

### Virtual network subnets

In the spoke virtual network, the workload team creates and allocates the subnets that are aligned with the requirements of the workload. Placing controls to restrict traffic in and out of the subnets helps provide segmentation. This architecture doesn't add any subnets beyond those subnets described the [baseline architecture](./baseline-openai-e2e-chat.yml#virtual-network-segmentation-and-security). The network architecture however no longer requires the `AzureBastionSubnet` subnet because the platform team hosts this service in their subscriptions.

You still have to implement local network controls when you deploy your workload in an Azure landing zone. Organizations might impose further network restrictions to safeguard against data exfiltration and ensure visibility for the central security operations center (SOC) and the IT network team.

### Ingress traffic

The ingress traffic flow remains the same as the [baseline architecture](./baseline-openai-e2e-chat.yml#network-flows).

Your workload team is responsible for any resources that are related to public internet ingress into the workload. For example, in this architecture, Application Gateway and its public IP address are placed in the spoke network and not the hub network. Some organizations might place resources with ingress traffic in a connectivity subscription by using a centralized perimeter network (also known as DMZ, demilitarized zone, and screened subnet) implementation. Integration with that specific topology is out of scope for this article.

#### Alternate approach to inspecting incoming traffic

This architecture doesn't use Azure Firewall to inspect incoming traffic. Sometimes organizational governance requires this approach. Platform teams support the implementation to provide workload teams an extra layer of intrusion detection and prevention to block unwanted inbound traffic. This architecture needs more UDR configurations to support this topology. For more information about this approach, see [Zero Trust network for web applications with Azure Firewall and Application Gateway](../../example-scenario/gateway/application-gateway-before-azure-firewall.yml).

### DNS configuration

In the baseline architecture, Azure DNS is used directly by all components for DNS resolution.

*Change from the baseline:* DNS is usually delegated to one or more DNS servers in the hub. When the virtual network is created for this architecture, the DNS properties on the virtual network are expected to already be set accordingly. The DNS service is considered opaque to your workload team.

The workload components in this architecture get configured with DNS in the following ways.

| Component | DNS configuration |
| :-------- | :---------------- |
| Application Gateway | Inherited from virtual network. |
| App Service (chat UI) | Inherited from virtual network. |
| App Service (prompt flow) | Inherited from virtual network. |
| AI Search | Can't be overridden, uses Azure DNS. |
| Azure AI Foundry serverless compute | &#9642; Managed virtual network, can't be overridden, and uses Azure DNS. This architecture uses this approach.<br/> &#9642; Virtual network integration, inherited from virtual network. |
| Azure AI Foundry compute cluster | &#9642; Managed virtual network, can't be overridden, and uses Azure DNS. This architecture uses this approach.<br/> &#9642; Virtual network integration, inherited from virtual network. |
| Azure AI Foundry automatic runtime | &#9642; Managed virtual network, can't be overridden, uses Azure DNS.<br/><br/> &#9642; Virtual network integration, inherited from virtual network.<br/>This architecture doesn't use automatic runtime. |
| Azure AI Foundry compute instance | &#9642; Managed virtual network, can't be overridden, uses Azure DNS. This architecture uses this approach.<br/> &#9642; Virtual network integration, inherited from virtual network. |
| Azure OpenAI | Can't be overridden, uses Azure DNS. |
| Jump box | Inherited from virtual network. |
| Build agents | Inherited from virtual network. |

No DNS settings are configured for the remaining components in the architecture because no outbound communication occurs from those services. No DNS resolution is required for those components.

Many of these components require appropriate DNS records in the hub's DNS servers to resolve this workload's many private endpoints. For more information, see [Azure Private DNS zones](#private-dns-zones). For components where hub-based DNS resolution can't occur, you're faced with the following limitations:

- The platform team can't log DNS requests, which might be an organizational security team requirement.

- Resolving to Azure Private Link exposed services in your landing zone or other application landing zones might be impossible. Some services, such as Azure AI Foundry computes, work around this limitation through service-specific features.

We recommend that you familiarize yourself with how the platform team manages DNS. For more information, see [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale). When you add component features that directly depend on Azure DNS, you might introduce complexities in the platform-provided DNS topology. You can redesign components or negotiate exceptions to minimize complexity.

### Egress traffic

In the baseline architecture, internet egress control is available only through the network configuration on the Azure AI Foundry hub and App Service, combined with using NSGs on the various subnets.

*Change from the baseline:* The egress controls are further augmented. All traffic that leaves the spoke virtual network is rerouted through the peered hub network via an egress firewall. Traffic that originates inside the managed virtual network for Azure AI Foundry computes isn't subject to this egress route.

:::image type="complex" source="./_images/azure-openai-baseline-landing-zone-networking-egress.png" alt-text="Architecture diagram that focuses mostly on network egress flows." border="false":::
    The top section of this architecture diagram is labeled application landing zone subscription and contains a spoke virtual network box and an Azure AI Foundry box. The Azure AI Foundry box contains private endpoints for Storage, Container Registry, AI Search, and Azure OpenAI. The spoke virtual network box contains five subnets: snet-appGateway,  snet-agents, snet-jumpbox, snet-appServicePlan, and snet-privateEndpoints. All of the subnets, except for snet-appGateway, have a dashed line leading from them to Azure Firewall, which is in the bottom box. The bottom box is labeled "Connectivity subscription." Azure Firewall has the same style line that points to the internet represented as a cloud. The Azure AI Foundry box has the same dashed line style that points from it to the internet cloud as well. The top box reads Where possible all workload-originated, internet-bound traffic flows through the hub due to the 0.0.0.0/0 UDR. The hub virtual network in the bottom box and the spoke virtual network in the top box are connected with a line that reads virtual network peering.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-chat-baseline-alz.vsdx) of this architecture.*

East-west client communication to the private endpoints for Container Registry, Key Vault, Azure OpenAI, and others remains the same as the [baseline architecture](./baseline-openai-e2e-chat.yml#networking). That path is omitted from the preceding diagram for brevity.

#### Route internet traffic to the firewall

A route is attached to all of the possible subnets in the spoke network that directs all traffic headed to the internet (*0.0.0.0/0*) first to the hub's Azure Firewall.

| Component | Mechanism to force internet traffic through the hub |
| :-------- | :---------------- |
| Application Gateway | None. Internet-bound traffic that originates from this service can't be forced through a platform team firewall. |
| App Service (chat UI) | [Regional virtual network integration](/azure/app-service/configure-vnet-integration-enable) is enabled.<br/>[vnetRouteAllEnabled](/azure/app-service/configure-vnet-integration-routing#configure-application-routing) is enabled. |
| App Service (prompt flow) | [Regional virtual network integration](/azure/app-service/configure-vnet-integration-enable) is enabled.<br/>[vnetRouteAllEnabled](/azure/app-service/configure-vnet-integration-routing#configure-application-routing) is enabled. |
| AI Search | None. Traffic that originates from this service can't be forced through a firewall. This architecture doesn't use skills. |
| Azure AI Foundry serverless compute | &#9642; Managed virtual network: Internet-bound traffic that originates from this service can't be forced through a platform team firewall. This architecture uses this approach.<br/> &#9642; Virtual network integration: Uses a UDR that's applied to the subnet that contains the compute cluster. |
| Azure AI Foundry compute cluster | &#9642; Managed virtual network: Internet-bound traffic that originates from this service can't be forced through a platform team firewall. This architecture uses this approach.<br/> &#9642; Virtual network integration: Uses a UDR that's applied to the subnet that contains the compute cluster. |
| Azure AI Foundry automatic runtime | &#9642; Managed virtual network: Internet-bound traffic that originates from this service can't be forced through a platform team firewall. <br/> &#9642; Virtual network integration: Uses a UDR that's applied to the subnet that contains the compute cluster.<br/><br/>This architecture doesn't use automatic runtime. |
| Azure AI Foundry compute instance | &#9642; Managed virtual network: Internet-bound traffic that originates from this service can't be forced through a platform team firewall. This architecture uses this approach.<br/> &#9642; Virtual network integration: Uses a UDR that's applied to the subnet that contains the compute cluster. |
| Azure OpenAI | None. Traffic that originates from this service, for example via the [on your data](/azure/ai-services/openai/concepts/use-your-data) feature, can't be forced through a firewall. This architecture doesn't use any of these features. |
| Jump box | Uses the UDR that's applied to snet-jumpbox. |
| Build agents | Uses the UDR that's applied to snet-agents. |

No force tunnel settings are configured for the components that remain in the architecture because no outbound communication happens from those services.

For components or component features where egress control through hub routing isn't possible, your workload team must align with organizational requirements on this traffic. Use compensating controls, redesign the workload to exclude these features, or seek formal exceptions. Workloads are ultimately responsible for mitigating data exfiltration and abuse.

Apply the platform-provided internet route to all subnets, even if the subnet isn't expected to have outgoing traffic. This approach ensures that any unexpected deployments into that subnet are subjected to routine egress filtering. Ensure subnets that contain private endpoints have network policy enabled for full routing and NSG control.

When you apply this route configuration to the architecture, all outbound connections from App Service, the Azure AI Foundry hub and its projects, or any other services that originated on the workload's virtual network are scrutinized and controlled.

<a name='private-dns-zones'></a>

### Azure Private DNS zones

Architectures that use private endpoints for east-west traffic within their workload need DNS zone records in the configured DNS provider. This architecture requires many DNS zone records to function properly: Key Vault, Azure OpenAI, and more to support Private Link.

*Change from the baseline:* The workload team is directly responsible for the private DNS zones in the baseline architecture. In the landing zone architecture, the platform team typically maintains private DNS zones. They might use another technology, but for this architecture, it's private DNS zone records. The workload team must clearly understand the platform team's requirements and expectations for the management of those private DNS zone records.

In this architecture, the platform team must ensure reliable and timely DNS hosting for the following Private Link endpoints:

- AI search
- Azure OpenAI
- Container Registry
- Key Vault
- Storage accounts

## Data scientist and prompt flow authorship access

Like the [baseline architecture](./baseline-openai-e2e-chat.yml#ingress-to-machine-learning), public ingress access to the Azure AI Foundry portal and other browser-based experiences are disabled. The baseline architecture deploys a jump box to provide a browser with a source IP address from the virtual network that's used by various workload roles.

When your workload is connected to an Azure landing zone, more options are available to your team for this access. Work with your platform team to see whether private access to the various browser-based AI studios can instead be achieved without the need to manage and govern a virtual machine (VM). This access might be accomplished through transitive access from an already-established ExpressRoute or VPN Gateway connection. Native workstation-based access requires cross-premises routing and DNS resolution, which the platform team can help provide. Make this requirement known in your subscription vending request.

Providing native workstation-based access to these portals is a productivity enhancement over the baseline and can be simpler to maintain than VM jump boxes.

### The role of the jump box

Having a jump box in this architecture is valuable but not for runtime purposes or AI or machine learning development purposes. The jump box can troubleshoot DNS and network routing problems because it provides internal network access to otherwise externally inaccessible components.

In the baseline architecture, Azure Bastion accesses the jump box, which is managed by the workload team.

In this architecture, Azure Bastion is deployed within the connectivity subscription as a shared regional resource that's managed by the platform team. To demonstrate that use case in this architecture, Azure Bastion is in the connectivity subscription and no longer deployed by the workload team.

The VM that's used as the jump box must comply with organizational requirements for VMs. These requirements might include items such as corporate identities in Microsoft Entra ID, specific base images, and patching regimes.

## Monitor resources

The Azure landing zone platform provides shared observability resources as part of the management subscription. However, we recommend that you provision your own monitoring resources to facilitate ownership responsibilities of the workload. This approach is consistent with the [baseline architecture](./baseline-openai-e2e-chat.yml#monitoring).

The workload team provisions the monitoring resources, which include:

- Application Insights as the application performance management (APM) service for the workload team. This feature is configured in the chat UI and prompt flow code.

- The Azure Monitor Logs workspace as the unified sink for all logs and metrics that are collected from workload-owned Azure resources.

Similar to the baseline, all resources are configured to send Azure Diagnostics logs to the Azure Monitor Logs workspace that the workload team provisions as part of the infrastructure as code (IaC) deployment of the resources. You might also need to send logs to a central Azure Monitor Logs workspace. In Azure landing zones, that workspace is typically in the management subscription.

The platform team might also have processes that affect your application landing zone resources. For example, they might use DINE policies to configure diagnostics and send logs to their centralized management subscriptions. Or they might use [Monitor baseline alerts](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/HowTo/deploy/Introduction-to-deploying-the-ALZ-Pattern/) applied through policy. It's important to ensure that your implementation doesn't restrict the extra log and alerting flows.

## Azure Policy

The [baseline architecture](./baseline-openai-e2e-chat.yml#governance-through-policy) recommends some general policies to help govern the workload. When you deploy this architecture into an application landing zone, you don't need to add or remove any more policies. Continue to apply policies to your subscription, resource groups, or resources that help enforce governance and enhance the security of this workload.

Expect the application landing zone subscription to have policies already applied, even before the workload is deployed. Some policies help organizational governance by auditing or blocking specific configurations in deployments. Here are some example policies that might lead to workload deployment complexities:

- Policy: "Secrets [in Key Vault] should have the specified maximum validity period."

    Complication: Azure AI Foundry manages secrets in the workload's Key Vault, and those secrets don't have an expiry date set.

- Policy: "Machine Learning workspaces should be encrypted with a customer-managed key."

    Complication: This architecture isn't designed solely to handle customer-managed keys. However, it can be extended to use them.

- Policy: "Azure Machine Learning workspaces should enable V1LegacyMode to support network isolation backward compatibility."

    Complication: This architecture does not require network isolation backward compatibility."

- Policy: "Azure Machine Learning workspaces should use user-assigned managed identity."

    Complication: This architecture uses system-assigned managed identity to take advantage of system-managed role assignments.

Platform teams might apply DINE policies to handle automated deployments into an application landing zone subscription. Preemptively incorporate and test the platform-initiated restrictions and changes into your IaC templates. If the platform team uses Azure policies that conflict with the requirements of the application, you can negotiate a resolution with the platform team.

## Manage changes over time

Platform-provided services and operations are considered external dependencies in this architecture. The platform team continues to apply changes, onboard landing zones, and apply cost controls. The platform team serving the organization might not prioritize individual workloads. Changes to those dependencies, such as firewall modifications, can affect multiple workloads.

Workload and platform teams must communicate in an efficient and timely manner to manage all external dependencies. It's important to test changes beforehand so that they don't negatively affect workloads.

### Platform changes that affect this workload

In this architecture, the platform team manages the following resources. Changes to these resources can potentially affect the workload's reliability, security, operations, and performance targets. It's important to evaluate these changes before the platform team implements them to determine how they affect the workload.

- **Azure policies:** Changes to Azure policies can affect workload resources and their dependencies. For example, there might be direct policy changes or movement of the landing zone into a new management group hierarchy. These changes might go unnoticed until there's a new deployment, so it's important to thoroughly test them.

  *Example:* A policy no longer allows the deployment of Azure OpenAI instances that support API key access.

- **Firewall rules:** Modifications to firewall rules can affect the workload's virtual network or rules that apply broadly across all traffic. These modifications can result in blocked traffic and even silent process failures. These potential problems apply to both the egress firewall and Azure Virtual Network Manager-applied NSG rules.

  *Example:* Blocked vendor update servers lead to failed operating system updates on the jump box or build agents.

- **Routing in the hub network:** Changes in the transitive nature of routing in the hub can potentially affect the workload functionality if a workload depends on routing to other virtual networks.

  *Example:* Prevents prompt flow to access a vector store that's operated by another team or data science teams from accessing browser-based experiences in the AI portals from their workstations.

- **Azure Bastion host:** Changes to the Azure Bastion host availability or configuration.

  *Example*: Prevents access to jump boxes and build agent VMs.

#### Workload changes that affect the platform

The following examples are workload changes in this architecture that you should communicate to the platform team. It's important that the platform team validates the platform service's reliability, security, operations, and performance targets against the new workload team's changes before they go into effect.

- **Network egress:** Monitor any significant increase in network egress to prevent the workload from becoming a noisy neighbor on network devices. This problem can potentially affect the performance or reliability targets of other workloads. This architecture is mostly self-contained and likely won't experience a significant change in outbound traffic patterns.

- **Public access:** Changes in the public access to workload components might require further testing. The platform team might relocate the workload to a different management group.

  *Example:* In this architecture, if you remove the public IP address from Application Gateway and make this application internal only, the workload's exposure to the internet changes. Another example is if the browser-based AI portals are changed to be exposed to the internet, which isn't recommended.

- **Business criticality rating:** If there are changes to the workload's service-level agreements (SLAs), you might need a new collaboration approach between the platform and workload teams.

  *Example:* Your workload can transition from low to high business critically with increased adoption and workload success.

## Enterprise architecture team

Some organizations have an enterprise architecture team that might influence the design of your workload and its architecture. That team will be familiar with the enterprise's [AI adoption](/azure/cloud-adoption-framework/scenarios/ai/) strategy as well as the principles and recommendations found in the [AI workloads on Azure](/azure/well-architected/ai/get-started) design. Work with this team to ensure this chat workload meets both the objectives of the scenario while also aligning with recommendations and strategy of the organization.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture aligns with the reliability guarantees in the [baseline architecture](./baseline-openai-e2e-chat.yml#reliability). There are no new reliability considerations for the core workload components.

#### Reliability targets

The maximum possible composite [service-level objective (SLO)](/azure/well-architected/reliability/metrics) for this architecture is lower than the baseline composite service-level objective (SLO) due to new components like egress network control. These components, common in landing zone environments, aren't unique to this architecture. The SLO is similarly reduced if the workload team directly controls these Azure services.

##### Critical dependencies

View all functionality that the workload performs in the platform and application landing zone as dependencies. Incident response plans require that the workload team is aware of the point and method of contact information for these dependencies. Also include these dependencies in the workload's failure mode analysis (FMA).

For this architecture, consider the following workload dependencies:

- **Egress firewall:** The centralized egress firewall, shared by multiple workloads, undergoes changes unrelated to the workload.

- **DNS resolution:** This architecture uses DNS provided by the platform team instead of directly interfacing with Azure DNS. This means that timely updates to DNS records for private endpoints and availability of DNS services are new dependencies.

- **DINE policies:** DINE policies for Azure DNS private DNS zones, or any other platform-provided dependency, are *best effort*, with no SLA when you apply them. For example, a delay in DNS configuration for this architecture's private endpoints can cause delays in the readiness of the chat UI to handle traffic or prompt flow from completing queries.

- **Management group policies:** Consistent policies among environments are key for reliability. Ensure that preproduction environments are similar to production environments to provide accurate testing and to prevent environment-specific deviations that can block a deployment or scale. For more information, see [Manage application development environments in Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments).

Many of these considerations might exist without Azure landing zones, but the workload and platform teams need to collaboratively address these problems to ensure that needs are met. For more information, see [Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis#identify-dependencies).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Ingress traffic control

Isolate your workload from other workload spokes within your organization by using NSGs on your subnets and the nontransitive nature or controls in the regional hub. Construct comprehensive NSGs that only permit the inbound network requirements of your application and its infrastructure. We recommend that you don't solely rely on the nontransitive nature of the hub network for security.

The platform team implements Azure policies for security. For example, a policy might ensure that Application Gateway has a web application firewall set to *deny mode*, which restricts the number of public IP addresses available to your subscription. In addition to those policies, the workload team should deploy more workload-centric policies that reinforce the ingress security posture.

The following table shows examples of ingress controls in this architecture.

| Source | Purpose | Workload control | Platform control |
| :----- | :------ | :--------------- | :--------------- |
| Internet | Application traffic flows | Funnels all workload requests through an NSG, a web application firewall, and routing rules before allowing public traffic to transition to private traffic for the chat UI. | None |
| Internet | Azure AI Foundry portal access | Deny all through service-level configuration. | None |
| Internet | Data plane access to all but Application Gateway | Deny all through NSG and service-level configuration. | None |
| Azure Bastion | Jump box and build agent access | NSG on jump box subnet that blocks all traffic to remote access ports, unless it's sourced from the platform's designated Azure Bastion subnet | None |
| Cross-premises | Azure AI Foundry portal access | Deny all. Unless jump box isn't used, then only allow workstations from authorized subnets for data scientist access. | Nontransitive routing or Azure Firewall if an Azure Virtual WAN secured hub is used |
| Other spokes | None | Blocked via NSG rules. | Nontransitive routing or Azure Firewall if a Virtual WAN secured hub is used |

#### Egress traffic control

Apply NSG rules that express the required outbound connectivity requirements of your solution and deny everything else. Don't rely only on the hub network controls. As a workload operator, you have the responsibility to stop undesired egress traffic as close to the source as practicable.

While you own your workload's subnets within the virtual network, the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture are still compatible with your original request. Work with your network team to ensure continuity of least-access egress control.

The following table shows examples of egress in this architecture.

| Endpoint | Purpose | Workload control | Platform control |
| :------- | :------ | :---------- | :---------- |
| Public internet sources | Prompt flow might require an internet search to complement an Azure OpenAI request | NSG on the prompt flow container host subnet or Azure AI Foundry-managed virtual network configuration | Firewall network rule allowance for the same as the workload control |
| Azure OpenAI data plane | The compute hosting prompt flow calls to this API for prompt handling | *TCP/443* to the private endpoint subnet from the subnet that contains the prompt flow | None |
| Key Vault | To access secrets from the chat UI or prompt flow host | *TCP/443* to the private endpoint subnet that contains Key Vault | None |

For traffic that leaves this architecture's virtual network, controls are best implemented at the workload level via NSGs and at the platform level via a hub network firewall. The NSGs provide initial, broad network traffic rules that are further narrowed down by specific firewall rules in the platform's hub network for added security. There's no expectation that east-west traffic within the workload's components, such as between the Azure AI Foundry portal and the Storage account in this architecture, should be routed through the hub.

#### DDoS Protection

Determine who should apply the DDoS Protection plan that covers all of your solution's public IP addresses. The platform team might use IP address protection plans, or use Azure Policy to enforce virtual network protection plans. This architecture should have coverage because it involves a public IP address for ingress from the internet. For more information, see [Recommendations for networking and connectivity](/azure/well-architected/security/networking).

#### Identity and access management

Unless otherwise required by your platform team's governance automation, there are no expectations of extra authorization requirements on this architecture because of the platform team's involvement. Azure role-based access control (RBAC) should continue to fulfill the principle of least privilege, which grants limited access only to those who need it and only when needed. For more information, see [Recommendations for identity and access management](/azure/well-architected/security/identity-access).

#### Certificates and encryption

The workload team typically procures the TLS certificate for the public IP address on Application Gateway in this architecture. Work with your platform team to understand how the certificate procurement and management processes should align with the organizational expectations.

All of the data storage services in this architecture support encryption keys managed by Microsoft or by customers. Use customer-managed encryption keys if your workload design or organization requires more control. Azure landing zones themselves don't mandate one or the other.

### Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For the workload resources, all of the cost optimization strategies in the [baseline architecture](./baseline-openai-e2e-chat.yml#cost-optimization) also apply to this architecture.

This architecture greatly benefits from Azure landing zone [platform resources](#platform-team-owned-resources). Even if you use those resources via a chargeback model, the added security and cross-premises connectivity are more cost-effective than self-managing those resources. Take advantage of other centralized offerings from your platform team to extend those benefits to your workload without compromising its SLO, recovery time objective (RTO), or recovery point objective (RPO).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The workload team is still responsible for all of the operational excellence considerations covered in the [baseline architecture](./baseline-openai-e2e-chat.yml#operational-excellence), such as monitoring, GenAIOps, quality assurance, and safe deployment practices.

#### Correlate data from multiple sinks

The workload's logs and metrics and its infrastructure components are stored in the workload's Azure Monitor Logs workspace. However, logs and metrics from centralized services, such as Azure Firewall, DNS Private Resolver, and Azure Bastion, are often stored in a central Azure Monitor Logs workspace. Correlating data from multiple sinks can be a complex task.

Correlated data is often used during incident response. Make sure that the triage runbook for this architecture addresses this situation and includes organizational points of contact if the problem extends beyond the workload resources. Workload administrators might require assistance from platform administrators to correlate log entries from enterprise networking, security, or other platform services.

> [!IMPORTANT]
> **For the platform team:** When possible, grant RBAC to query and read log sinks for relevant platform resources. Enable firewall logs for network and application rule evaluations and DNS proxy. The application teams can use this information to troubleshoot tasks. For more information, see [Recommendations for monitoring and threat detection](/azure/well-architected/security/monitor-threats).

#### Build agents

Many services in this architecture use private endpoints. Similar to the baseline architecture, this design potentially makes build agents a requirement of this architecture. Safe and reliable deployment of the build agents is a responsibility of the workload team, without involvement of the platform team. However, make sure that the management of the build agents is compliant with the organization. For example, use platform-approved operating system images, patching schedules, compliance reporting, and user authentication methods.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The performance efficiency considerations described in the [baseline architecture](./baseline-openai-e2e-chat.yml#performance-efficiency) also apply to this architecture. The workload team retains control over the resources used in demand flows, not the platform team. Scale the chat UI host, prompt flow host, language models, and others according to the workload and cost constraints. Depending on the final implementation of your architecture, consider the following factors when you measure your performance against performance targets.

- Egress and cross-premises latency
- SKU limitations derived from cost containment governance

## Deploy this scenario

A landing zone deployment for this reference architecture is available on GitHub.

> [!div class="nextstepaction"]
> [Implementation: Azure OpenAI chat baseline in an application landing zone](https://github.com/Azure-Samples/azure-openai-chat-baseline-landing-zone)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Azure patterns & practices - Microsoft
- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) | Microsoft Cloud Solution Architect
- [Bilal Amjad](https://www.linkedin.com/in/mbilalamjad/) | Microsoft Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

Review the collaboration and technical details shared between a workload team and platform teams.

> [!div class="nextstepaction"]
> [Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)

## Related resource

- Follow the recommendations found in the Well-Architected Framework's perspective on [AI workloads on Azure](/azure/well-architected/ai/get-started).
