---
title: Azure control plane security
description: Examine security considerations for Azure control plane. A control plane refers to the management of resources in your subscription.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-rbac
ms.custom:
  - article
categories:
  - security
subject: 
  - security
---

# Azure control plane security

The term _control plane_ refers to the management of resources in your subscription. These activities include creating, updating, and deleting Azure resources as required by the technical team.  

Azure Resource Manager handles all control plane requests and applies restrictions that you specify through Azure role-based access control (Azure RBAC), Azure Policy, locks. Apply those restrictions are based on the requirement of the organization.

## Key points

- Restrict access based on a need-to-know basis and least privilege security principles.
- Assign permissions to users, groups, and applications at a certain scope through Azure RBAC. 
- Use built-in roles when possible.
- Prevent deletion or modification of a resource, resource group, or subscription through management locks.
- Use less critical control in your CI/CD pipeline for development and test environments.

## Roles and permission assignment 

**Is the workload infrastructure protected with Azure role-based access control (Azure RBAC)?**
***

Azure role-based access control (Azure RBAC) provides the separation when accessing the resources that an application uses. Decide who has access to resources at the granular level and what they can do with those resources. For example:

- Developers can't access production infrastructure.
- Only the SecOps team can read and manage Key Vault secrets.
- If there are multiple teams, Project A team can access and manage Resource Group A and all resources within.

>![Task](../../_images/i-best-practices.svg) Grant roles the appropriate permissions that start with least privilege and add more based on your operational needs. Provide clear guidance to your technical teams that implement permissions. This clarity makes it easier to detect and correct that reduces human errors such as overpermissioning.

Azure RBAC helps you manage that separation. You can assign permissions to users, groups, and applications at a certain scope. The scope of a role assignment can be a subscription, a resource group, or a single resource. For details, see [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

-  Assign permissions at management group instead of individual subscriptions to drive consistency and ensure application to future subscriptions.
- Consider the built-in roles before creating custom roles to grant the appropriate permissions to resources and other objects. 

For example, assign security teams with the **Security Readers** permission that provides access needed to assess risk factors, identify potential mitigations, without providing access to the data.

> [!IMPORTANT] 
> Treat security teams as critical accounts and apply the same protections as administrators.

## Management locks

**Are there resource locks applied on critical parts of the infrastructure?**
***

Unlike Azure role-based access control, management locks are used to apply a restriction across all users and roles.

Critical infrastructure typically doesn't change often. Use management locks to prevent deletion or modification of a resource, resource group, or subscription. Lock in use cases where only specific roles and users with permissions should be able to delete, or modify resources. 

As an administrator, you may need to lock a subscription, resource group, or resource to prevent other users in your organization from accidentally deleting or modifying critical resources. You can set the lock level to `CanNotDelete` or `ReadOnly`. In the portal, the locks are called **Delete** and **Read-only**, respectively:

  - *CanNotDelete* means authorized users can still read and modify a resource, but they can't delete the resource.
  - *ReadOnly* means authorized users can read a resource, but they can't delete or update the resource. Applying this lock is similar to restricting all authorized users to the permissions granted by the *Reader* role.

When you apply a lock at a parent scope, all resources within that scope inherit the same lock. Even resources you add later inherit the lock from the parent. The most restrictive lock in the inheritance takes precedence.

Unlike role-based access control, you use management locks to apply a restriction across all users and roles. To learn about setting permissions for users and roles, see [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

Identify critical infrastructure and evaluate resource lock suitability. 

Set locks in the DevOps process carefully because modification locks can sometimes block automation. For examples of those blocks and considerations, see [Considerations before applying locks](/azure/azure-resource-manager/management/lock-resources#considerations-before-applying-locks).

For more information about implementing resource locks to protect critical infrastructure, reference [Lock resources to prevent unexpected changes](/azure/azure-resource-manager/management/lock-resources?tabs=json).

## Application deployment
**Is there a direct access to the application infrastructure through Azure portal, Command-line Interface (CLI), or REST API?**
***
It's recommended that you deploy application infrastructure through automation and CI/CD. To maximize application autonomy and agility, balance restrictive access control on less critical development and test environments.

**Are CI/CD pipeline roles clearly defined and permissions set?**
***
Azure DevOps offers built-in roles that can be assigned to individual users of groups. For example, using them properly can make sure that only users responsible for production releases are able to initiate the process and that only developers can access the source code. Variable groups often contain sensitive configuration information and can be protected as well.


## Next
Grant or deny access to a system by verifying whether the accessor has the permissions to perform the requested action. 

> [!div class="nextstepaction"]
> [Authentication](design-identity-authentication.md)


## Related links

> Back to the main article: [Azure identity and access management considerations](design-identity.md)
