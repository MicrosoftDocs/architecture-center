---
title: Repeatable Infrastructure
description: Repeatable Infrastructure 
author: neilpeterson
ms.date: 09/02/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Repeatable Infrastructure

## Tailwind case study

As part of the Tailwindtrader's efforts to reduce unnecessary toil, the Tailwind operations team has identified significant effort spent building or re-setting the tailwindtraders.com test environments before each release. Much of this effort is spent performing the following manual tasks:

- Evaluating the tailwind production environment for current operating systems, data systems, os and patch levels, and other configuration items.
- Procuring and configuring virtual machines to match production as close as possible.
- Deploying the current version of taiwindtraders.com application.
- Testing, documentation, etc..

While the Tailwind team does use scripting technology as much as possible during these activities, the level of provided automation is relatively isolated to a single activity like basic operating system configurations, which does not result in a significant reduction of toil. Furthermore, the risk is high that a miss-configuration has been introduced, resulting in miss-matched test and production environments.

## Deploying repeatable infrastructure

## Declarative Tools

### Azure Resource Manager Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON) and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the ARM engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- Parallele resource deployment
- Modular deployments
- Day one resource support
- Extensibility
- Testing, validation, and change preview
- Deployment scopes
- Tooling

For more information about Azure Resource Manager Templates, see [What are ARM templates](https://docs.microsoft.com/azure/azure-resource-manager/templates/overview).

### Terraform

## Imperative Tools

### The Azure Command Line Interface

### The Azure PowerShell Module

### Azure Cloud Shell

#### Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)