---
title: "Migration Environment - Planning Checklist"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Validate environmental readiness prior to migration
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Migration environment planning checklist - Validate environmental readiness prior to migration

As an initial step in the migration process, you need to create the right environment in the cloud to receive, host, and support migrating assets. This article provides a list of things to validate in the current environment prior to migration.

The following checklist aligns with the guidance found in the [Ready section](../../../ready/index.md) of the Cloud Adoption Framework. Review that section for guidance regarding execution of any of the following.

## Effort type assumption

This article and checklist assume a _rehost_ or _cloud transition_ approach to cloud migration.

## Governance alignment

The first and most important decision regarding any migration-ready environment is the choice of governance alignment. Has a consensus been achieved regarding alignment of governance with the migration foundation? At minimum, the cloud adoption team should understand whether this migration is landing in a single environment with limited governance, a fully governed environment factory, or some variant in between. For more options and guidance on governance alignment, see the article on [Governance and compliance alignment](../../expanded-scope/governance-or-compliance.md).

## Cloud readiness implementation

Whether you choose to align with a broader cloud governance strategy or not for your initial migration, you will need to ensure your cloud deployment environment is configured to support your workloads.

If you're planning to align your migration with a cloud governance strategy from the start, you'll need to apply the [Five Disciplines of Cloud Governance](../../../governance/governance-disciplines.md) to help inform decisions on policies, toolchains, and enforcement mechanisms that will align your cloud environment with overall corporate requirements. Consult the Cloud Adoption Framework [actionable governance design guides](../../../governance/journeys/index.md) for examples of how to implement this model using Azure services.

If your initial migrations are not closely aligned with a broader cloud governance strategy, the general issues of organization, access, and infrastructure planning still need to be managed. Consult the [Azure readiness guide](../../../ready/azure-readiness-guide/index.md) for help with these cloud readiness decisions.

> [!CAUTION]
> We highly recommend that you develop a governance strategy for anything beyond your initial workload migration.

Regardless of your level of governance alignment, you will need to make decisions related to the following topics.

### Resource organization

Based on the governance alignment decision, an approach to the organization and deployment of resources should be established prior to migration.

### Nomenclature

A consistent approach for naming resources, along with consistent naming schemas, should be established prior to migration.

### Resource governance

A decision regarding the tools to govern resources should be made prior to migration. The tools do not need to be fully implemented, but a direction should be selected and tested. It is advised that the cloud governance team define and require the implementation of a minimum viable product (MVP) for governance tooling prior to migration.

## Network

Your cloud-based workloads will require the provisioning of virtual networks to support end-user and administrative access. Based on resource organization and resource governance decisions, you should select a network approach align it to IT security requirements. Further, your networking decisions should be aligned with any hybrid network constraints required to operate the workloads in the migration backlog and support any access to resources hosted on-premises.

## Identity

Cloud-based identity services are a prerequisite for offering identity and access management (IAM) for your cloud resources. Align your identity management strategy with your cloud adoption plans before proceeding. For example, when migrating existing on-premises assets, consider supporting a hybrid identity approach using [directory synchronization](../../../decision-guides/identity/index.md) to allow a consistent set of user credentials across you on-premises and cloud environments during and after the migration.

## Next steps

If the environment meets the minimum requirements, it may be deemed approved for migration readiness. [Cultural complexity and change management](./culture-complexity.md) helps to align roles and responsibilities to ensure proper expectations during execution of the plan.

> [!div class="nextstepaction"]
> [Cultural complexity and change management](./culture-complexity.md)
