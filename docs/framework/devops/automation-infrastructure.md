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

## Azure Landing Zones (Repeatable environment configuration)

Organizations which centrally manage, govern, or support multiple workloads in the cloud will require repeatable **and consistent** environments. Azure Landing Zones provide central operations teams with a repeatable approach to environmental configuration. To deliver consistent environments, all Azure Landing Zones provide a set of common design areas, reference architecture, reference implementation, and a process to modify that deployment to fit the organization design requirements.

> [!WARNING]
> Some organizations are following a growing industry trend towards decentralized operations (or workload operations). When operations is decentralized, the organization chooses to accept duplication of resources and potential inconsistencies in environmental configuration, in favor of reduced dependencies and full control of the environment through DevOps pipelines. Organizations who are following a decentralized operating model are less likely to leverage Azure Landing Zones to create repeatable environment configurations, but will still find value in the subsequent sections of this article.

The following is a series of links from the Cloud Adoption Framework to help deploy Azure Landing Zones:

- All Azure Landing Zones adhere to a [common set of design areas](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-areas) to guide configuration of required environment considerations including: Identity, Network topology and connectivity, Resource organization, Governance disciplines, Operations baseline, and Business continuity and disaster recovery (BCDR)
- All Azure Landing Zones can be deployed through the Azure portal, but are designed to leverage infrastructure as code to create, [test](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/considerations/test-driven-development), and [refactor](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/refactor) repeatable deployments of the environmental configuration.
- The Cloud Adoption Framework provides a number of [Azure Landing Zone implementation options](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/implementation-options), including:
  - Start small & expand implementation using Azure Blueprints and ARM Templates
  - Enterprise-Scale implementation using Azure Policy and ARM Templates
  - CAF Terraform modules and a variety of landing zone options 

To get started with Azure Landing Zones to create consistent, repeatable environment configuration see the article series on [Azure Landing Zones](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/).

If Azure Landing Zones are not a fit for your organization, you should consider the following sections of this article to manual integrate environment configuration into your DevOps pipelines. 

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

## Next steps

> [!div class="nextstepaction"]
> [Automate infrastructure configuration](./automation-configuration.md)
