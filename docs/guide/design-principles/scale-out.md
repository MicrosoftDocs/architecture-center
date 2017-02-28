---
title: Design to scale out
description: Cloud applications should be designed for horizontal scaling.
pnp.series.title: Cloud design principles
---

# Design to scale out

**Design your application so that it can scale horizontally, adding or removing new instances as demand requires.**

A primary advantage of the cloud is elastic scaling &mdash; the ability to use as much capacity as you need, scaling out as load increases, and scaling in when the extra capacity is not needed. Design your application so that it can scale horizontally, adding or removing new instances as demand requires.

## Examples

**Avoid instance stickiness**. Stickiness, or *session affinity*, is when requests from the same client are always routed to the same server. Stickiness limits the application's ability to scale out. For example, traffic from a high-volume user will not be distributed across instances. Causes of stickiness include storing session state in memory, and using machine-specific keys for encryption. Make sure that any instance can handle any request. 

**Use built-in autoscaling features**. [Azure App Service][app-service-autoscale], [VM Scale Sets][vmss-autoscale], and [Cloud Services][cloud-service-autoscale] all support autoscaling as a built-in feature of the service. If the application has a predictable, regular workload, scale out on a schedule. For example, scale out during business hours. Otherwise, if the workload is not predictable, use performance metrics such as CPU or request queue length to trigger autoscaling. For autoscaling best practices, see [Autoscaling][autoscaling].

**Identify bottlenecks**. Scaling out isn't a magic fix for every performance issue. For example, if your backend database is the bottleneck, it won't help to add more web servers. Identity and resolve the bottlenecks in the system first, before throwing more instances at the problem. Stateful parts of the system are the mostly likely cause of bottlenecks. 

**Consider aggressive auto-scaling for critical workloads**. For critical workloads, you want to keep ahead of demand. It's better to add new instances quickly under heavy load to handle the additional traffic, and then gradually scale back.

**Design for scale-in**.  Remember that with elastic scale, the application will have periods of scale in, when instances get removed. The application must gracefully handle instances being removed. Here are some ways to handle scale-in:

- Listen for shutdown events (when available) and shut down cleanly. 

- Clients/consumers of a service should support transient fault handling and retry. 

- For long-running tasks, consider breaking up the work, using checkpoints or the [Pipes and Filters][pipes-filters-pattern] pattern. 

- Put work items on a queue so that another instance can pick up the work, if an instance is removed mid-processing. 


<!-- links -->

[app-service-autoscale]: https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-scale
[autoscaling]: ../../best-practices/auto-scaling.md
[cloud-service-autoscale]: https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-how-to-scale
[pipes-filters-pattern]: ../../patterns/pipes-and-filters.md
[vmss-autoscale]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
