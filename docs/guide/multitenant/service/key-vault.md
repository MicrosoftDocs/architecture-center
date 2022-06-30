---
title: Azure Key Vault considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Key Vault that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Key Vault in a multitenant solution.
author: jodowns
ms.author: johndowns
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

Azure Key Vault is used to manage secure data for your solution, including secrets, encryption keys, and certificates. On this page, we describe some of the features of Azure Key Vault that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Azure Key Vault.

## Isolation models

### Shared vault

- Store multiple tenants' secrets within a single vault, managed in your (the provider's) Azure subscription.
- This is the most commonly used approach, and what we'd generally recommend.
- Watch out for limits around the number of operations you can perform against a vault. Again, follow best practices to avoid running up against the limit.
- If you build a multi-region solution, consider using a separate vault in each region. This helps with performance, because you don't want cross-region traffic to access vault data.
- If you build out your solution by using deployment stamps, deploy shared vaults into each stamp.
- When defining your secrets, keys, and certificates, consider using naming convention like a naming prefix - e.g. prepending the tenant ID to the name of each secret.

### Vault per tenant, in provider's subscription

- Can make sense when you have separate application deployments for each tenant. If you don't, consider whether this really gives you any benefit because the trust will probably be from the app to all of the vaults.
- There is no limit to the number of vaults you can deploy into a subscription (TODO confirm with PG).
- Watch out for the subscription-wide transaction limit - i.e. all vaults within a subscription can use (between them) 20,000 transactions per second. But, realistically, even high scale services can run against Key Vault if they follow [best practices](https://docs.microsoft.com/azure/key-vault/general/overview-throttling) like caching secrets and using [envelope encryption](https://docs.microsoft.com/azure/security/fundamentals/encryption-atrest#envelope-encryption-with-a-key-hierarchy). Avoid sending every encryption operation to Key Vault.
- Also, when you get to higher numbers of vaults, be aware of the [total number of RBAC role assignments you can create within a subscription](https://docs.microsoft.com/azure/role-based-access-control/troubleshooting#azure-role-assignments-limit).

### Vault per tenant, in the tenant's subscription

- You might need to access a vault that a tenant creates and manages in their own Azure subscription. They create secrets, certificates, and keys for you to read and work with.
- This is sometimes called *customer-managed keys* (CMKs).
- In order to access the data in their vault, tou need to authenticate to the tenant's Azure AD tenant. Common approaches for enabling cross-Azure AD tenant authentication include:
  - You publish a [multitenant Azure AD application](https://docs.microsoft.com/azure/active-directory/develop/single-and-multi-tenant-apps). You request your your tenants to register that multitenant app in their Azure AD tenant and grant it access to their vault. Your application code uses a service principal associated with the multitenant Azure AD application to authenticate to their key vault.
  - You ask your tenants to create a service principal for your service to use, and to provide you with its credentials.
- If your tenants use network access controls on their vaults, ensure that you'll be able to access the vaults.

## Features of Azure Key Vault that support multitenancy

### Tags

- Key Vault supports tagging secrets, certificates, and keys. So you could use them to attach the tenant ID or other metadata.
- However, you can't query by tags, so this is more for management purposes than for application logic.

More information:
- [Secret tags](https://docs.microsoft.com/azure/key-vault/secrets/about-secrets#secret-tags)
- [Certificate tags](https://docs.microsoft.com/azure/key-vault/certificates/about-certificates#certificate-attributes-and-tags)
- [Key tags](https://docs.microsoft.com/azure/key-vault/keys/about-keys-details#key-tags)

### Azure Policy support

- If you decide to deploy large numbers of vaults, consider using Azure Policy to verify the vaults have been configured according to your requirements, such as using the correct network access settings, logging, etc.

More information:
- [Integrate Azure Key Vault with Azure Policy](https://docs.microsoft.com/azure/key-vault/general/azure-policy?tabs=certificates)
- [Azure Policy built-in definitions for Key Vault](https://docs.microsoft.com/azure/key-vault/policy-reference)

### Managed HSM and Dedicated HSM

- If you need to do a large number of operations per second and this could cause you problems with limits, consider [Managed HSM](https://docs.microsoft.com/azure/key-vault/managed-hsm/overview) or [Dedicated HSM](https://docs.microsoft.com/azure/dedicated-hsm/overview).
- Both products provide a reserved capacity model, but are generally more costly than Key Vault. Additionally, be aware of the limits on the number of instances that you can deploy into each region.

More information:
- [How do I decide whether to use Azure Key Vault or Azure Dedicated HSM?](https://docs.microsoft.com/azure/dedicated-hsm/faq#how-do-i-decide-whether-to-use-azure-key-vault-or-azure-dedicated-hsm-)
- [Is Azure Dedicated HSM right for you?](https://docs.microsoft.com/azure/dedicated-hsm/overview#is-azure-dedicated-hsm-right-for-you)

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
