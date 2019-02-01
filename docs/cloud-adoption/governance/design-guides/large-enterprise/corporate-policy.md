---
title: "Fusion: Large Enterprise - Initial corporate policy behind the governance strategy"
description: Large Enterprise - Initial corporate policy behind the governance strategy.
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Large Enterprise - Initial corporate policy behind the governance strategy

The following corporate policy defines the initial governance position, which is the starting point for this journey. This article defines early-stage risks, initial policy statements, and early processes to enforce policy statements.

> [!NOTE]
>Note: The corporate policy is not a technical document, but it drives many technical decisions. The governance MVP described in the [overview](./overview.md) ultimately derives from this policy. Before implementing a governance MVP, a Cloud Governance team should develop a corporate policy based on the company’s unique objectives and business risks.

## Cloud Governance team

The CIO recently held a meeting with the IT Governance team to understand the history of the PII and Mission Critical policies and review the impact of changing those policies. She also discussed the overall potential of the cloud for IT and the company.

After the meeting, two members of the IT Governance team requested permission to research and support the cloud planning efforts. Recognizing the need for governance and an opportunity to limit shadow IT, the Director of IT Governance supported this idea. With that, the Cloud Governance team was born. Over the next several months, they will inherit the cleanup of many mistakes made during exploration in the cloud from a governance perspective. This will earn them the moniker of Cloud Custodians. In later evolutions, this journey will show how their roles change over time.

## Objective

The initial objective is to establish a foundation for governance agility. An effective governance MVP allows the Cloud Governance team to stay ahead of cloud adoption and implement guardrails as the adoption plan evolves.

## Business risks

The company is at an early stage of cloud adoption, experimenting and building proofs of concept. Risks are now relatively low, but future risks are likely. There is little definition around the final state of the technical solutions to be deployed to the cloud. In addition, the cloud readiness of IT employees is low. A foundation for cloud adoption will help the team safely learn and grow.

**Business Risk**: There is a risk of not empowering growth, as well as not providing the right protections against future risk.

An agile yet robust governance approach is needed to support the board’s vision for corporate and technical growth. Failure to implement such a strategy would slow technical progress, potentially risking market share growth and future market share. The impact of such a business risk is unquestionably high. Given the expectations placed on the IT team to support those business efforts, the IT risks are also relatively high. However, at this stage tolerance for that risk is equally high.

This business risk can be broken down tactically into several technical risks:

- Well-intended corporate policies could slow transformation efforts or break critical business processes, if not considered within a structured approval flow.
- The application of governance to deployed assets may be difficult and costly.
- Governance may not be properly applied across an application or workload, creating gaps in security.
- With so many teams working in the cloud, there is a risk of inconsistency.
- Costs may not properly align to business units, teams, or other budget structures, resulting in increased costs instead of the desired cost savings.
- Using multiple identities to manage various deployments could lead to security issues.
- Despite current policies, protected data or mission critical apps could be mistakenly deployed to the cloud.

## Tolerance indicators

The current risk tolerance is high and the appetite for investing in cloud governance is low. As such, the tolerance indicators act as an early warning system to trigger the investment of time and energy. If the following indicators are observed, it would be wise to evolve the governance strategy.

- Cost Management: Scale of deployment exceeds 1,000 assets to the cloud, or monthly spend exceeds $10,000/month. 
- Identity Baseline: Inclusion of applications with legacy or third-party multifactor authentication (MFA) requirements.
- Security Baseline: Inclusion of protected data in defined cloud adoption plans.
- Resource Consistency: Inclusion of any mission-critical applications in defined cloud adoption plans.

## Policy Statements

The following policy statements establish requirements to mitigate the defined risks. These policies define the functional requirements for the governance MVP. Each will be represented in the implementation of the governance MVP.

Deployment Acceleration: 

- All assets must be grouped and tagged in accordance with grouping and tagging strategies.
- All assets must use an approved deployment model.
- Once a governance foundation has been established for a cloud provider, any deployment tooling must be compatible with the tools approved by the Cloud Governance team.

Identity Baseline: 

- All cloud-based assets should be controlled using identities and roles approved by current governance policies.
- All groups in the on-premises Active Directory with elevated privileges should be mapped to an approved RBAC role.

Security Baseline: 

- Any asset deployed to the cloud must have an approved and validated data classification.
- Assets identified with a protected level of data cannot be deployed to the cloud until requirements for security and governance can be approved and met.
- Until minimum network security requirements can be validated and governed, cloud environments are treated as a demilitarized zone and should meet similar connection requirements as other datacenters or internal networks.

Cost Management:

- All assets must be assigned to an Application Owner, Geography, and Business Unit for tracking purposes.
- When cost concerns arise, additional governance requirements will be established in cooperation with the Finance team.

Resource Consistency: 

- Because no mission critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed.
- When mission-critical workloads are deployed, additional governance requirements will be established with IT operations.

## Processes

No budget has been allocated for ongoing monitoring and enforcement of these governance policies. However, the Cloud Governance team has some ad hoc ways to monitor adherence to policy statements:
- **Education**: The Cloud Governance team is investing time to educate the Cloud Adoption teams on the governance journeys that support these policies.
- **Deployment reviews**: Before deploying any asset, the Cloud Governance team will review the governance journey with the Cloud Adoption teams.

## Next steps

This corporate policy prepares the cloud governance team to implement the governance MVP, which will be the foundation for adoption. For more information, read [Governance MVP design](./governance-mvp.md).

> [!div class="nextstepaction"]
> [Implement the Governance MVP](./governance-mvp.md)