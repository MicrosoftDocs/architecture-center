This reference architecture provides guidance for deploying a mission-critical workload that uses centralized shared services, needs on-premises connectivity, and integrates with other workloads of an enterprise. This guidance is intended for a workload owner who is part of an application team in the organization.

You might find yourself in this situation when your organization wants to deploy the workload in an _Azure application landing zone_ that inherits the Corp. Management group. The workload is expected to integrate with pre-provisioned shared resources in the _Azure platform landing zone_ that are managed by centralized teams.  

> [!IMPORTANT]
> **What is an Azure landing zone?**
> An application landing zone is a Azure subscription in which the workload runs. It's connected to the organization's shared resources. Through that connection, it has access to basic infrastructure needed to run the workload, such as networking, identity access management, policies, and monitoring. The platform landing zones is a collection of various subscriptions, each with a specific function. For example, the Connectivity subscription provides centralized DNS resolution, on-premises connectivity, and network virtual appliances (NVAs) that's available for use by application teams. 
>
> As a workload owner, you benefit by offloading management of shared resources to central teams and focus on workload development efforts. The organization benefits by applying consistent governance and amortizing costs across multiple workloads.
> 
> We highly recommend that you understand the concept of [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/). 

In this approach, maximum reliability is a shared responsibility between you and the platform team. **The centrally managed components need to be highly reliable for a mission-critical workload to operate as expected.** You must have a trusted relationship with the platform team so that unavailability issues in the centralized services, which affect the workload, are mitigated at the platform level. But, your team is accountable for driving requirements with the platform team to achieve your targets.

This architecture builds on the [**mission-critical **baseline architecture** with network controls**](./mission-critical-network-architecture.yml). It's recommended that you become familiar with the **baseline architecture** before proceeding with this article. 

> [!NOTE]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) that showcases mission-critical application development on Azure. This implementation can be used as a basis for further solution development as your first step towards production.

## Key design strategies
Apply these strategies on top of the [mission-critical baseline](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#key-design-strategies):

- **Critical path**

    Not all components of the architecture need to be equally reliable. Critical path includes those components that must be kept functional so that the workload doesn't experience any down time or degraded performance. Keeping that path lean will minimize points of failure. 

- **Lifecycle of components**

    Consider the lifecycle of critical components because it has an impact on your goal of achieving near zero down time. Components can be **ephemeral** or short-lived resources that can be created and destroyed as needed; **non-ephemeral** or long-lived resources that share the lifetime with the system or region. 

- **External dependencies**

    Minimize external dependencies on components and processes, which can introduce points of failure. The architecture has resources owned by various teams outside your team. Those components (if critical) are in-scope for this architecture. 

- **Subscription topology**

    Azure landing zones don't imply a single subscription topology. Plan your subscription footprint in advance with your platform team to accommodate workload reliability requirements across all environments.

- **Autonomous observability into the critical path**

    Have dedicated monitoring resources that enable the team to quickly query their data collection (especially the critical path) and act on remediations.  

## Architecture

:::image type="content" source="./images/mission-critical-architecture-landing-zone.svg" alt-text="Architecture diagram of a mission-critical workload in an Azure landing zone." lightbox="./images/mission-critical-architecture-landing-zone-high-res.png":::

*Download a [Visio file](https://arch-center.azureedge.net/mission-critical-landing-zone.vsdx) of this architecture.*

The components of this architecture are same as the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml). The descriptions are short for brevity. If you need more information, see the linked articles. For product documentation about Azure services, see [Related resources](#related-resources).

### Global resources

These resources live in the application landing zone subscription(s). Global resources are non-ephemeral and share the lifetime of the system. The Azure services and their configuration remain the same as the [**baseline global resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#global-resources).

### Regional networking resources

These resources live across the platform landing zone subscriptions and the application landing zone subscription(s). The **baseline architecture** deploys all resources owned by you. However in this architecture, networking resources are provided through the [Connectivity subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology) are provisioned as part of the platform landing zone. 

> In this article, see the [Regional hub virtual network](#regional-hub-virtual-network) section.

### Regional stamp resources

These resources live in the application landing zone subscription(s). These resources share nothing with other resources, except the [global resources](#global-resources). 

Most Azure services and their configuration remain the same as the [**baseline stamp architecture**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#deployment-stamp-resources), except for the networking resources, which are pre-provisioned by the platform team. 

> In this article, see the [Regional spoke virtual network](#regional-spoke-virtual-network) section.

### External resources

The workload interacts with on-premises resources. Some of them are on the critical path for the workload, for example an on-premises database. These resources and communication with them is factored into the overall composite Service Level Agreement (SLA) of the workload. All communication is through the Connectivity subscription. There are other external resources that the workload might reach but they aren't considered as critical.   

### Deployment pipeline resources

Build and release pipelines for a mission-critical application must be fully automated to guarantee a consistent way of deploying a validated stamp. These resources remain the same as the [**baseline deployment pipeline**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#deployment-pipeline-resources). 

### Regional monitoring resources

These resources live in the application landing zone subscription(s). Monitoring data for global resources and regional resources are stored independently. The Azure services and their configuration remain the same as the [**baseline monitoring resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#observability-resources).

> In this article, see the [Monitoring considerations](#monitoring-considerations) section.

### Management resources

To gain access to the private compute cluster and other resources, this architecture uses private build agents and jump box virtual machines instances. Azure Bastion provides secure access to the jump boxes. The resources inside the stamps remain the same as the [**baseline management resources**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#management-resources).

## Networking considerations

In this design, the workload is deployed in the application landing zone and needs connectivity to the federated resources in the platform landing zone. The purpose could be for accessing on-premises resources, controlling egress traffic, and so on. 

### Network topology

The platform team decides the network topology for the entire organization. [Hub-spoke topology](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology) is assumed in this architecture. An alternative could be Azure Virtual WAN.

##### Regional hub virtual network

The Connectivity subscription contains a hub virtual network with resources, which are shared by the entire organization. These resources are owned and maintained by the platform team. 

From a mission-critical perspective, this network is non-ephemeral, and these resources are on the critical path. 

|Azure resource|Purpose|
|---|---|
|**Azure ExpressRoute**|Provides private connectivity from on-premises to Azure infrastructure.
|**Azure Firewall**|Acts as the NVA that inspects and restricts egress traffic.|
|**Azure DNS**|Provides cross-premises name resolution.|
|**VPN gateway**|Connects remote organization branches over the public internet to Azure infrastructure. Also acts as a backup connectivity alternative for adding resiliency.| 

The resources are provisioned in each region and peered to the spoke virtual network (described next). Make sure you understand and agree to the updates to NVA, firewall rules, routing rules, ExpressRoute fail over to VPN Gateway, DNS infrastructure, and so on.

> [!NOTE]
> A key benefit in using the federated hub is that the workload can integrate with other workloads either in Azure or cross-premises by traversing the organization-managed network hubs. This change also lowers your operational costs because a part of the responsibility is shifted to the platform team. 

##### Regional spoke virtual network

The application landing zone has at least two pre-provisioned **Azure Virtual Networks**, per region, which are referenced by the regional stamps. These networks are non-ephemeral. One serves production traffic and the other targets the vNext deployment. This approach gives you the ability to perform [reliable and safe deployments practices](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-landing-zone#zero-downtime-deployment). 

##### Operations virtual network

Operational traffic is isolated in a separate virtual network. This virtual network is non-ephemeral and you own this network. This architecture keeps the same design as the [**baseline architecture with network controls**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#operations-virtual-network).  

There's no peering between the operations network and spoke network. All communication is through Private Links. 

### Shared responsibilities

Have a clear understanding of which team is accountable for each design element of the architecture. Here are some key areas.

##### IP address planning

After you've estimated the size needed to run your workload, work with the platform team so that they can provision the network appropriately.

**Platform team**

- Provide distinct addresses for virtual networks that participate in peerings. Overlapping addresses, for example of on-premises and workload networks, can cause disruptions leading to outage.

- Allocate IP address spaces that are large enough to contain the runtime and deployments resources, handle failovers, and support scalability. 

The pre-provisioned virtual network and peerings must be able to support the expected growth of the workload. You must evaluate that growth with the platform team regularly. For more information, see [Connectivity to Azure](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure).

##### Regional spoke network subnetting

You're responsible for allocating subnets in the regional virtual network. The subnets and the resources in them are ephemeral. The address space should be large enough to accommodate potential growth. 

- **Private endpoints subnet** After traffic reaches the virtual network, communication with PaaS services within the network, is restricted by using private endpoints, just like the [**baseline architecture with network controls**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#private-endpoints-for-paas-services). These endpoints are placed in a dedicated subnet. Private IP addresses to the private endpoints are assigned from that subnet.

- **Cluster subnet** The scalability requirements of the workload influence how much address space should be allocated for the subnets. As AKS nodes and pods scale out, IP addresses are assigned from this subnet. 

##### Network segmentation

Maintain proper segmentation so that your workload's reliability isn't compromised by unauthorized access. 

This architecture uses Network Security Groups (NSGs) to restrict traffic across subnets and the Connectivity subscription. NSGs use ServiceTags for the supported services.

**Platform team**

- Enforce the use of NSGs through Azure Network Manager Policies.

- Be aware of the workload design. There isn't any direct traffic between the stamps. Also there aren't inter-region flows. If those paths are needed, traffic must flow through the Connectivity subscription. 

- Prevent unnecessary hub traffic originating from other workloads into the mission-critical workload.


##### Egress traffic from regional stamps

All outgoing traffic from each regional spoke network is routed through the centralized Azure Firewall in the regional hub network. It acts as the next hop that inspects and then allows or denies traffic. 

**Platform team**

- Create UDRs for that custom route. 

- Assign Azure policies that will block the application team from creating subnets that don't have the new route table. 

- Give adequate role-based access control (RBAC) permissions to the application team so that they can extend the routes based on the requirements of the workload.


##### Multi-region redundancy

Your mission-critical workloads must be deployed in multiple regions to withstand regional outages. Work with the platform team to make sure the infrastructure is reliable.

**Platform team**
- Deploy centralized networking resources per region. The mission-critical design methodology requires regional isolation.

- Work with the application team to uncover hidden regional dependencies so that a degraded platform resource in one region doesn't impact workloads in another region.

##### DNS resolution

The Connectivity subscription provides private DNS zones. However, that centralized approach might not factor in the DNS needs that might be specific to your use case. Provision your own DNS zones and link to the regional stamp. If the application team doesn't own DNS, then management of private links becomes challenging for global resources, such as Azure Cosmos DB. 

**Platform team**
- Delegate the Azure Private DNS zones to the application team to cover their use cases. 

- For the regional hub network, set the DNS servers value to Default (Azure-provided) to support private DNS zones managed by the application team. 

## Environment design considerations

It's a general practice to place workloads in separate environments for **production**, **pre-production**, and **development**. Here are some key considerations.

##### How is isolation maintained?

The production environment _must_ be isolated from other environments. Lower environments should also  maintain a level of isolation. Avoid sharing application-owned resources between environments.

One production environment is required for global, regional, and stamp resources owned by the application team. Pre-production environments, such as staging and integration, are needed to make sure the application is tested in an environment that simulates production, as much as possible. Development environment should be a scaled down version of production.

##### What is the expected lifecycle?

Pre-production environments can be destroyed after validation tests are completed. It's recommended that development environments share the lifetime of a feature and are destroyed when development is complete. Those actions done by continuous integration/continuous deployment (CI/CD) automation.

##### What are the tradeoffs?

Consider the tradeoffs between isolation of environments, complexity of management, and cost optimization.

> [!TIP]
> All environments should take dependencies on production instances of external resources including platform resources. For example, a production regional hub in the Connectivity subscription. You'll be able to minimize the delta between pre-production and production environments.

## Subscription topology for workload infrastructure

Subscriptions are given to you by the platform team. Depending on the **number of environments**, you'll request several subscriptions for just one workload. Depending on the **type of environment**, some environments might need dedicated subscriptions while other environments might be consolidated into one subscription. 

Regardless, work with the platform team to design a topology that meets the overall reliability target for the workload. There's benefit to sharing the platform-provided resources between environments in the same subscription because it will reflect the production environment.

> [!NOTE]
> Using multiple subscriptions to contain the environments can achieve the required level of isolation. Landing zone subscriptions are inherited from the same management group. So, consistency with production is ensured for testing and validation.

##### Production subscription

There might be resource limits on the subscription given to you. If you colocate all those resources in one subscription, you may reach those limits. Based on your scale units and expected scale, consider a more distributed model. For example,

- One subscription that contains both Azure DevOps build agents and global resources.

- One subscription, per region. It contains the regional resources, the stamp resources, and jump boxes for the regional stamp(s).

Here's an example subscription topology used in this architecture.

:::image type="content" source="./images/connected-subscription.svg" alt-text="Diagram of an example subscription layout for a mission-critical workload in an Azure landing zone." lightbox="./images/connected-subscription-high-res.png":::


##### Pre-production subscription

At least one subscription is required. It can run many independent environments, however, having multiple environments in dedicated subscriptions is recommended. This subscription may also be subject to resource limits like the production subscription, described above.

##### Development subscription

At least one subscription is required. This subscription might be subject to resource limits if runs all independent environments. So, you may request multiple subscriptions. Having individual environments in their dedicated subscriptions is recommended.

Try to match the production topology as much as possible.

## Deployment considerations

Failed deployments or erroneous releases are common causes for application outages. Test your application (and new features) thoroughly as part of the application lifecycle. When deploying the workload in a landing zone, you'll need to integrate your design with the platform-provided resources and governance. 

> Refer to: [Well-architected mission-critical workloads: Deployment and testing](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing).

### Deployment infrastructure

Reliability of the deployment infrastructure, such as build agents and their network, is often as important as the runtime resources of the workload.

This architecture uses private build agents to prevent unauthorized access that can impact the application's availability. 

Maintaining isolation between deployment resources is highly recommended. A deployment infrastructure should be bound to your workload subscription(s) for that environment. If you're using multiple environments in pre-production subscriptions, then create further separation by limiting access to only those individual environments. Per-region deployment resources could be considered to make the deployment infrastructure more reliable.

### Zero-downtime deployment

Updates to the application can cause outages. Enforcing consistent deployments will boost reliability. These approaches are recommended:
- Have fully automated deployment pipelines.
- Deploy updates in pre-production environments on a clean stamp. 

> For more information, see [Mission-critical deployment and testing guidelines](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-deploy-test).

In the **baseline architecture**, those strategies are implemented by unprovisioning and then tearing down the stamp with each update. In this design, complete unprovisioning isn't possible because the platform team owns some resources. So the deployment model was changed.

##### Deployment model

The **baseline architecture** uses Blue-Green model to deploy application updates. New stamps with changes are deployed alongside existing stamps. After traffic is moved to the new stamp, the existing stamp is destroyed. 

In this case, the given peered virtual network is non-ephemeral. The stamp isn't allowed to create the virtual network or peering to the regional hub. You'll need to reuse those resources in each deployment.

Canary model can achieve safe deployment with the option to roll back. First, a new stamp is deployed with code changes. The deployment pipeline references the pre-provisioned virtual network and allocates subnets, deploys resources, adds private endpoints. Then, it shifts traffic to these subnets in this pre-provisioned virtual network.

When the existing stamp is no longer required, all stamp resources are deleted by the pipeline, except for the platform-owned resources. The virtual network, diagnostic settings, peering, IP address space, DNS configuration, and role-based access control (RBAC) are preserved. At this point, the stamp is in a clean state, and ready for the next new deployment.

##### DINE (deploy-if-not-exists) Azure policies

Azure application landing zones might have DINE (deploy-if-not-exists) Azure policies. Those checks ensure that deployed resources meet corporate standards in application landing zones, even when they're owned by the application team. There might be a mismatch between your deployment and the final resource configuration.

Understand the impact of all DINE policies that will be applied to your resources. If there are changes to resource configuration, incorporate the intention of the policies into your declarative deployments early in the workload’s development cycle. Otherwise, there might be a drift leading to delta between the desired state and the deployed state.

##### Deployment subscription access management

Treat subscription boundaries as your security boundaries to limit the blast radius. Threats can impact the workload's reliability. 

**Platform team** 

- Give the application teams authorization for operations with permissions scoped to the application landing zone subscription. 

If you're running multiple deployments within a single subscription, a breach will impact both deployments. Running deployments in dedicated subscriptions is recommended. Create service principals per environment for maintaining logical separation.

The service principal should provide autonomy over workload resources. Also, it should have restrictions in place that will prevent excessive manipulation of the platform resources within the subscription.

## Monitoring considerations

The Azure landing zone platform provides shared observability resources as part of the Management subscriptions. The centralized operations team [encourage the application teams to use the federated model](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads). But for mission-critical workloads, a single, centralized observability store isn't recommended because it can potentially be a single point of failure. Mission-critical workloads also generate telemetry that might not be applicable or actionable for centralized operations teams.

So, an autonomous approach for monitoring is highly recommended. Workload operators are ultimately responsible for the monitoring and must have access to all data that represents overall health.

The **baseline architecture** follows that approach and is continued in this reference architecture. Azure Log Analytics and Azure Application Insights are deployed regionally and globally to monitor resources in those scopes. Aggregating logs, creating dashboards, and alerting is in scope for your team. Take advantage of Azure Diagnostics capabilities that send metrics and logs to various sinks to support platform requirements for log & metric collection. 

### Health model

Mission-critical design methodology requires a system [health model](mission-critical-health-modeling.md). When you're defining an overall health score, include in-scope platform landing zone flows that the application depends on. Build log, health, and alert queries to perform cross-workspace monitoring.

**Platform team** 
- Grant role-based access control (RBAC) query and read log sinks for relevant platform resources that are used in the critical path of the mission-critical application. 

- Support the organizational goal of reliability toward the mission-critical workload by giving the application team enough permission to do their operations.

In this architecture, the health model includes logs and metrics from resources provisioned in Connectivity subscription. If you extend this design to reach an on-premises resource such as a database, the health model must include network connectivity to that resource, including security boundaries like network virtual appliances in Azure _and_ on-premises. This information is important to quickly determine the root cause and remediate the reliability impact. For example, did the failure occur when trying to route to the database, or was there an issue with the database?

> Refer to: [Well-architected mission-critical workloads: Health modeling](/azure/architecture/framework/mission-critical/mission-critical-health-modeling).

## Integration with the platform-provided policies and rules

The application landing zone subscription inherits Azure policies, Azure Network Manager rules, and other controls from its management group. The platform team provides those guardrails. 

For deployments, don't depend on the platform-provided policies exclusively, because:

- They aren't design to cover the needs of individual workloads. 
- The policies and rules might get updated or removed outside your team, and so can impact reliability. 

It's highly recommended that you create and assign Azure policies within your deployments. This effort might lead to some duplication but that's acceptable, considering the potential impact on reliability of the system. If there are changes in the platform policies, the workload policies will still be in effect locally. 

**Platform team** 

- Involve the application team in the change management process of policies as they evolve. 
- Be aware of the policies used by the application team. Evaluate if they should be added to the management group. 

## Deploy this architecture

The networking aspects of this architecture are implemented in the Mission-critical Connected implementation.

> [!div class="nextstepaction"]
> [Implementation: Mission-critical Connected](https://github.com/Azure/Mission-Critical-Connected)

> [!NOTE]
> The Connected implementation is intended to illustrate a mission-critical workload that relies on organizational resources, integrates with other workloads, and uses shared services. The implementation assumes that a Connectivity subscription already exists.

## Next steps

Review the networking and connectivity design area in Azure Well-architected Framework.

> [!div class="nextstepaction"]
> [Design area: Networking and connectivity](/azure/architecture/framework/mission-critical/mission-critical-networking-connectivity)

## Related resources

In addition to the [**Azure services used in the baseline architecture**](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-network-architecture#related-resources), these services are important for this architecture.

- [Azure Management Groups](/azure/governance/management-groups/)
- [Azure Policy](/azure/governance/policy/)
- [Azure Network Manager](/azure/virtual-network-manager/)
- [Azure Monitor](/azure/azure-monitor/)
- [Virtual Networks](/azure/virtual-network/)
- [Route tables](/azure/virtual-network/virtual-networks-udr-overview)

