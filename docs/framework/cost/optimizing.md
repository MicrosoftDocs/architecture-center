---
title: Optimizing Cloud Costs
description: Describes how to best take advantage of the benefits of the cloud to minimize your cost.
author: david-stanford
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Optimizing cloud costs

When the first calculation is more or less close to on-prem analog in terms of the cost - customers prefer to migrate to the cloud. And after migration, continue to optimize the infrastructure by using the right types/sizes of VMs and arrange the scale-down of unused resources.

For example, look at a VM running the SAP on Azure project can show you how initially the VM was sized based on the size of existing hardware server (with cost around €1 K per month), but the real utilization of VM was not more than 25% - but simple choosing the right VM size in the cloud we can achieve 75% saving (resize saving). And by applying the snoozing you can get additional 14% of economy:

![](../_images/run-cost-optimization.png)

It is easy to handle cost comparison when you are well equipped and for this Microsoft provides the set of specific services and tools that help you to understand and plan costs. These include the TCO Calculator, Azure Pricing Calculator, Azure Cost Management (Cloudyn), Azure Migrate, CosmosDB Sizing Calculator, and the Azure Site Recovery Deployment Planner.

As we are talking about financial things - the way how you purchase cloud services, in which selling channel, may also bring the difference into the final cost. Consider the following methods of purchasing Azure and ways of modifying your pricing:

- Enterprise Agreement

- Enterprise Dev Test Subscription

- Cloud Service Provider (Partner Program)

- Azure Hybrid Use Benefit

- Azure Reserved Instances

## Act on recommendations

Azure Advisor enables you to act on cost management recommendations from within the Azure portal, such as resizing virtual machines. [Act on recommendations](/azure/cost-management/tutorial-acm-opt-recommendations). Make sure that all stakeholders are in agreement regarding the implementation and timing of this change. Resizing a virtual machine does require the VM to be shut down and restarted, causing a period of time when it will be unavailable, so time this carefully for minimal business impact.