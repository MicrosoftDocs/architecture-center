---
title: Performance
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you thinking about Performance? 
---

# Performance

## Defining performance goals

Defining performance goals allows you to build architecture that aligns to your business needs.  Learn More: [/azure/architecture/antipatterns/](/azure/architecture/antipatterns/)

## Horizontal Scaling

Horizontal scaling allows you to dynamically add and remove resources based on demand.

Read more about [Auto-scaling](/azure/architecture/best-practices/auto-scaling).

## Scaling down when load decreases

Scaling in removes unused resources when they become idle.

## Performance Bottlenecks

Understanding your performance bottlenecks is critical for designing systems that will have variable throughput over time. Review [architecture anti-patterns](/azure/architecture/antipatterns/) to avoid common pitfalls when building solutions.

## Throttling

Learn More: [/azure/architecture/patterns/throttling](/azure/architecture/patterns/throttling)

## Idempotency

If a worker crashes in the middle of an operation, another worker simply picks up the work item.

Learn More: [/azure/architecture/guide/design-principles/scale-out](/azure/architecture/guide/design-principles/scale-out)

## Failure handling

In a distributed system, failures happen. Hardware can fail. The network can have transient failures. Review [Design for self-healing](/azure/architecture/guide/design-principles/self-healing) to learn more about gracefully handling failures.