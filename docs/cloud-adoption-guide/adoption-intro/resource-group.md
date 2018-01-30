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
- A resource group can be used to scope access control for administrative actions. You can apply RBAC permissions at the subscription level or at the resource group level. Anything assigned at the subscription level will be inherited at the resource group level.

## Best practices

- Your resource group design can follow the architecture of your workload. For example, if you are deploying an n-tier architecture, you can create a separate resource group for the web tier, application tier, data tier, and management tier resources.
- Assign permissions at the resource group level as opposed to assigning them at the subscription level.
- Use tagging within your resource groups to ensure categorization of resources for billing and security purposes.
- Use a cohesive and consistent naming standard of your security groups across your subscriptions.
- When creating resource groups, ensure that specific tiers (web, app, data, management) of the workload are assigned to the same region. 