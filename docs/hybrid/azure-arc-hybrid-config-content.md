

This reference architecture illustrates how Azure Arc enables you to manage, govern, and secure servers across on-premises, multiple cloud, and edge scenarios.

:::image type="content" source="./images/azure-arc-hybrid-config.png" alt-text="An Azure Arc hybrid server topology diagram with Arc-enabled servers connected to Azure." lightbox="./images/azure-arc-hybrid-config.png" :::

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

**TODO** - update Visio file (https://arch-center.azureedge.net/azure-arc-hybrid-config.vsdx) to reflect revised Jumpstart ArcBox for IT Pros image.

Typical uses for this architecture include:

- Organize, govern, and inventory large groups of virtual machines (VMs) and servers across multiple environments.
- Enforce organization standards and assess compliance at scale for all your resources anywhere with Azure Policy.
- Easily deploy supported VM extensions to Arc-enabled servers.
- Configure and enforce Azure Policy for VMs and servers hosted across multiple environments.

## Architecture

The architecture consists of the following components:

- **[Azure Arc-enabled servers][Azure Arc-enabled servers]**. Azure Arc-enabled servers enables you to connect Azure to your Windows and Linux machines hosted outside of Azure on your corporate network. When a server is connected to Azure, it becomes an Arc-enabled server and is treated as a resource in Azure. Each Arc-enabled server has a Resource ID, a managed system identity, and is managed as part of a resource group inside a subscription. Arc-enabled servers benefit from standard Azure constructs such as inventory, policy, tags, and Azure Lighthouse.
- **[Azure Policy Guest Configuration][Azure Policy Guest Configuration]**. Azure Policy Guest Configuration can audit operating systems and machine configuration both for machines running in Azure and Arc-enabled servers running on-premises or in other clouds.
- **[Azure Monitor][Azure Monitor]**. Azure Monitor enables you to track performance and events for systems running in Azure, on-premises, or in other clouds.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Connecting machines to Azure Arc

You can connect any other physical or virtual machine running Windows or Linux to Azure Arc. To use Azure Arc to connect the machine to Azure, you need to install the Azure Connected Machine agent on each machine that you plan to connect using Azure Arc.

Once configured, the Connected Machine agent sends a regular heartbeat message every five minutes to Azure. When the heartbeat is not received, Azure assigns the machine Offline status, which is reflected in the portal within 15 to 30 minutes. Upon receiving a subsequent heartbeat message from the Connected Machine agent, its status will automatically change to Connected.

#### Manual installation

You can enable Azure Arc-enabled servers for one or a few Windows or Linux machines in your environment by using the Windows Admin Center tool set or by performing a set of steps manually. You can download the [Windows agent Windows Installer package][windows-agent-download] from the Microsoft Download Center or the Linux agent from [Microsoft's package repository][microsoft-package-repo].

For more information, see [Overview of Azure Arc-enabled servers agent][agent-overview].

#### Script-based installation

You can perform automated agent installation by running a template script that you download from the Azure portal. This script automates the download and installation of both agents.

This method requires that you have administrator permissions on the machine to install and configure the agent. You can use the root account on Linux, or on Windows, you can use an account that is a member of the local administrators group.

#### Connect machines at scale using a service principal

To connect the machines to Azure Arc-enabled servers, you can use an Azure Active Directory service principal instead of using your privileged identity to interactively connect the machine. A service principal is a special, limited management identity that has the minimum permission necessary to connect machines to Azure using the **azcmagent** command. Using a service principal is safer than using a higher privileged account like a Tenant Administrator and follows access control security best practices. The service principal is only used during onboarding. For more information, see [Connect hybrid machines to Azure at scale][connect-hybrid-at-scale].

#### Installation using Windows PowerShell DSC

You can automate agent installation and configuration for a Windows computer by using Windows PowerShell Desired State Configuration (DSC), Windows PowerShell, the AzureConnectedMachine DSC Module, and a service principal for onboarding. For more information, see [How to install the Connected Machine agent using Windows PowerShell DSC][onboard-dsc].

### Manage VM extensions

Azure Arc-enabled servers enables you to deploy a supported subset of Azure VM extensions to non-Azure Windows and Linux VMs, providing a consistent extension management experience between Azure and non-Azure VMs. VM extensions allow you to:

- Collect log data for analysis with Azure Monitor Logs enabled through the Log Analytics agent VM extension.
- Analyze the performance of your Windows and Linux VMs using Azure Monitor and monitor their processes and dependencies on other resources and external processes.
- Download and execute scripts on Arc-enabled servers using the Custom Script extension.

For more information, see [VM extension management with Azure Arc-enabled servers][manage-vm-extensions].

### Implement Azure Policy Guest Configuration

Azure Policy Guest Configuration can audit settings inside a machine, both for machines running in Azure and Arc-enabled servers. For example, you can audit settings such as:

- Operating system configuration
- Application configuration or presence
- Environment settings

There are several [Azure Policy built-in definitions for Azure Arc][arc-built-in-policies]. These policies provide auditing and configuration settings for both Windows and Linux-based machines.

### Implement Update Management

You can perform update management for Arc-enabled servers.  Update management in Azure Automation enables you to manage operating system updates and quickly assess the status of available updates on all agent machines. You can also manage the process of installing required updates for servers.

### Implement Change Tracking and Inventory

You can use Azure Automation Change Tracking and Inventory for Arc-enabled servers to determine what software is installed in your environment. You can collect and observe inventory for software, files, Linux daemons, Windows services, and Windows Registry keys on your computers. Tracking the configurations of your machines can help you pinpoint operational issues across your environment and better understand the state of your machines.

### Implement Azure Monitor

You can use Azure Monitor to monitor your VMs, virtual machine scale sets, and Azure Arc machines at scale. Azure Monitor analyzes the performance and health of your Windows and Linux VMs and monitors their processes and dependencies on other resources and external processes. It includes support for monitoring performance and application dependencies for VMs that are hosted on-premises or in another cloud provider.

### Implement Microsoft Sentinel

You can use [Microsoft Sentinel](/azure/sentinel/overview) to deliver intelligent security analytics and threat intelligence across the enterprise, providing a single solution for alert detection, threat visibility, proactive hunting, and threat response. Microsoft Sentinel is a scalable, cloud-native, security information event management (SIEM), and security orchestration automated response (SOAR) solution that enables several scenarios including:

- Collect data at cloud scale across all users, devices, applications, and infrastructure, both on-premises and in multiple clouds.
- Detect previously undetected threats and minimize false positives.
- Investigate threats with artificial intelligence and hunt for suspicious activities at scale.
- Respond to incidents rapidly with built-in orchestration and automation of common tasks.

### Topology and network considerations

The Connected Machine agent for Linux and Windows communicates outbound securely to Azure Arc over TCP port **443**. If the machine connects through a firewall or proxy server to communicate over the internet, review the required URLs and service tags found on the Azure Arc Agent [Networking configuration][networking configuration] page.


**TODO:** align the following RA "considerations" sections w/WAF "pillars" (Reliability, Security, Cost Optimization, Operational excellence, Performance efficiency). Also note the RA Performance and Scalability considerations sections are missing below.

## Availability considerations

- In most cases, the location you select when you create the installation script should be the Azure region geographically closest to your machine's location. The rest of the data will be stored within the Azure geography containing the region you specify, which might also affect your choice of region if you have data residency requirements. If an outage affects the Azure region to which your machine is connected, the outage will not affect the Arc-enabled server, but management operations using Azure might not be able to complete. For resilience in the event of a regional outage, if you have multiple locations that provide a geographical-redundant service, it's best to connect the machines in each location to a different Azure region.
- Ensure that Azure Arc-enabled servers is supported in your regions by checking [supported regions][supported regions].
- Ensure that services referenced in the Architecture section are supported in the region to which Azure Arc-enabled servers is deployed.

## Manageability considerations

- Consult the list of supported [operated systems][supported operating systems] on the Azure Arc-enabled servers agent overview page.
- Before configuring your machines with Azure Arc-enabled servers, you should review the Azure Resource Manager [subscription limits][subscription-limits] and [resource group limits][rg-limits] to plan for the number of machines to be connected.

## Security considerations

- Appropriate Azure role-based access control (Azure RBAC) access should be managed for Arc-enabled servers. To onboard machines, you must be a member of the **Azure Connected Machine Onboarding** role. To read, modify, re-onboard, and delete a machine, you must be a member of the **Azure Connected Machine Resource Administrator** role.
- You can use Azure Policy to manage security policies across your Arc-enabled servers, including implementing security policies in Microsoft Defender for Cloud. A security policy defines the desired configuration of your workloads and helps ensure you're complying with the security requirements of your company or regulators. Defender for Cloud policies are based on policy initiatives created in Azure Policy.

## Cost considerations

- Use the [Azure pricing calculator][pricing-calculator] to estimate costs.
- Other considerations are described in the [Principles of cost optimization][principles-cost-opt] section in the Microsoft Azure Well-Architected Framework.

## Deploy the solution

**TODO:** Complete this section

Deployment assets will come from [Jumpstart ArcBox for IT Pros](https://azurearcjumpstart.io/azure_jumpstart_arcbox/itpro/)

## Next steps

- [Learn more about Azure Arc][Azure Arc]
- [Learn more about Azure virtual machines][Azure virtual machines]
- [Learn more about Azure Policy Guest Configuration][Azure Policy Guest Configuration]
- [Learn more about Azure Monitor][Azure Monitor]
- [Overview of Azure Arc-enabled servers agent][agent-overview]

[architectural-diagram]: ./images/azure-arc-hybrid-config.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-arc-hybrid-config.vsdx
[Azure Arc]: /azure/azure-arc/
[Azure Arc-enabled servers]: /azure/azure-arc/servers/overview
[Azure Policy Guest Configuration]: /azure/governance/policy/concepts/guest-configuration
[Azure Monitor]: /azure/azure-monitor/
[Azure virtual machines]: /azure/virtual-machines/
[windows-agent-download]: https://aka.ms/AzureConnectedMachineAgent
[microsoft-package-repo]: https://packages.microsoft.com/
[agent-overview]: /azure/azure-arc/servers/agent-overview
[Azure Automation State Configuration]: /azure/automation/automation-dsc-overview
[connect-hybrid-at-scale]: /azure/azure-arc/servers/onboard-service-principal
[manage-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[networking configuration]: /azure/azure-arc/servers/agent-overview#networking-configuration
[supported regions]: /azure/azure-arc/servers/overview#supported-regions
[supported operating systems]: /azure/azure-arc/servers/agent-overview#supported-operating-systems
[subscription-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#subscription-limits
[rg-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits
[arc-built-in-policies]: /azure/azure-arc/servers/policy-samples
[pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[principles-cost-opt]: /azure/architecture/framework/cost/overview
[onboard-dsc]: /azure/azure-arc/servers/onboard-dsc
