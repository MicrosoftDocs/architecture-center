---
title: "Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?"
description: How can a company add Configuration Management discipline to their Cloud Governance execution?
author: alexbuckgit
ms.date: 01/17/2019
---

# Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Configuration Management is defined as one of the Five Disciplines of Cloud Governance. 

    This discipline focuses on ways of establishing policies that ensure consistency and continuity of user identities regardless of the cloud provider that hosts the application or workload. Within the Five Disciplines of Cloud Governance, Identity Management includes decisions regarding the [Hybrid Identity Strategy](../../infrastructure/identity/overview.md), evaluation and extension of identity repositories, implementation of single sign-on (same sign-on), auditing and monitoring for unauthorized use or malicious actors. In some cases, it may also involve decisions to modernize, consolidate, or integrate multiple identity providers.

This article outlines the Identity Management process that a company experiences during the planning, building, adopting, and operating phases of implementing a cloud solution. It's impossible for any one document to account for all of the requirements of any business. As such, each section of this article outlines suggested minimum and potential activities. The objective of these activities is to help you build a [Policy MVP](../policy-compliance/overview.md#policy-minimally-viable-product-mvp), but establish a framework for [Incremental Policy](../policy-compliance/overview.md#incremental-policy-growth) evolution. The Cloud Governance Team should decide how much to invest in the potential activities to improve the Identity Management position.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance.*

## Planning and readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities:**

- Evaluate your [Configuration Management tool chain](toolchain.md) options and implement a hybrid strategy that is appropriate to your organization.
- Develop a draft Architecture Guidelines document and distribute to key stakeholders.
- Educate and involve the people and teams impacted by the development of Architecture Guidelines.

**Potential activities:**

- Define roles and assignments that will govern configuration management in the cloud.
- a
- 

## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities:**

- Consider a pilot test before implementing your [Configuration management tool chain](toolchain.md), making sure it simplifies the user experience as much as possible.
- Apply feedback from pilot tests into the pre-deployment. Repeat until results are acceptable.
- Update the Architecture Guidelines document to include deployment and user adoption plans, and distribute to key stakeholders.
- Continue to educate the people and teams most impacted by the Architecture Guidelines.

**Potential activities:**

- 
- 
- 

## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities:**

* Migrate your [configuration management tool chain](toolchain.md) from development to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives, and other programs to help drive user adoption.

**Potential activities:**

* Validate that the best practices defined during the Build / Pre-deployment phases are properly executed.
* Validate and/or refine your [Hybrid Identity Strategy](../../infrastructure/identity/overview.md).
* Ensure that each application/workload continues to align with the identity strategy prior to release.
* Validate that single sign-on (SSO) and seamless SSO is working within the application(s) as expected.
* Reduce or eliminate the number of alternative identity stores, when possible.
* Scrutinize the need for any in-app or in-database identity stores. Identities that fall outside of a proper identity provider (1st or 3rd party) can represent risk to the application and the users.
* Enable conditional access for [on-premises federated applications](/azure/active-directory/active-directory-device-registration-on-premises-setup).
* Distribute identity across global regions in multiple hubs with synchronization between regions.
* Establish central role-based access control (RBAC) federation.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an  application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities:**

* Customize your [Identity tool chain](toolchain.md) based on changes to your organization’s changing identity needs.
* Automate notifications and reports to alert you of potential malicious threats.
* Monitor and report on system usage and user adoption progress.
* Report on post-deployment metrics and distribute to stakeholders.
* Refine the Architecture Guidelines to guide future adoption processes.
* Communicate and continually re-educate the impacted people and teams on a periodic basis to ensure ongoing adherence to Architecture Guidelines.

**Potential activities:**

* Conduct periodic audits of identity policies and adherence practices.
* Scan for malicious actors and data breaches regularly, particularly those related to identity fraud, such as potential admin account takeovers.
* Configure a monitoring and reporting tool.
* Consider integrating more closely with security and fraud-prevention systems.
* Regularly review access rights for elevated users or roles.
  * Identify every user who is eligible to activate admin privilege.
* Review on-boarding, off-boarding, and credential update processes.
* Investigate increasing levels of automation and communication between identity access management (IAM) modules.
* Consider implementing a development security operations (DevSecOps) approach.
* Carry out an impact analysis to gauge results on costs, security, and user adoption.
* Periodically produce an impact report that shows the changes in metrics created by the system and estimate the business impacts of the [Hybrid Identity Strategy](../../infrastructure/identity/overview.md).
* Establish integrated monitoring recommended by [The Azure Security Center](/azure/security-center/security-center-intro).
