---
title: "Fusion: Azure Virtual Datacenter - Identity and roles" 
description: Discusses how Azure Active Directory and RBAC is used within the Azure Virtual Datacenter (VDC) model
author: rotycenh
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - Identity and roles

Jump to: [Azure Active Directory Tenants](#azure-active-directory-tenants) | [Federation and hybrid identity](#federation-and-hybrid-identity) | [Roles and RBAC](#roles-and-rbac)

The [Identity topic](overview.md) of the [Fusion framework](../../overview.md)'s [infrastructure section](../overview.md) discusses identity in general and how identity is used within Azure to manage access control and resource management. The discussion below will explore how Azure AD identity services lie at the core of the [Azure Virtual Datacenter (VDC)](../virtual-datacenter/overview.md) model's ability to manage access control and insure isolation of your cloud hosted resources.

## Azure Active Directory Tenants

The Azure Virtual Datacenter model uses Azure Active Directory (Azure AD) as its primary identity provider. Workloads hosted within a VDC may take advantage of other identity solutions, but the hub network, shared services, and management plane features are all dependent on Azure AD for access control and management.

An Azure AD tenant is a dedicated instance of an Azure AD directory that your organization receives when it signs up for a Microsoft cloud service such as Azure or Office 365. Each Azure AD directory is distinct and separate from other Azure AD directories, and contains its own users, groups, and roles. An Azure AD tenant is a pre-requisite for deploying resources on Azure.

Along with planning your [subscription](../subscriptions/vdc-subscriptions.md) strategy, picking the Azure AD tenant you'll be using with your VDC is one of the first things you'll need to decide. An Azure tenant can be used by multiple subscriptions, but subscriptions can only associate with a single tenant. As part of VDC deployment you can choose to use an existing tenant owned by your organization or create a net new one explicitly for the VDC. 

## Federation and hybrid identity

VDC assumes you have existing on-premise identity infrastructure and need to use consistent users and roles across your organization. If you do not already have an federation identity solution in place, Azure AD Connect allows you to integrate their on-premises directory services with Azure AD. [Azure AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-hybrid-identity?toc=%2Fen-us%2Fazure%2Factive-directory%2Fhybrid%2FTOC.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json) is used to provide synchronization of users and roles between on-premises Active Directory service and the Azure AD tenant associated with the virtual datacenter.  

## Roles and RBAC

As with an on-premises datacenter, certain groups of people are responsible for jobs within your IT environment. A VDC doesn't need facilities management or physical security, but many other responsibilities, such as network security or operations, are very similar in a VDC to what they are in a physical data center. 

Central to the VDC access control and management architecture is using Azure AD roles to group users based on their jobs and responsibilities. These roles serve as the basis for a [role-based access control (RBAC) system](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview). 

**Built-in roles**

Azure includes several [built-in roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) that you can use. The following lists the top fundamental built-in roles. The first three apply to all resource types.

- Owner - Has full access to all resources including the right to delegate access to others.
- Contributor - Can create and manage all types of Azure resources but can’t grant access to others.
- Reader - Can view existing Azure resources.
- User Access Administrator - Lets you manage user access to Azure resources.

The remaining built-in roles allow management of specific Azure resources. For example, the Virtual Machine Contributor role allows a user to create and manage virtual machines. If the built-in roles don't meet the specific needs of your organization, you can create your own [custom roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles).

**Organizational roles** 

RBAC allows the definition of organizational roles, which define the access rights to specific Azure resources and subscription management rights to users and groups assigned to those roles.

The scope of a role can be at the Azure subscription, resource group, or single resource level. RBAC also allows the inheritance of permissions, so that a role assigned at a parent level also grants access to the children contained within it.

This functionality allows different parts of the VDC to be managed by different teams, so that central IT control over core access and security features can be paired with developers and associated teams having large amounts of control over specific workloads.

**Primary IT Roles**

The structure and breakdown of roles within your organization will very, but the VDC model assumes the central IT management tasks for the virtual DataCenter breaks down into at least the three primary roles:

| Group                  | Common role name    | Responsibilities                                                                                                                                                          |
|------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Security Operations    | SecOps              | Provide general security oversight.<br><br>Establish and enforce security policy such as encryption at rest.<br><br>Manage encryption keys.<br><br>Manage firewall rules. |
| Network Operations     | NetOps              | Manage network configuration and operations within virtual networks of the virtual DataCenter such as routes and peerings.                                                |
| Systems Operations     | SysOps              | Specify compute and storage infrastructure options and maintain resources that have been deployed.                                                                        |

In addition to these three primary IT roles, each individual workload spoke is expected to have a DevOps role associated with it, having the delegated rights to create and manage resources necessary to support workload applications and services.

## Next steps

Learn how [resource grouping](../resource-grouping/vdc-resource-grouping.md) is used to organize and standardize deployments within an Azure Virtual Datacenter.

Use [role-based access control (RBAC)](https://docs.microsoft.com/en-us/azure/role-based-access-control) to define duties within your teams and grant the amount of access to users that they need to perform their jobs. 

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Resource Grouping](../resource-grouping/vdc-resource-grouping.md)
