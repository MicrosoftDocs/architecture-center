This reference architecture describes how to implement the [Medallion Lakehouse](/azure/databricks/lakehouse/medallion) for an solution focused use case. 

The solution leverages a hub and spoke network topology with landing zones following the Cloud Adoption Framework (CAF) best practices. 

## Context and Key-Design-Decisions

This design covers an illustrative customer, Contoso, a mid-large organization on the journey to Azure cloud, enabled by automation.

Contoso have established their Azure cloud foundation with an [Enterprise Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) and are now looking to take their first data workloads to the cloud, guided by Microsoft’s [Well-Architected Framework](/azure/well-architected/). 

This initial use case involves sourcing data from an on-premises financial operation system, taking it to the cloud for analytical use cases and leading into establishing an enterprise data science capability. 

### Key Requirements

- The Solution is an analytical/reporting system, which will be primarily used by the Finance department and other corporate functions.
- The on-premises source system is:
  - Currently estimated to be 1TB with a 5% forecasted growth.
  - Has batch update process which is scheduled each night, typically finishing before 3am (unless end of financial year updates are required).
  - The solution MUST minimize it's impact on the source system.
- Financial users SHOULD have the ability to view data as “it was” at a point in time.
- The initial use case targets analytical and management reporting, with the ability to self-serve. This SHOULD also create the data foundation to enable an enterprise data science capability.
- The data is classified “Company Confidential”, so the solution MUST have effective security controls and monitoring to both the components and data accessed/used. 
- Contoso have an enterprise data model of which this finance data is a subset of. The key data elements MUST be cleansed, modelled and conformed to the various reporting hierarchies before being served for reporting.  
- Source data ingested which isn’t currently mapped to the enterprise model MUST be retained and made available for future analysis and use cases. 
- The Solution MUST be updated daily, based on source feeds availability with elastic compute optionality targeting <90mins for an end-to-end solution update. 
- The Solution MUST support the target SLA’s of:
  - 99.5% target uptime (or ~1 day, 20 hours downtime within a year).
  - Recovery Point Objective (RPO) of 3 days.
  - Recovery Time Objective (RTO) of 1 day.
- The Solution SHOULD be designed for the future, accommodating future growth and capability extension without fundamental redesign.
- The Solution MUST support the forecast usage of:
   - 200 Managers, Financial Controllers and Analysts attached to the Finance department with an estimated growth of <5% annually.
   - 100 Analysts attached to other corporate functions with an estimated growth of <5% annually.
   - Only Contoso employees can access the solution. This explicitly excludes any direct access by 3rd parties or externals. 
- The Solution MUST have:
  - End-to-End monitoring and audit trails.
  - Configurable alerting across functions, SLA’s and cost.
- The Solution SHOULD strongly prefer:
  - Reuse of existing skills/capabilities over new, reducing complexity, risk and cost.
  - Modern cloud service tiers: For example, it should use PaaS services whenever practical to reduce management burden, risk and below the line cost.
  - Use of components which are mature in the market, easy to find and upskill resources across the SDLC.
- The Solution SHOULD be optimized for the NFR’s (in order):
  - Minimise the cost to build and run.
  - Solution Performance.
  - Maintainability.

### The Key Design Decisions (KDD's)

- The Microsoft – Reference Architecture for [Modern Analytics Architecture](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture) with Azure Databricks as the central component has been selected for the solution.
  - This is a natural extension of the Azure Landing Zone and reuses many of the foundational components i.e. Entra ID, Azure Monitoring, etc. requiring only solution specific configuration updates.
  - Easily accommodate the forecasted volume and processing requirements, including auto-scale requirements.
  - Delta Lake supports the “point in time” requirements, along with enhanced data versioning, schema enforcement, time travel, and provides ACID guarantees.
  - Mature in market offering, high levels of skill availability and strong upskilling/training offering available.
  - Supports the strategic desire for an enterprise data science capacity through raw or validated lake access in Azure Databricks.
  - Efficient medium-sized data storage and processing with Azure Data Lake Storage Gen2 and Azure Databricks.
  - Easily support the requirements for performance, reliability and service resiliency.
- The selection of PaaS services offloading much of the operational toil to Microsoft, accepting the trade-off of less control.
- Given the initial solution release, Power BI [Pro licensing](https://learn.microsoft.com/power-bi/fundamentals/service-features-license-type#pro-license) is selected. This has an explicit trade-off of OPEX cost vs Power BI [Premium performance](https://learn.microsoft.com/power-bi/enterprise/service-premium-what-is). 
- The key changes for this solution:
  - Azure SQL has been selected for the data modeling capability due to expected data volumes, reduction in new components introduced and reuse of existing skills. 
  - As the solution is batch based, ADF has been selected based upon functional match, cost and simplicity.
   - The design is easily extensible to support streaming ingestion.
  - ADF SHIR will be required for on-prem ingestion, therefore requiring Azure Site Recovery for service resiliency. 
  - Purview Data Governance as part of the foundation layer, providing transparency, data catalogue and governance capabilities.


## Architecture

![Diagram showing Medallion architecture and data flow.](_images/ADF-ALZ-Medallion-Initial.png)

### Dataflow

This solution uses Azure Data Factory (ADF) with self-hosted integration runtime (SHIR) to ingest data from the on-premises source system to Azure Data Lake Storage Gen2 (ADLS Gen2). ADF also orchestrates Azure Databricks notebooks to transform and load the data into Delta Lake tables hosted on ADLS Gen2.
Delta Lake provides an open format layer that enables data versioning, schema enforcement, and time travel. Couple with Power BI which is used to create senior leader dashboards and analysis on top of the Delta Lake tables. Azure Databricks also provides raw or validated lake access for data science and machine learning workloads.

The typical workflow of accessing and landing data through the architecture:

1.	Data is ingested from an on-premises source system to [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage/) using [Azure Data Factory](https://azure.microsoft.com/products/data-factory/) (ADF) with self-hosted integration runtime (SHIR).

- ADF also provides process orchestration for [Azure Databricks](https://azure.microsoft.com/products/databricks/) notebooks to transform and load the data into Delta Lake tables stored on ADLS Gen2, along with [Azure SQL Server](/azure/azure-sql/?view=azuresql) ETL processes.
  
2.	[Delta Lake](/azure/databricks/delta/) provides an open format layer that enables data versioning, schema enforcement, time travel and provides ACID guarantees. Data is organised into the following layers:

- Bronze: Holds all raw data.
- Silver: Contains cleaned, filtered data.
- Gold: Stores aggregated data that is useful for business analytics.
- Data Lake Storage Gen2 underpins the Delta Lake due to its ability to efficiently store all types of data, supporting any speed of workflow at low cost.
  
3.	Azure SQL Server is used to support the Enterprise data modeling requirements, including hierarchical conformance.

4.	[Power BI](https://learn.microsoft.com/power-bi/fundamentals/power-bi-overview) is used to create management information dashboards from the enterprise model, providing a consistent, standardized and performant view of data. Power BI can also enable analysis work directly from the [Delta Lake via Databricks](/azure/databricks/partners/bi/power-bi).
  
5.	The solution adds two additional components to the foundational Azure services which enable collaboration, governance, reliability, and security:

- [Microsoft Purview Data Governance](https://learn.microsoft.com/purview/governance-home) is added to provide data discovery services, a data catalogue, and governance insights across the platform.

- [Azure Site Recovery](/azure/site-recovery/) is added to support the backup/recovery of the VM’s which provide the compute to the ADF – SHIR, required to ingest data from on-premises.
- The following foundation services require extension to support this solution:
  - [Azure DevOps](/azure/devops/?view=azure-devops) offers continuous integration and continuous deployment (CI/CD) and other integrated version control features.
  - [Azure Key Vault](/azure/key-vault/general/) securely manages secrets, keys, and certificates.
  - [Microsoft Entra ID](https://learn.microsoft.com/entra/identity/) provides single sign-on (SSO) across the stack, including Azure Databricks and Power BI users. 
  - [Azure Monitor](/azure/azure-monitor/) collects and analyzes Azure resource telemetry, providing audit and alerting. By proactively identifying problems, this service maximizes performance and reliability.
  - [Azure Cost Management and Billing](/azure/cost-management-billing/) provide financial governance services for Azure workloads.

### Network Design

![Diagram showing Medallion architecture Network design.](_images/ADF-ALZ-Medallion-Initial-Network.png)

- Azure Firewalls can be used to secure network connectivity between your on-premises infrastructure and your Azure virtual network.
- Self-hosted integration runtime (SHIR) can be deployed on a virtual machine (VM) in your on-premises environment or in Azure, with the later being the recommendation. The SHIR can be used to securely connect to on-premises data sources and perform data integration tasks in ADF.
- Leverage PrivateLink and Private Endpoints which allows you to bring the service into your virtual network.
- ML-assisted data labeling doesn't support default storage accounts that are secured behind a virtual network [1]. You must use a non-default storage account for ML-assisted data labeling. The non-default storage account can be secured behind the virtual network
  

## Callouts

- The use of Databricks Delta Lake means that Storage Accounts - Archive tier cannot be used, as this is effectivity off-line storage. This is a trade-off between functionality and cost.
- When creating a new Azure Databricks workspace, the default redundancy for the managed storage account (Databricks filesystem or DBFS root) is set as Geo-redundant storage (GRS). You can change the redundancy to Locally-redundant storage (LRS).
- As a general rule, data warehouses of less than 1TB will perform better on Azure SQL DB than on Azure Synapse. Synapse starts to show performance gains when the data warehouse is more than 1-5TB.  This is the main factor for selecting [Azure SQL over Synapse](https://learn.microsoft.com/en-us/answers/questions/976202/azure-sql-server-vs-synapse-dedicated-sql-pool).


## Alternatives

Alternatives for the storage processing layer:

- [Azure Synapse Analytics](/azure/synapse-analytics/): Discounted due to Azure Databricks functional match, maturity and skilling available in the market.

Alternatives for the storage modeling layer:

- [Azure Synapse Analytics](/azure/synapse-analytics/): Discounted due to data volumes and functional overlap with Databricks.
- [SQL Managed Instance](/azure/azure-sql/managed-instance/?view=azuresql): Discounted due to the lack of migration requirement and OPEX cost.
- [Azure PostgresSQL](/azure/postgresql/): Discounted due to Contoso’s existing skillsets and desire to introduce as few new technologies as required, reducing cost and complexity. 


## Considerations

The following considerations provide guidance for implementing the pillars of the [Azure Well-Architected Framework](/azure/well-architected/) in the context of this architecture. 

### Reliability

[Reliability](/azure/well-architected/reliability/) ensures that solution is resilient to malfunction and to ensure that it returns to a fully functioning state after a failure occurs. 

Given the solution requirements for a BI analytical/reporting system:

- The default Azure [SLA's](https://www.azure.cn/support/sla/summary/) across the solution meet the requirements, so no high-availability or multi-regional uplift is required.
- Given the low service critically of solution and the use of PaaS services, a [Wait for Microsoft](https://learn.microsoft.com/azure/architecture/data-guide/disaster-recovery/dr-for-azure-data-platform-recommendations#dr-strategy-impacts) DR strategy has been selected.
- Data backups have been addressed via:
  - Databricks [Delta Lake table history](/azure/databricks/delta/history).
  - SQL Server [default backups](https://learn.microsoft.com/azure/azure-sql/database/automated-backups-overview?view=azuresql#backup-frequency).
  - All source data ingested will be stored in the Delta Lake – Bronze layer, in an append only format. This will enable a full replay of the solution without, re-ingestion from the source system.

> [!IMPORTANT] 
> Multiple SHIR need to be deployed across different zones or across regions, where available, to meet your resilience goals. 

### Security

[Security](/azure/well-architected/security/) provides guidance to your architecture to help ensure the confidentiality, integrity, and availability of your data and systems.

This architecture addresses security via configuration of the infrastructure selected, control and data plane controls implemented, based upon [zero-trust model](/azure/security/fundamentals/zero-trust) and [less privilege required](/entra/identity-platform/secure-least-privileged-access) principles. These include:

- Solution components use [managed identities](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview) for authentication and authorisation, enabling consistent RBAC control.
- Azure [Key Vault](/azure/key-vault/) stores application secrets and certificates securely.
- The use of component specific [in-built roles](/azure/role-based-access-control/built-in-roles), enabling a finer grain control for authorisation at the control plane level. 
  - Due to scope, these are preferred over the [general roles]( https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#:~:text=ID-,General,-Contributor).
  - [Custom Roles](/azure/role-based-access-control/tutorial-custom-role-powershell) are explicitly excluded due ongoing lifecycle management requirements.
- Access to data across the solution will be controlled via a set of domain specific Entra ID groups, reflecting Contoso’s data classification framework. Individual solution components will then use these groups to apply data level controls. i.e. SQL Server [dynamic data masking](https://learn.microsoft.com/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver16), Power BI [RLS](https://learn.microsoft.com/power-bi/enterprise/service-admin-rls).
  - It will be possible to have access to a component, yet not be able to view the data within. To get access to data, the user must also have component access.
  - Creating the groups at the domain level i.e. Finance, will enable reuse. Representing the data classification framework will limit the spray of solution-specific groups.

### Cost Optimization

[Cost optimization](/azure/well-architected/cost-optimization/) provides guidance in your architecture to sustain and improve your return on investment (ROI).

This architecture addresses cost optimization with:

- Strongly linking component SKU selection to the requirements, avoiding the "built it and they will come" anti-pattern. Scheduling in regular reviews of metrics to enable ["right-sizing"](https://azure.microsoft.com/blog/rightsize-to-maximize-your-cloud-investment-with-microsoft-azure/) and use of [Microsoft Copilot for Azure](/azure/copilot/analyze-cost-management) for further guidance.
- As part of a broader [FinOps framework](/azure/cost-management-billing/finops/overview-finops), implementing the various OPEX saving benefits, such as:
  - [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for stable workloads and [Savings plans](/azure/cost-management-billing/savings-plan/scope-savings-plan) for dynamic workloads, for the maximum term across the solution.
  - ADF [Reserved capacity](/azure/data-factory/data-flow-reserved-capacity-overview) for data flows.
  - Log Analytics [Commitment tiers](/azure/azure-monitor/logs/cost-logs).
- Component configuration, accepting the trade-off between cost savings and instantaneous response:
  - Databricks [Serverless compute](/azure/databricks/serverless-compute/).
  - Storage Account - [Access Tiers](/azure/storage/blobs/access-tiers-overview), automated via [Lifecycle Policies](/azure/storage/blobs/lifecycle-management-overview) configuration. Noting that the [Archive tier](/azure/storage/blobs/access-tiers-overview#archive-access-tier) cannot be used within the Delta Lake.
  - Log Analytics Workspaces for [data retention and archiving](/azure/azure-monitor/best-practices-logs#:~:text=different%20pricing%20tiers.-,Configure%20data%20retention%20and%20archiving.,-There%20is%20a) and [Azure Monitor](/azure/azure-monitor/best-practices-cost). 
- Using [Azure Hybrid Benefit](/azure/azure-sql/virtual-machines/windows/pricing-guidance?view=azuresql) for SQL Server lower licensing costs.
- Implementing cost and budget alerting via [Cost Management](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending), along with [spending guardrails](/azure/well-architected/cost-optimization/set-spending-guardrails#use-governance-policies).

### Operational Efficiency

[Operational excellence](/azure/well-architected/operational-excellence/) ensures workload quality through standardized processes and team cohesion. 

The enablers for operational efficiency are automation, monitoring, and auditing across the SDLC. The callout's for this solution include:

- [Azure Monitor](/azure/azure-monitor/overview) and [Log Analytics workspaces](/azure/azure-monitor/logs/log-analytics-workspace-overview) are the core monitoring components. 
- Implement a [Tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) that enables transparency across the solution components.
- For development:
  - Lock down all production deployments to using [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops?toc=%2Fazure%2Fdevops%2Fget-started%2Ftoc.json&view=azure-devops) using configuration-as-code, all stored within a Source control repository, such as [Azure Repos](https://azure.microsoft.com/products/devops/repos/) or [GitHub](https://docs.github.com). Providing a full audit trail of deployment and enabling modern deployment methodologies, rollbacks and recovery.  
  - Utilize testing frameworks like [PSRule](https://azure.github.io/PSRule.Rules.Azure/) to ensure deployments align with WAF guidance.
  - Utilize [Azure Policy](/azure/governance/policy/overview) to enforce organizational standards and to assess compliance at-scale, supported by [Azure Governance Visualizer](https://github.com/Azure/Azure-Governance-Visualizer) for configurable, granular insights on the technical implementation.

#### Monitoring

Monitoring is a critical part of any production-level solution. It is strongly recommended that any Azure solution is supported by a [Monitoring strategy](/azure/cloud-adoption-framework/strategy/monitoring-strategy) as part of the end-to-end [observability](/azure/cloud-adoption-framework/manage/monitor/observability).

Azure Databricks offers robust functionality for monitoring custom application metrics, streaming query events, and application log messages. Azure Databricks can send this monitoring data to different logging services. You can use Azure Monitor to monitor Azure Data Factory (ADF) pipelines and write diagnostic logs in Azure Monitor. Azure Monitor provides base-level infrastructure metrics and logs for most Azure services. For more information, see [Monitoring Azure Databricks](/azure/architecture/databricks-monitoring/).

Suggested alerting baseline:

- Based upon the solution financial modeling having cost and budget alerting in place, particularly targeting the Databricks computer cluster, ADF SHIR’s and SQL server processing.
- Long running processes across the solution.
- SQL Server connections refused.
- Power BI usage.
  - If used, Power BI Premium capacity throttling.
- Log Analytics Workspaces for when [data collection is high](/azure/azure-monitor/logs/analyze-usage#send-alert-when-data-collection-is-high).

> [!IMPORTANT] 
> Ensure that Alert [Action Groups](/azure/azure-monitor/alerts/action-groups#:~:text=be%20set%20as-,%22Global%22.,-Expand%20table) are created as a global resource to ensure continuity in the event of regional service issue.
 
### Performance Efficiency

[Performance efficiency](/azure/well-architected/performance-efficiency/) is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. 

This architecture addresses performance efficiency with:

- Based upon the requirements, the standard service tiers of the various component SKUs will be acceptable, acknowledging these can be scaled-up, on-demand with no interruption in service levels.
  - This should be [rigorously tested](/azure/well-architected/performance-efficiency/performance-test) before production release.
- Selecting a baseline of compute SKU, utilising the cloud native features to support increased demand, such as:
  - Databricks [autoscaling](/azure/databricks/delta-live-tables/auto-scaling).
  - SQL Server [Scale up/down](/azure/azure-sql/database/scale-resources?view=azuresql).
  - Configuring ADF jobs for [performance and scalability](/azure/data-factory/copy-activity-performance). 
- Apply various [optimization guides](/azure/well-architected/performance-efficiency/optimize-data-performance) across the solution, such as:
  - [Databricks](/azure/databricks/optimizations/).
  - ADF [Data flows](/azure/data-factory/concepts-data-flow-performance) and [SHIR](/azure/data-factory/self-hosted-integration-runtime-troubleshoot-guide?tabs=data-factory).
  - [SQL Server](https://learn.microsoft.com/sql/relational-databases/performance/performance-monitoring-and-tuning-tools?view=sql-server-ver16).
  - [Power BI](https://learn.microsoft.com/power-bi/guidance/power-bi-optimization).
- Acknowledging that the performance of data solutions generally degrade overtime, establish the capacity for [continuous performance optimization](/azure/well-architected/performance-efficiency/continuous-performance-optimize), along with proactive technical reviews of the solution, ensuring it remains ["fit for purpose"](/azure/well-architected/performance-efficiency/principles).

## Anti-Patterns

- **The On-prem mindset** - Cloud services address the traditional constraints of procurement time, functionality and capacity, while introducing the critical requirement of cost management across the SDLC. Failure to account for this across people, process and technology often leads to bill shock and stakeholder friction. 
- **Boundary controls are the answer** - Cloud services and PaaS in particular have introduced Identity as the key control that must be implemented and well governed. Networking and boundaries controls are _**part**_ of the answer, not _**the**_ answer. 
- **Set and Forget** - Any Cloud solution must have regular reviews which account for the current usage and performance, along with the functional and pricing changes in Azure. Failure to do so will often result in the erosion of value and effectiveness. 

## Next steps

- [Azure Data Factory Enterprise Hardening](TO_BE_ADDED) 
- [Azure Data Factory Mission Critical](TO_BE_ADDED) 

## Related resources

- [Azure Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/)
- [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/)
- [Decide between a savings plan and a reservation](azure/cost-management-billing/savings-plan/decide-between-savings-plan-reservation#choose-a-reservation)
