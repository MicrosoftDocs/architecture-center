---
title: Design for reliability
description: Review a checklist for reliability in application design. Considerations include uptime (availability), high resiliency, low latency, and cost.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Design for reliability

Reliable applications should maintain a pre-defined percentage of uptime (*availability*). They should also balance between high resiliency, low latency, and cost (*High Availability*). Just as important, applications should be able to recover from failures (*resiliency*).

## Checklist

**How have you designed your applications with reliability in mind?**
***

> [!div class="checklist"]
> - Define availability and recovery targets to meet business requirements.
> - Build resiliency and availability into your apps by gathering requirements.
> - Ensure that application and data platforms meet your reliability requirements.
> - Configure connection paths to promote availability.
> - Use Availability Zones where applicable to improve reliability and optimize costs.
> - Ensure that your application architecture is resilient to failures.
> - Know what happens if the requirements of Service Level Agreements are not met.
> - Identify possible failure points in the system to build resiliency.
> - Ensure that applications can operate in the absence of their dependencies.

## Azure services

- [Azure Front Door](/azure/frontdoor/front-door-overview)
- [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview)
- [Service Fabric](/azure/service-fabric/service-fabric-overview)
- [Kubernetes Service (AKS)](/azure/aks/intro-kubernetes)
- [Azure Site Recovery](/azure/site-recovery/site-recovery-overview)

## Reference architecture

- [Deploy highly available network virtual appliances](../../reference-architectures/dmz/nva-ha.yml)
- [Failure Mode Analysis for Azure applications](../../resiliency/failure-mode-analysis.md)
- [Minimize coordination](../../guide/design-principles/minimize-coordination.md)

## Next step

> [!div class="nextstepaction"]
> [Target & non-functional requirements](./design-requirements.md)

## Related links

- [Use platform as a service (PaaS) options](../../guide/design-principles/managed-services.md)
- [Design to scale out](../../guide/design-principles/scale-out.md)
- [Workload availability targets](./business-metrics.md).
- [Building solutions for high availability using Availability Zones](../../high-availability/building-solutions-for-high-availability.md)
- [Make all things redundant](../../guide/design-principles/redundancy.md)
