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

# Deploy infrastructure

Before an application, solution, or other pieces of code can be made usable, a platform on which to run the code must be deployed, configured, and made accessible for hosting an application.

## Azure Resource Manager Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON) and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the ARM engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- Parallele resource deployment
- Modular deployments
- Day one resource support
- Extensibility
- Testing, validation, and change preview
- Deployment scopes
- Tooling

For more information about Azure Resource Manager Templates, see [What are ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview).

### Authoring ARM Templates

Any code or text editor can be used to author an ARM template. We recommend Visual Studio Code and the ARM Tools extension as it is the most feature-rich tooling and is under active development. The ARM Tools extension not only helps ensure that an ARM template is syntactically correct but also uses Azure resource schemas to provide validation that Azure resources have been correctly defined.

### Testing ARM Templates

### Deploying ARM Templates

## Terraform

### Authoring Terraform configurations

### Testing Terraform configurations

### Deploying Terraform configurations

## Others

### Palumi

#### Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)