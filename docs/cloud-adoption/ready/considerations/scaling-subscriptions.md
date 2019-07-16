---
title: "Scaling with multiple Azure subscriptions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn how to scale with multiple Azure subscriptions.
author: alexbuckgit
ms.author: abuck
ms.date: 05/20/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Scaling with multiple Azure subscriptions

Organizations often need more than one Azure subscription to meet their needs. Subscription resource limits and other governance considerations often necessitate additional subscriptions. It's important that you have a strategy for scaling your subscriptions when the need arises.

## Production and preproduction workloads

When deploying your first production workload in Azure, you should start with at least two subscriptions: one for your production environment and one for your preproduction (dev/test) environment.

![A basic subscription model showing images labeled "Prod" and "Pre-Prod"](../../_images/ready/basic-subscription-model.png)

We recommend this approach for several reasons:

- Azure has specific subscription offerings for dev/test workloads. These offerings provide discounted rates on Azure services and licensing.
- Your production and preproduction environments will likely have different sets of defined Azure policies. By using separate subscriptions, you can apply distinct policy sets at the subscription level.
- You might want to make available certain types of Azure resources in a dev/test subscription for exploration and testing. Separate subscriptions allow this without making those resource types available in your production environment.
- You can use dev/test subscriptions as isolated sandbox environments. That isolation allows administrators and developers to rapidly build up and tear down entire sets of Azure resources. This isolation can also help with data protection and security concerns.
- Acceptable cost thresholds will likely vary between production and dev/test subscriptions.

## Other reasons for multiple subscriptions

Other situations can require additional subscriptions. Keep the following in mind as you expand your cloud estate.

- Subscriptions have different limits for different resource types. For example, there's a limit to the number of virtual networks in a subscription. When a subscription approaches any of its limits, you will need to create another subscription and spill over new resources into that subscription. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits).

- Each subscription can have its own policies for deployable resource types.

- Each subscription can have its own policies for which regions it supports.

- Subscriptions in public cloud regions and sovereign cloud regions have different limitations. These limitation are often driven by different data-classification levels between environments.

- If you completely segregate different sets of users for security or compliance reasons, you might require separate subscriptions. For example, government organizations might need to limit a subscription’s access to national citizens only.

- Different subscriptions might have different types of offerings, each with its own terms and benefits.

- Trust issues might exist between the owners of a subscription and the owner of resources to be deployed. Using a subscription with different ownership can mitigate these issues.

- Strict financial or geopolitical controls might require separate financial arrangements for specific subscriptions.  Possible reasons include considerations of data sovereignty, companies having multiple subsidiaries, or business units having separate accounting and billing in different countries.

- Azure resources created using the classic deployment model should be isolated in their own subscription. The security for classic resources differs from that of resources deployed via Azure Resource Manager. Azure policies can’t be applied to classic resources.

  Also, service admins using the Azure classic portal have the same permissions as role-based access control (RBAC) owners of a subscription. Because of these permissions, it's difficult to sufficiently narrow their access in a subscription that mixes classic resources and Resource Manager resources.

You might also opt to create additional subscriptions for other business or technical reasons specific to your organization. Although there can be some additional costs for data flow between subscriptions, this is a relatively low-cost option that some organizations use to separate different workloads for various reasons.

You can also move many types of resources from one subscription to another or use automated deployments to migrate resources to another subscription. For more information, see [Move Azure resources to another resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources).

## Managing multiple subscriptions

If you have only a few subscriptions, managing them independently is relatively simple. If you increase the number of subscriptions you’re using, you should consider creating a management group hierarchy to simplify managing your subscriptions and resources.

Management groups allow efficient management of access, policies, and compliance for an organization’s subscriptions. Each management group is a container for one or more subscriptions.

Management groups are arranged in a single hierarchy. You define this hierarchy in your Azure AD tenant to align with your organization’s structure and needs. The top level is called the *Root management group*. You can define up to six levels of management groups in your hierarchy. Each subscription is contained by only one management group.

Azure provides four levels of management scope: management groups, subscriptions, resource groups, and resources. Any access or policies applied at one level in the hierarchy are inherited by the levels below it. An inherited policy can't be altered by the resource owner or subscription owner, enabling improved governance. By relying on this inheritance model, you can arrange the subscriptions in your hierarchy so that each subscription complies with the policies and security controls appropriate for that subscription.

![Scope levels for organizing your Azure resources](/azure/architecture/cloud-adoption/ready/azure-readiness-guide/media/organize-resources/scope-levels.png)

Any access or policy assignment on the Root management group applies to all resources in the directory. Items defined at this scope should be carefully considered, and any assignments at this scope should be ones you must have only. When initially defining your management group hierarchy, you first create the Root management group, and then you move all existing subscriptions in the directory into the Root management group. New subscriptions are always created in the root management group. They can then be moved to another management group.

When you move a subscription to an existing management group, it inherits the policies and role assignments from the management group hierarchy above it. Once you have established multiple subscriptions for your Azure workloads, you should create additional subscriptions to contain Azure services that are shared by the other subscriptions.

![Example of a management group hierarchy](../../_images/ready/management-group-hierarchy.png)

For more information, see [Organizing your resources with Azure management groups](/azure/governance/management-groups).

## Tips for creating new subscriptions

- Identify who will be responsible for creating new subscriptions.
- Decide which resources will be in a subscription by default.
- Decide what all "standard" subscriptions should look like, including RBAC access, policies, tags, and infrastructure resources.
- If possible, [use a service principal](/azure/azure-resource-manager/grant-access-to-create-subscription) for creating new subscriptions. Define a security group that can request new subscriptions via an automated workflow.
- If you have an enterprise agreement, ask Azure support to block creation of non-EA subscriptions for your organization.

## Related resources

- [Azure fundamental concepts](./fundamental-concepts.md).
- [Organize your resources with Azure management groups](/azure/governance/management-groups).
- [Elevate access to manage all Azure subscriptions and management groups](/azure/role-based-access-control/elevate-access-global-admin).
- [Move Azure resources to another resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources).

## Next steps

Review [recommended naming and tagging conventions](./name-and-tag.md) to follow when deploying your Azure resources.

> [!div class="nextstepaction"]
> [Recommended naming and tagging conventions](./name-and-tag.md)
