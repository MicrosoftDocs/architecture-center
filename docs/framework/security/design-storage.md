---
title: Security storage in Azure | Microsoft Docs
description: Secure data storage in Azure
author: v-aangie
ms.date: 09/17/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Storage

Protecting data at rest is required to maintain confidentiality, integrity, and availability assurances across all workloads. Storage in a cloud service like Azure is [architected and implemented](https://azure.microsoft.com/blog/sosp-paper-windows-azure-storage-a-highly-available-cloud-storage-service-with-strong-consistency/) quite differently than on premises solutions to enable massive scaling, modern
access through REST APIs, and isolation between tenants.

Granting access to Azure storage is possible through Azure Active Directory (Azure AD) as well as key based authentication mechanisms (Symmetric Shared Key Authentication, or Shared Access Signature (SAS)).

Storage in Azure includes a number of native security design attributes:

- All data is encrypted by the service.

- Data in the storage system cannot be read by a tenant if it has not been
    written by that tenant (to mitigate the risk of cross tenant data leakage).

- Data will remain only in the region you choose.

- The system maintains three synchronous copies of data in the region you choose.

- Detailed activity logging is available on an opt-in basis.

Additional security features can be configured such as a storage firewall to provide an additional layer of access control as well as storage threat protection to detect anomalous access and activities.
