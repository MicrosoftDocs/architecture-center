---
title: "Fusion: Governance Design Guide future proof"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: A Governance Design Guide to future proof deployments

Fusion provides a cloud agnostic approach to the creation of a cloud governance strategy. To learn more about that model, checkout the [overview section of Governance](../overview.md). This article demonstrates implementation of a cloud governance strategy that aligns to the specific use case below: Future Proof for Governance.

## Use Case: Future Proof

The need for governance is personal and unique. Defining and implementing a governance strategy requires an understanding of the business risks and the business's tolerance for those risks. Both evolve over time, especially as new technical features are adopted. When risk is high and tolerance is low, the business may be willing to invest in the disciplines required to govern the cloud. Conversely, if risk is low and tolerance is high, it may be difficult to fund an enterprise scale cloud governance program.

This design guide focuses on the later of the two scenarios above; low risk cloud deployments for a company that has a relatively high risk tolerance. The following are characteristics that were factored into the design of the cloud governance strategy and this design guide.

### Current State

* A few IT assets have been deployed to the cloud
* Multiple development teams are working in a dev/test capacity to learn about cloud native capabilities
* The BI team is experimenting with big data in the cloud
* The governance team has set a policy that customer's PII (Personally Identifiable Information) and financial data can not be hosted in the cloud, which limits mission critical applications in the current deployments.

### Future State

* The cloud adoption plan calls for 500% growth in cloud adoption this year
* The CIO and CFO have committed to terminating two data centers within the next 36 months, by migrating more than 5,000 assets to the cloud
* Both App Dev and BI will likely release production solutions to the cloud in the next 24 months.
* The governance team's policy on PII and financial data will need to evolve for either of the future state visions to be realized.

### Objective

For the future state to be realized, PII and Financial Data will have to go to the cloud. For that to happen, the cloud will need a robust governance strategy.
The business is not willing to invest in Cloud Governance today. However, Cloud Governance is likely to be a wise investment in the near future.
The objective of this design guide is to establish a common foundation for all deployments. That foundation will need to scale as new policies and governance disciplines are added.

## Corporate Policy

Based on the [Future Proof Use Case](#use-case:-future-proof), the following is a sample of a corporate policy synthesized from similar customer experiences. This corporate policy can serve as a foundation for personalizing and defining a more targeted governance policies. The landing page on the [five disciplines of cloud governance](../governance-disciplines.md) can aid in customizing this policy.

## Business Risks

At this stage of cloud adoption, future compatibility represents the greatest risk from a governance perspective. A basic foundation for cloud adoption would help avoid costly rework and future adoption blockers. This business risk can be broken down tactically into a few technical risks:

* There is a risk that the application of governance to deployed assets could be difficult and costly.
* There is a risk that governance may not be properly applied across an application or workload, creating gaps in security.
* There is a risk of inconsistency with so many teams working in the cloud.
* There is a risk of costs not properly aligning to business units, teams, or other budgetary management units.
* There is a risk associated with multiple identities being used to manage various deployments, which could lead to security issues.
* In spite of current policies, there is a risk that protected data could be mistakenly deployed to the cloud.

In a real-world scenario, there are likely to be a few additional [business risks](../policy-compliance/understanding-business-risk.md) worth noting at this stage of adoption. The article on [understanding business risks](../policy-compliance/understanding-business-risk.md) can help capture relevant business risks.

## Tolerance Indictors

The current tolerance for risk is high and appetite for investing in cloud governance is low. As such, the tolerance indicators for the Future Proof policy act like a reminder. When/if the following indicators are observed, it would be wise to revisit the business's tolerance for risk.

* Inclusion of protected data in defined cloud adoption plans
* Deployment of more than 100 assets to the cloud
* Monthly spend exceeding $10,000/month

The above indicators are based on the synthesized use case. Adjust accordingly to align with actual tolerance indicators. See the article on [metrics and tolerance indicators](../policy-compliance/risk-tolerance.md) for additional guidance.

## Policy Statements

The following policy statements would establish requirements to mitigate the defined risks.

* Cost
* Security
* Identity
* Resource
* Configuration

## Monitoring and Enforcement

Add an initial process here...

## Design Guide

Many of the risks above can be mitigated through the adoption of basic standards and a few simple policy statements.
Mitigating these risks early in the process will future proof deployments, easing governance adoption down the road. The following steps should mitigate each of the identified risks:

1) Establish a standard for [Resource Grouping](../../infrastructure/resource-grouping/overview.md)
2) Establish a standard for [Resource Tagging](../../infrastructure/resource-tagging/overview.md)
3) Establish a standard for Deployment models
...
X) Implement a [Hybrid Identity Solution](../../infrastructure/identity/overview.md)


Build on scaffolding to define a set of basic standards, mapping business risk to each suggested policy statement & implementation