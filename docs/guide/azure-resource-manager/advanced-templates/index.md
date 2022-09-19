---
title: Advanced Azure Resource Manager templates
description: Learn tips for getting the most out of Azure Resource Manager template functionality by following advanced examples.
author: hallihan
ms.date: 09/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - developer-tools
  - devops
categories:
  - developer-tools
  - devops
products:
  - azure-resource-manager
ms.custom:
  - article
---

# Advanced Azure Resource Manager template functionality

This section provides advanced examples for Azure Resource Manager templates.

**[Update a resource](update-resource.md)**. You may need to update a resource during a deployment. You might encounter this scenario when you cannot specify all the properties for a resource until other, dependent resources are created.

**[Use an object parameter in a copy loop](objects-as-parameters.md)**. There is a limit of 256 parameters per deployment. Once you get to larger and more complex deployments you may run out of parameters. One way to solve this problem is to use an object as a parameter instead of a value.

**[Property transformer and collector](collector.md)**. A property transform and collector template can transform objects into the JSON schema expected by a nested template.

> [!NOTE]
> These articles assume you have an advanced understanding of Azure Resource Manager templates.
