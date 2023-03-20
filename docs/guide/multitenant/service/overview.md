---
title: Service-specific guidance for a multitenant solution
titleSuffix: Azure Architecture Center
description: This article introduces the guidance we provide for using many distinct Azure services in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 02/28/2023
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

# Service-specific guidance for a multitenant solution

When you're building a solution on Azure, you combine multiple distinct Azure services together to achieve your business and technical goals. Although Azure services work in a consistent manner, there are specific considerations for how you design and implement each service. When you design a multitenant solution, there are further considerations to review, for each service.

In this section, we provide guidance about the features of each service that are helpful for multitenant solutions. We also discuss the levels of tenant isolation that each service supports. Where applicable, we link to more details and sample implementations in the service's documentation.

> [!NOTE]
> The content in this section focuses specifically on the aspects of each service that relate to building a multitenant solution on Azure. For comprehensive information about each service and its features, refer to the service's documentation.

## Intended audience

The content in this section is designed for architects, lead developers, and anyone building or implementing Azure components for a multitenant solution. The audience also includes independent software vendors (ISVs) and startups who develop SaaS solutions.

## What's covered in this section?

The articles in this section describe some Azure services commonly used in multitenant solutions.

We frequently add new articles with guidance for additional services. You're also welcome to [submit suggestions for additional service-specific guidance](https://aka.ms/multitenancy/feedback).

## Next steps

Review the guidance for [Azure Resource Manager](resource-manager.md).
