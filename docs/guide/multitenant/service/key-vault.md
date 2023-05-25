---
title: Azure Key Vault considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Key Vault that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Key Vault in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 05/08/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-key-vault
categories:
 - management-and-governance
 - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Key Vault

Azure Key Vault is used to manage secure data for your solution, including secrets, encryption keys, and certificates. In this article, we describe some of the features of Azure Key Vault that are useful for multitenant solutions. We then provide links to the guidance that can help you, when you're planning how you're going to use Key Vault.

## Isolation models

When working with a multitenant system using Key Vault, you need to make a decision about the level of isolation that you want to use. The choice of isolation models you use depends on the following factors:

- How many tenants do you plan to have?
- Do you share your application tier between multiple tenants, do you deploy single-tenant application instances, or do you deploy separate deployment stamps for each tenant?
- Do your tenants need to manage their own encryption keys?
- Do your tenants have compliance requirements that require their secrets are stored separately from other tenants' secrets?

The following table summarizes the differences between the main tenancy models for Key Vault:

| Consideration | Vault per tenant, in the provider's subscription | Vault per tenant, in the tenant's subscription | Shared vault |
|-|-|-|-|
| **Data isolation** | High | Very high | Low |
| **Performance isolation** | Medium. High throughput might be limited, even with many vaults | High | Low |
| **Deployment complexity** | Low-medium, depending on the number of tenants | High. The tenant must correctly grant access to the provider | Low |
| **Operational complexity** | High | Low for the provider, higher for the tenant | Lowest |
| **Example scenario** | Individual application instances per tenant | Customer-managed encryption keys | Large multitenant solution with a shared application tier |

### Vault per tenant, in the provider's subscription

You might consider deploying a vault for each of your tenants within your (the service provider's) Azure subscription. This approach provides you with strong data isolation between each tenant's data, but it requires that you deploy and manage an increasing number of vaults, as you increase the number of tenants.

This approach makes sense when you have separate application deployments for each tenant. If you have a shared application tier, it's unlikely that using separate vaults will give you much data isolation benefit, because all of the vaults need to trust the same application tier.

There's no limit to the number of vaults you can deploy into an Azure subscription. However, you should consider the following limits:

- [There are subscription-wide limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#key-vault-limits) on the number of requests in a time period. These limits apply regardless of the number of vaults in the subscription. So, it's important to follow our [throttling guidance](/azure/key-vault/general/overview-throttling), even when you have tenant-specific vaults.
- There's a [limit to the number of Azure role assignments that you can create within a subscription](/azure/role-based-access-control/troubleshooting#azure-role-assignments-limit). When you deploy and configure large numbers of vaults in a subscription, you might approach these limits.

### Vault per tenant, in the tenant's subscription

In some situations, your tenants might create vaults in their own Azure subscriptions, and they might want to grant your application access to work with secrets, certificates, or keys. This approach is appropriate when you allow *customer-managed keys* (CMKs) for encryption within your solution.

In order to access the data in your tenant's vault, the tenant must provide your application with access to their vault. This process requires that your application authenticates through their Azure AD instance. One approach is to publish a [multitenant Azure AD application](/azure/active-directory/develop/single-and-multi-tenant-apps). Your tenants must perform a one-time consent process. They first register the multitenant Azure AD application in their own Azure AD tenant. Then, they grant your multitenant Azure AD application the appropriate level of access to their vault. They also need to provide you with the full resource ID of the vault that they've created. Then, your application code can use a service principal that's associated with the multitenant Azure AD application in your own Azure AD, to access each tenant's vault.

Alternatively, you might ask each tenant to create a service principal for your service to use, and to provide you with its credentials. However, this approach requires that you securely store and manage credentials for each tenant, which is a potential security liability.

If your tenants configure network access controls on their vaults, make sure you'll be able to access the vaults.

### Shared vaults

You might choose to share tenants' secrets within a single vault. The vault is deployed in your (the solution provider's) Azure subscription, and you're responsible for managing it. This approach is simplest, but it provides the least data isolation and performance isolation.

You might also choose to deploy multiple shared vaults. For example, if you follow the [Deployment Stamps pattern](../approaches/overview.yml#deployment-stamps-pattern), it's likely you'll deploy a shared vault within each stamp. Similarly, if you deploy a multi-region solution, you should deploy vaults into each region for the following reasons:

- To avoid cross-region traffic latency when working with the data in your vault.
- To support data residency requirements.
- To enable the use of regional vaults within other services that require same-region deployments.

When you work with a shared vault, it's important to consider the number of operations you perform against the vault. Operations include reading secrets and performing encryption or decryption operations. [Key Vault imposes limits on the number of requests](/azure/azure-resource-manager/management/azure-subscription-service-limits#key-vault-limits) that can be made against a single vault, and across all of the vaults within an Azure subscription. Ensure that you follow the [throttling guidance](/azure/key-vault/general/overview-throttling). It's important to follow the recommended practices, including securely caching the secrets that you retrieve and using [envelope encryption](/azure/security/fundamentals/encryption-atrest#envelope-encryption-with-a-key-hierarchy) to avoid sending every encryption operation to Key Vault. When you follow these best practices, you can run high-scale solutions against a single vault.

If you need to store tenant-specific secrets, keys, or certificates, consider using a naming convention like a naming prefix. For example, you might prepend the tenant ID to the name of each secret. Then, your application code can easily load the value of a specific secret for a specific tenant.

## Features of Azure Key Vault that support multitenancy

### Tags

Key Vault supports tagging secrets, certificates, and keys with custom metadata, so you can use a tag to track the tenant ID for each tenant-specific secret. However, Key Vault doesn't support querying by tags, so this feature is best suited for management purposes, rather than for use within your application logic.

More information:
- [Secret tags](/azure/key-vault/secrets/about-secrets#secret-tags)
- [Certificate tags](/azure/key-vault/certificates/about-certificates#certificate-attributes-and-tags)
- [Key tags](/azure/key-vault/keys/about-keys-details#key-tags)

### Azure Policy support

If you decide to deploy a large number of vaults, it's important to ensure that they follow a consistent standard for network access configuration, logging, and access control. Consider using Azure Policy to verify the vaults have been configured according to your requirements.

More information:
- [Integrate Azure Key Vault with Azure Policy](/azure/key-vault/general/azure-policy?tabs=certificates)
- [Azure Policy built-in definitions for Key Vault](/azure/key-vault/policy-reference)

### Managed HSM and Dedicated HSM

If you need to perform a large number of operations per second, and the Key Vault operation limits are insufficient, consider using either [Managed HSM](/azure/key-vault/managed-hsm/overview) or [Dedicated HSM](/azure/dedicated-hsm/overview). Both products provide you with a reserved amount of capacity, but they're usually more costly than Key Vault. Additionally, be aware of the limits on the number of instances of these services that you can deploy into each region.

More information:
- [How do I decide whether to use Azure Key Vault or Azure Dedicated HSM?](/azure/dedicated-hsm/faq#how-do-i-decide-whether-to-use-azure-key-vault-or-azure-dedicated-hsm-)
- [Is Azure Dedicated HSM right for you?](/azure/dedicated-hsm/overview#is-azure-dedicated-hsm-right-for-you)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

 * [Jack Lichwa](https://www.linkedin.com/in/jacklichwa) | Principal Product Manager, Azure Key Vault
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
