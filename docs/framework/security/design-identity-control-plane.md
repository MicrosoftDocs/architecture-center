---
title: Azure control plane security
description: Examine security considerations for Azure control plane. A control plane refers to the management of resources in your subscription.
author: PageWriter-MSFT
ms.date: 10/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-rbac
categories:
  - security
  - identity
subject:
  - identity
ms.custom:
  - article
---

# Azure control plane security

The term _control plane_ refers to the management of resources in your subscription. These activities include creating, updating, and deleting Azure resources as required by the technical team.

Azure Resource Manager handles all control plane requests and applies restrictions that you specify through Azure role-based access control (Azure RBAC), Azure Policy, locks. Apply those restrictions based on the requirement of the organization.

It's recommended to implement Infrastructure as Code, and to deploy application infrastructure through automation, and CI/CD for consistency and auditing purposes.

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

Azure role-based access control (Azure RBAC) provides the necessary tools to maintain separation of concerns for administration and access to application infrastructure. Decide who has access to resources at the granular level and what they can do with those resources. For example:

- Developers can't access production infrastructure.
- Only the SecOps team can read and manage Key Vault secrets.
- If there are multiple teams, Project A team can access and manage Resource Group A and all resources within.

> ![Task](../../_images/i-best-practices.svg) Grant roles the appropriate permissions that start with least privilege and add more based on your operational needs. Provide clear guidance to your technical teams that implement permissions. This clarity makes it easier to detect and correct which reduces human errors such as overpermissioning.

Azure RBAC helps you manage that separation. You can assign permissions to users, groups, and applications at a certain scope. The scope of a role assignment can be a subscription, a resource group, or a single resource. For details, see [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

- Assign permissions at management group instead of individual subscriptions to drive consistency and ensure application to future subscriptions.
- Consider the built-in roles before creating custom roles to grant the appropriate permissions to resources and other objects.

For example, assign security teams with the **Security Readers** permission that provides access needed to assess risk factors, identify potential mitigations, without providing access to the data.

> [!IMPORTANT]
> Treat security teams as critical accounts and apply the same protections as administrators.

**Learn more**

[Azure RBAC documentation](/azure/role-based-access-control/)

## Management locks

**Are there resource locks applied on critical parts of the infrastructure?**
***

Unlike Azure role-based access control, management locks are used to apply a restriction across all users and roles.

Critical infrastructure typically doesn't change often. Use management locks to prevent deletion or modification of a resource, resource group, or subscription. Lock in use cases where only specific roles and users with permissions can delete, or modify resources.

As an administrator, you may need to lock a subscription, resource group, or resource to prevent other users in your organization from accidentally deleting or modifying critical resources. You can set the lock level to `CanNotDelete` or `ReadOnly`. In the portal, the locks are called **Delete** and **Read-only**, respectively:

  - *CanNotDelete* means authorized users can still read and modify a resource, but they can't delete the resource.
  - *ReadOnly* means authorized users can read a resource, but they can't delete or update the resource. Applying this lock is similar to restricting all authorized users to the permissions granted by the *Reader* role.

When you apply a lock at a parent scope, all resources within that scope inherit the same lock. Even resources you add later inherit the lock from the parent. The most restrictive lock in the inheritance takes precedence.

Unlike role-based access control, you use management locks to apply a restriction across all users and roles. To learn about setting permissions for users and roles, see [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

Identify critical infrastructure and evaluate resource lock suitability.

Set locks in the DevOps process carefully because modification locks can sometimes block automation. For examples of those blocks and considerations, see [Considerations before applying locks](/azure/azure-resource-manager/management/lock-resources#considerations-before-applying-locks).

## Suggested actions

- Restrict application infrastructure access to CI/CD only.
- Use conditional access policies to restrict access to Microsoft Azure Management.
- Configure role-based and resource-based authorization within [Azure AD](/azure/active-directory/).

## Learn more

- [Manage access to Azure management with Conditional Access](/azure/role-based-access-control/conditional-access-azure-management)
- [Role-based and resource-based authorization](/azure/architecture/multitenant-identity/authorize)

## Next steps

Grant or deny access to a system by verifying whether the accessor has the permissions to perform the requested action.

> [!div class="nextstepaction"]
> [Authentication](design-identity-authentication.md)

## Related links

> Back to the main article: [Azure identity and access management considerations](design-identity.md)
