---
title: Data encryption in Azure
description: Protect data in transit and at rest through encryption in Azure.
author: PageWriter-MSFT
ms.date: 12/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-storage
  - azure-active-directory
ms.custom:
  - article
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

For example, consider some built-in features of Azure Storage. 

- **Identity-based access**. Supports access through Azure Active Directory (Azure AD) and key-based authentication mechanisms, such as Symmetric Shared Key Authentication, or Shared Access Signature (SAS).  
- **Built-in encryption**. All stored data is encrypted by Azure storage. Data cannot be read by a tenant if it has not been written by that tenant. This feature provides control over cross tenant data leakage. 
- **Region-based controls**. Data remains only in the selected region and three synchronous copies of data are maintained within that region. Azure storage provides detailed activity logging is available on an opt-in basis. 
- **Firewall features**. The firewall provides an additional layer of access control and storage threat protection to detect anomalous access and activities. 

For the complete set of features, see [Azure Storage Service encryption](/azure/storage/common/storage-service-encryption).

## Standard encryption algorithms

**Does the organization use industry standard encryption algorithms instead of creating their own?**
***

Avoid using custom encryption algorithms or direct cryptography in your workload. These methods rarely stand up to real world attacks. If custom implementation is required, developers should use well-established cryptographic algorithms and secure standards. Use Advanced Encryption Standard (AES) as a symmetric block cipher, AES-128, AES-192, and AES-256 are acceptable. 

Developers should use cryptography APIs built into operating systems instead of non-platform cryptography libraries. For .NET, follow the [.NET Cryptography Model](/dotnet/standard/security/cryptography-model).

**Are modern hashing functions used?**
***
Applications should use the SHA-2 family of hash algorithms (SHA-256, SHA-384, SHA-512).

## Data at rest
Classify and protect all information storage objects. Use encryption to make sure the contents of file cannot be accessed by unauthorized users.

### Data classification
A crucial and an initial exercise for protecting data is to organize it into categories based on certain criteria. The classification criteria can be your business needs, compliance requirements, and the type of data. 

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

An example of virtual disk encryption is [Azure Disk Encryption](/azure/security/fundamentals/azure-disk-encryption-vms-vmss).

**Does the organization use identity-based storage access controls for this workload?**
***

There are many ways to control access to data: shared keys, shared signatures, anonymous access, identity provider-based. Use Azure Active Directory (Azure AD) and role-based access control (RBAC) to grant access. For more information, see [Identity and access management considerations](design-identity.md).

**Does the organization protect keys in this workload with an additional key encryption key (KEK)?**
***

Use more than one encryption key in an encryption at rest implementation. Storing an encryption key in Azure Key Vault ensures secure key access and central management of keys.

Use an additional key encryption key (KEK) to protect your data encryption key (DEK).


## Data in transit

Data in transit should be encrypted at all points to ensure data integrity. 

**Does the workload communicate over encrypted network traffic only?**
***

Any network communication between client and server where man-in-the-middle attack can occur, must be encrypted. All website communication should use HTTPS, no matter the perceived sensitivity of transferred data. Man-in-the-middle attacks can occur anywhere on the site, not just login forms.

This mechanism can be applied to use cases such as:
- Web applications and APIs for all communication with clients. 
- Data moving across a service bus from on-premises to the cloud and other way around, or during an input/output process.

In certain architecture styles such as microservices, data must be encrypted during communication between the services. 

**What TLS version is used across workloads?**
***

Using the latest version of TLS is preferred. All Azure services support TLS 1.2 on public HTTPS endpoints. Migrate solutions to support TLS 1.2 and use this version by default.

When traffic from clients using older versions of TLS is minimal, or it's acceptable to fail requests made with an older version of TLS, consider enforcing a minimum TLS version. For information about TLS support in Azure Storage, see [Remediate security risks with a minimum version of TLS](/azure/storage/common/transport-layer-security-configure-minimum-version?tabs=portal#remediate-security-risks-with-a-minimum-version-of-tls).

Sometimes you need to isolate your entire communication channel between your on-premises and the cloud
infrastructure by using either a virtual private network (VPN) or [ExpressRoute](/azure/expressroute/). For more information, see  these articles: 

- [Extending on-premises data solutions to the cloud](../../data-guide/scenarios/hybrid-on-premises-and-cloud.md)
- [Configure a Point-to-Site VPN connection to a VNet using native Azure certificate authentication: Azure portal](/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal#architecture)

For more information, see [Protect data in transit](/azure/security/fundamentals/data-encryption-best-practices#protect-data-in-transit).

**Is there any portion of the application that doesn't secure data in transit?**
***

All data should be encrypted in transit using a common encryption standard. Determine if all components in the solution are using a consistent standard. There are times when encryption is not possible because of technical limitations, make sure the reason is clear and valid.


## Next steps
While it's important to protect data through encryption, it's equally important to protect they keys that provide access to the data. 

> [!div class="nextstepaction"]
> [Key and secret management](design-storage-keys.md)

## Related links
Identity and access management services authenticate and grant permission to users, partners, customers, applications, services, and other entities. For security considerations, see [Azure identity and access management considerations](design-identity.md).

> [Back to the main article: Data protection](design-storage.md)
