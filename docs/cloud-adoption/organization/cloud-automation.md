---
title: "Cloud automation capabilities"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Describe the formation of cloud automation capabilities
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: organize
ms.custom: organize
---

# Cloud automation capabilities

During cloud adoption efforts, cloud automation capabilities will unlock the potential of DevOps and a cloud-native approach. Expertise in each of these areas can accelerate adoption and innovation.

## Possible sources for cloud automation expertise

The skills needed to provide cloud automation capabilities could be provided by:

- DevOps engineers
- Developers with DevOps and infrastructure expertise
- IT engineers with DevOps and automation expertise

These subject matter experts might be providing capabilities in other areas such as cloud adoption, cloud governance, or cloud platform. After they demonstrate proficiency at automating complex workloads, you can recruit these experts to deliver automation value.

## Mindset

Before you admit a team member to this group, they should demonstrate three key characteristics:

- Expertise in any cloud platform with a special emphasis on DevOps and automation.
- A growth mindset or openness to changing the way IT operates today.
- A desire to accelerate business change and remove traditional IT roadblocks.

## Key responsibilities

The primary duty of cloud automation is to own and advance the solution catalog. The solution catalog is a collection of prebuilt solutions or automation templates. These solutions can rapidly deploy various platforms as required to support needed workloads. These solutions are building blocks that accelerate cloud adoption and reduce the time to market during migration or innovation efforts.

Examples of solutions in the catalog include:

- A script to deploy a containerized application
- A Resource Manager template to deploy a SQL HA AO cluster
- Sample code to build a deployment pipeline using Azure DevOps
- An Azure DevTest Labs instance of the corporate ERP for development purposes
- Automated deployment of a self-service environment commonly requested by business users

The solutions in the solution catalog aren't deployment pipelines for a workload. Instead, you might use automation scripts in the catalog to quickly create a deployment pipeline. You might also use a solution in the catalog to quickly provision platform components to support workload tasks like automated deployment, manual deployment, or migration.

These following tasks are typically executed by cloud automation on a regular basis:

### Strategic tasks

- Review:
  - [business outcomes](../business-strategy/business-outcomes/index.md)
  - [financial models](../business-strategy/financial-models.md)
  - [motivations for cloud adoption](../business-strategy/motivations-why-are-we-moving-to-the-cloud.md)
  - [business risks](../governance/policy-compliance/risk-tolerance.md)
  - [rationalization of the digital estate](../digital-estate/overview.md)
- Monitor adoption plans and progress against the [prioritized migration backlog](../migrate/migration-considerations/assess/release-iteration-backlog.md).
- Identify opportunities to accelerate cloud adoption, reduce effort through automation, and improve security, stability, and consistency.
- Prioritize a backlog of solutions for the solution catalog that delivers the most value given other strategic inputs.

### Technical tasks

- Curate or develop solutions based on the prioritized backlog.
- Ensure solutions align to platform requirements.
- Ensure solutions are consistently applied and meet existing governance/compliance requirements.
- Create and validate solutions in the catalog.
- Review release plans for sources of new automation opportunities.

## Meeting cadence

Cloud automation is a working team. Expect participants to commit a large portion of their daily schedules to cloud automation work. Contributions aren't limited to meetings and feedback cycles.

The cloud automation team should align activities with other areas of capability. This alignment might result in meeting fatigue. To ensure cloud automation has sufficient time to manage the solution catalog, you should review meeting cadences to maximize collaboration and minimize disruptions to development activities.

## Next steps

As the essential cloud capabilities align, the collective teams can help [develop needed technical skills](./suggested-skills.md).

> [!div class="nextstepaction"]
> [Building technical skills](./suggested-skills.md)
