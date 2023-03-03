This reference architecture illustrates how to use Microsoft Defender for Cloud and Microsoft Sentinel to monitor the security configuration and telemetry of on-premises, Azure, and Azure Stack workloads.

## Architecture

![Diagram illustrating deployed Microsoft Monitoring Agent on on-premises systems as well as on Azure based virtual machines transferring data to Microsoft Defender for Cloud and Microsoft Sentinel][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Workflow

- **[Microsoft Defender for Cloud][azure-security-center]**. This is an advanced, unified security-management platform that Microsoft offers to all Azure subscribers. Defender for Cloud  is segmented as a cloud security posture management (CSPM) and cloud workload protection platform (CWPP). CWPP is defined by workload-centric security protection solutions, which are typically agent-based. Microsoft Defender for Cloud provides threat protection for Azure workloads, both on-premises and in other clouds, including Windows and Linux virtual machines (VMs), containers, databases, and Internet of Things (IoT). When activated, the Log Analytics agent deploys automatically into Azure Virtual Machines. For on-premises Windows and Linux servers and VMs, you can manually deploy the agent, use your organization's deployment tool, such as Microsoft Endpoint Protection Manager, or utilize scripted deployment methods. Defender for Cloud begins assessing the security state of all your VMs, networks, applications, and data.
- **[Microsoft Sentinel][azure-sentinel]**. Is a cloud-native Security Information and Event Management (SIEM) and security orchestration automated response (SOAR) solution that uses advanced AI and security analytics to help you detect, hunt, prevent, and respond to threats across your enterprise.
- **[Azure Stack][azure-stack]**. Is a portfolio of products that extend Azure services and capabilities to your environment of choice, including the datacenter, edge locations, and remote offices. Azure Stack implementations typically utilize racks of four to sixteen servers that are built by trusted hardware partners and delivered to your datacenter.
- **[Azure Monitor][azure-monitor]**. Collects monitoring telemetry from a variety of on-premises and Azure sources. Management tools, such as those in Microsoft Defender for Cloud and Azure Automation, also push log data to Azure Monitor.
- **Log Analytics workspace**. Azure Monitor stores log data in a Log Analytics workspace, which is a container that includes data and configuration information.
- **Log Analytics agent**. The Log Analytics agent collects monitoring data from the guest operating system and VM workloads in Azure, from other cloud providers, and from on-premises. The Log Analytics Agent supports Proxy configuration and, typically in this scenario, a Microsoft Operations Management Suite (OMS) Gateway acts as proxy.
- **On-premises network**. This is the firewall configured to support HTTPS egress from defined systems.
- **On-premises Windows and Linux systems**. Systems with the Log Analytics Agent installed.
- **Azure Windows and Linux VMs**. Systems on which the Microsoft Defender for Cloud monitoring agent is installed.

### Components

- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel)
- [Azure Stack](https://azure.microsoft.com/overview/azure-stack)
- [Azure Monitor](https://azure.microsoft.com/products/monitor)

## Scenario details

### Potential use cases

Typical uses for this architecture include:

- Best practices for integrating on-premises security and telemetry monitoring with Azure-based workloads
- Integrating Microsoft Defender for Cloud with Azure Stack
- Integrating Microsoft Defender for Cloud with Microsoft Sentinel

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Microsoft Defender for Cloud upgrade

This reference architecture uses **Microsoft Defender for Cloud** to monitor on-premises systems, Azure VMs, Azure Monitor resources, and even VMs hosted by other cloud providers. Details about Microsoft Defender for Cloud pricing can be found [here][azure-security-center-pricing].

### Customized Log Analytics Workspace

**Microsoft Sentinel** needs access to a Log Analytics workspace. In this scenario, you can't use the default Defender for Cloud Log Analytics workspace with Microsoft Sentinel. Instead, you create a customized workspace. Data retention for a customized workspace is based on the workspace pricing tier, and you can find pricing models for Monitor Logs [here][azure-monitor-storage-pricing].

> [!NOTE]
> Microsoft Sentinel can run on workspaces in any general availability (GA) region of Log Analytics except the China and Germany (Sovereign) regions. Data that Microsoft Sentinel generates, such as incidents, bookmarks, and alert rules, which may contain some customer data sourced from these workspaces, is saved either in Europe (for Europe-based workspaces), in Australia (for Australia-based workspaces), or in the East US (for workspaces located in any other region).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

A **security policy** defines the set of controls that are recommended for resources within a specified subscription. In Microsoft Defender for Cloud, you define policies for your Azure subscriptions according to the security requirements of your company and the type of applications or data sensitivity for each subscription.

The security policies that you enable in Microsoft Defender for Cloud drive security recommendations and monitoring. To learn more about security policies, refer to [Strengthen your security policy with Microsoft Defender for Cloud.][azure-security-center-health-monitoring] You can assign security policies in Microsoft Defender for Cloud only at the management or subscription group levels.

> [!NOTE]
> Part one of the reference architecture details how to enable Microsoft Defender for Cloud to monitor Azure resources, on-premises systems, and Azure Stack systems.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

As previously described, costs beyond your Azure subscription can include:

  1. Microsoft Defender for Cloud costs. For more information, refer to [Defender for Cloud pricing][azure-security-center-pricing].
  1. Azure Monitor workspace offers granularity of billing. For more information, refer to [Manage Usage and Costs with Azure Monitor Logs][azure-monitor-storage-pricing].
  1. Microsoft Sentinel is a paid service. For more information, refer to [Microsoft Sentinel pricing][azure-sentinel-pricing].

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Microsoft Defender for Cloud roles

Defender for Cloud assesses the configuration of your resources to identify security issues and vulnerabilities, and displays information related to a resource when you are assigned the role of owner, contributor, or reader for the subscription or resource group to which a resource belongs.

In addition to these roles, there are two specific Defender for Cloud roles:

- **Security Reader**. A user that belongs to this role has read only rights to Defender for Cloud. The user can observe recommendations, alerts, a security policy, and security states, but can't make changes.

- **Security Admin**. A user that belongs to this role has the same rights as the Security Reader, and also can update security policies, and dismiss alerts and recommendations. Typically, these are users that manage the workload.

- The security roles, **Security Reader** and **Security Admin**, have access only in Defender for Cloud. The security roles don't have access to other Azure service areas, such as storage, web, mobile, or IoT.

#### Microsoft Sentinel subscription

- To enable Microsoft Sentinel, you need contributor permissions to the subscription in which the Microsoft Sentinel workspace resides.
- To use Microsoft Sentinel, you need contributor or reader permissions on the resource group to which the workspace belongs.
- Microsoft Sentinel is a paid service. For more information, refer to [Microsoft Sentinel pricing][azure-sentinel-pricing].

### Performance efficiency

Performance efficiency is the ability of your workload to scale in an efficient manner to meet the demands that users place on it. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The Log Analytics Agent for Windows and Linux is designed to have very minimal impact on the performance of VMs or physical systems.

Microsoft Defender for Cloud operational process won't interfere with your normal operational procedures. Instead, it passively monitors your deployments and provides recommendations based on the security policies you enable.

## Deploy this scenario

### Create a Log Analytics workspace in the Azure portal

1. Sign into the Azure portal as a user with Security Admin privileges.
1. In the Azure portal, select **All services**. In the list of resources, enter **Log Analytics**. As you begin entering, the list filters based on your input. Select **Log Analytics workspaces**.
1. Select **Add** on the Log Analytics page.
1. Provide a name for the new Log Analytics workspace, such as **Defender for Cloud-SentinelWorkspace**. This name must be globally unique across all Azure Monitor subscriptions.
1. Select a subscription by selecting from the drop-down list if the default selection is not appropriate.
1. For **Resource Group**, choose to use an existing resource group or create a new one.
1. For **Location**, select an available geolocation.
1. Select **OK** to complete the configuration.
    ![New Workspace created for the architecture][screenshot-workspace]

### Enable Defender for Cloud

While you're still signed into the Azure portal as a user with Security Admin privileges, select **Defender for Cloud** in the panel. **Defender for Cloud - Overview** opens:

![Defender for Cloud Overview dashboard blade opens][screenshot-overview]

Defender for Cloud automatically enables the Free tier for any of the Azure subscriptions not previously onboarded by you or another subscription user.

### Upgrade Microsoft Defender for Cloud

1. On the Defender for Cloud main menu, select **Getting Started**.
1. Select the **Upgrade Now** button. Defender for Cloud lists your subscriptions and workspaces that are eligible for use.
1. You can select eligible workspaces and subscriptions to start your trial. Select the previously created workspace, **ASC-SentinelWorkspace.** from the drop-down menu.
1. In the Defender for Cloud main menu, select **Start trial**.
1. The **Install Agents** dialog box should display.
1. Select the **Install Agents** button. The **Defender for Cloud - Coverage** blade displays and you should observe your selected subscription.
    ![Security Coverage blade showing your subscriptions should be open][screenshot-coverage]

You've now enabled automatic provisioning and Defender for Cloud will install the Log Analytics Agent for Windows (**HealthService.exe**) and the **omsagent** for Linux on all supported Azure VMs and any new ones that you create. You can turn off this policy and manually manage it, although we strongly recommend automatic provisioning.

To learn more about the specific Defender for Cloud features available in Windows and Linux, refer to [Feature coverage for machines][azure-security-center-services].

### Enable Microsoft Defender for Cloud monitoring of on-premises Windows computers

1. In the Azure portal on the **Defender for Cloud - Overview** blade, select the **Get Started** tab.
1. Select **Configure** under **Add new non-Azure computers**. A list of your Log Analytics workspaces displays, and should include the **Defender for Cloud-SentinelWorkspace**.
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

The Log Analytics Agent service collects event and performance data, executes tasks, and other workflows defined in a management pack. Defender for Cloud extends its cloud workload protection platforms by integrating with **Microsoft Defender for Servers**. Together, they provide comprehensive endpoint detection and response (EDR) capabilities.

For more information about Microsoft Defender for Servers, refer to [Onboard servers to the Microsoft Defender for Servers service.][windows-defender-atp-onboard]

### Enable Microsoft Defender for Cloud monitoring of on-premises Linux computers

1. Return to the **Getting Started** tab as previously described.
1. Select **Configure** under **Add new non-Azure computers**. A list of your Log Analytics workspaces displays. The list should include the **Defender for Cloud-SentinelWorkspace** that you created.
1. On the **Direct Agent** blade under **DOWNLOAD AND ONBOARD AGENT FOR LINUX,** select **copy** to copy the **wget** command.
1. Open Notepad and then paste this command. Save this file to a location that you can access from your Linux computer.

> [!NOTE]
> On Unix and Linux operating systems, **wget** is a tool for non-interactive file downloading from the web. It supports HTTPS, FTPs, and proxies.

The Linux agent uses the Linux Audit Daemon framework. Defender for Cloud integrates functionalities from this framework within the Log Analytics agent, which enables audit records to be collected, enriched, and aggregated into events by using the Log Analytics Agent for Linux. Defender for Cloud continuously adds new analytics that use Linux signals to detect malicious behaviors on cloud and on-premises Linux machines.

For a list of the Linux alerts, refer to the [Reference table of alerts][azure-security-center-alerts].

### Install the Linux agent

To install the agent on the targeted Linux computers, follow these steps:

1. On your Linux computer, open the file that you previously saved. Select and copy the entire content, open a terminal console, and then paste the command.
1. Once the installation finishes, you can validate that the **omsagent** is installed by running the **pgrep** command. The command will return the **omsagent** process identifier (PID). You can find the logs for the agent at: **/var/opt/microsoft/omsagent/"workspace id"/log/**.

It can take up to 30 minutes for the new Linux computer to display in Defender for Cloud.

### Enable Microsoft Defender for Cloud monitoring of Azure Stack VMs

After you onboard your Azure subscription, you can enable Defender for Cloud to protect your VMs running on Azure Stack by adding the **Azure Monitor, Update and Configuration Management** VM extension from the Azure Stack marketplace. To do this:

1. Return to the **Getting Started** tab as previously described.
1. Select **Configure** under **Add new non-Azure computers**. A list of your Log Analytics workspaces displays, and it should include the **Defender for Cloud-SentinelWorkspace** that you created.
1. On the **Direct Agent** blade there is a link for downloading the agent and keys for your workspace ID to use during agent configuration. You don't need to download the agent manually. It'll be installed as a VM extension in the following steps.
1. To the right of **Workspace ID**, select **Copy**, and then paste the ID into Notepad.
1. To the right of **Primary Key**, select **Copy**, and then paste the key into Notepad.

### Enable Defender for Cloud monitoring of Azure Stack VMs

Microsoft Defender for Cloud uses the **Azure Monitor, Update and Configuration Management** VM extension bundled with Azure Stack. To enable the **Azure Monitor, Update and Configuration Management** extension, follow these steps:

1. In a new browser tab, sign into your **Azure Stack** portal.
1. Refer to the **Virtual machines** page, and then select the virtual machine that you want to protect with Defender for Cloud.
1. Select **Extensions**. The list of VM extensions installed on this VM displays.
1. Select the **Add** tab. The **New Resource** menu blade opens and displays the list of available VM extensions.
1. Select the **Azure Monitor, Update and Configuration Management** extension and then select **Create**. The **Install extension** configuration blade opens.
1. On the **Install extension** configuration blade, paste the **Workspace ID** and **Workspace Key (Primary Key)** that you copied into Notepad in the previous procedure.
1. When you finish providing the necessary configuration settings, select **OK**.
1. Once the extension installation completes, its status will display as **Provisioning Succeeded**. It might take up to one hour for the VM to appear in the Defender for Cloud portal.

For more information about installing and configuring the agent for Windows, refer to [Install the agent using setup wizard][azure-monitor-install-agent].

For troubleshooting issues for the Linux agent, refer to [How to troubleshoot issues with the Log Analytics agent for Linux][azure-monitor-install-agent-linux].

Now you can monitor your Azure VMs and non-Azure computers in one place. **Azure Compute** provides you with an overview of all VMs and computers along with recommendations. Each column represents one set of recommendations, and the color represents the VMs or computers and the current security state for that recommendation. Defender for Cloud also provides any detections for these computers in security alerts.
![Defender for Cloud list of systems monitored on the Compute blade][screenshot-output]

There are two types of icons represented on the **Compute** blade:

![Purple computer icon that represents a non-azure monitored computer][icon-nonazurevm] Non-Azure computer

![Blue terminal icon that represents an Azure monitored computer][icon-azurevm] Azure computer

> [!NOTE]
> Part two of the reference architecture will connect alerts from Microsoft Defender for Cloud and stream them into Microsoft Sentinel.

The role of Microsoft Sentinel is to ingest data from different data sources and perform data correlation across these data sources. Microsoft Sentinel leverages machine learning and AI to make threat hunting, alert detection, and threat responses smarter.

To onboard Microsoft Sentinel, you need to enable it, and then connect your data sources. Microsoft Sentinel comes with a number of connectors for Microsoft solutions, which are available out of the box and provide real-time integration, including Microsoft Security Center, Microsoft Threat Protection solutions, Microsoft 365 sources (including Office 365), Azure Active Directory (Azure AD), Microsoft Defender for Servers, Microsoft Defender for Cloud Apps, and more. Additionally, there are built-in connectors to the broader security ecosystem for non-Microsoft solutions. You can also use Common Event Format, syslog, or the Representational State Transfer API to connect your data sources with Microsoft Sentinel.

### Requirements for integrating Microsoft Sentinel with Microsoft Defender for Cloud

1. A Microsoft Azure Subscription
1. A Log Analytics workspace that isn't the default workspace created when you enable Microsoft Defender for Cloud.
1. Microsoft Defender for Cloud.

All three requirements should be in place if you worked through the previous section.

### Global prerequisites

- To enable Microsoft Sentinel, you need contributor permissions to the subscription in which the Microsoft Sentinel workspace resides.
- To use Microsoft Sentinel, you need contributor or reader permissions on the resource group to which the workspace belongs.
- You might need additional permissions to connect specific data sources. You don't need additional permissions to connect to Defender for Cloud.
- Microsoft Sentinel is a paid service. For more information, refer to [Microsoft Sentinel pricing][azure-sentinel-pricing].

### Enable Microsoft Sentinel

1. Sign into the Azure portal with a user that has contributor rights for **Defender for Cloud-Sentinelworkspace**.
1. Search for and select **Microsoft Sentinel**.
    ![In the Azure portal search for the term "Microsoft Sentinel"][screenshot-search]
1. Select **Add**.
1. On the **Microsoft Sentinel** blade, select **Defender for Cloud-Sentinelworkspace**.
1. In Microsoft Sentinel, select **Data connectors** from the **navigation** menu.
1. From the data connectors gallery, select **Microsoft Defender for Cloud**, and select the **Open connector page** button.
    ![In Microsoft Sentinel showing the open Collectors page][screenshot-collectdata]
1. Under **Configuration**, select **Connect** next to those subscriptions for which you want alerts to stream into Microsoft Sentinel. The **Connect** button will be available only if you have the required permissions and the Defender for Cloud subscription.
1. You should now observe the **Connection Status** as **Connecting**. After connecting, it will switch to **Connected**.
1. After confirming the connectivity, you can close Defender for Cloud **Data Connector** settings and refresh the page to observe alerts in Microsoft Sentinel. It might take some time for the logs to start syncing with Microsoft Sentinel. After you connect, you'll observe a data summary in the Data received graph and the connectivity status of the data types.
1. You can select whether you want the alerts from Microsoft Defender for Cloud to automatically generate incidents in Microsoft Sentinel. Under **Create incidents**, select **Enabled** to turn on the default analytics rule that automatically creates incidents from alerts. You can then edit this rule under **Analytics**, in the **Active rules** tab.
1. To use the relevant schema in Log Analytics for the Microsoft Defender for Cloud alerts, search for **SecurityAlert**.

One advantage of using Microsoft Sentinel as your SIEM is that it provides data correlation across multiple sources, which enables you to have an end-to-end visibility of your organization's security-related events.

> [!NOTE]
> To learn how to increase visibility in your data and identify potential threats, refer to [Azure playbooks on TechNet Gallery][technet-gallery-azure-playbooks], which has a collection of resources including a lab in which you can simulate attacks. You should not use this lab in a production environment.

To learn more about Microsoft Sentinel, refer to the following articles:

- [Quickstart][azure-sentinel-quickstart]: Get started with Microsoft Sentinel
- [Tutorial][azure-sentinel-tutorial]: Detect threats out-of-the-box

## Next steps

### Azure Monitor

- [Azure Monitor][azure-monitor]

### Microsoft Defender for Cloud

- [Microsoft Defender for Cloud][azure-security-center]
- [Microsoft Defender for Cloud Smart Alert Correlation][azure-security-center-cloud-smart-alert-correlation]
- [Microsoft Defender for Cloud Connect Data][azure-security-center-connect-data]
- [Microsoft Defender for Cloud Coverage][azure-security-center-coverage]
- [Microsoft Defender for Cloud Endpoint Protection][azure-security-center-endpoint-protection]
- [Microsoft Defender for Cloud FAQ][azure-security-center-faq]
- [Microsoft Defender for Cloud Planning][azure-security-center-planning]
- [Microsoft Defender for Cloud Secure Score][azure-security-center-secure-score]
- [Microsoft Defender for Cloud Security Alerts][azure-security-center-security-alerts]
- [Microsoft Defender for Cloud Security Policies][azure-security-center-security-policies]
- [Microsoft Defender for Cloud Security Recommendations][azure-security-center-security-recommendations]
- [Microsoft Defender for Cloud Supported Platforms][azure-security-center-supported-platforms]
- [Microsoft Defender for Cloud Threat Protection][azure-security-center-threat-protection]
- [Microsoft Defender for Cloud Tutorial][azure-security-center-tutorial]

### Microsoft Sentinel

- [Microsoft Sentinel][azure-sentinel]
- [Microsoft Sentinel Analytics][azure-sentinel-analytics]
- [Microsoft Sentinel Attack Detection][azure-sentinel-attack-detection]
- [Microsoft Sentinel Connect Windows Firewall][azure-sentinel-connect-windows-firewall]
- [Microsoft Sentinel Connect Windows Security Events][azure-sentinel-connect-windows-security-events]
- [Microsoft Sentinel Data Sources][azure-sentinel-data-sources]
- [Microsoft Sentinel Hunting][azure-sentinel-hunting]
- [Microsoft Sentinel Investigate][azure-sentinel-investigate]
- [Microsoft Sentinel Monitor][azure-sentinel-monitor]
- [Microsoft Sentinel Overview][azure-sentinel-overview]
- [Microsoft Sentinel Permissions][azure-sentinel-permissions]
- [Microsoft Sentinel Quickstart][azure-sentinel-quickstart]

### Azure Stack

- [Azure Stack][azure-stack]
- [Azure Stack Automate Onboarding PowerShell][azure-stack-automate-onboarding-powershell]
- [Azure Stack Hub][azure-stack-hub]

## Related resources

- [Implement a secure hybrid network](../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Enhanced-security hybrid messaging infrastructure — web access](../example-scenario/hybrid/secure-hybrid-messaging-web.yml)
- [Centralized app configuration and security](../solution-ideas/articles/appconfig-key-vault.yml)
- [Automate Sentinel integration with Azure DevOps](../example-scenario/devops/automate-sentinel-integration.yml)

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
