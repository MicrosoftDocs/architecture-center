---
title: Architecting multitenant solutions on Azure
titleSuffix: Azure Architecture Center
description: Learn how to build multitenant solutions on Azure through the guidance we provide in this series.
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
  - security
ms.category:
  - fcp
ms.custom:
  - guide
---

# Architect multitenant solutions on Azure

A multitenant solution is one used by multiple customers, or *tenants*. Tenants are distinct from users. Multiple users from a single organization, company, or group form a single tenant. Examples of multitenant applications include:

* Business-to-business (B2B) solutions, such as accounting software, work tracking, and other software as a service (SaaS) products.
* Business-to-consumer (B2C) solutions, such as music streaming, photo sharing, and social network services.
* Enterprise-wide platform solutions, such as a shared Kubernetes cluster that's used by multiple business units within an organization.

When you build your own multitenant solution in Azure, there are several elements you need to consider that factor into your architecture.

In this series, we provide guidance about how to design, build, and operate your own multitenant solutions in Azure.

> [!NOTE]
> In this series, we use the term *tenant* to refer to **your** tenants, which might be your customers or groups of users. Our guidance is intended to help you to build your own multitenant software solutions on top of the Azure platform.
>
> Azure Active Directory (Azure AD) also includes the concept of a tenant to refer to individual directories, and it uses the term *multitenancy* to refer to interactions between multiple Azure AD tenants. Although the terms are the same, the concepts are not. When we need to refer to the Azure AD concept of a tenant, we disambiguate it by using the full term *Azure AD tenant*.

## Scope

Azure is itself a multitenant service, and some of our guidance is based on our experience with running large multitenant solutions. However, the focus of this series is on helping you build your own multitenant services, while harnessing the power of the Azure platform.

Additionally, when you design a solution, there are many areas you need to consider. The content in this section is specific to how you design for multitenancy. We don't cover all of the features of the Azure services, or all of the architectural design considerations for every application. You should read this guide in conjunction with the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) and the documentation for each Azure service that you use.

## Intended audience

The guidance provided in this series is applicable to anyone building a multitenant application in Azure. The audience also includes anybody who is building SaaS products, such as independent software vendors (ISVs) and startups, whether those SaaS products are targeted for businesses or consumers. It also includes anyone building a product or platform that's intended to be used by multiple customers or tenants.

Some of the content in this series is designed to be useful for technical decision-makers, like chief technology officers (CTOs) and architects, and anyone designing or implementing a multitenant solution on Microsoft Azure. Other content is more technically focused and is targeted at solution architects and engineers who implement a multitenant solution.

> [!NOTE]
> *Managed service providers* (MSPs) manage and operate Azure environments on behalf of their customers, and work with multiple Azure Active Directory tenants in the process. This is another form of multitenancy, but it's focused on managing Azure resources across multiple Azure Active Directory tenants. This series isn't intended to provide guidance on these matters.
>
> However, the series is likely to be helpful for ISVs who build software for MSPs, or for anyone else who builds and deploys multitenant software.

## What's in this series?

The content in this series is composed of three main sections:

* [**Architectural considerations for a multitenant solution:**](considerations/overview.yml) This section provides an overview of the key requirements and considerations you need to be aware of when planning and designing a multitenant solution.

  The architectural considerations are particularly relevant for technical decision-makers, like chief technology officers (CTOs) and architects. Product managers will also find it valuable to understand how multitenancy affects their solutions. Additionally, anyone who works with multitenant architectures should have some familiarity with these principles and tradeoffs.

* [**Architectural approaches for multitenancy:**](approaches/overview.yml) This section describes the approaches you can consider when designing and building multitenant solutions, by using key cloud resource types. The section includes a discussion how to build multitenant solutions with compute, networking, storage, data, messaging, identity, AI/ML, and IoT components, as well as deployment, configuration, resource organization, governance, compliance, and cost management.

  The architectural approaches are intended to be useful for solution architects and lead developers.

* [**Service-specific guidance for a multitenant solution:**](service/overview.md) This section provides targeted guidance for specific Azure services. It includes discussions of the tenancy isolation models that you might consider for the components in your solution, as well as any features that are particularly relevant for a multitenant solution.

  The service-specific guidance is useful for architects, lead developers, and anyone building or implementing Azure components for a multitenant solution.

Additionally, we provide a [list of related resources and links](related-resources.md) for architects and developers of multitenant solutions.

## Video

For an overview of the content covered in this series, and the basic concepts of multitenancy, see this video from Microsoft Reactor:

<br/>

> [!VIDEO https://www.youtube.com/embed/aem8elgN7iI]

## Next steps

Review the [architectural considerations for a multitenant solution](considerations/overview.yml).
