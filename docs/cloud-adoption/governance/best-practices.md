---
title: "Mature your initial governance foundation"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Mature your initial governance foundation
author: BrianBlanchard
ms.author: brblanch
ms.date: 01/03/2019
ms.topic: landing-page
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
layout: LandingPage
---

# Mature your initial governance foundation

This article assumes that an [initial governance foundation](./getting-started.md) is already in place. As your cloud adoption plan is implemented, tangible risks will emerge from the proposed approaches by which teams want to adopt the cloud. As these risks surface in release planning conversations, use the following grid to quickly identify a few best practices for getting ahead of the adoption plan to prevent risks from becoming real threats.

## Maturity vectors

At any time, the following best practices can be applied to the initial governance foundation to accommodate the risk or need mentioned in the table below.

> [!IMPORTANT]
> The organization of resources can have a direct impact on how the best practices are applied. It is important to start with the best practice which best aligns with the initial governance foundation (or governance mvp) you implemented in the previous step.

|Risk/Need | Small-medium enterprise | Large enterprise |
|---|---|---|
|Sensitive data in the cloud|[Best practice](./journeys/small-to-medium-enterprise/security-baseline-evolution.md)|[Best practice](./journeys/large-enterprise/security-baseline-evolution.md)|
|Mission critical apps in the cloud|[Best practice](./journeys/small-to-medium-enterprise/resource-consistency-evolution.md)|[Best practice](./journeys/large-enterprise/resource-consistency-evolution.md)|
|Cloud cost management|[Best practice](./journeys/small-to-medium-enterprise/cost-management-evolution.md)|[Best practice](./journeys/large-enterprise/cost-management-evolution.md)|
|Multicloud|[Best practice](./journeys/small-to-medium-enterprise/multicloud-evolution.md)|[Best practice](./journeys/large-enterprise/multicloud-evolution.md)|
|Complex/legacy identity management|         |[Best practice](./journeys/large-enterprise/identity-baseline-evolution.md)|
|Multiple layers of governance|         |[Best practice](./journeys/large-enterprise/multiple-layers-of-governance.md)|

## Next steps

In addition to the application of best practices, the governance methodology in the Cloud Adoption Framework is extensively customizable to fit unique business constraints. After applying the appropriate best practices, evaluate [corporate policy to understand additional customization requirements](./corporate-policy.md).

> [!div class="nextstepaction"]
> [Evaluate corporate policy to understand additional customization requirements](./corporate-policy.md)
