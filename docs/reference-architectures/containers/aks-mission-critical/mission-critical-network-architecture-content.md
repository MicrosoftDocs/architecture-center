This architecture provides guidance for designing a mission critical workload that has strict network controls in place to prevent unauthorized public access from the internet to any of the workload resources. The intent is to stop attack vectors at the networking layer so that the overall reliability of the system isn't impacted. For example, a Distributed Denial of Service (DDoS) attack, if left unchecked, can cause a resource to become unavailable by overwhelming it with illegitimate traffic.

It builds on the **[mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)**, which is focused on maximizing reliability and operational effectiveness without network controls. This architecture adds features to restrict ingress and egress paths using the appropriate cloud-native capabilities, such as Azure Virtual Network(VNet) and private endpoints, Azure Private Link, Azure Private DNS Zone, and others.

It's recommended that you become familiar with the baseline before proceeding with this article.

## Key design strategies

The [design strategies for mission-critical baseline](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#key-design-strategies) still apply in this use case. Here are the additional networking considerations for this architecture:

- **Control ingress traffic**

    Ingress or inbound communication into the virtual network must be restricted to prevent malicious attacks.

    Apply Web Application Firewall (WAF) capabilities at the global level to _stop attacks at the network edge closer to the attack source_.

    _Eliminate public connectivity to Azure services_. One approach is to use private endpoints.

    _Inspect traffic before it enters the network_. Network security groups (NSGs) on subnets help filter traffic by allowing or denying flow to the configured IP addresses and ports. This level of control also helps in granular logging.

- **Control egress traffic**

    Egress traffic from a virtual network to entities outside that network must be restricted. Lack of controls might lead to data exfiltration attacks by malicious third-party services.

    _Restrict outbound traffic to the internet using Azure Firewall_. Firewall can filter traffic granularly using fully qualified domain name (FQDN).

- **Balance tradeoffs with security**

    There are significant trade-offs when security features are added to a workload architecture. You might notice some impact on performance, operational agility, and even reliability. However, _attacks, such as Denial-Of-Service (DDoS), data intrusion, and others, can target the system's overall reliability and eventually cause unavailability_.
  
> The strategies are based on the overall guidance provided for mission-critical workloads in [Well-architected mission critical workloads](/azure/architecture/framework/mission-critical/). We suggest that you explore the [design area of networking and connectivity](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity) for recommendations and best practices when defining your own mission critical architecture.

## Architecture

:::image type="content" source="./images/mission-critical-architecture-network.svg" alt-text="Diagram showing private endpoint subnet in the regional stamp virtual network." lightbox="./images/mission-critical-architecture-network-highres.png":::

*Download a [Visio file](https://arch-center.azureedge.net/mission-critical-network-architecture.vsdx) of this architecture.*

The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

The global resources are long living and share the lifetime of the system. They have the capability of being globally available within the context of a multi-region deployment model. For more information, see [**Global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

**Azure Front Door Premium SKU** is used as the global load balancer for reliably routing traffic to the regional deployments, which are exposed through private endpoints. 

> Refer to [Well-architected mission critical workloads: Global traffic routing](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#global-traffic-routing).

**Azure Cosmos DB for NoSQL** is still used to store state outside the compute cluster and has baseline configuration settings for reliability. Access is limited to authorized private endpoint connections.

> Refer to [Well-architected mission critical workloads: Globally distributed multi-write datastore](/azure/architecture/framework/mission-critical/mission-critical-data-platform#globally-distributed-multi-write-datastore).

**Azure Container Registry** is used to store all container images with geo-replication capabilities. Access is limited to authorized private endpoint connections.

> Refer to [Well-architected mission critical workloads: Container registry](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#container-registry).

### Regional resources

The regional resources are provisioned as part of a _deployment stamp_ to a single Azure region. They are short-lived to provide more resiliency, scale, and proximity to users. These resources share nothing with resources in another region. They can be independently removed or replicated to other regions. They, however, share [global resources](#global-resources) between each other. For more information, see [**Regional stamp resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources).

**Static website in an Azure Storage Account** hosts a single page application (SPA) that send requests to backend services. This component has the same configuration as the [baseline frontend](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#frontend). Access is limited to authorized private endpoint connections.

**Azure Virtual Networks** provide secure environments for running the workload and management operations. 

**Internal load balancer** is the application origin. Front Door uses this origin for establishing private and direct connectivity to the backend using Private Link. 

**Azure Kubernetes Service (AKS)** is the orchestrator for backend compute that runs an application and is stateless. The AKS cluster is deployed as a private cluster. So, the Kubernetes API server isn't exposed to the public internet. Access to the API server is limited to a private network. For more information, see the [Compute cluster](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#compute-cluster) article of this architecture.

> Refer to [Well-architected mission critical workloads: Container Orchestration and Kubernetes](/azure/architecture/framework/mission-critical/mission-critical-application-platform#container-orchestration-and-kubernetes).

**Azure Firewall** inspects and protects all egress traffic from the Azure Virtual Network resources.

**Azure Event Hubs** is used as the [message broker](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-message-broker). Access is limited to authorized private endpoint connections.

> Refer to [Well-architected mission critical workloads: Loosely coupled event-driven architecture](/azure/architecture/framework/mission-critical/mission-critical-application-design#loosely-coupled-event-driven-architecture).

**Azure Key Vault** is used as the [regional secret store](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-secret-store). Access is limited to authorized private endpoint connections.

> Refer to [Well-architected mission critical workloads: Data integrity protection](/azure/architecture/framework/mission-critical/mission-critical-security#data-integrity-protection).

### Deployment pipeline resources

Build and release pipelines for a mission critical application must be fully automated to guarantee a consistent way of deploying a validated stamp.  

**GitHub** is still used for source control as a highly available git-based platform.

**Azure Pipelines** is chosen to automate pipelines that are required for building, testing, and deploying a workload in preproduction _and_ production environments.

> Refer to [Well-architected mission critical workloads: DevOps processes](/azure/architecture/framework/mission-critical/mission-critical-operational-procedures#devops-processes).

**Self-hosted Azure DevOps build agent pools** are used to have more control over the builds and deployments. This level of autonomy is needed because the compute cluster and all PaaS resources are private, which requires a network level integration that is not possible on Microsoft-hosted build agents.

### Observability resources

Monitoring data for global resources and regional resources are stored independently. A single, centralized observability store isn't recommended to avoid a single point of failure. For more information, see [Observability resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#observability-resources).

- **Azure Log Analytics** is used as a unified sink to store logs and metrics for all application and infrastructure components.

- **Azure Application Insights** is used as an Application Performance Management (APM) tool to collect all application monitoring data and store it directly within Log Analytics.

> Refer to [Well-architected mission critical workloads: Predictive action and AI operations](/azure/architecture/framework/mission-critical/mission-critical-health-modeling#predictive-action-and-ai-operations-aiops).

### Management resources

A significant design change from the baseline architecture is the compute cluster. In this design the AKS cluster is private. This change requires extra resources to be provisioned to gain access.

**Azure Virtual Machine Scale Sets** for the private build agents and jump box instances to run tools against the cluster, such as kubectl.

**Azure Bastion** provides secure access to the jump box VMs and removes the need for the VMs to have public IPs.

## Private endpoints for PaaS services

To process business or deployment operations, the application and the build agents need to reach several Azure PaaS services that are provisioned globally, within the region, and even within the stamp. In the baseline architecture, that communication is over the services' public endpoints.

In this design, those services have been protected with private endpoints to remove them from public internet access. This approach reduces the overall attack surface area to mitigate direct service tampering from unexpected sources. However, it introduces another potential point of failure and increases complexity. Carefully consider the tradeoffs with security before adopting this approach.

Private endpoints should be put in a dedicated subnet of the stamp's virtual network. Private IP addresses to the private endpoints are assigned from that subnet. Essentially, any resource in the virtual network can communicate with the service by reaching the private IP address. Make sure the address space is large enough to accommodate all private endpoints necessary for that stamp.

To connect over a private endpoint, you need a DNS record. It's recommended that DNS records associated with the services are kept in Azure Private DNS zones serviced by Azure DNS. Make sure that the fully qualified domain name (FQDN) resolves to the private IP address.

:::image type="content" source="./images/mission-critical-private-endpoint-snet.png" alt-text="Diagram showing private endpoint subnet in the regional stamp virtual network." lightbox="./images/mission-critical-private-endpoint-snet.png":::

In this architecture, private endpoints have been configured for Azure Container Registry, Azure Cosmos DB, Key Vault, Storage resources, and Event Hubs. Also, the AKS cluster is deployed as a private cluster, which creates a private endpoint for the Kubernetes API service in the cluster's network.

There are two virtual networks provisioned in this design and both have dedicated subnets to hold private endpoints for all those services. The network layout is described in [Virtual network layout](#virtual-network-layout).

As you add more components to the architecture, consider adding more private endpoints. For example, you can add restrictions to the [observability resources](#observability-resources). Both Azure Log Analytics and Azure Application Insights support the use of private endpoints. For details, see [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security).

They can be created on the same or different subnets within the same virtual network. There are limits to the number of private endpoints you can create in a subscription. For more information, see [Azure limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits).

Control access to the services further by using [network security groups on the subnet](/azure/private-link/disable-private-endpoint-network-policy).

## Private ingress

Azure Front Door Premium SKU is used as the global entry point for all incoming client traffic. It uses Web Application Firewall (WAF) capabilities to allow or deny traffic at the network edge. The configured WAF rules prevent attacks even before they enter the stamp virtual networks.

This architecture also takes advantage of Front Door's capability to use Azure Private Link to access application origin without the use of public IPs/endpoints on the backends. This requires an internal load balancer in the stamp virtual network. This resource is in front of the Kubernetes Ingress Controller running in the cluster. On top of this private Load Balancer, a Private Link service is created by AKS, which is used for the private connection from Front Door.

After connection is established, Private endpoints on Front Door network have direct connectivity with the load balancer and static web site in the stamp network over Private Link.

For more information, see [How Private Link works](/azure/frontdoor/private-link#how-private-link-works).

:::image type="content" source="./images/network-diagram-ingress.png" alt-text="Diagram showing Private Link access from Front Door to application backend." lightbox="./images/network-diagram-ingress-highres.png":::

> Refer to [Well-architected mission critical workloads: Application delivery services](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#application-delivery-services).

## Restricted egress

Applications might require some outbound internet connectivity. Controlling that traffic provides a way to limit, monitor, and restrict egress traffic. Otherwise, unexpected inside-out access might lead to compromise and potentially an unreliable system state. Restricted egress can also solve for other security concerns, such as data exfiltration.

Using firewall and Network Security Groups (NSGs) can make sure that outbound traffic from the application is inspected and logged.

In this architecture, Azure Firewall is the single egress point and is used to inspect all outgoing traffic that originates from the virtual network. User-defined routes (UDRs) are used on subnets that are capable of generating egress traffic, such as the application subnet. 

:::image type="content" source="./images/mission-critical-secure-network-egress.svg" alt-text="Diagram showing Azure Firewall used to restrict egress traffic." lightbox="./images/mission-critical-secure-network-egress-highres.png":::

For information about restricting outbound traffic, see [Control egress traffic for cluster nodes in Azure Kubernetes Service (AKS)](/azure/aks/limit-egress-traffic).

## Virtual network layout

Isolate regional resources and management resources in separate virtual networks. They have distinct characteristics, purposes, and security considerations.

- **Type of traffic**: Regional resources, which participate in processing of business operations, need higher security controls. For example, the compute cluster must be protected from direct internet traffic. Management resources are provisioned only to access the regional resources for operations.

- **Lifetime**: The expected lifetimes of those resources are also different. Regional resources are expected to be short-lived (ephemeral). They are created as part of the deployment stamp and destroyed when the stamp is torn down. Management resources share the lifetime of the region and out live the stamp resources.

In this architecture, there are two virtual networks: stamp network and operations network. Create further isolation within each virtual network by using subnets and network security groups (NSGs) to secure communication between the subnets.

> Refer to [Well-architected mission critical workloads: Isolated virtual networks](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity#isolated-virtual-networks).

### Regional stamp virtual network

The deployment stamp provisions a virtual network in each region.

:::image type="content" source="./images/mission-critical-secure-network-ingress.svg" alt-text="Diagram showing secure global routing for a mission critical workload." lightbox="./images/mission-critical-secure-network-ingress-highres.png":::

The virtual network is divided into these main subnets. All subnets have Network Security Groups (NSGs) assigned to block any unauthorized access from the virtual network. NSGs will restrict traffic between the application subnet and other components in the network.

- **Application subnet**

    The AKS cluster node pools are isolated in a subnet. If you need to further isolate the system node pool from the worker node pool, you can place them in separate subnets.

- **Stamp ingress subnet**

    The entry point to each stamp is an internal Azure Standard Load Balancer that is placed in a dedicated subnet. The Private Link service used for the private connection from Front Door is also placed here.

    Both resources are provisioned as part of the stamp deployment.

- **Stamp egress subnet**

    Azure Firewall is placed in a separate subnet and inspects egress traffic from application subnet by using a user-defined route (UDR).

- **Private endpoints subnet**

    The application subnet will need to access the PaaS services in the regional stamp, Key Vault, and others. Also, access to global resources such as the container registry is needed. In this architecture, [all PaaS service are locked down](#private-endpoints-for-paas-services) and can only be reached through private endpoints. So, another subnet is created for those endpoints. Inbound access to this subnet is secured by NSG that only allows traffic from the application.

    You can add further restriction by using [UDR support for private endpoints](https://azure.microsoft.com/updates/public-preview-of-private-link-udr-support/), so that this traffic could also egress through the stamp egress subnet.

### Operations virtual network

The operational traffic is isolated in a separate virtual network. Because the AKS cluster's API service is private in this architecture, all deployment and operational traffic must also come from private resources such as self-hosted build agents and jump boxes. Those resources are deployed in a separate virtual network with direct connectivity to the application resources through their own set of private endpoints. The build agents and jump boxes are in separate subnets.

Instead of using private endpoints, an alternate approach is to use virtual network peering. However, peering adds complexity that can be hard to manage especially when virtual networks are designed to be ephemeral.

Both the build agents (and optionally jump boxes) need to access PaaS services that are located globally and within the regional stamp. Similar to the regional stamp virtual network, a dedicated subnet is created for the private endpoints to the necessary PaaS services. NSG on this subnet makes sure ingress traffic is allowed only from the management and deployment subnets.

:::image type="content" source="./images/mission-critical-ops.png" alt-text="Diagram showing the management network flow." lightbox="./images/mission-critical-ops.png":::

#### Management operations

A typical use case is when an operator needs to access the compute cluster to run management tools and commands. The API service in a private cluster  can't be accessed directly. That's why jump boxes are provisioned where the operator can run the tools. There's a separate subnet for the jump boxes.

But, those jump boxes need to be protected as well from unauthorized access. Direct access to jump boxes by opening RDP/SSH ports should be avoided. Azure Bastion is recommended for this purpose and requires a dedicated subnet in this virtual network.  

> [!CAUTION]
> Connectivity through Azure Bastion and jump boxes can have an impact on developer productivity, such as running debugging tools requires additional process. Be aware of these impacts before deciding to harden security for your mission-critical workload.

You can further restrict access to the jump box subnet by using an NSG that only allows inbound traffic from the Bastion subnet over SSH.

#### Deployment operations

To build deployment pipelines, you need to provision additional compute to run build agents. These resources won't directly impact the runtime availability of the workload but a reliability failure can jeopardize the ability to deploy or service your mission critical environment. So, reliability features should be extended to these resources.

This architecture uses Virtual Machine Scale Sets for both build agents and jump boxes (as opposed to single VMs). Also, network segmentation is provided through the use of subnets. Ingress is restricted to Azure DevOps.

## Cost considerations

There's a significant impact on cost for mission-critical workloads. In this architecture, technology choices such as using Azure Front Door Premium SKU and provisioning Azure Firewall in each stamp will lead to increased costs. There are also added costs related to maintenance and operational resources. Such tradeoffs must be carefully considered before adopting a network-controlled version of the baseline architecture.

## Deploy this architecture

The networking aspects of this architecture are implemented in the Mission-critical Connected implementation.

> [!div class="nextstepaction"]
> [Implementation: Mission-critical Connected](https://github.com/Azure/Mission-Critical-Connected)

> [!NOTE]
> The Connected implementation is intended to illustrate a mission-critical workload that relies on organizational resources, integrates with other workloads, and uses shared services. It builds on this architecture and uses the network controls described in this article. However, the Connected scenario assumes that virtual private network or Azure Private DNS Zone already exist within the Azure landing zones connectivity subscription.

## Next steps

For details on the design decisions made in this architecture, review the networking and connectivity design area for mission-critical workloads in Azure Well-architected Framework.

> [!div class="nextstepaction"]
> [Design area: Networking and connectivity](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity)

## Related resources

For product documentation on the Azure services used in this architecture, see these articles.

- [Azure Front Door](/azure/frontdoor/)
- [Azure Cosmos DB](/azure/cosmos-db/)
- [Azure Container Registry](/azure/container-registry/)
- [Azure Log Analytics](/azure/azure-monitor/)
- [Azure Key Vault](/azure/key-vault/)
- [Azure Service Bus](/azure/service-bus-messaging/)
- [Azure Kubernetes Service](/azure/aks/)
- [Azure Application Insights](/azure/azure-monitor/)
- [Azure Event Hubs](/azure/event-hubs/)
- [Azure Blob Storage](/azure/storage/blobs/)
- [Azure Firewall](/azure/firewall/overview)
