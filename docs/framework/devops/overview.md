---
title: Overview of the devops pillar 
description: Describes the devops pillar
author: david-stanford
ms.date: 11/01/2019
ms.topic: overview
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
---

# Overview of DevOps

In the Azure Architecture Framework we understand DevOps in a very broad sense. In order to ensure that your application is running effectively over time, you need to consider multiple perspectives, from both an application and infrastructure angles, including the processes that you implement to make sure that your users are getting the right experience. And most importantly, those perspectives are closely interrelated to each other. That is why in this framework we have grouped disciplines such as management, monitoring and CI/CD under the DevOps umbrella.

These are the disciplines we group in the DevOps pillar:

| DevOps Discipline | Description |
|-------------------|-------------|
| [Monitoring][monitoring] | Something that enterprises have been doing for years, enriched with some specifics for applications running in the cloud |
| [Application Performance Management][performance] | Although you could see this as part of Monitoring, we decided to consider as its own discipline due to its importance |
| [Code deployment][deployment] | How you deploy your application code is going to be one of the key factors that will determine your application stability  |
| [Infrastructure provisioning][iac] | Frequently known as "Automation" or "Infrastructure as code", this discipline refers to best practices for deploying the platform where your application will run on |
| [Testing][testing] | Ideally integrated in the application deployment process, testing is fundamental in order to be prepared for the unexpected, and catch mistakes before they impact actual users |
| [Processes][process] | In the triangle People-Processes-Tools, Azure provides you with enough tooling to succeed in the disciplines above, but you need to ensure that your organization uses those tools effectively |
| ... |  |

<!-- devops disciplines -->
[monitoring]: ./monitoring.md
[performance]: ./performance.md
[deployment]: ./deployment.md
[iac]: ./iac.md
[testing]: ./testing.md
[process]: ./process.md
