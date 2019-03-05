---
title: Resiliency patterns
titleSuffix: Cloud Design Patterns
description: Resiliency is the ability of a system to gracefully handle and recover from failures. The nature of cloud hosting, where applications are often multi-tenant, use shared platform services, compete for resources and bandwidth, communicate over the Internet, and run on commodity hardware means there is an increased likelihood that both transient and more permanent faults will arise. Detecting failures, and recovering quickly and efficiently, is necessary to maintain resiliency.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Resiliency patterns

Resiliency is the ability of a system to gracefully handle and recover from failures. The nature of cloud hosting, where applications are often multi-tenant, use shared platform services, compete for resources and bandwidth, communicate over the Internet, and run on commodity hardware means there is an increased likelihood that both transient and more permanent faults will arise. Detecting failures, and recovering quickly and efficiently, is necessary to maintain resiliency.

|                            Pattern                             |                                                                                                      Summary                                                                                                       |
|----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                   [Bulkhead](../bulkhead.md)                   |                                                     Isolate elements of an application into pools so that if one fails, the others will continue to function.                                                      |
|            [Circuit Breaker](../circuit-breaker.md)            |                                                  Handle faults that might take a variable amount of time to fix when connecting to a remote service or resource.                                                   |
|   [Compensating Transaction](../compensating-transaction.md)   |                                                      Undo the work performed by a series of steps, which together define an eventually consistent operation.                                                       |
| [Health Endpoint Monitoring](../health-endpoint-monitoring.md) |                                            Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals.                                            |
|            [Leader Election](../leader-election.md)            | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. |
|  [Queue-Based Load Leveling](../queue-based-load-leveling.md)  |                                            Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.                                             |
|                      [Retry](../retry.md)                      |             Enable an application to handle anticipated, temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that's previously failed.             |
| [Scheduler Agent Supervisor](../scheduler-agent-supervisor.md) |                                                            Coordinate a set of actions across a distributed set of services and other remote resources.                                                            |