---
title: "CAF: Simple Migration Journey"
description: Learn how to migrate your services to Azure effectively for your organization, with step-by-step guidance.
author: matticusau
ms.author: mlavery
ms.date: 04/04/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: fasttrack-new
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

This guide covers the **rehost** migration journey. Also known as **lift-and-shift**, a rehost effort moves current state assets to Azure, with minimal changes to overall architecture. This guide is designed for migration efforts with low complexity. To determine whether this scope meets your needs, see the **When to use this guide** tab.

When you migrate to Azure, you can migrate resources as-is. However, you have flexibility regarding the types of resources you migrate, where to locate them, and how to set them up. As you consider your migration strategy, you might ask:

- How do I know which services to migrate to?
- How do I minimize downtime during the migration?
- How do I control costs?
- How do I track resource costs and bill them accurately?
- How do I ensure we remain compliant and meet regulations?
- How do I meet legal requirements for data sovereignty in certain countries?

This guide helps answer those questions. It suggests the tasks and features you should consider as you prepare to deploy resources in Azure, including:

> [!div class="checklist"]
>
> - **Configure prerequisites.** Plan and prepare for migration.
> - **Assess your technical fit.** Validate the technical readiness and suitability for migration.
> - **Migrate your services.** Perform the actual migration.
> - **Manage costs and billing.** Look at the costs of your resources.
> - **Organize your resources.** Lock resources critical to your system and tag resources to track them.
> - **Optimize and transform.** Use the post-migration opportunity to review your resources.
> - **Secure and manage.** Ensure that your environment is secure and monitored properly.
> - **Get assistance.** Get help and support during your migration or post-migration activities.

::: zone target="docs"

To learn more, see [Governance in Azure](/azure/security/governance-in-azure/).

::: zone-end

# [When to use this guide](#tab/WhenToUseThisGuide)

This guide is designed for migrations with minimal complexity. This migration guide may meet your needs in the following cases:

- You are migrating a homogeneous environment.
- Very few business units need to align to complete the migration.
- You are not planning to automate the entire migration.
- You are migrating a small number of servers.
- The dependency mapping of the components to be migrated is simple to define.
- Your industry has minimal regulatory requirements relevant to this migration.

If any of these cases don't apply to your situation, you should instead consider the information provided in the [Expanded Scope Guide](../expanded-scope/index.md). We also recommend you request assistance from one of our Microsoft teams or partners to perform migrations requiring the expanded scope guide. we have found that customers who engage with Microsoft or certified partners are more successful in these scenarios. More information about requesting assistance can be found in the relevant section of this guide.

::: zone target="docs"

For more information, see:

- [Migration Expanded Scope](../expanded-scope/index.md)

::: zone-end

# [Migration options](#tab/MigrationOptions)

You can perform a cloud migration several ways. Some are better suited to different scenarios than others. While this guide focuses on the rehost method, you should consider all these choices and decide if this guide provides the right approach to migrate your environment.

- **Rehost:** Also known as lift-and-shift, a rehost effort moves the current state asset to Azure, with minimal change to overall architecture.
- **Refactor:** Platform as a service (PaaS) options can reduce operational costs associated with many applications. It can be prudent to slightly refactor an application to fit a PaaS model. This also refers to the application development process of refactoring code to allow an application to deliver on new business opportunities.
- **Rearchitect:** Some aging applications aren't compatible with cloud providers because of the architectural decisions made when the application was built. In these cases, the application may need to be rearchitected as part of a migration.
- **Rebuild:** In some scenarios, the changes required to migrate an application can be too large to justify further investment, and the solution must be rebuilt.
- **Replace:** Solutions are generally implemented using the best technology and techniques available at the time. In some cases, modern software as a service (SaaS) applications can meet all of the functionality provided by the hosted application. In these scenarios, a workload could be slated for future replacement, thus removing it from consideration as part of the migration.

These methods are not mutually exclusive&mdash;for example, while your initial migration might use **rehost**, you may choose to implement **refactor** or **rearchitect** as part of the-post migration optimization phase. This will be revisited in the Optimize and Transform section of this guide.

![Infographic of the migration options](../../_images/migration/migration-options.png)
