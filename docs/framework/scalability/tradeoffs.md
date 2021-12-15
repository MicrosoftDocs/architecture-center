---
title: Tradeoffs for performance efficiency
description: Discover the pros and cons of performance optimization. Learn about tradeoffs between performance efficiency, operational excellence, reliability, scalability, and more.
author: v-aangie
ms.date: 01/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cost-management
  - azure-security-center
  - azure-monitor
categories:
  - management-and-governance
subject:
  - security
  - monitoring
ms.custom:
  - What scalability tradeoffs are you making?
  - article
  - seo-aac-fy21q3
keywords:
  - Performance efficiency
  - cost efficiency
  - performance optimization
  - operational excellence
---

# Tradeoffs for performance efficiency

As you design the workload, consider tradeoffs between performance optimization and other aspects of the design, such as cost efficiency, operability, reliability, and security.

## Performance efficiency vs. cost efficiency

Cost can increase as a result of boosting performance. Here are a few factors to consider when optimizing for performance and how they impact cost:

- Avoid cost estimation of a workload at consistently high utilization. Consumption-based pricing will be more expensive than the equivalent provisioned pricing. Smooth out the peaks to get a consistent flow of compute and data. Ideally, use manual and autoscaling to find the right balance. Scaling up is generally more expensive than scaling out.

- Cost scales directly with number of regions. Locating resources in cheaper regions shouldn't negate the cost of network ingress and egress or degraded application performance because of increased latency.

- Every render cycle of a payload consumes both compute and memory. You can use caching to reduce load on servers and save with pre-canned storage and bandwidth costs. The savings can be dramatic, especially for static content services.

  - While caching can reduce cost, there are some performance tradeoffs. For example, Azure Traffic Manager pricing is based on the number of DNS (Domain Name Service) queries that reach the service. You can reduce that number through caching and configure how often the cache is refreshed. Relying on the cache that isn't frequently updated will cause longer user failover times if an endpoint is unavailable.

- Using dedicated resources for batch processing long running jobs will increase the cost. You can lower cost by provisioning Spot VMs but be prepared for the job to be interrupted every time Azure evicts the VM.

For cost considerations, see the [Cost Optimization](../cost/index.yml) pillar.

## Performance efficiency vs. operational excellence

As you determine how to scale your workload to meet the demands placed on it by users in an efficient manner, consider the operations processes that are keeping an application running in production. To achieve operational excellence with these processes, make sure the deployments remain reliable and predictable. They should be automated to reduce the chance of human error. They should be a fast and routine process, so they don't slow down the release of new features or bug fixes. Equally important, you must be able to quickly roll back or roll forward if an update has problems.

### Automated performance testing

One operational process that can help to identify performance issues early is [automated performance testing](../../checklist/dev-ops.md#testing). The impact of a serious performance issue can be as severe as a bug in the code. While automated functional tests can prevent application bugs, they might not detect performance problems. Define acceptable performance goals for metrics such as latency, load times, and resource usage. Include automated performance tests in your release pipeline, to make sure the application meets those goals.

### Fast builds

Another operational efficiency process is making sure that your product is in a deployable state through a fast [build](../devops/release-engineering-performance.md#build-times) process. Builds provide crucial information about the status of your product.

The following can help faster builds:

- Select the right size of VMs.
- Ensure that the build server is located near the sources and a target location, so it can reduce the duration of your build considerably.
- Scale-out build servers.
- Optimizing the build.

For an explanation of these items, see [Builds](../devops/release-engineering-performance.md#build-times).

### Monitoring performance optimization

As you consider making performance improvements, monitoring should be done to verify that your application is running correctly. Monitoring should include the application, platform, and networking. To learn more, see [Monitoring](../devops/monitoring.md).

For operational considerations, see the [Operational Excellence](../devops/overview.md) pillar.

## Performance efficiency vs. reliability

We acknowledge up front that failures will happen. Instead of trying to prevent failures altogether, the goal is to minimize the effects of a single failing component.

Reliable applications are *resilient* and *highly available* (HA). Resiliency allows systems to recover gracefully from failures, and they continue to function with minimal downtime and data loss before full recovery. HA systems run as designed in a healthy state with no significant downtime. Maintaining reliability enables you to maintain performance efficiency.

Some reliability considerations are:

- Use the [Circuit Breaker](../../patterns/circuit-breaker.md) pattern to provide stability while the system recovers from a failure and minimizes the impact on performance.

- Achieve levels of scale and performance needed for your solution by segregating read and write interfaces by implementing the [CQRS pattern](../../patterns/cqrs.md).

- Often, you can achieve higher availability by adopting an *eventual consistency* model. To learn about selecting the correct data store, see [Use the best data store for the job](../../guide/design-principles/use-the-best-data-store.md).

- If your application requires more storage accounts than are currently available in your subscription, create a new subscription with additional storage accounts. For more information, see [Scalability and performance targets](/azure/storage/common/scalability-targets-standard-account).

- Avoid scaling up or down. Instead, select a tier and instance size that meet your performance requirements under typical load, and then scale out the instances to handle changes in traffic volume. Scaling up and down may trigger an application restart.

- Create a separate storage account for logs. Don't use the same storage account for logs and application data. This helps to prevent logging from reducing application performance.

- Monitor performance. Use a performance monitoring service such as [Application Insights](/azure/azure-monitor/app/app-insights-overview) or [New Relic](https://newrelic.com/) to monitor application performance and behavior under load. Performance monitoring gives you real-time insight into the application. It enables you to diagnose issues and perform root-cause analysis of failures.

For resiliency, availability, and reliability considerations, see the [Reliability](../resiliency/principles.md) pillar.

## Performance efficiency vs. security

If performance is so poor that the data is unusable, you can consider the data to be inaccessible. From a security perspective, you need to do whatever you can to make sure that your services have optimal uptime and performance.

A popular and effective method for enhancing availability and performance is load balancing. Load balancing is a method of distributing network traffic across servers that are part of a service. It helps performance because the processor, network, and memory overhead for serving requests are distributed across all the load-balanced servers. We recommend that you employ load balancing whenever you can, and as appropriate for your services. For information on load balancing scenarios, see [Optimize uptime and performance](/azure/security/fundamentals/network-best-practices#optimize-uptime-and-performance).

Consider these security measures, which impact performance:

- To optimize performance and maximize availability, application code should first try to get OAuth access tokens silently from a cache before attempting to acquire a token from the identity provider. OAuth is a technological standard that allows you to securely share information between services without exposing your password.

- Ensure that you are integrating critical security alerts and logs into SIEMs (security information and event management) without introducing a high volume of low value data. Doing so can increase SIEM cost, false positives, and lower performance. For more information, see [Prioritize alert and log integration](../security/monitor-logs-alerts.md).

- Use Azure AD Connect to synchronize your on-premises directory with your cloud directory. There are factors that affect the performance of Azure AD Connect. Ensure Azure AD Connect has enough capacity to keep underperforming systems from impeding security and productivity. Large or complex organizations (organizations provisioning more than 100,000 objects) should follow the [recommendations](/azure/active-directory/hybrid/whatis-hybrid-identity) to optimize their Azure AD Connect implementation.

- If you want to gain access to real time performance information at the packet level, use [packet capture](/azure/network-watcher/network-watcher-alert-triggered-packet-capture) to set alerts.

For other security considerations, see the [Security](../security/overview.md) pillar.
