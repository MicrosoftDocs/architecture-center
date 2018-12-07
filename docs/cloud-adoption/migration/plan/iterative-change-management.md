---
title: "Fusion: Iterative Change Management and Oversight"
description: An iterative approach to change management
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Iterative Change Management and Oversight

Migration to the cloud is deceptively similar to migration to a new data center. However, at its root, the processes associated with a cloud migration, more closely mimic behaviors of a software development process. Much like a software development team, the Cloud Adoption Team and Cloud Governance Team start with an ambiguous understanding of the way an application might perform once deployed. As work is completed, clarity is achieved and decisions are more easily made. During such a mutual journey of discovery, the dependencies between these two teams (& their business stakeholders), are similar to those of a developer and DBA, working to achieve business objectives, **iteratively**. 

> [!TIP]
> For teams that have long operated in waterfall execution models, this can present a difficult shift in thinking and operation. Agile or Scrum training, certification, or experience can help ease this transition in management styles.

## Iterative Approach to Change Management

![Iterative Approach to change management](../../_images/operational-transformation-manage.png)

*Figure 1. Iterative Approach to change management*

In the graphic above, management of Operational Transformation is represented as three concentric rings. Each ring represents an iterative layer of management, as follows:

* [Migration Backlog](migration-backlog.md): The outer most ring of management. The migration backlog represents the business plan and business priorities, as they map to the digital estate. This backlog general contains collections of workloads, prioritized based on the order the business would like to see the applications released in production.
* [Release Backlog](../execute/iteration-release-backlog.md#release-backlog): The middle layer of management. The release backlog serves as the change management tacking mechanism during a migration. This backlog generally contains as list of digital assets (VMs, appliances, data, etc...) grouped by the application(s) each asset supports. This backlog is used to track assets, as they are migrated and prepared for promotion to production.
* [Iteration Backlog](../execute/iteration-release-backlog.md#iteration-backlog): The inner most layer of management. The iteration backlog generally consists of the actual tasks to be completed by the Cloud Migration or CLoud Governance teams.

## Mapping Iterative Management to Azure Devops

For teams using Azure DevOps to manage a migration effort, the backlogs above would be represented by specific work item types. 

* Items in the Migration Backlog would be added as Epics. Each Epic representing a collection of applications or workloads that are required to execute a business process.
* Items in the Release Backlog would be added as User Stories, linked to a relevant Epic. Each User Story would represent a single asset that can be migrated independently to the cloud.
* Items in an Iteration Backlog would consist of various efforts required to migrate the asset. For an example of the types of work in a given release, see the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) of an [Operational Transformation](../../transformation-journeys/operational-transformation/overview.md).