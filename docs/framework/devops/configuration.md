---
title: Configuration for DevOps
titleSuffix: Optimizing Cloud Costs
description: Describes how to best take advantage of the benefits of the cloud to minimize your cost.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Configuration for DevOps

## Automation of manual tasks
Use automation runbooks with hybrid runbook worker to unify management by orchestrating across on- premises environments. Use webhooks to provide a way to fulfill requests and ensure continuous delivery and operations by triggering automation from ITSM, DevOps, and monitoring systems.

## Monitor and update machine configuration
Use Azure Automation State Configuration to provide configuration management required for enterprise environments.

## Schedule deployments
Employ Update Management to manage VM updates in Azure, on- premises, or in other cloud providers.

## Monitor resource configuration
Use Azure Advisor to follow best practices to optimize Azure deployments and analyze your resource configuration and usage telemetry.

## How do you deploy, manage, and monitor a solution as a group rather than handling its components individually?
Use Azure Resource Manager to define the dependencies between resources so they're deployed in the correct order.

## Repeated deployment of resources
Utilize Azure Resource Manager deployment modes to provision all resources specified in the template.

## Configuration management
Employ VSTS configuration management for visibility to dev and operations teams. Use PowerShell DSC for configuration management.

## Bug tracking
Utilize VSTS bug tracking tool for establishing links between code and bugs. Use Bugzilla integration with VSTS.

## Audit and track changes
Employ VSTS history and auditing for a consolidated view of changes to code and infrastructure.