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

As part of the Tailwindtrader's effort to release more often, increase reliability, while reducing effort, the Tailwind operations team has identified significant effort spent building or re-setting the tailwindtraders.com test environments before each release. Furthermore, confidence is low in that the test environments provide the proper amount of production likeness to effectively raise awareness of potential issues. 

Much of this effort is spent performing the following manual tasks:

- Evaluating the tailwind production environment for current operating systems, data systems, patch levels, and other configuration items.
- Procuring and configuring virtual machines to match production as close as possible.
- Deploying the current version of taiwindtraders.com application.
- Manually observing things like load performance, failover, and other common run time considerations. 

While the Tailwind team does use tooling and scripting during these activities, the level of provided automation is relatively isolated to a single activity like basic operating system configurations, which and do not result in a significant reduction of toil. Furthermore, the risk remains high that a miss-configuration has been introduced, resulting in miss-matched test and production environments.

## Repeatable infrastructure

< Fill this out >

## Declarative Tools

A declarative automation framework is characterized for handling some of the details about the resource creation on behalf of the user. The user needs to define what should be created, and the declarative framework will figure out how. You can use many declarative infrastructure deployment technologies with Azure, here we detail two of the most common.

### Azure Resource Manager Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON) and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the ARM engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- Parallele resource deployment
- Modular deployments
- Day one resource support
- Extensibility
- Testing, validation, and change preview
- Deployment scopes
- Tooling

For more information about Azure Resource Manager Templates, see [Docs: What are ARM templates](https://docs.microsoft.com/azure/azure-resource-manager/templates/overview).
To take a guided learning experience with Azure Resource Manager Template, see [Learn: Deploy consistent infrastructure with ARM Templates](https://docs.microsoft.com/learn/modules/create-azure-resource-manager-template-vs-code/).
To see a sample Azure Resource Manager Template, see [Code Samples: ARM Tempalte](https://docs.microsoft.com/samples/browse/?terms=arm%20templates).

### Terraform

Terraform is a cloud-agnostic declarative framework that supports many private and public clouds, Azure being one of them. It has the main advantage of offering a cloud-agnostic framework: while Terraform configurations are specific to each cloud, the framework itself is the same for all of them. Additional benefits of using Terraform for infrastructure deployments include:

- Multi-cloud and endpoint support
- Full feature state tracking solution
- Modular deployments
- Extensibility
- Testing, validation, and change preview

Take note, the Terraform provider for Azure is an abstraction on top of Azure APIs. This is beneficial because some of the API surface complexities can be obfuscated, however comes at a cost in that the Terraform provider for Azure does not always provide parity with the capabilities of the Azure APIs.

For more information about Terraform on Azure, see [Docs: Using Terraform on Azure](https://docs.microsoft.com/azure/developer/terraform/overview).
To see a sample Azure Resource Manager Template, see [Code Samples: Terraform](https://docs.microsoft.com/samples/browse/?terms=Terraform).

#### Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)