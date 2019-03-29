---
title: "Approve architecture changes prior to migration"
description: Understanding the importance of approval prior to migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Approve architecture changes prior to migration

During the Assess process of migration, each workload should have been evaluated, architected, and estimated to develop a future state plan for the workload. Some workloads can be migrated to the cloud with no change to the architecture. Maintaining on-premises configuration and architecture can reduce risk and streamline the migration process. Unfortunately, not every application can run in the cloud without changes to the architecture. When architecture changes are required, this article can help classify the change an provides some guidance on the proper approval activities.

## Business impact and approval

During migration, some things are likely to change in ways that impact the business. While change is sometimes unavoidable, surprises as a result of undisclosed or undocumented change should not be. To maintain stakeholder support throughout the migration effort, its important to avoid surprises. Surprising application owners or business stakeholders can slow, or even stop, a cloud adoption effort.

Prior to migration, it is important to prepare the business owner of the workload for any changes that could impact business processes. A few common examples would include: Changes to SLAs, Changes to access patterns or security requirements that impact the end user, Changes to data retention practices, Changes to core application performance.

Even when a workload can be migrated with minimal to no change, there could still be a business impact. Replication processes can slow the performance of production systems. Changes to the environment in preparation to migration has a potential of causing routing or network performance limitations. There are a host of additional impacts that could result from replication, staging, or promotion activities.

Regular approval activities can help minimize or avoid surprises as a result of change or performance driven business impacts. It is advised that the Cloud Adoption Team execute a change approval process at the end of the Assess process, before beginning the migration process.

## Technical approval

Organizational readiness for the approval of technical change is amongst the most common reasons for cloud migration failure. More projects are stalled by a series of technical approvals than any deficit in a cloud platform. Preparing the organization for technical change approval is an important requirement for migration success. The following area few best practices to ensure the organization is ready for technical approval.

### ITIL Change Advisory Board challenges

Every change management approach has its own set of controls and approval processes. Migration is a series of continuous changes that start with a high degree of ambiguity, developing additional clarity through the course of execution. As such, migration is best governed by Agile-based change management approaches, with the Cloud Strategy Team serving as a Product Owner. Unfortunately, the assets being moved are typically governed by traditional ITIL based change management processes. In many enterprise migrations a Change Advisory Boards (CAB) is accountable for the assets in the migration backlog.

Approvals by a CAB is a proven means of reducing risk and minimizing business impact during stable-state maintenance managed by IT operations. However, the scale and frequency of change during a cloud migration doesn't fit well with the nature of ITIL processes. Requirements for a CAB approval can actually increase risk of success during a migration, slowing or stopping the effort. Further, in the early stages of migration, ambiguity is high and subject matter expertise tends to be low. For the first several workload migrations or releases, the cloud adoption team is often in a learning mode. As such, it could be very difficult for the Cloud Adoption Team to provide the types of data needed to pass a CAB approval.

The following best practices can help the CAB maintain a degree of comfort during migration without become a painful blocker.

### Standardize Change

It is very tempting for Cloud Adoption Teams to consider detailed architectural decisions for each workload being migrated to the cloud. It is equally tempting to use cloud migration as a catalyst to refactor past architectural decisions. For organizations that are migrating a few hundred VMs or a few dozen workloads, either approach can be properly managed. When migrating a datacenter consisting of a thousand or more assets, each of these approaches is considered a high-risk anti-pattern that significantly reduces the likelihood of success. Modernizing, refactoring, and re-archetecting every application requires diverse skill sets, requires a high variety of changes, and creates dependencies on human efforts at scale. Each of these dependencies injects risk into the migration effort.

The article on [Digital Estate Rationalization](../../../digital-estate/rationalize.md) discusses the agility and time saving impact of basic assumptions when rationalizing a digital estate. There is an additional benefit of standardized change. By choosing a default rationalization approach to govern the migration effort, the Cloud Advisory Board or Product Owner can review and approval the application of one change to a long list of workloads. This reduces technical approval of each workload to those workloads that require a significant architecture change to be cloud compatible.

### Clarify Expectations and Roles of approvers

Before the first workload is assessed, it is advised that the Cloud Strategy Team document and communicate the expectations of anyone involved in the approval of change. This simple activity can avoid costly delays when the Cloud Adoption Team is fully engaged.

### Seek approval early

When possible, technical change can be detected and documented during the assessment process. Regardless of approval processes, it is advised that the Cloud Adoption Team engage approvers early. The sooner change approval can begin, the less likely an approval process is to block migration activities.

## Next steps

With the help of these best practices, it should be easier to integrate proper, low risk approval into migration efforts. Once workload changes are approved, the Cloud Adoption Team is ready to [Migrate workloads](../migrate/index.md).

> [!div class="nextstepaction"]
> [Migrate workloads](../migrate/index.md)