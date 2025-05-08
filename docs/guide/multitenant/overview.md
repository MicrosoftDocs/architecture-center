---
title: Architect Multitenant Solutions on Azure
description: Learn how to build multitenant solutions on Azure through the guidance that provided in this series.
author: johndowns
ms.author: jodowns
ms.date: 04/17/2025
ms.topic: conceptual
ms.subservice: architecture-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.custom:
  - arb-saas
---

# Architect multitenant solutions on Azure

A multitenant solution is a solution used by multiple customers, or *tenants*. Tenants are distinct from users. Multiple users from a single organization, company, or group form a single tenant. Examples of multitenant applications include:

- Business-to-business solutions, such as accounting software, work tracking, and other software as a service (SaaS) products.

- Business-to-consumer solutions, such as music streaming, photo sharing, and social network services.

- Enterprise-wide platform solutions, such as a shared Kubernetes cluster that's used by multiple business units within an organization.

When you build your own multitenant solution in Azure, there are several elements that you need to consider for your architecture.

In this series, we provide guidance about how to design, build, and operate your own multitenant solutions in Azure.

> [!NOTE]
> In this series, we use the term *tenant* to refer to **your** tenants, which might be your customers or groups of users. Our guidance is intended to help you build your own multitenant software solutions on top of the Azure platform.
>
> Microsoft Entra ID also includes the concept of a *tenant* to refer to individual directories. It uses the term *multitenancy* to refer to interactions between multiple Microsoft Entra tenants. The terms are the same, but the concepts aren't. When we refer to the Microsoft Entra concept of a tenant, we use the full term, *Microsoft Entra tenant*, to avoid ambiguity.

## Scope

Azure is a multitenant service, and some of our guidance is based on our experience with running large multitenant solutions. However, the focus of this series is on helping you build your own multitenant services, while harnessing the power of the Azure platform.

When you design a solution, there are many areas you need to consider. The content in this section is specific to how you design for multitenancy. We don't cover all of the features of the Azure services or all of the architectural design considerations for every application. You should read this guide in conjunction with the [Microsoft Azure Well-Architected Framework](/azure/well-architected/) and the documentation for each Azure service that you use.

## Intended audience

The guidance provided in this series applies to anyone building a multitenant application in Azure. The audience also includes anyone who's building SaaS products, such as independent software vendors (ISVs) and startups, that target businesses or consumers. It also includes anyone building a product or platform that's intended to be used by multiple customers or tenants.

Some of the content in this series is designed to be useful for technical decision-makers, like chief technology officers (CTOs) and architects, and anyone designing or implementing a multitenant solution on Azure. Other content has a more technical focus and targets solution architects and engineers who implement a multitenant solution.

> [!NOTE]
> *Managed service providers (MSPs)* manage and operate Azure environments on behalf of their customers and work with multiple Microsoft Entra tenants in the process. This is another form of multitenancy, but it's focused on managing Azure resources across multiple Microsoft Entra tenants. This series isn't intended to provide guidance for these scenarios.
>
> However, the series is likely to be helpful for ISVs who build software for MSPs or for anyone who builds and deploys multitenant software.

## What's in this series?

The content in this series is composed of three main sections:

- **[Architectural considerations for a multitenant solution](considerations/overview.yml):** This section provides an overview of the key requirements and considerations that you need to be aware of when you plan and design a multitenant solution.

  The architectural considerations are particularly relevant for technical decision-makers, like CTOs and architects. Product managers will also find it valuable to understand how multitenancy affects their solutions. Also, anyone who works with multitenant architectures should have some familiarity with these principles and trade-offs.

- **[Architectural approaches for multitenancy](approaches/overview.yml):** This section describes the approaches that you can consider when you design and build multitenant solutions by using key cloud resource types. This section includes a discussion about how to build multitenant solutions with compute, networking, storage, data, messaging, identity, AI/ML, and IoT components, as well as deployment, configuration, resource organization, governance, compliance, and cost management.

  The architectural approaches are intended to be useful for solution architects and lead developers.

- **[Service-specific guidance for a multitenant solution](service/overview.md):** This section provides targeted guidance for specific Azure services. It includes discussions of the tenancy isolation models that you might consider for the components in your solution and any features that are particularly relevant for a multitenant solution.

  The service-specific guidance is useful for architects, lead developers, and anyone building or implementing Azure components for a multitenant solution.

We also provide a checklist to use when you [design and build a multitenant solution](checklist.md) and a [list of related resources and links](related-resources.md) for architects and developers of multitenant solutions.

## Video

For an overview of the content covered in this series, and the basic concepts of multitenancy, see this video from Microsoft Reactor:

<br/>

> [!VIDEO https://www.youtube.com/embed/aem8elgN7iI]

Microsoft Azure Active Directory (Azure AD) is now Microsoft Entra ID. For more information, see [New name for Azure AD](/entra/fundamentals/new-name).

## Next step

Review the [architectural considerations for a multitenant solution](considerations/overview.yml).
