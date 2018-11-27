---
title: "Fusion: Azure Virtual Datacenter - Identity and Roles" 
description: Discusses how Azure Active Directory and RBAC is used within the Azure Virtual Datacenter (VDC) model
author: rotycen
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - Identity and Roles

The [Identity topic](overview.md) of the [Fusion framework](../../overview.md)'s [infrastructure section](../overview.md) discusses identity in general and how identity is used within Azure to manage access control and resource management. This discussion below will explore how identity services lie at the core of the Azure Virtual Datacenter model's ability to manage access control and insure isolation of your cloud hosted resources.

## Azure Active Directory Tenants

The Azure Virtual Datacenter model uses Azure Active Directory (Azure AD) as its primary identity provider. Workloads hosted within a VDC may take advantage of other identity solutions, but the hub network, shared services, and management plane features are all dependent on Azure AD for access control and management.

An Azure AD tenant is a dedicated instance of an Azure AD directory that your organization receives when it signs up for a Microsoft cloud service such as Azure or Office 365. Each Azure AD directory is distinct and separate from other Azure AD directories, and contains its own users, groups, and roles. An Azure AD tenant is a pre-requisite for deploying resources on Azure.

Along with planning your [subscription](../subscriptions/vdc-subscriptions.md) strategy, picking the Azure AD tenant you'll be using with your VDC is one of the first things you'll need to decide. An Azure tenant can be used by multiple subscriptions, but subscriptions can only associate with a single tenant. As part of VDC deployment you can choose to use an existing tenant owned by your organization or create a net new one explicitly for the VDC. 

## Federation and hybrid identity

VDC assumes you have existing on-premise identity infrastructure and need to use consistent users and roles across your organization. If you do not already have an federation identity solution in place, Azure AD Connect allows you to integrate their on-premises directory services with Azure AD. [Azure AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-hybrid-identity?toc=%2Fen-us%2Fazure%2Factive-directory%2Fhybrid%2FTOC.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json) is used to provide synchronization of users and roles between on-premises Active Directory service and the Azure AD tenant associated with the virtual datacenter.  

## Roles and RBAC

As with an on-premises datacenter, certain groups of people are responsible for jobs within your IT environment. A VDC doesn't need facilities management or physical security, but many other responsibilities, such as network security or operations, are very similar in a VDC to what they are in a physical data center.

Central to the VDC access control and management architecture is using Azure AD roles to group users based on their jobs and responsibilities. These roles serve as the basis for a role-based access control (RBAC) system. RBAC allows the definition of organizational roles, which define the access rights to specific Azure resources and subscription management rights to users and groups assigned to those roles.

The scope of a role can be at the Azure subscription, resource group, or single resource level. RBAC also allows the inheritance of permissions, so that a role assigned at a parent level also grants access to the children contained within it.
This functionality allows different parts of the VDC to be managed by different teams, so that central IT control over core access and security features can be paired with developers and associated teams having large amounts of control over specific workloads.

The structure and breakdown of roles within your organization will very, but the VDC model assumes the central IT management tasks for the virtual DataCenter breaks down into at least the three primary roles:

| Group                  | Common role name    | Responsibilities                                                                                                                                                          |
|------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Security Operations    | SecOps              | Provide general security oversight.<br><br>Establish and enforce security policy such as encryption at rest.<br><br>Manage encryption keys.<br><br>Manage firewall rules. |
| Network Operations     | NetOps              | Manage network configuration and operations within virtual networks of the virtual DataCenter such as routes and peerings.                                                |
| Systems Operations     | SysOps              | Specify compute and storage infrastructure options and maintain resources that have been deployed.                                                                        |

In addition to these three core IT roles, each individual workload spoke is expected to have a DevOps role associated with it, having the delegated rights to create and manage resources necessary to support workload applications and services.

## Next steps

Learn  how [policy enforcement](../policy-enforcement/vdc-policy-enforcement.md) is implemented within an Azure Virtual Datacenter.

> [!div class="nextstepaction"]
> [Azure Vitual Datacenter: Policy Enforcement](../policy-enforcement/vdc-policy-enforcement.md)