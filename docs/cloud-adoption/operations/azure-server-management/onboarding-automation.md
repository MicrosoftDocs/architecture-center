---
title: "Automate onboarding and alert configuration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Automate onboarding and alert configuration
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: operate
---

# Automate onboarding

To improve the efficiency of deploying Azure server management services, consider automating the deployment of management services by using the recommendations discussed in the previous sections of this guidance. The script and the example templates that are provided in the following sections are starting points for developing your own automation of onboarding processes.

## Onboarding by using Automation

This guidance has a supporting GitHub repository of sample code, [CloudAdoptionFramework](https://aka.ms/CAF/manage/automation-samples), which provides example scripts and Azure Resource Manager templates to help you automate the deployment of Azure server management services.

These sample files illustrate how to use Azure PowerShell cmdlets to automate the following tasks:

1. Create a [Log Analytics workspace](/azure/azure-monitor/platform/manage-access) (or use an existing workspace if it meets the requirements&mdash;see [Workspace planning](./prerequisites.md#log-analytics-workspace-and-automation-account-planning)).

2. Create an Automation account (or use an existing account if it meets the requirements&mdash;see [Workspace planning](./prerequisites.md#log-analytics-workspace-and-automation-account-planning)).

3. Link the Automation account and the Log Analytics workspace (not required if onboarding through the portal).

4. Enable Update Management and Change Tracking and Inventory for the workspace.

5. Onboard Azure VMs using Azure Policy (a policy installs the Log Analytics Agent and Dependency Agent on the Azure VMs).

6. Onboard on-premises servers by installing the Log Analytics agent on them.

The files described in the following table are used in this sample, and you can customize them to support your own deployment scenarios.

| File name | Description |
|-----------|-------------|
| New-AMSDeployment.ps1 | The main, orchestrating script that automates onboarding. This PowerShell script requires an existing subscription, but it will create resource groups, location, workspace, and Automation accounts if they do not exist. |
| Workspace-AutomationAccount.json | A Resource Manager template that deploys the workspace and Automation account resources. |
| WorkspaceSolutions.json | A Resource Manager template that enables your desired solutions in the Log Analytics workspace. |
| ScopeConfig.json | A Resource Manager template that uses the opt-in model for on-premises servers with the Change tracking solution. Using the opt-in model is optional. |
| Enable-VMInsightsPerfCounters.ps1 | A PowerShell script that enables VMInsight for servers and configures performance counters. |
| ChangeTracking-Filelist.json | A Resource Manager template that defines the list of files that will be monitored by Change Tracking. |

You can run New-AMSDeployment.ps1 by using the following command:

```powershell
.\New-AMSDeployment.ps1 -SubscriptionName '{Subscription Name}' -WorkspaceName '{Workspace Name}' -WorkspaceLocation '{Azure Location}' -AutomationAccountName {Account Name} -AutomationAccountLocation {Account Location}
```

## Next steps

Learn how to set up basic alerts to notify your team of key management events and issues.

> [!div class="nextstepaction"]
> [Setting up basic alerts](./setup-alerts.md)
