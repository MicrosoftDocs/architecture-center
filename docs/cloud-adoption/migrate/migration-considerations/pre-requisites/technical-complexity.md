---
title: "Preparing for technical complexity - Agile Change Management"
description: Preparing for technical complexity - Agile Change Management
author: BrianBlanchard
ms.date: 4/4/2019
---

# Preparing for technical complexity - Agile Change Management

When an entire data center can be destroyed and recreated with a single line of code, traditional processes struggle to keep up. the guidance throughout the Cloud Adoption Framework is built on practices like ITSM, TOGAF, and others. However, to ensure agility and responsiveness to business change, this framework molds those practices to fit agile methodologies and devops approaches.

When shifting to an agile model, technical complexity and change management are managed differently than they are in a traditional waterfall model. This article outlines the high level approach to change management in an agile based migration effort. At this end of this article, the reader should have a general understanding of the levels of change management and documentation involved in an incremental migration approach. Additional training and decisions will be required to select and implement agile practices based on that understanding. The intention of this article is to prepare cloud architects for a facilitated conversation with the PMO to explain the general concept of change management in this approach.

## Addressing technical complexity

When changing any technical system, complexity and interdependency injects risk into project plans. Cloud migrations are no exception. When moving thousands, or tens of thousands, of assets to the cloud these risks are amplified. Detecting and mapping all dependencies across a large digital estate could take years. Few businesses will tolerate such a long analysis cycle. To balance the need for architectural analysis and business acceleration, CAF focuses on an I.N.V.E.S.T. model to product backlog management. The following sections will summarize this type of model

## INVEST in workloads

The term workload appears throughout CAF. A "Workload" is a unit of application functionality that can be migrated to the cloud. It could be a single application, a layer of an application, or a collection of an application. The definition is flexible and may change at various phrases of migration. CAF uses the term INVEST to define a workload.

Invest is a common acronym in many Agile methodologies for writing User Stories or Product Backlog Items. Both of which are units of output in Agile project management tools. The measurable unit of output in a migration, is a migrated workload. CAF modifies the INVEST acronym a bit to create a construct for defining workloads, as follows:

- Independent: A workload should not have any inaccessible dependencies. For a workload to be considered migrated, all dependencies should be accessible &/or included in the migration effort.
- Negotiable: As additional discovery is performed, the definition of a workload will change. The architects planning the migration could negotiate a number of factors regarding dependencies. examples of negotiation points could include pre-release of features, making features accessible over a hybrid network, or packaging all dependencies in a single release.
- Valuable: Value in a workload is measured in the ability to provide users with access to a production workload.
- Estimable: Dependencies, assets, migration time, performance, and cloud costs should all be estimable and estimated prior to migration.
- Small: The goal is to package workloads in a single sprint. However, this may not always be feasible. Instead, teams are encouraged to plan sprints and releases to minimize the time required to move a workload to production.
- Testable: There should always be a defined means of testing or validating completion of the migration of a workload.

This acronym is not intended as a basis for rigid adherence, but helps guide the definition of the term workload.

## Migration Backlog: Aligning business priorities and timing

Prior to migration, it is encouraged that cloud strategy team and cloud adoption team agree to a prioritized list of "Workloads" to be migrated. Initially, workloads on the migration backlog are unlikely to meet the INVEST criteria outlined in the prior section. Instead, they will serve as a logical grouping of assets from an initial inventory to serve as a placeholder for future work. Those placeholders may not be technically accurate, but they will serve as a the basis for coordination with the business.

In any migration backlog, the change management team should strive to obtain the following information for any workload in the plan. At minimum, this data should be available for any workloads prioritized for migration in the next 2-3 releases.

### Migration Backlog Data Points

- Workload name
- Initial inventory: Any assets required to provide the functionality of the workload, including VMs, IT appliances, data, applications, deployment pipelines, etc... It is assumed that this information is likely to be inaccurate.
- Relative business priority: a stack ranked list of workloads based on business priorities.
- Expected timelines: When the migration is expected to be completed.
- Workload freezes: Time frames in which the workload should be ineligible for change.
- Business impact: Understanding of the impact to the business of missing the expected timeline or reducing functionality during freeze windows.

## Release Backlog: Aligning business change and technical coordination

In Agile terms, a release represents the delivery of a software package after several features have been developed. In a migration context a release is very similar. During cloud migration, a release represents an iteration of business change. After one or more workloads have been prepared for production promotion, a release occurs. The decision to package a release is generally made when the workloads migrated represent enough business value to justify injecting change into a business environment. Releases are usually executed in conjunction with a [business change plan](../optimize/business-change-plan.md), after [business testing](../optimize/business-test.md) has been completed. The Cloud Strategy Team is responsible for planning an overseeing the execution of a release to ensure the desired business change is released.

A release backlog is the future state plan which defines a coming release. Release backlog is the pivot point between business change management (migration backlog) and technical change management (sprint backlog). A release backlog consists of a list of workloads from the migration backlog that align to a specific subset of business outcome realization. Definition and submission of a release backlog to the Cloud Adoption Team, serves as a trigger for deeper analysis and migration planning. Once the Cloud Adoption Team has verified the technical details associated with a release, the Cloud Adoption Team will choose to "commit" to the release, establishing a release timeline based on current knowledge.

Given the degree of analysis required to validate a release, it is advised that the Cloud Strategy Team maintain a running list of the next 2-4 releases. It also advised that the Cloud Strategy Team attempt to validate as much of the following information as possible before defining and submitting a release. A disciplined Cloud Strategy Team capable of maintaining the next 4 releases will significantly increase the consistency and accuracy of release timeline estimates.

### Release Backlog Data Points

A partnership between the Cloud Strategy Team and Cloud Adoption Team will collaborate to add the following data points for any workloads in the release backlog.

- Refined inventory: Validation of required assets to be migrated. Often validated through log or monitoring data at the host, network, or OS level to ensure an accurate understanding of network and hardware dependencies of each assets under standard load.
- Usage patterns: An understanding of the patterns of usage from end users. Often times these patterns will include an analysis of end user geographical distribution, network routes, seasonal usage spikes, daily/hourly usage spikes, end user composition (interval vs external)
- Performance expectations: Analysis of available log data capturing throughput, pageview, network routes, and other performance data required to replicate the end users experience
- Dependencies: Analysis of network traffic and application usage patterns to identify any additional workload dependencies. These dependencies should be factored into sequencing and environmental readiness. A workload should not be included in a release until one of the following criteria can be met:
    - All dependent workloads have been migrated
    - Network and security configurations have been implemented to allow the workload to access all dependencies in alignment with existing performance expectations
- Desired migration approach: At the migration backlog level, the assumed migration effort is the only consideration used in analysis. For instance, if the business outcome is an exit from an existing data center, then all migrations are assumed to be a rehost scenario in the migration backlog. In the release backlog, the cloud strategy team and cloud adoption team should evaluate the long term value of additional features, modernization, and continued development investments to evaluate if a more modern approach should be involved.
- Business testing criteria: Once a workload is added to the migration backlog, testing criteria should be mutually agreed. In some cases, testing criteria can be limited to a performance test with a defined power user group. However, for statistical validation, an automated performance test is desired and should be included. Often times the existing instance of the application has no automated testing capabilities. Should this prove accurate, it is not uncommon for the cloud architects to work with power users to create a baseline load test against the existing solution to establish a benchmark to be used during migration. 

### Release backlog cadence

In mature migrations, releases come in a regular cadence. Often times the velocity of the Cloud Adoption Team will normalize, producing a release every 2-4 iterations (approximately every 1 - 2 months). However, this should be an organic outcome. Creating artificial release cadences can negatively impact the Cloud Adoption Teams ability to achieve consistent throughput.

To stabilize business impact, it is advised that the Cloud Strategy Team establish a monthly release process with the business to maintain regular dialogue, but establish the expectation that it will be several months before a regular release cadence can be predicted.

## Sprint or Iteration Backlog: Aligning technical change and effort

A Sprint or iteration is a consistent, time-bound unit of work. Often times in the migration process, this is measured in two week increments. However, its not unheard of to have one week or four week iterations. Creating time bound iterations forces consistent intervals of effort completion and allows for more frequent adjustment to plans, based on new learnings. During any given sprint, there will commonly be work related to the assessment, migration, and optimization of workloads defined in the migration backlog. Those units of worked should be tracked and managed in the same project management tool as the migration and release backlog to drive consistency across each level of change management.

A Sprint Backlog (or iteration backlog) consists of the technical work to be completed in a single sprint or iteration. That work should be derived from the workloads to be migrated. When using tools like Azure DevOps (previously visual studio online) for project management, the work items in a sprint would be children of the Product Backlog Items in a release backlog and the Epics in a Migration backlog. Such a parent child relationship allows for clarity at all levels of change management.

Within a single sprint or iteration, the Cloud Adoption Team would work to deliver the committed amount of technical work, driving towards the migration of a defined workload. Those efforts are the end result of the change management strategy. When complete, those efforts can be testing by validating production readiness of a workload staged in the cloud.

### Large or complex sprint structures

For a small migration with a self-contained migration team, a single sprint could include all four phases of a migration for a single workload (Assess, Migrate, Optimize, & Secure and Manage). More commonly, each of these processes are spread across multiple teams in distinct work items across numerous sprints. Depending on the effort type, effort scale, and roles these sprints can take a few different shapes.

**Migration Factory:** Large scale migrations sometimes require an approach that resembles a factory in the execution model. In this model, various teams are allocated to the execution of a specific migration process (or subset of the process). Once complete, the output of one team's sprint populates the backlog for the next team. This is an efficient approach for large scale rehost migrations with thousands of virtual machines moving through phases of assessment, architecture, remediation, and migration. However, for this approach to work a new homogenous environment with streamlined change management and approval processes is a must.

**Migration Waves:** Another approach that works well for large migrations is a wave model. In this model, division of labor isn't nearly as clear. Teams dedicate themselves to the migration process execution of individual workloads. However, the nature of each sprint changes. In one sprint the team may complete assessment and architecture work. In another sprint, the team may complete the migration work. In yet another sprint, optimization and production release would occur. This approach allows a core team to stay aligned to workloads seeing them through the process in its entirety. When using this approach, the diversity of skills and context switching could reduce potential velocity of the team, slowing the migration effort. Additionally, roadblocks during approval cycles can cause significant delays. It is important to maintain options in the release backlog to keep the team moving during blocked periods with this model. It is also important to cross train team members and ensure skill sets align with the theme of each sprint.

### Sprint Backlog Data Points

The outcome of a sprint captures and documents the changes made to a workload, thus closing the change management loop. When completed the following should be documented at a minimum. Through out the execution of a sprint, the documentation regarding each of the following should be completed in tandem with the completion of technical work items.

- Assets deployed: Any assets deployed to the cloud to host the workload
- Remediation: Any changes to the assets to prepare for cloud migration
- Configuration: Chosen configuration of any assets deployed, including anr references to configuration scripts
- Deployment model: Approach used to deploy the asset to the cloud, including references to any deployment scripts
- Architecture: Documentation of the architecture deployed to the cloud
- Performance metrics: Output of an automated &/or business testing performed to validate performance at the time of deployment
- Unique requirements or configuration: Any unique aspects fo the deployment, configuration, or technical requirements necessary to operate the workload
- Operational approval: Sign off from the application owner and managed service provider who will own the workload post deployment to validate operational readiness
- Architecture approval: Sign off from the application owner and Cloud Adoption Team to validate any architecture changes required to host each asset

## Next steps

Once change management approaches have been established, its time to begin aligning the culture to execute against the backlog. [Cultural complexity and change management](./culture-complexity.md) will help align roles and responsibilities to ensure proper expectations during execution of the plan.

> [!div class="nextstepaction"]
> [Cultural complexity and change management](./culture-complexity.md)