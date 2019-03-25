---
title: "CAF: Simple Migration Journey"
description: Learn how to migrate your services to Azure effectively for your organization with step-by-step guidance.
author: matticusau
ms.author: mlavery
ms.date: 4/14/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack - new"
---

::: zone target="chromeless"

# Before you start  

::: zone-end

::: zone target="docs"

# Intro to the journey / guide

::: zone-end

Before you start migrating your services to your Azure environment, you need to decide the migration methodology and features which will be utilized to govern and secure your environment. This playbook walks you through this journey and decision making.

::: zone target="docs"

For the best experience, view this playbook in the Azure portal. Go to the **Azure QuickStart Center** in the Azure portal and select **Migrate your environment to Azure**. The Azure QuickStart Center is currently in preview.

::: zone-end

# [Overview](#tab/Overview)

This guide will focus on the **Rehost** migration journey. Also known as "lift and shift," a rehost effort moves the current state asset to the chosen cloud provider, with minimal change to overall architecture. This guide is designed for straightforward migration scopes, for information related to migration scopes which require more planning and expanded scopes, please refer to the accompanying documentation in the [CAF: Azure Migration Guide > Expanded Scope](../expanded-scope/).

When you migrate to Azure, you may migrate as-is, however you may have flexibility on the types of resources, where they are located, and how to set them up. As you consider your migration strategy, you might wonder:

* How do I know which services to migrate to?
* How do I minimize downtime during the migration?
* How do I control costs?
* How do I track resource costs and bill it accurately?
* How do I ensure I remain compliant and meet regulations?
* How do I meet legal requirements for data sovereignty in certain countries?

This guide helps address those questions. It suggests the tasks and features you should consider as you get ready to deploy resources in Azure. Specifically:

> [!div class="checklist"]
> * **Pre-requisites**: Plan and determine your migration.
> * **Assess your technical fit**: Validate the technical readiness and suitability for migration.
> * **Migrate your services**: Perform the actual migration.
> * **Manage costs and billing**: Look at the costs of your resources.
> * **Organize your resources**: Lock resources critical to your system and tag resources to track them.
> * **Optimize and Transform**: Utilize the post migration opportunity to review your resources
> * **Secure and Manage**: Ensure that your environment is secure and being monitored.
> * **Assistance**: Get help and support during your migration or post migration activities.

::: zone target="docs"

To learn more, see [Governance in Azure](/azure/security/governance-in-azure/). 

::: zone-end

# [Migration Options](#tab/MigrationOptions)

There are a number of methodologies available for performing a cloud migration. Some are better suited to different scenarios than others. While this guide focuses on the **Rehost** methodology, as you consider how to migrate your environment please consider all of the following options to decide if this guide is the right approach for your purpose.

> * **Rehost** - Also known as "lift and shift," a rehost effort moves the current state asset to the chosen cloud provider, with minimal change to overall architecture.
> * **Refactor** - Platform as a Service (PaaS) options can reduce operational costs associated with many applications. It can be prudent to slightly refactor an application to fit a PaaS based model. Refactor also refers to the application development process of refactoring code to allow an application to deliver on new business opportunities.
> * **Rearchitect** - Some aging applications aren't compatible with cloud providers because of the architectural decisions made when the application was built. In these cases, the application may need to be rearchitected prior to transformation.
> * **Rebuild** - In some scenarios, the delta that must be overcome to carry forward an application can be too large to justify further investment and the solution must be rebuilt.
> * **Replace** - Solutions are generally implemented using the best technology and approach available at the time. In some cases, Software as a Service (SaaS) applications can meet all of the functionality required of the hosted application. In these scenarios, a workload could be slated for future replacement, effectively removing it from the transformation effort.

These methodologies are not mutually exclusive as while the initial migration used **Rehost**, you may choose to implement **Refactor** or **Rearchitect** as part of the post migration optimization phase. This will be revisited in the Optimize and Transform section of this guide.

![Infographic of the migration options](../../_images/migration/migration-options.png)
