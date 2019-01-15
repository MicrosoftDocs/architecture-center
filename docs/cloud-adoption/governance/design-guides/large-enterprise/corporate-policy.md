---
title: "Fusion: Governance Design Guide future proof"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 2/1/2018
---

# Fusion: Corporate Policies behind the Enterprise MVP Governance Design Guide

The [Enterprise MVP Governance Design Guide](./design-guide.md) presents a highly opinionated view of adopting governance for Azure. That design guide serves as a starting point to develop a custom governance position for enterprises that are moving to Azure but are not ready to invest heavily in governance disciplines. This article outlines the corporate policies set by a synthesized company, based on a [specific use case](./use-case.md). Before adopting the opinionated design guide, this article can help the reader understand if that opinion is relevant and aligned to their specific corporate policies.

> [!TIP]
> It is unlikely that the corporate policies below will align 100% with any reader of this design guide. It is simply a starting point to be customized and refined, as needed. For additional guidance on establishing corporate policies that better align, see the series of articles on [defining corporate policy](../../policy-compliance/overview.md). If a specific governance discipline isn't aligned with the reader's required implementation, see the series of articles on the [disciplines of cloud governance](../../governance-disciplines.md).

## Corporate Policy supporting this use case

Based on the [Enterprise MVP Use Case](./use-case.md), the following is a set of sample corporate policy statements synthesized from similar customer experiences.
The corporate policy consists of four sections: business risk, tolerance indicators, policy statements, and processes for monitoring and enforcing policy.

## Business Risks

At this stage of cloud adoption, future compatibility represents the greatest risk from a governance perspective. A basic foundation for cloud adoption would help avoid costly rework and future adoption blockers. This business risk can be broken down tactically into a few technical risks:

* There is a risk that the application of governance to deployed assets could be difficult and costly.
* There is a risk that governance may not be properly applied across an application or workload, creating gaps in security.
* There is a risk of inconsistency with so many teams working in the cloud.
* There is a risk of costs not properly aligning to business units, teams, or other budgetary management units.
* There is a risk associated with multiple identities being used to manage various deployments, which could lead to security issues.
* There is a risk of not meeting SLAs to the business for various assets or workloads
* There is a risk of one of the teams deploying to the cloud accidentally violating security, sla, or cost assumptions.

In a real-world scenario, there are likely to be a few additional [business risks](../../policy-compliance/understanding-business-risk.md) worth noting at this stage of adoption. The article on [understanding business risks](../../policy-compliance/understanding-business-risk.md) can help capture relevant business risks.

## Tolerance Indictors

The current tolerance for risk is high and appetite for investing in cloud governance is low. As such, the tolerance indicators for this use case act more like a reminder than an observable metric. When/if the following indicators are observed, it would be wise to revisit the business's tolerance for risk.

* Inclusion of protected data in defined cloud adoption plans
* Inclusion of assets that have any dependency on protected data
* Inclusion of assets that support mission critical functionality
* Deployment of more than 1,000 assets to the cloud
* Monthly spend exceeding $10,000/month

The above indicators are based on the synthesized use case. Adjust accordingly to align with actual tolerance indicators. See the article on [metrics and tolerance indicators](../../policy-compliance/risk-tolerance.md) for additional guidance.

## Policy Statements

The following policy statements would establish requirements to mitigate the defined risks. To understand options and better align the 5 disciplines of cloud governance, click on any of the policy statement headers to learn more about the specific governance discipline.

* [Configuration Management](../../configuration-management/overview.md): Multiple
    * All assets must be grouped and tagged, in alignment with the Grouping and Tagging strategies defined in the design guide.
    * All assets must use an approved deployment model defined in the design guide.
* [Identity Management](../../identity-management/overview.md): Multiple
    * All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
    * All groups in the on-prem AD infrastructure which have elevated privileges should be mapped to an approved RBAC role
    * All authentication models in the cloud should be compatible with ticket-based and third-party multi-factor authentication  
* [Security Management](../../security-management/overview.md): Multiple
    * Any asset deployed to the cloud must have an approved data classification
    * No assets identified with a protected level of data may be deployed to the cloud
    * Until minimum network security requirements can be validated and governed, cloud environments are seen as a demilitarized zone and should meet similar connection requirements
* [Cost Management](../../cost-management/overview.md): For tracking purposes, all assets must be assigned to a billing unit.
* [Resource Management](../../resource-management/overview.md): Since no mission critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed.

The above policy statements are based on the synthesized use case. See the article on [developing policy statements](../../policy-compliance/define-policy.md) for additional guidance on crafting unique policy statements.

## Monitoring and Enforcement Processes

A budget has not been allocated to the on-going monitoring and enforcement of these governance policies. Initial education and limited involvement in deployment planning are the two primary opportunities to monitor adherence to policy statements.

The cloud governance team currently consists of two members of the existing governance team, who are interested in learning about the cloud and aiding in adoption efforts.

**Initial Eduction:** The "cloud governance team" is investing time to educate the cloud adoption teams on the design guides that support these policies.

**Deployment Planning:** Prior to deployment of any asset, the "cloud governance team" will review the design guide with the cloud adoption teams to validate alignment.

The suggested processes are very minimal due to the state of maturity outlined in the synthesized use case. See the article on [establishing policy adherence processes](../../policy-compliance/processes.md) for additional guidance on developing monitoring and enforcement processes.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case](./use-case.md) and the policy statements listed above.
More than likely, this guide will require customization. To aid in making relevant decisions to customize this guide, the following links may be of value:

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

> [!div class="nextstepaction"]
> [Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)
