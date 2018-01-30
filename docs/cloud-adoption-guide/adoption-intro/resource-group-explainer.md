---
title: Explainer - what is Azure resource group?
description: Explanation of the internal Azure function of a resource group
author: petertay
---

# What is a resource group?

In the [what is Azure Resource Manager](resource-manager-explainer.md) explainer, you learned that Azure Resource Manager requires a **resource group identifier** when a call is made to create, read, update, or delete a resource. The resource group ID refers to a **resource group**. A resource group is simply an identifier that Azure Resource Manager applies to resources to group them together. This allows Azure Resource Manager to apply operations to a group of resources that share a common resource group ID.

For example, a user can make a **delete** call to an Azure Resource Manager RESTful API specifying the resource group ID without including any specific resource ID. Azure Resource Manager queries an internal Azure database for all resources with the specified resource group ID and calls the RESTful API to delete each of the resources.

A resource group cannot include resources from different subscriptions. This is because individual resources are first indexed by tenant ID, then subscription ID, then resource group ID, then resource ID. This means that a resource cannot have multiple resource group IDs, and a resource group cannot have multiple subscription IDs.

# Next steps

