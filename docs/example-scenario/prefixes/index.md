---
title: Add IP Address spaces on Peered Virtual Networks in Azure
titleSuffix: Azure Example Scenarios
description: Your Description
author: randycampbell
ms.date: 02/01/2020
ms.topic: example-scenarios
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
    - fcp
---

# Add IP Address spaces on Peered Virtual Networks in Azure

In this example scenario we pursue a scenario where customers deploy a virtual networking architecture, such as a [Hub and Spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) model, and at some point in the future, this Hub virtual network needs additional IP Address spaces.  At this time, you can't add address ranges to, or delete address ranges from a virtual network's address space once a virtual network is peered with another virtual network. To add or remove address ranges, delete the peering, add or remove the address ranges, then re-create the peering manually.  To accommodate this scenario, we have developed two PowerShell scripts that can make this process easier.

## Relevant Use Cases

The following use cases have been tested with these scripts:

* Single subscription scenarios where both hub and all spoke virtual networks are in the same subscription.

* Single Azure Active Directory tenant, different subscription scenarios where the hub virtual network is in one subscription and all other spoke virtual networks are in different subscriptions.

## Architecture

* Single Subscription

![Single Sub.png](Single-Sub.png)

* Multiple Subscriptions

![Multi Sub.png](Multi-Sub.png)

## Components

* Virtual Networks
* Virtual Network Peerings

## Alternatives

Use one or a combination of the existing methods for removing Virtual Network peerings manually ([Azure Portal](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#delete-a-peering), [Azure PowerShell](https://docs.microsoft.com/en-us/powershell/module/az.network/remove-azvirtualnetworkpeering), or [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/network/vnet/peering)) before adding any new IP Address spaces.

## Considerations

* These scrips require the Azure PowerShell module version 1.0.0 or later. Run `Get-Module -ListAvailable Az` to find the installed version. If you need to upgrade, see [Install Azure PowerShell module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps). You need to run `Connect-AzAccount` to create a connection with Azure.
* Performing this exercise will result in outage or disconnections between the Hub and Spoke virtual networks.  Perform this during an approved maintenance window.
* The accounts you use to work with virtual network peering must be assigned to the [Network Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles?toc=%2fazure%2fvirtual-network%2ftoc.json#network-contributor) role or a [Custom Role](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles) containing the necessary actions found at https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#permissions.
* The accounts you use to add IP Address spaces must be assigned to the [Network Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles?toc=%2fazure%2fvirtual-network%2ftoc.json#network-contributor) role or a [Custom Role](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles) containing the necessary actions found at https://docs.microsoft.com/en-us/azure/virtual-network/manage-virtual-network#permissions. 
* The IP address space you wish to add to the Hub virtual network must not overlap with any of the IP address spaces of the Spoke virtual networks that you intend to peer with the Hub virtual network. 

## Add the IP Address Range

**Single Subscription**: This script automatically removes all Virtual Network peerings from the Hub Virtual Network, adds an IP address range prefix to the Hub Virtual Network based on Input parameters, adds the Virtual Network peerings back to the Hub Virtual Network, and reconnects the Hub virtual network peerings to the existing Spoke virtual network peerings. 

Before executing the script, the following items will need to be updated in the script:

* $SpokeRG
* $SpokeVNet
* $SpokePeeringName


```azurepowershell
#region Input parameters
param(
    # Address Prefix range (CIDR Notation, e.g., 10.0.0.0/24)
    [parameter(Mandatory=$true)]
    [ValidatePattern('^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$')]
	[String]$IPAddressRange1,

    # Address Prefix range (Subscription ID for Hub VNet)
    [parameter(Mandatory=$true)]
	[String]$HubVNetSubsID,

    # Address Prefix range (Hub VNet Resource Group Name)
    [parameter(Mandatory=$true)]
	[String]$HubVNetRGName,

    # Address Prefix range (Hub VNet Name)
    [parameter(Mandatory=$true)]
	[String]$HubVNetName
)
#endregion Input parameters

#region Set context to Hub VNet Subscription
Set-AzContext -Subscription $HubVNetSubsID
#endregion

#region Get All Hub VNet Peerings and Hub VNet Object
$hubpeerings = Get-AzVirtualNetworkPeering -ResourceGroupName $HubVNetRGName -VirtualNetworkName $HubVNetName
$hubvnet = Get-AzVirtualNetwork -Name $HubVNetName -ResourceGroupName $HubVNetRGName
#endregion

#region Remove All Hub VNet Peerings
$hubpeerings | Remove-AzVirtualNetworkPeering -Force
#endregion

#region ADD IP ADDRESS RANGE TO THE HUB VNET #
$hubvnet.AddressSpace.AddressPrefixes.Add($IPAddressRange1)
Set-AzVirtualNetwork -VirtualNetwork $hubvnet
#endregion

#region Get all Spoke VNet Peerings and "Reset" them

#AFTER THE HUB VNET PEERINGS ARE DELETED, THE SPOKE VNET PEERINGS ARE NOW IN A "DISCONNECTED" STATE.
#THE FOLLOWING COMMANDS PUTS THE SPOKE VNET PEERINGS INTO A VARIABLE AND THEN "RESETS" THEM TO AN "INITIATED" STATE.  

$spoke1peering = Get-AzVirtualNetworkPeering -ResourceGroupName $Spoke1RG -VirtualNetworkName $Spoke1VNet -Name $Spoke1PeeringName
Set-AzVirtualNetworkPeering -VirtualNetworkPeering $spoke1peering

#REPEAT FOR ANY ADDITIONAL SPOKE VNETS:

#$spoke2peering = Get-AzVirtualNetworkPeering -ResourceGroupName "Spoke2RG" -VirtualNetworkName "Spoke2VNet" -Name "Spoke2_to_Hub"
#Set-AzVirtualNetworkPeering -VirtualNetworkPeering $spoke2peering

#$spoke3peering = Get-AzVirtualNetworkPeering -ResourceGroupName "Spoke3RG" -VirtualNetworkName "Spoke3VNet" -Name "SpokeVNet3PeeringName"
#Set-AzVirtualNetworkPeering -VirtualNetworkPeering $spoke3peering

#endregion

#region Recreate All Hub VNet Peerings

#THE FOLLOWING COMMAND RECREATES ALL PREVIOUS HUB VNET PEERINGS THAT WERE DELETED WITH THE "ALLOW GATEWAY TRANSIT" OPTION ENABLED
#IF YOU ALSO NEED ANY ADDITIONAL FLAGS, SUCH AS "ALLOW FORWARDED TRAFFIC", SET THAT FLAG AT THE END OF THE COMMAND BELOW

$hubpeerings | ForEach-Object {Add-AzVirtualNetworkPeering -Name $_.Name -VirtualNetwork $hubvnet -RemoteVirtualNetworkId $_.RemoteVirtualNetwork.Id -AllowGatewayTransit}  
#endregion
```

**Multiple Subscriptions**:
This script automatically removes all Virtual Network peerings from the Hub Virtual Network, adds an IP address range prefix to the Hub Virtual Network based on an Input parameter, adds the Virtual Network peerings back to the Hub Virtual Network, and reconnects the Hub virtual network peerings to the existing Spoke virtual network peerings. 

Before executing the script, the following items will need to be updated in the script:

* $SpokeRG
* $SpokeVNet
* $SpokePeeringName
* $SpokeSubscriptionID


```azurepowershell
#region Input parameters
param(
    # Address Prefix range (CIDR Notation, e.g., 10.0.0.0/24)
    [parameter(Mandatory=$true)]
    [ValidatePattern('^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$')]
	[String]$IPAddressRange1,

    # Address Prefix range (Subscription ID for Hub VNet)
    [parameter(Mandatory=$true)]
	[String]$HubVNetSubsID,

    # Address Prefix range (Hub VNet Resource Group Name)
    [parameter(Mandatory=$true)]
	[String]$HubVNetRGName,

    # Address Prefix range (Hub VNet Name)
    [parameter(Mandatory=$true)]
	[String]$HubVNetName
)
#endregion Input parameters

#region Set context to Hub VNet Subscription
Set-AzContext -Subscription $HubVNetSubsID
#endregion

#region Get All Hub VNet Peerings and Hub VNet Object
$hubpeerings = Get-AzVirtualNetworkPeering -ResourceGroupName $HubVNetRGName -VirtualNetworkName $HubVNetName
$hubvnet = Get-AzVirtualNetwork -Name $HubVNetName -ResourceGroupName $HubVNetRGName
#endregion

#region Remove All Hub VNet Peerings
$hubpeerings | Remove-AzVirtualNetworkPeering -Force
#endregion

#region ADD IP ADDRESS RANGE TO THE HUB VNET #
$hubvnet.AddressSpace.AddressPrefixes.Add($IPAddressRange1)
Set-AzVirtualNetwork -VirtualNetwork $hubvnet
#endregion

#region Set Context to "Spoke1" subscription

# COPY AND PASTE THE SUBSCRIPTION ID FOR THE SPOKE SUBSCRIPTION    
Set-AzContext -Subscription $SpokeSubscriptionID
#endregion

#region Get all Spoke VNet Peerings and "Reset" them

#AFTER THE HUB VNET PEERINGS ARE DELETED, THE SPOKE VNET PEERINGS ARE NOW IN A "DISCONNECTED" STATE.
#THE FOLLOWING COMMANDS PUTS THE SPOKE VNET PEERINGS INTO A VARIABLE AND THEN "RESETS" THEM TO AN "INITIATED" STATE.  

$spoke1peering = Get-AzVirtualNetworkPeering -ResourceGroupName $Spoke1RG -VirtualNetworkName $Spoke1VNet -Name #SpokeVNet1PeeringName
Set-AzVirtualNetworkPeering -VirtualNetworkPeering $spoke1peering

#REPEAT FOR ANY ADDITIONAL SPOKE VNETS IN THIS SUBSCRIPTION LIKE THE FOLLOWING:

#$spoke2peering = Get-AzVirtualNetworkPeering -ResourceGroupName "Spoke2RG" -VirtualNetworkName "Spoke2VNet" -Name "SpokeVNet2PeeringName"
#Set-AzVirtualNetworkPeering -VirtualNetworkPeering $spoke2peering

#$spoke3peering = Get-AzVirtualNetworkPeering -ResourceGroupName "Spoke3RG" -VirtualNetworkName "Spoke3VNet" -Name "SpokeVNet3PeeringName"
#Set-AzVirtualNetworkPeering -VirtualNetworkPeering $spoke3peering

#endregion

# REPEAT STARTING AT LINE 49 FOR ANY ADDITIONAL SPOKE SUBSCRIPTIONS YOU MAY HAVE

#region Set context back to Hub VNet Subscription
Set-AzContext -Subscription $HubVNetSubsID
#endregion

#region Recreate All Hub VNet Peerings

#THE FOLLOWING COMMAND RECREATES ALL PREVIOUS HUB VNET PEERINGS THAT WERE DELETED WITH THE "ALLOW GATEWAY TRANSIT" OPTION ENABLED
#IF YOU ALSO NEED ANY ADDITIONAL FLAGS, SUCH AS "ALLOW FORWARDED TRAFFIC", SET THAT FLAG AT THE END OF THE COMMAND BELOW

$hubpeerings | ForEach-Object {Add-AzVirtualNetworkPeering -Name $_.Name -VirtualNetwork $hubvnet -RemoteVirtualNetworkId $_.RemoteVirtualNetwork.Id -AllowGatewayTransit}  
#endregion
```

## Pricing

There is a nominal charge for ingress and egress traffic that utilizes a virtual network peering. There is no change to existing pricing when adding an additional IP address space to an Azure virtual network.  For more information, see the [pricing page](https://azure.microsoft.com/pricing/details/virtual-network).

## Next Steps

* Learn more about [managing Virtual Network peerings](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering)

* Learn more about [managing IP Address ranges](https://docs.microsoft.com/en-us/azure/virtual-network/manage-virtual-network#add-or-remove-an-address-range) on Virtual Networks