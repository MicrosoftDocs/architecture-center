---
title: "How to: configure Azure governance controls for the foundational adoption stage"
description: Guidance for configuring Azure governance controls to enable a user to deploy a simple workload
author: petertay
---

# Azure governance design guide for the foundational adoption stage

The audience for this design guide is the *central IT* persona in your organization. *Central IT* is responsible for designing and implementing your organization's cloud governance architecture. As you learned in the [what is cloud resource governance?](governance-explainer.md) explainer, governance refers to the ongoing process of managing, monitoring, and auditing the use of Azure resources to meet the goals and requirements of your organization.

The goal of this guidance is to help you learn the process of designing your organization's governance architecture. To facilitate this, we'll look at a set of hypothetical goverance goals and requirements and discuss how to configure Azure's governance tools to meet them. 

In the foundational adoption stage, our goal is to deploy a simple workload to Azure. This results in the following requirements:
* Identity management for a single user or small group of users who will be responsible for deploying and maintaining the simple workload.
* Manage user identity for the simple workload as single unit.
* Manage all resources for the simple workload as a single management unit.
* A permissions model that allows for least privilege access to resources.

## Identity management

Azure only trusts [Azure Active Directory (AD)](/azure/active-directory) to authenticate users and manage user access to resources. Azure AD users are segmented into **tenants**. A tenant is a logical construct that represents a secure, dedicated instance of Azure AD. 

Our requirement is for a single user or small group of users who will be responsible for deploying the workload, and we want to manage them as a single unit.

A single Azure AD tenant satifies these requirements. Within a single Azure AD tenant we can [create a single user or multiple users](/azure/active-directory/add-users-azure-active-directory) and [manage them as a group](/azure/active-directory/add-users-azure-active-directory).

## Resource management scope

As the number of resources deployed by your organization grows, the complexity of governing those resources grows as well. Azure implements a logical container hierarchy to enable your organization to manage your resources in groups at various levels of granularity, also known as **scope**. 

The top level of resource management scope is the **subscription** level. A subscription is also associated with a financial commitment, and that will be covered in more depth in the intermediate adoption stage.

The next level of management scope is the **resource group** level. A resource group is a logical container for resources. Operations applied at the resource group level apply to all resources in a the group.

The lowest level of management scope is at the **resource** level. Operations applied at the resource level apply only to the resource itself.

> [!NOTE]
> Each resource must belong to a resource group.

Our requirement is to manage all of the resources in the simple workload as a single unit. The first step to meet this requirement is to design the highest scope of resource management, which as we've already dicussed is the *subscription* level. The primary consideration for subscription management is deciding on the number of subscriptions your organization will use. 

You could choose to put each resource into a single subscription, but this requires your *Central IT* and *workload owner* personas to manage each resource one at a time in each subscription. The other choice is to place all resources into a single subscription, which allows your *Central IT* and *workload owner* personas to select the subscription and apply changes to all resources in that subscription. 

The next step is to design how we'll manage resources within each subscription. As with subscriptions, you could choose to put each resource into a single resource group, but that would require your *Central IT* and *workload owner* personas to manage each resource one at time in each resource group. The other choice is to place all the resources for a workload into a single resource group, which allows your *Central IT* and *workload owner* personas to select the resource group and apply changes to all resources at once.

Therefore, the design of a single subscription and a single resource group for each workload is the correct design to meet the requirement of managing all resources for a simple workload as a single unit.

## Permissions model of least privilege access 

The requirement for least privilege access to resources means that we want users to have permission to peform approved actions on approved resources and nothing more. In Azure, these permissions are controlled using **role-based access control (RBAC)**. 

RBAC roles define which capabilities the **role** has for a particular resource, and a role is applied to individual user identities. For example, the built-in **contributor** role allows a user to create, read, update, and delete a resource. The built-in **owner** role is similar, except it also allows the user to assign roles to other users.

A major consideration in satisfying this requirement is assigning the right role to a user at the correct resource management scope. For example, we want a *workload owner* to be able to manage Azure resources for their project but no other projects. The *workload owner* may also want to allow other users on the project team to view resources but not create, update, or delete them.

Therefore, our permissions model should include a single *central IT* user that has permission to add users to Azure AD as well as permission to assign those users to a subscription. This user will have the highest level permissions in your organization and permissions for all other users in your organization are granted by this *central IT* user.

When this *central IT* user creates user accounts in Azure AD, they must assign a role to each new user. This role is applied to the user for all subscriptions that the user is assigned to. Therefore, to meet the least privilege access requirement, your organization must make some decisions about the structure of your *workload owners* team. 

As discussed earlier, any user with the **owner** or **contributor** role at the subscription level can create, read, update, and delete any type of resource within the subscription regardless of the resource group that contains those resources. If you have a *workload owner* with the **owner** or **contributor** role at the subscription level, that *workload owner* will be able to perform all actions on a resource in any resource group within the subscription, even those for which this user might not be an owner.     

However, in order to be able to do anything at all, at least one user in the *workload owner* persona must be able to request that a resource group be created, and request that resources be deployed into that resource group. At this point, your organization must decide whether the *central IT* persona is responsible for creating resource groups, or whether the individual *workload owner* personas are trusted to not only access their own resources but the resources other *workload owners*. 

If your organization's decision is to allow only the *central IT* persona to create resource groups, the requirement of least privilege access can be satisfied by applying the **reader** role to the *workload owner* persona at the subscription level, and overriding the **reader** role with the **owner** or **contributor** role at the resource group level. 

If your organization's decision is to trust the *workload owner* persona to create resource groups at the subscription scope, the requirement of least privilege access can be satisifed by applying either the **owner** or **contributor** role.

All other users that work with the *workload owner* persona should have the least privilege access **reader** role applied at the subscription level. If the *workload owner* has the **owner** role applied at the resource group level they will have permission to change the role of the other users. Otherwise, the *workload owner* will have to request that *central IT* make any role changes.

## Next steps

Return to the [foundational adoption stage overview](overview.md) and learn about the different types of compute options in Azure. Then, select a type of workload and learn how to deploy it.