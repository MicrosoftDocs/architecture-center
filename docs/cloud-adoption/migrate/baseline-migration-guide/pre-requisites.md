---
title: "CAF: Pre-requisites before starting the Simple Migration Journey"
description: Pre-requisites before starting the Simple Migration Journey
author: matticusau
ms.author: mlavery
ms.date: 4/14/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack - new"
---

::: zone target="chromeless"

# Pre-requisites

::: zone-end

::: zone target="docs"

# Pre-requisites before migrating to Azure

::: zone-end

Prior to beginning any migrations, the environment must be prepared for the coming changes. The resources provided within this section of the guide will assist you in achieving this objective.

# [Narrative](#tab/Narrative)

Tell the customer's story

## Migration Characteristics

What does the digital estate look like for this customer before the migration?
What do they hope to accomplish after this migration?

::: zone target="docs"

## Link examples in docs view

- [Management Groups](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade).
- [Understanding resource access management in Azure](/azure/architecture/cloud-adoption-guide/adoption-intro/azure-resource-access)

::: zone-end

::: zone target="chromeless"

## Actions examples in Quick Start Center view

::: form action="OpenBlade[#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade]" submitText="Go to Management groups" :::

::: zone-end

# [When to use this approach](#tab/Approach)

This guide has been designed for environments

# Learn More

- [CAF: Migration Theory](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/migrate/theory/pre-requisites/?branch=caf%2Fmigrate-v1)
- [CAF: 5 Rs of Rationalization](https://docs.microsoft.com/en-gb/azure/architecture/cloud-adoption/digital-estate/5-rs-of-rationalization)

# [Planning Checklist](#tab/Checklist)

Before starting a migration there are a number of activities you will need to complete. The exact details of these activities will vary depending on the environment you are migrating, however as a general rule the following checklist may apply:

> [!div class="checklist"]
> * **Identify stakeholders**: Identify the key people who will have a role to play or stake in the outcome of the migration
> * **Identify key milestones**: To effectively plan the migration timelines identify the key milestones to be met.
> * **Identify the migration strategy**: Determine which of the 5 Rs of rationalization you will use.
> * **Assess your technical fit**: Validate the technical readiness and suitability for migration.
> * **Migrate your services**: Perform the actual migration.
> * **Post Migration**: Understand what is required after you migrate your environment to Azure.

Assuming you choose a "rehost" approach to migration the following child activities will be relevant:

> [!div class="checklist"]
> * **Governance alignment**: Has a consensus been achieved regarding alignment of governance with the migration foundation.
> * **Network**: A network approach should be selected and aligned to IT security requirement.
> * **Identity**: A hybrid identity approach should be aligned to fit the identity management and cloud adoption plan.

::: zone target="docs"

# Learn More

- [CAF: 5 Rs of Rationalization](https://docs.microsoft.com/en-gb/azure/architecture/cloud-adoption/digital-estate/5-rs-of-rationalization)
- [CAF: Planning Checklist](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/migrate/theory/pre-requisites/planning-checklist?branch=caf%2Fmigrate-v1)

::: zone-end
