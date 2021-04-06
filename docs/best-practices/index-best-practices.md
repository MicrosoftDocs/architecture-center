---
title: Cloud best practices
titleSuffix: Azure Architecture Center
description: Learn best practices for building reliable, scalable, and secure applications in the cloud. See resources on caching, partitioning, monitoring, and other areas.
author: edprice
ms.date: 04/09/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: design-pattern
ms.custom:
  - design-pattern
keywords:
  - Azure
categories:
  - devops
  - management-and-governance
  - security
  - storage
products:
  - azure
---

# Cloud best practices

These best practices are useful for building reliable, scalable, and secure applications in the cloud.

Each practice offers guidelines and tips for designing and implementing efficient and robust systems, mechanisms, and approaches. Many practices include code examples that you can use with Azure services. All practices apply to any distributed system, whether your host is Azure or a different cloud platform.

## Challenges in cloud development

:::row:::
   :::column span="1":::
      [![Icon showing simplified images of a database and data in a tabular format.](../patterns/_images/category/data-management.svg)][Data Management patterns]
   :::column-end:::
   :::column span="3":::
      ### Data management

      A key element of cloud applications is [data management][Data Management patterns]. Cloud systems typically host data in different locations and across multiple servers. This approach can improve performance, scalability, and availability but can also present a range of challenges. For example, to maintain consistency, you often need to synchronize data across different locations.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="1":::
      [![Icon showing a simplified view of an architecture diagram and a pencil.](../patterns/_images/category/design-implementation.svg)][Design and implementation patterns]
   :::column-end:::
   :::column span="3":::
      ### Design and implementation

      [Good design][Design and implementation patterns] encompasses many factors. One example is consistency and coherence in component design and deployment. Another factor involves making systems easy to maintain in order to simplify administration and development. Reusability makes up a third factor. This aspect focuses on using components and subsystems in other applications and scenarios. Decisions that you make during design and implementation phases have a huge impact on the quality and cost of your cloud-hosted applications and services.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="1":::
      [![Icon showing two envelopes. One is set at an angle and is slightly higher than the other. The implied movement represents the message delivery process.](../patterns/_images/category/messaging.svg)][Messaging patterns]
   :::column-end:::
   :::column span="3":::
      ### Messaging

      The distributed nature of cloud applications requires a [messaging][Messaging patterns] infrastructure. Ideally this infrastructure connects components and services in a loosely coupled manner that maximizes scalability. Asynchronous messaging provides a solution with many benefits. But asynchronous messaging also brings challenges. Examples include guaranteeing message ordering, handling poison messages, and supporting idempotency.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="1":::
   :::column-end:::
   :::column span="3":::
   :::column-end:::
:::row-end:::

## Catalog of practices

This table lists various best practices. The **Category** column contains the following links:

- Cloud development challenges that the practice helps to overcome.
- Pillars of the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework] that the practice focuses on.

| Practice | Summary | Category |
| ------- | ------- | -------- |
| [Web API design][Web API design] | Design web APIs to support platform independence by using standard protocols and agreed-upon data formats. Promote service evolution so that clients can discover functionality without requiring modification. Improve response times and prevent transient faults by supporting partial responses and providing ways to filter and paginate data. | [Design and implementation][Design and implementation patterns], [Performance efficiency][Overview of the performance efficiency pillar], [Operational excellence][Overview of the operational excellence pillar] |
| [Web API implementation][Web API implementation] | Implement web APIs to be efficient, responsive, scalable, and available. Make actions idempotent, support content negotiation, and follow the HTTP specification. Handle exceptions, and support the discovery of resources. Provide ways to handle large requests and minimize network traffic. | [Design and implementation][Design and implementation patterns], [Operational excellence][Overview of the operational excellence pillar] |
| [Autoscaling][Autoscaling] | Design apps to dynamically allocate and de-allocate resources to match performance requirements and minimize costs. Take advantage of [Azure Monitor autoscale][Overview of autoscale in Microsoft Azure] and the built-in autoscaling that many Azure components offer. | [Performance efficiency][Overview of the performance efficiency pillar], [Cost optimization][Principles of cost optimization] |
| [Background jobs][Background jobs] | Implement batch jobs, processing tasks, and workflows as background jobs. Use Azure platform services to host these tasks. Trigger tasks with events or schedules, and return results to calling tasks. | [Design and implementation][Design and implementation patterns], [Operational excellence][Overview of the operational excellence pillar] |
| [Caching][Caching] | Improve performance by copying data to fast storage that's close to apps. Cache data that you read often but rarely modify. Manage data expiration and concurrency. See how to populate caches and use the [Azure Cache for Redis][About Azure Cache for Redis] service. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar] |
| [Best practices for using content delivery networks (CDNs)][Best practices for using content delivery networks (CDNs)] | Use content delivery networks (CDNs) to efficiently deliver web content to users and reduce load on web apps. Overcome deployment, versioning, security, and resilience challenges. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar] |
| [Horizontal, vertical, and functional data partitioning][Horizontal, vertical, and functional data partitioning]| Partition data to improve scalability, availability, and performance, and to reduce contention and data storage costs. Design schemes to use horizontal, vertical, and functional partitioning in efficient ways. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar], [Cost optimization][Principles of cost optimization] |
| [Data partitioning strategies][Data partitioning strategies] | Partition data in [Azure SQL Database][What is Azure SQL Database?] and [Azure Storage][Introduction to the core Azure Storage services] services like [Azure Table Storage][What is Azure Table storage?] and [Azure Blob Storage][Introduction to Azure Blob storage]. Shard data to distribute loads, reduce latency, and support horizontal scaling. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar], [Cost optimization][Principles of cost optimization] |
| [Message encoding considerations][Message encoding considerations] | Use asynchronous messages to exchange information between system components. Choose the payload structure, encoding format, and serialization library that work best with your data. | [Messaging][Messaging patterns], [Security][Overview of the security pillar] |
| [Best practices for monitoring cloud applications][Best practices for monitoring cloud applications] | Track system health, usage, and performance with a monitoring and diagnostics pipeline. Turn monitoring data into alerts, reports, and triggers that help in various situations. Examples include detecting and correcting issues, spotting potential problems, meeting performance guarantees, and fulfilling auditing requirements. | [Operational excellence][Overview of the operational excellence pillar] |
| [Retry guidance for Azure services][Retry guidance for Azure services] | Use, adapt, and extend the retry mechanisms that Azure services and client SDKs offer. Develop a systematic, robust approach for managing temporary issues with connections, operations, and resources. | [Design and implementation][Design and implementation patterns], [Reliability][Principles of the reliability pillar] |
| [Transient fault handling][Transient fault handling] | Handle transient faults caused by unavailable networks or resources. Overcome challenges when developing appropriate retry strategies. Avoid duplicating layers of retry code and other anti-patterns. | [Design and implementation][Design and implementation patterns], [Reliability][Principles of the reliability pillar] |

## Next steps

- [Web API design][Web API design]
- [Web API implementation][Web API implementation]

## Related resources

- [Cloud design patterns][Cloud Design Patterns]
- [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework]

[About Azure Cache for Redis]: /azure/azure-cache-for-redis/cache-overview
[Autoscaling]: ./auto-scaling.md
[Background jobs]: ./background-jobs.md
[Best practices for monitoring cloud applications]: ./monitoring.md
[Best practices for using content delivery networks (CDNs)]: ./cdn.md
[Caching]: ./caching.md
[Cloud Design Patterns]: /azure/architecture/patterns/index-patterns
[Data Management patterns]: /azure/architecture/patterns/category/data-management
[Data partitioning strategies]: ./data-partitioning-strategies.md
[Design and implementation patterns]: /azure/architecture/patterns/category/design-implementation
[Horizontal, vertical, and functional data partitioning]: ./data-partitioning.md
[Introduction to Azure Blob storage]: /azure/storage/blobs/storage-blobs-introduction
[Introduction to the core Azure Storage services]: /azure/storage/common/storage-introduction
[Message encoding considerations]: ./message-encode.md
[Messaging patterns]: /azure/architecture/patterns/category/messaging
[Microsoft Azure Well-Architected Framework]: /azure/architecture/framework
[Overview of autoscale in Microsoft Azure]: /azure/azure-monitor/autoscale/autoscale-overview
[Overview of the operational excellene pillar]: /azure/architecture/framework/devops/overview
[Overview of the performance efficiency pillar]: /azure/architecture/framework/scalability/overview
[Overview of the security pillar]: /azure/architecture/framework/security/overview
[Principles of cost optimization]: /azure/architecture/framework/cost/overview
[Principles of the reliability pillar]: /azure/architecture/framework/resiliency/overview
[Retry guidance for Azure services]: ./retry-service-specific.md
[Transient fault handling]: ./transient-faults.md
[Web API design]: ./api-design.md
[Web API implementation]: ./api-implementation.md
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Table storage?]: /azure/storage/tables/table-storage-overview