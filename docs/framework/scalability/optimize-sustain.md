---
title: Sustain performance efficiency over time
description: Learn to sustain performance efficiency over time. Optimize autoscaling, separate out critical workload, right-size your resources, and remote antipatterns.
author: v-aangie
ms.date: 01/11/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
categories:
  - management-and-governance
---

# Sustain performance efficiency over time

Performance is an indication of the responsiveness of a system to execute any action within a given time interval. As workloads and requirements change over time, you need to continuously ensure that systems do not start to under-perform. This article explains some steps you can take to help make sure your systems are continuously running at an optimum level.

## Optimize autoscaling

[Autoscaling](./design-scale.md#use-autoscaling-to-manage-load-increases-and-decreases) is the process of dynamically allocating resources to match performance requirements. As the volume of work grows, an application may need additional resources to maintain the desired performance levels and satisfy service-level agreements (SLAs). As demand slackens and the additional resources are no longer needed, they can be de-allocated to minimize costs.

To prevent a system from attempting to scale out excessively, and to avoid the costs associated with running many thousands of instances, consider limiting the maximum number of instances that can be automatically added. Most autoscaling mechanisms allow you to specify the minimum and maximum number of instances for a rule. In addition, consider gracefully degrading the functionality that the system provides if the maximum number of instances have been deployed, and the system is still overloaded.

Autoscaling might not always be the most appropriate mechanism to handle a sudden burst in workload. It takes time to provision and start new instances of a service or add resources to a system, and the peak demand may have passed by the time these additional resources have been made available. In this scenario, it may be better to throttle the service. For more information, see [Throttling pattern](../../patterns/throttling.md).

Conversely, if you do need the capacity to process all requests when the volume fluctuates rapidly, and cost isn't a major contributing factor, consider using an aggressive autoscaling strategy that starts additional instances more quickly. You can also use a scheduled policy that starts a sufficient number of instances to meet the maximum load before that load is expected.

## Separate out critical workload

Some data is accessed more frequently than other data. If you store data in its own partition depending on its usage pattern, your system can run more efficiently. Operations that affect more than one partition can run in parallel.

[Partitioning](./optimize-partition.md) data can improve the availability of applications by ensuring that the entire dataset does not constitute a single point of failure and that subsets of the dataset can be managed independently. This is an important reason why you might want to separate out critical workload from non-critical. If one instance fails, only the data in that partition is unavailable. Operations on other partitions can continue. For managed PaaS data stores, this consideration is less relevant, because these services are designed with built-in redundancy.

To learn more, see [Data partitioning](../../best-practices/data-partitioning.md).

## Right-size your resources

Changes to the resources that support a workload may impact the architecture of the workload. When this happens, additional considerations are required to minimize the impact on end users and business functions. One of these considerations is right-sizing, which is about controlling cost by continuously monitoring and adjusting size of your instances to meet needs. Cost shouldn't necessarily be the main decision-making factor. Choosing the least expensive option could expose the workload to performance and availability risks.

Follow the best practices in this section below to achieve right-sizing.

### For accountability purposes

Identify right-size opportunities by reviewing your current resource utilization and performance requirements across the environment. Then, modify each resource to use the smallest instance or SKU that can support the performance requirements of each resource.

For additional best practices, see [Best practices by team and accountability](/azure/cloud-adoption-framework/govern/cost-management/best-practices#best-practices-by-team-and-accountability).

### For operational cost management purposes

Identify right size opportunities by reviewing your current resource utilization and performance requirements across the environment. Then, identify resources which have remained underutilized for a period of time (generally more than 90 days). Also, right-size provisioned SKUs by modifying underutilized resources to use the smallest instance or SKU that can support the performance requirements of each resource. Finally, right-size redundancy. If the resource doesn't require a high degree of redundancy, remove geo-redundant storage.

For additional best practices, see [Operational cost management best practices](/azure/cloud-adoption-framework/govern/cost-management/best-practices#operational-cost-management-best-practices).

### Right-size VMs

When considering costing and sizing resources hosted in Azure, right-sizing VMs is a best practice. Choosing the right storage type for data can save your organization several thousands of dollars every month. Microsoft offers many options when you deploy Azure VMs to support workloads. Each VM type has specific features and different combinations of CPU, memory, and disks.

To learn more about VM types, see [Best practice: Right-size VMs](/azure/cloud-adoption-framework/govern/cost-management/best-practices#best-practice-right-size-vms).

## Remove antipatterns

A performance antipattern is a common practice that is likely to cause scalability problems when an application is under pressure. Examples of some common antipatterns occur when a system offloads too much processing to a data store, moves resource-intensive tasks onto background threads, continually sends many small network requests, or fails to cache data. Antipatterns can cause decreased response time, high latency, slow I/O calls, and other performance issues.

Many factors can cause an antipattern to occur. Sometimes an application inherits a design that worked on-premises, but doesn't scale in the cloud. Or, an application might start with a very clean design, but as new features are added, one or more of these antipatterns creeps in.

Removing antipatterns can improve performance efficiency. This is not a straight-forward task, as sometimes the problem only manifests under certain circumstances. Instrumentation and logging are key to finding the root cause, but you also have to know what to look for. To learn more about common antipatterns and how to identify and fix them, see [Catalog of antipatterns](../../antipatterns/index.md#catalog-of-antipatterns).
