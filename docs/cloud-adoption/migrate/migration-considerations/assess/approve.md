---
title: "Approve architecture changes before migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Understanding the importance of approval before migration
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Approve architecture changes before migration

During the assess process of migration, each workload is evaluated, architected, and estimated to develop a future state plan for the workload. Some workloads can be migrated to the cloud with no change to the architecture. Maintaining on-premises configuration and architecture can reduce risk and streamline the migration process. Unfortunately, not every application can run in the cloud without changes to the architecture. When architecture changes are required, this article can help classify the change and can provide some guidance on the proper approval activities.

## Business impact and approval

During migration, some things are likely to change in ways that impact the business. Although change sometimes can’t be avoided, surprises as a result of undisclosed or undocumented changes should be. To maintain stakeholder support throughout the migration effort, it’s important to avoid surprises. Surprising application owners or business stakeholders can slow or halt a cloud adoption effort.

Prior to migration, it is important to prepare the workload’s business owner for any changes that could affect business processes, such as changes to:

- Service-level agreements.
- Access patterns or security requirements that impact the end user.
- Data retention practices.
- Core application performance.

Even when a workload can be migrated with minimal to no change, there could still be a business impact. Replication processes can slow the performance of production systems. Changes to the environment in preparation for migration have the potential to cause routing or network performance limitations. There are many additional impacts that could result from replication, staging, or promotion activities.

Regular approval activities can help minimize or avoid surprises as a result of change or performance-driven business impacts. The cloud adoption team should execute a change approval process at the end of the assessment process, before beginning the migration process.

## Existing culture

Your IT teams likely have existing mechanisms for managing change involving your on-premises assets. Typically these mechanisms are governed by traditional Information Technology Infrastructure Library–based (ITIL-based) change management processes. In many enterprise migrations, these processes involve a Change Advisory Board (CAB) that is responsible for reviewing, documenting, and approving all IT-related requests for changes (RFC).

The CAB generally includes experts from multiple IT and business teams, offering a variety of perspectives and detailed review for all IT-related changes. A CAB approval process is a proven way to reduce risk and minimize the business impact of changes involving stable workloads managed by IT operations.

## Technical approval

Organizational readiness for the approval of technical change is among the most common reasons for cloud migration failure. More projects are stalled by a series of technical approvals than any deficit in a cloud platform. Preparing the organization for technical change approval is an important requirement for migration success. The following are a few best practices to ensure that the organization is ready for technical approval.

### ITIL Change Advisory Board challenges

Every change management approach has its own set of controls and approval processes. Migration is a series of continuous changes that start with a high degree of ambiguity and develop additional clarity through the course of execution. As such, migration is best governed by agile-based change management approaches, with the cloud strategy team serving as a product owner.

However, the scale and frequency of change during a cloud migration doesn't fit well with the nature of ITIL processes. The requirements of a CAB approval can risk the success of a migration, slowing or stopping the effort. Further, in the early stages of migration, ambiguity is high and subject matter expertise tends to be low. For the first several workload migrations or releases, the cloud adoption team is often in a learning mode. As such, it could be difficult for the team to provide the types of data needed to pass a CAB approval.

The following best practices can help the CAB maintain a degree of comfort during migration without become a painful blocker.

### Standardize change

It is tempting for a cloud adoption team to consider detailed architectural decisions for each workload being migrated to the cloud. It is equally tempting to use cloud migration as a catalyst to refactor past architectural decisions. For organizations that are migrating a few hundred VMs or a few dozen workloads, either approach can be properly managed. When migrating a datacenter consisting of 1,000 or more assets, each of these approaches is considered a high-risk antipattern that significantly reduces the likelihood of success. Modernizing, refactoring, and rearchitecting every application require diverse skillsets and a significant variety of changes, and these tasks create dependencies on human efforts at scale. Each of these dependencies injects risk into the migration effort.

The article on [digital estate rationalization](../../../digital-estate/rationalize.md) discusses the agility and time-saving impact of basic assumptions when rationalizing a digital estate. There is an additional benefit of standardized change. By choosing a default rationalization approach to govern the migration effort, the Cloud Advisory Board or product owner can review and approve the application of one change to a long list of workloads. This reduces technical approval of each workload to those that require a significant architecture change to be cloud compatible.

### Clarify expectations and roles of approvers

Before the first workload is assessed, the cloud strategy team should document and communicate the expectations of anyone involved in the approval of change. This simple activity can avoid costly delays when the cloud adoption team is fully engaged.

### Seek approval early

When possible, technical change should be detected and documented during the assessment process. Regardless of approval processes, the cloud adoption team should engage approvers early. The sooner that change approval can begin, the less likely an approval process is to block migration activities.

## Next steps

With the help of these best practices, it should be easier to integrate proper, low-risk approval into migration efforts. After workload changes are approved, the cloud adoption team is ready to [migrate workloads](../migrate/index.md).

> [!div class="nextstepaction"]
> [Migrate workloads](../migrate/index.md)
