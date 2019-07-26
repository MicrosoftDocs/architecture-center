---
title: "Scaling with multiple Azure subscriptions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn how to scale with multiple Azure subscriptions.
author: alexbuckgit
ms.author: abuck
ms.date: 05/20/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: ready
---

# Scaling with multiple Azure subscriptions

Organizations often need more than one Azure subscription. Subscription resource limits and other governance considerations often require additional subscriptions. Having a strategy for scaling your subscriptions is important.

## Production and preproduction workloads

When deploying your first production workload in Azure, you should start with at least two subscriptions: one for your production environment and one for your preproduction (dev/test) environment.

![A basic subscription model showing keys next to boxes labeled "Production" and "Preproduction"](../../_images/ready/basic-subscription-model.png)

We recommend this approach for several reasons:

- Azure has specific subscription offerings for dev/test workloads. These offerings provide discounted rates on Azure services and licensing.
- Your production and preproduction environments will likely have different sets of Azure policies. Using separate subscriptions makes it simple to apply each distinct policy set at the subscription level.
- You might want certain types of Azure resources in a dev/test subscription for exploration and testing. With a separate subscription, you can use those resource types without making them available in your production environment.
- You can use dev/test subscriptions as isolated sandbox environments. Such sandboxes allow admins and developers to rapidly build up and tear down entire sets of Azure resources. This isolation can also help with data protection and security concerns.
- Acceptable cost thresholds will likely vary between production and dev/test subscriptions.

## Other reasons for multiple subscriptions

Other situations might require additional subscriptions. Keep the following in mind as you expand your cloud estate.

- Subscriptions have different limits for different resource types. For example, the number of virtual networks in a subscription is limited. When a subscription approaches any of its limits, you'll need to create another subscription and put new resources there.

  For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits).

- Each subscription can implement its own policies for deployable resource types.

- Each subscription can implement its own policies for supported regions.

- Subscriptions in public cloud regions and sovereign cloud regions have different limitations. These are often driven by different data-classification levels between environments.

- If you completely segregate different sets of users for security or compliance reasons, you might require separate subscriptions. For example, national government organizations might need to limit a subscription’s access to citizens only.

- Different subscriptions might have different types of offerings, each with its own terms and benefits.

- Trust issues might exist between the owners of a subscription and the owner of resources to be deployed. Using another subscription with different ownership can mitigate these issues.

- Rigid financial or geopolitical controls might require separate financial arrangements for specific subscriptions. These concerns might include considerations of data sovereignty, companies with multiple subsidiaries, or separate accounting and billing for business units in different countries.

- Azure resources created using the classic deployment model should be isolated in their own subscription. The security for classic resources differs from that of resources deployed via Azure Resource Manager. Azure policies can’t be applied to classic resources.

  Service admins using classic resources have the same permissions as role-based access control (RBAC) owners of a subscription. It's difficult to sufficiently narrow these service admins' access in a subscription that mixes classic resources and Resource Manager resources.

You might also opt to create additional subscriptions for other business or technical reasons specific to your organization. There might be some additional costs for data ingress and egress between subscriptions. But this is a relatively low-cost option that some organizations use to separate different workloads.

You can move many types of resources from one subscription to another or use automated deployments to migrate resources to another subscription. For more information, see [Move Azure resources to another resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources).

## Managing multiple subscriptions

If you have only a few subscriptions, managing them independently is relatively simple. But if you have many subscriptions, you should consider creating a management-group hierarchy to simplify managing your subscriptions and resources.

Management groups allow efficient management of access, policies, and compliance for an organization’s subscriptions. Each management group is a container for one or more subscriptions.

Management groups are arranged in a single hierarchy. You define this hierarchy in your Azure Active Directory (Azure AD) tenant to align with your organization’s structure and needs. The top level is called the *root management group*. You can define up to six levels of management groups in your hierarchy. Each subscription is contained by only one management group.

Azure provides four levels of management scope: management groups, subscriptions, resource groups, and resources. Any access or policy applied at one level in the hierarchy is inherited by the levels below it. A resource owner or subscription owner can't alter an inherited policy. This limitation helps improve governance.

By relying on this inheritance model, you can arrange the subscriptions in your hierarchy so that each subscription follows appropriate policies and security controls.

![The four scope levels for organizing your Azure resources](/azure/architecture/cloud-adoption/ready/azure-readiness-guide/media/organize-resources/scope-levels.png)

Any access or policy assignment on the root management group applies to all resources in the directory. Carefully consider which items you define at this scope. Include only the assignments you must have.

When you initially define your management-group hierarchy, you first create the root management group. You then move all existing subscriptions in the directory into the root management group. New subscriptions are always created in the root management group. You can later move them to another management group.

When you move a subscription to an existing management group, it inherits the policies and role assignments from the management-group hierarchy above it. Once you have established multiple subscriptions for your Azure workloads, you should create additional subscriptions to contain Azure services that other subscriptions share.

![Example of a management-group hierarchy](../../_images/ready/management-group-hierarchy.png)

For more information, see [Organizing your resources with Azure management groups](/azure/governance/management-groups).

## Tips for creating new subscriptions

- Identify who will be responsible for creating new subscriptions.
- Decide which resources will be in a subscription by default.
- Decide what all standard subscriptions should look like. Considerations include RBAC access, policies, tags, and infrastructure resources.
- If possible, [use a service principal](/azure/azure-resource-manager/grant-access-to-create-subscription) to create new subscriptions. Define a security group that can request new subscriptions via an automated workflow.
- If you're an Enterprise Agreement (EA) customer, ask Azure support to block creation of non-EA subscriptions for your organization.

## Related resources

- [Azure fundamental concepts](./fundamental-concepts.md).
- [Organize your resources with Azure management groups](/azure/governance/management-groups).
- [Elevate access to manage all Azure subscriptions and management groups](/azure/role-based-access-control/elevate-access-global-admin).
- [Move Azure resources to another resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources).

## Next steps

Review [recommended naming and tagging conventions](./name-and-tag.md) to follow when deploying your Azure resources.

> [!div class="nextstepaction"]
> [Recommended naming and tagging conventions](./name-and-tag.md)
