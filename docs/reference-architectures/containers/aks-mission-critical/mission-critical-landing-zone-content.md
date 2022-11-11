This reference architecture provides guidance for deploying a mission critical workload that uses centralized shared services and integrates with other workloads of an enterprise. As a workload owner, you might find yourself in this situation if there's a need to deploy the workload in an _application Azure landing zone_ provided by your organization. In this case, the organization will also provide _platform Azure landing zones_ with pre-provisioned shared resources that are managed by centralized teams.

In this approach, **the centrally managed components need to be highly reliable for a mission critical workload to operate as expected.** The reliability tier of the platform and the workload must be aligned. The workload team must have a trusted relationship with the platform team so that unavailability issues in the foundational services, which  affect the workload, are mitigated at the platform level. 

> [!IMPORTANT]
> An application landing zone is a pre-provisioned subscription that's connected to the organization's shared resources. It has access to basic infrastructure needed to run the workload, such as networking, identity access management, policies, and monitoring capabilities. Platform landing zones is a collection of various subscriptions each with specific functionality. For example, the connectivity subscription contains Azure Private DNS Zone, ExpressRoute circuit, Firewall in a virtual network that's available for application teams to use. 
>
> A key benefit for the application team is that they can offload management of shared reources to central teams, and  focus on development efforts. The organization benefits by applying consistent governance and optimizing on cost of reusing resources for multiple application teams. 
> 
> If you aren't familiar with the concept of landing zones, we highly recommend you start with [What is an Azure landing zone?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)


This architecture builds on the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml). It's recommended that you become familiar with the **baseline architecture** before proceeding with this article. 

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Key design strategies

- **Autonomous observability**

    Even though the platform provides a management subscription for the purposes of centralized observability, application teams will be responsible for provisioning dedicated monitoring resources for the workload. This decision enables the team to query their data collection quickly in case of issues. TODO justification needs to be written better 

- **Multiple deployment environments**

    - One application landing zone subscription as the production environment that contains only team-managed resources that are used to run, deploy, maintain, and monitor the application in production, across all regions. 
    - One application landing zone subscription as a pre-production environment to contain deployments that fully reflect production. Multiple independent deployments may exist in this subscription, such as staging and integration.
    - One application landing zone subscription that contains all development environments. The environments are short-lived while the subscription isn't 


- TODO:  keep adding as you see interesting things

## Architecture

![Architecture diagram of a mission-critical workload in an Azure landing zone.](./images/mission-critical-architecture-hub-spoke.svg)

The components of this architecture are same as the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml). The descriptions are short for brevity. If you need more information, see the linked articles. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

The global resources are long living and share the lifetime of the system. These resources remain the same as the baseline architecture. Here's a brief summary: 

- **Azure Front Door Premium SKU** is used as the global load balancer for reliably routing traffic to the regional deployments, which are exposed through private endpoints. 

- **Azure Cosmos DB with SQL API** is still used to store state outside the compute cluster and has baseline configuration settings for reliability. Access is limited to authorized private endpoint connections.

- **Azure Container Registry** is used to store all container images with geo-replication capabilities. Access is limited to authorized private endpoint connections.

> For more information, see [**Global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

### Regional monitoring resources

Monitoring data for global resources and regional resources are stored independently. A single, centralized observability store isn't recommended because TODO: write a believable justification. These resources remain the same as the baseline architecture.
> For more information, see [baseline monitoring resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#observability-resources).

### Regional networking resources

The networking resources are provisioned in the connectivity subscription of the platform landing zone. It has virtual networking peering with the regional stamp network.

The **baseline architecture** is designed to restrict both ingress and egress traffic from the same virtual network. However in this architecture, egress restrictions are provided through the connectivity subscription. 

The workload takes dependency on these resources and are assumed to be pre-provisioned in the connectivity subscription.

- **Azure Virtual Network** provide a shared environment that contains services used by the workload to connect with organizational resources, other workloads, and on-premises network. The regional hub network isn't short-lived.

- **Azure Firewall** inspects and protects all egress traffic from the Azure Virtual Network resources.

- **On-premises gateway** enables the virtual network to connect to on-premises network through a VPN device or ExpressRoute circuit. 

### Regional stamp resources

These resources live in an application landing zone subscription that is provisioned by the platform team. The resources are part of a _deployment stamp_ and intended to be ephemeral (short-lived) to provide more resiliency, scale, and proximity to users. These resources share nothing with resources in another region. They, however, share [global resources](#global-resources) between each other. 

- **Azure Virtual Network** is pre-provisioned in the landing zone subscription. It's the only part of stamp that is _not_ ephemeral. The workload deloyment references the network and provisions the resources in subnets defined by the application team. 

- **Static website in an Azure Storage Account** hosts a single page application (SPA) that send requests to backend services. This component has the same configuration as the [baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#frontend). Access is limited to authorized private endpoint connections.

- **Internal load balancer** is the application origin. Front Door uses this origin for establishing private and direct connectivity to the backend using Private Link. 

- **Azure Kubernetes Service (AKS)** is the orchestrator for [backend compute](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#compute-cluster) that runs an application and is stateless. The AKS cluster is private. 

- **Azure Event Hubs** is used as the [message broker](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-message-broker). Access is limited to authorized private endpoint connections.

- **Azure Key Vault** is used as the [regional secret store](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#regional-secret-store). Access is limited to authorized private endpoint connections.

For more information, see [**Regional stamp resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources).

## Deployment pipeline resources

Build and release pipelines for a mission critical application must be fully automated to guarantee a consistent way of deploying a validated stamp. These resources remain the same as the [baseline deployment pipeline](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#deployment-pipeline-resources).

## Management resources
To gain access to the private compute cluster, this architecture uses private build agents and jump box virtual machine (VM) instances. Azure Bastion provides secure access to the jump box VMs. These resources remain the same as the [baseline management resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#management-resources).



## Deployment considerations

TODO: write intro later

### Subscription topology for deployment environments

The application (and new features) must be tested thoroughly as part of the application lifecycle before releasing to  production. Here are some key points.

- **Isolation**. It's a common practice to place workloads in separate environments for development, pre-production, and production. The production environment _must_ be isolated from other environments. Lower environments should also  maintain a level of isolation. 
- **Lifecycle**. Environments have different lifecycle requirements. Some are long standing while others are ephemeral (short-lived), which can be created and destroyed as needed through continuous integration/continuous deployment (CI/CD) automation.

Using subscriptions as a way to contain the environments can achieve the required level of isolation. The subscriptions themselves are usually not ephemeral while the deployments within them can be.

All application landing zone subscriptions inherit the same governance from the organization's management groups. That way, consistency with production is ensured, in terms of testing and validation. However, subscription topology can become complex. Depending on the number of environments, you'll need several subscriptions for just one workload. Depending on the type of environment, some enviroments might need dedicated subscriptions while other environments might be consolidated into one subscription.

Regardless, the application landing zone subscription must be provisioned by your platform team. Work with them to design the topology so that the overall reliability target for the workload is met. Consider the tradeoffs between isolation of environments, complexity of management, and cost optimization. Avoid usage of shared resources between environments, even when environments are colocated in the same subscription.

**Production**

One production environment is required for global, regional, and stamp resources owned by the application team. These resources will run, deploy, maintain, and monitor the application, across all regions. Factor in resources needed for production runtime _and_ the side-by-side zero-downtime deployments. In addition, there are build agents, Azure Bastion, and jump boxes needed for management.

There might be resource limits defined on the subscription given to you as part of the application landing zone.
If you colocate all those resources in one subscription, you may reach those limits. Based on your scale units and expected scale, consider a more distributed model. For example,
- One application landing zone subscription that contains both Azure DevOps build agents and global resources.
- One application landing zone subscription, per region, that would contain the regional, stamp, and jump box resources for that region’s stamp(s).

Here's an example subscription topology used in this architecture.

![Diagram of an example subscription layout for a mission-critical workload in an Azure landing zone.](./images/connected-subscription.png)

**Pre-production**

Pre-production environments, such as staging and integration, are needed to make sure the application is tested in an environment that simulates production, as much as possible. These environments are short-lived and should be destroyed after validation tests are completed. 

At least one Azure landing zone subscription is required. It can run many independent environments, however, having multiple environments in dedicated subscriptions is recommended. Of course, this subscription may also be subject to resource limits like the production subscription, described above.

**Development**

Development must be done in completely separate environment. It's recommended that development enviroments are short-lived. The enviroment should share the lifetime of a feature.  For instance, you can create a new development environment tied to the feature branch and destroy it when the feaure is merged with an upstream branch. Consider using automated pipelines for that purpose.

Multiple features should be simultaneously developed in multiple dedicated environments. Shared environments for parallel feature development should be avoided as they can cause bugs to leak into production environment. 

At least, one Azure landing zone subscription is recommended for consolidating these environments. This environment should be a scaled down version of production, containing all relevant Azure resources and components used by the application. While subscription that has production-like rigor is ideal, for development, a subscription with fewer constraints, governance, and capabilities can be considered. This deviation is to support the flexibility needed for activities such as exploratory development, v-next feature resource usage and configuration, advanced debugging techniques, and so on. That subscription should still be provided by your platform team. Work with your platform team to place the subscription under a suitable management group hierarchy to achieve this outcome. 

### Zero-downtime deployment

The Azure Well-Architected mission-critical methodology requires a zero-downtime deployment approach. 

TODO: write a better intro

#### Ephemeral resources

One way to acheive this goal is to enforce consistency by deploying entire new infrastructure (global, regional, stamp resource) every time there's a change to the code is deployed.

In this architecture, that approach changes. Only the resources owned by the application team are deployed every time. The deployment must take into consideration how to work with resources that cannot be destroyed and are owned by the platform team.

In the application landing zone, the stamp resources are ephemeral and owned by the application team. But, the given pre-peered virtual network isn't. The deployment stamp is responsible for allocating subnet(s) in the provided IP address space, applying network security groups, and connecting the Azure resources to those subnets. The stamp isn't allowed to create the virtual network or its peering to the regional hub. 

The networking section explores the preceding case in detail.

#### DINE (deploy-if-not-exists) Azure policies

Azure landing zones use DINE (deploy-if-not-exists) Azure policies to manipulate deployed resources in application landing zones. 

Evaluate the impact of all DINE policies that will be applied to your resources, early in the workload’s development cycle. If you need make to changes, incorporate them into your declarative deployments. Otherwise, there might be a mismatch between what you deployed and the final resource configuration. Don't fix post-deployment discrepencies through imperative approaches as they can impact reliability.  

#### Canary deployments

Typically, the fundamental change in this architecture over the prior reference architectures will be surfaced in the networking components; Azure DNS, virtual networks, network peering, etc. which will require integration in your deployment. We’ll focus on the virtual network to illustrate. Instead of your deployment stamp creating the virtual network (treating host networks as ephemeral), you can assume that your workload Azure landing zone will have at least two virtual networks pre-provisioned, per region. This gives you the ability to still perform canary deployments for reliable and safe deployment practices (including the option to rollback), by targeting one network for your vNext deployment, while the other serves production traffic. Your deployment pipeline will be responsible for shaping the target virtual network’s subnets, deploying resources connected to it and private endpoints into it, and then shifting traffic to that subnet as per the prior reference architectures.
When the prior deployment stamp is no longer required, all stamp resources are deleted by your pipelines, except the pre-provisioned network, making it ready to be the eventual vNext target. Ideally, you’d de-provision/delete as much as practical, which would even include deleting subnets inside the virtual network to get back to a fully “factory reset” state, as subnets would be considered part of the stamp, ready for that next deployment.




TO DO:

How are the subscriptions tied to regions. Does every region run in a separate subscription? If there are 2 regions, there are 4 vnets. Do i have 4, 2, 1 sub. 


--------------STOP HERE---------------------------


## DUMP ZONE


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
