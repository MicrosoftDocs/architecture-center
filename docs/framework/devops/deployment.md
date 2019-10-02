---
title: Deployment considerations for DevOps
description: Describes deployment considerations to make to enable DevOps in your organization.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Deployment considerations for DevOps

## Automation
Utilize VSTS continuous testing. Use VSTS Test Case Management for documenting and fixing bugs after test execution. Practice VSTS Unit, Integration, and UAT testing for code coverage.

## Release process
Use VSTS release management for end-to-end traceability. Utilize VSTS history and auditing for a consolidated view of changes to code and infrastructure.

One of the challenges with automating deployment is the cut-over itself, taking software from the final stage of testing to live production. You usually need to do this quickly in order to minimize downtime. The blue-green deployment approach does this by ensuring you have two production environments, as identical as possible.

Use VSTS Release Management for continuous delivery of software at a faster pace and with lower risk.

## Stage your workloads
Use staging slots in Azure App Service.

Deployment to various stages and running tests/validations at each stage before moving on to the next ensures friction free production deployment.

## Manual activities
Use Azure Automation for complete control during deployment, operations, and decommissioning of workloads and resources.

## Deployment scripts
Utilize Azure Resource Manager templates and scripts for automated resource provisioning.

## Deployment strategies
Use the blue/green or canary release deployment technique.

## Logging and auditing
Use VSTS release management for end-to-end traceability. Utilize VSTS history and auditing for a consolidated view of changes to code and infrastructure.

## Rollback plan
Use App Service deployment slots to fall back on last-known good menu. Run VSTS conditional rollback.

The most important step is to implement an architecture that supports the need to rollback. For instance, componentized, service based architectures lend themselves well to this. Persistent message queues and asynchronous services allow you to bring components down for rollback without impacting the main user base. Work towards something like the Blue-Green release pattern such that your application can stay available whilst you are working on one half of the system.

## High availability considerations
Use an App Service plan that offers multiple instances. Use virtual machine scale set. Deploy multiple instances of the web app.

## Hotfixes

## Logging
Use VSTS extensions to create documentation from source code. Utilize VSTS history and auditing for a consolidated view of changes to code and infrastructure.

## Manage infrastructure after deployment
Use VSTS access management to grant or restrict access to resources and features you want to control. Use Azure Automation Change Tracking.