---
title: encryption
description: Describes considerations to make when encrypting your workload
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing encryption for this workload? 
---

# encryption

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
implement (near zero overhead).<!-- You have enabled platform encryption services -->
[!include[3b071bca-019b-44e6-a9d4-0ad6b6efd682](../../../includes/aar_guidance/3b071bca-019b-44e6-a9d4-0ad6b6efd682.md)]

<!-- Key management strategy -->
[!include[5ecb1483-b8a4-49ae-8db6-320ca944d571](../../../includes/aar_guidance/5ecb1483-b8a4-49ae-8db6-320ca944d571.md)]

<!-- Encryption policy -->
[!include[8f600cf8-2b7f-453d-b4d9-26a427ec74b1](../../../includes/aar_guidance/8f600cf8-2b7f-453d-b4d9-26a427ec74b1.md)]

<!-- Data at rest -->
[!include[f814cf06-a764-4af1-a84c-0cb920b933f5](../../../includes/aar_guidance/f814cf06-a764-4af1-a84c-0cb920b933f5.md)]

<!-- Data in transit -->
[!include[a1583f13-8bec-45fe-a42e-d0d481ec85f6](../../../includes/aar_guidance/a1583f13-8bec-45fe-a42e-d0d481ec85f6.md)]

<!-- Appropriate encryption algorithms -->
[!include[ce3d8eed-fddd-4e82-bd4b-5665d7ddf68d](../../../includes/aar_guidance/ce3d8eed-fddd-4e82-bd4b-5665d7ddf68d.md)]

<!-- File level encryption -->
[!include[e8a807d0-59d9-46ba-9884-e51355196d25](../../../includes/aar_guidance/e8a807d0-59d9-46ba-9884-e51355196d25.md)]

<!-- You encrypt your virtual disk files. -->
[!include[e0dc5c60-d25f-4199-b991-3d241f99ea2b](../../../includes/aar_guidance/e0dc5c60-d25f-4199-b991-3d241f99ea2b.md)]

