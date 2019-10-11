---
title: App Design
description: 
author: david-stanford
ms.date: 10/11/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How have you ensured that your application is resilient to failures? 
---

# App Design

<!-- Retry and Circuit Breaker patterns are used -->
[!include[52f1a917-f368-439a-98f9-0262a25de762](../../../includes/aar_guidance/52f1a917-f368-439a-98f9-0262a25de762.md)]

<!-- Third-party services have documented SLAs and support information -->
[!include[32696b2a-af6d-4c34-8301-aa4a420ecda1](../../../includes/aar_guidance/32696b2a-af6d-4c34-8301-aa4a420ecda1.md)]

<!-- Third-party services are monitored -->
[!include[5a3257b3-1668-4edf-949c-717de2efc1bb](../../../includes/aar_guidance/5a3257b3-1668-4edf-949c-717de2efc1bb.md)]

<!-- Health probes/checks are implemented for load balancers (LB) and application gateways (AGW) -->
[!include[b58e95eb-a88b-469c-9842-9adf4f2b56ed](../../../includes/aar_guidance/b58e95eb-a88b-469c-9842-9adf4f2b56ed.md)]

<!-- Storage is replicated locally utilizing RAID or equivialnt technologies to protect against disk failure -->
[!include[5d3517be-f6f3-4c0c-8f0d-bc534d0c509a](../../../includes/aar_guidance/5d3517be-f6f3-4c0c-8f0d-bc534d0c509a.md)]

<!-- Load balancing is implemented -->
[!include[cb5b6fb3-ef56-490c-b8a9-42d66b71f1b9](../../../includes/aar_guidance/cb5b6fb3-ef56-490c-b8a9-42d66b71f1b9.md)]

<!-- Throttling is implemented -->
[!include[ebd007eb-55b7-4189-af5a-388cf30e318f](../../../includes/aar_guidance/ebd007eb-55b7-4189-af5a-388cf30e318f.md)]

<!-- Message brokers are utilized -->
[!include[ea92ec48-0524-41e1-ae33-f0b7fd901059](../../../includes/aar_guidance/ea92ec48-0524-41e1-ae33-f0b7fd901059.md)]

<!-- Each application component has an SLA defined -->
[!include[46c01ec1-43ae-424b-9ef7-f328cea862fa](../../../includes/aar_guidance/46c01ec1-43ae-424b-9ef7-f328cea862fa.md)]

<!-- Multiple instances of the app & database are running -->
[!include[38d1d690-c16a-4343-8147-f24a5b3df0d5](../../../includes/aar_guidance/38d1d690-c16a-4343-8147-f24a5b3df0d5.md)]

<!-- Performed a failure mode analysis of the application. -->
[!include[6cbc14af-ed03-4ad4-929e-1b4905c2cdbc](../../../includes/aar_guidance/6cbc14af-ed03-4ad4-929e-1b4905c2cdbc.md)]

<!-- Availability Sets are used for each application tier -->
[!include[8ad5e66c-bdc0-40ef-93cb-bcb5787fff8c](../../../includes/aar_guidance/8ad5e66c-bdc0-40ef-93cb-bcb5787fff8c.md)]

<!-- VMs are replicated -->
[!include[4fc5dd89-3067-49ed-a65a-42d4f9182964](../../../includes/aar_guidance/4fc5dd89-3067-49ed-a65a-42d4f9182964.md)]

<!-- Deployed the application across multiple regions -->
[!include[61c17190-428b-47ca-b09f-68daca74faf2](../../../includes/aar_guidance/61c17190-428b-47ca-b09f-68daca74faf2.md)]

