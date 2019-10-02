---
title: Development considerations when enabling DevOps
description: Describes considerations to make when enabling DevOps for your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Development considerations when enabling DevOps

## Production like environment for Dev/Test
Use VSTS load testing with cloud scale and mimic real- life, peak-usage scenario.

## Application instrumentation for insight
Use Azure Monitor, Azure Advisor, Azure Service Health, Activity Log, Azure Application Insights, Log Analytics, ExpressRoute monitor, Service Map, availability tests, and general monitoring Azure applications and resources.

## Technical debt
Track technical debt using SonarQube with Visual Studio Team Services (VSTS).

## Continous deployment / continous integration
Use feature toggles and canary releases. Utilize App Service deployment slots to safely deploy applications.

Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early. The key details to note are that you need to run code integration multiple times a day, every day, and you need to run the automated verification of the integration. What’s the motivation for this? Well, in the development process, the earlier we surface errors, the better. And one source of frequently occurring errors is the code integration step.

## Feature flags
Using feature flags is a technique that will help you integrate code into a shared repository at least once a day and ship it, even if you haven't finished the feature yet. You'll be able to deploy at any time but defer the decision to release for another day.