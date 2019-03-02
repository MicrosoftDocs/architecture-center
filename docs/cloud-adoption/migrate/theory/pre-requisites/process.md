---
title: "Migration Process Decisions"
description: Important decisions to be made regarding the migration process
author: BrianBlanchard
ms.date: 4/4/2019
---

# Migration Process Decisions (Effort, Roles, Definition of Done)

During migration, there are a number of factors that will impact decisions and execution activities. This article will explain the central theme to those decisions and a few questions that will carry through all of the migration theory content.

## Effort

Migration is a broad term. This term could describe the tactical process of migrating a small digital estate of a few hundred vms using an automated tool like [Azure Migrate](/azure/migrate/migrate-overview). Conversely, Migration could also describe the process for modernizing tens of thousands of applications during a highly strategic PaaS migration process that creates new experiences for a customer base. Before making any decisions that could have a long term impact, it is vital to create consensus on the following decisions regarding the current migration program.

### Effort Type

In any migration of significant scale (>250 VMs), assets will go through a variety of transition options. Some assets will be modernized through a **rebuild** or **rearchitect** process, creating a more modern application with new features and/or technical capabilities. Other assets will go through a **refactor** or operational changes, like a move to containers, or other more modern IT operation approaches which don't necessarily impact the solutions codebase. Commonly virtual machines and other assets which are more well established will go through a **rehost** process, transitioning those assets from the data center to the cloud. Some applications should not be migrated to the cloud, but should instead be **replaced** by cloud functionality found in SaaS based versions of an application, like Office365 as an alternative to migrating Exchange servers. In the majority of scenarios, some business event creates a forcing function which causes a high percentage of assets to go through a temporarily rehost process, followed by a more impactful secondary transition once in the cloud. This process is commonly known as a **cloud transition**.

During the process of [rationalizing the digital estate](../../../digital-estate/calculate.md), these types of decisions will be applied to each asset to migrate. However, the pre-requisite needed at this time is to make a baseline assumption. Of the six options above, which best aligns with the business objectives or business outcomes driving this migration effort? This decision will serve as a guiding assumption throughout the migration effort.

### Effort Scale

Scale of the migration is the next most important pre-requisite decision. The processes required to migrate 1,000 assets is very different from the process required to move 10,000 assets. Before beginning any migration effort, it is important to answer the following two questions:

- How many assets exist in the digital estate today? Assets would include data structures, applications, VMs, and necessary IT appliances.
- Of those assets how many are slated for migration? It is common for a percentage of assets to be terminated during a migration process, due to lack of sustained end user dependency.
- What are the top-down estimates of the migratable estates scale? Of the assets slated for migration, estimate the following variables. These variables will define asset and effort scale assumptions.
    - VMs: How many virtual machines will be moved? Total number of cores, memory, and total disk space for each.
    - IT Appliances: How many IT appliances will be required? How many of those appliances available in a virtual form in the Azure Marketplace?
    - Applications: How many applications will be migrated? Now is a good time to begin documenting application owners.
    - Data: How many data sources will be migrated? What is the approximate size of each data source, in GB or TB?

### Effort Timing

Often times, migrations are driving by a compelling business event that is time sensitive. For instance, termination or renewal of a 3rd party hosting contract is a common driver. While there are many potential business events necessitating a migration, they are share one commonality; an end date. It is important to understand the timing of any approaching business events, so activities and velocity can be planned and validated properly.

## Definition of Done

Understanding the effort will drive a definition of done for each of the four migrations processes: Assess, Migrate, Optimize, & Secure and Manage. The process page in each section of the migration theory section will outline decisions regarding definition of done. Those decisions will have a significant impact on the day to day operations of migration processes.

For instance, during assessment of a small migration effort of less than 1,000 vms, the definition of done could consist of a simple statement like: Execute Azure Migrate for each of the five hosts to be migrated. For a 10,000 unit migration, the definition of done could be a complex assessment process that requires years to complete, in parallel to on-going migration efforts.

## Roles

During each process of the migration, the assignment of roles and responsibilities will directly shape effort, assignments, and definition of done. It is important to understand which roles will be participate in the process and how.

Example of the impacts of Roles. A self-contained migration team could execute a full migration, including promotion of an application to production during the Migrate process. More commonly in large enterprises, a number of architects, IT admins, vendors, and applications owners would be required to review, approve, and execute the same type of work. In the case of the larger enterprises with separated duties, promotion to production would most likely occur during the Optimize process.

## Recap

Before proceeding, document the following assumptions and share them with the cloud strategy and cloud adoption teams:
-Effort Type:
-Effort Scale:
-Effort Timing:
-Definition of Done: This will be documented and refined for each of the four migration processes.
-Roles: This will be documented and refined for each of the four migration processes.

## Next steps

Once the process is understood amongst the team, its time to review technical pre-requisites the [Migration Planning Checklist](planning-checklist.md) will help ensure the technical foundation is ready for migration.

> [!div class="nextstepaction"]
> [Review the migration planning checklist](planning-checklist.md)