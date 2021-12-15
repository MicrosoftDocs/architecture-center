This reference architecture illustrates how to extend automation to on-premises or other cloud providers. It describes the services that must be deployed in Azure to provide automated management and configuration across on-premises or other cloud providers. The same architecture can be applied on Azure virtual machines (VMs) that reside behind a firewall, with outbound connectivity over the 443 TCP port.

![Azure Automation in a hybrid environment][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Automated management and configuration across Azure, on-premises, or other cloud providers.
- Automation of Azure virtual machines (VMs) that reside behind a firewall, with outbound connectivity over the 443 TCP port.

## Architecture

The architecture consists of the following components:

- **Log Analytics Workspace:**  A [Log Analytics workspace][1] is a data repository for log data collected from resources that run in Azure, on-premises or in another cloud provider.
- **Automation Hybrid Worker solution:** With this, you can create [Hybrid Runbook Workers][2] to run [Azure Automation][3] runbooks on your Azure and non-Azure computers.
- **Automation Account:** A cloud service that automates configuration and management across your Azure and non-Azure environments.
- **Hybrid Runbook Worker:** A computer that is configured with the Hybrid Runbook Worker feature and can execute runbooks directly on the computer and against the resources in the local environment.
- **Hybrid Runbook Worker Group:** Groups multiple Hybrid runbook workers for higher availability and scale to run a set of runbooks.
- **A Runbook:** A collection of one or more linked activities that together automate a process or operation.
- **On-premises machines and VMs**. On-premises computers and VMs with Windows or Linux operating system hosted in a private local-area network.

## Recommendations

The following recommendations apply to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

The following steps highlight the actual implementation:

- Create a Log Analytics Workspace
- Add an Automation Hybrid Worker Solution
- Create an Automation Account
- Link an Automation Account with Log Analytics Workspace
- Deploy a Log Analytics agent and connect to a Log Analytics Workspace
- Deploy a Hybrid Runbook Worker Group and Hybrid Runbook Worker on an on-premises Windows computer (optional Linux VM)
- Create a Runbook in Azure Automation
- Create a Run As account for authentication (if applicable)
- Deploy a Runbook on a Hybrid Runbook Worker Group

### Create a Log Analytics Workspace

Before you create a Log Analytics Workspace, ensure that you have at least Log Analytics Contributor role permissions. An Azure subscription can contain more than one Log Analytics Workspace for data isolation or for geographic location for data storage, but the Log Analytics agent can be configured to report to one Log Analytics Workspace. For more information, review the [Azure Monitor Log design guidance][4] before you create the workspace. Use the following steps to create a Log Analytics Workspace:

1. Sign in to the Azure portal at [**https://portal.azure.com**][5].
1. In the Azure portal, select  **Create a Resource**. In the Search the Marketplace, enter  **Log Analytics**. As you begin entering, the list filters based on your input. Select  **Log Analytics Workspaces**.
1. Select  **Create**, and then select choices for the following items:
    1. Select a  **Subscription**  to link to by selecting from the drop-down list if the default selected is not appropriate.
    1. For  **Resource Group**, use an existing resource group already set up or create a new one.
    1. Provide a unique name for the new  **Log Analytics Workspace**, such as _Hybrid __Workspace__-your name_.
    1. Select the  **Location**  for your deployment.
    1. Select **Pricing Tier** to proceed to further customization.
    1. If you're creating a workspace in a subscription created after April 2, 2018, it'll automatically use the _Per GB_ pricing plan. The option to select a pricing tier won't be available. If you're creating a workspace for an existing subscription created before April 2, 2018 or to a subscription that was tied to an existing Enterprise Agreement enrollment, select your preferred pricing tier. For additional information about the particular tiers, refer to [Log Analytics Pricing Details][6].
    1. Select **Tags** and optionally provide name/value for categorization of the resources.
    1. Select **Review + Create**.
1. After providing the required information on the  **Log Analytics Workspace**  pane, select  **Create**.

### Add an Automation Hybrid Worker Solution

Next, prepare the Log Analytics Workspace with the necessary components required for the Hybrid Runbook Worker. Use the following steps to add Automation Hybrid Worker Solution:

1. In the Azure portal, select  **Create a Resource**.
1. In the Search the Marketplace, enter  **Automation Hybrid Worker.** As you begin entering, the list filters based on your input. Select  **Automation Hybrid Worker.**
1. Select  **Create**, and then select the **Log Analytics Workspace** that you created in the previous step. For example, _HybridWorkspace-yourname._
1. After providing the required information on the  **Automation Hybrid Worker** pane, select  **Create**.

### Create an Automation Account

When Automation Hybrid Worker Solution has been added to Log Analytics Workplace, proceed with creating the Azure Automation Account. It's important that you create an Automation Account in the same region and preferably in the same Resource Group as the Log Analytics Workplace.

Use the following steps to create the Automation Account:

1. In the Azure portal, select  **Create a Resource**.
1. In the Search the Marketplace, enter  **Automation.** As you begin, the list filters based on your input. Select  **Automation**, and then select **Create.**
1. Select  **Create** and then select choices for the following items:
    - Provide the **Name** for the Automation Account, such as _hybrid-auto._
    - Select a  **Subscription**  to link to by selecting from the drop-down list if the default selected is not appropriate.
    - For  **Resource Group**, choose the same resource group in which you've created the Log Analytics Workspace.
    - Select the  **Location**  to be the same as the Log Analytics Workspace.
    - **Create Azure Run As account** is optional. This only provides authentication with Azure to manage Azure resources from Automation runbooks.
1. After providing the required information on the  **Add Automation Account** pane, select  **Create**.

### Link an Automation Account with Log Analytics Workspace

Automation accounts use the components of Hybrid Runbook Worker that are deployed in Log Analytics Workspace. Integrate those services before you deploy a Log Analytics agent on an on-premises machine. If you plan to use the same Automation Account for Update Management and Change Tracking, you must map the Log Analytics Workspace and Automation Account. Currently, mappings between Log Analytics Workspace and Automation Account are supported in several regions. For further information, refer to [Supported regions for linked Log Analytics workspace.][7]

Use the following steps to link the Automation Account with Log Analytics Workspace:

1. In the Azure portal, select **All services**, and then enter **automation.** As you begin entering, the list filters based on your input. Select  **Automation Account**, and then select your automation account created in the previous step.
1. In the **Automation Account** pane, in the **Update Management** section, select **Update Management.**
1. In the **Update Management** pane, select choices for the following items:
    - Select a  **Subscription**  to link to by selecting from the drop-down list if the default selected is not appropriate.
    - For **Log Analytics workspace**, select the Log Analytics Workspace that you created. For example,  _HybridWorkspace-Marjan._
1. After providing the required information in the  **Update Management** pane, select **Enable.**

### Deploy a Log Analytics agent and connect to a Log Analytics Workspace

Deploying a Hybrid Runbook Worker component is part of the deployment of Log Analytics Agent.

If you test the solution using an Azure VM, install Log Analytics Agent and enroll the VM into an existing Log Analytics Workspace by using VM extension for both [Linux][8] and [Windows][9]. Deploy the agent using Azure Automation Desired State Configuration (DSC), PowerShell script, or use the Resource Manager template for VMs. For more information, refer to the following article [Connect Windows computers to Azure Monitor.][10]

For non-Azure VMs, deploy the agent both on Windows and Linux computers, physical or VMs, using manual or automated process.

For Windows machines, configure the agent to communicate with Log Analytics Workspace using TLS 1.2 protocol. Deployment procedure is explained in detail in the following article [Connect Windows computers to Azure Monitor.][11]

The Log Analytics Agent for Linux can be deployed:

- [Manually][12] using a shell script bundle that contains Debian and Red Hat Package Manager (RPM) packages for each of the agent components. This is recommended when the Linux machine doesn't have internet connectivity and will communicate with Log Analytic Service through [Log Analytics gateway][13].
- Using [wrapper-script][14] hosted on GitHub, when the computer has connectivity to the Internet.

The Log Analytics Agent must be configured to communicate with Log Analytics Workspace by using [workspace ID and key][15] of the Log Analytics Workspace.

Use the following steps to deploy Log Analytics Agent and connect to Log Analytics Workspace:

1. In the Azure portal, search for and select  **Log Analytics Workspaces**.
1. In your list of Log Analytics Workspaces, select the workspace you intend to configure the agent to report to.
1. Select  **Agents management**.
1. Copy and paste into your favorite editor, the  **Workspace ID**  and  **Primary Key**.
1. In your Log Analytics Workspace, from the  **Windows Servers**  page you navigated to earlier, select the appropriate  **Download Windows Agent**  version to download depending on the processor architecture of the Windows operating system.
1. Run Setup to install the agent on your computer.
1. On the  **Welcome**  page, select  **Next**.
1. On the  **License Terms**  page, read the license, and then select  **I Agree**.
1. On the  **Destination Folder**  page, change or keep the default installation folder, and then select  **Next**.
1. On the  **Agent Setup Options**  page, choose to connect the agent to Azure Log Analytics, and then select  **Next**.
1. On the  **Azure Log Analytics**  page, perform the following:
    - Paste the  **Workspace ID**  and **Workspace Key (Primary Key)** that you copied earlier. If the computer should report to a Log Analytics Workspace in Azure Government cloud, select  **Azure US Government**  from the  **Azure Cloud**  drop-down list.
    - If the computer needs to communicate through a proxy server to the Log Analytics service, select  **Advanced**  and provide the URL and port number of the proxy server. If your proxy server requires authentication, enter the username and password to authenticate with the proxy server, and then select **Next**.
1. Select  **Next**  when you've completed providing the necessary configuration settings.

### Deploy Hybrid Runbook Worker Group and Hybrid Runbook Worker on an on-premises Windows machine (optional Linux VM)

The Hybrid Runbook Worker role requires the Log Analytics agent for the supported operating system.

- For Windows operating system, refer to the following ["prerequisites"][16]
- For Linux operating system, refer to the following ["prerequisites"][17]

Deploy Hybrid Worker role on a Windows machine using automated and manual deployment.

For [automated deployment][18], Microsoft provides PowerShell scripts [**New-OnPremiseHybridWorker.ps1**][19] that can be downloaded from the PowerShell Gallery.

For manual deployment, the log analytics agent will download the necessary components that are required for the Hybrid Runbook worker from the Log Analytics Workspace. The link that exists between the Log Analytics Workspace and the Azure Automation account will push down the **HybridRegistration** PowerShell module, which contains the **Add-HybridRunbookWorker** cmdlet.

Use the following procedure to manually deploy Hybrid Runbook Worker Group and Hybrid Runbook Worker on an on-premises Windows machine:

1. In the Azure portal, search for and select  **Automation Account**.
1. In your list of Automation Accounts, select the Automation Account you intend to configure the agent to report to.
1. In the Account Settings section, select **Keys**.
1. Copy and paste into your favorite editor, the  **Primary access key** and  **URL.**
1. Switch on the windows machine, open a PowerShell session in Administrator mode, and then execute the following commands to import the module:

  ```powershell
  cd "C:\Program Files\Microsoft Monitoring Agent\Agent\AzureAutomation\\<version>\HybridRegistration"

  Import-Module .\HybridRegistration.psd1
  ```

1. Now execute the Add-HybridRunbookWorker cmdlet using the following syntax:

  ```powershell
  Add-HybridRunbookWorker –GroupName <String> -Url <Url> -Key <String>
  ```

  > [!NOTE]
  > For the URL, use the previously recorded **URL**, and for the **Key**, use the previously copied **Primary access key**.

### Create a Runbook in Azure Automation

To manage resources on a local computer or against resources in the local environment where the hybrid worker is deployed, you must create a Runbook. Add a Runbook to Azure Automation by either creating a new one or importing an existing one from a file or the [Runbook Gallery][20].

  > [!NOTE]
  > When the Hybrid Runbook host machine reboots, any open Runbook job restarts from the beginning or from the last checkpoint for PowerShell Workflow Runbooks. This occurs for a maximum of three times, and then it is suspended.

Use the following steps to create or import Runbook in Azure Automation:

1. In the Azure portal, search for and then select  **Automation Account**.
1. In your list of Automation Accounts, select the Automation Account you intend to configure the agent to report to.
1. In the Process Automation section, select **Runbooks.**
1. Select **Create a Runbook** or **Import a Runbook** to configure the automation task that will run on on-premises machines.

### Create a Run As Account for Authentication (as applicable)

Hybrid Runbook Workers on Azure VMs can use managed identities from Azure Active Directory to authenticate to Azure resources.

A Runbook that creates jobs on Hybrid Runbook Worker by default operates under the local **System account** on Windows or the [nxautomation account][21] on Linux.

For accessing local resources using different authentication, specify a Run As account for a Hybrid Runbook Worker group. The Run As account is defined with [credential asset][22] that has sufficient permission to access the local resources.

Use the following steps to create a Run As Account for authentication:

1. In the Azure portal, search for and then select  **Automation Account**.
1. In your list of Automation Accounts, select the Automation Account you created previously.
1. In the Shared Resources section, select **Credentials**.
1. Select **Add a credential** to create a credential asset with access to local resources.
1. In the Automation account pane in the Process Automation section, select **Hybrid Worker Groups**, and then select the specific group.
1. In the Hybrid Worker group settings, select  **Hybrid worker group settings**.
1. Change the value of  **Run As**  from  **Default**  to  **Custom**.
1. Select the **Run As** credential created before, and then select  **Save**.

### Deploy a Runbook on a Hybrid Runbook Worker Group

The final step is to deploy a runbook to execute on a Hybrid Runbook Worker Group. The runbook must be published and started using one of the following methods:

- Azure portal
- PowerShell
- Azure Automation API
- Webhooks
- Schedule
- Respond to Azure Alert
- From another Runbook

Refer to the following article [Start a runbook in Azure Automation][23] to determine the method to start a runbook in Azure Automation.

Test the runbook in a draft version but consider that runbook still executes normally and performs against any resources in the environment.

To test and deploy the runbook on a Hybrid Runbook Worker Group, use the following steps:

1. In the Azure portal, search for and then select  **Automation Account**.
1. In your list of Automation Accounts, select the Automation Account you have created previously.
1. In the Automation account pane in the Process Automation section, select **Runbooks.**
1. Select your runbook created before and select **Edit.**
1. In the edit runbook, select the Test Pane.
1. In the Test Pane, change the value of **Run on** from Azure to **Hybrid Worker**.
1. In the Choose Hybrid Worker group, select your group created in the previous step.
1. Start the test to observe the result of the runbook.
1. Close the Test Pane to return to the Edit section.
1. Select **Publish** to save the final version of the runbook.
1. In the Runbooks pane, select **Link to schedule.**
1. In the Schedule, create or link the existing schedule to define the startup environment for the runbook.
1. In the Schedule Runbook pane, select **Parameters and Run Settings,** and then change the value of **Run On** from Azure to **Hybrid Worker.**
1. In the Choose Hybrid Worker group, select your group created in the previous step.
1. Confirm the choices by selecting **OK** to finish publishing the runbook on the Hybrid Runbook Worker.

## Scalability considerations

- The Log Analytics Agent for Windows and Linux have very minimal impact on the machine performance. Scale up your workers by configuring to run on more powerful machines with higher performance including (memory, CPU, IOPs).

- Increased demands for processing large number of jobs can be solved by organizing multiple Hybrid Workers into Hybrid Worker Groups. Runbooks are executed on each Hybrid worker using queuing mechanisms. The Hybrid worker checks the Automation account once every 30 seconds and pickup four jobs to execute.

- Multiple Hybrid Worker Groups can execute runbooks automation tasks using different Run As accounts.

## Availability considerations

- Currently, mappings between Log Analytics Workspace and Automation Account are supported in several regions. For further information, refer to [Supported regions for linked Log Analytics workspace][7].
- A Hybrid Runbook Worker Group with more than one machine configured with Hybrid Worker Role provides high availability because runbooks will start only on servers that are running and healthy.

## Manageability considerations

- To accelerate deployment of the Log Analytics Agent with Hybrid Worker Role running on Windows machine, use the PowerShell script  **New-OnPremiseHybridWorker.ps1**. The script performs the following steps:
  - Installs the necessary modules
  - Signs in with your Azure account
  - Verifies the existence of a specified resource group and Automation Account
  - Creates references to Automation account attributes
  - Creates an Azure Monitor Log Analytics Workspace if not specified
  - Enables the Azure Automation solution in the workspace
  - Downloads and installs the Log Analytics Agent for Windows
  - Registers the machine as a Hybrid Runbook Worker
- Deployment of many agents in on-premises infrastructure can be orchestrated using command line scripts and deployed using Group Policy or System Center Configuration Manager.

## Security considerations

- Encryption of sensitive assets in Automation: An Azure Automation Account can contain sensitive assets such as credentials, certificate, connection, and encrypted variables that might be used by the runbooks. Each secure asset is encrypted by default using a Data Encryption key that is generated for each Automation Account. These keys are encrypted and stored in Azure Automation with an Account Encryption Key (AEK) that can be stored in the Key Vault for customers who want to manage encryption with their own keys. By default, AEK is encrypted using Microsoft-managed Keys. Use the following guidelines to [apply encryption of secure assets in Azure Automation.][24]
- Runbook permission: By default, runbook permissions for a Hybrid Runbook Worker run in a system context on the machine where they're deployed. A runbook provides its own authentication to local resources. Authentication can be configured using managed identities for Azure resources or by specifying a Run As account to provide a user context for all runbooks.
- Network planning: Hybrid Runbook Worker requires outbound internet access over TCP port 443 to communicate with Automation. For computers with restricted internet access, use [Log Analytics gateway][25] to configure communication with Azure Automation and Azure Log Analytics Workspace.
- Azure Security baseline for Automation: [The Azure security baseline for Automation][26] contains recommendations on how to increase overall security configuration to protect your asset following best-practice guidance.

## DevOps considerations

- Azure Automation allows integration with popular source control systems, Azure DevOps, and GitHub. With Source Control, you can integrate the existing development environment that contains your scripts and custom code that have been previously tested in an isolated environment.
- For information on how to integrate Azure Automation with your Source Control environment, refer to: [Use source control integration][27].

## Cost considerations

- Use the [Azure pricing calculator][28] to estimate costs. Pricing models for Azure Automation are explained [here][29].
- Azure Automation costs are priced for job execution per minute or for configuration management per node. Every month, the first 500 minutes of process automation and configuration management on five nodes are free.
- Azure Log Analytics Workspace might generate additional costs related to the amount of log data stored in the Azure Log Analytics. The pricing model is based on consumption. The costs are associated for data ingestion and data retention. For ingesting data into Azure Log Analytics, use Capacity Reservation or Pay-As-You-Go model that include 5 gigabytes (GB) free per billing account per month. Data retention for the first 31 days are free of charge.
- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Pricing models for Log Analytics are explained [here][30].

## Next steps

More about Azure Automation:

- [Azure Automation in a hybrid environment](./azure-automation-hybrid.yml)
- [Hybrid Runbook Worker overview](/azure/automation/automation-hybrid-runbook-worker)
- [Create an Azure Automation account](/azure/automation/automation-quickstart-create-account)
- [Pre-requisites: Azure Automation network configuration details](/azure/automation/automation-network-configuration)
- [Azure Automation Update Management](./azure-update-mgmt.yml)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [Overview of VM insights](/azure/azure-monitor/vm/vminsights-overview)
- [Azure Arc Overview](/azure/azure-arc/overview)
- [What is Azure Arc enabled servers?](/azure/azure-arc/servers/overview)

[architectural-diagram]: ./images/azure-automation-hybrid.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-automation-hybrid.vsdx
[1]: /azure/azure-monitor/platform/design-logs-deployment
[2]: /azure/automation/automation-hybrid-runbook-worker
[3]: /azure/automation/automation-intro
[4]: /azure/azure-monitor/platform/design-logs-deployment
[5]: https://portal.azure.com/
[6]: https://azure.microsoft.com/pricing/details/log-analytics/
[7]: /azure/automation/how-to/region-mappings
[8]: /azure/virtual-machines/extensions/oms-linux
[9]: /azure/virtual-machines/extensions/oms-windows
[10]: /azure/azure-monitor/platform/agent-windows
[11]: /azure/azure-monitor/platform/agent-windows#configure-agent-to-use-tls-12
[12]: /azure/azure-monitor/platform/agent-linux#install-the-agent-manually
[13]: /azure/azure-monitor/platform/gateway
[14]: /azure/azure-monitor/platform/agent-linux#install-the-agent-using-wrapper-script
[15]: /azure/azure-monitor/platform/agent-windows#obtain-workspace-id-and-key
[16]: /azure/automation/automation-windows-hrw-install#prerequisites
[17]: /azure/automation/automation-linux-hrw-install#prerequisites
[18]: /azure/automation/automation-windows-hrw-install#automated-deployment
[19]: https://www.powershellgallery.com/packages/New-OnPremiseHybridWorker/1.7
[20]: /azure/automation/automation-runbook-gallery
[21]: /azure/automation/automation-runbook-execution#log-analytics-agent-for-linux
[22]: /azure/automation/shared-resources/credentials
[23]: /azure/automation/start-runbooks
[24]: /azure/automation/automation-secure-asset-encryption
[25]: /azure/azure-monitor/platform/gateway
[26]: /azure/automation/security-baseline
[27]: /azure/automation/source-control-integration
[28]: https://azure.microsoft.com/pricing/calculator
[29]: https://azure.microsoft.com/pricing/details/automation/
[30]: https://azure.microsoft.com/pricing/details/monitor/
