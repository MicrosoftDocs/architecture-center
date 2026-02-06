---
title: Multitenancy Checklist on Azure
description: Multitenancy lets you serve multiple tenants in an Azure-hosted solution. Use this checklist to evaluate your multitenancy needs and architecture.
author: arsenvlad
ms.author: arsenv
ms.date: 04/17/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy checklist on Azure

When you build your multitenant solution in Azure, there are many elements that you need to consider. Use this checklist as a starting point to help you design and build your multitenant solution. This checklist is a companion resource to the [Architect multitenant solutions on Azure](./overview.md) series of articles. The checklist is structured around the business and technical considerations and the five pillars of the [Azure Well-Architected Framework](/azure/well-architected/).

> [!TIP]
> After you go through this checklist, take the [SaaS Journey Review](/assessments/3a5bbc6d-c7be-4ccf-92f8-c1a0bdb0196a/) to evaluate your software as a service (SaaS) product by analyzing your understanding of multitenant architecture and its alignment with SaaS operation best practices.

## Business considerations

- Understand the type of solution that you're creating, such as business-to-business (B2B), business-to-consumer (B2C), or your enterprise software, and [how tenants are different from users](./overview.md).  

- [Define your tenants](./considerations/tenancy-models.md#define-a-tenant). Understand how many tenants you initially support and define your growth plans.  

- [Define your pricing model](./considerations/pricing-models.md) and ensure that it aligns with your [tenants' consumption of Azure resources](./considerations/measure-consumption.md).  

- Understand whether you need to separate your tenants into different [tiers](./considerations/pricing-models.md#feature--and-service-level-based-pricing). Tiers might have different pricing, features, performance promises, and geographic locations.

- Based on your customers' requirements, decide on the [tenancy models](./considerations/tenancy-models.md) that are appropriate for various parts of your solution.  

- When you're ready, sell your B2B multitenant solution by using the [Microsoft commercial marketplace](/azure/marketplace/plan-saas-offer).  

## Reliability considerations  

- Review the [Well-Architected Framework Reliability checklist](/azure/architecture/framework/resiliency/design-checklist), which is applicable to all workloads.  

- Understand the [Noisy Neighbor antipattern](../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Prevent individual tenants from affecting the system's availability for other tenants.  

- [Design your multitenant solution](./approaches/overview.md) for the level of growth that you expect. But don't overengineer for unrealistic growth.  

- Define [service-level objectives (SLOs)](/azure/well-architected/reliability/metrics) and optionally service-level agreements (SLAs) for your solution. SLOs and SLAs should be based on the requirements of your tenants.  

- Test the [scale](./approaches/compute.md#scale) of your solution. Ensure that it performs well under all levels of load and that it scales correctly as the number of tenants increases.  

- Apply [chaos engineering principles](./approaches/compute.md#isolation) to test the reliability of your solution.  

## Security considerations  

- Apply [zero trust](/security/zero-trust) and least privilege principles in all layers of your solution.

- Ensure that you can correctly [map user requests](./considerations/map-requests.yml) to tenants. Consider including the tenant context as part of the identity system or via another method, like application-level tenant authorization.  

- Design for [tenant isolation](./considerations/tenancy-models.md#tenant-isolation). Continuously [test your isolation model](./approaches/compute.md#isolation).  

- Ensure that your application code prevents any cross-tenant access or data leakage.  

- Perform ongoing penetration testing and security code reviews.  

- Understand your tenants' [compliance requirements](./approaches/governance-compliance.md), including data residency and any compliance or regulatory standards that they require you to meet.  

- Correctly [manage domain names](./considerations/domain-names.md) and avoid vulnerabilities like [dangling Domain Name System and subdomain takeover attacks](./considerations/domain-names.md#dangling-dns-and-subdomain-takeover-attacks).  

- Follow [service-specific guidance](./service/overview.md) for multitenancy.  

## Cost Optimization considerations  

- Review the [Well-Architected Framework Cost Optimization checklist](/azure/architecture/framework/cost/design-checklist), which is applicable to all workloads.  

- Ensure that you can adequately [measure per-tenant consumption](./considerations/measure-consumption.md) and correlate it with [your infrastructure costs](./approaches/cost-management-allocation.md).  

- Avoid [antipatterns](./approaches/cost-management-allocation.md#antipatterns-to-avoid). Antipatterns include failing to track costs, tracking costs with unnecessary precision, using real-time measurement, and using monitoring tools for billing.  

## Operational Excellence considerations  

- Use automation to manage the [tenant life cycle](./considerations/tenant-life-cycle.md), such as onboarding, [deployment, provisioning, and configuration](./approaches/deployment-configuration.md).  

- Understand the differences between [control planes](./considerations/control-planes.md) and data planes in your multitenant solution.  

- Find the right balance for [deploying service updates](./considerations/updates.md). Consider both your tenants' requirements and your own operational requirements.  

- Monitor the health of the overall system and each tenant.  

- Configure and test alerts to notify you when specific tenants experience problems or exceed their consumption limits.  

- [Organize your Azure resources](./approaches/resource-organization.md) for isolation and scale.  

- Avoid [deployment and configuration antipatterns](./approaches/deployment-configuration.md#antipatterns-to-avoid). Antipatterns include running separate versions of the solution for each tenant, hard-coding tenant-specific configurations or logic, and relying on manual deployments.  

## Performance Efficiency considerations  

- Review the [Well-Architected Framework Performance Efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency), which is applicable to all workloads.  

- If you use shared infrastructure, plan for how to mitigate [noisy neighbor](../../antipatterns/noisy-neighbor/noisy-neighbor.yml) concerns. Ensure that one tenant can't reduce the performance of the system for other tenants.  

- Determine how to scale your [compute](./approaches/compute.md), [storage](./approaches/storage-data.md), [networking](./approaches/networking.md), and other Azure resources to match the demands of your tenants.  

- Consider the scale limits for each Azure resource. [Organize your resources](./approaches/resource-organization.md) appropriately to avoid [resource organization antipatterns](./approaches/resource-organization.md#antipatterns-to-avoid). For example, don't over-architect your solution to work within unrealistic scale requirements.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer
- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk/) | Senior Customer Engineer

Other contributor:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural considerations for multitenant solutions](./considerations/overview.yml)
- [Architectural approaches for multitenancy](./approaches/overview.md)
- [Service-specific guidance for multitenancy](./service/overview.md)
- [Resources for architects and developers of multitenant solutions](related-resources.md)
