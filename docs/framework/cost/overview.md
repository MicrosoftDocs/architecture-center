---
title: Overview of the cost pillar 
description: Describes the cost pillar
author: david-stanford
ms.date: 10/21/2019
ms.topic: overview
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Overview of the cost pillar

Successful technology architectures are driven by the context of an organization's requirements. An architecture's purpose is to support achieving business goals and return on investment (ROI) requirements while remaining within an allocated budget. Cloud architecture design involves cost optimization: from all possible technology choices that meet business needs, which is the one that makes best use of the organization's financial investments?

Cloud services implement the concept of computing as utility. Analogous to conventional utility services, such as electricity, cloud technologies are offered under a service model, to be consumed on demand. This on-demand service offering is key, as it drives a fundamental change that directly impacts planning and bookkeeping of and organization.

When an organization decides to own infrastructure, it is required to buy equipment which goes onto the balance sheet as assets. Because a capital investment has been made, accountants categorize this transaction as a Capital Expense (CapEx). Over time, to account for the assets' limited useful lifespan, assets will be depreciated or amortized. In contrast, due to their consumption model, cloud service costs are categorized as an Operating Expense (OpEx). Under this scheme, there is no asset amortize. Instead, OpEx has direct impact on net profit, taxable income, and the associated expenses on the balance sheet.

Successful adoption of a cloud platform requires an organization to shift away from CapEx oriented budgeting towards OpEx, reflecting the paradigm shift from owned technology infrastructure to leased technology solutions.  Certain organizations can derive value from this new accounting model alone. A startup, for example, can attract investors merely by demonstrating a profitable idea at large scale, without having to worry about deterring investors with a large upfront investment required to purchase infrastructure as asset.

Cloud Services define primitives for operations that commonly appear in architecture design scenarios. These primitives are further bundled to provide solutions for typical customer end-goals. Cost structure of cloud services is reflective of this bundling. Understanding what gets bundled into the cost of a cloud service is important for calculating ROI or comparing technology solutions on the appropriate basis. Cloud providers factor in hardware, software, development, operations, security, data center space: anything that results in an expense for the provider, related to the service. It is important to remember that while cloud services can offset management or administrative tasks, they often do not entirely replace these needs within the consuming organization. For example, security will always be a shared responsibility between the cloud provider and consumer, and network expertise will still be needed to navigate hybrid cloud architectures. These tasks should remain as items in the cost structure to accurately capture the cost of the service.

While finding the answer is undoubtedly a complex matter, cost, being an absolute metric, is easy to grasp and work with. It is the ‘best use' criteria that are harder to pin down.

Substitution in architecture components usually come with associated changes in costs. Due to this property, costs are frequently used to compare technology choices when trying to assess business value. However, these comparisons are only meaningful when evaluated in the correct context: with a good understanding of cloud services' capabilities, limitations, pricing, and cost vs. scalability model.

This article introduces you to Cloud cost management through a series of important considerations that need to be applied to achieve both business objectives and cost justification.

## Principles

### Organization

**Develop a Cloud Operating Model.** One of the main considerations that should be made when adopting the cloud is the shift from static (or purchased) infrastructure to dynamic (or rented) infrastrcture.  This has implications across four facets of building software. Specifically, how you provision, secure, connect, and run your applications. If you are just starting in this process review [enable success during a cloud adoption journey ](/azure/cloud-adoption-framework/getting-started/enable).

### Architecture

**Understand the cloud.** Do not make assumptions about capability, availability, scale, or security. Success in the cloud requires understanding of the boundaries of shared responsibility between customer and provider. Strive to understand what exactly your provider promises to deliver as part of a service offering.

**Capture clear requirements.** More detailed metrics about your application translate to better cost estimates while planning. Knowing the business case or conducting a business impact analysis for your solution can assist in quantifying tangible and intangible costs such as brand value or reputation, allowing for holistic requirements.

### Provisioning

**Simplify via platform services.** Purpose-built platform and software services can greatly simplify overall architecture by alleviating operational, security, scale, resilience and sometimes, legal considerations. SaaS and PaaS offerings allow you to focus on core business goals instead of the nuances of efficient infrastructure management.

### Reporting

**Treat IT as a utility.** In the cloud, you're only billed for usage. While     your important data needs to be persisted, the infrastructure that processes     it doesn't. Treat your resources as transient, shutting them down as if you     switched off the light in a room upon exit.

### Optimization

**Measure and adapt.** One of the biggest benefits of the cloud is the way     it adapts to constant changes. Measuring and forecasting capacity needs     allow for dynamic provisioning and scaling with demand. Granular     understanding of your resource requirements also allows for right-sizing:     selection of architecture building blocks equipped to handle your workload     with the expected performance profile.

**Aim for scalable costs.** Your capacity requirements vary together with the rhythm of your business. In a cost-optimized architecture costs scale linearly with demand. Serving 10x more customers shouldn't cost 100x. Treat cost optimization as a process, rather than a point-in-time activity.
