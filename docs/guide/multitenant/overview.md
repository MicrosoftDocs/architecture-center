---
title: Architect Multitenant Solutions on Azure
description: Learn how to build multitenant solutions, including B2B and B2C SaaS, on Azure by using the guidance that this series provides.
author: johndowns
ms.author: pnp
ms.date: 04/17/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
---

# Architect multitenant solutions on Azure

A multitenant solution is a solution used by multiple customers, or *tenants*. Tenants are distinct from users. Multiple users from a single organization, company, or group form a single tenant. The following examples are multitenant applications:

- Business-to-business (B2B) solutions, such as accounting software, work tracking, and other software as a service (SaaS) products

- Business-to-consumer (B2C) solutions, such as music streaming, photo sharing, and social network services

- Enterprise-wide platform solutions, such as a shared Kubernetes cluster that multiple business units within an organization use

When you build your own multitenant solution in Azure, there are several elements that you need to consider for your architecture.

This series provides guidance about how to design, build, and operate your own multitenant solutions in Azure.

> [!NOTE]
> In this series, the term *tenant* refers to **your** tenants, which might be your customers or groups of users. The guidance is intended to help you build multitenant software solutions on top of the Azure platform.  
>
> Microsoft Entra ID also uses the term *tenant* to refer to individual directories. It defines *multitenancy* as interactions between multiple Microsoft Entra tenants. The terms are the same, but the concepts differ. To avoid ambiguity, the full term, *Microsoft Entra tenant*, is used when referring to the Microsoft Entra concept of a tenant.

## Scope

Azure is a multitenant service, and some of our guidance is based on our experience with designing and operating large multitenant solutions. However, this series focuses on helping you build your own multitenant services while harnessing the power of the Azure platform.

When you design a solution, there are many areas that you need to consider. The content in this section is specific to how you design for multitenancy. It doesn't cover all of the features of the Azure services or all of the architectural design considerations for every application. You should read this guide together with the [Azure Well-Architected Framework](/azure/well-architected/) and the documentation for each Azure service that you use.

## Intended audience

The guidance provided in this series applies to anyone building a multitenant application in Azure. The audience also includes anyone building SaaS products, such as independent software vendors (ISVs) and startups building solutions that target businesses or consumers. It also includes anyone building a product or platform that's intended for use by multiple customers or tenants.

Some of the content in this series is designed to be useful for technical decision-makers, like chief technology officers (CTOs) and architects, and anyone designing or implementing a multitenant solution on Azure. Other content has a more technical focus and targets solution architects and engineers who implement a multitenant solution.

> [!NOTE]
> *Managed service providers (MSPs)* manage and operate Azure environments on behalf of their customers and work with multiple Microsoft Entra tenants in the process. This approach is another form of multitenancy. However, it focuses on Azure resource management across multiple Microsoft Entra tenants. This series isn't intended to provide guidance for those scenarios.
>
> This series is likely to be helpful for ISVs who build software for MSPs or for anyone who builds and deploys multitenant software.

## What's in this series?

The content in this series is composed of three main sections:

- **[Architectural considerations for a multitenant solution](considerations/overview.yml):** This section provides an overview of the key requirements and considerations that you need to know when you plan and design a multitenant solution.

  The architectural considerations are especially relevant for technical decision-makers, like CTOs and architects. Product managers also benefit from understanding how multitenancy affects their solutions. Also, anyone who works with multitenant architectures should have some familiarity with these principles and trade-offs.

- **[Architectural approaches for multitenancy](approaches/overview.md):** This section describes the approaches that you can consider when you design and build multitenant solutions by using key cloud resource types. This section includes a discussion about how to build multitenant solutions with compute, networking, storage, data, messaging, identity, AI and machine learning, and Internet of Things components, as well as deployment, configuration, resource organization, governance, compliance, and cost management.

  The architectural approaches are intended to be useful for solution architects and lead developers.

- **[Service-specific guidance for a multitenant solution](service/overview.md):** This section provides targeted guidance for specific Azure services. It includes descriptions of the tenancy isolation models that you might consider for the components in your solution and any features that are especially relevant for a multitenant solution.

  The service-specific guidance is useful for architects, lead developers, and anyone building or implementing Azure components for a multitenant solution.

A checklist is also available for when you [design and build a multitenant solution](checklist.md), along with a [list of related resources and links](related-resources.md) for architects and developers of multitenant solutions.

## Video

For an overview of the content covered in this series and the basic concepts of multitenancy, see the following video from Microsoft Reactor:

<br/>

> [!VIDEO https://www.youtube.com/embed/aem8elgN7iI]

## Related resource

- [Architectural considerations for a multitenant solution](considerations/overview.yml)
