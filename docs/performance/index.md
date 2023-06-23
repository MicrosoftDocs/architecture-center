---
title: Performance tuning a distributed app
titleSuffix: Azure Architecture Center
description: Learn how to performance tune a distributed application by walking through several scenarios that use load tests and metrics to diagnose performance issues.
author: martinekuan
ms.author: architectures
ms.date: 07/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
azureCategories: compute
categories: compute
products: azure
ms.custom:
  - article
---

# Performance tuning a distributed application

In this series, we walk through several cloud application scenarios, showing how a development team used load tests and metrics to diagnose performance issues. These articles are based on our load testing when developing example applications. The code for each scenario is available on GitHub.

Scenarios:

- [Distributed business transaction](./distributed-transaction.yml)
- [Calling multiple backend services](./backend-services.yml)
- [Event stream processing](./event-streaming.yml)

## What is performance?

Performance is frequently measured in terms of throughput, response time, and availability. Performance targets should be based on business operations. Customer-facing tasks, such as generating reports, may have more stringent requirements than operational tasks.

Define a service level objective (SLO) that defines performance targets for each workload. You typically achieve this by breaking a performance target into a set of Key Performance Indicators (KPIs), such as:

- Latency or response time of specific requests
- The number of requests performed per second
- The rate at which the system generates exceptions.

Performance targets should explicitly include a target load. Also, not all users will receive precisely the same level of performance, even when accessing the system simultaneously and performing the same work. So an SLO should be framed in terms of percentiles.

An example SLO might be: "Client requests will have a response within 500 ms @ P90, at loads up to 25 K requests/second."

## Challenges of performance tuning a distributed system

It can be especially challenging to diagnose performance issues in a distributed application. Some of the challenges are:

- A single business transaction or operation typically involves multiple system components. Getting a holistic end-to-end view of a single operation can be challenging.

- Resource consumption is distributed across multiple nodes. You need to aggregate logs and metrics in one place to get a consistent view.

- The cloud offers an elastic scale. Autoscaling is an essential technique for handling spikes in load, but it can also mask underlying issues. Also, it can take a lot of work to know which components need to scale and when.

- Cascading failures can cause failures upstream of the root problem. As a result, the first signal of the problem may appear in a different component than the root cause.

## General best practices

Performance tuning is both an art and a science, but it can be made closer to science by taking a systematic approach. Here are some best practices:

- Enable telemetry to collect metrics. Instrument your code. Follow [best practices for monitoring](../best-practices/monitoring.yml). Use correlated tracing to view all the steps in a transaction.

- Monitor the 90/95/99 percentiles, not just the average. The average can mask outliers. The sampling rate for metrics also matters. If the sampling rate is too low, it can hide spikes or outliers that might indicate problems.

- Attack one bottleneck at a time. Form a hypothesis and test it by changing one variable at a time. Removing one bottleneck will often uncover another bottleneck further upstream or downstream.

- Errors and retries can have a significant impact on performance. If you see that backend services are throttling you, scale out or try to optimize usage (for example, by tuning database queries).

- Look for common [performance anti-patterns](../antipatterns/index.md).

- Look for opportunities to parallelize. Two common sources of bottlenecks are message queues and databases. In both cases, sharding can help. For more information, see [Horizontal, vertical, and functional data partitioning](../best-practices/data-partitioning.yml). Look for hot partitions that might indicate imbalanced read or write loads.

## Next steps

Read the performance-tuning scenarios.

- [Distributed business transaction](./distributed-transaction.yml)
- [Calling multiple backend services](./backend-services.yml)
- [Event stream processing](./event-streaming.yml)
