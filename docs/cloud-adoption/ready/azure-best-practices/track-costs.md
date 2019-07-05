---
title: "Tracking costs across business units, environments, or projects"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Tracking costs across business units, environments, or projects
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/19/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Tracking costs across business units, environments, or projects

[Building a cost-conscious organization](../../organization/cost-conscious-organization.md) requires visibility and properly defined access (or scope) to cost-related data. This best practice article outlines decisions and implementation approaches required to create proper tracking mechanisms.

![Cost-conscious process](../../_images/ready/cost-optimization-process.png)
*Figure 1. Outline of the cost conscious process*

Implementing this visibility across multiple roles and multiple views of the data requires three sets of decisions reflecting in the following sets of implementation instructions:

1. Establish a well-managed environment hierarchy
2. Provide the right level of cost access
3. Additional cost management resources

## Establish a well-managed environment hierarchy

Cost control, much like governance and other management constructs, depends on a well-managed environment. For complex environments, this results in a hierarchy of well-managed environments. Establishing such an environment requires consistent processes regarding the classification and organization of all assets.

Assets (also known as resources) include all virtual machines, data sources, and applications deployed to the cloud. Azure provides several mechanisms for classifying and organizing assets. [Scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md) details options for organizing resources based on multiple criteria to establish a well-managed environment. This article focuses on the application of Azure fundamental concepts to provide cloud cost visibility.

### Classification

**Tagging:** Tagging is an easy means of classifying assets. Tagging associates metadata to a given asset. That metadata can be used to classify the asset based on various data points. When tags are used to classify assets as part of a cost management effort, companies will commonly require the following tags: business unit, department, billing code, geography, environment, project, workload or "Application Categorization." Azure Cost Management can use these tags to create a variety of different views of cost data.

Tagging is a primary means of understanding the data in any cost reporting. Establishing and governing the use of tags is a fundamental component of establishing any well-managed environment. It is also the first step of establishing proper governance of any environment.

The first step to accurately tracking cost information across business units/business units, environments, and projects is to define a tagging standard. The second step is to ensure that tagging standard is consistently applied. The following articles can help accomplish each of these steps:

- [Develop naming and tagging standards](../considerations/name-and-tag.md)
- [Establish a governance MVP to enforce tagging standards](../../governance/journeys/large-enterprise/index.md)

Once assets are classified, the next important prerequisite to accurate cost visibility is resource organization.

### Resource organization

There are several approaches to organizing assets. Establishing a resource organization approach requires perspectives beyond cost management to make sound decisions. The following section outlines a best practice based on the needs of a large enterprise with cost structures spread across business units, geographies, and various IT organizations. A similar best practice for a smaller, less complex organization is available in the [Small-to-medium enterprise governance journey](../../governance/journeys/small-to-medium-enterprise/index.md).

For a large enterprise with the need to view cost data across business unit, geography, environment, and projects the following model for management groups, subscriptions, and resource groups would create a hierarchy that allowed each team to have the right level of visibility to perform their necessary duties. When cost controls are needed to prevent budget overrun, governance tooling like Azure Blueprints or Azure Policy could be applied to the subscriptions within this structure to quickly block future cost errors.

![Diagram of large-enterprise resource organization](../../_images/governance/large-enterprise-resource-organization.png)

In the diagram above, the root of the management group hierarchy contains a node for each business unit. In this example, the multinational company requires visibility into the regional business units of each business unit, creating a node for geography under each business unit in the hierarchy. Within each geography, there is a separate node for production and nonproduction environments to isolate cost, access, and governance controls. To allow for more efficient operations and wiser operations investments, subscriptions are used to further isolate production environments with varying degrees of operational performance commitments. Finally, resource groups are used to capture deployable units of function referred to as applications.

Options not pictured in this best practice diagram:

- Many companies limit operations to a single geo-political region, reducing the need to diversify governance disciplines or cost data based on local data sovereignty requirements. In those cases, a geography node would be unnecessary.
- Some companies prefer to further segregate development, testing, and quality control environments into separate subscriptions.
- When integrating a cloud center of excellence (CCoE) team, there will likely be shared services subscriptions in each geography node to reduce duplicated assets.
- Smaller adoption efforts may have a considerably smaller management hierarchy. It is common to see a single root node for corporate IT, with a single level of subordinate nodes in the hierarchy for various environments. While this is not a violation of best practices for a well-managed environment, it does make it more difficult to provide a least-rights access model for cost control and other important functions.

The remainder of this article assumes the use of the best practice approach in the diagram above. However, the following articles can aid in applying the approach to resource organization that best fits your company:

- [Scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md)
- [Deploying a Governance MVP to govern well-managed environment standards](../../governance/journeys/large-enterprise/index.md)

## Provide the right level of cost access

Managing cost is a team sport. The organization readiness section of the Cloud Adoption Framework defines a small number of core teams and outlines how those teams support cloud adoption efforts. This article expands on the team definitions to define the scope and roles to assign to members of each team for the proper level of visibility into cost management data.

- **Roles:** Roles define what a user can do to various assets
- **Scope:** Scope defines which assets a user can do those things to.

As a general best practice, a least-privilege model to assigning people to various roles and scopes is suggested. The following discussion will outline the suggested configurations for each.

## Roles

Cost Management supports the following built-in roles for each of the following scopes:

- **[Owner](/azure/role-based-access-control/built-in-roles#owner)**. Can view costs and manage everything, including cost configuration.
- **[Contributor](/azure/role-based-access-control/built-in-roles#contributor)**. Can view costs and manage everything, including cost configuration, but excluding access control.
- **[Reader](/azure/role-based-access-control/built-in-roles#reader)**. Can view everything, including cost data and configuration, but cannot make any changes.
- **[Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor)**. Can view costs and manage cost configuration.
- **[Cost Management Reader](/azure/role-based-access-control/built-in-roles#cost-management-reader)** Can view cost data and configuration.

As a general best practice, members of all teams should be assigned the role of Cost Management Contributor. This role grants access to create and manage budgets and exports to more effectively monitor and report on costs. However, members of the
[Cloud Strategy team](../../organization/cloud-strategy.md), who are not involved in setting budgets within the Azure Cost Management tool, should be set to Cost Management Reader only.

## Scope

Once a plan for role assignment has been determined, it can be set at a specific "scope", which grants access to the user, group, service principal, or managed identity. The following list of best practice scope and role settings that, if added, will create the required visibility into cost management. However, this best practice may require minor changes to align to asset organization decisions.

**[Cloud adoption team](../../organization/cloud-adoption.md)**. Responsibilities for ongoing optimization changes will require cost management contributor access at the resource group level.

- **Working environment**. At a minimum, the cloud adoption team should already have [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to all affected resource groups, or at least those groups related to dev/test or ongoing deployment activities. No additional scope setting is required.
- **Production environments**. When proper separation of responsibility has been established, it is unlikely that the cloud adoption team will continue to have access to the resource groups related to their projects. The resource groups that support the production instances of their workloads will need additional scope to give this team visibility into the production cost-impact of their decisions. Setting [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) scope for production resource groups for this team will allow them to monitor costs and set budgets based on usage and ongoing investment in the supported workloads.

**[Cloud Strategy team](../../organization/cloud-strategy.md)**. Responsibilities for tracking costs across multiple projects, business units, and business units will require cost management reader access at the root level of the management group hierarchy.

- Assign [Cost Management Reader](/azure/role-based-access-control/built-in-roles#cost-management-reader) access to this team at the management group. This will ensure ongoing visibility into all deployments associated with the subscriptions governed by that management group hierarchy.

**[Cloud governance team](../../organization/cloud-governance.md)**. Responsibilities for managing cost, budget alignment, and reporting across all adoption efforts, requires cost management contributor at the root level of the management group hierarchy.

- In a well-managed environment, the Cloud Governance team will likely already have a higher degree of access already, making additional scope assignment for [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) unnecessary.

**[Cloud center of excellence](../../organization/cloud-center-excellence.md)**. Responsibility for managing costs related to shared services requires cost management contributor access at the subscription level. Additionally, this team may also require cost management contributor access to resource groups or subscriptions that contain assets deployed by CCoE automations to understand how those automations affect costs.

- **Shared services**. When a cloud center of excellence is engaged, best practice suggests that assets managed by the CCoE be supported from a centralized shared service subscription within a hub/spoke model. In this scenario, the CCoE likely has contributor or owner access to that subscription, making additional scope assignment for [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) unnecessary.
- **CCoE Automation/Controls**. The CCoE common provides controls and automated deployment scripts to cloud adoption teams. The CCoE has a responsibility to understand how these accelerators affect costs. To gain that visibility, the team needs [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) access to any resource groups or subscriptions running those accelerators.

**Cloud operations team**. Responsibility for managing ongoing costs of production environments requires cost management contributor access to all production subscriptions.

- The general best practice puts production and nonproduction assets in separate subscriptions that are governed by nodes of the management group hierarchy associated with production environments. In a well-managed environment, members of the operations team likely have owner or contributor access to production subscriptions already, making the [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) unnecessary.

## Additional cost management resources

Azure Cost Management is a well-documented tool for setting budgets and gaining visibility into cloud costs for Azure or AWS. Once proper access to a well-managed environment hierarchy has been established, the following articles can aid in using that tool to monitor and control costs.

### Get started with Azure Cost Management

For more information on getting started with Azure Cost Management, see [How to optimize your cloud investment with Azure Cost Management](https://docs.microsoft.com/azure/cost-management/cost-mgt-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json).

### Using Azure Cost Management

- [Create and manage budgets](/azure/cost-management/tutorial-acm-create-budgets)
- [Export cost data](/azure/cost-management/tutorial-export-acm-data)
- [Optimize costs based on recommendations](/azure/cost-management/tutorial-acm-opt-recommendations)
- [Use cost alerts to monitor usage and spending](/azure/cost-management/cost-mgt-alerts-monitor-usage-spending)

### Using Azure Cost Management to govern AWS costs

- [AWS Cost and Usage report integration](/azure/cost-management/aws-integration-set-up-configure)
- [Manage AWS Costs](/azure/cost-management/aws-integration-manage)

### Help establishing access, roles, and scope

- [Understanding cost management scope](/azure/cost-management/understand-work-scopes)
- [Setting scope for a resource group](/azure/role-based-access-control/quickstart-assign-role-user-portal)
