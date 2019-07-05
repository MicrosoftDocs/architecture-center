---
title: "Common Azure Policy examples"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Common Azure Policy examples
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Common Azure Policy examples

[Azure Policy](https://docs.microsoft.com/azure/governance/policy/overview) provides powerful capabilities that help you to apply governance to your cloud resources. This service can be used to help create guardrails ensuring company-wide compliance to governance policy requirements. To create policies, use either the Azure portal or PowerShell cmdlets. Some PowerShell cmdlet examples are provided below.

> [!NOTE]
> With Azure Policy, enforcement policies (deployIfNotExists) are not automatically deployed to existing VMs. To keep them in compliance, they require remediation. See this article for details on how to understand and accomplish remediation with policy.

## Common policy examples

Some commonly used policies:

### Restrict resource regions

Regulatory and policy compliance will often depend on control the physical location where resources are deployed. You can use a built-in policy to only allow users to create resources in whitelisted Azure regions. You can find it in the portal by searching "location" in the policy definition page.

Alternatively, you can run this cmdlet to find the policies:

```powershell
Get-AzPolicyDefinition | Where-Object { ($_.Properties.policyType -eq "BuiltIn") -and ($_.Properties.displayName -like "*location*") }
```

The following example script illustrates how to assign the policy. To use it, modify the ```$SubscriptionID``` to point to the subscription you want to assign this policy to. Before running this script, you will need to sign in using the [Connect-AzAccount](https://docs.microsoft.com/powershell/module/az.accounts/connect-azaccount?view=azps-2.1.0) cmdlet.

```powershell
#Specify the value for $SubscriptionID below
$SubscriptionID = <subscription ID>
$scope = "/subscriptions/$SubscriptionID"

#replace the -Name GUID with the policy GUID you want to assign
$AllowedLocationPolicy = Get-AzPolicyDefinition -Name "e56962a6-4747-49cd-b67b-bf8b01975c4c"

#replace the locations for the list you want to specify
$policyParam = '{"listOfAllowedLocations":{"value":["eastus","westus"]}}'
New-AzPolicyAssignment -Name "Allowed Location" -DisplayName "Allowed locations for resource creation" -Scope $scope -PolicyDefinition $AllowedLocationPolicy -Location eastus -PolicyParameter $policyparam
```

You can use this same example script to apply the other policies discussed in this article by replacing the GUID in the line setting the  ```$AllowedLocationPolicy``` with a GUID associated the policy you want to apply.

### Block certain resource types

Another common built-in policy used to control costs is to block certain resource types. You can find this policy in the portal by searching "allowed resource types" on the policy definition page.

Alternatively, you can run this cmdlet to get the policies:

```powershell
Get-AzPolicyDefinition | Where-Object { ($_.Properties.policyType -eq "BuiltIn") -and ($_.Properties.displayName -like "*allowed resource types") }
```

Once you have identified the policy you want to use, you can modify the powershell sample in the [Restrict resource regions](#restrict-resource-regions) section to assign this policy.

### Restrict VM size

Azure offers a wide range of VM sizes supporting various types of workloads. To be more effective with your budget, you could create a policy that allows only a subset of VM sizes to your subscriptions.

### Deploy Antimalware

This policy allows you to deploy a Microsoft IaaSAntimalware extension with a default configuration when a VM is not protected by any antimalware application.

The policy GUID is '2835b622-407b-4114-9198-6f7064cbe0dc'.

The following example script illustrates how to assign the policy. To use it, modify the ```$SubscriptionID``` to point to the subscription you want to assign this policy to. Before running this script, you will need to sign in using the [Connect-AzAccount](https://docs.microsoft.com/powershell/module/az.accounts/connect-azaccount?view=azps-2.1.0) cmdlet.

```powershell
#Specify the value for $SubscriptionID below
$SubscriptionID = <subscription ID>
$scope = "/subscriptions/$SubscriptionID"

$AntimalwarePolicy = Get-AzPolicyDefinition -Name "2835b622-407b-4114-9198-6f7064cbe0dc"

#replace location “eastus” to the value you want to use
New-AzPolicyAssignment -Name "Deploy Antimalware" -DisplayName "Deploy default Microsoft IaaSAntimalware extension for Windows Server" -Scope $scope -PolicyDefinition $AntimalwarePolicy -Location eastus –AssignIdentity

```

## Next steps

Understand what other server management tools and services are available.

> [!div class="nextstepaction"]
> [Azure server management tools and services](./tools-services.md)
