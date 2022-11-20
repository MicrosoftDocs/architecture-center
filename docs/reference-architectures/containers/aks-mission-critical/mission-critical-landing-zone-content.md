This reference architecture provides guidance for deploying a mission-critical workload that uses centralized shared services, needs on-premises connectivity, and integrates with other workloads of an enterprise. This guidance is intended for a workload owner who is part of an application team in the organization.

You might find yourself in this situation when your organization wants to deploy the workload in an _application Azure landing zone_ that inherits the Corp Management group. The workload is expected to integrate with the pre-provisioned shared resources that are managed by centralized teams in the _platform Azure landing zone_ that inherits the Corp Management group.  

In this approach, **the centrally managed components need to be highly reliable for a mission-critical workload to operate as expected.** The reliability tier of the platform and the workload must be aligned. You must have a trusted relationship with the platform team so that unavailability issues in the foundational services, which affect the workload, are mitigated at the platform level.

> [!IMPORTANT]
> An application landing zone is a pre-provisioned subscription that's connected to the organization's shared resources. It has access to basic infrastructure needed to run the workload, such as networking, identity access management, policies, and monitoring capabilities. The Azure platform landing zones is a collection of various subscriptions each with specific functionality. For example, the Connectivity subscription contains Azure Private DNS Zone, ExpressRoute circuit, Firewall in a virtual network that's available for use in applicable scenarios. 
>
> You benefit by offloading management of shared resources to central teams and focus on workload development efforts. The organization benefits by applying consistent governance and amortizing costs across multiple workloads.
> 
> If you aren't familiar with the concept of landing zones, we highly recommend you start with [What is an Azure landing zone?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)

This architecture builds on the [**mission-critical **baseline architecture** with network controls**](./mission-critical-network-architecture.yml). It's recommended that you become familiar with the **baseline architecture** before proceeding with this article. 

> [!NOTE]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission-critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Key design strategies
The design strategies for mission-critical baseline still apply in this use case. Here are the considerations for this architecture:

- **Critical path**

    Not all components of the architecture are equally important. Critical path includes those components that must be kept functional so that the workload doesn't experience any down time or degraded performance. Keeping that path lean will minimize points of failure. Design choices for maximum reliability, are a shared responsibility between the platform team and you. The application team is accountable for driving continuous evaluation and the overall change with the platform team.

- **Lifecycle of components**

    Consider the lifecycle of critical components because that aspect has an impact on your goal of achieving zero down time deployments. Components can be **ephemeral** or short-lived resources that can be created and destroyed as needed; **non-ephemeral** or long-lived resources that share the lifetime with the system or region. There are also components that used to be ephemeral in the **baseline architecture** but are now non-ephemeral because they're pre-provisioned by the platform team.  

- **External dependencies**

    Minimize external dependencies on components and processes, which can introduce points of failure. Understand and mitigate remaining risks with agreed upon configurations. The architecture has resources owned by various teams outside your team. Those components are in-scope for workload. Evaluate the reliability of those components and policies with the platform team regularly.

- **Subscription topology**

    Azure landing zones don't imply a single subscription topology. Plan your subscription footprint in advance with your platform team to accommodate workload reliability and requirements and the DevOps team responsibilities across all environments.

- **Autonomous observability into the critical path**

    Have dedicated monitoring resources that enable the team to query their data collection (especially the critical path) quickly and act on remediations.  

## Architecture

:::image type="content" source="./images/mission-critical-architecture-landing-zone-highres.png" alt-text="Architecture diagram of a mission-critical workload in an Azure landing zone." lightbox="./images/mission-critical-architecture-landing-zone.png":::

The components of this architecture are same as the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml). The descriptions are short for brevity. If you need more information, see the linked articles. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

These resources live in the application landing zone subscription(s). Global resources are non-ephemeral and share the lifetime of the system. The Azure services and their configuration remain the same as the [**baseline global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

### Regional monitoring resources

These resources live in the application landing zone subscription(s). Monitoring data for global resources and regional resources are stored independently. A single, centralized observability store isn't recommended because it can potentially be a single point of failure. The Azure services and their configuration remain the same as the [**baseline monitoring resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#observability-resources).

> For more information, see the [Monitoring considerations](#monitoring-considerations) section.

### Regional networking resources

These resources live in both the platform landing zone subscriptions and the application landing zone subscription(s). The **baseline architecture** deploys all resources owned by you. However in this architecture, networking resources are provided through the [Connectivity subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology) provisioned as part of the platform landing zone. 

> For more information, see the [Networking considerations](#networking-considerations) section.

### Regional stamp resources

These resources live in the application landing zone subscription(s). The resources are part of a _deployment stamp_ and intended to be ephemeral to provide more resiliency, scale, and proximity to users. These resources share nothing with resources in another region. They share [global resources](#global-resources) between each other. 

Most Azure services and their configuration remain the same as the [**baseline stamp architecture**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources), except for the networking resources. Those resources pre-provisioned by the platform team. 

> For more information, see the [Networking considerations](#networking-considerations) section.

### External resources

The workload interacts with on-premises resources. Some of them are on the critical path for the workload, for example an on-premises database. These resources and communication with them is factored in the overall composite Service Level Agreement (SLA) of the workload. All communication is through the Connectivity subscription. There are other external resources that the workload might reach but they aren't considered as critical.   

### Deployment pipeline resources

Build and release pipelines for a mission-critical application must be fully automated to guarantee a consistent way of deploying a validated stamp. These resources remain the same as the [**baseline deployment pipeline**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#deployment-pipeline-resources). 

### Management resources
To gain access to the private compute cluster and other private resources, this architecture uses private build agents and jump box virtual machines instances. Azure Bastion provides secure access to the jump box VMs. The resources inside the stamps remain the same as the [**baseline management resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#management-resources).

## Networking considerations

In this design, the workload is deployed in the application landing zone and will need connectivity to the federated resources in the platform landing zone. The purpose could be for accessing on-premises resources, controlling egress traffic, and so on. 

### Network topology

The platform team decides the network topology for the entire organization. This architecture assumes the [hub-spoke topology](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology), used for regional deployments.

##### Regional hub virtual network

The Connectivity subscription contains a hub virtual network with resources, which are shared by the entire organization. These resources are owned by maintained by the platform team. 

From a mission-critical perspective, this network is ephemeral and these resources are in-scope for your workload. 

|Azure resource|Purpose|
|---|---|
|**Azure ExpressRoute**|Provides private connectivity from on-premises to Azure infrastructure.
|**Azure Firewall**|Acts as the network virtual appliance (NVA) that inspects and restricts egress traffic.|
|**Azure Active Directory**-integrated DNS infrastructure|Cross-premises DNS name resolution.
|**VPN gateway**|Connectivity from remote organization branches over the public internet to Azure infrastructure. Also acts as a backup connectivity alternative for adding resiliency.| 

The resources are provisioned in each region and peered to the spoke virtual network (described next). Make sure you understand and agree with the updates to NVA, firewall rules, routing rules, ExpressRoute fail over to VPN Gateway, DNS infrastructure, and so on.

> [!NOTE]
> A key benefit in using the federated hub is that the workload can integrate with other workloads either in Azure or cross-premises by traversing the organization-managed network hubs. Another benefit is cost optimization when compared to the **baseline architecture with network controls**. This change also lowers your operational costs because a part of the responsibility is shifted to the platform team. 

##### Regional spoke virtual network

The application landing zone has at least two pre-provisioned **Azure Virtual Networks**, per region, which are referenced by the mission-critical stamps. These networks are non-ephemeral. One serves production traffic and the other targets the vNext deployment. This approach gives you the ability to perform [reliable and safe deployments practices](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-landing-zone#zero-downtime-deployment). 

##### Operations virtual network

Operational traffic isolated in a separate virtual network. This virtual network is non-ephemeral and you own this network. This architecture keeps the same design as the [**baseline architecture with network controls**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#operations-virtual-network).  

There's no peering between the operations network and spoke network. All communication is through Private Links. 

### Shared responsibilities

Have a clear understanding of which team is accountable for each design element of the architecture. Here are some key areas.

##### IP address planning

After you've estimated the size needed to run your workload, work with the platform team so that they can provision the network properly.

**Platform team**

- Provide distinct addresses for virtual networks that participate in peerings. Overlapping addresses, for example of on-premises and workload networks, can cause disruptions leading to outage.

- Allocate IP address spaces that are large enough to contain the runtime and deployments resources, handle failovers, and support scalability. 

The pre-provisioned virtual network and peerings must be able to support the expected growth of the workload. You must evaluate that growth with the platform team regularly. For more information, see [Connectivity to Azure](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure).

##### Regional spoke network subnetting

You're responsible for allocating subnets in the regional virtual network. The subnets and the resources in them are ephemeral. 

After traffic reaches the virtual network, communication with PaaS services within the network, is locked down by using private endpoints, just like the [**baseline architecture with network controls**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#private-endpoints-for-paas-services). These endpoints are placed in a dedicated subnet, outside the AKS node pool subnet. The address space is large enough to accommodate all private endpoints necessary for the stamp. Private IP addresses to the private endpoints are assigned from that subnet. 

The scalability requirements of the workload influence how much address space should be allocated for the subnets. They should be large enough to accommodate the AKS nodes and pods as they scale out. 

##### Network segmentation

Maintain proper network segmentation so that your workload's reliability isn't compromised by unauthorized access. 

This architecture uses Network Security Groups (NSGs) to restrict traffic across subnets and the Connectivity subscription. NSGs use ServiceTags for the supported services.

**Platform team**

- Enforce NSGs through Azure Network Manager Policies.

- Be aware of the workload design. There isn't any direct traffic between the stamps. Also there aren't inter-region flows. If those paths are needed, traffic must flow through the Connectivity subscription. 

- Minimize unnecessary hub traffic originating from other workloads into the mission-critical workload.


##### Egress traffic from regional stamps

All outgoing traffic from each regional spoke network is routed through the centralized Azure Firewall in the regional hub network. It acts as the next hop that inspects and then allows or denies traffic. 

**Platform team**

- Create UDRs for that custom route. 

- Assign Azure policy that will block your team from creating subnets without assigning that new route table. 

- Give proper role-based access control (RBAC) permissions to the application team so that they can extend the routes based on the requirements of the workload.


##### Multi-region redundancy

Your mission-critical workloads must be deployed in multiple regions to withstand regional outages. Work with the platform team to make sure the infrastructure is reliable.

**Platform team**
- Deploy the centralized networking resources per region. The mission-critical design methodology requires regional isolation.

- Work with the application team to uncover hidden regional dependencies so that a degraded platform resource in one region doesn't impact workloads in another region.

##### DNS resolution

The Connnectivity subscription provides private DNS zones. However, that centralized approach might not factor in the DNS failures that are specific to your workload. Provision your own DNS zones and link to the regional stamp. 

**Platform team**
- When possible, delegate the Azure Private DNS zones to the application team to cover their use cases. 

- For the regional hub network, set the DNS servers value to Default (Azure-provided) to support private DNS zones managed by the application team. 


## Deployment considerations

Failed deployments or erroneous releases are common causes for application outages. Test your application (and new features) thoroughly as part of the application lifecycle. When deploying the workload in a landing zone, you'll need to integrate your design with the platform-provided resources and governance. 

> Refer to: [Well-architected mission-critical workloads: Deployment and testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing).

### Deployment environments

- **How is isolation maintained?** It's a general practice to place workloads in separate environments for **production**, **pre-production**, and **development**. The production environment _must_ be isolated from other environments. Lower environments should also  maintain a level of isolation. Avoid sharing application-owned resources between environments.

    One production environment is required for global, regional, and stamp resources owned by the application team. Pre-production environments, such as staging and integration, are needed to make sure the application is tested in an environment that simulates production, as much as possible. Development environment should be a scaled down version of production.

- **What is the expected lifecycle?** Environments have different lifecycle requirements. Ephemeral environments can be created and destroyed as needed through continuous integration/continuous deployment (CI/CD) automation.

    Pre-production environments can be destroyed after validation tests are completed. It's recommended that development environments share the lifetime of a feature and are destroyed when development is complete. 

- **What are the tradeoffs?** Consider the tradeoffs between isolation of environments, complexity of management, and cost optimization.

> [!TIP]
> All environments should take dependencies on production instances of external resources including platform resources. For example, a production regional hub in the Connectivity subscription. You'll be able to minimize the delta between pre-production and production environments.

### Subscription topology for workload infrastructure

The platform team will give you an Azure landing zone subscription to run your workload. Depending on the **number of environments**, you might request several subscriptions for just one workload. Depending on the **type of environment**, some environments might need dedicated subscriptions while other environments might be consolidated into one subscription. 

Regardless, work with the platform team to design a topology that meets the overall reliability target for the workload. There's benefit to sharing the platform-provided resources between environments in the same subscription because it will reflect the production environment.

> [!NOTE]
> Using multiple subscriptions to contain the environments can achieve the required level of isolation. Landing zone subscriptions inherit from the same management group. So, consistency with production is ensured for testing and validation.

##### Production subscription

There might be resource limits on the application landing zone subscription given to you. If you colocate all those resources in one subscription, you may reach those limits. Based on your scale units and expected scale, consider a more distributed model. For example,

- One subscription that contains both Azure DevOps build agents and global resources.

- One subscription, per region. It contains the regional resources, the stamp resources, and jump boxes for the regional stamp(s).

Here's an example subscription topology used in this architecture.

![Diagram of an example subscription layout for a mission-critical workload in an Azure landing zone.](./images/connected-subscription.png)

##### Pre-production subscription

At least one subscription is required. It can run many independent environments, however, having multiple environments in dedicated subscriptions is recommended. This subscription may also be subject to resource limits like the production subscription, described above.

##### Development subscription

At least one subscription is required. This subscription might be subject to resource limits if runs all independent environments. So, you may request multiple subscriptions. Having individual environments in their dedicated subscriptions is recommended.

Try to match the production topology as much as possible. 

### Deployment infrastructure

Reliability of the deployment infrastructure, such as build agents and their network, is as important as the runtime resources of the workload. 

This architecture uses private build agents to prevent unauthorized access that can impact the application's availability. 

Maintaining isolation between deployment resources is highly recommended. A deployment infrastructure should be bound to your workload subscription. If you're using multiple environments, then create further separation by limiting access to only those individual environments. Per-region deployment resources could be considered to make the deployment more reliable.

### Zero-downtime deployment

A mission-critical workload must not experience outage caused by updates to the application. Consistent deployments must be enforced with each update. These approaches are recommended:
- Fully automated deployment pipelines
- New deployments must start from a _factory reset_ state and always in pre-production environments. After the stamp has been unprovisioned, it's torn down, and a new deployment creates infrastructure resources. For more information, see [Mission-critical deployment and testing guidelines](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-deploy-test).

In the **baseline architecture**, those strategies can be implemented as the application team has full autonomy of the workload resources. In this architecture, the platform team owns some of those resources. So, there are some areas where you might need to adjust your approach.

##### Non-ephemeral resources

In the application landing zone, the given pre-peered virtual network is non-ephemeral. The stamp isn't allowed to create the virtual network or peering to the regional hub. 

You'll need to reuse the non-ephemeral resources in each deployment. The strategy is illustrated for networking resources in the next section.

##### Deployment model

The **baseline architecture** uses Blue-Green model to deploy application updates. New stamps with changes are deployed alongside existing stamps. After traffic is moved to the new stamp, the existing stamp is destroyed. 

In this case, the Canary model can achieve reliable and safe deployment with the option to roll back. First, a new stamp is deployed with code changes. The deployment pipeline references the pre-provisioned virtual network and allocates subnets, deploys resources, adds private endpoints. Then, it shifts traffic to the new subnets.

When the existing stamp is no longer required, all stamp resources are deleted by the pipeline, except for the platform-owned resources. The virtual network, diagnostic settings, peering, IP address space, DNS configuration, and role-based access control (RBAC) are preserved. At this point, the stamp is at a factory reset state, and ready for the next new deployment.


##### DINE (deploy-if-not-exists) Azure policies

Azure landing zones might use DINE (deploy-if-not-exists) Azure policies to ensure that deployed resources meet corporate standards in application landing zones, even when they're owned by the application team. There might be a mismatch between your deployment and the final resource configuration.

Evaluate the impact of all DINE policies that will be applied to your resources. If there are changes to the configuration, incorporate the intention of the policies into your declarative deployments early in the workload’s development cycle. Don't apply those changes through imperative approaches as they can impact overall reliability.

##### Deployment subscription access management

Treat subscription boundaries as your security boundaries to limit the blast radius. Threats can impact the workload's reliability. 

As part of the application landing zone subscription, the platform team should give the application teams proper authorization for operations with permissions scoped to the landing zone subscription. 

If you're running multiple deployments within a single subscription, avoid using a shared service principal because a breach will impact both deployments. Using one service principal per environment is recommended. The service principals should provide autonomy over resources that your workload will need to create as part of the deployment. Also, it should have restrictions in place that will prevent excessive manipulation of the platform resources within the subscription.

## Monitoring considerations

The Azure landing zone platform provides shared observability resources as part of the Management subscriptions. The centralized operations team [encourage the application teams to use federated model](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads) but for mission-critical workloads, an autonomous approach for monitoring is highly recommended.  

Mission-critical workloads need telemetry that might not be applicable or actionable for centralized operations teams. Workload operators are ultimately responsible for the monitoring and must have access to all data that represents overall health.

The **baseline architecture** follows that approach and is continued in this reference architecture. Azure Log Analytics and Azure Application Insights are deployed regionally and globally to monitor resources in those scopes. Aggregating logs, creating dashboards, and alerting is in scope for the workload team. The workload team can take advantage of Azure Diagnostics capabilities that send metrics and logs to various sinks. 

### Health model

Mission-critical design methodology requires a system [health model](mission-critical-health-modeling.md). When you're defining an overall health score, include the platform landing zone flows that the application depends on. Those platform resources are in-scope for this architecture. Build log, health, and alert queries to perform cross-workspace queries to factor in those resources.

The platform team should grant role-based access control (RBAC) to log sinks for relevant resources that are used in the critical path of your architecture. Be sure to negotiate that access to support the shared responsibility of the platform team toward the mission-critical workload.

In this architecture, the health model includes logs and metrics from resources provisioned in Connectivity subscription, such as Azure Firewall. If you extend this design to reach an on-premises database, the health model must include network connectivity to that database, including security boundaries like network virtual appliances in Azure _and_ on-premises. This information is important to quickly determine the root cause and remediate the reliability impact. For example, did the failure occur when trying to route to the database, or was there an issue with the database?

> Refer to: [Well-architected mission-critical workloads: Health modeling](/azure/architecture/framework/mission-critical/mission-critical-health-modeling).

## Integration with the platform-provided policies and rules

The application landing zone subscription inherits Azure policies, Azure Network Manager rules, and other controls from its management group. The platform team provides those guardrails. 

For deployments, don't depend on the platform-provided policies exclusively as they won't cover the needs of the workload. When those policies and rules changed or removed outside your workload’s control, they could impact reliability. It's highly recommended that you create and assign Azure policies within your deployments that meet the workload requirement. This effort might lead to some duplication but that's acceptable, considering the potential impact on reliability of the system. If there are changes or removals in the platform policies, the workload policies will still be in effect locally. 

As platform policies evolve, make sure you're involved in the change control process so that the reliability target of your application isn't compromised. 




## Deploy this architecture

The networking aspects of this architecture are implemented in the Mission-critical Connected implementation.

> [!div class="nextstepaction"]
> [Implementation: Mission-critical Connected](https://github.com/Azure/Mission-Critical-Connected)

> [!NOTE]
> The Connected implementation is intended to illustrate a mission-critical workload that relies on organizational resources, integrates with other workloads, and uses shared services. It builds on this reference architecture and uses the network controls described in this article. However, the Connected scenario assumes that virtual private network or Azure Private DNS Zone already exist within the Azure landing zones Connectivity subscription.

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

