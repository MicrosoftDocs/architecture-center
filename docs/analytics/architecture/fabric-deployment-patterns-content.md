This article describes four deployment patterns that you can choose from when you deploy Microsoft Fabric. Learn about considerations, recommendations, and potential nonreversible decisions for each deployment pattern.

## Architecture

The following diagram shows the four-level hierarchy that defines all Fabric deployments:

:::image type="content" source="../media/fabric-deployment-patterns-conceptual-overview.svg" alt-text="Diagram showing the Microsoft Fabric deployment hierarchy: M365 Tenant contains Capacities (region-bound), which contain Workspaces, which contain Items. Fabric Domains group workspaces logically across capacities, and OneLake provides unified storage across all levels." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/fabric-deployment-patterns.vsdx) of this architecture.*

### Workflow

The deployment hierarchy flows from the Microsoft 365 tenant down to individual items:

- **Tenant level**: At the top is your Microsoft 365 tenant, which contains your Fabric tenant. All Fabric resources exist within this single tenant boundary. Tenant-level settings (Conditional Access, Private Links, sensitivity labels) apply across all capacities and workspaces.

- **Capacity level**: Within a M365 tenant, you provision one or more Fabric capacities. Each capacity is region-bound and has a specific SKU (F2, F4, F64, etc.) that determines compute resources (capacity units). Capacities control data residency and provide billing boundaries. A capacity can host multiple workspaces.

- **Workspace level**: Each capacity contains one or more workspaces. Workspaces are the primary containers for collaboration and governance. They define access control (Admin, Member, Contributor, Viewer roles), support Git integration for version control, and serve as the scope for deployment pipelines. A workspace belongs to exactly one capacity at a time but can be migrated between capacities within the same region.

- **Item level**: Workspaces contain Fabric items—lakehouses, warehouses, notebooks, pipelines, semantic models, reports, and more. Items inherit workspace permissions by default. OneLake security roles provide granular row- and column-level access control for data assets.

**Cross-cutting concepts** span the hierarchy:

- **Fabric Domains**: Logical groupings of workspaces (potentially across multiple capacities and regions) that represent a business unit or subject area. Domains enable delegated administration and governance.
- **OneLake**: A single, tenant-wide data lake that provides unified storage for all Fabric items. OneLake is automatically provisioned—no separate deployment is needed. It integrates with Azure Data Lake Storage Gen2 APIs and supports shortcuts to external data sources.

### Components

- **Microsoft 365 Tenant**: Identity and admin boundary for your organization. Hosts Entra ID (formerly Azure AD) for authentication and authorization.
- **[Fabric Capacity](/fabric/enterprise/licenses#capacity)**: Compute and billing resource provisioned in a specific Azure region (for example, East US, West Europe). Available SKUs: F2, F4, F8, F16, F32, F64, F128, F256, F512, F1024, F2048. Capacities can be paused to stop billing when not in use.
- **[Fabric Workspace](/fabric/get-started/workspaces)**: Collaboration container for Fabric items. Supports role-based access control, Git integration, and deployment pipelines. Workspaces can be assigned to Fabric Domains for logical grouping.
- **[Fabric Items](/fabric/get-started/fabric-home)**: Data and analytics artifacts such as Lakehouses, Data Warehouses, Notebooks, Pipelines, Dataflows, Semantic Models, Reports, and Dashboards.
- **[Fabric Domains](/fabric/governance/domains)**: Logical groupings used in Microsoft Fabric to organize workspaces and data assets by business unit or subject area. Domains support delegated governance and are surfaced in the OneLake catalog for discovery and oversight.
- **[OneLake](/fabric/onelake/onelake-overview)**: Unified, hierarchical data lake with a tenant → workspace → item structure. All Fabric data is automatically stored in OneLake. OneLake supports ADLS Gen2 APIs, shortcuts to external storage, and integration with Azure Storage Explorer, AzCopy, and other ADLS Gen2 tools.
- **[OneLake catalog](/fabric/governance/onelake-catalog-overview)**: Centralized interface for discovering, governing, and securing Fabric data assets across the tenant. Users can interact with the catalog via familiar interfaces including Microsoft Teams, Excel, and Copilot Studio.

### Alternatives

- **Azure Synapse Analytics**: If your organization requires more granular control over networking (customer-managed VNets, custom DNS, firewall rules that Fabric doesn't expose), Synapse Analytics provides dedicated SQL pools and Spark pools with deeper Azure integration. However, it requires more operational overhead (manual scaling, infrastructure provisioning) compared to Fabric's managed approach.

- **Azure Data Lake Storage Gen2 + Azure Databricks + Power BI**: If your organization wants more control instead of a single SaaS platform, you can build a data estate using ADLS Gen2 for storage, Databricks for end-to-end processing, and Power BI for reporting.

## Deployment patterns

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

For example, an organization can use [domains](/fabric/governance/domains) to group workspaces in Fabric. Similarly, organizations that require centralized collaboration and content discovery can leverage the [OneLake catalog](/fabric/governance/onelake-catalog-overview), which surfaces a unified discovery and governance experience over the Tenant's OneLake data access layer and enables users to find and interact with content from familiar tools such as Microsoft Teams and Excel.

In Fabric, a large organization that has business units in separate geographical locations can use capacities to control where its data resides. Fabric domains allow a geographically distributed business unit to be governed as a single unit. This is possible because domains can span workspaces and their associated capacities across regions.

For more information about Fabric levels and their role in choosing a deployment pattern, see [Microsoft Fabric concepts and licenses](/fabric/enterprise/licenses).

## How Fabric deployment patterns align

All Fabric deployment patterns:

- Use Fabric workspaces as boundaries for scale, governance, and security.
- Use [Fabric domains](/fabric/governance/domains) for delegation, to manage multiple workspaces that might belong to the same business unit, or when data that belongs to a business domain spans more than one workspace. You can set some tenant-level settings for managing and governing data [at the domain level](/fabric/governance/domains#domain-settings-delegation) and use domain-specific configuration for those settings.
- Use Fabric capacities to scale compute resources while provisioning dedicated capacities per workspace when specific performance levels must be met.
- Extend to use equivalent features from a Microsoft Cloud (Microsoft Azure, Microsoft 365, and others) when a feature isn't available in Fabric.
- Use a [OneLake catalog](/fabric/governance/onelake-catalog-overview) to promote discovery and the use of data assets.
- Use [OneLake security](/fabric/onelake/security/get-started-security) to set up data security policies for data assets.

### Scenarios based on business requirements

This article uses the following scenarios to describe how each deployment pattern can address various business requirements:

- **Scenario 1**: For organizations that want to have faster (or slower) time to market by organizing teams that can cross-collaborate, with lower restrictions on data usage. In this scenario, an organization can benefit by using a *monolithic* deployment pattern. The organization operates in and manages a single workspace.

  For more information, see [Pattern 1: Monolithic deployment](#pattern-1-monolithic-deployment).
- **Scenario 2**: For organizations that want to provide isolated environments for teams to work in, with a central team that is responsible for providing and managing infrastructure. This scenario also suits organizations that want to implement data mesh. In this scenario, an organization can implement *multiple workspaces* that either use a shared capacity or have separate capacities.

  For more information, see [Pattern 2: Multiple workspaces backed by a single Fabric capacity](#pattern-2-multiple-workspaces-backed-by-a-single-fabric-capacity) and [Pattern 3: Multiple workspaces backed by separate capacities](#pattern-3-multiple-workspaces-backed-by-separate-capacities).
- **Scenario 3**: For organizations that want an entirely decentralized model that gives business units or teams the freedom to control and manage their own data platforms. In this scenario, an organization can choose a deployment model in which it uses *separate workspaces*, each with dedicated capacity, or possibly with multiple Fabric tenants.

  For more information, see [Pattern 3: Multiple workspaces backed by separate capacities](#pattern-3-multiple-workspaces-backed-by-separate-capacities) and [Pattern 4: Multiple Fabric tenants](#pattern-4-multiple-fabric-tenants).
- **Scenario 4**: An organization might choose to use a hybrid approach in which it combines multiple patterns to achieve its requirements. For example, an organization might set up a single workspace for specific business units (a monolithic deployment pattern) while using separate, dedicated workspaces and separate capacities for other business units.

## Pattern 1: Monolithic deployment

In this deployment pattern, you provision a single workspace to cater to all your use cases. All business units work within the same, single workspace.

:::image type="content" source="../media/fabric-deployment-pattern-1-monolithic-deployment.svg" alt-text="Diagram that shows a single Fabric tenant that has a single capacity and a single workspace." border="false":::

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
| **Administration** | The organization has:<br/><br/>- Lower administration costs. <br/>- No stringent need to track and monitor access and usage per team. <br/>- Less stringent Fabric workload monitoring across teams. |
| **DevOps** | DevOps benefits from:<br/><br/>- A single release for the entire platform. <br/>- Less complicated release pipelines. |
| **Usability - Administrators** | - It's easier for administrators to manage because they have fewer items to manage. <br/>- There's no need for other provisioning or to handle requests from teams for new capacities or workspaces. <br/>- Capacity administrators can be tenant administrators, so there's no need to create or manage other groups or teams. |
|  **Usability - Other roles** | - It's acceptable to share the workspace with other users. <br/>- Collaboration among users is encouraged. |
| **Performance** | - Isolation of workloads isn't mandatory. <br/>- No strict performance service-level objectives (SLOs) need to be met. <br/>- Throttling isn't likely. |
| **Billing and cost management** | - One, single team can handle costs. <br/>- There's no need to chargeback to different teams. |

## Pattern 2: Multiple workspaces backed by a single Fabric capacity

In this deployment pattern, you use separate workspaces. Because a single capacity is shared across workspaces, workloads that run concurrently can affect the performance of jobs and interactive queries.

:::image type="content" source="../media/fabric-deployment-pattern-2-multiple-workspaces-single-capacity.svg" alt-text="Diagram that shows a single Fabric tenant that contains a single capacity and two workspaces." border="false":::

When you provision a single Fabric capacity and attach multiple workspaces to it, the following points are true:

- All Fabric items share the same provisioned capacity. The amount of time a query or job takes to finish varies because other workloads use the same capacity.
- The maximum CUs that a workspace can use is limited to the largest possible F SKU or P SKU. For data engineering experiences, you can provision separate Spark pools to move the compute capacity that Fabric Spark requires outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units that share that workspace.
- All workspace items and data are in one region. You can't use this pattern for multi-geo scenarios.
- You can use DevOps features that require separate workspaces, like for deployment pipelines and lifecycle management.
- [Limitations](/fabric/fundamentals/workspaces#considerations-and-limitations) that are associated with a single workspace apply.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) that are associated with a specific SKU apply.

You might choose to implement this deployment pattern for one or more of the following reasons:

- You want a hub-and-spoke architecture in which your organization centralizes some aspects of operating the analytics environment and decentralizes others.
- You want decentralization from an operational and management aspect but to varying degrees. For example, when building a medallion architecture, an organization may choose to host the bronze and silver layers in one workspace, with the gold layer deployed in a separate workspace. This separation often reflects distinct operational responsibilities, where one team manages the bronze and silver layers and another team operates and governs the gold layer.
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
| **Performance** | - Strict performance SLOs don't need to be met. <br/>- Throttling is acceptable during peak periods. |
| **Billing and cost management** | - You don't have a specific requirement to chargeback per team. <br/>- A central team bears all costs. <br/>- Infrastructure teams are owners of Fabric capacities in the organization. |

## Pattern 3: Multiple workspaces backed by separate capacities

In this deployment pattern, you achieve separation between business units for governance and performance.

:::image type="content" source="../media/fabric-deployment-pattern-3-multiple-workspaces-multiple-capacities.svg" alt-text="Diagram that shows a single Fabric tenant that contains two capacities. The first capacity has two workspaces. The second capacity has one workspace." border="false":::

When you provision multiple Fabric capacities with their own workspaces, the following points are true:

- The largest possible F SKU or P SKU attached to a workspace determines the maximum CUs that a workspace can use.
- Organizational and management decentralization is achieved by provisioning separate workspaces.
- Organizations can scale beyond one region by provisioning capacities and workspaces in different geographical regions.
- You can use the full capabilities of Fabric because business units can have one or more workspaces that are in separate capacities and grouped together through Fabric domains.
- [Limitations](/fabric/fundamentals/workspaces#considerations-and-limitations) that are associated with a single workspace apply, but you can scale beyond these limits by creating new workspaces.
- [Capacity limitations](/fabric/enterprise/licenses#capacity-license) that are associated with a specific SKU apply, but you can scale CUs by provisioning separate capacities.
- All Fabric items in all workspaces in the tenant and their certification statuses can be discovered by using a OneLake catalog.
- Domains can group workspaces together so that a single business unit can operate and manage multiple workspaces.
- [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) reduce data movement by eliminating physical copies of data, while enabling controlled, cross‑workspace access through OneLake without transferring ownership of the underlying data.

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
| **Usability - Administrators** | - You get granular visibility into usage by department or team. <br/>- You delegate capacity rights per department or team to support scaling and granular configuration. |
| **Usability - Other roles** | - Workspaces are available per medallion layer and capacity. <br/>- Fabric items are isolated per workspace, which helps prevent accidental corruption. <br/>- You have more options to prevent throttling that's caused by surges on shared capacity. |
| **Performance** | - Performance requirements are high, and workloads need to meet higher SLOs. <br/>- You have flexibility in scaling up individual workloads per department or team. |
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

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The per-pattern tables earlier in this article use design areas (Governance, Security, Administration, DevOps, Usability, Performance, Billing) that are specific to Fabric deployment decisions. The following subsections provide complementary guidance organized by WAF pillar. Use the per-pattern tables to compare patterns side by side, and use these subsections for cross-cutting architectural guidance that applies regardless of which pattern you choose.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Fabric provides built-in regional resiliency through availability zones where supported, automatically distributing resources across multiple zones without customer configuration. Cross-region recovery is available through an opt-in disaster recovery setting on the capacity settings page. Enabling the disaster recovery capacity setting replicates OneLake data across Azure paired regions using asynchronous replication.

> [!IMPORTANT]
> Some Azure regions lack paired regions that support Fabric, which may compromise disaster recovery capabilities even if data is replicated. Additionally, data replication is asynchronous, meaning data written immediately before a regional disaster may be lost. For more information, see [Reliability in Fabric](/azure/reliability/reliability-fabric).

Consider the following reliability implications when you choose a deployment pattern:

- **Single-capacity patterns (1 and 2)**: All workloads are in one Azure region. If the region experiences an outage, all workspaces are affected simultaneously. To protect against regional failure, configure the capacity setting to replicate OneLake data to a paired region. Plan for the recovery time needed to restore service in the paired region.
- **Multi-capacity patterns (3 and 4)**: Capacities in different regions provide natural regional isolation. A regional outage affects only the capacities in that region. Workloads in other regions continue to operate. This pattern supports data residency requirements and provides the foundation for active-passive or active-active regional strategies.
- **Capacity pausing**: When you pause a Fabric capacity to reduce costs, all workloads on that capacity become unavailable. Consider the reliability effect before you pause a capacity that supports production workloads.
- **OneLake shortcuts**: Shortcuts to external data sources introduce a dependency on the availability of those sources. If the external source is unavailable, items that rely on shortcuts might fail. Monitor the health of external data sources and plan for graceful degradation.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Fabric implements a layered security model that spans the tenant, workspace, and item levels. Your choice of deployment pattern determines how you segment security boundaries.

#### Identity and access

- Use [Microsoft Entra Conditional Access](/entra/identity/conditional-access/overview) to enforce tenant-level authentication policies such as multifactor authentication, device compliance, and location-based restrictions. Conditional Access requires a Microsoft Entra ID P1 license.
- Assign [workspace roles](/fabric/fundamentals/roles-workspaces) (Admin, Member, Contributor, Viewer) to control who can create, edit, and consume items within a workspace. In multi-workspace patterns (2, 3, and 4), use separate workspaces to enforce role boundaries between business units.
- Use [OneLake security roles](/fabric/onelake/security/get-started-security) (preview) to apply granular access control at the table, folder, column, and row level for users in the Viewer role. Admins, Members, and Contributors bypass these roles.

#### Network security

- Use [private links](/fabric/security/security-private-links-overview) to route inbound traffic over the Microsoft backbone instead of the public internet. Tenant-level private links apply to all workspaces. Workspace-level private links (F SKU only) provide per-workspace granularity.
- Use [managed private endpoints](/fabric/security/security-managed-private-endpoints-overview) to secure outbound connections from Fabric Spark workloads to firewall-protected data sources such as Azure Data Lake Storage Gen2 and Azure SQL Database.
- When tenant-level private links are enabled, on-premises data gateways can't register. Use a [VNet data gateway](/data-integration/vnet/overview) as a replacement for bridging on-premises or VNet-protected data sources.

#### Data protection

- For data classification and protection, apply [sensitivity labels](/fabric/governance/information-protection) from Microsoft Purview Information Protection as data flows through Fabric. Labels follow the data from source to report.
- Review [audit logs](/fabric/security/security-overview#audit-logs) and use [Microsoft Purview Compliance Manager](/purview/compliance-manager-alert-policies) to detect and respond to policy violations.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The deployment pattern you choose directly affects your cost structure. Use [Fabric pricing](https://azure.microsoft.com/pricing/details/microsoft-fabric/) and the [Fabric capacity estimator](https://www.microsoft.com/microsoft-fabric/capacity-estimator) to model costs for your scenario.

- **Capacity sizing**: Right-size your F SKU based on actual workload demand. Start with a smaller SKU and scale up as needed. Use the [Fabric capacity metrics app](/fabric/enterprise/metrics-app) to monitor consumption and identify over-provisioned or under-provisioned capacities.
- **Capacity pausing**: F SKU capacities can be paused to stop billing when not in use. In development or test environments, pause capacities outside of working hours. Consider automation through Azure Resource Manager APIs or scheduled pipelines. Important: Pausing makes all workloads unavailable (see Reliability).
- **Single-capacity patterns (1 and 2)**: One capacity means one bill. Cost management is centralized, but chargeback to individual business units isn’t possible because all workloads share the same capacity.
- **Multi-capacity patterns (3 and 4)**: Each capacity generates its own Azure billing meter. You can chargeback costs to the business unit responsible for each capacity. You can independently right-size or pause each capacity based on the workload it supports.
- **OneLake storage**: OneLake storage is billed at a pay-as-you-go rate per GB and doesn't consume capacity units. Regularly delete unused data (including soft-deleted data) and monitor storage through the capacity metrics app.
- **Spark compute**: For data engineering workloads, you can provision separate Spark pools to move compute outside of the provisioned CU budget. Monitor Spark CU consumption to avoid unexpected costs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **CI/CD and deployment pipelines**: Use [Fabric deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) to promote content through development, test, and production stages. Deployment pipelines require separate workspaces, so they aren't available in Pattern 1 (monolithic). In Patterns 2, 3, and 4, create dedicated workspaces for each DTAP stage. **Capacity strategy varies by pattern**: In Pattern 2, all DTAP workspaces share the same capacity, which is cost-effective but provides no performance isolation between environments. In Pattern 3, you can provision dedicated capacities per environment for full isolation, or use a shared capacity for dev/test with a separate production capacity to balance cost and isolation. Consider pausing non-production capacities outside of working hours to optimize costs.
- **Git integration**: Connect workspaces to [Git repositories](/fabric/cicd/git-integration/intro-to-git-integration) for source control. Separate workspaces per team or workload (Patterns 2 and 3) align with standard branching strategies. In Pattern 1, all teams share a single repository, which can create merge contention.
- **Monitoring**: Use the [Fabric capacity metrics app](/fabric/enterprise/metrics-app) to monitor capacity consumption (CU usage, throttling, and overages). Use [workspace monitoring](/fabric/fundamentals/workspace-monitoring-overview) for detailed telemetry about individual workloads. In multi-capacity patterns (3 and 4), you can delegate monitoring to the team responsible for each capacity.
- **Administration delegation**: In Patterns 2 and 3, you can use [Fabric domains](/fabric/governance/domains) to delegate tenant settings and workspace management to domain-level administrators without granting tenant-admin privileges. Pattern 1 doesn't benefit from domains because all items are in one workspace.
- **Infrastructure as code**: Provision and manage Fabric capacities by using [Azure Resource Manager templates](/azure/templates/microsoft.fabric/capacities), Bicep, or Terraform. Store infrastructure definitions in source control alongside application code.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Capacity sizing and scaling**: Each capacity has a fixed CU allocation determined by its SKU. When demand exceeds available CUs, Fabric applies [throttling](/fabric/enterprise/throttling) and queues requests. Monitor throttling events through the capacity metrics app and scale up the SKU or distribute workloads across multiple capacities as needed.
- **Workload isolation**: In single-capacity patterns (1 and 2), all workloads compete for the same CUs. An expensive query or data pipeline can degrade interactive query performance for other users. In multi-capacity patterns (3 and 4), you can isolate performance-sensitive workloads on a dedicated capacity with a guaranteed CU allocation.
- **Spark pools**: For data engineering workloads, provision [custom Spark pools](/fabric/data-engineering/create-custom-spark-pools) to control min/max node counts and enable autoscaling. Managed virtual networks disable Starter pools (prewarmed shared clusters), which increases session start time from seconds to 3–5 minutes.
- **Multi-geo performance**: In Pattern 3, you can provision capacities in regions close to data producers or consumers, which reduces cross-region latency. OneLake shortcuts can reference data in other regions, but cross-region reads incur latency and egress costs.
- **Optimization techniques**: Use [Z-Ordering and V-Ordering](/fabric/data-engineering/delta-optimization-and-v-order) for Lakehouses to improve scan performance. For Warehouses, optimize query patterns to read smaller batches. Implement [Direct Lake](/fabric/fundamentals/direct-lake-overview) mode for Power BI reports to reduce capacity load compared to Import mode.

### Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Amanjeet Singh](https://www.linkedin.com/in/amanjeetsingh2004/) | Principal Program Manager

Other contributors:


- [Holly Kelly](https://www.linkedin.com/in/holly-kelly-9466063/) | Principal Program Manager
- [Gabi Muenster](https://www.linkedin.com/in/gabimuenster/) | Senior Program Manager
- [Lorrin Ferdinand](https://www.linkedin.com/in/lorrin-ferdinand/) | Principal Consultant
- [Sarath Sasidharan](https://www.linkedin.com/in/sarathsasidharan/) | Senior Program Manager


*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Microsoft Fabric?](/fabric/fundamentals/microsoft-fabric-overview)
- [Microsoft Fabric concepts and licenses](/fabric/enterprise/licenses)
- [Fabric workspaces](/fabric/get-started/workspaces)
- [Fabric domains](/fabric/governance/domains)
- [What is OneLake?](/fabric/onelake/onelake-overview)
- [Fabric deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines)
- [Reliability in Microsoft Fabric](/azure/reliability/reliability-fabric)
- [Fabric security overview](/fabric/security/security-overview)

## Related resources

- [Analytics end-to-end with Microsoft Fabric](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
- [Enterprise business intelligence with Microsoft Fabric](../../example-scenario/analytics/enterprise-bi-microsoft-fabric.yml)
- [Build a greenfield lakehouse with Microsoft Fabric](../../example-scenario/data/greenfield-lakehouse-fabric.yml)
