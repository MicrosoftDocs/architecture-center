---
title: "Pre-requisites to migration"
description: Pre-requisites to migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Pre-requisites to migration

Prior to beginning any migrations, the environment must be prepared for the coming changes. In this case, environment refers to the technical foundation in the cloud. Environment also means the business environment and mindset driving the migration. Likewise, the environment also includes the culture of the teams executing the change and those receiving the output of these changes. Failure to prepare for these changes is the most common reason for failure of migrations. This article series will walk the reader through a number of suggested pre-requisites to prepare the environment.

## Objective

Ensure business, culture, and technical readiness prior to beginning an iterative migration plan.

## Definition of Done

Pre-requisites are completed when the following are true:

* Technical Readiness: The landing zone (or allocated hosting space in the cloud) that will receive the migrated assets meets minimum requirements to host the first migrated workload
* Business Readiness: The Cloud Strategy Team has defined and prioritized a high-level migration backlog representing the portion of the digital estate to be migrated in the next 2-3 releases. The Cloud Strategy Team and Cloud Adoption Team have agreed to an initial strategy for managing change
* Culture Readiness: The roles, responsibilities, and expectations of the Cloud Adoption Team, Cloud Strategy Team, and impacted users have been agreed upon regarding the workloads to be migrated in the next 2-3 releases.

> [!CAUTION]
> Not preparing for a migration can cause unintended consequences throughout the migration process. However, there is an equal risk of over-preparation stopping the migration from ever happening. It is suggested that initial planning focus on the next 2-3 workloads to avoid "analysis paralysis", a term used to describe the state in which over-investment in planning prevents productive outputs.

Generally speaking, if it takes more than a month to start migrating the first workload, too much thought is going into readiness. The teams making decisions often don't have the experience with cloud migrations to be able to complete accurate planning beyond the first few workloads. Attempting to migrate the first workload will quickly demonstrate cloud principles to the team and create a forcing function to learn about the cloud.

## Accountability during pre-requisites

Two teams are accountable for readiness during the pre-requisites phase.

* Cloud Strategy Team: The cloud strategy team is responsible for identifying and prioritizing the first 2-3 workloads to serve as migration candidates.
* Cloud Adoption Team: The cloud adoption team is responsible for validating readiness of the technical environment and feasibility of migrating the proposed workloads.

It is advised that a single member of each team be identified as accountable for each of the three "definition of done" statements in the prior section.

## Responsibilities during pre-requisites

In addition to the high level accountability, there are a number of actions that an individual or group of individuals will need to be directly responsible for. The following are a few such responsibilities that will impact these activities.

* **Digital estate inventory and analysis:** Execution of the tools required to inventory and analyze the digital estate
* **Business prioritization:** Make business decisions regarding the workloads to be migrated and general timing constraints
* **Landing zone readiness:** Evaluate the landing zone to ensure it complies with requirements of the first few workload candidates
* **Change management readiness:** Establish and communicate the plan for tracking technical change during migration
* **Business user alignment:** Establish a plan for readying the business user community for execution

The remaining articles in this series will help with the execution of each.

## Next steps

With a general understanding of the pre-requisites, the reader is ready to address the first pre-requisite [Early Migration Decisions](decisions.md).

> [!div class="nextstepaction"]
> [Early Migration Decisions](decisions.md)
