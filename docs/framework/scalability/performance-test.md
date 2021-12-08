---
title: Performance testing
description: Explore testing considerations for performance efficiency. Establish baselines. Learn about testing for load, stress, and multiple regions.
author: v-aangie
ms.date: 12/02/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
categories:
  - management-and-governance
ms.custom:
  - How are you handling user load?
  - article
---

# Performance testing

Performance testing helps to maintain systems properly and fix defects before problems reach system users. It helps maintain the efficiency, responsiveness, scalability, and speed of applications when compared with business requirements. When done effectively, performance testing should give you the diagnostic information necessary to eliminate bottlenecks, which lead to poor performance. A bottleneck occurs when data flow is either interrupted or stops due to insufficient capacity to handle the workload.

To avoid experiencing poor performance, commit time and resources to testing system performance. Two subsets of performance testing, load testing and stress testing, can determine the upper (close to capacity limit) and maximum (point of failure) limit, respectively, of the application's capacity. By performing these tests, you can determine the necessary infrastructure to support the anticipated workloads.

A best practice is to plan for a load buffer to accommodate random spikes without overloading the infrastructure. For example, if a normal system load is 100,000 requests per second, the infrastructure should support 100,000 requests at 80% of total capacity (i.e., 125,000 requests per second). If you anticipate that the application will continue to sustain 100,000 requests per second, and the current SKU (Stock Keeping Unit) introduces latency at 65,000 requests per second, you'll most likely need to upgrade your product to the next higher SKU. If there is a secondary region, you'll need to ensure that it also supports the higher SKU.

Depending on the scale of your performance test, you need to plan for and maintain a testing infrastructure. You can use a cloud-based tool, such as [Azure Load Testing Preview](/azure/load-testing/overview-what-is-azure-load-testing), to abstract the infrastructure needed to run your performance tests.

## Establish baselines
First, establish performance baselines for your application. Then, establish a regular cadence for running the tests. Run the test as part of a scheduled event or part of a continuous integration (CI) build pipeline.

Baselines help to determine the current efficiency state of your application and its supporting infrastructure. Baselines can provide good insights for improvements and determine if the application is meeting business goals. Baselines can be created for any application regardless of its maturity. No matter when you establish the baseline, measure performance against that baseline during continued development. When code and, or infrastructure changes, the effect on performance can be actively measured.

## Load testing

Load testing measures system performance as the workload increases. It identifies where and when your application breaks, so you can fix the issue before shipping to production. It does this by testing system behavior under typical and heavy loads.

Load testing takes places in stages of load. These stages are usually measured by virtual users (VUs) or simulated requests, and the stages happen over given intervals. Load testing provides insights into how and when your application needs to scale in order to continue to meet your SLA to your customers (whether internal or external). Load testing can also be useful for determining latency across distributed applications and microservices.

The following are key points to consider for load testing:

- **Know the Azure service limits:** Different Azure services have *soft* and *hard* limits associated with them. The terms soft limit and hard limit describe the current, adjustable service limit (soft limit) and the maximum limit (hard limit). Understand the limits for the services you consume so that you are not blocked if you need to exceed them. For a list of the most common Azure limits, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

  :::image type="icon" source="../../_images/github.png" border="false"::: The [ResourceLimits](https://github.com/mspnp/samples/tree/master/OperationalExcellence/ResourceLimits) sample shows how to query the limits and quotas for commonly used resources.

- **Measure typical loads:** Knowing the typical and maximum loads on your system helps you understand when something is operating outside of its designed limits.  Monitor traffic to understand application behavior.

- **Understand application behavior under various scales:** Load test your application to understand how it performs at various scales. First, test to see how the application performs under a typical load. Then, test to see how it performs under load using different scaling operations. To get additional insight into how to evaluate your application as the amount of traffic sent to it increases, see [Autoscale best practices](/azure/azure-monitor/platform/autoscale-best-practices).

## Stress testing

Unlike load testing, which ensures that a system can handle what it's designed to handle, stress testing focuses on overloading the system until it breaks. A stress test determines how stable a system is and its ability to withstand extreme increases in load. It does this by testing the maximum number requests from another service (for example) that a system can handle at a given time before performance is compromised and fails. Find this maximum to understand what kind of load the current environment can adequately support.

Determine the maximum demand you want to place on memory, CPU, and disk IOPS. Once a stress test has been performed, you will know the maximum supported load and an operational margin. It is best to choose an operational threshold so that scaling can be performed before the threshold has been reached.

Once you determine an acceptable operational margin and response time under typical loads, verify that the environment is configured adequately. To do this, make sure the SKUs that you selected are based on the desired margins. Be careful to stay as close as possible to your margins. Allocating too much can increase costs and maintenance unnecessarily; allocating too few can result in poor user experience.

In addition to stress testing through increased load, you can stress test by reducing resources to identify what happens when the machine runs out of memory. You can also stress test by increasing latency (e.g., the database takes 10x time to reply, writes to storage takes 10x longer, etc.).

## Multiregion testing

A multiregion architecture can provide higher availability than deploying to a single region. If a regional outage affects the primary region, you can use [Front Door](/azure/frontdoor/front-door-overview) to use the secondary region. This architecture can also help if an individual subsystem of the application fails.

Test the amount of time it would take for users to be rerouted to the paired region so that the region doesn't fail. To learn more about routing, see [Front Door routing methods](/azure/frontdoor/front-door-routing-methods#priority-based-traffic-routing). Typically, a planned test failover can help determine how much time would be required to fully scale to support the redirected load.

## Configure the environment based on testing results

Once you have performed testing and found an acceptable operational margin and response under increased levels of load, configure the environment to sustain performance efficiency. Scale out or scale in to handle increases and decreases in load. For example, you may know that you will encounter high levels of traffic during the day and low levels on weekends. You may configure the environment to scale out for increases in load or scale in for decreases before the load actually changes.

For more information on autoscaling, see [Design for scaling](./design-scale.md) in the Performance Efficiency pillar.

> [!NOTE]
> Ensure that a rule has been configured to scale the environment back down once load reaches below the set thresholds. This will save you money.

## Next steps

> [!div class="nextstepaction"]
> [Testing tools](./test-tools.md)
