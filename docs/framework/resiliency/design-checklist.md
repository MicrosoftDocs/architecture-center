---
title: Design for reliability
description: Describes considerations for reliability in application design.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Design for reliability

Reliable applications should maintain a pre-defined percentage of uptime (*availability*). They should also balance between high resiliency, low latency, and cost (*High Availability*). Just as important, applications should be able to recover from failures (*resiliency*).

## Checklist

**How have you designed your applications with reliability in mind?**
***

> [!div class="checklist"]
> - Define availability and revovery targets to meet business requirements.
> - Build resiliency and availability into your apps by gathering requirements.
> - Ensure that application and data platforms meet your reliability requirements.
> - Configure connection paths to promote availability.
> - Use Availability Zones where applicable to improve reliability and optimize costs.
> - Ensure that your application architecture is resilient to failures.
> - Know what happens if the requirements of Service Level Agreements are not met.
> - Identify possible failure points in the system to build resiliency.
> - Ensure that applications can operate in the absence of their dependencies.
  
## In this section

Follow these questions to assess the workload at a deeper level.

| Assessment | Description |
| ------------- | ------------- |
| [How will you design Azure applications to ensure reliability?](/azure/architecture/framework/resiliency/app-design) | Consider how systems use Availability Zones, perform scalability, respond to failure, and other strategies that optimize reliability in application design.
| [What decisions have been taken to ensure that reliability requirements are met?](/azure/architecture/framework/resiliency/design-requirements) | Target and non-functional requirements such as availability and recovery targets allow you to measure the uptime and downtime of your workloads.
| [Have you identified all possible failure points and dependencies for applications?](/azure/architecture/framework/resilirncy/design-resiliency) | Validate that the application can operate effectively in the absence of its dependencies, and minimize downtime.

## Azure services

- [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview)
- [Azure Traffic Manager](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview)
- [Azure Load Balancer](https://docs.microsoft.com/azure/load-balancer/load-balancer-overview)
- [Service Fabric](https://docs.microsoft.com/azure/service-fabric/service-fabric-overview)
- [Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes)
- [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview)

## Reference architecture

- [Deploy highly available network virtual appliances](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/nva-ha)
- [Failure Mode Analysis for Azure applications](https://docs.microsoft.com/azure/architecture/resiliency/failure-mode-analysis)
- [Minimize coordination](https://docs.microsoft.com/azure/architecture/guide/design-principles/minimize-coordination)

## Next step

>[!div class="nextstepaction"]
>[Target & non-functional requirements](/azure/architecture/framework/resiliency/design-requirements)

## Related links

- [Use platform as a service (PaaS) options](https://docs.microsoft.com/azure/architecture/guide/design-principles/managed-services)  
- [Design to scale out](/azure/architecture/guide/design-principles/scale-out)
- [Workload availability targets](/azure/architecture/framework/resiliency/business-metrics).
- [Building solutions for high availability using Availability Zones](https://docs.microsoft.com/azure/architecture/high-availability/building-solutions-for-high-availability)
- [Make all things redundant](https://docs.microsoft.com/azure/architecture/guide/design-principles/redundancy) 
