---
title: "Pre-requisites to migration"
description: Pre-requisites to migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Prerequisites for migration

Prior to beginning any migrations, your migration target *environment* must be prepared for the coming changes. In this case, environment refers to the technical foundation in the cloud. Environment also means the business environment and mindset driving the migration. Likewise, the environment includes the culture of the teams executing the changes and those receiving the output. Lack of preparation for these changes is the most common reason for failure of migrations. This article series will walk you through a number of suggested prerequisites to prepare the environment.

## Objective

Ensure business, culture, and technical readiness prior to beginning an iterative migration plan.

## Review business drivers

Before beginning any cloud migration, review the CAF [Plan](../../business-strategy/overview.md) and [Ready](../../ready/overview.md) guidance to ensure your organization is prepared for cloud adoption and migration processes. In particular, review the business requirements and expected outcomes driving the migration:

- [Getting started: Migrate](../../../getting-started/migrate.md)
- [Why are we moving to the cloud?](../../../business-strategy/motivations-why-are-we-moving-to-the-cloud.md)

## Definition of *done*

Prerequisites are completed when the following are true:

- **Business readiness.** The Cloud Strategy Team has defined and prioritized a high-level migration backlog representing the portion of the digital estate to be migrated in the next two or three releases. The Cloud Strategy Team and Cloud Adoption Team have agreed to an initial strategy for managing change.
- **Culture readiness.** The roles, responsibilities, and expectations of the Cloud Adoption Team, Cloud Strategy Team, and impacted users have been agreed upon regarding the workloads to be migrated in the next two or three releases.
- **Technical readiness.** The landing zone (or allocated hosting space in the cloud) that will receive the migrated assets meets minimum requirements to host the first migrated workload.

> [!CAUTION]
> Preparation is key to the success of a migration. However, over-preparation can lead to *analysis paralysis*, where over-investment in planning can seriously delay a migration effort. The processes and prerequisites defined in this section are meant to help you make decisions, but don't let them block you from making meaningful progress.
>
> Choose a relatively simple workload for your initial migration. Use the processes discussed in this section as you plan and implement this first migration. This first migration effort will quickly demonstrate cloud principles to your team and force them to learn about how the cloud works. As your team gains experience, integrate these  learnings as you take on larger and more complex migrations.


## Accountability during prerequisites

Two teams are accountable for readiness during the prerequisites phase:

- **Cloud Strategy Team.** This team is responsible for identifying and prioritizing the first two or three workloads to serve as migration candidates.
- **Cloud Adoption Team.** This team is responsible for validating readiness of the technical environment and the feasibility of migrating the proposed workloads.

A single member of each team should be identified as accountable for each of the three definitions of done statements in the prior section.

## Responsibilities during prerequisites

In addition to the high-level accountability, there are a number of actions that an individual or group needs to be directly responsible for. The following are a few such responsibilities that impact these activities:

- **Business prioritization.** Make business decisions regarding the workloads to be migrated and general timing constraints. See the CAF discussion on [cloud migration business motivations](../../../business-strategy/motivations-why-are-we-moving-to-the-cloud.md) for more information.
- **Change management readiness.** Establish and communicate the plan for tracking technical change during migration. More information on this topic will be available Summer 2019.
- **Business user alignment.** Establish a plan for readying the business user community for migration execution. More information on this topic will be available Summer 2019.
- **Digital estate inventory and analysis.** Execution of the tools required to inventory and analyze the digital estate. See the CAF discussion of the [digital estate](../../../digital-estate/index.md) for more information.
- **Cloud readiness.** Evaluate the target deployment environment to ensure that it complies with requirements of the first few workload candidates. See the [Azure readiness guide](../../../ready/azure-readiness-guide/index.md) for more information.

The remaining articles in this series help with the execution of each.

## Next steps

With a general understanding of the prerequisites, you are ready to address the first prerequisite [Early Migration Decisions](./decisions.md).

> [!div class="nextstepaction"]
> [Early Migration Decisions](./decisions.md)