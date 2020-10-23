---
title: Availability patterns
titleSuffix: Cloud Design Patterns
description: Learn about availability, which is measured as a percentage of uptime and defines the proportion of time that a system is functional and working.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Availability patterns

Availability is measured as a percentage of uptime, and defines the proportion of time that a system is functional and working. Availability is affected by system errors, infrastructure problems, malicious attacks, and system load. Cloud applications typically provide users with a service level agreement (SLA), which means that applications must be designed and implemented to maximize availability.

|                            Pattern                             |                                                           Summary                                                            |
|----------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
|           [Deployment Stamps](../deployment-stamp.md)          |                 Deploy multiple independent copies of application components, including data stores.                         |
| [Geodes](../geodes.md) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. |
| [Health Endpoint Monitoring](../health-endpoint-monitoring.md) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. |
|  [Queue-Based Load Leveling](../queue-based-load-leveling.md)  | Use a queue that acts as a buffer between a task and a service that it invokes, to smooth intermittent heavy loads.  |
|                 [Throttling](../throttling.md)                 |   Control the consumption of resources by an instance of an application, an individual tenant, or an entire service.    |

To mitigate against availability risks from malicious Distributed Denial of Service (DDoS) attacks, implement the native [Azure DDoS protection standard](/azure/virtual-network/ddos-protection-overview) service or a 3rd party capability.
