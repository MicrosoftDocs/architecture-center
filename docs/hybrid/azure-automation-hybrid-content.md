Runbooks in Azure Automation might not have access to resources in other clouds or in your on-premises environment because they run on the Azure cloud platform. You can use the Hybrid Runbook Worker feature of Azure Automation to run runbooks directly on the machine hosting the role and against resources in the environment to manage those local resources. Runbooks are stored and managed in Azure Automation and then delivered to one or more assigned machines.

## Runbook integration types

Azure Automation provides native integration of the Hybrid Runbook Worker role through the Azure virtual machine (VM) extension framework. The Azure VM agent is responsible for management of the extension on Azure VMs on Windows and Linux VMs, and on non-Azure machines through the Arc-enabled servers connected Machine agent. Now, there are two Hybrid Runbook Workers installation platforms supported by Azure Automation.


|**Platform** | **Description**
--- | ---
[Extension-based(V2)][1] | Installed using the Hybrid Runbook Worker VM extension, without any dependency on the Log Analytics agent reporting to an Azure Monitor Log Analytics workspace. This is the **recommended** approach, as it offers seamless onboarding and ease of manageability.
[Agent-based(V1)][2] | Installed after the Log Analytics agent reporting to an Azure Monitor Log Analytics workspace is completed.

A hybrid worker can co-exist with both platforms: Agent based (V1) and Extension based (V2). If you install Extension based (V2) on a hybrid worker already running Agent based (V1), then you would see two entries of the Hybrid Runbook Worker in the group. One with Platform Extension based (V2) and the other Agent based (V1). [Learn more][3]

## Runbook worker types

There are two types of Runbook Workers - System and User. The following table describes the difference between them.

**Type** | **Description**
--- | ---
**System** | Supports a set of hidden runbooks used by the Update Management feature that are designed to install user-specified updates on Windows and Linux machines.This type of Hybrid Runbook Worker isn't a member of a Hybrid Runbook Worker group, and therefore doesn't run runbooks that target a Runbook Worker group.
**User** | Supports user-defined runbooks intended to run directly on the Windows and Linux machine that are members of one or more Runbook Worker groups.

The extension-based Hybrid Runbook Worker only supports the user Hybrid Runbook Worker type and doesn't include the system Hybrid Runbook Worker required for the Update Management feature. 

Agent-based (V1) Hybrid Runbook Workers rely on the [Log Analytics agent][4] reporting to an Azure Monitor [Log Analytics workspace][5]. The workspace isn't only to collect monitoring data from the machine, but also to download the components required to install the agent-based Hybrid Runbook Worker. When Azure Automation [Update Management][6] is enabled, any machine connected to your Log Analytics workspace is automatically configured as a system Hybrid Runbook Worker.

## Architecture

### Components

The architecture consists of the following components:

- Automation Account: A cloud service that automates configuration and management across your Azure and non-Azure environments.
- Hybrid Runbook Worker: A computer that is configured with the Hybrid Runbook Worker feature and can execute runbooks directly on the computer and against the resources in the local environment.
- Hybrid Runbook Worker Group: Groups multiple Hybrid runbook workers for higher availability and scale to run a set of runbooks.
- A Runbook: A collection of one or more linked activities that together automate a process or operation. [Learn more][7]
- On-premises machines and VMs: On-premises computers and VMs with Windows or Linux operating system hosted in a private local-area network.
- Components applicable for extension-based approach (V2):
    - Hybrid Runbook Worker VM Extension: A small application installed on a computer that configures it as a Hybrid Runbook Worker 
    - Arc-enabled Server: Azure Arc-enabled servers enables you to manage your Windows and Linux physical servers and virtual machines hosted outside of Azure, on your corporate network, or other cloud provider. This management experience is designed to be consistent with how you manage native Azure virtual machines. [Learn more][8]
- Components applicable for agent-based approach (V1):
    - Log Analytics Workspace: A Log Analytics workspace is a data repository for log data collected from resources that run in Azure, on-premises or in another cloud provider.
    - Automation Hybrid Worker solution: With this, you can create Hybrid Runbook Workers to run Azure Automation runbooks on your Azure and non-Azure computers.

#### User Hybrid Runbook Worker

![Azure Automation in a User Hybrid Runbook Worker][architectural-diagram]
*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Each user Hybrid Runbook Worker is a member of a Hybrid Runbook Worker group that you specify when you install the worker. A group can include a single worker, but you can include multiple workers in a group for high availability. Each machine can host one Hybrid Runbook Worker reporting to one Automation account; you can't register the hybrid worker across multiple Automation accounts. A hybrid worker can only listen for jobs from a single Automation account.

#### System Hybrid Runbook Worker

![Azure Automation in a System Hybrid Runbook Worker][System-architectural-diagram]
*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

For machines hosting the system Hybrid Runbook worker managed by Update Management, they can be added to a Hybrid Runbook Worker group. But you must use the same Automation account for both Update Management and the Hybrid Runbook Worker group membership.

#### Job execution on Hybrid Runbook Worker

When you start a runbook on a user Hybrid Runbook Worker, you specify the group that it runs on. Each worker in the group polls Azure Automation to see if any jobs are available. If a job is available, the first worker to get the job takes it. The processing time of the jobs queue depends on the hybrid worker hardware profile and load. You can't specify a particular worker. Hybrid worker works on a polling mechanism (every 30 secs) and follows an order of first-come, first-serve.

## Scalability considerations

- A Hybrid Runbook Worker doesn't have many of the [Azure sandbox][9] resource [limits][10] on disk space, memory, or network sockets. The limits on a hybrid worker are only related to the worker's own resources, and they aren't constrained by the [fair share][11] time limit that Azure sandboxes have.
- The following table shows the limits applicable for Hybrid Runbook Workers. If you have more than 4,000 machines to manage, we recommend creating another Automation account.

**Resource** | **Limit**
--- | ---
Maximum number of system hybrid runbook workers per Automation Account| 4000
Maximum number of user hybrid runbook workers per Automation Account | 4000
Maximum number of concurrent jobs that can be run on a single Hybrid Runbook Worker | 50

- Increased demands for processing large number of jobs can be solved by organizing multiple Hybrid Workers into Hybrid Worker Groups. Runbooks are executed on each Hybrid worker using queuing mechanisms. The Hybrid worker checks the Automation account once every 30 seconds and picks up four jobs to execute. If your rate of pushing jobs is higher than four per 30 seconds, then there's a high possibility another hybrid worker in the Hybrid Runbook Worker group picked up the job.
- Multiple Hybrid Worker Groups can execute runbooks automation tasks using different Run As accounts.
- To control the distribution of runbooks on Hybrid Runbook Workers and when or how the jobs are triggered, you can register the hybrid worker against different Hybrid Runbook Worker groups within your Automation account. Target the jobs against the specific group or groups to support your execution arrangement.
- Applicable only for agent-based approach (V1) - the Log Analytics Agent for Windows and Linux have very minimal impact on the machine performance. Scale up your workers by configuring to run on more powerful machines with higher performance including memory, CPU, IOPs.

## Availability considerations

- A Hybrid Runbook Worker Group with more than one machine configured with Hybrid Worker Role provides high availability because runbooks will start only on servers that are running and healthy.
- The extension-based (V1) Hybrid Runbook Worker only supports the user Hybrid Runbook Worker type and doesn't include the system Hybrid Runbook Worker required for the Update Management feature.
- Applicable only for agent-based approach (V1) - Currently, mappings between Log Analytics Workspace and Automation Account are supported in several regions. For further information, refer to Supported regions for linked Log Analytics workspace.

## Manageability considerations

- The extension-based approach (V2) offers ease of manageability as compared to agent-based approach (V1) through:
    - Native integration with ARM identity for Hybrid Runbook Worker and provides the flexibility for governance at scale through policies and templates.
    - Centralized control and management of identities and resource credentials, since it uses VM system assigned-identities provided by Azure AD.
    -	Unified experience for both Azure and non-Azure machines while onboarding and deboarding Hybrid Runbook Workers.

- Applicable only for agent-based approach (V1):
    - To accelerate deployment of the Log Analytics Agent with Hybrid Worker Role running on Windows machine, use the PowerShell script New-OnPremiseHybridWorker.ps1.
    - Deployment of many agents in on-premises infrastructure can be orchestrated using command line scripts and deployed using Group Policy or System Center Configuration Manager.

## Security considerations

- Encryption of sensitive assets in Automation: An Azure Automation Account can contain sensitive assets such as credentials, certificate, connection, and encrypted variables that might be used by the runbooks. Each secure asset is encrypted by default using a Data Encryption key that is generated for each Automation Account. These keys are encrypted and stored in Azure Automation with an Account Encryption Key (AEK) that can be stored in the Key Vault for customers who want to manage encryption with their own keys. By default, AEK is encrypted using Microsoft-managed Keys. Use the following guidelines to apply encryption of secure assets in Azure Automation.
- Runbook permission: By default, runbook permissions for a Hybrid Runbook Worker run in a system context on the machine where they're deployed. A runbook provides its own authentication to local resources. Authentication can be configured using managed identities for Azure resources or by specifying a Run As account to provide a user context for all runbooks.
- Network planning: 
    - If you use a proxy server for communication between Azure Automation and machines running the Hybrid Runbook Worker, ensure that the appropriate resources are accessible. The timeout for requests from the Hybrid Runbook Worker and Automation services is 30 seconds. After three attempts, a request fails.
    - Hybrid Runbook Worker requires outbound internet access over TCP port 443 to communicate with Automation. If you use a firewall to restrict access to the Internet, you must configure the firewall to permit access. For agent-based (V1) computers with restricted internet access, use Log Analytics gateway to configure communication with Azure Automation and Azure Log Analytics Workspace.
    - There is a CPU quota limit of 5% while configuring extension-based Linux Hybrid Runbook worker. There is no such limit for Windows extension-based Hybrid Runbook Worker.

- Azure Security baseline for Automation: The Azure security baseline for Automation contains recommendations on how to increase overall security configuration to protect your asset following best-practice guidance.

## DevOps considerations

- Azure Automation allows integration with popular source control systems, Azure DevOps, and GitHub. With Source Control, you can integrate the existing development environment that contains your scripts and custom code that have been previously tested in an isolated environment.
- For information on how to integrate Azure Automation with your Source Control environment, refer to: Use source control integration.

## Cost considerations

- Azure Automation costs are priced for job execution per minute. Every month, the first 500 minutes of process automation are free. Use the Azure pricing calculator to estimate costs. Pricing models for Azure Automation are explained here.
- For agent-based approach (V1) - Azure Log Analytics Workspace might generate additional costs related to the amount of log data stored in the Azure Log Analytics. The pricing model is based on consumption. The costs are associated for data.


## Next steps

More about Azure Automation:

- [Hybrid Runbook Worker overview](/azure/automation/automation-hybrid-runbook-worker)
- [Deploy extension-based Windows or Linux User Hybrid Runbook Worker](/azure/automation/extension-based-hybrid-runbook-worker-install)
- [Deploy an agent-based Windows Hybrid Runbook Worker in Automation](/azure/automation/automation-windows-hrw-install)
- [Deploy an agent-based Linux Hybrid Runbook Worker in Automation](/azure/automation/automation-linux-hrw-install)
- [Create an Azure Automation account](/azure/automation/automation-quickstart-create-account)
- [Create a runbook in Azure Automation using Managed Identities](/azure/automation/learn/powershell-runbook-managed-identity)
- [Run Automation runbooks on a Hybrid Runbook Worker](/azure/automation/automation-hrw-run-runbooks)
- [Pre-requisites: Azure Automation network configuration details](/azure/automation/automation-network-configuration)
- [Azure Arc Overview](/azure/azure-arc/overview)
- [What is Azure Arc enabled servers?](/azure/azure-arc/servers/overview)

## Related resources

- [Hybrid architecture design](/azure/architecture/hybrid/hybrid-start-here)
- [Connect an on-premises network to Azure](/azure/architecture/reference-architectures/hybrid-networking)
- [Enterprise monitoring with Azure Monitor](/azure/architecture/example-scenario/monitoring/enterprise-monitoring)
- [Computer forensics chain of custody in Azure](/azure/architecture/example-scenario/forensics)
- [Disaster Recovery for Azure Stack Hub virtual machines](/azure/architecture/hybrid/azure-stack-vm-dr)


[architectural-diagram]: ./images/azure-automation-hybrid.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-automation-system.vsdx
[System-architectural-diagram]: ./images/azure-automation-system.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-automation-hybrid.vsdx
[1]: /azure/automation/extension-based-hybrid-runbook-worker
[2]: /azure/automation/automation-windows-hrw-install
[3]: /azure/automation/extension-based-hybrid-runbook-worker-install
[4]: /azure/azure-monitor/agents/log-analytics-agent
[5]: /azure/azure-monitor/logs/design-logs-deployment
[6]: /azure/automation/update-management/overview
[7]: /azure/automation/automation-runbook-types
[8]: /azure/azure-arc/servers/overview
[9]: /azure/automation/automation-runbook-execution#runbook-execution-environment
[10]: /azure/azure-resource-manager/management/azure-subscription-service-limits#automation-limits
[11]: /azure/automation/automation-runbook-execution#fair-share
