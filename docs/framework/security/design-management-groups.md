---
title: Establish segmentation with management groups
description: Strategies using management groups to manage resources across multiple subscriptions consistently and efficiently.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories: 
  - management-and-governance
subject:
  - security
ms.custom:
  - article
---

# Establish segmentation with management groups

Management groups can manage resources across multiple subscriptions consistently and efficiently. However, due to its flexibility, your design can become complex and compromise security and operations.

The recommendations in this article are based on an example reference model. Start with this model and adapt it to your organization’s needs. For more information, see [Enterprise segmentation strategy](design-segmentation.md).

## Support your segmentation strategy with management groups

It's recommended that you align the top level of management groups into a simple enterprise segmentation strategy and limit the levels to no more than two. 

In the example reference, there are enterprise-wide resources used by all segments, a set of core services that share services, additional segments for each workload. 

An approach is to use these management groups:

- Root management group for enterprise-wide resources.

    Use the root management group to include identities that have the requirement to apply policies across every resource. For example, regulatory requirements, such as restrictions related to data sovereignty. This group is effective in by applying policies, permissions, tags, across all subscriptions. 
    > [!CAUTION]
    > Be careful when using the root management group because the policies can affect all resources on Azure and potentially cause downtime or other negative impacts. For considerations, see [Use root management group with caution](#use-root-management-group-with-caution) later in this article.
    >
    > For complete guidance about using management groups for an enterprise, see [CAF: Management group and subscription organization](/azure/cloud-adoption-framework/ready/enterprise-scale/management-group-and-subscription-organization).

- Management group for each workload segment.

    Use a separate management group for teams with limited scope of responsibility. This group is typically required because of organizational boundaries or regulatory requirements.

- Root or segment management group for the core set of services.  


## Use root management group with caution
Use the root management group to drive consistency across the enterprise by applying policies, permissions, tags, across all subscriptions. Care must be taken when planning and implementing assignments to the root management group. This group can affect all resources on Azure and potentially cause downtime or other negative impacts on productivity in the event of errors or unanticipated effects. 

Select enterprise-wide identities that have a clear requirement to be applied across all resources. These requirements could be for regulatory reasons. Also, select identities that have near-zero negative impact on operations. For example, policy with audit effect, tag assignment, Azure RBAC permissions assignments that have been carefully reviewed.

Use a dedicated service principal name (SPN) to execute management group management operations, subscription management operations, and role assignment. SPN reduces the number of users who have elevated rights and follows least-privilege guidelines. Assign the **User Access Administrator** at the root management group scope (/) to grant the SPN just mentioned access at the root level. After the SPN is granted permissions, the **User Access Administrator** role can be safely removed. In this way, only the SPN is part of the **User Access Administrator** role.

Assign **Contributor** permission to the SPN, which allows tenant-level operations. This permission level ensures that the SPN can be used to deploy and manage resources to any subscription within your organization.

Limit the number of Azure Policy assignments made at the root management group scope (/). This limitation minimizes debugging inherited policies in lower-level management groups.

Don't create any subscriptions under the root management group. This hierarchy ensures that subscriptions don't only inherit the small set of Azure policies assigned at the root-level management group, which don't represent a full set necessary for a workload.
    
> [!IMPORTANT] 
> Plan, test, and validate all enterprise-wide changes on the root management group before applying (policy, tags, Azure RBAC model, and so on). You can use a test lab. This can be representative lab tenant or lab segment in production tenant. Another option is to use a production pilot. This can be a segment management group or designated subset in subscription(s) management group. Validate changes to make sure the requirements have the desired effect.

For more information, reference [Use root management group carefully](./governance.md#use-root-management-group-carefully).
