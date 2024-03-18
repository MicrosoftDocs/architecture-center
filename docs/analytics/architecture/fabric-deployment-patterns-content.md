# Deployment patterns for Microsoft Fabric

This architecture guide outlines four different deployment patterns for Microsoft Fabric. For each deployment pattern, the article describes considerations, recommendations, and any potential nonreversible decisions that you should be aware of for your Fabric deployment.

For each deployment pattern, the following design areas are discussed:

- Governance
- Security
- Administration
- DevOps
- Usability
- Performance and scale
- Billing and cost management

## Hierarchy of a Fabric deployment

A Fabric deployment hierarchy consists of four levels: [tenant](/fabric/enterprise/licenses#tenant), [capacity](/fabric/get-started/workspaces), [workspace](/fabric/get-started/workspaces), and [item](/fabric/get-started/fabric-home). At the top level, there's the Fabric tenant, which can have one or more capacities. Each capacity can contain one or more workspaces, and each workspace can contain zero or more Fabric items.

There are many technical aspects that apply to each level of the hierarchy. These aspects form boundaries, and they include security, scale, governance, and application lifecycle. Each aspect can strongly influence each of the deployment patterns. Some deployment patterns are centered around how these components are analyzed.

In addition to these technical aspects, you might look for governance patterns to structure your landscape by organizational aspects. You can achieve that by using _domains_ in Fabric. [Domains](/fabric/governance/domains) allow you to group workspaces into the organizational structure that works for you. You can apply domains at any point in time, and they have no immediate effect on your choice of deployment pattern.

Apart from structuring the landscape from a technical and governance perspective, a centralized option to find content and collaborate with Fabric is required. [OneLake data hub](/fabric/get-started/onelake-data-hub) provides a centralized access point, and it's integrated with other commonly used products, like Microsoft Teams and Microsoft Excel.

For large organizations that might have business units that reside in different geographical locations, you can use capacities to control where data resides. Further, you can manage a business unit that operates in a different geographical location as a single unit by using Fabric domains. Domains can span workspaces that belong to different regions.

For more information, see [Microsoft Fabric concepts and licenses](/fabric/enterprise/licenses).

## Deployment patterns

The deployment patterns presented in this article adhere to the following set of guiding principles. They:

- Use Fabric workspaces as a boundary for scale, governance, and security.
- Use [Fabric domains](/fabric/governance/domains) for delegation and to manage multiple workspaces that might belong to the same business unit, or when data that belongs to a business domain spans more than one workspace. Some tenant-level settings for managing and governing data can be [set at the domain level](/fabric/governance/domains#domain-settings-delegation), thus allowing domain-specific configuration of those settings.
- Use Fabric capacities to scale compute with consideration for provisioning dedicated capacities per workspace when specific performance levels must be met.
- Extend a deployment pattern to use equivalent features from Microsoft cloud (Microsoft Azure, Microsoft 365, and others) when a feature isn't available in Fabric.
- Use [OneLake data hub](/fabric/get-started/onelake-data-hub) to promote discovery and use of data assets in Fabric.
- Use OneSecurity to set up data security policies for data assets in Fabric.

### Business requirements

This article defines scenarios to describe how each of the deployment patterns can address various business requirements.

- **Scenario 1** - For organizations that want to have faster (or lower) time to market with teams that can cross-collaborate with lower restrictions on data usage. In this scenario, organizations can benefit with a _monolithic_ deployment pattern where there's a single workspace to manage and operate. See [deployment pattern 1 (Monolithic deployment)](#pattern-1-monolithic-deployment).
- **Scenario 2** - For organizations that want to provide isolated environments for teams to work on, with a central team responsible for providing and managing infrastructure. This scenario also suits organizations that want to implement data mesh. In this scenario, organizations can implement _multiple workspaces_ that make use of a shared capacity or separate capacities. See [deployment pattern 2 (Multiple workspaces backed by a single Fabric capacity)](#pattern-2-multiple-workspaces-backed-by-a-single-fabric-capacity) and [deployment pattern 3 (Multiple workspaces backed by separate capacities)](#pattern-3-multiple-workspaces-backed-by-separate-capacities).
- **Scenario 3** - For organizations that want to have an entirely decentralized model that provides business units or teams with the freedom to control and manage their data platforms. In this scenario, organizations can choose to adopt a model where they use _separate workspaces_, each with dedicated capacity or possibly multiple Fabric tenants. See [deployment pattern 3 (Multiple workspaces backed by separate capacities)](#pattern-3-multiple-workspaces-backed-by-separate-capacities) and [deployment pattern 4 (Multiple Fabric tenants)](#pattern-4-multiple-fabric-tenants).
- **Scenario 4** - Some organizations might choose a hybrid approach where they combine multiple patterns to achieve their requirements. For instance, an organization might set up a single workspace for specific business units (monolithic) while using separate, dedicated workspaces along with separate capacities for other business units.

### Pattern 1: Monolithic deployment

This deployment pattern is about provisioning a single workspace to cater to all use cases. All business units work with the one workspace.

:::image type="content" source="./_images/fabric-deployment-pattern-1-monolithic-deployment.svg" alt-text="Diagram shows a single Fabric tenant that contains a single capacity with a single workspace." border="false":::

When you provision a single Fabric capacity and attach a single workspace to it, the following points are true.

- All Fabric items share the same provisioned capacity, which means that the amount of time a query or job takes to complete varies due to other workloads running on the same capacity at any given point in time.
- The maximum Capacity Units (CUs) that the workspace can use is limited to the largest possible [F SKU or P SKU](/fabric/enterprise/licenses#microsoft-fabric-license-types). For data engineering experiences, you can provision separate Spark pools that allow you to move compute capacity required by Fabric Spark outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units sharing that workspace.
- All workspace items and data reside in one region. Therefore, you can't use this pattern for multi-geo scenarios.
- Features that rely on multiple workspaces aren't available. For example, [deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines), and [lifecycle management](/fabric/cicd/cicd-overview).
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) associated with a single workspace apply.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) associated with a given SKU apply.

You might choose to implement this deployment pattern for one or more of the following reasons:

- Your organization doesn't have complex engineering requirements, it has a small user base, or its semantic models are small.
- Your organization operates in a single region.
- Organizational separation between business units isn't a primary concern.
- The workspace-scoped features aren't a challenge, like sharing code repositories with Git.
- To implement lakehouse medallion architecture. When your organization is limited to a single workspace, you can achieve separation between the bronze, silver, and gold layers by creating separate lakehouses within the workspace.
- Business units share roles and it's acceptable to have the same workspace-level permissions in the workspace. For example, when users who belong to different business units are assigned as administrator of the single workspace, they'll have the same rights on all items in the workspace.
- Your organization can tolerate variable job completion times. When an organization doesn't have any requirements around performance guarantees (for example, a job must complete in a certain time period), it's acceptable to share a single provisioned capacity across business units. When a capacity is shared, users can run their queries at any time, which means that the number of CUs available to run a job can vary depending on what other queries are running on the capacity. It can lead to variable job completion times.
- Your organization can achieve all of its business requirements (from a CU perspective) with a single Fabric capacity.

The following table presents considerations that could influence your decision to adopt this deployment pattern.

| Aspect | Consideration |
|---|---|
| **Governance** | &bull;&nbsp;Lower governance mandates and restrictions on the platform. <br/>&bull;&nbsp;Suited to smaller organizations that prefer faster time to market. <br/>&bull;&nbsp;Might present challenges should governance requirements evolve to become more complex. |
| **Security - Data plane** | &bull;&nbsp;Data can be shared across teams, so there's no need to have restrictions on data between different teams. <br/>&bull;&nbsp;Teams have ownership rights on the semantic models, and they can read, edit, and modify data in OneLake. |
| **Security - Control plane** | &bull;&nbsp;All users can collaborate in the same workspace. <br/>&bull;&nbsp;There are no restrictions on items; all users can read and edit all items. |
| **Administration** | &bull;&nbsp;Lower administration costs. <br/>&bull;&nbsp;No stringent need to track and monitor access and usage per team. <br/>&bull;&nbsp;Less stringent Fabric workload load monitoring across teams. |
| **DevOps** | &bull;&nbsp;Single release for the whole platform. <br/>&bull;&nbsp;Less complicated release pipelines. |
| **Usability - Administrators** | &bull;&nbsp;Easier for administrators to manage due to the fewer number of items to manage. <br/>&bull;&nbsp;No need for other provisioning or to handle requests from teams for new capacities or workspaces. <br/>&bull;&nbsp;Capacity administrators could be tenant administrators, so there's no need to create or manage other groups or teams. |
|  **Usability - Other roles** | &bull;&nbsp;It's acceptable to share the workspace with other users. <br/>&bull;&nbsp;Collaboration among users is desired. |
| **Performance** | &bull;&nbsp;Isolation of workloads isn't mandatory. <br/>&bull;&nbsp;No heavy performance service level agreements (SLAs) need to be met. <br/>&bull;&nbsp;Not impacted by higher likelihood of throttling. |
| **Billing and cost management** | &bull;&nbsp;One single team can handle costs. <br/>&bull;&nbsp;No need to charge back to different teams. |

### Pattern 2: Multiple workspaces backed by a single Fabric capacity

This deployment pattern is about using separate workspaces. Because a single capacity is shared across workspaces, performance of jobs and interactive queries can be affected by workloads that run concurrently at any given point in time.

:::image type="content" source="./_images/fabric-deployment-pattern-2-multiple-workspaces-single-capacity.svg" alt-text="Diagram shows a single Fabric tenant that contains a single capacity with two workspaces." border="false":::

When you provision a single Fabric capacity and attach multiple workspaces to it, the following points are true.

- All Fabric items share the same provisioned capacity, which means that the amount of time a query or job takes to complete varies depending on other workloads that are running at any given point in time.
- The maximum CUs that a workspace can use is limited to largest possible F SKU or P SKU. For data engineering experiences, you can provision separate Spark pools that allow you to move compute capacity required by Fabric Spark outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units sharing that workspace.
- All workspace items and data reside in one region. Therefore, you can't use this pattern for multi-geo scenarios.
- DevOps features, like deployment pipelines and lifecycle management, which require separate workspaces can be used.
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) associated with a single workspace apply, however, you can scale beyond these limits by creating new workspaces.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) associated with a given SKU apply.

You might choose to implement this deployment pattern for one (or more) of the following reasons.

- You want a hub and spoke architecture where the organization centralizes certain aspects of operating the analytics environment while decentralizing other aspects.
- You want decentralization from an operational and management aspect but to varying degrees. For example, you might choose to have bronze and silver layers of a medallion architecture deployed to one workspace, and the gold layer deployed to a different workspace. Your rationale might be that one team is responsible for the bronze and silver layers and a different team is responsible for operating and managing the gold layer.
- Performance management and the isolation of workloads from a performance perspective isn't a primary concern.
- From lakehouse medallion architecture perspective, your organization can create separate workspaces to implement bronze, silver, and gold layers.
- Your organization doesn't need to deploy workloads across different geographical regions (all data must reside in one region).
- Your organization might require separation of workspaces due to one or more of the following reasons:
  - The composition of the team responsible for workloads that reside across workspaces.
  - You want to create separate workspaces for each type of workload. For example, you might create a workspace for data ingestion (data pipelines, dataflow Gen2, or data engineering), and create a separate workspace for consumption through a data warehouse. This design works well when there are separate teams that are responsible for each of the workloads.
  - You want to implement a data mesh architecture where one or more workspaces are grouped together in a [Fabric domain](/fabric/governance/domains).
- Your organization might choose to deploy separate workspaces based on data classification.

The following table presents considerations that could influence your decision to adopt this deployment pattern.

| **Aspect** | **Consideration** |
|---|---|
| **Governance** | &bull;&nbsp;Medium governance mandates and restrictions on the platform. <br/>&bull;&nbsp;Need to have more granular control to govern departments, teams, and roles. |
| **Security - Data plane** | &bull;&nbsp;Data restrictions are needed, and you need to provide data protection based on access controls for departments, teams, and members. |
| **Security - Control plane** | &bull;&nbsp;Need to provide controlled access on Fabric items by role to avoid accidental corruption or actions by malicious users. |
| **Administration** | &bull;&nbsp;No need to manage capacities because it's a single capacity model. <br/>&bull;&nbsp;Workspaces can be used to isolate departments, teams, and users. |
| **DevOps** | &bull;&nbsp;Ability to do independent releases per department, team, or workload. <br/>&bull;&nbsp;Easier to meet Development, Testing, Acceptance, and Production (DTAP) requirement for teams when multiple workspaces are provisioned to address each release environment. |
| **Usability - Administrators** | &bull;&nbsp;No need to provision multiple capacities. <br/>&bull;&nbsp;Capacity is typically administered by tenant administrators, so there's no need to manage other groups or teams. |
| **Usability - Other roles** | &bull;&nbsp;Workspaces for each medallion layer. <br/>&bull;&nbsp;Isolation of Fabric items per workspace, which helps to prevent accidental corruption. |
| **Performance** | &bull;&nbsp;No heavy performance SLAs need to be met. <br/>&bull;&nbsp;Throttling is acceptable during peak periods. |
| **Billing and cost management** | &bull;&nbsp;No specific requirement to charge back per team. <br/>&bull;&nbsp;Central team bears all costs. <br/>&bull;&nbsp;Infrastructure teams are owners of Fabric capacities in the organization. |

### Pattern 3: Multiple workspaces backed by separate capacities

This deployment pattern is about achieving separation between business units from a governance and performance perspective.

:::image type="content" source="./_images/fabric-deployment-pattern-3-multiple-workspaces-multiple-capacites.svg" alt-text="Diagram shows a single Fabric tenant that contains two capacities. The first capacity has two workspaces; the second capacity has one workspace." border="false":::

When you provision multiple Fabric capacities with their own workspaces, the following points are true.

- The maximum CUs that a workspace can use is determined by the largest possible F SKU or P SKU attached to a workspace.
- Organizational and management decentralization is achieved by provisioning separate workspaces.
- Organizations can scale beyond one region by provisioning capacities and workspaces in different geographical regions.
- It's possible to use the full capabilities of Fabric because business units can have one or more workspaces that are in separate capacities, and that are grouped together by using Fabric domains.
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

| **Aspect** | **Consideration** |
|---|---|
| **Governance** | &bull;&nbsp;High degree of governance and management, and independence for each workspace. <br/>&bull;&nbsp;Ability to manage usage per department or business unit. <br/>&bull;&nbsp;Ability to conform to data residency requirements. <br/>&bull;&nbsp;Ability to isolate data based on regulatory requirements. |
| **Security - Data plane** | &bull;&nbsp;Data access can be controlled per department, team, or users. <br/>&bull;&nbsp;Isolation of data based on Fabric item type. |
| **Security - Control plane** | &bull;&nbsp;Ability to provide controlled access on Fabric items by role to avoid accidental corruption or actions by malicious users. |
| **Administration** | &bull;&nbsp;Granular administrator capabilities restricted to department, team, or users. <br/>&bull;&nbsp;Detailed monitoring requirements on usage or patterns of workloads. |
| **DevOps** | &bull;&nbsp;Ability to isolate DTAP environments by using different capacities. <br/>&bull;&nbsp;Independent releases based on department, team, or workload. |
| **Usability - Administrators** | &bull;&nbsp;Granular visibility into usage by department or team. <br/>&bull;&nbsp;Delegated capacity rights to capacity administrators per department or team, which helps with scaling and granular configuration. |
| **Usability - Other roles** | &bull;&nbsp;Workspaces per medallion layer and capacities. <br/>&bull;&nbsp;Isolation of Fabric items per workspace, which helps to prevent accidental corruption. <br/>&bull;&nbsp;More options to prevent throttling caused by surges on shared capacity. |
| **Performance** | &bull;&nbsp;Performance requirements are high, and workloads need to meet higher SLAs. <br/>&bull;&nbsp;Flexibility in scaling up individual workloads per department or team. |
| **Billing and cost management** | &bull;&nbsp;Cross charging requirements can be easily met by assigning dedicated capacities to an organizational entity (department, team, or project). <br/>&bull;&nbsp;Cost management can be delegated to respective teams to manage. |

### Pattern 4: Multiple Fabric tenants

When separate Fabric tenants are deployed, all instances of Fabric are separate entities with respect to governance, management, administration, scale, and storage.

The following points are true when using multiple Fabric tenants.

- There's complete segregation of resources across tenants.
- There's separate management planes across tenants.
- Tenants are separate entities and for all purposes they can have their own processes around governance and management, and separate administration.
- To share or access data between Fabric tenants, you can use [data pipelines](/fabric/data-factory/data-factory-overview#data-pipelines) or [data engineering](/fabric/data-engineering/data-engineering-overview) capabilities.

You might choose to implement this deployment pattern for the following reasons.

- The organization may end up with multiple Fabric tenants because of a business acquisition.
- The organization might choose to set up a Fabric tenant for business units or smaller subsidiaries.

## Contributors

**This article is maintained by Microsoft. It was originally written by the following contributors.**

- [Holly Kelly](https://www.linkedin.com/in/holly-kelly-9466063/) | Principal Program Manager
- [Gabi Muenster](https://www.linkedin.com/in/gabimuenster/) | Senior Program Manager
- [Sarath Sasidharan](https://www.linkedin.com/in/sarathsasidharan/) | Senior Program Manager
- Amanjeet Singh | Principal Program Manager
