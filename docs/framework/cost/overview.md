---
title: Overview of the cost pillar 
description: Describes the cost pillar
author: david-stanford
ms.date: 11/04/2019
ms.topic: overview
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Introduction to cost management for cloud applications

This article introduces you to cloud cost management, through a series of important considerations that need to be applied to achieve both business objectives and cost justification.

## Overview

Successful technology architectures are driven by an organization's requirements. The purpose of an architecture is to achieve business goals and return on investment (ROI) while staying within an allocated budget. Therefore, a cloud architecture must consider cost optimization: From all possible technology choices that meet business needs, which choice makes best use of the organization's financial investments?

Cloud services provide computing as a utility. Technologies in the cloud are provided under a service model, to be consumed on demand. This on-demand service offering drives a fundamental change that directly impacts planning, bookkeeping, and organization.

When an organization decides to own infrastructure, it buys equipment that goes onto the balance sheet as assets. Because a capital investment was made, accountants categorize this transaction as a Capital Expense (CapEx). Over time, to account for the assets' limited useful lifespan, assets are depreciated or amortized. Cloud services, on the other hand, are categorized as an Operating Expense (OpEx), because of their consumption model. Under this scheme, there is no asset to amortize. Instead, OpEx has direct impact on net profit, taxable income, and the associated expenses on the balance sheet.

When an organization adopts a cloud platform, it must shift away from CapEx-oriented budgeting towards OpEx, reflecting the shift from owning infrastructure to leasing solutions. Some organizations can derive value just from this new accounting model. A startup, for example, can attract investors by demonstrating a profitable idea at large scale, without needing a large investment up front to purchase infrastructure.

In order to calculate ROI or compare technology solutions, it's important to understand what's included in the pricing model. Cloud providers factor in hardware, software, development, operations, security, and data center space when setting the costs for various cloud services. However, while cloud services can offset management or administrative tasks, they don't entirely replace these needs. For example, security will always be a shared responsibility between the cloud provider and consumer, and network expertise is still needed when building hybrid cloud architectures. These tasks should remain as items in the cost structure to accurately capture the cost of the service.

Cost, being an absolute metric, is easy to grasp and work with, but the "best use" criteria are harder to quantify. When choosing among technology options, organizations often use cost to assess business value. However, these comparisons are only meaningful when in the correct context: with a good understanding of the capabilities, limitations, pricing, and scalability of individual services.

## Principles of cost optimization

### Organization

**Develop a Cloud Operating Model.** When adopting the cloud, one of the main considerations is the shift from static (or purchased) infrastructure to dynamic (or rented) infrastructure. This has implications across four facets of building software: Specifically, how you provision, secure, connect, and run your applications. If you are just starting in this process review [enable success during a cloud adoption journey ](/azure/cloud-adoption-framework/getting-started/enable).

### Architecture

**Understand the cloud.** Do not make assumptions about capability, availability, scale, or security. Understand the boundaries of shared responsibility between customer and provider, and try to understand exactly what your provider promises to deliver as part of a service offering.

**Capture clear requirements.** More detailed metrics about your application translate to better cost estimates while planning. Knowing the business case or conducting a business impact analysis can help you to quantify tangible and intangible costs, such as brand value or reputation, allowing for holistic requirements.

### Provisioning

**Simplify via platform services.** Purpose-built platform and software services can greatly simplify overall architecture by alleviating operational, security, scale, resilience and sometimes, legal considerations. SaaS and PaaS offerings allow you to focus on core business goals instead of the nuances of efficient infrastructure management.

### Reporting

**Treat IT as a utility.** In the cloud, you're only billed for usage. While your important data needs to be persisted, the infrastructure that processes it doesn't. Treat your resources as transient, shutting them down when not needed.

### Optimization

**Measure and adapt.** One of the biggest benefits of the cloud is how it adapts to constant changes. Measure and forecast your capacity needs, so that you can provision resources dynamically and scale with demand. Having a granular understanding of your resource requirements also allows for "right-sizing" &mdash; selecting architecture building blocks that can handle your workload with the expected performance profile.

**Aim for scalable costs.** Your capacity requirements vary together with the rhythm of your business. In a cost-optimized architecture, costs scale linearly with demand. Serving 10x more customers shouldn't cost 100x. Treat cost optimization as a process, rather than a point-in-time activity.

## Next steps

> [!div class="nextstepaction"]
> [Modeling your cloud costs](./modeling.md)