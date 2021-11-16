---
title: Design reliable Azure applications
description: Review the design considerations for making sure that Azure applications are reliable and resilient to failure.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How have you ensured that your application is resilient to failures?
  - article
---

# Design reliable Azure applications

Building a reliable application in the cloud is different from traditional application development. While historically you may have purchased levels of redundant higher-end hardware to minimize the chance of an entire application platform failing, in the cloud, we acknowledge up front that failures will happen. Instead of trying to prevent failures altogether, the goal is to minimize the effects of a single failing component. Failures you can expect here are inherent to highly distributed systems, not a feature of Azure.

## Key Points

- Use Availability Zones where applicable to improve reliability and optimize costs.
- Design applications to operate when impacted by failures.
- Use the native resiliency capabilities of PaaS to support overall application reliability.
- Design to scale out.
- Validate that required capacity is within Azure service scale limits and quotas.

## Use Availability Zones within a region

If your requirements demand an even greater failure isolation than Availability Zones alone can offer, consider deploying to multiple regions. Multiple regions should be used for failover purposes in a disaster state. Additional cost needs to be taken into consideration. Examples of cost needs are data and networking, and services such as Azure Site Recovery.

Design your application architecture to use *Availability Zones* within a region. Availability Zones can be used to optimize application availability within a region by providing datacenter level fault tolerance. However, the application architecture must not share dependencies between zones to use them effectively.

> [!NOTE]
> Availability Zones may introduce performance and cost considerations for applications which are extremely "chatty" across zones given the implied physical separation between each zone and inter-zone bandwidth charges. This also means that Availability Zones can be considered to get higher SLA for lower cost.

Consider if component proximity is required for application performance reasons. If all or part of the application is highly sensitive to latency, it may mandate component co-locality which can limit the applicability of multi-region and multi-zone strategies.

## Respond to failure

Avoiding failure is impossible in the public cloud, and as a result applications require resilience to respond to outages and deliver reliability. The application should therefore be designed to operate even when impacted by regional, zonal, service or component failures across critical application scenarios and functionality. Application operations may experience reduced functionality or degraded performance during an outage.

Define an availability strategy to capture how the application remains available when in a failure state. It should apply across all application components and the application deployment stamp as a whole such as via multi-geo scale-unit deployment approach. There are cost implications as well: More resources need to be provisioned in advance to provide high availability. Active-active setup, while more expensive than single deployment, can balance cost by lowering load on one stamp and reducing the total amount of resources needed.

In addition to an availability strategy, define a Business Continuity Disaster Recovery (BCDR) strategy for the application and/or its key scenarios. A disaster recovery strategy should capture how the application responds to a disaster situation such as a regional outage or the loss of a critical platform service, using either a re-deployment, warm-spare active-passive, or hot-spare active-active approach.

To drive cost down consider splitting application components and data into groups. For example:

- Must protect
- Nice to protect
- Ephemeral/can be rebuilt/lost, instead of protecting all data with the same policy

## Considerations for improving reliability

**Is the application designed to use managed services?**
***

Azure-managed services provide native resiliency capabilities to support overall application reliability. Platform as a service (PaaS) offerings should be used to leverage these capabilities. PaaS options are easier to configure and administer. You don't need to provision VMs, set up VNets, manage patches and updates, and all of the other overhead associated with running software on a VM. To learn more, see [Use managed services](../../guide/design-principles/managed-services.md).

**Has the application been designed to scale out?**
***

Azure provides elastic scalability and you should design to scale out. However, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally. Don't forget about scale in, which is important to drive cost down. For example, scale in and out for App Service is done via rules. Often customers write scale out rules and never write scale in rules. This leaves the App Service more expensive.

**Is the application deployed across multiple Azure subscriptions?**
***

Understanding the subscription landscape of the application and how components are organized within or across subscriptions is important when analyzing if relevant subscription limits or quotas can be navigated. Review Azure subscription and service limits to validate that required capacity is within Azure service scale limits and quotas. To learn more, see [Azure subscription and service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits).

## Next step

> [!div class="nextstepaction"]
> [Resiliency and dependencies](./design-resiliency.md)

## Related links

- For information on minimizing dependencies, see [Minimize coordination](../../guide/design-principles/minimize-coordination.md).
- For more information on fault-points and fault-modes, see [Failure Mode Analysis for Azure applications](../../resiliency/failure-mode-analysis.md).
- For information on managed services, see [Use platform as a service (PaaS) options](../../guide/design-principles/managed-services.md).

> Go back to the main article: [Design](design-checklist.md)
