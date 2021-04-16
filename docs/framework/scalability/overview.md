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

- **Performance testing** - It is imperative that any development efforts undergo continuous performance testing to ensure that any changes to the codebase does not negatively affect the application's performance. When conducting performance testing, it is important that you first establish baselines for your application and, then, establish a regular cadence for testing. This cadence for testing can be a regularly scheduled event or part of a CI build pipeline. But, regardless of how performance testing is conducted, it should be considered a requirement within the scope of development.

  - **Establish baselines** - Baselines help to establish the current efficiency of your application and its supporting infrastructure. Baselines can provide a good bearing for improvements in your application's performance and helps you determine if the application is meeting the business's KPIs. Baselines can be created for any application regardless of its maturity&mdash;a new project or an application that has been running in production for years. No matter when you establish the baseline, performance during continued development can be continuously measured against it. When code and/or infrastructure changes, the effect on performance can be actively measured.

  - **Load & stress testing** - Besides standard performance testing and the constant measurements against your baselines, there are two additional flavors of testing&mdash;load and stress testing. Load testing measures your application's performance under predetermined amounts of load. Stress testing measures the _maximum_ load your application and its infrastructure can support before it buckles.

    Load testing takes places in stages of load. These stages are usually measured by virtual users (VUs) or simulated requests, and the stages happen over given intervals. Load testing provides insights into how and when your application needs to scale in order to continue to meet your SLA to your customers (whether internal or external). Load testing can also be useful for determining latency across distributed applications and microservices.

  - **Identifying bottlenecks** - Bottlenecks are areas within your application that can hinder performance, and the bottleneck typically worsens as load increases. Bottlenecks can be the result of deficiencies in code or misconfiguration of a service.

  - **Improvement options** - The first step for determining options for improvement is to ensure that you are capturing telemetry throughout your application. [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) provides some great telemetry out of the box, and you can customize what is captured for even greater visibility. Next, you may want to compare your code to proven architectures in the [Cloud Design Patterns](../../patterns/index-patterns). By referencing the design patterns, you can avoid common mistakes by developers who are deploying applications into the cloud. Finally, you may consider other Azure services that may be more appropriate for your objectives. While Azure has many services that seem to overlap in capabilities, often there are specific use-cases for which the services are designed.
  
- **Monitoring** - Lack of monitoring new services​ and the health of current workloads are major inhibitors in workload quality. The overall monitoring strategy should take into consideration not only scalability, but resiliency (infrastructure, application, and dependent services) and application performance as well. For purposes of scalability, looking at the metrics would allow you to provision resources dynamically and scale with demand.

  - **Data-driven processes** -

  - **Troubleshooting** -

  - **Resolution planning** -

- **Capacity planning** -

  - **Technology & SKU service limits** -

  - **SLAs** -

  - **Costs** -

- **Distributed architecture** -

  - **Scale** -

  - **Anti-pattern avoidance** - A performance antipattern is a common practice that is likely to cause scalability problems when an application is under pressure. For example, you can have an application that behaves as expected during performance testing. However, when it is released to production and starts to handle live workloads, performance decreases. Scalability problems such as rejecting user requests, stalling, or throwing exceptions may arise. To learn how to identify and fix these antipatterns, see [Performance antipatterns for cloud applications](../../antipatterns/index.md)

  - **Fault-handling** -

## Next steps

- Performance efficiency impacts the entire architecture spectrum. Bridge gaps in you knowledge of Azure by reviewing the 5 pillars in the [Microsoft Azure Well-Architected Framework](../index.md).

- To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).
