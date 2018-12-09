---
title: "Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Configuration management in relation to cloud governance
author: BrianBlanchard
ms.date: 10/10/2018
---

# Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Configuration Management is one of the Five Disciplines to Cloud Governance. This discipline focuses on ways of establishing policies to govern asset configuration or deployment. Within the Five Disciplines of Cloud Governance, configuration governance includes deployment, configuration alignment, and HA/DR strategies. This could be through manual activities or fully automated DevOps activities. In either case, the policies would remain largely the same.

This article outlines different phases of Configuration Management evolution, as a company goes through increments of Planning, Building, Adopting, and Operating a cloud solution. It is impossible for any document collection to account for the various requirements of any business. As such, each section outlines a minimum suggested activity and a number of potential activities. The objective of each set of activities is to help build a [Policy MVP](../policy-compliance/overview.md), but establish a framework for [Incremental Policy](../policy-compliance/overview.md) evolution. The Cloud Governance Team should decide how much to invest in the potential activities to improve the Configuration Management position.

> [!CAUTION]
> Neither the minimum suggested activities, nor the potential activities, outlined in this article are aligned to individual corporate policies or 3rd party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoptionphases.png)

*Figure 1. Adoption phases of the Cloud Governance Model

## Planning & Readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum Suggested Activities**

* Evaluate your [Configuration Management Tool Chain](toolchain.md) options.
* Develop a draft Architecture Guidelines document and distribute to key stakeholders.
* Educate and involve the people and teams impacted by the development of Architecture Guidelines.

**Potential Activities**

* Establish deployment configuration and automation processes.
* Establish configuration alignment processes.
* Establish formal SLA classifications and recovery requirements.
* Align SLA costs and SLA classifications with the [Business Justification](../../business-strategy/cloud-migration-business-case.md).

## Build / Pre-Deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum Suggested Activities**

* Implement your [Configuration Management Tool Chain](toolchain.md) out in a pre-deployment phase.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential Activities**

* Implement a:
  * Deployment, DevOps or DevSecOps strategy.
  * Configuration Alignment strategy.
  * HA/DR strategy.

## Adopt / Migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum Suggested Activities**

* Migrate your [Configuration Management Tool Chain](toolchain.md) from pre-deployment to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential Activities**

* Validate: 
  * Proper use of deployment approaches.
  * OS and App Hardening has been completed.
  * Configuration alignment approaches.
  * Adherence to HA/DR strategy and SLA classification.
* Test deployment, configuration, and recovery policies in staging to validate adherence.

## Operate / Post-Implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an  application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum Suggested Activities**

* Customize your [Configuration Management Tool Chain](toolchain.md).
* Automate notifications and reports to alert you of potential configuration issues.
* Refine Architecture Guidelines to guide future adoption processes.
* Communicate and continually re-educate the impacted people and teams on a periodic basis to ensure on-going adherence to Architecture Guidelines.

**Potential Activities**

* Review OS and Application vulnerabilities.
* Test recovery plans (intrusive and non-instrusive).
* Implement configuration drift monitoring.
* Maintain and execute patch cycles.
* Prepare quarterly report including SLA costs versus business impact, along with results from recovery plan testing.

# Next steps
When planning your deployment, you will need to consider where logging data is stored and how you integrate cloud-based [reporting and monitoring services](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/infrastructure/logs-and-reporting/overview?branch=brian%2FCOMIntegration) with your existing processes and tools.
