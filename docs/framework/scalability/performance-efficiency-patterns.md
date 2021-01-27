---
title: Performance Efficiency patterns
titleSuffix: Cloud Design Patterns
description: Use these performance efficiency patterns to address variable workloads and peaks in activity for cloud applications.
keywords: design pattern
author: dragon119
ms.date: 08/27/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - seodec18
  - design-pattern
---

# Performance Efficiency patterns

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. You need to anticipate these increases to meet business requirements. An important consideration in achieving performance efficiency is to consider how your application scales and to implement PaaS offerings that have built-in scaling operations. Scalability is ability of a system either to handle increases in load without impact on performance or for the available resources to be readily increased. It concerns not just compute instances, but other elements such as data storage, messaging infrastructure, and more. 

|                           Pattern                            |                                                                        Summary                                                                         |
|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|               [Cache-Aside](https://docs.microsoft.com/azure/architecture/patterns/cache-aside)               |                                                   Load data on demand into a cache from a data store                                                   |
| [Choreography](https://docs.microsoft.com/azure/architecture/patterns/choreography) | Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control. |
|                      [CQRS](https://docs.microsoft.com/azure/architecture/patterns/cqrs)                      |                           Segregate operations that read data from operations that update data by using separate interfaces.                           |
|            [Event Sourcing](https://docs.microsoft.com/azure/architecture/patterns/event-sourcing)            |                     Use an append-only store to record the full series of events that describe actions taken on data in a domain.                      |
|         [Deployment Stamps](https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp)          |                                      Deploy multiple independent copies of application components, including data stores.                              |
| [Geodes](https://docs.microsoft.com/azure/architecture/patterns/geodes) | Deploy backend services into a set of geographical nodes, each of which can service any client request in any region. |
|               [Index Table](https://docs.microsoft.com/azure/architecture/patterns/index-table)               |                                Create indexes over the fields in data stores that are frequently referenced by queries.                                |
|         [Materialized View](https://docs.microsoft.com/azure/architecture/patterns/materialized-view)         |       Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations.        |
|            [Priority Queue](https://docs.microsoft.com/azure/architecture/patterns/priority-queue)            | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. |
| [Queue-Based Load Leveling](https://docs.microsoft.com/azure/architecture/patterns/queue-based-load-leveling) |              Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.               |
|                  [Sharding](https://docs.microsoft.com/azure/architecture/patterns/sharding)                  |                                           Divide a data store into a set of horizontal partitions or shards.                                           |
|    [Static Content Hosting](https://docs.microsoft.com/azure/architecture/patterns/static-content-hosting)    |                          Deploy static content to a cloud-based storage service that can deliver them directly to the client.                          |
|                [Throttling](https://docs.microsoft.com/azure/architecture/patterns/throttling)                |                Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service.                 |
