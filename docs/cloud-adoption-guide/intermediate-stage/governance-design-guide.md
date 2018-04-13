---
title: "Governance design walkthrough: new development in Azure for multiple teams"
description: Guidance for configuring Azure governance controls to enable a user to deploy a simple workload
author: petertay
---

# Governance design walkthrough: new development in Azure for multiple teams

The audience for this governance walkthrough is the *central IT* and *security operations* personas in your organization. *Central IT* is responsible for designing and implementing your organization's cloud governance architecture. *Security operations* is responsible for the infrastructure for storing secrets in Azure as well as implementing your organization's security protocols in Azure. This guide is also useful as a reference to aid in understanding how governance is implemented for the *finance*, *shared infrastructure owner*, and *workload owner* personas.

As you learned in the [what is cloud resource governance?](governance-explainer.md) explainer, governance refers to the ongoing process of managing, monitoring, and auditing the use of Azure resources to meet the goals and requirements of your organization.

The goal of this guidance is to help you learn the process of designing your organization's governance architecture to accomodate new development in Azure for multiple teams. To facilitate this, we'll look at a set of hypothetical goverance goals and requirements and discuss how to configure Azure's governance tools to meet them. 

Our requirements are:
* Identity management for multiple teams with multiple resource access requirements in Azure. Efficiently manage and audit resource access permissions for groups of users.
* Manage resources for each workload as a single unit in multiple environments in a single region.
* 
* Allow *workload owner* access to appropriate shared infrastructure resources (such as virtual networking) owned by *shared infrastructure owner*, but deny access to permanent infrastructure such as network gateways to prevent accidental changes or deletion.
* Enforce resource naming standards to enable cost tracking.
* Use Azure built-in roles to manage access to resources. 

## Identity management

Before we can design our identity management infrastructure to support multiple teams and multiple workloads, it's important to understand the functions that identity management provides in our governance model. These functions are:

* Administration: the processes and tools for managing user identity; we want to be able to efficiently manage user identity to ensure that users only have access to the resources we want them to access when they require that access. 
* Authentication: the process of verifying the identity of a user through the use of credentials such as a user name and password.
* Authorization: once a user has been authorized, this process determines which resources the user is allowed to access and what operations they are allowed to perform.
* Auditing: the process of periodically reviewing logs and other information to uncover any potential security issues related to user identity. This includes reviewing user connection patterns to ensure that a user's activity isn't suspicious, periodically running checks to ensure user permissions are accurate, and many other functions.

The only service trusted by Azure to provide this functionality is Azure Active Directory (AD), so our task in designing our identity management infrastructure is to configure this service to meet our requirements. 

Our first requirement is to efficiently administer identity and permissions for multiple users with multiple resource access requirements. The motivation for this requirement is to reduce the effort it takes to manage our users and their permissions. For example, we'd like to select some common criteria we can use to group users together and apply permissions to them all at once rather than one by one.

As you learned earlier, user identity can be grouped by **tenant** or by [**groups**](/azure/active-directory/active-directory-manage-groups) within the same tenant. 

Let's evaluate grouping by *tenant* first. Grouping at the *tenant* level means that a separate *tenant* is created for each group of users. This allows us to select all the users at the tenant level then apply permissions and audit their activities as a group. 

The first problem with this approach is that we cannot audit the activity of users across multiple tenants without exporting and aggregating activity logs from each tenant. The second problem with this approach is that we cannot share user identity between Azure AD tenants, so if we have a user that belongs in more than one group we have to replicate and manage their identity separately in each tenant.

Now let's evaluate grouping by Azure AD *group*. Grouping user identities at the *group* level means that we store all our user identities in a single *tenant* and organize them into one or more *groups*. Just as in a *tenant*, we can apply permissions and audit activities by *group*. We can also audit the activity of all users in all groups in a single log file, and we can include users in more than one group.

Based on our analysis, the design that most closely meets our requirements is a single Azure AD *tenant* and multiple *groups*. 

## Resource management scope

As the number of resources deployed by your organization grows, the complexity of governing those resources grows as well. Azure implements a logical container hierarchy to enable your organization to manage your resources in groups at various levels of granularity, also known as **scope**. 

The top level of resource management scope is the **subscription** level. A subscription is also associated with a financial commitment, and that will be covered in more depth in the intermediate adoption stage.

The next level of management scope is the **resource group** level. A resource group is a logical container for resources. Operations applied at the resource group level apply to all resources in a group.

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