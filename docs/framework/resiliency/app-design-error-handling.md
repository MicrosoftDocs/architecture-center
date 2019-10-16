---
title: App Design - Error Handling
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing errors & failures? 
---

# App Design - Error Handling

Ensuring your application can recover from errors is critical when working in a distributed system<!-- Retries for transient errors are impelmented and logged -->
[!include[3128430d-7c25-49da-97eb-643d29f1149c](../../../includes/aar_guidance/3128430d-7c25-49da-97eb-643d29f1149c.md)]

<!-- Request timeouts are configured -->
[!include[5c44424c-38f4-45a8-8d38-57cb34869f29](../../../includes/aar_guidance/5c44424c-38f4-45a8-8d38-57cb34869f29.md)]

<!-- Implemented the "Circuit Breaker" pattern to prevent cascading failures -->
[!include[2d348cc5-c6e0-4f9d-a29a-827f57527e5f](../../../includes/aar_guidance/2d348cc5-c6e0-4f9d-a29a-827f57527e5f.md)]

<!-- Application components are split with seperate health probes -->
[!include[309f1127-3a9e-4876-b5dd-91bade63f789](../../../includes/aar_guidance/309f1127-3a9e-4876-b5dd-91bade63f789.md)]

<!-- Command and Query Responsibility Segregation (CQRS) is implemented on data stores -->
[!include[c9dbb912-a194-4b28-9f04-1ebb17eb711c](../../../includes/aar_guidance/c9dbb912-a194-4b28-9f04-1ebb17eb711c.md)]

