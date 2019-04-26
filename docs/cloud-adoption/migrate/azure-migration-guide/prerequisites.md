---
title: "CAF: Prerequisites for the Simple Migration Journey"
description: Prerequisites for the Simple Migration Journey
author: matticusau
ms.author: mlavery
ms.date: 04/04/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: fasttrack-new
---

::: zone target="chromeless"

# Prerequisites

::: zone-end

::: zone target="docs"

# Prerequisites for migrating to Azure

::: zone-end

The resources in this section will help you to prepare your current environment for migration to Azure.

# [Overview](#tab/Overview)

Reasons for migrating to Azure include removing risks associated with legacy hardware, reducing capital expense, freeing up datacenter space, and a quick return on investment (ROI).

- **Eliminate legacy hardware.** You may have applications hosted on infrastructure reaching its end of life or support, either on-premises or with a hosting provider. Migration to the cloud offers an attractive solution to the challenge as the ability to migrate "as-is" allows the team to quickly resolve the current infrastructure lifecycle challenge, while then turning attention to the long-term planning of application lifecycle and optimization to take advantage of the cloud.
- **Reduce capital expense.** Hosting your own server infrastructure requires considerable investment in hardware, software, electricity, and personal. Migrating to a cloud solution can provide significant reductions in capital expense. To achieve the best capital expense reductions, a redesign of the solution may be required, however an "as-is" migration is a great first step.
- **Free up datacenter space.** You may choose Azure through the need to expand your datacenter capacity and one way to do this is to use the cloud as an extension of your on-premises services.
- **Quick return on investment.** Getting a return on investment (ROI) is much easier with cloud solutions as the overall infrastructure costs are shared across customers. The cloud payment model provides a great way to realize ROI.

Each of the above scenarios may be entry points to then extend your cloud footprint using another scenario.

## Migration characteristics

Prior to this migration the digital estate will consist of mostly on-premises hosted infrastructure, possibly with hosting business critical applications. After a successful migration your digital estate may look very much how it did on-premises but with the infrastructure hosted in cloud resources. Alternatively the ideal digital estate will be a variation of your current digital estate as it will have aspects of your on-premises infrastructure with components which have been refactored to optimize and take advantage of the cloud platform.

The focus of this migration journey is to achieve:

- Remediation of legacy hardware end-of-life.
- Reduction of capital expense.
- Return on investment.

> [!NOTE]
> An additional benefit of this migration journey, is the additional software support model for Windows 2008/2008 R2 and SQL Server 2008/2008 R2. For more information, see:
>
> - [Windows Server 2008/2008 R2](/cloud-platform/windows-server-2008).
> - [SQL Server 2008/2008 R2](/sql-server/sql-server-2008).

# [When to use this approach](#tab/Approach)

This guide has been designed largely for rehost ("lift and shift") migrations, however many principles apply to Replatform or Refactor migrations.

If your goal is simply to move existing applications to the cloud, first identify existing applications that won't require substantial modification to run in Azure App Service. These apps should be the first candidates for Cloud-Optimized. Then, for the apps that still can't move to Windows Containers and PaaS such as App Service or orchestrators like Azure Service Fabric, migrate those to VMs (IaaS).

But, keep in mind that correctly configuring, securing, and maintaining VMs requires much more time and IT expertise compared to using PaaS services in Azure. If you're considering Azure Virtual Machines, make sure that you take into account the ongoing maintenance effort required to patch, update, and manage your VM environment. Azure Virtual Machines is IaaS.

## Learn more

- [Cloud Adoption Framework migration considerations](../migration-considerations/prerequisites/index.md)
- [The Five Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)

# [Planning checklist](#tab/Checklist)

Before starting a migration there are a number of activities you will need to complete. The exact details of these activities will vary depending on the environment you are migrating, however, as a general rule the following checklist applies:

> [!div class="checklist"]
>
> - **Identify stakeholders:** Identify the key people who will have a role to play or stake in the outcome of the migration.
> - **Identify key milestones:** To effectively plan the migration timelines, identify key milestones to meet.
> - **Identify the migration strategy:**: Determine which of the 5 Rs of rationalization you will use.
> - **Assess your technical fit:** Validate the technical readiness and suitability for migration.
> - **Migrate your services:** Perform the actual migration.
> - **Post-migration:** Understand what is required after you migrate your environment to Azure.

Assuming you choose a rehost approach to migration, the following activities will also be relevant:

> [!div class="checklist"]
>
> - **Governance alignment:** Has a consensus been achieved regarding alignment of governance with the migration foundation?
> - **Network:** A network approach should be selected and aligned to IT security requirement.
> - **Identity:** A hybrid identity approach should be aligned to fit the identity management and cloud adoption plan.

::: zone target="docs"

<!-- markdownlint-disable MD024 -->

## Learn more

- [The 5 Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)
- [Cloud Adoption Framework planning checklist](../migration-considerations/prerequisites/planning-checklist.md)

::: zone-end
