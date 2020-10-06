---
title: Applications and services in Azure | Microsoft Docs
description: Secure your applications and services in Azure
author: v-aangie
ms.date: 09/17/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Applications and services

Applications and the data associated with them ultimately act as the primary store of business value on a cloud platform. While the platform components like identity and storage are critical elements of the security environment, applications play an outsize role in risks to the business because:

- **Business Processes** are encapsulated and executed by applications and services need to be available and provided with high integrity.
- **Business Data** is stored and processed by application workloads and requires high assurances of confidentiality, integrity, and availability.

This section focuses on applications written by your organization or by others on behalf of your organization vs. SaaS or commercially available applications installed on IaaS VMs.

![Diagram of Application Models](images/appmodels.png)

Modern cloud platforms like Azure can host both legacy and modern generations of applications.

- **Legacy** applications are hosted on Infrastructure as a Service (IaaS) virtual machines that typically include all dependencies including OS, middleware, and other components.

- **Modern** Platform as a Service (PaaS) applications don’t require the application owner to manage and secure the underlying server operating systems and are sometimes fully “Serverless” and built primarily using functions as a service.

    **Notes:** Popular forms of modern applications are application code hosted on Azure App Services and containerized applications (though containers can also be hosted on IaaS VMs or on-premises as well).

- **Hybrid:** While hybrid applications can take many forms, the most common is an “IaaS plus” state where legacy applications are transitioning to a modern architecture with modern services replacing legacy components or being added a legacy application.

Securing an application requires security assurances for three different component types:

- **Application Code:** This is the logic that defines the custom application that you write. The security of this code is the application owners’ responsibility in all generations of application architecture including any open-source snippets or components included in the code. Securing the code requires identifying and mitigating risks from the design and implementation of the application as well as assessing supply chain risk of included components. Note that the evolution of applications into [microservices architectures](/azure/service-fabric/service-fabric-overview-microservices) will break various aspects of application code into smaller services vs. a single monolithic codebase.

- **Application Services:** These are the various standardized components that the application uses such as databases, identity providers, event hubs, IoT device management, and so on. For cloud services this is a shared responsibility:

    -   **Cloud Provider -** The security of the underlying service is the responsibility of the cloud provider.

    -   **Application Owner** - The application owner is responsible for security implications of the configuration and operation of the service instance(s) used by the application including any data stored and processed on the service.

- **Application Hosting Platform** – This is the computing environment where the application actually executes and runs. In an enterprise with applications hosted on premises, in Azure and in third-party clouds like Amazon Web Services (AWS), this could take many forms with significant variations on who is responsible for security:

    -   **Legacy Applications** typically require a full operating system (and any middleware) hosted on physical or virtualized hardware. The virtual hardware can be hosted on premises or on Infrastructure as a Service (IaaS) VMs. This operating system and installed middleware/other components are operated and secured by the application owner or their infrastructure team(s). 
    The responsibility for the physical hardware and OS virtualization components (virtualization hosts, operating systems, and management services) varies:
         -   **On premises** - The application owner or their organization is responsible for maintenance and security.
         -   **IaaS** – The cloud provider is responsible for maintenance and security of the underlying infrastructure and the application owner’s organization is responsible for the VM configuration, 
            operating system, and any components installed on it.

    -   **Modern Applications** are hosted on Platform as a Service (PaaS) environments such as an Azure application service. In most application service types, the underlying operating system is abstracted from the application owner and secured by the cloud provider. Application owners are responsible for the security of the application service configurations that are provided to them.

    -   **Containers** are an application packaging mechanism in which applications are abstracted from the environment in which they run. These containerized applications fit into either the legacy or modern
        models above depending on whether they are run on a container service by the cloud provider (Modern Applications) or on a server managed by the organization (on premises or in IaaS).

## Identify and classify business critical applications

Ensure you have identified and classified the applications in your portfolio that are critical to business functions.

Enterprise organizations typically have a large application portfolio, so prioritizing where to invest time and effort into manual and resource intensive tasks like threat modeling can increase the effectiveness of your security program.

Identify applications that have a high potential impact and/or a high potential exposure to risk.

- **High potential impact** – Identify application that would a significant impact on the business if compromised. This could take the form of one or more of:

    -   **Business critical data** – Applications that process or store information, which would cause significant negative business or mission impact if an assurance of confidentiality, integrity, or availability is lost.

    -   **Regulated data** – Applications that handle monetary instruments and sensitive personal information regulated by standards. For example, payment card industry (PCI) and Health Information Portability and Accountability Act (HIPAA).

    -   **Business critical availability** – Applications whose functionality is critical to organizations business mission such as production lines generating revenue, devices, or services critical to life and safety, and other critical functions.

    -   **Significant Access** – Applications which have access to systems with a high potential impact through technical means such as 
        -   *Stored Credentials* or keys/certificates that grant access to the data/service
        -   *Permissions* granted via access control lists or other means

- **High exposure to attacks** – Applications that are easily accessible to attackers such as web applications on the open internet. Legacy applications can also be higher exposure as attackers and penetration testers frequently target them because they know these legacy applications often have vulnerabilities that are difficult to fix.

## Use Cloud services instead of custom implementations

Developers should use services available from your cloud provider for well-established functions like databases, encryption, identity directory, and authentication instead of writing custom versions of them.

These services provide better security, reliability, and efficiency because cloud providers operate and secure them with dedicated teams with deep expertise in those areas. Using these services also frees your developer resources from reinventing the proverbial wheel so that they can focus development time on your unique requirements for your business. This practice should be followed to avoid risk during new application development as well as to reduce risk in existing applications either during planned update cycle or with a security-focused application update.

Several capabilities that should be prioritized first because of potential security impact:

- **Identity** – User directories and other authentication functions are complex to develop and critically important to security assurances. Avoid using homegrown authentication solutions and favor mature capabilities like Azure Active Directory ([Azure AD](/azure/active-directory/)), [Azure AD B2B](/azure/active-directory/b2b/), [Azure AD B2C](/azure/active-directory-b2c/), or third-party solutions to authenticate and grant permission to users, partners, customers, applications, services, and other entities.

- **Data Protection** – Developers should use established capabilities from cloud providers such as native encryption in cloud services to encrypt and protect data. The security world is littered with examples of failed attempts to protect data or passwords that didn’t stand up to real world attacks. If direct use of cryptography is required, developers should call well-established cryptographic algorithms and not attempt to invent their own.

- **Key management** – Ideally use identity for authentication rather than directly handling keys (see [Prefer Identity Authentication over Keys](#prefer-identity-authentication-over-keys)).
    For situations where accessing services that require access to keys, leverage a key management service like [Azure Key Vault](/azure/key-vault/) or AWS [Key Management Service](https://aws.amazon.com/kms/) to manage and secure these keys rather than attempting to safely handle keys in application code. You can use [CredScan](https://secdevtools.azurewebsites.net/helpcredscan.html) to discover potentially exposed keys in your application code.

- **Application Configurations** – Inconsistent configurations for applications can create security Risks. Azure App Configuration provides a service to centrally manage application settings and feature flags, which helps mitigate this risk.

## Use Native Security capabilities in application services

Use native security capabilities built into cloud services instead of adding external security components (for data encryption, network traffic filtering, threat detection, and other functions).

Native security controls are maintained and supported by the service provider, eliminating or reducing effort required to integrate external security tooling and update those integrations over time. Cloud services evolve rapidly, which greatly increases the burden of maintaining an external tool and increases risk of losing security visibility and protections from these tools if the tool doesn’t keep up with the cloud service.

- List of Azure Services  
    <https://azure.microsoft.com/services/>

- Native security capabilities of each service  
    <https://docs.microsoft.com/azure/security/common-security-attributes>

## Prefer Identity Authentication over Keys

Always authenticate with identity services rather than cryptographic keys when available.

Managing keys securely with application code is difficult and regularly leads to mistakes like accidentally publishing sensitive access keys to code repositories like GitHub. Identity systems offer secure and usable experience for access control with built-in sophisticated mechanisms for key rotation, monitoring for anomalies, and more. Most organizations also have skilled teams dedicated to managing identity systems and few (if any) people actively managing key security systems.

For services that offer the Azure AD authentication like [Azure Storage](/azure/storage/common/storage-security-attributes), [Azure App Service](/azure/app-service/app-service-security-attributes), [Azure Backup](/azure/backup/backup-security-attributes), use it for authentication and authorization. To further simplify using identities for developers, you can also take advantage of [managed identities](/azure/active-directory/managed-identities-azure-resources/) to assign identities to resources like VMs and App Services so that developers don’t have to manage identities within the application.

For multitenant best practices, see [Manage identity in multitenant applications](../../multitenant-identity/index.md).