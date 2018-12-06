---
title: "Fusion: Azure Virtual Datacenter - Policy enforcement" 
description: Discussing the policy enforcement approach the the Azure Virtual Datacenter (VDC) model
author: rotycenh
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - Azure Policy enforcement in VDC

Jump to: [Azure policy definitions](#azure-policy-definitions) | [VDC policy recommendations](#vdc-policy-recommendations) | [Policy template examples](#policy-template-examples)

Policy enforcement in the the Azure Virtual Datacenter model requires a combination of [access control](../identity/vdc-identity.md), [encryption](../encryption/vdc-encryption.md), [networking configuration](../software-defined-networks/vdc-networking.md), and [monitoring](../logs-and-reporting/vdc-monitoring.md) to ensure your organization's requirements are being met. [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) helps add additional control over what types of resources can be created within a VDC and how resources are allowed to connect with each other in the VDC virtual network.

The default VDC model uses Azure Policy to enforce the following requirements:

- Traffic to and from workload spokes must flow through the central hub network.
- Spokes are only allowed to peer with the hub network.
- All data is encrypted at rest and in transit.
- Resources are deployed in accordance with your organization's resource grouping and tagging standards.

## Azure policy definitions

Azure policies can be created and applied through the portal, REST API, PowerShell, or Azure CLI. Definitions consist of a [standard JSON format](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure) that contain the following properties:

| Property          | Description                                                               |
|-------------------|---------------------------------------------------------------------------|
| Display name      | Policy name.  |
| Description       | Brief description of what the policy does. |
| Mode              | Allows you to choose if the policy applies to all resources, or only those that support tagging and are region-specific (most definitions will apply to all). |
| Parameters        | Allows you to include values in the definition that can be used for comparison in the policy rules. |
| Policy rule       | Rules consist of two parts:<ul><li>An *"if"* object testing what resources the policy applies to</li><li>A *"then"* object that specifies the rule's effect, for instance to deny the creation of certain resource types or trigger a compliance audit.</li></ul>See the Azure documentation for [understanding policy effects](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/effects) for more information on how effects are used in policy rules.   |

Once a policy definitions is created, you can then assign it at either the individual resource, resource group, or subscription level. Policy assignments apply to all resources contained by a resource group or subscription.

## VDC policy recommendations

The following sections provide recommended Azure Policy rules to apply at the subscription and resource group level when deploying a VDC.

### Subscription policy

As a baseline, all subscriptions used in a VDC deployment should have a common set of policy rules at the subscription level. 

| Policy                     | Description                                                               |
|----------------------------|---------------------------------------------------------------------------|
| Audit unassigned NSGs      | Triggers a compliance audit warning for any NSGs not assigned to a virtual network subnet or virtual network interface. |
| Enforce standard tagging   | Requires resources have values supplied for your organization's required tags.   |
| Enforce storage encryption | Requires Azure Storage accounts that have encryption enabled.              |
| Enforce storage HTTPS access | Enforces the use of SSL/TLS encryption for access to storage accounts.     |
| Enforce storage Service Endpoint | Requires storage accounts use [Virtual Network Service Endpoints](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview), preventing access to the account from outside the VDC virtual network.  |
| Enforce subnets use UDR | Prevents the creation of subnets that aren't associated with a pre-existing UDR. This ensures all subnets, and the virtual devices connected to them, obey routing rules defined by central IT. |  
| Permitted regions [optional]  | Defines the list of [Azure Regions](https://azure.microsoft.com/en-us/global-infrastructure/regions/) that resources are allowed to be created in.   |  
| Enforce Hub VNet Peeering [optional] | Applied to spoke subscriptions, this policy only allows virtual networks to peer with the hub network.    |  

### Resource Group policy

Most VDC resource groups should include some variation of the following policy definition types:

| Policy                     | Description                                                               |
|----------------------------|---------------------------------------------------------------------------|
| Restrict resource type     | Restricts what can be created in a resource group, based on resource type, enforcing the functional organization of your resource grouping. <br/><br/>Not a single policy, but a series of policies applied to specific resource groups. For instance, you can allow only key vault instances and logging storage accounts in a "Key Vault" resource group. Or only allow virtual networks, NSGs, UDRs, and related resources in a "Network" resource group.  |
| Deny Public IP             | Prevents the creation of publicly addressable IP addresses within the resource group, minimizing the possible attack surface of your VDC network. <br/><br/>You should apply this policy to any resource groups that do not have a legitimate need for public IPs. For example, the hub network resource group will need public IPs to enable VPN connections, while the rest of the hub resource groups don't need public IPs. Spoke resource groups should all apply this policy.<br/><br/>All resource groups that do not use this policy should be under central IT control. Any exceptions should be carefully monitored by your central IT security team.    |
| Enforce PaaS Service Endpoint | As with storage accounts at the subscription level, configure policy to enforce the use of [Virtual Network Service Endpoints](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview) on any PaaS services that support it, such as Key Vault or Azure SQL Database.  |

## Policy template examples

For general examples of Azure Policy definitions, see the [samples section of the  Azure documentation site](https://docs.microsoft.com/en-us/azure/governance/policy/samples/).

The Azure Virtual Datacenter Automation Toolkit[need public URL when this is released] also includes examples of applying Azure Policy definition as part of a template-driven VDC deployment.

## Next steps

Learn  how [naming and tagging](../resource-tagging/vdc-naming.md) are used to organize resources and improve management and access control of assets within an Azure Virtual Datacenter.

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Naming and Tagging](../resource-tagging/vdc-naming.md)