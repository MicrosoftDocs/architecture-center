---
title: Advanced Azure Resource Manager templates
description: Learn tips for getting the most out of Azure Resource Manager template functionality by following advanced examples.
author: hallihan
ms.date: 01/05/2023
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

The articles in this section provide examples of using Azure Resource Manager templates (ARM templates). They assume that you have an advanced understanding of ARM templates. The articles are:

- [Update a resource in an ARM template](update-resource.md). You can update a resource during a deployment if necessary. You'd need to do this, for example, if you can't specify all the properties for a resource until other, dependent resources are created.
- [Use objects as parameters in a copy loop in an ARM template](objects-as-parameters.md). There's a limit of 256 parameters per deployment. You can work around this limit by passing objects as parameters.
- [Implement a property transformer and collector in an ARM template](collector.md). A property transform and collector template can transform objects into JSON schemas for use by nested templates.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Rick Hallihan](https://www.linkedin.com/in/hallihan/) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Resource Manager](https://azure.microsoft.com/get-started/azure-portal/resource-manager)
- [What are ARM templates?](/azure/azure-resource-manager/templates/overview)
- [Tutorial: Create and deploy your first ARM template](/azure/azure-resource-manager/templates/template-tutorial-create-first-template)
- [Tutorial: Add a resource to your ARM template](/azure/azure-resource-manager/templates/template-tutorial-add-resource?tabs=azure-powershell)
- [ARM template best practices](/azure/azure-resource-manager/templates/best-practices)
- [Azure Resource Manager documentation](/azure/azure-resource-manager)
- [ARM template documentation](/azure/azure-resource-manager/templates)

## Related resources

- [Update a resource in an Azure Resource Manager template](update-resource.md)
- [Use objects as parameters in a copy loop in an Azure Resource Manager template](objects-as-parameters.md)
- [Implement a property transformer and collector in an Azure Resource Manager template](collector.md)
