---
title: "Create update schedules"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Create update schedules
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Create update schedules

Update schedules can be managed using the Azure portal or the new PowerShell cmdlet modules.

To create an update schedule via the Azure portal, see [Schedule an update deployment](/azure/automation/automation-tutorial-update-management#schedule-an-update-deployment).

The Az.Automation module now includes support for configuring Update Management using Azure PowerShell. [Version 1.7.0](https://www.powershellgallery.com/packages/Az/1.7.0) of the module adds support for the [New-AzAutomationUpdateManagementAzureQuery](/powershell/module/az.automation/new-azautomationupdatemanagementazurequery?view=azps-1.7.0) cmdlet, which allows you to use tags, location, and saved searches to support update schedules using a flexible grouping of machines.

## Example script

The following example script illustrates the use of tagging and querying to create dynamic groups of machines that update schedules can be applied to. It performs the following specific actions, which you can reference when creating your own scripts:

- Creates an Azure Automation update schedule set to run every Saturday at 8 AM.
- Creates a query for machines that match the following criteria:
  - Machines are deployed in the `westus`, `eastus`, and `eastus2` Azure locations.
  - Machines have a tag applied to them named `Owner` with a value set to `JaneSmith`.
  - Machines have a tag applied to them named `Production` with a value set to `true`.
- Applies the update schedule to the queried machines and sets a two-hour update window.

Before running the example script, you will need to login using the [Connect-AzAccount](https://docs.microsoft.com/powershell/module/az.accounts/connect-azaccount?view=azps-2.1.0) cmdlet. On launching the script, you will need to provide the following information:

- The target subscription ID.
- The target resource group.
- Your Log Analytics workspace name.
- Your Azure Automation account name.

```powershell
<#
    .SYNOPSIS
        This script rolls orchestrate the deployment of the solutions and the agents.
    .Parameter SubscriptionName
    .Parameter WorkspaceName
    .Parameter AutomationAccountName
    .Parameter ResourceGroupName

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$WorkspaceName,

    [Parameter(Mandatory=$true)]
    [string]$AutomationAccountName,

    [Parameter(Mandatory=$false)]
    [string]$scheduleName = "SaturdayCritialSecurity"
)

Import-Module Az.Automation

$startTime = ([DateTime]::Now).AddMinutes(10)
$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                     -AutomationAccountName $AutomationAccountName  `
                                     -StartTime $startTime `
                                     -Name $scheduleName `
                                     -Description "Saturday patches" `
                                     -DaysOfWeek Saturday `
                                     -WeekInterval 1 `
                                     -ForUpdateConfiguration

# Using AzAutomationUpdateManagementAzureQuery to create dynamic groups

$queryScope = @("/subscriptions/$SubscriptionID/resourceGroups/")

$query1Location =@("westus", "eastus", "eastus2")
$query1FilterOperator = "Any"
$ownerTag = @{"Owner"= @("JaneSmith")}
$ownerTag.add("Production", "true")

$DGQuery = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccountName `
                                       -Scope $queryScope `
                                       -Tag $ownerTag

$AzureQueries = @($DGQuery)

$UpdateConfig = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $ResourceGroupName `
                                                             -AutomationAccountName $AutomationAccountName `
                                                             -Schedule $schedule `
                                                             -Windows `
                                                             -Duration (New-TimeSpan -Hours 2) `
                                                             -AzureQuery $AzureQueries `
                                                             -IncludedUpdateClassification Security,Critical
```

## Next steps

See examples of how to implement [common policies in Azure](./common-policies.md) to help manage your servers.

> [!div class="nextstepaction"]
> [Common policies in Azure](./common-policies.md)
