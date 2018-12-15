---
title: "Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Configuration management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/11/2018
---

# Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Configuration Management is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing policies to govern asset configuration or deployment. Within the five disciplines of Cloud Governance, configuration governance includes deployment, configuration alignment, and HA/DR strategies. This could be through manual activities or fully automated DevOps activities. In either case, the policies would remain largely the same.

This article outlines the Configuration Management process that a company experiences during the planning, building, adopting, and operating phases of implementing a cloud solution. It's impossible for any one document to account for all of the requirements of any business. As such, each section of this article outlines suggested minimum and potential activities. The objective of these activities is to help you build a [Policy MVP](../policy-compliance/overview.md), but establish a framework for [Incremental Policy](../policy-compliance/overview.md) evolution. The Cloud Governance Team should decide how much to invest in these activities to improve the  Configuration Management position.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance*

## Planning and readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Evaluate your [Configuration Management Tool Chain](toolchain.md) options.
* Develop a draft Architecture Guidelines document and distribute to key stakeholders.
* Educate and involve the people and teams impacted by the development of Architecture Guidelines.

**Potential activities**

* Establish deployment configuration and automation processes.
* Establish configuration alignment processes.
* Establish formal SLA classifications and recovery requirements.
* Align SLA costs and SLA classifications with the [Business Justification](../../business-strategy/cloud-migration-business-case.md).

## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Implement your [Configuration Management Tool Chain](toolchain.md) out in a pre-deployment phase.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**

* Implement a:
  * Deployment, DevOps or DevSecOps strategy
  * Configuration Alignment strategy
  * HA/DR strategy

## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Migrate your [Configuration Management Tool Chain](toolchain.md) from pre-deployment to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**

* Validate: 
  * Proper use of deployment approaches
  * OS and App Hardening has been completed
  * Configuration alignment approaches
  * Adherence to HA/DR strategy and SLA classification
* Test deployment, configuration, and recovery policies in staging to validate adherence.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an  application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities**

* Customize your [Configuration Management Tool Chain](toolchain.md).
* Automate notifications and reports to alert you of potential configuration issues.
* Refine Architecture Guidelines to guide future adoption processes.
* Communicate and continually re-educate the impacted people and teams on a periodic basis to ensure on-going adherence to Architecture Guidelines.

**Potential activities**

* Review OS and Application vulnerabilities.
* Test recovery plans (intrusive and non-instrusive).
* Implement configuration drift monitoring.
* Maintain and execute patch cycles.
* Prepare quarterly report including SLA costs versus business impact, along with results from recovery plan testing.

# Next steps
When planning your deployment, you will need to consider where logging data is stored and how you integrate cloud-based [reporting and monitoring services](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/infrastructure/logs-and-reporting/overview?branch=brian%2FCOMIntegration) with your existing processes and tools.
