---
title: "Track costs across business units, environments, or projects"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Tracking costs across business units, environments, or projects
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/19/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: ready
---

# Track costs across business units, environments, or projects

[Building a cost-conscious organization](../../organization/cost-conscious-organization.md) requires visibility and properly defined access (or scope) to cost-related data. This best-practice article outlines decisions and implementation approaches to creating tracking mechanisms.

![Outline of the cost-conscious process](../../_images/ready/cost-optimization-process.png)

## Establish a well-managed environment hierarchy

Cost control, much like governance and other management constructs, depends on a well-managed environment. Establishing such an environment (especially a complex one) requires consistent processes in the classification and organization of all assets.

Assets (also known as resources) include all virtual machines, data sources, and applications deployed to the cloud. Azure provides several mechanisms for classifying and organizing assets. [Scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md) details options for organizing resources based on multiple criteria to establish a well-managed environment. This article focuses on the application of Azure fundamental concepts to provide cloud cost visibility.

### Classification

*Tagging* is an easy way to classify assets. Tagging associates metadata to an asset. That metadata can be used to classify the asset based on various data points. When tags are used to classify assets as part of a cost management effort, companies often need the following tags: business unit, department, billing code, geography, environment, project, and workload or "application categorization." Azure Cost Management can use these tags to create different views of cost data.

Tagging is a primary way to understand the data in any cost reporting. It's a fundamental part of any well-managed environment. It's also the first step in establishing proper governance of any environment.

The first step in accurately tracking cost information across business units, environments, and projects is to define a tagging standard. The second step is to ensure that the tagging standard is consistently applied. The following articles can help you accomplish each of these steps:

- [Develop naming and tagging standards](../considerations/name-and-tag.md)
- [Establish a governance MVP to enforce tagging standards](../../governance/journeys/large-enterprise/index.md)

### Resource organization

There are several approaches to organizing assets. This section outlines a best practice based on the needs of a large enterprise with cost structures spread across business units, geographies, and IT organizations. A similar best practice for a smaller, less complex organization is available in [Small-to-medium enterprise governance journey](../../governance/journeys/small-to-medium-enterprise/index.md).

For a large enterprise, the following model for management groups, subscriptions, and resource groups will create a hierarchy that allows each team to have the right level of visibility to perform their duties. When the enterprise needs cost controls to prevent budget overrun, it can apply governance tooling like Azure Blueprints or Azure Policy to the subscriptions within this structure to quickly block future cost errors.

![Diagram of resource organization for a large enterprise](../../_images/governance/large-enterprise-resource-organization.png)

In the preceding diagram, the root of the management group hierarchy contains a node for each business unit. In this example, the multinational company needs visibility into the regional business units, so it creates a node for geography under each business unit in the hierarchy.

Within each geography, there's a separate node for production and nonproduction environments to isolate cost, access, and governance controls. To allow for more efficient operations and wiser operations investments, the company uses subscriptions to further isolate production environments with varying degrees of operational performance commitments. Finally, the company uses resource groups to capture deployable units of a function, called applications.

The diagram shows best practices but doesn't include these options:

- Many companies limit operations to a single geopolitical region. That approach reduces the need to diversify governance disciplines or cost data based on local data-sovereignty requirements. In those cases, a geography node is unnecessary.
- Some companies prefer to further segregate development, testing, and quality control environments into separate subscriptions.
- When a company integrates a cloud center of excellence (CCoE) team, shared services subscriptions in each geography node can reduce duplicated assets.
- Smaller adoption efforts might have a much smaller management hierarchy. It's common to see a single root node for corporate IT, with a single level of subordinate nodes in the hierarchy for various environments. This isn't a violation of best practices for a well-managed environment. But it does make it more difficult to provide a least-rights access model for cost control and other important functions.

The rest of this article assumes the use of the best-practice approach in the preceding diagram. However, the following articles can help you apply the approach to a resource organization that best fits your company:

- [Scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md)
- [Deploying a Governance MVP to govern well-managed environment standards](../../governance/journeys/large-enterprise/index.md)

## Provide the right level of cost access

Managing cost is a team activity. The organization readiness section of the Cloud Adoption Framework defines a small number of core teams and outlines how those teams support cloud adoption efforts. This article expands on the team definitions to define the scope and roles to assign to members of each team for the proper level of visibility into cost management data.

- *Roles* define what a user can do to various assets.
- *Scope* defines which assets (user, group, service principal, or managed identity) a user can do those things to.

As a general best practice, we suggest a least-privilege model in assigning people to various roles and scopes.

### Roles

Azure Cost Management supports the following built-in roles for each scope:

- [Owner](/azure/role-based-access-control/built-in-roles#owner). Can view costs and manage everything, including cost configuration.
- [Contributor](/azure/role-based-access-control/built-in-roles#contributor). Can view costs and manage everything, including cost configuration, but excluding access control.
- [Reader](/azure/role-based-access-control/built-in-roles#reader). Can view everything, including cost data and configuration, but can't make any changes.
- [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor). Can view costs and manage cost configuration.
- [Cost Management Reader](/azure/role-based-access-control/built-in-roles#cost-management-reader) Can view cost data and configuration.

As a general best practice, members of all teams should be assigned the role of Cost Management Contributor. This role grants access to create and manage budgets and exports to more effectively monitor and report on costs. However, members of the
[cloud strategy team](../../organization/cloud-strategy.md) should be set to Cost Management Reader only. That's because they're not involved in setting budgets within the Azure Cost Management tool.

### Scope

The following scope and role settings will create the required visibility into cost management. This best practice might require minor changes to align to asset organization decisions.

- [Cloud adoption team](../../organization/cloud-adoption.md). Responsibilities for ongoing optimization changes require Cost Management Contributor access at the resource group level.

  - **Working environment**. At a minimum, the cloud adoption team should already have [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to all affected resource groups, or at least those groups related to dev/test or ongoing deployment activities. No additional scope setting is required.
  - **Production environments**. When proper separation of responsibility has been established, the cloud adoption team probably won't continue to have access to the resource groups related to its projects. The resource groups that support the production instances of their workloads will need additional scope to give this team visibility into the production cost impact of its decisions. Setting the [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) scope for production resource groups for this team will allow the team to monitor costs and set budgets based on usage and ongoing investment in the supported workloads.

- [Cloud strategy team](../../organization/cloud-strategy.md). Responsibilities for tracking costs across multiple projects and business units require Cost Management Reader access at the root level of the management group hierarchy.

  - Assign [Cost Management Reader](/azure/role-based-access-control/built-in-roles#cost-management-reader) access to this team at the management group. This will ensure ongoing visibility into all deployments associated with the subscriptions governed by that management group hierarchy.

- [Cloud governance team](../../organization/cloud-governance.md). Responsibilities for managing cost, budget alignment, and reporting across all adoption efforts requires Cost Management Contributor access at the root level of the management group hierarchy.

  - In a well-managed environment, the cloud governance team likely has a higher degree of access already, making additional scope assignment for [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) unnecessary.

- [Cloud center of excellence](../../organization/cloud-center-excellence.md). Responsibility for managing costs related to shared services requires Cost Management Contributor access at the subscription level. Additionally, this team might require Cost Management Contributor access to resource groups or subscriptions that contain assets deployed by CCoE automations to understand how those automations affect costs.

  - **Shared services**. When a cloud center of excellence is engaged, best practice suggests that assets managed by the CCoE are supported from a centralized shared service subscription within a hub/spoke model. In this scenario, the CCoE likely has contributor or owner access to that subscription, making additional scope assignment for [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) unnecessary.
  - **CCoE automation/controls**. The CCoE commonly provides controls and automated deployment scripts to cloud adoption teams. The CCoE has a responsibility to understand how these accelerators affect costs. To gain that visibility, the team needs [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) access to any resource groups or subscriptions running those accelerators.

- **Cloud operations team**. Responsibility for managing ongoing costs of production environments requires Cost Management Contributor access to all production subscriptions.

  - The general best practice puts production and nonproduction assets in separate subscriptions that are governed by nodes of the management group hierarchy associated with production environments. In a well-managed environment, members of the operations team likely have owner or contributor access to production subscriptions already, making the [Cost Management Contributor](/azure/role-based-access-control/built-in-roles#cost-management-contributor) role unnecessary.

## Additional cost management resources

Azure Cost Management is a well-documented tool for setting budgets and gaining visibility into cloud costs for Azure or AWS. After you establish access to a well-managed environment hierarchy, the following articles can help you use that tool to monitor and control costs.

### Get started with Azure Cost Management

For more information on getting started with Azure Cost Management, see [How to optimize your cloud investment with Azure Cost Management](https://docs.microsoft.com/azure/cost-management/cost-mgt-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json).

### Use Azure Cost Management

- [Create and manage budgets](/azure/cost-management/tutorial-acm-create-budgets)
- [Export cost data](/azure/cost-management/tutorial-export-acm-data)
- [Optimize costs based on recommendations](/azure/cost-management/tutorial-acm-opt-recommendations)
- [Use cost alerts to monitor usage and spending](/azure/cost-management/cost-mgt-alerts-monitor-usage-spending)

### Use Azure Cost Management to govern AWS costs

- [AWS Cost and Usage report integration](/azure/cost-management/aws-integration-set-up-configure)
- [Manage AWS costs](/azure/cost-management/aws-integration-manage)

### Establish access, roles, and scope

- [Understanding cost management scope](/azure/cost-management/understand-work-scopes)
- [Setting scope for a resource group](/azure/role-based-access-control/quickstart-assign-role-user-portal)
