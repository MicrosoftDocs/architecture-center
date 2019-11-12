---
title: Overview of the devops pillar 
description: Describes the devops pillar
author: david-stanford
ms.date: 10/21/2019
ms.topic: overview
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
---

# Overview of DevOps

In the Azure Architecture Framework, we understand DevOps in a broad sense. In order to ensure that your application is running effectively over time, you need to consider multiple perspectives, from both an application and infrastructure angles, including the processes that you implement to make sure that your users are getting the right experience. And most importantly, those perspectives are closely interrelated to each other. That is why in this framework we have grouped disciplines such as management, monitoring and CI/CD under the DevOps umbrella.

These are the disciplines we group in the DevOps pillar:

| DevOps Discipline | Description |
|-------------------|-------------|
| [Application design][app-design] | Provides guidance on how to design, build, and orchestrate workloads with DevOps principles in mind  |
| [Monitoring][monitoring] | Something that enterprises have been doing for years, enriched with some specifics for applications running in the cloud |
| [Application Performance Management][performance] | The monitoring and management of performance and availability of software applications through DevOps |
| [Code deployment][deployment] | How you deploy your application code is going to be one of the key factors that will determine your application stability  |
| [Infrastructure provisioning][iac] | Frequently known as "Automation" or "Infrastructure as code", this discipline refers to best practices for deploying the platform where your application will run on |
| [Testing][testing] | Testing is fundamental to be prepared for the unexpected and to catch mistakes before they impact users |


<!-- devops disciplines -->
[monitoring]: ./monitoring.md
[performance]: ./performance.md
[deployment]: ./deployment.md
[iac]: ./iac.md
[testing]: ./testing.md
[app-design]: ./app-design.md
