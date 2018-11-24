---
title: "Fusion: Resource Grouping" 
description: Discussion of resource grouping when planning an Azure migrations
author: rotycenh
ms.date: 11/13/2018
---

# Fusion: Resource grouping

[Subscription design](../subscriptions/overview.md) defines how you organize you cloud assets in relation to your organization's wider structure. Below that level,  integrating your existing IT management standards and your organizational policies depends on how you deploy and organize cloud resources *within* a subscription. The tools available to implement your resource grouping designs vary by cloud platform but will generally have some form of the following features:

- A logical grouping mechanism below the subscription or account level.
- Ability to deploy resources programatically though an API.
- Templates that can be used to create standardized deployments.
- Ability to deploy policy rules to the subscription, account, or resource grouping levels.

## Resource Grouping Decision Guide

![Plotting resource grouping options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-resource-grouping.png)

Jump to: [Cloud Native (Resource Groups)](#cloud-native-resource-groups) | [Deployment grouping (templated deployments)](#deployment-grouping-templated-deployments) | [Deployment configuration](#deployment-configuration) | [Query and govern](#query-and-govern) | [Complex grouping](#complex-grouping) | [Governance enforcement](#governance-enforcement)

Resource Grouping decisions are primarily driven by one of three factors: post-migration digital estate size, business or environmental  complexity that doesn't fit neatly within your existing subscription design approaches, or the need to enforce governance over time after resources have been deployed. More advanced resource grouping designs require an increased effort to ensure accurate grouping, and this results in an increase in the time spent on change management and tracking.

Limited resource grouping options are provided by most cloud providers, as a default required setting. Some cloud providers offer more options during deployment to improve initial governance. Other options include on-going control for post deployment governance enforcement. In Azure, [Management Groups](https://docs.microsoft.com/en-us/azure/governance/management-groups/) also allow for more flexible grouping to match complex organizational structures.

### Cloud Native (Resource Groups)

*Reviewers note: This section heavily re-purposes the Resource Groups content from the existing [Azure enterprise scaffold](../../appendix/azure-scaffold.md). The correct location of this content within the overall Azure Fusion guidance is still under consideration *

At the most basic level, most cloud platforms will provide a mechanism to logical group resources withing a subscription/account. In Azure, Resource Groups are the basic building block of grouping.

Azure [Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups) are containers of resources that have a common life cycle or share an attribute such as "all SQL servers" or "Application A". Resource groups can't be nested, and resources can only belong to one resource group. Some actions can act on all resources in a resource group. For example, deleting a resource group removes all resources within the resource group. There are common patterns when creating resource groups and these are commonly broken down between "Traditional IT" workloads and "Agile IT" workloads:

* "Traditional IT" workloads are most commonly grouped by items within the same life cycle, such as an application. Grouping by application allows for individual application management.
* "Agile IT" workloads tend to focus on external customer-facing cloud applications. The resource groups often reflect the layers of deployment (such as Web Tier, App Tier) and management.

### Deployment grouping (templated deployments)

Building on top of the base resource grouping mechanism, most cloud platforms provide a system for using templates to deploy your resources to the cloud environment. You can use templates to create consistent organization and naming conventions when deploying workloads, enforcing those aspects of your resource grouping design.

In Azure, [Resource Manager templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#template-deployment) provide this capability. Using Resource Manager templates, you can repeatedly deploy your solution and have confidence your resources are deployed in a consistent state and using your predetermined Resource Group structure. 

These templates can form a set of standards that you can base all of your deployments on. For example, you can have a standard template for deploying a web server workload, which would contain 2 virtual machines as servers coupled with load balancer to manage traffic between the servers. This template could be reused to create a structurally identical deployment whenever a new web server is needed, with the only modifications being the deployment name and IP addresses involved.

These templates can also be deployed programatically and integrated into your CI/CD systems.

### Deployment configuration

To ensure governance policies are applied from the moment resources are created, part of resource grouping design will involve the application of common configuration to your deployments. 

Using a combination of resource groups and standardized resource manager templates, you can enforce standards for what settings are required in a deployment and what [Azure policies](https://docs.microsoft.com/en-us/azure/governance/policy/overview) are applied to each resource group or resource.  

As an example, you may have a need to make sure all VMs deployed within you subscripiton connect to common subnet managed by your central IT team. You can create a standard template for deploying workload VMs which would create a separate resource group for the workload and deploy the required VMs there. This resource group would have a policy rule in place for only allow NICs within the resource to be joined to the shared subnet.

For a more in-depth discussion of enforcing your policy decisions within a cloud deployment, see the [policy enforcement](../policy-enforcement/overview.md) topic. 

### Query and govern

As the size of your cloud estate grows, your ability to locate, manage, and apply governance to resources becomes more difficult. Your resource grouping design, along with a well thought out [naming and tagging](../resource-tagging/overview.md) standard, provide the base that your IT staff will use to navigate through your cloud assets. 

However, in addition to properly structuring grouping, naming, and tagging for you deployments, your operations teams' ability to efficiently manage large numbers of resource will be greatly improved through the use of querying tools to explore your deployments and find specific resources. 

On the Azure platform, [Azure Resource Graph](https://docs.microsoft.com/en-us/azure/governance/resource-graph/overview) provides this capability. This graph service allows you to explore your resources using a query mechanism that can scale across all of your organization's subscriptions and management groups, allowing you to govern your entire cloud environment. 

### Complex grouping

As the size of your cloud estate grows you may need to support more complicated governance requirements than can be supported using the Azure Enterprise Agreement's Enterprise/Department/Account/Subscription hierarchy. Resource group design can allow you to support additional levels of hierarchy within your organization, with the ability to apply policy and access control rules at a resource group level.

As with your subscription design, [Azure Management Groups](../subscriptions/overview.md#management-groups) can help support more complicated organizational structures.

### Governance enforcement

For large cloud deployments, global governance becomes both more important and more complicated to implement. The ability to both automatically apply and enforce governance requirements when deploying resources, as well as updating requirements to existing deployments, is key in these scenarios. 

[Azure Blueprints](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview) are a key tool supporting global governance of large cloud estates on the Azure platform. Blueprints move beyond the capabilities provided by standard Resource Manager templates to create complete deployment orchestrations that include RBAC access control assignments, policy rules, resource manager templates, and resource group structures. These deployment packages makes it possible for IT and development teams to rapidly deploy new workloads and networking assets that comply with  organizational policy requirements. Blueprints can also be integrated into CI/CD pipelines which will apply updated governance standards on deployments as they are updated.

## Next steps

Learn how [resource naming and tagging](../resource-tagging/overview.md) are used to further organize and manage your cloud resources.

> [!div class="nextstepaction"]
> [Resource Naming and Tagging](../resource-tagging/overview.md)

