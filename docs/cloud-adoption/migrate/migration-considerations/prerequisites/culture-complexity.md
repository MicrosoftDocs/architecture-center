---
title: "Prepare for cultural complexity: aligning roles and responsibilities"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Preparing for cultural complexity - aligning roles and responsibilities.
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Prepare for cultural complexity: aligning roles and responsibilities

An understanding of the culture required to operate the existing datacenters is important to the success of any migration. In some organizations, datacenter management is contained within centralized IT operations teams. In these centralized teams, roles and responsibilities tend to be well defined and well understood throughout the team. For larger enterprises, especially those bound by third-party compliance requirements, the culture tends to be more nuanced and complex. Cultural complexity can lead to roadblocks that are difficult to understand and time consuming to overcome.

In either scenario, it’s wise to invest in the documentation of roles and responsibilities required to complete a migration. This article outlines some of the roles and responsibilities seen in a datacenter migration, to serve as a template for documentation that can drive clarity throughout execution.

## Business functions

In any migration, there are a few key functions that are best executed by the business, whenever possible. Often, IT is capable of completing the following tasks. However, engaging members of the business could aid in reducing barriers later in the adoption process. It also ensures mutual investment from key stakeholders throughout the migration process.

| Process | Activity | Description |
|---------|---------|---------|
| Assess | Business goals | Define the desired business outcomes of the migration effort. |
| Assess | Priorities | Ensure alignment with changing business priorities and market conditions. |
| Assess | Justification | Validate assumptions that drive changing business justifications. |
| Assess | Risk | Help the cloud adoption team understand the impact of tangible business risks. |
| Assess | Approve | Review and approve the business impact of proposed architecture changes. |
| Optimize | Change plan | Define a plan for consumption of change within the business, including periods of low activities and change freezes. |
| Optimize | Testing | Align power users capable of validating performance and functionality. |
| Secure and manage | Interruption impact | Aid the cloud adoption team in quantifying the impact of a business process interruption. |
| Secure and manage | Service-level agreement (SLA) validation | Aid the cloud adoption team in defining service level agreements and acceptable tolerances for business outages. |

Ultimately, the cloud adoption team is accountable for each of these activities. However, establishing responsibilities and a regular cadence with the business for the completion of these activities on an established rhythm can improve stakeholder alignment and cohesiveness with the business.

## Common roles and responsibilities

Each process within the discussion of the Cloud Adoption Framework migration principles includes a process article outlining specific activities to align roles and responsibilities. For clarity during execution, a single accountable party should be assigned for each activity, along with any responsible parties required to support those activities. However, the following list contains a series of common roles and responsibilities that have a higher degree of impact on migration execution. These roles should be identified early in the migration effort.

> [!NOTE]
> In the following table, an accountable party should start the alignment of roles. That column should be customized to fit existing processes for efficient execution. Ideally a single person should be named as the accountable party.

| Process | Activity | Description | Accountable party |
|---------|---------|---------|---------|
| Prerequisite | Digital estate | Align the existing inventory to basic assumptions, based on business outcomes. | cloud strategy team |
| Prerequisite | Migration backlog | Prioritize the sequence of workloads to be migrated. | cloud strategy team |
| Assess | Architecture | Challenge initial assumptions to define the target architecture based on usage metrics. | cloud adoption team |
| Assess | Approval | Approve the proposed architecture. | cloud strategy team |
| Migrate | Replication access | Access to existing on-premises hosts and assets to establish replication processes. | cloud adoption team |
| Optimize | Ready | Validate that the system meets performance and cost requirements prior to promotion. | cloud adoption team |
| Optimize | Promote | Permissions to promote a workload to production and redirect production traffic. | cloud adoption team |
| Secure and manage | Ops transition | Document production systems prior to production operations. | cloud adoption team |

> [!CAUTION]
> For these activities, permissions and authorization heavily influence the accountable party, who must have direct access to production systems in the existing environment or must have means of securing access through other responsible actors. Determining this accountable party directly affects the promotion strategy during the migrate and optimize processes.

## Next steps

When the team has a general understanding of roles and responsibilities, it’s time to begin preparing the technical details of the migration. Understanding [technical complexity and change management](./technical-complexity.md) can help prepare the cloud adoption team for the technical complexity of migration by aligning to an incremental change management process.

> [!div class="nextstepaction"]
> [Technical complexity and change management](./technical-complexity.md)
