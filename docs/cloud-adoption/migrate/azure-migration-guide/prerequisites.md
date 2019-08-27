---
title: "Prerequisites for migrating to Azure"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Prerequisites for migrating to Azure
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

# Prerequisites

::: zone-end

::: zone target="docs"

# Prerequisites for migrating to Azure

::: zone-end

The resources in this section will help prepare your current environment for migration to Azure.

# [Overview](#tab/Overview)

Reasons for migrating to Azure include removing risks associated with legacy hardware, reducing capital expense, freeing up datacenter space, and quickly realizing return on investment (ROI).

- **Eliminate legacy hardware.** You may have applications hosted on infrastructure that is nearing end of life or support, whether on-premises or at a hosting provider. Migration to the cloud offers an attractive solution to the challenge as the ability to migrate "as-is" allows the team to quickly resolve the current infrastructure lifecycle challenge and then turn its attention to long-term planning for application lifecycle and optimization in the cloud.
- **Address end-of-support for software.** You may have applications that depend on other software or operating systems that are nearing end of support. Moving to Azure may provide extended support options for these dependencies or other migration options that minimize refactoring requirements to support your applications going forward. For example, see [extended support options for Windows Server 2008 and SQL Server 2008](https://azure.microsoft.com/blog/announcing-new-options-for-sql-server-2008-and-windows-server-2008-end-of-support).
- **Reduce capital expense.** Hosting your own server infrastructure requires considerable investment in hardware, software, electricity, and personnel. Migrating to a cloud solution can provide significant reductions in capital expense. To achieve the best capital expense reductions, a redesign of the solution may be required. However, an "as-is" migration is a great first step.
- **Free up datacenter space.** You may choose Azure in order to expand your datacenter capacity. One way to do this is using the cloud as an extension of your on-premises capabilities.
- **Quickly realize return on investment.** Making a return on investment (ROI) is much easier with cloud solutions, as the cloud payment model provides great utilization insight and promotes a culture for realizing ROI.

Each of the above scenarios may be entry points for extending your cloud footprint using another methodology (rehost, refactor, rearchitect, rebuild, or replace).

## Migration characteristics

The guide assumes that prior to this migration, your digital estate consists mostly of on-premises hosted infrastructure and may include hosted business-critical applications. After a successful migration, your data estate may look very much how it did on-premises but with the infrastructure hosted in cloud resources. Alternatively, the ideal data estate is a variation of your current data estate, since it has aspects of your on-premises infrastructure with components which have been refactored to optimize and take advantage of the cloud platform.

The focus of this migration journey is to achieve:

- Remediation of legacy hardware end-of-life.
- Reduction of capital expense.
- Return on investment.

> [!NOTE]
> An additional benefit of this migration journey is the additional software support model for Windows 2008, Windows 2008 R2, and SQL Server 2008, and SQL Server 2008 R2. For more information, see:
>
> - [Windows Server 2008 and Windows Server 2008 R2](https://www.microsoft.com/cloud-platform/windows-server-2008).
> - [SQL Server 2008 and SQL Server 2008 R2](https://www.microsoft.com/sql-server/sql-server-2008).

# [Understand migration approaches](#tab/Approach)

The strategy and tools you use to migrate an application to Azure will largely depend on your business motivations, technology requirements, and timelines, as well as a deep understanding of the actual workload and assets (infrastructure, apps, and data) being migrated.

Before determining your cloud migration strategy, analyze candidate applications to identify their compatibility with cloud-hosting technologies. Use the Cloud Adoption Framework's [migration tools decision guide](../../decision-guides/migrate-decision-guide/index.md) to help you get started with this process.

An IaaS-focused migration, where servers (along with their associated applications and data) are rehosted in the cloud using virtual machines (VMs), is often the most straightforward approach to move workloads to the cloud. However, consider that correctly configuring, securing, and maintaining VMs can require more time and IT expertise compared to using PaaS services in Azure. If you're considering Azure Virtual Machines, make sure that you take into account the ongoing maintenance effort required to patch, update, and manage your VM environment.

When assessing workloads for migration, identify applications that would not require substantial modification to run using PaaS technologies such as Azure App Service or orchestrators like Azure Kubernetes Service. These apps should be the first candidates for modernization and cloud optimization.

## Learn more

- [Cloud Adoption Framework migration tools decision guide](../../decision-guides/migrate-decision-guide/index.md)
- [The Five Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)

# [Planning checklist](#tab/Checklist)

Before starting a migration, you'll need to complete some prerequisites. The exact details of these activities vary depending on the environment being migrated. Generally, the following checklist applies:

> [!div class="checklist"]
>
> - **Identify stakeholders:** Identify the key people who have a role to play or a stake in the outcome of the migration.
> - **Identify key milestones:** To effectively plan the migration timelines, identify key milestones to meet.
> - **Identify the migration strategy:** Determine which of the 5 Rs of rationalization you will use.
> - **Assess your technical fit:** Validate the technical readiness and suitability for migration, and determine what level of assistance you may require from external partners or Azure support.
> - **Migration planning:** Perform the detailed assessment and planning required to prepare your assets (infrastructure, apps, and data) as well as Azure infrastructure for the migration.
> - **Test your migration:** Validate your migration plan by performing limited-scope test migration.
> - **Migrate your services:** Perform the actual migration.
> - **Post-migration:** Understand what is required after you migrate your environment to Azure.

Assuming you choose a rehost approach to migration, the following activities will also be relevant:

> [!div class="checklist"]
>
> - **Governance alignment:** Has a consensus been achieved regarding alignment of governance with the migration foundation?
> - **Network:** A network strategy should be selected and aligned to IT security requirements.
> - **Identity:** A hybrid identity strategy should be aligned to fit the identity management and cloud adoption plan.

::: zone target="docs"

<!-- markdownlint-disable MD024 -->

## Learn more

- [The 5 Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)
- [Migration tools decision guide](../../decision-guides/migrate-decision-guide/index.md)
- [Cloud Adoption Framework planning checklist](../migration-considerations/prerequisites/planning-checklist.md)

::: zone-end
