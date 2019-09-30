---
title: "Architect workloads prior to migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Architect workloads prior to migration
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Architect workloads prior to migration

This article expands on the assessment process by reviewing activities associated with defining the architecture of a workload within a given iteration. As discussed in the article on [incremental rationalization](../../../digital-estate/rationalize.md), some architectural assumptions are made during any business transformation that requires a migration. This article clarifies those assumptions, shares a few roadblocks that can be avoided, and identifies opportunities to accelerate business value by challenging those assumptions. This incremental model for architecture allows teams to move faster and to obtain business outcomes sooner.

## Architecture assumptions prior to migration

The following assumptions are typical for any migration effort:

- **IaaS.** It is commonly assumed that migrating workloads primarily involves the movement of virtual machines from a physical datacenter to a cloud datacenter via an IaaS migration, requiring a minimum of redevelopment or reconfiguration. This is known as a "lift and shift" migration. (Exceptions follow.)
- **Architecture consistency.** Changes to core architecture during a migration considerably increase complexity. Debugging a changed system on a new platform introduces many variables that can be difficult to isolate. For this reason, workloads should undergo only minor changes during migration and any changes should be thoroughly tested.
- **Retirement test.** Migrations and the hosting of assets consume operational and potential capital expenses. It is assumed that any workloads being migrated have been reviewed to validate ongoing usage. The choice to retire unused assets produces immediate cost savings.
- **Resize assets.** It is assumed that few on-premises assets are fully using the allocated resources. Prior to migration, it is assumed that assets will be resized to best fit actual usage requirements.
- **Business continuity and disaster recovery (BCDR) requirements.** It is assumed that an agreed-on SLA for the workload has been negotiated with the business prior to release planning. These requirements are likely to produce minor architecture changes.
- **Migration downtime.** Likewise, downtime to promote the workload to production can have an adverse effect on the business. Sometimes, the solutions that must transition with minimum downtime need architecture changes. It is assumed that a general understanding of downtime requirements has been established prior to release planning.

## Roadblocks that can be avoided

The itemized assumptions can create roadblocks that could slow progress or cause later pain points. The following are a few roadblocks to watch for, prior to the release:

- **Paying for technical debt.** Some aging workloads carry with them a high amount of technical debt. This can lead to long-term challenges by increasing hosting costs with any cloud provider. When technical debt unnaturally increases hosting costs, alternative architectures should be evaluated.
- **User traffic patterns.** Existing solutions may depend on existing network routing patterns. These patterns could slow performance considerably. Further, introduction of new hybrid wide area network (WAN) solutions can take weeks or even months. Prepare early in the architecture process for these roadblocks by considering traffic patterns and changes to any core infrastructure services.

## Accelerating business value

Some scenarios could require an different architecture than the assumed IaaS rehosting strategy. The following are a few examples:

- PaaS alternatives. PaaS deployments can reduce hosting costs, and they can also reduce the time required to migrate certain workloads. For a list of approaches that could benefit from a PaaS conversion, see the article on [evaluating assets](./evaluate.md).
- Scripted deployments/DevOps. If a workload has an existing DevOps deployment or other forms of scripted deployment, the cost of changing those scripts could be lower than the cost of migrating the asset.
- Remediation efforts. The remediation efforts required to prepare a workload for migration can be extensive. In some cases, it makes more sense to modernize the solution than it does to remediate underlying compatibility issues.

In each of these itemized scenarios, an alternative architecture could be the best possible solution.

## Next steps

After the new architecture is defined, [accurate cost estimations can be calculated](./estimate.md).

> [!div class="nextstepaction"]
> [Estimate cloud costs](./estimate.md)
