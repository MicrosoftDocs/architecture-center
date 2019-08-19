---
title: "Cloud migration expanded scope checklist"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Cloud migration expanded scope checklist
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Expanded scope for cloud migration

The [Azure migration guide](../azure-migration-guide/index.md) in the Cloud Adoption Framework is the suggested starting point for readers who are interested in a rehost migration to Azure, also known as a "lift and shift" migration. That guide walks you through a series of prerequisites, tools, and approaches to migrating virtual machines to the cloud.

While this guide is an effective baseline to familiarize you with this type of migration, it makes several assumptions. Those assumptions align the guide with a large percentage of the Cloud Adoption Framework's readers by providing a simplified approach to migrations. This section of the Cloud Adoption Framework addresses some expanded scope migration scenarios, which help guide efforts when those assumptions don't apply.

## Cloud migration expanded scope checklist

The following checklist outlines the common areas of complexity which could require the scope of the migration to be expanded beyond the [Azure migration guide](../azure-migration-guide/index.md).

- **Business-driven scope changes:**
  - [Balancing the portfolio](./balance-the-portfolio.md)
  - [Support global markets](./multiple-regions.md)
  - Cost consciousness during a migration *(Coming Q3 2019)*
- **Culture-driven scope changes:**
  - Change management and approval processes *(Coming Q3 2019)*
  - Executive readiness *(Coming Q3 2019)*
  - [Skills readiness](./suggested-skills.md)
  - Aligning support (Partner, services, and support) *(Coming Q3 2019)*
- **Technical strategy-driven scope changes:**
  - Existing datacenter constraints *(Coming Q3 2019)*
  - Migrating at scale - High volume or velocity of migrations *(Coming Q3 2019)*
  - [Multiple datacenters](./multiple-datacenters.md)
  - [Data requirements exceed network capacity](./network-capacity-exceeded.md)
  - Change management and solution documentation *(Coming Q3 2019)*
  - [Governance or compliance strategy](./governance-or-compliance.md)
- **Workload-specific scope changes:**
  - Architect workloads for resiliency *(Coming Q3 2019)*
  - Align migration to application patterns *(Coming Q3 2019)*

If any of these complexities align with your scenario, then this section of the Cloud Adoption Framework will likely provide the type of guidance needed to properly align scope in the migration processes.

Each of these scenarios is addressed by the various articles in this section of the Cloud Adoption Framework.

## Scope options explained

To help you understand each scope expansion scenario, the following list will briefly summarize the titles used in the above checklist.

### Business-driven scope changes

- **Balancing the cloud adoption portfolio:** The cloud strategy team is interested in investing more heavily in migration (rehosting existing workloads and applications with a minimum of modifications) or innovation (refactoring or rebuilding those workloads and applications using modern cloud technology). Often, a balance between the two priorities is the key to success. In this guide, the topic of balancing the cloud adoption portfolio is a common one, addressed in each of the migrate processes.
- **Support global markets:** The business operates in multiple geographic regions with disparate data sovereignty requirements. To meet those requirements, additional considerations should be factored into the prerequisite review and distribution of assets during migration.

### Culture-driven scope changes

- **Change management and approval processes:** When your organization's culture is complex, highly matrixed, or siloed the processes related to change management and approvals becomes challenging. Guidance on managing this complexity can be found in assess, migrate, and optimize processes.
- **Executive readiness:** Proper levels of executive support and leadership are critical to the success of a migration effort. If the executive team is not ready to engage, then support is unlikely to follow. This complexity is addressed during the prerequisite and assess processes.
- **Skills readiness:** When the cloud adoption team or other supporting teams are not ready to execute, it can quickly inject complexity throughout the migration effort. This challenge is addressed during each of the migration processes in a specific page on skills readiness.
- **Aligning support (Partner, service, and support options):** Within each of the the processes outlined, there are ways in which a partner, services from the cloud vendor, and support from the cloud vendor can aid in execution. In each of the processes sections a page on support alignment will discuss the options further.

### Technical strategy-driven scope changes

- **Existing datacenter constraints:** Companies frequently choose to migrate to the cloud because the capacity, speed, and stability of an existing datacenter is no longer satisfactory. Unfortunately, those same constraints add complexity to the migration process, requiring additional planning during the assessment and migration processes.
- **Migrating at scale:** Migrations exceeding 2,000 assets are likely to run into constraints that require additional planning and a disciplined approach to execution. The Assess and Migrate processes are adjusted to account for scale complexity.
- **Multiple datacenters:** Migration of multiple datacenters adds a great deal of complexity. During the Assess, Migrate, Optimization, and Manage processes, additional considerations are discussed.
- **Change management and solution documentation:** Large digital estate inventories, complex solution architectures, long standing technical debt, and interdependencies can create a complexity that should be addressed during assess, migrate, and optimize processes.
- **Governance or compliance strategy:** When governance and compliance are vital to the success of a migration, additional alignment between IT Governance teams and the cloud adoption team is required.

### Workload-specific scope changes

- **Architect workloads for resiliency:** Common cloud design principles can help prepare mission-critical workloads for improved resiliency. This article will explain the impact on a migration process when resiliency is a workload requirement. It also shares a few common principles to include in the general environment configuration to improve resiliency for the environment.
- **Align migration to application patterns:** The migration pattern of a workload can affect the migration path chosen. This article outlines a few scope changes that would be integrated into the work item level of a migration backlog to reflect different approaches to migration per workload.

## Next steps

Browse the table of contents on the left to address specific needs or scope changes. Alternatively, the first scope enhancement on the list, [balancing the portfolio](./balance-the-portfolio.md) is a good starting place when reviewing these scenarios.

> [!div class="nextstepaction"]
> [Balancing the portfolio](./balance-the-portfolio.md)
