---
title: Best practices in cloud applications
description: Learn best practices for building reliable, scalable, and secure applications in the cloud. See resources on caching, partitioning, monitoring, and other areas.
ms.author: pnp
author: claytonsiemens77
ms.date: 01/04/2022
ms.topic: best-practice
ms.subservice: cloud-fundamentals
---

# Best practices in cloud applications

Building reliable, scalable, and secure cloud applications requires deliberate architectural decisions. The best practices in this section provide guidance for common concerns that arise in distributed systems, such as caching, data partitioning, API design, and transient fault handling. Each practice addresses one or more pillars of the [Azure Well-Architected Framework](/azure/well-architected/), which defines five quality attributes for workload design: [Reliability](/azure/well-architected/reliability/), [Security](/azure/well-architected/security/), [Cost Optimization](/azure/well-architected/cost-optimization/), [Operational Excellence](/azure/well-architected/operational-excellence/), and [Performance Efficiency](/azure/well-architected/performance-efficiency/).

These practices complement other foundational guidance in the Azure Architecture Center. The [design principles for Azure applications](../guide/design-principles/index.md) provide high-level strategies, like designing for self-healing and scaling out. The [cloud design patterns](../patterns/index.md) offer reusable solutions to recurring architectural problems. The [performance antipatterns](../antipatterns/index.md) describe common defects that cause scalability issues under load. These resources help you make informed architectural choices.

## Catalog of practices

Each practice in this table maps to one or more [Well-Architected Framework pillars](/azure/well-architected/pillars). Use these mappings to identify which practices are most relevant to the quality attributes you're prioritizing in your workload.

| Practice | Summary | Related pillars |
| :------- | :------ | :-------------- |
| [API design](./api-design.md) | Design web APIs to support platform independence by using standard protocols and agreed-upon data formats. Promote service evolution so that clients can discover functionality without requiring modification. Improve response times and prevent transient faults by supporting partial responses and providing ways to filter and paginate data. | [Performance Efficiency](/azure/well-architected/performance-efficiency/), [Operational Excellence](/azure/well-architected/operational-excellence/) |
| [API implementation](./api-implementation.md) | Implement web APIs to be efficient, responsive, scalable, and available. Make actions idempotent, support content negotiation, and follow the HTTP specification. Handle exceptions, and support the discovery of resources. Provide ways to handle large requests and minimize network traffic. | [Operational Excellence](/azure/well-architected/operational-excellence/) |
| [Autoscaling](./auto-scaling.md) | Design apps to dynamically allocate and de-allocate resources to satisfy performance requirements and minimize costs. Take advantage of [Azure Monitor autoscale](/azure/azure-monitor/autoscale/autoscale-overview) and the built-in autoscaling that many Azure components offer. | [Performance Efficiency](/azure/well-architected/performance-efficiency/), [Cost Optimization](/azure/well-architected/cost-optimization/) |
| [Background jobs](./background-jobs.md) | Implement batch jobs, processing tasks, and workflows as background jobs. Use Azure platform services to host these tasks. Trigger tasks with events or schedules, and return results to calling tasks. | [Operational Excellence](/azure/well-architected/operational-excellence/) |
| [Caching](./caching.yml) | Improve performance by copying data to fast storage that's close to apps. Cache data that you read often but rarely modify. Manage data expiration and concurrency. See how to populate caches and use the [Azure Managed Redis](/azure/redis/overview) service. | [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Content Delivery Network](./cdn.yml) | Use content delivery networks (CDNs) to efficiently deliver web content to users and reduce load on web apps. Overcome deployment, versioning, security, and resilience challenges. | [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Data partitioning](./data-partitioning.yml) | Partition data to improve scalability, availability, and performance, and to reduce contention and data storage costs. Use horizontal, vertical, and functional partitioning in efficient ways. | [Performance Efficiency](/azure/well-architected/performance-efficiency/), [Cost Optimization](/azure/well-architected/cost-optimization/) |
| [Data partitioning strategies (by service)](./data-partitioning-strategies.yml) | Partition data in [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) and [Azure Storage](/azure/storage/common/storage-introduction) services like [Azure Table Storage](/azure/storage/tables/table-storage-overview) and [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction). Shard your data to distribute loads, reduce latency, and support horizontal scaling. | [Performance Efficiency](/azure/well-architected/performance-efficiency/), [Cost Optimization](/azure/well-architected/cost-optimization/) |
| [Host name preservation](./host-name-preservation.md) | Learn why it's important to preserve the original HTTP host name between a reverse proxy and its back-end web application, and how to implement this recommendation for the most common Azure services. | [Reliability](/azure/well-architected/reliability/) |
| [Message encoding considerations](./message-encode.md) | Use asynchronous messages to exchange information between system components. Choose the payload structure, encoding format, and serialization library that work best with your data. | [Security](/azure/well-architected/security/) |
| [Monitoring and diagnostics](./monitoring.yml) | Track system health, usage, and performance with a monitoring and diagnostics pipeline. Turn monitoring data into alerts, reports, and triggers that help in various situations. Examples include detecting and correcting issues, spotting potential problems, meeting performance guarantees, and fulfilling auditing requirements. | [Operational Excellence](/azure/well-architected/operational-excellence/) |
| [Transient fault handling](./transient-faults.md) | Handle transient faults caused by unavailable networks or resources. Overcome challenges when developing appropriate retry strategies. Avoid duplicating layers of retry code and other antipatterns. | [Reliability](/azure/well-architected/reliability/) |

## Performance antipatterns

Best practices tell you what to do. Antipatterns describe common defects that surface under production load. These issues often stem from designs that don't scale or from shortcuts that accumulate as features are added. Recognizing these antipatterns during design reviews and code reviews helps you avoid performance and scalability problems before they reach production. For more detail on each antipattern and how to detect and resolve it, see [Performance antipatterns for cloud applications](../antipatterns/index.md).

| Antipattern | Description |
| :---------- | :---------- |
| [Busy Database](../antipatterns/busy-database/index.md) | Offloading too much processing to a data store. |
| [Busy Front End](../antipatterns/busy-front-end/index.md) | Moving resource-intensive tasks onto background threads that starve foreground work. |
| [Chatty I/O](../antipatterns/chatty-io/index.md) | Continually sending many small network requests. |
| [Extraneous Fetching](../antipatterns/extraneous-fetching/index.md) | Retrieving more data than is needed, resulting in unnecessary I/O. |
| [Improper Instantiation](../antipatterns/improper-instantiation/index.md) | Repeatedly creating and destroying objects that are designed to be shared and reused. |
| [Monolithic Persistence](../antipatterns/monolithic-persistence/index.md) | Using the same data store for data with very different usage patterns. |
| [No Caching](../antipatterns/no-caching/index.md) | Failing to cache data that is read frequently but changes rarely. |
| [Noisy Neighbor](../antipatterns/noisy-neighbor/noisy-neighbor.yml) | A single tenant consuming a disproportionate share of shared resources. |
| [Retry Storm](../antipatterns/retry-storm/index.md) | Retrying failed requests too aggressively, amplifying load on a recovering service. |
| [Synchronous I/O](../antipatterns/synchronous-io/index.md) | Blocking the calling thread while I/O completes. |

## Next steps

- [Web API design](./api-design.md)
- [Web API implementation](./api-implementation.md)

## Related resources

- [Cloud design patterns](../patterns/index.md)
- [Azure Well-Architected Framework](/azure/well-architected/)
