---
title: Application classification for security
description: Understanding the Azure hosting models of legacy and modern apps through IaaS and PaaS, and the security responsibilities of those models.
author: v-aangie
ms.date: 09/17/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
products:
  - azure-devops
categories:
  - security
subject:
  - security
---
# Application classification for security

Azure can host both legacy and modern applications through Infrastructure as a Service (IaaS) virtual machines and 	Platform as a Service (PaaS). With legacy applications, you have the responsibility of securing all dependencies including OS, middleware, and other components. For PaaS applications, you don't need to manage and secure the underlying server OS. You are responsible for the application configuration.

This article describes the considerations for understanding the hosting models and the security responsibility of each, identifying critical applications.

## Understand your responsibility as an owner

![Diagram of Application Models](images/appmodels.png)

Securing an application requires security assurances for three aspects:

- **Application code**. The logic that defines the custom application that you write. Securing that code requires identifying and mitigating risks from the design and implementation of the application and assessing supply chain risk of included components.
- **Application services**. The cloud services that the application uses such as databases, identity providers, event hubs, IoT device management, and so on. Security for cloud services is a shared responsibility. The cloud provider ensures the security of the underlying service. The application owner is responsible for security implications of the configuration and operation of the service instance(s) used by the application including any data stored and processed on the service.
- **Application hosting platform**. The computing environment where the application runs. This could take many forms with significant variations on who is responsible for security:

    -   **Legacy applications**. typically require a full operating system (and any middleware) hosted on physical or virtualized hardware. This operating system and installed middleware/other components are operated and secured by the application owner or their infrastructure team(s). The security responsibility for the physical hardware and OS virtualization components (virtualization hosts, operating systems, and management services) varies:
         -   **On-premises:** The application owner is responsible for maintenance and security.
         -   **IaaS:** The cloud provider is responsible for the underlying infrastructure and the application owner's organization is responsible for the VM configuration, operating system, and any components installed on it.

    -   **Modern applications** are hosted on PaaS environments such as an Azure application service. The underlying operating system is secured by the cloud provider. Application owners are responsible for the security of the application service configurations.

    -   **Containers** are an application packaging mechanism in which applications are abstracted from the environment in which they run. The containerized applications can run on a container service by the cloud provider (modern applications) or on a server managed on premises or in IaaS.

## Identify and classify applications

Identify applications that have a high potential impact and,or a high potential exposure to risk.
- **Business critical data**. Applications that process or store information must have assurance of confidentiality, integrity, and availability.
- **Regulated data**. Applications that handle monetary instruments and sensitive personal information regulated by standards such as the payment card industry (PCI), General Data Protection Regulation (GDPR), and Health Information Portability and Accountability Act (HIPAA).
- **Business critical availability**. Applications whose functionality is critical to the business mission, such as production lines generating revenue, devices or services critical to life and safety, and other critical functions.
- **Significant Access**. Applications that have access to systems with a high impact through technical means such as
    - Stored Credentials or keys/certificates that grant access to the data/service.
    - Permissions granted through access control lists or other methods.
- **High exposure to attacks**. Applications that are easily accessible to attackers such as web applications on the public internet. Legacy applications can also be higher exposure as attackers (and penetration testers) frequently target them because they know these legacy applications often have vulnerabilities that are difficult to fix.

## Use Azure services for fundamental components

Developers should use services available from a cloud provider for well-established functions like databases, encryption, identity directory, and authentication, instead of building or adopting custom implementations, or third-party solutions that require integration with the cloud provider. These services provide better security, reliability, and efficiency because cloud providers operate and secure them with dedicated teams with deep expertise in those areas.

Using these services also frees your developer resources from reinventing the proverbial wheel so that they can focus development time on your unique requirements for your business. This practice should be followed to avoid risk during new application development and to reduce risk in existing applications either during the planned update cycle, or with a security-focused application update.

We recommend using cloud services from your cloud provider for identity, data protection, key management, and application configurations:

- **Identity:** User directories and other authentication functions are complex to develop and critically important to security assurances. Avoid custom authentication solutions. Instead  choose native capabilities like Azure Active Directory ([Azure AD](/azure/active-directory/)), [Azure AD B2B](/azure/active-directory/b2b/), [Azure AD B2C](/azure/active-directory-b2c/), or third-party solutions to authenticate and grant permission to users, partners, customers, applications, services, and other entities. For more information, see [Security with identity and access management (IAM) in Azure](design-identity.md).

- **Data Protection:** Use established capabilities from cloud providers such as native encryption in cloud services to encrypt and protect data. If direct use of cryptography is required, use well-established cryptographic algorithms and not attempt to invent their own.

- **Key management:** Always authenticate with identity services rather than handling cryptographic key. For situations where you need to keys, use a managed key store such as [Azure Key Vault](/azure/key-vault/). This will make sure keys are handled safely in application code. Tools such as, CredScan can discover potentially exposed keys in your application code.

- **Application Configurations:** Inconsistent configurations for applications can create security risks. Application configuration information can be stored with the application itself or preferably using a dedicated configuration management system like [Azure App Configuration](/azure/azure-app-configuration/overview) or Azure Key Vault. App Configuration provides a service to centrally manage application settings and feature flags, which helps mitigate this risk. Don't store keys and secrets in application configuration.

For more information about using cloud services instead of custom implementations, reference [Applications and services](./design-apps-services.md).

## Use native capabilities

Use native security capabilities built into cloud services instead of adding external security components, such as  data encryption, network traffic filtering, threat detection, and other functions.

Azure controls are maintained and supported by Microsoft. You don't have to invest in additional security tooling.

- [List of Azure Services](https://azure.microsoft.com/services/)
- [Native security capabilities of each service](/azure/security/common-security-attributes)

## Next steps
- [Applications and services](design-apps-services.md)
- [Application classification](design-apps-considerations.md)
- [Application threat analysis](design-threat-model.md)
- [Regulatory compliance](design-regulatory-compliance.md)
