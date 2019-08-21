---
title: "Small-to-medium enterprise: Initial corporate policy behind the governance strategy"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Small-to-medium enterprise - Initial corporate policy behind the governance strategy.
author: BrianBlanchard
---

# Small-to-medium enterprise: Initial corporate policy behind the governance strategy

The following corporate policy defines an initial governance position, which is the starting point for this journey. This article defines early-stage risks, initial policy statements, and early processes to enforce policy statements.

> [!NOTE]
>The corporate policy is not a technical document, but it drives many technical decisions. The governance MVP described in the [overview](./index.md) ultimately derives from this policy. Before implementing a governance MVP, your organization should develop a corporate policy based on your own objectives and business risks.

## Cloud Governance team

In this narrative, the Cloud Governance team is comprised of two systems administrators who have recognized the need for governance. Over the next several months, they will inherit the job of cleaning up the governance of the company’s cloud presence, earning them the title of _cloud custodians_. In subsequent evolutions, this title will likely change.

[!INCLUDE [business-risk](../../../includes/governance/business-risks.md)]

## Tolerance indicators

The current tolerance for risk is high and the appetite for investing in cloud governance is low. As such, the tolerance indicators act as an early warning system to trigger more investment of time and energy. If and when the following indicators are observed, you should evolve the governance strategy.

- Cost Management: The scale of deployment exceeds 100 assets to the cloud, or monthly spending exceeds $1,000 USD per month.
- Security Baseline: Inclusion of protected data in defined cloud adoption plans.
- Resource Consistency: Inclusion of any mission-critical applications in defined cloud adoption plans.

[!INCLUDE [policy-statements](../../../includes/governance/policy-statements.md)]

## Next steps

This corporate policy prepares the Cloud Governance team to implement the governance MVP, which will be the foundation for adoption. The next step is to implement this MVP.

> [!div class="nextstepaction"]
> [Best practice explained](./best-practice-explained.md)