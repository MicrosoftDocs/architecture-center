---
title: "Fusion: What is monitoring & enforcement in relation to cloud governance"
description: Explanation of the concept monitoring & enforcement in relation to cloud governance
author: BrianBlanchard
ms.date: 12/21/2018
---

# Fusion: What is monitoring and enforcement in relation to cloud governance?

The five disciplines of Cloud Governance that are introduced in the [intro to cloud governance](../overview.md) provide the building blocks needed to develop corporate cloud governance standards, giving you a baseline [policy MVP](../policy-compliance/overview.md#policy-minimally-viable-product-mvp) to use when migrating to the cloud. Critical to all of these disciplines, and the wider process of [incremental policy](../policy-compliance/overview.md#incremental-policy-growth) evolution, is the ability to detect policy non-compliance and use historical information about past resource activity to guide policy revision.

Establishing monitoring and reporting standards, and implementing automated systems and processes to support these standards, provides visibility into the behavior and operations or your cloud-based resources. During operations, the reports and alerts generated from monitoring systems are critical for IT staff to detect and resolve performance issues, security vulnerabilities, or otherwise enforce policy standards. Monitoring systems are also critical in triggering automation remediation systems 

Setting future policy goals depends on understanding the current and past state of your cloud estate. As part of the ongoing nature of cloud governance, monitoring data serves an equally important role in informing decisions made for each of the five core governance disciplines.

This article outlines how an organization integrates monitoring concerns into the planning, building, adoption, and operational phases of implementing a cloud solution. Monitoring requirements vary between organizations, so each section of this discussion will list a suggested minimum activities for implementing monitoring, as well as potential additional actions that will support more mature monitoring capabilities. Your Cloud Governance Team should decide how much investment you need in these activities to support your overall governance requirements.

For a discussion on implementing monitoring systems on cloud platforms, see the [logging, reporting, and monitoring](../../infrastructure/logs-and-reporting/overview.md) topic in the Fusion infrastructure guidance section.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance*

## Planning and readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Evaluate your [Monitoring and Enforcement Tool Chain](toolchain.md) options.
* Develop a draft monitoring architecture guidelines document and distribute to key stakeholders.
* Educate and involve the people and teams responsible for policy enforcement and IT operations that will interact with monitoring systems.
* Add prioritized monitoring system deployment and configuration tasks to your [migration backlog](../../migration/plan/migration-backlog.md).

**Potential activities**

* Use previous monitoring data to provide learnings to the Cloud Governance Team as part of the overall planning phase.
* Gather monitoring requirements based on policies defined for [configuration](../configuration-management/overview.md), [cost](../cost-management/overview.md), [identity](../identity-management/overview.md), [resource](../resource-management/overview.md), and [security](../security-management/overview.md) management.
* Determine SLA requirements for alerts and remediation tasks.

## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Implement your [Monitoring and Enforcement Tool Chain](toolchain.md) by rolling out in a pre-deployment phase.
* Update the architecture guidelines document and distribute to key stakeholders.
* Implement monitoring deployment tasks on your prioritized migration backlog.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help relevant IT teams understand changes to existing monitoring systems and processes.

**Potential activities**

* Evaluate how your cloud-based monitoring systems will integrate with your existing on-premises or other external [monitoring and reporting](../../infrastructure/logs-and-reporting/overview.md) solution, and determine if logging data should be replicated to an on-premises, cloud gateway, or hybrid solution. Implement any APIs or other import/export mechanisms used to support this decision.
* Identify teams and individuals that need to be included in alerts and reporting.
* Implement security and access control monitoring.
* Implement VM and service health monitoring.
* Implement network traffic monitoring.
* Implement application and workload monitoring.
* Implement deployment and resource change monitoring.
* Create regular usage and accounting reports.
* Implement automation to remediate issues based on alerts triggered by monitoring systems.

## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Migrate your [Monitoring and Enforcement Tool Chain](toolchain.md) from pre-deployment to production.
* Update the monitoring architecture guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help support user adoption.
* Migrate any existing automated remediation scripts or tools to support defined SLA requirements.

**Potential activities**

* Complete and test integration of cloud monitoring and reporting data with your chosen on-premises, cloud gateway, or hybrid solution. 
* Validate deployed resources and services are properly logging data.
* Test automation integration with monitoring systems.
* Ensure IT staff are able to receive alerts and respond within defined SLA requirements. 
* Validate cost and usage reports are accurate.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities**

* Customize your [Monitoring and Enforcement Tool Chain](toolchain.md) based on updates to your organization’s changing cost management needs.
* Consider adding or updating automation for common alerts and reports based on updated monitoring information.
* Refine monitoring architecture guidelines to guide future adoption processes.
* Re-educate impacted teams on a periodic basis to ensure on-going adherence to the architecture guidelines.

**Potential activities**

* Keep the cloud governance team, cloud strategy team, and other important stakeholders informed by regularly compiling overall policy compliance reports based on monitoring data.
* Use monitoring data to generate policy recommendations for the next iteration of the incremental policy review cycle.

