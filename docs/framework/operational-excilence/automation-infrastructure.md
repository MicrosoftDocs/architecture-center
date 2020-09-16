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

Historically, deploying a new service or application involves manual work such as procuring and preparing hardware, configuring operating environments, and enabling monitoring solutions. Ideally, an organization would have multiple environments in which to test deployments. These test environments should be similar enough to production that deployment and run time issues are detected before deployment to production. This manual work not only takes time but is error-prone, and if not done well, can produce inconsistencies between the environments.

Cloud computing changes the way we procure infrastructure. No longer are we unboxing, racking, and cabling physical infrastructure, we have internet accessible management portals and REST interfaces to help us. We can now provision virtual machines and databases on demand and globally. When we no longer need cloud services, they can be easily deleted. However, cloud computing alone does not remove the effort and risk in provisioning infrastructure. When using a cloud portal to build systems, much of the same manual configuration tasks remain. Application servers require configuration, databases need networking, and firewalls need firewalling. 

To fully realize deployment optimization, reduce configuration effort, and automate full environments' deployment, something more is required. One option is referred to as infrastructure as code.

## Infrastructure as code

Cloud computing changes so much about deploying and provisioning infrastructure. Not only can we procure compute, data, and so many other service types on demand, we have APIs for doing so. Because of cloud service's API-driven nature, programmatically deploying and configuring cloud services makes sense. The concept known as infrastructure as code involves using a declarative framework to describe your desired service configuration. Infrastructure as code solutions translates the requested configuration into the proper cloud provider API requests, which results in usable cloud services. Benefits of using infrastructure as code include:

- Deploy similarily configured infrastructure across multiple environments (test and production)
- Deploy all required components as a single unit (infrastructure, monitoring solutions, and configured alerts)
- Version control infrastructure in a source control solution
- Use continuous integration solutions to manage and test infrastructure deployments

You can use many declarative infrastructure deployment technologies with Azure, here we detail two of the most common.

## ARM Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON), and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the ARM engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- Parallele resource deployment
- Modular deployments
- Day one resource support
- Extensibility
- Testing, validation, and change preview
- Tooling

**Learn more**

- [Docs: What are ARM templates](https://docs.microsoft.com/azure/azure-resource-manager/templates/overview)
- [Learn: Deploy consistent infrastructure with ARM Templates](https://docs.microsoft.com/learn/modules/create-azure-resource-manager-template-vs-code/)
- [Code Samples: ARM templates](https://docs.microsoft.com/samples/browse/?terms=arm%20templates)

## Terraform

Terraform is a cloud-agnostic declarative framework that supports many private and public clouds, Azure being one of them. It has the main advantage of offering a cloud-agnostic framework: while Terraform configurations are specific to each cloud, the framework itself is the same for all of them. Additional benefits of using Terraform for infrastructure deployments include:

- Multi-cloud and endpoint support
- Full feature state tracking solution
- Modular deployments
- Extensibility
- Testing, validation, and change preview

Take note, the Terraform provider for Azure is an abstraction on top of Azure APIs. This abstraction is beneficial because the API complexities are obfuscated. This abstraction comes at a cost; the Terraform provider for Azure does not always provide parity with the Azure APIs' capabilities.

**Learn more**

- [Docs: Using Terraform on Azure](https://docs.microsoft.com/azure/developer/terraform/overview)
- [Code Samples: Terraform](https://docs.microsoft.com/samples/browse/?terms=Terraform)

## Tailwind case study

As part of a Tailwind Trader's cloud effort to release more often, increase reliability, while reducing effort, the Tailwind operations team has identified significant effort spent building or re-setting tailwindtraders.com test environments before each release. Furthermore, confidence is low in that the test environments provide the proper amount of production likeness to identify potential issues effectively. For example, monitoring and observability systems are not replicated to the test environments. 

Much of this effort spent performing the following manual tasks:

- Evaluating the tailwind production environment for current operating systems, data systems, patch levels, and other configuration items.
- Procuring and configuring virtual machines, data stores, and other components to match production as close as possible.
- Deploying the updated version of taiwindtraders.com application.
- Manually observing things like load performance, failover, and other typical run time considerations. 

While the Tailwind team uses tooling and scripting, the automation is ad-hock, isolated to single actions, and does not significantly reduce toil. Furthermore, the risk remains high that a miss-configuration has been introduced, resulting in miss-matched test and production environments.

In support of the modernization effort, Tailwind Traders has adopted an infrastructure as code approach for all cloud deployments. Using a single deployment template, the Tailwind team can deploy the following resources to multiple environments.

- An Azure App Service to hose the tailwindtraders.com site
- Azure Kubernetes Service for running the tailwindtraders.com backend services
- Azure Container Registry for storing container images
- Several database storage solutions
- Azure Application Insights for application performance monitoring

**Tailwind examples**

Take a look at the tailwindtraders.com infrastructure as code configuration at the following links.

- [Code Samples: Tailwind ARM](https://docs.microsoft.com/azure/developer/terraform/overview)
- [Code Samples: Tailwind Terraform](https://docs.microsoft.com/samples/browse/?terms=Terraform)

#### Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)