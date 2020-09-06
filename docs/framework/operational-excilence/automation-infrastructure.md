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

As part of the Tailwindtrader's effort to release more often, increase reliability, while reducing effort, the Tailwind operations team has identified significant effort spent building or re-setting tailwindtraders.com test environments before each release. Furthermore, confidence is low in that the test environments provide the proper amount of production likeness to identify potential issues effectively. For example, monitoring and observability systems are not replicated in the test environments. Where a new release may deploy and function fine, can the tailwind team have confidence when going to production that the application will...

Much of this effort spent performing the following manual tasks:

- Evaluating the tailwind production environment for current operating systems, data systems, patch levels, and other configuration items.
- Procuring and configuring virtual machines, data stores, and other components to match production as close as possible.
- Deploying the updated version of taiwindtraders.com application.
- Manually observing things like load performance, failover, and other typical run time considerations. 

While the Tailwind team uses tooling and scripting, the automation is ad-hock, isolated to single actions, and does not result in a significant reduction in toil. Furthermore, the risk remains high that a miss-configuration has been introduced, resulting in miss-matched test and production environments.

## Infrastructure as code

Cloud computing changes so much about deploying and provisioning infrastructure. Not only can we procure compute, data, and so many other service types on demand, we have APIs for doing so. Because of cloud service's API-driven nature, programmatically deploying and configuring cloud services makes sense. The concept known as infrastructure as code involves using a declarative framework to describe the service configure that you desire. Infrastructure as code solutions translates the requested configuration into the proper cloud provider API requests, which results in usable cloud services. Benefits of using infrastructure as code include:

- Deploy similarily configured infrastructure across multiple environments (test and production).
- Deploy all required components as a single unit (infrastructure, monitoring solutions, and configured alerts).
- Version control infrastructure in a source control solution.
- Use continuous integration solutions to manage and test infrastructure deployments
- Recover from failure more quickly

You can use many declarative infrastructure deployment technologies with Azure, here we detail two of the most common.

## ARM Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON) and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the ARM engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- Parallele resource deployment
- Modular deployments
- Day one resource support
- Extensibility
- Testing, validation, and change preview
- Deployment scopes
- Tooling

|---|---|
| Docs: What are ARM templates | [link](https://docs.microsoft.com/azure/azure-resource-manager/templates/overview) |
| Learn: Deploy consistent infrastructure with ARM Templates | [link](https://docs.microsoft.com/learn/modules/create-azure-resource-manager-template-vs-code/) |
| Code Samples: ARM Tempalte | [link](https://docs.microsoft.com/samples/browse/?terms=arm%20templates) |

For more information about Azure Resource Manager Templates, see [Docs: What are ARM templates](https://docs.microsoft.com/azure/azure-resource-manager/templates/overview).

To take a guided learning experience with Azure Resource Manager Template, see [Learn: Deploy consistent infrastructure with ARM Templates](https://docs.microsoft.com/learn/modules/create-azure-resource-manager-template-vs-code/).

To see a sample Azure Resource Manager Template, see [Code Samples: ARM Tempalte](https://docs.microsoft.com/samples/browse/?terms=arm%20templates).

## Terraform

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