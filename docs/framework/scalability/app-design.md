---
title: App Design
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you designing your applications to scale? 
---

# App Design

Application design is critical to handling scale as load increases<!-- Chose the right data store to match usage -->
[!include[f4fea556-8c81-4e49-9715-39a7f8fcfca8](../../../includes/aar_guidance/f4fea556-8c81-4e49-9715-39a7f8fcfca8.md)]

<!-- Using dynamic service discovery for micro-services applications -->
[!include[2284ac26-7be3-458a-bb96-d8c4695f5a02](../../../includes/aar_guidance/2284ac26-7be3-458a-bb96-d8c4695f5a02.md)]

<!-- Utilize connection pooling -->
[!include[fe142e43-c782-467a-af9a-b84262f65ef3](../../../includes/aar_guidance/fe142e43-c782-467a-af9a-b84262f65ef3.md)]

<!-- Compress data when appropriate -->
[!include[35e74034-cf86-4c27-9cfe-8b3c20ce9bbf](../../../includes/aar_guidance/35e74034-cf86-4c27-9cfe-8b3c20ce9bbf.md)]

<!-- Use locking to ensure consistancy -->
[!include[8e3058be-8434-46f9-b6db-de41c8e69d75](../../../includes/aar_guidance/8e3058be-8434-46f9-b6db-de41c8e69d75.md)]

<!-- Use async calls and waits to prevent locks -->
[!include[59218e34-f303-4b96-80b0-f2432dba7317](../../../includes/aar_guidance/59218e34-f303-4b96-80b0-f2432dba7317.md)]

<!-- Utilize Microservices -->
[!include[1a6f861d-df86-4b8b-86bd-7846f639346d](../../../includes/aar_guidance/1a6f861d-df86-4b8b-86bd-7846f639346d.md)]

<!-- Using queues -->
[!include[f5b436a2-aad6-43b7-9d6e-563713263d7d](../../../includes/aar_guidance/f5b436a2-aad6-43b7-9d6e-563713263d7d.md)]

<!-- Avoid sticky sessions and client affinity -->
[!include[48e520f4-3ae0-4185-8e61-0b194cab0f9e](../../../includes/aar_guidance/48e520f4-3ae0-4185-8e61-0b194cab0f9e.md)]

<!-- Automatically scale when load increses -->
[!include[dfe40589-8d10-40c4-85cd-e15ab0ce3b19](../../../includes/aar_guidance/dfe40589-8d10-40c4-85cd-e15ab0ce3b19.md)]

<!-- Utilize background jobs -->
[!include[1fadc07b-c206-4e16-bf2c-67aa3c5bec6a](../../../includes/aar_guidance/1fadc07b-c206-4e16-bf2c-67aa3c5bec6a.md)]

