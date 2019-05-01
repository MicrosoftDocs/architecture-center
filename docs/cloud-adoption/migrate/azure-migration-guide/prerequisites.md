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
- **Software end of support.** You may have applications that are dependent on other software or operating systems that are nearing end of support. Moving to Azure may offer extended support options for these dependencies (for example extended support for [Windows Server 2008 and SQL Server 2008](https://azure.microsoft.com/en-us/blog/announcing-new-options-for-sql-server-2008-and-windows-server-2008-end-of-support/)) or other migration options that minimize refactoring requirements to support your applications going forward."
- **Reduce capital expense.** Hosting your own server infrastructure requires considerable investment in hardware, software, electricity, and personnel. Migrating to a cloud solution can provide significant reductions in capital expense. To achieve the best capital expense reductions, a redesign of the solution may be required, however an "as-is" migration is a great first step.
- **Free up datacenter space.** You may choose Azure through the need to expand your datacenter capacity and one way to do this is to use the cloud as an extension of your on-premises services.
- **Quick return on investment.** Getting a return on investment (ROI) is much easier with cloud solutions as the cloud payment model provides great utilization insight and promotes a culture to realize ROI.

Each of the above scenarios may be entry points to then extend your cloud footprint using another methodology (rehost, refactor, rearchitect, rebuild or replace).

## Migration characteristics

The guide assumes that prior to this migration, your digital estate consists mostly of on-premises hosted infrastructure and possibly hosted business-critical applications. After a successful migration, your data estate may look very much how it did on-premises but with the infrastructure hosted in cloud resources. Alternatively, the ideal data estate is a variation of your current data estate, since it has aspects of your on-premises infrastructure with components which have been refactored to optimize and take advantage of the cloud platform.

The focus of this migration journey is to achieve:

- Remediation of legacy hardware end-of-life.
- Reduction of capital expense.
- Return on investment.

> [!NOTE]
> An additional benefit of this migration journey, is the additional software support model for Windows 2008/2008 R2 and SQL Server 2008/2008 R2. For more information, see:
>
> - [Windows Server 2008/2008 R2](/cloud-platform/windows-server-2008).
> - [SQL Server 2008/2008 R2](/sql-server/sql-server-2008).

# [Understand migration approaches](#tab/Approach)

The strategy and tools you use to migrate an application to Azure will largely depend on your business motivations, technology requirements, and timelines, as well as a deep understanding of the actual workload and assets (Infrastructure, Applications, and Data) being migrated.

Before deciding on a cloud migration strategy, analyze candidate applications to identify their compatibility with cloud hosting technologies. Use the Cloud Adoption Framework's [Migration tool decision guide](migration-decision-guide.md) to help you get started with this process.

An IaaS focused migration, where servers (and their associated applications, and data) are rehosted in the cloud using virtual machines, is often the most straightforward way to get workloads moved to the cloud. But keep in mind that correctly configuring, securing, and maintaining VMs can require more time and IT expertise compared to using PaaS services in Azure. If you're considering Azure Virtual Machines, make sure that you take into account the ongoing maintenance effort required to patch, update, and manage your VM environment.

When assessing workloads for migration, identify applications that would not require substantial modification to run using PaaS technologies such Azure App Service, Windows Containers, or orchestrators like Azure Kubernetes Service. These apps should be the first candidates for modernization and cloud optimization.

## Learn more

- [Cloud Adoption Framework migration considerations](../migration-considerations/prerequisites/index.md)
- [Cloud Adoption Framework migration tool decision guide](migration-decision-guide.md)
- [The Five Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)

# [Planning checklist](#tab/Checklist)

Before starting a migration there are a number of activities you will need to complete. The exact details of these activities will vary depending on the environment you are migrating, however, as a general rule the following checklist applies:

> [!div class="checklist"]
>
> - **Identify stakeholders:** Identify the key people who will have a role to play or stake in the outcome of the migration.
> - **Identify key milestones:** To effectively plan the migration timelines, identify key milestones to meet.
> - **Identify the migration strategy:** Determine which of the 5 Rs of rationalization you will use.
> - **Assess your technical fit:** Validate the technical readiness and suitability for migration, and determine what level of assistance you may require from external partners or Azure support.
> - **Migration planning:** Perform the detailed assessment and planning required to prepare your assets and Azure infrastructure for the migration.
> - **Test your migration:** Validate your migration plan by performing limited scope test migration.
> - **Migrate your services:** Perform the actual migration.
> - **Post-migration:** Understand what is required after you migrate your environment to Azure.

Assuming you choose a rehost approach to migration, the following activities will also be relevant:

> [!div class="checklist"]
>
> - **Governance alignment:** Has a consensus been achieved regarding alignment of governance with the migration foundation?
> - **Network:** A network strategy should be selected and aligned to IT security requirement.
> - **Identity:** A hybrid identity strategy should be aligned to fit the identity management and cloud adoption plan.

::: zone target="docs"

<!-- markdownlint-disable MD024 -->

## Learn more

- [The 5 Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)
- [Cloud Adoption Framework migration tool decision guide](migration-decision-guide.md)
- [Cloud Adoption Framework planning checklist](../migration-considerations/prerequisites/planning-checklist.md)

::: zone-end
