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

### Relevant Business Characteristics

* All sales and operations reside in a single country with a small percentage of global customers
* The business operates as a single business unit, with budget aligned to functions (Sales, Marketing, Operations, IT, etc...)
* The business views most of IT as a capital drain or a cost center.

### Cloud Adoption: Current State

* IT operates two hosted infrastructure environments (Production and Disaster Recovery) across two different providers. IT refers to these environment as their two datacenters.
* IT entered the cloud by migrating all end user email to Office 365, which has been complete for over 6 months.
* A few IT assets have been deployed to the cloud.
* The application development teams is working in a dev/test capacity to learn about cloud native capabilities.
* The BI team is experimenting with big data in the cloud.
* The company has a loosely defined policy stating that customer's PII (Personally Identifiable Information) and financial data can not be hosted in the cloud, which limits mission critical applications in the current deployments.

### Current State: Future State

* This year, the IT team will complete a project to retire the Disaster Recovery "Data Center", increasing cloud adoption.
* Both App Dev and BI will likely release production solutions to the cloud in the next 24 months.
* The CIO is reviewing the policy on PII and financial data to allow for the future state goals.

### Objective

For the future state to be realized, protected data will go to the cloud someday. For that to happen, the cloud will need a robust governance strategy.
The business is not willing to invest in Cloud Governance today. However, Cloud Governance is likely to be a wise investment in the near future.
The objective of this design guide is to establish a common foundation for all deployments. That foundation will need to scale as new policies and governance disciplines are added.

## Corporate Policy

Based on the [Future Proof Use Case](#use-case:-future-proof), the following is a sample of a corporate policy synthesized from similar customer experiences. This corporate policy can serve as a foundation for personalizing and defining a more targeted governance policies. The landing page on the [five disciplines of cloud governance](../governance-disciplines.md) can aid in customizing this policy.

> [!CAUTION]
> The following corporate policy section contains extremely specific guidance based on the Use Case established for this synthesized customer scenario. Each section contains one or more links to personalize the corporate policy to align to a specific use case.

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

The following policy statements would establish requirements to mitigate the defined risks. To understand options and better align the 5 disciplines of cloud governance, click on any of the policy statement headers to learn more about the specific governance discipline.

* [Configuration Management](../configuration-management/overview.md): Multiple
    * All assets must be grouped and tagged, in alignment with the Grouping and Tagging strategies defined in the design guide.
    * All assets must use an approved deployment model defined in the design guide.
* [Identity Management](../identity-management/overview.md): All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
* [Security Management](../security-management/overview.md): All assets deployed to the cloud should be tagged with the appropriate data classification. Later when protected forms of data will be included, this classification will help refine governance, security, and operations investments.
* [Cost Management](../cost-management/overview.md): For tracking purposes, all assets must be assigned to a billing unit.
* [Resource Management](../resource-management/overview.md): Since no mission critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed

## Monitoring and Enforcement

A budget has not been allocated to the on-going monitoring and enforcement of these governance policies. Initial education and limited involvement in deployment planning are the two primary opportunities to monitor adherence to policy statements.

The cloud governance team currently consists of two systems admins, who have foreseen the need for governance in the future.

**Initial Eduction:** The "cloud governance team" is investing time to educate the cloud adoption teams on the design guides that support these policies.

**Deployment Planning:** Prior to deployment of any asset, the "cloud governance team" will review the design guide with the cloud adoption teams to discuss alignment.

## Design Guide

Many of the risks above can be mitigated through the adoption of basic standards and a few simple policy statements.
Mitigating these risks early in the process will future proof deployments, easing governance adoption down the road.
> [!CAUTION]
> The following design guide contains extremely specific guidance based on the Use Case and Corporate Policies established for this synthesized customer scenario. Each section contains one or more links to personalize the Design Guidance to align to a specific use case.

1) [Subscription Model](../../infrastructure/subscriptions/overview): The Archetype pattern has been chosen for Azure subscriptions. This means that a subscription should be established for each type of application being deployed to the cloud.
2) [Resource Grouping](../../infrastructure/resource-grouping/overview.md): Deployment based grouping has been chosen for cloud deployments. This means that assets being deployed should be a member of a resource group. As part of the deployment process, an Azure Resource Management (ARM) template(s) for the resource group should be stored in source control. Since an Archetype pattern has been chosen for the subscription model, the resource groups should align to a workload or application.
3) [Resource Tagging](../../infrastructure/resource-tagging/overview.md): An Accounting pattern to Tagging has been chosen for all cloud deployments. This means that every asset being deployed to the cloud should be tagged with value for the following: Department/Billing Unit, Data Classification, Criticality, SLA, and Environment. These five values along with the resource group and subscription associated with a deployed asset will drive governance, operations, and security decisions.
4) [Identity Solution](../../infrastructure/identity/overview.md): The team has chosen a Federation pattern for hybrid identity. As such, all RBAC and local authentication will be provided by Azure AD, leveraging the federation or "Same Sign-On" that was implemented during the Office 365 implementation. Later in the app dev cycles, it is assumed that this pattern may evolve into a B2B-B2C pattern to move B2C users into an Azure AD tenant.
5) [Software Defined Network](../../infrastructure/software-defined-networks/overview.md): At this point, a Cloud Native pattern to networking is suggested but not required. No governance requirements have been set beyond the general pattern suggestion. Decisions regarding subnet, firewall, and routing is currently being deferred to each application/workload lead. Additional analysis will be required prior to the release of any protected data.
6) [Encryption](../../infrastructure/encryption/overview.md): At this point, a Cloud Native pattern to encryption is suggested but not required. No governance requirements have been set regarding the use of encryption, because mission critical and protected data are not permitted based on the use case. Additional analysis will be required prior to the release of any protected data.
7) [Log & Reporting](../../infrastructure/logs-and-reporting/overview.md): At this point, a Cloud Native pattern to log and reporting is suggested but not required. No governance requirements have been set regarding the data to be collected. Additional analysis will be required prior to the release of any protected data or mission critical workloads.
8) [Enforcement Automation](../monitoring-enforcement/overview.md): At this point, there is no policy enforcement automation being implemented. Upon release of protected data and mission critical workloads, it is assumed that an On-going Enforcement pattern will be required. At that stage, Azure Policy, Azure Management Groups, and Azure BluePrints will be used to enforce policy adherence. Cloud Adoption Teams are encourage to begin investigating these technologies in dev/test cycles.

The 8 best practices above will reduce risk and promote readiness for the future integration of a robust governance strategy.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case]() and [Corporate Policy]() that influenced this guidance.
More than likely, this guide will require customization. To aid in customizing this guide and making relevant decisions, the following links may be of value:

**[Defining Corporate Policy](../policy-compliance/overview.md)**: Fusion Model to defining risk driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

> [!div class="nextstepaction"]
> [Adjusting the 5 disciplines of cloud governance](../governance-disciplines.md)
