---
title: "Guest Configuration policy"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Guest Configuration policy
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: operate
---

# Guest Configuration policy

The Azure Policy [Guest Configuration](/azure/governance/policy/concepts/guest-configuration) extension allows you to audit the configuration settings in a virtual machine. Guest Configuration is currently supported only on Azure VMs.

You can find the list of Guest Configuration policies by searching for the category "Guest Configuration" on the Azure Policy portal page. You can also find the list by running this cmdlet in a PowerShell window:

```powershell
Get-AzPolicySetDefinition | where-object {$_.Properties.metadata.category -eq "Guest Configuration"}
```

> [!NOTE]
> Guest Configuration functionality is regularly updated to support additional policy sets. Check for new supported policies periodically and evaluate whether they're useful for your needs.

<!-- TODO: Update these links when available. 

By default, we recommend enabling the following policies:

- [Preview]: Audit to verify password security settings are set correctly inside Linux and Windows machines.
- Audit to verify that certificates are not nearing expiration on Windows VMs.

-->

## Deployment

You can use the following example PowerShell script to deploy these policies:

- Verify that password security settings in Windows and Linux computers are set correctly.
- Verify that certificates aren't close to expiration on Windows VMs.

 Before you run this script, you'll need to sign in by using the [Connect-AzAccount](https://docs.microsoft.com/powershell/module/az.accounts/connect-azaccount?view=azps-2.1.0) cmdlet. When you run the script, you'll need to provide the name of the subscription you want to apply the policies to.

```powershell
#Assign Guest Configuration policy.
param (
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionName
)

$Subscription = Get-AzSubscription -SubscriptionName $SubscriptionName
$scope = "/subscriptions/" + $Subscription.Id

$PasswordPolicy = Get-AzPolicySetDefinition -Name "3fa7cbf5-c0a4-4a59-85a5-cca4d996d5a6"
$CertExpirePolicy = Get-AzPolicySetDefinition -Name "b6f5e05c-0aaa-4337-8dd4-357c399d12ae"

New-AzPolicyAssignment -Name "PasswordPolicy" -DisplayName "[Preview]: Audit that password security settings are set correctly inside Linux and Windows machines" -Scope $scope -PolicySetDefinition $PasswordPolicy -AssignIdentity -Location eastus

New-AzPolicyAssignment -Name "CertExpirePolicy" -DisplayName "[Preview]: Audit that certificates are not expiring on Windows VMs" -Scope $scope -PolicySetDefinition $CertExpirePolicy -AssignIdentity -Location eastus
```

## Next steps

Learn how to [enable change tracking and alerting](./enable-tracking-alerting.md) for critical file, service, software, and registry changes.

> [!div class="nextstepaction"]
> [Enable tracking and alerting for critical changes](./enable-tracking-alerting.md)
