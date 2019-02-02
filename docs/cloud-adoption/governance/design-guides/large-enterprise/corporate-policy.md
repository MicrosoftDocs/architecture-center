---
title: "Fusion: Large Enterprise - Initial corporate policy behind the governance strategy"
description: Large Enterprise - Initial corporate policy behind the governance strategy.
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Large Enterprise - Initial corporate policy behind the governance strategy

The following corporate policy defines the initial governance position, which is the starting point for this journey. This article defines early-stage risks, initial policy statements, and early processes to enforce policy statements.

> [!NOTE]
>The corporate policy is not a technical document, but it drives many technical decisions. The governance minimum viable product (MVP) described in the [overview](./overview.md) ultimately derives from this policy. Before implementing a governance MVP, your organization should develop a corporate policy based on your own objectives and business risks.

## Cloud Governance team

The CIO recently held a meeting with the IT Governance team to understand the history of the PII and Mission Critical policies and review the impact of changing those policies. She also discussed the overall potential of the cloud for IT and the company.

After the meeting, two members of the IT Governance team requested permission to research and support the cloud planning efforts. Recognizing the need for governance and an opportunity to limit shadow IT, the Director of IT Governance supported this idea. With that, the Cloud Governance team was born. Over the next several months, they will inherit the cleanup of many mistakes made during exploration in the cloud from a governance perspective. This will earn them the moniker of Cloud Custodians. In later evolutions, this journey will show how their roles change over time.

[!INCLUDE [business-risk](../../../../../includes/cloud-adoption/governance/business-risks.md)]

## Tolerance indicators

The current risk tolerance is high and the appetite for investing in cloud governance is low. As such, the tolerance indicators act as an early warning system to trigger the investment of time and energy. If the following indicators are observed, it would be wise to evolve the governance strategy.

- Cost Management: Scale of deployment exceeds 1,000 assets to the cloud, or monthly spend exceeds $10,000/month. 
- Identity Baseline: Inclusion of applications with legacy or third-party multifactor authentication (MFA) requirements.
- Security Baseline: Inclusion of protected data in defined cloud adoption plans.
- Resource Consistency: Inclusion of any mission-critical applications in defined cloud adoption plans.

[!INCLUDE [policy-statements](../../../../../includes/cloud-adoption/governance/policy-statements.md)]

## Next steps

This corporate policy prepares the cloud governance team to implement the governance MVP, which will be the foundation for adoption. The next step is to implement this MVP.

> [!div class="nextstepaction"]
> [Implement the Governance MVP](./governance-mvp.md)