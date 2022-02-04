---
title: Multitenancy checklist on Azure
titleSuffix: Azure Architecture Center
description: TODO
author: cherchyk
ms.author: bocherch
ms.date: 01/04/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
ms.category:
  - fcp
ms.custom:
  - guide
---

# Checklist for architecting and building multitenant solutions on Azure

When you build your multitenant solution in Azure, there are several elements you need to consider. Use this checklist as a starting point to help you design and build your multitenant solution. This checklist is a companion resource to the [Architecting multitenant solutions on Azure](./overview.md) series of articles and is structured around the business considerations and the 5-pillars of the Azure Well-Architected Framework.

## Business Considerations

* Understand what kind of solution you are creating, such as Business-to-Business (B2B), Business-to-Consumer (B2C), or your enterprise software, and [how tenants are different from users](./overview.md).
* [Define your tenants](./considerations/tenancy-models.md#define-a-tenant), how many you will have initially, and your growth plans.
* Define your [pricing model](./considerations/pricing-models.md) and make sure it will align with your [tenants’ consumption](./considerations/measure-consumption.md).
* Understand if you need to separate your tenants into different [tiers](./considerations/pricing-models.md#feature--and-service-level-based-pricing) with different pricing, features, performance promises, geographic locations, etc.
* Based on your customers’ requirements, decide on the [tenancy models](./considerations/tenancy-models.md) appropriate for various parts of your solution.
* When ready, sell your B2B multitenant solution using the [Microsoft Commercial Marketplace](/azure/marketplace/plan-saas-offer).

## Reliability Considerations

* Review the Azure Well-Architected Reliability [checklist](/azure/architecture/framework/resiliency/design-checklist), applicable to all workloads.
* Understand the antipattern, and prevent individual tenants from impacting the system's availability for other tenants.
* [Design your multitenant solution](./approaches/overview.md) for the level of growth that you expect, but do not overengineer.
* Define Service Level Objectives (SLOs) and optionally [Service Level Agreements (SLAs)](/learn/modules/choose-azure-services-sla-lifecycle/2-what-are-service-level-agreements) for your solution based on the requirements of your tenants and the [composite SLA of the underlying components](/azure/architecture/framework/resiliency/business-metrics).
* Test the [scale](./approaches/compute.md#scale) of your solution to ensure it performs well under all levels of load and scales properly as the number of tenants increases.
* Apply [Chaos Engineering principles](./approaches/compute.md#isolation) to test the reliability of your solution.

## Security Considerations

* Apply [Zero Trust](/security/zero-trust/) and Least Privilege principles in all layers of your solution.
* Ensure that you can [properly map user requests](./considerations//map-requests.md) to tenants, either by having the tenant context as part of the identity or by using another means like application-level tenant authorization.
* Design for proper [tenant isolation](./considerations/tenancy-models.md#tenant-isolation) and continuously [test your isolation model](./approaches/compute.md#isolation).
* Ensure application code is behaving correctly and prevents any cross-tenant access.
* Perform ongoing penetration testing and code reviews.
* Understand your tenants' [compliance requirements](./approaches/governance-compliance.md), including data residency and any compliance standards they require that you meet.
* Properly [manage domain names](./considerations/domain-names.md) and avoid vulnerabilities.
* Follow [service-specific guidance](./service/overview.md) for multitenancy.

## Cost Optimization Considerations

* Review the Azure Well-Architected Cost Optimization [checklist](/azure/architecture/framework/cost/design-checklist), applicable to all workloads.
* Ensure you can adequately [measure per-tenant consumption](./considerations/measure-consumption.md) and correlate it with [your infrastructure costs](./approaches/cost-management-allocation.md).
* Avoid [antipatterns](./approaches/cost-management-allocation.md#antipatterns-to-avoid) such as not tracking costs, extreme precision, real-time measurement, and using monitoring tools for billing.

## Operational Excellence Considerations

* Review the Azure Well-Architected Operational Excellence [checklist](../../checklist/data-ops.md), applicable to all workloads.
* Use automation to manage the [tenant lifecycle](./considerations/tenant-lifecycle.md) such as onboarding, [deployment, provisioning, and configuration](./approaches/deployment-configuration-content.md) .
* Find the right balance for deploying [service updates](./considerations/updates.md) that meet your tenant's requirements.
* Monitor the health of the overall system as well as each tenant.
* Configure and test alerts to notify you when specific tenants are experiencing issues or exceeding their consumption limits.
* [Organize resources](./approaches/resource-organization.md) for isolation and scale.
* Avoid [antipatterns](./approaches/deployment-configuration-content.md#antipatterns-to-avoid) such as running separate versions of the solution or hardcoding tenant-specific configurations or logic or manual deployments.

## Performance Efficiency Considerations

* Review the Azure Well-Architected Performance Efficiency [checklist](/azure/architecture/framework/scalability/performance-efficiency), applicable to all workloads.
* If you use shared infrastructure, plan for how you'll mitigate the [Noisy Neighbor](../../antipatterns/noisy-neighbor/index.md) concerns and ensure that one tenant cannot negatively impact the system for other tenants.
* Determine how you will scale [compute](./approaches/compute.md), [storage](./approaches/storage-data.md), [networking](./approaches/networking.md), and other resources to match tenant demand.
* Consider various resource scale limits and [organize resources](./approaches/resource-organization.md) appropriately to avoid [antipatterns](./approaches/resource-organization.md#antipatterns-to-avoid) like not planning for scale at all or over-architecting when unnecessary.
