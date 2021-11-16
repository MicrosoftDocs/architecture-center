---
title: Key and secret management in Azure
description: Examine key and secret management considerations in Azure. Protect keys by storing them in the managed key vault service.
author: PageWriter-MSFT
ms.date: 09/23/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-active-directory
  - azure-key-vault
categories:
  - security
subject:
  - security
ms.custom:
  - article
---

# Key and secret management considerations in Azure

Encryption is an essential tool for security because it restricts access. However, it's equally important to protect the secrets (keys, certificates) key that provide access to the data.

## Key points
- Use identity-based access control instead of cryptographic keys.
- Use standard and recommended encryption algorithms.
- Store keys and secrets in managed key vault service. Control permissions with an access model.
- Rotate keys and other secrets frequently. Replace expired or compromised secrets.

## Identity-based access control

Organizations shouldn't develop and maintain their own encryption algorithms. There are many ways to provide access control over storage resources available, such as:

- Shared keys
- Shared signatures
- Anonymous access
- Identity provider-based methods

Secure standards already exist on the market and should be preferred. AES should be used as symmetric block cipher, `AES-128`, `AES-192`, and `AES-256` are acceptable. Crypto APIs built into operating systems should be used where possible, instead of non-platform crypto libraries. For .NET, make sure you follow the [.NET Cryptography Model](/dotnet/standard/security/cryptography-model#choosing-an-algorithm).

**Do you prioritize authentication through identity services for a workload over cryptographic keys?**
***
Protection of cryptographic keys can often get overlooked or implemented poorly. Managing keys securely with application code is especially difficult and can lead to mistakes such as accidentally publishing sensitive access keys to public code repositories.

Use of identity-based options for storage access control is recommended. This option uses role-based access controls (RBAC) over storage resources. Use RBAC to assign permissions to users, groups, and applications at a certain scope. Identity systems such as Azure Active Directory (Azure AD) offer secure and usable experience for access control with built-in mechanisms for handling key rotation, monitoring for anomalies, and others.

> [!NOTE]
> Grant access based on the principle of least privilege. Risk of giving more privileges than necessary can lead to data compromise.

Suppose you need to store sensitive data in Azure Blob Storage. You can use Azure AD and RBAC to authenticate a service principal that has the required permissions to access the storage. For more information about the feature, reference [Authorize access to blobs and queues using Azure Active Directory](/azure/storage/common/storage-auth-aad).

> [!TIP]
> Using SAS tokens is a common way to control access. SAS tokens are created by using the service owner's Azure AD credentials. The tokens are created per resource and you can use Azure RBAC to restrict access. SAS tokens have a time limit, which controls the window of exposure.
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: Azure Cognitive Services Reference Implementation](https://github.com/mspnp/cognitive-services-reference-implementation).
>
> The design considerations are described in [Speech transcription with Azure Cognitive Services](../../reference-architectures/ai/speech-to-text-transcription-pipeline.yml).

## Key storage

To prevent security leaks, store the following keys and secrets in a secure store:

- API keys
- Database connection strings
- Data encryption keys
- Passwords

Sensitive information shouldn't be stored within the application code or configuration. An attacker gaining read access to source code shouldn't gain knowledge of application and environment-specific secrets.

Store all application keys and secrets in a managed key vault service such as [Azure Key Vault](/azure/key-vault/general/overview) or [HashiCorp Vault](https://www.vaultproject.io/). Storing encryption keys in a managed store further limits access. The workload can access the secrets by authenticating against Key Vault by using managed identities. That access can be restricted with Azure RBAC.

Make sure no keys and secrets for any environment types (Dev, Test, or Production) are stored in application configuration files or CI/CD pipelines. Developers can use [Visual Studio Connected Services](/azure/key-vault/general/vs-key-vault-add-connected-service) or local-only files to access credentials.

Have processes that periodically detect exposed keys in your application code. An option is Credential Scanner. For information about the configuring task, reference [Credential Scanner task](/azure/security/develop/security-code-analysis-customize#credential-scanner-task).

**Do you have an access model for key vaults to grant access to keys and secrets?**
***
To secure access to your key vaults, control permissions to keys and secrets through an access model. For more information, reference [Access model overview](/azure/key-vault/general/secure-your-key-vault#access-model-overview).

**Suggested actions**

Consider using [Azure Key Vault](/azure/key-vault/general/overview) for secrets and keys.

## Operational considerations

**Who is responsible for managing keys and secrets in the application context?**
***

Key and certificate rotation is often the cause of application outages. Even Azure has experienced expired certificates. It's critical that the rotation of keys and certificates be scheduled and fully operationalized. The rotation process should be automated and tested to ensure effectiveness. Azure Key Vault supports key rotation and auditing.

Central SecOps team provides guidance on how keys and secrets are managed (governance). Application DevOps team is responsible for managing the application-related keys and secrets.

**What types of keys and secrets are used and how are those generated?**
***

The following approaches include:

- Microsoft-managed Keys
- Customer-managed Keys
- Bring Your Own Key

The decision is often driven by security, compliance, and specific data classification requirements. Develop a clear understanding of these requirements to determine the most suitable type of keys.

**Are keys and secrets rotated frequently?**
***

To reduce the attack vectors, secrets require rotation and are prone to expiration. The process should be automated and executed without any human interactions. Storing them in a managed store simplifies those operational tasks by handling key rotation.

Replace secrets after they've reached the end of their active lifetime or if they've been compromised. Renewed certificates should also use a new key. Have a process for situations where keys get compromised (leaked) and need to be regenerated on-demand. For example, secrets rotation in SQL Database.

For more information, reference [Key Vault Key Rotation](/azure/key-vault/secrets/tutorial-rotation-dual).

By using managed identities, you remove the operational overhead for storing the secrets or certificates of service principals.

**Are the expiration dates of SSL/TLS certificates monitored and are processes in place to renew them?**
***

A common cause of application outage is expired SSL/TLS certificates.

Avoid outages by tracking the expiration dates of SSL/TLS certificates and renewing them in due time. Ideally, the process should be automated, although this often depends on used certificate authority (CA). If not automated, use alerts to make sure expiration dates don't go unnoticed.

## Suggested actions

Implement a process for SSL certificate management and the automated renewal process with Azure Key Vault.

## Learn more

[Tutorial: Configure certificate auto-rotation in Key Vault](/azure/key-vault/certificates/tutorial-rotate-certificates)

## Related content

Identity and access management services authenticate and grant permission to the following groups:

- Users
- Partners
- Customers
- Applications
- Services
- Other entities

For security considerations, reference [Azure identity and access management considerations](design-identity.md).

> [Back to the main article: Data protection](design-storage.md)

## Next steps

Protect data at rest and in transit through encryption. Make sure you use standard encryption algorithms.

> [!div class="nextstepaction"]
> [Data encryption ](design-storage-encryption.md)
