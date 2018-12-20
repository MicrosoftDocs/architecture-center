---
title: "Fusion: Azure Virtual Datacenter - Identity and roles" 
description: Discusses how Azure Active Directory and RBAC is used within the Azure Virtual Datacenter model
author: rotycenh
ms.date: 12/19/2018
---
# Fusion: Azure Virtual Datacenter - Identity and roles

Jump to: [Azure Active Directory Tenants](#azure-active-directory-tenants) | [Federation and hybrid identity](#federation-and-hybrid-identity) | [Roles and RBAC](#roles-and-rbac)

The [Identity topic](overview.md) of the [Fusion framework](../../overview.md)'s [infrastructure section](../overview.md) discusses identity in general and how identity is used within Azure to manage access control and resource management. The discussion below explores how Azure AD identity services are at the core of the [Azure Virtual Datacenter model's](../virtual-datacenter/overview.md) ability to manage access control and ensure isolation of your cloud-hosted resources.

## Azure Active Directory tenants

The Azure Virtual Datacenter model uses Azure Active Directory (Azure AD) as its primary identity provider. Workloads hosted within a virtual datacenter (VDC) may take advantage of other identity solutions, but the hub network, shared services, and management plane features are all dependent on Azure AD for access control and management.

An Azure AD tenant is a dedicated instance of Azure AD that your organization receives when it signs up with a Microsoft cloud service, such as Azure or Office 365. Each Azure AD tenant is distinct and separate from other Azure AD instances, and each tenant contains its own users, groups, and roles. You must establish an Azure AD tenant, as it is a pre-requisite for deploying resources on Azure.

Along with planning your [subscription](../subscriptions/vdc-subscriptions.md) strategy, you also need to plan how you will configure your organization's Azure AD tenant for use with VDC subscriptions. This should be one of your top design decisions. An Azure tenant can be used by multiple subscriptions, but subscriptions can only be associated with a single tenant. As part of VDC deployment, you can choose to use an existing tenant owned by your organization or you can create a net new one, explicitly for the VDC. 

## Federation and hybrid identity

VDC assumes that you have an existing on-premises identity infrastructure, and therefore you will need to use consistent users and roles across the organization. If you do not already have a Federation identity solution in place, Azure AD Connect allows you to integrate your on-premises directory services with Azure AD. You can use [Azure AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-hybrid-identity?toc=%2Fen-us%2Fazure%2Factive-directory%2Fhybrid%2FTOC.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json) to provide synchronization of users and roles between on-premises Azure AD services and the Azure AD tenant associated with the VDC.  

## Roles and role-based access control (RBAC)

As with an on-premises datacenter, certain groups of people are responsible for jobs within your IT environment. A VDC doesn't need facilities management or physical security, but many other VDC responsibilities (such as network security and operations) are similar to what they would be in a physical data center. 

Central to the VDC access control and management architecture is using Azure AD roles to group users based on their jobs and responsibilities. These roles serve as the basis for a [role-based access control (RBAC) system](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview). 

**Built-in roles**

Azure AD includes several [built-in roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) that you can use. The following lists the top fundamental roles. The first three apply to all resource types.

- Owner - Has full access to all resources including the right to delegate access to others.
- Contributor - Can create and manage all types of Azure resources but can’t grant access to others.
- Reader - Can view existing Azure resources.
- User Access Administrator - Lets you manage user access to Azure resources.

The remaining built-in roles allow you to manage specific Azure resources. For example, the Virtual Machine Contributor role allows a user to create and manage virtual machines. If the built-in roles don't meet your organization's specific needs, you can create your own [custom roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles).

**Organizational roles** 

RBAC also allows for the definition of organizational roles, which define the access rights to specific Azure resources and subscription management rights to users and groups assigned to those roles.

The scope of a role can be at the Azure subscription, resource group, or single resource level. RBAC also allows the inheritance of permissions, so that a role assigned at a parent level also grants access to the children contained within it.

This functionality allows different parts of the VDC to be managed by different teams, so that central IT control over core access and security features can be paired with developers and associated teams having large amounts of control over specific workload resources.

**Primary IT roles**

The structure and breakdown of roles within your organization will vary, but the VDC model assumes that the central IT management tasks for the VDC break down into at least these three primary roles:

| Group                  | Common role name    | Responsibilities                                                                                                                                                          |
|------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Security Operations    | SecOps              | Provide general security oversight.<br><br>Establish and enforce security policy such as encryption at rest.<br><br>Manage encryption keys.<br><br>Manage firewall rules. |
| Network Operations     | NetOps              | Manage network configuration and operations within virtual networks of the VDC, such as routes and peerings. Configures network routing to ensure inbound and outbound traffic passes through the hub central firewall.  |
| Systems Operations     | SysOps              | Specify compute and storage infrastructure options and maintain resources that have been deployed.                                                                        |

In addition to these three primary IT roles, each individual workload spoke is expected to have specific workload DevOps roles associated with it. These roles can mirror the structure of the central IT roles, only with rights limited to creating and managing resources necessary to support workload applications and services.

When planning your VDC workload deployments, consider adopting a [development security operations (DevSecOps)](https://docs.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/security-in-devops) approach. This requires a change in organizational mindset, and is especially important for those organizations that develop their own applications and services.

## Next steps

Learn how [resource grouping](../resource-grouping/vdc-resource-grouping.md) is used to organize and standardize deployments within an Azure Virtual Datacenter.

Use [role-based access control (RBAC)](https://docs.microsoft.com/en-us/azure/role-based-access-control) to define duties within your teams and grant the amount of access to users that they need to perform their jobs. 

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Resource Grouping](../resource-grouping/vdc-resource-grouping.md)
