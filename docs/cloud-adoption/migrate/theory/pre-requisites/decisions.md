---
title: "Decisions that impact migrations"
description: Important decisions to be made regarding the migration process
author: BrianBlanchard
ms.date: 4/4/2019
---

# Decisions that impact migrations

During migration, there are a number of factors that will impact decisions and execution activities. This article will explain the central theme to those decisions and a few questions that will carry through all of the migration theory content.

## Business Outcomes

The objective or goal of any adoption effort can have a significant impact on the suggested approach to execution.

- Operational Transformation: Urgent business drivers, speed of adoption, or cost savings are examples of operational outcomes. These outcomes are central to efforts that drive business value from transitive change in IT or operations models.
- Incremental Transformation: Improving customer experience or growing market share are examples of incremental outcomes. The outcomes come from a collection of incremental changes focused on the needs and desires of current customers.
- Disruptive Transformation: New products or services, especially those that come from the power of data, are examples of disruptive outcomes. These outcomes are the result of experimentation and predictions that use data to disrupt status quo in the market.

No business would pursue just one of these outcomes. Without operations there are no customers and vice versus. Without looking to the customers of tomorrow, it's hard to care for the customers of today. Cloud adoption is the no different. Companies commonly work to each of these outcomes.

This pre-requisite isn't a demand for the reader to pick one of the three options above. Instead the need captured in this pre-requisite is to help the Cloud Strategy Team and Cloud Adoption Team establish a set of operational priorities that will guide execution for the next 3 to 6 months. These priorities are set by ranking each of the three options above from most impactful to least impactful, as it relates to the efforts this team can contribute to in the next 1-2 quarters.

### Acting on Operational Transformation

If operational outcomes rank highest in the list, then this section of the Cloud Adoption Framework will work well for the team. In this section, it is assumed that the team needs to value speed and cost savings as primary KPIs. In which case, a migration model to adoption would be well aligned with the outcomes. A migration focused model is heavily predicated on shift/lift migration of IaaS assets to deplete a data center and produce cost savings. In such a model, modernization may occur, but is a secondary focus until the primary migration mission is realized.

### Acting on Incremental Transformation

If market share and customer experience are the primary drivers, then this may not be the best section of the Cloud Adoption Framework to guide the teams' efforts. An Incremental Transformation requires a plan that focuses on the modernization and transition of applications, regardless of the underlying infrastructure. In such a case, the guidance in this section can be informative but may not be the best approach to guide core decisions.

### Acting on Disruptive Transformation

If data, experimentation, R&D, or new products are this teams priority for the next 6+ months, then this may not be the best section of the Cloud Adoption Framework to guide the teams' efforts. Any Disruptive Transformation effort could benefit from migration guidance regarding the migration of existing source data. However, the broader focus of that effort would be on the ingress and integration of additional data sources. Extending that guidance with predictions and new experiences is much more important than the migration of IaaS assets.

> [!WARNING]
> Only proceed to adopt the guidance in this section of the Cloud Adoption Framework, if Operational Transformation or Operational Outcomes are the primary focus of the cloud adoption team for the next 3-6 months.
> In some cases, a desire to **urgently drive change** could justify a company using an Operational Transformation approach, in spite of a desire to modernize or create new products. This is especially true for large application or data portfolios.

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

## Recap

Before proceeding, document the following assumptions and share them with the cloud strategy and cloud adoption teams:

- Effort Type:
- Effort Scale:
- Effort Timing:
- Definition of Done: This will be documented and refined for each of the four migration processes.
- Roles: This will be documented and refined for each of the four migration processes.

## Next steps

Once the process is understood amongst the team, its time to review technical pre-requisites the [Migration Planning Checklist](planning-checklist.md) will help ensure the technical foundation is ready for migration.

> [!div class="nextstepaction"]
> [Review the migration planning checklist](planning-checklist.md)