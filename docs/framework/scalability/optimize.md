---
title: Optimize scalability and reliability of cloud applications
description: Determine options for improvement based on the monitored data.
author: PageWriter-MSFT
ms.date: 04/28/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
categories:
  - management-and-governance    
ms.custom:
  - fasttrack-edit
---
# Optimize for scalability and reliability
Resolving performance issues requires time and patience&mdash;not just in discovery and investigation, but also in resolution. Code enhancements may be accomplished by deploying a new build, but enhancements to infrastructure may involve many teams. Some services may require updated configurations while others may need to be deprecated in favor of more-appropriate solutions. Regardless, it is critical that you understand the scope of your planned resolution so that all necessary stakeholders are informed.
## Checklist
> [!div class="checklist"]
> - Use caching whenever possible, whether it is client-side caching, view caching, or data caching.
> - Partition data to optimize performance, improve scalability, and reduce contention by lowering the taxation of database operations.
> - Prevent a system from attempting to scale out excessively. Gracefully degrading the functionality that the system provides if the maximum number of instances have been deployed, and the system is still overloaded. 
> - Improve the reliability of your workloads by implementing high availability, disaster recovery, backup, and monitoring in Azure.

## In this section

Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**Has caching and queuing been considered to handle varying load?**](optimize-cache.md)|Caching and queuing offers ways to handle heavy load in read and write scenarios, respectively. However, their usage must be carefully considered as this may mean that data is not fresh and writes to not happen instantly. This could create a scenario of eventual consistency and stale data.|
|[**Are you using database replicas and data partitioning?**](optimize-partition.md)|Collect platform metrics and logs to get visibility into the health and performance of services that are part of the architecture.|
|[**Has autoscaling been tested under sustained load?**](optimize-sustain.md))|Implement a unified solution to aggregate and query application and resource level logs, such as Azure Log Analytics.|
|[**Are the right sizes and SKUs used for workload services?**](design-capacity.md#choose-the-right-resources)|The required performance and infrastructure utilization are key factors which define the 'size' of Azure resources to be used, but there can be hidden aspects that affect cost too. Once the purchased SKUs have been identified, determine if they purchased resources have the capabilities of supporting anticipated load.|
|[**Is the application implemented with strategies for resiliency and self-healing?**](performance-efficiency-patterns.md)|Consider implementing strategies and capabilities for resiliency and self-healing needed to achieve workload availability targets. Programming paradigms such as retry patterns, request timeouts, and circuit breaker patterns can improve application resiliency by automatically recovering from transient faults.|

## Next section


Compare your code to proven architectures. By referencing the design patterns, you can avoid common mistakes by developers who are deploying applications into the cloud. Finally, you may consider other Azure services that may be more appropriate for your objectives. While Azure has many services that seem to overlap in capabilities, often there are specific use-cases for which the services are designed.

> [!div class="nextstepaction"] 
> [Performance Efficiency patterns](performance-efficiency-patterns.md)

## Related links
> [Back to the main article](overview.md)