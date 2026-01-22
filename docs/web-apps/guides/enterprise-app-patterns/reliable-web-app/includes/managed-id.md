---
author: claytonsiemens77 
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
Use [managed identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) for all Azure services that support them. A managed identity allows Azure resources, specifically [workload identities](/entra/workload-id/workload-identities-overview), to authenticate to and interact with other Azure services without requiring you to manage credentials. To simplify the migration, you can continue to use on-premises authentication solutions for hybrid and legacy systems, but you should transition them to managed identities as soon as possible. To implement managed identities, follow these recommendations:

- *Select the right type of managed identity*. Prefer user-assigned managed identities when you have two or more Azure resources that need the same set of permissions. This approach is more efficient than creating system-assigned managed identities for each of those resources and assigning the same permissions to all of them. Otherwise, use system-assigned managed identities.

- *Configure least privileges.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to grant only permissions that are critical for operations, like create, read, update, and delete (CRUD) actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide JIT or short-term permissions to workload identities. If Azure RBAC doesn't cover a specific scenario, supplement Azure RBAC with Azure service-level access policies.

- *Provide security for remaining secrets.* Store any remaining secrets in [Key Vault](/azure/key-vault/secrets/about-secrets). Load secrets from Key Vault at application startup instead of during each HTTP request. High-frequency access within HTTP requests can exceed [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions). Store application configurations in [App Configuration](/azure/azure-app-configuration/overview).
