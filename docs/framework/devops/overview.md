---
title: Overview of the operational excellence pillar
description: Understand the operational excellence pillar, which covers the operations processes that keep an application running in production.
author: david-stanford
ms.date: 10/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - fasttrack-edit
  - overview
products:
  - azure
categories:
  - management-and-governance
---

# Overview of the operational excellence pillar

The operational excellence pillar covers the operations processes that keep an application running in production. Deployments must be reliable and predictable. Automated deployments reduce the chance of human error. Fast and routine deployment processes won't slow down the release of new features or bug fixes. Equally important, you must be able to quickly roll back or roll forward if an update has problems.

To assess your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

We recommend the following video to help you achieve operational excellence with the Azure Well-Architected Framework:

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://docs.microsoft.com/en-us/shows/Azure-Enablement/Achieve-Operational-Excellence-With-Azure-Well-Architected-Framework/player]

<!-- markdownlint-enable MD034 -->

## Topics

The Microsoft Azure Well-Architected Framework includes the following topics in the operational excellence pillar:

| Operational excellence topics | Description |
|-------------------|-------------|
| [Application design][app-design] | Provides guidance on how to design, build, and orchestrate workloads with DevOps principles in mind.  |
| [Monitoring][monitoring] | Something that enterprises have been doing for years, enriched with specifics for applications running in the cloud. |
| [Application performance management][performance] | The monitoring and management of performance, and availability of software applications through DevOps. |
| [Code deployment][deployment] | How you deploy your application code is one of the key factors that determines your application stability.  |
| [Infrastructure provisioning][iac] | Frequently known as *Automation* or *Infrastructure as code*, this discipline refers to best practices for deploying the platform where your application will run. |
| [Testing][testing] | Testing is fundamental to prepare for the unexpected and to catch mistakes before they impact users. |

Monitoring and diagnostics are crucial. Cloud applications run in a remote data-center where you don't have full control of the infrastructure or, in some cases, the operating system. In a large application, it's not practical to log into virtual machines (VMs) to troubleshoot an issue or sift through log files. With PaaS services, there may not be a dedicated VM to log into. Monitoring and diagnostics give insight into the system, so that you know when and where failures occur. All systems must be observable. Use a common and consistent logging schema that lets you correlate events across systems.

The monitoring and diagnostics process has several distinct phases:

- *Instrumentation*: Generating the raw data from:
  - application logs
  - web server logs
  - diagnostics built into the Azure platform, and other sources.
- *Collection and storage*: Consolidating the data into one place.
- *Analysis and diagnosis*: To troubleshoot issues and see the overall health.
- *Visualization and alerts*: Using telemetry data to spot trends or alert the operations team.

Enforcing resource-level rules through [Azure Policy](/azure/governance/policy/overview) helps ensure adoption of operational excellence best practices for all the assets, which support your workload. For example, Azure Policy can help ensure all the VMs supporting your workload adhere to a pre-approved list of VM SKUs. Azure Advisor provides [a set of Azure Policy recommendations](/azure/advisor/advisor-operational-excellence-recommendations#use-azure-policy-recommendations) to help you quickly identify opportunities to implement Azure Policy best practices for your workload.

Use the [DevOps checklist][devops-checklist] to review your design from a management and DevOps standpoint.

## Next steps

Reference the operational excellence principles to guide you in your overall strategy.

> [!div class="nextstepaction"]
> [Principles](principles.md)

<!-- devops disciplines -->
[monitoring]: ./monitoring.md
[performance]: ./release-engineering-performance.md
[deployment]: ./release-engineering-cd.md
[iac]: ./automation-infrastructure.md
[testing]: ./release-engineering-testing.md
[app-design]: /azure/architecture/framework/devops/release-engineering-app-dev

<!-- checklist -->
[devops-checklist]: /azure/architecture/checklist/dev-ops
