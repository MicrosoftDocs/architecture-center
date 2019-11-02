---
title: Development considerations when enabling DevOps
description: Describes considerations to make when enabling DevOps for your workload.
author: UmarMohamedUsman
ms.date: 10/22/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit 
---

# Development considerations when enabling DevOps

## Production like environment for Dev/Test

Its paramount to maintain production like environment especially when you run in to issues in production and you want to release hot fixes/updates quickly. If you follow some of the best practices mentioned in the app-design section like Infrastructure as Code (IaC) & CI/CD process you can easily & swiftly spin up/tear down your environment as needed.  

With the use of [Resource Manager templates](/azure/azure-resource-manager/template-deployment-overview) or [Terraform](/azure/virtual-machines/windows/infrastructure-automation#terraform) you can use [Azure DevOps Services](/azure/virtual-machines/windows/infrastructure-automation#azure-devops-services) to provision production like environment in minutes to mimic real-life, peak-usage scenarios. This allows you save cost and provision load testing environment only when needed.

## Application instrumentation for insight

Insights provide a customized monitoring experience for particular applications and services. [Application Insights](/azure/azure-monitor/app/app-insights-overview), a feature of [Azure Monitor](/azure/azure-monitor/overview), is an extensible Application Performance Management (APM) service for web developers on multiple platforms. Use it to monitor your live web application. It will automatically detect performance anomalies.

## Technical debt

Technical debt includes anything the team must do to deploy production quality code and keep it running in production. Examples are bugs, performance issues, operational issues, not having unit tests (necessary for refactoring code), accessibility, and others. [SonarQube](https://www.sonarqube.org/) is a set of static analyzers that can be used to identify areas of improvement in your code. It allows you to analyze the technical debt in your project and keep track of it in the future.
For more info, see [Using SonarQube with Azure DevOps](/azure/devops/java/sonarqube?view=azure-devops).

## Continuous deployment / continuous integration

Use feature toggles and canary releases. Utilize [App Service deployment](/azure/app-service/deploy-staging-slots) slots to safely deploy applications.

Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early. The key details to note are that you need to run code integration multiple times a day, every day, and you need to run the automated verification of the integration. What's the motivation for this? Well, in the development process, the earlier we surface errors, the better. And one source of frequently occurring errors is the code integration step.

Employ [Azure DevOps Services](/azure/virtual-machines/windows/infrastructure-automation#azure-devops-services) continuous integration to build, test, and deploy applications quickly.

## Feature flags

Using feature flags is a technique that will help you integrate code into a shared repository at least once a day and ship it, even if you haven't finished the feature yet. You'll be able to deploy at any time but defer the decision to release for another day.