---
title: Azure resource group design guide
description: Guidance for Azure resource group design as part of a foundational cloud adoption strategy
author: petertay
---

# Azure resource group design guide

In Azure, a [resource group](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview#resource-groups) is a logical container in which resources are grouped. Each resource deployed in Azure must be deployed into a resource group. Each resource can only be deployed into a single resource group.

## Design considerations

- All resources in a resource group should share the same lifecycle. That is, your practice should be to deploy, update, and delete resources with the same lifecycle as a group. For example, a web application's compute and application resources are typically deployed as a single unit. However, a database shared with other web applications would most likely be managed in a different lifecycle, and should be in its own resource group.
- A resource group can contain resources that reside in different regions.
- All the resources in a resource group must be deployed to a single subscription. That is, a first resource deployed to a first subscription cannot be placed in a resource group that includes a second resource deployed to a second description. 
- A resource can be moved between resource groups, but resources cannot be moved into a resource group that contains a resource deployed to a different subscription.
- A resource does not affect the connectivity or interaction with resource groups in other resource groups. For example, a virtual machine deployed to a first resource group is capable of connecting to a database deployed to a second resource group as long as there is network connectivity between them.
- A resource group can be used to scope access control for administrative actions. You can apply role-based access control (RBAC) permissions at the subscription level or at the resource group level. Anything assigned at the subscription level will be inherited at the resource group level.

## Best practices

- At this foundational stage, you are most likely managing a small number of proof-of-concept projects with a small number of resources. Because the lifecycle of the resources for proof-of-concept projects are managed together, you can create a single resource group for each of these projects. 
- In the intermediate adoption stage, you will be managing multiple projects and different types of projects can benefit from other resource group designs. If you plan for any of your initial proof-of-concept projects to be promoted to production, as noted above you can move resources from one resource group to another as long as they are in the same subscription. Therefore, at this foundational stage, plan to deploy these resources to the same subscription to enable future resource group refactoring.

## Next steps

* Now that you have learned the best practices for the foundational adoption stage, you are able to create resource groups and add resources to them. While at this foundational stage you will be managing a small number of resources, as that number increases the task of managing them becomes more complex. Learn about [Azure naming conventions and tagging](/azure/architecture/best-practices/naming-conventions?toc=/azure/architecture/cloud-adoption-guide/toc.json) to name and tag your resources in preparation for the intermediate adoption stage. 