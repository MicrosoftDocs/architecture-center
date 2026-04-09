---
title: Best practices in cloud applications
description: Learn about some best practices for building cloud applications and how they align with the Azure Well-Architected Framework.
author: claytonsiemens77
ms.author: pnp
ms.date: 03/12/2026
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
| [API design](./api-design.md) | Design web APIs to support platform independence by using standard protocols and agreed-upon data formats. Promote service evolution so that clients can discover functionality without requiring modification. Improve response times by supporting partial responses and providing ways to filter and paginate data. | [Operational&nbsp;Excellence](/azure/well-architected/operational-excellence/), [Performance&nbsp;Efficiency](/azure/well-architected/performance-efficiency/) |
| [API implementation](./api-implementation.md) | Implement web APIs to be efficient, responsive, scalable, and available. Make actions idempotent, support content negotiation, and follow the HTTP specification. Handle exceptions, and support the discovery of resources. Provide ways to handle large requests and minimize network traffic. | [Operational Excellence](/azure/well-architected/operational-excellence/), [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Autoscaling](./auto-scaling.md) | Design apps to dynamically allocate and deallocate resources to satisfy performance requirements and minimize costs. Take advantage of [Azure Monitor autoscale](/azure/azure-monitor/autoscale/autoscale-overview) and the built-in autoscaling that many Azure components offer. | [Cost&nbsp;Optimization](/azure/well-architected/cost-optimization/), [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Background jobs](./background-jobs.md) | Implement batch jobs, processing tasks, and workflows as background jobs. Use Azure platform services to host these tasks. Trigger tasks with events or schedules, and return results to calling tasks. | [Reliability](/azure/well-architected/reliability/), [Operational&nbsp;Excellence](/azure/well-architected/operational-excellence/) |
| [Caching](./caching.yml) | Improve performance by copying data to fast storage that's close to apps. Cache data that you read often but rarely modify. Manage data expiration and concurrency. See how to populate caches and use the [Azure Managed Redis](/azure/redis/overview) service. | [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Content Delivery Network](./cdn.yml) | Use content delivery networks (CDNs) to efficiently deliver web content to users and reduce load on web apps. Overcome deployment, versioning, security, and resilience challenges. | [Reliability](/azure/well-architected/reliability/), [Performance&nbsp;Efficiency](/azure/well-architected/performance-efficiency/) |
| [Data partitioning](./data-partitioning.yml) | Partition data to improve scalability, availability, and performance, and to reduce contention and data storage costs. Use horizontal, vertical, and functional partitioning in efficient ways. | [Cost Optimization](/azure/well-architected/cost-optimization/), [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Data partitioning strategies (by service)](./data-partitioning-strategies.yml) | Apply partitioning strategies across Azure services, including [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview), [Azure Cosmos DB](/azure/cosmos-db/introduction), [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction), [Azure Managed Redis](/azure/redis/overview), [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview), and others. Distribute loads, reduce latency, and support horizontal scaling. | [Cost Optimization](/azure/well-architected/cost-optimization/), [Performance Efficiency](/azure/well-architected/performance-efficiency/) |
| [Host name preservation](./host-name-preservation.md) | Learn why it's important to preserve the original HTTP host name between a reverse proxy and its back-end web application, and how to implement this recommendation for the most common Azure services. | [Reliability](/azure/well-architected/reliability/), [Security](/azure/well-architected/security/) |
| [Message encoding considerations](./message-encode.md) | Choose the payload structure, encoding format, and serialization library for asynchronous messages exchanged between system components. Consider tradeoffs such as interoperability, size, human readability, and schema evolution. | [Security](/azure/well-architected/security/) |
| [Monitoring and diagnostics](./monitoring.yml) | Track system health, usage, and performance with a monitoring and diagnostics pipeline. Turn monitoring data into alerts, reports, and triggers that help in various situations. Examples include detecting and correcting issues, spotting potential problems, meeting performance guarantees, and fulfilling auditing requirements. | [Operational Excellence](/azure/well-architected/operational-excellence/) |
| [Transient fault handling](./transient-faults.md) | Handle transient faults caused by unavailable networks or resources. Overcome challenges when developing appropriate retry strategies. Avoid duplicating layers of retry code and other antipatterns. | [Reliability](/azure/well-architected/reliability/) |

## Design principles

Before you address specific technical concerns, establish a strong architectural foundation. The [design principles for Azure applications](../guide/design-principles/index.md) provide high-level strategies that apply across workloads, such as designing for self-healing, scaling out, and minimizing coordination. These principles shape decisions that the best practices listed previously help you implement.

## Cloud design patterns

With principles in place, [cloud design patterns](../patterns/index.md) give you reusable solutions for recurring problems in distributed systems. Many of the best practices in this section rely on one or more of these patterns. For example, the transient fault handling guidance builds on the [Retry pattern](../patterns/retry.yml) and [Circuit Breaker pattern](../patterns/circuit-breaker.md), the caching guidance relates to the [Cache-Aside pattern](../patterns/cache-aside.yml), and the background jobs guidance uses patterns like [Competing Consumers](../patterns/competing-consumers.md) and [Queue-Based Load Leveling](../patterns/queue-based-load-leveling.yml). Review the full catalog to identify patterns that address the architectural challenges in your workload.

## Performance antipatterns

Even with sound principles, good patterns, and best practices applied, defects can emerge under production load. [Performance antipatterns for cloud applications](../antipatterns/index.md) describe common designs that don't scale or shortcuts that accumulate as features are added. Use these antipatterns as a checklist during design reviews and code reviews to catch issues before they reach production.

## Next steps

- [Azure Well-Architected Review](/assessments/azure-architecture-review/) - Assess your workload against the Well-Architected Framework pillars.
- [Design principles for Azure applications](../guide/design-principles/index.md) - Start with the foundational principles that inform these best practices.
- [Cloud design patterns](../patterns/index.md) - Explore reusable solutions to common architectural challenges.
