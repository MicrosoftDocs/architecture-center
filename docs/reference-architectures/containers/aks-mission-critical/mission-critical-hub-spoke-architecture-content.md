This reference architecture provides guidance for deploying a mission critical workload that uses centralized shared services and integrates with other workloads of an enterprise. As a workload owner, you might find yourself in this situation if there's a need to deploy the workload in an _application Azure landing zone_ provided by your organization. In this case, the organization will also provide _platform Azure landing zones_ with pre-provisioned shared resources that are managed by centralized teams.

> [IMPORTANT]
> An application landing zone is a pre-provisioned subscription that's connected to the organization's shared resources. It has basic infrastructure needed to run the workload, such as networking, identity access management, policies, and monitoring capabilities. Platform landing zones is a collection of various subscriptions each with specific functionality. For example, the connectivity subscription contains Azure Private DNS Zone, ExpressRoute circuit, Firewall in a virtual network that's available for application teams to use. 
>
> A key benefit is that the application team can offload management of shared reources to central teams, and can focus on development efforts. The organization benefits by applying consistent governance and optimizing on cost of reusing resources for multiple application teams. 
> 
> If you aren't familiar with the concept of landing zones, we highly recommend you start with [What is an Azure landing zone?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)


In this approach, **the centrally managed components need to be highly reliable for a mission critical workload to operate as expected.** The reliability tier of the platform and the workload must be aligned. The workload team must have a trusted relationship with the platform team so that unavailability issues in the foundational services, which  affect the workload, are mitigated at the platform level. 

It builds on the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml), which is designed to restrict both ingress and egress traffic from the same virtual network. However in this architecture, egress is assumed through the shared hub network in the connectivity subscription. It's recommended that you become familiar with the **baseline architecture** before proceeding with this article.

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Key design strategies

- **Autonomous observability**

    Even though the platform provides a management subscription for the purposes of centralized observability, application team will be responsible for provisioning dedicated monitoring resources for the workload. This decision enables the team to query their data collection quickly in case of issues. <!--TODO justification needs to be written better> 

- **Multiple deployment environments**

    - One application landing zone subscription as the production enviroment that contains only team-managed resources that are used to run, deploy, maintain, and monitor the application in production, across all regions. 
    - One application landing zone subscription as pre-production environment to contain deployments that fully reflect production. Multiple independent deployments may exist in this subscription, such as staging and integration.
    - One application landing zone subscription that contains all development environments. The environments are short-lived while the subscription isn't 


- <!--TODO keep adding as you write it>

## Architecture

![Architecture diagram of a mission-critical workload in a hub-spoke topology.](./images/mission-critical-architecture-hub-spoke.svg)

It builds on the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml), which is designed to restrict both ingress and egress traffic from the same virtual network. However in this architecture, egress restrictions are provided through the hub network. Like other mission-critical architecture designs, cloud-native capabilities are used to maximize reliability and operational effectiveness of the workload.

The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

The global resources are long living and share the lifetime of the system. These resources remain the same as the baseline architecture. Here's a brief summary: 

- **Azure Front Door Premium SKU** is used as the global load balancer for reliably routing traffic to the regional deployments, which are exposed through private endpoints. 

- **Azure Cosmos DB with SQL API** is still used to store state outside the compute cluster and has baseline configuration settings for reliability. Access is limited to authorized private endpoint connections.

- **Azure Container Registry** is used to store all container images with geo-replication capabilities. Access is limited to authorized private endpoint connections.

For more information, see [**Global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

### Regional resources

In this architecture, the resources are provisioned in a peered hub and spoke networks.

#### Regional hub resources

- **Azure Virtual Network** provide a shared environment that contains services used by the workload to connect with organizational resources, other workloads, and on-premises network. The regional hub network isn't short-lived.

- **Azure Firewall** inspects and protects all egress traffic from the Azure Virtual Network resources.

- **On-premises gateway** enables the virtual network to connect to on-premises network through a VPN device or ExpressRoute circuit. 

#### Regional spoke resources

These resources are provisioned as part of a _deployment stamp_ to a single Azure region. They're short-lived to provide more resiliency, scale, and proximity to users. These resources share nothing with resources in another region. They, however, share [global resources](#global-resources) between each other. 

- **Azure Virtual Network** contains services used by the workload for processing incoming requests. This network isn't short-lived. In a centralized approach, this network is pre-provisioned by the platform team as part of landing zone. It has address space and peering in place. It doesn't have subnets. The application team is responsible for deploying the subnets and their settings. 

- **Static website in an Azure Storage Account** hosts a single page application (SPA) that send requests to backend services. This component has the same configuration as the [baseline frontend](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#frontend). Access is limited to authorized private endpoint connections.

- **Internal load balancer** is the application origin. Front Door uses this origin for establishing private and direct connectivity to the backend using Private Link. 

- **Azure Kubernetes Service (AKS)** is the orchestrator for [backend compute](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#compute-cluster) that runs an application and is stateless. The AKS cluster is private. 

- **Azure Event Hubs** is used as the [message broker](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-message-broker). Access is limited to authorized private endpoint connections.

- **Azure Key Vault** is used as the [regional secret store](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-secret-store). Access is limited to authorized private endpoint connections.

For more information, see [**Regional stamp resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources).

## Deployment pipeline resources

Build and release pipelines for a mission critical application must be fully automated to guarantee a consistent way of deploying a validated stamp. These resources remain the same as the [baseline deployment pipeline](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#deployment-pipeline-resources).

## Observability resources

Monitoring data for global resources and regional resources are stored independently. A single, centralized observability store isn't recommended to avoid a single point of failure. These resources remain the same as the [baseline monitoring resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#observability-resources).

## Management resources
To gain access to the private compute cluster, this architecture uses private build agents and jump box virtual machine instances. Azure Bastion provides secure access to the jump box VMs. These resources remain the same as the [baseline management resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#management-resources).

## Subscription democratization

TO DO:

How are the subscriptions tied to regions. Does every region run in a separate subscription? If there are 2 regions, there are 4 vnets. Do i have 4, 2, 1 sub. 

## Networking considerations

In the baseline architecture, each stamp has a virtual network with a dedicated subnet for the compute cluster and another subnet to hold the private endpoints of different services. While that layout doesn't change in this design, the workload assumes that the virtual network is pre-provisioned, and the workload resources are placed there. 

For a mission critical workload, multiple environments are recommended. If all those environments need connectivity, you'll need other pre-provisioned networks per environment. In this architecture, at least two virtual networks per environment and region are needed to support the blue-green deployment strategy. 

The scalability requirements of the workload influence how much address space should be allocated for the virtual network. The network should be large enough to accommodate the AKS nodes and pods as they scale out. Load test the workload components to determine the maximum scalability limit. Factor in all the system and user nodes and their limits. If you want to scale out by 400%, you'll need four times the addresses for the scaled-out nodes. This strategy applies to individual pods if they're reachable because each pod needs an individual address. 

The reference implementation is currently configured to require at least one virtual network with a `/23` address space for each stamp. This is to allow for a `/24` subnet for AKS nodes and their pods. 


## Overall reliability
TBD

## Tradeoffs
TBD

## Shift in responsibility
TBD

## Deploy this architecture

The networking aspects of this architecture are implemented in the Mission-critical Connected implementation.

> [!div class="nextstepaction"]
> [Implementation: Mission-critical Connected](https://github.com/Azure/Mission-Critical-Connected)

> [!NOTE]
> The Connected implementation is intended to illustrate a mission-critical workload that relies on organizational resources, integrates with other workloads, and uses shared services. It builds on this reference architecture and uses the network controls described in this article. However, the Connected scenario assumes that virtual private network or Azure Private DNS Zone already exist within the Azure landing zones connectivity subscription.

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
- [Azure Firewall](/azure/storage/firewall/)
