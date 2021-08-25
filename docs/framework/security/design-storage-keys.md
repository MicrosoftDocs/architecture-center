---
title: Key and secret management in Azure
description: Examine key and secret management considerations in Azure. Protect keys by storing them in the managed key vault service.
author: PageWriter-MSFT
ms.date: 12/03/2020
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
- Store keys and secrets in managed key vault service. Control permissions with an access model.
- Rotate keys and other secrets frequently. Replace secrets at the end their lifetime or if they've been compromised.

## Identity-based access control

There are many ways to provide access control over storage resources available, such as shared keys, shared signatures, anonymous access, and identity provider-based methods. 

**Do you prioritize authentication through identity services for a workload over cryptographic keys?**
***
Protection of cryptographic keys can often get overlooked or implemented poorly. Managing keys securely with application code is especially difficult and can lead to mistakes such as accidentally publishing sensitive access keys to public code repositories.

Use of identity-based option for storage access control is recommended. This option uses role-based access controls (RBAC) over storage resources. Use RBAC to assign permissions to users, groups, and applications at a certain scope. Identity systems such as Azure Active Directory(Azure AD) offer secure and usable experience for access control with built-in mechanisms for handling key rotation, monitoring for anomalies, and others.

> ![Task](../../_images/i-best-practices.svg) 
> Grant access based on the principle of least privilege. Risk of giving more privileges than necessary can lead to data compromise.

Suppose you need to store sensitive data in Azure Blob Storage. You can use Azure AD and RBAC to authenticate a service principal that has the required permissions to access the storage. For more information about the feature, see [Authorize access to blobs and queues using Azure Active Directory](/azure/storage/common/storage-auth-aad).

> [!TIP]
> Using SAS tokens is a common way to control access. These SAS tokens created by using the service owner's Azure AD credentials. The tokens are created per resource and you can use Azure RBAC to restrict access. SAS tokens have a time limit, which controls the window of exposure. 
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: Azure Cognitive Services Reference Implementation](https://github.com/mspnp/cognitive-services-reference-implementation).
>
> The design considerations are described in [Speech transcription with Azure Cognitive Services](../../reference-architectures/ai/speech-to-text-transcription-pipeline.yml).



## Key storage

API keys, database connection strings, and passwords can get leaked. Also, data encryption keys are considered to be sensitive information. 

Store all application keys and secrets in managed key vault service such as [Azure Key Vault](/azure/key-vault/general/overview) and not within the application code or configuration. Storing encryption keys a managed store further limits access. The workload can access the secrets by authenticating itself against Key Vault by using managed identities. That access can be restricted with Azure RBAC.

Make sure that no keys and secrets for any environment types (Dev/Test, or production) are stored in application configuration files or CI/CD pipelines. Developers can use [Visual Studio Connected Services](/azure/key-vault/general/vs-key-vault-add-connected-service) or local-only files to access credentials.

Have processes that periodically detect exposed keys in your application code. An option is Credential Scanner. For information about configuring task, see [Credential Scanner task](/azure/security/develop/security-code-analysis-customize#credential-scanner-task).

**Do you have an access model for key vaults to grant access to keys and secrets?**
***
To secure access to your key vaults, control permissions to keys and secrets an access model. For more information, see [Access model overview](/azure/key-vault/general/secure-your-key-vault#access-model-overview).


## Operational considerations


**Who is responsible for managing keys and secrets in the application context?**
***

Key and certificate rotation is often the cause of application outages. Even Azure has experienced expired certificates. It is critical that the rotation of keys and certificates be scheduled and fully operationalized. The rotation process should be automated and tested to ensure effectiveness. Azure Key Vault supports key rotation and auditing.

Central SecOps team provides guidance on how keys and secrets are managed (governance). Application DevOps team is responsible for managing the application-related keys and secrets.

**What types of keys and secrets are used and how are those generated?**
***

There are various approaches. Options include Microsoft-managed Keys, Customer-managed Keys, Bring Your Own Key. The decision is often driven by security, compliance and specific data classification requirements. Have a clear understanding these requirements to determine the most suitable type of keys. 

**Are keys and secrets rotated frequently?**
***

To reduce the attack vectors, secrets require rotation and be prone to expiration. The process should be automated and executed without any human interactions. Storing them in a managed store simplifies those operational tasks by handling key rotation.

Replace secrets after they've reached the end of their active lifetime or if they've been compromised. Renewed certificates should also use a new key. Have a process for situations where keys get compromised (leaked) and need to be regenerated on-demand. For example, secrets rotation in SQL Database.

For more information, see [Key Vault Key Rotation](/azure/key-vault/secrets/tutorial-rotation-dual).

By using managed identities, you remove the operational overhead for storing the secrets or certificates of service principals.

**Are the expiry dates of SSL/TLS certificates monitored and are processes in place to renew them?**
***

A common cause of application outage are expired SSL/TLS certificates.

Avoid outages by tracking the expiry dates of SSL/TLS certificates and renewing them in due time. Ideally, the process should be automated, although this often depends on used certificate authority (CA). If not automated, use alerts to make sure expiry dates do not go unnoticed.

## Suggested actions

Implement a process for SSL certificate management and the automated renewal process with Azure Key Vault.

## Learn more

[Tutorial: Configure certificate auto-rotation in Key Vault](/azure/key-vault/certificates/tutorial-rotate-certificates)


## Next steps

Protect data at rest and in transit through encryption. Make sure you use standard encryption algorithms. 

> [!div class="nextstepaction"]
> [Data encryption ](design-storage-encryption.md)


## Related content

Identity and access management services authenticate and grant permission to users, partners, customers, applications, services, and other entities. For security considerations, see [Azure identity and access management considerations](design-identity.md).

> [Back to the main article: Data protection](design-storage.md)