This example scenario builds on the [Analytics end-to-end with Azure Synapse][e2e-analytics] reference pattern, focusing on business intelligence. It uses Synapse Pipeline to ingest data from a SQL Database into Synapse SQL Pools, then transforms the data for analysis.

## Architecture

![Diagram of Enterprise BI architecture with Azure Synapse.](./media/aac-scoped-architecture-new.png)

*Download a [Visio file]() of this architecture.*

### Workflow

#### Data source

1. The source data is located in **Azure SQL Server Database**. To simulate the on-premises environment, deployment scripts for this scenario provision an Azure SQL Database. The [AdventureWorks Data Warehouse][adventureworksdw-sample-link] is used as the source data schema and sample data. For information on how to copy data from an on-premises database, see [copy and transform data to and from SQL Server](/azure/data-factory/connector-sql-server?tabs=data-factory).

#### Ingestion and data storage

1. [Azure Data Lake Gen2](/azure/databricks/data/data-sources/azure/adls-gen2/) is used as a temporary *staging* area during data ingestion, which allows us to use [PolyBase](/azure/data-factory/connector-azure-sql-data-warehouse?tabs=data-factory#use-polybase-to-load-data-into-azure-synapse-analytics) to copy data into the Azure Synapse Dedicated SQL Pool.

2. [Azure Synapse Analytics](/azure/synapse-analytics/) is a distributed system designed to perform analytics on large data. It supports massive parallel processing (MPP), which makes it suitable for running high-performance analytics. Azure Synapse Dedicated SQL Pool is a target for ongoing ingestion from on-premises. It can be used for further processing, as well as serving the data for [Power BI](/power-bi/fundamentals/power-bi-overview) over Direct Query mode.

3. [Azure Synapse pipelines](/azure/data-factory/concepts-pipelines-activities) are used to orchestrate data ingestion and transformation within your Azure Synapse workspace.

#### Analysis and reporting

1. The data modeling approach in this scenario is presented by combining the enterprise and BI Semantic models. [Enterprise model][enterprise-model] is stored in [Synapse Dedicated SQL Pool][synapse-dedicated-pool] and the [BI Semantic model][bi-model] is stored in [Power BI Premium capacities][pbi-premium-capacities]. Power BI accesses the data via Direct Query mode.

### Components

This scenario uses the following components:

- [Azure SQL Server](https://azure.microsoft.com/services/virtual-machines/sql-server)
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- [Power BI](https://powerbi.microsoft.com)
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory) (Azure AD)

### Architecture diagram

![Diagram of the enterprise BI pipeline.](./media/enterprise-bi-small-architecture.png)


## Scenario details

An organization has a large on-premises data warehouse stored in a SQL database. The organization wants to use Azure Synapse to perform analysis, using Power BI to serve these insights.

This example scenario shows on-premises data warehouse as a source of ongoing ingestion with cloud-based processing and serving of BI model. This approach could be an end goal or a first step towards full modernization with cloud-based components.

### Authentication

**Azure AD** authenticates users who connect to Power BI dashboards and apps. Single sign-on is used to connect to the data source in Azure Synapse Provisioned Pool. Authorization happens on the source.  

### Incremental loading

When you run an automated ETL or ELT process, it's most efficient to load only the data that changed since the previous run. It's called an *incremental load*, as opposed to a full load that loads all the data. To perform an incremental load, you need a way to identify which data has changed. The most common approach is to use a *high water mark* value, which tracks the latest value of some column in the source table, either a datetime column or a unique integer column.

Starting with SQL Server 2016, you can use [temporal tables](/sql/relational-databases/tables/temporal-tables), which are system-versioned tables that keep a full history of data changes. The database engine automatically records the history of every change in a separate history table. You can query the historical data by adding a `FOR SYSTEM_TIME` clause to a query. Internally, the database engine queries the history table, but it's transparent to the application.

> [!NOTE]
> For earlier versions of SQL Server, you can use [change data capture](/sql/relational-databases/track-changes/about-change-data-capture-sql-server) (CDC). This approach is less convenient than temporal tables, because you have to query a separate change table, and changes are tracked by a log sequence number, rather than a timestamp.

Temporal tables are useful for dimension data, which can change over time. Fact tables usually represent an immutable transaction such as a sale, in which case keeping the system version history doesn't make sense. Instead, transactions usually have a column that represents the transaction date, which can be used as the watermark value. For example, in the AdventureWorks Data Warehouse, the `SalesLT.*` tables have a `LastModified` field.

Here's the general flow for the ELT pipeline:

1. For each table in the source database, track the cutoff time when the last ELT job ran. Store this information in the data warehouse. On initial setup, all times are set to `1-1-1900`.

2. During the data export step, the cutoff time is passed as a parameter to a set of stored procedures in the source database. These stored procedures query any records that were changed or created after the cutoff time. For all tables in our example, we can use the `ModifiedDate` column.

3. When the data migration is complete, update the table that stores the cutoff times.

## Data pipeline

This scenario uses the [Adventure Works DW][adventureworksdw-sample-link] sample database as a data source. The [incremental data load pattern](/azure/data-factory/tutorial-incremental-copy-overview) discussed above is implemented to ensure we only load data that was modified or added after the most recent pipeline run.

### Metadata-driven copy tool

This architecture uses the built-in [metadata-driven copy tool](/azure/data-factory/copy-data-tool-metadata-driven) within Synapse Pipelines to incrementally load all tables contained within our relational database. By navigating through the wizard-based experience, we connect the Copy Data tool to our source database, and configure either incremental or full loading for each table. The Copy Data tool will then create both the pipelines, and SQL scripts to generate the control table required to store data for the incremental loading process (for example, high watermark value/column for each table). Once these scripts are run, the pipeline will be ready to load all tables in the source data warehouse into the Synapse dedicated pool.

![Screenshot of metadata-driven copy tool in Synapse Analytics.](./media/metadata-copy.png)

The tool will create three pipelines to iterate over all the tables in the database, before loading the data.

The pipelines generated by this tool will:

- Count the number of objects (for example, tables) to be copied in the pipeline run.
- Iterate over each object to be loaded/copied and execute the following:
  - Check whether a delta load is required (otherwise complete a normal full load)
  - Retrieve the high watermark value from the control table
  - Copy Data from the source tables into the staging account in ADLS Gen2
  - Load data into the Dedicated SQL pool via the selected copy method (for example, Polybase, Copy command)
  - Update the high watermark value in the control table

### Copy activity: Loading data into Synapse SQL Pool

The [copy activity](/azure/data-factory/copy-activity-overview) will copy data from the SQL DB into the Synapse SQL Pool. In this example, because our SQL DB is in Azure, we use the Azure integration runtime to read data from the SQL DB and write the data into the specified staging environment (ADLS).

The copy statement is then used to load data from the staging environment into the Synapse Dedicated pool.

### Using Synapse Pipelines

Azure Synapse Pipelines are used to define the ordered set of activities to complete for our incremental load pattern. Triggers are used to start the pipeline, which can be triggered manually or at a time specified.

### Transform the data

Because the sample database in our reference architecture isn't large, we created replicated tables with no partitions. For production workloads, using distributed tables is likely to improve query performance. See [Guidance for designing distributed tables in Azure Synapse](/azure/sql-data-warehouse/sql-data-warehouse-tables-distribute). Our example scripts run the queries using a static [resource class](/azure/sql-data-warehouse/resource-classes-for-workload-management).

In a production environment, consider creating staging tables with Round-Robin distribution. Then transform the data and move it into production tables with clustered columnstore indexes, which offer the best overall query performance. Columnstore indexes are optimized for queries that scan many records. Columnstore indexes don't perform as well for singleton lookups (that is, looking up a single row). If you need to perform frequent singleton lookups, you can add a non-clustered index to a table. Singleton lookups can run significantly faster using a non-clustered index. However, singleton lookups are typically less common in data warehouse scenarios than OLTP workloads. For more information, see [Indexing tables in Azure Synapse](/azure/sql-data-warehouse/sql-data-warehouse-tables-index).

> [!NOTE]
> Clustered columnstore tables do not support `varchar(max)`, `nvarchar(max)`, or `varbinary(max)` data types. In that case, consider a heap or clustered index. You might put those columns into a separate table.

### Use Power BI Premium to access, model, and visualize the data

Power BI supports several options for connecting to data sources on Azure, in particular Azure Synapse Provisioned Pool:

- Import: The data is imported into the Power BI model.
- DirectQuery: Data is pulled directly from relational storage.
- [Composite model](/power-bi/transform-model/desktop-composite-models): Combine *Import* for some tables and *DirectQuery* for others.

This scenario is delivered with DirectQuery dashboard, because the amount of data we use and model/dashboard complexity isn't high, so we can deliver good user experience. DirectQuery delegates the query to the powerful compute engine underneath and utilizes extensive security capabilities on the source. Also, using DirectQuery ensures that results are always consistent with the latest source data.

Import mode provides the fastest query response time, and should be considered when the model will fit entirely within Power BI’s memory, the data latency between data refreshes can be tolerated, and there might be some complex transformations between the source system and the final model. In this case, the reporting end users want full access to the most recent data with no delays in Power BI refreshing, and all historical data, which is larger than what a Power BI dataset can handle&mdash;between 25-400 GB, depending on the capacity size. As the data model in the dedicated SQL pool is already in a star schema and needs no transformation, DirectQuery is an appropriate choice.

![Screenshot of dashboard in Power BI.](./media/adventure-works-dashboard.png)

Using [Power BI Premium Gen2](/power-bi/enterprise/service-premium-gen2-what-is) gives you ability to handle large models, paginated reports, PBI deployment pipelines and built-in Analysis Services endpoint, and to have dedicated [capacity](/power-bi/admin/service-premium-what-is#reserved-capacities) with unique value proposition.
When the BI Model grows or dashboard complexity increases, you could switch to composite models and start importing parts of look-up tables (via [Hybrid Tables](/power-bi/connect-data/service-dataset-modes-understand#hybrid-tables)) and some pre-aggregated data. Enabling [query caching](/power-bi/connect-data/power-bi-query-caching) within Power BI for imported datasets is an option, as well as utilizing [dual tables](/power-bi/transform-model/desktop-storage-mode) for storage mode property. Within Composite model, datasets act as virtual pass through layer. When the user interacts with visualizations, Power BI generates SQL queries to Synapse SQL Pools Dual Storage: in memory or direct query depending on which one is more efficient. The engine decides when to switch from in-memory to direct query and pushes the logic to the Synapse SQL Pool. Depending on the context of the query tables, they can act as either cached (imported) or not cached Composite Models: pick and choose which table to cache into memory, combine data from one or more DirectQuery sources, and/or combine data from a mix of DirectQuery sources and imported data.

**Recommendations:**
When using PBI Direct Query over Azure Synapse Analytics Provisioned Pool:

- Use Azure Synapse [result set caching](/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching) to cache query results in the user database for repetitive use, improve query performance down to milliseconds, and reduce compute resource usage. Queries using cached results set don't use any concurrency slots in Azure Synapse Analytics and thus don't count against existing concurrency limits.
- Use Azure Synapse [materialized views](/azure/synapse-analytics/sql/develop-materialized-view-performance-tuning) to pre-compute, store, and maintain data in SQL Data Warehouse just like a table. Queries that use all or a subset of the data in materialized views can get faster performance, and they don't need to make a direct reference to the defined materialized view to use it.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Frequent headlines of data breaches, malware infections, and malicious code injection are among an extensive list of security concerns for companies looking to cloud modernization. Enterprise customers need a cloud provider or service solution that can address their concerns as they can't afford to get it wrong.

The solution above addresses the most demanding security concerns using a combination of layered security controls: network, identity, privacy, authorization. The bulk of the data is stored in Azure Synapse Provisioned Pool with PBI doing Direct Query using single sign-on. Azure AD is used for authentication, and we're using extensive security controls of Provisioned Pool for data authorization.

Some common security questions include:

- How can I control who can see what data?
  - Organizations need to protect their data to comply with federal, local, and company guidelines to mitigate risks of data breach. Synapse offers multiple [data protection capabilities](/azure/synapse-analytics/guidance/security-white-paper-data-protection) to achieve compliance.
- What are the options for verifying a user's identity?
  - Azure Synapse supports a wide range of capabilities to control who can access what data via [Access control](/azure/synapse-analytics/guidance/security-white-paper-access-control) and [Authentication](/azure/synapse-analytics/guidance/security-white-paper-authentication)
- What network security technology can I use to protect the integrity, confidentiality, and access of my networks and data?
  - To secure Azure Synapse, there are a range of [network security](/azure/synapse-analytics/guidance/security-white-paper-network-security) options available to consider.
- What are the tools that detect and notify me of threats?
  - Azure Synapse provides many [threat detection](/azure/synapse-analytics/guidance/security-white-paper-threat-protection) capabilities like: SQL Auditing, SQL Threat Detection, and Vulnerability Assessment to audit, protect, and monitor databases.
- What can I do to protect data in my storage account?
  - Azure Storage Accounts are ideal for workloads that require fast and consistent response times, or that have a high number of input-output operations (IOP) per second. Storage accounts contain all your Azure Storage data objects, and have many options for [storage account security](/azure/architecture/framework/services/storage/storage-accounts/security).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

This section provides information on pricing for different services involved in this solution, and mentions decisions made for this scenario with sample dataset.

#### Azure Synapse

Azure Synapse Analytics serverless architecture allows you to scale your compute and storage levels independently. Compute resources are charged based on usage, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs will increase as you ingest more data.

#### Azure Synapse Pipelines

Pricing details for Synapse Pipelines can be found under the 'Data Integration' tab on the [Synapse pricing page](https://azure.microsoft.com/pricing/details/synapse-analytics). There are three main components that influence the price of Synapse Pipeline:

1. Data Pipelines activities and integration runtime hours
1. Data Flows cluster size and execution
1. Operation charges

Depending on the components/activities you choose, frequency and number of Integration Runtime units, the price would vary.

For the sample dataset, we've picked standard Azure Hosted Integration Runtime, Copy Data Activity for the core of the pipeline, which is triggered on a daily schedule for all of the entities (tables) in the source database. The reference architecture contains no data flows. There are no operational costs, as we have less than one million operations with pipelines a month.

#### Azure Synapse Dedicated Pool and Storage

Pricing details for Synapse Dedicated Pool can be found under the 'Data Warehousing' tab on Synapse pricing page above. Under Dedicated consumption model, customers are billed per DWU units provisioned, per hour of uptime. Another contributing factor is data storage costs: size of your data at rest + snapshots + geo-redundancy, if any.

For the sample dataset, we have provisioned 500DWU, which guarantees good experience for analytical load. We keep compute up and running over business hours of reporting. If taken into production, reserved data warehouse capacity is an attractive option for cost management. Different techniques should be used to maximize cost/performance metrics, which are covered in the sections above.

#### Blob storage

Consider using the Azure Storage reserved capacity feature to lower cost on storage. With this model, you get a discount if you can commit to reservation for fixed storage capacity for one or three years. For more information, see [Optimize costs for Blob storage with reserved capacity][az-storage-reserved].

There's no persistent storage in this reference architecture.

#### Power BI Premium

Power BI Premium pricing details can be found on the [Power BI pricing page](https://powerbi.microsoft.com/en-us/pricing/).

This reference architecture uses PBI Premium workspaces(/power-bi/admin/service-premium-what-is/) with a range of performance enhancements built in to accommodate demanding analytical needs.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### DevOps recommendations

- Create separate resource groups for production, development, and test environments. Separate resource groups make it easier to manage deployments, delete test deployments, and assign access rights.
- Put each workload in a separate deployment template and store the resources in source control systems. You can deploy the templates together or individually as part of a CI/CD process, making the automation process easier.
  In this architecture, there are four main workloads:
  - The data warehouse server, and related resources
  - Azure Synapse pipelines
  - PBI assets: dashboards, apps, datasets
  - An on-premises to cloud simulated scenario
  
  Aim to have a separate deployment template for each of the workloads.
- Consider staging your workloads where practical. Deploy to various stages and run validation checks at each stage before moving to the next stage. That way you can push updates to your production environments in a highly controlled way and minimize unanticipated deployment issues. Use [blue-green deployment][blue-green-dep] and [canary release][canary-releases] strategies for updating live production environments.
- Have a good rollback strategy for handling failed deployments. For example, you can automatically redeploy an earlier, successful deployment from your deployment history. See the `--rollback-on-error` flag in Azure CLI.
- [Azure Monitor][azure-monitor] is the recommended option for analyzing the performance of your data warehouse and the entire Azure analytics platform for an integrated monitoring experience. [Azure Synapse Analytics][synapse-analytics] provides a monitoring experience within the Azure portal to show insights about your data warehouse workload. The Azure portal is the recommended tool when monitoring your data warehouse because it provides configurable retention periods, alerts, recommendations, and customizable charts and dashboards for metrics and logs.

#### Quick start

- Portal: [Azure Synapse proof of concept](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.synapse/synapse-poc)
- Azure CLI: [Create an Azure synapse workspace with Azure CLI](/azure/synapse-analytics/quickstart-create-workspace-cli)
- Terraform: [Modern data warehousing with Terraform and Microsoft Azure](https://github.com/terraform-azurerm-examples/example-adf-synapse)

For more information, see the DevOps section in [Microsoft Azure Well-Architected Framework][AAF-devops].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This section provides details on the sizing decisions to accommodate this dataset, and gives further guidance for you to pick the right size for workload.

#### Azure Synapse Provisioned Pool

There's a range of [data warehouse configurations](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-compute-overview) to choose from.

|Data warehouse units |# of compute nodes  |# of distributions per node|
|---------------------|:------------------:|:-------------------------:|
|DW100c               |1                   |60                         |
|                     | `-- TO --`         |                           |
|DW30000c             |60                  |1                          |  

To see the performance benefits of scaling out, especially for larger data warehouse units, use at least a 1-TB data set. To find the best number of data warehouse units for your dedicated SQL pool, try scaling up and down. Run a few queries with different numbers of data warehouse units after loading your data. Since scaling is quick, you can try various performance levels in an hour or less.

##### Finding the best number of data warehouse units

For a dedicated SQL pool in development, begin by selecting a smaller number of data warehouse units. A good starting point is *DW400c* or *DW200c*. Monitor your application performance, observing the number of data warehouse units selected compared to the performance you observe.
Assume a linear scale, and determine how much you need to increase or decrease the data warehouse units. Continue making adjustments until you reach an optimum performance level for your business requirements.

##### Scaling Synapse SQL Pool

- [Scale compute for Synapse SQL pool with the Azure portal](/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-portal).
- [Scale compute for dedicated SQL pool with Azure PowerShell](/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-powershell).
- [Scale compute for dedicated SQL pool in Azure Synapse Analytics using T-SQL](/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-tsql).
- [Pausing, monitoring, and automation](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-compute-overview).

#### Azure Synapse Pipelines

For scalability and performance optimization features of Azure Synapse Pipelines and the copy activity used, refer to this [guide](/azure/data-factory/copy-activity-performance).

#### Power BI Premium

This article uses [Power BI Premium Gen 2](/power-bi/enterprise/service-premium-architecture) to demonstrate BI capabilities of the solution. [Capacity SKUs for PBI Premium](/power-bi/enterprise/service-premium-gen2-what-is) range from P1 (eight v-cores) to P5 (128 v-cores) currently. The best way to select needed capacity is to undergo [capacity loading evaluation](/power-bi/enterprise/service-premium-concepts), install Gen 2 [metrics app](/power-bi/enterprise/service-premium-install-gen2-app?tabs=1st) for ongoing monitoring, and consider using [Autoscale with PBI Premium](/power-bi/enterprise/service-premium-auto-scale).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

- [Noah Costar](https://www.linkedin.com/in/noah-costar-6204b8157/) | Cloud Solution Architect
- [Galina Polyakova](https://www.linkedin.com/in/galinagpolyakova/) | Senior Cloud Solution Architect
- [George Stevens](https://www.linkedin.com/in/george-stevens/) | Cloud Solution Architect

Other contributors:

- [Jim McLeod](https://www.linkedin.com/in/jimmcleodaustralia/) | Cloud Solution Architect
- [Miguel Myers](https://www.linkedin.com/in/miguelmyers/) | Senior Program Manager

## Next steps

- [What is Power BI Premium?](/power-bi/enterprise/service-premium-what-is)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [Accessing Azure Data Lake Storage Gen2 and Blob Storage with Azure Databricks](/azure/databricks/data/data-sources/azure/azure-storage)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Pipelines and activities in Azure Data Factory and Azure Synapse Analytics](/azure/data-factory/concepts-pipelines-activities)
- [What is Azure SQL?](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)

## Related resources

- [Automated enterprise BI](/azure/architecture/reference-architectures/data/enterprise-bi-adf)
- [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end-experiment)
- [Big data analytics with enterprise-grade security using Azure Synapse](/azure/architecture/solution-ideas/articles/big-data-analytics-enterprise-grade-security)
- [Hybrid ETL with existing on-premises SSIS and Azure Data Factory](/azure/architecture/example-scenario/data/hybrid-etl-with-adf)

[AAF-devops]: /azure/architecture/framework/devops/overview
[azure-monitor]: https://azure.microsoft.com/services/monitor
[blue-green-dep]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[canary-releases]: https://martinfowler.com/bliki/CanaryRelease.html
[e2e-analytics]: /azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[synapse-analytics]: /azure/sql-data-warehouse/sql-data-warehouse-concept-resource-utilization-query-activity
[adventureworksdw-sample-link]: /sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms
[az-storage-reserved]: /azure/storage/blobs/storage-blob-reserved-capacity
[enterprise-model]: /powerbi/guidance/center-of-excellence-business-intelligence-solution-architecture#enterprise-models
[bi-model]: /powerbi/guidance/center-of-excellence-business-intelligence-solution-architecture#bi-semantic-models
[pbi-premium-capacities]: /powerbi/admin/service-premium-what-is#reserved-capacities
[synapse-dedicated-pool]: /azure/articles/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is#synapse-sql-pool-in-azure-synapse
[pbi-what-is-premium]: /power-bi/admin/service-premium-what-is#analysis-services-in-power-bi-premium
