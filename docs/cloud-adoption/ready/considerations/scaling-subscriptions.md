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

Organizations often need more than one subscription in Azure to meet their needs. Subscription resource limits and other governance considerations often require additional subscriptions. It is important that you have a strategy for scaling your subscriptions when the need arises.

## Production and preproduction workloads

When deploying your first production workload in Azure, you should start with at least two subscriptions: one for your production environment, and one for your preproduction (dev/test) environment.

![A basic subscription model](../../_images/ready/basic-subscription-model.png)

This approach is recommended for several reasons:

- Azure has specific subscription offerings for dev/test workloads. These offerings provide discounted rates on Azure services and licensing.
- You will likely have a different set of Azure policies defined for your production environment than for your preproduction environment. Using separate subscriptions makes it simple to apply each distinct policy set at the subscription level.
- You may want to enable certain types of Azure resources in a dev/test subscription for exploration and testing. Using a separate subscription allows this without making those resource types available in your production environment.
- You can use dev/test subscriptions as isolated sandbox environments, allowing administrators and developers to rapidly build up and tear down entire sets of Azure resources. This isolation can also help with data protection and security concerns.
- Acceptable cost thresholds will likely vary between production and dev/test subscriptions.

## Other reasons for multiple subscriptions

Other situations can require additional subscriptions. Keep these in mind as you expand your cloud estate.

- Subscriptions have different limits for different resource types. For example, there is a limit to the number of virtual networks in a subscription. When a subscription approaches any of these limits, you will need to create another subscription and "spill over" new resources into that subscription. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits).

- Different subscriptions can implement different policies for the types of resources that can be deployed.

- Different subscriptions can implement different policies for which regions can be used.

- Subscriptions in public cloud regions and sovereign cloud regions have different limitations, often driven by different data classification levels between environments.

- The need to completely segregate different sets of users for security or compliance reasons can require separate subscriptions. For example, government organizations may need to limit a subscription’s access to national citizens only.

- Different subscriptions may have different offer types with their own terms and benefits.

- Trust issues may exist between the owners of a subscription and the owner of resources to be deployed. Using another subscription with different ownership can mitigate these issues.

- Rigid financial or geopolitical controls may require separate financial arrangements for specific subscriptions. These concerns may include data sovereignty considerations, companies with multiple subsidiaries, or separate accounting and billing for business units in different countries.

- Classic Azure resources should be isolated to their own subscription. The security for classic resources is different from Azure resources deployment via Resource Manager. Azure policies can’t be applied to classic resources. And since classic Service Administrators also implicitly have the same permissions as RBAC owners of a subscription, it is difficult to sufficiently narrow their access in a subscription that mixes classic resources and Resource Manager resources.

You may also opt to create additional subscriptions for other business or technical reasons specific to your organization. Although there can be some additional costs for data ingress and egress between subscriptions, this is a relatively low-cost option that some organizations use to separate different workloads for various reasons. You can also move many types of resources from one subscription to another or use automated deployments to migrate resources to another subscription. For more information, see [Move Azure resources to another resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources).

## Managing multiple subscriptions

If you only have a few subscriptions, it is relatively simple to manage them independently. Once you increase the number of subscriptions you’re using, you should consider creating a management group hierarchy to simplify the management of your subscriptions and resources.

Management groups enable efficient management of access, policies, and compliance for an organization’s subscriptions. Each management group is a container for one or more subscriptions. Management groups are arranged in a single hierarchy you define in your Azure AD tenant to align with your organization’s structure and needs. The top level is called the **Root management group**, and you can define up to six levels of management groups in your hierarchy. Each subscription is contained by only one management group.

Azure provides four levels of management scope: management groups, subscriptions, resource groups, and resources. Any access or policies applied at one level in the hierarchy are inherited by the levels below it. An inherited policy cannot be altered by the resource owner or subscription owner, enabling improved governance. By relying on this inheritance model, you can arrange the subscriptions in your hierarchy so that each subscription complies with the policies and security controls appropriate for that subscription.

![Scope levels for organizing your Azure resources](/azure/architecture/cloud-adoption/ready/azure-readiness-guide/media/organize-resources/scope-levels.png)

Any access or policy assignment on the Root management group applies to all resources in the directory. Items defined at this scope should be carefully considered, and any assignments at this scope should be "Must Have" only. When initially defining your management group hierarchy, first the Root management group is created, and then all existing subscriptions in the directory are moved into the Root management group. New subscriptions are always created in the root management group and then can be moved to another management group.

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

- [Azure fundamental concepts](./fundamental-concepts.md)
- [Organize your resources with Azure management groups](/azure/governance/management-groups)
- [Elevate access to manage all Azure subscriptions and management groups](/azure/role-based-access-control/elevate-access-global-admin)
- [Move Azure resources to another resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources)

## Next steps

Review [recommended naming and tagging conventions](./name-and-tag.md) to follow when deploying your Azure resources.

> [!div class="nextstepaction"]
> [Recommended naming and tagging conventions](./name-and-tag.md)
