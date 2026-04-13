---
title: Choose a Microsoft Fabric deployment pattern
description: Learn about common deployment scenarios for Microsoft Fabric.
author: lferdinand
ms.author: lferdinand
ms.date: 03/08/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
# Pandora-managed document. Edit freely, chunks sync automatically.
---

# Choose a Microsoft Fabric deployment pattern

When you deploy [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview), you need to decide how to structure capacities, workspaces, and items across your organization. The right deployment pattern depends on your requirements for governance, security, performance isolation, and cost management. This guide helps architects and platform teams evaluate four deployment patterns and understand the considerations and tradeoffs for each one.

## Four-level hierarchy

The following diagram shows the four-level hierarchy that defines all Fabric deployments.

:::image type="complex" source="../images/fabric-deployment-patterns-conceptual-overview.svg" alt-text="Diagram showing the Microsoft Fabric deployment hierarchy with tenant, capacities, workspaces, and items." lightbox="../images/fabric-deployment-patterns-conceptual-overview.svg"  border="false":::
   The diagram shows a Microsoft 365 tenant as the outermost boundary. Inside the tenant, two overlapping layers are visible: Capacities (labeled along the left edge with the Microsoft Fabric logo) and Fabric Domains (labeled along the right edge). Within both layers sit Workspaces (shown with a collaboration icon), and within Workspaces sit Items (shown with icons representing a pipeline, a bar chart report, a table/grid, and a lakehouse). A vertical line connects Items downward to OneLake, shown as a pill-shaped element at the bottom of the tenant boundary with the OneLake globe icon. On the left side of the diagram, two inbound networking controls are shown: Microsoft Entra ID Conditional Access (shield/lock icon) and Private Link (chain-link icon). On the right side, six outbound networking controls are shown: Managed Private Endpoint, Managed Virtual Network, On-Premises Data Gateway, Service Tags, Virtual Network Data Gateway, and Microsoft Entra ID Managed Identity.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/fabric-deployment-patterns.vsdx) of this architecture.*

The deployment hierarchy flows from your Microsoft 365 tenant down to individual items. Your choice of deployment pattern determines how you use each level.

- **Tenant level.** At the top is your Microsoft 365 tenant, which serves as the identity and administrative boundary for your organization. Your [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) tenant exists within this Microsoft 365 tenant, and all Fabric resources live within this single tenant boundary. Tenant-level settings, including [Microsoft Entra Conditional Access](/entra/identity/conditional-access/overview), [private links](/fabric/security/security-private-links-overview), and [sensitivity labels](/fabric/governance/information-protection), apply across all capacities and workspaces.

- **Capacity level.** Within an M365 tenant, you provision one or more Fabric capacities. Each capacity is bound to a specific Azure region and has a specific [F SKU](/fabric/enterprise/capacity-licensing-purchasing) that determines available compute resources measured in capacity units (CUs). Capacities control data residency and provide billing boundaries. A single capacity can host multiple workspaces.

- **Workspace level.** Each capacity contains one or more [workspaces](/fabric/get-started/workspaces). Workspaces are the primary containers for collaboration and governance. They define access control through four roles (Admin, Member, Contributor, and Viewer), support [Git integration](/fabric/cicd/git-integration/intro-to-git-integration) for version control, and serve as the scope for [deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines). A workspace belongs to exactly one capacity at a time. Same-region capacity migration is straightforward; cross-region migration is technically possible but most Fabric item types — including lakehouses, warehouses, notebooks, and pipelines — must be removed and recreated, so same-region migration is strongly preferred.

- **Item level.** Workspaces contain Fabric items such as lakehouses, warehouses, notebooks, pipelines, semantic models, reports, and dashboards. Items inherit workspace permissions by default. [OneLake security roles](/fabric/onelake/security/get-started-security#onelake-security-preview) provide granular access control at the table, folder, column, and row level, but apply only to users in the Viewer role. Workspace Admins, Members, and Contributors bypass OneLake security roles entirely.

The following licensing and workspace-type constraints often determine which deployment pattern is practical:

- **New workspaces start on shared capacity unless you reassign them.** Every tenant has a shared capacity that hosts My Workspaces and can host Pro or Premium Per User (PPU) workspaces. To implement a governed Fabric deployment pattern for production workloads, you typically reassign workspaces to a dedicated Fabric capacity in the tenant.

- **PPU is not a substitute for Fabric capacity.** PPU provides Power BI Premium features on a per-user basis, but it doesn't provision a Fabric capacity. To create or run non-Power BI Fabric items such as lakehouses, warehouses, and notebooks, you need an F capacity.

- **Workspace type affects what the pattern can host.** Fabric deployment patterns in this article assume Fabric workspaces backed by F SKUs. A and EM SKUs support Power BI items only, so they aren't sufficient for end-to-end Fabric deployment patterns.

- **Power BI viewer licensing can change the economics of a pattern.** On F64 and larger capacities, users with only a free license can view Power BI content if they have the Viewer role. On capacities smaller than F64, each Power BI consumer needs a Pro, PPU, or trial license. This threshold can materially affect whether a centralized pattern is cost-effective for large reader populations.

- **At least one Pro or PPU user is still needed for Power BI authoring and sharing.** Even when a workspace is backed by Fabric capacity, organizations still need users with Pro or PPU licenses to create Power BI items outside My Workspace and share them with others.

### Components

- **Microsoft 365 Tenant**: Identity and admin boundary for your organization. Hosts Entra ID (formerly Azure AD) for authentication and authorization.
- **Fabric Capacity**: Compute and billing resource provisioned in a specific Azure region (for example, East US, West Europe). See [Fabric capacity licensing and purchasing](/fabric/enterprise/capacity-licensing-purchasing) for available SKU options. Capacities can be paused to stop billing when not in use.
- **[Fabric Workspace](/fabric/get-started/workspaces)**: Collaboration container for Fabric items. Supports role-based access control, Git integration, and deployment pipelines. Workspaces can be assigned to Fabric Domains for logical grouping.
- **[Fabric Items](/fabric/get-started/fabric-home)**: Data and analytics artifacts such as Lakehouses, Data Warehouses, Notebooks, Pipelines, Dataflows, Semantic Models, Reports, and Dashboards.
- **[Fabric Domains](/fabric/governance/domains)**: Logical groupings that organize workspaces by business unit or subject area. Domains support delegated governance and are surfaced in the OneLake catalog for discovery and oversight.
- **[OneLake](/fabric/onelake/onelake-overview)**: Unified, hierarchical data lake with a tenant → workspace → item structure. All Fabric data is automatically stored in OneLake. OneLake supports ADLS Gen2 APIs, shortcuts to external storage, and integration with Azure Storage Explorer, AzCopy, and other ADLS Gen2 tools.
- **[OneLake catalog](/fabric/governance/onelake-catalog-overview)**: Centralized interface for discovering, governing, and securing Fabric data assets across the tenant. Users can interact with the catalog via familiar interfaces including Microsoft Teams, Excel, and Copilot Studio.

## Understand Fabric deployment levels

Your organization's structure and objectives — security, scale, governance, and application lifecycle — drive decisions at each of the four deployment levels (tenant, capacity, workspace, and item). For a detailed description of each level, see [Four-level hierarchy](#four-level-hierarchy).

- **Capacities control data residency and geographic distribution.** A large organization that has business units in separate geographical locations can use capacities to control where its data resides. Each capacity is bound to a specific Azure region, so provisioning capacities in different regions enables multi-geo deployments. [Fabric Domains](/fabric/governance/domains) allow a geographically distributed business unit to be governed as a single unit because domains can span workspaces and their associated capacities across regions.

- **Workspaces serve as the primary governance and security boundary.** Each workspace defines access control through four roles, supports version control through Git integration, and serves as the scope for deployment pipelines. For a full description of workspace roles and lifecycle features, see [Four-level hierarchy](#four-level-hierarchy). Organizations that require centralized collaboration and content discovery use should the [OneLake catalog](/fabric/governance/onelake-catalog-overview), which surfaces a unified discovery and governance experience over the Tenant's OneLake data access layer and enables users to find and interact with content from familiar tools such as Microsoft Teams and Excel.

- **Each level influences application lifecycle choices.** Features such as [deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) and [lifecycle management](/fabric/cicd/cicd-overview) require separate workspaces, so they aren't available in single-workspace patterns. Similarly, organizations that use [domains](/fabric/governance/domains) to group workspaces can delegate domain-level administration without granting tenant-admin privileges, which affects how teams manage releases and governance across business units.

### Common patterns across all deployments

All Fabric deployment patterns share the following foundational characteristics:

- **Workspaces as boundaries for scale, governance, and security.** Every deployment pattern uses [Fabric workspaces](/fabric/get-started/workspaces) as the primary unit for organizing items, assigning permissions, and scoping DevOps features. Regardless of which pattern you choose, workspaces define the boundary for collaboration and access control.

- **Fabric Domains for delegation across multiple workspaces and business units.** Use [Fabric Domains](/fabric/governance/domains) for delegation, to manage multiple workspaces that might belong to the same business unit, or when data that belongs to a business domain spans more than one workspace. You can set some tenant-level settings for managing and governing data [at the domain level](/fabric/governance/domains#domain-settings-delegation) and use domain-specific configuration for those settings.

- **Capacities for compute scaling with dedicated capacity per workspace for performance guarantees.** Use Fabric capacities to scale compute resources while provisioning dedicated capacities per workspace when specific performance levels must be met. Organizations that need workload isolation for performance-sensitive jobs can assign those workspaces to a separate capacity with a guaranteed CU allocation.

- **OneLake catalog for asset discovery and Secure tab for data security policies.** Use the [OneLake catalog](/fabric/governance/onelake-catalog-overview) to promote discovery and the use of data assets across your tenant. Use the [Secure tab in the OneLake catalog](/fabric/governance/secure-your-data) to view, monitor, and configure security roles across workspaces and items.

- **Extension to Microsoft Cloud features when native Fabric features are unavailable.** All deployment patterns can extend to use equivalent features from a Microsoft Cloud (Microsoft Azure, Microsoft 365, and others) when a feature isn't available natively in Fabric. For example, organizations can use [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) or [GitHub Actions](/azure/developer/github/github-actions) for CI/CD orchestration when Fabric deployment pipelines don't cover their cross-workspace automation requirements, or use [Microsoft Purview](/purview/learn-about-microsoft-purview) for enterprise-wide data governance that spans Fabric and non-Fabric data sources.

## Select a deployment pattern

The following scenarios describe common business requirements and show which deployment patterns address them. Use these scenarios as a starting point to identify the pattern that best fits your organization.

- **Scenario 1: Faster time to market with cross-team collaboration.** If your organization wants faster time to market by organizing teams that can cross-collaborate, with lower restrictions on data usage, a *monolithic* deployment pattern can be a good fit. In this scenario, your organization operates in and manages a single workspace.

  Use [Pattern 1: monolithic deployment](#pattern-1-monolithic-deployment).

- **Scenario 2: Isolated team environments with central infrastructure management.** If your organization wants to provide isolated environments for teams to work in, with a central team that is responsible for providing and managing infrastructure, you can implement *multiple workspaces* that either use a shared capacity or have separate capacities. This scenario also suits organizations that want to implement a data mesh architecture.

  Use [Pattern 2: multiple workspaces, single capacity](#pattern-2-multiple-workspaces-single-capacity) or [Pattern 3: multiple workspaces, separate capacities](#pattern-3-multiple-workspaces-separate-capacities).

- **Scenario 3: Full business-unit autonomy over data platforms.** If your organization wants an entirely decentralized model that gives business units or teams the freedom to control and manage their own data platforms, you can choose a deployment model that uses *separate workspaces* with dedicated capacity, or possibly multiple Fabric tenants.

  Use [Pattern 3: multiple workspaces, separate capacities](#pattern-3-multiple-workspaces-separate-capacities) or [Pattern 4: multiple Fabric tenants](#pattern-4-multiple-fabric-tenants).

- **Scenario 4: Hybrid approach combining multiple patterns.** Your organization might choose to combine multiple patterns to meet its requirements. For example, you might set up a single workspace for specific business units (a monolithic deployment pattern) while using separate, dedicated workspaces and separate capacities for other business units.

### Pattern 1: monolithic deployment

In this deployment pattern, you provision a single workspace to cater to all your use cases. All business units work within the same, single workspace.

:::image type="content" source="../images/fabric-deployment-pattern-1-monolithic-deployment.svg" alt-text="Diagram showing a single Fabric tenant with a single capacity and a single workspace." lightbox="../images/fabric-deployment-pattern-1-monolithic-deployment.svg" border="false":::

When you provision a single Fabric capacity and attach a single workspace to it, the following constraints and characteristics apply:

- All Fabric items share the same provisioned capacity. The amount of time a query or job takes to finish varies because other workloads use the same capacity.
- The workspace maximum capacity units (CUs) are limited to the largest possible F SKU or P SKU. For data engineering experiences, you can provision separate Spark pools to move the compute capacity that Fabric Spark requires outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units that share that workspace.
- All workspace items and data are in one region. You can't use this pattern for multi-geo scenarios.
- Features that rely on multiple workspaces, like [deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) and [lifecycle management](/fabric/cicd/cicd-overview), aren't available.
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) that are associated with a single workspace apply.
- Capacity limitations that are associated with a specific SKU apply.

#### When to choose this pattern

You might choose to implement this deployment pattern for one or more of the following reasons:

- Your organization doesn't have complex engineering requirements, it has a small user base, or its semantic models are small.
- Your organization operates in a single region.
- You're not primarily concerned with organizational separation between business units.
- Your organization doesn't require workspace-scoped features, such as sharing code repositories with Git.
- You want to implement a lakehouse medallion architecture. When your organization is limited to a single workspace, you can achieve separation between bronze, silver, and gold layers by creating separate lakehouses within the workspace.
- Your organization's business units share roles, and it's acceptable to have the same workspace-level permissions for users in the workspace. For example, when multiple users who belong to different business units are administrators of a single workspace, they have the same rights on all items in the workspace.
- Your organization can tolerate variable job completion times. If your organization doesn't have any requirements for performance guarantees (for example, a job must finish in a specific time period), it's acceptable to share a single provisioned capacity across business units. When a capacity is shared, users can run their queries at any time. The number of CUs that are available to run a job varies depending on what other queries are running on the capacity, which can lead to variable job completion times.
- Your organization can achieve all its business requirements (from a CU perspective) by using a single Fabric capacity.

#### Design-area considerations

The following table presents considerations that might influence your decision to adopt this deployment pattern:

| Aspect | Considerations |
|---|---|
| **Governance** | Lower governance mandates and restrictions on the platform are required. Suits smaller organizations that prefer faster time to market. Challenges might develop if governance requirements evolve to become more complex. |
| **Security: data plane** | Data can be shared across teams, so there's no need to restrict data between teams. Teams have ownership rights on the semantic models. They can read, edit, and modify data in OneLake. |
| **Security: control plane** | All users can collaborate in the same workspace. There are no restrictions on items. All users can read and edit all items. |
| **Administration** | Lower administration costs. No stringent need to track and monitor access and usage per team. Less stringent Fabric workload monitoring across teams. |
| **DevOps** | A single release for the entire platform. Less complicated release pipelines. |
| **Usability: administrators** | Fewer items to manage. No need for other provisioning or to handle requests from teams for new capacities or workspaces. Capacity administrators can be tenant administrators, so there's no need to create or manage other groups or teams. |
| **Usability: other roles** | Sharing the workspace with other users is acceptable. Collaboration among users is encouraged. |
| **Performance** | Isolation of workloads isn't mandatory. No strict performance service-level objectives (SLOs) need to be met. Throttling is possible when workloads compete for the same shared CUs. This pattern suits organizations with low concurrency or predictable workloads. |
| **Billing and cost management** | One single team can handle costs. There's no need to chargeback to different teams. |

### Pattern 2: multiple workspaces, single capacity

In this deployment pattern, you provision multiple workspaces on a single shared capacity. Because that capacity is shared across workspaces, workloads that run concurrently can affect the performance of jobs and interactive queries.

:::image type="content" source="../images/fabric-deployment-pattern-2-multiple-workspaces-single-capacity.svg" alt-text="Diagram showing a single Fabric tenant with a single capacity and two workspaces." lightbox="../images/fabric-deployment-pattern-2-multiple-workspaces-single-capacity.svg" border="false":::

When you provision a single Fabric capacity and attach multiple workspaces to it, the following characteristics apply:

- All Fabric items share the same provisioned capacity. The amount of time a query or job takes to finish varies because other workloads use the same capacity.
- The maximum CUs that a workspace can use is limited to the largest possible F SKU or P SKU. For data engineering experiences, you can provision separate Spark pools to move the compute capacity that Fabric Spark requires outside of provisioned CUs.
- Features that are scoped to a workspace apply across all business units that share that workspace.
- All workspace items and data are in one region. You can't use this pattern for multi-geo scenarios.
- You can use DevOps features that require separate workspaces, like [deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) and [lifecycle management](/fabric/cicd/cicd-overview).
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) that are associated with a single workspace apply.
- Capacity limitations that are associated with a specific SKU apply.

#### When to choose this pattern

You might choose to implement this deployment pattern for one or more of the following reasons:

- You want a hub-and-spoke architecture in which your organization centralizes some aspects of operating the analytics environment and decentralizes others.
- You want decentralization from an operational and management aspect but to varying degrees. For example, when building a medallion architecture, your organization might choose to host the bronze and silver layers in one workspace, with the gold layer deployed in a separate workspace. This separation often reflects distinct operational responsibilities, where one team manages the bronze and silver layers and another team operates and governs the gold layer.
- You aren't primarily concerned about performance management and isolating workloads from a performance perspective.
- Your organization doesn't need to deploy workloads across different geographical regions (all data must reside in one region).
- Your organization might require separation of workspaces for one or more of the following reasons:
  - Members of the team that is responsible for workloads are in different workspaces.
  - You want to create separate workspaces for each type of workload. For example, you might create a workspace for data ingestion (data pipelines, dataflow Gen2, or data engineering) and create a separate workspace for consumption through a data warehouse. This design works well when separate teams are responsible for each of the workloads.
  - You want to implement a data mesh architecture in which one or more workspaces are grouped together in a [Fabric domain](/fabric/governance/domains).
- Your organization might choose to deploy separate workspaces based on data classification.

#### Design-area considerations

The following table presents considerations that might influence your decision to choose this deployment pattern:

| Aspect | Considerations |
|---|---|
| **Governance** | Medium governance mandates and restrictions on the platform are required. The organization needs more granular control to govern departments, teams, and roles. |
| **Security: data plane** | Data restrictions are required, and you need to provide data protection based on access controls for departments, teams, and members. |
| **Security: control plane** | To avoid accidental corruption or actions by malicious users, you might need to provide controlled access on Fabric items by role. |
| **Administration** | You don't need to manage capacities because it's a single-capacity model. You can use workspaces to isolate departments, teams, and users. |
| **DevOps** | You can do independent releases per department, team, or workload. It's easier to meet development, testing, acceptance, and production (DTAP) requirements for teams when multiple workspaces are provisioned to address each release environment. |
| **Usability: administrators** | You don't need to provision multiple capacities. Tenant administrators typically administer capacity, so you don't need to manage other groups or teams. |
| **Usability: other roles** | Workspaces are available for each medallion layer. Fabric items are isolated per workspace, which helps to prevent accidental corruption. |
| **Performance** | Strict performance SLOs don't need to be met. Throttling is acceptable during peak periods. |
| **Billing and cost management** | You don't have a specific requirement to chargeback per team. A central team bears all costs. Infrastructure teams are owners of Fabric capacities in the organization. |

### Pattern 3: multiple workspaces, separate capacities

In this deployment pattern, you provision multiple workspaces across separate Fabric capacities, which provides governance and performance isolation between business units.

:::image type="content" source="../images/fabric-deployment-pattern-3-multiple-workspaces-multiple-capacities.svg" alt-text="Diagram showing a single Fabric tenant with two capacities, where the first capacity has two workspaces and the second capacity has one workspace." lightbox="../images/fabric-deployment-pattern-3-multiple-workspaces-multiple-capacities.svg" border="false":::

When you provision multiple Fabric capacities with their own workspaces, the following characteristics apply:

- The largest possible F SKU or P SKU attached to a workspace determines the maximum CUs that a workspace can use.
- Organizational and management decentralization is achieved by provisioning separate workspaces.
- Organizations can scale beyond one region by provisioning capacities and workspaces in different geographical regions.
- You can use the full capabilities of Fabric because business units can have one or more workspaces that are in separate capacities and grouped together through [Fabric domains](/fabric/governance/domains).
- [Workspace limitations](/fabric/get-started/workspaces#considerations-and-limitations) that are associated with a single workspace apply, but you can scale beyond these limits by creating new workspaces.
- Capacity limitations that are associated with a specific SKU apply, but you can scale CUs by provisioning separate capacities.
- All Fabric items in all workspaces in the tenant and their certification statuses can be discovered by using the [OneLake catalog](/fabric/governance/onelake-catalog-overview).
- Domains can group workspaces together so that a single business unit can operate and manage multiple workspaces.
- [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) reduce data movement by eliminating physical copies of data, while enabling controlled, cross‑workspace access through OneLake without transferring ownership of the underlying data.

#### When to choose this pattern

You might choose to implement this deployment pattern for one or more of the following reasons:

- Your organization wants to deploy architectural frameworks like data mesh or data fabric.
- You want to prioritize flexibility in how you structure capacities and workspaces.
- You operate in different geographical regions. In this case, provisioning a separate capacity and workspace is the driving force to move toward this multi-capacity and multi-workspace deployment pattern.
- You operate at large scale and have requirements to scale beyond the limits of a single-capacity SKU or a single workspace.
- You have workloads that must always finish within a specific time or meet a specific performance SLO. You can provision a separate workspace that's backed by a Fabric capacity to meet performance guarantees for those workloads.

#### Design-area considerations

The following table presents considerations that might influence your decision to choose this deployment pattern:

| Aspect | Considerations |
|---|---|
| **Governance** | You have a high degree of governance and management, and you need independence for each workspace. You can manage usage per department or business unit. You can conform to data residency requirements. You can isolate data based on regulatory requirements. |
| **Security: data plane** | Data access can be controlled per department, team, or users. You can isolate data based on Fabric item type. |
| **Security: control plane** | You can provide controlled access on Fabric items by role to avoid accidental corruption or actions by malicious users. |
| **Administration** | Granular administrator capabilities are restricted to departments, teams, or users. You have access to detailed monitoring requirements on usage or patterns of workloads. |
| **DevOps** | You can isolate DTAP environments by using different capacities. Independent releases are based on a department, team, or workload. |
| **Usability: administrators** | You get granular visibility into usage by department or team. You delegate capacity rights per department or team to support scaling and granular configuration. |
| **Usability: other roles** | Workspaces are available per medallion layer and capacity. Fabric items are isolated per workspace, which helps prevent accidental corruption. You have more options to prevent throttling that's caused by surges on shared capacity. |
| **Performance** | Performance requirements are high, and workloads need to meet higher SLOs. You have flexibility in scaling up individual workloads per department or team. |
| **Billing and cost management** | Cross-charging requirements can be easily met by assigning dedicated capacities to an organizational entity (department, team, or project). Cost management can be delegated to respective teams to manage. |

### Pattern 4: multiple Fabric tenants

When separate Fabric tenants are deployed, all instances of Fabric are separate entities with respect to governance, management, administration, scale, and storage.

The following characteristics apply when you use multiple Fabric tenants:

- Tenant resources are strictly segregated.
- Management planes between tenants are separate.
- Tenants are separate entities, each with its own governance and management processes, and each administered independently.
- You can use [data pipelines](/fabric/data-factory/data-factory-overview#data-pipelines) or [data engineering](/fabric/data-engineering/data-engineering-overview) capabilities to share or access data between Fabric tenants.

#### When to choose this pattern

You might choose to implement this deployment pattern for the following reasons:

- Your organization might end up with multiple Fabric tenants because of a business acquisition.
- Your organization might choose to set up a Fabric tenant specifically for a business unit or smaller subsidiary.

## Evaluate alternative platforms

If your organization’s requirements don't align with Fabric-based deployment models, consider the following constrained alternatives.

- **[Azure Data Factory](/azure/data-factory/introduction) + [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) or [OneLake](/fabric/onelake/onelake-overview) (including hybrid ADF-Fabric architectures).**  
- **[Azure Data Factory](/azure/data-factory/introduction) + [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) or [OneLake](/fabric/onelake/onelake-overview) (including hybrid ADF-Fabric architectures).**

  Organizations that need explicit orchestration control or phased modernization can use Azure Data Factory for ingestion and pipeline orchestration, with ADLS Gen2 as the storage foundation. In a hybrid model, ADF-managed data pipelines can load OneLake, while Microsoft Fabric handles all creation of analytical data assets. This approach supports incremental adoption of Fabric while preserving established integration patterns.

- **[Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) + [Azure Databricks](/azure/databricks/introduction/) + [Power BI](/power-bi/fundamentals/power-bi-overview).**

  Organizations that intentionally prefer a PaaS-based architecture over a unified SaaS platform may choose to build a data estate using ADLS Gen2 for storage, Databricks for data engineering and analytics, and Power BI for semantic modeling and reporting. This approach offers maximum control and flexibility at the cost of increased integration effort, operational complexity, and governance overhead compared to Fabric.


## Apply Well-Architected Framework considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The per-pattern tables earlier in this article use design areas (Governance, Security, Administration, DevOps, Usability, Performance, Billing) that are specific to Fabric deployment decisions. The following subsections provide complementary guidance organized by WAF pillar. Use the per-pattern tables to compare patterns side by side, and use these subsections for cross-cutting architectural guidance that applies regardless of which pattern you choose.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Built-in regional resiliency.** Microsoft Fabric provides built-in regional resiliency through availability zones where supported, automatically distributing resources across multiple zones without customer configuration. Availability zone support varies by Azure region. To verify whether your target region supports availability zones for Fabric, see [Fabric region availability](/fabric/admin/region-availability).

- **Disaster recovery requires opt-in and has caveats.** Cross-region recovery is available through an opt-in disaster recovery setting on the capacity settings page. Enabling the disaster recovery capacity setting replicates OneLake data across Azure paired regions using asynchronous replication.

  > [!IMPORTANT]
  > Some Azure regions lack paired regions that support Fabric, which may compromise disaster recovery capabilities even if data is replicated. Additionally, data replication is asynchronous, meaning data written immediately before a regional disaster may be lost. For more information, see [Reliability in Fabric](/azure/reliability/reliability-fabric).

- **Single-capacity patterns (1 and 2) concentrate risk in one region.** All workloads are in one Azure region. If the region experiences an outage, all workspaces are affected simultaneously. To protect against regional failure, configure the capacity setting to replicate OneLake data to a paired region. Plan for the recovery time needed to restore service in the paired region.

- **Multi-capacity patterns (3 and 4) provide natural regional isolation.** Capacities in different regions mean a regional outage affects only the capacities in that region. Workloads in other regions continue to operate. This pattern supports data residency requirements and provides the foundation for active-passive or active-active regional strategies.

- **Capacity pausing affects reliability.** When you pause a Fabric capacity to reduce costs, all workloads on that capacity become unavailable. Consider the reliability effect before you pause a capacity that supports production workloads.

- **OneLake shortcuts introduce external dependencies.** Shortcuts to external data sources introduce a dependency on the availability of those sources. If the external source is unavailable, items that rely on shortcuts might fail. Monitor the health of external data sources and plan for graceful degradation.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- **Layered security model spans three levels.** Fabric implements a layered security model that spans the tenant, workspace, and item levels. Your choice of deployment pattern determines how you segment security boundaries. Single-workspace patterns (Pattern 1) enforce uniform access, while multi-workspace patterns (Patterns 2, 3, and 4) enable per-team or per-business-unit security boundaries.

#### Identity and access

- **Enforce tenant-level authentication policies with Conditional Access.** Use [Microsoft Entra Conditional Access](/entra/identity/conditional-access/overview) to enforce tenant-level authentication policies such as multifactor authentication, device compliance, and location-based restrictions. Conditional Access requires a [Microsoft Entra ID P1](/entra/fundamentals/whatis#what-are-the-microsoft-entra-id-licenses) license.

- **Use workspace roles to control item access.** Assign [workspace roles](/fabric/fundamentals/roles-workspaces) (Admin, Member, Contributor, Viewer) to control who can create, edit, and consume items within a workspace. In multi-workspace patterns (2, 3, and 4), use separate workspaces to enforce role boundaries between business units.

- **Apply granular data-level access with OneLake security roles.** Use [OneLake security roles](/fabric/onelake/security/get-started-security#onelake-security-preview) to apply granular access control at the table, folder, column, and row level for users in the Viewer role. Admins, Members, and Contributors bypass these roles.

#### Network security

- **Use private links for inbound traffic.** Use [private links](/fabric/security/security-private-links-overview) to route inbound traffic over the Microsoft backbone instead of the public internet. Tenant-level private links apply to all workspaces. Workspace-level private links provide per-workspace granularity.

- **Use managed private endpoints for outbound Spark connections.** Use [managed private endpoints](/fabric/security/security-managed-private-endpoints-overview) to secure outbound connections from Fabric Spark workloads to firewall-protected data sources such as [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) and [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview).

- **Use VNet data gateways when tenant-level private links block on-premises gateways.** When tenant-level private links are enabled, on-premises data gateways can't register. Use a [VNet data gateway](/data-integration/vnet/overview) as a replacement for bridging on-premises or VNet-protected data sources.

#### Data protection

- **Apply sensitivity labels for end-to-end data classification.** For data classification and protection, apply [sensitivity labels](/fabric/governance/information-protection) from [Microsoft Purview Information Protection](/purview/information-protection) as data flows through Fabric. Labels follow the data from source to report.

- **Use audit logs and compliance tools for policy enforcement.** Review [audit logs](/fabric/security/security-overview#audit-logs) and use [Microsoft Purview Compliance Manager](/purview/compliance-manager-alert-policies) to detect and respond to policy violations.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Model costs before you deploy.** The deployment pattern you choose directly affects your cost structure. Use [Fabric pricing](https://azure.microsoft.com/pricing/details/microsoft-fabric/) and the [Fabric capacity estimator](https://www.microsoft.com/microsoft-fabric/capacity-estimator) to model costs for your scenario.

- **Right-size your capacity SKU.** Right-size your F SKU based on actual workload demand. Start with a smaller SKU and scale up as needed. Use the [Fabric capacity metrics app](/fabric/enterprise/metrics-app) to monitor consumption and identify over-provisioned or under-provisioned capacities.

- **Automate capacity pausing for non-production environments.** F SKU capacities can be paused to stop billing when not in use. In development or test environments, pause capacities outside of working hours. Consider automation through [Azure Resource Manager Fabric APIs](/rest/api/microsoftfabric/fabric-capacities/suspend) or scheduled pipelines. Pausing makes all workloads unavailable.

- **Single-capacity patterns (1 and 2) centralize billing but limit chargeback.** One capacity means one bill. Cost management is centralized, but chargeback to individual business units isn't possible because all workloads share the same capacity.

- **Multi-capacity patterns (3 and 4) enable per-team chargeback.** Each capacity generates its own Azure billing meter. You can chargeback costs to the business unit responsible for each capacity. You can independently right-size or pause each capacity based on the workload it supports.

- **Manage OneLake storage costs independently.** OneLake storage is billed at a pay-as-you-go rate per GB and doesn't consume capacity units. Regularly delete unused data (including soft-deleted data) and monitor storage through the [Fabric capacity metrics app](/fabric/enterprise/metrics-app).

- **Monitor Spark compute separately.** For data engineering workloads, you can provision separate Spark pools to move compute outside of the provisioned CU budget. Monitor Spark CU consumption to avoid unexpected costs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Use deployment pipelines for staged promotion.** Use [Fabric deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) to promote content through development, test, and production stages. Deployment pipelines require separate workspaces, so they aren't available in Pattern 1 (monolithic). In Patterns 2, 3, and 4, create dedicated workspaces for each DTAP stage.

  Capacity strategy varies by pattern.

  - In Pattern 2, all DTAP workspaces share the same capacity, which is cost-effective but provides no performance isolation between environments.
  - In Pattern 3, you can provision dedicated capacities per environment for full isolation, or use a shared capacity for dev/test with a separate production capacity to balance cost and isolation.

- **Plan pre-production environments as a workspace-level design decision.** Pattern 1 provides no pre-production separation because development and testing occur in the production workspace. Pattern 2 supports separate dev, test, and production workspaces on one shared capacity, which is suitable for functional validation but not production-like performance or resilience testing. Pattern 3 is the pattern that supports production-like pre-production validation through environment-aligned workspaces with capacity-level isolation. Pattern 4 is a tenant-boundary decision; each tenant can independently choose its own environment topology and doesn't need to match other tenants.

- **Connect workspaces to Git repositories for source control.** Connect workspaces to [Git repositories](/fabric/cicd/git-integration/intro-to-git-integration) for source control. Separate workspaces per team or workload (Patterns 2 and 3) align with standard branching strategies. In Pattern 1, all teams share a single repository, which can create merge contention.

- **Monitor capacity and workload health.** Use the [Fabric capacity metrics app](/fabric/enterprise/metrics-app) to monitor capacity consumption (CU usage, throttling, and overages). Use [workspace monitoring](/fabric/fundamentals/workspace-monitoring-overview) for detailed telemetry about individual workloads. In multi-capacity patterns (3 and 4), you can delegate monitoring to the team responsible for each capacity.

- **Delegate administration through Fabric Domains.** In Patterns 2 and 3, you can use [Fabric Domains](/fabric/governance/domains) to delegate tenant settings and workspace management to domain-level administrators without granting tenant-admin privileges. Pattern 1 cannot use domains because all items are in one workspace.

- **Manage with infrastructure as code.** Provision and manage Fabric capacities by using [Bicep](/azure/templates/microsoft.fabric/capacities?pivots=deployment-language-bicep) or [Terraform](/azure/templates/microsoft.fabric/capacities?pivots=deployment-language-terraform). Store infrastructure definitions in source control alongside application code.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Understand capacity sizing and throttling behavior.** Each capacity has a fixed CU allocation determined by its SKU. When demand exceeds available CUs, Fabric applies [throttling](/fabric/enterprise/throttling) and queues requests. Monitor throttling events through the [Fabric capacity metrics app](/fabric/enterprise/metrics-app) and scale up the SKU or distribute workloads across multiple capacities as needed.

- **Isolate performance-sensitive workloads on dedicated capacity.** In single-capacity patterns (1 and 2), all workloads compete for the same CUs. An expensive query or data pipeline can degrade interactive query performance for other users. In multi-capacity patterns (3 and 4), you can isolate performance-sensitive workloads on a dedicated capacity with a guaranteed CU allocation.

- **Configure Spark pools for data engineering workloads.** For data engineering workloads, provision [custom Spark pools](/fabric/data-engineering/create-custom-spark-pools) to control min/max node counts and enable autoscaling. Managed virtual networks disable Starter pools (prewarmed shared clusters), which increases session start time from seconds to 3 to 5 minutes.

- **Place capacities close to data producers and consumers.** In Pattern 3, you can provision capacities in regions close to data producers or consumers, which reduces cross-region latency. [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) can reference data in other regions, but cross-region reads incur latency and egress costs.

- **Apply workload-specific optimization techniques.** Use [Z-Ordering and V-Ordering](/fabric/data-engineering/delta-optimization-and-v-order) for Lakehouses to improve scan performance. For Warehouses, optimize query patterns to read smaller batches. Implement [Direct Lake](/fabric/fundamentals/direct-lake-overview) mode for Power BI reports to reduce capacity load compared to Import mode.

## Capability matrix

The following tables summarize the key differences in capabilities among Pattern 1 (monolithic), Pattern 2 (multiple workspaces, single capacity), Pattern 3 (multiple workspaces, separate capacities), and Pattern 4 (multiple tenants).

### Governance and administration

| Capability | Pattern 1: monolithic | Pattern 2: multiple workspaces, single capacity | Pattern 3: multiple workspaces, separate capacities | Pattern 4: multiple tenants |
| :--- | :--- | :--- | :--- | :--- |
| Governance complexity | Low | Medium | High | High |
| Per-department usage tracking | No | Limited [1] | Yes | Yes |
| Domain-based delegation | No | Yes | Yes | N/A [2] |
| Granular admin delegation | No | Limited [1] | Yes | Yes |
| Data residency compliance | Single region only | Single region only | Multi-region | Multi-region |
| Regulatory data isolation | No | Limited [1] | Yes | Yes |

[1] Workspaces provide some isolation, but all workspaces share a single capacity, which limits the granularity of usage tracking and administration.

[2] Pattern 4 uses separate tenants rather than domains. Each tenant has its own administration model.

### Security

| Capability | Pattern 1: monolithic | Pattern 2: multiple workspaces, single capacity | Pattern 3: multiple workspaces, separate capacities | Pattern 4: multiple tenants |
| :--- | :--- | :--- | :--- | :--- |
| Data plane isolation between teams | No | Yes | Yes | Yes |
| Control plane isolation (item-level access) | No | Yes | Yes | Yes |
| Workspace role boundaries between business units | No | Yes | Yes | Yes |
| Tenant-level security segregation | N/A | N/A | N/A | Yes |

### DevOps and lifecycle management

| Capability | Pattern 1: monolithic | Pattern 2: multiple workspaces, single capacity | Pattern 3: multiple workspaces, separate capacities | Pattern 4: multiple tenants |
| :--- | :--- | :--- | :--- | :--- |
| [Deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines) | No [3] | Yes | Yes | Yes |
| [Git integration](/fabric/cicd/git-integration/intro-to-git-integration) | Limited [4] | Yes | Yes | Yes |
| Independent releases per team | No | Yes | Yes | Yes |
| DTAP environment isolation | No | Yes | Yes (across capacities) | Yes (across tenants) |

[3] Deployment pipelines require separate workspaces, which aren't available in a monolithic single-workspace pattern.

[4] Git integration is available but all teams share a single repository, which can create merge contention.

### Performance and scale

| Capability | Pattern 1: monolithic | Pattern 2: multiple workspaces, single capacity | Pattern 3: multiple workspaces, separate capacities | Pattern 4: multiple tenants |
| :--- | :--- | :--- | :--- | :--- |
| Workload isolation for performance | No | No | Yes | Yes |
| Multi-geo deployment | No | No | Yes | Yes |
| Scale beyond single SKU limits | No | No | Yes | Yes |
| Performance SLO guarantees | No | No | Yes | Yes |
| Throttling risk from shared capacity | High | High | Low [5] | Low |

[5] Throttling risk is low when workloads are on dedicated capacities, but throttling can still occur within a single capacity if demand exceeds available CUs.

### Billing and cost management

| Capability | Pattern 1: monolithic | Pattern 2: multiple workspaces, single capacity | Pattern 3: multiple workspaces, separate capacities | Pattern 4: multiple tenants |
| :--- | :--- | :--- | :--- | :--- |
| Centralized billing | Yes | Yes | No [6] | No |
| Per-team chargeback | No | No | Yes | Yes |
| Independent capacity pausing | N/A (single capacity) | N/A (single capacity) | Yes | Yes |
| Cost delegation to teams | No | No | Yes | Yes |

[6] Each capacity generates its own billing meter, so billing is distributed across capacities rather than centralized.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Amanjeet Singh](https://www.linkedin.com/in/amanjeetsingh2004/) | Principal Program Manager

Other contributors:

- [Holly Kelly](https://www.linkedin.com/in/holly-kelly-9466063/) | Principal Program Manager
- [Gabi Muenster](https://www.linkedin.com/in/gabimuenster/) | Senior Program Manager
- [Lorrin Ferdinand](https://www.linkedin.com/in/lorrin-ferdinand/) | Principal Consultant
- [Sarath Sasidharan](https://www.linkedin.com/in/sarathsasidharan/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Fabric concepts and licenses](/fabric/enterprise/licenses)
- [Fabric workspaces](/fabric/get-started/workspaces)
- [Fabric domains](/fabric/governance/domains)
- [What is OneLake?](/fabric/onelake/onelake-overview)
- [Fabric deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines)

## Related resources

- [Technology choices overview](technology-choices-overview.md)
- [Analytics end-to-end with Microsoft Fabric](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
- [Enterprise business intelligence with Microsoft Fabric](../../example-scenario/analytics/enterprise-bi-microsoft-fabric.yml)
- [Build a greenfield lakehouse with Microsoft Fabric](../../example-scenario/data/greenfield-lakehouse-fabric.yml)
- [Reliability in Microsoft Fabric](/azure/reliability/reliability-fabric)
- [Fabric security overview](/fabric/security/security-overview)
