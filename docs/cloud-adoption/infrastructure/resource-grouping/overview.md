---
title: "Fusion: Resource grouping" 
description: Discussion of resource grouping when planning an Azure migrations
author: rotycenh
ms.date: 12/27/2018
---

# Fusion: Resource grouping

[Subscription design](../subscriptions/overview.md) defines how you organize you cloud assets in relation to your organization's wider structure. In addition, integrating your existing IT management standards and your organizational policies depends on how you deploy and organize cloud resources within a subscription. The tools available to implement your resource grouping designs vary by cloud platform, but in general each solution includes the following features:

- A logical grouping mechanism below the subscription or account level
- Ability to deploy resources programmatically with APIs
- Templates that you can use to create standardized deployments
- Ability to deploy policy rules to the subscription, account, and resource grouping levels

## Resource grouping decision guide

![Plotting resource grouping options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-resource-grouping.png)

Jump to: [Cloud Native (Resource Groups)](#cloud-native-resource-groups) | [Deployment grouping (templated deployments)](#deployment-grouping-templated-deployments) | [Deployment configuration](#deployment-configuration) | [Query and govern](#query-and-govern) | [Complex grouping](#complex-grouping) | [Governance enforcement](#governance-enforcement)

Resource grouping decisions are primarily driven by these factors: post-migration digital estate size, business or environmental complexity that doesn't fit neatly within your existing subscription design approaches, or the need to enforce governance over time after resources have been deployed. More advanced resource grouping designs require an increased effort to ensure accurate grouping, and this results in an increase in the time spent on change management and tracking.

Limited resource grouping options are provided by most cloud providers as a default required setting. Some cloud providers offer more options during deployment to improve initial governance, such as on-going control for post deployment governance enforcement. With Azure, [Management Groups](https://docs.microsoft.com/en-us/azure/governance/management-groups/) also allow for more flexible grouping to match complex organizational structures.

### Cloud native (resource groups)

*Reviewers note: This section heavily re-purposes the Resource Groups content from the existing [Azure enterprise scaffold](../../appendix/azure-scaffold.md). The correct location of this content within the overall Azure Fusion guidance is still under consideration.*

At the most basic level, cloud platforms provide a mechanism to logically group resources within a subscription/account. With Azure, resource groups are the basic building block of grouping.

Azure [Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups) are containers of resources that have a common life cycle or they share an attribute, such as "all SQL servers" or "Application A". Resource groups can't be nested and resources can only belong to one resource group. Some actions can act on all resources in a resource group. For example, deleting a resource group removes all resources within that group. There are common patterns when creating resource groups and these are commonly broken down as "Traditional IT" workloads and "Agile IT" workloads:

* Traditional IT workloads: Most often grouped by items within the same life cycle, such as an application. Grouping by application allows for individual application management.
* Agile IT workloads: Focus on external customer-facing cloud applications. These resource groups often reflect the functional layers of deployment (such as Web Tier, App Tier) and management.

### Deployment grouping (templated deployments)

Building on top of the base resource grouping mechanism, most cloud platforms provide a system for using templates to deploy your resources to the cloud environment. You can use templates to create consistent organization and naming conventions when deploying workloads, enforcing those aspects of your resource grouping design.

[Azure Resource Manager templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#template-deployment) provide deployment grouping. You can use Resource Manager templates to repeatedly deploy your solution, and have confidence that your resources will be deployed in a consistent state using a predetermined resource group structure. 

Azure templates helps you form a set of standards that you can then base all of your deployments on. For example, you can have a standard template for deploying a web server workload, which would contain two virtual machines as servers coupled with load balancer to manage traffic between the servers. You can then reuse this template to create a structurally identical deployment whenever a new web server is needed, with the only modifications being the deployment name and IP addresses involved.

Note that you can also programmatically deploy these templates and integrate them with your CI/CD systems.

### Deployment configuration

To ensure that governance policies are applied from the moment that you create your resources, part of resource grouping design will involve the application of common configuration to your deployments. 

Using a combination of resource groups and standardized resource manager templates, you can enforce standards for what settings are required in a deployment and what [Azure Policies](https://docs.microsoft.com/en-us/azure/governance/policy/overview) are applied to each resource group or resource.  

As an example, you may have a requirement that all VMs deployed within your subscription connect to common subnet managed by your central IT team. You can create a standard template for deploying workload VMs which would create a separate resource group for the workload and deploy the required VMs there. This resource group would have a policy rule in place to only allow network interfaces within the resource group to be joined to the shared subnet.

The [Azure Virtual Datacenter model makes extensive use](vdc-resource-grouping.md) of resource groups to organize resources, apply access controls, and enforce resource creation policies.

For a more in-depth discussion of enforcing your policy decisions within a cloud deployment, see the [policy enforcement](../policy-enforcement/overview.md) topic. 

### Query and govern

As the size of your cloud estate grows, your ability to locate, manage, and apply governance to resources becomes more difficult. Your resource grouping design, along with a well thought out [naming and tagging](../resource-tagging/overview.md) standard, provide the base that your IT staff will use to navigate through your cloud assets. 

However, in addition to properly structuring grouping, naming, and tagging for you deployments, your operations teams' ability to efficiently manage large numbers of resource will be greatly improved through the use of querying tools to explore your deployments and find specific resources. 

[Azure Resource Graph](https://docs.microsoft.com/en-us/azure/governance/resource-graph/overview) provides the capability to govern your resources by enabling you to explore your resources using a query mechanism that can scale across all of your organization's subscriptions and management groups. With Azure Resource Graph, you can govern your entire cloud environment. 

### Complex grouping

As the size of your cloud estate grows you may need to support more complicated governance requirements than can be supported using the Azure Enterprise Agreement's Enterprise/Department/Account/Subscription hierarchy. Resource group design allows you to support additional levels of hierarchy within your organization, with the ability to apply policy and access control rules at a resource group level.

As with your subscription design, [Azure Management Groups](../subscriptions/overview.md#management-groups) can help support more complicated organizational structures.

### Governance enforcement

For large cloud deployments, global governance becomes both more important and more complicated to implement. Key is the ability to both automatically apply and enforce governance requirements when deploying resources, as well as updating requirements to existing deployments. 

[Azure Blueprints](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview) enable organizations to support global governance of large cloud estates on the Azure platform. Blueprints move beyond the capabilities provided by standard Azure Resource Manager templates to create complete deployment orchestrations that include role-based access control (RBAC) assignments, policy rules, resource manager templates, and resource group structures. These deployment packages makes it possible for IT and development teams to rapidly deploy new workloads and networking assets that comply with changing organizational policy requirements. Blueprints can also be integrated into CI/CD pipelines which will apply updated governance standards on deployments as they are updated.

## Next steps

Learn how [resource naming and tagging](../resource-tagging/overview.md) are used to further organize and manage your cloud resources.

> [!div class="nextstepaction"]
> [Resource Naming and Tagging](../resource-tagging/overview.md)

