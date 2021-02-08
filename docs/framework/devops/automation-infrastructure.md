---
title: Repeatable Infrastructure
description: Repeatable Infrastructure
author: neilpeterson
ms.date: 10/15/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Repeatable Infrastructure

Historically, deploying a new service or application involves manual work such as procuring and preparing hardware, configuring operating environments, and enabling monitoring solutions. Ideally, an organization would have multiple environments in which to test deployments. These test environments should be similar enough to production that deployment and run time issues are detected before deployment to production. This manual work takes time, is error-prone, and can produce inconsistencies between the environments if not done well.

Cloud computing changes the way we procure infrastructure. No longer are we unboxing, racking, and cabling physical infrastructure. We have internet accessible management portals and REST interfaces to help us. We can now provision virtual machines, databases, and other cloud services on demand and globally. When we no longer need cloud services, they can be easily deleted. However, cloud computing alone does not remove the effort and risk in provisioning infrastructure. When using a cloud portal to build systems, many of the same manual configuration tasks remain. Application servers require configuration, databases need networking, and firewalls need firewalling. 

## Deploy infrastructure with code

To fully realize deployment optimization, reduce configuration effort, and automate full environments' deployment, something more is required. One option is referred to as infrastructure as code.

Cloud computing changes so much about deploying and provisioning infrastructure. Not only can we procure compute, data, and so many other service types on demand, we have APIs for doing so. Because of cloud service's API-driven nature, programmatically deploying and configuring cloud services makes sense. The concept known as infrastructure as code involves using a declarative framework to describe your desired service configuration. Infrastructure as code solutions translate the declared configuration into the proper cloud provider API requests, which, once deployed result in usable cloud services. Benefits of using infrastructure as code include:

- Deploy similarly configured infrastructure across multiple environments e.g., test and production.
- Deploy all required components as a single unit (infrastructure, monitoring solutions, and configured alerts).
- Version control infrastructure in a source control solution.
- Use continuous integration solutions to manage and test infrastructure deployments.

You can use many declarative infrastructure deployment technologies with Azure, here we detail two of the most common.

## Automate deployments with ARM Templates

Azure Resource Manager (ARM) Templates provide an Azure native infrastructure as code solution. ARM Templates are written in a language derived from JavaScript Object Notation (JSON), and they define the infrastructure and configurations for Azure deployments. An ARM template is declarative, you state what intend to deploy, provide configuration values, and the Azure engine takes care of making the necessary Azure REST API put requests. Additional benefits of using ARM templates for infrastructure deployments include:

- **Parallel resource deployment** - the Azure deployment engine sequences resource deployments based on defined dependencies. If dependencies do not exist between two resources, they are deployed at the same time.
- **Modular deployments** - ARM templates can be broken up into multiple template files for reusability and modularization.
- **Day one resource support** - ARM templates support all Azure resources and resource properties as they are released.
- **Extensibility** - Azure deployments can be extended using deployment scripts and other automation solutions.
- **Validation** - Azure deployments are evaluated against a validation API to catch configuration mistakes. 
- **Testing** - the [ARM template test toolkit](/azure/azure-resource-manager/templates/test-toolkit) provides a static code analysis framework for testing ARM templates.
- **Change preview** - [ARM template what-if](/azure/azure-resource-manager/templates/template-deploy-what-if?tabs=azure-powershell) allows you to see what will be changed before deploying an ARM template.
- **Tooling** - Language service extensions are available for both [Visual Studio Code](/azure/azure-resource-manager/templates/quickstart-create-templates-use-visual-studio-code) and [Visual Studio](/azure/azure-resource-manager/templates/create-visual-studio-deployment-project) to assist in authoring ARM templates.

The following example demonstrates a simple ARM template that deploys a single Azure Storage account. In this example, a single parameter is defined to take in a name for the storage account. Under the resources section, a storage account is defined, the *storageName* parameter is used to provide a name, and the storage account details are defined. See the included documentation for an in-depth explanation of the different sections and configurations for ARM templates.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "storageName": {
            "type": "string",
            "defaultValue": "newStorageAccount"
        }
    },
    "resources": [
        {
            "name": "[parameters('storageName')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2019-06-01",
            "location": "[resourceGroup().location]",
            "kind": "StorageV2",
            "sku": {
                "name": "Premium_LRS",
                "tier": "Premium"
            }
        }
    ]
}
```

**Learn more**

- [Documentation: What are ARM templates](/azure/azure-resource-manager/templates/overview)
- [Learn module: Deploy consistent infrastructure with ARM Templates](/learn/modules/create-azure-resource-manager-template-vs-code/)
- [Code Samples: ARM templates](/samples/mspnp/samples/azure-well-architected-framework-sample-arm-template/)

## Automate deployments with Terraform

Terraform is a declarative framework for deploying and configuring infrastructure that supports many private and public clouds, Azure being one of them. It has the main advantage of offering a cloud-agnostic framework. While Terraform configurations are specific to each cloud, the framework itself is the same for all of them. Terraform configurations are written in a domain-specific language (DSL) called Hashicorp Configuration Language.

The following example demonstrates a simple Terraform configuration that deploys an Azure resource group and a single Azure Storage account.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "newStorageAccount"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

Take note, the Terraform provider for Azure is an abstraction on top of Azure APIs. This abstraction is beneficial because the API complexities are obfuscated. This abstraction comes at a cost; the Terraform provider for Azure does not always provide parity with the Azure APIs' capabilities.

**Learn more**

- [Documentation: Using Terraform on Azure](/azure/developer/terraform/overview)

## Manual deployment

Manual deployment steps introduce significant risks where human error is concerned and also increases overall deployment times. However, in some cases, manual steps may be required. For these cases, ensure that any manual steps are documented, including roles and responsibilities.

## Hotfix process

In some cases, you may have an unplanned deployment need. For instance, to deploy critical hotfixes or security remediation patches. A defined process for unplanned deployments can help prevent service availability and other deployment issues during these critical events. 

## Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)