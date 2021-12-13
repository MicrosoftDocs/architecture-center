---
title: Cost governance for an Azure workload
description: Understand how centralized governance functions in Azure can support your team with cost management. Follow organizational policies that define cost boundaries.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Governance
Governance can assist with cost management. This work will benefit your ongoing cost review process and will offer a level of protection for new resources.

## Understand how centralized governance functions can support your team

Centralized governance can relieve some of the burden related to on-going cost monitoring and optimization. However, that is an augmentation of the workload team's responsibilities, not a replacement. For an understanding of how centralized cloud governance teams operate, see the Cloud Adoption Framework's [Govern methodology](/azure/cloud-adoption-framework/govern/methodology).

- For more detailed information on cost optimization, see the section on [Cost Management discipline](/azure/cloud-adoption-framework/govern/cost-management/).
- For an example of the types of guardrails provided by a governance team, see the narrative for [improving the cost management discipline](/azure/cloud-adoption-framework/govern/cost-management/discipline-improvement), which includes examples of suggested tags and policies for improving cost governance.
- If your team isn't supported by centralized governance teams, see [Cloud governance function](/azure/cloud-adoption-framework/organize/cloud-governance) to better understand the types of activities your team may need to consider including in each sprint.

## Follow organizational policies that define cost boundaries

Use policies to ensure compliance to the identified cost boundaries. Also, it eliminates the need for manual resource approval and speeds up the total provisioning time.

Azure Policy can set rules on management groups, subscriptions, and resources groups. The policies control clouds service resource SKU size, replication features, and locations that are allowed. Use policies to prevent provisioning of expensive resources. Identify the built-in Azure policies that can help lower cost. For additional control, create custom policies.

For more information, see [Create management groups for resource organization and management](/azure/governance/management-groups/create).

Control the group who can manage resources in the subscription, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

Set limits or quotas to prevent unexpected costs, For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

## Enforce resource tagging
Use tags on resources and resource groups to track the incurred costs. Identify the service meters that can't be tagged or viewed in the cost analysis tool in Azure portal.

The advantages of tagging include:
- The cost can be reported to an owner, an application, a business department or a project initiative. This feature is useful because the overall cost can span multiple resources, locations, and subscriptions.
- Filter information. This filtering can be used in cost analysis tool in Azure portal allowing you to get granular reports.

There are some limitations:
- Not all Azure resources can be tagged and not all taggable resources in Azure are accounted for in the Azure cost analysis tool.
