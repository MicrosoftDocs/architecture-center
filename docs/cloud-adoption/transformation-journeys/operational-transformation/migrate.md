---
title: "Enterprise Cloud Adoption: Migrating Assets in an Operational Transformation"
description: Operational Transformation - Migrating Assets
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: Migrating Assets in an Operational Transformation Journey (OTJ)

[Operational Transformation](overview.md) is one of the [Transformation Journeys](../overview.md) included in the [Enterprise Cloud Adoption (ECA) framework](../../overview.md). The objective of an Operational Transformation, is the enablement and realization of internal business outcomes. Often times these outcomes center around increased efficiencies, reduced complexity, and improved agility. This article focuses on the Migrate process within a transformation.

![Migrate process within Operational Transformation](../../_images/operational-transformation-migrate.png)
*Figure 1. Migrate process within Operational Transformation. Activities within the process detailed below*

Download the full size infographic: [pdf format](../../_images/operational-transformation-infographic.png) [png format](../../_images/operational-transformation-infographic.pdf)

## Technology Activities (Sprint / Increment activities)

During each increment/sprint, activities are aligned to specific technical execution. There are no defined business or culture activities within an increment. The following six activities represent the vast majority of the technical work completed during an Operational Transformation.

* [Iteration or Release Backlog](../migration/execute/iteration-release-backlog.md): Iteration and Release backlog manage change and technical tasks during each iteration &/or release. During each sprint, the team will use the backlog to guide work. 
* [Assess](../migration/execute/assess.md): Evaluate assets to be migrated to determine compatibility and document constraints that would impact migration.
* [Architect](../migration/execute/architect.md): Determine the future state architecture and workload configuration based on constraints, cost, and business value.
* [Remediate](../migration/execute/remediate.md): Resolve any compatibility issues preventing migration. Complete minor replatforming tasks, when relevant to architecture decisions.
* [Replicate](../migration/execute/replicate.md): Replicate the OS, Configuration, and/or Data to the cloud hosting solution.
* [Stage](../migration/execute/stage.md): Prepare the migrated resources in a staging environment, so that the application or workload can be tested by the Cloud Migration Team, power users, and/or business stakeholders.

# Activities outside of the sprint or increment scope

There are several business, culture, and technical activities that happen outside of each iteration. The following activities generally occur after each sprint, or after each release.

## Business Activities

The following activities align help expand the business vision and build the relationships needed to coordinate bus/tech execution.

* [UAT Testing](../migration/execute/uat-test.md): During this process, power users and business stakeholders test applications that are slated for release to validate functionality and performance.
* [User Adoption Plan](../migration/execute/user-adoption-plan.md): Once an application/workload has passed UAT testing, the business unit begins planning the business transformation activities required to adopt the new technical solution. This plan manages the actual business change.
* [Business Priorities](../migration/execute/business-priorities.md): At the end of each iteration, the business stakeholders provide any updates to business outcomes and priorities. These changes influence the migration, release, and iteration backlog. Aligning the migration backlog to changing business priorities allows the Cloud Migration Team to align activities for maximum impact.

## Culture Activities

* [People & Skills](../culture-strategy/people-and-skills.md): During the Migrate process execution, technical work becomes very repetitive. Employees working in this area for long are at risk of losing interest in the project. Consider keeping the team fresh by rotating out team members, or blocking off time in each iteration to learn new skills.

## Technology Activities

* [Ready](../migration/execute/ready.md): Once an application or workload passes UAT testing, the Cloud Migration Team prepares the deployment for production usage. Depending on deployment strategies, this could include tasks like sizing, network changes, Backup/Disaster Recovery setup, etc...
* [Promote](../migration/execute/promote.md): When all assets are ready for production and the User Adoption Plan has been prepared, the workload is ready for production. In this stage, the Cloud Migration team re-routes network traffic to the assets hosted in the cloud and initiates the decomissioning process for the on-prem assets.
* [Retrospective](../migration/execute/retrospective.md): At the end of each iteration, the cloud migration and cloud governance teams share lessons learned & challenges that could be improved in future iterations.

## Next steps

In parallel to Migration, the Cloud Governance Team is likely advancing governance disciplines to mitigate business risk. Learn more about the [Govern process](govern.md).

> [!div class="nextstepaction"]
> [Govern cloud deployments](govern.md)