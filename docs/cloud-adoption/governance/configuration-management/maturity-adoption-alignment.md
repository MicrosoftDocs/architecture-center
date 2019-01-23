---
title: "Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?"
description: How can a company add Configuration Management discipline to their Cloud Governance execution?
author: alexbuckgit
ms.date: 01/17/2019
---

# Fusion: How can a company add Configuration Management discipline to their Cloud Governance execution?

The Configuration Management discipline focuses on establishing policies that ensure that resources are deployed and configured consistently and repeatably, and remain in compliance throughout their lifecycle. Within the Five Disciplines of Cloud Governance, configuration management includes decisions regarding automating deployments, source-controlling deployment artifacts, monitoring deployed resources to maintain desired state, and auditing any compliance issues.

This article outlines some potential tasks your company can engage in to better develop and mature the configuration management discipline. These tasks can be broken down into planning, building, adopting, and operating phases of implementing a cloud solution, which are then iterated on allowing the development of an [incremental governance model](../design-guides/overview.md#incremental-governance-model-mvp-and-continuous-improvement).

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance.*

It's impossible for any one document to account for the requirements of all businesses. As such, this article outlines suggested minimum and potential example activities for each phase of the governance maturation process. The initial objective of these activities is to help you build a [Policy MVP](../design-guides/overview.md#incremental-governance-model-mvp-and-continuous-improvement) and establish a framework for incremental policy evolution. Your cloud governance team will need to decide how much to invest in these activities to improve your identity management governance capabilities.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

## Planning and readiness

This phase of governance maturity bridges the divide between business outcomes and actionable strategies. During this process, the leadership team defines specific metrics, maps those metrics to the digital estate, and begins planning the overall migration effort.

**Minimum suggested activities:**

- Evaluate your [Configuration Management tool chain](toolchain.md) options and implement a hybrid strategy that is appropriate to your organization.
- Develop a draft Architecture Guidelines document and distribute to key stakeholders.
- Educate and involve the people and teams impacted by the development of Architecture Guidelines.
- Train development teams and IT staff to understand DevSecOps principles and strategies and the importance of fully automated deployments in the Configuration Management Discpline.

**Potential activities:**

- Define roles and assignments that will govern configuration management in the cloud.

## Build and pre-deployment

**Minimum suggested activities:**

- For new cloud-based applications, introduce fully automated deployments early in the development process. This investment will improve the reliability of your testing processes and ensure consistency across your development, QA, and production environments.
- Store all deployment artifacts such as deployment templates or configuration scripts using a source-control platform such as GitHub or Azure DevOps.
- Consider a pilot test before implementing your [Configuration management tool chain](toolchain.md), making sure it streamlines your deployments as much as possible. Apply feedback from pilot tests during the pre-deployment phase, repeating as needed.
- Evaluate the logical and physial architecture of your applications, and identify opportunities to automate the deployment of application resources or improve portions of the architecture using other cloud-based resources.
- Update the Architecture Guidelines document to include deployment and user adoption plans, and distribute to key stakeholders.
- Continue to educate the people and teams most impacted by the Architecture Guidelines.

**Potential activities:**

- Define a continuous integration and continuous deployment (CI/CD) pipeline to fully manage releasing updates to your application through your development, QA, and production environments.

## Adopt and migrate

Migration is an incremental process that focuses on the movement, testing, and adoption of applications or workloads in an existing digital estate.

**Minimum suggested activities:**

- Migrate your [Configuration Management tool chain](toolchain.md) from development to production.
- Update the Architecture Guidelines document and distribute to key stakeholders.
- Develop educational materials and documentation, awareness communications, incentives, and other programs to help drive developer and IT adoption.

**Potential activities:**

- Validate that the best practices defined during the build and pre-deployment phases are properly executed.
- Ensure that each application or workload aligns with the configuration management strategy prior to release.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities:**

- Customize your [Configuration Management tool chain](toolchain.md) based on changes to your organization’s changing identity needs.
- Automate notifications and reports to alert you of potential configuration issues or malicious threats.
- Monitor and report on application and resource usage.
- Report on post-deployment metrics and distribute to stakeholders.
- Revise the Architecture Guidelines to guide future adoption processes.
- Continue to communicate with and train the affected people and teams on a regular basis to ensure ongoing adherence to Architecture Guidelines.

**Potential activities:**

- Configure a desired state configuration monitoring and reporting tool.
- Regularly review configuration tools and scripts to improve processes and identify common issues.
- Work with development, operations, and security teams to help mature DevSecOps practices and break down organizational silos that lead to inefficiencies.

## Next steps

Now that you understand the concept of cloud identity governance, examine the [identity management tool chain](toolchain.md) to identify Azure tools and features that you'll need when developing the identity management governance discipline on the Azure platform.

> [!div class="nextstepaction"]
> [Azure specific identity management tool chain](toolchain.md)
