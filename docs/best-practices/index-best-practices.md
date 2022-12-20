---
title: Best practices in cloud applications
titleSuffix: Azure Architecture Center
description: Learn best practices for building reliable, scalable, and secure applications in the cloud. See resources on caching, partitioning, monitoring, and other areas.
author: martinekuan
ms.date: 01/04/2022
ms.topic: design-pattern
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

# Best practices in cloud applications

These best practices can help you build reliable, scalable, and secure applications in the cloud. They offer guidelines and tips for designing and implementing efficient and robust systems, mechanisms, and approaches. Many also include code examples that you can use with Azure services. The practices apply to any distributed system, whether your host is Azure or a different cloud platform.

## Catalog of practices

This table lists various best practices. The **Related pillars or patterns** column contains the following links:

- Cloud development challenges that the practice and related design patterns address.
- Pillars of the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework] that the practice focuses on.

| Practice | Summary | Related pillars or patterns |
| ------- | ------- | -------- |
| [API design][Web API design] | Design web APIs to support platform independence by using standard protocols and agreed-upon data formats. Promote service evolution so that clients can discover functionality without requiring modification. Improve response times and prevent transient faults by supporting partial responses and providing ways to filter and paginate data. | [Design and implementation][Design and implementation patterns], [Performance efficiency][Overview of the performance efficiency pillar], [Operational excellence][Overview of the operational excellence pillar] |
| [API implementation][Web API implementation] | Implement web APIs to be efficient, responsive, scalable, and available. Make actions idempotent, support content negotiation, and follow the HTTP specification. Handle exceptions, and support the discovery of resources. Provide ways to handle large requests and minimize network traffic. | [Design and implementation][Design and implementation patterns], [Operational excellence][Overview of the operational excellence pillar] |
| [Autoscaling][Autoscaling] | Design apps to dynamically allocate and de-allocate resources to satisfy performance requirements and minimize costs. Take advantage of [Azure Monitor autoscale][Overview of autoscale in Microsoft Azure] and the built-in autoscaling that many Azure components offer. | [Performance efficiency][Overview of the performance efficiency pillar], [Cost optimization][Principles of cost optimization] |
| [Background jobs][Background jobs] | Implement batch jobs, processing tasks, and workflows as background jobs. Use Azure platform services to host these tasks. Trigger tasks with events or schedules, and return results to calling tasks. | [Design and implementation][Design and implementation patterns], [Operational excellence][Overview of the operational excellence pillar] |
| [Caching][Caching] | Improve performance by copying data to fast storage that's close to apps. Cache data that you read often but rarely modify. Manage data expiration and concurrency. See how to populate caches and use the [Azure Cache for Redis][About Azure Cache for Redis] service. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar] |
| [Content delivery network][Best practices for using content delivery networks (CDNs)] | Use content delivery networks (CDNs) to efficiently deliver web content to users and reduce load on web apps. Overcome deployment, versioning, security, and resilience challenges. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar] |
| [Data partitioning][Horizontal, vertical, and functional data partitioning]| Partition data to improve scalability, availability, and performance, and to reduce contention and data storage costs. Use horizontal, vertical, and functional partitioning in efficient ways. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar], [Cost optimization][Principles of cost optimization] |
| [Data partitioning strategies (by service)][Data partitioning strategies] | Partition data in [Azure SQL Database][What is Azure SQL Database?] and [Azure Storage][Introduction to the core Azure Storage services] services like [Azure Table Storage][What is Azure Table storage?] and [Azure Blob Storage][Introduction to Azure Blob storage]. Shard your data to distribute loads, reduce latency, and support horizontal scaling. | [Data management][Data Management patterns], [Performance efficiency][Overview of the performance efficiency pillar], [Cost optimization][Principles of cost optimization] |
| [Host name preservation][Host name preservation] | Learn why it's important to preserve the original HTTP host name between a reverse proxy and its back-end web application, and how to implement this recommendation for the most common Azure services. | [Design and implementation][Design and implementation patterns], [Reliability][Principles of the reliability pillar] |
| [Message encoding considerations][Message encoding considerations] | Use asynchronous messages to exchange information between system components. Choose the payload structure, encoding format, and serialization library that work best with your data. | [Messaging][Messaging patterns], [Security][Overview of the security pillar] |
| [Monitoring and diagnostics][Best practices for monitoring cloud applications] | Track system health, usage, and performance with a monitoring and diagnostics pipeline. Turn monitoring data into alerts, reports, and triggers that help in various situations. Examples include detecting and correcting issues, spotting potential problems, meeting performance guarantees, and fulfilling auditing requirements. | [Operational excellence][Overview of the operational excellence pillar] |
| [Retry guidance for specific services][Retry guidance for Azure services] | Use, adapt, and extend the retry mechanisms that Azure services and client SDKs offer. Develop a systematic and robust approach for managing temporary issues with connections, operations, and resources. | [Design and implementation][Design and implementation patterns], [Reliability][Principles of the reliability pillar] |
| [Transient fault handling][Transient fault handling] | Handle transient faults caused by unavailable networks or resources. Overcome challenges when developing appropriate retry strategies. Avoid duplicating layers of retry code and other anti-patterns. | [Design and implementation][Design and implementation patterns], [Reliability][Principles of the reliability pillar] |

## Next steps

- [Web API design][Web API design]
- [Web API implementation][Web API implementation]

## Related resources

- [Cloud design patterns][Cloud Design Patterns]
- [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework]

[About Azure Cache for Redis]: /azure/azure-cache-for-redis/cache-overview
[Autoscaling]: ./auto-scaling.md
[Background jobs]: ./background-jobs.md
[Best practices for monitoring cloud applications]: ./monitoring.yml
[Best practices for using content delivery networks (CDNs)]: ./cdn.yml
[Caching]: ./caching.yml
[Cloud Design Patterns]: ../patterns/index.md
[Data Management patterns]: ../patterns/category/data-management.md
[Data partitioning strategies]: ./data-partitioning-strategies.yml
[Design and implementation patterns]: ../patterns/category/design-implementation.md
[Horizontal, vertical, and functional data partitioning]: ./data-partitioning.yml
[Host name preservation]: ./host-name-preservation.yml
[Introduction to Azure Blob storage]: /azure/storage/blobs/storage-blobs-introduction
[Introduction to the core Azure Storage services]: /azure/storage/common/storage-introduction
[Message encoding considerations]: ./message-encode.md
[Messaging patterns]: ../patterns/category/messaging.md
[Microsoft Azure Well-Architected Framework]: /azure/architecture/framework/index
[Overview of autoscale in Microsoft Azure]: /azure/azure-monitor/autoscale/autoscale-overview
[Overview of the operational excellence pillar]: /azure/architecture/framework/devops/overview
[Overview of the performance efficiency pillar]: /azure/architecture/framework/scalability/overview
[Overview of the security pillar]: /azure/architecture/framework/security/overview
[Principles of cost optimization]: /azure/architecture/framework/cost/overview
[Principles of the reliability pillar]: /azure/architecture/framework/resiliency/principles
[Retry guidance for Azure services]: ./retry-service-specific.md
[Transient fault handling]: ./transient-faults.md
[Web API design]: ./api-design.md
[Web API implementation]: ./api-implementation.md
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Table storage?]: /azure/storage/tables/table-storage-overview
