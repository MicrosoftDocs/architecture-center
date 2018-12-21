---
title: "Fusion: How can a company add Identity Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Identity management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/11/2018
---

# Fusion: How can a company add Identity Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Identity Management is defined as one of the Five Disciplines of Cloud Governance. This discipline focuses on ways of establishing policies that ensure consistency and continuity of user identities regardless of the cloud provider that hosts the application or workload. Within the Five Disciplines of Cloud Governance, Identity Management includes decisions regarding the [Hybrid Identity Strategy](../../infrastructure/identity/overview.md), evaluation and extension of identity repositories, implementation of single sign-on (same sign-on), auditing and monitoring for unauthorized use or malicious actors. In some cases, it may also involve decisions to modernize, consolidate, or integrate multiple identity providers.

This article outlines the Identiy Management process that a company experiences during the planning, building, adopting, and operating phases of implementing a cloud solution. It's impossible for any one document to account for all of the requirements of any business. As such, each section of this article outlines suggested minimum and potential activities. The objective of these activities is to help you build a [Policy MVP](../policy-compliance/overview.md), but establish a framework for [Incremental Policy](../policy-compliance/overview.md) evolution. The Cloud Governance Team should decide how much to invest in the potential activities to improve the Identity Management position.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance*

## Planning and readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Evaluate your [Identity tool chain](toolchain.md) options and implement a hybrid strategy that is appropriate to your organization.
* Develop a draft Architecture Guidelines document and distribute to key stakeholders.
* Educate and involve the people and teams impacted by the development of Architecture Guidelines.

**Potential activities**

* Define roles and assignments that will govern identity and access management in the cloud.
* Define your on-premises groups and map to corresponding cloud-based roles.
* Inventory identity providers (including database-driven identities used by custom applications).
* Consider options for consolidation or integration of identity providers where duplication exists, to simplify the overall identity solution.
* Evaluate hybrid compatibility of existing identity providers.
* For identity providers that are not hybrid compatible, evaluate consolidation or replacement options.

## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Consider a pilot test before implementing your [Identity tool chain](toolchain.md), making sure it simplifies the user experience as much as possible.
* Apply feedback from pilot tests into the pre-deployment. Repeat until results are acceptable.
* Update the Architecture Guidelines document to include deployment and user adoption plans, and distribute to key stakeholders.
* Consider establishing an early adopter program and rolling out to a limited number of users.
* Continue to educate the people and teams most impacted by the Architecture Guidelines.

**Potential activities**

* Evaluate your logical and physical architecture and determine a [Hybrid Identity Strategy](../../infrastructure/identity/overview.md).
* Map identity access management policies, such as login ID assignments, and choose the appropriate authentication method for Azure AD.
  * If federated, enable tenant restrictions for administrative accounts.
* Integrate your on-premises and cloud directories.
* Consider using the following access models:
  * [Least Privilege Access](https://docs.microsoft.com/windows-server/identity/ad-ds/plan/security-best-practices/implementing-least-privilege-administrative-models) model
  * [Privileged Identity Management](https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-configure) access model 
* Finalize all pre-integration details and review [Identity Best Practices](https://docs.microsoft.com/en-us/azure/security/azure-security-identity-management-best-practices).
  * Enable single identity, single sign-on (SSO), or seamless SSO
  * Configure multi-factor authentication (MFA) for admins
  * Consolidate or integrate identity providers, where necessary
  * Implement tooling necessary to centralize management of identities
  * Enable just-in-time (JIT) access and role change alerting
  * Conduct a risk analysis of key admin activities for assigning to built-in roles
  * Consider an updated rollout of stronger authentication for all users 
  * Enable Privileged Identity Management (PIM) for JIT (using time-limited activation) for additional administrative roles
  * Separate user accounts from Global admin accounts (to make sure that admins do not inadvertently open emails or run programs associated with their Global admin accounts)

## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Migrate your [Identity tool chain](toolchain.md) from development to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**

* Validate that the best practices defined during the Build / Pre-deployment phases are properly executed.
* Validate and/or refine your [Hybrid Identity Strategy](../../infrastructure/identity/overview.md).
* Ensure that each application/workload continues to align with the identity strategy prior to release.
* Validate that single sign-on (SSO) and seamless SSO is working within the application(s) as expected.
* Reduce or eliminate the number of alternative identity stores, when possible.
* Scrutinize the need for any in-app or in-database identity stores. Identities that fall outside of a proper identity provider (1st or 3rd party) can represent risk to the application and the users.
* Enable conditional access for [on-premises federated applications](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-device-registration-on-premises-setup).]
* Distribute identity across global regions in multiple hubs with synchronization between regions.
* Establish central role-based access control (RBAC) federation.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an  application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities**

* Customize your [Identity tool chain](toolchain.md) based on changes to your organization’s changing identity needs.
* Automate notifications and reports to alert you of potential malicious threats.
* Monitor and report on system usage and user adoption progress.
* Report on post-deployment metrics and distribute to stakeholders.
* Refine the Architecture Guidelines to guide future adoption processes.
* Communicate and continually re-educate the impacted people and teams on a periodic basis to ensure on-going adherence to Architecture Guidelines.

**Potential activities**

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
* Periodically produce an impact report that shows the changes in metrics created by the system and estimate the business impacts of the [Hybrid Identity Strategy](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/infrastructure/identity/overview).
* Establish integrated monitoring recommended by [The Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/security-center-intro).
