---
title: SaaS and Multitenant Solution Architecture
description: This guide provides an overview of the architectural content for software as a service (SaaS), startups, and multitenancy and guidance about how to architect multitenant solutions on Azure.
author: PlagueHO 
ms.author: dascottr 
ms.date: 12/16/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
---
# SaaS and multitenant solution architecture

An organization can use software as a service (SaaS) to efficiently deliver software to its customers. Typically, a SaaS vendor operates and manages the software for their customers. Many independent software vendors (ISVs) are moving away from providing software that customers must install and manage by themselves to using a SaaS model because it improves customer experience and reduces overhead. This article is an introduction to a series of articles that provide guidance and resources for organizations, including startups, that build SaaS solutions. It also provides extensive guidance about how to architect multitenant solutions on Azure.

## Key concepts

The key concepts in this article are *SaaS*, *startups*, and *multitenancy*. These terms are related, so they're often mistakenly used interchangeably. It's important to understand how these terms are different. SaaS and startups are business concepts, and multitenancy is an architecture concept.

**SaaS is a business model.** An organization can choose to provide its software product as a service to its customers. SaaS products are sold either to businesses in a business-to-business (B2B) model or directly to consumers in a business-to-consumer (B2C) model. SaaS products are different from products that customers install and manage by themselves because the solution vendor hosts and maintains SaaS products. Many SaaS solutions use a multitenant architecture. SaaS solutions might also use different multitenancy models or approaches.

**Startups are businesses in an early stage of their life cycle.** Many software startups build SaaS solutions, but some might provide software in other ways. Startups often have specific concerns, including rapid innovation, finding a product and market fit, and anticipating scale and growth.

**Multitenancy is a way of architecting a solution to share components between multiple tenants, which usually correspond to customers.** You usually use multitenant architectures in SaaS solutions. However, it is also possible to use multitenant architectures outside of SaaS, such as in organizations that build a platform for multiple business units to share. Multitenancy doesn't imply that every component in a solution is shared. Instead, it implies that at least *some* components are shared across multiple tenants.

How you [define a tenant](../multitenant/considerations/tenancy-models.md#define-a-tenant) and choose a [tenancy model](../multitenant/considerations/tenancy-models.md#common-tenancy-models) depends on whether your business model is B2C SaaS or B2B SaaS or you're a large organization.

> [!NOTE]
> This series uses the term *tenant* to refer to **your** tenants, which might be your customers or groups of users. The guidance can help you build your own multitenant software solutions on top of the Azure platform.
>
> In Microsoft Entra ID, a tenant refers to individual directories, and multitenancy refers to interactions between multiple Microsoft Entra tenants. The terms are the same, but the concepts aren't. For clarity, this series uses the full term, *Microsoft Entra tenant*, when referring to the Microsoft Entra ID concept of a tenant.

## Multitenant architecture for SaaS and non-SaaS business models

Although multitenancy is typically associated with SaaS solutions, it is also possible to use multitenant architectures in non-SaaS scenarios. The underlying multitenant architecture might be similar, but the business model affects how you define a tenant and your design choices.

The following diagram illustrates how you can use a multitenant architecture to serve a SaaS business model:

:::image type="complex" border="false" source="./images/saas-business-model.svg" alt-text="Diagram that shows a multitenant application architecture that serves a SaaS business model." lightbox="./images/saas-business-model.svg":::
   The diagram shows a business model section and a technical architecture section. The business model section includes a SaaS section that has B2C and B2B SaaS types. Arrows point from these types to the tenants in the multitenant application section. The technical architecture section includes tenants, user groups, and employees.
:::image-end:::

The following diagram illustrates how you can use a multitenant architecture in a business model that isn't a SaaS. For example, suppose you're designing a system for a large organization that has multiple business units and departments that wish to share a centralized application or platform. Each business unit is represented as a tenant, and has its own set of users.

:::image type="complex" border="false" source="./images/enterprise-business-model.svg" alt-text="Diagram that shows how an organization can use a multitenant architecture." lightbox="./images/enterprise-business-model.svg":::
   The diagram shows a business model section and a technical architecture section. The business model section includes an enterprise section which contains a business units section. The business units section includes accounting, HR, and sales. The technical architecture section includes a multitenant application section which contains a tenant section that has multiple tenants.
:::image-end:::

The key difference between the two diagrams is the business model, which affects how you define a tenant in the context of your organization. Your business model also affects your design choices for the underlying multitenant architecture, but the principles of multitenancy always remain the same.

## Related resources

- [Understand how startups architect their solutions](../startups/startup-architecture.md)
- [Learn about multitenant architectural approaches](../multitenant/overview.md)
- [Software as a service (SaaS) Workload Documentation - Azure Well-Architected Framework](/azure/well-architected/saas/)
