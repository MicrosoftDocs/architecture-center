---
title: "Introduction to the Azure migration guide"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn how to effectively migrate your organization's services to Azure with step-by-step guidance.
author: matticusau
ms.author: mlavery
ms.date: 04/04/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: migrate
ms.custom: fasttrack-new, AQC
ms.localizationpriority: high
---

::: zone target="chromeless"

# Before you start

::: zone-end

::: zone target="docs"

# Introduction to the Azure migration guide

::: zone-end

Before you migrate resources to Azure, you need to choose the migration method and the features you'll use to govern and secure your environment. This guide leads you through this decision process.

::: zone target="docs"

> [!TIP]
> For an interactive experience, view this guide in the Azure portal. Go to the [Azure Quickstart Center](https://portal.azure.com/?feature.quickstart=true#blade/Microsoft_Azure_Resources/QuickstartCenterBlade) in the Azure portal and select **Migrate your environment to Azure**.

::: zone-end

# [Overview](#tab/Overview)

This guide walks you through the basics of migrating applications and resources from your on-premises environment to Azure. It is designed for migration scopes with minimal complexity. To determine the suitability of this guide for your migration, see the **When to use this guide** tab.

When you migrate to Azure, you may migrate your applications as-is using IaaS-based virtual machine solutions (known as a "rehost" or "lift and shift" migration), or you may have the flexibility to use managed services and other cloud-native features to modernize your applications. See the **Migration options** tab for more information on these choices. As you develop your migration strategy, you might consider:

- Will my migrating applications work in the cloud?
- What is the best strategy (with regard to technology, tools, and migrations) for my application? See the Microsoft Cloud Adoption Framework's [Migration tools decision guide](../../decision-guides/migrate-decision-guide/index.md) for more information.
- How do I minimize downtime during the migration?
- How do I control costs?
- How do I track resource costs and bill them accurately?
- How do I ensure we remain compliant and meet regulations?
- How do I meet legal requirements for data sovereignty in certain countries?

This guide helps answer these questions. It suggests the tasks and features to consider as you prepare to deploy resources in Azure, including:

> [!div class="checklist"]
>
> - **Configure prerequisites.** Plan and prepare for migration.
> - **Assess your technical fit.** Validate the technical readiness and suitability for migration.
> - **Manage costs and billing.** Look at the costs of your resources.
> - **Migrate your services.** Perform the actual migration.
> - **Organize your resources.** Lock resources critical to your system and tag resources to track them.
> - **Optimize and transform.** Use the post-migration opportunity to review your resources.
> - **Secure and manage.** Ensure that your environment is secure and monitored properly.
> - **Get assistance.** Get help and support during your migration or post-migration activities.

::: zone target="docs"

To learn more about organizing and structuring your subscriptions, managing your deployed resources, and complying with your corporate policy requirements, see [Governance in Azure](/azure/security/governance-in-azure).

::: zone-end

# [When to use this guide](#tab/WhenToUseThisGuide)

While the tools discussed in this guide support a wide variety of migration scenarios, this guide will focus on limited scope efforts with _minimal complexity_. To determine whether this migration guide is suitable for your project, consider if the following conditions apply to you:

- You are migrating a homogeneous environment.
- Only a few business units need to align to complete the migration.
- You're not planning to automate the entire migration.
- You're migrating a small number of servers.
- The dependency mapping of the components to be migrated is simple to define.
- Your industry has minimal regulatory requirements relevant to this migration.

If any of these conditions _don't_ apply to your situation, you should instead consider the [expanded scope guide](../expanded-scope/index.md). We also recommend you request assistance from one of our Microsoft teams or partners to perform migrations requiring the expanded scope guide. Customers who engage with Microsoft or certified partners are more successful in these scenarios. More information about requesting assistance is available in this guide.

<!-- markdownlint-enable MD033 -->

::: zone target="docs"

For more information, see:

- [Expanded scope guide](../expanded-scope/index.md)

::: zone-end

# [Migration options](#tab/MigrationOptions)

You can perform a cloud migration several ways. Some are better suited to different scenarios than others. As you determine how to migrate your environment, consider the following options when deciding on a migration strategy:

- **Rehost:** Also known as "lift and shift", a rehost effort moves the current state to Azure, with minimal change to overall architecture.
- **Refactor:** Platform as a service (PaaS) options can reduce operational costs associated with many applications. It can be prudent to slightly refactor an application to fit a PaaS model. This also refers to the application development process of refactoring code to allow an application to deliver on new business opportunities.
- **Rearchitect:** Some aging applications aren't compatible with cloud providers because of the architectural decisions made when the application was built. In these cases, the application may need to be rearchitected as part of a migration.
- **Rebuild:** In some scenarios, the changes required to migrate an application can be too large to justify further investment, and the solution must be rebuilt.
- **Replace:** Solutions are generally implemented using the best technology and techniques available at the time. In some cases, modern software as a service (SaaS) applications can meet all of the functionality provided by the hosted application. In these scenarios, a workload could be scheduled for future replacement, thus removing it from consideration as part of the migration.

::: zone target="chromeless"

These methods are not mutually exclusive&mdash;for example, while your initial migration might use a **rehost** model, you may choose to implement **refactor** or **rearchitect** as part of the post-migration optimization phase. This is revisited in the **Optimize and transform** section of this guide.

::: zone-end

::: zone target="docs"

These methods are not mutually exclusive&mdash;for example, while your initial migration might use a **rehost** model, you may choose to implement **refactor** or **rearchitect** as part of the post-migration optimization phase. This is revisited in the [Optimize and transform](optimize-and-transform.md) section of this guide.

::: zone-end

![Infographic of the migration options](../../_images/migration/migration-options.png)
