---
title: Azure resource group design guidance
description: Guidance for Azure resource group design as part of a foundational cloud adoption strategy
author: petertay
---

# Azure resource group design guidance

In Azure, a [resource group](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview#resource-groups) is a logical container in which resources are grouped. Each resource deployed in Azure must be deployed into a single resource group.

## Design considerations

- All resources in a resource group should share the same lifecycle. That is, your practice should be to deploy, update, and delete resources with the same lifecycle as a group. For example, a web application's compute and application resources are typically deployed as a single unit. However, a database shared with other web applications would most likely be managed in a different lifecycle, and should be in its own resource group.
- A resource group can contain resources that reside in different regions.
- All the resources in a resource group must be deployed to a single subscription. A resource deployed to one subscription cannot be placed in a resource group that includes another resource deployed to a different subscription.
- A resource can be moved between resource groups, but not into a resource group containing a resource deployed to a different subscription.
- A resource's group assignment does not affect connectivity or interaction with resources in other resource groups. For example, a virtual machine assigned to one resource group can connect to a database assigned to another resource group if there is network connectivity between them.
- A resource group can be used to scope access control for administrative actions. You can apply role-based access control (RBAC) permissions at the subscription level or at the resource group level. Any permissions assigned at the subscription level are inherited at the resource group level.

## Proven practices

- In the foundational stage, you are likely managing only a few proof-of-concept (POC) projects, each with a small number of resources. Because POC resources usually share the same lifecycle, you can create a single resource group for each of these projects.
- During the intermediate adoption stage, you will manage multiple projects. Different types of projects can benefit from other resource group designs. If you intend to promote any of your initial POC projects to production, you can move resources to another resource group if it belongs to the same subscription. Therefore, at this stage you should deploy these resources to the same subscription so you can reorganize resources in the future.

## Next steps

* Now that you have learned the proven practices for the foundational adoption stage, you are able to create resource groups and add resources to them. While you are managing a small number of resources at this stage, managing them becomes more complex as you add more resources. Learn about [Azure naming conventions and tagging](/azure/architecture/best-practices/naming-conventions?toc=/azure/architecture/cloud-adoption-guide/toc.json) to name and tag your resources in preparation for the intermediate adoption stage.
