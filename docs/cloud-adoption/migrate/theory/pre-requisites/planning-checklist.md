---
title: "Migration Environment - Planning Checklist"
description: Validate environmental readiness prior to migration
author: BrianBlanchard
ms.date: 4/1/2019
---

# Migration Environment - Planning Checklist: Validate environmental readiness prior to migration

Prior to migrating assets, the right environment must be created in the cloud to receive, host, and support those assets. This article will provide a list of things to validate in the current environment prior to migration.

The following checklist aligns with the guidance found in the [Build section of the Cloud Adoption Framework](../../../build/index.md), please review that section for guidance regarding execution of any of the following.

## Effort Type Assumption

This article and checklist assumes a **rehost** or **cloud transition** approach to cloud migration.

## Governance alignment

The first and most important decision regarding any migration ready environment, is the choice of governance alignment. Has a consensus been achieved regarding alignment of governance with the migration foundation. At minimum, the cloud adoption team should understand if this migration is landing in a single environment with limited governance, a fully governed environment factory, or some variant in between. For more options and guidance on governance alignment, see the article on [Governance Alignment](../../../build/governance-alignment.md) in the  [Build section of the Cloud Adoption Framework](../../../build/index.md)

### Resource Organization

Based on the governance alignment decision, an approach to the organization and deployment of resources should be established prior to migration.

### Nomenclature

A consistent approach for naming resources, along with consistent naming schemas, should be established prior to migration.

### Resource Governance

A decision regarding the tools to govern resources should be made prior to migration. The tools do not need to be fully implemented, but a direction should be selected and tested. It is advised that the cloud governance team define and require the implementation of a Minimally Viable Product (MVP) for governance tooling, prior to migration.

## Network

Based on resource organization and resource governance decisions, a network approach should be selected and aligned to IT security requirements. Further, the network decisions should be aligned with any hybrid network constraints required to operate the applications in the migration backlog.

## Identity

A hybrid identity approach should be aligned to fit the identity management and cloud adoption plan.

## Next steps

If the environment meets the minimum requirements defined above, then the environment may be deemed approved for migration readiness. [Technical complexity and change management](./technical-complexity.md) will help prepare the cloud adoption team for the technical complexity of migration by aligning to an incremental change management process.

> [!div class="nextstepaction"]
> [Technical complexity and change management](./technical-complexity.md)