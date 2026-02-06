This article describes four deployment patterns that you can choose from when you deploy Microsoft Fabric. Learn about considerations, recommendations, and potential nonreversible decisions for each deployment pattern.

The following design areas are outlined for each Fabric deployment pattern:

- Governance
- Security
- Administration
- DevOps
- Usability
- Performance and scale
- Billing and cost management

## Levels in a Fabric deployment

A Fabric deployment has four levels: [Tenant](/fabric/enterprise/licenses#tenant), [capacity](/fabric/get-started/workspaces), [workspace](/fabric/get-started/workspaces), and [item](/fabric/get-started/fabric-home). At the top level is the Fabric tenant. Each tenant can have one or more capacities, each capacity can contain one or more workspaces, and each workspace can contain zero or more Fabric items.

An organization's structure or objectives in the areas of security, scale, governance, and application lifecycle might influence its choice of deployment pattern. Different deployment patterns offer varying flexibility and emphasis in the levels of a deployment.

For example, an organization can use [domains](/fabric/governance/domains) to group workspaces in Fabric. Similarly, if an organization must have a centralized option that it can use to collaborate and to find content, a [OneLake data hub](/fabric/get-started/onelake-data-hub) in Fabric offers a centralized access point and is integrated with other familiar products, like Microsoft Teams and Excel.

In Fabric, a large organization that has business units in separate geographical locations can use capacities to control where its data resides. It can manage a business unit that operates from a different geographical location as a single unit by using Fabric domains because domains can span workspaces that are in different regions.

For more information about Fabric levels and their role in choosing a deployment pattern, see [Microsoft Fabric concepts and licenses](/fabric/enterprise/licenses).

## How Fabric deployment patterns align

All Fabric deployment patterns:

- Use Fabric workspaces as boundaries for scale, governance, and security.
- Use [Fabric domains](/fabric/governance/domains) for delegation, to manage multiple workspaces that might belong to the same business unit, or when data that belongs to a business domain spans more than one workspace. You can set some tenant-level settings for managing and governing data [at the domain level](/fabric/governance/domains#domain-settings-delegation) and use domain-specific configuration for those settings.
- Use Fabric capacities to scale compute resources while provisioning dedicated capacities per workspace when specific performance levels must be met.
- Extend to use equivalent features from a Microsoft Cloud (Microsoft Azure, Microsoft 365, and others) when a feature isn't available in Fabric.
- Use a [OneLake data hub](/fabric/get-started/onelake-data-hub) to promote discovery and the use of data assets.
- Use OneSecurity to set up data security policies for data assets.

### Scenarios based on business requirements

This article uses the following scenarios to describe how each deployment pattern can address various business requirements:

- **Scenario 1**: For organizations that want to have faster (or slower) time to market by organizing teams that can cross-collaborate, with lower restrictions on data usage. In this scenario, an organization can benefit by using a *monolithic* deployment pattern. The organization operates in and manages a single workspace. For more information, see [Pattern 1: Monolithic deployment](#pattern-1-monolithic-deployment).
- **Scenario 2**: For organizations that want to provide isolated environments for teams to work in, with a central team that is responsible for providing and managing infrastructure. This scenario also suits organizations that want to implement data mesh. In this scenario, an organization can implement *multiple workspaces* that either use a shared capacity or have separate capacities. For more information, see [Pattern 2: Multiple workspaces backed by a single Fabric capacity](#pattern-2-multiple-workspaces-backed-by-a-single-fabric-capacity) and [Pattern 3: Multiple workspaces backed by separate capacities](#pattern-3-multiple-workspaces-backed-by-separate-capacities).
- **Scenario 3**: For organizations that want an entirely decentralized model that gives business units or teams the freedom to control and manage their own data platforms. In this scenario, an organization can choose a deployment model in which it uses *separate workspaces*, each with dedicated capacity, or possibly with multiple Fabric tenants. For more information, see [Pattern 3: Multiple workspaces backed by separate capacities](#pattern-3-multiple-workspaces-backed-by-separate-capacities) and [Pattern 4: Multiple Fabric tenants](#pattern-4-multiple-fabric-tenants).
- **Scenario 4**: An organization might choose to use a hybrid approach in which it combines multiple patterns to achieve its requirements. For example, an organization might set up a single workspace for specific business units (a monolithic deployment pattern) while using separate, dedicated workspaces and separate capacities for other business units.

## Pattern 1: Monolithic deployment

In this deployment pattern, you provision a single workspace to cater to all your use cases. All business units work within the same, single workspace.

:::image type="content" source="../_images/fabric-deployment-pattern-1-monolithic-deployment.svg" alt-text="Diagram that shows a single Fabric tenant that has a single capacity and a single workspace." border="false":::

When you provision a single Fabric capacity and attach a single workspace to it, the following points are true:

- All Fabric items share the same provisioned capacity. The amount of time a query or job takes to finish varies because other workloads use the same capacity.
- The workspace maximum capacity units (CUs) are limited to the largest possible [F SKU or P SKU](/fabric/enterprise/licenses#microsoft-fabric-license-types). For data engineering experiences, you can provision separate Spark pools to move the compute capacity that Fabric Spark requires outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units that share that workspace.
- All workspace items and data are in one region. You can't use this pattern for multi-geo scenarios.
- Features that rely on multiple workspaces, like [Deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) and [lifecycle management](/fabric/cicd/cicd-overview), aren't available.
- [Limitations](/fabric/get-started/workspaces#considerations-and-limitations) that are associated with a single workspace apply.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) that are associated with a specific SKU apply.

You might choose to implement this deployment pattern for one or more of the following reasons:

- Your organization doesn't have complex engineering requirements, it has a small user base, or its semantic models are small.
- Your organization operates in a single region.
- You're not primarily concerned with organizational separation between business units.
- Your organization doesn't require workspace-scoped features, such as sharing code repositories with Git.
- You want to implement a lakehouse medallion architecture. When your organization is limited to a single workspace, you can achieve separation between bronze, silver, and gold layers by creating separate lakehouses within the workspace.
- Your organization's business units share roles, and it's acceptable to have the same workspace-level permissions for users in the workspace. For example, when multiple users who belong to different business units are  administrators of a single workspace, they have the same rights on all items in the workspace.
- Your organization can tolerate variable job completion times. If an organization doesn't have any requirements for performance guarantees (for example, a job must finish in a specific time period), it's acceptable to share a single provisioned capacity across business units. When a capacity is shared, users can run their queries at any time. The number of CUs that are available to run a job varies depending on what other queries are running on the capacity. It can lead to variable job completion times.
- Your organization can achieve all its business requirements (from a CU perspective) by using a single Fabric capacity.

The following table presents considerations that might influence your decision to adopt this deployment pattern:

| Aspect | Considerations |
|---|---|
| **Governance** | - Lower governance mandates and restrictions on the platform are required. <br/>- It suits smaller organizations that prefer faster time to market. <br/>- Challenges might develop if governance requirements evolve to become more complex. |
| **Security - Data plane** | - Data can be shared across teams, so there's no need to have restrictions on data between teams. <br/>- Teams have ownership rights on the semantic models. They can read, edit, and modify data in OneLake. |
| **Security - Control plane** | - All users can collaborate in the same workspace. <br/>- There are no restrictions on items. All users can read and edit all items. |
| **Administration** | The organization has:<br/><br/>- Lower administration costs. <br/>- No stringent need to track and monitor access and usage per team. <br/>- Less stringent Fabric workload load monitoring across teams. |
| **DevOps** | DevOps benefits from:<br/><br/>- A single release for the entire platform. <br/>- Less complicated release pipelines. |
| **Usability - Administrators** | - It's easier for administrators to manage because they have fewer items to manage. <br/>- There's no need for other provisioning or to handle requests from teams for new capacities or workspaces. <br/>- Capacity administrators can be tenant administrators, so there's no need to create or manage other groups or teams. |
|  **Usability - Other roles** | - It's acceptable to share the workspace with other users. <br/>- Collaboration among users is encouraged. |
| **Performance** | - Isolation of workloads isn't mandatory. <br/>- No strict performance service-level agreements (SLAs) need to be met. <br/>- Throttling isn't likely. |
| **Billing and cost management** | - One, single team can handle costs. <br/>- There's no need to chargeback to different teams. |

## Pattern 2: Multiple workspaces backed by a single Fabric capacity

In this deployment pattern, you use separate workspaces. Because a single capacity is shared across workspaces, workloads that run concurrently can affect the performance of jobs and interactive queries.

:::image type="content" source="../_images/fabric-deployment-pattern-2-multiple-workspaces-single-capacity.svg" alt-text="Diagram that shows a single Fabric tenant that contains a single capacity and two workspaces." border="false":::

When you provision a single Fabric capacity and attach multiple workspaces to it, the following points are true:

- All Fabric items share the same provisioned capacity. The amount of time a query or job takes to finish varies because other workloads use the same capacity.
- The maximum CUs that a workspace can use is limited to the largest possible F SKU or P SKU. For data engineering experiences, you can provision separate Spark pools to move the compute capacity that Fabric Spark requires outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units that share that workspace.
- All workspace items and data are in one region. You can't use this pattern for multi-geo scenarios.
- You can use DevOps features that require separate workspaces, like for deployment pipelines and lifecycle management.
- [Limitations](/fabric/get-started/workspaces#considerations-and-limitations) that are associated with a single workspace apply.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) that are associated with a specific SKU apply.

You might choose to implement this deployment pattern for one or more of the following reasons:

- You want a hub-and-spoke architecture in which your organization centralizes some aspects of operating the analytics environment and decentralizes others.
- You want decentralization from an operational and management aspect but to varying degrees. For example, you might choose to have bronze and silver layers of a medallion architecture deployed to one workspace and the gold layer deployed to a different workspace. Your rationale might be that one team is responsible for the bronze and silver layers and a different team is responsible for operating and managing the gold layer.
- You aren't primarily concerned about performance management and isolating workloads from a performance perspective.
- From the perspective of a lakehouse medallion architecture, your organization can create separate workspaces to implement bronze, silver, and gold layers.
- Your organization doesn't need to deploy workloads across different geographical regions (all data must reside in one region).
- Your organization might require separation of workspaces for one or more of the following reasons:
  - Members of the team that is responsible for workloads are in different workspaces.
  - You want to create separate workspaces for each type of workload. For example, you might create a workspace for data ingestion (data pipelines, dataflow Gen2, or data engineering) and create a separate workspace for consumption through a data warehouse. This design works well when separate teams are responsible for each of the workloads.
  - You want to implement a data mesh architecture in which one or more workspaces are grouped together in a [Fabric domain](/fabric/governance/domains).
- Your organization might choose to deploy separate workspaces based on data classification.

The following table presents considerations that might influence your decision to choose this deployment pattern:

| Aspect | Considerations |
|---|---|
| **Governance** | - Medium governance mandates and restrictions on the platform are required. <br/>- The organization needs more granular control to govern departments, teams, and roles. |
| **Security - Data plane** | - Data restrictions are required, and you need to provide data protection based on access controls for departments, teams, and members. |
| **Security - Control plane** | - To avoid accidental corruption or actions by malicious users, you might need to provide controlled access on Fabric items by role. |
| **Administration** | - You don't need to manage capacities because it's a single-capacity model. <br/>- You can use workspaces to isolate departments, teams, and users. |
| **DevOps** | - You can do independent releases per department, team, or workload. <br/>- It's easier to meet development, testing, acceptance, and production (DTAP) requirements for teams when multiple workspaces are provisioned to address each release environment. |
| **Usability - Administrators** | - You don't need to provision multiple capacities. <br/>- Tenant administrators typically administer capacity, so you don't need to manage other groups or teams. |
| **Usability - Other roles** | - Workspaces are available for each medallion layer. <br/>- Fabric items are isolated per workspace, which helps to prevent accidental corruption. |
| **Performance** | - Strict performance SLAs don't need to be met. <br/>- Throttling is acceptable during peak periods. |
| **Billing and cost management** | - You don't have a specific requirement to chargeback per team. <br/>- A central team bears all costs. <br/>- Infrastructure teams are owners of Fabric capacities in the organization. |

## Pattern 3: Multiple workspaces backed by separate capacities

In this deployment pattern, you achieve separation between business units for governance and performance.

:::image type="content" source="../_images/fabric-deployment-pattern-3-multiple-workspaces-multiple-capacites.svg" alt-text="Diagram that shows a single Fabric tenant that contains two capacities. The first capacity has two workspaces. The second capacity has one workspace." border="false":::

When you provision multiple Fabric capacities with their own workspaces, the following points are true:

- The largest possible F SKU or P SKU attached to a workspace determines the maximum CUs that a workspace can use.
- Organizational and management decentralization is achieved by provisioning separate workspaces.
- Organizations can scale beyond one region by provisioning capacities and workspaces in different geographical regions.
- You can use the full capabilities of Fabric because business units can have one or more workspaces that are in separate capacities and grouped together through Fabric domains.
- [Limitations](/fabric/get-started/workspaces#considerations-and-limitations) that are associated with a single workspace apply, but you can scale beyond these limits by creating new workspaces.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) that are associated with a specific SKU apply, but you can scale CUs by provisioning separate capacities.
- All Fabric items in all workspaces in the tenant and their certification statuses can be discovered by using a OneLake data hub.
- Domains can group workspaces together so that a single business unit can operate and manage multiple workspaces.
- [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) reduce data movement, and they also reduce data usability across workspaces.

You might choose to implement this deployment pattern for one or more of the following reasons:

- Your organization wants to deploy architectural frameworks like data mesh or data fabric.
- You want to prioritize flexibility in how you structure capacities and workspaces.
- You operate in different geographical regions. In this case, provisioning a separate capacity and workspace is the driving force to move toward this multi-capacity and multi-workspace deployment pattern.
- You operate at large scale and have requirements to scale beyond the limits of a single-capacity SKU or a single workspace.
- You have workloads that must always finish within a specific time or meet a specific performance SLA. You can provision a separate workspace that's backed by a Fabric capacity to meet performance guarantees for those workloads.

The following table presents considerations that might influence your decision to choose this deployment pattern:

| Aspect | Considerations |
|---|---|
| **Governance** | - You have a high degree of governance and management, and you need independence for each workspace. <br/>- You can manage usage per department or business unit. <br/>- You can conform to data residency requirements. <br/>- You can isolate data based on regulatory requirements. |
| **Security - Data plane** | - Data access can be controlled per department, team, or users. <br/>- You can isolate data based on Fabric item type. |
| **Security - Control plane** | - You can provide controlled access on Fabric items by role to avoid accidental corruption or actions by malicious users. |
| **Administration** | - Granular administrator capabilities are restricted to departments, teams, or users. <br/>- You have access to detailed monitoring requirements on usage or patterns of workloads. |
| **DevOps** | - You can isolate DTAP environments by using different capacities. <br/>- Independent releases are based on a department, team, or workload. |
| **Usability - Administrators** | - You get granular visibility into usage by department or team. <br/>- You have delegated capacity rights to capacity administrators per department or team, which helps with scaling and granular configuration. |
| **Usability - Other roles** | - Workspaces are available per medallion layer and capacity. <br/>- Fabric items are isolated per workspace, which helps prevent accidental corruption. <br/>- You have more options to prevent throttling that's caused by surges on shared capacity. |
| **Performance** | - Performance requirements are high, and workloads need to meet higher SLAs. <br/>- You have flexibility in scaling up individual workloads per department or team. |
| **Billing and cost management** | - Cross-charging requirements can be easily met by assigning dedicated capacities to an organizational entity (department, team, or project). <br/>- Cost management can be delegated to respective teams to manage. |

## Pattern 4: Multiple Fabric tenants

When separate Fabric tenants are deployed, all instances of Fabric are separate entities with respect to governance, management, administration, scale, and storage.

The following points are true when you use multiple Fabric tenants:

- Tenant resources are strictly segregated.
- Management planes between tenants are separate.
- Tenants are separate entities and can have their own processes for governance and management, but you can administer them separately.
- You can use [data pipelines](/fabric/data-factory/data-factory-overview#data-pipelines) or [data engineering](/fabric/data-engineering/data-engineering-overview) capabilities to share or access data between Fabric tenants.

You might choose to implement this deployment pattern for the following reasons:

- The organization might end up with multiple Fabric tenants because of a business acquisition.
- The organization might choose to set up a Fabric tenant specifically for a business unit or smaller subsidiary.

### Contributors

**This article is maintained by Microsoft. It was originally written by the following contributors.**

- [Holly Kelly](https://www.linkedin.com/in/holly-kelly-9466063/) | Principal Program Manager
- [Gabi Muenster](https://www.linkedin.com/in/gabimuenster/) | Senior Program Manager
- [Sarath Sasidharan](https://www.linkedin.com/in/sarathsasidharan/) | Senior Program Manager
- Amanjeet Singh | Principal Program Manager
