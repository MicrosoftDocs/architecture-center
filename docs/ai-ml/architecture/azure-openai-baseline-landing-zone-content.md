The architecture in this article expands on the [Azure OpenAI end-to-end chat baseline architecture](baseline-openai-e2e-chat.yml) to address changes and expectations when you deploy it in an Azure landing zone application landing zone subscription.

This architecture describes a workload that needs a generative AI flow, such as a chat web interface that uses Azure OpenAI, and uses some shared resources that a platform team manages centrally. These shared resources include networking resources for connecting to or from on-premises locations, identity access management, and policies. This example assumes that the organization uses Azure landing zones today to ensure consistent governance and cost efficiency for multiple workloads or plans to adopt it prior to deploying this architecture described in this page.

As a workload owner, you can offload the management of shared resources to platform teams, so you can focus on workload development efforts. This article presents the workload team's perspective. Recommendations that are for the platform team are specified.

> [!IMPORTANT]
> **What are Azure landing zones?**
> Azure landing zones present two perspectives of an organization's cloud footprint. An *application landing zone* is an Azure subscription in which a workload runs. It's connected to the organization's shared platform resources. Through that connection, it has access to the infrastructure that supports the workload, such as networking, identity access management, policies, and monitoring. A *platform landing zone* is a collection of various subscriptions, each with a specific function. For example, a connectivity subscription provides centralized Domain Name System (DNS) resolution, hybrid connectivity (e.g. to/from on-premises), and network virtual appliances (NVAs) that are available for application teams to use.
>
> We recommend that you understand the concept of [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone), as well as its [design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) and [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas) to help you prepare for the implementation of this architecture.

## Article layout

| Architecture | Design decisions | Azure Well-Architected Framework approach |
| --- | --- | --- |
|&#9642; [Architecture diagram](#architecture)<br>&#9642; [Workload resources](#workload-team-owned-resources)<br>&#9642; [Federated resources](#platform-team-owned-resources) |&#9642; [Subscription setup](#subscription-setup)<br>&#9642; [Compute](#compute)<br>&#9642; [Networking](#networking)<br>&#9642; [Data scientist access](#data-scientist-and-prompt-flow-authorship-access)<br>&#9642; [Monitoring](#monitoring)<br>&#9642; [Organizational governance](#azure-policy)<br>&#9642; [Change management](#manage-changes-over-time)|&#9642; [Reliability](#reliability)<br>&#9642; [Security](#security)<br>&#9642; [Cost Optimization](#cost-optimization)<br>&#9642; [Operational Excellence](#operational-excellence)<br>&#9642; [Performance Efficiency](#performance-efficiency) |

> [!TIP]
> :::image type="icon" source="../../_images/github.svg"::: This [reference implementation](https://github.com/Azure-Samples/azure-openai-chat-baseline-landing-zone) demonstrates the best practices described in this article. The guidance in this is important for you to understand, consider and take inspiration from into your design decision prior to implementing.
>
> The repository artifacts provide a customizable foundation for your environment. The implementation sets up a hub network with shared resources like Azure Firewall for demonstration purposes. You can apply this setup to separate application landing zone subscriptions for distinct workload and platform functions.

## Architecture

:::image type="complex" source="./_images/azure-openai-baseline-landing-zone.svg" alt-text="TODO - WAITING FOR FINAL IMAGE" lightbox="./_images/azure-openai-baseline-landing-zone.svg":::
   TODO - WAITING FOR FINAL IMAGE
:::image-end:::
*Download a [Visio file - LINK TODO - WAITING FOR FINAL IMAGE](https://arch-center.azureedge.net/TODO) of this architecture.*

### Components

All Azure landing zone architectures have a separation of ownership between the platform team and the workload team, referred to as [subscription democratization](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization). Application architects, data scientists, and DevOps teams need to have a strong understanding of this responsibility split in order to understand what's under their direct influence or control and what's not.

Like most application landing zone implementations, the application team has a majority of the hands-on role in the configuration, management, and deployment of the workload components, including all AI services used in this architecture.

#### Workload team-owned resources

The following resources remain mostly unchanged from the [baseline architecture](./baseline-openai-e2e-chat.yml#components).

- **Azure OpenAI** is a managed service that provides REST API access to Azure OpenAI's large language models, including the GPT-4, GPT-3.5-Turbo, and Embedding models.
- **Azure Machine Learning** is used to develop and deploy [prompt flow](/azure/machine-learning/prompt-flow/overview-what-is-prompt-flow) logic used in this workload.
  - **Managed online endpoints** are used as a PaaS endpoint for the chat UI application, which invokes the prompt flows hosted by Azure Machine Learning.
- **Azure App Service** is used to host the example web application for the Chat UI. In this architecture, it's also possible to use this service to host the containerized prompt flow for more control over the hosting environment of prompt flow execution.
- **Azure AI Search** is included in the architecture as it's a common service used in the flows behind chat applications. Azure AI Search can be used to retrieve indexed data that is relevant for user queries.
- **Azure Storage** is used to persist the prompt flow source files for prompt flow development.
- **Azure Container Registry** is for storing flows that are packaged as container images.
- **Azure Application Gateway** is used as the reverse proxy to route user requests to the chat UI hosted in Azure App Service. The selected SKU is also used to host Azure Web Application Firewall to protect the front-end application from potentially malicious traffic.
- **Azure Key Vault** is used to store application secrets and certificates.
- **Azure Monitor, Log Analytics, and Application Insights** are used to collect, store, and visualize observability data.
- **Azure Policy** is used to apply policies that are specific to the workload to help govern, secure and apply controls at scale.

The workload team maintains and fulfills the following resources and responsibilities.

- **Spoke virtual network subnets and the network security groups (NSGs)** that are placed on those subnets to maintain segmentation and control traffic flow.
- **Private endpoints** to secure connectivity to platform as a service (PaaS) solutions.

#### Platform team-owned resources

The platform team owns and maintains these centralized resources to optimize overall organizational spend and provide governance. This architecture assumes that these resources are pre-provisioned and considers them dependencies.

- **Azure Firewall in the hub network** is used to route, inspect, and restrict egress traffic. Workload egress traffic is traffic going to the Internet, cross-premises destinations, or to other application landing zones. Compared to the baseline, this component is new in the architecture. Generally speaking, Azure Firewall isn't cost-effective or practical for each workload team to manage their own instance.
- **Azure Bastion in the hub network** provides secure operational access to workload components and also allows access to Azure AI Studio components. In the baseline architecture, the workload team owned this component.
- The **spoke virtual network** is where the workload is deployed. In the baseline architecture, the workload team own this network.
- **User-defined routes** (UDRs) are used to force tunneling to the hub network. This component is new in the architecture.
- **Azure Policy-based governance constraints** and `DeployIfNotExists` (DINE) policies are part of the workload subscription. These are extra policies that exist over what was described in the baseline. These policies can be applied at both the platform-team owned Management Group level or applied to the workload's subscription directly.
- **Azure Private DNS Zones** to host the `A` records for private endpoints. Relative to the baseline, this component is moved to the hub and is platform managed. See [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale).
- **DNS resolution service** for spoke virtual networks and cross-premises workstations. This usually takes the form of Azure Firewall DNS Proxy or Azure Private DNS Resolver. The choice of technology is obfuscated from workload teams and not a decision your workload team makes. In this architecture, this service resolves private endpoint DNS records for all DNS requests originating in the spoke.
- **Azure DDoS Protection** is used to protect public IPs against distributed attacks. Generally speaking, DDoS Protection isn't cost-effective for each workload team to manage their own protection plans and therefore centralized to platform teams.

> [!IMPORTANT]
> Azure landing zones provide some of the preceding resources as part of the platform landing zone subscriptions, and your workload subscription provides other resources. Many of the resources are part of the connectivity subscription, which has additional resources, such as Azure ExpressRoute, Azure VPN Gateway, and Azure Private DNS Resolver. These additional resources provide cross-premises access and name resolution. The management of these resources is outside the scope of this article.

## Subscription setup

In a landing zone context, the workload team implementing this architecture must inform the platform team of their specific requirements, and the platform team must communicate their requirements to the workload team.

For example, your **workload team** must include detailed information about the networking space that your workload needs, so that the platform team can allocate necessary resources. Your team determines the requirements and the platform team determines the IP addresses to assign within the virtual network.

Likewise, the **platform team** assigns an appropriate management group based on the workload's business criticality and technical requirements, for example if a workload is exposed to the Internet like this one is. The platform team determines the configuration and implementation of these management groups. Your workload team must design the workload to work and be operated on within that governance. For more information on typical management group distinctions, see [Tailor the Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/tailoring-alz).

Ultimately, the platform team is responsible for setting up the subscription for this architecture. The following sections provide guidance on the initial subscription setup as it relates to this architecture.

### Workload requirements and fulfillment

The workload team and platform teams need to collaborate on a few topics: management group assignment, including the associated Azure Policy governance, and networking setup. For this architecture, consider the following networking requirements that you should communicate to the platform team. Use these points as examples to understand the discussion and negotiation between the two teams.

- **The number of spoke virtual networks**: In this architecture, only one dedicated spoke is required. The deployed resources don't need to span across multiple networks and are colocated within a single virtual network.

- **The size of the spoke network**: Most of the services in this architecture are private endpoints with single IP addresses or have predefined space requirements. When communicating these requirements consider the following larger items:

  - Application Gateway subnet (fixed required size)
  - Prompt flow container host (either as part of Azure Machine Learning compute or on your dedicated host). If you plan to implement blue/green deployments of prompt flow compute, the maximum size should account for the space that your side-by-side deployments require. (variable size based on needs)
  - Private Endpoints and Azure Web App endpoints (fixed count).

- **The deployment region**: The platform team uses this information to ensure that the spoke's hub is provisioned in the same region.

- **The workload characteristics and design choices**: Communicate your design choices, components, and usage characteristics to your platform team.

  For instance, if you expect your prompt flow code to generate a high number of concurrent connections to the Internet (*chatty*), the platform team should ensure that there are sufficient ports available to prevent exhaustion. They can add IP addresses to the centralized firewall to support the traffic or set up a NAT gateway to route the traffic through an alternate path. It's possible that the platform team might consider placing you in a different management group (such as Online instead of Corp) based on a key decision point such as this.

- **The firewall configuration**: The platform team must be aware of specifics of the traffic that is expected to leave the spoke network. These are workload dependencies.

  For example, prompt flow might need access to a vector database that another team owns or maybe prompt flow connects to Wikipedia to augment the prompt to Azure OpenAI. Cover the needs of both the authoring experience and production hosting.

- **Data scientist access to browser-based portals**: The platform team can help decide how best to allow authorized network traffic into Azure AI Studio or similar portals.

  Platform team can help establish routing through an existing VPN gateway or ExpressRoute connection from the data scientists' workstations and corporate network connection. If that's not possible, the design to fall back to using Azure Bastion hosts provided by the platform team to a jump box managed by the workload team, which would be similar to the baseline.

- **The public IPs**: Inform the platform team about the ingress traffic profile, including any anticipated public IP addresses. The platform team should inform the workload team if these IPs are under an Azure DDoS Protection plan or if that's the responsibility of the workload team.

  In this architecture, only Internet-sourced traffic targets the public IP on Application Gateway.

- **Private endpoint usage**: Inform the platform team that this architecture uses private endpoints. All clients of those endpoints in the workload must able to resolve the private endpoint IP address.

> [!IMPORTANT]
> We recommend a subscription vending process for the platform team that involves a series of questions designed to capture information from the workload team. These questions might vary from one organization to another, but the intent is to gather the requirements for implementing subscriptions. For more information, see [Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).

## Compute

The compute hosting the prompt flow and the chat UI remains the same as the [baseline architecture](./baseline-openai-e2e-chat.yml#prompt-flow-runtimes).

An organization might impose requirements on the workload team that mandates the use of a specific Azure Machine Learning runtime. For example, the requirement might be to avoid automatic runtime or compute instance runtimes and instead favoring a prompt flow container host that fulfills compliance, security, and observability mandates.

The organization's governance might add more requirements around container base image maintenance and dependency package tracking than what the workload requirements indicate. Workload teams must ensure the workload's runtime environment, the code deployed to it, and its operations align with these organizational standards.

## Networking

In the [baseline architecture](./baseline-openai-e2e-chat.yml#networking), the workload is provisioned in a single virtual network. In landing zones, the workload is effectively split over two virtual networks. One network for the workload components and one for controlling internet and hybrid connectivity. The platform team determines how the workload's virtual network integrates with the organization's larger network architecture; usually with a hub-spoke topology.

:::image type="complex" source="./_images/azure-openai-baseline-landing-zone-networking.svg" alt-text="TODO - WAITING FOR FINAL IMAGE" lightbox="./_images/azure-openai-baseline-landing-zone-networking.svg":::
   TODO - WAITING FOR FINAL IMAGE
:::image-end:::
*Download a [Visio file - TODO - WAITING FOR FINAL IMAGE](https://arch-center.azureedge.net/TODO.vsdx) of this architecture.*

- **Hub virtual network**: A regional hub contains centralized, and often shared, services that communicate with workload resources in the same region. The hub found in the [connectivity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity). The platform team owns the resources in this network.

- **Spoke virtual network**: In this architecture, the single virtual network from the baseline architecture essentially becomes the spoke network. It's peered to the hub network by the platform team. The platform team owns and manages this spoke network, its peering, and DNS (domain name system) configuration. This network contains many of the [workload resources](#workload-team-owned-resources). The workload team owns the resources in this network, including its subnets.

Because of this management and ownership split, make sure that you clearly [communicate the workload's requirements](#subscription-setup) to the platform team.

> [!IMPORTANT]
> **For the platform team**:
> Unless specifically required by the workload, don't directly peer the spoke network to another spoke virtual network. This practice protects the segmentation goals of the workload. Unless the application landing zone teams have cross-connected with self-managed private endpoints, your team should facilitate all transitive virtual network connections. Be sure to inquire if components in this architecture requires access to dependencies hosted by other workloads. One such example might be prompt flow requiring access to a vector database managed by another workload team.

### Virtual network subnets

In the spoke virtual network, the workload team creates and allocates the subnets that are aligned with the requirements of the workload. Placing controls to restrict traffic in and out of the subnets helps to provide segmentation. This architecture doesn't add any subnets beyond those subnets described the [baseline architecture](./baseline-openai-e2e-chat.yml#virtual-network-segmentation-and-security). The network architecture however no longer requires the `AzureBastionSubnet` subnet as the platform team is hosting this service in their subscriptions.

When you deploy your workload in an Azure landing zone, you still have to implement local network controls. Organizations might impose further network restrictions to safeguard against data exfiltration and ensure visibility for the central security operations center (SOC) and the IT network team.

### Ingress traffic

The ingress traffic flow remains the same as the [baseline architecture](./baseline-openai-e2e-chat.yml#network-flows).

Your workload team is responsible for any resources that are related to public Internet ingress into the workload. For example, in this architecture, Application Gateway and its public IP are placed in the spoke network and not the hub network. Some organizations might place resources with ingress traffic in a connectivity subscription by using a centralized demilitarized (DMZ) implementation. Integration with that specific topology is out of scope for this article.

This architecture doesn't use Azure Firewall for inspecting incoming traffic. Sometimes organizational governance requires this approach. Platform teams support the implementation to provide workload teams an extra layer of intrusion detection and prevention to block unwanted inbound traffic. This architecture needs additional UDR configurations to support this topology. To explore this approach, see [Zero-trust network for web applications with Azure Firewall and Application Gateway](../../example-scenario/gateway/application-gateway-before-azure-firewall.yml).

### DNS configuration

In the baseline architecture, Azure DNS was used directly by all components for DNS resolution. In landing zone architectures, DNS is usually delegated to one or more DNS servers in the hub. When the virtual network is created for this architecture, the DNS properties on the virtual network are expected to already be set accordingly. The DNS service is considered opaque to your workload team.

The workload components in this architecture get configured with DNS in the following ways.

| Component | DNS configuration |
| :-------- | :---------------- |
| Azure Application Gateway | Inherited from virtual network |
| Azure App Service (Chat UI) | Workload team sets the web app to use hub DNS servers using the [`dnsConfiguration` property](/azure/app-service/overview-name-resolution#configuring-dns-servers). |
| Azure App Service (Prompt Flow) | Workload team sets the web app to use hub DNS servers using the [`dnsConfiguration` property](/azure/app-service/overview-name-resolution#configuring-dns-servers). |
| Azure AI Search | Can't be overridden, uses Azure DNS |
| Azure Machine Learning compute cluster | &#9642; Managed virtual network: Can't be overridden, uses Azure DNS. This architecture uses this approach.<br/> &#9642; Virtual network integration: Inherited from virtual network |
| Azure Machine Learning automatic runtime | &#9642; Managed virtual network: Can't be overridden, uses Azure DNS.<br/><br/> &#9642; Virtual network integration: Inherited from virtual network<br/>This architecture doesn't use automatic runtime. |
| Azure Machine Learning compute instance | &#9642; Managed virtual network: Can't be overridden, uses Azure DNS. This architecture uses this approach.<br/> &#9642; Virtual network integration: Inherited from virtual network |
| Azure OpenAI | Can't be overridden, uses Azure DNS |
| Jump box | Inherited from virtual network |
| Build agents | Inherited from virtual network |

No DNS settings are configured for the remaining components in the architecture, as no outbound communication happens from those services so no DNS resolution is required.

Many of these components require appropriate DNS records in the hub's DNS servers to resolve this workload's many private endpoints. More on this topic is found in [Private DNS zones](#private-dns-zones). For components where hub-based DNS resolution can't happen your architecture, you are faced with the following limitations:

- The platform team won't be able to log DNS requests, which might be an organizational security team requirement.
- Resolving to Private Link exposed services in your or other application landing zones might be impossible. Some services, such as Azure Machine Learning computes, work around this limitation through service-specific features.

If you do not know how DNS is managed by the platform team, familiarize yourself with the typical approaches in [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale). Be sure to evaluate if the inclusion of component features that directly depend on Azure DNS are problematic in your platform team's provided DNS topology. Exceptions might need to be made or redesign of this component in the workload might be necessary.

### Egress traffic

In the baseline architecture, Internet egress control was only available through the network configuration on Azure Machine Learning workspaces and Azure App Services, combined with using Network Security Groups (NSG) on the various subnets. Those controls remain present in this architecture but are further augmented. In this architecture, all traffic that leaves the spoke virtual network is now rerouted through the peered hub network via an egress firewall. Traffic originating inside the managed virtual network for Azure Machine Learning computes is not subject to this egress route.

:::image type="complex" source="./_images/azure-openai-baseline-landing-zone-networking-egress.svg" alt-text="TODO - WAITING FOR FINAL IMAGE" lightbox="./_images/azure-openai-baseline-landing-zone-networking-egress.svg":::
   TODO - WAITING FOR FINAL IMAGE
:::image-end:::
*Download a [Visio file TODO - WAITING FOR FINAL IMAGE](https://arch-center.azureedge.net/TODO.vsdx) of this architecture.*

East-west client communication to the private endpoints for Azure Container Registry, Azure Key Vault, Azure OpenAI, and so on, remains the same as the [baseline architecture](./baseline-openai-e2e-chat.yml#networking). That path is omitted from the preceding diagram for brevity.

#### Routing Internet traffic to the firewall

A route is attached to all the possible subnets in the spoke network that directs all traffic headed to the Internet (*0.0.0.0/0*) first to the hub's Azure Firewall.

| Component | Mechanism to force Internet traffic through hub |
| :-------- | :---------------- |
| Azure Application Gateway | None. Internet-bound traffic originating from this service can't be forced through a platform team firewall. |
| Azure App Service (Chat UI) | [Regional virtual network integration](/azure/app-service/configure-vnet-integration-enable) is enabled.<br/>[vnetRouteAllEnabled](/azure/app-service/configure-vnet-integration-routing#configure-application-routing) is enabled. |
| Azure App Service (Prompt Flow) | [Regional virtual network integration](/azure/app-service/configure-vnet-integration-enable) is enabled.<br/>[vnetRouteAllEnabled](/azure/app-service/configure-vnet-integration-routing#configure-application-routing) is enabled. |
| Azure AI Search | None. Traffic originating from this service can't be forced through a firewall. This architecture doesn't use skills. |
| Azure Machine Learning compute cluster | &#9642; Managed virtual network: Internet-bound traffic originating from this service can't be forced through a platform team firewall. This architecture uses this approach.<br/> &#9642; Virtual network integration: Uses UDR applied to the subnet containing the compute cluster. |
| Azure Machine Learning automatic runtime | &#9642; Managed virtual network: Internet-bound traffic originating from this service can't be forced through a platform team firewall. <br/> &#9642; Virtual network integration: Uses UDR applied to the subnet containing the compute cluster.<br/><br/>This architecture doesn't use automatic runtime. |
| Azure Machine Learning compute instance | &#9642; Managed virtual network: Internet-bound traffic originating from this service can't be forced through a platform team firewall. This architecture uses this approach.<br/> &#9642; Virtual network integration: Uses UDR applied to the subnet containing the compute cluster. |
| Azure OpenAI | None. Traffic originating from this service (such as "[On your data](/azure/ai-services/openai/concepts/use-your-data)") can't be forced through a firewall. This architecture doesn't any of these features. |
| Jump box | Uses the UDR applied to snet-jumpbox |
| Build agents | Uses the UDR applied to snet-agents |

No force tunnel settings are configured for the remaining components in the architecture, as no outbound communication happens from those services.

For components or component features where egress control through hub routing isn't possible, your workload team is still responsible to align with organizational requirements on this traffic. Use compensating controls, redesign the workload to avoid these features, or seek formal exception. Workloads are ultimately responsible for mitigating data exfiltration and abuse.

Apply the platform-provided Internet route to all subnets, even if the subnet isn't expected to have outgoing traffic. This approach ensures that any unexpected deployments into that subnet are subjected to routine egress filtering. Ensure subnets that contain private endpoints have network policy enabled for full routing and NSG control.

Applying this route configuration to the architecture ensures that all outbound connections from Azure App Services, Azure Machine Learning workspace, or any other services that originating on the workload's virtual network are scrutinized and controlled.

### Private DNS zones

Architectures that use private endpoints for east-west traffic within their workload need DNS zone records in the configured DNS provider. This architecture requires many DNS zone records to function properly: Azure Key Vault, Azure OpenAI, and more to support Private Link.

In this architecture, it's assumed that Azure Private DNS Zones are being maintained in the hub. This is a change from the baseline architecture in which the workload team was directly responsible for the private DNS zones. The platform team might use another technology, but for this architecture we assume it's private DNS zone records.

The workload team must have a clear understanding of the requirements and expectation of the management of those private DNS zone records from their platform team. These DNS zone records are typically managed through a process established by the platform team and can't be managed directly by your workload team. The correct configuration of these zone records enables functionality on Azure Firewall such as DNS proxy and fully qualified domain name (FQDN) network rules. The private DNS zones also support the use of Azure Private DNS Resolver as the region's spokes' DNS server.

In this architecture, the platform team must ensure the reliable and timely DNS hosting for the following private link endpoints:

- Azure AI search
- Azure Container Registry
- Azure Key Vault
- Azure OpenAI
- Azure Storage accounts

## Data scientist and prompt flow authorship access

Like the [baseline architecture](./baseline-openai-e2e-chat.yml#ingress-to-azure-machine-learning), public ingress access to the Azure Machine Learning workspace and other browser-based experiences are disabled. The baseline architecture deploys a jump box to provide a browser with a source IP from the virtual network to be used by various workload roles.

When your workload is connected to an Azure landing zone, more options are available to your team for this access. Work with your platform team to see if private access to the various browser-based AI studios can instead be achieved without the need for managing and governing a virtual machine. This might be accomplished through transitive access from an already-established ExpressRoute or VPN Gateway connection. Native workstation-based access requires cross-premisis routing and DNS resolution, which the platform team can help provide. Make this requirement known in your subscription vending request.

Providing native workstation-based access to these portals is a productivity enhancement over the baseline and can be simpler to maintain than virtual machine jump boxes.

### The role of the jump box

Having a jump box in this architecture is still valuable, but not for runtime or AI/ML development purposes. Since all of the components in this architecture are otherwise unreachable through an external network, having a "in network" virtual machine can be critical for troubleshooting DNS resolution issues or network routing issues in this architecture.

In the baseline architecture, Azure Bastion is deployed as part of the workload to access that jump box. For a typical organization that adopts Azure landing zones, the platform team deploys Azure Bastion as shared resources for each region. To demonstrate that use case in this architecture, Azure Bastion is in the connectivity subscription and no longer deployed by the workload team.

The virtual machine used as the jump box must comply with organizational requirements for virtual machines. These requirements might include items such as: using corporate identities in Microsoft Entra ID, using specific base images, patching regimes, and so on.

## Monitoring

The Azure landing zone platform provides shared observability resources as part of the management subscription. However, we recommend that you provision your own monitoring resources to facilitate ownership responsibilities of the workload. This approach is consistent with the [baseline architecture](./baseline-openai-e2e-chat.yml#monitoring).

The workload team provisions the monitoring resources, which include:

- Application Insights as the application performance monitoring (APM) service for the workload team. This is configured in the Chat UI and prompt flow code.
- The Log Analytics workspace as the unified sink for all logs and metrics that are collected from workload-owned Azure resources.

Similar to the baseline, all resources are configured to send Azure Diagnostics logs to the Log Analytics workspace that the workload team provisions as part of the infrastructure as code (IaC) deployment of the resources. You might also need to send logs to a central Log Analytics workspace. In Azure landing zones, that workspace is typically in the management subscription.

The platform team might also have processes that impact your application landing zone resources. For example, they might use DINE policies that they can use to configure Diagnostics to send logs to their centralized management subscriptions. Or they might use [Azure monitor baseline alerts](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/deploy/Introduction-to-deploying-the-ALZ-Pattern/) applied through policy. It's important to ensure that your implementation doesn't restrict the extra log and alerting flows.

## Azure Policy

The [baseline architecture](./baseline-openai-e2e-chat.yml#governance-through-policy) recommends some general policies to help govern the workload. There are no specific additional policies that are indicated or contraindicated while this architecture is operating from an application landing zone. Continue to apply policies to your subscription, resource groups, or resources that aid in the governance and security of this workload.

Generally speaking, the application landing zone subscription has policies applied that further restrict the workload deployment. Some policies help organizational governance by auditing or block specific configurations in deployments. Platform teams might also apply DINE policies to handle automated deployments into an application landing zone subscription. Preemptively incorporate and test the platform-initiated restrictions and changes into your IaC templates. If the platform team uses Azure policies that conflict with the requirements of the application, you can negotiate a resolution with the platform team.

## Manage changes over time

Platform-provided services and operations are considered external dependencies in this architecture. The platform team continues to apply changes, onboard landing zones, and apply cost controls. The platform team, serving the organization, might not prioritize individual workloads. Changes to those dependencies, such as firewall modifications can affect multiple workloads.

Therefore, workload and platform teams must communicate efficiently and timely to manage all external dependencies. It's important to test changes, so they don't negatively affect workloads.

### Platform changes that affect this workload

In this architecture, the platform team manages the following resources. Changes to these resources can potentially affect the workload's reliability, security, operations, and performance targets. It's important to have an opportunity to evaluate these changes before the platform team puts them into effect to determine how they affect the workload.

- **Azure policies**: Changes to Azure policies can affect workload resources and their dependencies. For example, there might be direct policy changes or movement of the landing zone into a new management group hierarchy. These changes might go unnoticed until there's a new deployment, so it's important to thoroughly test them. **Example**: A policy to no longer allow deploying Azure OpenAI instances with support for API key access.

- **Firewall rules**: Modifications to firewall rules can affect the workload's virtual network or rules that apply broadly across all traffic. These modifications can result in blocked traffic and even silent process failures. These potential problems apply to both the egress firewall and Azure Virtual Network Manager-applied NSG rules. **Example**: Blocking vendor update servers leading to failed OS updates on the jump box or build agents.

- **Routing in the hub network**: Changes in the transitive nature of routing in the hub can potentially affect the workload functionality if a workload depends on routing to other virtual networks. **Example**: Preventing prompt flow to access a vector store operated by another team or data science teams from accessing browser-based experiences in the AI portals from their workstations.

- **Azure Bastion host**: Changes to the Azure Bastion host availability or configuration. **Example**: Preventing access to jump boxes and build agent virtual machines.

#### Workload changes that affect the platform

The following examples are workload changes in this architecture that you should communicate to the platform team. It's important that the platform team validates the platform service's reliability, security, operations, and performance targets against the new workload team changes before they go into effect.

- **Network egress**: Monitor any significant increase in network egress to prevent the workload from becoming a noisy neighbor on network devices. This problem can potentially affect the performance or reliability targets of other workloads. This architecture is mostly self contained and likely won't experience a significant change in outbound traffic patterns.

- **Public access**: Changes in the public access to workload components might require further testing. The platform team might relocate the workload to a different management group. **Example**: In this architecture, this would happen by removing the Public IP from Application Gateway and having this be an internal-only application. It can also happen if the browser-based AI portals are changed to be exposed to the Internet (which is not recommended).

- **Business criticality rating**: If there are changes to the workload's service-level agreements (SLAs), you might need a new collaboration approach between the platform and workload teams. **Example**: Your workload could transition preview to low to high business critically with increased adoption and workload success.

## Reliability

This architecture aligns with the reliability guarantees in the [baseline architecture](./baseline-openai-e2e-chat.yml#reliability). There are no new reliability considerations for the core workload components.

### Reliability targets

The maximum possible composite service-level objective (SLO) for this architecture is lower than the baseline composite SLO due to new components like egress network control. These components, common in landing zone environments, aren't unique to this architecture. The SLO is similarly reduced if the workload team directly controls these Azure services.

#### Critical dependencies

View all functionality that the workload performs in the platform and application landing zone as dependencies. Incident response plans require that the workload team is aware of the point and method of contact information for these dependencies. Also include these dependencies in the workload's failure mode analysis (FMA).

For this architecture, consider the following workload dependencies in this architecture:

- **Egress firewall**: The centralized egress firewall, shared by multiple workloads, undergoes changes unrelated to the workload.
- - **DNS Resolution**: This architecture is using DNS provided by the platform team instead of directly interfacing with Azure DNS. This means that timely updates to DNS records for private endpoints and availability of DNS services are new dependencies.
- **DINE policies**: DINE policies for Azure DNS private DNS zones (or any other platform-provided dependency) are *best effort*, with no SLA on execution. For example, a delay in DNS configuration for this architecture's private endpoints can cause delays in the readiness of the chat UI to handle traffic or Prompt Flow from completing queries.
- **Management group policies**: Consistent policies among environments are key for reliability. Ensure that preproduction environments are similar to production environments to provide accurate testing and to prevent environment-specific deviations that can block a deployment or scale. For more information, see [Manage application development environments in Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments).

Many of these considerations might exist without Azure landing zones, but the workload and platform teams need to collaboratively address these problems to ensure needs are met.

## Security

The security considerations for this architecture largely carry over from the [baseline architecture](./baseline-openai-e2e-chat.yml#security). Areas of added attention follow.

### Ingress traffic control

You should isolate your workload from other workload spokes within your organization via NSGs on your subnets and using the nontransitive nature or controls in the regional hub. Construct comprehensive NSGs that only permit the inbound network requirements of your application and its infrastructure. We recommend that you don't solely rely on the nontransitive nature of the hub network for security.

The platform team likely implements Azure policies to ensure that Application Gateway has Web Application Firewall set to *deny mode*, to restrict the number of public IPs available to your subscription, and other checks. In addition to those policies, the workload team should own the responsibility of deploying more workload-centric policies that reinforce the ingress security posture.

The following table shows examples of ingress controls in this architecture.

| Source | Purpose | Workload control | Platform control |
| :----- | :------ | :--------------- | :--------------- |
| Internet | Application traffic flows | Funnels all workload requests through an NSG, Web Application Firewall, and routing rules before allowing public traffic to transition to private traffic for the Chat UI. | None |
| Internet | Azure AI Studio access | Deny all through service-level configuration. | None |
| Internet | Data plane access to all but Application Gateway | Deny all through NSG and service-level configuration. | None |
| Azure Bastion | Jump box and build agent access | NSG on jump box subnet that blocks all traffic to remote access ports, unless it's sourced from the platform's designated Azure Bastion subnet | None |
| Cross-premises | Azure AI Studio access | Deny all. Unless jump box isn't used, then only allow workstations from authorized subnets for data scientist access. | Nontransitive routing or Azure Firewall if an Azure Virtual WAN secured hub is used |
| Other spokes | None | Blocked via NSG rules | Nontransitive routing or Azure Firewall if an Azure Virtual WAN secured hub is used |

### Egress traffic control

Apply NSG rules that express the required outbound connectivity requirements of your solution and deny everything else. Don't rely only on the hub network controls. As a workload operator, you have the responsibility to stop undesired egress traffic as close to the source as practicable.

While you own your workload's subnets within the virtual network, the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture are still compatible with your original request. Or you can work with your network team to ensure continuity of least-access egress control.

The following table shows examples of egress in this architecture.

| Endpoint | Purpose | Workload control | Platform control |
| :------- | :------ | :---------- | :---------- |
| *public Internet sources* | Prompt flow might require an Internet search to compliment an Azure OpenAI request. | NSG on the prompt flow container host subnet or Azure Machine Learning managed virtual network configuration. | Firewall network rule allowance for the same as the workload control |
| Azure OpenAI data plane | The compute hosting prompt flow calls to this API for prompt handling | *TCP/443* to the private endpoint subnet from the subnet containing the prompt flow | None |
| Key Vault | To access secrets from the Chat UI or prompt flow host | *TCP/443* to the private endpoint subnet containing Key Vault | None |

For traffic leaving this architecture's virtual network, controls are best implemented at both the workload (Network Security Groups) and platform (Hub network firewall) levels. The NSGs provide initial, broad network traffic rules that are further narrowed down by specific firewall rules in the platform's hub network for added security. There's no expectation that east-west traffic within the workload's components (such as between Azure Machine Learning studio and the storage account in this architecture) be routed through the hub.

### DDoS Protection

Determine who's responsible for applying the DDoS Protection plan that covers all of your solution's public IPs. The platform team might use IP protection plans or might even use Azure Policy to enforce virtual network protection plans. This architecture should have coverage because it involves a public IP for ingress from the Internet.

### Identity and access management

Unless otherwise required by your platform team's governance automation, there are no expectations of additional authorization requirements on this architecture due to the platform team involvement. Azure role-based access control (RBAC) should continue to serve the least-priviledge needs of the workload.

### Certificates and encryption

Typically the workload team would be responsible for procuring the TLS certificate for the public IP on Application Gateway in this architecture. Work with your platform team to understand how certificate procurement and management are expected to occur in your application landing zone.

All of the data storage services in this architecture support both Microsoft-managed or customer-managed encryption keys. Use customer-managed instead of microsoft-managed encryption keys is if either the workload design indicates this requirement or your organization's cloud governance requires it. Azure landing zones themselves do not mandate one or the other.

## Cost optimization

For the workload resources, all of cost optimization strategies in the [baseline architecture](./baseline-openai-e2e-chat.yml#cost-optimization) also apply to this architecture.

This architecture greatly benefits from Azure landing zone [platform resources](#platform-team-owned-resources). Even if you use those resources via a chargeback model, the added security and cross-premises connectivity are more cost-effective than self-managing those resources. Take advantage of other centralized offerings from your platform team to extend those benefits to your workload without compromising its SLO, recovery time objective (RTO), or recovery point objective (RPO).

## Operational excellence

The workload team is still responsible for all of the operational excellence considerations covered in the [baseline architecture](./baseline-openai-e2e-chat.yml#operational-excellence); such as monitoring, LLMOps, quality assurance, and safe deployment practices.

### Correlate data from multiple sinks

The workload's logs and metrics and its infrastructure components are stored in the workload's Log Analytics workspace. However, logs and metrics that centralized services, such as Azure Firewall, Azure Private DNS Resolver, and Azure Bastion, generally are stored in a central Log Analytics workspace. Correlating data from multiple sinks can be a complex task.

Correlated data is often used during incident response. Make sure the triage runbook for this architecture addresses this situation and includes organizational points of contact if the problem extends beyond the workload resources. Workload administrators might require assistance from platform administrators to correlate log entries from enterprise networking, security, or other platform services.

> [!IMPORTANT]
>
> **For the platform team:** Where possible, grant role-based access control (RBAC) to query and read log sinks for relevant platform resources. Enable firewall logs for network and application rule evaluations and DNS proxy because the application teams can use this information during troubleshooting tasks.

### Build agents

Because many of the services in this architecture remain behind private endpoints, build agents are likely a requirement of this architecture, like they were in the baseline. Getting this workload safely and reliability deployed is still a direct responsibility and requirement of the workload team; the platform team isn't involved in workload deployment. Build agents are often virtual machines. Work with your platform team to ensure you're using compliant: OS images (potentially from a platform hosted Azure Compute Gallery instance), patching schedules, compliance reporting, and user authentication methods.

## Performance efficiency

The performance efficiency considerations addressed in the [baseline architecture](./baseline-openai-e2e-chat.yml#performance-efficiency) also apply to this architecture. Because the platform team is largely not involved in resources used in the demand flows of the workload, supply of the workload resources remains in control of the workload team. The workload team is free to scale the chat UI host, prompt flow host, large language models (LLM), and so on, as needed by the requirements of the workload and the workload's budget. Depending on implementation details of your final architecture, remember to consider the following factors when measuring your performance against performance targets.

- Egress & cross-premises latency
- SKU limitations derived from cost containment governance

## Deploy this scenario

A landing zone deployment for this reference architecture is available on GitHub.

> [!div class="nextstepaction"]
> [Implementation: Azure OpenAI chat baseline in an application landing zone](https://github.com/Azure-Samples/azure-openai-chat-baseline-landing-zone)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Azure patterns & practices - Microsoft
- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) | Cloud Solution Architect - Microsoft

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

Review the collaboration and technical details shared between a workload team and platform teams.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
