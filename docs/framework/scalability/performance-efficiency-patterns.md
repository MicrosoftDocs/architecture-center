---
title: Performance Efficiency patterns
titleSuffix: Cloud Design Patterns
description: Use these performance efficiency patterns to address variable workloads and peaks in activity for cloud applications.
author: dragon119
ms.date: 08/27/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - design-pattern
keywords:
  - design pattern
---

# Performance Efficiency patterns

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. You need to anticipate these increases to meet business requirements. An important consideration in achieving performance efficiency is to consider how your application scales and to implement PaaS offerings that have built-in scaling operations. Scalability is ability of a system either to handle increases in load without impact on performance or for the available resources to be readily increased. It concerns not just compute instances, but other elements such as data storage, messaging infrastructure, and more.

|                           Pattern                            |                                                                        Summary                                                                         |
|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|               [Cache-Aside](../../patterns/cache-aside.md)               |                                                   Load data on demand into a cache from a data store.                                                   |
| [Choreography](../../patterns/choreography.md) | Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control. |
|                      [CQRS](../../patterns/cqrs.md)                      |                           Segregate operations that read data from operations that update data by using separate interfaces.                           |
|            [Event Sourcing](../../patterns/event-sourcing.md)            |                     Use an append-only store to record the full series of events that describe actions taken on data in a domain.                      |
|         [Deployment Stamps](../../patterns/deployment-stamp.md)          |                                      Deploy multiple independent copies of application components, including data stores.                              |
| [Geodes](../../patterns/geodes.md) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. |
|               [Index Table](../../patterns/index-table.md)               |                                Create indexes over the fields in data stores that are frequently referenced by queries.                                |
|         [Materialized View](../../patterns/materialized-view.md)         |       Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations.        |
|            [Priority Queue](../../patterns/priority-queue.md)            | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. |
| [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling.md) |              Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.               |
|                  [Sharding](../../patterns/sharding.md)                  |                                           Divide a data store into a set of horizontal partitions or shards.                                           |
|    [Static Content Hosting](../../patterns/static-content-hosting.md)    |                          Deploy static content to a cloud-based storage service that can deliver them directly to the client.                          |
|                [Throttling](../../patterns/throttling.md)                |                Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service.                 |
