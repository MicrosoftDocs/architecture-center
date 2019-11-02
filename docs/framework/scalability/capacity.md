---
title: Capacity
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you ensuring you have sufficient Capacity? 
---

# Capacity

## Content Delivery Networks (CDN)

With CDNs, you can cache static objects loaded from Azure Blob storage, a web application, or any publicly accessible web server, by using the closest point of presence (POP) server. CDNs can also accelerate dynamic content, which cannot be cached, by leveraging various network and routing optimizations. If you are not familiar with CDN's review [What is a content delivery network on Azure](/azure/cdn/cdn-overview) to get an introduction to the concept.

## Large-scale event management

Work with your business and marketing teams to prepare for large-scale events. Knowing if there will be sudden spikes in traffic (Superbowl, Black Friday, or Marketing pushes) can allow you to prepare your infrastructure ahead of time.

## Choosing the right resources

Right sizing your infrastructure to meet the needs of your applications can save you considerably as opposed to a 'one size fits all' solution often employed with on-premises hardware. Identify the needs of your application and choose the resources that best fit those needs. Review [sizes for Windows virtual machines in Azure](/azure/virtual-machines/windows/sizes) to learn more.

## Choosing metrics for scaling policies

Autoscaling rules that use a detection mechanism based on a measured trigger attribute (such as CPU usage or queue length) use an aggregated value over time, rather than instantaneous values, to trigger an autoscaling action. By default, the aggregate is an average of the values. This prevents the system from reacting too quickly, or causing rapid oscillation. To learn more [review autoscaling guidance](/azure/architecture/best-practices/auto-scaling).

## Preemptively scaling based on trends

Preemptively scaling based on historical data can ensure your application has consistent performance, even though your metrics have not yet indicated the need to scale. If you can predict the load on the application, consider using scheduled autoscaling, which adds and removes instances to meet anticipated peaks in demand. To learn more [review autoscaling guidance](/azure/architecture/best-practices/auto-scaling).