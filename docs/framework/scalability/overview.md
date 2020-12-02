---
title: Overview of the performance efficiency pillar
description: Describes the performance efficiency pillar
author: v-aangie
ms.date: 10/23/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - overview
---

# Overview of the performance efficiency pillar

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. Before the cloud became popular, when it came to planning how a system would handle increases in load, many organizations intentionally provisioned workloads to be oversized to meet business requirements. This might make sense in on-premises environments because it ensured *capacity* during peak usage. [Capacity](/azure/api-management/api-management-capacity#what-is-capacity) reflects resource availability (CPU and memory). This was a major consideration for processes that would be in place for a number of years.

Just as you needed to anticipate increases in load in on-premises environments, you need to anticipate increases in cloud environments to meet business requirements. One difference is that you may no longer need to make long-term predictions for anticipated changes to ensure that you will have enough capacity in the future. Another difference is in the approach used to manage performance.



## What is scalability and why is it important?

An important consideration in achieving performance efficiency is to consider how your application scales and to implement PaaS offerings that have built-in scaling operations. *Scalability* is the ability of a system to handle increased load. Services covered by [Azure Autoscale](/azure/azure-monitor/platform/autoscale-overview)<!--replace LINK with new Autoscaling--> can scale automatically to match demand to accommodate workload. They will scale out to ensure capacity during workload peaks and scaling will return to normal automatically when the peak drops.

In the cloud, the ability to take advantage of scalability depends on your infrastructure and services. Some platforms, such as Kubernetes, were built with scaling in mind. Virtual machines, on the other hand, may not scale as easily although scale operations are possible. With virtual machines, you may want to plan ahead to avoid scaling infrastructure in the future to meet demand. Another option is to select a different platform such as Azure virtual machines scale sets.

When using scalability, you need only predict the current average and peak times for your workload. Payment plan options allow you to manage this. You pay either per minute or per-hour depending on the service for a designated time period.

## Principles

Follow these principles to guide you through improving performance efficiency:

- **Become Data-driven** - Embrace a data-driven culture to deliver timely insights to everyone in your organization across all your data. To harness this culture, get the best *performance* from your analytics solution across all your data, ensure data has the *security* and privacy needed for your business environment, and make sure you have tools that enable everyone in your organization to gain [*insights*](https://azure.microsoft.com/blog/the-key-to-a-data-driven-culture-timely-insights/) from your data.

- **Avoid antipatterns** - A performance antipattern is a common practice that is likely to cause scalability problems when an application is under pressure. For example, you can have an application that behaves as expected during performance testing. However, when it is released to production and starts to handle live workloads, performance decreases. Scalability problems such as rejecting user requests, stalling, or throwing exceptions may arise. To learn how to identify and fix these antipatterns, see [Performance antipatterns for cloud applications](../../antipatterns/index.md).

- **Perform load testing to set limits** - [Load testing](./load-testing.md) helps ensure that your applications can scale and do not go down during peak traffic. Load test each application to understand how it performs at various scales. To learn about Azure service limits, see [Managing limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits).

- **Understand billing for metered resources** - Your business requirements will determine the tradeoffs between cost and level of performance efficiency. Azure doesn't directly bill based on the resource cost. Charges for a resource, such as a virtual machine, are calculated by using one or more [meters](/azure/cost-management-billing/understand/review-individual-bill#resources-are-billed-by-usage-meters). Meters are used to track a resource’s usage over time. These meters are then used to calculate the bill.

- **Monitor and optimize** - Lack of monitoring new services​ and the health of current workloads are major inhibitors in workload quality. The overall monitoring strategy should take into consideration not only scalability, but resiliency (infrastructure, application, and dependent services) and application performance as well. For purposes of scalability, looking at the metrics would allow you to provision resources dynamically and scale with demand.

## Next steps

- Performance efficiency impacts the entire architecture spectrum. Bridge gaps in you knowledge of Azure by reviewing the 5 pillars in the [Microsoft Azure Well-Architected Framework](../index.md).

- To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).