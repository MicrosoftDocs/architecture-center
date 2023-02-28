This reference architecture illustrates how Azure Arc enables you to manage, govern, and secure servers across on-premises, multicloud, and edge scenarios, and is based on the Azure Arc Jumpstart [ArcBox for IT Pros](https://azurearcjumpstart.io/azure_jumpstart_arcbox/itpro/) implementation. ArcBox is a solution that provides an easy to deploy sandbox for all things Azure Arc. ArcBox for IT Pros is a version of ArcBox that is intended for users who want to experience Azure Arc-enabled servers capabilities in a sandbox environment.

## Architecture

:::image type="content" alt-text="An Azure Arc hybrid server topology diagram with Arc-enabled servers connected to Azure." source="./images/azure-arc-hybrid-config.svg" lightbox="./images/azure-arc-hybrid-config.svg":::

*Download a [PowerPoint file][architectural-diagram-ppt-source] of this architecture.*

### Components

The architecture consists of the following components:

- An **[Azure Resource Group][Azure Resource Group]** is a container that holds related resources for an Azure solution. The resource group can include all the resources for the solution, or only those resources that you want to manage as a group.
- **[ArcBox workbook][ArcBox workbook]** is an Azure Monitor workbook, which provides a single pane of glass for monitoring and reporting on ArcBox resources. The workbook acts as a flexible canvas for data analysis and visualization in the Azure portal, gathering information from several data sources from across ArcBox and combining them into an integrated interactive experience.
- **[Azure Monitor][Azure Monitor]** enables you to track performance and events for systems running in Azure, on-premises, or in other clouds.
- **[Azure Policy guest configuration][Azure Policy Guest Configuration]** can audit operating systems and machine configuration both for machines running in Azure and Arc-enabled servers running on-premises or in other clouds.
- **[Azure Log Analytics][Azure Log Analytics]** is a tool in the Azure portal to edit and run log queries from data collected by Azure Monitor Logs and interactively analyze their results. You can use Log Analytics queries to retrieve records that match particular criteria, identify trends, analyze patterns, and provide various insights into your data.
- **[Microsoft Defender for Cloud][Microsoft Defender for Cloud]** is a cloud security posture management (CSPM) and cloud workload protection (CWP) solution. Microsoft Defender for Cloud finds weak spots across your cloud configuration, helps strengthen the overall security posture of your environment, and can protect workloads across multicloud and hybrid environments from evolving threats.
- **[Microsoft Sentinel][Microsoft Sentinel]** is a scalable, cloud-native, security information and event management (SIEM) and security orchestration, automation, and response (SOAR) solution. Microsoft Sentinel delivers intelligent security analytics and threat intelligence across the enterprise, providing a single solution for attack detection, threat visibility, proactive hunting, and threat response.
- **[Azure Arc-enabled servers][Azure Arc-enabled servers]** enables you to connect Azure to your Windows and Linux machines hosted outside of Azure on your corporate network. When a server is connected to Azure, it becomes an Arc-enabled server and is treated as a resource in Azure. Each Arc-enabled server has a Resource ID, a managed system identity, and is managed as part of a resource group inside a subscription. Arc-enabled servers benefit from standard Azure constructs such as inventory, policy, tags, and Azure Lighthouse.
- **[Hyper-V nested virtualization][Hyper-V nested virtualization]** is used by Jumpstart ArcBox for IT Pros to host Windows Server virtual machines inside of an Azure virtual machine. This provides the same experience as using physical Windows Server machines, but without the hardware requirements.
- **[Azure Virtual Network][Azure Virtual Network]** provides a private network that enables components within the Azure Resource Group to communicate, such as the virtual machines.

## Scenario details

### Potential use cases

Typical uses for this architecture include:

- Organize, govern, and inventory large groups of virtual machines (VMs) and servers across multiple environments.
- Enforce organization standards and assess compliance at scale for all your resources anywhere with Azure Policy.
- Easily deploy supported VM extensions to Arc enabled servers.
- Configure and enforce Azure Policy for VMs and servers hosted across multiple environments.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Configure Azure Arc Connected Machine agent

You can connect any other physical or virtual machine running Windows or Linux to Azure Arc. Before onboarding machines, be sure to complete the [Connected machine agent prerequisites][agent-prerequisites], which includes registering the Azure resource providers for Azure Arc-enabled servers. To use Azure Arc to connect the machine to Azure, you need to install the Azure Connected Machine agent on each machine that you plan to connect using Azure Arc. For more information, see [Overview of Azure Arc-enabled servers agent][agent-overview].

Once configured, the Connected Machine agent sends a regular heartbeat message every five minutes to Azure. When the heartbeat isn't received, Azure assigns the machine Offline status, which is reflected in the portal within 15 to 30 minutes. Upon receiving a subsequent heartbeat message from the Connected Machine agent, its status will automatically change to Connected.

There are several options available in Azure to connect your Windows and Linux machines:

- Manual installation: Azure Arc-enabled servers can be enabled for one or a few Windows or Linux machines in your environment by using the Windows Admin Center tool set or by performing a set of steps manually.
- Script-based installation: You can perform automated agent installation by running a template script that you download from the Azure portal.
- Connect machines at scale using a service principal: To onboard at scale, use a service principal and deploy via your organizations existing automation.
- Installation using Windows PowerShell DSC

Consult the [Azure Connected Machine agent deployment options](/azure/azure-arc/servers/deployment-options) for comprehensive documentation on the various deployment options available.

### Enable Azure Policy guest configuration

Azure Arc-enabled servers support [Azure Policy](/azure/governance/policy/overview) at the Azure resource management layer, and also within the individual server machine using [guest configuration policies](/azure/governance/policy/concepts/guest-configuration). Azure Policy guest configuration can audit settings inside a machine, both for machines running in Azure and Arc-enabled servers. For example, you can audit settings such as:

- Operating system configuration
- Application configuration or presence
- Environment settings

There are several [Azure Policy built-in definitions for Azure Arc][arc-built-in-policies]. These policies provide auditing and configuration settings for both Windows and Linux-based machines.

### Enable Azure Update Management

Update Management. You can perform update management for Arc-enabled servers. [Update management](/azure/automation/update-management/overview) in Azure Automation enables you to manage operating system updates and quickly assess the status of available updates on all agent machines. You can also manage the process of installing required updates for servers.

Change Tracking and Inventory. [Azure Automation Change Tracking and Inventory](/azure/automation/change-tracking/overview) for Arc-enabled servers allows you to determine what software is installed in your environment. You can collect and observe inventory for software, files, Linux daemons, Windows services, and Windows Registry keys. Tracking the configurations of your machines can help you pinpoint operational issues across your environment and better understand the state of your machines.

### Monitor Azure Arc-enabled servers

You can use Azure Monitor to monitor your VMs, virtual machine scale sets, and Azure Arc machines at scale. Azure Monitor analyzes the performance and health of your Windows and Linux VMs, and monitors their processes and dependencies on other resources and external processes. It includes support for monitoring performance and application dependencies for VMs that are hosted on-premises or in another cloud provider.

The Azure Monitor agents should be automatically deployed to Azure Arc-enabled Windows and Linux servers, through [Azure Policy](/azure/azure-monitor/best-practices). Review and understand how the [Log Analytics agent](/azure/azure-monitor/agents/log-analytics-agent) operates and collects data before deployment.

Design and plan your Log Analytics workspace deployment. It will be the container where data is collected, aggregated, and later analyzed. A Log Analytics workspace represents a geographical location of your data, data isolation, and scope for configurations like data retention. Use a single Azure Monitor Log Analytics workspace as described in the [management and monitoring best practices](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management) of Cloud Adoption Framework.

### Secure Azure Arc-enabled servers

Use Azure RBAC to control and manage the permission for Azure Arc-enabled servers managed identities and perform periodic access reviews for these identities. Control privileged user roles to avoid system-managed identities being misused to gain unauthorized access to Azure resources.

Consider using [Azure Key Vault](/azure/key-vault/general/basic-concepts) to manage certificates on your Azure Arc-enabled servers. The key vault VM extension allows you to manage the certificate lifecycle on Windows and Linux machines.

[Connect Azure Arc-enabled servers to Microsoft Defender for Cloud](/azure/cloud-adoption-framework/manage/hybrid/server/best-practices/arc-security-center).This helps you start collecting security-related configurations and event logs so you can recommend actions and improve your overall Azure security posture.

[Connect Azure Arc-enabled servers to Microsoft Sentinel](/azure/cloud-adoption-framework/manage/hybrid/server/best-practices/arc-azure-sentinel). This enables you to start collecting security-related events and start correlating them with other data sources.

### Validate network topology

The Connected Machine agent for Linux and Windows communicates outbound securely to Azure Arc over TCP port **443**. The Connected Machine agent can connect to the Azure control plane using the following methods:

- [Direct connection to Azure public endpoints](/azure/azure-arc/servers/agent-overview#networking-configuration), optionally from behind a firewall or a proxy server.
- [Azure Private Link](/azure/azure-arc/servers/private-link-security#restrictions-and-limitations) using a Private Link Scope model to allow multiple servers or machines to communicate with their Azure Arc resources using a single private endpoint.

Consult [Network topology and connectivity for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-arc-servers-connectivity) for comprehensive networking guidance for your Arc-enabled servers implementation.

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
