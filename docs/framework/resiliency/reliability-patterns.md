---
title: Reliability patterns
titleSuffix: Cloud Design Patterns
description: Learn about availability, high availability, and resiliency as factors that are related to reliability patterns.
author: v-aangie
ms.date: 12/08/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - design-pattern
keywords:
  - design pattern
---

# Reliability patterns

## Availability

Availability is measured as a percentage of uptime, and defines the proportion of time that a system is functional and working. Availability is affected by system errors, infrastructure problems, malicious attacks, and system load. Cloud applications typically provide users with a service level agreement (SLA), which means that applications must be designed and implemented to maximize availability.

|                            Pattern                             |                                                           Summary                                                            |
|----------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
|           [Deployment Stamps](../../patterns/deployment-stamp.md)          |                 Deploy multiple independent copies of application components, including data stores.                         |
| [Geodes](../../patterns/geodes.md) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. |
| [Health Endpoint Monitoring](../../patterns/health-endpoint-monitoring.md) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. |
|  [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling.md)  | Use a queue that acts as a buffer between a task and a service that it invokes, to smooth intermittent heavy loads.  |
|                 [Throttling](../../patterns/throttling.md)                 |   Control the consumption of resources by an instance of an application, an individual tenant, or an entire service.    |

To mitigate against availability risks from malicious Distributed Denial of Service (DDoS) attacks, implement the native [Azure DDoS protection standard](/azure/virtual-network/ddos-protection-overview) service or a third party capability.

## High availability

Azure infrastructure is composed of geographies, regions, and Availability Zones, which limit the blast radius of a failure and therefore limit potential impact to customer applications and data. The Azure Availability Zones construct was developed to provide a software and networking solution to protect against datacenter failures and to provide increased high availability (HA) to our customers. With HA architecture there is a balance between high resilience, low latency, and cost.

| Pattern | Summary |
|--|--|
| [Deployment Stamps](../../patterns/deployment-stamp.md) | Deploy multiple independent copies of application components, including data stores. |
| [Geodes](../../patterns/geodes.md) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. |
| [Health Endpoint Monitoring](../../patterns/health-endpoint-monitoring.md) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. |
| [Bulkhead](../../patterns/bulkhead.md) | Isolate elements of an application into pools so that if one fails, the others will continue to function. |
| [Circuit Breaker](../../patterns/circuit-breaker.md) | Handle faults that might take a variable amount of time to fix when connecting to a remote service or resource. |

## Resiliency

Resiliency is the ability of a system to gracefully handle and recover from failures, both inadvertent and malicious.

The nature of cloud hosting, where applications are often multi-tenant, use shared platform services, compete for resources and bandwidth, communicate over the Internet, and run on commodity hardware means there is an increased likelihood that both transient and more permanent faults will arise. The connected nature of the internet and the rise in sophistication and volume of attacks increase the likelihood of a security disruption.

Detecting failures and recovering quickly and efficiently, is necessary to maintain resiliency.

|                            Pattern                             |                                                                                                      Summary                                                                                                       |
|----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                   [Bulkhead](../../patterns/bulkhead.md)                   |                                                     Isolate elements of an application into pools so that if one fails, the others will continue to function.                                                      |
|            [Circuit Breaker](../../patterns/circuit-breaker.md)            |                                                  Handle faults that might take a variable amount of time to fix when connecting to a remote service or resource.                                                   |
|   [Compensating Transaction](../../patterns/compensating-transaction.md)   |                                                      Undo the work performed by a series of steps, which together define an eventually consistent operation.                                                       |
| [Health Endpoint Monitoring](../../patterns/health-endpoint-monitoring.md) |                                            Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals.                                            |
|            [Leader Election](../../patterns/leader-election.md)            | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. |
|  [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling.md)  |                                            Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.                                             |
|                      [Retry](../../patterns/retry.md)                      |             Enable an application to handle anticipated, temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that's previously failed.             |
| [Scheduler Agent Supervisor](../../patterns/scheduler-agent-supervisor.md) |                                                            Coordinate a set of actions across a distributed set of services and other remote resources.
