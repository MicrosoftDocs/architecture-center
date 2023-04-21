---
title: SaaS and multitenant solution architecture
description: This guide provides an overview of the architectural content for SaaS, startups, and multitenancy.
author: landonpierce 
ms.author: landonpierce 
ms.date: 04/21/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
---
# SaaS and multitenant solution architecture

This series of articles provides guidance and resources for organizations that build software as a service (SaaS), including startups. It also provides extensive guidance about architecting multitenant solutions on Azure.

## Key concepts

The key concepts in this series of articles are *SaaS*, *startups*, and *multitenancy*. These terms are related but distinct. SaaS and startup are business concepts, and multitenancy is an architecture concept.

**SaaS is a business model.** An organization can choose to provide their software product as a service to their customers. Commonly, SaaS products are sold to businesses (business-to-business, or B2B), or to consumers (business-to-consumer, or B2C). SaaS products are distinct from products that customers install and manage themselves. Many SaaS solutions use a multitenant architecture, but some don't. SaaS solutions might also use different multitenancy models or approaches.

**Startups are businesses in an early stage of their lifecycle.** Many software startups build SaaS solutions, but some might provide software in other ways instead. Startups often have specific concerns, including rapid innovation, finding a product and market fit, and anticipating scale and growth.

**Multitenancy is a way of architecting a solution to share components between multiple customers, or *tenants.** Multitenant architectures are frequently used in SaaS solutions, but there are also some places where they're used outside of SaaS, such as in enterprises who build a platform for multiple business units to share. Multitenancy doesn't imply that every component in a solution is shared. Rather, it implies that at least *some* components of a solution are reused across multiple tenants.

## Next steps

- [Plan your own journey to SaaS](plan-journey-saas.md)
- [Understand how startups architect their solutions](../startups/startup-architecture.md)
- [Learn about multitenant architectural approaches](../multitenant/overview.md)
