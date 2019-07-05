---
title: "Automate onboarding and alert configuration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Automate onboarding and alert configuration
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Automate onboarding

To improve the efficiency of deploying Azure server management services, consider automating the deployment of management services using the recommendations discussed in the previous sections of this guidance. The example Resource Manager templates and PowerShell scripts provided in the following sections are starting points for developing your own automation onboarding processes.

## Onboarding using Automation

This guidance has a supporting [sample code GitHub repository](https://aka.ms/CAF/manage/automation-samples) that provides example script and template files to help you automate the deployment of Azure server management services.

These sample files illustrate how to use Azure PowerShell cmdlets to automate the following:

1. Create a [Log Analytics workspace](/azure/azure-monitor/platform/manage-access) (or use an existing workspace if it meets the requirements&mdash;see [Workspace planning](./prerequisites.md#log-analytics-workspace-and-automation-account-planning)).
2. Create an Automation account (or use an existing one if it meets the requirements&mdash;see [Workspace planning](./prerequisites.md#log-analytics-workspace-and-automation-account-planning)).
3. Link the Automation account and the Log Analytics workspace (not required if onboarding through the portal).
4. Enable Update Management and Change Tracking and Inventory for the workspace.
5. Onboard Azure VMs using Azure Policy (a policy installs the Log Analytics Agent and Dependency Agent on the Azure VMs).
6. Onboard on-premises servers by installing the Log Analytics agent on them.

The following files are used in this sample and can be customized to support your own deployment scenarios:

| File name | Description |
|-----------|-------------|
| New-AMSDeployment.ps1 | The main orchestration PowerShell script used to automate onboarding. This script requires an existing subscription, but it will create resource groups, location, workspace, and Automation accounts if they do not exist. |
| Workspace-AutomationAccount.json | Resource Manager template used when deploying the workspace and Automation account resources. |
| WorkspaceSolutions.json | Resource Manager template used to enable the desired solutions in the Log Analytics workspace. |
| ScopeConfig.json | Resource Manager template optionally used if you want to use the opt-in model for on-premises servers with the Change tracking solution. |
| Enable-VMInsightsPerfCounters.ps1 | PowerShell script used to enable VMInsight for servers and set up performance counters. |
| ChangeTracking-Filelist.json | Resource Manager template used to define the list of files that will be monitored by Change Tracking. |

This sample script can be executed using the following command:

```powershell
.\New-AMSDeployment.ps1 -SubscriptionName '{Subscription Name}' -WorkspaceName '{Workspace Name}' -WorkspaceLocation '{Azure Location}' -AutomationAccountName {Account Name} -AutomationAccountLocation {Account Location}
```

## Next steps

Learn how to set up basic alerts to notify your team of key management events and issues.

> [!div class="nextstepaction"]
> [Setting up basic alerts](./setup-alerts.md)
