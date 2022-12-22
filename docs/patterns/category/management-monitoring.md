---
title: Management and Monitoring patterns
titleSuffix: Cloud Design Patterns
description: Use these management and monitoring patterns to support cloud applications, which offer special challenges because the applications run in a remote datacenter.
author: martinekuan
ms.author: architectures
ms.date: 07/28/2022
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: design-pattern
ms.custom:
  - design-pattern
keywords:
  - design pattern
products: azure
categories: featured
---

# Management and Monitoring patterns

Cloud applications run in a remote datacenter where you do not have full control of the infrastructure or, in some cases, the operating system. This can make management and monitoring more difficult than an on-premises deployment. Applications must expose runtime information that administrators and operators can use to manage and monitor the system, as well as supporting changing business requirements and customization without requiring the application to be stopped or redeployed.

|                              Pattern                               |                                                              Summary                                                              |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
|                   [Ambassador](../ambassador.yml)                   |                 Create helper services that send network requests on behalf of a consumer service or application.                 |
|        [Anti-Corruption Layer](../anti-corruption-layer.yml)        |                       Implement a façade or adapter layer between a modern application and a legacy system.                       |
| [External Configuration Store](../external-configuration-store.yml) |                Move configuration information out of the application deployment package to a centralized location.                |
|          [Gateway Aggregation](../gateway-aggregation.yml)          |                          Use a gateway to aggregate multiple individual requests into a single request.                           |
|           [Gateway Offloading](../gateway-offloading.yml)           |                              Offload shared or specialized service functionality to a gateway proxy.                              |
|              [Gateway Routing](../gateway-routing.yml)              |                                   Route requests to multiple services using a single endpoint.                                    |
|   [Health Endpoint Monitoring](../health-endpoint-monitoring.yml)   |   Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals.    |
|                      [Sidecar](../sidecar.yml)                      |         Deploy components of an application into a separate process or container to provide isolation and encapsulation.          |
|                    [Strangler Fig](../strangler-fig.yml)                    | Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services. |
