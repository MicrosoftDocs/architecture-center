---
title: "Preparing for cultural complexity - Aligning roles and responsibilities"
description: Preparing for cultural complexity - Aligning roles and responsibilities
author: BrianBlanchard
ms.date: 4/4/2019
---

# Preparing for cultural complexity - Aligning roles and responsibilities

Understanding the culture required to operate the existing datacenters is important to the success of any migration. In some organizations, data center management is contained within centralized IT operations teams. In these centralized teams, roles and responsibilities tend to be well defined and understood throughout the team. For larger enterprises, especially those who are bound by 3rd party compliance requirements, the culture tends to be more nuanced and complex. Cultural complexity can lead to roadblocks that are difficult to understand and time consuming to overcome.

In either scenario, it can be wise to invest in the documentation of roles and responsibilities required to complete a migration. This article will outline a number of the roles and responsibilities seen in a data center migration, to serve as a template for documentation which can drive clarity throughout execution.

## Business functions

In any migration, there are a few key functions that are best executed by the business, when ever possible. Often times IT is capable of completing the following tasks. However, engaging members of the business could aid in reducing barriers later in the adoption process. It also ensures mutual investment from key stakeholders throughout the migration process.

|Process  |Activity  |Description  |
|---------|---------|---------|
|Assess     |Priorities|Ensure alignment with changing business priorities and market conditions|
|Assess     |Justification|Validate assumptions that drive evolving business justifications|
|Assess     |Risk|Help the Cloud Adoption Team understand the impact of tangible business risks|
|Assess     |Approve|Review and approve the business impact of proposed architecture changes|
|Optimize     |Change Plan|Define a plan for consumption of change within the business including periods of low activities and change freezes|
|Optimize     |Testing|Align power users capable of validating performance and functionality|
|Secure & Manage     |Interruption Impact|Aid the cloud adoption team in quantifying the impact of a business process interruption|
|Secure & Manage     |SLA Validation|Aid the cloud adoption team in defining service level agreements and acceptable tolerances for business outages|

Ultimately, the Cloud Adoption Team is accountable for each of these activities. However, establishing responsibilities and a regular cadence with the business for the completion of these activities on a regular rhythm can improve stakeholder alignment and cohesiveness with the business.

## Common roles and responsibilities

Each process within the migrate theory content includes a process article outlining specific activities to align roles and responsibilities. For clarity during execution it is advised that a single accountable party be assigned for each activity, along with any responsible parties required to support those activities. However, the following list contains a series of common roles and responsibilities that have a higher degree of impact on migration execution. It is advised that these roles be identified early in the migration effort.

> [!IMPORTANT]
> In the table below an accountable party is suggested to start the alignment of roles. That column should be customized to fit existing processes for efficient execution. Ideally a single person should be named as the accountable party.

|Process  |Activity  |Description  |Accountable party  |
|---------|---------|---------|---------|
|Pre-Requisite|Digital Estate|Align the existing inventory to basic assumptions based on business outcomes|Cloud Strategy Team|
|Pre-Requisite|Migration Backlog|Prioritize the sequence of workloads to be migrated|Cloud Strategy Team|
|Assess|Architecture|Challenge initial assumptions to define the target architecture based on usage metrics|Cloud Adoption Team|
|Assess|Approval|Approve the proposed architecture|Cloud Strategy Team|
|Migrate|Replication Access|Access to existing on-prem hosts and assets to establish replication processes|Cloud Adoption Team*|
|Optimize|Ready|Validation that the system meets performance and cost requirements prior to promotion|Cloud Adoption Team|
|Optimize|Promote|Permissions to promote a workload to production and redirect production traffic|Cloud Adoption Team*|
|Secure and Manage|Ops Transition|Documentation of production systems prior to production operations|Cloud Adoption Team|

> [!WARNING]
> * Permissions and authorization will heavily influence the accountable party for these activities. The accountable party must have direct access to production systems in the existing environment, or means of securing access through other responsible actors. Determining this accountable party will directly impact the promotion strategy during the migrate and optimize processes.

## Next steps

When the team has a general understanding of roles and responsibilities, its time to address the final pre-requisite [Digital Estate Review](./migration-backlog-review.md)

> [!div class="nextstepaction"]
> [Digital Estate Review](./migration-backlog-review.md)