---
title: Challenges of monitoring distributed architectures
description: Team expertise, scaling issues, antipatterns, and resiliency tracking issues when monitoring for performance efficiency
author: PageWriter-MSFT
ms.date: 04/28/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
categories:
  - management-and-governance
ms.custom:
  - fasttrack-edit
  - article
---

# Challenges of monitoring distributed architectures

Most cloud deployments are based on distributed architectures where components are distributed across various services. Troubleshooting monolithic applications often requires only one or two lenses&mdash;the application and the database. With distributed architectures, troubleshooting is complex and challenging because of various factors. This article describes some of those challenges.

## Key points
> [!div class="checklist"]
> - The team may not have the expertise across all the services used in an architecture.
> - Uncovering and resolving bottlenecks by monitoring all of your services and their infrastructure is complex.
> - Antipatterns in design and code causes issues the application is under pressure.
> - Resilience any service may impact your application's ability to meet current load.

## Team expertise
Distributed architectures require many areas of expertise. To adequately monitor performance, it's critical that telemetry is captured throughout the application, across all services, and is rich. Also, your team should have the necessary skills to troubleshoot all services used in the architecture. When making technology choices, it's advantageous and simple to choose a service over another because of the team's expertise. As the collective skillset grows, you can incorporate other technologies.

## Scaling issues

For monolithic applications, scale is  two-dimensional. An application usually consist of a group of application servers, some web front ends (WFEs), and database servers. _Uncovering_ bottlenecks is simpler but _resolving_ them can require considerable effort. For distributed applications, complexity increases exponentially in both aspects for performance issues. You must consider each application, its supporting service, and the latency between all the application layers.

Performance efficiency is a complex mixture of applications and infrastructure (IaaS and PaaS). First, you must ensure that all services can scale to support the expected load and that one service will not cause a bottleneck. Second, while performance testing, you may realize that certain services scale under different load conditions as opposed to scaling all services uniformly. Monitoring all of your services and their infrastructure can help fine-tune your application for optimal performance.

For more information about monitoring for scalability, see [Monitor performance for scalability and reliability](monitor-scalability-reliability.md).

## Antipatterns in design

Antipatterns in design and code are a common cause for performance problems when an application is under pressure. For example, an application behaves as expected during performance testing. However, when it's released to production and starts to handle live workloads, performance decreases. Problems such as rejecting user requests, stalling, or throwing exceptions may arise. To learn how to identify and fix these antipatterns, see [Performance antipatterns for cloud applications](../../antipatterns/index.md).

## Fault tracking

If a service in the architecture fails, how will it affect your application's overall performance? Is the error transient, allowing your application to continue to function; or, will the application experience a critical failure? If the error is transient, does your application experience a decrease in performance? Resiliency plays a significant role in performance efficiency because the failure of any service may impact your application's ability to meet your business goals and scale to meet current load. Chaos testing&mdash;the introduction of random failures within your infrastructure&mdash;against your application can help determine how well your application continues to perform under varying stages of load.

For more information about reliability impacts on performance, see [Monitor performance for scalability and reliability](monitor-scalability-reliability.md).

## Next
> [!div class="nextstepaction"]
> [Design scalable Azure applications](design-apps.md)

## Community links

To learn more about chaos testing, see [Advancing resilience through chaos engineering and fault injection](https://azure.microsoft.com/blog/advancing-resilience-through-chaos-engineering-and-fault-injection/).

## Related links
- [Performance antipatterns for cloud applications](../../antipatterns/index.md)
- [Monitor performance for scalability and reliability](monitor-scalability-reliability.md)
> [Back to the main article](design-checklist.md)
