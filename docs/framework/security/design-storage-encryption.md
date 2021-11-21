---
title: Data encryption in Azure
description: Protect data in transit and at rest through encryption in Azure. Learn about Azure encryption features and standard encryption algorithms.
author: PageWriter-MSFT
ms.date: 9/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-storage
  - azure-active-directory
ms.custom:
  - article
categories:
  - security
subject:
  - security
---

# Data encryption in Azure

Data can be categorized by its state:

- **Data at rest**. All information storage objects, containers, and types that exist statically on physical media, whether magnetic or optical disk.

- **Data in transit**. Data that is being transferred between components, locations, or programs.

In a cloud solution, a single business transaction can lead to multiple data operations where data moves from one storage medium to another. To provide complete data protection, it must be encrypted on storage volumes and while it's transferred from one point to another.

## Key points

- Use identity-based storage access controls.
- Use standard and recommended encryption algorithms.
- Use only secure hash algorithms (SHA-2 family).
- Classify your data at rest and use encryption.
- Encrypt virtual disks.
- Use an additional key encryption key (KEK) to protect your data encryption key (DEK).
- Protect data in transit through encrypted network channels (TLS/HTTPS) for all client/server communication. Use TLS 1.2 on Azure.

## Azure encryption features

Azure provides built-in features for data encryption in many layers that participate in data processing. We recommend that for each service, enable the encryption capability. The encryption is handled automatically using Azure-managed keys. This almost requires no user interaction.

We recommend implementing identity-based storage access controls. Authentication with a shared key (like a Shared Access Signature) doesn't permit the same flexibility and control as identity-based access control. The leak of a shared key might allow indefinite access to a resource, whereas a role-based access control can be identified and authenticated more strongly.

Storage in a cloud service like Azure is architected and implemented quite differently than on-premises solutions to enable massive scaling, modern access through REST APIs, and isolation between tenants.  Cloud service providers make multiple methods of access control over storage resources available. Examples include shared keys, shared signatures, anonymous access, and identity provider-based methods.

Consider some built-in features of Azure Storage:

- **Identity-based access**. Supports access through Azure Active Directory (Azure AD) and key-based authentication mechanisms, such as Symmetric Shared Key Authentication, or Shared Access Signature (SAS).
- **Built-in encryption**. All stored data is encrypted by Azure storage. Data cannot be read by a tenant if it has not been written by that tenant. This feature provides control over cross tenant data leakage.
- **Region-based controls**. Data remains only in the selected region and three synchronous copies of data are maintained within that region. Azure storage provides detailed activity logging is available on an opt-in basis.
- **Firewall features**. The firewall provides an additional layer of access control and storage threat protection to detect anomalous access and activities.

For the complete set of features, see [Azure Storage Service encryption](/azure/storage/common/storage-service-encryption).

## Suggested action

Identify provider methods of authentication and authorization that are the least likely to be compromised, and enable more fine-grained role-based access controls over storage resources.

**Learn more**

For more information, reference [Authorize access to blobs using Azure Active Directory](/azure/storage/blobs/authorize-access-azure-active-directory).

## Standard encryption algorithms

**Does the organization use industry standard encryption algorithms instead of creating their own?**
***

Organizations should not develop and maintain their own encryption algorithms. Avoid using custom encryption algorithms or direct cryptography in your workload. These methods rarely stand up to real world attacks.

Secure standards already exist on the market and should be preferred. If custom implementation is required, developers should use well-established cryptographic algorithms and secure standards. Use Advanced Encryption Standard (AES) as a symmetric block cipher, AES-128, AES-192, and AES-256 are acceptable.

Developers should use cryptography APIs built into operating systems instead of non-platform cryptography libraries. For .NET, follow the [.NET Cryptography Model](/dotnet/standard/security/cryptography-model).

We advise using standard and recommended encryption algorithms.

For more information, refer to [Choose an algorithm](/dotnet/standard/security/cryptography-model#choose-an-algorithm).

**Are modern hashing functions used?**
***
Applications should use the SHA-2 family of hash algorithms (SHA-256, SHA-384, SHA-512).

## Data at rest

All important data should be classified and encrypted with an encryption standard. Classify and protect all information storage objects. Use encryption to make sure the contents of files cannot be accessed by unauthorized users.

Data at rest is encrypted by default in Azure, but is your critical data classified and tagged, or labeled so that it can be audited?

Your most sensitive data might include business, financial, healthcare, or personal information. Discovering and classifying this data can play a pivotal role in your organization's information protection approach. It can serve as infrastructure for:

- Helping to meet standards for data privacy and requirements for regulatory compliance.
- Various security scenarios, such as monitoring (auditing) and alerting on anomalous access to sensitive data.
- Controlling access to and hardening the security of databases that contain highly sensitive data.

**Suggested action**

Classify your data. Consider using [Data Discovery & Classification](/azure/azure-sql/database/data-discovery-and-classification-overview) in Azure SQL Database.

## Data classification

A crucial initial exercise for protecting data is to organize it into categories based on certain criteria. The classification criteria can be your business needs, compliance requirements, and the type of data.

Depending on the category, you can protect it through:

- Standard encryption mechanisms.
- Enforce security governance through policies.
- Conduct audits to make sure the security measures are compliant.

One way of classifying data is through the use of tags.

**Does the organization encrypt virtual disk files for virtual machines that are associated with this workload?**
***

There are many options to store files in the cloud. Cloud-native apps typically use Azure Storage. Apps that run on VMs use them to store files. VMs use virtual disk files as virtual storage volumes and exist in a blob storage.

Consider a hybrid solution. Files can  move from on-premises to the cloud, from the cloud to on-premises, or between services hosted in the cloud. One strategy is to make sure that the files and their contents aren't accessible to unauthorized users. You can use authentication-based access controls to prevent unauthorized downloading of files. However, that is not enough. Have a backup mechanism to secure the virtual disk files in case authentication and authorization or its configuration is compromised. There are several approaches. You can encrypt the virtual disk files. If an attempt is made to mount disk files, the contents of the files cannot be accessed because of the encryption.

We recommend that you enable virtual disk encryption. For information about how to encrypt Windows VM disks, see [Quickstart: Create and encrypt a Windows VM with the Azure CLI](/azure/virtual-machines/windows/disk-encryption-cli-quickstart).

Azure-based virtual disks are stored as files in a Storage account. If no encryption is applied to a virtual disk, and an attacker manages to download a virtual disk image file, it can be mounted and inspected at the attacker's leisure as if they had physical access to the source computer. Encrypting virtual disk files helps prevent attackers from gaining access to the contents of those disk files in the event they are able to download them. Depending on the sensitivity of the information stored on the disk, unencrypted access could represent a critical risk to confidential business data (such as a SQL database) or identity (such as an AD Domain Controller).

An example of virtual disk encryption is [Azure Disk Encryption](/azure/security/fundamentals/azure-disk-encryption-vms-vmss).

Azure Disk Encryption helps protect and safeguard your data to meet your organizational security and compliance commitments. It uses the Bitlocker-feature of Windows (or DM-Crypt on Linux) to provide volume encryption for the OS and data disks of Azure virtual machines (VMs). It is integrated with Azure Key Vault to help you control and manage the disk encryption keys, and secrets.

Virtual machines use virtual disk files as storage volumes and exist in a cloud service provider's blob storage system. These files can be moved from on-premises to cloud systems, from cloud systems to on-premises, or between cloud systems. Due to the mobility of these files, it's recommended that the files and the contents are not accessible to unauthorized users.

**Does the organization use identity-based storage access controls for this workload?**
***

There are many ways to control access to data: shared keys, shared signatures, anonymous access, identity provider-based. Use Azure Active Directory (Azure AD) and role-based access control (RBAC) to grant access. For more information, see [Identity and access management considerations](design-identity.md).

**Does the organization protect keys in this workload with an additional key encryption key (KEK)?**
***

Use more than one encryption key in an encryption at rest implementation. Storing an encryption key in Azure Key Vault ensures secure key access and central management of keys.

Use an additional key encryption key (KEK) to protect your data encryption key (DEK).

**Suggested actions**

Identify unencrypted virtual machines via Microsoft Defender for Cloud or script, and encrypt via Azure Disk Encryption.  Ensure all new virtual machines are encrypted by default and regularly monitor for unprotected disks.

**Learn more**

[Azure Disk Encryption for virtual machines and virtual machine scale sets](/azure/security/fundamentals/azure-disk-encryption-vms-vmss)

## Data in transit

Data in transit should be encrypted at all points to ensure data integrity.

Protecting data in transit should be an essential part of your data protection strategy. Because data is moving back and forth from many locations, we generally recommend that you always use SSL/TLS protocols to exchange data across different locations.

For data moving between your on-premises infrastructure and Azure, consider appropriate safeguards such as HTTPS or VPN. When sending encrypted traffic between an Azure virtual network and an on-premises location over the public internet, use Azure VPN Gateway.

**Does the workload communicate over encrypted network traffic only?**
***

Any network communication between client and server where man-in-the-middle attacks can occur, must be encrypted. All website communication should use HTTPS, no matter the perceived sensitivity of transferred data. Man-in-the-middle attacks can occur anywhere on the site, not just login forms.

This mechanism can be applied to use cases such as:

- Web applications and APIs for all communication with clients.
- Data moving across a service bus from on-premises to the cloud and other way around, or during an input/output process.

In certain architecture styles such as microservices, data must be encrypted during communication between the services.

**What TLS version is used across workloads?**
***

Using the latest version of TLS is preferred. All Azure services support TLS 1.2 on public HTTPS endpoints. Migrate solutions to support TLS 1.2 and use this version by default.

When traffic from clients using older versions of TLS is minimal, or it's acceptable to fail requests made with an older version of TLS, consider enforcing a minimum TLS version. For information about TLS support in Azure Storage, see [Remediate security risks with a minimum version of TLS](/azure/storage/common/transport-layer-security-configure-minimum-version?tabs=portal#remediate-security-risks-with-a-minimum-version-of-tls).

Sometimes you need to isolate your entire communication channel between your on-premises and the cloud infrastructure by using either a virtual private network (VPN) or [ExpressRoute](/azure/expressroute/). For more information, see  these articles:

- [Extending on-premises data solutions to the cloud](../../data-guide/scenarios/hybrid-on-premises-and-cloud.md)
- [Configure a Point-to-Site VPN connection to a VNet using native Azure certificate authentication: Azure portal](/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal#architecture)

For more information, see [Protect data in transit](/azure/security/fundamentals/data-encryption-best-practices#protect-data-in-transit).

**Is there any portion of the application that doesn't secure data in transit?**
***

All data should be encrypted in transit using a common encryption standard. Determine if all components in the solution are using a consistent standard. There are times when encryption is not possible because of technical limitations, make sure the reason is clear and valid.

### Suggested actions

Identify workloads using unencrypted sessions and configure the service to require encryption.

## Learn more

- [Encrypt data in transit](./storage-data-encryption.md#encrypt-data-in-transit)
- [Azure encryption overview](/azure/security/fundamentals/encryption-overview#encryption-of-data-in-transit)

## Next steps

While it's important to protect data through encryption, it's equally important to protect they keys that provide access to the data.

> [!div class="nextstepaction"]
> [Key and secret management](design-storage-keys.md)

## Related links

Identity and access management services authenticate and grant permission to users, partners, customers, applications, services, and other entities. For security considerations, see [Azure identity and access management considerations](design-identity.md).

> [Back to the main article: Data protection](design-storage.md)
