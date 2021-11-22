---
title: Checklist - Design for cost
description: View checklists for the cost model and architecture to use when you design a cost-effective workload in Azure.
author: david-stanford
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Checklist - Design for cost

Use this checklist when designing a cost-effective workload.
## Cost model

- **Capture clear requirements**. Gather detailed information about the business workflow,  regulatory, security, and availability.
    - [Capture requirements](./design-capture-requirements.md)

- **Estimate the initial cost**. Use tools such as [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to assess cost of the services you plan to use in the workload. Use [Azure Migrate](/azure/migrate/migrate-services-overview) and [Microsoft Azure Total Cost of Ownership (TCO) Calculator](https://azure.microsoft.com/pricing/tco/calculator/) for migration projects. Accurately reflect the cost associated with right storage type. Add hidden costs, such as networking cost for large data download.
    - [Estimate the initial cost](./design-initial-estimate.md)

- **Define policies for the cost constraints defined by the organization**. Understand the constraints and define acceptable boundaries for quality pillars of scale, availability, security.
    - [Consider the cost constraints](./design-model.md#cost-constraints)

- **Identify shared assets**. Evaluate the business areas where you can use shared resources. Review the billing meters build chargeback reports per consumer to identify metered costs for shared cloud services.
    - [Create a structured view of the organization in the cloud](./design-model.md#organization-structure)

- **Plan a governance strategy**. Plan for cost controls through Azure Policy. Use resource tags so that custom cost report can be created. Define budgets and alerts to send notifications when certain thresholds are reached.
    - [Governance](./design-governance.md)

## Architecture

- **Check the cost of resources in various Azure geographic regions**. Check your egress and ingress cost, within regions and across regions. Only deploy to multiple regions if your service levels require it for either availability or geo-distribution.
    - [Azure regions](./design-regions.md)

- **Choose a subscription that is appropriate for the workload**. Azure Dev/Test subscription types are suitable for experimental or non-production workloads and have lower prices on some Azure services such as specific VM sizes. If you can commit to one or three years, consider subscriptions and offer types that support Azure Reservations.
    - [Subscription and offer type](./design-resources.md#subscription-and-offer-type)

- **Choose the right resources to handle the performance**. Understand the usage meters and the number of meters for each resource in the workload. Consider tradeoffs over time. For example, cheaper virtual machines may initially indicate a lower cost but can be more expensive over time to maintain a certain performance level. Be clear about the billing model of third-party services.
    - [Azure resources](./design-resources.md)
    - [Use cost alerts to monitor usage and spending](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending)

- **Compare consumption-based pricing with pre-provisioned cost**. Establish baseline cost by considering the peaks and the frequency of peaks when analyzing performance.
    - [Consumption and fixed cost models](./design-price.md)

- **Use proof-of-concept deployments**. The [Azure Architecture Center](/azure/architecture) has many reference architectures and implementations that can serve as a starting point.  The [Azure Tech Community](https://techcommunity.microsoft.com/t5/azure/ct-p/Azure) has architecture and services forums.

- **Choose managed services when possible**. With PaaS and SaaS options, the cost of running and maintaining the infrastructure is included in the service price.
    - [Managed services](./design-paas.md)
