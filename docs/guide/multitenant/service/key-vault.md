---
title: Azure Key Vault considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Key Vault that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Key Vault in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 06/20/2022
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

Azure Key Vault is used to manage secure data for your solution, including secrets, encryption keys, and certificates. On this page, we describe some of the features of Azure Key Vault that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Key Vault.

## Isolation models

When working with a multitenant system using Key Vault, you need to make a decision about the level of isolation you want to use. Key Vault supports several isolation models.

### Shared vault

You might choose to share tenants' secrets within a single vault. The vault is deployed in your (the solution provider's) Azure subscription, and you are responsible for managing it. The shared vault approach is the most commonly used isolation for Key Vault, and is the best choice for many solutions.

You might choose to deploy multiple shared vaults. For example, if you follow the [Deployment Stamps pattern](../approaches/overview.yml#deployment-stamps-pattern), it's likely you'll deploy a shared vault within each stamp. Similarly, if you deploy a multi-region solution, you should deploy vaults into each region to avoid cross-region traffic latency when working with the data in your vault.

When you work with a shared vault, it's important to consider the number of operations you perform against the vault, such as reading secrets or performing encryption or decryption operations. [Key Vault imposes limits on the number of requests](/azure/azure-resource-manager/management/azure-subscription-service-limits#key-vault-limits) that can be made against a single vault, and across all of the vaults within an Azure subscription. Ensure that you follow the [throttling guidance](/azure/key-vault/general/overview-throttling). It's important to follow the recommended practices including caching the secrets that you retrieve, and using [envelope encryption](/azure/security/fundamentals/encryption-atrest#envelope-encryption-with-a-key-hierarchy) to avoid sending every encryption operation to Key Vault. When you follow these best practices, you can run high-scale solutions against a single vault.

If you need to store tenant-specific secrets, keys, or certificates, consider using a naming convetion like a naming prefix. For example, you might prepend the tenant ID to the name of each secret. Then, your application code can easily load the value of a specific secret for a specific tenant.

### Vault per tenant, in provider's subscription

If you need more isolation than a single vault provides, you can deploy a vault for each of your tenants within your (the service provider's) Azure subscription.

This approach makes sense when you have separate application deployments for each tenant. If you have a shared application tier, it's unlikely that using separate vaults will give you much isolation benefit because all of the vaults need to trust the same application tier.

There's no limit to the number of vaults you can deploy into an Azure subscription. However, two limits you should consider are:

- [There are subscription-wide limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#key-vault-limits) on the number of requests in a time period. These limits regardless of the number of vaults in the subscription. So, it's important to follow [throttling guidance](/azure/key-vault/general/overview-throttling) even when you have tenant-specific vaults.
- There is a [limit to the number of Azure role assignments that you can create within a subscription](/azure/role-based-access-control/troubleshooting#azure-role-assignments-limit). When you deploy and configure large numbers of vaults in a subscription, you might approach these limits.

### Vault per tenant, in the tenant's subscription

In some situations, your tenants might create vaults in their own Azure subscriptions and want to grant you access to work with secrets, certificates, or keys. This approach might be appropriate when you allow *customer-managed keys* (CMKs) for encryption within your solution.

In order to access the data in their vault, you need to authenticate to the tenant's Azure AD tenant. One approach is to publish a [multitenant Azure AD application](/azure/active-directory/develop/single-and-multi-tenant-apps). Your tenants must perform a one-time configuration process where they register the multitenant Azure AD application in their own Azure AD tenant, and grant your multitenant Azure AD application the appropriate level of access to their vault. They also need to provide you with the full resource ID of the vault that they've created. Then, your application code can uses a service principal associated with the multitenant Azure AD application in your own Azure AD tenant to authenticate to each tenant's vault.

Alternatively, you might ask each tenant to create a service principal for your service to use, and to provide you with its credentials. However, this approach requires that you securely store and manage credentials for each tenant, which is a potential security liability.

If your tenants configure network access controls on their vaults, ensure that you'll be able to access the vaults.

## Features of Azure Key Vault that support multitenancy

### Tags

- Key Vault supports tagging secrets, certificates, and keys. So you could use them to attach the tenant ID or other metadata.
- However, you can't query by tags, so this is more for management purposes than for application logic.

More information:
- [Secret tags](/azure/key-vault/secrets/about-secrets#secret-tags)
- [Certificate tags](/azure/key-vault/certificates/about-certificates#certificate-attributes-and-tags)
- [Key tags](/azure/key-vault/keys/about-keys-details#key-tags)

### Azure Policy support

- If you decide to deploy large numbers of vaults, consider using Azure Policy to verify the vaults have been configured according to your requirements, such as using the correct network access settings, logging, etc.

More information:
- [Integrate Azure Key Vault with Azure Policy](/azure/key-vault/general/azure-policy?tabs=certificates)
- [Azure Policy built-in definitions for Key Vault](/azure/key-vault/policy-reference)

### Managed HSM and Dedicated HSM

- If you need to do a large number of operations per second and this could cause you problems with limits, consider [Managed HSM](/azure/key-vault/managed-hsm/overview) or [Dedicated HSM](/azure/dedicated-hsm/overview).
- Both products provide a reserved capacity model, but are generally more costly than Key Vault. Additionally, be aware of the limits on the number of instances that you can deploy into each region.

More information:
- [How do I decide whether to use Azure Key Vault or Azure Dedicated HSM?](/azure/dedicated-hsm/faq#how-do-i-decide-whether-to-use-azure-key-vault-or-azure-dedicated-hsm-)
- [Is Azure Dedicated HSM right for you?](/azure/dedicated-hsm/overview#is-azure-dedicated-hsm-right-for-you)

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
