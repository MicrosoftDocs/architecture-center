---
title: Overview of the performance efficiency pillar
description: Explore an overview of the performance efficiency pillar in the Azure Well-Architected Framework. Learn about the importance of scalability.
author: v-aangie
ms.date: 10/23/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
categories:
  - management-and-governance   
ms.custom:
  - overview
---

# Overview of the performance efficiency pillar

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. Before the cloud became popular, when it came to planning how a system would handle increases in load, many organizations intentionally provisioned workloads to be oversized to meet business requirements. This might make sense in on-premises environments because it ensured *capacity* during peak usage. [Capacity](/azure/api-management/api-management-capacity#what-is-capacity) reflects resource availability (CPU and memory). This was a major consideration for processes that would be in place for many years.

Just as you needed to anticipate increases in load in on-premises environments, you need to anticipate increases in cloud environments to meet business requirements. One difference is that you may no longer need to make long-term predictions for anticipated changes to ensure that you will have enough capacity in the future. Another difference is in the approach used to manage performance.

## What is scalability and why is it important?

An important consideration in achieving performance efficiency is to consider how your application scales and to implement PaaS offerings that have built-in scaling operations. *Scalability* is the ability of a system to handle increased load. Services covered by [Azure Autoscale](/azure/azure-monitor/platform/autoscale-overview)<!--replace LINK with new Autoscaling--> can scale automatically to match demand to accommodate workload. They will scale out to ensure capacity during workload peaks and scaling will return to normal automatically when the peak drops.

In the cloud, the ability to take advantage of scalability depends on your infrastructure and services. Some platforms, such as Kubernetes, were built with scaling in mind. Virtual machines, on the other hand, may not scale as easily although scale operations are possible. With virtual machines, you may want to plan ahead to avoid scaling infrastructure in the future to meet demand. Another option is to select a different platform such as Azure virtual machines scale sets.

When using scalability, you need only predict the current average and peak times for your workload. Payment plan options allow you to manage this prediction. You pay either per minute or per-hour depending on the service for a designated time period.

## Next section

Read the performance efficient principles that are intended to guide you in your overall strategy.

> [!div class="nextstepaction"] 
> [Principles](principles.md)
