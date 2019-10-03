---
title: App Design
description: 
author: david-stanford
ms.date: 2019-10-03
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How have you ensured that your application is resilient to failures? 
---

# App Design

<!-- Retry and Circuit Breaker patterns are used -->
[!include(xref:52f1a917-f368-439a-98f9-0262a25de762)]

<!-- Third-party services have documented SLAs and support information -->
[!include(xref:32696b2a-af6d-4c34-8301-aa4a420ecda1)]

<!-- Third-party services are monitored -->
[!include(xref:5a3257b3-1668-4edf-949c-717de2efc1bb)]

<!-- Health probes/checks are implemented for load balancers (LB) and application gateways (AGW) -->
[!include(xref:b58e95eb-a88b-469c-9842-9adf4f2b56ed)]

<!-- Storage is replicated locally utilizing RAID or equivialnt technologies to protect against disk failure -->
[!include(xref:5d3517be-f6f3-4c0c-8f0d-bc534d0c509a)]

<!-- Load balancing is implemented -->
[!include(xref:cb5b6fb3-ef56-490c-b8a9-42d66b71f1b9)]

<!-- Throttling is implemented -->
[!include(xref:ebd007eb-55b7-4189-af5a-388cf30e318f)]

<!-- Message brokers are utilized -->
[!include(xref:ea92ec48-0524-41e1-ae33-f0b7fd901059)]

<!-- Each application component has an SLA defined -->
[!include(xref:46c01ec1-43ae-424b-9ef7-f328cea862fa)]

<!-- Multiple instances of the app & database are running -->
[!include(xref:38d1d690-c16a-4343-8147-f24a5b3df0d5)]

<!-- Performed a failure mode analysis of the application. -->
[!include(xref:6cbc14af-ed03-4ad4-929e-1b4905c2cdbc)]

<!-- Availability Sets are used for each application tier -->
[!include(xref:8ad5e66c-bdc0-40ef-93cb-bcb5787fff8c)]

<!-- VMs are replicated using Azure Site Recovery -->
[!include(xref:4fc5dd89-3067-49ed-a65a-42d4f9182964)]

<!-- Deployed the application across multiple regions -->
[!include(xref:61c17190-428b-47ca-b09f-68daca74faf2)]

<!-- Health probes are configured and tested for load balancers and traffic managers -->
[!include(xref:808d565e-331d-44e5-866d-eb563f89c575)]

