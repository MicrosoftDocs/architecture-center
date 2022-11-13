This reference architecture provides guidance for deploying a mission critical workload that uses centralized shared services and integrates with other workloads of an enterprise. As a workload owner, you might find yourself in this situation if there's a need to deploy the workload in an _application Azure landing zone_ provided by your organization. In this case, the organization will also provide _platform Azure landing zones_ with pre-provisioned shared resources that are managed by centralized teams.

In this approach, **the centrally managed components need to be highly reliable for a mission critical workload to operate as expected.** The reliability tier of the platform and the workload must be aligned. The workload team must have a trusted relationship with the platform team so that unavailability issues in the foundational services, which  affect the workload, are mitigated at the platform level. 

> [!IMPORTANT]
> An application landing zone is a pre-provisioned subscription that's connected to the organization's shared resources. It has access to basic infrastructure needed to run the workload, such as networking, identity access management, policies, and monitoring capabilities. Platform landing zones is a collection of various subscriptions each with specific functionality. For example, the connectivity subscription contains Azure Private DNS Zone, ExpressRoute circuit, Firewall in a virtual network that's available for application teams to use. 
>
> A key benefit for the application team is that they can offload management of shared reources to central teams, and  focus on development efforts. The organization benefits by applying consistent governance and optimizing on cost of reusing resources for multiple application teams. 
> 
> If you aren't familiar with the concept of landing zones, we highly recommend you start with [What is an Azure landing zone?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)


This architecture builds on the [**mission-critical **baseline architecture** with network controls**](./mission-critical-network-architecture.yml). It's recommended that you become familiar with the **baseline architecture** before proceeding with this article. 

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Key design strategies
The design strategies for mission-critical baseline still apply in this use case. Here are the considerations for this architecture:


- **Autonomous observability**

    Even though the platform provides a management subscription for the purposes of centralized observability, application teams will be responsible for provisioning dedicated monitoring resources for the workload. This decision enables the team to query their data collection quickly.  

- **Isolation**
Using subscriptions to contain the environments can achieve the required level of isolation. The subscriptions themselves are usually not ephemeral while the deployments within them can be.
- **Multiple deployment environments**



    - One application landing zone subscription as the production environment that contains only team-managed resources that are used to run, deploy, maintain, and monitor the application in production, across all regions. 
    - One application landing zone subscription as a pre-production environment to contain deployments that fully reflect production. Multiple independent deployments may exist in this subscription, such as staging and integration.
    - One application landing zone subscription that contains all development environments. The environments are short-lived while the subscription isn't 

- Zero-downtime deployments with non-ephemeral resources

- TODO:  keep adding as you see interesting things

## Architecture

![Architecture diagram of a mission-critical workload in an Azure landing zone.](./images/mission-critical-architecture-hub-spoke.svg)

The components of this architecture are same as the [**mission-critical baseline architecture** with network controls**](./mission-critical-network-architecture.yml). The descriptions are short for brevity. If you need more information, see the linked articles. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

The global resources are long living and share the lifetime of the system. The Azure services and their configuration remain the same as the **baseline architecture**.

> For more information, see [**Global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

### Regional monitoring resources

Monitoring data for global resources and regional resources are stored independently. A single, centralized observability store isn't recommended because it can potentially be a single point of failure. The Azure services and their configuration remain the same as the **baseline architecture**.

> For more information, see [baseline monitoring resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#observability-resources).

### Regional networking resources

The **baseline architecture** deploys resources owned by the application team. However in this architecture, networking resources are provided through the connectivity subscription provisioned as part of the platform landing zone. It has virtual networking peering with the regional stamp network.

The stamp depends on these platform-owned resources. **Azure Virtual Network** provides a shared environment, **Azure Firewall** inspects all egress traffic, and **On-premises gateway** connects to on-premises network through a VPN device or ExpressRoute circuit. 
> For more information, see [Connectivity subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology).

### Regional stamp resources

These resources live in an application landing zone subscription that is provisioned by the platform team. The resources are part of a _deployment stamp_ and intended to be ephemeral (short-lived) to provide more resiliency, scale, and proximity to users. These resources share nothing with resources in another region. They, however, share [global resources](#global-resources) between each other. 

**Azure Virtual Network** is pre-provisioned in the landing zone subscription. It's the only part of stamp that is _not_ ephemeral. The workload deployment references the network and provisions the resources in subnets defined by the application team. 

Other Azure services and their configuration remain the same as the **baseline architecture**.

> For more information, see [**Regional stamp resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources).

### Deployment pipeline resources

Build and release pipelines for a mission critical application must be fully automated to guarantee a consistent way of deploying a validated stamp. These resources remain the same as the **baseline architecture**. However, there are [deployment considerations](#deployment-considerations) unique to this architecture. 

> For more information, see [Deployment pipeline](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#deployment-pipeline-resources).

### Management resources
To gain access to the private compute cluster, this architecture uses private build agents and jump box virtual machine (VM) instances. Azure Bastion provides secure access to the jump box VMs. These resources remain the same as the **baseline architecture**.

> For more information, see [Management resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#management-resources).

## Monitoring considerations



## Deployment considerations

Failed deployments or erroneous releases are common causes for application outages. Here are some points to consider so that the application (and new features) is tested thoroughly as part of the application lifecycle. When deploying the workload in a landing zone, you'll need to integrate your design with the platform-provided resources and governance. 

### Deployment environments

- **How is isolation maintained?** It's a general practice to place workloads in separate environments for development, pre-production, and production. The production environment _must_ be isolated from other environments. Lower environments should also  maintain a level of isolation. 

- **What is the expected lifecycle?** Environments have different lifecycle requirements. Some are long standing while others are ephemeral (short-lived), which can be created and destroyed as needed through continuous integration/continuous deployment (CI/CD) automation.

- **What are the tradeoffs?** Consider the tradeoffs between isolation of environments, complexity of management, and cost optimization.

##### Production environment

One production environment is required for global, regional, and stamp resources owned by the application team. These resources will run, deploy, maintain, and monitor the application, across all regions. Factor in resources needed for production runtime _and_ the side-by-side zero-downtime deployments. In addition, there are build agents, Azure Bastion, and jump boxes needed for management.

##### Pre-production environment

Pre-production environments, such as staging and integration, are needed to make sure the application is tested in an environment that simulates production, as much as possible. These environments are short-lived and should be destroyed after validation tests are completed. 

##### Development environment

Development must be done in separate environment. This environment should be a scaled down version of production, containing all relevant Azure resources and components used by the application. It's recommended that development environments are short-lived. The environment should share the lifetime of a feature. For instance, you can create a new development environment tied to the feature branch and destroy it when the feature is merged with an upstream branch. Consider using automated pipelines for that purpose.

Multiple features should be simultaneously developed in multiple dedicated environments. Shared environments for parallel feature development should be avoided as they can cause bugs to leak into production environment. 

### Subscription topology for workload infrastructure

Using subscriptions to contain the environments can achieve the required level of isolation. Typically, the subscriptions aren't ephemeral but the deployments within them can be. The application landing zone subscription is provisioned by your platform team.

All application landing zone subscriptions inherit the same governance from the organization's management groups. That way, consistency with production is ensured for testing and validation. However, subscription topologies can become complex. Depending on the number of environments, you'll need several subscriptions for just one workload. Depending on the type of environment, some environments might need dedicated subscriptions while other environments might be consolidated into one subscription.

Regardless, work with the platform team to design a topology that meets the overall reliability target for the workload.  Avoid using shared resources between environments, even when environments are colocated in the same subscription.

##### Production subscription

There might be resource limits defined on the subscription given to you as part of the application landing zone.
If you colocate all those resources in one subscription, you may reach those limits. Based on your scale units and expected scale, consider a more distributed model. For example,
- One application landing zone subscription that contains both Azure DevOps build agents and global resources.
- One application landing zone subscription, per region. It contains the regional, stamp, and jump boxes for the regional stamp(s).

Here's an example subscription topology used in this architecture.

![Diagram of an example subscription layout for a mission-critical workload in an Azure landing zone.](./images/connected-subscription.png)

##### Pre-production subscription

At least one Azure landing zone subscription is required. It can run many independent environments, however, having multiple environments in dedicated subscriptions is recommended. This subscription may also be subject to resource limits like the production subscription, described above.

##### Development subscription

At least, one Azure landing zone subscription is recommended for consolidating these environments.  While a subscription that has production-like rigor is ideal, for development, a subscription with fewer constraints, governance, and capabilities can be considered. This deviation is to support the flexibility needed for activities such as exploratory development, v-next feature resource usage and configuration, advanced debugging techniques, and so on. That subscription should still be provided by your platform team. Work with your platform team to place the subscription under a suitable management group hierarchy to achieve this outcome. 

### Deployment infrastructure

Reliability of the deployment infrastructure, such as build agents and their network, is as important as the runtime resources of the workload. 

This architecture uses private build agents to prevent unauthorized access that can impact the application's availability. 

Maintaining isolation between deployment resources is highly recommended. Don't share resources between your production Azure landing zone and pre-production instances. A deployment infrastructure should be bound to your application landing zone subscription. If you're using multiple environments, then create further separation by limiting access to only those individual environments. Per-region deployment resources could be considered to make the deployment more reliable.

### Zero-downtime deployment

A mission-critical workload must not experience outage caused by updates to the application. Consistent deployments must be enforced with each update. These approaches are recommended:
- Fully automated deployment pipelines
- New deployments must start from a _factory reset_ state. You'll need to tear down existing deployment and create infrastructure resources (global, regional, and stamp) every time there's a change to the code is deployed.

In the baseline architecture, those strategies can be implemented as the application team has full autonomy of the workload resources. They can be created and destroyed in every deployment. In this architecture, the platform team owns some of those resources, applies policies. So, there are some areas where you might need to adjust your approach.

#### Non-ephemeral resources

In the application landing zone, the stamp resources are ephemeral and owned by the application team. But, the given pre-peered virtual network isn't. The deployment stamp allocates subnet(s) in the provided IP address space, applies network security groups, and connects the Azure resources to those subnets. The stamp isn't allowed to create the virtual network or peering to the regional hub. 

You'll need to reuse the non-ephemeral resources in each deployment. The strategy is illustrated for networking resources in the next section.

#### Deployment model

The **baseline architecture** uses Blue-Green model to deploy application updates. New stamps with changes are deployed alongside existing stamps. After traffic is moved to the new stamp, the existing stamp is destroyed. 

In this architecture, the existing stamp can't be destroyed because platform-owned resources aren't ephemeral. For example, networking components, such as Azure DNS, virtual networks, network peering, and so on. The workload assumes at least two virtual networks pre-provisioned, per region, in the application landing zone. 

In this case, the Canary model can achieve reliable and safe deployment with the option to roll back. First, a new stamp is deployed with code changes. The deployment pipeline references the pre-provisioned virtual network and allocates subnets, deploys resources, adds private endpoints. Then, it shifts traffic to the new subnets.

When the existing stamp is no longer required, all stamp resources are deleted by the pipeline, except the pre-provisioned network. It will take the stamp to a factory reset state, and is used for the next new deployment.


#### DINE (deploy-if-not-exists) Azure policies

Azure landing zones use DINE (deploy-if-not-exists) Azure policies to manipulate deployed resources in application landing zones, even when they're owned by the application team. There might be a mismatch between your deployment and the final resource configuration.

Evaluate the impact of all DINE policies that will be applied to your resources, early in the workload’s development cycle. If you need make to changes, incorporate them into your declarative deployments. Don't fix post-deployment discrepancies through imperative approaches as they can impact the overall reliability.  

#### Deployment identity and access management

As part of the application landing zone subscription, the platform team should give you a deployment service principal. It has permissions scoped to the resources within that subscription. 

If you're running multiple deployments within a subscription, you would be given one service principal per environment. Having separate service principals ensures reliability by limiting the blast radius. If there's a mis-configured pipeline, then only resources in that environment are impacted. Expect those service principals to provide autonomy over resources your workload will need to create and to be restricted from excessively manipulating the corp-provided and configured resources within the subscription.

## Integration with the platform-provided policies

The application landing zone subscription inherits Azure policies, Azure Network Manager rules, and other controls from its management group. Those guardrails are provided by the platform team. 

Don't depend on the platform-provided policies exclusively as they can lead to reliability issues. Especially when those policies and rules change outside your workload’s control. It's highly recommended that you create Azure policies and network security group (NSG) rules that meet the workload requirement. This effort might lead to some duplication but that's acceptable considering the potential impact on reliability of the system. If there are changes in the platform policies, the workload policies will still be in effect locally. 

As platform policies evolve, make sure you're involved in the change control process so that the reliability target of your application isn't compromised.





--------------STOP HERE---------------------------



## DUMP ZONE


## Networking considerations

The baseline architecture is designed to restrict both ingress and egress traffic from the same virtual network. However in this architecture, egress restrictions are provided through the connectivity subscription provisioned as part of the platform landing zone. It has virtual networking peering with the regional stamp network.

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
