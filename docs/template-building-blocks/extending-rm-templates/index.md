---
title: Patterns for extending Azure Resource Manager template functionality
description: Describes patterns, tips and tricks on how to extend Azure Resource Manager template functionality
author: petertay
ms.service: guidance
ms.topic: article
ms.date: 05/03/2017
ms.author: pnp

pnp.series.title: Patterns for extending Azure Resource Manager template functionality
pnp.series.prev: 
pnp.series.next: 
---
# Patterns for extending Azure Resource Manager template functionality

In 2016, the AzureCAT patterns & practices team created a set of Azure Resource Manager [template building blocks](https://github.com/mspnp/template-building-blocks/wiki) with the goal of simplifying resource deployment. The template building blocks are a set of pre-built templates that deploy sets of resources specified by separate parameter files.

The building block templates are designed to be combined together to create larger and more complex deployments. For example, deploying a virtual machine in Azure requires a virtual network (VNet), storage accounts, and other resources. The [VNet building block template](https://github.com/mspnp/template-building-blocks/wiki/VNet-(v1)) deploys a VNet and subnets. The [virtual machine building block template](https://github.com/mspnp/template-building-blocks/wiki/Windows-and-Linux-VMs-(v1)) deploys storage accounts, network interfaces, and the actual VMs. You can then create a script or template to call both building block templates with their corresponding parameter files to deploy a complete architecture with one operation.

While developing the building block templates, p&p designed several patterns to extend Azure Resource Manager template functionality. In this series, we will cover several of these patterns. 

> [!NOTE]
> These articles assume you have an advanced understanding of Azure Resource Manager templates.