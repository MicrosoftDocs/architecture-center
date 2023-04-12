This reference architecture illustrates how to design a hybrid update management solution to manage updates on both Microsoft Azure and on-premises Windows and Linux computers.

## Architecture

[ ![Azure Update management is configuration component of Azure Automation. Windows and Linux computers, both in Azure and on-premises, send assessment information about missing updates to the Log Analytics workspace. Azure Automation then uses that information to create a schedule for automatic deployment of the missing updates.](./images/azure-update-mgmt.svg)](./images/azure-update-mgmt.svg#lightbox)

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Workflow

The architecture consists of the following services:

- **Log Analytics workspace:** A [Log Analytics workspace][1] is a data repository for log data that's collected from resources that run in Azure, on-premises, or in another cloud provider.
- **Automation Hybrid Worker solution:** Create [Hybrid Runbook Workers][2] to run [Azure Automation][3] runbooks on your Azure and non-Azure computers.
- **Automation account:** This is a cloud service that automates configuration and management across your Azure and non-Azure environments.
- **Hybrid Runbook Worker:** This is a computer that's configured with the Hybrid Runbook Worker feature and can run runbooks directly on the computer and against the resources in the local environment.
- **Hybrid Runbook Worker group:** It's a group of Hybrid Runbook Workers used for high availability.
- **Runbook:** This is a collection of one or more linked activities that together automate a process or operation.
- **On-premises computers and VMs:** These are on-premises computers and VMs with Windows or Linux operating systems that reside on-premises.
- **Azure VMs:** Azure VMs include Windows or Linux VMs that are hosted in Azure.

### Components

- [Azure Automation](https://azure.microsoft.com/services/automation)
- [Azure Virtual Machines](https://azure.microsoft.com/free/virtual-machines)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)
- [Azure Arc](https://azure.microsoft.com/services/azure-arc)

## Scenario details

Typical uses for this architecture include:

- Managing updates across on-premises and in Azure using the Update Management component of Automation Account.
- Using scheduled deployments to orchestrate the installation of updates within a defined maintenance window.

## Recommendations

The following recommendations apply for most scenarios. Follow them unless you have a specific requirement that overrides them.

### Update Management

[Update Management][4] is a configuration component of Automation. Windows and Linux computers, both in Azure and on-premises, send assessment information about missing updates to the Log Analytics workspace. Azure Automation then uses that information to create a schedule for automatic deployment of the missing updates.

The following steps highlight the actual implementation:

1. Create a Log Analytics workspace.
1. Create an Automation account.
1. Link the Automation account with the Log Analytics workspace.
1. Enable Update Management for Azure VMs.
1. Enable Update Management for non-Azure VMs.

### Create a Log Analytics workspace

Before you create a Log Analytics workspace, ensure that you have at least Log Analytics Contributor role permissions.

You can have more than one Log Analytics workspace for data isolation or for geographic location of data storage, but the Log Analytics agent can be configured to report to one Log Analytics workspace. For more information, review the [Designing your Azure Monitor Logs deployment][5] before you create the workspace.

Use the following procedure to create a Log Analytics workspace:

1. Sign in to the Azure portal at [**https://portal.azure.com**][6].
1. In the Azure portal, select **Create a resource**.
1. In the **Search the Marketplace** box, enter **Log Analytics**. As you begin entering this text, the list filters based on your input. Select **Log Analytics workspaces**.
1. Select **Create**, and then configure the following items:
    1. Select a different **Subscription** in the drop-down list if the default selection isn't appropriate.
    1. For the **Resource Group**, choose to use an existing resource group that's already set up or create a new one.
    1. Provide a unique name for the new **Log Analytics workspace**, such as *HybridWorkspace-yourname*
    1. Select the **Location** for your deployment.
    1. Select **pricing tier** to proceed to further customizations.
    1. If you're creating a workspace in a subscription that was created after April 2, 2018, it'll automatically use the **Per GB** pricing plan, and the option to select a pricing tier won't be available. If you're creating a workspace for an existing subscription that was created before that date or for a subscription that was tied to an existing Enterprise Agreement enrollment, select your preferred pricing tier. For more information about the particular tiers, refer to [Log Analytics Pricing details][7].
    1. Select **Tags** and optionally provide a name and value for categorization of the resources.
    1. Select **Review + Create**.
1. After providing the required information in the **Log Analytics workspace** pane, select **Create**.

### Create an Automation account

After the Automation Hybrid Worker solution has been added to the Log Analytics workspace, proceed with creation of the Automation account. Refer to [Supported regions for linked Log Analytics workspace][8] to select the regions for Automation account and Log Analytics workspace. It's important that you create the Automation account based on the region mapping document and preferably in the same resource group as the Log Analytics workspace.

Use the following procedure to create an Automation account:

1. In the Azure portal, select **Create a resource**.
1. In the **Search the Marketplace** box, enter **Automation**. As you begin entering this text, the list filters based on your input. Select **Automation**, and then select **Create**.
1. Select **Create**, and then configure the following items:
    1. Provide the **Name** for the Automation account, such as *hybrid-auto*.
    1. Select a different **Subscription** in the drop-down list if the default selection isn't appropriate.
    1. For the **Resource Group**, choose the same resource group in which you want to create the automation account.
    1. Select the **Location** based on the region mapping document.
    1. **Create Azure Run As account** is optional because this only provides authentication with Azure to manage Azure resources from Automation runbooks.
1. After providing the required information in the **Add Automation Account** pane, select **Create**.

### Link the Automation account with the Log Analytics workspace

Automation accounts use the Hybrid Runbook Worker components that deploy in the Log Analytics workspace. You must integrate those services before you deploy a Log Analytics agent on an on-premises computer. Currently, mappings between Log Analytics workspaces and Automation accounts are supported in several regions. For further information, refer to [Supported regions for linked Log Analytics workspace][8].

Use the following procedure to link an Automation account with a Log Analytics workspace:

1. In the Azure portal, select **All services**, and then enter **automation**. As you begin entering this text, the list filters based on your input. Select **Automation Account**, and then select the Automation account that you created earlier.
1. In the **Automation Account** pane, select **Update Management** in the **Update Management** section.
1. In the **Update Management** pane, configure the following items:
    1. Select a different **Subscription** in the drop-down list if the default selection isn't appropriate.
    1. For **Log Analytics workspace**, select your existing Log Analytics workspace; for example, *HybridWorkspace-yourname*.
1. After providing the required information in the **Update Management** pane, select **Enable**.

### Enable Update Management for Azure VMs

Enable Update Management for Azure VMs by using the following tools:

- [Azure Resource Manager template][9]. Microsoft provides a sample template that can automate creation of an Azure Log Analytics workspace, creation of an Automation account, linking the Automation account to the Log Analytics workspace, and enabling Update Management.
- [Update Management from the Azure portal][10]. Use this method when you want to update multiple VMs that reside in different regions.
- [Update Management from an Azure VM][11]. This will configure updates for a selected VM.
- [Update Management from an Automation account][12]. Use this method when you want to update both Azure and non-Azure computers and VMs at the same time.
- [Update Management from a runbook][13]. Use this method to enable Update Management as an automated procedure combined with other automation activities.

Use the following procedure to enable Update Management for Azure VMs:

1. In the Azure portal, select **All services**, and then enter **automation**. As you begin entering this text, the list filters based on your input. Select **Automation Account**, and then select the Automation account that you created earlier.
1. In the **Automation Account** pane, select **Update Management** in the **Update Management** section.
1. In the **Update Management** pane, select **Add Azure VMs**, select one or more VMs that are ready for Update Management, and then select **Enable**.

### Deploy the Log Analytics agent and connect to a Log Analytics workspace

Deploying a Hybrid Runbook Worker component is part of the deployment of a Log Analytics agent.

If you test the solution by using an Azure VM, you can install the Log Analytics agent and enroll the VM in an existing Log Analytics workspace by using a VM extension for both [Linux][14] and [Windows][15]. You can also deploy the agent by using Azure Automation Desired State Configuration, a Windows PowerShell script, or by using a Resource Manager template for VMs. For more information, refer to [Connect Windows computers to Azure Monitor][16].

For non-Azure VMs, deploy the agent by using a manual or automated process both on physical Windows and Linux computers or VMs that are in your environment.

For Windows computers, configure the agent to communicate with the Log Analytics service by using the Transport Layer Security (TLS) 1.2 protocol. Refer to [Connect Windows computers to Azure Monitor][17] for a detailed explanation of the deployment procedure.

The Log Analytics agent for Linux can be deployed:

- [Manually][18] by using a shell script bundle that contains Debian and Red Hat Package Manager (RPM) packages for each of the agent components. This is recommended when a Linux computer doesn't have internet connectivity and will communicate with the Log Analytics service through the [Log Analytics gateway][19].
- By using a [wrapper-script][20] that's hosted on GitHub when the computer has connectivity to the internet.

The Log Analytics agent must be configured to communicate with a Log Analytics workspace by using the [workspace ID and key][21] of the Log Analytics workspace.

Use the following procedure to deploy a Log Analytics agent and connect to a Log Analytics workspace:

1. In the Azure portal, search for and select **Log Analytics workspaces**.
1. In your list of Log Analytics workspaces, select the workspace that the agent uses for reporting.
1. Select **Agents management**.
1. Copy and paste the **Workspace ID** and **Primary Key** into your favorite editor.
1. In your Log Analytics workspace, from the **Windows Servers** page that you browsed to earlier, select the appropriate **Download Windows Agent** version to download based on the processor architecture of the Windows operating system.
1. Run **Setup** to install the agent on your computer.
1. On the **Welcome** page, select **Next**.
1. On the **License Terms** page, read the license, and then select **I Agree**.
1. On the **Destination Folder** page, change or keep the default installation folder, and then select **Next**.
1. On the **Agent Setup Options** page, choose to connect the agent to Azure Log Analytics, and then select **Next**.
1. On the **Azure Log Analytics** page, perform the following steps:
    1. Paste the **Workspace ID** and **Workspace Key (Primary Key)** that you copied earlier. If the computer reports to a Log Analytics workspace in a Microsoft Azure Government cloud, select **Azure US Government** in the **Azure Cloud** drop-down list.
    1. If the computer needs to communicate through a proxy server to the Log Analytics service, select **Advanced**, and then provide the URL and port number of the proxy server. If your proxy server requires authentication, enter the username and password to authenticate with the proxy server, and then select **Next**.
1. Select **Next** after you finish providing the necessary configuration settings.

### Enable Update Management for non-Azure computers

Enabling Update Management on non-Azure computers has the following prerequisites:

- Deploy the Log Analytics agent and connect to a Log Analytics workspace.

Previous procedures explain how to configure those prerequisites.

After installing the Log Analytics agent on an on-premises computer, enable Update Management in the Azure portal by using the following procedure:

1. In the Azure portal, select **All services**, and then enter **automation**. As you begin entering this text, the list filters based on your input. Select **Automation Account**, and then select the Automation account that you created earlier.
1. In the **Automation Account** pane, select **Update Management** in the **Update Management** section.
1. In the **Update Management** pane, select **Manage machines**, and then select computers that are listed and have been configured to send log data to the Log Analytics workspace.
1. Select **Enable** to finish the configuration of Update Management on non-Azure machines.

Each Windows computer managed by Update Management is listed in the **Hybrid Worker groups** pane as a System Hybrid Worker group for the Automation account. Use these groups only for deploying updates, not for targeting the groups with runbooks for automated tasks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Manageability

#### Manage updates for Azure VMs and non-Azure machines

Update assessment for all missing updates that both Azure VMs and non-Azure computers require is visible in the **Update Management** section of your Automation account.

Schedule an update deployment by using the Azure portal or by using PowerShell, which creates schedule assets that are linked to the **Patch-MicrosoftOMSComputers** runbook.

Use the following procedure to schedule a new update deployment:

1. In your Automation account, go to **Update management** under **Update management**, and then select **Schedule update deployment**.

1. Under **New update deployment**, use the **Name** box to enter a unique name for your deployment.

1. Select the operating system to target for the update deployment.
1. In the **Groups to update** pane, define a query that combines subscription, resource groups, locations, and tags to build a dynamic group of Azure VMs to include in your deployment. To learn more, refer to [Use dynamic groups with Update Management][22].
1. In the **Machines to update** pane, select a saved search, an imported group, or pick **Machines** from the drop-down menu, and then select individual machines.
1. Use the **Update classifications** drop-down menu to specify [update classifications][23] for products.
1. Use the **Include/exclude updates** pane to select specific updates for deployment.
1. Select **Schedule settings** to define a time when the update deployment will run on computers.
1. Use the **Recurrence** box to specify if the deployment occurs once or uses a recurring schedule, and then select **OK**.
1. In the **Pre-scripts + Post-scripts (Preview)** region, select the scripts to run before and after your deployment. To learn more, refer to [Manage pre-scripts and post-scripts][24].
1. Use the **Maintenance window (minutes)** box to specify the amount of time that's allowed for updates to install.
1. Use the **Reboot options** box to specify the way to handle reboots during deployment.
1. When you finish configuring the deployment schedule, select **Create**.

Results of a completed update deployment are visible in the **Update Management** pane on the **History** tab.

#### Configure Windows Update settings

Azure Update Management depends on Windows Update Client to download and install updates either from Windows Update (default setting) or from Windows Server Update Server. Configure Windows Update Client settings to connect to Windows Server Update Services (WSUS) by using:

- Local Group Policy Editor
- Group Policy
- PowerShell
- Directly editing the registry

For more information, refer to how to [configure Windows Update settings][25].

#### Integrate Update Management with Microsoft Endpoint Configuration Manager

The Software Update Management cycle can integrate with Microsoft Endpoint Configuration Manager for customers that are already using this product to manage PCs, servers, and mobile devices.

To integrate Software Update Management with Endpoint Configuration Manager, first integrate Endpoint Configuration Manager with Azure Monitor logs and import the collections in the Log Analytics workspace.

For details, refer to [Connect Configuration Manager to Azure Monitor][26].

To manage updates on local computers, configure them with:

- The Endpoint Configuration Manager client.
- The Log Analytics agent, which is configured to report to a Log Analytics workspace that's enabled for Update Management.
- Windows agents that are configured to communicate with WSUS or have access to Microsoft Update.

To manage updates on computers with Endpoint Configuration Manager, deploy the following roles on the Endpoint Configuration Manager computer:

- Management point. This site system role manages clients with a policy that contains configuration settings and service location information.
- Distribution point. This contains source files for clients.
- Software update point. This is a role on the server that's hosting WSUS.

Manage software updates by using:

- Endpoint Configuration Manager
- Azure Automation

Partner updates on Windows machines can be deployed from a custom repository that [System Center Updates Publisher][27] (SCUP) provides. SCUP can import custom updates either in standalone WSUS or integrated with Endpoint Configuration Manager.

For more information, refer to [Integrate Update Management with Windows Endpoint Configuration Manager][28].

#### Deploy the Log Analytics agent by using a PowerShell script

To accelerate deployment of the Log Analytics agent with the Hybrid Worker role running on a Windows computer, use the **New-OnPremiseHybridWorker.ps1** PowerShell script. The script:

- Installs the necessary modules.
- Signs in with your Azure account.
- Verifies the existence of a specified resource group and Automation account.
- Creates references to Automation account attributes.
- Creates an Azure Monitor Log Analytics workspace if not specified.
- Enables the Automation solution in the workspace.
- Downloads and installs the Log Analytics agent for the Windows operating system.
- Registers the machine as a Hybrid Runbook Worker.

Deploying many agents in an on-premises infrastructure can be orchestrated by using command-line scripts and by using Group Policy or Endpoint Configuration Manager.

#### Use dynamic groups for Azure and non-Azure machines

Dynamic groups for Azure VMs filter VMs based on a combination of:

- Subscriptions
- Resource groups
- Locations
- Tags

Dynamic groups for non-Azure computers use saved searches to filter the computers for deployment of the update. Saved searches, also known as *computer groups*, can be created by using:

- A log query. Use Azure Data Explorer to define a logical expression to filter the computers.
- Active Directory Domain Services. A group is created in Log Analytics workspace for any members of an Active Directory domain.
- Endpoint Configuration Manager. Import computer collections from Endpoint Configuration Manager into a Log Analytics workspace.
- WSUS. Groups that are created in WSUS servers can be imported into a Log Analytics workspace.

For more information on how to create computer groups for filtering machines for update deployment, refer to [Computer groups in Azure Monitor log queries][29].

### Scalability

Azure Automation can process up to 1,000 computers per update deployment. If you expect to update more than 1,000 computers, you can split up the updates among multiple update schedules. Refer to [Azure subscription and service limits, quotas, and constraints][30].

### Availability

- Currently, mappings between Log Analytics Workspace and Automation Account are supported in several regions. For further information, refer to [Supported regions for linked Log Analytics workspace][8].
- Supported client types: Update assessment and patching is supported on Windows and Linux computers that run in Azure or in your on-premises environment. Currently, the Windows client isn't officially supported. For a list of the supported clients, refer to [Supported client types][31].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Update Management permissions: The Update Management component of Automation and the Log Analytics workspace component of Monitor can use Azure role-based access control (Azure RBAC) with built-in roles from Azure Resource Manager. For segregation of the duties, these roles can be assigned to different users, groups, and security principals. For a list of the roles in Automation accounts, refer to [Manage role permissions and security][32].
- Encryption of sensitive assets in Automation: An Automation account can contain sensitive assets such as credentials, certificates, and encrypted variables that runbooks might use. Each secure asset is encrypted by default using a data encryption key that's generated for each Automation account. These keys are encrypted and stored in Automation with an account encryption key that can be stored in the Azure Key Vault for customers who want to manage encryption with their own keys. By default, an account encryption key is encrypted by using Microsoft-managed keys. Use the following guidelines to [apply encryption of secure assets in Azure Automation][33].
- Runbook permissions for a Hybrid Runbook Worker: By default, runbook permissions for a Hybrid Runbook Worker run in a system context on the machine where they're deployed. A runbook provides its own authentication to local resources. Authentication can be configured using managed identities for Azure resources or by specifying a Run As account to provide a user context for all runbooks.
- Network planning: Hybrid Runbook Worker requires outbound internet access over TCP port 443 to communicate with Automation. For computers with restricted internet access, you can use the [Log Analytics gateway][34] to configure communication with Automation and an Azure Log Analytics workspace.
- Azure Security baseline for Automation: [Azure security baseline for Automation][35] contains recommendations about how to increase overall security to protect your assets following best practice guidance.

### DevOps

- You can schedule update deployment programmatically through the REST API. For more information, refer to [Software Update Configurations - Create][36].
- Azure Automation allows integration with popular source control systems like Azure DevOps and GitHub. With source control, you can integrate an existing development environment that contains your scripts and custom code that has been previously tested in an isolated environment.
- For more information about how to integrate Automation with your source control environment, refer to [Use source control integration][37].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Use the [Azure pricing calculator][38] to estimate costs. For more information about Automation pricing models, refer to [Automation pricing][39].
- Azure Automation costs are priced for job execution per minute or for configuration management per node. Every month, the first 500 minutes of process automation and configuration management on five nodes are free.
- An Azure Log Analytics workspace might generate more costs related to the amount of log data that's stored in Azure Log Analytics. The pricing is based on consumption, and the costs are associated with data ingestion and data retention. For ingesting data into Azure Log Analytics, use the capacity reservation or pay-as-you-go model that includes 5 gigabytes (GB) free a month for each billing account. Data retention for the first 31 days is free of charge.
- Use the Azure pricing calculator to estimate costs. For more information about Log Analytics pricing models, refer to [Azure Monitor pricing][40].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:
- [Mike Martin](https://www.linkedin.com/in/techmike2kx) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

More about Azure Automation:

- [Hybrid Runbook Worker overview](/azure/automation/automation-hybrid-runbook-worker)
- [Create an Azure Automation account](/azure/automation/quickstarts/create-azure-automation-account-portal)
- [Pre-requisites: Azure Automation network configuration details](/azure/automation/automation-network-configuration)
- [Azure Automation Update Management](./azure-update-mgmt.yml)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [Overview of VM insights](/azure/azure-monitor/vm/vminsights-overview)
- [Azure Arc Overview](/azure/azure-arc/overview)
- [What is Azure Arc enabled servers?](/azure/azure-arc/servers/overview)

## Related resources

- [Azure Automation in a hybrid environment](./azure-automation-hybrid.yml)
- [Event-based cloud automation](../reference-architectures/serverless/cloud-automation.yml)
- [Azure Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)

[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-update-mgmt.vsdx
[1]: /azure/azure-monitor/platform/design-logs-deployment
[2]: /azure/automation/automation-hybrid-runbook-worker
[3]: /azure/automation/automation-intro
[4]: /azure/automation/update-management/update-mgmt-overview
[5]: /azure/azure-monitor/platform/design-logs-deployment
[6]: https://portal.azure.com/
[7]: https://azure.microsoft.com/pricing/details/log-analytics/
[8]: /azure/automation/how-to/region-mappings
[8]: /azure/automation/how-to/region-mappings
[9]: /azure/automation/update-management/update-mgmt-enable-template
[10]: /azure/automation/update-management/update-mgmt-enable-portal
[11]: /azure/automation/update-management/update-mgmt-enable-vm
[12]: /azure/automation/update-management/update-mgmt-enable-automation-account
[13]: /azure/automation/update-management/update-mgmt-enable-runbook
[14]: /azure/virtual-machines/extensions/oms-linux
[15]: /azure/virtual-machines/extensions/oms-windows
[16]: /azure/azure-monitor/platform/agent-windows
[17]: /azure/azure-monitor/platform/agent-windows#configure-agent-to-use-tls-12
[18]: /azure/azure-monitor/platform/agent-linux#install-the-agent-manually
[19]: /azure/azure-monitor/platform/gateway
[20]: /azure/azure-monitor/platform/agent-linux#install-the-agent-using-wrapper-script
[21]: /azure/azure-monitor/platform/agent-windows#obtain-workspace-id-and-key
[22]: /azure/automation/update-management/update-mgmt-groups
[23]: /azure/automation/update-management/view-update-assessments
[24]: /azure/automation/update-management/update-mgmt-pre-post-scripts
[25]: /azure/automation/update-management/update-mgmt-configure-wuagent
[26]: /azure/azure-monitor/platform/collect-sccm
[27]: /configmgr/sum/tools/updates-publisher
[28]: /azure/automation/update-management/update-mgmt-mecmintegration
[29]: /azure/azure-monitor/platform/computer-groups
[30]: /azure/azure-resource-manager/management/azure-subscription-service-limits#automation-limits
[31]: /azure/automation/update-management/update-mgmt-overview#clients
[32]: /azure/automation/automation-role-based-access-control#update-management-permissions
[33]: /azure/automation/automation-secure-asset-encryption
[34]: /azure/azure-monitor/platform/gateway
[35]: /azure/automation/security-baseline
[36]: /rest/api/automation/softwareupdateconfigurations/create
[37]: /azure/automation/source-control-integration
[38]: https://azure.microsoft.com/pricing/calculator
[39]: https://azure.microsoft.com/pricing/details/automation/
[40]: https://azure.microsoft.com/pricing/details/monitor/
