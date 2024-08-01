This article describes how to implement a [medallion lakehouse](/azure/databricks/lakehouse/medallion) for a solution-focused use case.

> [!IMPORTANT]
> ![GitHub logo](_images/github.svg) This guidance is supported by an [example implementation](https://github.com/azure-samples/data-factory-to-databricks) that demonstrates a baseline Azure Data Factory setup on Azure. You can use this implementation as a foundation for further solution development in your first step toward production.

The solution uses a hub-and-spoke network topology with landing zones that follow the Cloud Adoption Framework for Azure best practices.

## Context and key design decisions

This design covers Contoso, a mid-to-large organization, embarking on its journey to the Azure cloud with the support of automation.

Contoso has an established Azure cloud foundation with an [enterprise landing zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). Leadership is preparing to take their first data workloads to the cloud, guided by the [Azure Well-Architected Framework](/azure/well-architected/).

This initial use case involves the following scenarios:

- Data is sourced from an on-premises financial operation system.
- Data is copied to the cloud for analytical use cases.
- Contoso establishes an enterprise data science capability.

### Key requirements

- The finance department and other corporate functions primarily use the solution as an analytical and reporting system.

- The on-premises source system has the following properties:

  - Currently estimated to be 1 terabyte (TB) with a 5% annual expected growth.
  
  - Has a batch update process that is scheduled each night, typically finishing before 3am (unless ends of financial year updates are required).
  
  - The solution must minimize its effect on the source system.
  
- Financial users should have the ability to view data as "it was" at any given point in time.

- The initial use case targets analytical and management reporting, with the ability to self-serve. This solution design should also serve as the foundation to build an enterprise data science capability upon.

- The data is classified "Company Confidential," so the solution MUST have effective security controls and monitoring to both the components and data accessed/used.

  - All data should be secured with strong encryption at rest and in transit.

- Contoso has an enterprise data model that the finance data is a subset of. The key data elements must be cleansed, modeled, and conformed to the various reporting hierarchies before being served for reporting.  

- Ingested source data that isn’t currently mapped to the enterprise model MUST be retained and made available for future analysis and use cases.

- The solution must be updated daily, based on source feeds availability with elastic compute optionality targeting sub-90 minutes for an end-to-end solution update.

- The solution must support the target service level agreements (SLAs) of:

  - 99.5% target uptime (or about 1 day, 20 hours downtime within a year).
  
  - Recovery point objective (RPO) of three days.
  
  - Recovery time objective (RTO) of one day.
  
- The solution should be designed for the future, accommodating future growth and capability extension without fundamental redesign.

- The solution must support the expected usage of:

  - 200 managers, financial controllers, and analysts attached to the finance department with an estimated growth of <5% annually.

  - 100 analysts attached to other corporate functions with an estimated growth of <5% annually.

  - Only Contoso employees can access the solution. This control explicitly excludes any direct access by 3rd parties or externals.

- The solution must have:

  - End-to-end monitoring and audit trails.
  
  - Alerting enabled for reliability, performance, and cost metrics.
  
- The solution should prioritize:

  - Reuse of existing skills and capabilities over new. This strategy reduces complexity, risk, and cost.
  
  - Modern cloud service tiers. For example, it should use platform as a service (PaaS) services whenever practical to reduce management burden, risk, and to help control costs.
  
  - Components that are mature in the market and easy to find. Contoso plans to upskill engineers across the software development lifecycle (SDLC).
  
- The solution should be optimized for the nonfunctional requirements (NFRs) in the following order:

  1. Minimize the cost to build and run.
  
  1. Solution performance.
  
  1. Maintainability.

### Key design decisions

- The [Modern analytics with Azure Databricks architecture](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture) is the chosen basis for the solution design. This design is a natural extension of the Azure landing zone enterprise architecture. It reuses many foundational components from that architecture, like Microsoft Entra ID and Azure Monitoring. Only solution-specific configuration updates are required.
  
  - This design easily accommodates the expected volume and processing requirements, including autoscale requirements.
  
  - Delta Lake supports the "point in time" requirements, along with enhanced data versioning, schema enforcement, time travel, and provides ACID guarantees.
  
  - Mature in market offering, high levels of skill availability, and strong upskilling/training offering available.
  
  - Supports the strategic desire for an enterprise data science capacity through raw or validated lake access in Azure Databricks.
  
  - Efficient medium-sized data storage and processing with Azure Data Lake Storage Gen2 and Azure Databricks.
  
  - Easily support the requirements for performance, reliability, and service resiliency.
  
- The selection of PaaS services offloads much of the operational burden to Microsoft, and accepts the trade-off of less control.

- Because of the initial solution release, we recommend that you use Power BI [Pro licensing](/power-bi/fundamentals/service-features-license-type#pro-license) as the SKU. This choice has an explicit trade-off of OPEX cost vs Power BI [Premium performance](/power-bi/enterprise/service-premium-what-is).

- The key changes for this solution:

  - Azure SQL is used for the data modeling capability because of expected data volumes, reduction in new components introduced, and reuse of existing skills.
  
  - Because the solution is batch-based, Azure Data Factory is used according to functional match, cost, and simplicity.
  
  - The design is easily extensible to support streaming ingestion.

  - Data Factory self-hosted integration runtime (SHIR) is required for on-premises ingestion, therefore requiring Azure Site Recovery for service resiliency.
  
  - Purview Data Governance as part of the foundation layer, providing transparency, data catalog, and governance capabilities.

## Architecture

:::image type="content" source="_images/azure-data-factory-baseline.png" alt-text="Diagram that shows the medallion architecture and data flow." border="false" lightbox="_images/azure-data-factory-baseline.png":::

### Dataflow

This solution uses Data Factory with a SHIR to ingest data from the on-premises source system to Azure Data Lake Storage Gen2. Data Factory also orchestrates Azure Databricks notebooks to transform and load the data into Delta Lake tables hosted on ADLS Gen2.

Delta Lake is coupled with Power BI, which is used to create senior leadership dashboards and analysis on top of the Delta Lake tables. Azure Databricks also provides raw or validated lake access for data science and machine learning workloads.

The following dataflow corresponds to the preceding diagram:

1. Data is ingested from an on-premises source system to [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage/) using [Data Factory](https://azure.microsoft.com/products/data-factory/) Data Factory with a SHIR. Data Factory also provides process orchestration for [Azure Databricks](https://azure.microsoft.com/products/databricks/) notebooks to transform and load the data into Delta Lake tables stored on ADLS Gen2, along with [Azure SQL Server](/azure/azure-sql/?view=azuresql) extract, transform, load (ETL) processes.

1. [Delta Lake](/azure/databricks/delta/) provides an open format layer that enables data versioning, schema enforcement, time-travel, and provides ACID guarantees. Data is organized into the following layers:

- The bronze layer holds all raw data.

- The silver layer contains cleaned and filtered data.

- The gold layer stores aggregated data that is useful for business analytics.

- Azure Data Lake Storage Gen2 underpins the Delta Lake because of its ability to efficiently store all types of data, supporting any speed of workflow at low cost.

1. Azure SQL Server is used to support the Enterprise data modeling requirements, including hierarchical conformance.

1. [Power BI](/power-bi/fundamentals/power-bi-overview) is used to create management information dashboards from the enterprise model, providing a consistent, standardized, and performant view of data. Power BI can also enable analysis work directly from the [Delta Lake via Databricks](/azure/databricks/partners/bi/power-bi).
  
1. The solution adds two more components to the foundational Azure services, which enable collaboration, governance, reliability, and security:

- [Microsoft Purview Data Governance](/purview/governance-home) is added to provide data discovery services, a data catalog, and governance insights across the platform.

- [Azure Site Recovery](/azure/site-recovery/) is added to support the backup and recovery of the VMs, which provide the compute to the Data Factory SHIR, required to ingest data from on-premises.

- The following foundation services require extension to support this solution:

  - [Azure DevOps](/azure/devops/?view=azure-devops) offers continuous integration and continuous deployment (CI/CD) and other integrated version control features.
  
  - [Azure Key Vault](/azure/key-vault/general/) securely manages secrets, keys, and certificates.
  
  - [Microsoft Entra ID](/entra/identity/) provides single sign-on (SSO) across the stack, including Azure Databricks and Power BI users.
  
  - [Azure Monitor](/azure/azure-monitor/) collects and analyzes Azure resource telemetry, providing audit and alerting. By proactively identifying problems, this service maximizes performance and reliability.
  
  - [Microsoft Cost Management and Billing](/azure/cost-management-billing/) provide financial governance services for Azure workloads.

### Network design

:::image type="content" source="_images/azure-data-factory-baseline-network.png" alt-text="Diagram that shows a medallion architecture network design." border="false" lightbox="_images/azure-data-factory-baseline-network.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-baseline.vsdx) of this architecture.*

- You can use Azure Firewalls to secure network connectivity between your on-premises infrastructure and your Azure virtual network.

- You cn deploy a SHIR on a virtual machine (VM) in your on-premises environment or in Azure, with the latter being the recommendation. A SHIR can be used to securely connect to on-premises data sources and perform data integration tasks in Data Factory.

- Private Link and Private Endpoints are implemented, which allows you to bring the service into your virtual network.

- In order to take advantage of ML-assisted data labeling, you must create a new storage account, different than the default storage account you created when creating the AML workspace. The new, nondefault storage account can be bound to the same virtual network as the workspace, and can reside in a separate subnet within that virtual network if you prefer to keep it separated.
  
## Callouts

- The use of Databricks Delta Lake means that Archive tier Storage Accounts can't be used, as that tier is effectivity off-line storage. This design choice is a trade-off between functionality and cost.

- When you create a new Azure Databricks workspace, the default redundancy for the managed storage account (Databricks filesystem or DBFS root) is set as Geo-redundant storage (GRS). You can change the redundancy to Locally redundant storage (LRS) if geo-redundancy isn't needed.

- As a general rule, data warehouses of less than 1 TB perform better on Azure SQL Database than on Azure Synapse. Synapse starts to show performance gains when the data warehouse is more than 1-5 TB. This performance difference is the main factor for selecting [Azure SQL over Synapse](/answers/questions/976202/azure-sql-server-vs-synapse-dedicated-sql-pool).

## Alternatives

[Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) has Data Factory, Azure Databricks, and Power BI built-in as a single solution. As a relatively new service, there might be some functionality that isn't currently available to match that of the services used in this scenario, and there might be a learning curve for operators.

The following are alternatives for the storage processing layer:

- [Azure Synapse Analytics](/azure/synapse-analytics/): This service isn't a good match for the scenario described here because of Azure Databricks functional match, maturity, and skilling available in the market.

The following are alternatives for the storage modeling layer:

- [Azure Synapse Analytics](/azure/synapse-analytics/): This service isn't a good match for the scenario described here because of data volumes and functional overlap with Databricks.

- [SQL Managed Instance](/azure/azure-sql/managed-instance/?view=azuresql): This service isn't a good match for the scenario described here because of the lack of migration requirement and OPEX cost.

- [Azure PostgresSQL](/azure/postgresql/): This service isn't a good match for the scenario described here because of Contoso’s existing skillset and desire to introduce as few new technologies as required, reducing cost and complexity.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Given the reliability targets for a BI analytical/reporting system:

- The default Azure [SLAs](https://www.azure.cn/support/sla/summary/) across the solution meet the requirements, so no high-availability or multi-regional uplift is required.

- Given the low service criticality of the solution and the use of PaaS services, a [Wait for Microsoft](/azure/architecture/data-guide/disaster-recovery/dr-for-azure-data-platform-recommendations#dr-strategy-impacts) disaster recovery strategy is the preferred design choice.

- Data backups are addressed with the following native functionality:

  - Databricks [Delta Lake table history](/azure/databricks/delta/history).
  
  - SQL Server [default backups](/azure/azure-sql/database/automated-backups-overview?view=azuresql#backup-frequency).
  
  - All source data ingested is stored in the Delta Lake – Bronze layer, in an append-only format. This functionality enables a full replay of the solution without reingestion from the source system.

> [!IMPORTANT]
> Multiple SHIR instances should be deployed across different Availability Zones or across regions, where available, to meet your resilience goals.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture addresses security via configuration of the infrastructure selected and the control and data plane controls implemented. These design choices are based upon the [zero-trust model](/azure/security/fundamentals/zero-trust) and [least privilege access](/entra/identity-platform/secure-least-privileged-access) principles. The security controls natively supported include:

- solution components use [managed identities](/entra/identity/managed-identities-azure-resources/overview) for authentication and authorization, which enables consistent RBAC control.

- Azure [Key Vault](/azure/key-vault/) stores application secrets and certificates securely.

- The use of component-specific [built-in roles](/azure/role-based-access-control/built-in-roles), which enables a granular control for authorization at the control plane level.

  - Because of scope, these specific roles are preferred over the [general roles](/azure/role-based-access-control/built-in-roles#:~:text=ID-,General,-Contributor).
  
  - [Custom roles](/azure/role-based-access-control/tutorial-custom-role-powershell) are explicitly excluded because of ongoing lifecycle management requirements.
  
- Access to data across the solution is controlled via a set of domain-specific Microsoft Entra ID groups, which reflects Contoso’s data classification framework. Individual solution components use these groups to apply data level controls. For example, SQL Server [dynamic data masking](/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver16) and Power BI [row level security](/power-bi/enterprise/service-admin-rls) both support this design.

  - This design makes it possible to grant access to a component, while disallowing the ability to view the data within. To get access to data, the user must also have component access.
  
  - Creating the groups at the domain level, like Finance, enables reuse. Representing the data classification framework limits the sprawl of solution-specific groups.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This architecture addresses cost optimization by:

- Strongly linking component SKU selection to the requirements, avoiding the "build it and they'll come" antipattern. Scheduling in regular reviews of metrics to enable [right-sizing](https://azure.microsoft.com/blog/rightsize-to-maximize-your-cloud-investment-with-microsoft-azure/) and use of [Microsoft Copilot for Azure](/azure/copilot/analyze-cost-management) for further guidance.

- As part of a broader [FinOps framework](/azure/cost-management-billing/finops/overview-finops), implementing practical OPEX saving benefits, such as:

  - [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for stable workloads and [Savings plans](/azure/cost-management-billing/savings-plan/scope-savings-plan) for dynamic workloads, for the maximum term across the solution.
  
  - Data Factory [Reserved capacity](/azure/data-factory/data-flow-reserved-capacity-overview) for data flows.
  
  - Log Analytics [Commitment tiers](/azure/azure-monitor/logs/cost-logs).
  
- Component configuration, accepting the trade-off between cost savings and instantaneous response:

  - Databricks [Serverless compute](/azure/databricks/serverless-compute/).
  
  - Storage Account - [Access Tiers](/azure/storage/blobs/access-tiers-overview), automated via [Lifecycle Policies](/azure/storage/blobs/lifecycle-management-overview) configuration. Noting that the [Archive tier](/azure/storage/blobs/access-tiers-overview#archive-access-tier) can't be used within the Delta Lake.
  
  - Log Analytics workspaces for [data retention and archiving](/azure/azure-monitor/best-practices-logs#:~:text=different%20pricing%20tiers.-,Configure%20data%20retention%20and%20archiving.,-There%20is%20a) and [Azure Monitor](/azure/azure-monitor/best-practices-cost).
  
- Using [Azure Hybrid Benefit](/azure/azure-sql/virtual-machines/windows/pricing-guidance?view=azuresql) to lower the costs for SQL Server licensing.

- Implementing cost and budget alerting via [Cost Management](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending), along with [spending guardrails](/azure/well-architected/cost-optimization/set-spending-guardrails#use-governance-policies).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Operational excellence is enabled through automation, monitoring, and auditing across the SDLC. The callouts for this solution include:

- [Azure Monitor](/azure/azure-monitor/overview) and [Log Analytics workspaces](/azure/azure-monitor/logs/log-analytics-workspace-overview) are the core monitoring components.

- Implement a [Tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) that enables transparency across the solution components.

- For development:

  - Lock down all production deployments to using [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops?toc=%2Fazure%2Fdevops%2Fget-started%2Ftoc.json&view=azure-devops) using configuration-as-code, all stored within a source control repository, such as [Azure Repos](https://azure.microsoft.com/products/devops/repos/) or [GitHub](https://docs.github.com). Providing a full audit trail of deployment and enabling modern deployment methodologies, rollbacks and recovery.  
  
  - Utilize testing frameworks like [PSRule](https://azure.github.io/PSRule.Rules.Azure/) to ensure deployments align with Well-Architected Framework guidance.
  
  - Utilize [Azure Policy](/azure/governance/policy/overview) to enforce organizational standards and to assess compliance at-scale, supported by [Azure Governance Visualizer](https://github.com/Azure/Azure-Governance-Visualizer) for configurable, granular insights on the technical implementation.

#### Monitoring

Monitoring is a critical part of any production-level solution. It's strongly recommended that any Azure solution is supported by a [monitoring strategy](/azure/cloud-adoption-framework/strategy/monitoring-strategy) as part of the end-to-end [observability](/azure/cloud-adoption-framework/manage/monitor/observability) strategy.

Azure Databricks offers robust functionality for monitoring custom application metrics, streaming query events, and application log messages. Azure Databricks can send this monitoring data to different logging services. You can use Azure Monitor to monitor Data Factory pipelines and write diagnostic logs in Azure Monitor. Azure Monitor provides base-level infrastructure metrics and logs for most Azure services. For more information, see [Monitoring Azure Databricks](/azure/architecture/databricks-monitoring/).

Suggested alerting baseline:

- Cost and budget alerting for the Databricks compute cluster, the Data Factory SHIRs, and SQL server.

- Long running processes across the solution.

- SQL Server connections refused.

- Power BI usage. If used, Power BI Premium capacity throttling.
  
- Log Analytics workspaces for when [data collection is high](/azure/azure-monitor/logs/analyze-usage#send-alert-when-data-collection-is-high).

> [!IMPORTANT]
> Ensure that alert [action groups](/azure/azure-monitor/alerts/action-groups#:~:text=be%20set%20as-,%22Global%22.,-Expand%20table) are created as a global resource to ensure continuity in the event of regional service issue.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This architecture addresses performance efficiency with:

- Based upon the requirements, the standard service tiers of the various component SKUs are acceptable, understanding that these types of resources can be scaled up, on-demand with no interruption in service levels. Autoscaling should be [rigorously tested](/azure/well-architected/performance-efficiency/performance-test) before production release.
  
- Selecting a baseline of compute SKU, utilizing the cloud native features to support increased demand, such as:

  - Databricks [autoscaling](/azure/databricks/delta-live-tables/auto-scaling).
  
  - SQL Server [Scale up/down](/azure/azure-sql/database/scale-resources?view=azuresql).
  
  - Configuring Data Factory jobs for [performance and scalability](/azure/data-factory/copy-activity-performance).
  
- Apply guidance available in the following [optimization guides](/azure/well-architected/performance-efficiency/optimize-data-performance) across the solution, such as:

  - [Databricks](/azure/databricks/optimizations/).
  
  - Data Factory [data flows](/azure/data-factory/concepts-data-flow-performance) and a [SHIR](/azure/data-factory/self-hosted-integration-runtime-troubleshoot-guide?tabs=data-factory).
  
  - [SQL Server](/sql/relational-databases/performance/performance-monitoring-and-tuning-tools?view=sql-server-ver16).
  
  - [Power BI](/power-bi/guidance/power-bi-optimization).
  
- Understanding that the performance of data solutions generally degrades over time, establish the capacity for [continuous performance optimization](/azure/well-architected/performance-efficiency/continuous-performance-optimize), along with proactive technical reviews of the solution, ensuring it remains [fit for purpose](/azure/well-architected/performance-efficiency/principles).

## Antipatterns

- **The on-premises mindset:** Cloud services address the traditional constraints of procurement time, functionality, and capacity, while introducing the critical requirement of cost management across the SDLC. Failure to account for this factor across people, process, and technology often leads to bill shock and stakeholder friction.

- **Boundary controls are the answer:** Cloud services and PaaS in particular have introduced Identity as the key control that must be implemented and well-governed. Networking and boundaries controls are part of the answer and not the actual answer.

- **Set and forget:** Any cloud solution must have regular reviews that account for the current usage and performance, along with the functional and pricing changes in Azure. Failure to do so often results in the erosion of value and effectiveness.

## Deploy this scenario

To deploy this architecture, follow the step-by-step instructions in the [GitHub sample](https://github.com/azure-samples/data-factory-to-databricks).

To deploy a SHIR on an Azure VM, use the [quick start template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.compute/vms-with-selfhost-integration-runtime).

## Next steps

- [Data Factory enterprise hardened architecture](azure-data-factory-enterprise-hardened.yml)
- [Data Factory mission critical](azure-data-factory-mission-critical.yml)

## Related resources

- [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/)
- [Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Decide between a savings plan and a reservation](/azure/cost-management-billing/savings-plan/decide-between-savings-plan-reservation#choose-a-reservation)
