---
title: "Fusion: Azure Virtual Datacenter - Subscriptions" 
description: Discussing the subscription component the the Azure Virtual Datacenter (VDC) model
author: rotycenh
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - Subscriptions

Jump to: [Subscription requirements](#subscription-requirements) | [Geo-regional considerations](#geo-regional-considerations)

The [Azure Virtual Datacenter (VDC)](../virtual-datacenter/overview.md) model is intended to support a wide variety of [subscription design](overview.md) approaches. Although the VDC model supports deploying hub and spokes to a single subscription, one of the primary benefits of a VDC is the ability to centrally manage workloads spread across multiple subscriptions.  

 Your organization's accounting and ownership of VDC-hosted resources and workloads will depend on the departmental and account hierarchy of subscriptions in your Azure Enterprise Agreement. However, this hierarchy is independent from your VDC structure. A VDC can be deployed to strictly reflect your organization's hierarchy, or to provide access to resources from across your digital estate.

## Subscription requirements 

To support the secure deployment and management of resources across a virtual datacenter, all subscriptions hosting VDC resources need the following: 

- Common Azure AD tenant - All subscriptions with resources connecting to a VDC should be associated with a common [Azure AD tenant](../identity/vdc-identity.md), allowing access control based on a common set of users, groups, and roles.  
- Central IT admin access - A VDC assumes the use of a series of [central IT RBAC roles](../identity/overview.md#identity-and-the-azure-management-plane) for centralized management of security and policy enforcement across the VDC. All subscriptions should grant these roles appropriate permissions.

## Geo-regional considerations

Although subscriptions can host resources in multiple Azure regions, many organizations structure their subscription designs with geographic or sovereignty requirements in mind. [Global VNet Peering](https://azure.microsoft.com/en-us/blog/global-vnet-peering-now-generally-available/) allows a VDC to connect between virtual networks  in both different subscriptions and regions.

Deploying all VDC resources to the same region minimizes latency between hub and spoke environments for high-performance workloads and avoids cross-region policy issues. If your subscription design will result in a VDC that crosses regions, carefully consider any policy or performance impacts.

## Next steps

Learn  how [Identity and Roles](../identity/vdc-identity.md) are used to manage access control and enforce management and organizational structures within an Azure Virtual Datacenter.

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Identity and Roles](../identity/vdc-identity.md)