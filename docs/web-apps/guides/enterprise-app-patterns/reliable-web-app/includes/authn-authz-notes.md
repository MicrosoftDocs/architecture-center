---
author: claytonsiemens77 
ms.author: csiemens
ms.date: 10/15/2024
ms.topic: include
---
- *Prefer temporary access to storage.* Use temporary permissions to safeguard against unauthorized access and breaches. For example, you can use [shared access signatures (SAS)](/rest/api/storageservices/delegate-access-with-shared-access-signature) to limit access to a period of time. Use user delegation SAS to maximize security when you grant temporary access. It's the only SAS that uses Microsoft Entra ID credentials and doesn't require a permanent storage account key.

- *Enforce authorization in Azure.* Use [Azure RBAC)](/azure/role-based-access-control/best-practices) to assign least privileges to user identities. Azure RBAC defines the Azure resources that identities can access, what they can do with those resources, and the areas that they have access to.

- *Avoid permanent elevated permissions.* Use [Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure) to grant just-in-time (JIT) access for privileged operations. For example, developers often need administrator-level access to create and delete databases, modify table schemas, and change user permissions. When you use JIT access, user identities receive temporary permissions to perform privileged tasks.
