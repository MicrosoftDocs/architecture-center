This reference architecture provides guidance for a mission critical workload in a hub-spoke network topology. The workload resources are deployed in a spoke virtual network. The hub network has shared resources that can be used by one or more workloads. In this topology, there are some options in terms of levels of responsibilities.

- **Centralized approach**

    The hub-spoke topology is a common approach for organizations to manage a shared platform through centralized teams. Suppose, an organization adopts the use of _landing zones_ for deploying applications. It provides a pre-provisioned subscription that has the infrastructure needed to run the workload. It has networking, identity access management, policies, and monitoring capabilities. For the networking components, the workload assumes that the virtual private networks (both hub and spoke), Azure Private DNS Zone, ExpressRoute circuit, and other shared services, already exist within the connectivity subscription provided by the landing zone. A key benefit is that the workload doesn't have to manage those resources. Without additional overhead, the workload can rely on centralized teams, integrate with other workloads (if needed), and use shared services. However, the workload must be designed to operate within the restrictions imposed by the subscription. For example, you might have to implement the regional deployment stamp such that the resources are still ephemeral but the virtual network isn't.

    In this approach, **the landing zone itself needs to be highly reliable for a mission critical workload to operate as expected.** The reliability tier of the platform and the workload must be aligned. The workload team must have a trusted relationship with the platform team so that unavailability issues in the foundational services, which  affect the workload, are mitigated at the platform level. 

- **Autonomous approach**

    Alternatively, the entire infrastructure can be federated as part of the workload.  <TO DO: Add massive details here> 
    
    The workload team is responsible for all shared services deployed in the regional hub network. They also add identity and governance policies as per the workload's needs. The goal is to maximize reliability by removing external (and,or centralized) dependencies so that end-to-end workload flows aren't disrupted. The common areas include observability, deployment, and even networking choices. For example, the implementation can choose to make the network ephemeral along with regional stamp resources, or not.

    However, expect added complexity and management overhead.

This architecture shows a hybrid approach. It leans on being automonous while adhering to some aspects of a landing zone. It builds on the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml), which is designed to restrict both ingress and egress traffic from the same virtual network. However in this architecture, egress restrictions are provided through the hub network. Like other mission-critical architecture designs, cloud-native capabilities are used to maximize reliability and operational effectiveness of the workload.

> [!NOTE]
> You can also build on the **[mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)** where the workload is accessed over a public endpoint.

It's recommended that you become familiar with the **baseline architecture** before proceeding with this article.

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Architecture

![Architecture diagram of a mission-critical workload in a hub-spoke topology.](./images/mission-critical-architecture-hub-spoke.svg)

The components of this architecture can be broadly categorized in this manner. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

The global resources are long living and share the lifetime of the system. These resource remain the same as the baseline architecture. Here's a brief summary: 

- **Azure Front Door Premium SKU** is used as the global load balancer for reliably routing traffic to the regional deployments, which are exposed through private endpoints. 

- **Azure Cosmos DB with SQL API** is still used to store state outside the compute cluster and has baseline configuration settings for reliability. Access is limited to authorized private endpoint connections.

- **Azure Container Registry** is used to store all container images with geo-replication capabilities. Access is limited to authorized private endpoint connections.

For more information, see [**Global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

### Regional resources

The regional resources are provisioned as part of a _deployment stamp_ to a single Azure region. They are short-lived to provide more resiliency, scale, and proximity to users. These resources share nothing with resources in another region. They can be independently removed or replicated to other regions. They, however, share [global resources](#global-resources) between each other. For more information, see [**Regional stamp resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources).

In this architecture, the resources are provisioned in a peered hub and spoke networks.

#### Regional hub resources

- **Azure Virtual Network** provide a shared environment that contains services used by the workload to connect with organizational resources, other workloads, and on-premises network. 

- **Azure Firewall** inspects and protects all egress traffic from the Azure Virtual Network resources.

- **On-premises gateway** enables the virtual network to connect to on-premises network through a VPN device or ExpressRoute circuit. 

#### Regional spoke resources

**Static website in an Azure Storage Account** hosts a single page application (SPA) that send requests to backend services. This component has the same configuration as the [baseline frontend](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#frontend). Access is limited to authorized private endpoint connections.

**Internal load balancer** is the application origin. Front Door uses this origin for establishing private and direct connectivity to the backend using Private Link. 

**Azure Kubernetes Service (AKS)** is the orchestrator for backend compute that runs an application and is stateless. The AKS cluster is deployed as a private cluster. So, the Kubernetes API server isn't exposed to the public internet. Access to the API server is limited to a private network. For more information, see the [Compute cluster](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#compute-cluster) article of this architecture.

> Refer to [Well-architected mission critical workloads: Container Orchestration and Kubernetes](/azure/architecture/framework/mission-critical/mission-critical-application-platform#container-orchestration-and-kubernetes).

**Azure Event Hubs** is used as the [message broker](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-message-broker). Access is limited to authorized private endpoint connections.

> Refer to [Well-architected mission critical workloads: Loosely coupled event-driven architecture](/azure/architecture/framework/mission-critical/mission-critical-application-design#loosely-coupled-event-driven-architecture).

**Azure Key Vault** is used as the [regional secret store](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-secret-store). Access is limited to authorized private endpoint connections.

> Refer to [Well-architected mission critical workloads: Data integrity protection](/azure/architecture/framework/mission-critical/mission-critical-security#data-integrity-protection).

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
