---
title: Architecting multitenant solutions on Azure
titleSuffix: Azure Architecture Center
description: This article introduces how to build multitenant solutions on Azure and the guidance we provide throughout this series.
author: johndowns
ms.author: jodowns
ms.date: 11/24/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.category:
  - fcp
ms.custom:
  - guide
---

# Architecting multitenant solutions on Azure

A multitenant solution is one used by multiple customers, or *tenants*. Tenants are distinct from users. Multiple users from a single organization, company, or group form a single tenant. Examples of multitenant applications include:

* Business-to-business (B2B) solutions, like accounting software, work tracking, and other software as a service (SaaS) products.
* Business-to-consumer (B2C) solutions, like music streaming, photo sharing, and social network services.
* Enterprise-wide platform solutions, like a shared Kubernetes cluster used by multiple business units within an organization.

When you build your own multitenant solution in Azure there are a number of elements you need to consider factor into your architecture.

In this series, we provide guidance about how to design, build, and operate your own multitenant solutions in Azure.

## Scope

While Azure is itself a multitenant service, and some of our guidance is based on our experience with running large multitenant solutions, the focus of this series is on helping you build your own multitenant services, while harnessing the power of the Azure platform.

Additionally, when you design a solution, there are many areas you need to consider. The content in this section is specific to how you design for multitenancy. We don't cover all of the features of Azure services, or all of the architectural design considerations for every application. This guide should be read in conjunction with the [Microsoft Azure Well-Architected Framework](../../../framework/index.md) and the documentation for each Azure service you use.

## Intended audience

The guidance provided in this series is applicable to anyone building a multitenant solution in Azure. These include independent software vendors (ISVs) who are building SaaS products, whether they are targeted for businesses or consumers. It also includes anyone building a product or platform intended to be used by multiple customers or tenants.

The content throughout this series is designed to be useful for technical decision-makers, like chief technology officers (CTOs) and architects, and anyone designing or implementing a multitenant solution on Microsoft Azure.

## What's in this series?

The content in this series is comprised of three main sections:

* [**Architectural considerations for a multitenant solution:**](considerations/overview.md) This section provides an overview of the key requirements and considerations you need to be aware of when planning and designing a multitenant solution.

  The pages in this section are particularly relevant for technical decision-makers, like chief technology officers (CTOs) and architects. However, anyone who works with multitenant architectures should have some familiarity with these principles and tradeoffs.

* [**Architectural approaches for multitenancy:**](approaches/overview.md) This section describes the approaches you can consider when designing and building multitenant solutions using key cloud resource types. The section includes a discussion how to build multitenant solutions with compute, networking, storage and data components, as well as deployment and configuration, governance, and cost management.

  The architectural approaches are intended to be useful for solution architects and lead developers.

* [**Service-specific guidance for a multitenant solution:**](service/overview.md) This section provides targeted guidance for specific Azure services. It includes discussions of the tenancy isolation models you might consider for the components in your solution, as well as any features that are particularly relevant for a multitenant solution.

  The service-specific guidance is useful for architects, lead developers, and anyone building or implementing Azure components for a multitenant solution.

Additionally, we provide a [list of related resources and links](related-resources.md) for architects and developers of multitenant solutions.

## Next steps

Review the [architectural considerations for a multitenant solution](considerations/overview.md).
