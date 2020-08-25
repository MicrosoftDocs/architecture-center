---
title: "Deploy infrastructure"
description: "Deploy infrastructure"
author: neilpeterson
ms.date: 08/18/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: fasttrack-edit
---

# Deploy infrastructure as code

Whether your application is running on Azure Virtual Machines, on Azure Web App Services, or on Kubernetes, you need to deploy those services before actually being able to put your application on them. Creating VMs is a task performed daily in most organizations, however, you should leverage automation so that the infrastructure deployment is consistent across different environments.

Consistency of infrastructure deployments will give you multiple benefits:

- The platform where developers test their applications will be identical to the platform where the applications will run in production, thus preventing the "but it runs on my machine" type of situation, where production systems differ from testing systems.
- If any of the stages (development, testing, staging, production) have an issue, it might be quicker to just redeploy the whole platform, instead of trying to fix the existing one.
- Automated deployment is a possible strategy to enable Business Continuity and Disaster Recovery since you can deploy both the infrastructure and the application code quickly and reliably in any Azure region.
- By automating the creation of the application platform, you eliminate human errors from the equation. Every environment is created the same without the risk of human administrators forgetting to set a property or tick a checkbox.

## Options for Infrastructure as Code on Azure

### Azure Resource Manager Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON) and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the ARM engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- Parallele resource deployment
- Modular deployments
- Day one resource support
- Extensibility
- Testing, validation, and change preview
- Deployment scopes
- Tooling

For more information about Azure Resource Manager Templates, see [What are ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview).

### Terraform

### Others

## Testing infrastructure

## Deploying infrastructure

### Deployment environments

## Configuration drift

#### Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)