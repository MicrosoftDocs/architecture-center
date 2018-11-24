---
title: "Fusion: Guidance to prepare workload architecture prior to migration"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Guidance to prepare workload architecture prior to migration

The [Migration section](../overview.md) of the [Fusion framework](../../overview.md), outlines the processes typically required to migrate a datacenter to the cloud. This article, expands on the [Migration Execution Process](overview.md)by reviewing activities associated with defining the Architecture of a workload within a given iteration.

As discussed in the article on [Incremental Rationalization](../../digital-estate/rationalize-incremental.md), a number of architectural assumptions are made during any business transformation that requires a migration. This article will clarify those assumptions, share a few roadblocks that can be avoided, and identify opportunities to accelerate business value by challenging those assumptions. This incremental model for architecture allows teams to move faster and obtain business outcomes sooner.

## Architecture assumptions prior to migration

The following assumptions are generally made with any migration effort.

* Infrastructure as a Service (IaaS): It is generally assumed that a migration entails the movement of virtual machines from a physical data center to a cloud data center, via an IaaS migration. This is also known as a Lift & Shift. (See exceptions below...)
* Architecture Consistency: Changes to core architecture during a migration considerably increases complexity. Debugging a changed system on a new platform introduces many variables that can be difficult to isolate. For this reason, it is suggested that applications undergo only minor changes during migration & that any changes are tested thoroughly.
* Retirement Test: Migrations and the hosting of assets consume operational and potential capital expenses. It is assumed that any application being migrated has been reviewed to validate on-going usage. The choice to retire unused assets will produce immediate cost savings.
* Resize Assets: It is assumed that few on-prem assets actually use the allocated resources. Prior to migration, it is assumed that assets will be resized to best fit actual usage requirements.
* BC/DR (Business Continuity/Disaster Recovery) requirements: It is assumed that an agreed upon SLA for the application has been negotiated with the business prior to release planning. These requirements are likely to produce minor architecture changes.
* Migration Downtime: Likewise, downtime to promote the application to production can have an adverse impact on the business. Sometimes, the solutions required to transition with minimum downtime can require architecture changes. It is assumed that a general understanding of downtime requirements has been established prior to release planning.

## Roadblocks that can be avoided

The assumptions above can create roadblocks which could slow progress or cause later pain points. The following are a few roadblocks to watch for prior to the release.

* Paying for technical debt: Some aging applications carry with them a high amount of technical debt. This can lead to long term challenges by increasing hosting costs with any cloud provider. When technical debt, unnaturally increases hosting costs, alternative architectures should be evaluated.
* User traffic patterns: Existing solutions may be dependent upon existing network routing patterns. These patterns could slow application performance considerably. Further, introduction of new hybrid WAN (Wide Area Network) solutions can take weeks or even months. Prepare for these roadblocks by considering traffic patterns and changes to any Core Infrastructure services, early in the architecture process.

## Accelerating business value

There are a number scenarios that could prompt for an alternative architecture. The following are a few examples:

* PaaS alternatives: Platform as a Service (PaaS) deployments can reduce hosting costs, they can also reduce the time required to migrate certain applications. See the article on [Assessing Assets](assess.md) for a list of approaches that could benefit from a PaaS conversion.
* Scripted Deployments / DevOps: If an application has an existing DevOps deployment or other forms of scripted deployment, the cost of changing that scripts could be lower than the cost of migrating the asset.
* Remediation efforts: The remediation efforts required to prepare an application for migration can be extensive. In some cases, it makes more sense to modernize the solution, than it does to remediate underlying compatibility issues.

In each of the above scenarios, an alternative architecture could be the best possible solution.

## Next steps

Once the new architecture is defined, [Remediation activities](remediate.md) are a logical next step.
If no remediation is required in a given iteration, [Replication activities](remediate.md) may be more appropriate.

> [!div class="nextstepaction"]
> [Remediation assets](remediate.md)