---
title: Principles of the performance efficiency
description: Describes the performance efficiency guiding principles
author: a11smiles
ms.date: 10/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
categories:
  - management-and-governance
products:
  - azure-monitor
ms.custom:
  - overview
---

# Performance efficiency principles
Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. You need to anticipate increases in cloud environments to meet business requirements. These principles are intended to guide you in your overall strategy for improving performance efficiency.

[**Understand the challenges of distributed architectures**](design-distributed.md)

Most cloud deployments are based on distributed architectures where components are distributed across various services. Troubleshooting monolithic applications often requires only one or two lenses—the application and the database. With distributed architectures, troubleshooting is complex and challenging because of various factors. For example, capturing telemetry throughout the application—across all services—as possible. Also, the team should be skilled with the necessary expertise to troubleshoot all services in your architecture.

[**Run performance testing in the scope of development**](performance-test.md)

Any development effort must go through continuous performance testing. The tests make sure that _any_ change to the codebase doesn't negatively affect the application's performance. Establish a regular cadence for running the tests. Run the test as part of a scheduled event or part of a continuous integration (CI) build pipeline.

- **Establish performance baselines**&mdash;Determine the current efficiency of the application and its supporting infrastructure. Measuring performance against baselines can provide strategies for improvements and determine if the application is meeting the business goals.

- **Run load and stress tests**&mdash;Load testing measures your application's performance under predetermined amounts of load. Stress testing measures the _maximum_ load your application and its infrastructure can support before it buckles.

- **Identify bottlenecks**&mdash;Bottlenecks is an area within your application that can hinder performance. These spots can be the result of shortages in code or misconfiguration of a service. Typically, a bottleneck worsens as load increases.

[**Continuously monitor the application and the supporting infrastructure**](checklist.md)

- **Have a data-driven approach**&mdash;Base your decisions on the data captured from repeatable processes. Archive data to monitor performance changes  _over time_, not just compared to the last measurement taken.
- **Monitor the health of current workloads**&mdash;In monitoring strategy, consider scalability _and_ resiliency of the infrastructure, application, and dependent services. For scalability, look at the metrics that would allow you to provision resources dynamically and scale with demand. For reliability, look for early warning signs that might require proactive intervention.
- **Troubleshoot performance issues**&mdash;Issues in performance can arise from database queries, connectivity between services, under-provisioned resources, or memory leaks in code. Application telemetry and profiling can be useful tools for troubleshooting your application.

[**Identify improvement opportunities with resolution planning**](optimize.md)

Understand the scope of your planned resolution and communicate the changes to all necessary stakeholders. Make code enhancements through a new build. Enhancements to infrastructure may involve many teams. This involved effort may require updated configurations and deprecations in favor of more-appropriate solutions.

[**Invest in capacity planning**](design-capacity.md)

Plan for fluctuation in expected load that can occur because of world events. Test variations of load before the events, including unexpected ones, to ensure that your application can scale. Make sure all regions can adequately scale to support total load, if a region fails. Take into consideration:

- Technology and the SKU service limits.
- SLAs when determining the services to use in the design. Also, the SLAs of those services.
- Cost analysis to determine how much improvement will be realized in the application if costs are increased. Evaluate if the cost is worth the investment.

## Next section
Use this checklist to review your application architecture from a performance design standpoint.

> [!div class="nextstepaction"]
> [Design checklist](design-checklist.md)

## Related links
- Performance efficiency impacts the entire architecture spectrum. Bridge gaps in your knowledge of Azure by reviewing the five pillars of the [Microsoft Azure Well-Architected Framework](../index.md).

- To assess your workload using pillars, see the [Microsoft Azure Well-Architected Review](/assessments/?mode=pre-assessment&session=5c2bcc40-1c41-47b1-8729-1fba49dbe408).
