---
title: Advanced Azure Resource Manager template functionality
description: Describes tips and for Azure Resource Manager template functionality.
author: hallihan
ms.date: 12/21/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
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

**[Conditionally deploy a resource](conditional-deploy.md)**. There are scenarios you need to deploy a resource based on a condition, such as whether or not a parameter value is present.

**[Use an object as a parameter](objects-as-parameters.md)**. There is a limit of 255 parameters per deployment. Once you get to larger and more complex deployments you may run out of parameters. One way to solve this problem is to use an object as a parameter instead of a value.

**[Property transformer and collector](collector.md)**. A property transform and collector template can transform objects into the JSON schema expected by a nested template.

> [!NOTE]
> These articles assume you have an advanced understanding of Azure Resource Manager templates.
