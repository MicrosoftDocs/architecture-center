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

In this example scenario we pursue a scenario where customers deploy a virtual networking architecture, such as a [Hub and Spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) model, and at some point in the future, this Hub virtual network needs additional IP Address spaces.  At this time, you can't add address ranges to, or delete address ranges from a virtual network's address space once a virtual network is peered with another virtual network. To add or remove address ranges, delete the peering, add or remove the address ranges, then re-create the peering manually.  To accommodate this scenario, we have developed two PowerShell scripts that can make this process much easier.

## Relevant Use Cases

The following use cases have been tested with these scripts:
• Single subscription scenarios where both hub and all spoke virtual networks are in the same subscription.
• Single Azure Active Directory tenant, different subscription scenarios where the hub virtual network is in one subscription and all other spoke virtual networks are in different subscriptions.

## Architecture

* Single Subscription

![Single Sub.png](Single Sub.png)

* Multiple Subscriptions

## Components
 * Virtual Networks
 * Virtual NEtwork Peerings

## Alternatives

Use one or a combination of the existing methods for removing Virtual Network peerings manually ([Azure Portal](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#delete-a-peering), [Azure PowerShell](https://docs.microsoft.com/en-us/powershell/module/az.network/remove-azvirtualnetworkpeering), or [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/network/vnet/peering)) before adding any new IP Address spaces.

## Considerations

* These scrips require the Azure PowerShell module version 1.0.0 or later. Run `Get-Module -ListAvailable Az` to find the installed version. If you need to upgrade, see [Install Azure PowerShell module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps). You need to run `Connect-AzAccount` to create a connection with Azure.
* Performing this exercise will result in outage or disconnections between the Hub and Spoke virtual networks.  Perform this during an approved maintenance window.
* The accounts you use to work with virtual network peering must be assigned to the [Network Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles?toc=%2fazure%2fvirtual-network%2ftoc.json#network-contributor) role or a [Custom Role](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles) containing the necessary actions found at https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#permissions.
* The accounts you use to add IP Address spaces must be assigned to the [Network Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles?toc=%2fazure%2fvirtual-network%2ftoc.json#network-contributor) role or a [Custom Role](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles) containing the necessary actions found at https://docs.microsoft.com/en-us/azure/virtual-network/manage-virtual-network#permissions. 
* The IP address space you wish to add to the Hub virtual network must not overlap with any of the IP address spaces of the Spoke virtual networks that you intend to peer with the Hub virtual network. 

