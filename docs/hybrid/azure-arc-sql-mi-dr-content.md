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

- Ensure that your instances of Arc-enabled SQL Managed Instance have different names for primary and secondary sites, and that the shared-name value for the sites is identical.

- Perform regular disaster recovery drills to validate the failover process.

- Create a process for initiating both manual and forced failovers.

- Monitor the health of your Arc-enabled Kubernetes clusters using [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-overview).

- Define the DNS record for the shared name of the distributed availability group in your DNS servers to avoid needing to manually create DNS records during the failover.

Review the [Azure Arc-enabled SQL Managed Instance landing zone accelerator](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery) for best practices and guidance on business continuity and disaster recovery.


## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

- In most cases, the location you select when you create the installation script should be the Azure region geographically closest to your machine's location. The rest of the data will be stored within the Azure geography containing the region you specify, which might also affect your choice of region if you have data residency requirements. If an outage affects the Azure region to which your machine is connected, the outage won't affect the Arc-enabled server. However, management operations using Azure might not be available.
- If you have multiple locations that provide a geographical-redundant service, it's best to connect the machines in each location to a different Azure region for resilience in the event of a regional outage.
- If the Azure connected machine agent stops sending heartbeats to Azure, or goes offline, you will not be able to perform operational tasks on it. Hence, it's necessary to [develop a plan for notifications and responses](/azure/azure-arc/servers/plan-at-scale-deployment#phase-3-manage-and-operate).
- Set up [resource health alerts](/azure/service-health/resource-health-alert-monitor-guide) to get notified in near real-time when resources have a change in their health status. And define a monitoring and alerting policy in [Azure Policy](/azure/governance/policy) that identifies unhealthy Azure Arc-enabled servers.
- Extend your current backup solution to Azure, or easily configure our application-aware replication and application-consistent backup that scales based on your business needs. The centralized management interface for [Azure Backup](https://azure.microsoft.com/services/backup/) and [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) makes it simple to define policies to natively protect, monitor, and manage your Arc-enabled Windows and Linux servers.
- Review the [business continuity and disaster recovery](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery) guidance to determine whether your enterprise requirements are met.
- Other reliability considerations for your solution are described in the [reliability design principles][waf-principles-reliability] section in the Microsoft Azure Well-Architected Framework.

### Security

- Appropriate Azure role-based access control (Azure RBAC) should be managed for Arc-enabled servers. To onboard machines, you must be a member of the **Azure Connected Machine Onboarding** role. To read, modify, re-onboard, and delete a machine, you must be a member of the **Azure Connected Machine Resource Administrator** role.
- Microsoft Defender for Cloud can monitor on-premises systems, Azure VMs, Azure Monitor resources, and even VMs hosted by other cloud providers. Enable Microsoft Defender for servers for all subscriptions containing Azure Arc-enabled servers for security baseline monitoring, security posture management, and threat protection.
- Microsoft Sentinel can help simplify data collection across different sources, including Azure, on-premises solutions, and across clouds using built-in connectors.
- You can use Azure Policy to manage security policies across your Arc-enabled servers, including implementing security policies in Microsoft Defender for Cloud. A security policy defines the desired configuration of your workloads and helps ensure you're complying with the security requirements of your company or regulators. Defender for Cloud policies are based on policy initiatives created in Azure Policy.
- To limit which extensions can be installed on your Arc-enabled server, you can configure the lists of extensions you wish to allow and block on the server. The extension manager will evaluate all requests to install, update, or upgrade extensions against the allowlist and blocklist to determine if the extension can be installed on the server.
- [Azure Private Link](/azure/private-link/private-link-overview) allows you to securely link Azure PaaS services to your virtual network using private endpoints. You can connect your on-premises or multicloud servers with Azure Arc and send all traffic over an Azure ExpressRoute or site-to-site VPN connection instead of using public networks. You can use a Private Link Scope model to allow multiple servers or machines to communicate with their Azure Arc resources using a single private endpoint.
- Consult [Azure Arc-enabled servers security overview](/azure/azure-arc/servers/security-overview) for a comprehensive overview of the security features in Azure Arc-enabled server.
- Other security considerations for your solution are described in the [security design principles][waf-principles-security] section in the Microsoft Azure Well-Architected Framework.

### Cost optimization

- Azure Arc control plane functionality is provided at no extra cost. This includes support for resource organization through Azure management groups and tags, and access control through Azure role-based access control (RBAC). Azure services used in conjunction to Azure Arc-enabled servers incur costs according to their usage.
- Consult [Cost governance for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-cost-governance) for additional Azure Arc cost optimization guidance.
- Other cost optimization considerations for your solution are described in the [Principles of cost optimization][waf-principles-cost-opt] section in the Microsoft Azure Well-Architected Framework.
- Use the [Azure pricing calculator][pricing-calculator] to estimate costs.
- When deploying the Jumpstart ArcBox for IT Pros reference implementation for this architecture, keep in mind ArcBox resources generate Azure Consumption charges from the underlying Azure resources. These resources include core compute, storage, networking and auxiliary services.

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
