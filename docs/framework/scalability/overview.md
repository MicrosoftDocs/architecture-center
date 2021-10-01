---
title: Performance efficiency pillar overview
description: Explore an overview of the performance efficiency pillar in the Azure Well-Architected Framework. Learn about the importance of scalability.
author: v-aangie
ms.date: 10/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products: azure
categories:
  - management-and-governance   
ms.custom:
  - overview
---

# Overview of the performance efficiency pillar

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. Before the cloud became popular, when it came to planning how a system would handle increases in load, many organizations intentionally provisioned oversized workloads to meet business requirements. This decision made sense in on-premises environments because it ensured *capacity* during peak usage. [Capacity](/azure/api-management/api-management-capacity#what-is-capacity) reflects resource availability (CPU and memory). Capacity was a major consideration for processes that would be in place for many years.

Just as you need to anticipate increases in load in on-premises environments, you need to expect increases in cloud environments to meet business requirements. One difference is that you may no longer need to make long-term predictions for expected changes to ensure you'll have enough capacity in the future. Another difference is in the approach used to manage performance.

To assess your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

We recommend the following video about optimizing for quick and reliable VM deployments:

> [!VIDEO https://channel9.msdn.com/Events/All-Around-Azure/Well-Architected-The-Backstage-Tour/Performance-Efficiency/player]

## Scalability and why it's important

To achieve performance efficiency, consider how your application scales and implement PaaS offerings that have built-in scaling operations. *Scalability* is the ability of a system to handle increased load. Services covered by [Azure Autoscale](https://azure.microsoft.com/features/autoscale/) can scale automatically to match demand to accommodate workload. Services will scale out to ensure capacity during workload peaks and scaling will return to normal automatically when the peak drops.

Two main ways an application can scale include *vertical scaling* and *horizontal scaling*. Vertical scaling (scaling *up*) means increasing the capacity of a resource, for example by using a larger VM size. Horizontal scaling (scaling *out*) is adding new instances of a resource, such as VMs or database replicas.

Horizontal scaling has significant advantages over vertical scaling:

- *True cloud scale*: Applications can be designed to run on hundreds or even thousands of nodes, reaching scales that aren't possible on a single node.
- *Horizontal scale is elastic*: You can add more instances if load increases, or remove them during quieter periods.
- Scaling out can be triggered automatically, either on a schedule or in response to changes in load.
- Scaling out may be cheaper than scaling up. Running several small VMs can cost less than a single large VM.
- Horizontal scaling can also improve resiliency, by adding redundancy. If an instance goes down, the application keeps running.

An advantage of vertical scaling is that you can do it without making any changes to the application. But at some point, you'll hit a limit, where you can't scale up anymore. At that point, any further scaling must be horizontal.

Horizontal scale must be designed into the system. For example, you can scale out VMs by placing them behind a load balancer. But each VM in the pool must handle any client request, so the application must be stateless or store state externally (say, in a distributed cache). Managed PaaS services often have horizontal scaling and autoscaling built in. The ease of scaling these services is a major advantage of using PaaS services.

Just adding more instances doesn't mean an application will scale, however. It might push the bottleneck somewhere else. For example, if you scale a web front end to handle more client requests, that might trigger lock contentions in the database. Then, you'd want to consider other measures, such as optimistic concurrency or data partitioning, to enable more throughput to the database.

Always conduct performance and load testing to find these potential bottlenecks. The stateful parts of a system, such as databases, are the most common cause of bottlenecks, and require careful design to scale horizontally. Resolving one bottleneck may reveal other bottlenecks elsewhere.

Use the [Performance efficiency checklist](performance-efficiency.md) to review your design from a scalability standpoint.

In the cloud, the ability to take advantage of scalability depends on your infrastructure and services. Platforms, such as Kubernetes, were built with scaling in mind. Virtual machines may not scale as easily although scale operations are possible. With virtual machines, you may want to plan ahead to avoid scaling infrastructure in the future to meet demand. Another option is to select a different platform such as Azure virtual machines scale sets.

When using scalability, you can predict the current average and peak times for your workload. Payment plan options allow you to manage this prediction. You pay either per minute or per-hour depending on the service for a chosen time period.

## Topics

The performance efficiency pillar covers the following topics to help you effectively scale your workload:

|Performance efficiency topic|Description|
|----------------------------|-----------|
|[Performance principles](principles.md)|Principles to guide you in your overall strategy for improving performance efficiency.|
|[Design for performance](design-checklist.md)| Review your application architecture from a performance design standpoint.|
|[Plan for growth](design-scale.md)|Plan for growth by understanding your current workloads.|
|[Plan for capacity](design-capacity.md)|Plan to scale your application tier by adding extra infrastructure to meet demand.|
|[Monitor for performance](monitor.md)|Monitor services and check the health state of current workloads to maintain overall workload performance.|
|[Performance patterns](performance-efficiency-patterns.md)|Implement design patterns to build more performant workloads.|
|[Tradeoffs](tradeoffs.md)|Consider tradeoffs between performance optimization and other aspects of the design, such as reliability, security, cost efficiency, and operability.|

## Next steps

Reference the performance efficiency principles intended to guide you in your overall strategy.

> [!div class="nextstepaction"]
> [Principles](principles.md)
