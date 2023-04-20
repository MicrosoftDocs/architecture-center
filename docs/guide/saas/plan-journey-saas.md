---
title: Overview of the journey for designing SaaS and multitenant solutions
description: This guide provides an overview of the journey to create a SaaS solution. It also provides links to resources used in many SaaS, multitenant, Azure Marketplace, and ISV & Startup scenarios.
author: landonpierce 
ms.author: landonpierce 
ms.date: 04/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
---
# Plan your journey to SaaS

Building and operating software as a service (SaaS) presents both a unique opportunity and a unique challenge for a business at any stage. The considerations of SaaS are important to keep in mind not only when planning your SaaS offering, but also on a daily basis as you operate your business.

The following diagram depicts the typical journey a company goes through while building a SaaS product. Understanding this process is helpful for knowing which resources apply to you at your current stage. The rest of the article provides a brief description of each stage of the SaaS journey and any links that are relevant to a business currently in that stage.

:::image type="content" alt-text="Diagram that shows the journey of a SaaS product." source="./images/saas-journey.png" border="false" :::

## 1. Plan for a SaaS business model

The first stage in the SaaS journey is centered around business decisions. Business decisions must be thought through carefully before making any technical decisions, as they eventually become the software requirements for your application. At a minimum, consider these issues:

- **Identify the problem you're trying to solve.**  SaaS solutions are designed to solve business problems. Identify the business problem you're trying to solve before designing a solution around it.
- **Know how your solution solves the problem.** Understand clearly how your designed SaaS solution solves the problem you identified.
- **Know your pricing model.** SaaS solutions are ultimately designed to generate revenue. Understand the various [pricing models](/azure/architecture/guide/multitenant/considerations/pricing-models) and which one aligns best with the solution you're designing.
- **Understand your customers and how they will interact with your application.** Know who your customers are and what features they care about. Knowing this up front saves you precious time and energy so that you're not developing features that are underutilized.

In addition to your application requirements, also consider these few things that relate to your overall business:

- **Ensure your business is ready to take on the responsibility of operating a SaaS application.** Operating a SaaS business means customers depend solely on your company for things like support. Make sure you have the ability to provide support for the application, potentially on a 24/7 basis.  
- **Ensure you have a smooth path for migration from legacy offerings.** If you plan on migrating from a different business model, make sure you have a plan in place for migrating your customers without too much disruption.
- **Understand how the processes you establish will scale.** As you're planning, proceed with the understanding that processes need to change over time as your business grows. You might be able to do some things manually when you only have a handful of customers, but this approach doesn't scale well. For more information, see these articles:

- [Foundations of SaaS](/training/saas/saas-foundations/) - A Microsoft Learn module about the foundations of SaaS
- [Accelerate and de-risk your journey to SaaS](https://www.youtube.com/watch?v=B8dPAFIG1xA) - A video from Microsoft Ignite 2021 that outlines the key considerations, challenges, and other lessons for SaaS migration and modernization projects.
- [Microsoft SaaS Academy](https://www.microsoft.com/en-us/saas-academy/main) - Free SaaS learning courses.
- [Pricing model considerations](../multitenant/considerations/pricing-models.md) - Important technical considerations to keep in mind when deciding on a pricing strategy.
- [Microsoft for Startups Founders Hub](https://www.microsoft.com/startups) - A resource center for startups building solutions on Azure that provides business and technical mentoring, such as Microsoft software for running your business including LinkedIn, Microsoft 365 and GitHub Enterprise, and Azure credits.
- [Microsoft SaaS Stories](https://aka.ms/saasstories) - A series of video interviews with some of Microsoft's ISV partners that highlight their experiences building SaaS.

## 2. Design and architect a SaaS solution

After deciding what your business requirements are, the next stage in the journey is to design your application to support your requirements. SaaS products typically need to take into account the concept of multitenancy, and there are many considerations that come into play. The output of this step should be an application architecture that addresses your specific requirements and any considerations. For more information, see these articles:

- [Architect multitenant solutions on Azure](../multitenant/overview.md) - An introduction to multitenant applications on Azure.
- [Multitenant architecture considerations](../multitenant/considerations/overview.yml) - Key considerations of designing a multitenant architecture.
- [Tenancy models](../multitenant/considerations/tenancy-models.yml) - An overview of the main tenancy models and the differences between them.
- [Independent software vendor (ISV) considerations for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/isv-landing-zone) - A comparison between different landing zones for ISV scenarios.
- [Azure Well-Architected Framework](/azure/architecture/framework) - A set of guiding tenets that help improve the quality of a workload.
- [Technical guide to building SaaS apps on Azure](https://azure.microsoft.com/resources/technical-guide-to-building-saas-apps-on-azure/) - An E-book created for ISVs, technical professionals, and technical business leaders that outlines several SaaS technical decision points.
- [Architecture for startups](../startups/startup-architecture.md) - An introduction to architectures for startups.

## 3. Implement a SaaS solution

You need to implement the architecture you developed. In this stage, you develop and iterate on your SaaS product using the normal software development life cycle (SDLC) process. It's important in this stage to not put too many requirements into development at one time. Try to figure out which features would provide the most benefit to your customers and start from a minimum viable product (MVP). More iterations with smaller improvements over time are easier to implement than larger chunks of development. For more information, see these articles:

- [SaaS starter web app architecture](../../example-scenario/apps/saas-starter-web-app.yml) - A reference architecture for a starter web-based SaaS application.
- [Azure SaaS Dev Kit](https://github.com/azure/azure-saas) - A modular implementation of the architecture designed to provide a starting place for building a SaaS application in .NET.

## 4. Operate your SaaS solution

In this stage, you begin to onboard customers to your new SaaS product and begin operating as a SaaS provider with users in production. Have your SaaS product close to completion and have a strategy to migrate existing customers or onboard new ones. Have a plan in place to support your customers if problems arise. It's also important to begin identifying key performance indicator (KPI) metrics that you can collect, which help drive various business and technical decisions later on. For more information, see these articles:

- [Deploy multitenant applications](../multitenant/considerations/updates.md) - Considerations for maintaining and deploying to your multitenant application.
- [Measure tenant consumption](../multitenant/considerations/measure-consumption.md) - Considerations for collecting consumption data from your multitenant application.

## 5. Market and sell your SaaS solution

In this stage, you begin to market and sell your SaaS solution. Explore all avenues available to you for selling your application, including but not limited to the [Azure Marketplace](https://azure.microsoft.com/partners/marketplace). This stage is also when you begin to take the KPI data from the previous stage and use it to analyze how your customers are interacting with your SaaS application. Then use that analysis to make business and technical decisions about the roadmap of your SaaS product. For more information, see these articles:

- [Mastering the marketplace](https://aka.ms/MasteringTheMarketplace) - Learning content that is focused around how to best take advantage of the Azure Marketplace.
- [Marketplace publishing guide](/azure/marketplace/publisher-guide-by-offer-type) -  The offer types that are available in the Azure Marketplace and the key differences between them.
- [Marketing best practices](/azure/marketplace/gtm-marketing-best-practices) - A comprehensive guide for using the Azure Marketplace to market and sell your application.
- [Plan a SaaS marketplace offer](/azure/marketplace/plan-saas-offer) - The documentation page for how to plan a SaaS offer on the Azure Marketplace.
- [Co-sell with Microsoft sales teams](/partner-center/co-sell-overview) - An overview of how to Co-sell with Microsoft sales teams.
- [Join the Microsoft partner network](https://partner.microsoft.com) - The Microsoft partner network. Here, you register your company as a Microsoft partner and obtain information about the various partner programs.

## 6. Repeat the process

Developing SaaS solutions is a cyclical journey. To get the most out of your SaaS product, you must constantly iterate and adapt to the needs of your customers and the market. After you have made your decisions about the current direction of your product, the process starts over at stage one. For more information, see these articles:

- [Azure well-architected review](/assessments/azure-architecture-review/) - An assessment of your workload against the Azure Well Architected Framework that results in curated and personalized guidance for your scenario. Complete this review regularly to identify areas of your application you can improve.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Customer Engineer, FastTrack for Azure
- [Arsen Vladimirsky](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
- [Irina Kostina](https://www.linkedin.com/in/irina-kostina/) | Software Engineer, FastTrack for Azure
- [Nick Ward](https://www.linkedin.com/in/nickward13) | Senior Cloud Solution Architect

## Next steps

- [Foundations of SaaS](/training/saas/saas-foundations/)
- [Technical guide to building SaaS apps on Azure](https://azure.microsoft.com/resources/technical-guide-to-building-saas-apps-on-azure/)
- [Azure Well-Architected Framework](/azure/architecture/framework)

## Related resources

- [SaaS and multitenant solution architecture](overview.md)
- [Understand how startups architect their solutions](../startups/startup-architecture.md)
- [Learn about multitenant architectural approaches](../multitenant/overview.md)
