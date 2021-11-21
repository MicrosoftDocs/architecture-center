---
title: Authorization with Azure AD
description: Use Azure Active Directory (Azure AD) roles to define clear lines of responsibility, access, and separation of duties.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-active-directory
ms.custom:
  - article
categories:
  - security
subject:
  - security
---

# Authorization with Azure AD

Authorization is a process that grants or denies access to a system by verifying whether the accessor has the permissions to perform the requested action. The accessor in this context is the workload (cloud application) or the user of the workload. The action might be operational or related to resource management. There are two main approaches to authorization: role-based and resource-based. Both can be configured with Azure AD.

## Key points

- Use a mix of role-based and resource-based authorization. Start with the principle of least privilege and add more actions based on your needs.
- Define clear lines of responsibility and separation of duties for application roles and the resources it can manage. Consider the access levels of each operational function, such as permissions needed to publish production release, access customer data, manipulate database records.
- Do not provide permanent access for any critical accounts. Elevate access permissions that are based on approval and is time bound using Azure AD Privileged Identity Management (Azure AD PIM).|

## Role-based authorization

This approach authorizes an action based on the role assigned to a user. For example, some actions require an administrator role.

A role is a set of permissions. For example, the administrator role has permissions to perform all read, write, and delete operations. Also, the role has a scope. The scope specifies the management groups, subscriptions, or resource groups within which the role is allowed to operate.

Applying consistent permissions to resources via management groups or resource groups reduces proliferation of custom, specific, per-resource permissions. Custom resource-based permissions are often unnecessary, and can cause confusion because they do not carry their intent to new similar resources. This process can accumulate into a complex legacy configuration that is difficult to maintain or change without fear of *breaking something*, and negatively impacting both security, and solution agility.

When assigning a role to a user consider what actions the role can perform and what is the scope of those operations. Here are some considerations for role assignment:

- Use built-in roles before creating custom roles to grant the appropriate permissions to VMs and other objects. You can assign built-in roles to users, groups, service principals, and managed identities. For more information, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

- If you need to create custom roles, grant roles with the appropriate action. Actions are categorized into operational and data actions. To avoid overpermissioning, start with actions that have least privilege and add more based your operational or data access needs. Provide clear guidance to your technical teams that implement permissions. For more information, see [Azure custom roles](/azure/role-based-access-control/custom-roles).

- If you have a segmentation strategy, assign permissions with a scope. For example, if you use management group to support your strategy, set the scope to the group rather than the individual subscriptions. This will drive consistency and ensure application to future subscriptions. When assigning permissions for a segment, consider consistency while allowing flexibility to accommodate several organizational models. These models can range from a single centralized IT group to mostly independent IT and DevOps teams. For information about assigning scope, see [AssignableScopes](/azure/role-based-access-control/role-definitions#assignablescopes).

- You can use security groups to assign permissions. However, there are disadvantages. It can get complex because the workload needs to keep track of which security groups correspond to which application roles, for each tenant. Also, access tokens can grow significantly and Azure AD includes an "overage" claim to limit the token size. See [Microsoft identity platform access tokens](/azure/active-directory/develop/access-tokens).

- Instead of granting permissions to specific users, assign access to Azure AD groups. In addition, build a comprehensive delegation model that includes management groups, subscription, or resource groups RBAC. For more information, see [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

For information about implementing role-based authorization in an ASP.NET application, see [Role-based authorization](../../multitenant-identity/authorize.md#role-based-authorization).

**Learn more**

- [Avoid granular and custom permissions](/azure/architecture/framework/security/design-admins#avoid-granular-and-custom-permissions)
- [Delegate administration in Azure AD](/azure/active-directory/roles/security-planning)

## Resource-based authorization

With role-based authorization, a user gets the same level of control on a resource based on the user's role. However, there might be situations where you need to define access rights per resource. For example, in a resource group, you want to allow some users to delete the resource; other users cannot. In such situations, use resource-based authorization that authorizes an action based on a particular resource. Every resource has an Owner. Owner can delete the resource. Contributors can read and update but can't delete it.

> [!NOTE]
> The *owner* and *contributor* roles for a resource are not the same as application roles.

You'll need to implement custom logic for resource-based authorization. That logic might be a mapping of resources, Azure AD object (like role, group, user), and permissions.

For information and code sample about implementing resource-based authorization in an ASP.NET application, see [Resource-based authorization](../../multitenant-identity/authorize.md#resource-based-authorization).

## Authorization for critical accounts

There might be cases when you need to do activities that require access to important resources. Those resources might already be accessible to critical accounts such as an administrator account. Or, you might need to elevate the access permissions until the activities are complete. Both approaches can pose significant risks.

Critical accounts are those which can produce a business-critical outcome, whether cloud administrators or workload-specific privileged users. Compromise or misuse of such an account can have a detrimental-to-material effect on the business and its information systems. It's important to identify those accounts and adopt processes including close monitoring, and lifecycle management, including retirement.

Securing privileged access is a critical first step to establishing security assurances for business assets in a modern organization. The security of most or all business assets in an IT organization depends on the integrity of the privileged accounts used to administer, manage, and develop. Cyberattackers often target these accounts and other elements of privileged access to gain access to data, and systems using credential theft attacks like Pass-the-Hash, and Pass-the-Ticket.

Protecting privileged access against determined adversaries requires you to take a complete and thoughtful approach to isolate these systems from risks.

**Are there any processes and tools leveraged to manage privileged activities?**
***

Do not provide permanent access for any critical accounts and lower permissions when access is no longer required. Some strategies include:

- Just-in-time privileged access to Azure AD and Azure resources.
- Time-bound access.
- Approval-based access.
- Break glass for emergency access process to gain access.

Limit write access to production systems to service principals. No user accounts should have regular write-access.

Ensure there's a process for disabling or deleting administrative accounts that are unused.

You can use native and third-party options to elevate access permissions for at least highly privileged if not all activities. Azure AD Privileged Identity Management (Azure AD PIM) is the recommended native solution on Azure.

For more information about PIM, see [What is Azure AD Privileged Identity Management?](/azure/active-directory/privileged-identity-management/pim-configure)

## Learn more

[Establish lifecycle management for critical impact accounts](/azure/architecture/framework/security/design-admins#establish-lifecycle-management-for-critical-impact-accounts)

## Related links

> Back to the main article: [Azure identity and access management considerations](design-identity.md)
