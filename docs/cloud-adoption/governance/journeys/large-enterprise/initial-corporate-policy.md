---
title: "Large enterprise: Initial corporate policy behind the governance strategy"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Large enterprise – Initial corporate policy behind the governance strategy.
author: BrianBlanchard
---

# Large enterprise: Initial corporate policy behind the governance strategy

The following corporate policy defines the initial governance position, which is the starting point for this journey. This article defines early-stage risks, initial policy statements, and early processes to enforce policy statements.

> [!NOTE]
>The corporate policy is not a technical document, but it drives many technical decisions. The governance MVP described in the [overview](./index.md) ultimately derives from this policy. Before implementing a governance MVP, your organization should develop a corporate policy based on your own objectives and business risks.

## Cloud Governance team

The CIO recently held a meeting with the IT Governance team to understand the history of the PII and mission-critical policies and review the effect of changing those policies. She also discussed the overall potential of the cloud for IT and the company.

After the meeting, two members of the IT Governance team requested permission to research and support the cloud planning efforts. Recognizing the need for governance and an opportunity to limit shadow IT, the Director of IT Governance supported this idea. With that, the Cloud Governance team was born. Over the next several months, they will inherit the cleanup of many mistakes made during exploration in the cloud from a governance perspective. This will earn them the moniker of _cloud custodians_. In later evolutions, this journey will show how their roles change over time.

[!INCLUDE [business-risk](../../../includes/governance/business-risks.md)]

## Tolerance indicators

The current risk tolerance is high and the appetite for investing in cloud governance is low. As such, the tolerance indicators act as an early warning system to trigger the investment of time and energy. If the following indicators are observed, it would be wise to evolve the governance strategy.

- **Cost Management:** Scale of deployment exceeds 1,000 assets to the cloud, or monthly spending exceeds $10,000 USD per month.
- **Identity Baseline:** Inclusion of applications with legacy or third-party multi-factor authentication requirements.
- **Security Baseline:** Inclusion of protected data in defined cloud adoption plans.
- **Resource Consistency:** Inclusion of any mission-critical applications in defined cloud adoption plans.

[!INCLUDE [policy-statements](../../../includes/governance/policy-statements.md)]

## Next steps

This corporate policy prepares the Cloud Governance team to implement the governance MVP, which will be the foundation for adoption. The next step is to implement this MVP.

> [!div class="nextstepaction"]
> [Best practice explained](./best-practice-explained.md)