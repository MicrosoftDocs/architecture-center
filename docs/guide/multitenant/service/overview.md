---
title: Service-Specific Guidance for a Multitenant Solution
description: This article introduces the guidance for using many distinct Azure services in a multitenant solution to achieve business and technical goals.
author: johndowns
ms.author: pnp
ms.date: 06/11/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
---

# Service-specific guidance for a multitenant solution

When you build a solution on Azure, you combine multiple distinct Azure services to achieve your business and technical goals. Azure services operate consistently, but each service requires specific design and implementation considerations. A multitenant solution introduces extra design factors to evaluate for each service.

This section provides guidance about the features of each service that support multitenant solutions. It also explains the levels of tenant isolation that each service supports. Where applicable, it includes links to detailed documentation and sample implementations.

> [!NOTE]
> The content in this section focuses specifically on the aspects of each service that relate to building a multitenant solution on Azure. For comprehensive information about each service and its features, see the service's documentation.

## Intended audience

The content in this section helps architects, lead developers, and others build or implement Azure components for a multitenant solution. The audience also includes independent software vendors and startups who develop software as a service (SaaS) solutions.

## Related resource

- [Azure Resource Manager](resource-manager.md)
