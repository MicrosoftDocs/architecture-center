---
title: Performance testing
description: Describes the testing considerations for performance efficiency
author: v-aangie
ms.date: 12/02/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you handling user load?
  - article
---

# Performance testing

Performance testing helps to maintain systems properly and fix defects before problems reach system users. It helps maintain the efficiency, responsiveness, scalability, and speed of applications when compared with business requirements. When done effectively, performance testing should give you the diagnostic information necessary to eliminate bottlenecks, which lead to poor performance. A bottleneck occurs when data flow is either interrupted or stops due to insufficient capacity to handle the workload.

To avoid experiencing poor performance, commit time and resources to testing system performance. Two subsets of performance testing, load testing and stress testing, can determine the upper (close to capacity limit) and maximum (point of failure) limit, respectively, of the application's capacity. By performing these tests, you can determine the necessary infrastructure to support the anticipated workloads. 

A best practice is to plan for a load buffer to accommodate random spikes without overloading the infrastructure. For example, if a normal system load is 100,000 requests per second, the infrastructure should support 100,000 requests at 80% of total capacity (i.e., 125,000 requests per second). If you anticipate that the application will continue to sustain 100,000 requests per second, and the current SKU introduces latency at 65,000 requests per second, you'll most likely need to upgrade your product to the next higher SKU. If there is a secondary region, you'll need to ensure that it also supports the higher SKU.

## Load testing

Load testing measures system performance as the workload increases. It identifies where and when your application breaks, so you can fix the issue before shipping to production. It does this by testing system behavior under typical and heavy loads. The following are key points to consider for load testing:

- **Know the Azure service limits** - Different Azure services have *soft* and *hard* limits associated with them. The terms soft limit and hard limit describe the current, adjustable service limit (soft limit) and the maximum limit (hard limit). Understand the limits for the services you consume so that you are not blocked if you need to exceed them. For a list of the most common Azure limits, see [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits).

  :::image type="icon" source="../../_images/github.png" border="false"::: The [ResourceLimits](https://github.com/mspnp/samples/tree/master/OperationalExcellence/ResourceLimits) sample shows how to query the limits and quotas for commonly used resources.

- **Understand application behavior under load** - Load test your application to understand how it performs at various scales. To get additional insight into how to evaluate your application as the amount of traffic sent to it increases, see [Autoscale best practices](https://docs.microsoft.com/azure/azure-monitor/platform/autoscale-best-practices).

- **Measure typical loads** - Knowing the typical and maximum loads on your system helps you understand when something is operating outside of its designed limits.  Monitor traffic to your application to understand user behavior.

- **Caching** - Applications should implement a strategy that helps to ensure that the data in the cache is as up to date as possible. The strategy should also detect and handle situations that arise when the data in the cache has become stale. This strategy can improve performance. Also, it can help to maintain consistency between data held in the cache and data in the underlying data store. To learn how to load data on demand into a cache from a data store, see [Cache-Aside pattern](https://docs.microsoft.com/azure/architecture/patterns/cache-aside).

- **Plan according to SKU Availability** - Certain Azure SKUs are available only in certain regions. Understand which SKUs are available in the regions you operate in so you can plan accordingly. To see which regions support specific products, see [Products available by region](https://azure.microsoft.com/global-infrastructure/services/).

Use [Azure Advisor](https://azure.microsoft.com/services/advisor/) to optimize your Azure deployments. Azure Advisor analyzes your configurations and usage telemetry. It offers personalized, actionable recommendations to help you optimize your Azure resources for performance, reliability, security, operational excellence, and cost.

## Stress testing

Unlike load testing, which ensures that a system can handle what it’s designed to handle, stress testing focuses on overloading the system until it breaks. A stress test determines how stable a system is and its ability to withstand extreme increases in load. It does this by testing the maximum number of users a system can handle at a given time before performance is compromised and fails. Find this maximum to understand what kind of load the current environment can adequately support.

Determine the maximum demand you want to place on resources. Consider memory, CPU, and disk IOPS in your decision. Once a stress test has been performed resulting in the maximum supported load and an operational margin has been chosen, it is best to choose an operational threshold. Then, environment scaling can be performed after the threshold has been reached.

Once you determine an acceptable operational margin and response time under typical loads, verify that the environment is configured adequately. To do this, make sure the SKUs that you selected are based on the desired margins. Be careful to stay as close as possible to your margins. Allocating too much can increase costs and maintenance unnecessarily; allocating too few can result in poor user experience.

## Multiregion testing

A multiregion architecture can provide higher availability than deploying to a single region. If a regional outage affects the primary region, you can use [Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview) to fail over to the secondary region. This architecture can also help if an individual subsystem of the application fails.

Test the amount of time it would take for users to fail over to the paired region so that the region doesn't fail. You should know how long it would take for users to be rerouted from a failed region. To learn more about routing, see [Front Door routing methods](https://docs.microsoft.com/azure/frontdoor/front-door-routing-methods#priority-based-traffic-routing). Typically, a planned test failover can help determine how much time would be required to fully scale to support the redirected load. Based on the recovery time (i.e., time required to scale), you can plan for unforeseen outages adequately.

## Configure the environment based on testing results

Once you have performed testing and found an acceptable operational margin and response under increased levels of load, configure the environment to sustain performance efficiency. Scale out or scale in to handle increases and decreases in load. For example, you may know that you will encounter high levels of traffic during the day and low levels on weekends. You may configure the environment to scale out for increases in load or scale in for decreases before the load actually changes.

For more information on autoscaling, see *Design for scaling* in the Performance Efficiency pillar. <!--Add link -->

> [!NOTE]
> Ensure that a rule has been configured to scale the environment back down once load reaches below the set thresholds. This will save you money.

## Next steps

>[!div class="nextstepaction"]
>[Testing tools](https://docs.microsoft.com/azure/architecture/framework/scalability/testing-tools)