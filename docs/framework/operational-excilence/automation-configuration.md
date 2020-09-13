---
title: Configure Infrastructure
description: Configure Infrastructure
author: neilpeterson
ms.date: 09/02/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Configure Infrastructure

When working with Azure, many services can be created and configured programmatically using automation tools. These tools access Azure through the exposed REST APIs or what we will refer to as the control plane. Other configurations, such as installing software on a virtual machine, adding data to a database, or starting pod in an Azure Kubernetes Service cluster can not be accessed through the control plane and require a different set of automation tools. 

## Bottstrap Virtula Machines

### Azure VM extensions

Azure virtual machine extensions are small packages that run post-deployment configuration and automation on Azure virtual machines. Several extensions are available for many different configuration tasks, such as running scripts, configuring antimalware solutions, and configuring logging solutions. These extensions can be installed and run on virtual machines using an ARM template, the Azure CLI, Azure PowerShell module, or the Azure portal. Each Azure VM has a VM Agent installed, and this agent manages the lifecycle of the extension.

A typical VM extension use case would be to use a custom script extension, which 

```
az vm extension set \
  --resource-group myResourceGroup \
  --vm-name myVM --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --protected-settings ./script-config.json
```

**Learn more**

- More information about Azure VM extension: [Docs: Azure virtual machine extensions](https://docs.microsoft.com/azure/virtual-machines/extensions/overview)
- Sample Azure Resource Manager Templates: [Code Samples: Configure VM during ARM deployent](https://docs.microsoft.com/samples/browse/?terms=arm%20templates)

### Virtual machine run command

**Learn more**

### Cloudinit

**Learn more**

## Configuration Management

**Learn more**

### Desired State Configuration

**Learn more**

### Chef

**Learn more**

### Puppet

**Learn more**

## Other automation

### Azure CLI

### Azure PowerShell module

### Azure deployment script resource

#### Next steps

> [!div class="nextstepaction"]
> [Automate operational tasks](./automation-tasks.md)
