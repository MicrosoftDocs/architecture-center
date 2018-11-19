---
title: "Fusion: How can a company add Identity Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Identity management in relation to cloud governance
author: BrianBlanchard
ms.date: 10/10/2018
---

# Fusion: How can a company add Identity Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Identity Management is one of the Five Disciplines to Cloud Governance. This discipline focuses on ways of establishing policies that ensure consistency and continuity of user identities regardless of the cloud provider that hosts the application or workload. Within the Five Disciplines of Cloud Governance, Identity Management includes decisions regarding the [Hybrid Identity Strategy](../../infrastructure/identity/overview.md), evaluation and extension of identity repositories, implementation of single sign-on (same sign-on), auditing and monitoring for unauthorized use or malicious actors. In some cases, it may also involve decisions to modernize, consolidate, or integrate multiple identity providers.

This article outlines different phases of Identity Management evolution, as a company goes through increments of Planning, Building, Adopting, and Operating a cloud solution. It is impossible for any document collection to account for the various requirements of any business. As such, each section outlines a minimum suggested activity and a number of potential activities. The objective of each set of activities is to help build a [Policy MVP](../policy-compliance/overview.md), but establish a framework for [Incremental Policy](../policy-compliance/overview.md) evolution. The Cloud Governance Team should decide how much to invest in the potential activities to improve the Identity Management position.

> [!CAUTION]
> Neither the minimum suggested activities, nor the potential activities, outlined in this article are aligned to individual corporate policies or 3rd party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.
![Evolution of the Identity Management Discipline across various phases of adoption](../../_images/governance-discipline-identity-management.png)

*Figure 1. Evolution of Identity Management discipline across various phases of adoption

## Planning & Readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum Suggested Activities**

* Evaluate [Tool Chain](toolchain.md) options
* Develop and surface a draft of Architecture Guidelines
* Educate and involve the teams impacted in the development of Architecture Guidelines

**Potential Activities**

* Define roles and assignments that will govern access in the cloud
* Map on-prem groups to cloud based roles
* Inventory identity providers (including an database driven identities used by custom applications)
* Where duplication exists consider options for consolidation or integration of identity providers to simplify the overall identity solution
* Evaluate hybrid compatibility of existing identity providers
* For identity providers that are not hybrid compatible, evaluate consolidation or replacement options

## Build / Pre-Deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum Suggested Activities**

* Implement [Tool Chain](toolchain.md)
* Update Architecture Guidelines
* Educate teams impacted in the Architecture Guidelines

**Potential Activities**

* Decide on a [Hybrid Identity Strategy](../../infrastructure/identity/overview.md)
* Consider a [Least Privilege Access](https://docs.microsoft.com/windows-server/identity/ad-ds/plan/security-best-practices/implementing-least-privilege-administrative-models) model
* Evaluate other [Identity Best Practices](https://docs.microsoft.com/en-us/azure/security/azure-security-identity-management-best-practices)

    * Enable single identity, single sign-on, or same sign-on
    * Consolidate or integrate identity providers, where necessary
    * Implement tooling necessary to centralize management of identities
    * Enable just in time access and role change alerting

## Adopt / Migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum Suggested Activities**

* Adjust [Tool Chain](toolchain.md)
* Adjust Architecture Guidelines
* Educate teams impacted in the Architecture Guidelines

**Potential Activities**

* Validate that best practices defined during the Build / Pre-deployment phases are properly executed
* Validate &/or refine the hybrid identity strategy
* Ensure each application/workload aligns with the identity strategy prior to release
* Validate that single sign-on works within the application(s) as expected
* Reduce or eliminate the number of alternative identity stores, when possible
* Scrutinize the need for any in-app or in-db identity stores. Identities that fall outside of a proper identity provider (1st or 3rd party) can represent risk to the application and the users

## Operate / Post-Implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an  application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum Suggested Activities**

* Customize [Tool Chain](toolchain.md)
* Automate [Tool Chain](toolchain.md)
* Refine Architecture Guidelines to guide future adoption processes
* Re-Educate impacted teams on a periodic basis to ensure on-going adherence to Architecture Guidelines

**Potential Activities**

* Periodic audits of identity policies and adherence
* Scan for malicious actors regularly
* Regularly review access rights for elevated users or roles
* Review on-boarding, off-boarding, and credential update processes