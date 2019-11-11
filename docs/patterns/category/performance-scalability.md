---
title: Performance and Scalability patterns
titleSuffix: Cloud Design Patterns
description: Performance is an indication of the responsiveness of a system to execute any action within a given time interval, while scalability is ability of a system either to handle increases in load without impact on performance or for the available resources to be readily increased. Cloud applications typically encounter variable workloads and peaks in activity. Predicting these, especially in a multi-tenant scenario, is almost impossible. Instead, applications should be able to scale out within limits to meet peaks in demand, and scale in when demand decreases. Scalability concerns not just compute instances, but other elements such as data storage, messaging infrastructure, and more.
keywords: design pattern
author: dragon119
ms.date: 08/27/2019
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Performance and Scalability patterns

Performance is an indication of the responsiveness of a system to execute any action within a given time interval, while scalability is ability of a system either to handle increases in load without impact on performance or for the available resources to be readily increased. Cloud applications typically encounter variable workloads and peaks in activity. Predicting these, especially in a multi-tenant scenario, is almost impossible. Instead, applications should be able to scale out within limits to meet peaks in demand, and scale in when demand decreases. Scalability concerns not just compute instances, but other elements such as data storage, messaging infrastructure, and more.

|                           Pattern                            |                                                                        Summary                                                                         |
|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|               [Cache-Aside](../cache-aside.md)               |                                                   Load data on demand into a cache from a data store                                                   |
| [Choreography](../choreography.md) | Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control. |
|                      [CQRS](../cqrs.md)                      |                           Segregate operations that read data from operations that update data by using separate interfaces.                           |
|            [Event Sourcing](../event-sourcing.md)            |                     Use an append-only store to record the full series of events that describe actions taken on data in a domain.                      |
|               [Index Table](../index-table.md)               |                                Create indexes over the fields in data stores that are frequently referenced by queries.                                |
|         [Materialized View](../materialized-view.md)         |       Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations.        |
|            [Priority Queue](../priority-queue.md)            | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. |
| [Queue-Based Load Leveling](../queue-based-load-leveling.md) |              Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.               |
|                  [Sharding](../sharding.md)                  |                                           Divide a data store into a set of horizontal partitions or shards.                                           |
|    [Static Content Hosting](../static-content-hosting.md)    |                          Deploy static content to a cloud-based storage service that can deliver them directly to the client.                          |
|                [Throttling](../throttling.md)                |                Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service.                 |
