---
title: Use Azure Key Vault in a Multitenant Solution
description: Learn how to use Azure Key Vault in multitenant solutions, including isolation models, tenant-specific vaults, shared vaults, and multitenancy features.
author: johndowns
ms.author: pnp
ms.date: 09/10/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Use Azure Key Vault in a multitenant solution

Azure Key Vault manages secure data, including secrets, encryption keys, and certificates. This article describes Key Vault features that benefit multitenant solutions. It also provides links to guidance that can help you plan how to use Key Vault.

## Isolation models

When you work with a multitenant system that uses Key Vault, determine the level of isolation that you need. Your isolation model depends on the following factors:

- How many tenants you have

- Whether you share your application tier between multiple tenants, deploy single-tenant application instances, or deploy separate deployment stamps for each tenant
- Whether your tenants must manage their own encryption keys
- Whether your tenants have compliance requirements that require you to store their secrets separately from other tenants' secrets

The following table summarizes the differences between the main tenancy models for Key Vault.

| Consideration | Vault for each tenant, in the provider's subscription | Vault for each tenant, in the tenant's subscription | Shared vault |
|-|-|-|-|
| **Data isolation** | High | Very high | Low |
| **Performance isolation** | Medium. High throughput might be limited, even with many vaults. | High | Low |
| **Deployment complexity** | Low-medium, depending on the number of tenants | High. The tenant must correctly grant access to the provider. | Low |
| **Operational complexity** | High | Low for the provider, higher for the tenant | Lowest |
| **Example scenario** | Individual application instances for each tenant | Customer-managed encryption keys | Large multitenant solution that has a shared application tier |

### Vault for each tenant, in the provider's subscription

Consider deploying a vault for each tenant within your (the service provider's) Azure subscription. This approach provides strong data isolation between each tenant's data. But you must deploy and manage an increasing number of vaults as the number of tenants increases.

Azure doesn't limit the number of vaults that you can deploy within a single subscription. But consider other limits:

- [Subscription-wide limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-key-vault-limits) on the number of requests that you can make within a time period. These limits apply regardless of the number of vaults in the subscription. Follow the [throttling guidance](/azure/key-vault/general/overview-throttling) even when you have tenant-specific vaults.

- The [number of Azure role assignments that you can create within a subscription](/azure/role-based-access-control/troubleshoot-limits). When you deploy and configure large numbers of vaults in a subscription, you might approach these limits.

### Vault for each tenant, in the tenant's subscription

In some scenarios, your tenants can create vaults in their own Azure subscriptions and grant your application access to work with secrets, certificates, or keys. Use this approach when you allow customer-managed keys for encryption within your solution.

To access the data in your tenant's vault, the tenant must provide your application with access to their vault. This process requires that your application authenticates through their Microsoft Entra ID instance. You can publish a [multitenant Microsoft Entra ID application](/entra/identity-platform/single-and-multi-tenant-apps). 

Your tenants must perform a one-time consent process that includes the following steps:

1. Register the multitenant Microsoft Entra application in their Microsoft Entra tenant.

1. Grant your multitenant Microsoft Entra application the appropriate level of access to their vault.
1. Provide you with the full resource ID of the vault that they create.


After this setup, your application code can use a service principal associated with the multitenant Microsoft Entra ID application in your Microsoft Entra ID to access each tenant's vault.

Or you can ask each tenant to create a service principal for your service to use and provide you with its credentials. But this approach requires you to securely store and manage credentials for each tenant, which introduces a security liability.

If your tenants configure network access controls on their vaults, make sure that you can access the vaults. Design your application to handle situations where a tenant changes their network access controls and blocks your access to their vaults.

### Shared vaults

You can share tenants' secrets within a single vault. You deploy the vault in your (the solution provider's) Azure subscription, and you manage the vault. This approach is the simplest but provides the least data isolation and performance isolation.

You can also deploy multiple shared vaults. For example, a solution that follows the [Deployment Stamps pattern](../approaches/overview.md#deployment-stamps-pattern) likely deploys a shared vault within each stamp. Similarly, if you deploy a multi-region solution, you should deploy vaults into each region for the following reasons:

- To avoid cross-region traffic latency when you work with data in your vault
- To support data residency requirements
- To enable the use of regional vaults within other services that require same-region deployments

When you work with a shared vault, consider the number of operations that you perform against the vault. Operations include reading secrets and performing encryption or decryption operations. [Key Vault imposes limits on the number of requests](/azure/azure-resource-manager/management/azure-subscription-service-limits#key-vault-limits) made against a single vault and across all vaults within an Azure subscription. Follow the [throttling guidance](/azure/key-vault/general/overview-throttling), and apply other recommended practices. Securely cache secrets that you retrieve, and use [envelope encryption](/azure/security/fundamentals/encryption-atrest#envelope-encryption-with-a-key-hierarchy) to avoid sending all encryption operations to Key Vault. These best practices help you run high-scale solutions against a single vault.

If you need to store tenant-specific secrets, keys, or certificates, consider using a naming convention like a naming prefix. For example, you might prepend the tenant ID to the name of each secret. Then your application code can easily load the value of a specific secret for a specific tenant.

## Features of Key Vault that support multitenancy

### Tags

Key Vault supports tagging secrets, certificates, and keys by adding custom metadata. You can use a tag to track the tenant ID for each tenant-specific secret. But Key Vault doesn't support querying by tags, so this feature works best for management purposes rather than within application logic.

For more information, see the following resources:

- [Secret tags](/azure/key-vault/secrets/about-secrets#secret-tags)
- [Certificate tags](/azure/key-vault/certificates/about-certificates#certificate-attributes-and-tags)
- [Key tags](/azure/key-vault/keys/about-keys-details#key-tags)

### Azure Policy support

If you deploy a large number of vaults, ensure that they follow a consistent standard for network access configuration, logging, and access control. Consider using Azure Policy to verify that the vaults are configured according to your requirements.

For more information, see the following resources:

- [Integrate Key Vault with Azure Policy](/azure/key-vault/general/azure-policy?tabs=certificates)
- [Azure Policy built-in definitions for Key Vault](/azure/key-vault/policy-reference)

### Key Vault Managed HSM and Azure Dedicated HSM

If you need to perform a large number of operations per second, and the Key Vault operation limits are insufficient, consider using either [Managed HSM](/azure/key-vault/managed-hsm/overview) or [Dedicated HSM](/azure/dedicated-hsm/overview). Both products provide a reserved amount of capacity, but they increase cost compared to Key Vault. Understand the limits on how many instances of these services that you can deploy in each region.

For more information, see the following resources:

- [Determine whether to use Key Vault or Dedicated HSM](/azure/dedicated-hsm/faq#how-do-i-decide-whether-to-use-azure-key-vault-or-azure-dedicated-hsm-)
- [Determine whether Dedicated HSM is right for you](/azure/dedicated-hsm/overview#is-azure-dedicated-hsm-right-for-you)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Jack Lichwa](https://www.linkedin.com/in/jacklichwa) | Principal Product Manager, Azure Key Vault
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.md)
