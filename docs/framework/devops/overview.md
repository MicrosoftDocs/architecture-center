---
title: Overview of the operational excellence pillar
description: Describes the operational excellence pillar.
author: david-stanford
ms.date: 10/21/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - fasttrack-edit
  - overview
---

# Overview of the operational excellence pillar

This pillar covers the operations processes that keep an application running in production. Deployments must be reliable and predictable. They should be automated to reduce the chance of human error. They should be a fast and routine process, so they don't slow down the release of new features or bug fixes. Equally important, you must be able to quickly roll back or roll forward if an update has problems.

To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

These are the disciplines we group in the operational excellence pillar:

| Operational excellence disciplines | Description |
|-------------------|-------------|
| [Application design][app-design] | Provides guidance on how to design, build, and orchestrate workloads with DevOps principles in mind  |
| [Monitoring][monitoring] | Something that enterprises have been doing for years, enriched with some specifics for applications running in the cloud |
| [Application performance management][performance] | The monitoring and management of performance and availability of software applications through DevOps |
| [Code deployment][deployment] | How you deploy your application code is going to be one of the key factors that will determine your application stability  |
| [Infrastructure provisioning][iac] | Frequently known as "Automation" or "Infrastructure as code", this discipline refers to best practices for deploying the platform where your application will run on |
| [Testing][testing] | Testing is fundamental to be prepared for the unexpected and to catch mistakes before they impact users |

<!-- devops disciplines -->
[monitoring]: ./monitoring.md
[performance]: ./release-engineering-performance.md
[deployment]: ./release-engineering-cd.md
[iac]: ./automation-infrastructure.md
[testing]: ./release-engineering-testing.md
[app-design]: ./app-design.md