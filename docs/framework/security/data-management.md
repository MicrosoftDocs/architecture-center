---
title: data management
description: Describes security considerations to take into account for the management of the data in your workload.
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you securely managing your data for this workload? 
---

# data management

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
protection to detect anomalous access and activities.<!-- You use identity based storage access controls -->
[!include[8b505a34-2978-44bc-9feb-4baf39533635](../../../includes/aar_guidance/8b505a34-2978-44bc-9feb-4baf39533635.md)]

<!-- Database access -->
[!include[3d7dd02d-9fc6-4db0-8c04-72b060705e23](../../../includes/aar_guidance/3d7dd02d-9fc6-4db0-8c04-72b060705e23.md)]

<!-- Database authentication -->
[!include[7f84b699-dc51-44d7-b5c2-f7a3f25f35d3](../../../includes/aar_guidance/7f84b699-dc51-44d7-b5c2-f7a3f25f35d3.md)]

<!-- Database auditing -->
[!include[ddb71284-9a19-406b-8ab4-3473e4d71357](../../../includes/aar_guidance/ddb71284-9a19-406b-8ab4-3473e4d71357.md)]

