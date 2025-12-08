---
title: Design to scale out
description: Use these recommendations to design your applications for horizontal scaling, which is the ability to use as much capacity as the application needs.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2023
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Design to scale out

## Design your application so that it can scale horizontally

A primary advantage of the cloud is elastic scaling &mdash; the ability to use as much capacity as you need, scaling out as load increases, and scaling in when the extra capacity isn't needed. Design your application so that it can scale horizontally, adding or removing instances, matching supply to demand.

Scalability is measured by the ratio of throughput gain to resource increase. Ideally in a well-designed system, both numbers are proportional: a twofold allocation of resources will double the throughput. Scalability is typically limited by the introduction of bottlenecks or synchronization points within the system.

## Recommendations

**Avoid instance stickiness**. Stickiness, or *session affinity*, is when requests from the same client are always routed to the same server. Stickiness limits the application's ability to scale out. For example, traffic from a high-volume user will not be distributed across instances. Causes of stickiness include storing session state in memory, and using machine-specific keys for encryption. Make sure that any instance can handle any request.

**Identify bottlenecks**. Scaling out isn't a magic fix for every performance issue. For example, if your backend database is the bottleneck, it won't help to add more web servers. Identify and resolve the bottlenecks in the system first, before throwing more instances at the problem. Stateful parts of the system are the most likely cause of bottlenecks.

**Decompose workloads by scalability requirements.**  Applications often consist of multiple workloads, with different requirements for scaling. For example, an application might have a public-facing site and a separate administration site. The public site might experience sudden surges in traffic, while the administration site has a smaller, more predictable load.

**Design autonomous and decoupled components that communicate through asynchronous communication protocols.** Ideally, components should have their own, independent state and use events to communicate any change or activity to outside components. This helps to independently scale only the overloaded component. Implement flow control mechanisms to manage traffic and to degrade gracefully. Consumers should control their own rate of consumption. Producers should control their own rate of transmission, including halting. Message queues are good options to absorb extra workload and to allow consumers to drain the work at their leisure.

**Avoid needless communication, coordination, and waiting.**

**Offload naturally asynchronous tasks.** Tasks like sending emails, actions where the user doesn't need an immediate response, and integration with other systems are all good places to make use of [asynchronous messaging patterns](/dotnet/architecture/microservices/architect-microservice-container-applications/asynchronous-message-based-communication).

**Offload resource-intensive tasks.** Tasks that require intensive CPU or I/O resources should be moved to [background jobs][background-jobs] when possible, to minimize the load on the front end that handles user requests.

**Autoscale based on live usage metrics and use built-in autoscaling features**. Many Azure compute services have built-in support for autoscaling. If the application has a predictable, regular workload, scale out on a schedule. For example, scale out during business hours. Otherwise, if the workload isn't predictable, use performance metrics such as CPU or request queue length to trigger autoscaling. Observe applications and their communications to identify bottlenecks and to derive more accurate decisions. For autoscaling best practices, see [Autoscaling][autoscaling].

**Consider aggressive autoscaling for critical workloads**. For critical workloads, you want to keep ahead of demand. It's better to add new instances quickly under heavy load to handle the additional traffic, and then gradually scale back.

**Design for scale in**.  Remember that with elastic scale, the application will have periods of scale in, when instances get removed. The application must gracefully handle instances being removed. Here are some ways to handle scalein:

- Listen for shutdown events (when available) and shut down cleanly.
- Clients/consumers of a service should support transient fault handling and retry.
- For long-running tasks, consider breaking up the work, using checkpoints or the [Pipes and Filters][pipes-filters-pattern] pattern.
- Put work items on a queue so that another instance can pick up the work, if an instance is removed in the middle of processing.

**Consider scaling for redundancy.** Scaling out can improve your application's reliability. For example, consider scaling out across multiple [availability zones](/azure/reliability/availability-zones-overview), such as by using zone-redundant services. This approach can improve your application's throughput as well as provide resiliency if one zone experiences an outage.

**Model and optimize your system's scalability.** You can use model your system using an approach such as [Amdahl's law](https://wikipedia.org/wiki/Amdahl's_law). Quantify scalability based on parameters such as contention and coherency.  Contention refers to delay due to waiting or queueing for shared resources. Coherence refers to delay for data to become consistent. For example, having a high contention indicates sequential processing that could be parallelized, while having a high coherency suggests excessive dependencies among processes, prompting you to minimize interactions. During workload design, you can calculate the maximum effective capacity of your system to avoid providing [more supply than demand which leads to waste](/azure/well-architected/cost-optimization/optimize-scaling-costs#optimize-demand-and-supply).

## Related resources

- [Autoscaling](/azure/architecture/best-practices/auto-scaling)
- [Asynchronous messaging patterns](/dotnet/architecture/microservices/architect-microservice-container-applications/asynchronous-message-based-communication)
- [Background jobs](/azure/architecture/best-practices/background-jobs)
- [Pipes and Filters pattern](/azure/architecture/patterns/pipes-and-filters)

<!-- links -->

[autoscaling]: ../../best-practices/auto-scaling.md
[background-jobs]: ../../best-practices/background-jobs.md
[pipes-filters-pattern]: ../../patterns/pipes-and-filters.yml
