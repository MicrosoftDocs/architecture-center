---
title: Management and Monitoring patterns
titleSuffix: Cloud Design Patterns
description: Cloud applications run in a remote datacenter where you do not have full control of the infrastructure or, in some cases, the operating system. This can make management and monitoring more difficult than an on-premises deployment. Applications must expose runtime information that administrators and operators can use to manage and monitor the system, as well as supporting changing business requirements and customization without requiring the application to be stopped or redeployed.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Management and Monitoring patterns

Cloud applications run in a remote datacenter where you do not have full control of the infrastructure or, in some cases, the operating system. This can make management and monitoring more difficult than an on-premises deployment. Applications must expose runtime information that administrators and operators can use to manage and monitor the system, as well as supporting changing business requirements and customization without requiring the application to be stopped or redeployed.

|                              Pattern                               |                                                              Summary                                                              |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
|                   [Ambassador](../ambassador.md)                   |                 Create helper services that send network requests on behalf of a consumer service or application.                 |
|        [Anti-Corruption Layer](../anti-corruption-layer.md)        |                       Implement a façade or adapter layer between a modern application and a legacy system.                       |
| [External Configuration Store](../external-configuration-store.md) |                Move configuration information out of the application deployment package to a centralized location.                |
|          [Gateway Aggregation](../gateway-aggregation.md)          |                          Use a gateway to aggregate multiple individual requests into a single request.                           |
|           [Gateway Offloading](../gateway-offloading.md)           |                              Offload shared or specialized service functionality to a gateway proxy.                              |
|              [Gateway Routing](../gateway-routing.md)              |                                   Route requests to multiple services using a single endpoint.                                    |
|   [Health Endpoint Monitoring](../health-endpoint-monitoring.md)   |   Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals.    |
|                      [Sidecar](../sidecar.md)                      |         Deploy components of an application into a separate process or container to provide isolation and encapsulation.          |
|                    [Strangler](../strangler.md)                    | Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services. |
