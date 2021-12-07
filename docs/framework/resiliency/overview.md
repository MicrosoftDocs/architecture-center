---
title: Overview of the reliability pillar
description: High-level summary of the reliability pillar associated with the Azure Well-Architected Framework.
author: v-stacywray
manager: david-stanford
ms.date: 10/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - overview
products:
  - azure
categories:
  - management-and-governance
---

# Overview of the reliability pillar

Reliability ensures your application can meet the commitments you make to your customers. Architecting resiliency into your application framework ensures your workloads are available and can recover from failures at any scale.

Building for reliability includes:

- Ensuring a highly available architecture
- Recovering from failures such as data loss, major downtime, or ransomware incidents

To assess the reliability of your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

For more information, explore the following video on diving deeper into Azure workload reliability:

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://docs.microsoft.com/_themes/docs.theme/master/en-us/_themes/global/video-embed.html?show=azure-enablement&ep=diving-deeper-into-azure-workload-reliability-part-2--reliability-ep-2--well-architected]

<!-- markdownlint-enable MD034 -->

In traditional application development, there has been a focus on increasing the mean time between failures (MTBF). Effort was spent trying to prevent the system from failing. In cloud computing, a different mindset is required, because of several factors:

- Distributed systems are complex, and a failure at one point can potentially cascade throughout the system.
- Costs for cloud environments are kept low through commodity hardware, so occasional hardware failures must be expected.
- Applications often depend on external services, which may become temporarily unavailable or throttle high-volume users.
- Today's users expect an application to be available 24/7 without ever going offline.

All of these factors mean that cloud applications must be designed to expect occasional failures and recover from them. Azure has many resiliency features already built into the platform. For example:

- Azure Storage, SQL Database, and Cosmos DB all provide built-in data replication across availability zones and regions.
- Azure managed disks are automatically placed in different storage scale units to limit the effects of hardware failures.
- Virtual machines (VMs) in an availability set are spread across several fault domains. A *fault domain* is a group of VMs that share a common power source and network switch. Spreading VMs across fault domains limits the impact of physical hardware failures, network outages, or power interruptions.
- *Availability Zones* are physically separate locations within each Azure region. Each zone is composed of one or more datacenters equipped with independent power, cooling, and networking infrastructure. With availability zones, you can design and operate applications, and databases that automatically transition between zones without interruption, which ensures resiliency if one zone is affected. For more information, reference [Regions and Availability Zones in Azure](/azure/availability-zones/az-overview).

That said, you still need to build resiliency into your application. Resiliency strategies can be applied at all levels of the architecture. Some mitigations are more tactical in nature&mdash;for example, retrying a remote call after a transient network failure. Other mitigations are more strategic, such as failing over the entire application to a secondary region. Tactical mitigations can make a large difference. While it's rare for an entire region to experience a disruption, transient problems such as network congestion are more common&mdash;so target these issues first. Having the right monitoring and diagnostics is also important, both to detect failures when they happen, and to find the root causes.

When designing an application to be resilient, you must understand your availability requirements. How much downtime is acceptable? The amount of downtime is partly a function of cost. How much will potential downtime cost your business? How much should you invest in making the application highly available?

## Topics and best practices

The reliability pillar covers the following topics and best practices to help you build a resilient workload:

|Reliability topic|Description|
|-----------------|-----------|
|[Reliability principles](principles.md)|These critical principles are used as lenses to assess the reliability of an application deployed on Azure.|
|[Design for reliability](design-checklist.md)|Consider how systems use Availability Zones, perform scalability, respond to failure, and other strategies that optimize reliability in application design.|
|[Resiliency checklist for specific Azure services](/azure/architecture/checklist/resiliency-per-service)|Every technology has its own particular failure modes, which you must consider when designing and implementing your application. Use this checklist to review the resiliency considerations for specific Azure services.|
|[Target and non-functional requirements](design-requirements.md)|Target and non-functional requirements such as availability targets and recovery targets allow you to measure the uptime and downtime of your workloads. Having clearly defined targets is crucial to have a goal to work and measure against.|
|[Resiliency and dependencies](design-resiliency.md)|Building failure recovery into the system should be part of the architecture and design phases from the beginning to avoid the risk of failure. Dependencies are required for the application to fully operate.|
|[Availability Zones](/azure/architecture/high-availability/building-solutions-for-high-availability)|Availability Zones can be used to spread a solution across multiple zones within a region, allowing for an application to continue functioning when one zone fails.|
|[Availability of services](/azure/availability-zones/region-types-service-categories-azure)|Availability of services across Azure regions depends on a region's type. Azure's general policy on deploying services into any given region is primarily driven by region type, service categories, and customer demand.|
|[Availability zone terminology](/azure/availability-zones/glossary)|To better understand regions and availability zones in Azure, it helps to understand key terms or concepts.|
|[Best practices](design-best-practices.md)|During the architectural phase, focus on implementing practices that meet your business requirements, identify failure points, and minimize the scope of failures.|
|[Testing for reliability](test-checklist.md)|Regular testing should be performed as part of each major change to validate existing thresholds, targets, and assumptions.|
|[Monitoring for reliability](monitor-checklist.md)|Get an overall picture of application health. If something fails, you need to know *that* it failed, *when* it failed, and *why*.|
|[Reliability patterns](reliability-patterns.md)|Applications must be designed and implemented to maximize availability.|

## Next step

> [!div class="nextstepaction"]
> [Principles](./principles.md)
