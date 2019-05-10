---
title: Extend Azure Resource Manager template functionality
description: Describes tips and tricks on how to extend Azure Resource Manager template functionality.
author: petertay
ms.date: 06/09/2017
ms.topic: article
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Extend Azure Resource Manager template functionality

In 2016, the Microsoft patterns & practices team created a set of Azure Resource Manager [template building blocks](https://github.com/mspnp/template-building-blocks/wiki) with the goal of simplifying resource deployment. Each building block contains a set of prebuilt templates that deploy sets of resources specified by separate parameter files.

The building block templates are designed to be combined together to create larger and more complex deployments. For example, deploying a virtual machine in Azure requires a virtual network, storage accounts, and other resources. The [virtual network building block template](https://github.com/mspnp/template-building-blocks/wiki/VNet-(v1)) deploys a virtual network and subnets. The [virtual machine building block template](https://github.com/mspnp/template-building-blocks/wiki/Windows-and-Linux-VMs-(v1)) deploys storage accounts, network interfaces, and the actual VMs. You can then create a script or template to call both building block templates with their corresponding parameter files to deploy a complete architecture with one operation.

While developing the building block templates, p&p designed several concepts to extend Azure Resource Manager template functionality. In this series, we will describe several of these concepts so you can use them in your own templates.

> [!NOTE]
> These articles assume you have an advanced understanding of Azure Resource Manager templates.