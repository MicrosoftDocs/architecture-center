


This reference architecture illustrates how to use Azure Security Center and Azure Sentinel to monitor
the security configuration and telemetry of on-premises and Azure operating system workloads. This includes Azure Stack.

![Diagram illustrating deployed Microsoft Monitoring Agent on on-premises systems as well as on Azure based virtual machines transferring data to Azure Security Center and Azure Sentinel][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Best practices for integrating on-premises security and telemetry monitoring with Azure-based workloads
- How to integrate Azure Security Center with Azure Stack
- How to integrate Azure Security Center with Azure Sentinel

## Architecture

The architecture consists of the following components:

- **[Azure Security Center][azure-security-center]**. This is an advanced, unified security-management platform that Microsoft offers to all Azure subscribers. Security Center  is segmented as a cloud security posture management (CSPM) and cloud workload protection platform (CWPP). CWPP is defined by workload-centric security protection solutions, which are typically agent-based.
Azure Security Center provides threat protection for Azure workloads, both on-premises and in other clouds, including Windows and Linux virtual machines (VMs), containers, databases, and Internet of Things (IoT).
When activated, the Log Analytics agent deploys automatically into Azure Virtual Machines. For on-premises Windows and Linux servers and VMs, you can manually deploy the agent, use your organization's deployment tool, such as Microsoft Endpoint Protection Manager, or utilize scripted deployment methods. Security Center begins assessing the security state of all your VMs, networks, applications, and data.
- **[Azure Sentinel][azure-sentinel]**. Is a cloud-native Security Information and Event Management (SIEM) and security orchestration automated response (SOAR) solution that uses advanced AI and security analytics to help you detect, hunt, prevent, and respond to threats across your enterprise.
- **[Azure Stack][azure-stack]**. Is a portfolio of products that extend Azure services and capabilities to your environment of choice, from the datacenter to edge locations and remote offices. Systems that you integrate with Azure Stack typically utilize racks of four to sixteen servers, built by trusted hardware partners and delivered straight to your datacenter.
- **[Azure Monitor][azure-monitor]**. Collects monitoring telemetry from a variety of on-premises and Azure sources. Management tools, such as those in Azure Security Center and Azure Automation, also push log data to Azure Monitor.
- **Log Analytics workspace**. Azure Monitor stores log data in a Log Analytics workspace, which is a container that includes data and configuration information.
- **Log Analytics agent**. The Log Analytics agent collects monitoring data from the guest operating system and VM workloads in Azure, other cloud providers, and on-premises. The Log Analytics Agent supports Proxy configuration and, typically in this scenario, a Microsoft Operations Management Suite (OMS) Gateway acts as proxy.
- **On-premises network**. This is the firewall configured to support HTTPS egress from defined systems.
- **On-premises Windows and Linux systems**. Systems with the Log Analytics Agent installed.
- **Azure Windows and Linux VMs**. Systems on which the Azure Security Center monitoring agent is installed.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Azure Security Center upgrade

This reference architecture uses **Azure Security Center** to monitor on-premises systems, Azure VMs, Azure Monitor resources, and even VMs hosted by other cloud providers. To support that functionality, the **standard fee-based tier** of Azure Security Center is needed. We recommend that you use the 30-day free trial to validate your requirements.

Details about Azure Security Center pricing can be found [here][azure-security-center-pricing].

### Customized Log Analytics Workspace

**Azure Sentinel** needs access to a Log Analytics workspace. In this scenario, you can’t use the default ASC Log Analytics workspace with Azure Sentinel. You’ll need to create a customized workspace. Data retention for a customized workspace is based on the workspace pricing tier, and you can find pricing models for Monitor Logs [here][azure-monitor-storage-pricing].

> [!NOTE]
> Azure Sentinel can run on workspaces in any general availability (GA) region of Log Analytics except the China and Germany (Sovereign) regions. Data that Azure Sentinel generates, such as incidents, bookmarks, and alert rules, which may contain some customer data sourced from these workspaces, is saved either in Europe (for Europe-based workspaces), in Australia (for Australia-based workspaces), or in the East US (for workspaces located in any other region).

## Scalability considerations

The Log Analytics Agent for Windows and Linux is designed to have very minimal impact on the performance of VMs or physical systems.

Azure Security Center operational process won’t interfere with your normal operational procedures. Instead, it passively monitors your deployments and provides recommendations based on the security policies you enable.

## Manageability considerations

### Azure Security Center roles

Security Center assesses your resources’ configuration to identify security issues and vulnerabilities, and displays information related to a resource when you are assigned the role of owner, contributor, or reader for the subscription or resource group to which a resource belongs.

In addition to these roles, there are two specific Security Center roles:

- **Security Reader**. A user that belongs to this role has read only rights to Security Center. The user can observe recommendations, alerts, a security policy, and security states, but can’t make changes.

- **Security Admin**. A user that belongs to this role has the same rights as the Security Reader, and also can update security policies, and dismiss alerts and recommendations. Typically, these are users that manage the workload.

- The security roles, **Security Reader** and **Security Admin**, have access only in Security Center. The security roles don’t have access to other Azure service areas, such as storage, web, mobile, or IoT.

### Azure Sentinel subscription

- To enable Azure Sentinel, you need contributor permissions to the subscription in which the Azure Sentinel workspace resides.
- To use Azure Sentinel, you need contributor or reader permissions on the resource group to which the workspace belongs.
- Azure Sentinel is a paid service. For more information, refer to [Azure Sentinel pricing][azure-sentinel-pricing].

## Security considerations

A **security policy** defines the set of controls that are recommended for resources within a specified subscription. In Azure Security Center, you define policies for your Azure subscriptions according to your company's security requirements and the type of applications or data sensitivity for each subscription.

The security policies that you enable in Azure Security Center drive security recommendations and monitoring. To learn more about security policies, refer to [Strengthen your security policy with Azure Security Center.][azure-security-center-health-monitoring] You can assign security policies in Azure Security Center only at the management or subscription group levels.

> [!NOTE]
> Part one of the reference architecture details how to enable Azure Security Center to monitor Azure resources, on-premises systems, and Azure Stack systems.

## Deploy the solution

### Create a Log Analytics workspace in Azure Portal

1. Sign into the Azure portal as a user with Security Admin privileges.
1. In the Azure portal, select **All services**. In the list of resources, enter **Log Analytics**. As you begin entering, the list filters based on your input. Select **Log Analytics workspaces**.
1. Select **Add** on the Log Analytics page.
1. Provide a name for the new Log Analytics workspace, such as **ASC-SentinelWorkspace**. This name must be globally unique across all Azure Monitor subscriptions.
1. Select a subscription by selecting from the drop-down list if the default selection is not appropriate.
1. For **Resource Group**, choose to use an existing resource group or create a new one.
1. For **Location**, select an available geolocation.
1. Select **OK** to complete the configuration.
    ![New Workspace created for the architecture][screenshot-workspace]

### Enable Security Center

While you're still signed into the Azure portal as a user with Security Admin privileges, select **Security Center** in the panel. **Security Center - Overview** opens:

![Security Center Overview dashboard blade opens][screenshot-overview]

Security Center automatically enables the Free tier for any of the Azure subscriptions not previously onboarded by you or another subscription user.

### Upgrade to the Standard tier

> [!IMPORTANT]
> This reference architecture uses the 30-day free trial of Security Center Standard tier.

1. On the Security Center main menu, select **Getting Started**.
1. Select the **Upgrade Now** button. Security Center lists your subscriptions and workspaces that are eligible for use in the Standard tier.
1. You can select eligible workspaces and subscriptions to start your trial. Select the previously created workspace, **ASC-SentinelWorkspace.** from the drop-down menu.
1. In the Security Center main menu, select **Start trial**.
1. The **Install Agents** dialog box should display.
1. Select the **Install Agents** button. The **Security Center - Coverage** blade displays and you should observe your selected subscription in the **Standard coverage** tab.
    ![Security Coverage blade showing your subscriptions should be open][screenshot-coverage]

You've now enabled automatic provisioning and Security Center will install the Log Analytics Agent for Windows (**HealthService.exe**) and the **omsagent** for Linux on all supported Azure VMs and any new ones that you create. You can turn off this policy and manually manage it, although we strongly recommend automatic provisioning.

To learn more about the specific Security Center features available in Windows and Linux, refer to [Feature coverage for machines][azure-security-center-services].

### Enable Azure Security Center monitoring of on-premises Windows computers

1. In the Azure Portal on the **Security Center - Overview** blade, select the **Get Started** tab.
1. Select **Configure** under **Add new non-Azure computers**. A list of your Log Analytics workspaces displays, and should include the **ASC-SentinelWorkspace**.
1. Select this workspace. The **Direct Agent** blade opens with a link for downloading a Windows agent and keys for your workspace identification (ID) to use when you configure the agent.
1. Select the **Download Windows Agent** link applicable to your computer processor type to download the setup file.
1. To the right  of **Workspace ID**, select **Copy**, and then paste the ID into Notepad.
1. To the right of **Primary Key**, select **Copy**, and then paste the key into Notepad.

### Install the Windows agent

To install the agent on the targeted computers, follow these steps.

1. Copy the file to the target computer and then **Run Setup**.
1. On the **Welcome** page, select **Next**.
1. On the **License Terms** page, read the license and then select **I Agree**.
1. On the **Destination Folder** page, change or keep the default installation folder and then select **Next**.
1. On the **Agent Setup Options** page, choose to connect the agent to Azure Log Analytics and then select **Next**.
1. On the **Azure Log Analytics** page, paste the **Workspace ID** and **Workspace Key (Primary Key)** that you copied into Notepad in the previous procedure.
1. If the computer should report to a Log Analytics workspace in Azure Government cloud, select **Azure US Government** from the **Azure Cloud** drop-down list. If the computer needs to communicate through a proxy server to the Log Analytics service, select **Advanced**, and then provide the proxy server's URL and port number.
1. After you provide the necessary configuration settings, select **Next**.
    ![Log Analytics Agent setup page for connecting agent to an Azure Log Analytics workspace][screenshot-logworkspace]
1. On the **Ready to Install** page, review your choices and then select **Install**.
1. On the **Configuration completed successfully** page, select **Finish**.

When complete, the Log Analytics agent appears in Windows Control Panel, and you can review your configuration and verify that the agent is connected.

For further information about installing and configuring the agent, refer to [Install Log Analytics agent on Windows computers][azure-monitor-install-agent].

The Log Analytics Agent service collects event and performance data, executes tasks, and other workflows defined in a management pack. Security Center extends its cloud workload protection platforms by integrating with **Microsoft Defender Advanced Threat Protection (ATP)** for **Servers**. Together, they provide comprehensive endpoint detection and response (EDR) capabilities.

For more information about Microsoft Defender ATP, refer to [Onboard servers to the Microsoft Defender ATP service.][windows-defender-atp-onboard]

### Enable Azure Security Center monitoring of on-premises Linux computers

1. Return to the **Getting Started** tab as previously described.
1. Select **Configure** under **Add new non-Azure computers**. A list of your Log Analytics workspaces displays. The list should include the **ASC-SentinelWorkspace** that you created.
1. On the **Direct Agent** blade under **DOWNLOAD AND ONBOARD AGENT FOR LINUX,** select **copy** to copy the **wget** command.
1. Open Notepad and then paste this command. Save this file to a location that you can access from your Linux computer.

> [!NOTE]
> On Unix and Linux operating systems, **wget** is a tool for non-interactive file downloading from the web. It supports HTTPS, FTPs, and proxies.

The Linux agent uses the Linux Audit Daemon framework. Security Center integrates functionalities from this framework within the Log Analytics agent, which enables audit records to be collected, enriched, and aggregated into events by using the Log Analytics Agent for Linux. Security Center continuously adds new analytics that use Linux signals to detect malicious behaviors on cloud and on-premises Linux machines.

For a list of the Linux alerts, refer to the [Reference table of alerts][azure-security-center-alerts].

### Install the Linux agent

To install the agent on the targeted Linux computers, follow these steps:

1. On your Linux computer, open the file that you previously saved. Select and copy the entire content, open a terminal console, and then paste the command.
1. Once the installation finishes, you can validate that the **omsagent** is installed by running the **pgrep** command. The command will return the **omsagent** process identifier (PID). You can find the logs for the agent at: **/var/opt/microsoft/omsagent/"workspace id"/log/**.

It can take up to 30 minutes for the new Linux computer to display in Security Center.

### Enable Azure Security Center monitoring of Azure Stack VMs

After you onboard your Azure subscription, you can enable Security Center to protect your VMs running on Azure Stack by adding the **Azure Monitor, Update and Configuration Management** VM extension from the Azure Stack marketplace. To do this:

1. Return to the **Getting Started** tab as previously described.
1. Select **Configure** under **Add new non-Azure computers**. A list of your Log Analytics workspaces displays, and it should include the **ASC-SentinelWorkspace** that you created.
1. On the **Direct Agent** blade there is a link for downloading the agent and keys for your workspace ID to use during agent configuration. You don’t need to download the agent manually. It’ll be installed as a VM extension in the following steps.
1. To the right of **Workspace ID**, select **Copy**, and then paste the ID into Notepad.
1. To the right of **Primary Key**, select **Copy**, and then paste the key into Notepad.

### Enable ASC monitoring of Azure Stack VMs

Azure Security Center uses the **Azure Monitor, Update and Configuration Management** VM extension bundled with Azure Stack.
To enable the **Azure Monitor, Update and Configuration Management** extension, follow these steps:

1. In a new browser tab, sign into your **Azure Stack** portal.
1. Refer to the **Virtual machines** page, and then select the virtual machine that you want to protect with Security Center.
1. Select **Extensions**. The list of VM extensions installed on this VM displays.
1. Select the **Add** tab. The **New Resource** menu blade opens and displays the list of available VM extensions.
1. Select the **Azure Monitor, Update and Configuration Management** extension and then select **Create**. The **Install extension** configuration blade opens.
1. On the **Install extension** configuration blade, paste the **Workspace ID** and **Workspace Key (Primary Key)** that you copied into Notepad in the previous procedure.
1. When you finish providing the necessary configuration settings, select **OK**.
1. Once the extension installation completes, its status will display as **Provisioning Succeeded**. It might take up to one hour for the VM to appear in the Security Center portal.

For more information about installing and configuring the agent for Windows, refer to [Install the agent using setup wizard][azure-monitor-install-agent].

For troubleshooting issues for the Linux agent, refer to [How to troubleshoot issues with the Log Analytics agent for Linux][azure-monitor-install-agent-linux].

Now you can monitor your Azure VMs and non-Azure computers in one place. **Azure Compute** provides you with an overview of all VMs and computers along with recommendations. Each column represents one set of recommendations, and the color represents the VMs or computers and the current security state for that recommendation. Security Center also provides any detections for these computers in security alerts.
![ASC list of systems monitored on the Compute blade][screenshot-output]

There are two types of icons represented on the **Compute** blade:

![Purple computer icon that represents a non-azure monitored computer][icon-nonazurevm] Non-Azure computer

![Blue terminal icon that represents a Azure monitored computer][icon-azurevm] Azure computer

> [!NOTE]
> Part two of the reference architecture will connect alerts from Azure Security Center and stream them into Azure Sentinel.

The role of Azure Sentinel is to ingest data from different data sources and perform data correlation across these data sources. Azure Sentinel leverages machine learning and AI to make threat hunting, alert detection, and threat responses smarter.

To onboard Azure Sentinel, you need to enable it, and then connect your data sources. Azure Sentinel comes with a number of connectors for Microsoft solutions, which are available out of the box and provide real-time integration, including Microsoft Security Center, Microsoft Threat Protection solutions, Microsoft 365 sources (including Office 365), Azure Active Directory (Azure AD), Azure ATP, Microsoft Cloud App Security, and more. Additionally, there are built-in connectors to the broader security ecosystem for non-Microsoft solutions. You can also use Common Event Format, syslog, or the Representational State Transfer API to connect your data sources with Azure Sentinel.

### Requirements for integrating Azure Sentinel with Azure Security Center

1. A Microsoft Azure Subscription
1. A Log Analytics workspace that isn't the default workspace created when you enable Azure Security Center.
1. Azure Security Center with Security Center Standard tier enabled.

All three requirements should be in place if you worked through the previous section.

### Global prerequisites

- To enable Azure Sentinel, you need contributor permissions to the subscription in which the Azure Sentinel workspace resides.
- To use Azure Sentinel, you need contributor or reader permissions on the resource group to which the workspace belongs.
- You might need additional permissions to connect specific data sources. You don't need additional permissions to connect to ASC.
- Azure Sentinel is a paid service. For more information, refer to [Azure Sentinel pricing][azure-sentinel-pricing].

### Enable Azure Sentinel

1. Sign into the Azure portal with a user that has contributor rights for **ASC-Sentinelworkspace**.
1. Search for and select **Azure Sentinel**.
    ![In the Azure portal search for the term "Azure Sentinel"][screenshot-search]
1. Select **Add**.
1. On the **Azure Sentinel** blade, select **ASC-Sentinelworkspace**.
1. In Azure Sentinel, select **Data connectors** from the **navigation** menu.
1. From the data connectors gallery, select **Azure Security Center**, and select the **Open connector page** button.
    ![In Azure Sentinel showing the open Collectors page][screenshot-collectdata]
1. Under **Configuration**, select **Connect** next to those subscriptions for which you want alerts to stream into Azure Sentinel. The **Connect** button will be available only if you have the required permissions and the ASC Standard tier subscription.
1. You should now observe the **Connection Status** as **Connecting**. After connecting, it will switch to **Connected**.
1. After confirming the connectivity, you can close ASC **Data Connector** settings and refresh the page to observe alerts in Azure Sentinel. It might take some time for the logs to start syncing with Azure Sentinel. After you connect, you'll observe a data summary in the Data received graph and the connectivity status of the data types.
1. You can select whether you want the alerts from Azure Security Center to automatically generate incidents in Azure Sentinel. Under **Create incidents**, select **Enabled** to turn on the default analytics rule that automatically creates incidents from alerts. You can then edit this rule under **Analytics**, in the **Active rules** tab.
1. To use the relevant schema in Log Analytics for the Azure Security Center alerts, search for **SecurityAlert**.

One advantage of using Azure Sentinel as your SIEM is that it provides data correlation across multiple sources, which enables you to have an end-to-end visibility of your organization’s security-related events.

> [!NOTE]
> To learn how to increase visibility in your data and identify potential threats, refer to [Azure playbooks on TechNet Gallery][technet-gallery-azure-playbooks], which has a collection of resources including a lab in which you can simulate attacks. You should not use this lab in a production environment.

To learn more about Azure Sentinel, refer to the following articles:

- [Quickstart][azure-sentinel-quickstart]: Get started with Azure Sentinel
- [Tutorial][azure-sentinel-tutorial]: Detect threats out-of-the-box

## Cost considerations

- As previously described, costs beyond your Azure subscription might include:
  1. Azure Security Center Standard tier. For more information, refer to [Security Center pricing][azure-security-center-pricing].
  1. Azure Monitor workspace offers granularity of billing. For more information, refer to [Manage Usage and Costs with Azure Monitor Logs][azure-monitor-storage-pricing].
  1. Azure Sentinel is a paid service. For more information, refer to [Azure Sentinel pricing][azure-sentinel-pricing].

## References

### Azure Monitor

- [Azure Monitor][azure-monitor]

### Azure Security Center

- [Azure Security Center][azure-security-center]
- [Azure Security Center Cloud Smart Alert Correlation][azure-security-center-cloud-smart-alert-correlation]
- [Azure Security Center Connect Data][azure-security-center-connect-data]
- [Azure Security Center Coverage][azure-security-center-coverage]
- [Azure Security Center Endpoint Protection][azure-security-center-endpoint-protection]
- [Azure Security Center FAQ][azure-security-center-faq]
- [Azure Security Center Planning][azure-security-center-planning]
- [Azure Security Center Secure Score][azure-security-center-secure-score]
- [Azure Security Center Security Alerts][azure-security-center-security-alerts]
- [Azure Security Center Security Policies][azure-security-center-security-policies]
- [Azure Security Center Security Recommendations][azure-security-center-security-recommendations]
- [Azure Security Center Security Recommendations][azure-security-center-security-recommendations]
- [Azure Security Center Supported Platforms][azure-security-center-supported-platforms]
- [Azure Security Center Threat Protection][azure-security-center-threat-protection]
- [Azure Security Center Tutorial][azure-security-center-tutorial]

### Azure Sentinel

- [Azure Sentinel][azure-sentinel]
- [Azure Sentinel Analytics][azure-sentinel-analytics]
- [Azure Sentinel Attack Detection][azure-sentinel-attack-detection]
- [Azure Sentinel Connect Windows Firewall][azure-sentinel-connect-windows-firewall]
- [Azure Sentinel Connect Windows Security Events][azure-sentinel-connect-windows-security-events]
- [Azure Sentinel Data Sources][azure-sentinel-data-sources]
- [Azure Sentinel Hunting][azure-sentinel-hunting]
- [Azure Sentinel Investigate][azure-sentinel-investigate]
- [Azure Sentinel Monitor][azure-sentinel-monitor]
- [Azure Sentinel Overview][azure-sentinel-overview]
- [Azure Sentinel Permissions][azure-sentinel-permissions]
- [Azure Sentinel Quickstart][azure-sentinel-quickstart]

### Azure Stack

- [Azure Stack][azure-stack]
- [Azure Stack Automate Onboarding PowerShell][azure-stack-automate-onboarding-powershell]
- [Azure Stack Hub][azure-stack-hub]

[architectural-diagram]: ./images/hybrid-security-monitoring.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/hybrid-security-monitoring.vsdx
[azure-monitor]: /azure/azure-monitor/
[azure-monitor-install-agent]: /azure/azure-monitor/platform/agent-windows#install-agent-using-setup-wizard
[azure-monitor-install-agent-linux]: /azure/azure-monitor/platform/agent-linux-troubleshoot
[azure-monitor-storage-pricing]: /azure/azure-monitor/platform/manage-cost-storage
[azure-security-center]: /azure/security-center/
[azure-security-center-alerts]: /azure/security-center/alerts-reference#alerts-linux
[azure-security-center-cloud-smart-alert-correlation]: /azure/security-center/security-center-alerts-overview#cloud-smart-alert-correlation-in-azure-security-center-incidents
[azure-security-center-connect-data]: /azure/sentinel/connect-azure-security-center
[azure-security-center-coverage]: /azure/security-center/security-center-services?tabs=features-windows
[azure-security-center-endpoint-protection]: /azure/security-center/security-center-endpoint-protection
[azure-security-center-faq]: /azure/security-center/security-center-alerts-overview#cloud-smart-alert-correlation-in-azure-security-center-incidents
[azure-security-center-health-monitoring]: /azure/security-center/security-center-monitoring
[azure-security-center-planning]: /azure/security-center/security-center-planning-and-operations-guide
[azure-security-center-pricing]: https://azure.microsoft.com/pricing/details/security-center/
[azure-security-center-secure-score]: /azure/security-center/secure-score-security-controls
[azure-security-center-security-alerts]: /azure/security-center/alerts-reference
[azure-security-center-security-policies]: /azure/security-center/tutorial-security-policy
[azure-security-center-security-recommendations]: /azure/security-center/recommendations-reference
[azure-security-center-security-recommendations]: /azure/security-center/security-center-recommendations
[azure-security-center-services]: /azure/security-center/security-center-services?tabs=features-windows
[azure-security-center-supported-platforms]: /azure/security-center/security-center-os-coverage
[azure-security-center-threat-protection]: /azure/security-center/threat-protection
[azure-security-center-tutorial]: /azure/security-center/tutorial-security-incident
[azure-sentinel]: /azure/sentinel/
[azure-sentinel-analytics]: /azure/sentinel/tutorial-detect-threats-built-in
[azure-sentinel-attack-detection]: /azure/sentinel/fusion
[azure-sentinel-connect-windows-firewall]: /azure/sentinel/connect-windows-firewall
[azure-sentinel-connect-windows-security-events]: /azure/sentinel/connect-windows-security-events
[azure-sentinel-data-sources]: /azure/sentinel/connect-data-sources
[azure-sentinel-hunting]: /azure/sentinel/hunting
[azure-sentinel-investigate]: /azure/sentinel/tutorial-investigate-cases
[azure-sentinel-monitor]: /azure/sentinel/tutorial-monitor-your-data
[azure-sentinel-overview]: /azure/sentinel/overview
[azure-sentinel-permissions]: /azure/sentinel/roles
[azure-sentinel-pricing]: https://azure.microsoft.com/pricing/details/azure-sentinel/
[azure-sentinel-quickstart]: /azure/sentinel/quickstart-get-visibility
[azure-sentinel-quickstart]: /azure/sentinel/quickstart-get-visibility
[azure-sentinel-tutorial]: /azure/sentinel/tutorial-detect-threats-built-in
[azure-stack]: /azure-stack/
[azure-stack-automate-onboarding-powershell]: /azure/security-center/security-center-powershell-onboarding
[azure-stack-hub]: /azure-stack/operator/azure-stack-overview?view=azs-2002
[icon-azurevm]: ./images/hybrid-security-monitoring-asc-Azure-VM.png
[icon-nonazurevm]: ./images/hybrid-security-monitoring-asc-non-Azure.png
[screenshot-collectdata]: ./images/hybrid-security-monitoring-collect-data-page.png
[screenshot-coverage]: ./images/hybrid-security-monitoring-asc-coverage.png
[screenshot-logworkspace]: ./images/hybrid-security-monitoring-log-analytics-mma-setup-workspace.png
[screenshot-output]: ./images/hybrid-security-monitoring-asc-output.png
[screenshot-overview]: ./images/hybrid-security-monitoring-asc-overview.png
[screenshot-search]: ./images/hybrid-security-monitoring-search-sentinel.png
[screenshot-workspace]: ./images/hybrid-security-monitoring-workspace.png
[technet-gallery-azure-playbooks]: https://gallery.technet.microsoft.com/site/search?query=Azure%20playbook&f[1].Value=Azure%20playbook&f[1].Type=SearchText&f[0].Value=security&f[0].Type=RootCategory&ac=5
[windows-defender-atp-onboard]: /windows/security/threat-protection/microsoft-defender-atp/configure-server-endpoints
