---
title: Availability patterns
description: Availability defines the proportion of time that the system is functional and working. It will be affected by system errors, infrastructure problems, malicious attacks, and system load. It is usually measured as a percentage of uptime. Cloud applications typically provide users with a service level agreement (SLA), which means that applications must be designed and implemented in a way that maximizes availability.
keywords: design pattern
author: dragon119
ms.author: pnp
ms.date: 03/24/2017
ms.topic: article
ms.service: guidance

pnp.series.title: Cloud Design Patterns
---

# Availability patterns

[!INCLUDE [header](../../_includes/header.md)]

Availability defines the proportion of time that the system is functional and working. It will be affected by system errors, infrastructure problems, malicious attacks, and system load. It is usually measured as a percentage of uptime. Cloud applications typically provide users with a service level agreement (SLA), which means that applications must be designed and implemented in a way that maximizes availability.

| Pattern | Summary |
| ------- | ------- |
| [Health Endpoint Monitoring](../health-endpoint-monitoring.md) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. |
| [Queue-Based Load Leveling](../queue-based-load-leveling.md) | Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads. |
| [Throttling](../throttling.md) | Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service. |