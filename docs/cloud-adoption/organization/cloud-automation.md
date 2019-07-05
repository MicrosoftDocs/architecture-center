---
title: "Cloud automation capabilities"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Describe the formation of cloud automation capabilities
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: organize
---

# Cloud automation capabilities

Cloud automation capabilities unlock the potential of both DevOps and a cloud-native approach during cloud adoption efforts. Each of which accelerate adoption and innovation.

## Possible sources for this capability

The skills needed to provide cloud automation capabilities could be provided by:

- DevOps engineers.
- Developers with DevOps and infrastructure expertise.
- IT engineers with DevOps and automation expertise.

Commonly, these subject matter experts are already providing capabilities in other areas such as cloud adoption, cloud governance, or cloud platform. After demonstrating proficiency at automating complex workloads, these experts are recruited to deliver automation value.

## Mindset

Before admittance to this group, team members should demonstrate three key characteristics:

- Expertise in any cloud platform, with a special emphasis on DevOps and automation.
- A growth mindset or openness to changing the way IT operates today.
- A desire to accelerate business change and remove traditional IT roadblocks.

## Key responsibilities

The primary duty of cloud automation is to own and advance the solution catalog. The solution catalog is a collection of prebuilt solutions, or automation templates, which can be used to rapidly deploy various platforms required to support specific workloads. The solutions in the catalog are used like building blocks to accelerate cloud adoption and reduce time to market during migration or innovation efforts.

Examples of solutions in the catalog could include things like:

- A script to deploy a containerized application.
- A Resource Manager template to deploy a SQL HA AO cluster.
- Sample code to build a deployment pipeline using Azure DevOps.
- A DevTest Labs instance of the corporate ERP for development purposes.
- Automated deployment of a self-service environment commonly requested by business users.

The solutions in the solution catalog are not deployment pipelines for a workload, but the automation scripts in the catalog can be used to more quickly create a deployment pipeline. They could also be used to quickly provision platform components that could support automated deployment, manual deployment, or migration of a workload.

These tasks are typically executed by cloud automation on a regular basis:

### Strategic tasks

- Review [business outcomes](../business-strategy/business-outcomes/index.md), [financial models](../business-strategy/financial-models.md), [motivations for cloud adoption](../business-strategy/motivations-why-are-we-moving-to-the-cloud.md), [business risks](../governance/policy-compliance/risk-tolerance.md), and [rationalization of the digital estate](../digital-estate/overview.md).
- Monitor adoption plans and progress against the [prioritized migration backlog](../migrate/migration-considerations/assess/release-iteration-backlog.md)
- Identify opportunities to accelerate cloud adoption, reduce effort through automation, and improve security, stability, and consistency.
- Prioritize a backlog of solutions for the solution catalog that delivers the most value given other strategic inputs.

### Technical tasks

- Curate or develop solutions based on the prioritized backlog.
- Ensure solutions align to platform requirements.
- Ensure solutions are consistently applied and meet existing governance/compliance requirements.
- Create and validate solutions in the catalog.
- Review release plans for sources of new automation opportunities.

## Meeting cadence

Cloud automation is a working team. The time commitment from each team member will represent a large percentage of their daily schedules. Contributions will not be limited to meetings and feedback cycles.

Cloud automation should align activities with other areas of capability. This alignment could quickly trigger meeting fatigue. To ensure cloud automation has sufficient time to manage the solution catalog, meeting cadences should be reviewed to maximize collaboration and minimize disruptions to development activities.

## Next steps

With each of the essential cloud capabilities aligned, the collective teams can aid in shaping the [development of technical skills](./suggested-skills.md).

> [!div class="nextstepaction"]
> [Building technical skills](./suggested-skills.md)