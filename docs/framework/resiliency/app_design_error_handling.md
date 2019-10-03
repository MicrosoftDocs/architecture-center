---
title: App Design - Error Handling
description: 
author: david-stanford
ms.date: 2019-10-03
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing errors & failures? 
---

# App Design - Error Handling

<!-- Retries for transient errors are impelmented and logged -->
[!include(xref:3128430d-7c25-49da-97eb-643d29f1149c)]

<!-- Request timeouts are configured -->
[!include(xref:5c44424c-38f4-45a8-8d38-57cb34869f29)]

<!-- Implemented the "Circuit Breaker" pattern to prevent cascading failures -->
[!include(xref:2d348cc5-c6e0-4f9d-a29a-827f57527e5f)]

<!-- Application components are split with seperate health probes -->
[!include(xref:309f1127-3a9e-4876-b5dd-91bade63f789)]

<!-- Command and Query Responsibility Segregation (CQRS) is implemented on data stores -->
[!include(xref:c9dbb912-a194-4b28-9f04-1ebb17eb711c)]

