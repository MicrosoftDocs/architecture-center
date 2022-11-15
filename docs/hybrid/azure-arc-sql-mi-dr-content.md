This reference architecture demonstrates how to deploy an Azure Arc-enabled SQL Managed Instance in a highly available architecture across two sites, and is based on the Azure Arc Jumpstart [ArcBox for DataOps](https://azurearcjumpstart.io/azure_jumpstart_arcbox/dataops/) implementation. ArcBox is a solution that provides an easy to deploy sandbox for all things Azure Arc. ArcBox for DataOps is a version of ArcBox that is intended for users who want to experience Azure Arc-enabled SQL Managed Instance capabilities in a sandbox environment.

## Architecture

:::image type="content" source="./images/azure-arc-sql-mi-dr.png" alt-text="An Azure Arc-enabled SQL Managed Instance topology diagram in across two sites." lightbox="./images/azure-arc-sql-mi-dr.png" :::

*Download a [PowerPoint file][architectural-diagram-ppt-source] of this architecture.*

### Components

The architecture consists of the following components:

- An **[Azure Resource Group][Azure Resource Group]** is a container that holds related resources for an Azure solution. The resource group can include all the resources for the solution, or only those resources that you want to manage as a group.
- **[Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/)**. Attach and configure Kubernetes clusters inside or outside of Azure by using Azure Arc-enabled Kubernetes. When a Kubernetes cluster is attached to Azure Arc, you can deploy Azure Arc Data services to it like Azure Arc-enabled SQL Managed Instance.
- **[Azure Arc Data Controller](/azure/azure-arc/data/create-data-controller-direct-cli?tabs=linux)**. The Arc Data Controller is the orchestrator in the Azure Arc-enabled data services architecture, its responsible to manage services like provisioning, elasticity, recoverability, monitoring, and high availability.
- **[Azure Arc-enabled SQL Managed Instance](/azure/azure-arc/data/managed-instance-overview)**. Deploy Azure Arc-enabled SQL Managed Instances to host your data workloads using the Azure PaaS data offerings on your hybrid and multi-cloud infrastructure.
- **Domain Controller**. Domain controllers are deployed into this architecture to manage authentication and authorization to the Azure Arc-enabled SQL Managed Instances.

## Scenario details

### Potential use cases

Typical uses for this architecture include:

- The need to deploy a highly available Azure Arc-enabled SQL Managed Instance in one site that is resilient to any crashes.
- Deploying Azure Arc-enabled SQL Managed Instance in a primary and a DR site to recovery from complete site downtime.
- Deploy a resilient data backend for your mission critical applications that resides on your hybrid or multi-cloud infrastructure.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Azure Arc-enabled SQL Managed Instance deployment

You can connect any [validated Kubernetes distribution](/azure/azure-arc/kubernetes/validation-program) to Azure Arc. Before connecting clusters, be sure to complete the [Azure Arc-enabled Kubernetes prerequisites][/azure/azure-arc/kubernetes/quickstart-connect-cluster#prerequisites].

Once connected, you would need to deploy an Azure Arc Data Controller. Make sure to complete the [Azure Arc Data Controller prerequisites](/azure/azure-arc/data/create-data-controller-direct-prerequisites?tabs=azure-cli), then you can start deployed the Azure Arc-enabled SQL Managed Instance.

There are are two service tiers where you can deploy Azure Arc-enabled SQL Managed Instance:

- General Purpose is a budget-friendly tier designed for most workloads with common performance and availability features.
- Business Critical tier is designed for performance-sensitive workloads with higher availability features.

A more detailed comparison between the service tiers can be found [here](/azure/azure-arc/data/service-tiers#service-tier-comparison).

### Monitor Azure Arc-enabled SQL Managed Instance

You can use Azure Monitor to monitor your Arc-enabled SQL Managed Instance using Log Analytics or you can use open-source solutions like [Grafana](/azure/azure-arc/data/monitor-grafana-kibana).

Design and plan your Log Analytics workspace deployment. It will be the container where data is collected, aggregated, and later analyzed. A Log Analytics workspace represents a geographical location of your data, data isolation, and scope for configurations like data retention. Use a single Azure Monitor Log Analytics workspace as described in the [management and monitoring best practices](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management) of Cloud Adoption Framework.

### Business continuity and disaster recovery

- Deploy Azure Arc-enabled SQL Managed Instance using the Business Critical service tier with 3 replicas to achieve near-zero data loss.

- Ensure that your instances of Arc-enabled SQL Managed Instance have different names for primary and secondary sites, and that the shared-name value for the sites is identical.

- Perform regular disaster recovery drills to validate the failover process.

- Create a process for initiating both manual and forced failovers.

- Monitor the health of your Arc-enabled Kubernetes clusters using [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-overview).

- Define the DNS record for the shared name of the distributed availability group in your DNS servers to avoid needing to manually create DNS records during the failover.

Review the [Azure Arc-enabled SQL Managed Instance landing zone accelerator](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery) for best practices and guidance on business continuity and disaster recovery.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

- Define your targets for [recovery point objective](/azure/cloud-adoption-framework/manage/considerations/protect#recovery-point-objectives-rpo) (RPO) and [recovery time objective](/azure/cloud-adoption-framework/manage/considerations/protect#recovery-time-objectives-rto) (RTO).
- Plan and configure [Point-in-time restore](/azure/azure-sql/managed-instance/point-in-time-restore?view=azuresql&tabs=azure-portal) capability to be able to restore your databases to a point in time.
- Consider how many replicas—one to three—to deploy in the Business Critical service tier.
- When deploying an instance in a Business Critical service tier with two or more replicas, you can configure the secondary replicas as readable. Decide on the number of secondary replicas to deploy in the Business Critical service tier. For information on changing the number, see [Configure readable secondaries](/azure/azure-arc/data/configure-managed-instance#configure-readable-secondaries).
- Consider how to monitor the downtime of the primary instance to decide when to perform a failover to the secondary instance.
- The instances of Azure Arc-enabled SQL Managed Instance in both geo-primary and geo-secondary sites must be identical in compute and capacity, as well as deployed to the same service tiers.
- Decide on a location in which to store the mirroring certificates when you create the disaster recovery configuration that is accessible by both clusters that host the instance.
- Decide which Kubernetes service type you'll use, *LoadBalancer* or *NodePort*. If you use the load balancer, then applications can reconnect to the same primary endpoint, and Kubernetes will redirect the connection to the new primary. If you use the node port, then applications must reconnect to the new IP address.
- Review the [business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery) guidance to determine whether your enterprise requirements are met.
- Other reliability considerations for your solution are described in the [reliability design principles][waf-principles-reliability] section in the Microsoft Azure Well-Architected Framework.

### Security

- Consider which Azure regions you plan to deploy your Arc-enabled SQL Managed Instance and Data Controllers within based on your security and compliance requirements, taking into consideration any data sovereignty requirements. Understand [what data is collected from your resources](/azure/azure-arc/data/privacy-data-collection-and-reporting) in *Directly* and *Indirectly Connected* mode, and plan accordingly based on the data residency requirements of your organization.
- Your Arc-enabled SQL Managed Instance can reside on hybrid or multicloud Kubernetes clusters. Review the security and governance considerations for your chosen cloud provider and Kubernetes distribution.
- While considering your organization's separation of duties and least-privileged access requirements, define cluster administration, operations, database administration, and developer roles within your organization. Mapping each team to actions and responsibilities determines Azure role-based access control (RBAC) roles or the Kubernetes _ClusterRoleBinding_ and _RoleBinding_ depending on the connectivity mode used.
- Decide on the authentication model to be used within your Arc-enabled SQL Managed Instance, whether it's Azure Active Directory (Azure AD) authentication or SQL authentication. Review the [identity and access management design area](./eslz-arc-data-service-sql-managed-instance-identity-access-management.md) for design considerations and recommendations to choose the right authentication mode.
- Review the [security capabilities](/azure/azure-arc/data/managed-instance-features#RDBMSS) that are available in Arc-enabled SQL Managed Instance for your data workloads.
- Consider the need for keeping your Arc-enabled SQL Managed Instance up-to-date with the latest versions, whether they're deployed in Directly or Indirectly Connected mode. Review the [upgradeability disciplines critical design area](./eslz-arc-data-service-sql-managed-instance-upgradeability-disciplines.md) for more guidance.
- Review the design considerations in the Azure Arc-enabled Kubernetes [governance and security disciplines design area](../arc-enabled-kubernetes/eslz-arc-kubernetes-governance-disciplines.md).
- Consult [Azure Arc-enabled SQL Managed Instance security and governance disciplines](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-governance-disciplines#design-considerations) for a comprehensive overview of the security features in Azure Arc-enabled SQL Managed Instance.
- Other security considerations for your solution are described in the [security design principles][waf-principles-security] section in the Microsoft Azure Well-Architected Framework.

### Cost optimization

- **Service tier** Define the business requirements to determine the most appropriate service tier. In addition, consider the extra infrastructure needed to support [business continuity and disaster recovery](./eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery.md).
- **Connectivity modes** How usage and billing information is sent to Azure varies depending on whether one is using the directly connected or indirectly connected mode. If you're using the indirectly connected mode, consider how the usage and billing information is regularly sent to Azure.
- **Reserved instances** Based on the expected time for Arc-enabled SQL MI, consider whether pay-as-you-go, a one-year reserved instance, or a three-year reserved instance offers savings.
- **Azure Hybrid Benefit** For SQL Server, Azure Hybrid Benefits offers savings on both service tiers of Arc-enabled SQL MI.
- Consult [Cost governance for Azure Arc-enabled SQL Managed Instance](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-cost-governance) for additional Azure Arc cost optimization guidance.
- Other cost optimization considerations for your solution are described in the [Principles of cost optimization][waf-principles-cost-opt] section in the Microsoft Azure Well-Architected Framework.
- Use the [Azure pricing calculator][pricing-calculator] to estimate costs.
- When deploying the Jumpstart ArcBox for DataOps reference implementation for this architecture, keep in mind ArcBox resources generate Azure Consumption charges from the underlying Azure resources. These resources include core compute, storage, networking and auxiliary services.

### Operational excellence

- Automate the deployment of your Arc-enabled servers environment. The [reference implementation](#deploy-this-scenario) of this architecture is fully automated using a combination of Azure ARM templates, VM extensions, Azure Policy configurations, and PowerShell scripts. You can also reuse these artifacts for your own deployments. Consult [Automation disciplines for Azure Arc-enabled servers][caf-arc-servers-automation] for additional Arc-enabled servers automation guidance in the Cloud Adoption Framework (CAF).
- There are several options available in Azure to automate the [onboarding of Arc-enabled servers][Arc-agent-deployment-options]. To onboard at scale, use a service principal and deploy via your organizations existing automation platform.
- VM extensions can be deployed to Arc-enabled servers to simplify the management of hybrid servers throughout their lifecycle. Consider automating the deployment of VM extensions via Azure Policy when managing servers at scale.
- Enable patch and Update Management in your onboarded Azure Arc-enabled servers to ease OS lifecycle management.
- Review [Azure Arc Jumpstart Unified Operations Use Cases][Arc Jumpstart unifiedops scenarios] to learn about additional operational excellence scenarios for Azure Arc-enabled servers.
- Other operational excellence considerations for your solution are described in the [Operational excellence design principles][waf-principles-operational-excellence] section in the Microsoft Azure Well-Architected Framework.

### Performance efficiency

- Before configuring your machines with Azure Arc-enabled servers, you should review the Azure Resource Manager [subscription limits][subscription-limits] and [resource group limits][rg-limits] to plan for the number of machines to be connected.
- A phased deployment approach as described in the [deployment guide](/azure/azure-arc/servers/plan-at-scale-deployment) can help you determine the resource capacity requirements for your implementation.
- Use Azure Monitor to collect data directly from your Azure Arc-enabled servers into a Log Analytics workspace for detailed analysis and correlation. Review the [deployment options](/azure/azure-arc/servers/concept-log-analytics-extension-deployment) for the Azure Monitor agents.
- Additional performance efficiency considerations for your solution are described in the [Performance efficiency principles][waf-principles-performance-efficiency] section in the Microsoft Azure Well-Architected Framework.

## Deploy this scenario

The reference implementation of this architecture can be found in the [Jumpstart ArcBox for IT Pros](https://azurearcjumpstart.io/azure_jumpstart_arcbox/itpro), included as part of the [Arc Jumpstart](https://azurearcjumpstart.io/) project. ArcBox is designed to be completely self-contained within a single Azure subscription and resource group. ArcBox makes it easy for a user to get hands-on experience with all available Azure Arc technology with nothing more than an available Azure subscription.

To deploy the reference implementation, follow the steps in the GitHub repo by selecting the **Jumpstart ArcBox for IT Pros** button below.

> [!div class="nextstepaction"]
> [Jumpstart ArcBox for IT Pros](https://azurearcjumpstart.io/azure_jumpstart_arcbox/itpro/#deployment-options-and-automation-flow)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:
- [Pieter de Bruin](https://www.linkedin.com/in/pieterjmdebruin) | Senior Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learn more about Azure Arc][Azure Arc docs]
- [Learn more about Azure Arc-enabled servers][Azure Arc-enabled servers docs]
- [Azure Arc learning path](/training/paths/manage-hybrid-infrastructure-with-azure-arc/)
- [Review Azure Arc Jumpstart scenarios][Arc Jumpstart servers scenarios] in the Arc Jumpstart
- [Review Arc-enabled servers landing zone accelerator][CAF Arc Accelerator] in CAF

## Related resources

Explore related architectures:

- [Manage configurations for Azure Arc-enabled servers](/azure/architecture/hybrid/azure-arc-hybrid-config)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)

[agent-prerequisites]: /azure/azure-arc/servers/prerequisites#azure-resource-providers
[agent-overview]: /azure/azure-arc/servers/agent-overview
[Arc-agent-deployment-options]: /azure/azure-arc/servers/deployment-options
[arc-built-in-policies]: /azure/azure-arc/servers/policy-samples
[Arc Jumpstart]: https://azurearcjumpstart.io
[Arc Jumpstart servers scenarios]: https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/
[Arc Jumpstart unifiedops scenarios]: https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/day2/
[ArcBox for IT Pros]: https://azurearcjumpstart.io/azure_jumpstart_arcbox/itpro
[ArcBox workbook]: https://azurearcjumpstart.io/azure_jumpstart_arcbox/workbook/flavors/itpro/
[architectural-diagram]: ./images/azure-arc-hybrid-config.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-arc-hybrid-config.vsdx
[architectural-diagram-ppt-source]: https://arch-center.azureedge.net/azure-arc-hybrid-config.pptx
[Azure Arc docs]: /azure/azure-arc/
[Azure Arc-enabled servers]: https://azure.microsoft.com/services/azure-arc/#infrastructure
[Azure Arc-enabled servers docs]: /azure/azure-arc/servers/overview
[Azure Automation State Configuration]: /azure/automation/automation-dsc-overview
[Azure Log Analytics]: /azure/azure-monitor/logs/log-analytics-overview
[Azure Monitor]: https://azure.microsoft.com/services/monitor/
[Azure Arc]: /azure/azure-arc
[Azure Policy Guest Configuration]: /azure/governance/policy/concepts/guest-configuration
[Azure Resource Group]: /azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group
[Azure virtual machines]: /azure/virtual-machines/
[Azure Virtual Network]: https://azure.microsoft.com/services/virtual-network/
[caf-arc-servers-automation]: /azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-automation-arc-server
[CAF Arc Accelerator]: /azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone
[windows-agent-download]: https://aka.ms/AzureConnectedMachineAgent
[microsoft-package-repo]: https://packages.microsoft.com
[agent-overview]: /azure/azure-arc/servers/agent-overview
[Azure Automation State Configuration]: /azure/automation/automation-dsc-overview
[connect-hybrid-at-scale]: /azure/azure-arc/servers/onboard-service-principal
[Hyper-V nested virtualization]: /virtualization/hyper-v-on-windows/user-guide/nested-virtualization
[manage-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[Microsoft Defender for Cloud]: https://azure.microsoft.com/services/defender-for-cloud/
[Microsoft Sentinel]: https://azure.microsoft.com/services/microsoft-sentinel/
[microsoft-package-repo]: https://packages.microsoft.com/
[networking configuration]: /azure/azure-arc/servers/agent-overview#networking-configuration
[onboard-dsc]: /azure/azure-arc/servers/onboard-dsc
[pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[rg-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits
[subscription-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#subscription-limits
[supported regions]: /azure/azure-arc/servers/overview#supported-regions
[supported operating systems]: /azure/azure-arc/servers/agent-overview#supported-operating-systems
[waf-principles-reliability]: /azure/architecture/framework/resiliency/principles
[waf-principles-security]: /azure/architecture/framework/security/security-principles
[waf-principles-cost-opt]: /azure/architecture/framework/cost/principles
[waf-principles-operational-excellence]: /azure/architecture/framework/devops/principles
[waf-principles-performance-efficiency]: /azure/architecture/framework/scalability/principles
[windows-agent-download]: https://aka.ms/AzureConnectedMachineAgent
