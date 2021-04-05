---
title: Azure control plane security
description: Security considerations for Azure control plane.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-rbac
ms.custom:
  - article
---

# Azure control plane security

The term _control plane_ refers to the management of resources in your subscription. These activities include creating, updating, and deleting Azure resources as required by the technical team.  

Azure Resource Manager handles all control plane requests and applies restrictions that you specify through Azure role-based access control (Azure RBAC), Azure Policy, locks. Apply those restrictions are based on the requirement of the organization.

## Key points
> [!div class="checklist"]
> - Restrict access based on a need-to-know basis and least privilege security principles.
> - Assign permissions to users, groups, and applications at a certain scope through Azure RBAC. 
> - Use built-in roles when possible.
> - Prevent deletion or modification of a resource, resource group, or subscription through management locks.
> - Use less critical control in your CI/CD pipeline for development and test environments.

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

For critical infrastructure, use management locks to prevent deletion or modification of a resource, resource group, or subscription. Lock in use cases where only specific roles and users with permissions should be able to delete/modify resources. 

Set locks in the DevOps process carefully because modification locks can sometimes block automation. For examples of those blocks and considerations, see [Considerations before applying locks](/azure/azure-resource-manager/management/lock-resources#considerations-before-applying-locks).


## Next
Grant or deny access to a system by verifying whether the accessor has the permissions to perform the requested action. 

> [!div class="nextstepaction"]
> [Authentication](design-identity-authentication.md)


## Related links

> Back to the main article: [Azure identity and access management considerations](design-identity.md)
