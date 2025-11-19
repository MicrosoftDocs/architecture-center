This article describes how to implement a [medallion lakehouse](/azure/databricks/lakehouse/medallion) design pattern for a solution-focused use case. The solution uses a hub-and-spoke network topology with landing zones that follow the [Cloud Adoption Framework for Azure best practices](/azure/cloud-adoption-framework/overview).

> [!IMPORTANT]
> ![GitHub logo.](_images/github.svg) This guidance is supported by an [example implementation](https://github.com/azure-samples/data-factory-to-databricks) that demonstrates a baseline Azure Data Factory setup on Azure. You can use this implementation as a foundation for further solution development in your first step toward production.

## Key design decisions

This design covers the medium-to-large organization Contoso as it embarks on its journey to the Azure cloud with the support of automation. Contoso has an established Azure cloud foundation with an [enterprise landing zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). Leadership is preparing to take their first data workloads to the cloud, guided by the [Azure Well-Architected Framework](/azure/well-architected/).

This initial use case includes the following scenarios:

- Data is sourced from an on-premises financial operation system.
- Data is copied to the cloud for analytical use cases.
- Contoso establishes an enterprise data science capability.

### Key requirements

- The finance department and other corporate functions primarily use the solution as an analytical and reporting system.

- The on-premises source system has the following properties:

  - A size of one terabyte (TB) with a 5% annual expected growth.

  - A batch update process that runs each night and typically finishes before 3 AM, except during the end-of-year financial updates.

- The solution must minimize its effect on the source system.

- Financial users should have the ability to view the state of data at any given point in time.

- The initial use case targets analytical and management reporting with self-service capabilities. This solution design should also serve as the foundation for building an enterprise data science capability.

- The data is classified as *company confidential*, so the solution must have effective security controls and monitoring for both the components and the data being accessed or used. Secure all data with strong encryption of data at rest and data in transit.

- Contoso's enterprise data model includes a subset specifically for finance data. The key data elements must be cleansed, modeled, and conformed to the various reporting hierarchies before being served for reporting.

- Ingested source data that isn't currently mapped to the enterprise model must be retained and made available for future analysis and use cases.

- The solution must be updated daily based on source feeds availability and have elastic compute optionality that targets less than 90 minutes for an end-to-end solution update.

- The solution must support the following target service-level agreements (SLAs):

  - 99.5% target uptime, or about 1 day and 20 hours of downtime within a year.

  - Recovery point objective of three days.

  - Recovery time objective of one day.

- The solution should be designed for the future to accommodate future growth and capability extension without fundamental redesign.

- The solution must support the following expected usage:

  - 200 managers, financial controllers, and analysts that are connected to the finance department, with an estimated growth of less than 5% annually.

  - 100 analysts that are connected to other corporate functions, with an estimated growth of less than 5% annually.

  - Only Contoso employees can access the solution. This control explicitly excludes any direct access by non-Contoso or external parties.

- The solution must have:

  - End-to-end monitoring and audit trails.

  - Alerting enabled for reliability, performance, and cost metrics.

- The solution should prioritize:

  - Existing skills and capabilities instead of developing new skills. This strategy reduces complexity, risk, and cost.

  - Modern cloud service tiers. For example, the solution should use platform as a service (PaaS) solutions whenever practical to reduce management burden, risk, and to help control costs.

  - Components that are mature in the market and easy to find. Contoso plans to upskill engineers across the software development life cycle (SDLC).

- The solution should be optimized for the nonfunctional requirements (NFRs) in the following order:

  1. The cost to build and run the solution.

  1. The performance of the solution.

  1. The maintainability of the solution.

### Key design decisions

The [modern analytics architecture with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture) is the basis for the solution design. This design is a natural extension of the Azure landing zone enterprise architecture. It reuses many foundational components from the Azure landing zone enterprise architecture, like Microsoft Entra ID and Azure Monitor. Only solution-specific configuration updates are required.

- This design easily accommodates the expected volume and processing requirements, including autoscale requirements.

- Delta Lake supports the *point-in-time* requirements and enhanced data versioning, schema enforcement, and time travel. Delta Lake also provides atomicity, consistency, isolation, and durability (ACID) guarantees.

- Mature in market offering, high levels of skill availability, and strong upskilling and training are available.

- Supports the strategic desire for an enterprise data science capacity by using raw or validated lake access in Azure Databricks.

- Azure Data Lake Storage and Azure Databricks provide efficient medium-sized data storage and processing.

- Supports the requirements for performance, reliability, and service resiliency.

- The selection of PaaS services offloads much of the operational burden to Microsoft in exchange for less control.

- Because of the initial solution release, we recommend that you use Power BI [Pro licensing](/power-bi/fundamentals/service-features-license-type#pro-license) as the licensing option. This choice has an explicit tradeoff of operating expenses versus Power BI [Premium performance](/power-bi/enterprise/service-premium-what-is).

- The key changes for this solution:

  - Azure SQL is used for the data modeling capability because of expected data volumes, reduction in new components introduced, and reuse of existing skills.

  - Because the solution is batch-based, Data Factory is used according to functional match, cost, and simplicity.

  - The design is extensible to support streaming ingestion.

  - A Data Factory self-hosted integration runtime (SHIR) is required for on-premises ingestion, which means that Azure Site Recovery is required for service resiliency.

  - Microsoft Purview Data Governance is part of the foundation layer, which provides transparency, a data catalog, and governance capabilities.

## Architecture

:::image type="content" source="_images/azure-data-factory-baseline.png" alt-text="Diagram that shows the medallion architecture and data flow." border="false" lightbox="_images/azure-data-factory-baseline.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-baseline-logical.vsdx) of this architecture.*

### Dataflow

This solution uses Data Factory with a SHIR to ingest data from the on-premises source system to Data Lake Storage. Data Factory also orchestrates Azure Databricks notebooks to transform and load the data into Delta Lake tables hosted on Data Lake Storage.

Delta Lake is coupled with Power BI, which is used to create senior leadership dashboards and analysis on top of the Delta Lake tables. Azure Databricks also provides raw or validated lake access for data science and machine learning workloads.

The following dataflow corresponds to the preceding diagram:

1. Data is ingested from an on-premises source system to [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage/) by using [Data Factory](https://azure.microsoft.com/products/data-factory/) with a SHIR. Data Factory also provides process orchestration for [Azure Databricks](https://azure.microsoft.com/products/databricks/) notebooks to transform and load the data into Delta Lake tables stored on Data Lake Storage, along with [SQL Server](/azure/azure-sql/) extract, transform, load processes.

1. [Delta Lake](/azure/databricks/delta/) provides an open format layer that supports data versioning, enforces schema, enables time travel, and ensures ACID compliance. Data is organized into the following layers:

    - The bronze layer holds all raw data.

    - The silver layer contains cleaned and filtered data.

    - The gold layer stores aggregated data that's useful for business analytics.

Data Lake Storage underpins Delta Lake because of its ability to efficiently store all types of data. This flexibility supports workflows of varying speeds and maintains cost effectiveness.

1. SQL Server is used to support the enterprise data modeling requirements, including hierarchical conformance.

1. [Power BI](/power-bi/fundamentals/power-bi-overview) is used to create management information dashboards from the enterprise model. This service provides a consistent, standardized, and performant view of data. Power BI can also enable analysis work directly from [Delta Lake by using Azure Databricks](/azure/databricks/partners/bi/power-bi).

1. The solution adds two more components to the foundational Azure services, which enable collaboration, governance, reliability, and security:

    - Microsoft Purview provides data discovery services, a [Unified Catalog](/purview/unified-catalog), and governance insights across the platform.

    - [Site Recovery](/azure/site-recovery/) supports the backup and recovery of the VMs, which provide the compute to the Data Factory SHIR, required to ingest data from on-premises.

The following foundation services require extension to support this solution:

- [Azure DevOps](/azure/devops/) offers continuous integration and continuous delivery (CI/CD) and other integrated version control features.

- [Azure Key Vault](/azure/key-vault/general/) securely manages secrets, keys, and certificates.

- [Microsoft Entra ID](/entra/identity/) provides single sign-on (SSO) across the stack, including Azure Databricks and Power BI users.

- [Azure Monitor](/azure/azure-monitor/) collects and analyzes Azure resource telemetry, which provides audit and alerting. This service maximizes performance and reliability by proactively identifying problems.

- [Microsoft Cost Management](/azure/cost-management-billing/) provides financial governance services for Azure workloads.

### Network design

:::image type="content" source="_images/azure-data-factory-baseline-network.png" alt-text="Diagram that shows a medallion architecture network design." border="false" lightbox="_images/azure-data-factory-baseline-network.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-baseline-network.vsdx) of this architecture.*

- You can use Azure firewalls to secure network connectivity between your on-premises infrastructure and your Azure virtual network.

- You can deploy a SHIR on a virtual machine (VM) in your on-premises environment or in Azure, with the latter being the recommendation. You can use a SHIR to securely connect to on-premises data sources and perform data integration tasks in Data Factory.

- A private link and private endpoints are implemented, which you can use to bring the service into your virtual network.

- To take advantage of machine learning-assisted data labeling, you must create a new storage account that is different than the default storage account you created for the Azure Machine Learning workspace. You can bind the new, nondefault storage account to the same virtual network as the workspace. If you prefer to keep the storage account separate, you can place it in a different subnet within that virtual network.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

- The use of Azure Databricks Delta Lake means that you can't use the Archive tier Azure Storage accounts because that tier is effectivity offline storage. This design choice is a tradeoff between functionality and cost.

- When you create a new Azure Databricks workspace, the default redundancy for the managed storage account (Azure Databricks File system or Databricks File system root) is set as geo-redundant storage (GRS). You can change the redundancy to locally redundant storage (LRS) if geo-redundancy isn't needed.

- As a general rule, data warehouses that are less than one TB perform better on Azure SQL Database than on Synapse. Synapse starts to show performance gains when the data warehouse is more than 1 to 5 TB. This performance difference is the main factor for selecting [Azure SQL rather than Synapse](/answers/questions/976202/azure-sql-server-vs-synapse-dedicated-sql-pool).

## Alternatives

[Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) has Data Factory, Azure Databricks, and Power BI built-in as a single solution. Because Fabric is a relatively new service, there might be some functionality that isn't currently available to match that of the services that are used in this scenario. There might also be a learning curve for operators.

[Azure Synapse Analytics](/azure/synapse-analytics/) is an alternative for the storage processing layer. This service isn't a good match for the scenario described in this article because Azure Databricks is a mature, functional match and has skilling available in the market.

The following services are alternatives for the storage modeling layer:

- [Azure Synapse Analytics](/azure/synapse-analytics/): This service isn't a good match for the scenario described in this article because of data volumes and functional overlap with Azure Databricks.

- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/): This service isn't a good match for the scenario described in this article because of the lack of migration requirement and higher operating expenses.

- [Azure Database for PostgreSQL](/azure/postgresql/): This service isn't a good match for the scenario described in this article because of Contoso's existing skill set and preference to minimize the introduction of new technologies, which reduces cost and complexity.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

To align with the reliability targets for a business intelligence analytical and reporting system:

- The default Azure [SLAs](https://www.azure.cn/support/sla/summary/) across the solution meet the requirements, so no high-availability or multi-regional uplift is required.

- The architecture uses a [Wait for Microsoft](/azure/architecture/data-guide/disaster-recovery/dr-for-azure-data-platform-recommendations#dr-strategy-impacts) disaster recovery strategy because of the low service criticality of the solution and the use of PaaS services.

- The following native functionalities address data backups:

  - Azure Databricks [Delta Lake table history](/azure/databricks/delta/history).

  - SQL Server [default backups](/azure/azure-sql/database/automated-backups-overview#backup-frequency).

  - The Delta Lake bronze layer that stores all ingested source data in an append-only format. This functionality enables a full replay of the solution without reingestion from the source system.

> [!IMPORTANT]
> To achieve your resilience goals, deploy multiple SHIR instances across various availability zones or regions, where possible.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture addresses security via configuration of the infrastructure selected and the control and data plane controls implemented. These design choices are based on the [Zero Trust model](/azure/security/fundamentals/zero-trust) and [least privilege access](/entra/identity-platform/secure-least-privileged-access) principles. Native components use the following security controls:

- Solution components use [managed identities](/entra/identity/managed-identities-azure-resources/overview) for authentication and authorization, which enables consistent role-based access control.

- [Key Vault](/azure/key-vault/) stores application secrets and certificates securely.

- Component-specific [built-in roles](/azure/role-based-access-control/built-in-roles) enable granular control for authorization at the control plane level.

  - Because of scope, these specific roles are preferred over the [general roles](/azure/role-based-access-control/built-in-roles#:~:text=ID-,General,-Contributor).

  - [Custom roles](/azure/role-based-access-control/tutorial-custom-role-powershell) are explicitly excluded because of ongoing lifecycle management requirements.

- A set of domain-specific Microsoft Entra groups control access to data across the solution, which reflects Contoso's data classification framework. Individual solution components use these groups to apply data-level controls. For example, SQL Server [dynamic data masking](/sql/relational-databases/security/dynamic-data-masking) and Power BI [row-level security](/power-bi/enterprise/service-admin-rls) both support this design.

  - This design makes it possible to grant access to a component, while disallowing the ability to view the data in the component. To get access to data, the user must also have component access.

  - This solution creates the groups, like finance, at the domain level to enable reuse. The data classification framework limits the sprawl of solution-specific groups.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To address cost optimization, this architecture:

- Strongly links component SKU selection to the requirements, which avoids the *build it and they'll come* antipattern. This solution schedules in regular reviews of metrics to enable [rightsizing](https://azure.microsoft.com/blog/rightsize-to-maximize-your-cloud-investment-with-microsoft-azure/) and use of [Azure Copilot](/azure/copilot/analyze-cost-management).

- Implements practical operating expense saving benefits as part of a broader [financial operations framework](/azure/cost-management-billing/finops/overview-finops), such as:

  - [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for stable workloads and [savings plans](/azure/cost-management-billing/savings-plan/scope-savings-plan) for dynamic workloads, for the maximum term across the solution.

  - Data Factory [reserved capacity](/azure/data-factory/data-flow-reserved-capacity-overview) for data flows.

  - Log Analytics [commitment tiers](/azure/azure-monitor/logs/cost-logs).

- Has component configurations that accommodate the tradeoff between cost savings and instantaneous response:

  - Azure Databricks [serverless compute](/azure/databricks/serverless-compute/).

  - Storage account [access tiers](/azure/storage/blobs/access-tiers-overview), automated through [lifecycle management policies](/azure/storage/blobs/lifecycle-management-overview) configuration. You can't use the [Archive tier](/azure/storage/blobs/access-tiers-overview#archive-access-tier) within Delta Lake.

  - Log Analytics workspaces for [data retention and archiving](/azure/azure-monitor/logs/log-analytics-workspace-overview#data-retention) and [Azure Monitor](/azure/azure-monitor/best-practices-cost).

- Uses [Azure Hybrid Benefit](/azure/azure-sql/virtual-machines/windows/pricing-guidance#byol) to lower the costs for SQL Server licensing.

- Implements cost and budget alerting through [Cost Management](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending) and [spending guardrails](/azure/well-architected/cost-optimization/set-spending-guardrails#use-governance-policies).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Operational excellence is enabled through automation, monitoring, and auditing across the SDLC. This solution includes:

- [Azure Monitor](/azure/azure-monitor/overview) and [Log Analytics workspaces](/azure/azure-monitor/logs/log-analytics-workspace-overview) as the core monitoring components.

- A [tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) that enables transparency across the solution components.

- The following components for development:

  - All production deployments use [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) via configuration as code, which is stored within a source control repository, such as [Azure Repos](https://azure.microsoft.com/products/devops/repos/) or [GitHub](https://docs.github.com). This configuration provides a full audit trail of deployment and enables modern deployment methodologies, rollbacks, and recovery.

  - Testing frameworks like [PSRule](https://azure.github.io/PSRule.Rules.Azure/) ensure that deployments align with Well-Architected Framework guidance.

  - [Azure Policy](/azure/governance/policy/overview) enforces organizational standards and assesses compliance at-scale. [Azure Governance Visualizer](https://github.com/Azure/Azure-Governance-Visualizer) provides configurable, granular insights about the technical implementation.

#### Monitoring

Monitoring is a critical part of any production-level solution. Support Azure solutions with a [monitoring strategy](/azure/cloud-adoption-framework/strategy/monitoring-strategy) as part of the end-to-end [observability](/azure/cloud-adoption-framework/manage/monitor/observability) strategy.

Azure Databricks offers robust functionality for monitoring custom application metrics, streaming query events, and application log messages. Azure Databricks can send this monitoring data to various logging services. You can use Azure Monitor to monitor Data Factory pipelines and write diagnostic logs. Azure Monitor provides base-level infrastructure metrics and logs for most Azure services. For more information, see [Monitoring Azure Databricks](/azure/architecture/databricks-monitoring/).

The recommended alerting baseline includes:

- Cost and budget alerting for the Azure Databricks compute cluster, the Data Factory SHIRs, and SQL Server.

- Long-running processes across the solution.

- SQL Server connection refusals.

- Power BI usage and, if applicable, Power BI Premium capacity throttling.

- Log Analytics workspaces for when [data collection is high](/azure/azure-monitor/logs/analyze-usage#send-alert-when-data-collection-is-high).

> [!IMPORTANT]
> Create alert [action groups](/azure/azure-monitor/alerts/action-groups) as global resources to ensure continuity in the event of regional service problems.

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

To addresses performance efficiency, this architecture has:

- The standard service tiers of various component versions based on the requirements. You can scale up these resources on-demand without any interruption in service levels. You should [rigorously test](/azure/well-architected/performance-efficiency/performance-test) autoscaling before production release.

- A baseline of compute options that use cloud-native features to support demand, such as:

  - Azure Databricks [autoscaling](/azure/databricks/delta-live-tables/auto-scaling).

  - SQL Server [scale up and scale down](/azure/azure-sql/database/scale-resources).

  - Data Factory job configurations for [performance and scalability](/azure/data-factory/copy-activity-performance).

Apply guidance available in the following [optimization guides](/azure/well-architected/performance-efficiency/optimize-data-performance) across the solution, such as:

  - [Azure Databricks](/azure/databricks/optimizations/).

  - Data Factory [data flows](/azure/data-factory/concepts-data-flow-performance) and a [SHIR](/azure/data-factory/self-hosted-integration-runtime-troubleshoot-guide).

  - [SQL Server](/sql/relational-databases/performance/performance-monitoring-and-tuning-tools).

  - [Power BI](/power-bi/guidance/power-bi-optimization).

Understand that data solution performance typically degrades over time. Establish the capacity for [continuous performance optimization](/azure/well-architected/performance-efficiency/continuous-performance-optimize) and conduct proactive technical reviews to ensure that the solution remains [fit for purpose](/azure/well-architected/performance-efficiency/principles).

## Antipatterns

- **The on-premises mindset:** Cloud services address traditional constraints such as procurement time, functionality, and capacity. These services also introduce the crucial need for cost management throughout the SDLC. If you neglect this factor across people, processes, and technology, it often results in unexpected cost and stakeholder friction.

- **Boundary controls are the answer:** Cloud services, particularly PaaS, have identity as the primary control that needs to be implemented and well-governed. While networking and boundary controls are important, they're only part of the solution and not the complete answer.

- **Set and forget:** Cloud solutions require regular reviews to evaluate current usage and performance. These reviews should consider any functional and pricing changes in Azure. Without these reviews, the value and effectiveness of the solutions can diminish over time.

## Deploy this scenario

To deploy this architecture, follow the step-by-step instructions in the [GitHub sample](https://github.com/azure-samples/data-factory-to-databricks).

## Next steps

- [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/)
- [Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Decide between a savings plan and a reservation](/azure/cost-management-billing/savings-plan/decide-between-savings-plan-reservation#choose-a-reservation)

## Related resources

- [Data Factory enterprise hardened architecture](azure-data-factory-enterprise-hardened.yml)
- [Data Factory mission critical](azure-data-factory-mission-critical.yml)
