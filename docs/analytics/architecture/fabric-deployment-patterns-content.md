# Deployment patterns for Microsoft Fabric

This article outlines four different deployment patterns that you can choose from when you deploy Microsoft Fabric. For each deployment pattern, learn about considerations, recommendations, and any potential nonreversible decisions that you should be aware of for your Fabric deployment.

The following design areas are described for each Fabric deployment pattern:

- Governance
- Security
- Administration
- DevOps
- Usability
- Performance and scale
- Billing and cost management

## Hierarchy of a Fabric deployment

A Fabric deployment hierarchy consists of four levels: [tenant](/fabric/enterprise/licenses#tenant), [capacity](/fabric/get-started/workspaces), [workspace](/fabric/get-started/workspaces), and [item](/fabric/get-started/fabric-home). At the top level is the Fabric tenant. Each tenant can have one or more capacities, each capacity can contain one or more workspaces, and each workspace can contain zero or more Fabric items.

Many technical aspects apply to each level of a Fabric deployment hierarchy. These aspects include security, scale, governance, and application lifecycle, and they form boundaries. Each aspect can strongly influence each deployment pattern. Some deployment patterns are centered around how these components are analyzed.

In addition to these technical aspects, you might look for governance patterns that you can use to structure your landscape by organizational aspects. You can achieve that by using _domains_ in Fabric. Use [domains](/fabric/governance/domains) to group workspaces in the organizational structure that works for you. You can apply domains at any point in time, and they have no immediate effect on your choice of deployment pattern.

Apart from structuring the landscape from a technical and governance perspective, you must have a centralized option that you can use to find content and collaborate by using Fabric. [OneLake data hub](/fabric/get-started/onelake-data-hub) provides a centralized access point and is integrated with other commonly used products, like Microsoft Teams and Excel.

For large organizations that might have business units in separate geographical locations, you can use capacities to control where data resides. You can manage a business unit that operates in a different geographical location as a single unit by using Fabric domains. Domains can span workspaces that belong to different regions.

For more information, see [Microsoft Fabric concepts and licenses](/fabric/enterprise/licenses).

## Deployment patterns

This article describes deployment patterns that align with the following set of guiding principles. The patterns:

- Use Fabric workspaces as boundaries for scale, governance, and security.
- Use [Fabric domains](/fabric/governance/domains) for delegation, to manage multiple workspaces that might belong to the same business unit, or when data that belongs to a business domain spans more than one workspace. You can set some tenant-level settings for managing and governing data [at the domain level](/fabric/governance/domains#domain-settings-delegation) and use domain-specific configuration for those settings.
- Use Fabric capacities to scale compute with consideration for provisioning dedicated capacities per workspace when specific performance levels must be met.
- Extend a deployment pattern to use equivalent features from a Microsoft cloud (Microsoft Azure, Microsoft 365, and others) when a feature isn't available in Fabric.
- Use [OneLake data hub](/fabric/get-started/onelake-data-hub) to promote discovery and use of data assets in Fabric.
- Use OneSecurity to set up data security policies for data assets in Fabric.

### Business requirements

This article defines scenarios to describe how each deployment pattern can address various business requirements:

- **Scenario 1**: For organizations that want to have faster (or slower) time to market by having teams that can cross-collaborate with lower restrictions on data usage. In this scenario, organizations can benefit by using a _monolithic_ deployment pattern. It manages and operates in a single workspace. For more information, see [deployment pattern 1 (monolithic deployment)](#pattern-1-monolithic-deployment).
- **Scenario 2**: For organizations that want to provide isolated environments for teams to work on, with a central team responsible for providing and managing infrastructure. This scenario also suits organizations that want to implement data mesh. In this scenario, organizations can implement _multiple workspaces_ that make use of a shared capacity or separate capacities. For more information, see [deployment pattern 2 (multiple workspaces backed by a single Fabric capacity)](#pattern-2-multiple-workspaces-backed-by-a-single-fabric-capacity) and [deployment pattern 3 (multiple workspaces backed by separate capacities)](#pattern-3-multiple-workspaces-backed-by-separate-capacities).
- **Scenario 3**: For organizations that want to have an entirely decentralized model that provides business units or teams with the freedom to control and manage their data platforms. In this scenario, organizations can choose to adopt a model where they use _separate workspaces_, each with dedicated capacity, or possibly with multiple Fabric tenants. For more information, see [deployment pattern 3 (Multiple workspaces backed by separate capacities)](#pattern-3-multiple-workspaces-backed-by-separate-capacities) and [deployment pattern 4 (multiple Fabric tenants)](#pattern-4-multiple-fabric-tenants).
- **Scenario 4**: Some organizations might choose a hybrid approach where they combine multiple patterns to achieve their requirements. For instance, an organization might set up a single workspace for specific business units (monolithic) while using separate, dedicated workspaces along with separate capacities for other business units.

### Pattern 1: Monolithic deployment

This deployment pattern is about provisioning a single workspace to cater to all use cases. All business units work with the one workspace.

:::image type="content" source="./_images/fabric-deployment-pattern-1-monolithic-deployment.svg" alt-text="Diagram shows a single Fabric tenant that contains a single capacity with a single workspace." border="false":::

When you provision a single Fabric capacity and attach a single workspace to it, the following points are true.

- All Fabric items share the same provisioned capacity. The amount of time a query or job takes to complete varies due to other workloads running on the same capacity at the same time.
- The maximum capacity units (CUs) that the workspace can use is limited to the largest possible [F SKU or P SKU](/fabric/enterprise/licenses#microsoft-fabric-license-types). For data engineering experiences, you can provision separate Spark pools that allow you to move compute capacity required by Fabric Spark outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units sharing that workspace.
- All workspace items and data reside in one region. Therefore, you can't use this pattern for multi-geo scenarios.
- Features that rely on multiple workspaces aren't available. For example, [deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines), and [lifecycle management](/fabric/cicd/cicd-overview).
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) associated with a single workspace apply.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) associated with a given SKU apply.

You might choose to implement this deployment pattern for one or more of the following reasons:

- Your organization doesn't have complex engineering requirements, it has a small user base, or its semantic models are small.
- Your organization operates in a single region.
- You're not primarily concerned with organizational separation between business units.
- The workspace-scoped features aren't a challenge, such as by sharing code repositories with Git.
- You want to implement a lakehouse medallion architecture. When your organization is limited to a single workspace, you can achieve separation between bronze, silver, and gold layers by creating separate lakehouses within the workspace.
- Your organization's business units share roles, and it's acceptable to have the same workspace-level permissions in the workspace. For example, when users who belong to different business units are assigned as administrator of the single workspace, they have the same rights on all items in the workspace.
- Your organization can tolerate variable job completion times.

  When an organization doesn't have any requirements for performance guarantees (for example, a job must complete in a certain time period), it's acceptable to share a single provisioned capacity across business units. When a capacity is shared, users can run their queries at any time. The number of CUs that are available to run a job vary depending on what other queries are running on the capacity. It can lead to variable job completion times.
- Your organization can achieve all of its business requirements (from a CU perspective) with a single Fabric capacity.

The following table presents considerations that could influence your decision to adopt this deployment pattern:

| Aspect | Consideration |
|---|---|
| **Governance** | - Lower governance mandates and restrictions on the platform. <br/>- Suited to smaller organizations that prefer faster time to market. <br/>- Might present challenges should governance requirements evolve to become more complex. |
| **Security - Data plane** | - Data can be shared across teams, so there's no need to have restrictions on data between different teams. <br/>- Teams have ownership rights on the semantic models, and they can read, edit, and modify data in OneLake. |
| **Security - Control plane** | - All users can collaborate in the same workspace. <br/>- There are no restrictions on items; all users can read and edit all items. |
| **Administration** | - Lower administration costs. <br/>- No stringent need to track and monitor access and usage per team. <br/>- Less stringent Fabric workload load monitoring across teams. |
| **DevOps** | - Single release for the whole platform. <br/>- Less complicated release pipelines. |
| **Usability - Administrators** | - Easier for administrators to manage due to the fewer number of items to manage. <br/>- No need for other provisioning or to handle requests from teams for new capacities or workspaces. <br/>- Capacity administrators could be tenant administrators, so there's no need to create or manage other groups or teams. |
|  **Usability - Other roles** | - It's acceptable to share the workspace with other users. <br/>- Collaboration among users is desired. |
| **Performance** | - Isolation of workloads isn't mandatory. <br/>- No heavy performance service level agreements (SLAs) need to be met. <br/>- Not impacted by higher likelihood of throttling. |
| **Billing and cost management** | - One, single team can handle costs. <br/>- No need to charge back to different teams. |

### Pattern 2: Multiple workspaces backed by a single Fabric capacity

This deployment pattern is about using separate workspaces. Because a single capacity is shared across workspaces, workloads that run concurrently at any time might affect the performance of jobs and interactive queries.

:::image type="content" source="./_images/fabric-deployment-pattern-2-multiple-workspaces-single-capacity.svg" alt-text="Diagram shows a single Fabric tenant that contains a single capacity with two workspaces." border="false":::

When you provision a single Fabric capacity and attach multiple workspaces to it, the following points are true.

- All Fabric items share the same provisioned capacity. The time that a query or job takes to complete varies depending on other workloads that are running at the same time.
- The maximum CUs that a workspace can use is limited to largest possible F SKU or P SKU. For data engineering experiences, you can provision separate Spark pools that allow you to move compute capacity required by Fabric Spark outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units sharing that workspace.
- All workspace items and data reside in one region. Therefore, you can't use this pattern for multi-geo scenarios.
- DevOps features, like deployment pipelines and lifecycle management, which require separate workspaces can be used.
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) associated with a single workspace apply, however, you can scale beyond these limits by creating new workspaces.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) associated with a given SKU apply.

You might choose to implement this deployment pattern for one (or more) of the following reasons.

- You want a hub and spoke architecture where the organization centralizes certain aspects of operating the analytics environment while decentralizing other aspects.
- You want decentralization from an operational and management aspect but to varying degrees. For example, you might choose to have bronze and silver layers of a medallion architecture deployed to one workspace, and the gold layer deployed to a different workspace. Your rationale might be that one team is responsible for the bronze and silver layers and a different team is responsible for operating and managing the gold layer.
- You aren't primarily concerned about performance management and the isolation of workloads from a performance perspective.
- From lakehouse medallion architecture perspective, your organization can create separate workspaces to implement bronze, silver, and gold layers.
- Your organization doesn't need to deploy workloads across different geographical regions (all data must reside in one region).
- Your organization might require separation of workspaces due to one or more of the following reasons:
  - The composition of the team responsible for workloads that reside across workspaces.
  - You want to create separate workspaces for each type of workload. For example, you might create a workspace for data ingestion (data pipelines, dataflow Gen2, or data engineering), and create a separate workspace for consumption through a data warehouse. This design works well when there are separate teams that are responsible for each of the workloads.
  - You want to implement a data mesh architecture where one or more workspaces are grouped together in a [Fabric domain](/fabric/governance/domains).
- Your organization might choose to deploy separate workspaces based on data classification.

The following table presents considerations that could influence your decision to adopt this deployment pattern.

| Aspect | Consideration |
|---|---|
| **Governance** | - Medium governance mandates and restrictions on the platform. <br/>- Need to have more granular control to govern departments, teams, and roles. |
| **Security - Data plane** | - Data restrictions are needed, and you need to provide data protection based on access controls for departments, teams, and members. |
| **Security - Control plane** | - To avoid accidental corruption or actions by malicious users, you might need to provide controlled access on Fabric items by role. |
| **Administration** | - No need to manage capacities because it's a single capacity model. <br/>- Workspaces can be used to isolate departments, teams, and users. |
| **DevOps** | - Ability to do independent releases per department, team, or workload. <br/>- Easier to meet Development, Testing, Acceptance, and Production (DTAP) requirement for teams when multiple workspaces are provisioned to address each release environment. |
| **Usability - Administrators** | - No need to provision multiple capacities. <br/>- Tenant administrators typically administer capacity, so there's no need to manage other groups or teams. |
| **Usability - Other roles** | - Workspaces for each medallion layer. <br/>- Isolation of Fabric items per workspace, which helps to prevent accidental corruption. |
| **Performance** | - No heavy performance SLAs need to be met. <br/>- Throttling is acceptable during peak periods. |
| **Billing and cost management** | - No specific requirement to charge back per team. <br/>- Central team bears all costs. <br/>- Infrastructure teams are owners of Fabric capacities in the organization. |

### Pattern 3: Multiple workspaces backed by separate capacities

This deployment pattern is about achieving separation between business units from a governance and performance perspective.

:::image type="content" source="./_images/fabric-deployment-pattern-3-multiple-workspaces-multiple-capacites.svg" alt-text="Diagram shows a single Fabric tenant that contains two capacities. The first capacity has two workspaces; the second capacity has one workspace." border="false":::

When you provision multiple Fabric capacities with their own workspaces, the following points are true:

- The largest possible F SKU or P SKU attached to a workspace determine the maximum CUs that a workspace can use.
- Organizational and management decentralization is achieved by provisioning separate workspaces.
- Organizations can scale beyond one region by provisioning capacities and workspaces in different geographical regions.
- It's possible to use the full capabilities of Fabric because business units can have one or more workspaces that are in separate capacities and grouped together by using Fabric domains.
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) associated with a single workspace apply, however, you can scale beyond these limits by creating new workspaces.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) associated with a given SKU apply; however, you can scale CUs by provisioning separate capacities.
- All Fabric items across all workspaces (in the tenant) and their certification status can be discovered by using OneLake data hub.
- Domains can group workspaces together so that a single business unit can operate and manage multiple workspaces.
- [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) reduce data movement, and they also reduce data usability across workspaces.

You might choose to implement this deployment pattern for one (or more) of the following reasons.

- Your organization wants to deploy architectural frameworks such as data mesh or Data Fabric.
- You want to prioritize flexibility in terms of how to structure capacities and workspaces.
- You operate out of different geographical regions. In this case, provisioning a separate capacity and workspace is the driving force to move toward this multi-capacity and multi-workspace deployment pattern.
- You operate at large scale and have requirements to scale beyond limits of a single capacity SKU and/or single workspace.
- You might have certain workloads that must always complete within a certain time or meet a specific performance SLA. To this end, you can provision a separate workspace backed by Fabric capacity to meet performance guarantees.

The following table presents considerations that could influence your decision to adopt this deployment pattern.

| Aspect | Consideration |
|---|---|
| **Governance** | - High degree of governance and management, and independence for each workspace. <br/>- Ability to manage usage per department or business unit. <br/>- Ability to conform to data residency requirements. <br/>- Ability to isolate data based on regulatory requirements. |
| **Security - Data plane** | - Data access can be controlled per department, team, or users. <br/>- Isolation of data based on Fabric item type. |
| **Security - Control plane** | - Ability to provide controlled access on Fabric items by role to avoid accidental corruption or actions by malicious users. |
| **Administration** | - Granular administrator capabilities restricted to department, team, or users. <br/>- Detailed monitoring requirements on usage or patterns of workloads. |
| **DevOps** | - Ability to isolate DTAP environments by using different capacities. <br/>- Independent releases based on department, team, or workload. |
| **Usability - Administrators** | - Granular visibility into usage by department or team. <br/>- Delegated capacity rights to capacity administrators per department or team, which helps with scaling and granular configuration. |
| **Usability - Other roles** | - Workspaces per medallion layer and capacities. <br/>- Isolation of Fabric items per workspace, which helps to prevent accidental corruption. <br/>- More options to prevent throttling caused by surges on shared capacity. |
| **Performance** | - Performance requirements are high, and workloads need to meet higher SLAs. <br/>- Flexibility in scaling up individual workloads per department or team. |
| **Billing and cost management** | - Cross-charging requirements can be easily met by assigning dedicated capacities to an organizational entity (department, team, or project). <br/>- Cost management can be delegated to respective teams to manage. |

### Pattern 4: Multiple Fabric tenants

When separate Fabric tenants are deployed, all instances of Fabric are separate entities with respect to governance, management, administration, scale, and storage.

The following points are true when you use multiple Fabric tenants:

- Tenant resources are strictly segregated.
- Management planes between tenants are separate.
- Tenants are separate entities and can have their own processes for governance and management, but still be administrated separately.
- You can use [data pipelines](/fabric/data-factory/data-factory-overview#data-pipelines) or [data engineering](/fabric/data-engineering/data-engineering-overview) capabilities to share or access data between Fabric tenants.

You might choose to implement this deployment pattern for the following reasons:

- The organization might end up with multiple Fabric tenants because of a business acquisition.
- The organization might choose to set up a Fabric tenant for business units or smaller subsidiaries.

## Contributors

**This article is maintained by Microsoft. It was originally written by the following contributors.**

- [Holly Kelly](https://www.linkedin.com/in/holly-kelly-9466063/) | Principal Program Manager
- [Gabi Muenster](https://www.linkedin.com/in/gabimuenster/) | Senior Program Manager
- [Sarath Sasidharan](https://www.linkedin.com/in/sarathsasidharan/) | Senior Program Manager
- Amanjeet Singh | Principal Program Manager
