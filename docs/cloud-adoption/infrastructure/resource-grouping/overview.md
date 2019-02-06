---
title: "Fusion: Resource grouping" 
description: Discussion of resource grouping when planning an Azure migrations
author: rotycenh
ms.date: 12/27/2018
---

# Fusion: Resource grouping

Azure [subscription design](../subscriptions/overview.md) defines how you organize your cloud assets in relation to your organization's overall structure. In addition, integrating your existing IT management standards and your organizational policies depends on how you deploy and organize cloud resources within a subscription.

The tools available to implement your resource deployment, grouping, and management designs vary by cloud platform. In general, each solution includes the following features:

- A logical grouping mechanism below the subscription or account level.
- The ability to deploy resources programmatically with APIs.
- Templates for creating standardized deployments.
- The ability to deploy policy rules at the subscription, account, and resource grouping levels.

## Resource grouping decision guide

![Plotting resource grouping options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-resource-grouping.png)

Jump to: [Cloud Native (Resource Groups)](#cloud-native-resource-groups) | [Deployment grouping (templated deployments)](#deployment-grouping-templated-deployments) | [Deployment configuration](#deployment-configuration) | [Query and govern](#query-and-govern) | [Complex grouping](#complex-grouping) | [Governance enforcement](#governance-enforcement)

Resource deployment and grouping decisions are primarily driven by these factors: post-migration digital estate size, business or environmental complexity that doesn't fit neatly within your existing subscription design approaches, or the need to enforce governance over time after resources have been deployed. More advanced resource grouping designs require an increased effort to ensure accurate grouping, and this results in an increase in the time spent on change management and tracking.

## Basic grouping

In Azure, [resource groups](/azure/azure-resource-manager/resource-group-overview#resource-groups) are a core resource organization mechanism to logically group resources within a subscription.

Resource groups act as containers for resources with a common lifecycle or shared management constraints such as policy or role-based access control (RBAC) requirements. Resource groups can't be nested, and resources can only belong to one resource group. Some actions can act on all resources in a resource group. For example, deleting a resource group removes all resources within that group. There are common patterns when creating resource groups, commonly divided into two categories:

- Traditional IT workloads: Most often grouped by items within the same lifecycle, such as an application. Grouping by application allows for individual application management.
- Agile IT workloads: Focus on external customer-facing cloud applications. These resource groups often reflect the functional layers of deployment (such as web tier or app tier) and management.

## Deployment consistency

Building on top of the base resource grouping mechanism, most cloud platforms provide a system for using templates to deploy your resources to the cloud environment. You can use templates to create consistent organization and naming conventions when deploying workloads, enforcing those aspects of your resource deployment and management design.

[Azure Resource Manager templates](/azure/azure-resource-manager/resource-group-overview#template-deployment) allow you to repeatedly deploy your resources in a consistent state using a predetermined configuration and resource group structure. Resource Manager templates help you define a set of standards as a basis for your deployments.

For example, you can have a standard template for deploying a web server workload that contains two virtual machines as web servers combined with a load balancer to manage traffic between the servers. You can then reuse this template to create structurally identical deployments whenever a new web server workload is needed, only changing the deployment name and IP addresses involved.

Note that you can also programmatically deploy these templates and integrate them with your CI/CD systems.

## Policy consistency

To ensure that governance policies are applied when resources are created, part of resource grouping design involves using a common configuration when deploying resources.

By combining resource groups and standardized resource manager templates, you can enforce standards for what settings are required in a deployment and what [Azure Policy](/azure/governance/policy/overview) rules are applied to each resource group or resource.

For example, you may have a requirement that all virtual machines deployed within your subscription connect to a common subnet managed by your central IT team. You can create a standard template for deploying workload VMs which would create a separate resource group for the workload and deploy the required VMs there. This resource group would have a policy rule to only allow network interfaces within the resource group to be joined to the shared subnet.

For a more in-depth discussion of enforcing your policy decisions within a cloud deployment, see [Policy enforcement](../policy-enforcement/overview.md).

## Hierarchical consistency

As the size of your cloud estate grows, you may need to support more complicated governance requirements than can be supported using the Azure Enterprise Agreement's Enterprise/Department/Account/Subscription hierarchy. Resource groups allows you to support additional levels of hierarchy within your organization, applying Azure Policy rules and access controls at a resource group level.

[Azure Management Groups](../subscriptions/overview.md#management-groups) can support more complicated organizational structures by overlaying an alternative hierarchy on top of your enterprise agreement's structure. This allows subscriptions, and the resources they contain, to support access control and policy enforcement mechanisms organized to match your business organizational requirements.

## Automated consistency

For large cloud deployments, global governance becomes both more important and more complex. It is crucial to automatically apply and enforce governance requirements when deploying resources, as well as meet updated requirements for existing deployments.

[Azure Blueprints](/azure/governance/blueprints/overview) enable organizations to support global governance of large cloud estates in Azure. Blueprints move beyond the capabilities provided by standard Azure Resource Manager templates to create complete deployment orchestrations capable of deploying resources and applying policy rules. Blueprints supports versioning, the ability to make apply updates to all subscriptions where the blueprint was used, and the ability to lock down deployed subscriptions to avoid the unauthorized creation and modification of resources.

These deployment packages allow IT and development teams to rapidly deploy new workloads and networking assets that comply with changing organizational policy requirements. Blueprints can also be integrated into CI/CD pipelines to apply revised governance standards to deployments as they are updated.

## Next steps

Learn how resource naming and tagging are used to further organize and manage your cloud resources.

> [!div class="nextstepaction"]
> [Resource naming and tagging](../resource-tagging/overview.md)
