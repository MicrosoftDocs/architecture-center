---
title: Capacity
description: Make sure your Azure architecture provides sufficient capacity. Use content delivery networks (CDNs), and choose the right resources and metrics.
author: david-stanford
ms.date: 10/16/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-blob-storage
ms.custom:
  - How are you ensuring you have sufficient Capacity?
  - article
---

# Capacity

## Content Delivery Networks (CDN)

With CDNs, you can cache static objects loaded from Azure Blob storage, a web application, or any publicly accessible web server, by using the closest point of presence (POP) server. CDNs can also accelerate dynamic content, which cannot be cached, by leveraging various network and routing optimizations. If you are not familiar with CDN's review [What is a content delivery network on Azure](/azure/cdn/cdn-overview) to get an introduction to the concept.

## Large-scale event management

Work with your business and marketing teams to prepare for large-scale events. Knowing if there will be sudden spikes in traffic (Superbowl, Black Friday, or Marketing pushes) can allow you to prepare your infrastructure ahead of time.

## Choosing the right resources

Right sizing your infrastructure to meet the needs of your applications can save you considerably as opposed to a 'one size fits all' solution often employed with on-premises hardware. Identify the needs of your application and choose the resources that best fit those needs. Review [sizes for Windows virtual machines in Azure](/azure/virtual-machines/windows/sizes) to learn more.

## Choosing metrics for scaling policies

Autoscaling rules that use a detection mechanism based on a measured trigger attribute (such as CPU usage or queue length) use an aggregated value over time, rather than instantaneous values, to trigger an autoscaling action. By default, the aggregate is an average of the values. This prevents the system from reacting too quickly, or causing rapid oscillation. To learn more [review autoscaling guidance](../../best-practices/auto-scaling.md).

## Preemptively scaling based on trends

Preemptively scaling based on historical data can ensure your application has consistent performance, even though your metrics have not yet indicated the need to scale. If you can predict the load on the application, consider using scheduled autoscaling, which adds and removes instances to meet anticipated peaks in demand. To learn more [review autoscaling guidance](../../best-practices/auto-scaling.md).

## Automated scale operations

Fluctuation in application traffic is expected. To ensure optimal operation conditions are maintained, such variations should be met by automated scalability operations. While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured range of resources, provisioning or de-provisioning capacity is more advanced and complex, for example, adding additional scale units like additional clusters, compute instances, or deployments. The process should be codified, automated, and the effects of adding/removing capacity should be well understood. To learn more [review repeatable infrastructure](../devops/automation-infrastructure.md).

## Application health and capacity

Any change in the health state of application components can influence the capacity demands on other components. These impacts need to be fully understood, and auto-scaling measures need to be in place to handle those. For example, if an outage in an external API is mitigated by writing messages into a retry queue, this queue will get sudden spikes in the load that it will need to handle.
