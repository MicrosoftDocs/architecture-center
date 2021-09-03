---
title: Overview of the cost optimization pillar
description: Provides an overview of the cost optimization pillar in the Azure Well-Architected Framework.
author: v-stacywray
ms.date: 09/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - overview
products: azure
categories: management-and-governance
---

# Overview of the cost optimization pillar

The cost optimization pillar provides principles for balancing business objectives with budget justification to create a cost-effective workload while avoiding capital-intensive solutions. Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies.

To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

The Microsoft Azure Well-Architected Framework includes the following topics in the cost optimization pillar:

| Cost Topic | Description |
|------------|-------------|
|[Capture cost requirements](./cost/design-capture-requirements.md)| Start your planning with a careful enumeration of requirements. Make sure the needs of the stakeholders are addressed. For strong alignment with business goals, those areas must be defined by the stakeholders and shouldn't be collected from a vendor.|
|[Cost of resources in Azure regions](./cost/design-regions.md)|Cost of an Azure service can vary between locations based on demand and local infrastructure costs.|
|[Governance](./cost/design-resources.md)| Understand how governance can assist with cost management. This work will benefit your ongoing cost review process and will offer a level of protection for new resources.|
|[Estimate the initial cost](./cost/design-initial-estimate.md)|It's difficult to attribute costs before deploying a workload to the cloud. If you use methods for on-premises estimation or directly map on-premises assets to cloud resources, estimate will be inaccurate.|
|[PaaS](./cost/design-paas.md)| Look for areas in the architecture where it may be natural to incorporate platform-as-a-service (PaaS) options. These include caching, queues, and data storage. PaaS reduces time and cost of managing servers, storage, networking, and other application infrastructure.|
|[Consumption](./cost/design-price.md)|A common way to estimate cost is by considering workloads on a peak throughput. Under consistently high utilization, consumption-based pricing can be less efficient for estimating baseline costs when compared to the equivalent provisioned pricing.|
|[Provision cloud resources](./cost/provision-checklist.md)|Deployment of workload cloud resources can optimize cost.|
|[Monitor cost](./cost/monitor-alert.md)|Azure Cost Management has an alert feature. Alerts are generated when consumption reaches a threshold.|
|[Optimize cost](./optimize-checklist.md)|Monitor and optimize the workload by using the right resources and sizes.
|[Tradeoffs for costs](./cost/tradeoffs.md)|As you design the workload, consider tradeoffs between cost optimization and other aspects of the design, such as security, scalability, resilience, and operability.
