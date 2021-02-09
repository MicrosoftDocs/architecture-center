---
title: Operational Excellence patterns
titleSuffix: Cloud Design Patterns
description: Use these management and monitoring patterns to support cloud applications, which offer special challenges because the applications run in a remote datacenter.
author: dragon119
ms.date: 06/23/2017
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - seodec18
  - design-pattern
keywords: design pattern
---

# Operational Excellence patterns

Cloud applications run in a remote datacenter where you do not have full control of the infrastructure or, in some cases, the operating system. This can make management and monitoring more difficult than an on-premises deployment. Applications must expose runtime information that administrators and operators can use to manage and monitor the system, as well as supporting changing business requirements and customization without requiring the application to be stopped or redeployed.

|                              Pattern                               |                                                              Summary                                                              |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
|                   [Ambassador](https://docs.microsoft.com/azure/architecture/patterns/ambassador)                   |                 Create helper services that send network requests on behalf of a consumer service or application.                 |
|        [Anti-Corruption Layer](https://docs.microsoft.com/azure/architecture/patterns/anti-corruption-layer)        |                       Implement a façade or adapter layer between a modern application and a legacy system.                       |
| [External Configuration Store](https://docs.microsoft.com/azure/architecture/patterns/external-configuration-store) |                Move configuration information out of the application deployment package to a centralized location.                |
|          [Gateway Aggregation](https://docs.microsoft.com/azure/architecture/patterns/gateway-aggregation)          |                          Use a gateway to aggregate multiple individual requests into a single request.                           |
|           [Gateway Offloading](https://docs.microsoft.com/azure/architecture/patterns/gateway-offloading)           |                              Offload shared or specialized service functionality to a gateway proxy.                              |
|              [Gateway Routing](https://docs.microsoft.com/azure/architecture/patterns/gateway-routing)              |                                   Route requests to multiple services using a single endpoint.                                    |
|   [Health Endpoint Monitoring](https://docs.microsoft.com/azure/architecture/patterns/health-endpoint-monitoring)   |   Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals.    |
|                      [Sidecar](https://docs.microsoft.com/azure/architecture/patterns/sidecar)                      |         Deploy components of an application into a separate process or container to provide isolation and encapsulation.          |
|                    [Strangler](https://docs.microsoft.com/azure/architecture/patterns/strangler)                    | Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services. |
