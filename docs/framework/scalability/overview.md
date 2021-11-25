---
title: Performance efficiency pillar overview
description: Explore an overview of the performance efficiency pillar in the Azure Well-Architected Framework. Learn about the importance of scalability.
author: v-aangie
ms.date: 10/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - management-and-governance
ms.custom:
  - overview
---

# Overview of the performance efficiency pillar

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. Before the cloud became popular, when it came to planning how a system would handle increases in load, many organizations intentionally provisioned oversized workloads to meet business requirements. This decision made sense in on-premises environments because it ensured *capacity* during peak usage. [Capacity](/azure/api-management/api-management-capacity#what-is-capacity) reflects resource availability (CPU and memory). Capacity was a major consideration for processes that would be in place for many years.

Just as you need to anticipate increases in load in on-premises environments, you need to expect increases in cloud environments to meet business requirements. One difference is that you may no longer need to make long-term predictions for expected changes to ensure you'll have enough capacity in the future. Another difference is in the approach used to manage performance.

To assess your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

To boost performance efficiency, we recommend the following video about optimizing for quick and reliable VM deployments:

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://docs.microsoft.com/en-us/events/all-around-azure-well-architected-the-backstage-tour/performance-efficiency/player]

<!-- markdownlint-enable MD034 -->

## Topics

The performance efficiency pillar covers the following topics to help you effectively scale your workload:

|Performance efficiency topic|Description|
|----------------------------|-----------|
|[Performance efficiency checklist](performance-efficiency.md)|Review your application architecture to ensure your workload scales to meet the demands placed on it by users in an efficient manner.|
|[Performance principles](principles.md)|Principles to guide you in your overall strategy for improving performance efficiency.|
|[Design for performance](design-checklist.md)| Review your application architecture from a performance design standpoint.|
|[Consider scalability](design-scale.md)|Plan for growth by understanding your current workloads.|
|[Plan for capacity](design-capacity.md)|Plan to scale your application tier by adding extra infrastructure to meet demand.|
|[Performance monitoring checklist](checklist.md)|Monitor services and check the health state of current workloads to maintain overall workload performance.|
|[Performance patterns](performance-efficiency-patterns.md)|Implement design patterns to build more performant workloads.|
|[Tradeoffs](tradeoffs.md)|Consider tradeoffs between performance optimization and other aspects of the design, such as reliability, security, cost efficiency, and operability.|

## Next steps

Reference the performance efficiency principles intended to guide you in your overall strategy.

> [!div class="nextstepaction"]
> [Principles](principles.md)
