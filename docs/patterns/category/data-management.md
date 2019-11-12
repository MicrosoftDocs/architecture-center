---
title: Data Management patterns
titleSuffix: Cloud Design Patterns
description: Data management is the key element of cloud applications, and influences most of the quality attributes. Data is typically hosted in different locations and across multiple servers for reasons such as performance, scalability or availability, and this can present a range of challenges. For example, data consistency must be maintained, and data will typically need to be synchronized across different locations.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Data Management patterns

Data management is the key element of cloud applications, and influences most of the quality attributes. Data is typically hosted in different locations and across multiple servers for reasons such as performance, scalability or availability, and this can present a range of challenges. For example, data consistency must be maintained, and data will typically need to be synchronized across different locations.

|                        Pattern                         |                                                                  Summary                                                                  |
|--------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
|            [Cache-Aside](../cache-aside.md)            |                                            Load data on demand into a cache from a data store                                             |
|                   [CQRS](../cqrs.md)                   |                    Segregate operations that read data from operations that update data by using separate interfaces.                     |
|         [Event Sourcing](../event-sourcing.md)         |               Use an append-only store to record the full series of events that describe actions taken on data in a domain.               |
|            [Index Table](../index-table.md)            |                         Create indexes over the fields in data stores that are frequently referenced by queries.                          |
|      [Materialized View](../materialized-view.md)      | Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations. |
|               [Sharding](../sharding.md)               |                                    Divide a data store into a set of horizontal partitions or shards.                                     |
| [Static Content Hosting](../static-content-hosting.md) |                   Deploy static content to a cloud-based storage service that can deliver them directly to the client.                    |
|              [Valet Key](../valet-key.md)              |                 Use a token or key that provides clients with restricted direct access to a specific resource or service.                 |
