---
title: Storage, data, and encryption in Azure | Microsoft Docs
description: How to secure data storage in Azure 
author: dsk-2015
ms.date: 07/03/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
---

# Storage, data, and encryption


Protecting data at rest is required to maintain confidentiality, integrity, and
availability assurances across all workloads. Storage in a cloud service like
Azure is [architected and
implemented](https://azure.microsoft.com/blog/sosp-paper-windows-azure-storage-a-highly-available-cloud-storage-service-with-strong-consistency/)
quite differently than on premises solutions to enable massive scaling, modern
access through REST APIs, and isolation between tenants.

Granting access to Azure storage is possible through Azure Active Directory
(Azure AD) as well as key based authentication mechanisms (Symmetric Shared Key
Authentication, or Shared Access Signature (SAS))

Storage in Azure includes a number of native security design attributes

-   All data is encrypted by the service

-   Data in the storage system cannot be read by a tenant if it has not been
    written by that tenant (to mitigate the risk of cross tenant data leakage)

-   Data will remain only in the region you choose

-   The system maintains three synchronous copies of data in the region you choose.

-   Detailed activity logging is available on an opt-in basis.

Additional security features can be configured such as a storage firewall to
provide an additional layer of access control as well as storage threat
protection to detect anomalous access and activities.

Encryption is a powerful tool for security, but it's critical to understand its
limits in protecting data. Much like a safe, encryption restricts access to only
those with possession of a small item (a mathematical key). While it's easier to
protect possession of keys than larger datasets, it is imperative that you
provide the appropriate protections for the keys. Protecting cryptographic keys
is not a natural intuitive human process (especially because electronic data
like keys can be copied perfectly without a forensic evidence trail), so it is
often overlooked or implemented poorly.

While encryption is available in many layers in Azure (and often on by default),
we have identified the layers that are most important to implement (high
potential for data to move to another storage medium) and are easiest to
implement (near zero overhead).

## Use Identity based storage access controls

Cloud service providers make multiple methods of access control over storage
resources available. Examples include shared keys, shared signatures, anonymous
access, and identity provider-based methods.

Identify provider methods of authentication and authorization are the least
liable to compromise and enable more fine-grained role-based access controls
over storage resources.

We recommend that you use an identity-based option for storage access control.

An example of this is [Azure Active Directory Authentication to Azure blob and queue services](https://docs.microsoft.com/rest/api/storageservices/authenticate-with-azure-active-directory).

## Encrypt virtual disk files

Virtual machines use virtual disk files as virtual storage volumes and exist in
a cloud service provider’s blob storage system. These files can be moved from
on-premises to cloud systems, from cloud systems to on-premises, or between
cloud systems. Due to the mobility of these files, you need to make sure the
files and their contents are not accessible to unauthorized users.

Authentication-based access controls should be in place to prevent potential
attackers from downloading the files to their own systems. In the event of a
flaw in the authentication and authorization system or its configuration, you
want to have a backup mechanism to secure the virtual disk files.

You can encrypt the virtual disk files to help prevent attackers from gaining
access to the contents of the disk files in the event that an attacker is able
to download the files. When attackers attempt to mount an encrypted disk file,
they will not be able to because of the encryption.

We recommend that you enable virtual disk encryption.

An example of virtual disk encryption is [Azure Disk
Encryption](https://docs.microsoft.com/azure/security/fundamentals/azure-disk-encryption-vms-vmss).

## Enable platform encryption services

All public cloud service providers enable encryption that is done automatically
using provider-managed keys on their platform. In many cases, this is done for
the customer and no user interaction is required. In other cases, the provider
makes this an option that the customer can choose to use or not to use.

There is almost no overhead in enabling this type of encryption as it’s managed
by the cloud service provider.

We recommend that for each service that supports service provider encryption
that you enable that option.

An example of service-specific service provider encryption is [Azure Storage Service encryption](https://docs.microsoft.com/azure/storage/common/storage-service-encryption).