---
title: "Explainer - what is an Azure resource group?"
description: Explains the internal Azure function of a resource group
author: petertay
---

# What is an Azure resource group?

In the [what is Azure Resource Manager?](resource-manager-explainer.md) explainer article, you learned that Azure Resource Manager requires a **resource group identifier** when a call is made to create, read, update, or delete a resource. This resource group ID refers to a **resource group**. A resource group is simply an identifier that Azure Resource Manager applies to resources to group them together. This resource group ID allows Azure Resource Manager to perform operations on a group of resources that share this ID.

For example, a user can make a **delete** call to an Azure Resource Manager RESTful API specifying the resource group ID without including any specific resource ID. Azure Resource Manager queries an internal Azure database for all resources with the specified resource group ID and calls the RESTful API to delete each of the resources.

A resource group cannot include resources from different subscriptions. This is because there is a one-to-many relationship between tenant ID and subscription ID &mdash; multiple subscriptions can trust the same tenant to provide authentication and authorization, but each subscription can trust only one tenant. There is also a one-to-many relationship between subscription ID and resource group ID &mdash; multiple resource groups can belong to the same subscription, but each resource group can belong to only one subscription. Finally, there is a one-to-many relationship between resource group ID and resource ID &mdash; a single resource group can have multiple resources, but each resource can only belong to a single resource group.

## Next steps

* Now that you have learned about Azure resource groups, gain foundational knowledge [about restricting access to resources](/azure/active-directory/active-directory-understanding-resource-access?toc=/azure/architecture/cloud-adoption-guide/toc.json). Though it's not a part of the foundational adoption stage, it is important during the intermediate adoption stage. Then you can [create your first resource group](/azure/azure-resource-manager/resource-group-portal?toc=/azure/architecture/cloud-adoption-guide/toc.json) and review the [design guidance for Azure resource groups](resource-group.md).
